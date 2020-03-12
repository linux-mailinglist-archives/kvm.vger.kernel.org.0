Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD0B18397F
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 20:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgCLTcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 15:32:50 -0400
Received: from mail-bn7nam10on2136.outbound.protection.outlook.com ([40.107.92.136]:47681
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726845AbgCLTcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 15:32:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVv+87ogYGZepORLJmt6p+xbv8fCubKmJPcA1ie0B3V/I29C/7IrF8jlaRO0hHfbWkktWyb046H0ku5k1vcv2YWZ8ESHvP3MqYysOJU3F8S+R+G4SlQ6dve1iQfq1CwLso5ixOfn8lu1RyLr4lyH7s40biCvTqE4qrepj1kpgEu9GV7Mpy48c8CD/8clfimTadGXMxakC72dpndwiqDBZgCjfANaREKMFweactVu6VNy4YnzZa/lk22yK2CI6jzUQ8dakx5hSA3qt/mOtr45EnvxPXmSKL+WT9RmEeO7ZkHbjH8rnP32zP1q/PXDE8BSPrK/Xlc8t7dP0RvqlRXrhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/1Cm88OUHRwDBd0XfKPLL1sNSpCXjN/0aVT/yoU1RA=;
 b=gGraBhj8S50u8CPE51EeImeY8CAENGYf1z9h4UsmuQe1jfIvtXNnpoy2btlSxVgiGB/6cPdlC5w/M+vE6AgHdt77EBprlpAwXhf0e4edVh0CeJ4MHrNs140s6X2lyPeMoRzvM34ZSrcfCyqBhrrG0tc+s75O4mFhFpMxRGiKox1GaD3cNp3iBby1w4M8aF5fIf1DFrpa5hnDeXrdk4w5cGcwdeAGlqwHrn6ZygDHujkdLjBusrEYUseviD0t9Z2fZ8glZaZfDGi5HaoYiIZJODf/gXZPxFKsJ80Ue2SXTU/4Rg/N/5hvV8HNxlETXrr9yOZiw0ssTD0ljrk74CuMpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/1Cm88OUHRwDBd0XfKPLL1sNSpCXjN/0aVT/yoU1RA=;
 b=c2qDSPmqAPIH+ABfXEoST8KrkybUlfQuk84BNOohboFLGiV9fA+CI02OMIDhQm5a08bHACizR/IBr1YI9O7T9fkbQSOp/WIPEXBwvbSP73Lg11UF1NuQ1NgpBBzftD6QLB8LPz+MyDfSQ2fvp+UKcgPz+EtFD4IMd9oQPT4aSyc=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1098.namprd21.prod.outlook.com (2603:10b6:302:a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.2; Thu, 12 Mar
 2020 19:32:46 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%9]) with mapi id 15.20.2835.003; Thu, 12 Mar 2020
 19:32:46 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Jon Doron <arilou@gmail.com>
CC:     vkuznets <vkuznets@redhat.com>, Wei Liu <wei.liu@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Topic: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Index: AQHV9j9ukyAJ0hjklE6HBDoXElbMoqhAvCqQgABuRICAAAUi4IADzpOAgAAQ5oCAAEjBAIAABLlg
Date:   Thu, 12 Mar 2020 19:32:46 +0000
Message-ID: <MW2PR2101MB1052572531F218BF7DAFBA2AD7FD0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200309182017.3559534-1-arilou@gmail.com>
 <20200309182017.3559534-3-arilou@gmail.com>
 <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
 <20200310032453.GC3755153@jondnuc>
 <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <87d09hr89w.fsf@vitty.brq.redhat.com>
 <MW2PR2101MB10527BA547449B34FEC65C1FD7FD0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200312191216.GA2950@jondnuc>
