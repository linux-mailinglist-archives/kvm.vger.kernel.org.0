Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CCA635349
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 09:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbiKWIxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 03:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbiKWIxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 03:53:40 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F817E9317;
        Wed, 23 Nov 2022 00:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669193617; x=1700729617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=92GMYwruPq1euQyDFnuhanx8gnB+ExNc1Pwljt6ssbw=;
  b=dLxzfGVFlPv17S31rTpYbs3ppEek6cCnd3WP0tjwxrq8J/fxs1dqznoP
   bGBaHnQjbEfiJNiE3Ic2DAeyNQufY+WlRk3EfWySAVPWw4woSAtzNeV3m
   fahTiPxCrr/HDHYiLLk0Qsagl2IPKtAuye4936QcF6YGpKHLokmVAKVGj
   eB9MqbcNHuRCXqxQu0PwrW4t+1eB75pGEbWYXHx9quSSBF0Don8i0K8aI
   fx0hPRIfFl5bDplzowbvGMPGd26rGSObNVAzH0GIbdf29PAFcwpqIH9dh
   nthL9FZr1SHBgzcSD2SMNImYEUarrZD0bfIMKtOet8uJi6H3DpJRSNJ3X
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="378274596"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="378274596"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 00:53:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="592445856"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="592445856"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2022 00:53:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 00:53:36 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 00:53:36 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 00:53:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buipUy+TdPs1BrDVBJkJR0sSGV2l869fdTALb5Q9527Nl8+b10DqTUSPhSaCjNFVKqHiN6H3T2KhHN2V69e6cNKoTF9oP4QTdxMCBauWRTN/us9VXiMQhjKhkJqMPZxG9xKG0jUQeKzMbI2PuuXzRKX4ukEkYQeyWajZXeygpJ+Yg4H5omEUrbM9uvVsF/cSWDWLeW2sT5r3Sud78Zsvh744j8WTYfSYO/9ct6q9OAwWp9BgQ0nti8igR2snlMtdkaoVhnUzzS4G0bZKAPFZ5YaYt5EOt1aScYwoEgbBLg+ohDRWkA2Cd5YwzsU7CEFyoBhHLPuE3SJdGL/ckiz6GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=92GMYwruPq1euQyDFnuhanx8gnB+ExNc1Pwljt6ssbw=;
 b=MRc0wL0eyJpsVPNEDYFsu7vXu77EKiyrXNHvwEzSF6vrRyviQ6lONaBAvK62Ce7VyB8DyLuf1pBsg8WclIXZs0GOUCa6wardbHBe9bnN+Xw3GFLjHDkQnKD10ytQdg8VG5qhaRBZv/Wuh6YvZT43/SLJum5ufe7eJUqGxviy3oQwQoXyWMjZPingDSBjSI354id7RLL7bhD4qLd6Q/9/rsqoGnk4MsMmNx1VEc+d1RCGwTWtkKKqoc0P9xmxyjH0bebmxuFGbBB8C9Ys2jhXjzEp/bydYaj3uB31lpe4iQqIhn6tXk2a852uOmOzejps/b6A2hmDz8nm+xDKEl4m2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5304.namprd11.prod.outlook.com (2603:10b6:208:316::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 23 Nov
 2022 08:53:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 08:53:30 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 05/20] x86/virt/tdx: Implement functions to make
 SEAMCALL
Thread-Topic: [PATCH v7 05/20] x86/virt/tdx: Implement functions to make
 SEAMCALL
Thread-Index: AQHY/T3A+/0sXXuTQkqld4kSQb8mzK5KqPiAgAGOqAA=
Date:   Wed, 23 Nov 2022 08:53:30 +0000
Message-ID: <526f79da588734cc9d83764b36be87e4b0f4fcb2.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <5977ec3c2e682e6927ce1c33e7fcac7fcfe2d346.1668988357.git.kai.huang@intel.com>
         <Y3yRHf982s/tNlvC@hirez.programming.kicks-ass.net>
