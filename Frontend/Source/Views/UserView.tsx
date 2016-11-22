import * as React from "react";
import {SideBar} from "../Components/SideBar";

export interface UserViewProps {}
export interface UserViewState {}

export class UserView extends React.Component<UserViewProps, UserViewState> {
    render() {
        return (
            <div>
                <SideBar />
            </div>
        )
    }
}