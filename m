Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D27741DFE
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 04:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjF2CLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 22:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF2CLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 22:11:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2666C210E;
        Wed, 28 Jun 2023 19:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688004671; x=1719540671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c53ho8xqT1D4AiFjQ77yZoqQ58QDfLE/76F7GUWArYw=;
  b=nT1Zh068mDZV+uPTLDwWJroTPqH3uVQqSgUu0JxNqiCchrC3UuJPkrAZ
   vm8DtgL9JlTUrRzISNA3Saa17nTfznR1LkaHDn4IGeMctLUXJxSCTQXwF
   Qw2Jjm7YTI5ZoxIIL1LlIvTWkmlTkgRGCkK/+UL2/fcmhvWj5ZfAwjQ7+
   W4As+E8+kPI4ats3lhyBe3cmFkuHaqUJdsf6nNQCz7l8WoULaoImUWpab
   zvFT27sG5ZriAs2mDRpm2GXYDlpTd1Rpv4P7ssWnoWy+2LtOCrmwKBceC
   J8OhIDthhU5KGqyWkXww4y2Avd0YvVVZjLsKoHGixoDdxut0tVQQrr1Rj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="428021879"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="428021879"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 19:11:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="963830788"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="963830788"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2023 19:11:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 19:11:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 19:11:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 19:11:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+VFSFwqlWNSxNLN4kgogfyBh8wPN2vKSfIgXlu49qUW7NZYmZ96rPueJvfQUi0nFLBtH3hjcjdFE5Z/By979hjctln96sYpE8BxocNTqMhacw1ySfH0XnQrmQZElHkHVpE7bqwZ6CIymKHdRkcySJ8uP62vVWDqR65HhlZqZn5kLf9DBwf0ALY0nVNkd1AE44/7KoZGluyS/Iz/VGUwwjex2V6VrYNOJrXimuRImhKV8erEKgAEGYAcPkKjhJtRD3lSzfnQzLQulfCG4T843CJ7MutWL0cIc4BwMPL9fhXZyL2/uFpOJNdiEE9n+EzOKQBCxJSnvXi6SS07Jrjklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c53ho8xqT1D4AiFjQ77yZoqQ58QDfLE/76F7GUWArYw=;
 b=AG61eh1vI3ynX1wurCF+Tm9//jzV7DqTLwxpZ49LjzOsts7o7OrtOH104xLQ+WJ+Ivwst+svKA1YXRwrWolbfkONP/V7ek7qAoNVoLCi7ARlV61QLZEldKyFIqzgE1Da0bARsiczVh3U1N+q55fRI5dQpWWY30rlWucR8LQwNJQkZqiczQ8IDmjhYKdqT/52wXuAOWGkKkuUJND3vEJdjXXCHcQ1eiRNvR4RY5wWtuKabgVNzApl1gPLkBEqWQd6rH64Fb6KFbdPqv+mrR/idHbmYMd4MjFnKD1W65m1ZGqDI9TGp1Q+3Li0WFQCbzl0JCPZ/wN/yDVWxBB6YHUzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by BL1PR11MB5977.namprd11.prod.outlook.com (2603:10b6:208:384::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 02:11:05 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c3fd:5b99:a829:ebc6]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c3fd:5b99:a829:ebc6%5]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 02:11:05 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] perf/x86/intel: Get shared reg constraints first for
 vLBR
Thread-Topic: [PATCH 1/4] perf/x86/intel: Get shared reg constraints first for
 vLBR
Thread-Index: AQHZoEaW1Qxk7Psj+ka2F4yjhfPZd6+fsIYAgAFUXXA=
Date:   Thu, 29 Jun 2023 02:11:04 +0000
Message-ID: <MW4PR11MB5824E7C159A4B5CCA39101CFBB25A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-2-xiong.y.zhang@intel.com>
 <ca71fc1f-280e-19ff-ce0f-8befa29f45cd@gmail.com>
