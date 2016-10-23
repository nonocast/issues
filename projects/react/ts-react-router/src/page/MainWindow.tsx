import * as React from "react";
import { NavLink } from "../component/NavLink";

import { Home } from "./Home";
require('../../style/index.sass');

export class MainWindow extends React.Component<{}, {}> {
  render() {
    return (
      <div>
        <h1>React Router Tutorial</h1>
        <ul role="nav">
          <li><NavLink to="/" onlyActiveOnIndex={true}>Home</NavLink></li>
          <li><NavLink to="/about">About</NavLink></li>
          <li><NavLink to="/repos">Repos</NavLink></li>
        </ul>
        {this.props.children}
      </div>
    );
  }
}