Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552511B4DF3
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 22:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgDVUEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 16:04:12 -0400
Received: from mail-eopbgr770101.outbound.protection.outlook.com ([40.107.77.101]:32069
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726079AbgDVUEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 16:04:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsMOuL5MpDBG6taisXtqkTvqSLwZTEcxPmucCqm1bHZljQUg0mp9pT9NsQwesQ6vAhogoGAgfJBtydIu5edNIYFLvednt/9amMP5fV3HlifdyKR5nWcERraC5Tw1DrqWFEaq6JrpYz8ZpYL7K/Vsr6i8fYmZ6+SJ9XIlmJzeXpmF+ZlKvECRpTkmXVIfX1IRmxccQOylBGE8C9EUZDUM29ZfAPXAjNx3S5CZoa4K4geWa4GrMGvP3cjveo+7zbwQihIc/R/DzQruXNSFp/SgxGYrimJCQXqf3rVDLkff61NGPkgC2icVQhiGKd+y8OMBQ48ssrgvaGbo3lj+vELujQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4bM1n8YUkawzCbiNzSwLFoeYs+T9anpLVtHg6M7Emw=;
 b=f2HNvaRD3RgqHppocrNW5f0kn4+ySu6hKuWIoVSShkJ+y8++HMBzD0f+0VHEmrhsdEInuHlWy4c2SjTpKpa6YuKCaGj0Uo1p6l+wp9HxvUIkZTM9KQOGHXomI5L0os5qZ+8DdUzJRimzehB60YAKFLhQw6a6ZSNyDq0i8q3vh8pPyS0SBzV/rDqobGvQGNMfRNBXC4BcQc7OgidVnH2k0dbd6Oi+5cHJWok/gYftQo0EKbLFVANUawwb+Y8LALXe9IJI6tQ6a5/CWRoPqiY0hbiroic+WFFTUvRpxZVkGJhUyy7MXLUQwYDN7sZzmWR0hsDTQjQIFzPn6BHuca/aFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4bM1n8YUkawzCbiNzSwLFoeYs+T9anpLVtHg6M7Emw=;
 b=drRAX8U8XpfVIpxSPzJ89Q/eqLnRIGgW/v7nJAGVSiUK9txz0/LxFqViTw34ZTYrSc8eu9FpNhtJNDd1W/2OC+DGUUL0c2Z+AG9kI4nGm8ni49b9tA/yb2lodH1jvm2vVnc3bDi+TaqAqvupXDlQeX/8RKPb3y7g5WCgN85tLH8=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1130.namprd21.prod.outlook.com (2603:10b6:302:4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.3; Wed, 22 Apr
 2020 20:04:08 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::71ee:121:71bd:6156%8]) with mapi id 15.20.2958.001; Wed, 22 Apr 2020
 20:04:08 +0000
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
Thread-Index: AQHWFzqo2MJXKNqRb0OpB2C/Ixhrm6iDi9EAgAAtKyCAAdnBAA==
Date:   Wed, 22 Apr 2020 20:04:08 +0000
Message-ID: <MW2PR2101MB10522065BF1835CE5D2B233AD7D20@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200420173838.24672-1-mikelley@microsoft.com>
 <20200420173838.24672-5-mikelley@microsoft.com>
 <87y2qpq9e7.fsf@vitty.brq.redhat.com>
 <MW2PR2101MB1052EF4972CDCF9BF2B0356AD7D50@MW2PR2101MB1052.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB1052EF4972CDCF9BF2B0356AD7D50@MW2PR2101MB1052.namprd21.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 87f15622-a183-454e-c5d0-08d7e6f85160
