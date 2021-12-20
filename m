Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFD647B26C
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 18:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240160AbhLTR4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 12:56:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:26626 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231527AbhLTR4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 12:56:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640023005; x=1671559005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MXCYBocgngQYhFOuLN4r729neAFM39pNCLf0H6FBrFw=;
  b=Mj0X9LAxSPIa/DFMQER/vfz9HCT9iI6f3o6720MKz0OETJZ/yIyrhgxo
   RDwgp+h8QqLGktnfxIS6MupAYepuEc/nSy4o8mRd4xoyWILMpX0aT02KI
   irysq1ZU3MTPXvSnXsxBYVkHrqkYDroR5rNiHTLhHYDMa8M63w2TCC2Ch
   Et0V7ikncUWZFy9xmE/7BEerq3Nxlk+KmkkyA/6uNsXMdVfYjnhIt++si
   rgvtWMmTfd7XRyItHozMCqFIn0TeS4s8qEAV2tT3upiZx//+Z7mdf6LsS
   Ec+GxgBsiIufzc45UFO2apPn9yiFJr/kysTS9gnTGqEkqy6gS7eYu/3jW
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="264420779"
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="264420779"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 09:54:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="606797393"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2021 09:54:19 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 09:54:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 09:54:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 20 Dec 2021 09:54:18 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 20 Dec 2021 09:54:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzY15ybpxkiZe0JITkJH0bewGrcQGDrmQe3tDESDABf7MQDl45vIdC2QEkk4wfUjGl9m5no7tZl8fZXkuEneT31wjp0k0yCyzduawcXOg7Mzhmj8r6X8WNyeF3aemLJLO66uljmEHg237dla5ARHfT8FTPLWC0IrsoqKz1PNKDQKIhKSYmbE++BEyYgQ5NMP1NhKjx6v5ByKoZYJfCizhADHg6d/7P0gIT+jM8aZ0EGEYrFgSoZcAGRQJpbWYV8Q6rYBdpADL/X8Eqr36VX5mJ573bknLJqu4Aw4yM8nDhxUF4GNYFxO5PDLe5XKGkOij3F2VgunLwphN8/re1E7IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/EoLbzwiovJHXQA80b8i9/rbMx2l13ugofkVZwpkns=;
 b=X5TAd+yTh/4jgZ1OnJUjFI0TYppFlIkGkF8pF/w2xZx1cANgb07JdYQP5RvAf03Xu8Do7dbUZc68qZXpG4jQnmzOSr9eL8CH3It+hfnhCceq0oGnm0APFUErMwHdlXtj2K+oE7Y5I7sPsLUmo59VjNtAew4jgR4xRYnqLDo5ZKSgnj3EIqlS7qPLxW8JI4naj/evQ04RNhSRraxjESvbWqk8G6X5qzqyQzsknBbudVw/IoDfFTuGK2IXRSDZiomMSHY79O7GFVp5IhDRVrsbo3QigRzjVWbLheRAHbCJN0RDbhHSL+y00ymim93B8G1qjAfnXPJpM8qWtHRM1mVHMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30)
 by BYAPR11MB3030.namprd11.prod.outlook.com (2603:10b6:a03:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 17:54:09 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::495a:4bae:83b3:b111]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::495a:4bae:83b3:b111%7]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 17:54:09 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>
Subject: State Component 18 and Palette 1 (Re: [PATCH 16/19] kvm: x86:
 Introduce KVM_{G|S}ET_XSAVE2 ioctl)
Thread-Topic: State Component 18 and Palette 1 (Re: [PATCH 16/19] kvm: x86:
 Introduce KVM_{G|S}ET_XSAVE2 ioctl)
