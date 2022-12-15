Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8C64D562
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 04:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiLOC7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 21:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLOC7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 21:59:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718304A046;
        Wed, 14 Dec 2022 18:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671073189; x=1702609189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aHcFiUt2GVMmlMt7hOtVFXeOEJFkplCDmRrmjHvS0KA=;
  b=XhJO2xSMI+XwnNGd26qsHljees03GIq5Q/omyhOe2skLewIX4CU5pfun
   AehThegc34FpzFHRmOFEKjeVm69h77tFj56Ya8eQAxOHQqobl3l18QqND
   4l9DBDf0Voo4/sjvc3C+iLnjBZuiQJZYDFpysraEdUdExwNgk1tJZpcKF
   /mctvZQvsF4aeNuQEJRf4DZLN//cl7HbvYmA1opaKNVb9VFrtN4F+SDZ9
   WuCWlx2spAUm+Aifiltdvdeil3y3ZuJFS2ZYdcKgji7Gj1L7xaM+K8hO/
   LB7nDmN+41JBxKFfzMGs5xXtuv7sxycbPuBCJzekPdRCsJW76ClYfPwRC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="404838679"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="404838679"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 18:59:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="717837510"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="717837510"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2022 18:59:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 18:59:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 18:59:47 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 18:59:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCnf5yMQi3Y01E2G7aVOJYNZp+zJnEKLLwNxEN8j2R5PUdbyLUGS1PHvyytuBe/YKxzZk3ATfeRK/vRqVOsccQr0cSxNLZqgNA86M62FRU3fJs0rGqQrawovb4GTfqz11nsAaLfJSwkQx2hgSAFgNyQgNZrhvvkHx5i8l0zhF7+Vgn7+S9s68xThhdNgi7tTQU+4SxPQLeHArZtLSsRuBFB9EJpVNuHstbfNYPLfnqJWCQcNff6+8V1mBvA50cCapdShK1S7F2KFEfaMcD5BA9XoZItnxpjAYrEcjoZSIBFAR5/3q+mf5Wkc/x7bGTbjrLkTuK76N5SHX3HU/yj0BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHcFiUt2GVMmlMt7hOtVFXeOEJFkplCDmRrmjHvS0KA=;
 b=Lu7F2kEkOcNpnhEyFJEJ5a4tn4KmYKrF11dlSwnXIw0GXz2kUyDVvpnRwWzU9ReybXsJCd++WvS5mGIRFt40l1K6y1evD3NuzkocHofcmSBQ6zhxi0U3xG3pNoWNnsGQ+/U3UiO3oybkHWOwWlXaIksZWvVXle2mIjeLHCZpSIviOKKii/GbCasUO4N3hRECGvBmB5eN4OVpF4TYG7FVndWUP8XeyBdo4xKnyI5foDipZVzPrUqO9a4cN2i1gsIGdABY5FOYm9I/Qq1wicCgqp4jyOaCeXU+9lYg7eEU/MmPuJuQydfkjF/wBs7L5vzROy1E5zMHzAC0KTvwTwOzWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0031.namprd11.prod.outlook.com (2603:10b6:301:69::37)
 by IA1PR11MB7776.namprd11.prod.outlook.com (2603:10b6:208:3f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 02:59:45 +0000
Received: from MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5]) by MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5%7]) with mapi id 15.20.5924.011; Thu, 15 Dec 2022
 02:59:45 +0000
From:   "Zhang, Chen" <chen.zhang@intel.com>
To:     Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [RFC PATCH 2/9] KVM: x86: Add a kvm-only leaf for RRSBA_CTRL
Thread-Topic: [RFC PATCH 2/9] KVM: x86: Add a kvm-only leaf for RRSBA_CTRL
Thread-Index: AQHZDLMfWcd8CShN1kKrF7OSJP+Sha5t7gqAgABaGHA=
Date:   Thu, 15 Dec 2022 02:59:45 +0000
Message-ID: <MWHPR11MB0031009C01144135F0EE32279BE19@MWHPR11MB0031.namprd11.prod.outlook.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-3-chen.zhang@intel.com>
 <20221214213335.GB16072@ranerica-svr.sc.intel.com>
