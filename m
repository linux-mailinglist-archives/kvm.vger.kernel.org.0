Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9663670CFA1
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbjEWAk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbjEWAGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:06:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C87D19BD;
        Mon, 22 May 2023 16:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684799044; x=1716335044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UyWmAi1miZjKdtEPTEtyWH07vQ0DIdiw6o8aMP86fG4=;
  b=WhNvSAq4ieVrbcOAiQ0bQdoWme+T0sNYU13EFlo4+fWfLl+VirLPTZSD
   AB7PQWuYu/lfaRk8f0Tcx/WDIWU1WADhEjJguvBxU0AjPh+esBgEKBXE4
   ekUj0GS+3N4vAZYEgUMfuImxjQNi4M5bXt3EKKjOLP1GvF28g9Yvq/VV4
   SJQaRCkt6Tl1/wpBvFPjp3kjnEeepQuE67LybckfuuaRpWnqOMCDDhfxz
   xjQbMjYxu1NZORi7H7T6J4ex6bS5zLyMbqOQlZnOEStdZKb3GQIyRItbE
   Dpu5FSGFmF/5CVh9X7YMGZK6c9eLNEWG62GqTJGSEK0PKNnGXK0kKK+Y0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="416537961"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="416537961"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:44:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="697813826"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="697813826"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 22 May 2023 16:44:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:44:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:44:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 16:44:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 16:44:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFvaH//BaRU5PJvBzmhmgN++y/ghxFr2PrbbZ7JVuAjGVZj9b9Mvy26uykyDrBztpv8JPN49dH9stsS8Vvo2XaOq7aebYsNgUZj+AmmVoN0Ry8YbdbKdt+ajSB+eq++QpXxLLES3V1usUrcnp5ffEuZkdfYYSl25GS8sRFRYvcwyAdB6zcWEn3HCQg+zb4mzuos2ovkgvBV2DNdrXVJZ4F5+9yAfyzn0joRgOebBMf+EzV5sGdH5+PEpm1ls8Zeb96x57eZ22JpLYSEqu5qERgBFtmmvYWL4UKGseNL7MFZFiBJWyZ+NyHD/6OaUtXGpb/Q0P6nqqsx5uroij3lJpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyWmAi1miZjKdtEPTEtyWH07vQ0DIdiw6o8aMP86fG4=;
 b=W9/NSXbxsC0TM3YJax/Ahp7LzRq3q3VWgFmk0sSCyrzsRHbMPxVi3ZE2bp1r1hmi12R7OYqNW+f4keVs702IXZ945cK1o1cuRci0gXDzrKcYte2GS0Q1A8voOhBeYl/mAFOyyvIHkOZz/EjrOrruKNoe+G0D+aWRDLBeg5DQf0YJlzxLYsvhoUgxHkqhkMHHDCr8BP9CGtuyqeOp3bzv5yZEIB7OUBvRlMaM7nSbPGXGbiv8PVEN1Z3C4zRaKs3k0KSKXS6yP2HSuAK7hhlKBvcPXUOHXXFsIaWuznjAv9dJVIPdtDsssfBg7TZPGU1MWZXzsm6BhuljfUA8UDq0pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4621.namprd11.prod.outlook.com (2603:10b6:806:72::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:44:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:44:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 13/18] x86/virt: KVM: Open code cpu_has_svm() into
 kvm_is_svm_supported()
Thread-Topic: [PATCH v3 13/18] x86/virt: KVM: Open code cpu_has_svm() into
 kvm_is_svm_supported()
