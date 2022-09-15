Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DAC5B92B9
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 04:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiIOCqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 22:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIOCqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 22:46:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F068C038;
        Wed, 14 Sep 2022 19:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663209978; x=1694745978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+wrk+e3vpu9L/5mkEMfP2FQpmp2GK3f88Q+lDZ7RIRs=;
  b=fflYz3Fa+AgZCnbgCeXD5JOn829MGV7ABaU0anUV2O7CIp31BsgTwmVy
   M3B2Wr56hQ49iJ1Q/CfmG1xkHAzalAvDmKBYSAPAr+bgX+zaQD4lnuVSH
   xolTBT0Xvn9JPVZbtmpO7v5jiEJPg5VlkpxL04Wggn6zKZ+1aVYahl6Jr
   hsJVuxmzQP2VbEu7t2BEPJkMGJNTwzU6nNhvYgTBEr7fanui6AvEj3FFw
   VW4xr1xXD84tZUY0YVSQpiTE5Op3/uIvMZb5cBM/RYZbzrL9T3bfyHUg5
   svubDH+5MIaJUQJJAvzUXUClmzTsea3nUsHGbsvbzQ9/jCsnCaFvvn/l+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="362556550"
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="362556550"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 19:46:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="792536192"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 14 Sep 2022 19:46:18 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 19:46:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 14 Sep 2022 19:46:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 14 Sep 2022 19:46:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1f5c80ZwDOtEKeB+oVCfiQfQ/e3m4tIkfdNvYzf9byHAyRJCRqtTatnlJH2huzon+XoihUsJTRJUNWY5wIOkMr+rFz8vgKzknO+RYrRIZujw+kb397tFrddJP6RIXTenI0UGua7S0FdjokZ3qMRTxPbChIMT/h3W+t1kJriWBwT0Zv//sablOYBRzd7xL5qZSgbLTs6dW/1/GxNOqdqW1L8I2NcrKJMSVivCKQMaVwlH6UB7Hp5noW+hd8rcofVdF2eyNeJuclf5IG8wgQaiZ99TVNekx41E+i6eRxQQvczOAhHcqxUS7P/pWMpJaa3m7kfxpyPwnFDo6I5GnRRbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wrk+e3vpu9L/5mkEMfP2FQpmp2GK3f88Q+lDZ7RIRs=;
 b=Mzspg3NPp7DP901TBrsxgynQPnT6VtpBGtXCgfR8gwlik+EziPoYRWXAPVNPnVcz2MNZ2zkXi5ZaaHsR9bjkBP/nV3fuBwuU4AM0m68AJ/gflwNsj0W05qwQGTJ1GNSp4qoyS2r/TXhc6PFw1kAGKFsr5yDLOJXQ5j7uRFHfz0+tnHFO3H4uUzZZgzLW/nadpVuFNoD50pfp1f7qskpp3oOcHFgd8neo+R3GadlhlpBofGZtWyYijKyy5lbT48TGIOU2Bg/wSFocT9Hz/Gnla7QHZ2AHJIAU8t0B3Fyglv+hywgUddvfEd/uIqktjEHhqUPA1BA85hDaMscY4VooSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5)
 by BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 02:46:14 +0000
Received: from CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::990c:fb7c:d6ab:3b18]) by CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::990c:fb7c:d6ab:3b18%4]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 02:46:14 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Topic: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Index: AQHYuGCfKwYxaXR4306din/WULaC4K3Fff5wgBjymACAABFugIAA/X4AgABj1pA=
Date:   Thu, 15 Sep 2022 02:46:14 +0000
Message-ID: <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
 <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
