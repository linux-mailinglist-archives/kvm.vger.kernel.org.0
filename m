Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AB1723E2F
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbjFFJss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237393AbjFFJs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:48:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1884510C3;
        Tue,  6 Jun 2023 02:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686044893; x=1717580893;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KJCgRzxeyxw6N04wM1IRmpkPmdgmb7A5+BcIK0Jy1tA=;
  b=EtS8QUX8dNkAGOxmh4sQ8ngzeZU01Gc5LMoJrsuGTnL/xEAQwS5x6lE0
   6RTbBMKZV2s7zGsVYf88yCMIlXwBYKD7IjrznuXa58+L+5GnqxRae+t7U
   R+VKMok5Hbb9bgabXmn+VvcIMlheyQfqmxa9ky84nziurBNe8QVxd/CHZ
   3uPPQkLUVHn+81CjOh/5j1pKrlvpQHOz2/jZF8hyPwfwRM4DkpVPseonv
   Z+MIp6ZP0WiNwqo8zMtOd9xbSE3l1J8vXPsPvRTWhbliabpotldXv/H2Z
   uUIXI3STkgG2wUcKvZBiJE1uJq4xKBEmiJYuTugF73q67qGyF0xBTJrIT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="355472943"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="355472943"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:47:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="738719461"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="738719461"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 06 Jun 2023 02:47:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 02:47:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 02:47:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 02:47:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irxOEeOSG+mgr0+td/r9u9CtBV63H+Ib8PQg+kcSwlLTZ4wHlrGxp1n1YAmZKLcQmaJS9/oiey5FT81xDUvN3zoH3Sa0gIEwPwKbHWEA/NLlIuTml14mw+hTCmZTdSolTMcJPrsdg33JR5+S88n8m6hEOOMYe09X6BNUdsYqJ4O0HXj5uyNs6CUVOrSqqEXBOT17CAqydq2z2VdB9PRWF5Sg6r3+wSq/hczWCjh/NbX0rGKiJw8GvewjNbojUmvAyQEFfLBlFJSXdObbvqiM0v9UON6COheyTsr8FH/LQY+WxsTrPEu/tT1k9Y7VCT7e1B6uD2rXIqz976dRp0KXMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJCgRzxeyxw6N04wM1IRmpkPmdgmb7A5+BcIK0Jy1tA=;
 b=MRAwkOEs5vJ/sLutCYFc5/3wZrTDoPJ938h5bXjoW5+rxBy/q1U5/dRDi3brWlSw9KL4iwhrWpiTkF2xLAqbQU4/aHyySOz8kO7P8sDr7a4BmBSF8GWdIdtBK6N2EVesIaOx/7ZEyX4kDXLwE/937oUF6zST9u4RcuUzfDNLX7mpe/7rwRRsD8JzGeHe2mBYbNpiVHOWq9JjD4ASjqKt1a2ZuJtkFp1JgCEEPry4LDu114Hm0Pm9mryokPy/3rG84eP54YcF9PbQLuGpz2BD3vwlPwuy/+3iS85tSt4DkCfbsjhwidbkoOXxaaQ0+KnNs+fg1nGNagwN2bd6pCzlIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:47:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:47:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "zhuangel570@gmail.com" <zhuangel570@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Rongqing" <lirongqing@baidu.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
Thread-Topic: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
Thread-Index: AQHZlO1zKb2hljWx0EKj92isk5YT0693Bv+AgACXgICABe+MgA==
Date:   Tue, 6 Jun 2023 09:47:50 +0000
Message-ID: <18de02cd277646675ff4ee62f7af0f52c13534aa.camel@intel.com>
References: <20230602005859.784190-1-seanjc@google.com>
         <28bd9d11-282f-bb22-66f5-d3d9165d4adf@gmail.com>
         <ZHoGEwFqx3kJrmJe@google.com>