In-Reply-To: <ca71fc1f-280e-19ff-ce0f-8befa29f45cd@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|BL1PR11MB5977:EE_
x-ms-office365-filtering-correlation-id: 391791d9-edca-407f-2c43-08db78461803
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EpmD28BRYEK0Bw1DG5z2ypi+7MbySGt8c4HXY122MptXTsBoKNVJwdLdaIrvX56ruf+mxHQ9MZ1bpdjEE0ShlFa//JcfdFh3MMTaFdVzObc19xzZ6kDqP1w0nIN9SlR6IC/8JUvkq8g6hWZ1TY1NAjWw5K2agWGhQUAuhL6Gnv5dsiZmxyYVjbOe+CVMGGrhJ6LSFOzLGFj40JAX0UFXn2Rg+qcKkwbN7Fzsw9rQ81j9xF2ulMQs95bdL5cp3HflwH6NNoybrv2OmMiweeVehV/jr9V2oi18OH0a0hT63d6/BI5tI6yKAriuAzC8Xg92Od3xqBV8qDh/riGzY0VvIQ0XhXJBbMqh4sW20OQeP5Bj/X9q4H2xRLlbvdWdd584rftfc6y/SqCImJjYpg4EFKAf7pGfXUq7K122DXRFAGcdqrPeJB7fTowxzaNwlsuxu7UyW/LwMViimh5BHXfakvzw7j5io+VdIivKf5LJMAMnbaqcgDPwRpFNJI/ijrxwNP8OXgronUxxqEApEdHCmEbG2g9ziQiCzenIp9KXRJaYv//Ob+Qx77OPz7ScZE+rNghZiLdu3NL2HVQItOsNrg4dUjWTFDCPVRLOB5KCn7I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199021)(26005)(9686003)(66556008)(66476007)(4326008)(38070700005)(6506007)(110136005)(966005)(7696005)(54906003)(478600001)(186003)(2906002)(53546011)(71200400001)(83380400001)(33656002)(122000001)(66946007)(55016003)(82960400001)(5660300002)(52536014)(38100700002)(76116006)(64756008)(86362001)(8676002)(316002)(8936002)(41300700001)(66446008)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHhpZnFFUXl0NnFwTDMrMHJXdW1UZFVKUkZMUTdhYURrZXppdERDL0V4ejlV?=
 =?utf-8?B?V0tGMVE1M1FzZms1VkQrSGNNdXBuNnM2d1o1Y3ZuKzZtajEwWW1OS29zMUg5?=
 =?utf-8?B?RTJFcG5LbUd3aVI5aXJ1TkdOTWJDbnI3U2lEam1mcUs5VktCZnkrcHgxcnY2?=
 =?utf-8?B?b1psRG1RS2RMbzNwTHBOanJwTkpSdFA0aGdVbDkwYnJkYXJ3Z2FyRkhQZ3R3?=
 =?utf-8?B?a1d3b2tLQVZucUlkQTY1czdpVzN4cUpFNnd6d2tkQndINTZxbi9yWWMrS3lC?=
 =?utf-8?B?QzVZVjNjNGp1YXlENm5jY0g3M1Faa245dVBzL1FrT3JrY2dSVld3NHAwTmhR?=
 =?utf-8?B?Z3VXNUJBM1c0WTdXS3p4NC9QTkN2ZGJRWHlnZVI2SHFnY2lZUnlIOGJTSURw?=
 =?utf-8?B?d0NIMUVhb2J3NFBzWWV4RyttMm9SNkJxWGJocXdpakp1a3Vwa045ektuQnlJ?=
 =?utf-8?B?QVFvb0haTTMybU12bDE5ZlBXYTBVc2s5bEhaRTZUS0ErQ1VOZzhEYzF5VkV6?=
 =?utf-8?B?Uk1vcm1KNkRxb0s3LzNoMEhFNk9waUt4aCtmSXk4Z2dWTjJUNWt1ZnZiK0VE?=
 =?utf-8?B?cVM0aWpBSzg0dWI0VXNCQVhZOFMwTVFvcmRWV1ViVHBIcG1SWjRXY1VqUUJQ?=
 =?utf-8?B?VTBFL25VeW1RVEVnQS9lRWQ1VjdoSXhxbDk5QjNjZHRYbzZXSXNLazQyWFhV?=
 =?utf-8?B?ZGtYVXlTbVZnSDdLVGNMUDMrVk1ETTRxdWttd0g1ZTRZOUd5MmYrK1QwTHJY?=
 =?utf-8?B?MktmOXFqNXMyOXhiNkdCVE1Nb0c4TFpqcW5uOXc0K0VCNUowaDZOUG1GV0ZS?=
 =?utf-8?B?cU9RdDZqc0dsZG1xQ0lxTGVkd09YNTBHSEQzYmpqdWtqNmN3RSsrckNOOW8w?=
 =?utf-8?B?aFVuRTg4Q2NTNVEwT0VuN3pZZ1BlL1RyQnNHOWtZNUdpblMvTDBmTGhRUHRo?=
 =?utf-8?B?OVZkZXhsRi9pNmRsQ29QdldBdzQvRithMmgrS3NPNDVOcjVsU2ZMTExrQ05U?=
 =?utf-8?B?ZUJqVTkraW83UHNHUmxaV0xHd2VQbHVSd293cEwyYWIyTWNMeGpRcEVONFMv?=
 =?utf-8?B?dC81ejZLMGtpZFhSN0U3UnpZNG95UWxUTGw4M0dad3pXY1RwUVF5ZHBEV1ZL?=
 =?utf-8?B?TjltUnp3ZTl3bUx1bkwwSGVYSFBLMkxnOCtnb3Z3Q0l2djZDUHJrTnVLYklK?=
 =?utf-8?B?SUVzYkhueG5uclRvR2cvb2JjOEhTNG5WMEpZT3pCMTFRL05lbXRiVVAwZTBl?=
 =?utf-8?B?NWJlMTh0TlNlNU04U3hOY2JZc1lRbnRUNkxaK25JRjVIVEhrM1VEOTl0Umdo?=
 =?utf-8?B?cVVRdjdMd0czS0h3bUpBVFIxYmdLcTA5Wnp1RkdpcWdQN3VVMm5wNmpwa3da?=
 =?utf-8?B?Y0RwbVVxQ3dGd1FUMzlvdHhPZ0Y5aFpxRVNmTDRURUljS0ppRzUzS1N6ditk?=
 =?utf-8?B?ZnNTNEx4eE4rejZ4WHZqZVdKbE90UXAxVFhHN3A2QUVOYm1mRmI3dXgxNm9F?=
 =?utf-8?B?K3RCQWZ6dmFDNHM2VlNPcjdLTFprUjVmOWNDUUFJSXAwSEtjWDVDckdnSEdV?=
 =?utf-8?B?SnMxR0REeDZ2U3J4dWpNY0M5Z2EwNXNrM29MUGlRRTBSM2NQckwrTXFMRnJr?=
 =?utf-8?B?YkNJOUlFQXpqK1RaVC8yaU93VkJUZEJ1RHQvcnhEUmJSM2dNY2Z0K0xBMWZ4?=
 =?utf-8?B?b1BhSFNldzVyMXhTNGdkU1ZGdlVlTWl4YW5zNkdKai9EbkE4bXBhbURYUi8r?=
 =?utf-8?B?cHR1aEFaVi9TaXNVS3k2Z21SNlhua254N2w5NkVQNUc4SWFSMEhoYUVnNDdz?=
 =?utf-8?B?WUZFT3phblpJSldKUWJoUVRPWmpES05xVmJ3Q28vcGJxZGdXQU1iekpTMFJO?=
 =?utf-8?B?T1lhZ3htZ3U3QTRsK0ljbTd4RUdtbmVFcklpZlgwdU1lTmdxelZ0MUxOazFt?=
 =?utf-8?B?VEtJY1BqY0RKN1A2aVdSSlFDdkk3Q3Y5U3MzcUFoR0owRzVKbmd6RzlDc3Az?=
 =?utf-8?B?RlF1ZjBQR3VaR3NDK0lMd3lybTU0b1RRdzJRZVBZeFB5R3F4WEJCdC9ud2Nz?=
 =?utf-8?B?bGI1eFc1ckJsSElKVDRDNEFEMG5YemxCOHJBenI5Z0c0dWowQW1PcWhHekRw?=
 =?utf-8?Q?QqObvqCxC+Ynq/IZl+rIUJJOj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 391791d9-edca-407f-2c43-08db78461803
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 02:11:04.8713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VXaOATxGr2XNaWdZHyFkHLqRYMmGuh+5AobT+FJ4oKjt5IeQdA74X2U06pCVP6h/HTILxwhDXyC6JuL6L85ILA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5977
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

