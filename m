Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF6ED028A
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 22:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbfJHUyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 16:54:55 -0400
Received: from mail-eopbgr790135.outbound.protection.outlook.com ([40.107.79.135]:2048
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730523AbfJHUyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 16:54:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOXI1qg3x6B/kS49NRedIVLsUdZwoy+vuZDGl+X+V7JSgE4DYZcFb8DWf8aSvmWfPQkwpgfkL0+E28ceXetSwACNih7egdgjJxJUp7K9cl5S5lddS3H1HMr1G4i004B0eiJ0YteqQGK/lc8Mecx3c/L3HpHBe/h8V9bQx4Ua0eh3y6NbnO+xMXusx/rDC+SchIGRbaaR7JBhYoOixu7/DSvaKGcmInYIl293d9lMgNINj3xrsN5cX0i+ZdirmdnQimxVdc7Up2kJYB+l2oP7ySq7NC+WccIiDH8WtDIcbgvD+xoH0WAM84WbasKQbMX5vxUcmjZotriwsZG0tLcpfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytBaq0fwxlwfP/lJqWdo5bdiSsoJwepxG/t7I7sLP0w=;
 b=Q74Pjh4ZtwAwhz9rWVij31BbCNzzhuWexQsL5hn0kKalhlc3Qqd1XBuo++Ymt4vY9NBNO0ws8+LWTiN7jjzFc/xSsrnl/F0/+btMGOTSqrBgYuRHntNUyBDSnUC9cW+lSykB2c1btfNvm8GYEkRVnd3Db/Wff7oP42xMra4UzayatNqKFplPmPw0NkTQTb3pnF3A1YqPfragoa5UKb0oLL9wJmkpXBE3UXtW030/J+Ava86vEON4gdxB8KRHGcqgNCT2DaXpBnBKyCR66wE4lbE30eg/pOzKtxapMnq67tz3gqwafDRT3L8y3kIKz71yIKKK9ojnHsMGt9RmC4FVzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytBaq0fwxlwfP/lJqWdo5bdiSsoJwepxG/t7I7sLP0w=;
 b=O5fUuTSoGbfpHiAs14lvhVxSiWYUJAt3b1tAvJnJ5Ux4RpeY5+43UCeYCDKp6+GzKFy7/cgtKtGDDAgIRG/Cir0wTd5bN6rmOS7rltL0NduPDALOQe1r9IRBoqV80Ya5dF8HD7Csq9TGtA3v/ZVwwTm5nTkchOhOR3dTc4RgXPI=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0764.namprd21.prod.outlook.com (10.173.172.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256) id
 15.20.2367.2; Tue, 8 Oct 2019 20:54:51 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e%11]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 20:54:51 +0000
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
Thread-Index: AQHVeQrgrl6z6kaUqkyr6D3zFBAn2KdIv6eAgAAhHwCAAOlpQIAAbTiAgADZYJCABg2jwA==
Date:   Tue, 8 Oct 2019 20:54:50 +0000
Message-ID: <DM5PR21MB0137D136B42F72296B24B11AD79A0@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <20191002101923.4981-1-rkagan@virtuozzo.com>
 <87muei14ms.fsf@vitty.brq.redhat.com> <20191003125236.GA2424@rkaganb.sw.ru>
 <CY4PR21MB0136269170E69EA8F02A89E9D79E0@CY4PR21MB0136.namprd21.prod.outlook.com>
 <20191004091855.GA26970@rkaganb.sw.ru>
 <DM5PR21MB0137FCE28A16166207E08C7CD79E0@DM5PR21MB0137.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR21MB0137FCE28A16166207E08C7CD79E0@DM5PR21MB0137.namprd21.prod.outlook.com>
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
x-originating-ip: [2001:4898:80e8:f:dd36:c36c:f433:5add]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efffe2b7-89fa-4e1a-8eda-08d74c31c34f
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0764:|DM5PR21MB0764:|DM5PR21MB0764:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB07649DB7E8B88D8BBA3F1624D79A0@DM5PR21MB0764.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(199004)(189003)(14454004)(81166006)(33656002)(6916009)(478600001)(5660300002)(71190400001)(86362001)(71200400001)(25786009)(14444005)(256004)(46003)(186003)(102836004)(486006)(54906003)(7416002)(81156014)(52536014)(7736002)(305945005)(74316002)(8676002)(316002)(22452003)(8936002)(11346002)(476003)(446003)(6436002)(55016002)(9686003)(229853002)(66556008)(7696005)(66476007)(66446008)(64756008)(6116002)(2906002)(99286004)(6246003)(6506007)(66946007)(8990500004)(76116006)(10290500003)(10090500001)(76176011)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0764;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xGQHgbilpsV4LH1Y+YJtQ00WKHOICTAV5QV8943iE9cdyUgK1BcWf9lCqN8aEFiFQUBj6IrPXRZYWZ3IiJwqt+s2QnARlT6L81t02xnf4Lmzj0dpsbXLaKs9Wws/irNedo9OgE+WQnIBFGqMB4BVe4mPGmPE3j381odZFbp6JjjjbDrMHrTpBqleeoZRd64idbdQ93PbzjDjn7fUutDG8ytRFl7H+4Osp1N/p77qRaa4t6pJ/iaYN/Z4KHF0l4CRheSuEQB1Py9k2SYbTue01VNAPwsUQHzlrIqpIJo6S9dzOk8K9F4X0cwzIOH5KfsrbZ6tF+YSxVXMx70i54rBxs5FOES/qvkxRuZt3IYnI7dDhrD7m6Lx3/KJ0UXzWb3yMZh89uWVM8IFig7VKhibQ4Cn41SRpGBhOOfOpGczdVg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efffe2b7-89fa-4e1a-8eda-08d74c31c34f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 20:54:50.7775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SW1nbofe+sCZiPo2M1iGVtoJvSC5CnCGvLTu7e6D4w2sIbNYwNZPudjlI6xtMjLwlCDn5XAKFaqDbLMMxVi9cdGtKsl3nabFlskXC/pUfes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0764
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com> Sent: Friday, October 4, 2019=
 3:33 PM
