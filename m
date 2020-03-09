Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA717EAAF
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 22:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgCIVCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 17:02:01 -0400
Received: from mail-bn8nam12on2096.outbound.protection.outlook.com ([40.107.237.96]:42529
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbgCIVCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 17:02:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPph1fw4D5RPjKP11Q/lC4invJoP69FjFn3fgHN3NCb4NRzpE+bOWOHeJiuhgzRM2fgaHJ9aLlzbm9XD7cDDStOKm0PRCrRAvn4CC8upIS9iv6BNVYeq+0c6XONt9wVSrtBNuS3bJFMMiWfkXjI7+BR82OWGKPihsDTYelS9kjGm17e/tGrwsCtOOVaLKtx1ib5gBpTBIZ7b7liQJwSL3yxhYR6p19hbX2JesHP1G24StohQtoGO3D/i4cPOpsr5W/XSygpnyFySRAhW0cpjLQplpZzkMkisgsyNyHX5/OO2+G/L1dSC4fQsjTiyO6Jm80WyH82rI/3kAh7gmETv9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1+XGjzU/yWbgsvIut3YoxCNyKQAISz6+V7AlxRfpJQ=;
 b=h1FoZ4ab72ZEsXu6He9gt6wIhXZhNeSMYypBETKyNTAiVuTGWlbUmuFOYO6uHsPKuIj9fhHwW451063gav2rTlUtr63S6FK7snJc/Fws6sjPGNT5VyU1ZIwIO6fjB9VpQUKoXXdh62Ei9/MjGLaLw/I7JrtHd7nEN2KBWI6Ld4OZIbwoKmZ5ZvSLK7e/8DenkxFzmMXFaLUhSa2GaTNdsdHNMNwVfEi1KQFwFfyCDW0tr4B90SGLvGnVYkGof6FyztxLe1jbI86F+8nNYrD9SGPI1LvPLVxLykwFt3VoX7/SMCB0vmaQC/bW31vLsaRSWZ5NsFxHmeKur3nRRh0xwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1+XGjzU/yWbgsvIut3YoxCNyKQAISz6+V7AlxRfpJQ=;
 b=IDZ4wb0HINIj0SZ3GHAyXiul8aRDSkvIm4sQSUdD0KgJhU7qAn381kujsBvMbBX+MtL2/gETr4RWFR0gjL2PM8k6lIWC37P/J+cBkg1QKhwxcGtHOUPpQIjMgRl62F/UjtntmYWIww9hPPkx7nrTZOQqWPj8eaqPh2nZv9XHgoI=
Received: from DM5PR2101MB1047.namprd21.prod.outlook.com (2603:10b6:4:9e::16)
 by DM5PR2101MB1095.namprd21.prod.outlook.com (2603:10b6:4:a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.0; Mon, 9 Mar
 2020 21:00:22 +0000
Received: from DM5PR2101MB1047.namprd21.prod.outlook.com
 ([fe80::1cf9:aae4:18cc:8b3d]) by DM5PR2101MB1047.namprd21.prod.outlook.com
 ([fe80::1cf9:aae4:18cc:8b3d%7]) with mapi id 15.20.2835.003; Mon, 9 Mar 2020
 21:00:22 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Jon Doron <arilou@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Topic: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Index: AQHV9j9ukyAJ0hjklE6HBDoXElbMoqhAvCqQ
Date:   Mon, 9 Mar 2020 21:00:22 +0000
Message-ID: <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
References: <20200309182017.3559534-1-arilou@gmail.com>
 <20200309182017.3559534-3-arilou@gmail.com>
In-Reply-To: <20200309182017.3559534-3-arilou@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-09T21:00:20.4152392Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=72330bda-0cd5-47b6-8fad-70f216e647e2;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e06f9d59-d973-4485-ccc2-08d7c46ce20c
x-ms-traffictypediagnostic: DM5PR2101MB1095:|DM5PR2101MB1095:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR2101MB109502685F0ABFB9FF441DC1D7FE0@DM5PR2101MB1095.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(189003)(199004)(10290500003)(26005)(5660300002)(4326008)(66556008)(64756008)(66476007)(66946007)(66446008)(86362001)(55016002)(9686003)(81166006)(81156014)(71200400001)(8676002)(186003)(8936002)(52536014)(76116006)(6506007)(2906002)(110136005)(316002)(478600001)(33656002)(7696005)(8990500004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1095;H:DM5PR2101MB1047.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LlHdf/w/7TJ+qnqVK17q5ZJx+M0AQ9jQtrsCoxSYGwa3UZMFareiGjqwmsUiLD9JZ5wzhMnZFkfKvW/fpJ1mbKMrWxzF2DxIbfl5FJlGh066NcPNaqh70v0ddl0d843Bxn/ERIzYkI6NncjuA1XszPicDRr1xYrcXaUe/LCLtxPrjAr/TKkuUqD0L8R3BLYVhor52yUUGuO71taB63Edrsrl8RKiOxd/20lK7dC+VX2mg+jOY/QdGCXN7FQbGRWzwDTMn6lL2etqfX4QVQdL0Ce3HBgdVoL1vulKLVuMQSHsaFWY9KG209ztZ7zbpkVD9qAGBvrVAj64fCOtm5C4ArqoutmrUwAWJ4J4d5Wxw9Sjd7ef9eATN9I0UjrIizcKsmfhKUexv8wEXPflKY/fjIBlCtk/cCNC76HZTkLN2L0BZXpsCZiT1WF61BqDXpwC
x-ms-exchange-antispam-messagedata: AmDlBFrX0xfpUPNTOk4wHnLSn4hiBf3Jm0IM/mAKna3Owye/Ou4T4D/OatjJHjr/E3s4buFkwiHxcaQzD1wE6HWqrWmvSmOEhzZSYF7GtkCu8H22Ro15FQ1Op0HZD8cMX07e4X7FGBmyWsq0ijoRGw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e06f9d59-d973-4485-ccc2-08d7c46ce20c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 21:00:22.2966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kXnZcMe7PsXIRFvsLU85Fbr6BfqHFlx+f52awP52IFZsw0JXWI2j65dFhhuZ1sqRnsRJtgqR6sTWgmF0WwttvoGKhNTgnpZWoELNDfuvoLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jon Doron <arilou@gmail.com> Sent: Monday, March 9, 2020 11:20 AM
>=20
> Hyper-V synthetic debugger has two modes, one that uses MSRs and
> the other that use Hypercalls.
>=20
> Add all the required definitions to both types of synthetic debugger
> interface.
>=20
> Signed-off-by: Jon Doron <arilou@gmail.com>

I got some additional details from the Hyper-V team about the Hyper-V
synthetic debugger functionality.  Starting with Windows 10 and Windows
Server 2016, KDNET is built-in to the Windows OS.  So when these and later
Windows versions are running as a guest on KVM, the synthetic debugger
support should not be needed.  It would only be needed for older Windows
versions (Windows 8.1, Windows Server 2012 R2, and earlier) that lack a
built-in KDNET.  Given the age of these Windows versions, I'm wondering
whether having KVM try to emulate Hyper-V's synthetic debugging support
is worthwhile.  While the synthetic debugger support is still present in
current Windows releases along with the built-in KDNET, it is a legacy feat=
ure
that is subject to being removed at any time in a future release.  Also, th=
e
debug hypercalls are only offered to the parent partition, so they are
undocumented in the TLFS and the interfaces are subject to change at any
time.

Given the situation, I would rather not have the MSR and CPUID leaf definit=
ions
added to hyperv-tlfs.h.  But maybe I'm misunderstanding what you are trying
to accomplish.  Is there a bigger picture of what the goals are for adding =
the
synthetic debugger support?

Michael

> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 92abc1e42bfc..12596da95a53 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -33,6 +33,9 @@
>  #define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
>  #define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
>  #define HYPERV_CPUID_NESTED_FEATURES		0x4000000A
> +#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
> +#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
> +#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
>=20
>  #define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
>  #define HYPERV_CPUID_MIN			0x40000005
> @@ -131,6 +134,8 @@
>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
>  /* Crash MSR available */
>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
> +/* Support for debug MSRs available */
> +#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
>  /* stimer Direct Mode is available */
>  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
>=20
> @@ -194,6 +199,12 @@
>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>=20
> +/*
> + * Hyper-V synthetic debugger platform capabilities
> + * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
> + */
> +#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
> +
>  /* Hyper-V specific model specific registers (MSRs) */
>=20
>  /* MSR used to identify the guest OS. */
> @@ -267,6 +278,17 @@
>  /* Hyper-V guest idle MSR */
>  #define HV_X64_MSR_GUEST_IDLE			0x400000F0
>=20
> +/* Hyper-V Synthetic debug options MSR */
> +#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
> +#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
> +#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
> +#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
> +#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
> +#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
> +
> +/* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
> +#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
> +
>  /* Hyper-V guest crash notification MSR's */
>  #define HV_X64_MSR_CRASH_P0			0x40000100
>  #define HV_X64_MSR_CRASH_P1			0x40000101
> @@ -376,6 +398,9 @@ struct hv_tsc_emulation_status {
>  #define HVCALL_SEND_IPI_EX			0x0015
>  #define HVCALL_POST_MESSAGE			0x005c
>  #define HVCALL_SIGNAL_EVENT			0x005d
> +#define HVCALL_POST_DEBUG_DATA			0x0069
> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>=20
> @@ -419,6 +444,7 @@ enum HV_GENERIC_SET_FORMAT {
>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>  #define HV_STATUS_INVALID_ALIGNMENT		4
>  #define HV_STATUS_INVALID_PARAMETER		5
> +#define HV_STATUS_OPERATION_DENIED		8
>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
>  #define HV_STATUS_INVALID_PORT_ID		17
>  #define HV_STATUS_INVALID_CONNECTION_ID		18
> --
> 2.24.1