Thread-Index: AQHX9cqW3RnCbmxVGU2/PYJFwRrY+g==
Date:   Mon, 20 Dec 2021 17:54:09 +0000
Message-ID: <24CFD156-5093-4833-8516-526A90FF350E@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
In-Reply-To: <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3770924-8fd7-428a-20aa-08d9c3e1b97d
x-ms-traffictypediagnostic: BYAPR11MB3030:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB3030DA5D2546058588B899669A7B9@BYAPR11MB3030.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sj68zEnTFQfimA9wozz7+LmF47jdVp4AJsyQ8NK+DtP12T9UHJMHLStous1cyRXC4AgbatHdpP4ZaBzW8WoYqwNKMRgtBmbDFOZEarRKl+E7sJISHkSmvWKk4M7DKXhKHBNHsHK85VWPSzhX37mrQcAgNkrw+uIJDfjbpG5gN17qf3QG/OHix/4alOFAxwxVn4qe982f1zu31Klq1/kwTBU368mGxGvzJWpKMVlQkC+NNzDOajlv3jGpw45y2hAiubSGq4b3WSYxVTjUo1IPaZ9fSQhM8nVni+cj8Q8dHlcKyrN0sM35axfP5jxLAPKOovt+IOqHQJbKapbQLdAEGF5lAJr4xHuFCLJ9nAT1zPh7lcgxYJXl2CdZVG2CSrLmFSgOpBhgv68OradWxefe54y0ylCfBG8bWzepYC5oCc+BBZwiwptoZtZEJ+huYvb5PNWTc7eow2TBYRygHMM06+i0cCBhdp4kPRVlE/U7kXVhzaCJSPuJOhzJ9LmZUqZMYjzLH9bBoIUOYzX2/+uGd13w/Mbc4Ck2yhtPSS1SSrc+OFYZ8bfGCV2FGbTDbweDHKrQnzxQpqvtMQQ9I3jbJ9ikSAiqZRtj9IbRbkSykrDvdiipuT0xcbFxCaIhPfCB9I/4vAXwqdopLzrsCYjXVU+iGsPZO/opZ6xjHBT2LvH2ysvYs9tCyPyjogoEHoswCQwXxwzUBs94ozyTLTorhW/ibFqwcQL4sVAIglosS6foo3A2dC4NgG4S6djScl2t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(38070700005)(76116006)(6916009)(83380400001)(508600001)(86362001)(316002)(2906002)(54906003)(53546011)(6506007)(5660300002)(66476007)(82960400001)(66446008)(64756008)(66946007)(66556008)(36756003)(26005)(71200400001)(38100700002)(7416002)(33656002)(8936002)(186003)(122000001)(6486002)(8676002)(2616005)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N8whsCbczTKKX7sO0mECans83uUnTIC0y6+llCv0EIvawCw+aynh1bw0y/WK?=
 =?us-ascii?Q?8Ex5jdh+iOmNh80RMKqxXjStDLakOAwuM66d6NGEPpIVetC1Woqzqwy4qBTH?=
 =?us-ascii?Q?UnjCN7sFrG4XwCTQOjBgMozsPv0ckcIPX8/lhPX9LPFi8/tFSBoOcpiMwNdQ?=
 =?us-ascii?Q?StyvA8BmWpssWxscf4QyXnb8OuZ3wIBCrt+VMUECgMe2aJ8dMUEWEwyAr9Wp?=
 =?us-ascii?Q?uBPQkfQQeW1o0eHv3AV4sAYpYMqVr8S4o+WUmRhFZcOF3OAh+J6617tkz9q1?=
 =?us-ascii?Q?6k5g9+KMD8a2g909H14MNwxQbyY6VOdcgYludZnT3IHqBfl+/07qBVwyUP20?=
 =?us-ascii?Q?9ckp6kLdvf73GRyBNhpWdeR2Czd8A0DJykkigudCM1aod1SphqU5PCHvPQ5G?=
 =?us-ascii?Q?yw47UF1hts+S3i5rucyzGOt3D8g3aPcR8yYhU4hSp5mi+drhIxbMuHVgMapY?=
 =?us-ascii?Q?aH9AgziXjGqQIp76m30JoRPBMPX4w8xlz9tGwCXLlzsnIuPoPizJeAQr24CD?=
 =?us-ascii?Q?hA2MevvMC0KBYAK5osfBvyh5G2uHgM5FhcnUGKO78LF+RwlGytvWWU9aBVRM?=
 =?us-ascii?Q?tByyqnZOHL3UVaVRN4OJblFV4cgdMzmK+GYKnjKy8STGwG8osIYftzZ1H3TF?=
 =?us-ascii?Q?R4uDj+9A+RtcY7YEdZnSwX6FL6ydjEdGN0yOTg6l5Oxn6Rfe4X03DHB4sNIP?=
 =?us-ascii?Q?rOm20VTPJK2fhoGcVar5jTHcelbMjjvrLr9m1P/NIO++aMJtQzQS2MekQDre?=
 =?us-ascii?Q?Bm27vZK6ZUO3W9rslT2wdAzIxb3wGc8R0NStOGWXT/EO55GoDDXduQ6tgEnl?=
 =?us-ascii?Q?VRJKpWvqg6DVGbWDfL8J5lVTVtA/rwvxMMEnLlsa6BHMrgvjFO9gdAZrhSCV?=
 =?us-ascii?Q?M71xppQLfX9VpOKKx6hKI6vsHzwh+1lU4QFXyHE3NaO+PHgMYh4E3AJO2TXV?=
 =?us-ascii?Q?Kumw+ZJbNR8i4zGu8/sz5/rstfi3Zm5yNei27BCIT2RSJfcX30CenThVX8rO?=
 =?us-ascii?Q?QMyQfsPWannEQdhOA8hwvosQToodOCskUceNOw4e6qlXXVI5yO4ANZNbkz4S?=
 =?us-ascii?Q?FmVvqFm6UGQWp149VUF/22Oqs2InSwsCs60C32NxksFZPwVwt09mRikkflYv?=
 =?us-ascii?Q?4H36d8Ocq4zE9Pjgw+FORdSq6ufQK2XDr6o2FF0+BK3Q97cDndXdHRLCJ+55?=
 =?us-ascii?Q?SdT+PUZVcQOt7g4XYGmitNSew8eEtPXIixVmTeRCZs3FYGVBDEApu4aSqAjl?=
 =?us-ascii?Q?T3ifRqhC9Y9m1m1zAuKmdan5amzZlEd4AaeXbT/PZSthh5fkWtwXRjNUAyan?=
 =?us-ascii?Q?t36gTnkbAI7fFOS5q/hrPFznMlJqrR3IK4wpcZdyk1HS3ZOc8c2x9yczhsBx?=
 =?us-ascii?Q?n2eYx8hIJV0BC382nspo9DiUqp69z18OnYt60APwC5cHAvlsTfVB+GOE5dqN?=
 =?us-ascii?Q?8xnRDnHFEHu8n8qytuktyh0zyt7W8ZUKqvwXDhkgVr9P+k/+J7Wt8IW1Ek12?=
 =?us-ascii?Q?pkT+RuvKHa4n+57u/XUA96VoY7ZEmiIhBOWrJtUdJPUr3dt1JNwPmEoSm52P?=
 =?us-ascii?Q?m78V1hsswbXsXWzft9KM6GeMi44vmx8FSTiwcKS7IeFkZvy8Eg4u3i+Bfir0?=
 =?us-ascii?Q?RO28EzdayuleKaphY6xvmc4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B13976B3160E6A4E90D25F032771CCAA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3770924-8fd7-428a-20aa-08d9c3e1b97d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 17:54:09.4860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f57d+Ki4EmoRA2aPb+Wj/YT4Wvi0Xr51CtI944Wf5r2qmAA1UVmI9LpA7dWGbBAfdl4Wi2d+0oKgGpbIM4068A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3030
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Dec 10, 2021, at 2:13 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 12/10/21 17:30, Paolo Bonzini wrote:
>>>=20
>>> +static int kvm_vcpu_ioctl_x86_set_xsave2(struct kvm_vcpu *vcpu, u8 *st=
ate)
>>> +{
>>> +    if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>>> +        return 0;
>>> +
>>> +    return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, state=
,
>>> +                          supported_xcr0, &vcpu->arch.pkru);
>>> +}
>>> +
>> I think fpu_copy_uabi_to_guest_fpstate (and therefore copy_uabi_from_ker=
nel_to_xstate) needs to check that the size is compatible with the componen=
ts in the input.
>> Also, IIUC the size of the AMX state will vary in different processors. =
  Is this correct?  If so, this should be handled already by KVM_GET/SET_XS=