In-Reply-To: <ZHoGEwFqx3kJrmJe@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL3PR11MB6313:EE_
x-ms-office365-filtering-correlation-id: da96682c-d5e0-4850-f767-08db6673176a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2XmYbJMPZumnq7bwdr5eqGgQ566yFH8AOP0/EcKwRZ/DKq2VgE28ZJ6B7F51MR8IhjpTJJ7c3cYve/ClpIGiWvNRWZovy37e6NR6IPMlV5N+K3s5+AwyW9re4kkpqbyr3hNx4n+7qynzyF28QPWfJH9fngUU5GNALv/Gzz+1m0qEWtGq5CnR0sUoslWxowZkgCFsRTvrCND85IsTJeAeOcpTqJeqEgslaNSk26idRFQ1hP3XDtxbC6xBQoqiyeKPayGFLKEujmXd9lNtyNWJn8aBoZI1yt4FVQjQT3I7Bqv22UiFM2Twh0fMT4WtW1tcWZspKyE3EoCn8utqObSgL8BMEoxe7eXcZh8HsuHoBX7xj5PCfLLbLorU5c4OrRA0kSVOtPArbQcWnNL7G4fIonlY9o3Yu+X+Vspu7JhMdF3i6yLWmqT2KNJEyej9mo57pmwRpAobhgKr710964p++oXSo33bR+WqO8SMIDNod0HIBjncuWLkvPv8zlwb5GwpCmVGKFB76dOgaPQm9uxpPpEb4QuUPxKidF2TWQnGXm5mvQphuaYTFyW6lmrSzQSRnRYVfuJT5dVZjz/xP98gjK1X4CxIpIXlPfj1zchy0LPmBjMnnhGGw0k1kjlKIde3SS88NByiKxURPDrrded4ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199021)(54906003)(110136005)(71200400001)(478600001)(8936002)(8676002)(2906002)(36756003)(38070700005)(86362001)(5660300002)(4326008)(64756008)(122000001)(66446008)(76116006)(66556008)(66476007)(91956017)(316002)(66946007)(82960400001)(6506007)(38100700002)(2616005)(41300700001)(53546011)(6512007)(26005)(83380400001)(186003)(6486002)(14583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkVxK1FTNWFpcmYvY1pBTVkxS3JHUnF1VXVFSEk3NXVTREIvUjE1eUZCSndK?=
 =?utf-8?B?SG5SMDFkanRDRFU2SXNZRFlobHJqaERNTWhSTk1Jc3lqU280UVN4UE02ZHBZ?=
 =?utf-8?B?RGw0dFdZcDk2Z05BaDA0Z2djVXJMUmdFa3AvMlFkL29talZGK0ZHZlFQeUdV?=
 =?utf-8?B?dzBFYW0vVE1YY1ZpSXhzaXlUQmJrMEwyOWkxR3JqZG1Kb1FJQWJSMGxsVTVo?=
 =?utf-8?B?V3V6M1V0UkROTTVPWWxCZ1ZkNkJYVC9BSXpmL2hLZG44dDltQ1oxeE9VeWNN?=
 =?utf-8?B?SUtzU1dTM0s0a05rUWJ4My9ZVGNKVFMzVU4rYVphSDM4SU41a2h5NC9oMlNr?=
 =?utf-8?B?Z1FqS0RTYVBnbEQ0UW9hU3lTbUV2QTJiU0N0QWZxL3NSM2lMbUt4S1IxaHhK?=
 =?utf-8?B?Q202cXVKNUVJN3NhcGJHVXZvYzFGZ1ZTVS9VaHgvWTQzYlZ2NS8xMVBFQmto?=
 =?utf-8?B?eWtEamtqbGlKcTBTeDlYOURuTzdjc2g2RlJvc3NhUGFLSGFCTXhCQXhXWjRo?=
 =?utf-8?B?WGNJMGFDOS9sRnAxN25DMTE0MjlmNlFOVElXaTNPRnRoOGttVVdDVVZQUndI?=
 =?utf-8?B?cmk2MUFqcmxhZ2t4VXpHclJJTG5qN2JvRzF4SWoxUXhrRTRqay9lWTFxU3FU?=
 =?utf-8?B?Ukl6c3pwdXduUmU5NWFWOE9qOXI4clUzZTNydEI2Qkl5TW5CUHVNZWNYcDFQ?=
 =?utf-8?B?eXEzaC92b1JFY2VtZWZPM2NHb3BLcTRhQXh2RVExZjJyN01wYmVzTndrMkRT?=
 =?utf-8?B?OE5WV0dEMTJnTEI4c1ZqcHkzSXFkZmtnWE5mNlJERythTkNaTi9IQUtkcGhj?=
 =?utf-8?B?ZWJERm5XNzNWZDV4OWY1NXozNUxWMUNzL2tpRC9RVU9WSkRHZVhnQjdCMHdn?=
 =?utf-8?B?dk9jSkVCRVRlOEFzV2EvWnQwWkZIUzVhaUExbzIwTU40UTJ4eEFxTDFoaHBV?=
 =?utf-8?B?cy8vdHhWSHl0YS92d0xNV1lTdHZ4TUJ4SWJ0cjF3aFB2WEg3aklYVXdJSklS?=
 =?utf-8?B?aHpTOXZrZExBcVpVS1pWVXI1UnJYWnpPRjNZZXA2Z0gxZnNkc050Wit6Qndu?=
 =?utf-8?B?a1p2UEFQTlN1MTBWZ0R3cFpERzZsVlZNaFJYZlhJYUtaem9GVTJPcVYrT2lZ?=
 =?utf-8?B?QVVIN2JoTnRFL3pGU0ZlMnZEbjhYdlFZZkhIejZ6SDhZazA1VTBJTXdoblJv?=
 =?utf-8?B?NVlja2ZYMUZtcGFOS1YvY0YzZ0NEVExNcndhU0w3RXIxMzE4K3J1Y2N6ZmRE?=
 =?utf-8?B?RzAxU0F3L1VtSXFENmxyZzJYeERZYzR5T3h2Nm0rVHVHY0tFZFZQVU5mSVBR?=
 =?utf-8?B?RkdxT3RzcFd6U2R1Uzg3Mm5lZE9vc0htNitpSTFzZENDZFZGSEYzbGl0YWEy?=
 =?utf-8?B?WjBNMnBtYWs2VE95UHlNSzJlSUpPaXZPTU1ubUdvZnFlNDNiNTVPdTFCb09o?=
 =?utf-8?B?akdETloyQjBhMUs3K2h4STJiTTFCUVV2VDdlUk9lSDlnRHFiYzdrZGhjUmhl?=
 =?utf-8?B?Y3NHZnk2ME5sUUk2WmhKUFFqdHY5R1FONFNwK08rRWVpd0VKZU5NbWNZdU4v?=
 =?utf-8?B?ck90R2QyeGxldC9aSHpldEtMUDNsOXZiaGp4WG52bEZsRDlVY2tVbDZrS25w?=
 =?utf-8?B?Q1k2eTVkcldEb3ZFajBRdW0wMkxzbS9yUEMvaitXV3o5WnZ5QkR1OGlyQnQ0?=
 =?utf-8?B?OWFaSW51MGdGM3gwL1c4VE9zb3JtSWwzU3lnL1ZmaUlCajdhRVN0cU1mVkkx?=
 =?utf-8?B?eDF6aTkzaWNuR3pFakx6VnE4WnprVVY1Q3JiL1M4MkM1OEpIaGxtOFNQVnRl?=
 =?utf-8?B?QVp6VDVpSEovNGVibko3ZXc3bEdJVDFsVEJ4Rmt1MlBHMTJNMWdsL3lwelVv?=
 =?utf-8?B?YWt2N1NTajEvZHEvcXJvdnIvL3R6S09BSmRkL3VsdEJlUUtaWHc0QTU0KzZT?=
 =?utf-8?B?b2VCSW50SDNPV2tHamxkVnoyb291dG8rNzU5YUhVemVWVVF1bXVNTGRFSHl5?=
 =?utf-8?B?dFY3cVdqSE1HRVY5N2VxeFdFR2paV09TK1NPSlErZmxYeHlLRmh0SWZTaE8w?=
 =?utf-8?B?djhIQ3NpMldpQ0ZYdUNpaUJYMkFBODlXdjVGTUZlUjBPVWJNUXRpVDZWKzM3?=
 =?utf-8?Q?If+yWQPoSeYq/S+Z0F+vGbg/v?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1B90B17345A2643942821E09AC183C5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da96682c-d5e0-4850-f767-08db6673176a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 09:47:50.3165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9s2sEpI4fxnpMjWICTAhykThIpXG4kwHuF0UvvGrRw78rjoxENULahbGRDeYkidpQq7f3Q0VLG+B8Qk0icKQNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTAyIGF0IDA4OjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEp1biAwMiwgMjAyMywgUm9iZXJ0IEhvbyB3cm90ZToNCj4gPiBPbiA2
LzIvMjAyMyA4OjU4IEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gQEAgLTY4
NjAsMTUgKzY4NzEsMjkgQEAgc3RhdGljIGludCBzZXRfbnhfaHVnZV9wYWdlcyhjb25zdCBjaGFy
ICp2YWwsIGNvbnN0IHN0cnVjdCBrZXJuZWxfcGFyYW0gKmtwKQ0KPiA+ID4gICAJYm9vbCBvbGRf
dmFsID0gbnhfaHVnZV9wYWdlczsNCj4gPiA+ICAgCWJvb2wgbmV3X3ZhbDsNCj4gPiA+ICsJaWYg
KG54X2h1Z2VwYWdlX21pdGlnYXRpb25faGFyZF9kaXNhYmxlZCkNCj4gPiA+ICsJCXJldHVybiAt
RVBFUk07DQo+ID4gPiArDQo+ID4gPiAgIAkvKiBJbiAiYXV0byIgbW9kZSBkZXBsb3kgd29ya2Fy
b3VuZCBvbmx5IGlmIENQVSBoYXMgdGhlIGJ1Zy4gKi8NCj4gPiA+IC0JaWYgKHN5c2ZzX3N0cmVx
KHZhbCwgIm9mZiIpKQ0KPiA+ID4gKwlpZiAoc3lzZnNfc3RyZXEodmFsLCAib2ZmIikpIHsNCj4g
PiA+ICAgCQluZXdfdmFsID0gMDsNCj4gPiA+IC0JZWxzZSBpZiAoc3lzZnNfc3RyZXEodmFsLCAi
Zm9yY2UiKSkNCj4gPiA+ICsJfSBlbHNlIGlmIChzeXNmc19zdHJlcSh2YWwsICJmb3JjZSIpKSB7
DQo+ID4gPiAgIAkJbmV3X3ZhbCA9IDE7DQo+ID4gPiAtCWVsc2UgaWYgKHN5c2ZzX3N0cmVxKHZh
bCwgImF1dG8iKSkNCj4gPiA+ICsJfSBlbHNlIGlmIChzeXNmc19zdHJlcSh2YWwsICJhdXRvIikp
IHsNCj4gPiA+ICAgCQluZXdfdmFsID0gZ2V0X254X2F1dG9fbW9kZSgpOw0KPiA+ID4gLQllbHNl
IGlmIChrc3RydG9ib29sKHZhbCwgJm5ld192YWwpIDwgMCkNCj4gPiA+ICsJfSBlbHNlIGlmIChz
eXNmc19zdHJlcSh2YWwsICJuZXZlciIpKSB7DQo+ID4gPiArCQluZXdfdmFsID0gMDsNCj4gPiA+
ICsNCj4gPiA+ICsJCW11dGV4X2xvY2soJmt2bV9sb2NrKTsNCj4gPiA+ICsJCWlmICghbGlzdF9l
bXB0eSgmdm1fbGlzdCkpIHsNCj4gPiA+ICsJCQltdXRleF91bmxvY2soJmt2bV9sb2NrKTsNCj4g
PiA+ICsJCQlyZXR1cm4gLUVCVVNZOw0KPiA+ID4gKwkJfQ0KPiA+ID4gKwkJbnhfaHVnZXBhZ2Vf
bWl0aWdhdGlvbl9oYXJkX2Rpc2FibGVkID0gdHJ1ZTsNCj4gPiA+ICsJCW11dGV4X3VubG9jaygm
a3ZtX2xvY2spOw0KPiA+ID4gKwl9IGVsc2UgaWYgKGtzdHJ0b2Jvb2wodmFsLCAmbmV3X3ZhbCkg
PCAwKSB7DQo+ID4gPiAgIAkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gPiArCX0NCj4gPiA+IA0KPiA+
IA0KPiA+IElJVUMsIChJbml0aWFsbHkpICJhdXRvX29mZiIvIm9mZiIgLS0+IGNyZWF0ZSBzb21l
IFZNIC0tPiB0dXJuIHRvICJuZXZlciIsDQo+ID4gdGhlIGNyZWF0ZWQgVk1zIHN0aWxsIGhhdmUg
dGhvc2Uga3RocmVhZHMsIGJ1dCBjYW4gbmV2ZXIgYmUgdXNlZCwgdW50aWwNCj4gPiBkZXN0cm95
ZWQgd2l0aCBWTS4NCj4gDQo+IFNob3VsZG4ndCBiZSBhYmxlIHRvIGhhcHBlbi4gIFRoZSBhYm92
ZSByZWplY3RzICJuZXZlciIgaWYgdm1fbGlzdCBpc24ndCBlbXB0eSwNCj4gaS5lLiBpZiB0aGVy
ZSBhcmUgYW55IFZNcywgYW5kIHNldHMgbnhfaHVnZXBhZ2VfbWl0aWdhdGlvbl9oYXJkX2Rpc2Fi
bGVkIHVuZGVyDQo+IGt2bV9sb2NrIHRvIGVuc3VyZSBpdCBjYW4ndCByYWNlIHdpdGggS1ZNX0NS
RUFURV9WTS4gIEkgZm9yZ290IHRvIGNhbGwgdGhpcyBvdXQNCj4gaW4gdGhlIGNoYW5nZWxvZyB0
aG91Z2guDQoNCkFsc28gSUlVQyBvbmNlIHNldCB0byAibmV2ZXIiIHVzZXJzcGFjZSB3aWxsIG5v
dCBiZSBhYmxlIHRvIHN3aXRjaCB0byBvdGhlcg0KbW9kZXMsIHVubGVzcyB1c2Vyc3BhY2UgcmVs
b2FkcyBLVk0uICBXb3J0aCB0byBjYWxsIG91dCB0aGlzIHRvbz8NCg0KQWNrZWQtYnk6IEthaSBI
dWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K