In-Reply-To: <20221214213335.GB16072@ranerica-svr.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB0031:EE_|IA1PR11MB7776:EE_
x-ms-office365-filtering-correlation-id: aeb9e4a1-2710-4caa-1154-08dade486b9e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e0wGagfXs8trYKZYxybS7vd2czQ8gr3SlnrTJlGUQFrQiraOf01V2wYT9sGZd+Suyl2COiPE/ZMz9pNUSkyVVhyCLKE27hxA+W2kim1rE3RWjiSnPGqDovb6M6Gt0R+mkJgZjC9z5H2ra4DlsH2XXPqK3wWDIndxvl8XwjtfVL0Efe+Ao1HXuLZz4uHBFT99JgigX3p+iCXJ53UVRG5NCZ8ZlNRxQsO3RyavOIreBMOobGJQJPO8rUsNsi2pJpbclUpbnJPEO45760hKe63GFFNMA+sSVc1vHnHLBITkCNu8kvb78tx5wT4mBzXJI0KT+UPKPJ6rEQaSU2aPVyKlbfwnyeVavUgmE63NNRRz+hlhqx8/AYgNJOown4lX/OZzz5ccDRymEW/MvJPc+1SxecgS1HHIb8l/boMUIi9W7eWZf30kErYOUvcfCebKQK2J2Z1MClAseVe/Kmu9D+As69CtfUm0G1hEuBqB4iuY/y5sJGIRg/G6cg33+cG81dTpdI4miB2K/8aRosZVhIOYn8I4kAPn2VRZtxmLtwScFoH7J2G6LLchMjTLDXqApr5kdzWWxvrOihtv6lJWBhSKrHIrqh3omOhjIxIQhn93EYM6fbcfcq+sCerV5vBVan0nwHibhOBd/pQ89W6Hg0+0QGYhJH5wXTTatmqg9MBkCP1z514jkAVS71A+t05zbdOW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0031.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(6916009)(86362001)(83380400001)(33656002)(2906002)(54906003)(9686003)(38100700002)(5660300002)(52536014)(64756008)(41300700001)(55016003)(122000001)(38070700005)(4326008)(8936002)(66556008)(76116006)(66476007)(7416002)(66446008)(66946007)(8676002)(6506007)(71200400001)(316002)(82960400001)(53546011)(478600001)(7696005)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u3he+JZIPpfUPp63LojgZcZEbbpfQSMPYiV+JKtD9RVp792yTh4pgYLKIomu?=
 =?us-ascii?Q?z+oBnMXrWP+5lT0jUl4DlX2DRuROZV0XMFnOGy+KEDCeOCmdSBZLUCKcjakV?=
 =?us-ascii?Q?SvZWgPnEe0z33QCQ/XHDu6Los+dFEd3eBaz/9z9/lrhDnvGhVr9rtP/jLPO/?=
 =?us-ascii?Q?dJbCBQfiJVOTQM2JPXiJTQubevaN2RTSVJtVw21+O5nTXpFjBHJ9zxvyicRY?=
 =?us-ascii?Q?auFtBth//SXMZ+GTVcLsO9nkZhn9GnFnkDy+vUbh8DeeXpC1d2iWM5XARhdO?=
 =?us-ascii?Q?YG1sFFblny/Mld3jR5FAZUm5YO+6O1ucSIBdUi2xXFgA0OyM7FmzLxFta5gc?=
 =?us-ascii?Q?9C2C3dKydbSfdWsm0ut7LKQRTYCxIt38Bg5MMwEWP1OV+DDC8WIyDHHjpC1Y?=
 =?us-ascii?Q?mxJ/DRMFSMVj6EIfP5ivPkQnO0fjtcOgxuzb+pQudWAGvfH+MBODGH1KMpdJ?=
 =?us-ascii?Q?MmgBoJbp3AVdrm5dIUpO+pDQDGGN5eBK/mZ3siDJawAJxBIlGtqv+3VWQpNM?=
 =?us-ascii?Q?hhfoLiB0Fxgf0tD3cRh7QMFisD9ohg0n+esIKenVR4dYjARnX27LQ94WSUYV?=
 =?us-ascii?Q?6Cg49jDJd6zZCQLRz5SpfQ/qxt48B0pW8D5nLolrAxgpV3rkbBBdYvFebNk6?=
 =?us-ascii?Q?ChRoV1ot+UD6cK/aiorJ1whJdC/x9GErl6UE/3P6I93NfC7WbdR7FVa9ofBJ?=
 =?us-ascii?Q?VgqoVvPurY0xLD3z/oJLu4LoRVwhxwd7xUraMT1QiiiYLL2GtF6A6jntKbqN?=
 =?us-ascii?Q?P/gb+lec3+F77Or4NEnUR24EE7NCv85KKIAU60QwepHARRlUygKtjrBuaqYC?=
 =?us-ascii?Q?arpCqPRwpW0rOUwMgaxLBEatwBc05D3fWcdyLIiM6lps9r2boh03Fj6Vyzi/?=
 =?us-ascii?Q?2rVeMA2fHOEOF1J5a9LYYC9ROvLkKioExFgKFC071wU0psZzwTP0rKVzuR6p?=
 =?us-ascii?Q?ukOU3vJ6aV0W5TsTRExLfNTOCtAe5c9l9cKaayo/KsVXVmFpChfAj4755SWV?=
 =?us-ascii?Q?KYzzg4JYSrJtagMR0b9IarBAiJrylidi69s8298izlYsdCeg94LTnGRFerra?=
 =?us-ascii?Q?Rr1Lh+dYTolQCussoAmcmEtV+dTCud0oHOBupFE5O5Z6BDgPPJsKD6vtm4d1?=
 =?us-ascii?Q?1j26sHnthagpC1tDVEMdWVMdD37F8PKh8lk/bLtBCE6j7v6biUi1nMQQP+1f?=
 =?us-ascii?Q?Cc/nyRpfb30AiCJ2OQeKYAZ04jG/zQTXyB7sgtUfkEBWxWgUgE/cN88yWGA1?=
 =?us-ascii?Q?OPi1UDLgeIynHbIJmXtAzb/AVxEzRcfROy+T7VyEZXc38KPeXm/XFHXjZXBW?=
 =?us-ascii?Q?E8QW+YIxSeNUVS3+A0yZJUYPQZyb3EPutoz/iFIdJnb711YWCzZ68fcPEBtc?=
 =?us-ascii?Q?Dx45Qgco7CTMeq3zdI5Z8KE1dbj6N5kFihJH864gdAJWp2LuCIKH750dCR2/?=
 =?us-ascii?Q?O7jflsIOpsbOtg9GthnUVoLTZRNUb4p0Gvpa5iGqGzTJv6cLb9EtAtvyOqUU?=
 =?us-ascii?Q?B1wstpkKdbntJP66YfSCO1yLU6SDzCnraX6vKAj+Vvhql/V0GLdqFSawXBz0?=
 =?us-ascii?Q?9ZKQqNFWjrxkWauYIsJErSXhO2cFkr6sm6btR4M5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0031.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb9e4a1-2710-4caa-1154-08dade486b9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 02:59:45.0566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FgBqQ/paouikh3PgzlgEiHQ1IPDvYsAArJFOBfNXOoX/Lt8IkJW/RSkQAv31Gwamx5sRQ6qQBEg9eD9qx8+UFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7776
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> Sent: Thursday, December 15, 2022 5:34 AM
> To: Zhang, Chen <chen.zhang@intel.com>
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Ga=
o,
> Chao <chao.gao@intel.com>; Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com>; Paolo Bonzini
> <pbonzini@redhat.com>; Christopherson,, Sean <seanjc@google.com>; H.
> Peter Anvin <hpa@zytor.com>; Dave Hansen <dave.hansen@linux.intel.com>;
> Borislav Petkov <bp@alien8.de>; Ingo Molnar <mingo@redhat.com>; Thomas
> Gleixner <tglx@linutronix.de>
> Subject: Re: [RFC PATCH 2/9] KVM: x86: Add a kvm-only leaf for RRSBA_CTRL
>=20
> On Sun, Dec 11, 2022 at 12:00:39AM +0800, Zhang Chen wrote:
> > KVM needs to check if guests can see RRSBA_CTRL. If a guest is using
> > retpoline and cannot see RRSBA_CTRL and the host enumerates RRSBA, KVM
> > is responsible for setting RRSBA_DIS_S for the guest.
> >
> > This allows VM migration from parts doesn't enumerates RRSBA to those
>=20
> perhaps s/parts doesn't enumerates/parts that do not enumerate/ reads
> better?

OK.

>=20
> > that enumerate RRSBA.
>=20
> and here maybe s/that enumerate RRSBA/do/ ?

Looks good to me. Thanks for your comments.
I will fix patch2/3 in the next version.

Thanks
Chen

>=20
> Thanks and BR,
> Ricardo
