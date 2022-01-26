Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F25D49C0BE
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 02:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbiAZBYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 20:24:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:33450 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232531AbiAZBY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 20:24:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643160269; x=1674696269;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nD2ctv+ZgW8sFPfn8TlZLo99GaziE85S6K9YZ2sue8k=;
  b=gRDTGUolrVjQ/ySspoBppODZ+HcDRQd6UOWcZ+1BwvqwZZWcOLuEA0ln
   D08BCM1aNmDLsJUwKabYDUmLEmZ3AIQaJaQDlKM67bZi9SxaEYknxYGtO
   wTI9x2cFmPTE39fytYLiJSwNux6xUXCxvDV2+fcm54k41U2RK8ehslaTX
   vQdK8Ti67JxrcjAjsdDqiBCKESpT+OAELveEDfJiNEsi2GqMGWNtnTWRB
   zMtPUVw5oSsCA5DluJErF8ElW79bBOL0CYkfYcJ17YexndGKKoQy49YP2
   AMn+jGXY4kdHNTE9Kn1nEMmK1OTHvYvPv0yyjnUZPK08LPRMmnVdxpgje
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="270907091"
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="270907091"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 17:24:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="495204230"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 25 Jan 2022 17:24:28 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 25 Jan 2022 17:24:28 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 25 Jan 2022 17:24:28 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 25 Jan 2022 17:24:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6RMVEIE8ipck9yJwmnq1jPvCs+5e7UbH3QIDcpC0aU72pvK015zdr3om/visLXA8ojwt68q3JK7Ziyy6DEbtEYyzgNXmcT62CDJKrPhJcU+Y5GetQU52vO6EId3JIeB5Nrif6SLozKuaI4yDQIHLUmFl6pOMpYABQiLwRM8ThEC7QX75iYSoOe48XGDc2OezMcKxX3d1QDTEcASrKtPrkSp3EYO76ot/lymfx70Ia959bLs3+18JGwigjLSVVzlA1AoSBegs8uBo5ft1dqqtIBSM+BbAO9tTKRHNFT/Xv5G8lS5xPnXqYKObLGSmdxE1UL3y4B7qGjUW2rfcfauJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nD2ctv+ZgW8sFPfn8TlZLo99GaziE85S6K9YZ2sue8k=;
 b=XGUqo9iq8YCl07EUlE0W+r1PQWO7HYgrrt2GpRuwPMuZEC9Y7wwhQy2q0Pfzz7aCEqiPT9tzRcAHUoFZHa0+UfZimjsVRS+4ihSV/udvw2SzCCImJEmF0MU+PPWjILKKx6XV6EWS7HHURvSJQ8oz9PTpIjBQo97dLs7SO8OrZ6Ue3cYr6t0lrHK4sD9ILICjTdHGIHtK8qWECwwGUA1/HLiFgnpmGv/JtGbNpz7uTa6R08Ur+ljs9hUduxpjwuBZkFQ6by75LRAFScmOTdbwxjUYB8bHgnvhjkKk67Xp2B4+ghwv7Tf405slF+MAgx0hnaage/i+vl2XR2Y94ED9Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5184.namprd11.prod.outlook.com (2603:10b6:a03:2d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 26 Jan
 2022 01:23:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%4]) with mapi id 15.20.4909.019; Wed, 26 Jan 2022
 01:23:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
CC:     "Liu, Jing2" <jing2.liu@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for
 vcpu->arch.guest_supported_xcr0
Thread-Topic: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for
 vcpu->arch.guest_supported_xcr0
Thread-Index: AQHYEB04i+jH6+Lv20CJG71ADhixA6xxwR/ggAADloCAAJhpgIAAAciAgACa5uCAAHDWgIABG7ag
Date:   Wed, 26 Jan 2022 01:23:55 +0000
Message-ID: <BN9PR11MB5276857ADADACA58911149638C209@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220123055025.81342-1-likexu@tencent.com>
 <BN9PR11MB52762E2DEF810DF9AFAE1DDC8C5E9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <38c1fbc3-d770-48f3-5432-8fa1fde033f5@gmail.com>
 <Ye7SbfPL/QAjOI6s@google.com>
 <e5744e0b-00fc-8563-edb7-b6bf52c63b0e@redhat.com>
 <BN9PR11MB5276170712A9EF842B36ACE48C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f00d0e56-e5d3-4ac6-1519-fa843fb4d734@redhat.com>
