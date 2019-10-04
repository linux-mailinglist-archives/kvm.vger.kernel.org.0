Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCB9CC5EF
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2019 00:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfJDWdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 18:33:33 -0400
Received: from mail-eopbgr700139.outbound.protection.outlook.com ([40.107.70.139]:53857
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727548AbfJDWdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 18:33:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnJAFYDHZPYNjjWDknz51d//VkUzwU/kaukSN3CjI1QGRVOWcpKKIHPajMfJSFRkaiI0KuV/CVPLH/V2HpXFCGv7sVM9NKm5+U8EBTfpFrJpsQi0sC/IAfynRLJ+OKAZYgidpw564RSGtIVlHLparC8k/VsWLTUQww1l2OBLN0A9rMTsxCcloNC9XadVX3nYTdfecXTyBaQ6OiXGT5fnK3Jl7kmER9FakaJtG+0ihKvSaqcI0l+LzAowhpdly8tMJWfm9PI6E6po/pNE2XyOGli2KAfGScdXi+xMyMP17YJ94aBJfGNmrLWegGn6cPAGXZH2MnXfnzOMaL3x2l2gbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipzJS26IRZJ72N+odoZrDKHKtivHmE/mlk8nbyunYqQ=;
 b=glPJCgYs8diyyfK9zdLQWYndBSsCgbvng2BejG07IzEkHtAoW2UI5TvHCk3tb17t7RaJZSiPFM8Xz0ELVGajv8iD14VUb3y/hSN84ZUMLYkEDv+jFCWTqddCMIze6vJjJrr9cXvV5iIgRzvUCP5uf2nSL2uzZca1wVvPT6tX/bt7J5C74pmMYlPlWEkS4VBoFBj2LIz0hHwdXEoH+68o5CIMH9msddbWOsuiksPx7WZZ+5Km7UyDEn2GCuOrAB8s7t/iJ2o/eDXXYzJ9XeBBWJoVtmts+wU/d1E9EuXD/+1H2Mm38wyZgy4235zJk83Dxtrd0rH54GaVcdiX0VHP9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipzJS26IRZJ72N+odoZrDKHKtivHmE/mlk8nbyunYqQ=;
 b=Acco0LPmWBW/hl6N2J4vz+ETxfO2V6pHBpgEqRU9Pivqy7lH+uXdqkawD1ePF4p37KE8ePzLJAgTVdkLprBKuzGBoFbqlVK5fK4lPopp8QeotPf2a+IL424rptXzCylHxD12ECh8H1OvQWKzVMCgYd4hsLPwBA/n1V/XoPwBiSE=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0281.namprd21.prod.outlook.com (10.173.174.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.0; Fri, 4 Oct 2019 22:33:29 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e%11]) with mapi id 15.20.2347.012; Fri, 4 Oct 2019
 22:33:29 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Roman Kagan <rkagan@virtuozzo.com>
CC:     vkuznets <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Joerg Roedel <jroedel@suse.de>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] x86/hyperv: make vapic support x2apic mode
Thread-Topic: [PATCH v2] x86/hyperv: make vapic support x2apic mode
Thread-Index: AQHVeQrgrl6z6kaUqkyr6D3zFBAn2KdIv6eAgAAhHwCAAOlpQIAAbTiAgADZYJA=
Date:   Fri, 4 Oct 2019 22:33:29 +0000
Message-ID: <DM5PR21MB0137FCE28A16166207E08C7CD79E0@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <20191002101923.4981-1-rkagan@virtuozzo.com>
 <87muei14ms.fsf@vitty.brq.redhat.com> <20191003125236.GA2424@rkaganb.sw.ru>
 <CY4PR21MB0136269170E69EA8F02A89E9D79E0@CY4PR21MB0136.namprd21.prod.outlook.com>
 <20191004091855.GA26970@rkaganb.sw.ru>
