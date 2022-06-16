Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F73454E8B1
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbiFPRgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiFPRgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:36:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8F02D1DF;
        Thu, 16 Jun 2022 10:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655400982; x=1686936982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LKILEY2weD+ihISoiMS1s6oJ26VicZUon3A1EDtkaHs=;
  b=DdmZ5Pp+pu961ipWHLMROU95NgKfqEC3+3wcCEOW0665qyeyfT9pZ9cT
   ziF2lPz/DSuVkGFsR/dMDudkwbGSdv6m2YXiBgJ92amrblB3rdQv7/O6d
   p8vuIWetkkc641IxP7GlDjk1FaUQ3Po8g8w9LtdSqzCXX2ZM2k1kTZ3ss
   X2DTCgoi2US00hxdGerBWoXWR1X1H4vUJdtTrwQxdRrbu3Rrhj1SnxfDg
   XLbDhNAteYRzBI8YrY1xwlZD5a20Lch4etIkSlMS/o2DQDsa5G4jUsH2k
   zEHlrz3NRwhR86xY4HAGUu8aHwU7qVozTg+QxpwgUS1+ZZqefFJzGzVUS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="304752894"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="304752894"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 10:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="589742159"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2022 10:36:22 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 10:36:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 10:36:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 10:36:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 10:36:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADtM9aIK8r/SSPVRMJO8Lujsa3Krm9W/B3btmGZ6MAFE6s+1M0a3fhyYyJuPYgKIKZF8UE/8kDI1lsje0WfpB22r8hvcXjVp7tjZd/8Qy66ret0URITQw192zaZhBxWegwCXWm3ZywQNDRM0H+oA/5bAmMzYSkQCwEfNOvRIsUMAsTAiSFkhlJw58SDU+afsXK9kzUMiS0ve4601cmyUDBTSsTVdx11SWnFlAxLPRtJLNFzpdIAFscAnHWZINSxEJVWob8mGbAmubeUl1coYhk6k6CyCFPPIMrB6rRau/2O9ucdohYT2HTgt/G15EFVM6t3nbf4D7k+Ho6rAjlKc9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKILEY2weD+ihISoiMS1s6oJ26VicZUon3A1EDtkaHs=;
 b=TokUv7XwJ50y3Qctpy8Xqdn+LLA6pb0Co/V3PNkNFh05D/+bY2sFrALqFGFtvx3IrHyOFP4ApHUJy6dcsshia5fE4LQv+IEf9AoasT6INxHgeJAhYQP7QLOZOlcd2Nw6A2GtR5KtMFQPuXVEpl6faQDW2VHTtCQo27XH5jJQluZe3ISl0KdjvLVgkaajxHi7Vcd+jMepkH5TiG9Su1SagTRZh7dP39peY9ltHhk75Z5+qzc3iZeEJIKl/BnFd94geqe80+c7pyEgxGVA71+XlcYF3gbzraJWtcF52rkci5gZaK6ub3u/81RQi/1B2+YifwzaIegGDBjb3BPs38xcDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by BN7PR11MB2817.namprd11.prod.outlook.com (2603:10b6:406:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 17:36:18 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::6463:8e61:8405:30f4]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::6463:8e61:8405:30f4%12]) with mapi id 15.20.5353.015; Thu, 16 Jun
 2022 17:36:18 +0000
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
Subject: Re: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Thread-Topic: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Thread-Index: AQHYgV3BGYVuI+Dv/0Gr8tfHe/6Wwq1R1BuAgAB4VQA=
Date:   Thu, 16 Jun 2022 17:36:18 +0000
Message-ID: <079695b2f009d1a04d0022d8cac82ca3ee19103f.camel@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
         <20220616084643.19564-4-weijiang.yang@intel.com>
         <YqsFIRDPvaEKMqIh@hirez.programming.kicks-ass.net>