In-Reply-To: <f00d0e56-e5d3-4ac6-1519-fa843fb4d734@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1efc5e3d-580a-43a0-70d9-08d9e06a8512
x-ms-traffictypediagnostic: SJ0PR11MB5184:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR11MB5184A0240C3B0076BDE16F598C209@SJ0PR11MB5184.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yDNobRS4cWg9dhG1J7ACpOWe5YpkrDyUFt8+J/d33q3Lb4MgFc4/63WpxJAzhSxMbMjx3wBybWKvsLHp1vkzAS6z2GL7Z4b7rJSgkayy4oDm9zf4zw5EPv5/aV10DturfnA1FBcgJahsf4n0xhCnMszOzCcT7kBTEVcnrq08jaeRVmKlASHKQx3Mi621d1qSeMckqp1mIs5f6Lv60gQBITdfp4LoroLQ1hPhvlwBiaQuegX1Ku8YmulAbvZW7/wF3yaZqgUm7KUDzSdroCWQ+OeBKihGmbBkw9AkQ1n188Rlo1PVAUufRfMd1+8lBIliIeaSYPvq6L+hvmNqVafas4jy7yGcf8c4emhNX+khs39JorWqlT/aD4BdrWykL7DcKyAPLCaV0K3gmaBwT6P84Eh6xaZpX5XAvNDNR4pqacAXg2FJ84mqbY1DCh3V6DLwVq5onrOUcFS8aM7fWIOg+Q5fKT9zi3Z5PR9R/h516mSHuSYgYvWdDetukxOIEpxbb9xLrP//X1ZUj9c48VchGhvAO5Aic3L2XrB7BcZeVZz24Mgv6XmC2Tp6w8qdEGOfEyxMPwWqNHmnc2IpjTieAewNihxYHQdCf282yDsNj5p6aPwUptB3mm7GZDoE1FEfWVsVrU4M9hxFuGN58a8GAhsGvxNJTTe4LupxirKhdYn79G1H0JIhdTlfjd0PZA8cH7FsEDLY4QH7TaeIIM1MUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(38070700005)(54906003)(66556008)(5660300002)(82960400001)(76116006)(186003)(66446008)(8676002)(107886003)(316002)(66946007)(110136005)(6506007)(66476007)(64756008)(26005)(83380400001)(38100700002)(122000001)(7696005)(2906002)(508600001)(52536014)(55016003)(4326008)(8936002)(53546011)(9686003)(33656002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SG5kZ1F0dkRNc3h3R0NRN2RQVUtTYnBxUjBDeng1N0lqN2VIcFJ2Z0hPbDZM?=
 =?utf-8?B?RVlDNlBTOXVLaVlaK01sRkFHQjMwalZMdFNoVkpYbVV2NXhBT0hsUDg3ZlNM?=
 =?utf-8?B?TkxJTGhSVXZHV0Jxa0UvRjhBdDM3NVNTSW44Z29ldm43aVlMWW9UZWRJTzZk?=
 =?utf-8?B?dlFHc25KOGlvV25Bclh4aG5KbzhQSVExd0FabE8xUnhjbTZneVhRaFRKMmVZ?=
 =?utf-8?B?Z1czeHhzVE9pdXRROEVERk42dSs4WEZhR0NiWUIzNkFqcmdjV1BxU3IvSVd4?=
 =?utf-8?B?UjJ3eHptSzVDQjVmVEJ0V094M09kVkZUalZnU3hPM0I1MTJkK3dqbWhnZDZ2?=
 =?utf-8?B?UGEwOGRUbFd5TUhJVnA2bHBQRXVUUUxLNlNjdDJGclJYN3EyeWJKWVhhZmFP?=
 =?utf-8?B?R3dNcjFCV001Wmw4SUFiZjlmYVdMcHc5clA3TGk0alpIeUZYTU9SWUNYRWgr?=
 =?utf-8?B?NTlIUHU5UVJ0aWtUYXVVZWc2RkZ5WXM3cnpRcmpkSUhjbFU0aVBHdklReWJy?=
 =?utf-8?B?VDdvR1B2MTh0dmRnLzRQbkgxOHBKeFRFd3JFejFSZUNWZExIY2JFLzRZTGlm?=
 =?utf-8?B?OWQ5dC9SOWVLUDlSSUpRYktod002NlBFdXROaS8rOHp3WmYzd2lBZkR6WmlF?=
 =?utf-8?B?RnFCemttZzJ2N2NNSEtWMC96V3RmNDlCUGh2cG40bVZTeHZ3Ri9tOEJEVkhp?=
 =?utf-8?B?ajFUUGVuU1lkaFhIeExNU0ZZemNyT3dtaVVwRHZzVmJ4cktQUm1WOEpNMkxu?=
 =?utf-8?B?VDVWdGIwK3ppa2FQbkZRV2EvaElVK3Fkd1JGZ3BTWU15ZTk2WGxVQVloNm5n?=
 =?utf-8?B?T1ljZnZzSWlHWjV3ZmU2a2lKb3RKRXEzUEtyS1VpUEFJZ3hPanBTYnJUSnJY?=
 =?utf-8?B?MmhncFhQNjZ2UFRielQrUFVSVkMvZDBqYWdVOHdrZWFKUEFLUWtJOFZLQVlp?=
 =?utf-8?B?c1BUZDBWTEJBSnB4TjdWMjdMNi9jelpzMi9KVXJxM2VvOVdIMDNzMU5oZ0x5?=
 =?utf-8?B?Zmw2K1ViVTNBK0ZYdjZJemhZbTUwNU50Wjl2eEhmdmJRNDkyTjdaMTlUREEr?=
 =?utf-8?B?RGlyWENYZCt5K0tVbW02QWFqR2RaNUpUV3pqT2o3U3R6RmZxa20vUmFtMVZs?=
 =?utf-8?B?T1QxTkVrcmFrK1pxUUtzWTdaVDMrS2U3VFJJSEc5LzJ5QlhXbk5YWFBUa2lW?=
 =?utf-8?B?SWRRdkRBaUtqS0dINWl3TXNwaDJoenJRbTVtdmtkVDBZaGl0TnZScUZST2lM?=
 =?utf-8?B?MS9Edm1TVitaV3kyS1BNR1pxNk5NWmttNHRMdjlnQnNUQTNDTmlpaGd1Rlcv?=
 =?utf-8?B?ZlhYd20vbGFEUk5Fa2xTTGQ4Y3VwekFOK0JyT0ZraUpqdFdTK0tUUHhGQU9S?=
 =?utf-8?B?TWdEMHNtMkkrd0VpcjBtaUJuNTlyVng1R3N0SWgvR0VZd2ZSRFVpeTR0aURE?=
 =?utf-8?B?S3MyOCs3cW9mK1F3RHo5bnRrMC9nWjRFQkFGTWJvcXA5MEhsUW4wWExVcTVX?=
 =?utf-8?B?RS9hQkdHMmxCVEphY09yc1lxNGtOdVdwbE0zYldaQWlLeGJnYXB2SXlrSnBt?=
 =?utf-8?B?bzVIWmF6RVdGcXVkZTFxcFRVdFJpWHZ1bXhxZTdzUURSZzkrbXAzdnFzczNy?=
 =?utf-8?B?eENVeTU3aG9MbWJKNXllN0RNVjFhZVpOa1Jkb3VMc1FMbHBwUm1iQnhLcXk3?=
 =?utf-8?B?amhnUlcwWkJrUlg5bU1sQWluWTRpUHc1a0NYUStuaG9vMkVENndvUU1VV1lC?=
 =?utf-8?B?cnUxWmRBa2c2OURtcWZMbTlZa2NycEhUemhlRnhCd2NoODFpcGRkdnA1TDQr?=
 =?utf-8?B?V0VDa3lNOWRJVXpaTlJCOW9hNG5TRDNYcmQ0K2tLWjFIZm9mQmpoVHg0cU13?=
 =?utf-8?B?UWE0cHQvTmxCSktXMVNrYmptZVlBdHlCMy84djExb2FkSnhaejZ6NUx2MTht?=
 =?utf-8?B?aUxJSG9TVHFuNWg2bnkvdzZpYlR3WWJ2MHQ3QVRVQ2QzN0g5Z0paY2hsN2ZD?=
 =?utf-8?B?ZFpYVStGYXJEcTBiRUs2SEx4SE5CUkYvWWY4SUxvRVE1RXFzblJWRkhEL1Vp?=
 =?utf-8?B?KzN5UVp3UlRMblJmQ2ZOVmY0RDV6dlZHQzVBcnQvM0JzVHoyVjdOdnQwWDBU?=
 =?utf-8?B?aHNqbFAxN3JQNnlDblZCeHFaNFp3aFRHejFNUVlpc25ibTdrWHRucHp4TTdN?=
 =?utf-8?Q?tXNm39ZG40CckqO4e1xk30c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1efc5e3d-580a-43a0-70d9-08d9e06a8512
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 01:23:55.2275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFK0/HhYV5ef3AFllFSXEJ9lVlKJ9t8G+9kumXJRBcnwDP25w0EBSniUAY3kX5NtDDt/ithvFmecPq5QcmLkQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5184
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBKYW51YXJ5IDI1LCAyMDIyIDQ6MjggUE0NCj4gDQo+IE9uIDEvMjUvMjIgMDI6NTQsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBUaGUgZXh0cmEgY29tcGxpY2F0aW9uIGlzIHRoYXQNCj4g
YXJjaF9wcmN0bChBUkNIX1JFUV9YQ09NUF9HVUVTVF9QRVJNKQ0KPiA+PiBjaGFuZ2VzIHdoYXQg
aG9zdCB1c2Vyc3BhY2UgY2FuL2Nhbid0IGRvLiAgSXQgd291bGQgYmUgZWFzaWVyIGlmIHdlDQo+
ID4+IGNvdWxkIGp1c3Qgc2F5IHRoYXQgS1ZNX0dFVF9TVVBQT1JURURfQ1BVSUQgcmV0dXJucyAi
dGhlIG1vc3QiIHRoYXQNCj4gPj4gdXNlcnNwYWNlIGNhbiBkbywgYnV0IHdlIGFscmVhZHkgaGF2
ZSB0aGUgY29udHJhY3QgdGhhdCB1c2Vyc3BhY2UgY2FuDQo+ID4+IHRha2UgS1ZNX0dFVF9TVVBQ
T1JURURfQ1BVSUQgYW5kIHBhc3MgaXQgc3RyYWlnaHQgdG8NCj4gS1ZNX1NFVF9DUFVJRDIuDQo+
ID4+DQo+ID4+IFRoZXJlZm9yZSwgIEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlEIG11c3QgbGltaXQg
aXRzIHJldHVybmVkIHZhbHVlcw0KPiB0bw0KPiA+PiB3aGF0IGhhcyBhbHJlYWR5IGJlZW4gZW5h
YmxlZC4NCj4gPj4NCj4gPj4gV2hpbGUgcmV2aWV3aW5nIHRoZSBRRU1VIHBhcnQgb2YgQU1YIHN1
cHBvcnQgKHRoaXMgbW9ybmluZyksIEkgYWxzbw0KPiA+PiBub3RpY2VkIHRoYXQgdGhlcmUgaXMg
bm8gZXF1aXZhbGVudCBmb3IgZ3Vlc3QgcGVybWlzc2lvbnMgb2YNCj4gPj4gQVJDSF9HRVRfWENP
TVBfU1VQUC4gIFRoaXMgbmVlZHMgdG8ga25vdyBLVk0ncyBzdXBwb3J0ZWRfeGNyMCwgc28NCj4g
aXQncw0KPiA+PiBwcm9iYWJseSBiZXN0IHJlYWxpemVkIGFzIGEgbmV3IEtWTV9DSEVDS19FWFRF
TlNJT04gcmF0aGVyIHRoYW4gYXMNCj4gYW4NCj4gPj4gYXJjaF9wcmN0bC4NCj4gPj4NCj4gPiBX
b3VsZCB0aGF0IGxlYWQgdG8gYSB3ZWlyZCBzaXR1YXRpb24gd2hlcmUgYWx0aG91Z2ggS1ZNIHNh
eXMgbm8gc3VwcG9ydA0KPiA+IG9mIGd1ZXN0IHBlcm1pc3Npb25zIHdoaWxlIHRoZSB1c2VyIGNh
biBzdGlsbCByZXF1ZXN0IHRoZW0gdmlhIHByY3RsKCk/DQo+IA0KPiBUaGlzIGlzIGFscmVhZHkg
dGhlIGNhc2UgZm9yIHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIG9mDQo+IEtWTV9HRVRfU1VQ
UE9SVEVEX0NQVUlELg0KPiANCg0KZmFpciBlbm91Z2guDQo=
