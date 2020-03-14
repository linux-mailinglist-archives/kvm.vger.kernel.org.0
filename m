Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB341856E3
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 02:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCOBa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 21:30:29 -0400
Received: from mail-eopbgr700109.outbound.protection.outlook.com ([40.107.70.109]:3776
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727206AbgCOBa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 21:30:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eyh/rK7PqGfs1GTT04/xd7CFSGR+ZJ/BkoVZEd4feozNJzglKT6uzzFmfJRj2olemprZoOKIUOo/1t92WKvGsd0uKaUf/VuRQd5jVZ8sb4mCZtnM9xAFGhQz1Y3LB/2FKKpgX3KjK/SKOEDKOusAAxG/BT6xWPU3aUAMJNiSKvrYe0dFLwJZvQ9IkRzUxJxuRzJ4lg2OAL6gRtm5+cXEfq4H+V8D0KhRivTin277Vtiei2Zh1e1YfNoqr9mOjNPFNKUCax32T2zAE3xJyjJQol6lvMDMXBnyBQwR6UUE1qzoFNmWBU6hTr48FcB4GuE6fhqoiTR0G/LcZCVJM753GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDNDhKNMMl/elMotPjXPxRshnKot+EpSDmiev/+jHog=;
 b=HOJZbX3907AqC9R1b62n49kZHJUwE87PEr/K+rHiumiC7WJafbhn8hqLx2RrbeS+FTxMDsYdO3a+Gt0G+bcPM87EldvJvYHbLgVUJ7CHooBnWOjgIyIpqdhW9x6X+moZvgybP9izOOf5eS8ZGS4cUR/McGKf0IzScNCNuefqIQU6CvAZ2paMe2crgtRu4NuKkALvJDfkA7Gy8yT91hdL6y2mL8NFhl105ozIpPVOvF7BfvNUXOFYKBZkuN0XcYX1ud9/4AsLQVnmhxNNAlO0vRn37/9rhfKEF3xK+x/JcozKuIVgvcGZjQda+lyf8HIYQ8tQoGUHcp2+ValmLpR1Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDNDhKNMMl/elMotPjXPxRshnKot+EpSDmiev/+jHog=;
 b=J8ENPY1Rs+j+ZWIW99eJY9tydJ6GUYiq4o3TpgTOzrerv2Xuagpk9Kw8nMM/jHUEKRoKgP4QuM4N2U0qkRWM3D0qarNGh4DaPyQGfEcncQDT9LkIoe6Wg8PvOCfnUKvsvpLKH2bQqlAUSlumYm464oKqs48ymCaiFveQE+Blhko=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0987.namprd21.prod.outlook.com (2603:10b6:302:4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.2; Sat, 14 Mar
 2020 14:14:41 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%9]) with mapi id 15.20.2835.003; Sat, 14 Mar 2020
 14:14:41 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Jon Doron <arilou@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH v5 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Topic: [PATCH v5 2/5] x86/hyper-v: Add synthetic debugger definitions
Thread-Index: AQHV+To/OcoVcvMEKUyFhrb80x2BNahG+0vAgACI2ICAAJ2b0A==
Date:   Sat, 14 Mar 2020 14:14:41 +0000
Message-ID: <MW2PR2101MB105281002BEE02E23A43D517D7FB0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200313132034.132315-1-arilou@gmail.com>
 <20200313132034.132315-3-arilou@gmail.com>
 <MW2PR2101MB10521050158699C7C96613F5D7FA0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200314044451.GA15879@jondnuc>
