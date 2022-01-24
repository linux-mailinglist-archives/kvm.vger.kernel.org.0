Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96007497919
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 08:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiAXHGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 02:06:35 -0500
Received: from mga07.intel.com ([134.134.136.100]:53842 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229776AbiAXHGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 02:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643007993; x=1674543993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ix93v/T78ZzMVOPgk9AGrQra1qXgRuYsLzOj9dLBImA=;
  b=i/xzJOnSQwbBI25ytDZ9oQyu1m/XglWlyiMnjI21E0nbqlG11KWiRDo+
   tAgvLSO7oy11LOAV080cpdOcKmhUFGNUYRg1Ixp4IuGtPH+CgoLP5R4Tr
   5l9P7VhOnP/nlW1IYBrNj2Ngz3ata78M0pXTtdvSSwh/LzmzVlQxkFYBn
   KpVmpRoZTUSjoiv3tX+eOMd/TFBM3onU9fRsVbb9sxP+SLW6HvvYUrwTx
   bIYyuCCpapW4LVWkuTgLBCwKXRIUX0C95dRpsoJviQmIsH7KB4FBe5ltO
   URqcGIwuQ8+mBt/jKi424H84WDio3k15j04a4B8uuK5zMIgyzG5OZOOxT
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309301255"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309301255"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 23:06:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="476615302"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 23 Jan 2022 23:06:33 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 23 Jan 2022 23:06:32 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 23 Jan 2022 23:06:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 23 Jan 2022 23:06:32 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 23 Jan 2022 23:06:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkXv8x9Em/+s32gOS1IZnUlTOlS7pw3HhC7UX+LXlpHQJ7r5lIsGnV224DJ6hxRY8UDOQPCyb0DohS2YNSYI37KWmSjbyLilc0FoUyRONoECUwyquwhvAtkCDMpfDyakHrUEpJOtm3BViHLZ3sq0+aGBdZX4YewAVSNX+YINXAyAZFu5Hh+TdoTikB9GI9hbT8jioMA+GxVgxHNOd/wL/voOsQAbrXggm66blaslqXeKOnVpv5gT95Pl1dljkN1loedJigTweWgrWVt43hrr5CB4vv63Vs6n7hWGvlqnJMLqUyVc3RHnjQas+4VKN0EciFJHR4GhCpfu66/nYdl+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NyInaY1d8r2c3H6spgYi2fGdrOFnV3rFEmWu7E71y4=;
 b=nOklRwaQ8KpC8by5C41E9pA4MC219OuTWQjatNpatzVK2iwLQQA6QLixL0wamAJs/o2JJrTOjLArpS86AMLBJfGmZ/Uo38z5RrPItw1qpumnygG46imZIAmH276KDPtbHlK7ve5RQXLdFsBbuSp1z0xXAhjQ68h36vzs+zKbHt++rkHwXSCORb0jcNecLz9hN0THopwhtNy9m5L+1qIYP1ZBFlBdnX6MAXCDkNAYP3EDM3aK3OOo1CVfBmk0CWjtGQmNWqrbHL7PFcnocKLfhOTflkK+r+2x2fpjqEScQXM2hxON7bqW8CGA+fWgGB0z7H23OLWlHlV2LnPxPgE18A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3939.namprd11.prod.outlook.com (2603:10b6:405:7b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 07:06:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%5]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 07:06:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Liu, Jing2" <jing2.liu@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for
 vcpu->arch.guest_supported_xcr0
Thread-Topic: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for
 vcpu->arch.guest_supported_xcr0
Thread-Index: AQHYEB04i+jH6+Lv20CJG71ADhixA6xxwR/g
Date:   Mon, 24 Jan 2022 07:06:27 +0000
Message-ID: <BN9PR11MB52762E2DEF810DF9AFAE1DDC8C5E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220123055025.81342-1-likexu@tencent.com>
In-Reply-To: <20220123055025.81342-1-likexu@tencent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f614cc7-43c3-4bc5-d4af-08d9df080a19
x-ms-traffictypediagnostic: BN6PR11MB3939:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB39390EDD09A2C4F4FD6DE3E38C5E9@BN6PR11MB3939.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a1i0PYT0gHDw/dXiCvxtuvZ2yW/9IqoFGfNVArekLUnH7JK87z4ozJ09Of1xVh2+5Gaq7GoCHiaicBvywAW7Gyj5nLG51Asvz4OE14wt0VkcRul2dZx5iNXDX9Gr5knE0VluepH2wyqRHNXnvWwjkTXJnkQYQYYG3/RpMtdh8TQ5XuknP5rMmS3SqbZTkkYjbWhfZFOlJOD0n0ROpk7GDqqlL8dGsRLvZZ+3g3AHYQM4vhZ3AsFyvz9GTV3bNfjYMp+XmAb6DLa8XNrNjioQOzMZskRTZpIuqM4iM36JErk/Xez6aDpCSnglnkHB7a4MrIJhmW8JhmIEDubRApDETiUWQdSKg4KP60ImST6S7AyZpQVAOHx/A6fylU+5TdPdE8yrnRYfHfb1MF9CPDZwUkr2ZabY4BlsPdnYi22A8M3jNN0M6PM2jD9KJGstoEu307AW1ziyrU4EknNs3S2Uld7gP0ESG/WhELcSFLIHS3/xXwKcL+5ZFTnCYiRq//M4kYYoOiMnrQdq7c4jY1MuKuKr+FNkIzoFRsLmjjV2T/NpOKU/xM3TnG+cnZVdlxnjn5Ehj1nqvTKcm+GIE1I4ve1uqp+Elyx3X6agwyCJ+tgq1kuv461Ig64/jqu0TX10OgUp8KyF1gBnY0Hy0af3bLiziSWhQvCnaILy//rQfnB2y0Q1tG/q/Vd/ipIOECQnqCUVI8QCVu4UScfYb15+4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(9686003)(316002)(110136005)(5660300002)(4326008)(54906003)(64756008)(66946007)(66556008)(66476007)(66446008)(76116006)(52536014)(38070700005)(33656002)(55016003)(186003)(8936002)(26005)(122000001)(7696005)(6506007)(82960400001)(38100700002)(2906002)(71200400001)(86362001)(83380400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Znjhep9uV0JK6VBVgs2EmZXD2Ec31p84ObjTp3cOoq46zemC/1AAIOKMLLL2?=
 =?us-ascii?Q?4Z0tD83AJy5Yf2KfC1HnsGId2dS1dTABvRVyk9QKAp05b/YUXMGrYwdZd3MH?=
 =?us-ascii?Q?ZHLuvZl2j2VYYJETuPtnIYDJOsjH7k6aYLwGbQaE2W/i1YQRQ/6xibzus2lr?=
 =?us-ascii?Q?GVb63YwaPYVhYCK+STnvWEvJuDF/wicv34Xdx77v0jbDo1po8hPoNlyu1vDs?=
 =?us-ascii?Q?LDv66UQPgYELPbFvhl2oq05p34MWggV+RLL+YaV4or+8SWGLJY3lMH70axAU?=
 =?us-ascii?Q?WjS5A22pa9yGN6ttrbkYxYUTzjtsfjI5Ma/OECsd8W5sn4zn3gBrq1DHZu3H?=
 =?us-ascii?Q?BezVDnwQ841bTAhd6naMsvQjLGl4s3kpi5l4Dq2pFGbV+I6tjBTRsRBOPRNR?=
 =?us-ascii?Q?bZocJEkJO/YZzm3cOP9CKcXgQRdTn5vu1vawMdd1IOSGlePAtVuU5hhyiHqj?=
 =?us-ascii?Q?81w0zFU3tHYdjv6zC4zWCIwswv6g1twrrLrBU40BWhKHHJRmgJLG9tsiuj+D?=
 =?us-ascii?Q?pCqn5KS+Kkdqo1C0H1heoFztJew0YrICUvpkdYecV6bYq1uSNrZV5CIdQb8f?=
 =?us-ascii?Q?zFugJ6hEVRiRSKgsHgjjwToiVSO2vhsqu+oeCw6IXmetqAVht6hD3aMssakS?=
 =?us-ascii?Q?dLD2JoXGvx4BY0AUGrxFwTSxpx+BPVZX8v07Zq11PWtoLOOhdm2iwjW0IZif?=
 =?us-ascii?Q?feJuf4pHSyly7XxrUDJ9ylkhx5ZJqhIylg7lM8PXCwEgYlPedd1JI0zuB/zN?=
 =?us-ascii?Q?eTj8MiT4Q4vcl6SL6DAzfZDd6S5GL78gV5qVS9ksUiG7IyV6G8mSNmlELnrH?=
 =?us-ascii?Q?LagwAEaR4nuteTjDKcR+/hb+K4wraJ36n1VF5IKSei/s6esjZ0bkbGjnpfj4?=
 =?us-ascii?Q?RVW4VK5ADPfRVP/+w5OAUnW205KyTOZQujy+wDKIIUstpMI2ShnglG2+kL9G?=
 =?us-ascii?Q?0z6TvwVYfD66ulL1+aK1A8FgBWcDZLHxPoNwf4shbjb9bhtjyTqiI7G/lYSd?=
 =?us-ascii?Q?oxTBORsSOZu60MhVd1BBdXAxK62APIh80TYIPETqvB+1r/bUsxffO7U/4xNr?=
 =?us-ascii?Q?nzk9/fsnMj1RuA8xztXcakbIBj5YbeS+AyydRV6lWtQ0qm0qZbgy8VlGRVoS?=
 =?us-ascii?Q?s902M1K4p2wcqTbMaJWvLhPcSHxtmWYdCI2CuorzQyF0Pg4duNGk3hO2YX23?=
 =?us-ascii?Q?dTfB0ZP36RfcH9lkxMC6SOkWzWkv36xoGJtt5IlYOCG/hOzW0i7A0A0UWHsi?=
 =?us-ascii?Q?kNYOv4ckcxNeZs9tc5hcoXnK+HYyanVqCqkznnfyMzukC6VIVP8wanibXQsK?=
 =?us-ascii?Q?RFvtm26X/zsG2ThCwFMeAJLn3xpNTAujyPObfKmsxk+RLDk6p/dhkjn5ETnE?=
 =?us-ascii?Q?6NYe+CxK7x47Z0lCHJFgXUpxbrhIndz1Wdtc5x5n+b01Zxs2n+gVdNbFzTDh?=
 =?us-ascii?Q?TffagZybMY99jTcdz8RlQAizTq3EPaWSKlG1BO9CQzLQPJjTBYPGStnDztbZ?=
 =?us-ascii?Q?O/K1Y/LSowAWdTVn+jvKKD6SzkY4DP8JqLZ4w1SOjsryYK6A5e7+yD2AJ12w?=
 =?us-ascii?Q?Wc3gChrIRzmCYwsVQNjddvqpoj9TMC0rLEYj7G/mQXX3QWtZX85i+l1PakIs?=
 =?us-ascii?Q?0qvoMOv+V4IAOgbaNeGWzQk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f614cc7-43c3-4bc5-d4af-08d9df080a19
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 07:06:27.1051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2oDZqn0fuJ2vHZqIC9NQCb7IUV/6cOaB8Hqz5v8US4ZO5cI9bPrkkhzGjsXrVBUaFHCTDVjhMGF6W+82fvOVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3939
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Like Xu <like.xu.linux@gmail.com>
> Sent: Sunday, January 23, 2022 1:50 PM
>=20
> From: Like Xu <likexu@tencent.com>
>=20
> A malicious user space can bypass xstate_get_guest_group_perm() in the
> KVM_GET_SUPPORTED_CPUID mechanism and obtain unpermitted xfeatures,
> since the validity check of xcr0 depends only on guest_supported_xcr0.

Unpermitted xfeatures cannot pass kvm_check_cpuid()...

>=20
> Fixes: 445ecdf79be0 ("kvm: x86: Exclude unpermitted xfeatures at
> KVM_GET_SUPPORTED_CPUID")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 3902c28fb6cb..1bd4d560cbdd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -266,7 +266,8 @@ static void kvm_vcpu_after_set_cpuid(struct
> kvm_vcpu *vcpu)
>  		vcpu->arch.guest_supported_xcr0 =3D 0;
>  	else
>  		vcpu->arch.guest_supported_xcr0 =3D
> -			(best->eax | ((u64)best->edx << 32)) &
> supported_xcr0;
> +			(best->eax | ((u64)best->edx << 32)) &
> +			(supported_xcr0 & xstate_get_guest_group_perm());
>=20
>  	/*
>  	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1)
> enumerate
> --
> 2.33.1

