Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5434B74230A
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjF2JP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 05:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjF2JPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 05:15:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDBB2122;
        Thu, 29 Jun 2023 02:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688030146; x=1719566146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fN7VyP4WgDZ45u5vM1LVbbGXx9v7jRA2y8/eTLWo6rc=;
  b=MDxohnCDUZPcLxBzhTRnMfmMAD1WwIrpyDn/goDjwXdGDaoZfRV/RB+A
   Ha5YneV1jC+6dGy3AQRISI147aza8ArBtFUz3qyCgjl2mHGN4FKmfUd/S
   AwPExXAyX8GsYRGM2Y4v4MiN9Llmu+5ijA8WUSeCAxRIwc0FwE8fFbtzF
   IqJnCtjIToHKbcIU9BsnXhBOnXM5zTj9jlssvnFSM5y8v183i1vNdSjUb
   r9viW5vlpo3BU5U9rAu+Ykx+m3atNkHzY1t7z4mYmRnRzAqSsfc8YiJHo
   p9YP2AKH5UAJg139H0zkWGQnYQF2tHPASf10NwLH4PDs/6tZfoM8TRJq8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="428081919"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="428081919"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 02:15:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="807238078"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="807238078"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jun 2023 02:15:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 02:15:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 02:15:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 02:15:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mialnqw5S2XslyHsU8+oVai9VUvBiIHCjp49ZQviQwBUa/91kJwLkDYI4LQHSkrpcrDhAor/7VK4zbQWC8DBYkupUSjlh5y/s8WjUIJOPW63tZvSzDPOBYhtsoNtyqskgkPXbkY9sJ1JCfX8y4ESXXPJB3Dz2GDnoXy2E803NiRumPHg0uOxkzInPK/C+RWZbwe+KQuSmzofST2ptLlgA+xX4jxyCsltrLWjcYZubBnUIKy1gViDsMItmmpMSRXNP1Rrz2KDbGtRhhwYNgLaExQCGsCw4qoocWXzauk/DQQH/mAskKoaMNrLFp0HaETaj4qAZjclkZ3jNSRyQ4Gu+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fN7VyP4WgDZ45u5vM1LVbbGXx9v7jRA2y8/eTLWo6rc=;
 b=Ic7LmxglPUfS5dcEPs/r0aZbJfVbuqKnIVbxIoZigFfc1nYNnxEvO/1Qgtk29ezDrKKGfVuzOXSstox0OzBwR7hPXvTQFVojcAUbkeHKSzHben/QkubHi6ZRXUCPU1F23nF++Gaz7Z3ZzaFKqNrsRzymQnTIf1X6M2MOqVBQ9pEfufMvY087boxPCJWoYT024XktQsRgJqSk4o5/xxZ/PBrNp1p4xZgU+VZBbqDh32TplOd9aviMmgPkoCrWd0ZbN9RGb3kfWKrHqCKd5AyXKeIIvvhDHBMJwJ1pVCoJLLU5xIurza1w4K2TE5efqQwxmyO7UyNbID3FRgEXxTNDeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7543.namprd11.prod.outlook.com (2603:10b6:510:26c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 09:15:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 09:15:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZqDWtVIac1znuLUmerNJjHJZ1la+gRBWAgAFABgA=
Date:   Thu, 29 Jun 2023 09:15:39 +0000
Message-ID: <d759c22d1360a56aa43796700a7fa3a9106d9fa9.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
         <20230628141011.GG2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628141011.GG2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB7543:EE_
x-ms-office365-filtering-correlation-id: ccc80ba2-debd-4186-d294-08db78816810
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GsqTHlAnfyoS0NsjQYhsK2z+B5FqIKuGp0G9ed5XvwSLUTPMVLa0RY/iKVJ3ClVLWv90nI+wPyhaqUrQeUezbE3HFE0GBzG2n/8sGwHAJELtEvS3hSKHdMhFvr6bT7164sMCbH+O3DfGj3jRCuegs4NsuJW1C1d3phK/r4qi4SnR7II507xyKlDwtocNFc5iSc/BGYXX+1xKZ3tEAPjPuPc0F7NNyqijtk3FG3JyAG2XofTN4ybgzECGXQ+j9i0qDDYH5uyuLlLVrNJpV84esgau2o5pSXFpGt5ZvRIcAC2LpX2+5MP9M+7dHgjMfPRWQXFnkJgoKuSOLsfHzX/Io8Stu65Ku9SZb+aF09qFGO5bAcoj3BKVU+00mDFD0TDjKQN4bjAvbO/GgNH6Dw2lhin3HitlIQslhd0k8RbWHPHouE2pPdV5VMa/SMQ9CeWPP3kpIoTMspILQA6sSWr8zp7e9VTnWt90IpW2CJn38Z23nc3x58yG50txT9ZabVSZ2xWvAP1UVWeo5dY9y+3/622hOYx8RMPt1FsrGwPiOaUeu8hFiNIeCaMhxkoAxOG6M73GUoHdz+Q0WqkYy+sB5EbVl5tUhw/swR5Gzdr0fHN4IHLkLn04NNLhynVH8oHaI1VZZXjusCty4Cka4rmLDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199021)(41300700001)(8676002)(8936002)(6512007)(36756003)(2906002)(6506007)(186003)(26005)(66946007)(66446008)(66556008)(54906003)(91956017)(38070700005)(6916009)(316002)(38100700002)(66476007)(4326008)(64756008)(86362001)(6486002)(76116006)(2616005)(71200400001)(122000001)(478600001)(82960400001)(966005)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTF5RjRWL3NQNzJkSUVHSU5ZY3VES2dWWEM1eFM4dVpHbnFxZnZsM0hwZDZu?=
 =?utf-8?B?Q01mRnd6c1FudWxSSTlPY2E2ZEJHMWRyajNzYTgrVWtvZXgwMm0zSndkdFln?=
 =?utf-8?B?bGFIYjRpbFJodERWSytuQURCY3ovK05hOHcvcWlGMlR0UjhyL1hhcGxjUkR2?=
 =?utf-8?B?bVp0YXRoaFN0V3VMVW1VaXhockpGaTQyajJSdFJmZ1hURnJLM1U2MEN2eVZ1?=
 =?utf-8?B?TkI2VkJJdkVhd2xaeGt4OXlxWHU1SVJWLzRxNWJWcG4rb2ZzMkhoV3BQSDR0?=
 =?utf-8?B?YzZWTldJUklmWXk0RjZqdis1YVVCOURkVkd6VzQ4S0F0TnpBb25TSk55SWlS?=
 =?utf-8?B?Q29PZGxLV2pWWGYzRzRNK202YzAwaG42L2N0T2FLRHBWNkZUSVBtUURCMm5M?=
 =?utf-8?B?NG1BQ29QalNXK2FVc0dLVGZ2L2krU1R4UkYyL0lVM1U5cnpXL1RITUxmRzFP?=
 =?utf-8?B?UERSSzJ3QUpMQkJJa3pSTzZya1IwOG5UcU5wUFV2eU5HK0RiT1JLUVk0Wm5N?=
 =?utf-8?B?UFhzZHd5Y3Q5VytpVy8rK3hQYTZGT29HM0hMVGV5ZzY0K0ZqMDVRK0NhbEp0?=
 =?utf-8?B?Q2g3SWZBSXJGK0hxOFcwWE5ELzQ0Z0RpeVppTE5qV2tLZStKdnFMaXlRTjkx?=
 =?utf-8?B?STFiTUgvbHRXVmxtaEN6bE9WazFpMjJnTVQxNzg4LzdaWlRnSWZSWmJaUDFD?=
 =?utf-8?B?ZmNuYmlkQUtVeVEzUG5vS3dxajEydzI3QVVHVU5TZStjeW9xV29aNUh6NmEx?=
 =?utf-8?B?ZGhuWnUrSlBSRHdiUXA2cmhyUVFyUmJlQmJMZmE3SERWenR3SDNVTFRxMlNY?=
 =?utf-8?B?VlpaSXJkZmR0RnFsMXN2SkRWZlhjQ2hFaEVsaERWQkZMYjJrSVlCbHNnK0x1?=
 =?utf-8?B?MGc3T0Z2ZnpDazcydUVsa0Nwc3JWRU82b1ZuUS8wT2k2NTFnbVZEcGNMa3Ft?=
 =?utf-8?B?RE5xSWJGUk45YjlMMmpHNVVXRmQ5QVplamlQblg3Q25pbTBPenlTcHBSNUpV?=
 =?utf-8?B?NUNiaCttQ0Rjbnk1WnNob1RTM04zR3NHaXJEZGljS200ZFVoaFlIaEhLMGhR?=
 =?utf-8?B?enJFdEVGNndpeExoWXRTR2pVNFpmNEpWZzdiTFRJQk8rdmwvUWpmVEowRVhE?=
 =?utf-8?B?Z2J4SCsya2Y2SzFybWhSRmdab09uT0RNYk0rVXZHQ1VjNVE5MWlpY0M5S3hV?=
 =?utf-8?B?Y29Yd1ZuaDBoVUx5b3NCV0hPZ1lON2txVzFFTWdWdk42d0M2WitaanZYQkx6?=
 =?utf-8?B?dHBlbHlnUkVLZ2NwbG1EKytXNnlRRmlBeEVRTUYwbzIwN2FLWUN1SFBuUVMv?=
 =?utf-8?B?RVVOZFIyMEd6K0UvZi9jRmNuaWY3MEtmUnBqUjJld3hWTWc1TE40M1lEVThz?=
 =?utf-8?B?emRTSlpBejlHM2JtY2xibTlySWNNd3FyVlRKOE1NME0rQkJRYUR6Y0pOb1Vk?=
 =?utf-8?B?bzlORVVXa1hVbUc2WldwZWJabjJCbzZTWjAySHhlYjhhYm94L0hXQit3dnFG?=
 =?utf-8?B?SmgyNXNuYWF5a1crMmV1Wms1QVZtcW1NWUJLZ2lzd0t0OGF1MGxMSEJ5Umo0?=
 =?utf-8?B?aWtpWVF0bkZkbnZFMzdEL1MwdEF2aGVrajQ5TUNUVy8yMnU1aFV6OGRMZ21N?=
 =?utf-8?B?ZXpsMGI4OUd5WDVPWC81Wm1JYkt1NGF0SmNTRVhtMHJQRTJCUHN5UTd4YmxN?=
 =?utf-8?B?NFozZjVWKzg0L3ArVEtXV01sNEw4ZjRoeXlwTUc3WWZMcVFLbTk2azFsUXRW?=
 =?utf-8?B?YlZCNWFkWWkxL1VEVTU2UkxLOW5aOCtYVFB2bnBzU3F5K0NlM0VCWGNsYTZz?=
 =?utf-8?B?WDNzazFFc21SaXNnaE1rQzFJVVlIdC9zR1Z5aXM5UEhka1RaNWR0T0NaVCt4?=
 =?utf-8?B?ZFJKNDlDQ3VaazN1SzNLNThlOFVXMzBYdkJqbDYzelZ0TFNOOWcwL2xZZGd0?=
 =?utf-8?B?R1NNb3BTTXZYc0R6ZlZJU0QvRmc0a3ovQlErbnR6Z0g4R3FzaFhhUTBUN25w?=
 =?utf-8?B?cnBpbXBQc2dBZ25TUnF3WG9BaWRZSEhsYnI1TlJ5V0p1Nmoyclp4SC9TL3pq?=
 =?utf-8?B?ZEZwQUMwR20rZ2ZyMEsreEZ0ZGNtWm0yZVJQVW15UXZqTmk0VXRmQWNqMC9O?=
 =?utf-8?B?WnhNZzNkdVRJUExXRHovR2hWa3dFRXdyMDlpS1VJS2FtZ25kRHNMUEh2a0FU?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <587A221AAA52204FA6894A7F3602E9D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc80ba2-debd-4186-d294-08db78816810
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 09:15:39.4842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fek71N9IWa3/88sbwSGNWOczer8ZqKhosE0h01l9LQ+lsmgNeyh67xIdSC0XKJJ0gsYOn9JiutXqj0choPjidw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7543
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE2OjEwICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6MzhBTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiA+ICtzdGF0aWMgaW50IHRkeF9nZXRfc3lzaW5mbyhzdHJ1Y3QgdGRzeXNpbmZvX3N0
cnVjdCAqc3lzaW5mbywNCj4gPiArCQkJICAgc3RydWN0IGNtcl9pbmZvICpjbXJfYXJyYXkpDQo+
ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhfbW9kdWxlX291dHB1dCBvdXQ7DQo+ID4gKwl1NjQgc3lz
aW5mb19wYSwgY21yX2FycmF5X3BhOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlzeXNp
bmZvX3BhID0gX19wYShzeXNpbmZvKTsNCj4gPiArCWNtcl9hcnJheV9wYSA9IF9fcGEoY21yX2Fy
cmF5KTsNCj4gPiArCXJldCA9IHNlYW1jYWxsKFRESF9TWVNfSU5GTywgc3lzaW5mb19wYSwgVERT
WVNJTkZPX1NUUlVDVF9TSVpFLA0KPiA+ICsJCQljbXJfYXJyYXlfcGEsIE1BWF9DTVJTLCBOVUxM
LCAmb3V0KTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4g
Kwlwcl9pbmZvKCJURFggbW9kdWxlOiBhdHRyaWJ1dGVzIDB4JXgsIHZlbmRvcl9pZCAweCV4LCBt
YWpvcl92ZXJzaW9uICV1LCBtaW5vcl92ZXJzaW9uICV1LCBidWlsZF9kYXRlICV1LCBidWlsZF9u
dW0gJXUiLA0KPiA+ICsJCXN5c2luZm8tPmF0dHJpYnV0ZXMsCXN5c2luZm8tPnZlbmRvcl9pZCwN
Cj4gPiArCQlzeXNpbmZvLT5tYWpvcl92ZXJzaW9uLCBzeXNpbmZvLT5taW5vcl92ZXJzaW9uLA0K
PiA+ICsJCXN5c2luZm8tPmJ1aWxkX2RhdGUsCXN5c2luZm8tPmJ1aWxkX251bSk7DQo+ID4gKw0K
PiA+ICsJLyogUjkgY29udGFpbnMgdGhlIGFjdHVhbCBlbnRyaWVzIHdyaXR0ZW4gdG8gdGhlIENN
UiBhcnJheS4gKi8NCj4gDQo+IFNvIEknbSB2ZXhlZCBieSB0aGlzIGNvbW1lbnQ7IGl0J3MgZWl0
aGVyIG5vdCBlbm91Z2ggb3IgdG9vIG11Y2guDQo+IA0KPiBJIG1lYW4sIGFzIGdpdmVuIHlvdSBh
c3N1bWUgd2UgYWxsIGtub3cgYWJvdXQgdGhlIG1hZ2ljIHBhcmFtZXRlcnMgdG8NCj4gVERIX1NZ
U19JTkZPIGJ1dCB0aGVuIHNvbWVob3cgbmVlZCBhbiBleHBsYW5hdGlvbiBmb3IgaG93ICVyOSBp
cyBjaGFuZ2VkDQo+IGZyb20gdGhlIGFycmF5IHNpemUgdG8gdGhlIG51bWJlciBvZiB1c2VkIGVu
dHJpZXMuDQo+IA0KPiBFaXRoZXIgZGVzY3JpYmUgdGhlIHdob2xlIHRoaW5nIG9yIG5vbmUgb2Yg
aXQuDQo+IA0KPiBNZSwgSSB3b3VsZCBwcmVmZXIgYWxsIG9mIGl0LCBiZWNhdXNlIEkndmUgbm8g
aWRlYSB3aGVyZSB0byBiZWdpbg0KPiBsb29raW5nIGZvciBhbnkgb2YgdGhpcyzCoA0KPiANCg0K
U3VyZS4gIEhvdyBhYm91dCBiZWxvdz8NCg0KKyAgICAgICAvKg0KKyAgICAgICAgKiBUREguU1lT
LklORk8gd3JpdGVzIHRoZSBURFNZU0lORk9fU1RSVUNUIGFuZCB0aGUgQ01SIGFycmF5DQorICAg
ICAgICAqIHRvIHRoZSBidWZmZXJzIHByb3ZpZGVkIGJ5IHRoZSBrZXJuZWwgKHZpYSBSQ1ggYW5k
IFI4DQorICAgICAgICAqIHJlc3BlY3RpdmVseSkuICBUaGUgYnVmZmVyIHNpemUgb2YgdGhlIFRE
U1lTSU5GT19TVFJVQ1QNCisgICAgICAgICogKHZpYSBSRFgpIGFuZCB0aGUgbWF4aW11bSBlbnRy
aWVzIG9mIHRoZSBDTVIgYXJyYXkgKHZpYSBSOSkNCisgICAgICAgICogcGFzc2VkIHRvIHRoaXMg
U0VBTUNBTEwgbXVzdCBiZSBhdCBsZWFzdCB0aGUgc2l6ZSBvZg0KKyAgICAgICAgKiBURFNZU0lO
Rk9fU1RSVUNUIGFuZCBNQVhfQ01SUyByZXNwZWN0aXZlbHkuDQorICAgICAgICAqDQorICAgICAg
ICAqIFVwb24gYSBzdWNjZXNzZnVsIHJldHVybiwgUjkgY29udGFpbnMgdGhlIGFjdHVhbCBlbnRy
aWVzDQorICAgICAgICAqIHdyaXR0ZW4gdG8gdGhlIENNUiBhcnJheS4NCisgICAgICAgICovDQog
ICAgICAgIHN5c2luZm9fcGEgPSBfX3BhKHN5c2luZm8pOw0KICAgICAgICBjbXJfYXJyYXlfcGEg
PSBfX3BhKGNtcl9hcnJheSk7DQogICAgICAgIHJldCA9IHNlYW1jYWxsKFRESF9TWVNfSU5GTywg
c3lzaW5mb19wYSwgVERTWVNJTkZPX1NUUlVDVF9TSVpFLA0KQEAgLTIyOCw3ICsyMzksNiBAQCBz
dGF0aWMgaW50IHRkeF9nZXRfc3lzaW5mbyhzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCAqc3lzaW5m
bywNCiAgICAgICAgICAgICAgICBzeXNpbmZvLT5tYWpvcl92ZXJzaW9uLCBzeXNpbmZvLT5taW5v
cl92ZXJzaW9uLA0KICAgICAgICAgICAgICAgIHN5c2luZm8tPmJ1aWxkX2RhdGUsICAgIHN5c2lu
Zm8tPmJ1aWxkX251bSk7DQogDQotICAgICAgIC8qIFI5IGNvbnRhaW5zIHRoZSBhY3R1YWwgZW50
cmllcyB3cml0dGVuIHRvIHRoZSBDTVIgYXJyYXkuICovDQogICAgICAgIHByaW50X2NtcnMoY21y
X2FycmF5LCBvdXQucjkpOw0KDQpPciBzaG91bGQgSSBqdXN0IHJlcGVhdCB0aGUgc3BlYyBsaWtl
IGJlbG93Pw0KDQorICAgICAgIC8qDQorICAgICAgICAqIFRESC5TWVMuSU5GTyB3cml0ZXMgdGhl
IFREU1lTSU5GT19TVFJVQ1QgYW5kIHRoZSBDTVIgYXJyYXkNCisgICAgICAgICogdG8gdGhlIGJ1
ZmZlcnMgcHJvdmlkZWQgYnkgdGhlIGtlcm5lbDoNCisgICAgICAgICoNCisgICAgICAgICogSW5w
dXQ6DQorICAgICAgICAqICAtIFJDWDogVGhlIGJ1ZmZlciBvZiBURFNZU0lORk9fU1RSVUNUDQor
ICAgICAgICAqICAtIFJEWDogVGhlIHNpemUgb2YgdGhlIFREU1lTSU5GT19TVFJVQ1QgYnVmZmVy
LCBtdXN0IGJlIGF0DQorICAgICAgICAqICAgICAgICAgYXQgbGVhc3QgdGhlIHNpemUgb2YgVERT
WVNJTkZPX1NUUlVDVA0KKyAgICAgICAgKiAgLSBSODogVGhlIGJ1ZmZlciBvZiB0aGUgQ01SIGFy
cmF5DQorICAgICAgICAqICAtIFI5OiBUaGUgZW50cnkgbnVtYmVyIG9mIHRoZSBhcnJheSwgbXVz
dCBiZSBhdCBsZWFzdA0KKyAgICAgICAgKiAgICAgICAgTUFYX0NNUlMuDQorICAgICAgICAqDQor
ICAgICAgICAqIE91dHB1dCAoc3VjY2Vzc2Z1bCk6DQorICAgICAgICAqICAtIFJEWDogVGhlIGFj
dHVhbCBieXRlcyB3cml0dGVuIHRvIHRoZSBURFNZU0lORk9fU1RSVUNUDQorICAgICAgICAqICAg
ICAgICAgYnVmZmVyDQorICAgICAgICAqICAtIFI5OiBUaGUgYWN0dWFsIGVudHJpZXMgd3JpdHRl
biB0byB0aGUgQ01SIGFycmF5Lg0KKyAgICAgICAgKi8NCiAgICAgICAgc3lzaW5mb19wYSA9IF9f
cGEoc3lzaW5mbyk7DQogICAgICAgIGNtcl9hcnJheV9wYSA9IF9fcGEoY21yX2FycmF5KTsNCiAg
ICAgICAgcmV0ID0gc2VhbWNhbGwoVERIX1NZU19JTkZPLCBzeXNpbmZvX3BhLCBURFNZU0lORk9f
U1RSVUNUX1NJWkUsDQpAQCAtMjI4LDcgKzI0NSw2IEBAIHN0YXRpYyBpbnQgdGR4X2dldF9zeXNp
bmZvKHN0cnVjdCB0ZHN5c2luZm9fc3RydWN0ICpzeXNpbmZvLA0KICAgICAgICAgICAgICAgIHN5
c2luZm8tPm1ham9yX3ZlcnNpb24sIHN5c2luZm8tPm1pbm9yX3ZlcnNpb24sDQogICAgICAgICAg
ICAgICAgc3lzaW5mby0+YnVpbGRfZGF0ZSwgICAgc3lzaW5mby0+YnVpbGRfbnVtKTsNCiANCi0g
ICAgICAgLyogUjkgY29udGFpbnMgdGhlIGFjdHVhbCBlbnRyaWVzIHdyaXR0ZW4gdG8gdGhlIENN
UiBhcnJheS4gKi8NCiAgICAgICAgcHJpbnRfY21ycyhjbXJfYXJyYXksIG91dC5yOSk7DQoNCj4g
U0RNIGRvZXNuJ3Qgc2VlbSB0byBiZSB0aGUgcGxhY2UuIFRoYXQgZG9lc24ndA0KPiBldmVuIGxp
c3QgVERDQUxML1NFQU1DQUxMIGluIFZvbHVtZSAyIDotKCBMZXQgYWxvbmUgZGVzY3JpYmUgdGhl
IG1hZ2ljDQo+IHZhbHVlcy4NCj4gDQoNClREWCBoYXMgaXQncyBvd24gc3BlY3MgYXQgaGVyZToN
Cg0KaHR0cHM6Ly93d3cuaW50ZWwuY29tL2NvbnRlbnQvd3d3L3VzL2VuL2RldmVsb3Blci9hcnRp
Y2xlcy90ZWNobmljYWwvaW50ZWwtdHJ1c3QtZG9tYWluLWV4dGVuc2lvbnMuaHRtbA0KDQpGb3Ig
dGhpcyBvbmUgeW91IGNhbiBmaW5kIGl0IGluIGhlcmU6DQoNCmh0dHBzOi8vY2RyZHYyLmludGVs
LmNvbS92MS9kbC9nZXRDb250ZW50LzczMzU2OA0KDQoNCg==
