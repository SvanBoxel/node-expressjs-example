
/**
 * @name Tainted setTimeout
 * @description User-controlled delay
 * @kind path-problem
 * @problem.severity warning
 * @id custom-queries/tainted-settimeout
 */

import javascript
import DataFlow
import DataFlow::PathGraph

class MyConfig extends TaintTracking::Configuration {
  MyConfig() { this = "MyConfig" }
  override predicate isSource(Node node) { node instanceof RemoteFlowSource }
  override predicate isSink(DataFlow::Node sink) {
    DataFlow::globalVarRef("setTimeout").getACall().getArgument(1) = sink
  }
}

from MyConfig cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "setTimeout with user-controlled delay from $@.", source.getNode(), "here"
