Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEFC79DFA4
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 08:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjIMGA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 02:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbjIMGAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 02:00:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB3C172D
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 23:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694584851; x=1726120851;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RcyDNRVelGP7OhgQMGCTiCod2lPx2skoRue52YQgXN0=;
  b=iszms2zf0zZSu+M+tUSUta+4egnIloIOXb7rQHmoNg+08T1ISllk43zD
   Zh1ctOsexAS7hmjeIIruy8ccjxy8VdqWiuUIYtlMzZYPt1vMEB4x3AkOz
   Rp9Rlpl8drwI/dZnv1w/016edGRyfl13UtW8KJPja/7TeZ180auePC91i
   UU7Vvu09jXLo5yOxPXm1n4i/etxAt9aM4+LDsMN9I/DjniJaqCmHGUIiC
   livRSVVNO69wwz3cRkmo50+zCH/gM3TjXnQtFm8vvz5fxpeYxA8IXXzZq
   KkITjMP5TSuM+Vwj/rVYSddLRIMLMN9aJkHZC0OWUcoM9Q+fbab0E8Jk6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="445011637"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="445011637"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 23:00:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="779075368"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="779075368"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2023 23:00:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 23:00:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 12 Sep 2023 23:00:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 12 Sep 2023 23:00:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcKPqAEL82h5c9jnbnHqY96akJpNtsr+7p1DkGU6Je4pH2qHawVQiGcbd3g9RhkLotMK2juk9NKXXkP3LYRTA9x1rKA2GCHYaINNwQH1xR+KVdG2saaGv/TfzQa5X6XZe4hrf/YFrTHqdUQR39Va48sh3FFLO6nztSOn7TyOTM6t56WqH8hGUhIG0P/R/Uy+8Y0wliOHPInx6NZ4nm0tFOVXmshqMgrxgLt8GirqE81imgxxsVHc0kICTaChb7yAEdAWIkQJfyeRXMt3J0yuVnr7JUEeQEkcUc5MeiPVB8KOkDtBczIyoBQvheQCcZ0+iqAfZwwMgEjxaB/WU+KxGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcyDNRVelGP7OhgQMGCTiCod2lPx2skoRue52YQgXN0=;
 b=PBatD0yNHNG9iN9yHGcbAez0d98AJxbVg7wc8JeBRMyZG8vPIA67gjysLgyvgTd0mGliIqlF+Ur9vDHtYrPyTaJQ6djwPB8pH7AUiVXKzx3MF/12UBRFigU8J0RL8xctXZojQ+EEMOVj+dVqJ8jnWnOtGxedloFUTC7wFOgmXJb3zTzHK18GT2S5tpUUflITjti13a5QLteObEqRg9udn1belUGNKOB9DqnjfsI4Q5seFDmKacHRdbHlh0ydtfRQmEZ6xgysfB8BgtVkCsbZhdgbQ+V9j2kn25Xnfm5Cgv33ixPJgfWw8XkhJ/WkuTE8BXYBEhhMtdvSES/FsalEgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by MW4PR11MB7079.namprd11.prod.outlook.com (2603:10b6:303:22b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Wed, 13 Sep
 2023 06:00:40 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032%7]) with mapi id 15.20.6768.029; Wed, 13 Sep 2023
 06:00:40 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/9] KVM: x86/PMU: Don't release vLBR caused by PMI
Thread-Topic: [PATCH 1/9] KVM: x86/PMU: Don't release vLBR caused by PMI
Thread-Index: AQHZ3KYHHDbqA5M9vkOEvoDuoqulHbAXJpOAgAEjESA=
Date:   Wed, 13 Sep 2023 06:00:40 +0000
Message-ID: <MW4PR11MB582426159CA155A7655C3C8EBBF0A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-2-xiong.y.zhang@intel.com>
 <af7c3bae-d63c-1a11-e5ba-588c0dcd3368@gmail.com>
