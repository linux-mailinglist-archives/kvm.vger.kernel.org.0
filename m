Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73573A7E16
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 14:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFOMW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 08:22:26 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:54984 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbhFOMWZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 08:22:25 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6638EC0447
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1623759621; bh=WhjIYtBFuo3qecxYkuUjgoyOfduF98ZA23TuKwZAO9w=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=bn6y55HmwPftBk8+I6h2lzWVUX4o1bf9wHzvmJ01STStnb9GEZXIRRjCN04xD16Cn
         BnqFEhLKVLwtPNrfmvXHsgFWCWuG3YfzwofBXiEcfIvPE5bNJ8OIAzfCNxzBGCA+M7
         7XP7jDTYC/9zjGQ74a3Hn/PHCaQiT8aDoLTdy66E/se29HEfqJ7GSTZw9OJiuINKHT
         WhugqsLGIUcPZU0OyQnrosGZK9xEQ04K1psq2p5isyyM+QaEq2MsfYU3Z9OeIVmHhK
         Aq+ydylBByJsvWdBXctKVTAOxCOGZ1swtVfAPzwXLXA36LnAuszNbt0nml8OBpBvB4
         iL3jmpr8xUXRQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2A229A0096
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 12:20:21 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id ED7D54019C
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 12:20:20 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=tobies@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="TGvfM0jI";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqfcC5BeO7Ie4PUYMDxHbtjKmvOtnIrDLfX0iY7D0mrraHt27GW6QRkS7U7hKHgCzD43U44glZKxa6dRu/bRfHVvkjkCS8sBc8RkEd1rkyGQ2Ao4nrfhUJGZ6fvdxJ7mMtxqSk3ZZkOAnBe6kg74r5IPhpxo06mVnAc+mSKNZ2uzgR/36bx3DS9cDTjhZaygXRszgeacaGFO7ENW1pCVlkcepGYNL8+8bVQ6Lrx4fQ7MzCXvVMMEh6oxylj2ZG1HLIFPqwiG+IurKxh9/cb4b3vOwhRIFKEX0wWutxXbX3iE82WwHj8P07/0KtVmnU+eJgG/WnXgs/YX0qMjIAPcMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhjIYtBFuo3qecxYkuUjgoyOfduF98ZA23TuKwZAO9w=;
 b=LtqHBmXS1tbxDwC9Ahq1qP+belA+CfB/Csf5RGX8aD8E9zK4Ky2dPckIdWKK76zat2YwYuGVUv9yXwegKgrT956QAL2cS7OQEo2H8NgtJMqGoRhlTHX2gyB+5GyBHtBL3fF3j3517sLtw0Bo3uH4F+3O5kRJMlEhP4KEg1946FUJKOFUAGQk6a8XsnVTWYJP/zHrP+dRGuDZ/nsfDS7wWMHuj+zD3/EHXnYev7ND1UNCZzgU+TkxsLvhqh/zCGfoMp9mhomKsSsuR7iBIbwGNZ0FOkA2prnYkoqGHmGvIwPryFZC3UqAN8VJor+nRWUcLYNSi/CRFi3cowxycukiUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhjIYtBFuo3qecxYkuUjgoyOfduF98ZA23TuKwZAO9w=;
 b=TGvfM0jIB+FXtlo8t0zcuGF6YZA+rbH1HRFyLaVYuMgOXBUY6XIyxzxFwZFfTxjI1xO1bVuCbQcsv/JLeWI0lvUNbQVwP3w8h5BzIDAERv3UyW+K0PlQRYupEessl1QpsLkWS9pLhugcwkQ6A44yU1cCg1T+0Ym/gz4b2ejLLEA=