In-Reply-To: <Y3yRHf982s/tNlvC@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5304:EE_
x-ms-office365-filtering-correlation-id: 881f249a-cd71-4ec1-af87-08dacd303201
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mGdPFtl+d97iHN2MCGgh2EEtvFxv/itc+JfM6EDb8mJJON6idTXOW3VoHmjO+urmqPZSWQD+9VFH1pvZGvdtQI4a+qH9kpdki2bmmG/aSCl94iR0ZS8p6wwWDjG57RogKwJyYdEjn9tc6ZFe61EMEm67BiQCQM8m0RbR3FWQr+z73PVv1U/cMLXmu2wvYvQQcHCMFdvi/IhuizXXeQiVBnVSNXLoQENq8P5Q/pF1M3bp3mFTiEtww4k/0SVNlAcvcY5V4z4UHUZy7M39gSYUmWTQvjbJmGmrytTCN3hYhalTlh8B6VTRriq608va9Mii9wDOoOVma0mr22zysp5tApTev5IgLbsmcbU+TuQ7Djqw1Jg+eob5TWxQaDE6gnqbxnLy04l5PETWBYl4liypWwXOHjZTtZxl5jejh7VBA+hJSo5fxRITkWjOJQEUJI5PWOt7ElWEfhl+kh+RQgjaIhWqQ3DYerymqkOpx1/l8fjbGQYpitd/gU0pSgmsBAc3AWvmldggNFgH2huc50W7Rq6M8mmM5gKxfjm+s5MzyKE3tIQiPw84RM5yYhV44nuZCx0Gx2uD4+rRXRDqDTVmYnipc/0LbAY1RDQ6klhajDDkZ/z8MHrohQvSGR2iBbpOa50e/NtleIiKAo6IhTpBJWYHEETHiiu7QhdDj7BaL+l5/qiRYlGChfhh7JSEQeQfQIkvYXTC+Ay/g1/s2amPg0uFSVcGBYHk4bw8H1v89C4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199015)(36756003)(86362001)(5660300002)(7416002)(4001150100001)(2906002)(2616005)(186003)(26005)(6512007)(83380400001)(38070700005)(82960400001)(38100700002)(122000001)(91956017)(478600001)(6486002)(71200400001)(966005)(8936002)(41300700001)(76116006)(6916009)(54906003)(316002)(4326008)(6506007)(66946007)(66556008)(66476007)(64756008)(8676002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWVSUjlvTWU1YkExN1paR042OW5ndG9Bbm9tRU1IZURxcEt5WitKNEV2bGFh?=
 =?utf-8?B?c1ZrUSs2UFhYWjYvbUQ5dlV3N3BCZE13VGR4QkF6YUtidzllSThaek9RWFBu?=
 =?utf-8?B?R2RTNTUrY1lJWDRhdnY3MHVGeDBMZ1ZaNVkrVjl5eFM5MTcxdVpGMzMrVDlu?=
 =?utf-8?B?WFlya3R2ak1Gc3NIYlVYRUJBWFBKWkcrVkhBVGw0emwvWnBTUWdVSlpXeGE3?=
 =?utf-8?B?ei9OZFNaV2s0dllLdkFYOGd3eUFKVHR4Q2RReFROTldELzkyZG40ZTZ3a0Zw?=
 =?utf-8?B?ZUZzdUVlTERSZjA5OG40c25IWW1UT0hlOFRxY0xpSEhoaGJGRzV0NzV5Wks5?=
 =?utf-8?B?ZE5nN29QMVNvNkQ2NmF2azc1d3l0blFxM0hReVlGSUZXYlN6YXZTd2lzM2Nu?=
 =?utf-8?B?TDdTWFFaNmZZbjRjK0d6QUdWQXMwcEhkMkFSWW5GWjh1OU9KODdFWnNFempV?=
 =?utf-8?B?bHZXdkd1Q1hXZ3d4emtIWEJhMWRoRmk3YktCMUNBbmo5TWRxTElRMk1BcGd6?=
 =?utf-8?B?aDhpNEZ2NVlXTFN4TDl6TjNqdEVvcUtPeFRKSEIzYU5iVWRrZGoxbE5CMnZr?=
 =?utf-8?B?OEVubGV2akdOZWQzUVFlS3JIQk1pNVRoc0p2R1dCamNFTGNiMGFTaUgrWkNv?=
 =?utf-8?B?aWtNMDdSM29uNFF2dnpORXFIdXRoZjJvK01lVWZ5NkhUeEUrdWpvOUs3QU5t?=
 =?utf-8?B?UDJtYnRMbEh6dlgralBuOU5CM0FEZzlqYzBSRUhTZDJNME5iRk02a2IyYjNO?=
 =?utf-8?B?cGV0ZTFTNWFQazBDczNzNEQvVHFyVnRMSTlDcjZoT1ZjeVJqZy8yS002QW5j?=
 =?utf-8?B?dzJQRkVzR0R6Vm5rSWZyTFVHUGFkTVdUcnlnWGRCMjViNjhTbWlDWWdQdndr?=
 =?utf-8?B?R0N0QW1Td2kzbDBKVXVhZGhaWGQ4dlNlZ24zcE0zZ2lLWXppRHBtSzZOTlli?=
 =?utf-8?B?NVFCMkhIWERxaEdCcVgrYXhpUkpkL2Z1bzRJb2gwM1d2cTdWc1JadVB5WFJa?=
 =?utf-8?B?eGpOMmJRYnNRV29JYTZZcE5laEl3cFg2eVN1SmExWlI2S2ZiZDVFa252SFBH?=
 =?utf-8?B?c3NXWmlvTXdJdUE3Ym0xSjJLZTZTaVA5anh3VnE2RHQxaE95R1B2MmQ3amQ0?=
 =?utf-8?B?eXF0QkQ2bHhTTlJ4emp4dllWdjdnb2JoK3RzaGZYR1FkbTBIeWljWUYzNHVz?=
 =?utf-8?B?TUJUNVRMSnNaNUlHZlYvcDRkZHlqZEpnTjA4MVptT2Y5ME42Yzdab1drOTA2?=
 =?utf-8?B?TzhDaFBld21INDlUUy8vTDNUQkN1OW5MNlJuaWIxcHgxSlY2TTc0MCtOTXdm?=
 =?utf-8?B?K2kxSzRzekVlQ2YrQmExM1pMbm9HRk9XN3BFOFl5dlN1ZDBmNjF5d05KMExU?=
 =?utf-8?B?U0RQMjNqMWFqZElpblUyN1FJeVpsakRSa05HN2dhcUZkd3Zrb0NtWUczVDJp?=
 =?utf-8?B?NnZGdElNZ2RBNkRZdGtOQ1dwNGJ5RzJZRDRzdVBpSlhCSmF2QmNFemtoSThQ?=
 =?utf-8?B?SHNncWFPLzRhd0w0YXJsWU5EdWN2Rm5tYTcyOUVkR1RjcmRQYitVV0ZzYW54?=
 =?utf-8?B?Y2FvUEpjQm1YeUJrUkNhMzMzQ3NBbno3V2ZrbWVkMUp5c3BBM005UHkrakha?=
 =?utf-8?B?cW5XU3NBVGkzeUpBajE4WHpUM0ErdkJvcEZxOVRRUDZMWEkyK3c5RCtjMTdo?=
 =?utf-8?B?QVNQc2lGclJtNityMitweXRkTHQxdzVmcDVoa0FPQ3Y2ZHdNQWJKK1BkYmtm?=
 =?utf-8?B?dC8rNHhnYitFbUl3V2ZSNGlTNWlGMTZCSGJUK3JsM28raTZsWlc5NzJFT0k0?=
 =?utf-8?B?TmFtajZMQ0x0b1d6NlltWlF4SXFoc2FUWElyc0FMQVNuL25sUE1Hdi9EcGJr?=
 =?utf-8?B?VXM5SkxqRHdPTFU1YldZMlA2RFBXMWFZSHV0Tlp0bXl4WGtMRUVJQnUvSGZO?=
 =?utf-8?B?ZTFEV2NVNEhaeGNSRFdobjd1UjVUVlJFdDJIeWlObUQvR1lPbjhnejBJQVhE?=
 =?utf-8?B?ek4rRFhjRGlFNTdnSFdKZ0xrWDZ4Q0xPblAxSUwrTzA4MjNOSTgreU5JYU9V?=
 =?utf-8?B?dFM4RGxVU2d3RExJNjJlUHlKRUlLNlVhdmxDT1VXY2dYdFVqVmZIMG1wMFdY?=
 =?utf-8?B?OVEvYUU4RFVQRDNncjF2TjFhVFN1OTdWUTJiUlVnZ1BpUWMyWGo1TWRGU0RU?=
 =?utf-8?B?dGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFCCB215AE9FE4409F4BE7224395CAA4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 881f249a-cd71-4ec1-af87-08dacd303201
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 08:53:30.7129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ATWFNRhcQae4KZBOvoar7drij88lHtkY8Q3xib2x7/+mkur6ERWuEARM++fZz1+R8rGJdpLmq0xycDTm13jmvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5304
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDEwOjA2ICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gTW9uLCBOb3YgMjEsIDIwMjIgYXQgMDE6MjY6MjdQTSArMTMwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiA+ICsvKg0KPiA+ICsgKiBXcmFwcGVyIG9mIF9fc2VhbWNhbGwoKSB0byBjb252ZXJ0
IFNFQU1DQUxMIGxlYWYgZnVuY3Rpb24gZXJyb3IgY29kZQ0KPiA+ICsgKiB0byBrZXJuZWwgZXJy
b3IgY29kZS4gIEBzZWFtY2FsbF9yZXQgYW5kIEBvdXQgY29udGFpbiB0aGUgU0VBTUNBTEwNCj4g
PiArICogbGVhZiBmdW5jdGlvbiByZXR1cm4gY29kZSBhbmQgdGhlIGFkZGl0aW9uYWwgb3V0cHV0
IHJlc3BlY3RpdmVseSBpZg0KPiA+ICsgKiBub3QgTlVMTC4NCj4gPiArICovDQo+ID4gK3N0YXRp
YyBpbnQgX19hbHdheXNfdW51c2VkIHNlYW1jYWxsKHU2NCBmbiwgdTY0IHJjeCwgdTY0IHJkeCwg
dTY0IHI4LCB1NjQgcjksDQo+ID4gKwkJCQkgICAgdTY0ICpzZWFtY2FsbF9yZXQsDQo+ID4gKwkJ
CQkgICAgc3RydWN0IHRkeF9tb2R1bGVfb3V0cHV0ICpvdXQpDQo+ID4gK3sNCj4gDQo+IFdoYXQn
cyB0aGUgcG9pbnQgb2YgYSAnc3RhdGljIF9fYWx3YXlzX3VudXNlZCcgZnVuY3Rpb24gYWdhaW4/
IE90aGVyDQo+IHRoYW4gdG8gdGVzdCB0aGUgRENFIHBhc3Mgb2YgYSBsaW5rZXIsIHRoYXQgaXM/
DQo+IA0KDQpJdCBpcyB1c2VkIHRvIGF2b2lkIHRoZSBjb21waWxlIHdhcm5pbmcgYXMgc28gZmFy
IHdpdGggdGhpcyBwYXRjaCBpdCBkb2Vzbid0DQpoYXZlIGFueSBjYWxsZXIuICBXaXRob3V0IHRo
ZSBfX2Fsd2F5c191bnVzZWQsIHRoZSBjb21waWxlciB3aWxsIGNvbXBsYWluLg0KDQpPcmlnaW5h
bGx5IGl0IHdhcyBpbiB0aGUgcGF0Y2ggIlNodXQgZG93biBURFggbW9kdWxlIGluIGNhc2Ugb2Yg
ZXJyb3IiIHdoZXJlIGl0DQp3YXMgZmlyc3RseSBjYWxsZWQuICBEYXZlIHN1Z2dlc3RlZCB0byBt
b3ZlIGl0IG91dDoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzZlZDI3NDZkLWY0NGMt
NDUxMS03MzczLTU3MDZkZDdjM2YwZkBpbnRlbC5jb20vDQo=
