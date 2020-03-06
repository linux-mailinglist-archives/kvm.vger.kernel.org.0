Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020C817C212
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgCFPpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 10:45:20 -0500
Received: from mail-bn7nam10on2125.outbound.protection.outlook.com ([40.107.92.125]:21728
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbgCFPpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 10:45:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5jt3p0/3/+r+pHbEmzZOi9HRwhLTmOFx8KnUsQ8gbrI0ts7zi8FZnf9rEDKFKz3HVd+qSjpVUOETMdTMTkFJQVlwklSSmMuvhGG0M09D9ViQ9ic63DjkZAsIIPZnPrM2nz7WEOa2uHX6a6yQH1tH2C0GIZSTL2qLcxrwNce4PWz77bkh+0FOE+uMbkZEvKjKN5VYksalmptVMEjWfgE79UDtT6/cB5oxmG/D082I1rHSiW+bxqd/bYYN4PDOnv3+Xi3rcmDOd1a55NlkOPQPzCLfjat6O5GUtg/uA6Evb7OodPqpltZwF2FCcjgvv9jklm5zNgwE5meWfoQ808zSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCX+6KWnX6kPbDcSKCh0R2kDIPtoSWi1pW5+5Cv5vlw=;
 b=WsuvmbVN4vjxdBobD2fJ3Bwg60YT3RGJ9nQHal+0Hf6dtU3ByaefRepTuA6FFY3GydLw/HiThneBKCEQDTBxXaSPyCrRxE0qb63az+03I8clN6dT+zIeaUy2CWV7nZ+lnd7GJg+LPnKAlsN2HVpPBgR6fdDukyUd5kAdJeZTCzyUWSncj4T13IMOD7Lu9cPhjfdFzuXYZN3envNiqY/kVTTJ9RmUV41VeWdIhZj9lp6lUWVQrY2OS/PKcgbLoiVVOTGty+saDuHxnu7cByL59ho4u2we8mrUmZKnlfKWcW7pCnQan2sO6FsqiHIVPyTGaxZ9J9+HkgPXimwEkIC+tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCX+6KWnX6kPbDcSKCh0R2kDIPtoSWi1pW5+5Cv5vlw=;
 b=f80GU7mrEcOt39o/C8RFhMOto2had6vgvgEAEos+hXVE2uEpt6jYZgv/sxTedJg919M0TdSK3JSj8M93L6lFj15VVTB6wVravs992ZB7Lzw2i14zwqfdo/N+PdmS7NkzO5BeB2lWbMZFpTlCBlCPbd9MGfEg9MCZGtAtyqnGXhg=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0938.namprd21.prod.outlook.com (2603:10b6:302:4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.3; Fri, 6 Mar
 2020 15:45:14 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%8]) with mapi id 15.20.2814.007; Fri, 6 Mar 2020
 15:45:14 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>, Jon Doron <arilou@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v2 2/4] x86/kvm/hyper-v: Add support for synthetic
 debugger capability
Thread-Topic: [PATCH v2 2/4] x86/kvm/hyper-v: Add support for synthetic
 debugger capability
Thread-Index: AQHV8vacnEeUTbCT1kuy0d/JpjFqR6g7sVsAgAADmVA=
Date:   Fri, 6 Mar 2020 15:45:13 +0000
Message-ID: <MW2PR2101MB1052A1C56C05BFB0DDC4CF5FD7E30@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200305140142.413220-1-arilou@gmail.com>
 <20200305140142.413220-3-arilou@gmail.com>
 <874kv1ec7f.fsf@vitty.brq.redhat.com>