In-Reply-To: <20191004091855.GA26970@rkaganb.sw.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-04T22:33:27.3495621Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8f8051ff-be74-4bb4-9e27-c7431927dce0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [131.107.159.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cf42221-92b8-45fb-42d9-08d7491ae19d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0281:|DM5PR21MB0281:|DM5PR21MB0281:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB028154CFA1B2BED0C90925F8D79E0@DM5PR21MB0281.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(189003)(199004)(6436002)(64756008)(66476007)(476003)(66446008)(66556008)(14454004)(8936002)(86362001)(2906002)(52536014)(7696005)(76116006)(74316002)(33656002)(5660300002)(478600001)(229853002)(6506007)(76176011)(102836004)(66946007)(256004)(6246003)(186003)(10290500003)(7416002)(446003)(305945005)(10090500001)(14444005)(11346002)(486006)(55016002)(8676002)(25786009)(22452003)(54906003)(9686003)(316002)(99286004)(26005)(3846002)(6116002)(8990500004)(6916009)(4326008)(71200400001)(81166006)(7736002)(81156014)(66066001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0281;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vNcCKvKv6QAClLFLQiNOFSdQaA0gyojlGKueO3VhieZFmiQuhJHf7WdQNcw2O2iRUib9keI32hdBvR0lYmrDgYebZk0I+qApuV7owt+NaQw9nRtbVDUp6vtAOneQ9DsPU40bJSOkQ6mMvr5oDEPLjloExSM4tk+QIm1pfLuEtCIcILHbvFI31VvFGzo7NtXj0QxAJ7p2HWVtqT3hqkeXodx1eU2Ilck1OynqqhqwKJZJytOs/mInnEru//JyyxhEm9BPrFL+HXunXauZ36Zfg/Z0/UYNFl5gunI8Ku9jM+xw+yTeQ4LACH1zTeSO/d+PG8hhHmDFgMlvsXUTjSv+NcUX5GG63VvbChJVK5RzRioo29eNs7bAJL7/yb2ssPMTCb1OTOgfeHrlGNbHFA0lPB1YPsa6xx5RuY/yFY343Vc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf42221-92b8-45fb-42d9-08d7491ae19d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 22:33:29.6522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YwH9+nS/TDiAqE3quInJOeNTCVkI8yziRNFGGKzmUUs/H3hPzf8kplbb7W1LVC8odhz5kJMyjD1eq5MjfTHtavjSUYv0aHfLwqmeflBudi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0281
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Roman Kagan <rkagan@virtuozzo.com> Sent: Friday, October 4, 2019 2:19=
 AM
>=20
> On Fri, Oct 04, 2019 at 03:01:51AM +0000, Michael Kelley wrote:
> > From: Roman Kagan <rkagan@virtuozzo.com> Sent: Thursday, October 3, 201=
9 5:53 AM
> > > >
> > > > AFAIU you're trying to mirror native_x2apic_icr_write() here but th=
is is
> > > > different from what hv_apic_icr_write() does
> > > > (SET_APIC_DEST_FIELD(id)).
> > >
> > > Right.  In xapic mode the ICR2 aka the high 4 bytes of ICR is program=
med
> > > with the destination id in the highest byte; in x2apic mode the whole
> > > ICR2 is set to the 32bit destination id.
> > >
> > > > Is it actually correct? (I think you've tested this and it is but)
> > >
> > > As I wrote in the commit log, I haven't tested it in the sense that I
> > > ran a Linux guest in a Hyper-V VM exposing x2apic to the guest, becau=
se
> > > I didn't manage to configure it to do so.  OTOH I did run a Windows
> > > guest in QEMU/KVM with hv_apic and x2apic enabled and saw it write
> > > destination ids unshifted to the ICR2 part of ICR, so I assume it's
> > > correct.
> > >
> > > > Michael, could you please shed some light here?
> > >
> > > Would be appreciated, indeed.
> > >
> >
> > The newest version of Hyper-V provides an x2apic in a guest VM when the
> > number of vCPUs in the VM is > 240.  This version of Hyper-V is beginni=
ng
> > to be deployed in Azure to enable the M416v2 VM size, but the functiona=
lity
> > is not yet available for the on-premises version of Hyper-V.  However, =
I can
> > test this configuration internally with the above patch -- give me a fe=
w days.
> >
> > An additional complication is that when running on Intel processors tha=
t offer
> > vAPIC functionality, the Hyper-V "hints" value does *not* recommend usi=
ng the
> > MSR-based APIC accesses.  In this case, memory-mapped access to the x2a=
pic
> > registers is faster than the synthetic MSRs.
>=20
> I guess you mean "using regular x2apic MSRs compared to the synthetic
> MSRs". =20

Yes, of course you are correct.

> Indeed they do essentially the same thing, and there's no reason
> for one set of MSRs to be significantly faster than the other.  However,
> hv_apic_eoi_write makes use of "apic assists" aka lazy EOI which is
> certainly a win, and I'm not sure if it works without hv_apic.
>=20

I've checked with the Hyper-V people and the presence of vAPIC makes
a difference.  If vAPIC is present in the hardware:
1) Hyper-V does not set the HV_X64_APIC_ACCESS_RECOMMENDED flag
2) The architectural MSRs should be used instead of the Hyper-V
    synthetic MSRs, as they are significantly faster.  The architectural
    MSRs do not cause a VMEXIT because they are handled entirely by
    the vAPIC microcode in the CPU.  The synthetic MSRs do cause a VMEXIT.
3) The lazy EOI functionality should not be used

If vAPIC is not present in the hardware:
1) Hyper-V will set HV_X64_APIC_ACCESS_RECOMMENDED
2) Either set of MSRs has about the same performance, but we
    should use the synthetic MSRs.
3) The lazy EOI functionality has some value and should be used

The same will apply to the AMD AVIC in some Hyper-V updates that
are coming soon.

So I think your code makes sense given the above information.  By
Monday I'll try to test it on a Hyper-V guest VM with x2APIC.

Michael