In-Reply-To: <YqsFIRDPvaEKMqIh@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa64b439-3c1a-4d34-e17e-08da4fbeb8c5
x-ms-traffictypediagnostic: BN7PR11MB2817:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN7PR11MB2817F526033273C70E990D94C9AC9@BN7PR11MB2817.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WzOokcZvHSrt/J0kkPwrJte3+jP9y8Iy1qLoJN37tmGrF8ymrm28t6PIZj9TWmaDl3hNU8xI0xD2HoMRljXYOl7i8aS06EzDSvZ2zxu8cbxch6MYzogBiF/fR3GbKYCZoOg4aiO2/LoYthiGdIRh9lBS5pLaI5kWjXTxZZgimkq3KBin13nhVqK0dJRNr/kl+Lcv/chDoDqbeo1iIPAugdPZ2U28jO+ipdpPdl/kw24jcISlvQKZz2hhJrisOThyVaWZGhUWcIy3XLzklUtU2RZFRPoMgc0Lor1ArBaTi6NqBKo6+psTSRC84m52VXWOy8rPFU7b1tBuutET+SlYjfJmoWLtW70/3rhBDySeUSZzsIi6zpfyJw/eHY48XcFdj+/GHwz4dzgetf2gFb92HWxhw42cfgFBYJZqNB756sTkVSsGIIjlvI3u+MM1aGqyF6UL5i/ehEw6H5gPMvC9iMfTNhBFLSt7C0Vb8wgE4aSlJns6W6XALitywoRg39NEAzxs9ufBDd1vJBGmhHvpTul0rHp0AdvCOYxWNqtRZJuO+zLcbXDU6CA1aJwIpFEhBeKn61ryAQ4MW2P0yJ3+7HGBwhK4QRZJHsnue3yfGB4XleeqkgFpK8U3QyE13Vy5u4YbOPNlifielkaO9yzSPAVmN4MTfidH1DF4w4s01nQ3RFIUBKAQGJjSVK8u88Bw2iIwK7dbadsaqRrWZ7RaWi59EV64htH9vXHVkYplVko=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(38070700005)(6506007)(86362001)(76116006)(38100700002)(2906002)(6512007)(6486002)(54906003)(66446008)(64756008)(110136005)(36756003)(4326008)(6636002)(66476007)(66946007)(66556008)(186003)(8676002)(71200400001)(82960400001)(5660300002)(316002)(508600001)(2616005)(122000001)(8936002)(26005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFl4OExDZkRCQUdhQnpnRXFVMzBhUXVkT05vT01NVWx5VHB1V01HaG9kVFFs?=
 =?utf-8?B?VDhNN3pRVmU0c2M4RHltY3VHUGFHQ3hpYjdDOXJhMUZSR3RKZGs4TlNPbnJQ?=
 =?utf-8?B?dGFSTEQ2Q2QzZithU2VsRzNuRWxvU0F0UHZWU3VtVm93YjhsalBPT0hlYmN2?=
 =?utf-8?B?UFB2QzlDa1Q4a3NLeENwaU9tYmhua3hMaUFqZmpKdkY1QTg1bytOc05hZ2hM?=
 =?utf-8?B?UUlVMUxBc3VkNkE3eloyblJCWXI4aG5pYWZ5WHg2RU1zN2lBM2NIM0l3N3Y3?=
 =?utf-8?B?M3RJMXhCZyszN3hFOEd5VG8wYklOUkRaVDJLQUg4dlF6Tm8xckg0ais4N1BM?=
 =?utf-8?B?Y0YrbEVrdk4zVXptTmtBSS9kSDV0QmNic0Z2bjZuVWFYVEFiL0MzT3pvMHMz?=
 =?utf-8?B?TkxwdXlVWXFtRlM3UXVaWGtXUjU3NGJXZkRVbmtGYUlZSW9weFEySGx1NEEv?=
 =?utf-8?B?endyQk8wSjVNQlpQTXNNNFdIKzJuWVNsVFlSTUdTdE93MDZSTXdPb0NIQ3h1?=
 =?utf-8?B?dDI2MUs5SklDQnBjYXlsbGtTUU9rUzJBaGdFbkRCMldXbEhjajUyT3VXdGRX?=
 =?utf-8?B?Wm9pZHJXbkM1TktUeGVtVmRyTTNORDlDcHB2UURadkJwYVVBUVRZSXhIMVFt?=
 =?utf-8?B?TENtYkZGUFJLYmxIRXV0R01hMDQrKzJLZ3hoTjhJbXdTWVE4bXhqdFlPdElz?=
 =?utf-8?B?cEY4WlgxNE9KOUNqUjc2TTVNUW1Cck04U1RaNzNxaGRvVjNmbzloSVlnYVV2?=
 =?utf-8?B?TFJKd016b2czWkx3Z0VPQnR1ZUxnelFNRWoyVFNSY3RkUHJVQnR6TmkrSjNT?=
 =?utf-8?B?YVNrdTc0cVBvYUFBbmpHbVlHdGFZOGhkU2s4US9TYWt0Q1ZZK0xUVkpNVElw?=
 =?utf-8?B?L3NHM0JzVHNHK2JOdHVnL3hrWjBxcUFqTVl4YXZSTGR0ZGhFWm1XZ1BsNWRU?=
 =?utf-8?B?RkxxdVc1Vm9tK1hmZXpvbEg2WHlZbUN4UGtuQWI0VXM0YmhHdE9IQWwzY3ZK?=
 =?utf-8?B?blRrN3BudERXeHpvd2J0MzN2VlpIaENmMkQxS0daMjFxWnh5blVNeW8wZzNW?=
 =?utf-8?B?SEVjdVFoN294cS9hTlAzTFVDN3pmV2NveFM4WE1ndWZJdG1sZldCN1Nacmxs?=
 =?utf-8?B?TVNwQ2JsSjBjd1hCME1hbHNJY2ZlUW5JSXhsSVFZa2NYV2FnTWxUR01yZE1t?=
 =?utf-8?B?Z3R5WFRNbG9HSmlFNUtrVjdPQmE3bWhIdHl4NWM0UW1aVmVNOG9YeEZXYWNt?=
 =?utf-8?B?RHFlVzQ5b1RMMCtxeDlKT3FWMDFlVmJkWklROXJlcEs2clFTSldqQkVCYkc5?=
 =?utf-8?B?L1FpNCtwczZGbzJGdkVNMUVlbDFsYk5mR3BFL3lZb2ZieWJGMkJiRWxlVm5n?=
 =?utf-8?B?Q0JMYVVZaFVhWjJzRkhSNklGSFVsTnhPR0YyQ2M2MDlrMmtLUEJnY1VJNzdD?=
 =?utf-8?B?aVJ3L01KMzR4dVRSeEhiRDFJUFFDQXBoT1RHdktEYkRwQ2NUVmcvL0Z2aDNm?=
 =?utf-8?B?U21makRMUkI4S0ZGV3NjN1JnN2N3ZTFzZDlSVXJJSldjWlFlVDVEZEI1SWpP?=
 =?utf-8?B?bVZyNmQwU0s2MmEyRkprWWxXdis0REk3RVArUGR2R3V3S3duUVFrWDNXb2dB?=
 =?utf-8?B?QnhVMlhSOGE5Z2Mwb2R2T0RWYXQ0NGhnTE8xMklndmdNeEVrU3R3OGg4L1po?=
 =?utf-8?B?NE1EK1Z4eStKcklOVDB3Vm9CUmF2VU8rY1d4Mi9rWHZwc0VVQjRjeFBzZnVv?=
 =?utf-8?B?WklPWHlNQnRLUlBOYkNRaFprZU9yK1dLOEwxNkJCV3ZRK01kcUxiUDJPcUhB?=
 =?utf-8?B?NUU3cUxVNW9mRkV3M2NBY3hNaTNrcm5Gd1habll3Vk5mQkZtbDN2R3h4dS9q?=
 =?utf-8?B?K2k5SFVBMFAzMUEyczNiNzEzVDhhOFF4QzcrL0tNejZyRTNTaVpSVmdFeVVR?=
 =?utf-8?B?anZ5enRhQkprSXR6enV5V3oxNGZzalpZaEZmLzhGOHBrSnZwVzA3K2w2Ty9J?=
 =?utf-8?B?Ri9hNlA4eGZ2SXAwaC8weFYwZFRsWE5NeUZNUVArMlZXZ0ZhL3N2YTd2azdO?=
 =?utf-8?B?ZmtHZjR0MGlhMlRQemVRYUJkc1FpMThKVW5LT1llZ2lXckdrOHdUNndzUzhi?=
 =?utf-8?B?K0xwZHo4eGNEb3gwUTBZN0c0NEJsY1AzQXZOWHRoQnlYNDRzblFFL0kvV0hH?=
 =?utf-8?B?UFZZQVZmUHRLNkZyMlhReHdmMUtwcVJyZUhXZUpRN1Q2UnhTZjNvQkhpVjVz?=
 =?utf-8?B?Ui9MT0R5UGpKRktKNlJlSmx3V3pVMG5HTjNtRjRnbkxUcGdvL3BBeFB2Uk1o?=
 =?utf-8?B?WnJZQ1ZnVnQ2aUtRbzRIc1dha0wzK0tGbDJYc2FPWVFRaUhFZDJtUDJzTmZZ?=
 =?utf-8?Q?06T49nwPhCc5GuSgx7SfRnxDISbSSirumCGb7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2025BAC9C6D65A42BFD165AC758E6877@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa64b439-3c1a-4d34-e17e-08da4fbeb8c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 17:36:18.8078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iaxocQ8lQ2mmBPf390oLyVEYZ6sTHa4RecdtlbO4OtUIg1KSIExX7+NNhvobKa47YdbD7lbEqbNtYlDiLyI12dj9zVmj55j2sWYqJzAwJ/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2817
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTE2IGF0IDEyOjI1ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMTYsIDIwMjIgYXQgMDQ6NDY6MjdBTSAtMDQwMCwgWWFuZyBXZWlqaWFu
ZyB3cm90ZToNCj4gDQo+ID4gICBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgc2V0dXBfY2V0
KHN0cnVjdCBjcHVpbmZvX3g4NiAqYykNCj4gPiAgIHsNCj4gPiArICAgICBib29sIGtlcm5lbF9p
YnQgPSBIQVNfS0VSTkVMX0lCVCAmJg0KPiA+IGNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRV
UkVfSUJUKTsNCj4gPiAgICAgICAgdTY0IG1zciA9IENFVF9FTkRCUl9FTjsNCj4gPiAgIA0KPiA+
ICsgICAgIGlmIChrZXJuZWxfaWJ0KQ0KPiA+ICsgICAgICAgICAgICAgd3Jtc3JsKE1TUl9JQTMy
X1NfQ0VULCBtc3IpOw0KPiA+ICAgDQo+ID4gKyAgICAgaWYgKGtlcm5lbF9pYnQgfHwgY3B1X2Zl
YXR1cmVfZW5hYmxlZChYODZfRkVBVFVSRV9TSFNUSykpDQo+ID4gKyAgICAgICAgICAgICBjcjRf
c2V0X2JpdHMoWDg2X0NSNF9DRVQpOw0KPiANCj4gRG9lcyBmbGlwcGluZyB0aGUgQ1I0IGFuZCBT
X0NFVCBNU1Igd3JpdGUgbm90IHJlc3VsdCBpbiBzaW1wbGVyIGNvZGU/DQoNCkkgdGhvdWdodCBp
dCB3YXMgbW9yZSBkZWZlbnNpdmUgdG8gcmVzZXQgU19DRVQgYmVmb3JlIHR1cm5pbmcgaXQgb24N
CndpdGggQ1I0LiBPZiBjb3Vyc2UgQ1I0LkNFVCBjb3VsZCBoYXZlIGJlZW4gbGVmdCBvbiBhcyB3
ZWxsLCBidXQgaWYgQ0VUDQpmZWF0dXJlcyB3ZXJlIGFjdHVhbGx5IGZ1bGx5IHR1cm5lZCBvbiwg
dGhlbiB3ZSBwcm9iYWJseSB3b3VsZG4ndCBoYXZlDQpnb3R0ZW4gaGVyZS4gU2VlbSByZWFzb25h
YmxlPw0KDQo+IA0KPiA+ICAgDQo+ID4gKyAgICAgaWYgKGtlcm5lbF9pYnQgJiYgIWlidF9zZWxm
dGVzdCgpKSB7DQo+ID4gICAgICAgICAgICAgICAgcHJfZXJyKCJJQlQgc2VsZnRlc3Q6IEZhaWxl
ZCFcbiIpOw0KPiA+ICAgICAgICAgICAgICAgIHNldHVwX2NsZWFyX2NwdV9jYXAoWDg2X0ZFQVRV
UkVfSUJUKTsNCj4gDQo+IExvb2tpbmcgYXQgdGhpcyBlcnJvciBwYXRoOyBJIHRoaW5rIEkgZm9y
Z290IHRvIGNsZWFyIFNfQ0VUIGhlcmUuDQo+IA0KDQpZZWEuIEkgY2FuIGZpeCBpdCBpbiB0aGUg
bmV4dCB2ZXJzaW9uIG9mIHRoaXMgaWYgeW91IHdhbnQuDQoNCj4gPiAgICAgICAgICAgICAgICBy
ZXR1cm47DQo+ID4gICAgICAgIH0NCj4gPiAgIH0NCg==