In-Reply-To: <af7c3bae-d63c-1a11-e5ba-588c0dcd3368@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|MW4PR11MB7079:EE_
x-ms-office365-filtering-correlation-id: 30fafaef-16cc-4a07-6af9-08dbb41ec236
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B9i7cxAeeYixmXnpq3C3GsGVEBXbkjbPZaWvQjtrp4TjpOoVUGwpFsjr90z7CsmKFs0w9yh07nQ4meEl0BHwkOivz2iK1Jv7thjdCUAgMJQADktSRJtSFS+eaPmlG1YIHZ+WlOXtJzUCsrAgyJdrVZhfZH8ipSSNPQEyUtMcCnrc9TcCAKEmBxBBokdkS+UgYaVI5sG7xYPc+6gsL4xhdsHsz2WKdHq5zXXXFyM0cPeQUdaQxzNlpzqC43SaRG8AxIu4d9idY6959p2v7z4uwVzWPqwEsWgjXsnUrwpNwn6BIKbcbAe6Z19/ih+1SOf7Miz5OyhTvgdPXMyXbt6hr92GBkKvyDq67pO9hCfNgKnkhGoz8H9PDZGLl/UYg8pVsfi1JLVr4xzDzaXcycmVx/ER9zDwLy46LQdAcDzR8YwJjL7AE8F5JnwZqgoWeRdX3FVCNJC8ZuOlVgqGNMGDz38tPFDzfZ/ZzWTCqd7/S+UknS05qdUUfT84p9d+hA0MZnX/X6nucSZgABE8paAAZtk4uXWN9zN3JaHQr92PC2pz4KumSQ2S88YYCcwX9c4laeHcv8y1r/wC4cHeqNcBTsXRXhO0/tgMlNX6vYIGBgo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(376002)(346002)(39860400002)(186009)(1800799009)(451199024)(966005)(7696005)(53546011)(71200400001)(6506007)(9686003)(66476007)(66556008)(83380400001)(26005)(52536014)(41300700001)(8676002)(64756008)(54906003)(316002)(2906002)(76116006)(66446008)(8936002)(4326008)(66946007)(86362001)(55016003)(38070700005)(478600001)(82960400001)(38100700002)(6916009)(33656002)(5660300002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFJ6MEU3bitaTUowZjB0aGEzcXZ4ZzBZRFdka254bmg3Ry9BZk54L21wN0VF?=
 =?utf-8?B?d3FOdkQ0ZXVsTE1ueUVxQnlONmFUQmZDK3dYMHBVUXl2ZWlXdGNSaVlGYzJr?=
 =?utf-8?B?cmxMcXpQSDFkRm9SaHpXTXpOQk0yWFAxOXEwbHROSWFzQ3IxSURmVktJS1RZ?=
 =?utf-8?B?d1JwUjVSU3pLNWo5UHZZdmhCTHFOalNxZnN6R2haTGw2NEFqLzBHaWM1WG5W?=
 =?utf-8?B?Yk1sRlQ2STJGSy9mcVlKeWJNVFozZFFHYy9KQ3JwbURBODV6WjVqQWU1NERN?=
 =?utf-8?B?dXpJd2hnajMzNDhDWnAxSzJFZGI5OVNrUlBoQ2JBUzNlTy9NSTM0T3hjS2dN?=
 =?utf-8?B?Y1NkY3I3dHRSaFgvTmk3SUh6ZVZYMi9lOXZyeXZ6bFV6ZUdqNEcrelNoTS9m?=
 =?utf-8?B?Q3lGaWJ6WCt5NDVqa1hjU2xMSzRra0ZqcjdsaDJvVkdxOVhiQmU4NFRwNFpI?=
 =?utf-8?B?VjlraE1FZEc4OXc5ZnhiV0Q2RVVYelcwZzlLZHYyV1MvYzhWeHdXMEZXWnh4?=
 =?utf-8?B?UWEwcjRsWk9CaDh6TGxNTEJwZ0ZRS1MwUzNhaEFuRWx5TzM4L1RRYWtNZTFa?=
 =?utf-8?B?Wi9xRjF5WHZoakNpYUxEQzdsallnSlhSV1BYVVdiM0dCN3Y0NURRcFc3TWVV?=
 =?utf-8?B?ODZqZmZqNkcxam5qYXBtVk4rQjZnNXo3dXFveHpNSlVQYVl2SFltdjBTN0Nh?=
 =?utf-8?B?eERLNUZzN0xhTlRyQytEeVo5TTNjc2k5a0twSVFmQzVQMVg5SVFGSWthK2hB?=
 =?utf-8?B?d1JHNUlXRGhMREs0ODQ5a2hCaWtkVGxvMzUvNGVFNFhqUUdsQ3B6dyt5c3lH?=
 =?utf-8?B?c2poTUttb0VZUU1tSGdaSnJtTUxNbjVybFdkeDQ0MXc3elZJYUUzS2d4MGtY?=
 =?utf-8?B?Z3IxajlzK3dIcHYvaEZLVERNYktRK3U5TkhCbW1ORXljQmFhblhOT2o5UGJG?=
 =?utf-8?B?OEFCTnFGRDZPWElPbkR0dThDZGpCU1dKUnpaS3JtMzhiVlBXOG1uY3J1NU1h?=
 =?utf-8?B?ZE4zSEJGNUJobUxHd1R3Q2VXbDhFWERTV2FzWFJLc2VqNUdYd2owYWlTcnlu?=
 =?utf-8?B?eVBSdnJFSHNPbTlKczN2ODRyb0pPWm50QjJpcjA2aVZ4ZEtXUlNEcGZuMUc4?=
 =?utf-8?B?bndndC9Lci94Q0tqQ0F2RzUzVjhnM1NDOFh6M3QzbklDSkVJWHJSMGZSdWp5?=
 =?utf-8?B?M0YyNTlDMXpUZVZLSjRLSlJQeGFCeEE0M2RNQS9XY1ZKcjAzdHdRREdha1RC?=
 =?utf-8?B?OWR1cmN3T2UyQnJyY2RiZlRWVEpTbE5UeTl3THU2N1A2dGJmbjhXV0RzN1lD?=
 =?utf-8?B?WUpETEwzd0JJT01Tbi9CZUEzZGRsRzRUMjFkSlZ3ek1jTWJyM0NBZDFCVm9K?=
 =?utf-8?B?S3IzTzUzSXl5Y0NSdk1iMnd4Q0JhWGdvYVV1RzdDUll3QytPTC82cVhZQ3NZ?=
 =?utf-8?B?YWJmdGxNYUQ1SHh4NGVneGJXNUU5ZFlxMTYyS3I1NUpOT0N0VldaZGVJMFpM?=
 =?utf-8?B?ZVhCZlhNU1MraVc0UG9tUEJVallNSUdGZ0dYNk5hT1hSVmJZQmJZZzBjM3Aw?=
 =?utf-8?B?VWRzNnE3T0JkbDBUMG1lTXpEeWxwRnlueVo3Mmp1Q1JtKzF4ZkRabU5UaEsr?=
 =?utf-8?B?R3Q3Q1dyYjI4S0pSbXVWOWhINk9VeU1wT2dOVnE2blh3OXRWVVI0dGYrYmRr?=
 =?utf-8?B?LzQ4Zk15ZHBNaTJIbWlSY2hRQk1vQnQwZzZvUlFNOVROSjVWcmNJaGgwS2Rt?=
 =?utf-8?B?SWFvalJndkVJMDRqMHZVWjBvaVRCRTI3QVltN0kzSXRxaVV5VDFkU0JEY2g4?=
 =?utf-8?B?MlBENEpRU0Q5Q3R1SWF1TEh2cmVkMlFtOHdVcXlkZ1BxMm9qbTBmd0F4ejgv?=
 =?utf-8?B?SVNyMGdYY2FwMkZCTHhOdnZzRTYvRTNLQmNIZDZtWS90aWh1dGxyeURaTDFu?=
 =?utf-8?B?VGFKTDkwblVhZWpmY2l0ZFp6WFM5RHZ1dmU3Y1NlRS9oWFJKN0hTdllKVlJW?=
 =?utf-8?B?ejh6MVF5am5XV25XNy9aNlRkcmo3OHJsRXJqMUhGMFhMbmdEQ284K0ttbllw?=
 =?utf-8?B?dXZZNG80YnczUzZISkY3bjluZG8rOFY3V0V1dE9iOTVYVDMzT1VvZjJzdTNm?=
 =?utf-8?Q?MAZdY3slw8k8UszheBL7bvokB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30fafaef-16cc-4a07-6af9-08dbb41ec236
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2023 06:00:40.2951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PFflfjJVc7c6V1ou+uDcavEnG/zpPVjR2Z0YfmEZS8tgysh1H8tgkdRc/1UqhbtEyB0K1XAPJJL5FH/Vrm52VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7079
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAxLzkvMjAyMyAzOjI4IHBtLCBYaW9uZyBaaGFuZyB3cm90ZToNCj4gPiB2TEJSIGV2ZW50
IHdpbGwgYmUgcmVsZWFzZWQgYXQgdmNwdSBzY2hlZC1pbiB0aW1lIGlmIExCUl9FTiBiaXQgaXMg
bm90DQo+ID4gc2V0IGluIEdVRVNUX0lBMzJfREVCVUdDVEwgVk1DUyBmaWVsZCwgdGhpcyBiaXQg
aXMgY2xlYXJlZCBpbiB0d28gY2FzZXM6DQo+ID4gMS4gZ3Vlc3QgZGlzYWJsZSBMQlIgdGhyb3Vn
aCBXUk1TUg0KPiA+IDIuIEtWTSBkaXNhYmxlIExCUiBhdCBQTUkgaW5qZWN0aW9uIHRvIGVtdWxh
dGUgZ3Vlc3QgRlJFRVpFX0xCUl9PTl9QTUkuDQo+ID4NCj4gPiBUaGUgZmlyc3QgY2FzZSBpcyBn
dWVzdCBMQlIgd29uJ3QgYmUgdXNlZCBhbnltb3JlIGFuZCB2TEJSIGV2ZW50IGNhbg0KPiA+IGJl
IHJlbGVhc2VkLCBidXQgZ3Vlc3QgTEJSIGlzIHN0aWxsIGJlIHVzZWQgaW4gdGhlIHNlY29uZCBj
YXNlLCB2TEJSDQo+ID4gZXZlbnQgY2FuIG5vdCBiZSByZWxlYXNlZC4NCj4gPg0KPiA+IENvbnNp
ZGVyaW5nIHRoaXMgc2VyaWFsOg0KPiA+IDEuIHZQTUMgb3ZlcmZsb3csIEtWTSBpbmplY3RzIHZQ
TUkgYW5kIGNsZWFycyBndWVzdCBMQlJfRU4gMi4gZ3Vlc3QNCj4gPiBoYW5kbGVzIFBNSSwgYW5k
IHJlYWRzIExCUiByZWNvcmRzLg0KPiA+IDMuIHZDUFUgaXMgc2NoZWQtb3V0LCBsYXRlciBzY2hl
ZC1pbiwgdkxCUiBldmVudCBpcyByZWxlYXNlZC4NCj4gDQo+IFRoaXMgaGFzIG5vdGhpbmcgdG8g
ZG8gd2l0aCB2UE1JLiBJZiBndWVzdCBsYnIgaXMgZGlzYWJsZWQgYW5kIHRoZSBndWVzdCBMQlIg
ZHJpdmVyDQo+IGRvZXNuJ3QgcmVhZCBpdCBiZWZvcmUgdGhlIEtWTSB2TEJSIGV2ZW50IGlzIHJl
bGVhc2VkICh0eXBpY2FsbHkgYWZ0ZXIgdHdvIHNjaGVkDQo+IHNsaWNlcyksIHRoYXQgcGFydCBv
ZiB0aGUgTEJSIHJlY29yZHMgYXJlIGxvc3QgaW4gdGVybXMgb2YgZGVzaWduLiBXaGF0IGlzIG5l
ZWRlZA0KPiBoZXJlIGlzIGEgZ2VuZXJpYyBLVk0gbWVjaGFuaXNtIHRvIGNsb3NlIHRoaXMgZ2Fw
Lg0KUE1JIGhhbmRsZXIgd2lsbCByZWFkIExCUiByZWNvcmRzLCBzbyBpdCBpcyBlYXNpZXIgdG8g
ZmluZCB0aGlzIGlzc3VlIHdpdGggdlBNSS4NCkFjdHVhbGx5IEkgZm91bmQgdGhpcyBpc3N1ZSB3
aXRoIHRoaXMgdGVzdCAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjMwOTAxMDc0MDUy
LjY0MDI5Ni0zLXhpb25nLnkuemhhbmdAaW50ZWwuY29tL1QvI3UuDQpJbmRlZWQgaXQgY2FuIGJl
IGV4dGVuZGVkIHRvIGdlbmVyaWMgY2FzZSBhcyB5b3Ugc2FpZCwgaW4gb3JkZXIgdG8gZml4IHRo
aXMgZ2FwLCBteSByb3VnaCBpZGVhIGlzOg0KMS4gZmluZCBhIHBvaW50IHRvIHNhdmUgTEJSIHNu
YXBzaG90LCB3aGVyZSA/Pz8/ICBpdCBpcyB0b28gaGVhdnkgd2hlbiBndWVzdCBkaXNhYmxlIExC
UiwgaXQgaXMgdG9vIGxhdGUgd2hlbiB2Y3B1IHNjaGVkLW91dC4NCjIuIEJlZm9yZSBndWVzdCBl
bmFibGUgTEJSLCBrdm0gcmV0dXJuIExCUiBzbmFwc2hvdCB3aGVuIGd1ZXN0IHJlYWQgTEJSIHJl
Y29yZHMNCjMuIFdoZW4gZ3Vlc3QgZW5hYmxlIExCUiwga3ZtIGNyZWF0ZSB2TEJSIGFuZCByZXN0
b3JlIHNuYXBzaG90IChtYXliZSB0aGlzIHJlc3RvcmUgaXNuJ3QgbmVlZGVkKS4NCkFzIExCUiBt
c3JzIG51bWJlciBpcyBiaWcsIHRoaXMgd2lsbCBtYWtlIHZMQlIgb3ZlcmhlYWQgYmlnZ2VyLg0K
DQpBbnl3YXksIGFzIHZQTUkgbWF5IGJlIGZyZXF1ZW50LCB0aGlzIGNvbW1pdCBjb3VsZCByZWR1
Y2UgdGhlIG51bWJlciBvZiB2TEJSIHJlbGVhc2UgYW5kIGNyZWF0aW9uLCBzbyBpdCBpcyBzdGls
bCBuZWVkZWQuIA0KPiANCj4gPiA0LiBHdWVzdCBjb250aW51ZSByZWFkaW5nIExCUiByZWNvcmRz
LCBLVk0gY3JlYXRlcyB2TEJSIGV2ZW50IGFnYWluLA0KPiA+IHRoZSB2TEJSIGV2ZW50IGlzIHRo
ZSBvbmx5IExCUiB1c2VyIG9uIGhvc3Qgbm93LCBob3N0IFBNVSBkcml2ZXIgd2lsbA0KPiA+IHJl
c2V0IEhXIExCUiBmYWNpbGl0eSBhdCB2TEJSIGNyZWF0YWlvbi4NCj4gPiA1LiBHdWVzdCBnZXRz
IHRoZSByZW1haW4gTEJSIHJlY29yZHMgd2l0aCByZXNldCBzdGF0ZS4NCj4gPiBUaGlzIGlzIGNv
bmZsaWN0IHdpdGggRlJFRVpFX0xCUl9PTl9QTUkgbWVhbmluZywgc28gdkxCUiBldmVudCBjYW4g
bm90DQo+ID4gYmUgcmVsZWFzZSBvbiBQTUkuDQo+ID4NCj4gPiBUaGlzIGNvbW1pdCBhZGRzIGEg
ZnJlZXplX29uX3BtaSBmbGFnLCB0aGlzIGZsYWcgaXMgc2V0IGF0IHBtaQ0KPiA+IGluamVjdGlv
biBhbmQgaXMgY2xlYXJlZCB3aGVuIGd1ZXN0IG9wZXJhdGVzIGd1ZXN0IERFQlVHQ1RMX01TUi4g
SWYNCj4gPiB0aGlzIGZsYWcgaXMgdHJ1ZSwgdkxCUiBldmVudCB3aWxsIG5vdCBiZSByZWxlYXNl
ZC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFhpb25nIFpoYW5nIDx4aW9uZy55LnpoYW5nQGlu
dGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGFyY2gveDg2L2t2bS92bXgvcG11X2ludGVsLmMgfCAg
NSArKysrLQ0KPiA+ICAgYXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICB8IDEyICsrKysrKysr
Ky0tLQ0KPiA+ICAgYXJjaC94ODYva3ZtL3ZteC92bXguaCAgICAgICB8ICAzICsrKw0KPiA+ICAg
MyBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+DQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvcG11X2ludGVsLmMNCj4gPiBiL2FyY2gv
eDg2L2t2bS92bXgvcG11X2ludGVsLmMgaW5kZXggZjJlZmEwYmY3YWU4Li4zYTM2YTkxNjM4YzYg
MTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9wbXVfaW50ZWwuYw0KPiA+ICsrKyBi
L2FyY2gveDg2L2t2bS92bXgvcG11X2ludGVsLmMNCj4gPiBAQCAtNjI4LDYgKzYyOCw3IEBAIHN0
YXRpYyB2b2lkIGludGVsX3BtdV9pbml0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiAgIAls
YnJfZGVzYy0+cmVjb3Jkcy5uciA9IDA7DQo+ID4gICAJbGJyX2Rlc2MtPmV2ZW50ID0gTlVMTDsN
Cj4gPiAgIAlsYnJfZGVzYy0+bXNyX3Bhc3N0aHJvdWdoID0gZmFsc2U7DQo+ID4gKwlsYnJfZGVz
Yy0+ZnJlZXplX29uX3BtaSA9IGZhbHNlOw0KPiA+ICAgfQ0KPiA+DQo+ID4gICBzdGF0aWMgdm9p
ZCBpbnRlbF9wbXVfcmVzZXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KSBAQCAtNjcwLDYgKzY3MSw3
DQo+ID4gQEAgc3RhdGljIHZvaWQgaW50ZWxfcG11X2xlZ2FjeV9mcmVlemluZ19sYnJzX29uX3Bt
aShzdHJ1Y3Qga3ZtX3ZjcHUNCj4gKnZjcHUpDQo+ID4gICAJaWYgKGRhdGEgJiBERUJVR0NUTE1T
Ul9GUkVFWkVfTEJSU19PTl9QTUkpIHsNCj4gPiAgIAkJZGF0YSAmPSB+REVCVUdDVExNU1JfTEJS
Ow0KPiA+ICAgCQl2bWNzX3dyaXRlNjQoR1VFU1RfSUEzMl9ERUJVR0NUTCwgZGF0YSk7DQo+ID4g
KwkJdmNwdV90b19sYnJfZGVzYyh2Y3B1KS0+ZnJlZXplX29uX3BtaSA9IHRydWU7DQo+ID4gICAJ
fQ0KPiA+ICAgfQ0KPiA+DQo+ID4gQEAgLTc2MSw3ICs3NjMsOCBAQCB2b2lkIHZteF9wYXNzdGhy
b3VnaF9sYnJfbXNycyhzdHJ1Y3Qga3ZtX3ZjcHUNCj4gPiAqdmNwdSkNCj4gPg0KPiA+ICAgc3Rh
dGljIHZvaWQgaW50ZWxfcG11X2NsZWFudXAoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ICAg
ew0KPiA+IC0JaWYgKCEodm1jc19yZWFkNjQoR1VFU1RfSUEzMl9ERUJVR0NUTCkgJiBERUJVR0NU
TE1TUl9MQlIpKQ0KPiA+ICsJaWYgKCEodm1jc19yZWFkNjQoR1VFU1RfSUEzMl9ERUJVR0NUTCkg
JiBERUJVR0NUTE1TUl9MQlIpICYmDQo+ID4gKwkgICAgIXZjcHVfdG9fbGJyX2Rlc2ModmNwdSkt
PmZyZWV6ZV9vbl9wbWkpDQo+ID4gICAJCWludGVsX3BtdV9yZWxlYXNlX2d1ZXN0X2xicl9ldmVu
dCh2Y3B1KTsNCj4gPiAgIH0NCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14
L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYyBpbmRleA0KPiA+IGU2ODQ5Zjc4MGRiYS4u
MTk5ZDBkYTFkYmVlIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4g
PiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gQEAgLTIyMjMsOSArMjIyMywxNSBA
QCBzdGF0aWMgaW50IHZteF9zZXRfbXNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gc3RydWN0
IG1zcl9kYXRhICptc3JfaW5mbykNCj4gPiAgIAkJCWdldF92bWNzMTIodmNwdSktPmd1ZXN0X2lh
MzJfZGVidWdjdGwgPSBkYXRhOw0KPiA+DQo+ID4gICAJCXZtY3Nfd3JpdGU2NChHVUVTVF9JQTMy
X0RFQlVHQ1RMLCBkYXRhKTsNCj4gPiAtCQlpZiAoaW50ZWxfcG11X2xicl9pc19lbmFibGVkKHZj
cHUpICYmICF0b192bXgodmNwdSktDQo+ID5sYnJfZGVzYy5ldmVudCAmJg0KPiA+IC0JCSAgICAo
ZGF0YSAmIERFQlVHQ1RMTVNSX0xCUikpDQo+ID4gLQkJCWludGVsX3BtdV9jcmVhdGVfZ3Vlc3Rf
bGJyX2V2ZW50KHZjcHUpOw0KPiA+ICsNCj4gPiArCQlpZiAoaW50ZWxfcG11X2xicl9pc19lbmFi
bGVkKHZjcHUpKSB7DQo+ID4gKwkJCXN0cnVjdCBsYnJfZGVzYyAqbGJyX2Rlc2MgPSB2Y3B1X3Rv
X2xicl9kZXNjKHZjcHUpOw0KPiA+ICsNCj4gPiArCQkJbGJyX2Rlc2MtPmZyZWV6ZV9vbl9wbWkg
PSBmYWxzZTsNCj4gPiArCQkJaWYgKCFsYnJfZGVzYy0+ZXZlbnQgJiYgKGRhdGEgJiBERUJVR0NU
TE1TUl9MQlIpKQ0KPiA+ICsJCQkJaW50ZWxfcG11X2NyZWF0ZV9ndWVzdF9sYnJfZXZlbnQodmNw
dSk7DQo+ID4gKwkJfQ0KPiA+ICsNCj4gPiAgIAkJcmV0dXJuIDA7DQo+ID4gICAJfQ0KPiA+ICAg
CWNhc2UgTVNSX0lBMzJfQk5EQ0ZHUzoNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3Zt
eC92bXguaCBiL2FyY2gveDg2L2t2bS92bXgvdm14LmggaW5kZXgNCj4gPiBjMjEzMGQyYzhlMjQu
Ljk3MjljY2ZhNzVhZSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5oDQo+
ID4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguaA0KPiA+IEBAIC0xMDcsNiArMTA3LDkgQEAg
c3RydWN0IGxicl9kZXNjIHsNCj4gPg0KPiA+ICAgCS8qIFRydWUgaWYgTEJScyBhcmUgbWFya2Vk
IGFzIG5vdCBpbnRlcmNlcHRlZCBpbiB0aGUgTVNSIGJpdG1hcCAqLw0KPiA+ICAgCWJvb2wgbXNy
X3Bhc3N0aHJvdWdoOw0KPiA+ICsNCj4gPiArCS8qIFRydWUgaWYgTEJSIGlzIGZyb3plbiBvbiBQ
TUkgKi8NCj4gPiArCWJvb2wgZnJlZXplX29uX3BtaTsNCj4gPiAgIH07DQo+ID4NCj4gPiAgIC8q
DQo=
