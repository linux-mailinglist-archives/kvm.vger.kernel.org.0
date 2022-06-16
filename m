Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E339254E872
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377439AbiFPRMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354635AbiFPRMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:12:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354B517586;
        Thu, 16 Jun 2022 10:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655399564; x=1686935564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GNnBypH6+uUyCI1rqu388ivJ7/3b5FdWk8ugKsM2wMs=;
  b=al7rcy8pJwtBbGnY9CUOrvZ6GZOcwvDtq6fpmdHoxWSWZA0M9ClQgVke
   oHV/GMUjb0KctWmPKVU/ob8BhS0kSrwAc9s2w3OTMyqMP8vFWj+gPHTDA
   Su7VzhHzchXVZgbS6Vtjjw11P6prVtOmpDt0LOIah95Wjtkbld6+Tfu3x
   JfwkLXPE1pIZAb21CXTWpwAl3tEq8e+E/XMEYhmbBQoZOdbOijGymEIL+
   OmKLJ0XapFalIOE0lQ+kl+2IgCxvlIsCmW3g9I6PrfwL9yJHO8Air06Hj
   qZAhnPSQU9638HdJvx4OTIL8YL1Uwmo02eYV1usiV6A1qX+jjX+JqumrE
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280332710"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="280332710"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 10:12:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="912247371"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jun 2022 10:12:12 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 10:12:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 10:12:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 10:12:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpApJ01fThLkqyBF/Vx46C/rQrAaRhgpGkIjVdXwBhamSP1zp1jW6Nsb12wFDPqv/Ehyx87xk1kPVRduTR0cAcX9X1a4/ade96po3GtdOX/iyilLswARgzau8P+POvSbsik/DBadiyEyeyfc1tebCTBbbC18jA4uUy4ouJerSrzujg2Uwb7TBjCfj6zLZ/IYn+6ng0uVr+Obn2XjqxL4POvLbElgRPduqSncyxW971oVqUUQi09+hGVurT7F80s7M3V9860F3Bf7Dh5TrDQpouwkdoZU+ozPl9uKL/w/vxTPyi2I1Px9P9f7uxtSL8r3BKRbnuHB/Sd/jH9GcxLmfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNnBypH6+uUyCI1rqu388ivJ7/3b5FdWk8ugKsM2wMs=;
 b=GHvTBm2DjMeg+xEMHnbyUug31CvCsPbzFXGnDezlJhwjThcV4EaPPsM8L4P/KrihR8iHdEVGW+4Wr0/dLwIgI3sdQXtzAFv8VwhGYhFX8gBDFO5FNaKDIbx/S8Gw3J0FMCWK7HgYMZQS1Yb6BDnTpDDKKdLVAGukeTK7wcpViN9Q0SlZ06EG25PpfQ2MRtZDlzcxUgfvjDuORavKnNZmKgLi7Q01iM+j1iqmqrxvuRlM1Lvul3U0VPOU7KsIKqnRGOP3/qri+o+g13LjMu9affJgPKheMG/QhD1ocmHeGSxDCLrbWQ7a5LGmbF9HKQznfEYFvG26v5tUU9lt23UaNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by MN0PR11MB6303.namprd11.prod.outlook.com (2603:10b6:208:3c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 17:12:08 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::6463:8e61:8405:30f4]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::6463:8e61:8405:30f4%12]) with mapi id 15.20.5353.015; Thu, 16 Jun
 2022 17:12:08 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     "keescook@chromium.org" <keescook@chromium.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/19] x86/fpu/xstate: Introduce CET MSR and XSAVES
 supervisor states
Thread-Topic: [PATCH 04/19] x86/fpu/xstate: Introduce CET MSR and XSAVES
 supervisor states
Thread-Index: AQHYgV3CJfqPGqTFG0O2fBeJ8iGV961R1LaAgABw+QA=
Date:   Thu, 16 Jun 2022 17:12:08 +0000
Message-ID: <59a955d758f79e22f0a776f7a2d1e678a37a73a8.camel@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
         <20220616084643.19564-5-weijiang.yang@intel.com>
         <YqsFo+PdIlXfnJQM@hirez.programming.kicks-ass.net>
