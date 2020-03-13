Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60BA185081
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 21:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgCMUpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 16:45:38 -0400
Received: from mail-dm6nam12on2138.outbound.protection.outlook.com ([40.107.243.138]:24032
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbgCMUpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 16:45:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2GKrnbM/WQ+VswbUAFbcnkokS/iqVwTabzgFipn3nljjO7k72dohtrJbVW+atlbza2GUeXnttQZqKtkkEjilnA+vFbocWQ598p+EujqqCYnNtj/2znrQpkAGqzDaSv2qp786hjX3Y4je1tSvidjxzcw5LRoS6Mqm73n2QTdUfrnBRnCoVepkKg/crSZ7t1tcmorILdUld7WZjElCZSfvrmmysULgnCytwgBQQPzhN/sBiC6V6gm2rixwpxLcmxZg1jpkObMbxu9jYaWH9qKpZfKSKd/0BYoWGu4JoZjKxzmmU9vjywcPDuivDtNVIMLTFvf59Y4GftTl4yRwihh9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJ8Ou8EVo10cAXh45cYsLi97qSnoibJumf8RHDf6MKc=;
 b=RF692NTE8TbWfYZw1HWtLStQPzZd0F4n2yDUHHdcGPTtid5gDHnyPrFdFPIduj1tZ08Wh0pqkJ3jM3lBgClKGeLZdjWDU9w59+/hwAbTdhbZwbs5NWgtYeZGK8sqXyP/1Xvx4kRROYyfBZ5mIfI0JGPDHBshD6HDFJNXnIrj7vsJai7jU2S3pdOOJeCvNcOLofk4Fbt7P9BN8TO0VV2Fm8Lf5doFauOBMPeo9oHwNGcgGHcEP8Ua2qP/57xRnEaq17R8EuJthgcdkXso9N16mFHFlszoAopVcbl+Wo9yzdEL2Ev1NWBDSOxAR1UqfIuGWwnjHkHgwxQDHtgeOuXJ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJ8Ou8EVo10cAXh45cYsLi97qSnoibJumf8RHDf6MKc=;
 b=bLynF+TAvtpMcVRUFNfN1CoueTEcez3Z9abvIUqaEhulwOBL6RByx9o6La4ocvkXvZmB1Kq8xedLxSNzVILHDLD063djkVI/jMwDq0C5nrnjVUDB7YfIjg0nAfO/95vCga2jGHznPkjO1IW5ONdVOpAk60yFE47M5UTqpucfAHs=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1113.namprd21.prod.outlook.com (2603:10b6:302:a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.11; Fri, 13 Mar
 2020 20:45:34 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%9]) with mapi id 15.20.2835.003; Fri, 13 Mar 2020
 20:45:34 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Jon Doron <arilou@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH v5 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Topic: [PATCH v5 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Index: AQHV+To/OcoVcvMEKUyFhrb80x2BNahG+0vA
Date:   Fri, 13 Mar 2020 20:45:34 +0000
Message-ID: <MW2PR2101MB10521050158699C7C96613F5D7FA0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200313132034.132315-1-arilou@gmail.com>
 <20200313132034.132315-3-arilou@gmail.com>
In-Reply-To: <20200313132034.132315-3-arilou@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-13T20:45:31.6939368Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c0f0fb4a-eb2c-4dbf-bd0e-24fe2627bedd;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a0596ac4-fa2b-43be-d1f3-08d7c78f7a91
x-ms-traffictypediagnostic: MW2PR2101MB1113:|MW2PR2101MB1113:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB1113024D203367AF3DD26423D7FA0@MW2PR2101MB1113.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(199004)(71200400001)(6506007)(7696005)(26005)(186003)(86362001)(5660300002)(10290500003)(110136005)(52536014)(76116006)(316002)(8990500004)(66556008)(66946007)(64756008)(66476007)(478600001)(55016002)(9686003)(8936002)(4326008)(8676002)(2906002)(33656002)(81166006)(81156014)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1113;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZKUvlO4iV8wp3VefLd+kbcqmA8k0xPan7K096yZU2g9qBgOOuPDaDQIdIOSbATtno+cZHBqSH0F8AS1gJARiPJ4ppF6ng/1D1llvBkGX7JMyG4FR2ocLDmjHDJiHaEp+qmNS4jGwUTFYdtbCXhMn4645Ene7VCuNud3Xbvfo2Y7kaAo2s34Q2QlqdG7YD46+lBwIL9ezzXyHuHrXk8xEBIdp6zBpavlmCNBzWTCbcUywy/E+ocpC5YeJYlOJXhzj3Rv1ccJRH/mHgsUoHSwiHNhkcTPh7TCrmwQASKKeaOwHXdeBioWcqHqq+JJNuTs8pfdzV66Ee/GBwEp1nebQPM4VjE0r4OOyXUmRmSXlKGdNfvdMAkIve3Y0hEx1gw2MOYHxkgMFRgGsNVeadFaQOljnuwMz7rZNE2FBGKkMFXruRG/7X/MPj5bkgpDxFUf/
x-ms-exchange-antispam-messagedata: Xc9xjGbsxeD4BDkC6qTq2aQvnr4y0S+ctePbZppHSynmEKdqRa1swljGlOPSN/uy3XDFtmXdP8GjUu8fbR9LxG7wQjBvae9EuTx2BmBx4gdk8Ze2cNPo3eH5XDWJZSqe9lNQ0/ekFPGPRUCplOgnoA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0596ac4-fa2b-43be-d1f3-08d7c78f7a91
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2020 20:45:34.5332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oIO/cYQAJ1NZ5PXuDDP8yJYo9Jn1NPRzf00vuSDM81erqbRpT/WeVccGzriUUZ9ZKagHvuJGiUO5y08Pptw/4MpwaF2H+WGPfTNhvDfUd/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jon Doron <arilou@gmail.com> Sent: Friday, March 13, 2020 6:21 AM
>=20
> Hyper-V synthetic debugger has two modes, one that uses MSRs and
> the other that use Hypercalls.
>=20
> Add all the required definitions to both types of synthetic debugger
> interface.
>=20
> Some of the required new CPUIDs and MSRs are not documented in the TLFS
> so they are in hyperv.h instead.
>=20
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h |  6 ++++++
>  arch/x86/kvm/hyperv.h              | 22 ++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 92abc1e42bfc..671ce2a39d4b 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -131,6 +131,8 @@
>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
>  /* Crash MSR available */
>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
> +/* Support for debug MSRs available */
> +#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
>  /* stimer Direct Mode is available */
>  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
>=20
> @@ -376,6 +378,9 @@ struct hv_tsc_emulation_status {
>  #define HVCALL_SEND_IPI_EX			0x0015
>  #define HVCALL_POST_MESSAGE			0x005c
>  #define HVCALL_SIGNAL_EVENT			0x005d
> +#define HVCALL_POST_DEBUG_DATA			0x0069
> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>=20
> @@ -419,6 +424,7 @@ enum HV_GENERIC_SET_FORMAT {
>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>  #define HV_STATUS_INVALID_ALIGNMENT		4
>  #define HV_STATUS_INVALID_PARAMETER		5
> +#define HV_STATUS_OPERATION_DENIED		8
>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
>  #define HV_STATUS_INVALID_PORT_ID		17
>  #define HV_STATUS_INVALID_CONNECTION_ID		18
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 757cb578101c..56bc3416b62f 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -23,6 +23,28 @@
>=20
>  #include <linux/kvm_host.h>
>=20
> +/* These defines are required by KDNet and they are not part of Hyper-V =
TLFS */

I'm looking for a bit more info in the comment so that it's clear that the
synthetic debugger functionality is not committed to be available going
forward. Perhaps something along the lines of:

/* The #defines related to the synthetic debugger are required by KDNet, bu=
t
 * they are not documented in the Hyper-V TLFS because the synthetic debugg=
er
 * functionality has been deprecated and is subject to removal in future ve=
rsions
 * of Windows.
 */

But with that additional comment text,

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

> +#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
> +#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
> +#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
> +
> +/*
> + * Hyper-V synthetic debugger platform capabilities
> + * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
> + */
> +#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
> +
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
>  static inline struct kvm_vcpu_hv *vcpu_to_hv_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	return &vcpu->arch.hyperv;
> --
> 2.24.1

