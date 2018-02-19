import * as React from "react";
import * as ReactDOM from "react-dom";
import { Router, Route, browserHistory, IndexRoute } from "react-router"

import { MainWindow } from "./page/MainWindow";
import { Home } from "./page/Home";

export default (
  <Router history={browserHistory}>
    <Route path="/" component={MainWindow}>
      <IndexRoute component={Home}/>
    </Route>
  </Router>
);