import { UniTodoNode } from '../elements/UniTodoNode'

export class UniFunctionalPageNavigator extends UniTodoNode {
  constructor(id: number, parentNodeId: number, refNodeId: number) {
    super(id, 'uni-functional-page-navigator', parentNodeId, refNodeId)
  }
}
