Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7467A1247
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 02:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjIOAYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 20:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjIOAYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 20:24:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B58C2102;
        Thu, 14 Sep 2023 17:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694737453; x=1726273453;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qPiNuUrykfcko6uxaMPN2wZ4ou0Jpxc+1swWo/h4qBE=;
  b=Ud0mtkV+JJO35vFHeU4p94erDfS7fHFV/UIgU8SMxD7VOQxIQko+kbn/
   jfNWytMvYOd4971+7LcmcL/Zzt7djNi9UTqrJHPOH2rFqHv+TTOMZcTru
   Q/MzM96pWcVSxRxxbH2GmJtHI0txwlwh0nTML374qiYtnSqRFG04DglvF
   Ak/FgpvGncpfYTvDKLTsMd920yDtiOF9lKi045rY9drrysOe0VRl6JlsQ
   tn2xLYQQeTgn7sjVyMLJ1gDfS0P0eQqCHrh4HD0bE7JbcK5zTHCWBmg2d
   bJYvRmc+/2aMVeynSDNFE93YHPf/Z8MFunjjEfxuIK+OfhExWNYjZNhr1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="410060087"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="410060087"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 17:24:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="868470556"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="868470556"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 17:24:11 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 17:24:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 17:24:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 17:24:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJgoEIzTKPksDxewhzqQN3naA9xb/zVKohjg/ie3E/K3NlF5hub7ZBjIFw+VzI7lhpEmnHhSmbN+stl0wf2J49+ktRjOOdSs7vVtImWfcxbOZRfIgH0L6HShyBa7OnFG7+pukV1dUnPtSgD7UEr3XideffGyd1h5c0kpQopqQYryhFakZ7ibNhKs1Po7bBJo572ejAiPU2V+9B1PfJWDNVCX7FHHEA0XCz+m1SFku9DsyrwGUvrx6tECTivQMyADdoBtY5XOYlyzPzLNm/orizxcYj85K9oYG5qG0goXzdPsHRwApGt/zE3e9cSFEPrtl0HE6ECAJnH2aN8gTFMcug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPiNuUrykfcko6uxaMPN2wZ4ou0Jpxc+1swWo/h4qBE=;
 b=jHkP8YBSS27VmkzQHjqDOjKvsbnX48a5f35ezfzlzAz+DymKHV8lJlITf5+vvHGbfdEgVN6tbtF7DprdT7HQuwhTVqheWUEW3OFK8z+L74iOH4Vh8G3ZlokClhStV0iAZfNHPZzczS5V3DAqwMH8CcLqEwtCtb2kCSIMqUSIwTE89c6bmts7Rv7nGpWumxQ+AKc/ukkrkWOt2iq8+AtLzdKc0GxGddDKSxbUDfQEMVEJR6XxBauXY0Jc+BfWJT1wziP6MfzA4xGIXxBUr+JQakVUmSBXlVyx5ekbmwbhHcS3gPikzRl4gypZnJhM+aJuV8Bx/UECI9p9VU/dSA6HtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7998.namprd11.prod.outlook.com (2603:10b6:8:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Fri, 15 Sep
 2023 00:24:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 00:24:02 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
Subject: Re: [PATCH v6 04/25] x86/fpu/xstate: Introduce kernel dynamic
 xfeature set
Thread-Topic: [PATCH v6 04/25] x86/fpu/xstate: Introduce kernel dynamic
 xfeature set
Thread-Index: AQHZ5u84vNi8CjYN0UuEVTTsyqXXh7AbB/uA
Date:   Fri, 15 Sep 2023 00:24:01 +0000
Message-ID: <f16beeec3fba23a34c426f311239935c5be920ab.camel@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
         <20230914063325.85503-5-weijiang.yang@intel.com>
In-Reply-To: <20230914063325.85503-5-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7998:EE_
x-ms-office365-filtering-correlation-id: f514efac-89e8-4a91-f6aa-08dbb5820fe5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LpC2Ftsb2DAqdhCcQu+EKH5suR7CSeEd4fwRZyS5D2Y0v+vvuIdK0ZYlut/7AUXa3jqiA5AEyrqJWY98wr7avrXZEia5uBQ2uh8rZ+EzHWejMrHGcf0yDPiUHOrB2VYno4QSmvxGpmXMuW90bNPdh6+9mHsEAVlY/jS2VED82HPN7QehZaRyYUFYs4ZoYAEbxc/BD6BdU+QM+EwJIsgwQSh+IK8sxW70yKk6Dik1y2fyuaBm8xw6dSoAIOwrUNJFygHEUY7aFeeJByXDhXFsETDBS9wOpJGmaSDqICNfd0JvoPu8QP+QIhsHwbyX+NGGHOv98s/VhMJHvvvWhT0tXUziFb6vwLArN+MGEOSJpEHpUibiNsINp6cgnxiLrcnwZdSzdBdhkgBICL9hqTdY4c1ajaVs7ldDAt7X/kFuyd5w40jeoiH2KzmwSmwjOpuDU5s1axRohoFw6sobaXdFSvyzih9EGddKEcrXEw6B8E9uyDfGEYTJreT5nl22L83FJ0pRqybYZ0P0ZtT1k1F7Xq+gElBHHicFbZ8h7BLzLJ4r2KDML1tcSpjd47l/3jAkX1J1sBzl1mmVIeWrfYymYboVqokuF3sluUbcxTV8+cKWUkRihPaFdE8vpPPt0jxL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(136003)(366004)(346002)(186009)(1800799009)(451199024)(38100700002)(6486002)(2616005)(110136005)(76116006)(38070700005)(66946007)(478600001)(122000001)(86362001)(26005)(82960400001)(66556008)(91956017)(2906002)(54906003)(8676002)(6512007)(8936002)(5660300002)(64756008)(6506007)(66446008)(41300700001)(4326008)(36756003)(66476007)(316002)(4744005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmsxczNEeUZYWmRUWXBvSFpVSTltbDFsNzJ2ZzE3b044UW5qTnZuOW41SGdO?=
 =?utf-8?B?UFFKbnBCTENGSjFHYW1PSmd1U2I5VTZVQmViUEM4dFo3TVlkNFNQOWozajcv?=
 =?utf-8?B?NlY5K2NhdGN6S0JJWnI0UnRoYmhnaTNoK1lTQU1lUWRrZktiN0xJL0J0d0Vm?=
 =?utf-8?B?SUVSS0tPWXRiYWlkV1NxZnA0K21rc2NxVXRmSE9HSFJNRHozWGdnL2tubG9C?=
 =?utf-8?B?SWl5ZVIzN2preFV5SGZMVnEwR1Z2WW5XcCtUWWdESmxZZ2FyenFGZGx6K1BH?=
 =?utf-8?B?L0d3Q0xyYzlKK2NLSU1tOTJXLzNwaDA0UzVJUUVCTGdOcjluYXBlZjFnbUE2?=
 =?utf-8?B?R0FqRU5QWStMa20ybTRrRWdnWGxOMGZTSGROcEFBNlVLNGgvODQ1QkxRWm5x?=
 =?utf-8?B?MU9qZmRRZmIrclYyQnBWVjVtd3ZrRTZ4WVdlU3RGWDEwQVo1Y0VJYi9OdjZI?=
 =?utf-8?B?RG90cTVzRlU5cXlWbXVraGI1b0pUalNUTUYzNDh3VmNHSFdFaEprWnJnNloz?=
 =?utf-8?B?Q0pIeEpCRFFYZEdVZnJuZE9KTTBOVUFsVFJhMmRQT3k5NnFlbG85dkpKb0pB?=
 =?utf-8?B?ZGFsZDdBTC9CSklveFhGQnVUWEZTU0NWY3MvMGttb05aWkVTNW1hRzRuSDJ1?=
 =?utf-8?B?TTl1TU1mMGFMcjJDWTcrbjhiRlFEYUc3Y3l0WklueEZIa3ZZWG1NL3FMTVFj?=
 =?utf-8?B?eHZobytKUitOaDNraEhHZWs3ekYxeDFwbFNmWWQ0Z05wTUp2cnFWamtJUjht?=
 =?utf-8?B?MjhnbUJLOTNHNm1iZmZZK1lNODZPZ1VuSnlpZXFxdHlXdFdRNDhKOElpY3lS?=
 =?utf-8?B?SkNuQ3pEbyt4NHI3U0I4TnYyOCtFQkVhUmNsWllEcWxFYTBEUmVQRFdOSkR6?=
 =?utf-8?B?ajFlVkFVbDhwSGZhRFYwVGQ2dHl3R2tlOW5tWllaRkN0c2hORXhTaXc5Nk02?=
 =?utf-8?B?Z0NscXF2RlZ5cXBDMGlXdTUyeitGbGswWGlpR3VFV3lLMXk1OXNGUWdpNGFu?=
 =?utf-8?B?SXc5enpteGc5ZG43REhDOC8xVlM0ZE9lTUMxNHVRc0gvMXM4YWFFNW5MMERH?=
 =?utf-8?B?a1lISFI4VmtIZEs3Z0g3OENDeHNtSGlLVFdSb0w4QVRtL1ZoK2o4WlpzdDdy?=
 =?utf-8?B?UDMxamFsRmRzQlZRZ0tIY3FUajRRWUlSdlB0SFY5Y1NVbmxKV1owZDAzWTBm?=
 =?utf-8?B?V2hFaWFqSjVIWDlpTldWdzMyQkp4cGxFdXFtcXJ1bzIzTElqVjRTL0tybCtC?=
 =?utf-8?B?TUh3MmwxdTNTNFdLeEc0RnRSSXpiTVJZc0xxNGtGcG01MmpCeW1GR0t1VGRK?=
 =?utf-8?B?TDlmTmhYd2ZrVTVLWDBCMjdPYXpSVEN0UVFSUDNmS1o5aVMxMmp6d00wL2Ni?=
 =?utf-8?B?YnRKczU4dzF5ZVYrcDU0Q3R6V2M4VHpFS01qUjRJYTlpVE1vY2hBNVF5Mmxo?=
 =?utf-8?B?enY3OU5BbHkzQUZ1R2RrdDNHcHh5eG5ab01sTzlEbWR0NTloNmduRWdyWklW?=
 =?utf-8?B?WDhvVlkzQnljYW1TWWpWV0VTMGp6WW5IQ2RrdEtObDBxN3BMNFNBSHlNL0Yv?=
 =?utf-8?B?amJCbEx0dEtUdHg2b2ZLMzZXaTdydkwwNUY1YUFuM1JsV3ROa3JUM0NFVmpz?=
 =?utf-8?B?czRmWFlUbE5jcnFVcTFXdldQclI4YmgwVmx4aWZTQ1FLZG5pR3ZyT1RDNWRo?=
 =?utf-8?B?VzFKQlZualJQMlYvcHZiSUF6Y2Z1WkN1c1grTG5SQ0NGeTNDbmJiTk5CRHBm?=
 =?utf-8?B?eExVOWZXdUlESDNQSGtzVXEzRE5LTlQ1RVo0YkVYRXdTMHZiZFJvLzVnOFF3?=
 =?utf-8?B?L3ZXY1BMRmQyZEZPNFpLU2RidDZKQjBVV1BIQlJhSVBqYjlVazRDVGE0ZXF1?=
 =?utf-8?B?dVo3Z0oyQW5xdU80YjIxMWwvWitRKzRvVjFhRkdWTWdyQ09MYVpmYURUT0Ux?=
 =?utf-8?B?YUVyMyt5VzkvWkRTTDhvV0UyQ2phNitHOElpVkFGbk4rOWM1cUJkRFBzQnJp?=
 =?utf-8?B?eTY4S3VsclRscWR5QzVWTjVYb3FESGdCblJ3Nm4xMTN0SGR3dER5QVIwc0pa?=
 =?utf-8?B?REwvak0xdGRvaFByN3FGZ1VZTXdiTUZsdXZBdXIveEY3SmFBWXlNKzZ2b1lH?=
 =?utf-8?B?T0tjakpFVFRJaHB4MlhHc3NLTkZBS28wUGtHcE1CSXYrb0JmWGI0dG9YY3VN?=
 =?utf-8?B?RXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63FE8A0F43BFF74988F474AECD1F4EA0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f514efac-89e8-4a91-f6aa-08dbb5820fe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 00:24:02.0094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJQfaJEwDTzzS4Y1SYQV4B0OARWQs/1/heN9iXm/0SNya9x86E8Rwkc2x0+4GKPgEgFd551NjvVWrOC7GzRjFwbZbSbLER6QwYwxqpjk43I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7998
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA5LTE0IGF0IDAyOjMzIC0wNDAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOgo+
ICtzdGF0aWMgdm9pZCBfX2luaXQgaW5pdF9rZXJuZWxfZHluYW1pY194ZmVhdHVyZXModm9pZCkK
PiArewo+ICvCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIHNob3J0IGNpZDsKPiArwqDCoMKgwqDCoMKg
wqBpbnQgaTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUo
eHNhdmVfa2VybmVsX2R5bmFtaWNfeGZlYXR1cmVzKTsKPiBpKyspIHsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgY2lkID0geHNhdmVfa2VybmVsX2R5bmFtaWNfeGZlYXR1cmVzW2ld
Owo+ICsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGNpZCAmJiBib290X2Nw
dV9oYXMoY2lkKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGZwdV9rZXJuZWxfZHluYW1pY194ZmVhdHVyZXMgfD0gQklUX1VMTChpKTsKPiArwqDCoMKg
wqDCoMKgwqB9Cj4gK30KPiArCgpJIHRoaW5rIHRoaXMgY2FuIGJlIHBhcnQgb2YgdGhlIG1heF9m
ZWF0dXJlcyBjYWxjdWxhdGlvbiB0aGF0IHVzZXMKeHNhdmVfY3B1aWRfZmVhdHVyZXMgd2hlbiB5
b3UgdXNlIHVzZSBhIGZpeGVkIG1hc2sgbGlrZSBEYXZlIHN1Z2dlc3RlZAppbiB0aGUgb3RoZXIg
cGF0Y2guCg==
