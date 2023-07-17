Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824A2755BC5
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 08:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjGQGgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 02:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjGQGf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 02:35:57 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0C7E9;
        Sun, 16 Jul 2023 23:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689575756; x=1721111756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zquaZ18KxVBj1ekKnvFAxIJjfrNAKpoCXX7a/6NuXj8=;
  b=PXI63xFdsNrTMLJEr0nB0cTUg6j9zhOL7tKdeyOuPsbqAqeSj9F5KOv7
   D3luVZC3Fmmbv2cvnAYSUtbiPSTY3CovYD6SsVjcb0+hnmUHIEXkap9AO
   wmIJsAoPTteXBYizAXuoBZuY88S6ZBW2xZ3P2eU9fYXDkxvmRwx+hpNHF
   jWKQgngIFADpE+KcuPMxoDCYGd2kkajsSaXOcaVBKYFtLmPME206M5451
   /04aQcM3cRzxcOOZUqFVnXdx2iI2mS2YNmwWB1V1IXBusWpriB7FnqBc1
   RYxfnyhtXhUhNlZwybhABVmguZNcbWQtv7Xqo0QUfkalmiM4NSgwfAsEU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="355792697"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="355792697"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2023 23:35:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="969753768"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="969753768"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jul 2023 23:35:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 16 Jul 2023 23:35:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 16 Jul 2023 23:35:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 16 Jul 2023 23:35:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqvchFGSWQuxsGxPV0wQQ5ifVlaBA5DKiOVNNqOeHZN0ebjCtTlQbOrvdJHxhfe6EGH/t3K/IPgurUs6GcinckKe1GjBqWR+vvI+EmcBw7h+SZzRypmmtENVIUhawrRUrPnkhkWp7zuzFbw2n2+dESoasEVh7Blt9+WxlZ1MvzWixB3PdVhr1gt61tvIsy5stDCwKAeGq5jl2Tz+RmA31YeIhcc65ANTenoYdYrZl6Bcz8by4MaoZ1u/k52vVq+dJ+PdgyQPWLkGuFVNkfPcttlUhjemxvoU6zefskB4DI63WS0LsUxxfkKYPjzSThYDTLwWriO6B8S66MxCsJn/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zquaZ18KxVBj1ekKnvFAxIJjfrNAKpoCXX7a/6NuXj8=;
 b=IzZsUuHBfyLqcT76lXrfra1NlIqmMoF16KAH8eT4CXsGM0f1GDJB+3Do4Zg4gAmzfdiCxgsDxeXe+hG/+/U0+XdqQcjZMIKobakkzZyZdYDvTseyBADfaDBRCFFrW/dVPAe1tWYbwZirSkKtXcFb6t/Ik+T11yEuhTmka3U8Za+6qJSt0cm35uXOFWMipdhm/PWsJfGlbSQoEcrlmW6ApyCqGlOGG81xGku4HzIsBmZAdY2TAAeiqf3UYStK1J/FtOyYzCIWlV6Aa7bgqQuqPNwbg3pTTq/QhD6d2K7aqdeEE32xV6ktW3NSz+gfaxwDJTwc9qB0dEFH66jW+MtphQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6129.namprd11.prod.outlook.com (2603:10b6:a03:488::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 06:35:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 06:35:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL
 assembly
Thread-Topic: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL
 assembly
Thread-Index: AQHZtJ1x/DXmlypIv0ScbAwPZVWO1q+6np8AgALp8gA=
Date:   Mon, 17 Jul 2023 06:35:40 +0000
Message-ID: <71396c8928a5596be70482a467e9ba612286d659.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <c22a4697cfe90ab4e1de18d27aa48ea2152dbcfa.1689151537.git.kai.huang@intel.com>
         <b95c4169-88c8-219e-87b7-6c4e058c246a@suse.com>
In-Reply-To: <b95c4169-88c8-219e-87b7-6c4e058c246a@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6129:EE_
x-ms-office365-filtering-correlation-id: d5fdbb14-4d9d-4545-7000-08db86900a03
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ObMsTqpwUKU8d7mpPQD4LydBiGl8lU7KJUO7xB0xJIN1yaUPUWbOKCsEg2JRcNIrfRh+b8Gc6V6Ex5jZZQQeZU6Lk1sI45H7ufO7L3yM8Mp3GUckEF0NZ0UAs19m6Wsc/U8VUG2YwLMeFKElOFQlD2UP0qRNuCiuPOTNPM6tjaHRfSUh1VGPplFmggcFqQsK35RAC6ipZCd1G6mYK8pk9VTvQdt4G514nqUl+vIalb2nsVcCzLunNYvB5WCqcqb3nyklw5yNoR2xRROqFtQk/GXitwVc2wiOVFJ2YLZ/6H/fijRLL2EQPNnUryYdlcmX6yg+ibtphKi0FajAcfd1y0JLfZss/7ULxoN+CzqwbIvTHTcpSckM24geki9pRsBpfAANkCssOK+WghQ25FAf7ml6bDwZtFijcJ4tMCkiyVXozWytKZevN8uN4QCBFOSfjFWEvL6DWMpE4rss4WlXAcuCUkqZcyjqC4YAXfBFqdtLSTAXy1CzRHvwrnmRe3POvVjuML61yHNxJafGDLDGqac1GMf3ILnGM2IdCpNfTZ4e13yHnlFvO/fJ0EJgWn12Mb1K4lc4fua/fBkIDvHPfM7IZbVqqVHbmLAkL583L01dKHXl7E+JjYXid1v6Twr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(122000001)(110136005)(54906003)(82960400001)(38100700002)(6486002)(478600001)(71200400001)(41300700001)(8676002)(5660300002)(8936002)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(91956017)(76116006)(316002)(2616005)(186003)(83380400001)(6512007)(6506007)(26005)(86362001)(36756003)(38070700005)(7416002)(2906002)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFNRNGJ1ME1HK3pqbGxwWjh3Qm9wMngrVnpPRC9pSFhOUkh3eEl4dFowZi9Y?=
 =?utf-8?B?U2doYU15VTVNM1dYMjNEN3JwWGwvZmNSQWNubUJLaVVLcEZmUzYyNkdVME9h?=
 =?utf-8?B?bVlhQ3FHWnkzQThCMlBzK0loRXpDWkRHc3ZsV041cm0vUDlJazVSYW5NL2U2?=
 =?utf-8?B?VmRuT2xYRmJ5VmsxWE9Ma0pEMGNuM1hqNXNhS0ozN0xaOGJhL1NKUHM0cU5X?=
 =?utf-8?B?VFFhNGp0ZktaWGpobXZEV0NvdWpSeEV2NUV3NExXZldyU2JzcCs2Qzh2elEw?=
 =?utf-8?B?TWxDcWR2eFFUdzdWc25TZThwdElvZVhVS3RWV2dIaUZFZ1ZjL1VGb2p0N3pC?=
 =?utf-8?B?c0N0MlBhY3VjNzJ2anpQRG1VMWp6NlE4VFVycmJaTlJKVkdBemNwL1dScldq?=
 =?utf-8?B?OWNnZjVIZU0wN0pQd2c1aWpaOWFTUit2dk1aUWVWc1FLK1hPNkxrUkM2L3Zz?=
 =?utf-8?B?bkRPS3h5QXpLUGpOMHBtVDhma2F2cm5qVW9nT1duWXZUMHR2OHRwekRMVGRx?=
 =?utf-8?B?N0lKc25YOGszNythNklkRUlVM2xDYW1sK2Izd0JkYlBadW9UcXp1VUJ4RWVP?=
 =?utf-8?B?amRhcmZ0YndWekM4ZjhyMWVIVG1TRk53RVFvNUJRRUZQWGVsR3ZqZUVQQURV?=
 =?utf-8?B?VHVqdE5NNnFBUUpiaFlodVlQZWNFZzlGSVdsUktsK0lzWXZWbkxMUEs3QnBM?=
 =?utf-8?B?OHFkYkg3VVRpQVZncmloOEtTZytQMHdJcFZ4UEdBMklKTHJTTVM5T1NycUNI?=
 =?utf-8?B?MFVIbEhpVWpKODgzbDI2cXc2aE1xSGRiMHYwNGdSTGc4R1BIYmVXdDVrdWd3?=
 =?utf-8?B?Uk9FWVVjcktzMDhrOFJhNjlYdDBMdWRuTE9yWVI2T0RMWnQxQXgvb3l1d253?=
 =?utf-8?B?RGM5SkxEUTdGT1pia3BuMFpkOHIzanZyOUVvQWowMGlMakR0eTdEUXJGQlA4?=
 =?utf-8?B?aUM0Q0l5dDVFanhEZmljVitrUVNnZVBpbTU3dTA1K29ad0VoMVhCQ2J6blhj?=
 =?utf-8?B?T1lxYXYwNTBkakZZS3VNTHN5ay9TaVVERHBFNXo0c3lIQmVrNktUc0RwN0dH?=
 =?utf-8?B?WHlVS1YxenFES1BsZzV2M28wb3dyQUIrVG5QamllQTdQUGtBOFhqdjdxMTNH?=
 =?utf-8?B?aWNaUXRsMEtMaks2bWZqREIyWFgrN2VYVnZ5SllBallzWUU2WTU0U0pVNkJq?=
 =?utf-8?B?NExRRGN3ZStBeWxPSDY2d3gycEJtcmFrZHZYYUFKWUM5Mnp0UzU2bUNGeXg0?=
 =?utf-8?B?V3NFMDRhNDF6L2xGUHp1VExaMUVhcWc5MG14RlhlZzJlQUZBWkZheTNqalVJ?=
 =?utf-8?B?NStoaHRYcFZnWTlWVy9BblovUDlGTEtGQ2FUN0xjSFBPZkthUXBob0pFVEwz?=
 =?utf-8?B?eWNmaTl5blpkNlp1eTdiTmpFKzNNSGhETk00SXZUSUNWK2EvRS9EOVQxSlFr?=
 =?utf-8?B?VGtQcjlJZk9MdzVybllHa3RjMlJ0TFQrbGZBUDU2aU0wQWgxcFVzOFQyVjNH?=
 =?utf-8?B?QUNrM1JYL2tNYklMQ0tHK2hEOVJUUW9sTGVKM3UvZVFhQ1RPR0ZyTVk1MjZZ?=
 =?utf-8?B?U3FzYUY1VGdscnJ5Z3c2MC9rUVNQNk9McFZFVVo2cTNzTVh1M1RyakExdTZO?=
 =?utf-8?B?M0ZERmhMYWhEeEUzU25tTkgwWGd3d2t6ZWF2cVhQZ1YxazFobmJqWW9mK3hI?=
 =?utf-8?B?NFV3RGFycUlJWlAraVJKNldFU0ZTRW1hd1pET2lZWnd1dTNiUFo0LzhCZFJE?=
 =?utf-8?B?cVVoY0xnVFZ1ZlBRM3R5RVJUV1JPb1FkMzc0RVpIbld1R0hlSnlsbjNjUDYv?=
 =?utf-8?B?T09WZ0VkNHROUGtTQldCTTdweGNOempLVzc3dVFicWxHZlg3Z1d5d0lmc0py?=
 =?utf-8?B?WHQxOVlWU3FxZVJTU0lObzYxSlZFb0xpdHlKcVNCa2ZGNjV0WHlQLzlnaWNs?=
 =?utf-8?B?MnhwQTVpZG8zME9ZUkpHMm56Z00vSFdVMS8xMmNQdEpZamF2YzJkdWV5ZFls?=
 =?utf-8?B?bFNsQzBSZ1AzSGN4ak80TVZkVWl6OXU5Q2ZJR0VUWkhVVnpGcTN6OVZRV0ls?=
 =?utf-8?B?SFU4cjl1dHo1MWpDbnF1dmdnaFZ2NytLTEVZSnpLTGxHK21UcVI4VXBGK0tU?=
 =?utf-8?Q?p6SdbMHsDVhaWoNegq91WLYJu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <488378831795D142989CC13222F13C59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5fdbb14-4d9d-4545-7000-08db86900a03
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 06:35:40.3965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4WpNvBoRr9YsVDtAhqXC/JM4HbXz39AWZGn642o/Bmm7q2At0O9YlsQ7TXLtRWrV/GKGGJYCuQeNNRmQDDCiCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6129
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gKy8qIENhbGxlZCBmcm9tIF9fdGR4X2h5cGVyY2FsbCgpIGZvciB1bnJlY292ZXJhYmxl
IGZhaWx1cmUgKi8NCj4gPiArc3RhdGljIG5vaW5zdHIgdm9pZCBfX3RkeF9oeXBlcmNhbGxfZmFp
bGVkKHZvaWQpDQo+ID4gK3sNCj4gPiArCWluc3RydW1lbnRhdGlvbl9iZWdpbigpOw0KPiA+ICsJ
cGFuaWMoIlREVk1DQUxMIGZhaWxlZC4gVERYIG1vZHVsZSBidWc/Iik7DQo+ID4gK30NCj4gDQo+
IFNvIHdoYXQncyB0aGUgZGVhbCB3aXRoIHRoaXMgaW5zdHJ1bWVudGF0aW9uIGhlcmUuIFRoZSBp
bnN0cnVjdGlvbiBpcyANCj4gbm9pbnN0ciwgc28geW91IHdhbnQgdG8gbWFrZSBqdXN0IHRoZSBw
YW5pYyBjYWxsIGl0c2VsZiBpbnN0cnVtZW50YWJsZT8sIA0KPiBpZiBzbyB3aGVyZSdzIHRoZSBp
bnN0cnVtZW50YXRpb25fZW5kKCkgY2FsOz9ObyBpbnN0cnVtZW50YXRpb25fZW5kKCkgDQo+IGNh
bGwuIEFjdHVhbGx5IGlzIHRoaXMgY29tcGxleGl0eSByZWFsbHkgd29ydGggaXQgZm9yIHRoZSBm
YWlsdXJlIGNhc2U/DQo+IA0KPiBBRkFJQ1MgdGhlcmUgaXMgYSBzaW5nbGUgY2FsbCBzaXRlIGZv
ciBfX3RkeF9oeXBlcmNhbGxfZmFpbGVkIHNvIHdoeSANCj4gbm9vdCBjYWxsIHBhbmljKCkgZGly
ZWN0bHkgPw0KDQpXL28gdGhpcyBwYXRjaCwgdGhlIF9fdGR4X2h5cGVyY2FsbF9mYWlsZWQoKSBp
cyBjYWxsZWQgZnJvbSB0aGUgVERYX0hZUEVSQ0FMTA0KYXNzZW1ibHksIHdoaWNoIGlzIGluIC5u
b2luc3RyLnRleHQsIGFuZCAnaW5zdHJ1bWVudGF0aW9uX2JlZ2luKCknIHdhcyBuZWVkZWQgdG8N
CmF2b2lkIHRoZSBidWlsZCB3YXJuaW5nIEkgc3VwcG9zZS4NCg0KSG93ZXZlciBub3cgd2l0aCB0
aGlzIHBhdGNoIF9fdGR4X2h5cGVyY2FsbF9mYWlsZWQoKSBpcyBjYWxsZWQgZnJvbQ0KX190ZHhf
aHlwZXJjYWxsKCkgd2hpY2ggaXMgYSBDIGZ1bmN0aW9uIHcvbyAnbm9pbnN0cicgYW5ub3RhdGlv
biwgdGh1cyBJIGJlbGlldmUNCmluc3RydW1lbnRhdGlvbl9iZWdpbigpIGFuZCAnbm9pbnN0cicg
YW5ub3RhdGlvbiBhcmUgbm90IG5lZWRlZCBhbnltb3JlLg0KDQpJIGRpZG4ndCBub3RpY2UgdGhp
cyB3aGlsZSBtb3ZpbmcgdGhpcyBmdW5jdGlvbiBhcm91bmQgYW5kIG15IGtlcm5lbCBidWlsZCB0
ZXN0DQpkaWRuJ3Qgd2FybiBtZSBhYm91dCB0aGlzLiAgSSdsbCBjaGFuZ2UgaW4gbmV4dCB2ZXJz
aW9uLg0KDQpJbiBmYWN0LCBwZXJoYXBzIHRoaXMgcGF0Y2ggcGVyaGFwcyBpcyB0b28gYmlnIGZv
ciByZXZpZXcuICBJIHdpbGwgYWxzbyB0cnkgdG8NCnNwbGl0IGl0IHRvIHNtYWxsZXIgb25lcy4N
Cg0KPiANCj4gPiArDQo+ID4gK3N0YXRpYyBpbmxpbmUgdTY0IF9fdGR4X2h5cGVyY2FsbChzdHJ1
Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKQ0KPiA+ICt7DQo+ID4gKwl1NjQgcmV0Ow0KPiA+ICsN
Cj4gPiArCWFyZ3MtPnJjeCA9IFREVk1DQUxMX0VYUE9TRV9SRUdTX01BU0s7DQo+ID4gKwlyZXQg
PSBfX3RkY2FsbF9zYXZlZF9yZXQoVERHX1ZQX1ZNQ0FMTCwgYXJncyk7DQo+ID4gKw0KPiA+ICsJ
LyoNCj4gPiArCSAqIFJBWCE9MCBpbmRpY2F0ZXMgYSBmYWlsdXJlIG9mIHRoZSBURFZNQ0FMTCBt
ZWNoYW5pc20gaXRzZWxmIGFuZCB0aGF0DQo+IA0KPiBuaXQ6IFdoeSBtZW50aW9uIHRoZSByZWdp
c3RlciBleHBsaWNpdGx5LCBqdXN0IHNheSB0aGF0IGlmIA0KPiBfX3RkY2FsbF9zYXZlZF9yZXQg
cmV0dXJucyBub24temVybyAuLi4uDQoNCk9LIHdpbGwgZG8uICBJIGJhc2ljYWxseSBtb3ZlZCB0
aGUgY29tbWVudCBmcm9tIGFzc2VtYmx5IHRvIGhlcmUuDQoNCg0KDQo=