x-ms-traffictypediagnostic: MW2PR2101MB1130:|MW2PR2101MB1130:|MW2PR2101MB1130:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB11307F0FA27DB2493AFE4C1BD7D20@MW2PR2101MB1130.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 03818C953D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(6029001)(4636009)(366004)(66556008)(498600001)(82960400001)(55016002)(82950400001)(7416002)(10290500003)(76116006)(4326008)(71200400001)(66446008)(8676002)(6916009)(8936002)(33656002)(66946007)(52536014)(186003)(7696005)(54906003)(5660300002)(8990500004)(9686003)(2906002)(86362001)(26005)(81156014)(6506007)(66476007)(64756008)(41533002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i+KYUP9fD4QECsbg87W50voiFiDmErOO+vLO9XIkcmkVyxJRg15DRh6yX+N5miP09MwK88YEUrrt/W9MIBUNkL/fpmMOgn8wuuSrgo+PNUmxvFXYkzGtBOjxXlFvBkApqAMVyZo5cWjrui7St3lGrv/nR9skp5HvBA/ER1Z3oRtBOLO7++gJ9QWTHOujnZeFaOFuIHbVKJX8qoCbvuafKz+clICOsiL9CdEobA6cs/NLDVPBj0sRD6KzbkvYhIlmrRlzcRanRMu0pxWLe5fW2KP1qK9EJs8+f/zQX+oPuDIvbshV2SmUgkJh4mNHSbfZEIb+S47OSUQxJOWTMRRniMwJTYK3QmpyLE5k3WJMzWNhsgjPBn1PiFc+P2bTyjIkmu+O6UhGoYpyDtYUFi9JfOVRbcViHHvH946KVEFrPKf8ioJy8WFq4Rs/SG1Tn6FN4TyLo2Ea0/ngREkwh4MOawi76Uj4QaGfZvKpRgfSq1HTPiK5kH4eHSCPyK5hu9Vo
x-ms-exchange-antispam-messagedata: IsRHgblF6lc5+U0ziWmZJ1Dzb/QruKfPXKPozKUIOkr5toCbGXLS4RQji2O/7Q3hw5kp9d/J9heV7I6Y8USt9OEI800E6DAhm9HsM1nS0M+5nJYix4qjO41u7nbLI5shwgZPdDkxkGUy1ShEkT2/zXKHwziD+RM8rQF2onBD50yjzWSXjW6UZvNQ7woFPCj7lZFf+Ig0fq/v86N9PssZK4THiBTRvv4yHzXkCFInI/UoO2F+JVakAthAonHpzfK/rRJNkaXl8Ppdf7x/dol1L422SYxeIPAp9RIEGzZA5hDsQ/Nwx7Uly6S7/OkDO72WM5xT0/6zQbcfHArn3MIJktAdpqvApOPIIWgdKZ1ad2nK1gCPRyLVRSjw+RAfc3Npw3MPrPW2OF37ONxlM689CNSTDdRS5Rg/MEyzUrUjTsNkBvClwE+xlBeADFR2428TbpeJXG7fZIP9UYwarsbZ0RafqEq8rtVCZf2cPDoSm5JxdmFM0WAlIr316dwbUkZf/JBY9OnGy4Nrgg/PpefYkkDe7tajtvZsdFWWnH4ln5XK5ZXXEd8woDDX/3mFy5ErYFhCRTDyV9T9czqeamn58sqMqDvKG56G9AHjgXiHeC+bI25d2O9+FQw6+ytfCwsQA8SIjnLs8mRoxR4MoX1mdJjyi8CCP8IHq3ftme+3/OAeF0UfiRYsnXnaZCDiH6vArvTB17JIKDB0pJ9t+SrXn0DtVl59x7BIGVkawcNBCxmNxWuj9B3cSnnrA4aG7Bc0lGDW4sjjsJ49H35f/HbfxKnix/vZRSgz8L9Pw5norfw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f15622-a183-454e-c5d0-08d7e6f85160
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2020 20:04:08.6399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5w3F3rvPeVmxLB6shhGJAnnJeBUFIBpTtfCAnq6j93PKA0ehmyeUPTTrJaXlb0VwkIPjO1xLPT9DJoNRdPoa8nVR5IeT5+iq7cq76oYJ1gU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Kelley Sent: Tuesday, April 21, 2020 8:50 AM
>=20
> From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Tuesday, April 21, 202=
0 6:03 AM
> >
> > Michael Kelley <mikelley@microsoft.com> writes:
> >
> > > Add definitions for GetVpRegister and SetVpRegister hypercalls, which
> > > are implemented for both x86 and ARM64.
> > >
> > > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > > ---
> > >  include/asm-generic/hyperv-tlfs.h | 28 ++++++++++++++++++++++++++++
> > >  1 file changed, 28 insertions(+)
> > >
> > > diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/=
hyperv-tlfs.h
> > > index 1f92ef92eb56..29b60f5b6323 100644
> > > --- a/include/asm-generic/hyperv-tlfs.h
> > > +++ b/include/asm-generic/hyperv-tlfs.h
> > > @@ -141,6 +141,8 @@ struct ms_hyperv_tsc_page {
> > >  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX	0x0013
> > >  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX	0x0014
> > >  #define HVCALL_SEND_IPI_EX			0x0015
> > > +#define HVCALL_GET_VP_REGISTERS			0x0050
> > > +#define HVCALL_SET_VP_REGISTERS			0x0051
> > >  #define HVCALL_POST_MESSAGE			0x005c
> > >  #define HVCALL_SIGNAL_EVENT			0x005d
> > >  #define HVCALL_RETARGET_INTERRUPT		0x007e
> > > @@ -439,4 +441,30 @@ struct hv_retarget_device_interrupt {
> > >  	struct hv_device_interrupt_target int_target;
> > >  } __packed __aligned(8);
> > >
> > > +
> > > +/* HvGetVPRegister hypercall */
> >
> > Nit: 'HvGetVpRegisters' in TLFS
> >
> > > +struct hv_get_vp_register_input {
> >
> > Nit: I would also to name it 'hv_get_vp_registers_input' (plural, like
> > the hypercall).
> >
> > > +	u64 partitionid;
> > > +	u32 vpindex;
> > > +	u8  inputvtl;
> > > +	u8  padding[3];
> > > +	u32 name0;
> > > +	u32 name1;
> > > +} __packed;
> >
> > Isn't it a REP hypercall where we can we can pass a list? In that case
> > this should look like
> >
> > struct hv_get_vp_registers_input {
> > 	struct {
> > 		u64 partitionid;
> > 		u32 vpindex;
> > 		u8  inputvtl;
> > 		u8  padding[3];
> >         } header;
> > 	struct {
> > 		u32 name0;
> > 		u32 name1;
> >         } elem[];
> > } __packed;
> >
> > > +
> > > +struct hv_get_vp_register_output {
> >
> > Ditto.

I've sent out a new version, but didn't change
hv_get_vp_register_output except to make
it hv_get_vp_registers_output.   The C compiler
wont' let me put a  variable size array as the
only field in the struct.

> >
> > > +	union {
> > > +		struct {
> > > +			u32 a;
> > > +			u32 b;
> >  > +			u32 c;
> > > +			u32 d;
> > > +		} as32 __packed;
> > > +		struct {
> > > +			u64 low;
> > > +			u64 high;
> > > +		} as64 __packed;
> > > +	};
> > > +};
> >
> > I'm wondering why you define both
> > HVCALL_GET_VP_REGISTERS/HVCALL_SET_VP_REGISTERS but only add 'struct
> > hv_get_vp_register_input' and not 'struct hv_set_vp_register_input'.
> >
> > The later should look similar, AFAIU it is:
> >
> > struct hv_set_vp_registers_input {
> > 	struct {
> > 		u64 partitionid;
> > 		u32 vpindex;
> > 		u8  inputvtl;
> > 		u8  padding[3];
> >         } header;
> > 	struct {
> > 		u32 name;
> > 		u32 padding1;
> > 		u64 padding2; //not sure this is not a mistake in TLFS

The additional padding is not a mistake.  Hyper-V wants
the register value to be aligned to 128 bits even though
it is described in the TLFS document as two 64 bit fields.

> >             	u64 regvallow;
> >             	u64 regvalhigh;
> > 	} elem[];
> > } __packed;
> >
> > > +
> > >  #endif
> >

Michael
