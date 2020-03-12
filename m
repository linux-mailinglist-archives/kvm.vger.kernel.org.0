Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D0B1833F1
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 15:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCLO7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 10:59:21 -0400
Received: from mail-dm6nam11on2097.outbound.protection.outlook.com ([40.107.223.97]:14689
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbgCLO7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 10:59:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0G4BGmMGWYpQZWJwrfp0YV0qypdvm8zAZybRcYO5yQDDzq5Ql1hfT9PdYSdTBUKbdccE6cPiwxEzucy8ze+XnK2LFtT1aiPeTufZfHvqiU5oIkI+wFqBJ+gVhPVleah6f9ctR4NmqtFhJKwNumCwoVShUdxQhyvA7mxZuxKXpiMnRkai2TOXvoHwuAkQq0dpaqc57J9d5dY7VIVaTxzG6Ml7H39ZB4bGg298fZ1V98jWtC8+/5C2IB5sIIMRiy2qbUhaFdmwLjgPB0mmaiamNJ+IsRhmkDzv4XttH2OEXYHf9G7zXGttCYtMbZRiznmdHZpSXhiq+6s/j4rfdY8Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQ4SP6K6onp9nXGyypq2eJk/rd9gq2L/GrLWyivMToM=;
 b=eUrVgo7Fh6Kg1AJFQmjo8PxyhkF3KfthCbXma5qkBXl7D6m7ut5XAuEEe0FwHf5rfVbSUYx5DyhYx7GoAxk9Lg4MIASZ6p0aY8zdwihIuU+gcQ46GybAArYGIQ1hTIRDwmwliK+i09zUAmjVAOZLFcRPsw64Yr0j2Eu5WZooLt0Nw13wBoe3vXaEFsjePVo2gvwVIwuWdcb7/1TLU3RiGPG1WCA01J7mr627fJ2zxEC3WQXHPM9og34zafScZdJUwC+xiot1YokD+zcqeRFCfceMPG3ge4s+I5KwZ2T27dlWVFVB6h5LqrA5R3djH93nOz16lyQM/sPgqTkoztoFRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQ4SP6K6onp9nXGyypq2eJk/rd9gq2L/GrLWyivMToM=;
 b=Np7rbPSQUkRcbDEF6cL9x7f8Rhe3w1YeVQXMokbjdQzmFrwPmIkIocu5HdJL8nlZehXme4jNx/LAMIL29j4Js5f4GH6iLMw8ADWoIgHgMzw2TaS8M4pfHy8xQ88t9JzjPDziIf8IP3YnGb6wM3U3CW2K8rMBCc1w+fjNAaA6f18=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0892.namprd21.prod.outlook.com (2603:10b6:302:10::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.2; Thu, 12 Mar
 2020 14:59:17 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%9]) with mapi id 15.20.2835.003; Thu, 12 Mar 2020
 14:59:17 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>, Jon Doron <arilou@gmail.com>,
        Wei Liu <wei.liu@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Topic: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Index: AQHV9j9ukyAJ0hjklE6HBDoXElbMoqhAvCqQgABuRICAAAUi4IADzpOAgAAQ5oA=
Date:   Thu, 12 Mar 2020 14:59:17 +0000
Message-ID: <MW2PR2101MB10527BA547449B34FEC65C1FD7FD0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200309182017.3559534-1-arilou@gmail.com>
 <20200309182017.3559534-3-arilou@gmail.com>
 <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
 <20200310032453.GC3755153@jondnuc>
 <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <87d09hr89w.fsf@vitty.brq.redhat.com>
In-Reply-To: <87d09hr89w.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-12T14:59:15.9423104Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b81f8835-5389-4109-a8f7-1103d9bf5674;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 60a964ea-8221-44d2-f032-08d7c695f006
x-ms-traffictypediagnostic: MW2PR2101MB0892:|MW2PR2101MB0892:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB08923937963A46B8DEA906FDD7FD0@MW2PR2101MB0892.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(199004)(81156014)(81166006)(6506007)(8676002)(8936002)(86362001)(4326008)(55016002)(316002)(52536014)(9686003)(8990500004)(7696005)(110136005)(2906002)(54906003)(10290500003)(478600001)(66446008)(64756008)(66556008)(66476007)(66946007)(71200400001)(76116006)(33656002)(5660300002)(26005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0892;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjMG0lnY07QIuGm16/YKAigpXtz3Vd+BZ/rJZrDNd5kUt0Mj61QEuagtOmDQ5d/PveJB85ER+m6xbDKTbN+Ved04LHdsYrpzzR5HadEMKFet3tz9ObeD4OF61HqwDhvQbYS5RHcxHW8UzEyZq7KpmfcWgkUfnmoEv5PhSHiL9783Sq12YawN3VakPQuLkcBbK2J35uBA9VIwhHKjJrHW3D954DNgvI+ohzBBo663vAqSBYB18zUQA1PjbLo+Ztu/8cHbnSuDrcwcjlqm9yy1+yFGaYYynMkD20UFSLMSylDGZh2pjbdbLIxKjUncJEzMtGTJiymZLYEzmj0sngrslfZbXCiCMJmoLl8aRQzf03cJzNIJjyyelutXoKsjTEto6H2VvnJtMCNNl0bN8hZhnZPpac/4I7Y6J3JulDaHFEKcCaIfyXJrQQhq6C6LTlOd
x-ms-exchange-antispam-messagedata: xav4d8v+RhWmi4vithxefLtRf7IqpgphjGqaqOCfW/sLFYaVcbBhqbHiEGzNLBpnorAIH46eiJxndQIKouFBtRKkHS7EF/J6YblBPuKn+HWnPaI29ConLUN61gjKTB95+noZmoZi58yXmxjBqHybpA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a964ea-8221-44d2-f032-08d7c695f006
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2020 14:59:17.4058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O3hvWxcyP8n8TN1jpBDh38H+YSsx4j2wE5mSaMs1rsSmB3oWmwnGntS+vr77E/5aTrE6R62cANHUDEoRG6SFUHgGNDekLBvypQFQRNDkI7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0892
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>  Sent: Thursday, March 12, 202=
0 6:51 AM
>=20
> Michael Kelley <mikelley@microsoft.com> writes:
>=20
> > I'm flexible, and trying to not be a pain-in-the-neck. :-)  What would
> > the KVM guys think about putting the definitions in a KVM specific
> > #include file, and clearly marking them as deprecated, mostly
> > undocumented, and used only to support debugging old Windows
> > versions?
>=20
> I *think* we should do the following: defines which *are* present in
> TLFS doc (e.g. HV_FEATURE_DEBUG_MSRS_AVAILABLE,
> HV_STATUS_OPERATION_DENIED, ...) go to asm/hyperv-tlfs.h, the rest
> (syndbg) stuff goes to kvm-specific include (I'd suggest we just use
> hyperv.h we already have).
>=20
> What do you think?
>=20

I could live with this proposal, since they *are* in the TLFS v6.0 as it
exists today. However, v6.0 seems inconsistent in what parts of this
debugging functionality it exposes, probably just because someone
hasn't thought comprehensively about the topic across the whole=20
document.   I'll make sure that it gets looked at in the next revision=20
(which should be a lot sooner that the 2+ years it took to get the v6.0
revision done).   But I won't be surprised if the remaining vestiges are
removed at that time, in which case we would want to move the
definitions from hyperv-tlfs.h to KVM's hyper.h.

Michael
