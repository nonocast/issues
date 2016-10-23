import * as React from "react";

export class Repo extends React.Component<any, {}> {
  render() {
    return (
      <div>
        <h2>{this.props.params.userName}/{this.props.params.repoName}</h2>
      </div>
    );
  }
}