AVE2 and therefore should be part of the arch/x86/kernel/fpu APIs.  In the =
future we want to support migrating a "small AMX" host to a "large AMX" hos=
t; and also migrating from a "large AMX" host to a "small AMX" host if the =
guest CPUID is compatible with the destination of the migration.
>=20
> So, the size of the AMX state will depend on the active "palette" in TILE=
CONFIG, and on the CPUID information.  I have a few questions on how Intel =
intends to handle future extensions to AMX:
>=20
> - can we assume that, in the future, palette 1 will always have the same =
value (bytes_per_row=3D64, max_names=3D8, max_rows=3D16), and basically tha=
t the only variable value is really the number of palettes?
>=20
> - how does Intel plan to handle bigger TILEDATA?  Will it use more XCR0 b=
its or will it rather enlarge save state 18?
>=20
> If it will use more XCR0 bits, I suppose that XCR0 bits will control whic=
h palettes can be chosen by LDTILECFG.
>=20
> If not, on the other hand, this will be a first case of one system's XSAV=
E data not being XRSTOR-able on another system even if the destination syst=
em can set XCR0 to the same value as the source system.
>=20
> Likewise, if the size and offsets for save state 18 were to vary dependin=
g on the selected palette, then this would be novel, in that the save state=
 size and offsets would not be in CPUID anymore.  It would be particularly =
interesting for non-compacted format, where all save states after 18 would =
also move forward.
>=20
> So, I hope that save state 18 will be frozen to 8k.  In that case, and if=
 palette 1 is frozen to the same values as today, implementing migration wi=
ll not be a problem; it will be essentially the same as SSE->AVX (horizonta=
l extension of existing registers) and/or AVX->AVX512 (both horizontal and =
vertical extension).

Hi Paolo,

I would like to confirm that the state component 18 will remain 8KB and pal=
ette 1 will remain the same.=20

Thanks,
---=20
Jun





