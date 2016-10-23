import * as React from "react";
import * as ReactDOM from "react-dom";
import { Router, Route, browserHistory, IndexRoute } from "react-router"

import { MainWindow } from "./page/MainWindow";
import { Home } from "./page/Home";
import { Repos } from "./page/Repos";
import { Repo } from "./page/Repo";
import { About } from "./page/About";

export default (
  <Router history={browserHistory}>
    <Route path="/" component={MainWindow}>
      <IndexRoute component={Home}/>

      <Route path="/repos" component={Repos}>
        <Route path="/repos/:userName/:repoName" component={Repo}/>
      </Route>
      
      <Route path="/about" component={About} />
    </Route>
  </Router>
);