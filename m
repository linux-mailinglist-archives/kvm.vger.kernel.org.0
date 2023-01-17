Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C9466D4E6
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 04:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbjAQDLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 22:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbjAQDLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 22:11:51 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCCD17145;
        Mon, 16 Jan 2023 19:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673925110; x=1705461110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8ZtziamPYwKKN1KpLuBDYO317YmqaBGIGZA6fPSg5dg=;
  b=h3RnEfpfBnLATEKWmm8+0/pwwxiasu+SS99TTSsS/X5q5jme/WSwkgRu
   pzTQ4fjduufZvGjSfAs6ToEGrHbNGF0Xqt/JOsQXUm6JYgiI5vYi+3d7K
   vYgruJp3RHTdsKcpfNkKjNIgwLwRIZLy+xlwgGc+hpXQRtQ9l9v+da/Ga
   0hpNJYQ4KLJBrARKiwGmcuB2f8FvTeSS4wR6n6XnZikli8US2JIl0Rce9
   oBA6yxN82jfUFMuRSunM8V7r4mRFy0eRjRoAQh6lrrZk0rIH/6PCWxhWX
   mWiVQLNrAv/ylPRLe+Fx2c59mPqrrTwzevVhliVPly2Pwsf/pREmTXnQ6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="323296989"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="323296989"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 19:11:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="833017079"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="833017079"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 16 Jan 2023 19:11:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 19:11:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 19:11:49 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 19:11:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQJuF/yxlj8vi54sj5AcOSAHTCxdwvvLeqvp55BzVY0SlpX6igq8hFRsy1DH8Y5nxbOGa/EGDV2K/jWc3QzgFKO8ittoh4IkWJchQdrGU8f7Br3qJFv/CfuzumviRmh+h9avXJqNMMtpiq9IgtVph9PsGIocS5Hi2mtjA16BQFEDX2Rg+WmTYfUn7npI6N9DHu4wSppiXpQ31ctVgMPhcNXgcLBEsb/vgF7EzbJ92rOuE/94MSR1EwNGZYNpTZVsqMewAtMQE2lBZWxN1ix400h2RMQTyQNPhWRGECCtKMPtw/Sa+mtwAofMCfXo8cJDKeJOr9t0otrvGgHqH5OGVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZtziamPYwKKN1KpLuBDYO317YmqaBGIGZA6fPSg5dg=;
 b=EMv9VNb0XE9tNbmE/oMdtlQpinmxRbO+KGv5Wz+ftt1P3ZOJ4mCEbpnkgQ8qLMK8WN0jWVo8ZsQhT7LOy8Y44mGd+yrWtH5KLZkv+LlBuf7M6FMMNlU37TX9+azJDJv2mb3Y82/MTvFd21vLsNSZdwUeesrOUQTcetrGioKzHzjwWrpEXdOiYP892pR3mwLH2k7ZTsij91JftKoDRM44odJRpW0KHIokukxMHuZf145lp/fJdNvlHB6NWg01MDysaF+To6BKnO05e/uM8ykvxPNP2g60j17Bnaxu4mAgSFySi/2Fto5E8A7hEmlG4TFn6LTFTDuDDV5udcpM3TJ9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6980.namprd11.prod.outlook.com (2603:10b6:510:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Tue, 17 Jan
 2023 03:11:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Tue, 17 Jan 2023
 03:11:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 058/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Thread-Topic: [PATCH v11 058/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Thread-Index: AQHZJqWir7JSMuEP5k+09IxeugZm166h9Y6A
Date:   Tue, 17 Jan 2023 03:11:46 +0000
Message-ID: <1a32f2570f13fa0125ddbbceeabcd36fc4beb9db.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <21e0d94ccf2fd3d766d6aa7b45441791c04e5e4f.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <21e0d94ccf2fd3d766d6aa7b45441791c04e5e4f.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6980:EE_
x-ms-office365-filtering-correlation-id: 0b2aae5d-a1d2-4a25-0feb-08daf8389110
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qVES/ByO8sC7oKveC0bQYvWI5i8NXL1SUzq8729tjkZsyou/fkErw4y8S+dfYM6FHjhgPjuH3vvOGhuyneHsdHTzhTspRxcMHxrLKqBZeuPo8jT84f4p56quof6f2picx04+u+N5s1U1Dh3WJQ266AqG+i9gLDmgQT+hC3Xw8NE0+oTzkyu3Mk/bp1W//SgKeu9fTXIl2nJgj6ilqdarGRBiOzwKV/XAWDR0SC3y3Gg4lZtgNSUWTHC4ANQwia55SC7qgNG/um3c62YErIXxNooZO84YF4u7MZzebFQIhKg46chMUcdNTmsn7aeF2+KywZpPKV67K5RM0tYS75H+tN9EQ7A6pmBYB0ssO8Nid6MeyOmMWqgy9CPzaLU7j+y3MjHJ4WNvSIHOrod9xOpSEssQvEUAT+bFPb7foEZG0cU6dRMn/CnOBwivcAtt2wugK34eE1kknjcu10lAJd69z1pQgdiW2hUOw0v7fry2T+6OMfpQJ7pQ92grB/2nrthZOKx1Maj3mPZc8I/I2IU8zswEjXM72Y9gsISnx7S/ZbD20PGF6MCRCW8UJZKcsKJ67sGhnPScCscqhu8BfIIa0suCqQ7UHVxxjDKq3d1IZXI16fvNh9kFb64DAD6hzHeshVVgD6gLJ7ec4QQEdf/MIIEe7TAQQCfYXysNv+PS1l2AAKjVWtpn+GbxasZxBvy02/DoWV3hfTjr8OUjNgqdbIA9hUsmbl7YRKU1xf38jds=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199015)(8936002)(8676002)(41300700001)(76116006)(91956017)(66476007)(66556008)(38070700005)(4326008)(66946007)(66446008)(64756008)(316002)(6636002)(478600001)(54906003)(2616005)(36756003)(2906002)(5660300002)(110136005)(26005)(6486002)(71200400001)(82960400001)(6512007)(86362001)(6506007)(186003)(122000001)(38100700002)(966005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VE5BamhJM0Vuc3pQRUw1WXR2dXlwOWJ1MS9jQVlDbWNlOWp6MnhjWWUwcng2?=
 =?utf-8?B?WW9lQndQa0lvUnBQd2NnbjBxRStocXZta2VCaXFkZllzMk9hQ3J0Rit0Q2dW?=
 =?utf-8?B?bUlralFJZmlwUlJYMDZZZ1JoZVNpZkdHbnMweDZyL0lkNE92Q1BSWlY4NnJh?=
 =?utf-8?B?UmwrQmU1S3hUWmc1TnM3V0hvNWVpQ3MrK1dEdUY0TUtYbmxlRFJUYnFOdm1M?=
 =?utf-8?B?VWh5WUs4cTlQblVsL05zM3E1aktGUTRLa3VEMTVYR0hMU0ZrejdmbENSWk12?=
 =?utf-8?B?N1VCZWRScnRpSGdDVUVtTHZ3NVVnS2FpK0NEWldCNVNNVWx3ZWxJbmlRZ3F0?=
 =?utf-8?B?SGFkM20wTkFkYW0yTjZUZElFckpVNmhvKzVQRXhwR1krMXVXdEg0Z2Ivckgr?=
 =?utf-8?B?VmNidW1qMG8zSnNhQnVHRWZKemVJOWFwdlNRWWNCZTNGbTdONUFKLzQwS2Jz?=
 =?utf-8?B?dEJyMkNvYVJBUHc0REx3aURIK0pWOU4zWHdkaEREWllkQnZnb0FocEZVTFFH?=
 =?utf-8?B?d1lPOWZpdDlWNlB1QWdEeFZUYXZDYjhjbzhHMm9KZ3RFeHBHa0pjOUJXNDkv?=
 =?utf-8?B?WWtkU0IrQzNveWh1VFUvdzBScDlKYjdpVHc3ZDNMZTd5UnRhZU5uaEV2MVI0?=
 =?utf-8?B?a2NWOHBtb3lGSHVLVWxpcXpZRTRyNStlTUdQQ1ZCWG1LaXVtZXNmdURINWMz?=
 =?utf-8?B?UXFFVkRDbmdMYW50QnhiOGRIT3RQdGVwQUs5QTZyMHFXbC8xZncwOGtvVm0v?=
 =?utf-8?B?TTJjUWN5c1k4R0hUZm1tbEd5NXJlbkRsZE9kazZKRUt1dHFSRmM0TVhKZjNF?=
 =?utf-8?B?VlkvV1c1akVhd1k1L2YvNEVlSHBGVkZNODRBbEpwRDJSSG1ZQ0RsMHNLdGlm?=
 =?utf-8?B?TmRYdWREdFhvNUtWU2Z5VDh2K0N4RUhudGlybkYxUEN1aHMxUERsUEFZTUxx?=
 =?utf-8?B?Z08wZkVWVmVSQno2dHR0cFlsVWhjSGVPQ1BaczBZZFQvK1VONUtRQkc1V05v?=
 =?utf-8?B?MjZsM2ZySWtVTS8veGtXWEpvalY4UDRibGFBVUp1QmVEWmFZMGdvdGU3Q2F3?=
 =?utf-8?B?M2g4czVwcEhheG1FSEFMZWxmMUlsT0tuODM3Ym9IYW8xeVFLc0xUaU1paVRI?=
 =?utf-8?B?a2hBalBhTmpwZTU4QlVrN2ZvaTRYTVRkRWZlVEdMWk9WVXdnRWtYdUdRd0I5?=
 =?utf-8?B?TjRTZy8zYWU0SkpFT2lpTkZvckpIT1ltM2o2NjNtNC9Fdk5qQURucVVsSitI?=
 =?utf-8?B?QUVBYmNKQlQ2RUpVVUFqaStzUEVNaUs3MjEzUEk0bEt6QVhZNTg2WldOejFs?=
 =?utf-8?B?N1pUV3ZvSWFyOFlJQ0hxUWF2R3c4bllvaVZabXI2bnQ1VDJNcTZaUEZnSnBU?=
 =?utf-8?B?REJtWEllbHhFOHkzR3IveVJBVm5pTGloQlFjSXRJaXhkMzFaZGVZandlc3VU?=
 =?utf-8?B?cjVwWXluSHdLUHBSZWN4VWRRdEs2V0dndVUvamdyNEFSSjVweElLMXJBaXo0?=
 =?utf-8?B?TjYycGlWa0FCdVdyeE4xTyt2QlgzdExoWWN1SEJMQ014b2Z2NTFkd1IyRW03?=
 =?utf-8?B?SmJqanJ4b3BQQjM0WmhEdDJwQmNnTjJ1UkI3UFJFTFBOVVdiRkh0K1cxWHlF?=
 =?utf-8?B?MnVNR3pDb01jMGhyWkQrYlBBNG9kc0t2R1Z3anhVeVM3VU1QY1hyd1RuNDRU?=
 =?utf-8?B?dDRvY2VDNjFGTzVKQXc5M01LQUNBbHF2RGlhU1dKa3pFV1VtdlBURWg4RGJF?=
 =?utf-8?B?VjQzSXlydWhob3VzbjV4amJjQXdWSGhOL0Nzc0pQcE95QkZ0REhzS1J6dTFL?=
 =?utf-8?B?NU5LSDVMODZvMXBZNW9TVDd4djdXL2pYNHRYYVlBbTU4emczRXJwbUk5YkJk?=
 =?utf-8?B?NkhHTUJmU29tMVZSWC80QzI3VHRIS280V3dJOVlxeFNYVzhiS2FTMVhuVTh2?=
 =?utf-8?B?UXNPREltNTFXTVJqUEhkV3lDSE5CR0s4cmVaZ2J1MDNOLzg4Q3RwTVVnKzlh?=
 =?utf-8?B?NHF1V2s3d0ZnRk5oUGJBbW5zQ1FwYlZQNW4yZ0RHTVV5L2hFMElOT1FEaCth?=
 =?utf-8?B?K0l4MDBuRFczNzA3MytlZ0puTy9Wc0lEY1J6aHdTQVVDbFd6bmtObmxtNmhT?=
 =?utf-8?B?eTRWSFd5Zjg3S0s4SndVYUtadi94QlRyTzYyR0RoR3Z5K0hseW8reTJ2RlNp?=
 =?utf-8?B?Qnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A45C8AF151EB84B9FD7419F6E1C2968@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2aae5d-a1d2-4a25-0feb-08daf8389110
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 03:11:46.1640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elua6ib8V4kQ+lKu5opv004zEsegP6eWXjWb+m30j7s/E/EgnEpa+97vjG88IvfFe893rxbFuIV0QpzMu2LRWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6980
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMyIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBBbHRob3VnaCBURFggc3VwcG9ydHMgb25seSBXQiBmb3IgcHJpdmF0ZSBHUEEs
IE1UUlIvUEFUIGZvciBzaGFyZWQgR1BBDQo+IHNob3VsZCBiZSBzdXBwb3J0ZWQuIEltcGxlbWVu
dCBnZXRfbXRfbWFzaygpIGZvbGxvd2luZyB2bXggY2FzZS4NCg0KQnkgZmFyIHRoaXMgaXMgdGhl
IGZpcnN0IHBhdGNoIHRvIGhhbmRsZSBNVFJSL1BBVC4gIFRoZXJlJ3MgYWJzb2x1dGVseSBubw0K
YmFja2dyb3VuZCBoYXZlIGJlZW4gZXhwbGFpbmVkLg0KDQpTbyB3aGF0IGFib3V0IE1UUlIvUEFU
IHJlbGF0ZWQgTVNScyBoYW5kbGluZz8gIE5vIGNvZGUgbmVlZGVkIHRvIGhhbmRsZT8NCg0KSSB3
YXMgZXhwZWN0aW5nIHRoZXJlIHNob3VsZCBiZSBhdCBsZWFzdCBzb21lIHdvcmRzIGhlcmUgdG8g
ZXhwbGFpbiBob3cgVERYDQpoYW5kbGVzIHRoZW0sIGFuZCBpZiBubyBoYW5kbGluZyBpcyByZXF1
aXJlZCBpbiBLVk0sIHdoeS4NCg0KVy9vIHRob3NlLCBJIGRvbid0IHRoaW5rIHRoaXMgcGF0Y2gg
aXMgcmV2aWV3YWJsZS4gIA0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8
aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvbWFp
bi5jICAgIHwgMTAgKysrKysrKysrLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC90ZHguYyAgICAgfCAx
OSArKysrKysrKysrKysrKysrKysrDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3g4Nl9vcHMuaCB8ICAy
ICsrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L21haW4uYyBiL2FyY2gveDg2L2t2
bS92bXgvbWFpbi5jDQo+IGluZGV4IDc3MGQxYjI5ZDFjMy4uNDMxOWY2ZDdhNGRhIDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14
L21haW4uYw0KPiBAQCAtMTU4LDYgKzE1OCwxNCBAQCBzdGF0aWMgdm9pZCB2dF9sb2FkX21tdV9w
Z2Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBocGFfdCByb290X2hwYSwNCj4gIAl2bXhfbG9hZF9t
bXVfcGdkKHZjcHUsIHJvb3RfaHBhLCBwZ2RfbGV2ZWwpOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMg
dTggdnRfZ2V0X210X21hc2soc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBnZm5fdCBnZm4sIGJvb2wg
aXNfbW1pbykNCj4gK3sNCj4gKwlpZiAoaXNfdGRfdmNwdSh2Y3B1KSkNCj4gKwkJcmV0dXJuIHRk
eF9nZXRfbXRfbWFzayh2Y3B1LCBnZm4sIGlzX21taW8pOw0KPiArDQo+ICsJcmV0dXJuIHZteF9n
ZXRfbXRfbWFzayh2Y3B1LCBnZm4sIGlzX21taW8pOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgaW50
IHZ0X21lbV9lbmNfaW9jdGwoc3RydWN0IGt2bSAqa3ZtLCB2b2lkIF9fdXNlciAqYXJncCkNCj4g
IHsNCj4gIAlpZiAoIWlzX3RkKGt2bSkpDQo+IEBAIC0yNjcsNyArMjc1LDcgQEAgc3RydWN0IGt2
bV94ODZfb3BzIHZ0X3g4Nl9vcHMgX19pbml0ZGF0YSA9IHsNCj4gIA0KPiAgCS5zZXRfdHNzX2Fk
ZHIgPSB2bXhfc2V0X3Rzc19hZGRyLA0KPiAgCS5zZXRfaWRlbnRpdHlfbWFwX2FkZHIgPSB2bXhf
c2V0X2lkZW50aXR5X21hcF9hZGRyLA0KPiAtCS5nZXRfbXRfbWFzayA9IHZteF9nZXRfbXRfbWFz
aywNCj4gKwkuZ2V0X210X21hc2sgPSB2dF9nZXRfbXRfbWFzaywNCj4gIA0KPiAgCS5nZXRfZXhp
dF9pbmZvID0gdm14X2dldF9leGl0X2luZm8sDQo+ICANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IGluZGV4IGU2ODgxNjk5
OTM4Ny4uYzRjNWE4Zjc4NmMxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5j
DQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gQEAgLTMwOSw2ICszMDksMjUgQEAg
aW50IHRkeF92bV9pbml0KHN0cnVjdCBrdm0gKmt2bSkNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4g
IA0KPiArdTggdGR4X2dldF9tdF9tYXNrKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ2ZuX3QgZ2Zu
LCBib29sIGlzX21taW8pDQo+ICt7DQo+ICsJLyogVERYIHByaXZhdGUgR1BBIGlzIGFsd2F5cyBX
Qi4gKi8NCj4gKwlpZiAoZ2ZuICYga3ZtX2dmbl9zaGFyZWRfbWFzayh2Y3B1LT5rdm0pKSB7DQoN
CkZpcnN0IG9mIGFsbCwgcHJpdmF0ZSBHUEEgZG9lc24ndCBoYXZlICdzaGFyZWQgYml0JyBzZXQs
IHNvIGNvbW1lbnQgIGRvZXNuJ3QNCnJlZmxlY3QgY29kZS4NCg0KU2Vjb25kbHkgKGFuZCBhZ2Fp
biksIElJVUMgdGhlIHNoYXJlZCBiaXQgb2YgdGhlIGdmbiBoYXMgYmVlbiBzdHJpcHBlZCBvdXQg
bG9uZw0KdGltZSBhZ28sIHNvIHRoaXMgaXMgaW5jb3JyZWN0Lg0KDQpQbGVhc2UgZG9uJ3Qgc2xp
ZW50bHkgaWdub3JlIG90aGVyIHBlb3BsZSdzIGNvbW1lbnQ6DQoNCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xrbWwvWTE5TnpsUWN3aFYlMkYyd2wzQGRlYmlhbi5tZS9ULyNtZjMxOWQ1YjcxODUx
OTcwOTM2MmY5ZjA5NGJmYzViNTNmZDg3MDI0MQ0KDQoNCg0KPiArCQlXQVJOX09OX09OQ0UoaXNf
bW1pbyk7DQo+ICsJCXJldHVybiAgTVRSUl9UWVBFX1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQVEVf
U0hJRlQ7DQoNClNob3VsZG4ndCB5b3UgYWxzbyBpbmNsdWRlIFZNWF9FUFRfSVBBVF9CSVQ/ICBJ
IGxvc3QgeW91ciBsb2dpYy4uDQoNCj4gKwl9DQo+ICsNCj4gKwlpZiAoaXNfbW1pbykNCj4gKwkJ
cmV0dXJuIE1UUlJfVFlQRV9VTkNBQ0hBQkxFIDw8IFZNWF9FUFRfTVRfRVBURV9TSElGVDsNCj4g
Kw0KPiArCS8qDQo+ICsJICogRGV2aWNlIGFzc2lnbmVtbnQgd2l0aG91dCBWVC1kIHNub29waW5n
IGNhcGFiaWxpdHkgd2l0aCBzaGFyZWQtR1BBDQo+ICsJICogaXMgZHViaW91cy4NCj4gKwkgKi8N
Cj4gKwlXQVJOX09OX09OQ0Uoa3ZtX2FyY2hfaGFzX25vbmNvaGVyZW50X2RtYSh2Y3B1LT5rdm0p
KTsNCg0KSXMgdGhlcmUgYW55IGNvZGUgdG8gcmVqZWN0IHN1Y2ggY2FzZSBhdCB0aGUgYmVnaW5u
aW5nLCBmb3IgaW5zdGFuY2UsIGRvbid0DQphbGxvdyBhc3NpZ25pbmcgZGV2aWNlIGluIHN1Y2gg
Y2FzZT8NCg0KPiArCXJldHVybiAoTVRSUl9UWVBFX1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQVEVf
U0hJRlQpIHwgVk1YX0VQVF9JUEFUX0JJVDsNCj4gK30NCj4gKw0KPiAgaW50IHRkeF92Y3B1X2Ny
ZWF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICB7DQo+ICAJc3RydWN0IGt2bV9jcHVpZF9l
bnRyeTIgKmU7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3g4Nl9vcHMuaCBiL2Fy
Y2gveDg2L2t2bS92bXgveDg2X29wcy5oDQo+IGluZGV4IDhhZTY4OTkyOTM0Ny4uZDkwM2UwZjYw
NmQzIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3g4Nl9vcHMuaA0KPiArKysgYi9h
cmNoL3g4Ni9rdm0vdm14L3g4Nl9vcHMuaA0KPiBAQCAtMTU0LDYgKzE1NCw3IEBAIHZvaWQgdGR4
X3ZtX2ZyZWUoc3RydWN0IGt2bSAqa3ZtKTsNCj4gIGludCB0ZHhfdmNwdV9jcmVhdGUoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KTsNCj4gIHZvaWQgdGR4X3ZjcHVfZnJlZShzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpOw0KPiAgdm9pZCB0ZHhfdmNwdV9yZXNldChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGJv
b2wgaW5pdF9ldmVudCk7DQo+ICt1OCB0ZHhfZ2V0X210X21hc2soc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBnZm5fdCBnZm4sIGJvb2wgaXNfbW1pbyk7DQo+ICANCj4gIGludCB0ZHhfdm1faW9jdGwo
c3RydWN0IGt2bSAqa3ZtLCB2b2lkIF9fdXNlciAqYXJncCk7DQo+ICBpbnQgdGR4X3ZjcHVfaW9j
dGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB2b2lkIF9fdXNlciAqYXJncCk7DQo+IEBAIC0xNzYs
NiArMTc3LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHRkeF92bV9mcmVlKHN0cnVjdCBrdm0gKmt2
bSkge30NCj4gIHN0YXRpYyBpbmxpbmUgaW50IHRkeF92Y3B1X2NyZWF0ZShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpIHsgcmV0dXJuIC1FT1BOT1RTVVBQOyB9DQo+ICBzdGF0aWMgaW5saW5lIHZvaWQg
dGR4X3ZjcHVfZnJlZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHt9DQo+ICBzdGF0aWMgaW5saW5l
IHZvaWQgdGR4X3ZjcHVfcmVzZXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29sIGluaXRfZXZl
bnQpIHt9DQo+ICtzdGF0aWMgaW5saW5lIHU4IHRkeF9nZXRfbXRfbWFzayhzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIGdmbl90IGdmbiwgYm9vbCBpc19tbWlvKSB7IHJldHVybiAwOyB9DQo+ICANCj4g
IHN0YXRpYyBpbmxpbmUgaW50IHRkeF92bV9pb2N0bChzdHJ1Y3Qga3ZtICprdm0sIHZvaWQgX191
c2VyICphcmdwKSB7IHJldHVybiAtRU9QTk9UU1VQUDsgfQ0KPiAgc3RhdGljIGlubGluZSBpbnQg
dGR4X3ZjcHVfaW9jdGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB2b2lkIF9fdXNlciAqYXJncCkg
eyByZXR1cm4gLUVPUE5PVFNVUFA7IH0NCg0K
