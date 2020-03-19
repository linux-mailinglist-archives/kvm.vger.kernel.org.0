Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7FD18C1A6
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 21:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgCSUtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 16:49:07 -0400
Received: from mail-mw2nam12on2121.outbound.protection.outlook.com ([40.107.244.121]:61248
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbgCSUtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 16:49:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvoOcu/wafDKG6MhBhKNS6F16xzRHySL3d+lMhuogq+d0mvkuCkE8Xc7/oTux/D4PTk7A+fQxmFE5+1euqEeInOy1Ou1Y77SzAlFajGMe1J+YC7K1NR4vPydoZvposKJXPiY9ay1x5sdlNczRrh8Z66Ii2qW/gF8nqgoIuP5OsT0BtoY25Re/8ilXqjN1DLH1dDjAVf1XZAO1nh7yFjnsgi+HzmuBIF4pAf1oaEOwjbdxcEVZ+3Qfee1tqxQjDnpBGube1ATlYrJxOcv+uvLhsAml7BYxawqQQinlpMqbDSCcULp6TqF13jvsKW2dbA0rbgjaYwXM2Mm5PIIA/efWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F61YRBI6iznorIltp5qZLGSCwUgJUJPBJmsjVcsv+M0=;
 b=bodeVZ5KvXD08TyJCTrPGFNFqhtb+pL0HlFyQsh5XYDw9wAcH0/1CgqP915ojph0KlbWUfAHnXa/xeEwe1CMi6/T3ZjoOr/nMv9vzzT9eV/bDC1Npnn0Z834Neg9lGA/S9HyX6OoWlINcspP0yRVI/GxMqVYeCTOaiTMwWH/JlbrvJ3DmMxozmCYBOEZPeVtt53Syd2SAvxW0CNOzzHOeDviqTADVsubSv6XdY792jc36OtmCG8ErIRiJTFN8z41QZBtgPdMvzjC2YZy0kpU0AO1GOF3DuSdbm6hTKZ8GrRQEQXib0rDWQOqlW6Do8JFhn4t8hz1r3g131kpXr0dog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F61YRBI6iznorIltp5qZLGSCwUgJUJPBJmsjVcsv+M0=;
 b=N5JRqq3ayWJHv2O8ywdN1703ix/rr0EnXExiS4OeRyD27iau4aaf9UF8bsdTZmXHbrt+rPyvsZfdhNeteabeneq3g+SSO7g5KEjYeItOYb3gR1EUK+tZvmkIE9f6G/MHBh7/boNiyVkSCzDp5Ddm1xp0U9977jLJJuwv8jPIZD4=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1114.namprd21.prod.outlook.com (2603:10b6:302:a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.1; Thu, 19 Mar
 2020 20:49:01 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%10]) with mapi id 15.20.2856.003; Thu, 19 Mar 2020
 20:49:01 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Jon Doron <arilou@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH v8 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Topic: [PATCH v8 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Index: AQHV/bkRMMUyPxTkAEeuFf0GP1+Y4ahQY+qw
Date:   Thu, 19 Mar 2020 20:49:01 +0000
Message-ID: <MW2PR2101MB10524691B2FC06269E67E8FCD7F40@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200319063836.678562-1-arilou@gmail.com>
 <20200319063836.678562-3-arilou@gmail.com>
In-Reply-To: <20200319063836.678562-3-arilou@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-19T20:48:59.1055636Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f47dd57c-1b5e-485c-96da-8c6d1d26f1ae;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8df82f72-df39-42f7-2475-08d7cc46f45d
x-ms-traffictypediagnostic: MW2PR2101MB1114:|MW2PR2101MB1114:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB1114D0013DD1365A834BB877D7F40@MW2PR2101MB1114.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0347410860
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(76116006)(52536014)(10290500003)(110136005)(86362001)(66946007)(316002)(478600001)(81156014)(81166006)(8676002)(8936002)(26005)(71200400001)(55016002)(7696005)(8990500004)(186003)(4326008)(33656002)(2906002)(6506007)(5660300002)(9686003)(66556008)(66476007)(64756008)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1114;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /QPsjQR9yzIEfmv6jL66BO/Nd3fTyRpLYOPs0iTgHKa9d4K9DmH+6hawzhHK8NjCdBXcf6+ollEjeQqtpjfJ2YNE6q41NY7Ow37YnEBtK+Vh0MEdIEeEaAgvuiePB5X0hUPF1Et7CPn3cxkZG+bs9TnzQBatHmknLWNaIUy/ZMLte4wVePofGLXBv95truEeoxYx9obVIWvDiFo9MWhGVpp6MBHXLfkJESTXC79WirbtZAR35BDKirtTmpPYrxGgL4NNT9WuMRKg7dGXhN8rhdrFS8CbSsbNnxHj/0ung4FCh5kGQJF/9AN9xoXrLcbjZ1IjUW1IJUvtE1n/LoURn//CZqnDLoilIqQZ+5vGbtqya63e1hgLyWFNmKiq9uIvvNF/duwaMurO1wWs/gws1Fb2/ZorakIplixJkVP8qEixUy1LmXidYQl8Cp1gnQKg
x-ms-exchange-antispam-messagedata: zxU13xnl8zc4DdTLbzwwIVMpMPzsfVSrH+aJc5nw11ZN+sbE1jrIL6i6KXXWf/GodMTtNIjSUaeyGpiKKDTXOqSuqsL8uVqR6ifhJQZwYcydVeM70lS8sk86nrDpFP+ld3vGehDO8KXz4VybnO+wIA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df82f72-df39-42f7-2475-08d7cc46f45d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2020 20:49:01.3767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KhiI4eu140F/QBPhbu3fU+nvHQBrbiNL0JO0uEFR+oi+bMBKAo2iRb8Q5E/D2X+//OD6DUSFnBsWPi+N7ZDFTZYILcgHf0okwTm7v2WNzEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jon Doron <arilou@gmail.com> Sent: Wednesday, March 18, 2020 11:39 PM
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
> The reason they are not documented is because they are subjected to be
> removed in future versions of Windows.
>=20
> Signed-off-by: Jon Doron <arilou@gmail.com>

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

> ---
>  arch/x86/include/asm/hyperv-tlfs.h |  6 ++++++
>  arch/x86/kvm/hyperv.h              | 27 +++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
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
> index 757cb578101c..5e4780bf6dd7 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -23,6 +23,33 @@
>=20
>  #include <linux/kvm_host.h>
>=20
> +/*
> + * The #defines related to the synthetic debugger are required by KDNet,=
 but
> + * they are not documented in the Hyper-V TLFS because the synthetic deb=
ugger
> + * functionality has been deprecated and is subject to removal in future=
 versions
> + * of Windows.
> + */
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

