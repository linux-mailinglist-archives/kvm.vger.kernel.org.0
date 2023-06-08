Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF0B72750F
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 04:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbjFHCke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 22:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjFHCkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 22:40:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AC613D;
        Wed,  7 Jun 2023 19:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686192032; x=1717728032;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kzxNudaBUG/B4dqx6u6RSF11KUjdyMS5AYtxbiyZJoI=;
  b=m6kt8pQkyQNpJA7/ESexKeq1Waxx0+HygpBr7/oNeIUw87HmgsgG+1Uk
   NjxTzo/V3kcjyVvsGvOOzgGrT1U0S7lvuLnrpioB1ShlQVZJb/UF4txA9
   TSoJjZlxL9L1yy6xvkDpxd90UgP7zdKfic3ai82rH27jx26dO7OuK8BU0
   Pi85f6ie5In9NY0xLBtTluZ5Nhy9VRyS+kL5Duqxt5o0i8hunD/mtX1b/
   TVmCJcXQ+W6KUkwgUT8emX6gqex6Qw3gFqi732HVMCk3FAuTX+QM+Y8w3
   tVeHMzZW6qmnBYckuIz/EGEqI6sofh5JWiisN/SlIubEXH75t1LsfwhuP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="359648496"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="359648496"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 19:40:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="833983847"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="833983847"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 07 Jun 2023 19:40:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 19:40:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 19:40:31 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 19:40:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8/nk0DdDoLMrJg2wK/Io7umR3TLMgmwY9RwvPmMf46QgOLADbULakm8JIDmwImkDqMBKh3dIAyb1CS0kKYTkLUVAk2Lfc1s+/xum4JrFYqcQPGZoY2l0YDrR1oti/PvtuQcdN9HZRlYTczUQN2BVb6e2Vc0S07o5lZ2jFfssH1U207OfCdymhD9xeGFcwXgKjFYkq6Iw1hjdz2Om4E7GhhnFmfZMua0am2cJPa8L9RpiUwTSgdqUk3IkkP38L+LRz1H8W8ANMKNj5HnpX0DbvoyXsQJ6EDIJNhP0f/pFkiOQdV2Nlxg0gZg+re/nVOAolGL/q+WZnzZOXZz73i+DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzxNudaBUG/B4dqx6u6RSF11KUjdyMS5AYtxbiyZJoI=;
 b=QJ+ytgL28AKa/xlCPDzT64Vzd6QCZmqphyvqRE7VzFUfjLdnXBr8ZUlZWd4MYS/5yfQB7zLxTIS5J05XiwKBVNjBu8V7xIl9vkqnLE1d1QmKEZ8vRzNkkl1edB6zkBg87RK/aUbwfn/2x6YbsD/kNIqVeoVUTH0XUzkz5SdLmeOGX7DqMnmYSHUZikqo+sAOrV1z6umDJS7BQw1UnyPFFOOaXeC9yEkFekuVNphn0bViJHymYfQvvn38hHkYUuHfRzCBuhnONNQ4c08yr7Om5OJ3s0aNpZgSHYTw+vhLjE+BLkBj+C/aAcelh9eSycHHJLhKVmk6vJgv0u27qeUytA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6055.namprd11.prod.outlook.com (2603:10b6:510:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Thu, 8 Jun
 2023 02:40:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 02:40:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZlu+wT+VnAmvfKka8EfWTldC51a+AEh+AgAAlKYA=
Date:   Thu, 8 Jun 2023 02:40:27 +0000
Message-ID: <19ea7470e9d6fa698f9ad7caff3279873e530a0b.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
         <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
In-Reply-To: <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6055:EE_
x-ms-office365-filtering-correlation-id: 3e040fbd-2b63-4a94-f2dc-08db67c9b82c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3SST0BL1a8t3W5tAoM7eYnghmWuea1jCyyBub/SGXCnyhGQjixuv8UuRx9HemgFZoufIOBMlJ+UXlhIRHxokTZAY49F4tofDQ5+y6Ir3dvK+S3nPnN5ReVoHfq8HRQfayuU6/sv31HFH521fjGVg2So6zkS8or0ERWreCunEkyZaOOaifVkUOsEZV4BHtk25XTI+JuIQf3WT8NLhyyUmCiLkglXcO85az2mqPmrSxg/rQTa6Pb3lxhrDOczM9xSXGFj0EDL3VUs2SX8RHWmRr8qop8Xs+HkBPQxf4kXvRh4qdZTYHEFLs2rRXWKvJSd9Hk+a3jkXzf7N8YGjCgQr0OoRk52JW9x0jfdn3tVLd681X9R7+tSRIcF/ZhY6fwvVerQZNlFKjjuNVK8VmXopRzyt39n5Rgwsuj/Z3UffeOJdQoPPCf/840TtifGyVJ+OBwxgG7ND1JWF52memMQbyNZus9+6aVEsmYlCahrNR4DcN4p+/INczCOA/cvO0v6gnOOsDQjPk0ydxK5QWFf31Vck+qJ77/tJhktEZpUYcPTULQ+KR7Q9Wuv/XIZRTiZMQ33LRZU6pN4QnHGGO3quDI8plp2/PH4jUmcogpx7CU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199021)(26005)(6506007)(186003)(2616005)(6512007)(966005)(7416002)(83380400001)(36756003)(6486002)(71200400001)(2906002)(8676002)(8936002)(82960400001)(54906003)(478600001)(38100700002)(5660300002)(6916009)(122000001)(4326008)(86362001)(38070700005)(41300700001)(66446008)(66476007)(66556008)(64756008)(91956017)(316002)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVZzSWx5NVd1SVVPZzdMcUlpTGFXZFBGUlo5Y0VhMWFhSjBvR1dtTE91aDZw?=
 =?utf-8?B?eXBCSFhSR2Z5R2Rqb1dFLytzR3RqNzROYTRaV2VHQWNrTXlKRE5Gbkd6NzQr?=
 =?utf-8?B?VjAraTJWWmtlaTFFV2xvYlArTVRNZW5mWk1ZMHJ1cHg2ZzdmNGU0WVZ6aTNi?=
 =?utf-8?B?R0JkdS9yOUEvRm16dnN6cmJ3V3BJeXRnOS9iMnQzVWhJR0pWREtxZTlEbklQ?=
 =?utf-8?B?UmVlWStXejg0OHNDUHJQSDV0WHUvbVJKZHZCVUErSENZT20yOXVDRlVnekFV?=
 =?utf-8?B?NUxQclZkcU1kZGcxcm14dmkxSk1HbWUzdUJyYm96N0h2VG5vaEp3Q0lXVmdl?=
 =?utf-8?B?STJvUDNKSXlTdDVvd1FqUUNBRnlNeDkzSHVuUERNUkJVOEZ3am5UM01LVnIx?=
 =?utf-8?B?UHluZ1V6YTBzcjFNVnVlRTN5Z2pKVjZJMDVHNEdFMWJPNGFPdk9ScXhFdTd5?=
 =?utf-8?B?MzRGZHZxOWsyZHl2d2dIWW5qUThCS3FnWW9Hc1Q0dk5tOEswRjArV29hT3dG?=
 =?utf-8?B?UU5SM3NEZG9EZHJmbzZ0K21wOG1hL05TVXRHaHBUenRVK3JPQW5jVndVMENW?=
 =?utf-8?B?L0RDd2JXdHJVVjN6YXpGdjhOOVVIRFpUUkRlRFpBMm40VVNYdHlwa3IzdnZ5?=
 =?utf-8?B?UWFwRlhrcG1TSG5ZL2o1VlAxWXlKWTlMNEFSdElWRGtEWjlNUnIvT2RUdW5J?=
 =?utf-8?B?T3dFRFJUY2xsdmFjc080TUxrOEt2Z05NOVhKYU91UFVrUzhtSjdGNG5ra2Ev?=
 =?utf-8?B?Nk9nZzFJMThuYW1XcnlPMWttVWVCM0dmbmd6V3AyZWFzYjJnbEdEV1V3WStT?=
 =?utf-8?B?UHRaZjlaR3ZQSU4rZWQvYmkwTkw4Y1kzRU9XdUhGQUNaU003aHpZTzhlZy9V?=
 =?utf-8?B?N29Pa2lqbnl4ekJYTUg0Nm11Y3lqMjdBbm1HVTJ3R2FaMSthVC9QczNwS2ls?=
 =?utf-8?B?R1hxUDAwUGFQbGEwdDVlMjZ5MFY3ejF5RmRWTWNpSzZld25EYUo0WFk0cjNs?=
 =?utf-8?B?TDVRbHRPYW1obkRaRzBMRmZORWo2YWpTbXFlN2xEbmhDb0tGd2F1dEsva2tt?=
 =?utf-8?B?blEyakc5K2hmcFhtZFQ5T3ZZVzIxR1NJbGk5VloxRDVoWEFldEFkS2lXZjBF?=
 =?utf-8?B?WEtFdVc3RkZMUDlnZ2JTMGVKakhWTXIvVFRQVGQvQUVEb3NFcHNhNS9QVHIy?=
 =?utf-8?B?VnZBWmU5enJMRWkyODNXZldUVFRISytEelQxS25ucytSZVRqby9QKzBMV0VD?=
 =?utf-8?B?MWltb3cwRTVlMTlrMmpVVi95NE9nUHpzR3AvVUw1SWFvTit2NGdHTGc0NWVT?=
 =?utf-8?B?Q3Zsc2xYbjR4cXRTM05PcG10Tkt0ZG4vdzVkYjZmSUhySmhIdDNGWTQzRFd1?=
 =?utf-8?B?VVlxUUZvcGVDTjVLZHFZM290ZkQvWXZmbzF1ZXo3b2JLRjZmRVZIK0lCdkJ5?=
 =?utf-8?B?elBMMExUSUJDNnF3TzdCZExEcGhlbWJRNHNROE5zY2ZCWVVKdEM1YnJnV0dN?=
 =?utf-8?B?d1pBY1JIbGNxdURBU0Z5amI3UC9UVlNoa05pa1B5RUJ6T25UVUVPbm9zMUJC?=
 =?utf-8?B?a0V4bUMybDQ4SGpXRnhZRFd3OE4xMGNxb24wZDA4TWVhNmRRczhuRUt5QUZR?=
 =?utf-8?B?VXRKTjk4UDg1QXZlUzZyR0UzSnVuZzdKRXAxS3FTcWw1ZHBjMEtjWjg0SW9P?=
 =?utf-8?B?NmNwOGZwUFRwNFFMNVR4L1NJOTF0RHZFYktVUkNTYTJMbnVJR3BleXEvc0Mv?=
 =?utf-8?B?VFg5VTdERm0zbHF3b3g0Q1B3KzFvTGd5RjR2MldJVzdIV09SNGFJeS9nU1h0?=
 =?utf-8?B?MEFXSUpFOWh6cTZPeVd4eTIza0ZQWXdscDVzb3dMaCs3cGFZUmY5Y1BIcCtl?=
 =?utf-8?B?VGg2NG9YMVZ6L2hhU1B5cU1DcXk5OUFpeHNCL0phMVhQUTJ3SGx2UTV0SEJM?=
 =?utf-8?B?QTM1QmorSXRSMFZkMlJrSll4bGx0MVp1Q1VrSUxibjUwUHpDbytUenAvQUlK?=
 =?utf-8?B?QzMyc1BLcm1YYUJlNEdtNElDT21TWE5DN3c3UXpDTmpyUGhBUDF4UFFvaVd4?=
 =?utf-8?B?MCtkVmZvYWtwS0ZrWDIrOTRhaEpMa2xCSnJ2RFhUR1hRSWRTTnlsUUlVR2Ry?=
 =?utf-8?B?U2YrZGlESXhxOW5jb21Cc01aczVraWM0ZlpYMTlBQThIL25Vb3licng2WnY0?=
 =?utf-8?B?dGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <743BB20E9E6EB54C88DBE6F6B49D1ACD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e040fbd-2b63-4a94-f2dc-08db67c9b82c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 02:40:27.8557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yePl1KHKJVSqOc+IZIqZ0dHPgDHdxZxpFr004qsuvyw9m3Jam7cgk358UeM4Fzi6MMCqjzr6XOgHccaTP6L5sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6055
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA2LTA4IGF0IDAzOjI3ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMjoyNzoyMUFNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gRm9yIG5vdyBib3RoICd0ZHN5c2luZm9fc3RydWN0
JyBhbmQgQ01ScyBhcmUgb25seSB1c2VkIGR1cmluZyB0aGUgbW9kdWxlDQo+ID4gaW5pdGlhbGl6
YXRpb24uICBCdXQgYmVjYXVzZSB0aGV5IGFyZSBib3RoIHJlbGF0aXZlbHkgYmlnLCBkZWNsYXJl
IHRoZW0NCj4gPiBpbnNpZGUgdGhlIG1vZHVsZSBpbml0aWFsaXphdGlvbiBmdW5jdGlvbiBidXQg
YXMgc3RhdGljIHZhcmlhYmxlcy4NCj4gDQo+IFRoaXMganVzdGlmaWNhdGlvbiBkb2VzIG5vdCBt
YWtlIHNlbnNlIHRvIG1lLiBzdGF0aWMgdmFyaWFibGVzIHdpbGwgbm90IGJlDQo+IGZyZWVkIGFm
dGVyIGZ1bmN0aW9uIHJldHVybmVkLiBUaGV5IHdpbGwgc3RpbGwgY29uc3VtZSBtZW1vcnkuDQo+
IA0KPiBJIHRoaW5rIHlvdSBuZWVkIHRvIGFsbG9jYXRlL2ZyZWUgbWVtb3J5IGR5bmFtaWNhbGx5
LCBpZiB0aGV5IGFyZSB0b28gYmlnDQo+IGZvciBzdGFjay4NCg0KDQpJIGRvIG5lZWQgdG8ga2Vl
cCB0ZHN5c2luZm9fc3RydWN0IGFzIGl0IHdpbGwgYmUgdXNlZCBieSBLVk0gdG9vLiAgQ01ScyBh
cmUgbm90DQp1c2VkIGJ5IEtWTSBub3cgYnV0IHRoZXkgbWlnaHQgZ2V0IHVzZWQgaW4gdGhlIGZ1
dHVyZSwgZS5nLiwgd2UgbWF5IHdhbnQgdG8NCmV4cG9zZSB0aGVtIHRvIC9zeXMgaW4gdGhlIGZ1
dHVyZS4NCg0KQWxzbyBpdCB0YWtlcyBtb3JlIGxpbmVzIG9mIGNvZGUgdG8gZG8gZHluYW1pYyBh
bGxvY2F0aW9uLiAgSSdkIHByZWZlciB0aGUgY29kZQ0Kc2ltcGxpY2l0eS4gIERhdmUgaXMgZmlu
ZSB3aXRoIHN0YXRpYyB0b28sIGJ1dCBwcmVmZXJzIHRvIHB1dHRpbmcgdGhlbSBpbnNpZGUNCnRo
ZSBmdW5jdGlvbjoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9jb3Zlci4xNjcwNTY2
ODYxLmdpdC5rYWkuaHVhbmdAaW50ZWwuY29tL1QvI21iZmRhYTM1MzI3ODU4OGRhMDllNDNmM2Nl
MzdiN2JmOGRkZWRjMWIyDQoNCkkgY2FuIHVwZGF0ZSB0aGUgY2hhbmdlbG9nIHRvIHJlZmxlY3Qg
YWJvdmU6DQoNCglGb3Igbm93IGJvdGggJ3Rkc3lzaW5mb19zdHJ1Y3QnIGFuZCBDTVJzIGFyZSBv
bmx5IHVzZWQgZHVyaW5nIHRoZcKgDQoJbW9kdWxlIGluaXRpYWxpemF0aW9uLiAgS1ZNIHdpbGwg
bmVlZCB0byBhdCBsZWFzdCB1c2UNCid0ZHN5c2luZm9fc3RydWN0Jw0KCXdoZW4gc3VwcG9ydGlu
ZyBURFggZ3Vlc3RzLiAgRm9yIG5vdyBqdXN0IGRlY2xhcmUgdGhlbSBpbnNpZGUgdGhlDQptb2R1
bGUNCglpbml0aWFsaXphdGlvbiBmdW5jdGlvbiBidXQgYXMgc3RhdGljIHZhcmlhYmxlcy4NCg0K
Pw0KDQo=
