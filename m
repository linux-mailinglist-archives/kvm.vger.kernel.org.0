Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7651B2B96
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 17:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDUPuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 11:50:20 -0400
Received: from mail-eopbgr750124.outbound.protection.outlook.com ([40.107.75.124]:59527
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725613AbgDUPuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 11:50:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVactB9aZb+dWv/jZlZgFy5nGKJrkGd85/sF35aX3lvHMEP23VooIpzEF5//E1ScTAln6KVMKshjsQoEcftk+o/oksNha0WpMeLh+BQ1PdA+hMZgCN9awdkNOZxkP/RI0NI3Dl+IYDny0O7fsM6H3hQALXV4Ww/V3HKtPpnC7AOvo+CBMPo6h80mHLOcpE3aC3x+g5BPsezDaDwVZxobn8LHfZW5PcZKQop9+H7dbm/FYQHS01glYYJtK9c4ENWhVtgZkS21mLDOJBXfTPrWDAoNW9r9l71LV++AMFdB/iZ1vf2T1H6KOIJXZcBkP8LcIMNzdwxLQiN98K/l2OLisQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeD5JYaE2Q6wgoygoe/f0imLOAhpj/llq3cOJSrta4s=;
 b=cWsktVOhh4F/x9+5GnlQNoJzXDY8U9663IaGkz3RpE/7PWY0tQpXrZbCXMwP0nZNcViAnTa07vx525gdnY0VaBFql9e+g7tQft23mARjeq+QeGP+rF8nblWr8nM0FNwHZfjXm+oEQaSxHPfSzueo90owNiZlTgzHOIb5rrTGfPiSep9v02pDklc4GW8pltGcm2D4xYBIvDpBqqbjc1iePpgxLiNHdu/EbyiAwnbZObV6S+yUEPxnZ0Yw40Dqf7PXme9iqYbcLiETeayEuqgPQQl6+5Xzv2raqV1LKTw0kQDy5fiKpeESkNh2gE9AYZmCCcyhiJNQM2FgD53FJ3l2Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeD5JYaE2Q6wgoygoe/f0imLOAhpj/llq3cOJSrta4s=;
 b=KgK3aV938AW0sUzxkAd58L6LKLoJpUfUtFCz2yHIamZYYdZGllUObnKI2Opp4evrC814oh+l21uPL5VCM9zaPuLVzUgHDKuIoSRiS5Dib5YIki90JxAYU4hcuCreZ/Y5G1RX3FxlW7bduLcxF+e6Gi+ACzL43dtV8NXD/7Zhcvk=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0921.namprd21.prod.outlook.com (2603:10b6:302:10::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Tue, 21 Apr
 2020 15:50:12 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%8]) with mapi id 15.20.2958.001; Tue, 21 Apr 2020
 15:50:12 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH 4/4] asm-generic/hyperv: Add definitions for
 Get/SetVpRegister hypercalls
Thread-Topic: [PATCH 4/4] asm-generic/hyperv: Add definitions for
 Get/SetVpRegister hypercalls
Thread-Index: AQHWFzqo2MJXKNqRb0OpB2C/Ixhrm6iDi9EAgAAtKyA=
Date:   Tue, 21 Apr 2020 15:50:12 +0000
Message-ID: <MW2PR2101MB1052EF4972CDCF9BF2B0356AD7D50@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200420173838.24672-1-mikelley@microsoft.com>
 <20200420173838.24672-5-mikelley@microsoft.com>
 <87y2qpq9e7.fsf@vitty.brq.redhat.com>