In-Reply-To: <874kv1ec7f.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-06T15:45:12.4096987Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=02355911-1348-4391-aa5d-f6fa722cde7c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c13cf63f-12a1-402a-cca5-08d7c1e55ca5
x-ms-traffictypediagnostic: MW2PR2101MB0938:|MW2PR2101MB0938:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB0938C48D2CCCBF0FC58CD3A6D7E30@MW2PR2101MB0938.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0334223192
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(199004)(189003)(52536014)(8990500004)(5660300002)(8936002)(76116006)(54906003)(66446008)(64756008)(66556008)(66476007)(66946007)(71200400001)(9686003)(81166006)(316002)(8676002)(55016002)(26005)(81156014)(186003)(110136005)(4326008)(86362001)(33656002)(478600001)(2906002)(6506007)(7696005)(10290500003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0938;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t0co//gB43CbBI9E5TbiQaxi6XQXMtjNdste7R3T9dG0PmOgw0qiHZPN/dY3u7jTTPGiMhJNRGwEdQOiEP6vQqKCK8PsHzmU5fPThTREz3sM9ZxMDWB1qVZoBMlsJq5wIAdoFlh9tFhIZ+qnOnLTx8Ya+ASMeSkxXC1yiWOGTaX1ntYAiIP9P0Nf7k0wcOt3UMmHq9PvgLu2Tmi55jXcDpTy+SQLMx8MmdW2cwIlNju4Bp7Q+eVZVDuAMMZTHd8wMZhADNVgaRQBJS2EskG2oxS2Ywds1fbR7F5kmXQ+VO352mzlekab9bxrEHGYJRmdxBf735f+E7wkS6cJLsnBiDJKdPiG9b77OfUj2E/1YyZrNO2tb7kKVwkoayLDA+3wvdDa1NtYouVtXBDRWW+KbCju+C3/5fEP+hUX4FhAh+m6gkCoc24Vv3bFyTI83NVr
x-ms-exchange-antispam-messagedata: 0NWmx/AsIjX4gkHVFltIibJuvRj0FMD5R+AYNyhbp8kn4QHlMG7RWn57Jt605nbVoRo8rlHYXTZblkxyKKEeubnQ0ahE5Yq/31sLzK3cDn2WzXgkNwLYQpyCwBMTpJntqDOXH1S+7xRPmsKwhMDQ1A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c13cf63f-12a1-402a-cca5-08d7c1e55ca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2020 15:45:14.0756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4e0rTrB7pRXHwgTXeA20WrUK+EJWMY0tetuTJbAdN9t+Qj8cXJ5rhIzd/bDFrnVY0KcBcuL2oTw52BWfSHYWZviEBoAYI15lwqWYX6gBvR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0938
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>  Sent: Friday, March 6, 2020 7=
:27 AM
>=20
> Jon Doron <arilou@gmail.com> writes:
>=20
> > Add support for Hyper-V synthetic debugger (syndbg) interface.
> > The syndbg interface is using MSRs to emulate a way to send/recv packet=
s
> > data.
> >
> > The debug transport dll (kdvm/kdnet) will identify if Hyper-V is enable=
d
> > and if it supports the synthetic debugger interface it will attempt to
> > use it, instead of trying to initialize a network adapter.
> >
>=20
> I would suggest you split TLFS changes into it's own patch so Hyper-V
> folks can ACK (or they can ack the whole patch with KVM changes of
> course :-)

I have contacted the Hyper-V team for clarification of the status
of the synthetic debugging feature and the associated CPUID leaves and
MSRs.  The first statement I got is that these are "deprecated", but I'm
trying to get more specifics about exactly what that means, if they
are going to be removed in a future release.

Michael

>=20
> > Signed-off-by: Jon Doron <arilou@gmail.com>
> > ---
> >  arch/x86/include/asm/hyperv-tlfs.h |  16 ++++
> >  arch/x86/include/asm/kvm_host.h    |  13 ++++
> >  arch/x86/kvm/hyperv.c              | 114 ++++++++++++++++++++++++++++-
> >  arch/x86/kvm/hyperv.h              |   5 ++
> >  arch/x86/kvm/trace.h               |  25 +++++++
> >  arch/x86/kvm/x86.c                 |   9 +++
> >  include/uapi/linux/kvm.h           |  10 +++
> >  7 files changed, 191 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/=
hyperv-tlfs.h
> > index 92abc1e42bfc..8efdf974c23f 100644
> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > @@ -33,6 +33,9 @@
> >  #define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
> >  #define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
> >  #define HYPERV_CPUID_NESTED_FEATURES		0x4000000A
> > +#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
> > +#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
> > +#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
> >
> >  #define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
> >  #define HYPERV_CPUID_MIN			0x40000005
> > @@ -131,6 +134,8 @@
> >  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
> >  /* Crash MSR available */
> >  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
> > +/* Support for debug MSRs available */
> > +#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
> >  /* stimer Direct Mode is available */
> >  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
> >
> > @@ -194,6 +199,9 @@
> >  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
> >  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
> >
> > +/* Hyper-V synthetic debugger platform capabilities */
> > +#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
> > +
>=20
> hyperv-tlfs.h is not perfectly structured but still there is some
> structure there,
> e.g. HV_X64_NESTED_GUEST_MAPPING_FLUSH/HV_X64_NESTED_MSR_BITMAP/... are
> said to be HYPERV_CPUID_ENLIGHTMENT_INFO.EAX
> bits (see above HV_X64_AS_SWITCH_RECOMMENDED).
>=20
> To make it clear that HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING doesn't
> belong to these bits I'd suggest you add a comment like
>=20
> /*
>  * Hyper-V synthetic debugger platform capabilities.
>  * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
>  *
> */
>=20
> to make it clear.
>=20
> >  /* Hyper-V specific model specific registers (MSRs) */
> >
> >  /* MSR used to identify the guest OS. */
> > @@ -267,6 +275,14 @@
> >  /* Hyper-V guest idle MSR */
> >  #define HV_X64_MSR_GUEST_IDLE			0x400000F0
> >
> > +/* Hyper-V Synthetic debug options MSR */
> > +#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
> > +#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
> > +#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
> > +#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
> > +#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
> > +#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
> > +
> >  /* Hyper-V guest crash notification MSR's */
> >  #define HV_X64_MSR_CRASH_P0			0x40000100
> >  #define HV_X64_MSR_CRASH_P1			0x40000101