PiBPbiAxNi82LzIwMjMgNzozMyBwbSwgWGlvbmcgWmhhbmcgd3JvdGU6DQo+ID4gV2hlbiBob3N0
IGhhcyBwZXIgY3B1IHBpbm5lZCBMQlIgZXZlbnQgYW5kIGd1ZXN0IHVzZSBMQlIgYWxzbywgaG9z
dA0KPiA+IGNvdWxkbid0IGdldCBjb3JyZWN0IExCUiBkYXRhLCBhcyB0aGUgcGh5c2ljYWwgTEJS
IGlzIHByZWVtcHRlZCBieQ0KPiA+IGd1ZXN0Lg0KPiA+DQo+ID4gVGhlIHJ1bGUgZm9yIG11bHRp
IGV2ZW50cyBzaGFyaW5nIExCUiBpcyBkZWZpbmVkIGluDQo+ID4gX19pbnRlbF9zaGFyZWRfcmVn
X2dldF9jb25zdHJhaW50cygpLCBidXQgZ3Vlc3QgdkxCUiBldmVudCBza2lwcyB0aGlzDQo+ID4g
ZnVuY3Rpb24sIHNvIGV2ZW4gaWYgaG9zdCBoYXMgcGVyIGNwdSBwaW5uZWQgTEJSIGV2ZW50LCBn
dWVzdCB2TEJSDQo+ID4gZXZlbnQgY291bGQgZ2V0IGNvbnN0cmFpbnRzIHN1Y2Nlc3NmdWxseSBh
bmQgbWFrZSB2bGJyX2V4Y2x1ZGVfaG9zdA0KPiA+IHJldHVybnMgdHJ1ZSwgZmluYWxseSBob3N0
IGNvdWxkbid0IGVuYWJsZSBMQlIgaW4gaW50ZWxfcG11X2xicl9lbmFibGVfYWxsKCkuDQo+IA0K
PiBBbHRob3VnaCBpdCBnb2VzIGFnYWluc3QgdGhlICJwZXIgY3B1IHBpbm5lZCBMQlIgZXZlbnQi
IHByaW9yaXR5IGV4cGVjdGF0aW9uLCB0aGUNCj4gb3JkZXIgaXMgaW50ZW50aW9uYWxseSBzcGVj
aWZpZWQuIEZvciB0d28gcmVhc29uczoNCj4gDQo+IC0gdmxiciB1c2VzIHRoZSBmYWtlIGV2ZW50
IG1lY2hhbmlzbSBpbiBpdHMgaW1wbGVtZW50YXRpb24sIGEgcHJlc2VuY2Ugc2ltaWxhciB0bw0K
PiAgICBCVFMgZXZlbnQsIHRodXMgdGhlIHF1ZXN0aW9uIGhlcmUgaXMgd2hldGhlciB3ZSBjYW4g
Z2V0IHRoZSBwZXIgY3B1IHBpbm5lZA0KPiBCVFMNCj4gICAgZXZlbnQgdG8gd29yayBhcyBleHBl
Y3RlZDsNCj4gDQo+IC0gdGhpcyBjaGFuZ2Ugc2hvdWxkIG5vdCBiZSBhcHBsaWVkIGZpcnN0IGJl
Zm9yZSBLVk0gaGFzIGRvbmUgYSBnb29kIGpvYg0KPiAgICBvZiBtYWtpbmcgZ3Vlc3QgbGJyIGFu
ZCBvdGhlciBsYnIgZXZlbnRzIGNvZXhpc3QgY29ycmVjdGx5Ow0KPiANCj4gSW4gdHJlYXRpbmcg
dmxiciBldmVudCBhcyBhbiBvcmRpbmFyeSBwZXJmX2V2ZW50IGJlaGluZCBhIGd1ZXN0IGNvdW50
ZXIgdGhhdCBpcw0KPiBleHBlY3RlZCB0byBjb21wbHkgZXF1YWxseSB3aXRoIHRoZSBzY2hlZHVs
aW5nIHJ1bGVzIG9mIGhvc3QgcGVyZiwgdGhlIGZpcnN0IHRoaW5nDQo+IHdlIG5lZWQgdG8gYWRk
cmVzcyBpcyBob3cgYSBndWVzdCBjb3VudGVyIHNob3VsZCBjb250aW51ZSB0byBmdW5jdGlvbiBk
dXJpbmcNCj4gdGhlIHRpbWUgd2hlbiB0aGUgYmFja2VuZCBldmVudCBpcyBwcmVlbXB0ZWQgYnkg
YSBoaWdoZXIgcHJpb3JpdHkgb25lLg0KQm90aCBhcmNoIHZQTVUgYW5kIHZMQlIgaGF2ZSBzdWNo
IGlzc3VlLCB0aGlzIGlzIHZQTVUgYXJjaCBnYXAsIHlvdSBkaXNjdXNzZWQgdGhpcyBpbiB0aGUg
cGFzdDogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC84MTBjMzE0OC0xNzkxLWRlNTctMjdj
MC1kMWFjNWVkMzVmYjhAZ21haWwuY29tLw0KdGhpcyBuZWVkcyBwZXJmIGFuZCBrdm0gY29vcmRp
bmF0ZS4NCjEpIEluIG9yZGVyIHRvIGxldCBndWVzdCBnZXQgY29ycmVjdCBkYXRhLCBndWVzdCBw
ZXJmIGV2ZW50IGNvdWxkIGhhdmUgaGlnaGVyIHByaW9yaXR5IGFuZCBjb3VsZCBub3QgYmUgcHJl
ZW1wdGVkIGJ5IGhvc3QsIG9yIHBhc3N0aHJvdWdoL3Jlc2VydmVkIHNvbWUgY291bnRlciBpbnRv
IGd1ZXN0LiBUaGlzIGlzIHNpbWlsYXIgYXMgImd1ZXN0LW9ubHkgbGJyIHVzZSIgaW4gU0RNLiBC
dXQgdGhpcyBtYWtlIGhvc3QgcGVyZiBjb21wcm9taXNlZC4gDQoyKSBndWVzdCBwZXJmIGV2ZW50
IGlzIGFuIG9yZGluYXJ5IHBlcmZfZXZlbnQuIExpa2UgZXZlbnQgcHJlZW1wdGlvbiBvbiBob3N0
LCB3aGVuIGFuIGV2ZW50IGlzIHByZWVtcHRlZCwgdGhpcyBldmVudCBpcyBzdG9wcGVkIGFuZCBw
ZXJmIHN0b3AgdGhpcyBldmVudCdzIHRvdGFsX3RpbWVfcnVubmluZywgZmluYWxseSBwZXJmIGNh
bGN1bGF0ZXMgdGhlIGV2ZW50IGNvdW50ZXIgbGlrZSBtdWx0aXBsZXggYW4gZXZlbnQsIHRoZW4g
dGhlIGV2ZW50IGNvdW50IGlzIGFuIGVzdGltYXRlZCB2YWx1ZS4gQnV0IHBlcmYgY291bGRuJ3Qg
bm90aWZ5IHRoZSBiYWNrZW5kIGNvdW50ZXIgc3RvcHBlZCBpbnRvIGd1ZXN0LCBhbmQgbGV0IGd1
ZXN0IHBlcmYgbm90aWNlIGl0cyBldmVudCBoYXMgc3RvcHBlZC4gSGVyZSB0d28gbmV3IGludGVy
ZmFjZSBhcmUgbmVlZGVkOiAgcGVyZiBub3RpZnkga3ZtIHRoYXQgZ3Vlc3QgcGVyZiBldmVudCBp
cyBzdG9wcGVkLCBrdm0gbm90aWZ5IGd1ZXN0IHRoYXQgY291bnRlciBpcyBzdG9wcGVkLiANCkFu
eSBzdWdnZXN0aW9uIGFyZSB3ZWxjb21lLg0KDQp0aGFua3MNCj4gDQo+ID4NCj4gPiBUaGlzIGNv
bW1pdCBtb3ZlIGludGVsX3ZsYnJfY29uc3RyYWludHMoKSBiZWhpbmQNCj4gPiBpbnRlbF9zaGFy
ZWRfcmVnc19jb25zdHJhaW50cygpLCBndWVzdCB2TEJSIGV2ZW50IHdpbGwgdXNlIExCUiBhbHNv
DQo+ID4gYW5kIGl0IHNob3VsZCBnZXQgTEJSIHJlc291cmNlIHRocm91Z2ggaW50ZWxfc2hhcmVk
X3JlZ3NfY29uc3RyYWludHMoKS4NCj4gPg0KPiA+IEZpeGVzOiAwOTdlNDMxMWNkYTkgKCJwZXJm
L3g4NjogQWRkIGNvbnN0cmFpbnQgdG8gY3JlYXRlIGd1ZXN0IExCUg0KPiA+IGV2ZW50IHdpdGhv
dXQgaHcgY291bnRlciIpDQo+ID4gU2lnbmVkLW9mZi1ieTogWGlvbmcgWmhhbmcgPHhpb25nLnku
emhhbmdAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYvZXZlbnRzL2ludGVsL2Nv
cmUuYyB8IDYgKysrLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2V2ZW50cy9pbnRl
bC9jb3JlLmMNCj4gPiBiL2FyY2gveDg2L2V2ZW50cy9pbnRlbC9jb3JlLmMgaW5kZXggNmZkM2Nk
OTdhNmFjLi4yZTI3YTY5ZTk3MjUgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvZXZlbnRzL2lu
dGVsL2NvcmUuYw0KPiA+ICsrKyBiL2FyY2gveDg2L2V2ZW50cy9pbnRlbC9jb3JlLmMNCj4gPiBA
QCAtMzM0NywxNSArMzM0NywxNSBAQCBfX2ludGVsX2dldF9ldmVudF9jb25zdHJhaW50cyhzdHJ1
Y3QNCj4gY3B1X2h3X2V2ZW50cyAqY3B1YywgaW50IGlkeCwNCj4gPiAgIHsNCj4gPiAgIAlzdHJ1
Y3QgZXZlbnRfY29uc3RyYWludCAqYzsNCj4gPg0KPiA+IC0JYyA9IGludGVsX3ZsYnJfY29uc3Ry
YWludHMoZXZlbnQpOw0KPiA+ICsJYyA9IGludGVsX2J0c19jb25zdHJhaW50cyhldmVudCk7DQo+
ID4gICAJaWYgKGMpDQo+ID4gICAJCXJldHVybiBjOw0KPiA+DQo+ID4gLQljID0gaW50ZWxfYnRz
X2NvbnN0cmFpbnRzKGV2ZW50KTsNCj4gPiArCWMgPSBpbnRlbF9zaGFyZWRfcmVnc19jb25zdHJh
aW50cyhjcHVjLCBldmVudCk7DQo+ID4gICAJaWYgKGMpDQo+ID4gICAJCXJldHVybiBjOw0KPiA+
DQo+ID4gLQljID0gaW50ZWxfc2hhcmVkX3JlZ3NfY29uc3RyYWludHMoY3B1YywgZXZlbnQpOw0K
PiA+ICsJYyA9IGludGVsX3ZsYnJfY29uc3RyYWludHMoZXZlbnQpOw0KPiA+ICAgCWlmIChjKQ0K
PiA+ICAgCQlyZXR1cm4gYzsNCj4gPg0K