In-Reply-To: <YqsFo+PdIlXfnJQM@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec1101e8-c106-4743-9041-08da4fbb585f
x-ms-traffictypediagnostic: MN0PR11MB6303:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MN0PR11MB6303AA7FF7FE7C24B3615DC9C9AC9@MN0PR11MB6303.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6pNh/8+s+s8ld1qvSmGYo+u+fGOAnTRS0v2MtHb7zlAXF1FR28P/ojLo0TxnANH6gskVmXEb2arRN1SFmJgNSHWNc4C0CYskWmm2dr1AJ90GsubEQofbF7yIonoxSOq7kp3FNGB+y+5Ky6U7WNt6i3BQsSlustA6aP55FWoXBpLK+z2gjPH/99M100MVSFE5kLOo3TtqAhfjF8JIMq5/m5CGVsh4hCnaHfm+n9VIO3razwyGme7OJOo9jmwA9TU15FGrdFT7unDRxwwUuXcn7Cc40sWbg7CCD1filvI4UgIlMmeAyzKR3iJZVUu6QfOO7v/dXx4D8FfsaW2yWKf05tM5+FOHEGA3bVEzP4zMcQ5rE5TzbUstWyuzTEg2/bIXziqTm3rX2/YrwH6Sbu1U7DaQFWEOZbY6LSQMG/IU7V7TKgY8429zUtIxjJS5fYctNFTMscK/5J1I0kcEJkS31PaZv83EbjhTy79CL4qimlDKpNsKhSXB5Ax+teqaYRt9VRTQCn06qTMigZbQEkbN/jAsNTAGlV7OXo4smMw62vkQvQAtkyoZLc40f9XOkur3wG48uT7IeAwHULtO2hGkwP4zZVcMlCQzkyFS01cdjwkZk9Ts3iEuDjYKCcgidAOuSxMbY7WtQOdfaBBqOcemSnFSjMqyRdnDi+ssO20EHtVxdrpxCM8Y67VJUaI+J/p405RGb17lrteQ2Et8xiXsWXjY3DB8ql87GngtgzxNPgs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(71200400001)(6506007)(2906002)(38070700005)(2616005)(508600001)(6512007)(5660300002)(26005)(186003)(316002)(38100700002)(110136005)(86362001)(8936002)(6486002)(36756003)(54906003)(6636002)(82960400001)(8676002)(4326008)(122000001)(64756008)(66946007)(76116006)(66476007)(66556008)(66446008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGp1R0swTDl4NzJOczZLdTNjNmJ3WForemFLenlUL0lKOEVLNG1UejZ3Ry9C?=
 =?utf-8?B?WHNsVG5RSi9CSmtmR3pXbkduL3pGeWsveWVwbUxPVmtzaWNGbUZQMVZIdVBJ?=
 =?utf-8?B?MEJ4dU1FNTQ1bTkyQ29PT2VSLzNRWUJUYi8rNm5zczlOS1pRS1ZybmVXK1p1?=
 =?utf-8?B?Y2ZhS3drZFdjZGxCVGVDYkZaUER6dU5seHlBLzgxd0FFVk9rL2krdjZXTExJ?=
 =?utf-8?B?QjdtWVIzeFVncjZ4VWd0YTN5OFptQVBHWUxVMDhwa0I3RTJFdFBMcU5NalFp?=
 =?utf-8?B?VEFLMnFVb3FWTjZ0a1lXWVVFWnNLRGVYQWdVbzg1L0xLYXFtK1RXZzh6NFA0?=
 =?utf-8?B?UDRWOHlSUnUyeEFqSGZta1dOQ29RU2VDNDhMUEQ4VzdjRFYrbzFYNkFEUGlR?=
 =?utf-8?B?VGlZcDdVSkNITHhUSE1MM1RsVi9aeUtNS0hpSlNnTnFFRkRUQUFvdUR5eVU0?=
 =?utf-8?B?MGhLekZkcWpueEtNZ2lhTmwxUG9RK2RUaEtVVVcrOHM5WFprTm45Ymw3amk2?=
 =?utf-8?B?MmwvT2krcy9uSmJCRURUL1J5bkM4YUFoUHhFMktjOXloVHpUYTRhS2o4ajYw?=
 =?utf-8?B?c3BpSFR1cGNVRzE4aTRXTU1mY1JON3IxRTRLT2FkWFY0b0hzbWdyc3duRjkw?=
 =?utf-8?B?K0M4aXFaVm8vUmFseVRZaG1qM1pUemZDY0dLU0JUMG9IYTAwbmlqc0F3Y0hw?=
 =?utf-8?B?dU9XMk56Qnd1YVAwRWdoaEZqTy9kTW9ZTXFweEhURVNSb0dUQ2NZbG9ZeXpB?=
 =?utf-8?B?c1EzWWZ3Zm1TTmllSDBxeHpSRHI5eFNCdVlZdlVTeDdpTm85Vzg0MU1RSUxo?=
 =?utf-8?B?L1U5amx0T1c1SzIzd1crRVQ4MFJwNUM2ODBWcGdNVG5mZDRsdXdTSEROUjE4?=
 =?utf-8?B?WkZoU2xrVVU5eVVLeVBjL3hCT2g0dDVNeElSeElJdVRyT1VGbEVrQUZvdlZk?=
 =?utf-8?B?SDEzZC91bE52dHB1eHNoeFcrZVYxWUVxUjZ0ZjdqamJDWFV3dzBhWWVEdGc0?=
 =?utf-8?B?SHRIbWMwaHBxWW1ZVExHWTF2WVdDK2l6dlVWdG9YalJJZDhCZUhvYkJrTTVE?=
 =?utf-8?B?Zk9lWmdNQk5qWEMzenBsTXRpa0VxUjFxbzBoVXpXN0ZRRHowbnB3WDViMDI5?=
 =?utf-8?B?emdYeXFyc2xTMUFVOFhqZlczcFhlcW96dTZibTBKcEhIRm9ZZWtuVzkvdU1k?=
 =?utf-8?B?dXIrVDA5QVp5RCtGY0hjUWF5WFBHekF3TUpBTTRpZmYxa1ZUdGVFVitpNU1L?=
 =?utf-8?B?d21vOFg2NDhnUGJGNUVlRzJSMmIrcVVRaklBeWNrWVF2bVg2YlJBSFQwWUlF?=
 =?utf-8?B?SFR6U2pDdDVTZEJUM2hJMXhqK2NQRWozNmdqQUlCcDkzYm5kdk5rV3ZGVFEy?=
 =?utf-8?B?OUcrcUdWdkRJY29ycmlOajJwYldIaEtVUitZYSt0UzI1T2h5cnU3cUJSdnhj?=
 =?utf-8?B?RkNZaHNqTnN4M01FSjgyR1BGSnRlckc5SHpUd1hnSG04QjdYZ3JCZkJJVUlv?=
 =?utf-8?B?dXZ6YW5KRURaYkdWQldKcnZrREJLaDlmejdDWFFZTkZyRnRTZUdwTi9nM1pG?=
 =?utf-8?B?cTVYTTRtejZuVnJvSXZNVFEvL0RXdCtXSHNkdFg0OHRHVFFIUlh2eXU4OFh1?=
 =?utf-8?B?VVdUQXNFSitFZEhEY1JENjdZeVJIQnNsOGN3d2poMmdQZ3Rsb1QzcEdFaVZ5?=
 =?utf-8?B?emFJZmdFdEd2UXo2UzRCM1c5VFN1SzJpQmxIMTVRWG9rSkZ0OFlNbDArbkZx?=
 =?utf-8?B?djkxWk5VUnVTZmRLSmtFQlR3a2t6QjhIY0x6NndLQTlONDQ4VmIyam9MbG9w?=
 =?utf-8?B?RFNlaXRkNHVyU3pBYU5hREdXV3F4TGZONVMvemF1N2VPT2NMZjRVeDRLS1c1?=
 =?utf-8?B?cnVHV0lxZHJUbXBCM281elg2UlBRbXl6Y0Raby9CdzV5bEpKQm5ENHlIaVNQ?=
 =?utf-8?B?ZGd1ZWxJUER6aWQyVUNyUU1ZMFJFT25hMFNWSG1SRUk1dTdDazlnMDNJbzhZ?=
 =?utf-8?B?UjlGbHgrVlZpNjdTdlF6RVZnSUsrS0dkbGo3b2wrNGd6cUowUDExMjRYVUVH?=
 =?utf-8?B?UWR4bU9VU0J0Nzg5MG1sNVA4ODZTM2ZtNlVnVGVkTjRYWjBHUDUzZis4Q0Y2?=
 =?utf-8?B?TzF5MW43NzhCSUlVMm5Xc0JSc0xXd0JLbEdXVDdnRXZEWkg0Qmh1N2lOc2Ri?=
 =?utf-8?B?UDNINUltT2xoQWk2RG9uR3dtSy9UQkNkWUpHZEdKK0t6c253Z0RlOHRPVjRx?=
 =?utf-8?B?ajJWYWlYazhLRE0ybUJIOW1OOGR5WXFpWjE2L2hNN0lKd0I4dTE5TnRha0ZM?=
 =?utf-8?B?cTdsWkN2dCtaT21KYXBNOStRdmNnS2l3b0pRcWZxYUdYckwxbWZDVVAwYndC?=
 =?utf-8?Q?cKxBwcHxj442bn0XjYx3AnH+OGtZGucaaKY9b?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA7B468E3C627744A543A68A330DE05E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1101e8-c106-4743-9041-08da4fbb585f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 17:12:08.6014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yXV8fcQ2Ihqk6dBAGHxCPRNaMaoB1A/UjjuRKqhmP4xAXvfmJz41gBGROTV/mXz6bVBdBT1J8n8q1U6wEfb0x4lBSaV/ZCedPKK21NmLHHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6303
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTE2IGF0IDEyOjI3ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMTYsIDIwMjIgYXQgMDQ6NDY6MjhBTSAtMDQwMCwgWWFuZyBXZWlqaWFu
ZyB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vZnB1L3R5cGVz
LmgNCj4gPiBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2ZwdS90eXBlcy5oDQo+ID4gaW5kZXggZWI3
Y2QxMTM5ZDk3Li4wM2FhOThmYjljMmIgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vZnB1L3R5cGVzLmgNCj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUvdHlw
ZXMuaA0KPiA+IEBAIC0xMTUsOCArMTE1LDggQEAgZW51bSB4ZmVhdHVyZSB7DQo+ID4gICAgICAg
IFhGRUFUVVJFX1BUX1VOSU1QTEVNRU5URURfU09fRkFSLA0KPiA+ICAgICAgICBYRkVBVFVSRV9Q
S1JVLA0KPiA+ICAgICAgICBYRkVBVFVSRV9QQVNJRCwNCj4gPiAtICAgICBYRkVBVFVSRV9SU1JW
RF9DT01QXzExLA0KPiA+IC0gICAgIFhGRUFUVVJFX1JTUlZEX0NPTVBfMTIsDQo+ID4gKyAgICAg
WEZFQVRVUkVfQ0VUX1VTRVIsDQo+ID4gKyAgICAgWEZFQVRVUkVfQ0VUX0tFUk5FTF9VTklNUExF
TUVOVEVEX1NPX0ZBUiwNCj4gPiAgICAgICAgWEZFQVRVUkVfUlNSVkRfQ09NUF8xMywNCj4gPiAg
ICAgICAgWEZFQVRVUkVfUlNSVkRfQ09NUF8xNCwNCj4gPiAgICAgICAgWEZFQVRVUkVfTEJSLA0K
PiA+IEBAIC0xMzgsNiArMTM4LDggQEAgZW51bSB4ZmVhdHVyZSB7DQo+ID4gICAjZGVmaW5lIFhG
RUFUVVJFX01BU0tfUFQgICAgICAgICAgICAgKDEgPDwNCj4gPiBYRkVBVFVSRV9QVF9VTklNUExF
TUVOVEVEX1NPX0ZBUikNCj4gPiAgICNkZWZpbmUgWEZFQVRVUkVfTUFTS19QS1JVICAgICAgICAg
ICAoMSA8PCBYRkVBVFVSRV9QS1JVKQ0KPiA+ICAgI2RlZmluZSBYRkVBVFVSRV9NQVNLX1BBU0lE
ICAgICAgICAgICgxIDw8IFhGRUFUVVJFX1BBU0lEKQ0KPiA+ICsjZGVmaW5lIFhGRUFUVVJFX01B
U0tfQ0VUX1VTRVIgICAgICAgICAgICAgICAoMSA8PA0KPiA+IFhGRUFUVVJFX0NFVF9VU0VSKQ0K
PiA+ICsjZGVmaW5lIFhGRUFUVVJFX01BU0tfQ0VUX0tFUk5FTCAgICAgKDEgPDwNCj4gPiBYRkVB
VFVSRV9DRVRfS0VSTkVMX1VOSU1QTEVNRU5URURfU09fRkFSKQ0KPiA+ICAgI2RlZmluZSBYRkVB
VFVSRV9NQVNLX0xCUiAgICAgICAgICAgICgxIDw8IFhGRUFUVVJFX0xCUikNCj4gPiAgICNkZWZp
bmUgWEZFQVRVUkVfTUFTS19YVElMRV9DRkcgICAgICAgICAgICAgICgxIDw8DQo+ID4gWEZFQVRV
UkVfWFRJTEVfQ0ZHKQ0KPiA+ICAgI2RlZmluZSBYRkVBVFVSRV9NQVNLX1hUSUxFX0RBVEEgICAg
ICgxIDw8IFhGRUFUVVJFX1hUSUxFX0RBVEEpDQo+IA0KPiBJJ20gbm90IHN1cmUgYWJvdXQgdGhh
dCBVTklNUExFTUVOVEVEX1NPX0ZBUiB0aGluZywgdGhhdCBpcywgSSdtDQo+IHRoaW5raW5nIHdl
ICpuZXZlciogd2FudCBYU0FWRSBtYW5hZ2VkIFNfQ0VULg0KDQpIbW0sIHllcy4gSSBtb3N0bHkg
d2FzIGp1c3Qga2VlcGluZyB0aGUgcGF0dGVybiB3aXRoDQpYRkVBVFVSRV9QVF9VTklNUExFTUVO
VEVEX1NPX0ZBUi4NCg0KSG93IGFib3V0IFhGRUFUVVJFX0NFVF9LRVJORUxfVU5VU0VEPw0KDQo=
