Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BA877EDA1
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 01:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347115AbjHPXEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 19:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347126AbjHPXDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 19:03:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1E726B7;
        Wed, 16 Aug 2023 16:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692226997; x=1723762997;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iAiMIA0iVk49yGQ7Mbtn+cqLNbOIpM4vuRtddigpgmo=;
  b=H7+YMnVlfQlcl4gUgHKnzOFGI/0PPU7PEIV7b6ZiFIN8SOG4HJE1Gzi2
   g9pnBZGDVceJsZk1VaO/nLUiKSNzqDFgUV/z/SNTXayieSq2dbvj7WWUj
   NTDVY69SZ+KgKR026cIq+kbqoxkpFEr+zZGJD5Ak7EIZxu0IRDGH+mja0
   GUtuk/V4ibfIy5r4KHes/wCLSaNRSH1jGEmK6c3MKzlXXNf1d6JgKduNI
   qtER6dDAuNaCAv1TLC4E5Oot288mFtd55NmF1/UsTf7aHn9eyIZwh2/6m
   kCJk+nZDsm2JmkMjXIjFTompBggiR1bh6w4n+jNJmZ7a3bd+KAdmcwlGJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="357628439"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="357628439"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 16:03:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="1065017283"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="1065017283"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 16 Aug 2023 16:03:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 16:03:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 16:03:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 16:03:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mh8jDxobIxF+bxmc6HBg5pj1VYefSRGppG1wXbIXMbQCpGYp7b0gH6OOceiyvCkdx3Oi5yVrp75LU3an9PgFvSSp/JmF5YdUC2MBdbOArTvXMa4F6u1AoXf0zjPeBGmHEfP5wNGKJoiOmA9SuDt62BxhbjrmkTLyZqC62Jm60pddF5OsquunbayqCQLCeDuf6DGyrfAyxia+mNmBU5zDGJak89+mWK5e5jny6qO38fuUgPQBfTDwu3TwtHRBWK54xieJmItwyRUrn8Qdphl15niCZ8kmEMJmjS5FEZNe/lB35rm3r85YwWTa0rL9fwe3PIwWRsmLsq4KG44J/2rDlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAiMIA0iVk49yGQ7Mbtn+cqLNbOIpM4vuRtddigpgmo=;
 b=jqaSd+hAQxpZpEp0xJHO8Kgs7PxP3PCt9qyGtY22SP2X3fHXVSlKLSRDtYm0wJgQ+PzMkaBAuutpr4OCWYAqe0Zq/15JVKYY9z/ayPFRxVSN1Ky/pTzi1psuzYpSlxR/CCLqeADtFq5/6r+pESXreO1sApuL0LrPtH7kTh4aVF8nwy7XrhxCb8wI3FgHztrX9OvkgTm+HfYFwf+ZEkSsB/EhIYLwdt9nkuV8OIKDAcq6c+qGhjIbBkg/dg61DkU524tU2CJgSBBH5ZTUNiAnu0M7RE8p6vhUjaBTr2DgTRJWm8DnpcjZMJfKq/jKBxKDlkYpWD0HDo5sIZ6VHxUhUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8424.namprd11.prod.outlook.com (2603:10b6:a03:53e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 23:03:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 23:03:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "David.Laight@aculab.com" <David.Laight@aculab.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
Thread-Topic: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
Thread-Index: AQHZuk8pOpXGo6/5yUqsQMQAFLsPwq/sc/uAgAA4bYCAACw3AIAAxV+AgAAZCYA=
Date:   Wed, 16 Aug 2023 23:03:12 +0000
Message-ID: <340eab5f346e2581bcb252e975df6724e9f7afa4.camel@intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
         <20230719144131.29052-4-binbin.wu@linux.intel.com>
         <c4faf38ea79e0f4eb3d35d26c018cd2bfe9fe384.camel@intel.com>
         <66235c55-05ac-edd5-c45e-df1c42446eb3@linux.intel.com>
         <aa17648c001704d83dcf641c1c7e9894e65eb87a.camel@intel.com>
         <ZN1Ardu9GRx7KlAV@google.com>
In-Reply-To: <ZN1Ardu9GRx7KlAV@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8424:EE_
x-ms-office365-filtering-correlation-id: 20670b2d-d707-4075-769e-08db9eacf770
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H3sb14/BaOgfN1lCiXi/X9q2oYZa1UylOTE8xDUC0D+IcJszEbix3TEDstELdjNlOGyRKN2dwPTj+V/Pbt8O4IXQOGCDyMwtiNSeWtO5N0z57deJA6pA4G5sw7oM22muVHDvWTkM1BDbxnRo79WtVdCT4d/EO4i8vLo71wjQG/E6qeCKueZvMNOrMdq3Z80y+K/tkdGOw/yhssp4HcPXbOQztOebXYMV/veuAL2NR9OyOoYydJyPZJeSQMJzhP1t5JkNwCD2HI1wBSxebVWZtGUXM0mF67vStNOQdppMQSYqD490jzcx4+ErBAyS0XeN4V98DpU5oIoDt7S1h52IG5Fmi7JYbWdc1m3OAvvSJxtaEJzIOuNNDnPJV+l6XfrUTyAjwEueyp3ntlvJUQypJkftG6W08V+FbQuMVs0pbj0Pp/1t40kz2lAA0FVe/z2+YwFjMhnMV5Uro3i8AcsAKZAowRa06dPOfSgNd9E9iMX60uaa3LwXRe42qR8bgtSRl5H8lgwPy/GA+XK7PAZWzvprZ2kSZIZiuDrtCt2zIvT0EToEaToubVVfcdva1l7B7qSUTm8AqwHTja6gFkjdg6KzVb6zgy8nW6cmF35A19U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199024)(1800799009)(186009)(316002)(54906003)(6916009)(91956017)(66556008)(66946007)(66476007)(76116006)(64756008)(66446008)(122000001)(966005)(5660300002)(41300700001)(38100700002)(38070700005)(8676002)(4326008)(8936002)(82960400001)(2906002)(26005)(478600001)(86362001)(6512007)(36756003)(6506007)(71200400001)(6486002)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aG51YmFhQUNkZzVWWklwc0pQWHViS3BRUGFickhtOWZhTFU2ei9IcEE2bThm?=
 =?utf-8?B?NzcydTRuMm51TkgrWVlUOW4rRElKT1M0UDA4SHJSSTEwOXJQVm5adUtmMUdF?=
 =?utf-8?B?ZDB0QmlTSGdCVGs5Z0dzTlU1Y3FCMlJWMzI2dlJtcTkxOE1kSWswQWNuRWJV?=
 =?utf-8?B?SUNpdHFha3pUbnltM24vQTFKMnZXUDdGZ0dxbEV1ckFKU0RxK2xwU2J0cW92?=
 =?utf-8?B?TUl1R0FDa3I5ZXBiU0V1WU9ybTd1aW9OTXY0R0VNYllXN1N0MUNLZmQvSUlL?=
 =?utf-8?B?U1RVc3pMa3VPUDNPYzY1ZXJpM0RSR3l1TnJYUkZRSGdjQ0U2RmpLOVh1S0lh?=
 =?utf-8?B?YkZDK1EzSnFhdVV2M2pRN2g2WGJ0RHMxajQ2VjZLaHNKSlhFc1dlN2FoYkZI?=
 =?utf-8?B?WkMyZk45Rjc5c2M0QmZaYk9KSmh1VWFQNitrSm5kbEtMUFQ3Y3FUZ0Nyeng0?=
 =?utf-8?B?SlUycmJ4WktzYS9WWEZLY1FValNnQ0JxL0xDNlV5ZElrQmhFN0FIYjVHQXBV?=
 =?utf-8?B?UE5oOUwwdEdVcUpaK0FqZTAwVlVTYmc3MnRPa1RTaG1oQmVpenVZV2dYQkZO?=
 =?utf-8?B?R3d3YTVjNTNvRTZ6bjMydG5aTUdrR2ZpQm82cXEvWEtOdVUzSG9sOGN3SC9J?=
 =?utf-8?B?dHI2dUtlZjRzRzJ2R1psdkMwMmtCbmd6cE5veTlraGlJa0NNakJwWStQdXk1?=
 =?utf-8?B?ZUZIK2NvVFdYQzd6L0lXaWJaVnpQMW5OT2hoajJoK0VnclpwZUF1ckxRVVJD?=
 =?utf-8?B?MzAzSngwRVhNd1lkeGhJMEpKUVUrdkJzN2lOM3pDd3BIL0ZwTE0zYUQxTVFM?=
 =?utf-8?B?V1JvV1RoRmJPQkdINUVsMVBLc0tsSkJBQ3BRQU1rYkQ0MEpkMEZpSGZHOVJQ?=
 =?utf-8?B?QVhEMUNIZUxmUzJPeXIyQm9yK2Nzeit1TW1kOGI0YTg5MlhDMEVmZk9lUGdH?=
 =?utf-8?B?dXNuU1hCNnkzUkxXZlpzTW43L2wvODFZYVN6VktGK1lqZHh2aEU0VUk4ajUy?=
 =?utf-8?B?QlhBZE5jdkZEWDFWNCtvbTg5eTZydGY4bEhIUERJV3RQRk5oNFIxUFlnT29z?=
 =?utf-8?B?eWlRL2RZdVVTWlhBQUhkU3J6eCtoc3lTa29mY0FBa3JJdnJUdXBoWkpvQVo3?=
 =?utf-8?B?ekhNclNVN2Q3ZkdWMlkvMW53QzNaWEdHclZIRWNVMmxNVFVjVnRwUUVCVno1?=
 =?utf-8?B?eGg4WXFjZEo2dnZERlEyb2sycWh4S3RFTjBkWUUrdXlEeXRhUlpWK2RDams5?=
 =?utf-8?B?NFVHZlJkc2ZzTUJKV1dHZDM1Q0d3eExzNXAzU056MWlBVTZ2VUNRc0VDUUpq?=
 =?utf-8?B?Z2JIaEh2UVpEaWdteUpsSzdqZGpiNSs1cThHWUw0aDQ4Q1ZMaHM4cGdPSnZ6?=
 =?utf-8?B?KzRnZW1oemhrem4rdG04aktZbzkxN0VDU2Z2Y1BMdVFTMDhoYzBTNGs2RVps?=
 =?utf-8?B?ZzRmcXpKNXYzcWpQZWNyU1RpN1REVTZHdCtjR01NZTFIbzF2VXJWcFdoTTZF?=
 =?utf-8?B?akdEaDB0aUdhSkFMK0VWVVpvUWVwVmRvdGdEWkd0VFExaEVZak5OQkVqc2Q3?=
 =?utf-8?B?K1dmYnlHSGRMSmxTVGRIQ0tnbGRReDVxeW4zbERDQ3NUQmwvV0FhWGNnWjVN?=
 =?utf-8?B?TmVtZW5RNStXaTBLUlE0RTdFOVNJT2lkU1RpOEc0TE1na25NeHZvU3JOR081?=
 =?utf-8?B?dStlSlM5RlUvbGMxUzJUN2orMk5CTWZFTk9kR1J5UzErem5rb1A4QnJYVnl6?=
 =?utf-8?B?Yk1aRVRrWlNKLzdjd1ZqdVdOL0lUZ2dRL0NaNjBTdzNnSlJQWjBVTTB4RjBW?=
 =?utf-8?B?QUNJTDcwU1VFalM2UVJqZG91WXRvVlliTTQ0aTZnU1dGeE1hYlcwdnBMWnFp?=
 =?utf-8?B?WVowTHA0QTJZNGpjWTlHNjZuWWczR1pSVzQzYm1IbHE5SW1xNEZreHdTYjRT?=
 =?utf-8?B?UzBkNUJIQmhXcGVIWmJYeUdBZ0tOemliS3V2YVVXRHpuNjlrVW0xb1BNMHRu?=
 =?utf-8?B?blorZVE0TkNNU3lZbWdJNlFEVVdSQUMrcDRsalBBZTBkaC9zU1BxNlBqMkZm?=
 =?utf-8?B?WG5hQmQrTFIzRWJFbTk4eWZBem9DYWRHR3plUnJiT0hGWjdUTnRBeHI0aUR0?=
 =?utf-8?Q?Yq6pjF4tPyf5+4Zo+X+PDVv4T?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA6F92D4FA3DFF49A57A6ACB3A1B2D84@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20670b2d-d707-4075-769e-08db9eacf770
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 23:03:12.5896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s7UPYV96RpIpqsm8KLOwtWLpGqvbBRlm7OoEtPj1BxWAsLp48pj8cnWDOaK/kRC2Z0ne9lkw8cC79PVbB6NvgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8424
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA4LTE2IGF0IDE0OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEF1ZyAxNiwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+
ID4gPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiA+ID4gPiArKysgYi9hcmNo
L3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiA+ID4gQEAgLTc3ODMsNiArNzc4Myw5IEBAIHN0YXRp
YyB2b2lkIHZteF92Y3B1X2FmdGVyX3NldF9jcHVpZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+
ID4gPiA+ID4gICAJCXZteC0+bXNyX2lhMzJfZmVhdHVyZV9jb250cm9sX3ZhbGlkX2JpdHMgJj0N
Cj4gPiA+ID4gPiAgIAkJCX5GRUFUX0NUTF9TR1hfTENfRU5BQkxFRDsNCj4gPiA+ID4gPiAgIA0K
PiA+ID4gPiA+ICsJaWYgKGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9MQU0pKQ0KPiA+ID4gPiA+
ICsJCWt2bV9nb3Zlcm5lZF9mZWF0dXJlX2NoZWNrX2FuZF9zZXQodmNwdSwgWDg2X0ZFQVRVUkVf
TEFNKTsNCj4gPiA+ID4gPiArDQo+ID4gPiA+IElmIHlvdSB3YW50IHRvIHVzZSBib290X2NwdV9o
YXMoKSwgaXQncyBiZXR0ZXIgdG8gYmUgZG9uZSBhdCB5b3VyIGxhc3QgcGF0Y2ggdG8NCj4gPiA+
ID4gb25seSBzZXQgdGhlIGNhcCBiaXQgd2hlbiBib290X2NwdV9oYXMoKSBpcyB0cnVlLCBJIHN1
cHBvc2UuDQo+ID4gPiBZZXMsIGJ1dCBuZXcgdmVyc2lvbiBvZiBrdm1fZ292ZXJuZWRfZmVhdHVy
ZV9jaGVja19hbmRfc2V0KCkgb2YgDQo+ID4gPiBLVk0tZ292ZXJuZWQgZmVhdHVyZSBmcmFtZXdv
cmsgd2lsbCBjaGVjayBhZ2FpbnN0IGt2bV9jcHVfY2FwX2hhcygpIGFzIHdlbGwuDQo+ID4gPiBJ
IHdpbGwgcmVtb3ZlIHRoZSBpZiBzdGF0ZW1lbnQgYW5kIGNhbGwgDQo+ID4gPiBrdm1fZ292ZXJu
ZWRfZmVhdHVyZV9jaGVja19hbmRfc2V0KCnCoCBkaXJlY3RseS4NCj4gPiA+IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2t2bS8yMDIzMDgxNTIwMzY1My41MTkyOTctMi1zZWFuamNAZ29vZ2xlLmNv
bS8NCj4gPiA+IA0KPiA+IA0KPiA+IEkgbWVhbiBrdm1fY3B1X2NhcF9oYXMoKSBjaGVja3MgYWdh
aW5zdCB0aGUgaG9zdCBDUFVJRCBkaXJlY3RseSB3aGlsZSBoZXJlIHlvdQ0KPiA+IGFyZSB1c2lu
ZyBib290X2NwdV9oYXMoKS4gIFRoZXkgYXJlIG5vdCB0aGUgc2FtZS4gwqANCj4gPiANCj4gPiBJ
ZiBMQU0gc2hvdWxkIGJlIG9ubHkgc3VwcG9ydGVkIHdoZW4gYm9vdF9jcHVfaGFzKCkgaXMgdHJ1
ZSB0aGVuIGl0IHNlZW1zIHlvdQ0KPiA+IGNhbiBqdXN0IG9ubHkgc2V0IHRoZSBMQU0gY2FwIGJp
dCB3aGVuIGJvb3RfY3B1X2hhcygpIGlzIHRydWUuICBBcyB5b3UgYWxzbw0KPiA+IG1lbnRpb25l
ZCBhYm92ZSB0aGUga3ZtX2dvdmVybmVkX2ZlYXR1cmVfY2hlY2tfYW5kX3NldCgpIGhlcmUgaW50
ZXJuYWxseSBkb2VzDQo+ID4ga3ZtX2NwdV9jYXBfaGFzKCkuDQo+IA0KPiBUaGF0J3MgY292ZXJl
ZCBieSB0aGUgbGFzdCBwYXRjaDoNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vY3B1
aWQuYyBiL2FyY2gveDg2L2t2bS9jcHVpZC5jDQo+IGluZGV4IGU5NjFlOWEwNTg0Ny4uMDYwNjFj
MTFkNzRkIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vY3B1aWQuYw0KPiArKysgYi9hcmNo
L3g4Ni9rdm0vY3B1aWQuYw0KPiBAQCAtNjc3LDcgKzY3Nyw3IEBAIHZvaWQga3ZtX3NldF9jcHVf
Y2Fwcyh2b2lkKQ0KPiAgICAgICAgIGt2bV9jcHVfY2FwX21hc2soQ1BVSURfN18xX0VBWCwNCj4g
ICAgICAgICAgICAgICAgIEYoQVZYX1ZOTkkpIHwgRihBVlg1MTJfQkYxNikgfCBGKENNUENDWEFE
RCkgfA0KPiAgICAgICAgICAgICAgICAgRihGWlJNKSB8IEYoRlNSUykgfCBGKEZTUkMpIHwNCj4g
LSAgICAgICAgICAgICAgIEYoQU1YX0ZQMTYpIHwgRihBVlhfSUZNQSkNCj4gKyAgICAgICAgICAg
ICAgIEYoQU1YX0ZQMTYpIHwgRihBVlhfSUZNQSkgfCBGKExBTSkNCj4gICAgICAgICApOw0KPiAg
DQo+ICAgICAgICAga3ZtX2NwdV9jYXBfaW5pdF9rdm1fZGVmaW5lZChDUFVJRF83XzFfRURYLA0K
PiANCg0KQWggSSBtaXNzZWQgdGhpcyBwaWVjZSBvZiBjb2RlIGluIGt2bV9zZXRfY3B1X2NhcHMo
KToNCg0KICAgICAgICBtZW1jcHkoJmt2bV9jcHVfY2FwcywgJmJvb3RfY3B1X2RhdGEueDg2X2Nh
cGFiaWxpdHksDQogICAgICAgICAgICAgICBzaXplb2Yoa3ZtX2NwdV9jYXBzKSAtIChOS1ZNQ0FQ
SU5UUyAqIHNpemVvZigqa3ZtX2NwdV9jYXBzKSkpOw0KDQp3aGljaCBtYWtlcyBzdXJlIEtWTSBv
bmx5IHJlcG9ydHMgb25lIGZlYXR1cmUgd2hlbiBpdCBpcyBzZXQgaW4gYm9vdF9jcHVfZGF0YSwN
CndoaWNoIGlzIG9idmlvdXNseSBtb3JlIHJlYXNvbmFibGUuDQoNClNvcnJ5IGZvciB0aGUgbm9p
c2UgOi0pDQo=