In-Reply-To: <20200314044451.GA15879@jondnuc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-14T14:14:39.3506328Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cbf0e3a3-3ab2-42b4-b7d6-f4742b40c351;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 99c06d0e-9967-43e0-fee2-08d7c82209b0
x-ms-traffictypediagnostic: MW2PR2101MB0987:|MW2PR2101MB0987:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB098715E975D133394FE87B8CD7FB0@MW2PR2101MB0987.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(199004)(478600001)(10290500003)(66946007)(81166006)(55016002)(7696005)(76116006)(71200400001)(8990500004)(5660300002)(66556008)(66446008)(9686003)(8676002)(64756008)(33656002)(6916009)(8936002)(186003)(66476007)(81156014)(6506007)(4326008)(316002)(26005)(54906003)(52536014)(86362001)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0987;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ViMIIhg3MWmj2P8Lk4fxq0LoUlDOtJ5ce/X/pVJY9TfuCltUTGGTk3HZ15BPsCLtKSTp2+UiuAmqcMLGVR+51eqOkg/fiv//JJHrf86sfChpSI3+VLCGzmz8uc1OXpezGIuU8Q2/aJGiXK/AGP1osFiZAXcp4JPF5JIFIhZx9QYqjnZq7YXEryvvLkuTHs2BfoyuC2fkT3N674v92w0O53kYBy4yk/GdXQerLpkEWBVyjNpHTsk44BRdXBC1Nc3xR7kSvVTw4r5FB1r3KLgqmJxtfVEEzuV1d5p70rW+kkk5+WlradmUMDuJ7Si56cmxuMTbwcirz9t59m+XbOM8KFNklJCwWcsRLATLgJ1dCCAAv6g5baaRQUh3ihOcBB8Kqeh/A7P/vrKCY36hBzBPiu2R1a9l12qmBmXo8YnMy57w6GM9pB/ckGHqJg4aMDEb
x-ms-exchange-antispam-messagedata: MMQiIax0Xd1Z5KelQB/BmUSvX3xhoEULSJbsaHy5ELODGh6V9HfeUBRLy+YfahzJ/5tYpf51g3SIl5WfP/aWVD9cmiXbBuRwYggz7IgLAYaUoYWGhe+hoOjSiiGjZchDpk+zWUJFnbCeM8WRvWUxOQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c06d0e-9967-43e0-fee2-08d7c82209b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2020 14:14:41.1693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uqJvnW02fUI2zqKVdLRd4F56aWd0jEkPJf1UybtscZtITmu3KM5zK4bP3GuY5Nod4/PMLl7sCEyyE2ZvZ5EtleDzTSZTkgnOfuJ1MMcDuCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0987
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jon Doron <arilou@gmail.com>  Sent: Friday, March 13, 2020 9:45 PM
>=20
> On 13/03/2020, Michael Kelley wrote:
> >From: Jon Doron <arilou@gmail.com> Sent: Friday, March 13, 2020 6:21 AM
> >>
> >> Hyper-V synthetic debugger has two modes, one that uses MSRs and
> >> the other that use Hypercalls.
> >>
> >> Add all the required definitions to both types of synthetic debugger
> >> interface.
> >>
> >> Some of the required new CPUIDs and MSRs are not documented in the TLF=
S
> >> so they are in hyperv.h instead.
> >>
> >> Signed-off-by: Jon Doron <arilou@gmail.com>
> >> ---
> >>  arch/x86/include/asm/hyperv-tlfs.h |  6 ++++++
> >>  arch/x86/kvm/hyperv.h              | 22 ++++++++++++++++++++++
> >>  2 files changed, 28 insertions(+)
> >>
> >> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm=
/hyperv-tlfs.h
> >> index 92abc1e42bfc..671ce2a39d4b 100644
> >> --- a/arch/x86/include/asm/hyperv-tlfs.h
> >> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> >> @@ -131,6 +131,8 @@
> >>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
> >>  /* Crash MSR available */
> >>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
> >> +/* Support for debug MSRs available */
> >> +#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
> >>  /* stimer Direct Mode is available */
> >>  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
> >>
> >> @@ -376,6 +378,9 @@ struct hv_tsc_emulation_status {
> >>  #define HVCALL_SEND_IPI_EX			0x0015
> >>  #define HVCALL_POST_MESSAGE			0x005c
> >>  #define HVCALL_SIGNAL_EVENT			0x005d
> >> +#define HVCALL_POST_DEBUG_DATA			0x0069
> >> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
> >> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
> >>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
> >>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
> >>
> >> @@ -419,6 +424,7 @@ enum HV_GENERIC_SET_FORMAT {
> >>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
> >>  #define HV_STATUS_INVALID_ALIGNMENT		4
> >>  #define HV_STATUS_INVALID_PARAMETER		5
> >> +#define HV_STATUS_OPERATION_DENIED		8
> >>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
> >>  #define HV_STATUS_INVALID_PORT_ID		17
> >>  #define HV_STATUS_INVALID_CONNECTION_ID		18
> >> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> >> index 757cb578101c..56bc3416b62f 100644
> >> --- a/arch/x86/kvm/hyperv.h
> >> +++ b/arch/x86/kvm/hyperv.h
> >> @@ -23,6 +23,28 @@
> >>
> >>  #include <linux/kvm_host.h>
> >>
> >> +/* These defines are required by KDNet and they are not part of Hyper=
-V TLFS */
> >
> >I'm looking for a bit more info in the comment so that it's clear that t=
he
> >synthetic debugger functionality is not committed to be available going
> >forward. Perhaps something along the lines of:
> >
> >/* The #defines related to the synthetic debugger are required by KDNet,=
 but
> > * they are not documented in the Hyper-V TLFS because the synthetic deb=
ugger
> > * functionality has been deprecated and is subject to removal in future=
 versions
> > * of Windows.
> > */
> >
> >But with that additional comment text,
> >
> >Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> >
>=20
> Sure thing, but one quick question I have noticed that in the 6.0 TLFS
> the bit indicating the DEBUG_MSRS are available is still documented is
> that intentional or a juss a miss?

From the side conversation I had with the Hyper-V people, I think
this is just a miss.  They took out the MSR definitions, but forgot to
take out the flag indicating the presence of the MSRs.  As I think I
mentioned in an earlier email, there will be future updates to the
TLFS, and I've put this topic on my list of things to make sure get
cleaned up.

Michael

>=20
> Cheers,
> -- Jon.
>=20
> >> +#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
> >> +#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
> >> +#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
> >> +
> >> +/*
> >> + * Hyper-V synthetic debugger platform capabilities
> >> + * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
> >> + */
> >> +#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
> >> +
> >> +/* Hyper-V Synthetic debug options MSR */
> >> +#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
> >> +#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
> >> +#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
> >> +#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
> >> +#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
> >> +#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
> >> +
> >> +/* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
> >> +#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
> >> +
> >>  static inline struct kvm_vcpu_hv *vcpu_to_hv_vcpu(struct kvm_vcpu *vc=
pu)
> >>  {
> >>  	return &vcpu->arch.hyperv;
> >> --
> >> 2.24.1
> >
