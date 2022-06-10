import { Plugin, ResolvedConfig } from 'vite'
import { extend } from '@vue/shared'
import {
  checkUpdate,
  isWindows,
  formatErrMsg,
  formatInfoMsg,
  formatWarnMsg,
  isInHybridNVue,
} from '@dcloudio/uni-cli-shared'
import { VitePluginUniResolvedOptions } from '..'

import { initEnv } from './env'
import { initOptions } from './options'
import { initPlugins } from './plugins'
import { customResolver } from '../config/resolve'

export function createConfigResolved(options: VitePluginUniResolvedOptions) {
  return ((config) => {
    // 如果是混合编译且是 nvue 时，部分逻辑无需执行
    if (!isInHybridNVue(config)) {
      initEnv(config)
    }
    initLogger(config)
    initOptions(options, config)
    initPlugins(config, options)
    if (!isInHybridNVue(config)) {
      initCheckUpdate()
    }
    if (isWindows) {
      // TODO 等 https://github.com/vitejs/vite/issues/3331 修复后，可以移除下列代码
      // 2.8.0 已修复，但为了兼容旧版本，先不移除
      const item = config.resolve.alias.find((item) =>
        typeof item.find !== 'string' ? item.find.test('@/') : false
      )
      if (item) {
        item.customResolver = customResolver
      }
    }
  }) as Plugin['configResolved']
}

function initCheckUpdate() {
  checkUpdate({
    inputDir: process.env.UNI_INPUT_DIR,
    compilerVersion: process.env.UNI_COMPILER_VERSION,
    versionType: process.env.UNI_COMPILER_VERSION_TYPE,
  })
}

function initLogger({ logger, nvue }: ResolvedConfig & { nvue?: boolean }) {
  const { info, warn, error } = logger
  logger.info = (msg, opts) => {
    msg = formatInfoMsg(msg, extend(opts || {}, { nvue }))
    if (msg) {
      return info(msg, opts)
    }
  }
  logger.warn = (msg, opts) => {
    msg = formatWarnMsg(msg, opts)
    if (msg) {
      return warn(msg, opts)
    }
  }
  logger.error = (msg, opts) => {
    msg = formatErrMsg(msg, opts)
    if (msg) {
      return error(msg, opts)
    }
  }
}