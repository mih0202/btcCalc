<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BitcoinCalc._Default" %>

<%@ Register Src="~/UserControls/BitcoinCalc.ascx" TagPrefix="uc1" TagName="BitcoinCalc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContainer" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <uc1:BitcoinCalc runat="server" id="BitcoinCalc" />
</asp:Content>