>=20
> From: Roman Kagan <rkagan@virtuozzo.com> Sent: Friday, October 4, 2019 2:=
19 AM
> >
> > On Fri, Oct 04, 2019 at 03:01:51AM +0000, Michael Kelley wrote:
> > > From: Roman Kagan <rkagan@virtuozzo.com> Sent: Thursday, October 3, 2=
019 5:53 AM
> > > > >
> > > > > AFAIU you're trying to mirror native_x2apic_icr_write() here but =
this is
> > > > > different from what hv_apic_icr_write() does
> > > > > (SET_APIC_DEST_FIELD(id)).
> > > >
> > > > Right.  In xapic mode the ICR2 aka the high 4 bytes of ICR is progr=
ammed
> > > > with the destination id in the highest byte; in x2apic mode the who=
le
> > > > ICR2 is set to the 32bit destination id.
> > > >
> > > > > Is it actually correct? (I think you've tested this and it is but=
)
> > > >
> > > > As I wrote in the commit log, I haven't tested it in the sense that=
 I
> > > > ran a Linux guest in a Hyper-V VM exposing x2apic to the guest, bec=
ause
> > > > I didn't manage to configure it to do so.  OTOH I did run a Windows
> > > > guest in QEMU/KVM with hv_apic and x2apic enabled and saw it write
> > > > destination ids unshifted to the ICR2 part of ICR, so I assume it's
> > > > correct.
> > > >
> > > > > Michael, could you please shed some light here?
> > > >
> > > > Would be appreciated, indeed.
> > > >
> > >
> > > The newest version of Hyper-V provides an x2apic in a guest VM when t=
he
> > > number of vCPUs in the VM is > 240.  This version of Hyper-V is begin=
ning
> > > to be deployed in Azure to enable the M416v2 VM size, but the functio=
nality
> > > is not yet available for the on-premises version of Hyper-V.  However=
, I can
> > > test this configuration internally with the above patch -- give me a =
few days.
> > >
> > > An additional complication is that when running on Intel processors t=
hat offer
> > > vAPIC functionality, the Hyper-V "hints" value does *not* recommend u=
sing the
> > > MSR-based APIC accesses.  In this case, memory-mapped access to the x=
2apic
> > > registers is faster than the synthetic MSRs.
> >
> > I guess you mean "using regular x2apic MSRs compared to the synthetic
> > MSRs".
>=20
> Yes, of course you are correct.
>=20
> > Indeed they do essentially the same thing, and there's no reason
> > for one set of MSRs to be significantly faster than the other.  However=
,
> > hv_apic_eoi_write makes use of "apic assists" aka lazy EOI which is
> > certainly a win, and I'm not sure if it works without hv_apic.
> >
>=20
> I've checked with the Hyper-V people and the presence of vAPIC makes
> a difference.  If vAPIC is present in the hardware:
> 1) Hyper-V does not set the HV_X64_APIC_ACCESS_RECOMMENDED flag
> 2) The architectural MSRs should be used instead of the Hyper-V
>     synthetic MSRs, as they are significantly faster.  The architectural
>     MSRs do not cause a VMEXIT because they are handled entirely by
>     the vAPIC microcode in the CPU.  The synthetic MSRs do cause a VMEXIT=
.
> 3) The lazy EOI functionality should not be used
>=20
> If vAPIC is not present in the hardware:
> 1) Hyper-V will set HV_X64_APIC_ACCESS_RECOMMENDED
> 2) Either set of MSRs has about the same performance, but we
>     should use the synthetic MSRs.
> 3) The lazy EOI functionality has some value and should be used
>=20
> The same will apply to the AMD AVIC in some Hyper-V updates that
> are coming soon.
>=20
> So I think your code makes sense given the above information.  By
> Monday I'll try to test it on a Hyper-V guest VM with x2APIC.
>=20

I've smoke tested your code with a Hyper-V guest VM with x2APIC
and 1024 vCPUs and HV_X64_APIC_ACCESS_RECOMMENDED
enabled.  The new x2apic functions you have added appear to work.
No issues were seen.

However, based on further discussion with the Hyper-V team, the
architectural MSRs and the synthetic MSRs really are interchangeable
with an x2apic.  There's no perf difference like there is with the
memory-mapped registers in the classic APIC.  So your new x2apic
functions aren't really needed -- all that's needed is to skip plugging
in the hv_apic functions when an x2apic is present.  The native x2apic
functions will work just fine.  Note that even with x2apic,
hv_apic_eoi_write() should still be used to take advantage of the
lazy EOI functionality.  It's OK to use the synthetic EOI MSR with
x2apic for this case, so again no additional code is needed.

I quickly changed the code to do the above so that the architectural
MSRs are used, and those changes successfully smoke test on the
same 1024 vCPU VM with no problems.  I tested with vAPIC enabled
and with vAPIC disabled, and all looks good.

Michael
