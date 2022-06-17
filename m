Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4647754FF46
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 23:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345677AbiFQVS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 17:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiFQVS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 17:18:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0228729352;
        Fri, 17 Jun 2022 14:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655500735; x=1687036735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e7BqudSyAinua5MrcNoUP9jYm5BsNEssZ6GwS7P6a9M=;
  b=Luv4ozw2FbcO0vV85dzEH70if/3d59v1GO/jFZrg55OOiwAd9x7GU9n9
   buPCFgFz2iAjEloFyWKC5Xef4OndftTNFvoLrtWzbWlgXZlJGKWQOlC3G
   OHyyfa1vZYQmrZ4bjmCxpaldYykeGF7d0HVXUkfysKXN0xoGW3qoYfJX7
   QAkO7hLdH0WoDeCUogyoiu+DzUUhBpbbhqjJkDaMCR53kMn72Og10tSzc
   H9jV+A01yipEWD7E2gj1gOEIYuIpWBPHXeSFY+jm4F8xvSub81v1aXlLs
   EfUOsh5VIR3V6iA7sQMJdeYf9WZpgRYMEWkh2y9XIMNRLAAlp/fToXDAG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="259409485"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="259409485"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 14:18:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="728498921"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jun 2022 14:18:55 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 17 Jun 2022 14:18:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 17 Jun 2022 14:18:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 17 Jun 2022 14:18:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNhDKesqqhUud9Tb8jkSTGiwAmLvRVKGG6Ph3WRzb6g9s/PW3vEr3RALi1PfEBKmGh5e2QRRr+zXlRYs0Fg+A9k3G4xF9cjGylZ9i4XG6Ufa/dVHvOssysPADVXxr42gH13GgPs5k9NCFlIYOGVYxvP9ePPvxf6uOShNDrsrLDGE5rrFeeyySS4ZkM3zU2SFc/N4wa3UxgCtRLvjPHbHSq7pqOF0TZJwu5aoGYB9B6E6FJDmXyxPwyNmOTn0+F8psIZpTs1cYD900+MkMCPuxFvjE7mAarZb+EreAdghEdRpNy0FQZmTYS9oiyUG8MuBb8InOY0iskhnlzqbfachIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7BqudSyAinua5MrcNoUP9jYm5BsNEssZ6GwS7P6a9M=;
 b=A4xhjwpctBGgA15YdNyV9vrof6rh/Ze96CYtypvcBj/H9HxMtwNCjPR0BBo7slTMWbK9qfiKHF1117Q/Qb2qiN1hJCsMPmsETGiMLKX/Qy4xHNkIntXqfo2r+GEf3sxjRzOG+i8Dui+RXcPO73BzPB7o5hoc4dsOt0tGnbq+iOABoQrzmbK6cjZrm7oHnmvJ7uLyosc/ujwDMzZKhXyugioXSABcsTpAeJDODHVD3Cvwpm6ceATaIBCDiv2xElivkfn42hxlHulbyk44mARw0l5hINTRlvtdLr/xzr4KuLpfCToVO2+e9MlRwY83QOeDIaq5HzEr27Ry0Ji7mHAByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by MN2PR11MB3824.namprd11.prod.outlook.com (2603:10b6:208:f4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 17 Jun
 2022 21:18:47 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::6463:8e61:8405:30f4]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::6463:8e61:8405:30f4%12]) with mapi id 15.20.5353.016; Fri, 17 Jun
 2022 21:18:47 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Thread-Topic: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Thread-Index: AQHYgV3BGYVuI+Dv/0Gr8tfHe/6Wwq1R07MAgAByKQCAATT+gIAAohIA
Date:   Fri, 17 Jun 2022 21:18:47 +0000
Message-ID: <b1d4d26144e933382a92425164f78367ff92aea5.camel@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
         <20220616084643.19564-4-weijiang.yang@intel.com>
         <YqsEyoaxPFpZcolP@hirez.programming.kicks-ass.net>
         <ca4e04f2dcc33849ebb9bf128f6ff632b5ffe747.camel@intel.com>
         <YqxnwRn+/c+i1vL6@worktop.programming.kicks-ass.net>