In-Reply-To: <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR11MB6365:EE_|BL1PR11MB5978:EE_
x-ms-office365-filtering-correlation-id: 782bfa90-6862-490a-298f-08da96c474b5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mqKFi1bIZuQj8+r6Uex0MNLQc67xxTPTqBxWIYJVg0IUWBlM+UG2feQ3PP58DGGlhef2xeptzxlJT38xvkQNjC1wnljwbIwYp3C7G73q3F85MLnkG9WST1lT3Da0w57/smH+DYUesAKi2ebQ71tz4ig2PjHIusMBntsQ60WW3aN6X+4PL/JGcAFiXIwwGD+h3SXW3Z14QmphHn2KL5/bTmbLOCaDFVpdzdrOlSOhsnXIk7f3IwKH3q1kJjD4gaE0BQzySaP5FhctqmoYgMln2rj1AC6lXviUu7yIUD0Zf7Ex7q1bQF9ZMNsVB8mSWidbXUieTOZ7lLllht6zmxK/bFQkQ/0QDhSN/qZ/3cMp70zGhfojMUZ/tF1JzFa3KQp2yiA5uIjcMbU4jLX8nnXOy1IIioxfCLgbrqVrf9QvQVrtMBs8xppNO4FgyhhHtFFK1k5Pa/pTvmnfTXhmCQbehOyz+kXimC8ZxME/x95zRVwEZrDcW8+9AsL7MruqmncUOtGqOHPDm/44uQHD0oXz/pkmRGSD2kCmdT3lcqMLZKqT3s5M3B6IBBY1FmuluA9KS8bTWih75U3wWmRpqLXy2S/6t6Wl0qQvluQwZJMl9m30RPI8Mv9tH87CQavFGkmJyf+J2M5ryrNKl02PaVHy4XrDA+FCZr/2ym6/5CyKwrS3izFxzGk2E8qiZXb2/6wx1HBcwdZ2s93bT/66lXaGamSJfyifFBqZuenYbcTDb3g8M1vGOye7/x4ONp8my9TG+QQp7T6i6cabUx0ZL2tYTLu5SRfH9TK811oPaRH2kto=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6365.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(921005)(26005)(66476007)(33656002)(38070700005)(55016003)(41300700001)(6636002)(76116006)(5660300002)(9686003)(38100700002)(2906002)(122000001)(316002)(66556008)(71200400001)(110136005)(7416002)(8676002)(478600001)(52536014)(6506007)(82960400001)(83380400001)(7696005)(53546011)(66446008)(64756008)(8936002)(66946007)(86362001)(54906003)(4326008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aG5Qczl2ckdEcklUL2QxWWxPdlBKL1FGd0VaMldHYmE3UGNFbG1LODNXMUNU?=
 =?utf-8?B?Wlp4QlBMOGQyaisxRzFpcGVwQlU0M3hseWN4NUtFOGc5Q1o4YTdhcXhxUUJV?=
 =?utf-8?B?YVhNR0ZOSjFwK0JGOVRwb1pITmtMK2JWbHZFZ2QyWE5HWXZYd3lVUnR0QjN2?=
 =?utf-8?B?aERpSjZrK2k3YXh0cWZOYlFsMUdrRW5YSXNvSlF3b3c2blRyaGR5WGd4M2Zq?=
 =?utf-8?B?TTJFZERNOUV5MG1NVWJNWDZOSC9YVS9aV1VKeHJ6KzFZNFV3MmJ3MWFsc1Iv?=
 =?utf-8?B?enpDMGZhWDU1RkkwV0R5Y0ZldFlXWnRIZ09lVkpxalVVSTc0RkRwdDMvbEt3?=
 =?utf-8?B?V2ZrRlNlejhacUR4U1dlMlZmRng0YmFqTnFhbExBV2QxVnZjL3Z4dVdqN25G?=
 =?utf-8?B?alNoTUhRdHBiT200dDczcUZvNVpZZlBZeEo4c1FMOXF2WDRnTHFPdzVxS3Jj?=
 =?utf-8?B?MGxKKzJMWEhCT05EM0hKREhEVlhDQmxlSW50TlRQU0YzTzhIMkVhRE1vdnA3?=
 =?utf-8?B?ZVdvYVp4Q3BZM3FXd1ZjUzhSMWhXUDBHTUhSNjlYOTBBSEpYNUJWWHVWMTZo?=
 =?utf-8?B?cXpHd0F3YW5BRXdwbGNCZ0Z6dHRHQXVYNVpZN2p4L2xPRWZSKzJuc3NidUhh?=
 =?utf-8?B?d1ZXR1RUNWRxYjJwRDZDYkhsRGVhTU5aRHZUbnVkRXdPNnYwSzVYOUx3QjNP?=
 =?utf-8?B?ZkNNVy9SSTFUY2JuMXlwQWcyaXE1QVl0VkdEU2Q5L1RMSUZaU29rcU9Edlo2?=
 =?utf-8?B?SWplRlBUTmN5S084SWJKMHFYdXRaaFFTOUg3ZUZleXZsOU9CS3NSRjR1SHlq?=
 =?utf-8?B?VUNFNEIybUtqNE83WER2YUlpZklLOEs3RXdnb2p6YXN1SEFpaWlwWmdxdWtG?=
 =?utf-8?B?VktNV3hHK3lsLzN2aDc1K0szd0tCUTJGTFFXRXg0Ykg1K0syRHJNdmovUDZN?=
 =?utf-8?B?UWxFaitUTXVVa2JyVGZCOURLbm5LTFR5eHpIbmdKSHNFQzBqMTEwOVlCYTAy?=
 =?utf-8?B?NDk3Ly8yeW5sYXVObUxucGNwMTRCUWowc2Q5TmxKN1YreTFGMXJXYzV1VERQ?=
 =?utf-8?B?Ymh6OVNxWjY1dUdVL21YdzdnMmc0aG15eVExN3dwLzdPY2dtTVBoL1FnS1RF?=
 =?utf-8?B?UWlXN0d4R2FJSmYrMjN5UUJ2RDFUTXJoOXhkVWVqd3lXUSszRE9SYW9qME1Z?=
 =?utf-8?B?TUd2NnBtU0FxQVRCUEQ1aktiUmxiY3lJMDExazAwT0dHR2VsQ1FMUjR3clJm?=
 =?utf-8?B?VUxSc2RHclEvajZIbGVMSHd5MklBV1Y1a29PUHhLWG1INU5rcDNCdFNOdHhr?=
 =?utf-8?B?MUtPWTdWL1c3RmhNd2sybXhHWlg2KzJVRWQ1ZVdtdXdUMkt2a2VwSlFrZkFr?=
 =?utf-8?B?dFM2Tm5VdFZSVXQzTjdWY3VYZjlJSGl6ZU02YkwreUt4dWYzTlV5SDhMRlc0?=
 =?utf-8?B?ZXJpUWRjOTV4MmFPYjl5V3BNYXluc1ZQQThkYWI1NVV6ckF4Y2pHRzRhWDNv?=
 =?utf-8?B?Z2pTU1BCQWhkL1h2ZmZHSkFYWGIwRUUwUGd1VDhWZGNVdHFqbkpkcmsyN002?=
 =?utf-8?B?TlU4cVZMTWNoREN5QjdubFJDcWNtY1ZrNDg0WjY4K1FaOGVzVlN6M2NXRG9M?=
 =?utf-8?B?V1FJdldWQlhlQURGZmhFdEJzWnMyMzMvdURvRHFTamtGYjZuaWdlNDlLNm9B?=
 =?utf-8?B?SWhkYkdrUXFPTE9xWXRCZTJOVkM5UGlxOHI5VFVtL3hrS3AzNHNERVFUMVdZ?=
 =?utf-8?B?elhTenZkMWtsQU9YbVN4K2h4STUwVGZYb0NjTUlSUlVoK21Nb0FPVTM4NVpZ?=
 =?utf-8?B?ZE5mR0grSVVEdmpMcUZobFdIcVg0dTBqZjVLc3dKbFZnYVA1bnFkL1lidFVp?=
 =?utf-8?B?TW1iMlorTEhUSHhOWjhZeE9NWWhZbWNOOFVXWE54YWdjNFpqRXV2L2NXZ2Rh?=
 =?utf-8?B?bVpnUGlmN3lpSmNPdEtoM2VaU1ViMUZhTU8zeWZWV0xDR090N2oxNXFER2xy?=
 =?utf-8?B?b05BYjVSTFF0Qzl2NWRwK1I2cTNLREJFQXdqTThUNlppVldTYTZCK3RiL09z?=
 =?utf-8?B?M3RLdFMxSzZ4YVh3VXhlWWkxMllvM3pXbE9MelZPZE9tTVcvSEZlNGdDeTU4?=
 =?utf-8?Q?fO3MUBcsP95DOpfCoK6kuk5Jv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6365.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 782bfa90-6862-490a-298f-08da96c474b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 02:46:14.1820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g+peadIxqmvXYX1gSsPA1AM7Oyf42t0KSnbx1fvGgLVHW/CFRi2wLgkKwZ9bvHCVNSJh+8gh0sybtl40mUo3SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5978
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

T24gVGh1cnNkYXksIFNlcHRlbWJlciAxNSwgMjAyMiA0OjI2IEFNLCBMaWFuZywgS2FuIHdyb3Rl
Og0KPiBUaGUgcGVyZl9ldmVudF9kaXNhYmxlKCkgZXZlbnR1YWxseSBpbnZva2VzIHRoZSBpbnRl
bF9wdF9zdG9wKCkuDQo+IFdlIGFscmVhZHkgZXhwb3NlIHRoZSBpbnRlbF9wdF9zdG9wKCkvY3B1
X2VtZXJnZW5jeV9zdG9wX3B0KCkgdG8gb3RoZXINCj4gbW9kdWxlcy4gSSBkb24ndCB0aGluayB3
ZSBoYXZlIHRvIHVzZSB0aGUgcGVyZl9ldmVudF9kaXNhYmxlKCkuIEFsc28sIHRoZQ0KPiBwZXJm
X2V2ZW50X2Rpc2FibGUoKSByZXF1aXJlcyBleHRyYSBjb2Rlcy4NCj4gDQo+IEkgd2VudCB0aHJv
dWdoIHRoZSBkaXNjdXNzaW9ucy4gSSBhZ3JlZSB3aXRoIFNlYW4ncyBzdWdnZXN0aW9uLg0KPiBX
ZSBzaG91bGQgb25seSBwdXQgdGhlIGxvZ2ljIGluIHRoZSBLVk0gYnV0IGFsbCB0aGUgTVNSIGFj
Y2VzcyBkZXRhaWxzIGludG8gdGhlIFBUDQo+IGRyaXZlci4gDQoNCkV2ZW4gdGhlIGRyaXZlciBp
dHNlbGYgZG9lc27igJl0IGRyaXZlIHRoZSBzYXZlL3Jlc3RvcmUgb2YgdGhlIE1TUnMsIGl0IGlz
IGRyaXZlZCBieSBwZXJmLg0KMS4gSWYgd2UgbWFrZSBLVk0gYSB1c2VyIG9mIHBlcmYsIHdlIHNo
b3VsZCBkbyB0aGlzIHZpYSBwZXJmX2V2ZW50X2Rpc2FibGUvZW5hYmxlXyouDQoyLiBJZiB3ZSBt
YWtlIEtWTSBhbiBhbHRlcm5hdGl2ZSB0byBwZXJmIChpLmUuIGhhdmUgZGlyZWN0IGNvbnRyb2wg
b3ZlciBQTVUgSFcpLA0Kd2UgY2FuIGRvIHRoaXMgdmlhIGRyaXZlciBpbnRlcmZhY2VzIGxpa2Ug
cGVyZi4NClBlciBteSBleHBlcmllbmNlLCB3ZSBzaG91bGQgZ28gZm9yIDEuIFByb2JhYmx5IG5l
ZWQgUGV0ZXIncyBvcGluaW9ucyBvbiB0aGlzLg0KDQo+IEJ1dCBJIHByZWZlciBhIG1vcmUgZ2Vu
ZXJpYyBhbmQgc3RyYWlnaHRmb3J3YXJkIGZ1bmN0aW9uIG5hbWUsIGUuZy4sDQo+IGludGVsX3B0
X3N0b3Bfc2F2ZSgpL2ludGVsX3B0X3N0YXJ0X2xvYWQoKSwgaW4gY2FzZSBvdGhlciBtb2R1bGVz
IG1heSB3YW50IHRvDQo+IHNhdmUvcmVzdG9yZSB0aGUgUFQgaW5mb3JtYXRpb24gaW4gdGhlaXIg
Y29udGV4dCBzd2l0Y2ggbGF0ZXIuDQo+IA0KPiBUaGFua3MsDQo+IEthbg0KPiANCj4gPg0KPiA+
PiBJdCBzZWVtcyBwZXJmX2V2ZW50X2Rpc2FibGUoKSBpcyBub3QgdXNlZCB3aWRlbHkgYnkgb3Ro
ZXIga2VybmVsDQo+ID4+IGNvbXBvbmVudC4gDQoNCkJlY2F1c2UgdGhlcmUgYXJlIG5vdCBsb3Rz
IG9mIGtlcm5lbCB1c2Vycy4NCllvdSBjYW4gY2hlY2sgYW5vdGhlciB1c2VyLCB3YXRjaGRvZ19o
bGQuYywgcGVyZl9ldmVudF9lbmFibGUvZGlzYWJsZSBhcmUgdXNlZCB0aGVyZS4NCg==