In-Reply-To: <20200312191216.GA2950@jondnuc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-12T19:32:44.2984174Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=73a18ffe-e3fa-4698-a735-612d9bf24f58;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f7f34a8c-0c99-4a78-43d0-08d7c6bc2484
x-ms-traffictypediagnostic: MW2PR2101MB1098:|MW2PR2101MB1098:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB10982353BB1680F419E500F1D7FD0@MW2PR2101MB1098.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(199004)(26005)(4326008)(33656002)(71200400001)(186003)(6916009)(7696005)(6506007)(966005)(8990500004)(5660300002)(478600001)(9686003)(8676002)(2906002)(10290500003)(81156014)(81166006)(66946007)(76116006)(316002)(55016002)(8936002)(54906003)(86362001)(66476007)(64756008)(66556008)(66446008)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1098;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AWv1nF0AcDylW5VmVDrgYg2/kC26Uic9raM0ufORnKUGd6w/RL2QP45xTpFyb7bYfWD3Y8R3Prsz/ACStSau01HrA4qlOw4iPHQaozetz4QEY8sZ4s+OSJ6UX2bU0Ykjo2BGVNNyoPsqGm6htHbm3Es3kl8KkvMErDqJVl9B3Iznk/U6tiFKn9INRkwwGqA144g0AYZRHmqe+zDb08ETg/ntCkKKdss1DoLru4ZbVH2RgyjIVzW77oYyrxGxSDhkYNF9Ttdqp7c7i0lFebo8YCCBIz69/6EmoON5A0vExk3FDBjA8hgp+BXlwzIPRv30i9JEXugJZa0c/31InmwMJXFMPbhAcxdo+MDpJaj9kFRXyJmEb5QZFsPAfdUtLXg+2MkW2DrxA3HQm7UAxnsZxz+E0JFiEbh1fO6X0vI+GjXSdVr6Lg43uvhHCo3I7S28sE7uxNIWG2Yhk4sKAdLeHCZGvk1VEpIaXCzQbqtJIxOXsNVk7RB4Xg7wuHm9CSqkS68WK1l9PAbmmGWH/fWN5Q==
x-ms-exchange-antispam-messagedata: fz1SqfRyBKS1NMp4dtUClbDKdzwJZZeHwPchERdt+BCUIlZZPwjj96De70fyYDF0fJWVoduqCBH/JcMyrnybVVAnR/sc4mrXQ92W32UB/vgxJmsOr7BvLn5pBWtsDw343gQqHQwVVpQwHKjoyWJlHA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f34a8c-0c99-4a78-43d0-08d7c6bc2484
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2020 19:32:46.3314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +GZJQgSxS/iuGRGqCyNBXlJauQ4UFVAVfRHD43YqUpA27Awl73UBIchDP/4zkjMtmJSrlSAacGsNJwJE30M0f2ZillCZGY44IqjM91HkURE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jon Doron <arilou@gmail.com>  Sent: Thursday, March 12, 2020 12:12 PM
>=20
> On 12/03/2020, Michael Kelley wrote:
> >From: Vitaly Kuznetsov <vkuznets@redhat.com>  Sent: Thursday, March 12, =
2020 6:51 AM
> >>
> >> Michael Kelley <mikelley@microsoft.com> writes:
> >>
> >> > I'm flexible, and trying to not be a pain-in-the-neck. :-)  What wou=
ld
> >> > the KVM guys think about putting the definitions in a KVM specific
> >> > #include file, and clearly marking them as deprecated, mostly
> >> > undocumented, and used only to support debugging old Windows
> >> > versions?
> >>
> >> I *think* we should do the following: defines which *are* present in
> >> TLFS doc (e.g. HV_FEATURE_DEBUG_MSRS_AVAILABLE,
> >> HV_STATUS_OPERATION_DENIED, ...) go to asm/hyperv-tlfs.h, the rest
> >> (syndbg) stuff goes to kvm-specific include (I'd suggest we just use
> >> hyperv.h we already have).
> >>
> >> What do you think?
> >>
> >
> >I could live with this proposal, since they *are* in the TLFS v6.0 as it
> >exists today. However, v6.0 seems inconsistent in what parts of this
> >debugging functionality it exposes, probably just because someone
> >hasn't thought comprehensively about the topic across the whole
> >document.   I'll make sure that it gets looked at in the next revision
> >(which should be a lot sooner that the 2+ years it took to get the v6.0
> >revision done).   But I won't be surprised if the remaining vestiges are
> >removed at that time, in which case we would want to move the
> >definitions from hyperv-tlfs.h to KVM's hyper.h.
> >
> >Michael
>=20
> Hi guys, just a quick note I went over the old HyperV TLFS and it seems
> like all the Syndbg MSRs are documented (under Appendix F: Hypervisor
> Synthetic MSRs, from v5.0b).
>=20
> It seems like the undocumented stuff is HV_X64_MSR_SYNDBG_OPTIONS which
> seems kinda odd because that's how you enable the hypercalls debugging
> interface which is documented.
>=20
> And the syndbg CPUID leafs are not documented as well.
>=20
> So would you like me to put all the MSRs in the tlfs omitting the
> HV_X64_MSR_SYNDBG_OPTIONS.
>=20
> So in hyperv.h we will have HV_X64_MSR_SYNDBG_OPTIONS and the CPUID
> leafs.
>=20

Could you make the decision based on the new v6.0 of the Hyper-V TLFS?
See https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/refe=
rence/tlfs
to get a copy.  I think some of the synthetic debugger stuff has been dropp=
ed
from the v6.0 version compared with the earlier v5.0 versions, and I'd like=
 the
updates to hyperv-tlfs.h to reflect that newest version.

Michael
