import * as React from "react";

export interface NotFoundScreenProps {}
export interface NotFoundScreenState {}

export class NotFoundScreen extends React.Component<NotFoundScreenProps, NotFoundScreenState> {
    render() {
        return (
            <h1>Page not found!</h1>
        )
    }
}