In-Reply-To: <YqxnwRn+/c+i1vL6@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1f718d7-5d07-4242-52c8-08da50a6f7a6
x-ms-traffictypediagnostic: MN2PR11MB3824:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MN2PR11MB3824460205096EEACF58CC3CC9AF9@MN2PR11MB3824.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aDJAOUmnR4sc8KStZ/0sxQqAKcmpb2aROygkHktfUuAA+8Sc6qqVdwPqxHeVD51vYXTYkRNEZYDft95+KfhVWCYDmOZBFd7Smv/RCxre00u8/aXVbYyuqXwcZSaPdTx8PUq7nLSpCw8khQr2ArlPwDfHMLB6x9XmBk4Q10PQkphMSNl1LJ/IrDkuBhAS5n6wnnxGsMu2YOOOjXKLWYMn8iDrAwKEX/VUPebgkquDOz3G0K7Dipu8lFbs1aI6qbrmoKGl5OUkU+V+bNNekDpaDhhZ4puajKbGY3hL8dGWcOyqf2aAXz1I7CldtPl1yxUhxU4pAdUuryrPTr3+0nWu6cyQ8I7tbUPKlJERyHmgFvVaSZUW09Xazc/z8nbIQJa+JbzhwnQygTOixR0LHvbHML0ulN6KAH3uQuhUdJWEhjXeqEP9hvk9/3MIlqubFmQW9gRQrGxcFG2F2ZLRqnLOBLREc5gQFDhNYWPTb2QLCt0j74do1mHLdemxjsSq3+Q2P+U+++j9/pvP0SjSxTQWpMVQNcdSXysNJyJzxOI1l7eMp7qVxo0eUVoeMVxqJYhQficWOpvfkUgTqy0gvWWSjjKa5z9XeY1GL/taDPM+EdqNukSKtuZtQPDEufeDW7EZ0EAwzwLqkAXVfr9aBnfaxSLfjnM8VNzNJv/prycVzrlFBMohJkuZfZUOHqslfZoa1ZI4G3gGrcKCfWDUGppAzSBxSov4Aj1qWQILVN6RjSk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(498600001)(54906003)(186003)(2616005)(38100700002)(6506007)(26005)(110136005)(66556008)(6512007)(76116006)(66446008)(6486002)(86362001)(122000001)(66946007)(66476007)(64756008)(8676002)(4326008)(38070700005)(82960400001)(71200400001)(2906002)(5660300002)(83380400001)(36756003)(8936002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alhSTGpKaVNuMmtIUXFNWGV0cS9MYmVWUmZxczJHek5RSU4vemNsR3FMTHF4?=
 =?utf-8?B?eHFFL3NWUmFza2t4ZU93Mm1rT2tyN1hLTE5kN2ZEaTFmdWpjWEJqeFQ1bXZ2?=
 =?utf-8?B?d3NKWVhMWC9oR2RkODlJTnEvbncvYmdZV0FxUVljVXE4QTlOT2czYjlZNU5i?=
 =?utf-8?B?RGQvRVViR1JVT3ZoZEg0M3lOaUhmSzdNa2pndzVvZXEveTZwcWxYL0ZoT09E?=
 =?utf-8?B?Z3BJWDFORjZ4by8xNUZ1Q0x3M21FL3hLR0Z0ejZsUXNTV3M4NmRLU0RtVWx4?=
 =?utf-8?B?MUJPcjRHWUd3a0prMTl2aXQ2UVJiWGtUUUNpdjFSRVI3U1U2Wk9tdDFQMG5U?=
 =?utf-8?B?dGtOaUJ4RksrdGhOcU05WXZLYzJ3UDZwQzVkZStHclVrZHZTWnljM1FOYkNW?=
 =?utf-8?B?aUo4YTdEL0NCL2FVSktrV0pPVXdxOGlkVGlXb0tnbytsZnM4ZDN6NG1MblZi?=
 =?utf-8?B?eC8zcHpKM2lqTEpHcFlkZExTUjZiWEhoRW5WNGtCbUJ6SGZydHZtb0RKS3k0?=
 =?utf-8?B?c3prMWNZRmVEa2JpV2pvUWxKTHgrWG5ZbVg2eDBpMmk4RlBGQjdnaENjVE5m?=
 =?utf-8?B?T3F2ckc0TjRNWjMyY0NJZ2h4aCtLbGVxdC9hdkZSaFBjdzBSOXovcmVuNHA4?=
 =?utf-8?B?Y0pxa3FHVEMvd1lOT3p3b2NKK3JDNVBvM3Y2RkNTa0NWWUMrRDdFY29EcXdJ?=
 =?utf-8?B?YU1qVE50UVBuVHhpckwrRG04NkFaNXVPTEM1aGpMTEZNeGVqbkJMSkk4VXIz?=
 =?utf-8?B?eDVEU1o5bjRtVG1NMFlLVzA2N2tZZ3p2b3czaXdrWjFUTkxwOVV4M1krd2pL?=
 =?utf-8?B?aWJ2MEhyaVFRQ1lvTHQ2T1BRbEMycTNzM2xiUmpJbUpMZUhYd0VGK29MS0Ny?=
 =?utf-8?B?WTU0ak9MQ3g4ejR5bEg0a0pYZW1ZNzdSOVorRmE3RUVRd3VOMFh1SG9jVm5y?=
 =?utf-8?B?YXQyVU1IdFhXVVhuZndscUVRMmFGc0xyQkhNWE9sdTNLeGRkdmVkWFU2N2k4?=
 =?utf-8?B?a0xxKzJ2RzRucWQ3Q0xBWngxblRmK2ZDb2ZxUjd2TUtHUlhYdjh0bjNydGdH?=
 =?utf-8?B?dzJ5MjBjM3J2THNDNm96Mkc5WWVsbmtKZFRsZXJZejVwRElJb1RtN0xBWmF6?=
 =?utf-8?B?NFpzREhxWTVKWDVJeFJYRVpLejcwV0x3NDBta1pKSWtpeXpSNlNOQnpzUWJM?=
 =?utf-8?B?Vld1K2Q5V25IamJ5VTJZZU92Zm9oYStmUjZCeUhjYXFMYTJ2V1d3ZEZya1ND?=
 =?utf-8?B?MURHS2d6SloyZFNUaG9WYzlmejFFeE5YUFc0OWhyZjFJYitrZWJOYkFXaytQ?=
 =?utf-8?B?VHRUcjliZndsWGJtY2pmZDZ6bWVNZTBoKzVtZkZDcDVmb0tRZm9UMWZtaGJC?=
 =?utf-8?B?dU5XeVZvMGxRNCtjQTZYaVNOUGY3eVN6VE5XR1NXNGlzUGtHdzdNNDBlaXNM?=
 =?utf-8?B?SW9zYzVoMlVkOEEzWnlNVVZrYTl4MmZacTNCOFBDWnp1S3J2c0x6c2hCTnlZ?=
 =?utf-8?B?QzgwT2xsWEJRdk9BTm1qZDlycFgyR0JvaXJEalFvTHlxcXRDWUFNQjAwaWJ1?=
 =?utf-8?B?U2tpT25sdzBUaVlra2NiR0NkWXozaE5icWxGaVFTZHV5VURSaWdoWHZ4d0FF?=
 =?utf-8?B?OTdveE9lbHNsVVAvc3I1eVRESGd3NjlhYzROTGcydFBwRU9PQStFZldsaGVu?=
 =?utf-8?B?TEpUaWticlFxYW9TclBXYjNMQzRPeVlTZ1FOQTFwNkFidnpNL0RiMVhiY04y?=
 =?utf-8?B?b0hvN05IMFRPNU8wUWF4QU1Vb3Fsd3ZQQVdJT3dGbklpdHA1RFdIZUZQNndK?=
 =?utf-8?B?WTM5OXcxK1BZR1dKenhEL3ZLUXB2UlR2aGRmcXZWQlNXV3hXUnloL1BIbGVu?=
 =?utf-8?B?T0JFZGZyQ2M5RVgrbnRTNTNzR1VNdXRXeVcxMVRjcndRT1hzSStEUXIyMXN5?=
 =?utf-8?B?TkJwbmlLK1lIaElXYUpxWTVsU2htelJSL2Fpd002Q2orWDMwVk9vcjI3NEM1?=
 =?utf-8?B?NGF5bzV0WlVORlROVHJ0VDdWS2ZBeGg4ek1TUGFyVDAyd05hVzdpOVZmci96?=
 =?utf-8?B?anROL0tLMUdxVFFQRGF0ZnhiV3lwcndUcU5kS2NWNzRrV2h2ZTUvVjdSazRI?=
 =?utf-8?B?Z1lvSVV2L2x6Z2hIN1p0K0cwVXpZSE0xbGlSZzJBYkZ1aXZCcWpIZ1FEeSti?=
 =?utf-8?B?T3FJQk1Tcmo0QU1NTkRzcjVwQWdwWlJBMkEvWmZLUUpWTVlKRWlST05wdDhS?=
 =?utf-8?B?R1htV1RaUHc1U0dBejVua1FFZjR4MHh1K0FnSGxMeExXaERJNkwxdEVNS1lu?=
 =?utf-8?B?ZlZvT0VZRVc4V0Y4c3ljZnRSaXJYTzlsYnF4bWpkT1RkdVZKV2ZkWVY0cXBF?=
 =?utf-8?Q?GePniCQLxGXbNF4hm5K4ZSHs2+UEG2YOPf1a0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02FE8F5F91E5654F8D9F52B4CDC08E64@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f718d7-5d07-4242-52c8-08da50a6f7a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2022 21:18:47.5387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BGcSzHwhHKrTXQCO0jn12rA+LGWxypAI4jnUOapZ1xR5jp6l7D/AJFtqyBakmLgCqw+mV7TPEHPdu6qnHtRUizJPiGX4WHfuj811ltr/cJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3824
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

K2tleGVjIHBlb3BsZQ0KDQpPbiBGcmksIDIwMjItMDYtMTcgYXQgMTM6MzggKzAyMDAsIFBldGVy
IFppamxzdHJhIHdyb3RlOg0KPiBPbiBUaHUsIEp1biAxNiwgMjAyMiBhdCAwNToxMjo0N1BNICsw
MDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMjItMDYtMTYgYXQg
MTI6MjQgKzAyMDAsIFBldGVyIFppamxzdHJhIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBKdW4gMTYs
IDIwMjIgYXQgMDQ6NDY6MjdBTSAtMDQwMCwgWWFuZyBXZWlqaWFuZyB3cm90ZToNCj4gPiA+ID4g
LS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1LmgNCj4gPiA+ID4gKysrIGIvYXJjaC94ODYv
aW5jbHVkZS9hc20vY3B1LmgNCj4gPiA+ID4gQEAgLTc0LDcgKzc0LDcgQEAgdm9pZCBpbml0X2lh
MzJfZmVhdF9jdGwoc3RydWN0IGNwdWluZm9feDg2DQo+ID4gPiA+ICpjKTsNCj4gPiA+ID4gICAg
c3RhdGljIGlubGluZSB2b2lkIGluaXRfaWEzMl9mZWF0X2N0bChzdHJ1Y3QgY3B1aW5mb194ODYg
KmMpDQo+ID4gPiA+IHt9DQo+ID4gPiA+ICAgICNlbmRpZg0KPiA+ID4gPiAgICANCj4gPiA+ID4g
LWV4dGVybiBfX25vZW5kYnIgdm9pZCBjZXRfZGlzYWJsZSh2b2lkKTsNCj4gPiA+ID4gK2V4dGVy
biBfX25vZW5kYnIgdm9pZCBpYnRfZGlzYWJsZSh2b2lkKTsNCj4gPiA+ID4gICAgDQo+ID4gPiA+
ICAgIHN0cnVjdCB1Y29kZV9jcHVfaW5mbzsNCj4gPiA+ID4gICAgDQo+ID4gPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jDQo+ID4gPiA+IGIvYXJjaC94ODYva2Vy
bmVsL2NwdS9jb21tb24uYw0KPiA+ID4gPiBpbmRleCBjMjk2Y2IxYzAxMTMuLjg2MTAyYThkNDUx
ZSAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYw0KPiA+
ID4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jDQo+ID4gPiA+IEBAIC01OTgs
MjMgKzU5OCwyMyBAQCBfX25vZW5kYnIgdm9pZCBpYnRfcmVzdG9yZSh1NjQgc2F2ZSkNCj4gPiA+
ID4gICAgDQo+ID4gPiA+IC1fX25vZW5kYnIgdm9pZCBjZXRfZGlzYWJsZSh2b2lkKQ0KPiA+ID4g
PiArX19ub2VuZGJyIHZvaWQgaWJ0X2Rpc2FibGUodm9pZCkNCj4gPiA+ID4gICAgew0KPiA+ID4g
PiAgICAgICAgIGlmIChjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX0lCVCkpDQo+ID4g
PiA+ICAgICAgICAgICAgICAgICB3cm1zcmwoTVNSX0lBMzJfU19DRVQsIDApOw0KPiA+ID4gDQo+
ID4gPiBOb3Qgc3VyZSBhYm91dCB0aGlzIHJlbmFtZTsgaXQgcmVhbGx5IGRpc2FibGVzIGFsbCBv
ZiAoUykgQ0VULg0KPiA+ID4gDQo+ID4gPiBTcGVjaWZpY2FsbHksIG9uY2Ugd2UgZG8gUy1TSFNU
SyAoYWZ0ZXIgRlJFRCkgd2UgbWlnaHQgYWxzbyB2ZXJ5DQo+ID4gPiBtdWNoDQo+ID4gPiBuZWVk
IHRvIGtpbGwgdGhhdCBmb3Iga2V4ZWMuDQo+ID4gDQo+ID4gU3VyZSwgd2hhdCBhYm91dCBzb21l
dGhpbmcgbGlrZSBzdXBfY2V0X2Rpc2FibGUoKT8NCj4gDQo+IFdoeSBib3RoZXI/IEFyZ3VhYmx5
IGtleGVjIHNob3VsZCBjbGVhciBVX0NFVCB0b28uDQoNCkhtbSwgSSB0aGluayB5b3UncmUgcmln
aHQuIEl0IGRvZXNuJ3QgbG9vayB0aGUgZnB1IHN0dWZmIGFjdHVhbGx5IHdvdWxkDQpyZXNldCB1
bmtub3duIHhmZWF0dXJlcyB0byBpbml0LiBTbyBrZXJuZWxzIHdpdGggS2VybmVsIElCVCB3b3Vs
ZCBzZXQNCkNSNC5DRVQgYW5kIHRoZW4gTVNSX0lBMzJfVV9DRVQgbWlnaHQgbWFrZSBpdCB0byB0
aGUgcG9pbnQgd2hlcmUNCnVzZXJzcGFjZSB3b3VsZCBydW4gd2l0aCBDRVQgZW5hYmxlZC4NCg0K
SXQgc2VlbXMgbGlrZSBhIGdlbmVyYWwga2V4ZWMgcHJvYmxlbSBmb3Igd2hlbiB0aGUga2VybmVs
IGVuYWJsZXMgbmV3DQp4ZmVhdHVyZXMuIEkgc3VwcG9zZSBoYXZpbmcgdmVjdG9yIGluc3RydWN0
aW9uIHR5cGUgZGF0YSBzdGljayBhcm91bmQNCmlzIG5vdCBnb2luZyB0byBzaG93IHVwIHRoZSBz
YW1lIHdheSBhcyBoYXZpbmcgbmV3IGVuZm9yY2VtZW50IHJ1bGVzDQphcHBsaWVkLg0KDQpCdXQg
YWxzbywgbG9va2luZyBhdCB0aGlzLCB0aGUgZXhpc3RpbmcgY2xlYXJpbmcgb2YgTVNSX0lBMzJf
U19DRVQgaXMNCm5vdCBzdWZmaWNpZW50LCBzaW5jZSBpdCBvbmx5IGRvZXMgaXQgb24gdGhlIGNw
dSBkb2luZyB0aGUga2V4ZWMuIEkNCnRoaW5rIHNvbWV0aGluZyBsaWtlIHRoZSBiZWxvdyBtaWdo
dCBiZSBuZWVkZWQuIFNpbmNlIHBlciB0aGUgb3RoZXINCmRpc2N1c3Npb24gd2UgYXJlIGdvaW5n
IHRvIG5lZWQgdG8gc3RhcnQgc2V0dGluZyBDUjQuQ0VUIHdoZW5ldmVyIHRoZQ0KSFcgc3VwcG9y
dHMgaXQsIGZvciBLVk0ncyBiZW5lZml0LiBTbyB0aG9zZSBvdGhlciBDUFVzIG1pZ2h0IGdldA0K
c3VwZXJ2aXNvciBJQlQgZW5hYmxlZCBpZiB3ZSBkb24ndCBjbGVhciB0aGUgbXNyIGZyb20gZXZl
cnkgQ1BVLg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NyYXNoLmMgYi9hcmNoL3g4
Ni9rZXJuZWwvY3Jhc2guYw0KaW5kZXggOTczMGM4ODUzMGZjLi5lYjU3ZDdmNGZhNmEgMTAwNjQ0
DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3Jhc2guYw0KKysrIGIvYXJjaC94ODYva2VybmVsL2Ny
YXNoLmMNCkBAIC05Niw2ICs5NiwxMiBAQCBzdGF0aWMgdm9pZCBrZHVtcF9ubWlfY2FsbGJhY2so
aW50IGNwdSwgc3RydWN0DQpwdF9yZWdzICpyZWdzKQ0KICAgICAgICBjcHVfZW1lcmdlbmN5X3N0
b3BfcHQoKTsNCiANCiAgICAgICAgZGlzYWJsZV9sb2NhbF9BUElDKCk7DQorDQorICAgICAgIC8q
DQorICAgICAgICAqIE1ha2Ugc3VyZSB0byBkaXNhYmxlIENFVCBmZWF0dXJlcyBiZWZvcmUga2V4
ZWMgc28gdGhlIG5ldw0Ka2VybmVsDQorICAgICAgICAqIGRvZXNuJ3QgZ2V0IHN1cnByaXNlZCBi
eSB0aGUgZW5mb3JjZW1lbnQuDQorICAgICAgICAqLw0KKyAgICAgICBjZXRfZGlzYWJsZSgpOw0K
IH0NCiANCiB2b2lkIGtkdW1wX25taV9zaG9vdGRvd25fY3B1cyh2b2lkKQ0KZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2tlcm5lbC9wcm9jZXNzLmMgYi9hcmNoL3g4Ni9rZXJuZWwvcHJvY2Vzcy5jDQpp
bmRleCA3MzgyMjY0NzI0NjguLmRlNjViYWMwYWUwMiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2tl
cm5lbC9wcm9jZXNzLmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9wcm9jZXNzLmMNCkBAIC03ODcs
NiArNzg3LDEyIEBAIHZvaWQgX19ub3JldHVybiBzdG9wX3RoaXNfY3B1KHZvaWQgKmR1bW15KQ0K
ICAgICAgICAgKi8NCiAgICAgICAgaWYgKGNwdWlkX2VheCgweDgwMDAwMDFmKSAmIEJJVCgwKSkN
CiAgICAgICAgICAgICAgICBuYXRpdmVfd2JpbnZkKCk7DQorDQorICAgICAgIC8qDQorICAgICAg
ICAqIE1ha2Ugc3VyZSB0byBkaXNhYmxlIENFVCBmZWF0dXJlcyBiZWZvcmUga2V4ZWMgc28gdGhl
IG5ldw0Ka2VybmVsDQorICAgICAgICAqIGRvZXNuJ3QgZ2V0IHN1cnByaXNlZCBieSB0aGUgZW5m
b3JjZW1lbnQuDQorICAgICAgICAqLw0KKyAgICAgICBjZXRfZGlzYWJsZSgpOw0KICAgICAgICBm
b3IgKDs7KSB7DQogICAgICAgICAgICAgICAgLyoNCiAgICAgICAgICAgICAgICAgKiBVc2UgbmF0
aXZlX2hhbHQoKSBzbyB0aGF0IG1lbW9yeSBjb250ZW50cyBkb24ndA0KY2hhbmdlDQo=