Thread-Index: AQHZhSyc7KePmH4DEk6RrUg2yQ4fuK9nBDOA
Date:   Mon, 22 May 2023 23:44:00 +0000
Message-ID: <7557efce6fa10cf9f3cdb807ed88ebc2b38a94b5.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-14-seanjc@google.com>
In-Reply-To: <20230512235026.808058-14-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4621:EE_
x-ms-office365-filtering-correlation-id: e690270d-a885-4da0-3b61-08db5b1e6afc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0xMNcaufYbjKb7f7D4TGGpnXsAzmWmJa7h7ltjDslHsfDCaIC9VLl/syicoMHvCHkan1n+rKO4OIacdSl5pjlQ6c+n6df15Uve2thfw9YeLpxZyuEML/HjclhjzOuWDuBMHqhUQcIKBNjp1l2HYC2hdTR72W6RHPPLGXirRk3wrBFL7WofSjCEGgqOmyG+W8h1DjQD2LXvXACq6/kBmXz62P53iT7i//x9I5TrZJVoq4Rta4HnFPNmwloV1SDbAUiQU3CaS0SSz6GYnaGtYSReI1g+WqI2eK7/n4+++ToerX29xI8QJCMft+dhWJjfS+BNuGj+XkNEE6HhFABurwhxvsMNFYF27zp3I43Tig7225GPXYjzj2jSFoyJsTc96Tq4WMhi2Lkkatc4HKhSjGHpWcyvEsNKFt5aRMmbrOOMBR/7NbrO9b9SoUIF2NMHd//REeeoc+Jyd/e6VuUXTqtKqS74WNn+txZOOQGDB1FaYz8Enkx4Q8xh1jpm5Mq3pt0qJ/d/IziCQCmDpdD+k9UOsgcFRBLhCkqxvnuj75jwGiF3AIX1GWLz1piGjmw4tmpFJDyGNq3n8ySeyXKfohQgYOpFK5WYX37u6YLlwuNjn8JIARxJNJdWpuSoPZaq64
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199021)(76116006)(66946007)(64756008)(91956017)(66556008)(66476007)(66446008)(478600001)(41300700001)(6486002)(54906003)(110136005)(316002)(71200400001)(5660300002)(86362001)(8936002)(4326008)(38070700005)(8676002)(38100700002)(82960400001)(186003)(6506007)(26005)(2906002)(6512007)(122000001)(83380400001)(2616005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHRSZVlZdnZCam5OTzJwajNLaFY5bW8zSHllVkFQSUloQ2RwamJlUEVYNEJ2?=
 =?utf-8?B?SjZCdDkzYnRweFVwZzRteit5elVsNXZqRWJEbkxNZEw4M242QkFFOWFLSDBz?=
 =?utf-8?B?engwRG1GTitZcG5oY09XU2pBdVJqNmR0T1VwQjNaRUttQTBWWUkwcTNBRXN4?=
 =?utf-8?B?OGRJZW5UTVhUR0FLUWZxdmtpWGgrWi9MY0JRejdhRFQ2Tm5pS1Q5VU5sUkxC?=
 =?utf-8?B?dTdGSFJVMDdPaElRMi9yOXBYUDRZWnEzWHRZcy9CeVNERFlzbWYwQmJxNzk3?=
 =?utf-8?B?cFEwUm5RN1JNQjlnQXhRcmR1VWFnRG8xVktqTW9NMDhHSythRTJySG1hOXIy?=
 =?utf-8?B?VnFTZGtZTktZY05ETDloL0ZXNnNrMTNMbVZZcFJkbFdwaUVKc28rbjFseWY0?=
 =?utf-8?B?RXArOWFYVzRjbmVCMDBoZi9GWWVmVTJPckhzVTdNaFZIZUxpUEhwOGg4dWRH?=
 =?utf-8?B?aGphV1pxblJsbHFPRjg5US9RdnlqY2x1a1loVHdpMkFTK3g3eHozdTZNaklo?=
 =?utf-8?B?eUwwcmhtbklyOHVJR1hwditEd3VsMzd6RzUzbUlCdEcvdEVEMElrK1c3U1hN?=
 =?utf-8?B?emVqVXFsaHJ0d0hUcFhKVW12QW9MSjRuZE5KcGVCRG1UbWFwMHJTMy9CdEFR?=
 =?utf-8?B?MXJjVlJjSncrbGdic1VSU1VnY0xRQ1JWNHVhNlErTjRPdXg4LzBWZ2ZjNllj?=
 =?utf-8?B?MkxOYnN6aGZ1SFNHeTd6QUdKSXpPR3dYSUdxeDh4MjE0RHFJRVFWRytQK05w?=
 =?utf-8?B?MlNJajlYb3ArcEljb01HWDhMbFVNV0V6Wlc4a0pjZ2dLcnRXZHFHVEgzV2pr?=
 =?utf-8?B?L2huZXB4anRxSUlPb1FBMHB2dHk5N2c1M1BEQnBOMVFndERFUVYxTmsxN1Ny?=
 =?utf-8?B?ZlhTOU9nY0EwdVBvQW1xVFRiWnYwL1JiL0RzZE1wbklsOG9Ca29paFE2M3Rr?=
 =?utf-8?B?aldib3d0NFhwZFVvNmNXUlhsdURTcHhQUlhtMVU2aG1UcVRiZEwxR3AydlZt?=
 =?utf-8?B?dVdmcEgwK1NLVXhGTnBaak9FcERmeWV1dFluYS9ZWW01L2dhRXRtUTZZbGFP?=
 =?utf-8?B?Tzh6bW1ZbXpMZXlOWU5oN09kTzNWWmV5L0NRYkRRYlVXek9QWkRFRVdYNXBt?=
 =?utf-8?B?TUtBM2hlRVg4eHNHdzkxMmdVWlB5NEZpQ2t1N2tMN1V6WjR3NnFqcTNjT3hQ?=
 =?utf-8?B?KytwUHVrQi9YbEk0eTVaM0t5UXNWWFpuSGlxL0pveXVVNGRZZkxnK0FQMHdE?=
 =?utf-8?B?RGdnTGxVZzdPbWRlNGVvU3VCMkRXVm1IMCtjOHJvZk52c05ZKzlpU3U2aENI?=
 =?utf-8?B?NUtTWWhnWmVIMUE4b2g2TkVIaVNhNVBJWTR1SXdubllyVFU5UzB2cmU2VlEz?=
 =?utf-8?B?cDU3aitUeHFWMjIwSEd3eUx2VjV6NEtOcmNnNHpNMWFySy9qQ3dudVphUHE4?=
 =?utf-8?B?MmpuMzdOaE5HbEM5a3gyZUZzVVNKSlVuTzZVWVB2UWRmeDdoczdFQU9iWGVt?=
 =?utf-8?B?RkgvQ2pPOVZJaFBkTEFKby90NGZuNWFoR0MyZGw1aTBmTjE5cmdVNnhMSWZO?=
 =?utf-8?B?cy9PRTB1T2hoQUpwUHhiSEFmN1lOWFVlSTlScGdvRTlTM1FiQnB1SDFPSVBw?=
 =?utf-8?B?Z2k0WlR1aFdJUExPMDRSQ2ZEaDJhR2NadXFLZ0FzOEVOaFVSVjZnTGZSS2ZR?=
 =?utf-8?B?RWo1UDMrQng0eW81cnRpaWg5Tzh3NXl3YUM4NWFrQmtVMTJieTNRbDRYTENP?=
 =?utf-8?B?cVNXMHY4RFpCOFJQQWlGRFl3ZHVEcVozN2RWRnNybzlPZjI4eEJ2S2JRR2xQ?=
 =?utf-8?B?Vko5WElpcU44aGh3cGd5N3NSendkdW9nWG1kNWU4ek5aRXVkMnRyL2VieXBt?=
 =?utf-8?B?WXg0d3Q4RXN2QXFzZndvN3ltc1lGUEFyekFCTm1LTHB0eDB5ZVdZemRMbldD?=
 =?utf-8?B?eEw1Mlh1QWxXM0UyL3ZYWFZhU3N4eFo0Vy9ORjg1UnRxMlF1UHZBZ2lqQnJS?=
 =?utf-8?B?WGQvR3FJbm9ENkc5Q2RkT0NMd21WekJYNXVXRUFLU0R1UjI4elFrMDU2WFh4?=
 =?utf-8?B?SkNuNDY4b2RRdWJPbGN0T0VmTmgyNFArOGR4dUljcEJ2NzFWR1FhNmhYcW9j?=
 =?utf-8?B?YWxhemt3MmdCV1d0bEJwU1JhdnRaYTd3ZWFpamQ3QndwUUlvR2F6c1YvYURJ?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7584B5A8C927B448832FA50A5CD64CC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e690270d-a885-4da0-3b61-08db5b1e6afc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 23:44:00.4815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sRrE+zXJGYRr74SnJK2dOb56wKVETen8kVSeJnXeFoz+Sw7bI1COsxeHJntxIdyUy9UGpCNciw9GNyTdKHJxcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4621
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGb2xkIHRoZSBndXRzIG9mIGNwdV9oYXNfc3ZtKCkgaW50byBrdm1faXNfc3ZtX3N1
cHBvcnRlZCgpLCBpdHMgc29sZQ0KPiByZW1haW5pbmcgdXNlci4NCj4gDQo+IE5vIGZ1bmN0aW9u
YWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhl
cnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClRoZSBzYW1lIHRvIHRoZSByZXBseSB0byBWTVgg
cGF0Y2g6DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoN
Cj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS92aXJ0ZXh0LmggfCAyOCAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+ICBhcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jICAgICAgICAgfCAx
MSArKysrKysrKy0tLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDMxIGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZpcnRl
eHQuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZpcnRleHQuaA0KPiBpbmRleCBiZTUwYzQxNGVm
ZTQuLjYzMjU3NWUyNTdkOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdmly
dGV4dC5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZpcnRleHQuaA0KPiBAQCAtMjIs
MzUgKzIyLDcgQEANCj4gIC8qDQo+ICAgKiBTVk0gZnVuY3Rpb25zOg0KPiAgICovDQo+IC0NCj4g
LS8qKiBDaGVjayBpZiB0aGUgQ1BVIGhhcyBTVk0gc3VwcG9ydA0KPiAtICoNCj4gLSAqIFlvdSBj
YW4gdXNlIHRoZSAnbXNnJyBhcmcgdG8gZ2V0IGEgbWVzc2FnZSBkZXNjcmliaW5nIHRoZSBwcm9i
bGVtLA0KPiAtICogaWYgdGhlIGZ1bmN0aW9uIHJldHVybnMgemVyby4gU2ltcGx5IHBhc3MgTlVM
TCBpZiB5b3UgYXJlIG5vdCBpbnRlcmVzdGVkDQo+IC0gKiBvbiB0aGUgbWVzc2FnZXM7IGdjYyBz
aG91bGQgdGFrZSBjYXJlIG9mIG5vdCBnZW5lcmF0aW5nIGNvZGUgZm9yDQo+IC0gKiB0aGUgbWVz
c2FnZXMgb24gdGhpcyBjYXNlLg0KPiAtICovDQo+IC1zdGF0aWMgaW5saW5lIGludCBjcHVfaGFz
X3N2bShjb25zdCBjaGFyICoqbXNnKQ0KPiAtew0KPiAtCWlmIChib290X2NwdV9kYXRhLng4Nl92
ZW5kb3IgIT0gWDg2X1ZFTkRPUl9BTUQgJiYNCj4gLQkgICAgYm9vdF9jcHVfZGF0YS54ODZfdmVu
ZG9yICE9IFg4Nl9WRU5ET1JfSFlHT04pIHsNCj4gLQkJaWYgKG1zZykNCj4gLQkJCSptc2cgPSAi
bm90IGFtZCBvciBoeWdvbiI7DQo+IC0JCXJldHVybiAwOw0KPiAtCX0NCj4gLQ0KPiAtCWlmICgh
Ym9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1NWTSkpIHsNCj4gLQkJaWYgKG1zZykNCj4gLQkJCSpt
c2cgPSAic3ZtIG5vdCBhdmFpbGFibGUiOw0KPiAtCQlyZXR1cm4gMDsNCj4gLQl9DQo+IC0JcmV0
dXJuIDE7DQo+IC19DQo+IC0NCj4gLQ0KPiAgLyoqIERpc2FibGUgU1ZNIG9uIHRoZSBjdXJyZW50
IENQVQ0KPiAtICoNCj4gLSAqIFlvdSBzaG91bGQgY2FsbCB0aGlzIG9ubHkgaWYgY3B1X2hhc19z
dm0oKSByZXR1cm5lZCB0cnVlLg0KPiAgICovDQoNCk5pdDogImRvdWJsZSAqKiIgY2FuIGJlIHJl
bW92ZWQgaW4gdGhlIGNvbW1lbnQuDQoNCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBjcHVfc3ZtX2Rp
c2FibGUodm9pZCkNCj4gIHsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMg
Yi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IGluZGV4IDBmMGQwNDkwMGJmMi4uYjM0NzE3M2I0
ZTI5IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+ICsrKyBiL2FyY2gv
eDg2L2t2bS9zdm0vc3ZtLmMNCj4gQEAgLTUyNiwxMSArNTI2LDE2IEBAIHN0YXRpYyB2b2lkIHN2
bV9pbml0X29zdncoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgc3RhdGljIGJvb2wga3ZtX2lz
X3N2bV9zdXBwb3J0ZWQodm9pZCkNCj4gIHsNCj4gIAlpbnQgY3B1ID0gcmF3X3NtcF9wcm9jZXNz
b3JfaWQoKTsNCj4gLQljb25zdCBjaGFyICptc2c7DQo+ICAJdTY0IHZtX2NyOw0KPiAgDQo+IC0J
aWYgKCFjcHVfaGFzX3N2bSgmbXNnKSkgew0KPiAtCQlwcl9lcnIoIlNWTSBub3Qgc3VwcG9ydGVk
IGJ5IENQVSAlZCwgJXNcbiIsIGNwdSwgbXNnKTsNCj4gKwlpZiAoYm9vdF9jcHVfZGF0YS54ODZf
dmVuZG9yICE9IFg4Nl9WRU5ET1JfQU1EICYmDQo+ICsJICAgIGJvb3RfY3B1X2RhdGEueDg2X3Zl
bmRvciAhPSBYODZfVkVORE9SX0hZR09OKSB7DQo+ICsJCXByX2VycigiQ1BVICVkIGlzbid0IEFN
RCBvciBIeWdvblxuIiwgY3B1KTsNCj4gKwkJcmV0dXJuIGZhbHNlOw0KPiArCX0NCj4gKw0KPiAr
CWlmICghYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1NWTSkpIHsNCj4gKwkJcHJfZXJyKCJTVk0g
bm90IHN1cHBvcnRlZCBieSBDUFUgJWRcbiIsIGNwdSk7DQo+ICAJCXJldHVybiBmYWxzZTsNCj4g
IAl9DQo+ICANCj4gLS0gDQo+IDIuNDAuMS42MDYuZ2E0YjFiMTI4ZDYtZ29vZw0KPiANCg0K