Received: from DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17)
 by DM4PR12MB5325.namprd12.prod.outlook.com (2603:10b6:5:39e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Tue, 15 Jun
 2021 12:20:19 +0000
Received: from DM4PR12MB5264.namprd12.prod.outlook.com
 ([fe80::a049:643e:9e31:6029]) by DM4PR12MB5264.namprd12.prod.outlook.com
 ([fe80::a049:643e:9e31:6029%6]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 12:20:19 +0000
X-SNPS-Relay: synopsys.com
From:   Stephan Tobies <Stephan.Tobies@synopsys.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Controlling the guest TSC on x86
Thread-Topic: Controlling the guest TSC on x86
Thread-Index: Addh3tMY90dh+2TRQ4S6UC1dbuh2PgAAcnNg
Date:   Tue, 15 Jun 2021 12:20:19 +0000
Message-ID: <DM4PR12MB52646AE63A2FAEAD4DAE76D7B1309@DM4PR12MB5264.namprd12.prod.outlook.com>
References: <DM4PR12MB52648CB3F874AC3B7C41A19DB1309@DM4PR12MB5264.namprd12.prod.outlook.com>
In-Reply-To: <DM4PR12MB52648CB3F874AC3B7C41A19DB1309@DM4PR12MB5264.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdG9iaWVzXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMGFlNDAxNjAtY2RkNC0xMWViLWFlMzktY2MyZjcx?=
 =?us-ascii?Q?YzBjNjZkXGFtZS10ZXN0XDBhZTQwMTYyLWNkZDQtMTFlYi1hZTM5LWNjMmY3?=
 =?us-ascii?Q?MWMwYzY2ZGJvZHkudHh0IiBzej0iMTExOSIgdD0iMTMyNjgyMzMyMTc0NjY5?=
 =?us-ascii?Q?OTM1IiBoPSJBV3AzRXdQbzczTUJEZWM3cmlLY0V3MHNhL2M9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUJ2?=
 =?us-ascii?Q?MkQzTjRHSFhBVGdjdDNOY3Yxa3RPQnkzYzF5L1dTME5BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQVlpcS8wQUFBQUFBQUFBQUFBQUFBQUo0QUFBQm1BR2tBYmdC?=
 =?us-ascii?Q?aEFHNEFZd0JsQUY4QWNBQnNBR0VBYmdCdUFHa0FiZ0JuQUY4QWR3QmhBSFFB?=
 =?us-ascii?Q?WlFCeUFHMEFZUUJ5QUdzQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZQWJ3QjFBRzRBWkFCeUFIa0FYd0J3?=
 =?us-ascii?Q?QUdFQWNnQjBBRzRBWlFCeUFITUFYd0JuQUdZQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFaZ0J2QUhVQWJnQmtBSElBZVFCZkFIQUFZUUJ5QUhRQWJnQmxB?=
 =?us-ascii?Q?SElBY3dCZkFITUFZUUJ0QUhNQWRRQnVBR2NBWHdCakFHOEFiZ0JtQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCbUFHOEFk?=
 =?us-ascii?Q?UUJ1QUdRQWNnQjVBRjhBY0FCaEFISUFkQUJ1QUdVQWNnQnpBRjhBY3dCdEFH?=
 =?us-ascii?Q?a0FZd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1lBYndCMUFHNEFaQUJ5QUhrQVh3?=
 =?us-ascii?Q?QndBR0VBY2dCMEFHNEFaUUJ5QUhNQVh3QnpBSFFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVpnQnZBSFVBYmdCa0FISUFlUUJmQUhBQVlRQnlBSFFBYmdC?=
 =?us-ascii?Q?bEFISUFjd0JmQUhRQWN3QnRBR01BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJtQUc4?=
 =?us-ascii?Q?QWRRQnVBR1FBY2dCNUFGOEFjQUJoQUhJQWRBQnVBR1VBY2dCekFGOEFkUUJ0?=
 =?us-ascii?Q?QUdNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHY0FkQUJ6QUY4QWNBQnlBRzhB?=
 =?us-ascii?Q?WkFCMUFHTUFkQUJmQUhRQWNnQmhBR2tBYmdCcEFHNEFad0FBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFD?=
 =?us-ascii?Q?QUFBQUFBQ2VBQUFBY3dCaEFHd0FaUUJ6QUY4QVlRQmpBR01BYndCMUFHNEFk?=
 =?us-ascii?Q?QUJmQUhBQWJBQmhBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnpB?=
 =?us-ascii?Q?R0VBYkFCbEFITUFYd0J4QUhVQWJ3QjBBR1VBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUhNQWJnQndBSE1BWHdCc0FH?=
 =?us-ascii?Q?a0FZd0JsQUc0QWN3QmxBRjhBZEFCbEFISUFiUUJmQURFQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFB?=
 =?us-ascii?Q?QUNBQUFBQUFDZUFBQUFjd0J1QUhBQWN3QmZBR3dBYVFCakFHVUFiZ0J6QUdV?=
 =?us-ascii?Q?QVh3QjBBR1VBY2dCdEFGOEFjd0IwQUhVQVpBQmxBRzRBZEFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFC?=
 =?us-ascii?Q?MkFHY0FYd0JyQUdVQWVRQjNBRzhBY2dCa0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=synopsys.com;
x-originating-ip: [84.140.66.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7765a81-8018-47de-ae46-08d92ff7f0d4
x-ms-traffictypediagnostic: DM4PR12MB5325:
x-microsoft-antispam-prvs: <DM4PR12MB53256732FA647FAEBDDA0A36B1309@DM4PR12MB5325.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8DoG/XxO1srFcCdkoILh3+rxjdiDgA+Kzk2xqBqInxYikerRVxgrZDJe3D0yjOAwVc0mc4ZncPPgqjOC+twDvehmhaA6NBIfEYKz84dwrB6Mrt9Cq/4vETLdO4ScT6oQjlBALgAM8nWb/FF9RJzlAd9XXgB6dikEpY+YhiQQYVyEjX4p7aW7QcduysInkzhAgGEAmjTvnmdbuLNfsz1qbsQ2UtOzYt2yh6iW9i6GrCzHLweVOku6jC8/i8ckhqWoCs5FEJXrCksBwkLt0/29GvH7MCqOL94sjYxfwDf4Vo3h26ncZ/Glzmk6czhfY7X7bBeCvDFTAG733LsPAGJBZqM7Y29/YfUYIHnTRpirSiom7e+CrTnUtp3DVTGZyuYu52RqCBJ95vTuosw6uV6gMoWjBANgsiBN0YjONCTmkzhRddPHxp2ozhkJSfkanUumpzWnPy7stjezoddnjs+mgcaljcnuPhqLVOnz98G4KlhhSZSJ466AqZeuteojBP4RPor+TEKpwxFN7wXsY088MKibPLf1Hrv0IVXAY9cQDE8ld4d5fgmR7OTV6SkB2GF+CRmxkft9dc5qq2plaR+o6GLhJb5R68h0ETNerDRwGXM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5264.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(86362001)(478600001)(316002)(8936002)(6916009)(76116006)(52536014)(7696005)(33656002)(66946007)(66446008)(64756008)(66556008)(66476007)(8676002)(9686003)(2906002)(71200400001)(186003)(6506007)(122000001)(55016002)(26005)(2940100002)(38100700002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y9jPsUC4MlJKnJbv97vdAjnT5bqIHi14DZS08u24DYOsEX37u998PRYCLT3o?=
 =?us-ascii?Q?Y5EXiqrTkZ0CJU6BU6rJ2NrPObhUxM1sSvnTne8nHHT7/yjXZx1RvP6gLt86?=
 =?us-ascii?Q?RLmU0dUFK/CqagODNK93sjcoyAZLpDABZvvi6p7IUhk+ZclOi1N29HRIH2hG?=
 =?us-ascii?Q?G7H5hqh9rZ90KRlWCvC07vSSiDU5sRWvwqQwbixjbC7x6E8ZJfh2WUHVZrxD?=
 =?us-ascii?Q?b2uY9kot0Tj2XztwPCQ4aB6ntOllqx3S6bQVdz2qeedpfd8GJCTOGPQC4Cxe?=
 =?us-ascii?Q?hzFKGFE9SNqK3qEmhRdto1zYBifMNVfkBnbm55ZJ1P+gHoRROl+QSX9HcT3P?=
 =?us-ascii?Q?G6eEpRolgW4KDeRd2o830kAn1VxK1H/U/genOrpcQw480ZtCxH0Cv7z89oAT?=
 =?us-ascii?Q?x0o4BxbgmT39dU5ihYfDFj/oBWqaMgqyeSQZCcQOpXHVmuRU+eHCHqxL77MM?=
 =?us-ascii?Q?jmnkeq/H42ujO5FyxvKxiqGy1dKm3zIIaxFdymGv6THwvG2s5WHl/3heiqRV?=
 =?us-ascii?Q?mhmLjG28PdXAtLCBsOxInmtMzjdddZKHe0vcUMHmoLYiySkxRthBMgAzZKwU?=
 =?us-ascii?Q?3ifJ40e1f05verKS4rMB0zqYUP8pnKGC4WndLLHKyE0OIcQI6tUZ97sNdEZP?=
 =?us-ascii?Q?v6zbf5gB9HNRcNkP7/Z8rxvRPc+scesr9wfqoEFpKY3dbzqZwadDqPr084bM?=
 =?us-ascii?Q?h7hlWFl8G8XYnWccMC+zwQ4diTlkFG9Gkdr8IdEhojY1+zbI8MJ8pB6L71TA?=
 =?us-ascii?Q?JbBOa+fFOrKZANj6NAEW/K55n3qk3tWTVl6ToRbTdV8lRvV94Bd1ab45cE8l?=
 =?us-ascii?Q?xjoORa/tGSLw+OCDkcg1ko2UweD5e35DQna6XX8Pg1BmVr3TItgyoGjLuzuM?=
 =?us-ascii?Q?LxdLlGvYgHlQmVM1m39cblYLyEgdV5sXhaKMeifwAD4wZpfpCqcryRyc2SAF?=
 =?us-ascii?Q?Zung7LzgeAru20sG24nxqkSb4OFUOx0s7bKW4uqpfVL3W3A/UaWiSg4hGS78?=
 =?us-ascii?Q?GeBU8352hCVTZxotyQeWK0KuOZhOnzz2h9dx7dcFcBIVmxiLKqR7zg8YLJGx?=
 =?us-ascii?Q?kRjhxjkBJEYTj6T5MtcuzRorOaMB+DHP7bR/ja2H32NILA7omC+kQI2gReKR?=
 =?us-ascii?Q?qC0q7kuWO/J23K2Pa61hUDN0fSrJ/EF1suV/FrzM555KlmrP8cte8djpAtJU?=
 =?us-ascii?Q?4BKjCBiKg2KR9Ndueee5N943OLMhWKAwV2tgTxdLns8GkMLEiyvySmnY8eiH?=
 =?us-ascii?Q?DweXIxCIraw9T5G3NHfQT7v0B5Xew5r+jz7hAb5FB5zqSqV0x2p+huNsI4jK?=
 =?us-ascii?Q?lao=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5264.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7765a81-8018-47de-ae46-08d92ff7f0d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 12:20:19.3135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Osmv4e/CXxAwu2DI5ZUNvuzsEhYP0+GHYNBbGyBqbSYIxjVel4hsn+n6v7zlpwiXFb9cnZk1LakZTQRJIxtoHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5325
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good afternoon!

We are looking at the use of KVM on x86 to emulate an x86 processor in a Vi=
rtual Prototyping/SystemC context. The requirements are such that the guest=
 OS should be ideally run unmodified (i.e., in this case ideally without an=
y drivers that know and exploit the fact that the guest is not running on r=
eal HW but as a KVM guest).=20

For this, we also would like to control the TSC (as observed by the guest v=
ia rdtsc and related instructions) in such a way that time is apparently st=
opped whenever the guest is not actively executing in KVM_RUN.

I must admit that I am confused by the multitude of mechanism and MSRs that=
 are available in this context. So, how would one best achieve to (approxim=
ately) stop the increment of the TSC when the guest is not running. If this=
 is important, we are also not using the in-chip APIC but are using our own=
 SystemC models. Also, are there extra considerations when running multiple=
 virtual processors?

Any pointers would be greatly appreciated!

Thanks and best regards

Stephan Tobies