In-Reply-To: <87y2qpq9e7.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-21T15:50:10.7293324Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=12920825-1c00-49d2-bb48-99a21bd11be8;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a880323d-b986-48c1-96d1-08d7e60bad88
x-ms-traffictypediagnostic: MW2PR2101MB0921:|MW2PR2101MB0921:|MW2PR2101MB0921:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB092142E8B38E5ED6528B8B0AD7D50@MW2PR2101MB0921.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(6029001)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(71200400001)(186003)(26005)(82960400001)(64756008)(66446008)(66476007)(52536014)(66556008)(66946007)(8676002)(5660300002)(6916009)(9686003)(55016002)(33656002)(81156014)(2906002)(76116006)(10290500003)(478600001)(54906003)(86362001)(316002)(7696005)(4326008)(8936002)(82950400001)(6506007)(7416002)(8990500004)(41533002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gmrcMAXF60ZJAdZv06F2GNG3RGYWYv0aqnipoMxCYe+p3I+vkoibNGNEHLT/P42vThFh0foKWftync3O8UNSmBbVRMmSzPHwvW8OTLceLsp+HpE/cgrzTIeqel8I6N31iQvEPRDQP/TIBCchvkMPVZK83DY76GHDybl3aOY2SPWyG1PR+QJAqWMrAiPJlRvy5g1JeawRxWee6cyR8I/2Tt6/+0i/7GrcHQXCAR0v0hPExIS5vxYoi9Fq8m9VzlGEEnN5DJ7HYHGkEuw7FfvpVcvlvdF1vbwsG4lOnfda4sSY8Ba7vQubiE0LjhDOho5bD5+BYp3fT78toYKBRz3YbWdjrMECH+dHKbLGHDZ1CDbl8mgJAOE5Ay33PRDAcYZc0jQv8VIPtJSBPnX7tH9qZ9/Rfk1T2mw2n4V1SWAlUkC7HzJ9Hvr3KEuhDMMIeLnWS9bOnrKZZJposBU90rZmX0U4kQpRXhJhTXjtQbc6JMH8MPyEgh48PFSAyCH5KDZ0
x-ms-exchange-antispam-messagedata: j+9EeiqeaRrcck86tnhQKtxxiXNTFyMsmk0PZEkr0k1i3wazMfXULWmZxIxMHWlWKWT9klI1kXQrfvf2K+UVW/DLdn6wbeGCn48Tjzy+hT00X4KEkuhGM60F7shrBHujHasjcPI3qWJ0e0iiaDOvoVjPEx8luDkDd368aG0jh9/z9koIYJfolziMLqlBOMmxDJa0izNlKMJ0pidVONRJ3S4XczPy7tNQCSP9Y/RRdXCcNfO1bfMlcL6aF1w24aFnQusX92tUYWqm1Fe91iPQ+hWjiipyJFr7ucGCbTcaHdsBib/1jyTopqNCHq/LaUkZ2mKYO1BE1FNQVs1FsdrKVtam4zgFYcIER5/6g4NPO7g9Iqru8E9Y1RCyWDor3WmFAZTFc92IhVV7vM+IQwK6egxMIFmdmFSu4ew/keuCkX27lxipPM04oOEP8pGzbYy397E96OLrC8Sz1I0hKXIOF032z8920qSJHNqMhnL85uw3vcUgHVFzs/XDAAwxU6LIrtQKXWIxgKijmM2QmGLpHfS0EpRYh3zmjR8iQb+92A76zQny7BPX5Fz/rlesllGimhPFEBj0za23UXvFS3bAiLLLwWdUFn2fjMJMBD/3XGd3yWIrfzWf97g2mOuM7TocVcLuMp0qosCqkiqC1hj3yLtluUQxKdIbajxhb87SqWZdIgi777TrkVUbWWaZnEis//6Jb2s8gTsISWBd7Q1NWrGMSdBvRijCdnSp16R/9NADgLG1ef7SQMb57ksNCRynJvERAABdxpZoE8OKq9YnahkUM5OKFgr0QjEVc+fkK4E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a880323d-b986-48c1-96d1-08d7e60bad88
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 15:50:12.5193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WefsAt77eN0gNjAPFU2MV9JJgrtuTdIExhO5g12n2ZCqvra3djkX/yLWu7zeuyaQgJ1i06KK02G4uuMw3gudX+OMxb+KtL/aIJxvrBMOUm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0921
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Tuesday, April 21, 2020 =
6:03 AM
>=20
> Michael Kelley <mikelley@microsoft.com> writes:
>=20
> > Add definitions for GetVpRegister and SetVpRegister hypercalls, which
> > are implemented for both x86 and ARM64.
> >
> > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > ---
> >  include/asm-generic/hyperv-tlfs.h | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> >
> > diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hy=
perv-tlfs.h
> > index 1f92ef92eb56..29b60f5b6323 100644
> > --- a/include/asm-generic/hyperv-tlfs.h
> > +++ b/include/asm-generic/hyperv-tlfs.h
> > @@ -141,6 +141,8 @@ struct ms_hyperv_tsc_page {
> >  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX	0x0013
> >  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX	0x0014
> >  #define HVCALL_SEND_IPI_EX			0x0015
> > +#define HVCALL_GET_VP_REGISTERS			0x0050
> > +#define HVCALL_SET_VP_REGISTERS			0x0051
> >  #define HVCALL_POST_MESSAGE			0x005c
> >  #define HVCALL_SIGNAL_EVENT			0x005d
> >  #define HVCALL_RETARGET_INTERRUPT		0x007e
> > @@ -439,4 +441,30 @@ struct hv_retarget_device_interrupt {
> >  	struct hv_device_interrupt_target int_target;
> >  } __packed __aligned(8);
> >
> > +
> > +/* HvGetVPRegister hypercall */
>=20
> Nit: 'HvGetVpRegisters' in TLFS
>=20
> > +struct hv_get_vp_register_input {
>=20
> Nit: I would also to name it 'hv_get_vp_registers_input' (plural, like
> the hypercall).
>=20
> > +	u64 partitionid;
> > +	u32 vpindex;
> > +	u8  inputvtl;
> > +	u8  padding[3];
> > +	u32 name0;
> > +	u32 name1;
> > +} __packed;
>=20
> Isn't it a REP hypercall where we can we can pass a list? In that case
> this should look like
>=20
> struct hv_get_vp_registers_input {
> 	struct {
> 		u64 partitionid;
> 		u32 vpindex;
> 		u8  inputvtl;
> 		u8  padding[3];
>         } header;
> 	struct {
> 		u32 name0;
> 		u32 name1;
>         } elem[];
> } __packed;
>=20
> > +
> > +struct hv_get_vp_register_output {
>=20
> Ditto.
>=20
> > +	union {
> > +		struct {
> > +			u32 a;
> > +			u32 b;
>  > +			u32 c;
> > +			u32 d;
> > +		} as32 __packed;
> > +		struct {
> > +			u64 low;
> > +			u64 high;
> > +		} as64 __packed;
> > +	};
> > +};
>=20
> I'm wondering why you define both
> HVCALL_GET_VP_REGISTERS/HVCALL_SET_VP_REGISTERS but only add 'struct
> hv_get_vp_register_input' and not 'struct hv_set_vp_register_input'.
>=20
> The later should look similar, AFAIU it is:
>=20
> struct hv_set_vp_registers_input {
> 	struct {
> 		u64 partitionid;
> 		u32 vpindex;
> 		u8  inputvtl;
> 		u8  padding[3];
>         } header;
> 	struct {
> 		u32 name;
> 		u32 padding1;
> 		u64 padding2; //not sure this is not a mistake in TLFS
>             	u64 regvallow;
>             	u64 regvalhigh;
> 	} elem[];
> } __packed;
>=20
> > +
> >  #endif
>=20
> --
> Vitaly

Thanks.  I'll make these changes.  I was being a bit lazy since
the ARM64 code only gets/sets a single register at a time.  Also
HvSetVpRegisters works very nicely as a fast hypercall when setting
a single register, so I didn't define the in-memory data structure.
But for completeness, I shouldn't take these shortcuts, so I'll do
an update.

Michael

