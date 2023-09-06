Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F4793792
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 10:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbjIFI75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 04:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjIFI74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 04:59:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1444CE6
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 01:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693990793; x=1725526793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MNArWUcfYqLhfSvglGfbGUWIdvduLq+NYLKlh1xr8+Q=;
  b=LRoJ3IjPE/yy+xLzjbjt5Q0BrGbatZ3PN29IjOT5FYrlS7lzfyU6d0CE
   iCJFvIt06b9GSxSxOjVh3Y6AX/0Ew2K5BkGlYaXj7N0jE0H8/yGLKjc2w
   fTqc1v5C5zRaY1cGc/cQeXVbaVHGhrVufUutms35LMCITJdPMn/ynMfIb
   Y1akR9OYyEMDdehcGE2xQNhT4akIXjisXwok0iSIYauSBAw5NzkvSfJDZ
   akLOspeP/QJPRftGoWP7ffLaGuK4nYWxA1nv99v5jhu9VHYsDf8xCga/d
   qWZaSj/lWSy5ciFTyKVuK+TIWdOObPHO9BTA9aNG1wkr017HRgmZyshLU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="375912804"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="375912804"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 01:59:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="811577507"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="811577507"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2023 01:59:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 6 Sep 2023 01:59:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 6 Sep 2023 01:59:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 6 Sep 2023 01:59:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMiK3sh27XZk+kHKVNc0SWJ55DUxcoxQ94Sm8HBoziPKU2XdybPJgP3l6R0DgAROFgrTjlsZFx578c2dob52vhXKFsvcZpeh65doeoNeb48iO0cy8Zjc/DXWWeyPCBP+7u7kDRYezff/dZRHCFnTwEtVLxyafHZ4eLguZdWKzJ/YwLv3WjvMTQItRvzhnNFXOlBlR3ECs8b6nDAEUMpldTVDEx2o9utqB7PqjUMO62qVj0nqR6OCy/EQ5XajYzhS0Xe+HMfpWQiCIs+/PWPQuIj5Bmol3EAjDaDufB9tV63nX7o3T9b/ATq6gwsOEv9bKxDoNvZUbfy13NSeNa1Urg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNArWUcfYqLhfSvglGfbGUWIdvduLq+NYLKlh1xr8+Q=;
 b=YZ2Lw+voCpaB9RJh8Y42U0G8QQhnU1+hQNIgUm4ifMiRoXuHWXpSBfhiFOa619wYZ2Bq2rIrgLJB62VQ+bSNT34iBFma0uTGj+HxhCn/0qSIZfHV26r5llgjOt12CBdggmFTwN1ntsPLvn5E8BkXWV+b6soY/Z0Z/N2CWbZq/5qq/T8sNKI6X6wu34hcNgMm9nlImsZqyWAL8QvmY1PLUgp53i2lgSTY11di0zX3fQHwJ5PCdaQC//q1eCeaN3ER9SDTyj2fxSAzPjVM+O73h6YVfV0CA/bpMqVkR/tSma6loJ5TGG+f6sE/XUDQXE70yWSJpBKPoWl/sIMW3gTAXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13)
 by DS0PR11MB7877.namprd11.prod.outlook.com (2603:10b6:8:f4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.34; Wed, 6 Sep 2023 08:59:44 +0000
Received: from PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::111f:fc49:2538:b5ad]) by PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::111f:fc49:2538:b5ad%6]) with mapi id 15.20.6745.034; Wed, 6 Sep 2023
 08:59:43 +0000
From:   "Mi, Dapeng1" <dapeng1.mi@intel.com>
To:     Jim Mattson <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
CC:     "Xu, Like" <likexu@tencent.com>,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: RE: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
Thread-Topic: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
Thread-Index: AQHZ3QYmPmxiAhADqkmhg7D+w8uocLANhd8Q
Date:   Wed, 6 Sep 2023 08:59:43 +0000
Message-ID: <PH0PR11MB4824FFA9AD74719B8A3BB809CDEFA@PH0PR11MB4824.namprd11.prod.outlook.com>
References: <20230901185646.2823254-1-jmattson@google.com>
 <20230901185646.2823254-2-jmattson@google.com>
In-Reply-To: <20230901185646.2823254-2-jmattson@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB4824:EE_|DS0PR11MB7877:EE_
x-ms-office365-filtering-correlation-id: be82a1fc-ee3a-4445-9f51-08dbaeb79ccf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQXgBsgIS71n1ITdgzRT+JTteWJE/1MkWdgQAU6yVuFHRg88An7DO2YOLxAE4AjxtiZtXXdWBsFnpPtBekr3ZmL2b7qVe47thNrrS52n/khTUNWdGD4Rnzyi5Fowg9nUHkycIOA1bU5iPfPJrw4qAouJTGMUPLQrCstt1jByCfdiDidtIPe+pkp343NFZ8qkspfzRKyPHYMllYURK5mtO6mH/U9WDQoH3ashYjlitsczFKMEpPKevKefLPXqxaGhO8Pea4h8xOvB3dp2e3ckl/w01mqE/bAOZJ+qBQAIy37WdZeiGf6m3uADmBi6ctXn/XhqE1DjiFxYXzm0hBzd3E+ukO2sABojgkJ17fYMsSm/qd1eLhFIb1GCEOMmGK5YNOz/84OtOGYVNRWZHILyQiDMc8xoVr4ESyxePCB0DHGokEeoL0Cy6EdkNcDaeMfBUS0R9aoNBADAAyqr+x8y3RnvxCYSEgucKtEpcpQMFAWdWGzKRgLJ+4Z9Omeltjj8EHTlMmV84H/3cjUuSxpR9mrUSvsZMr64OeZQ4FeIBi6xKprV2J4LMvFk4LHe22Iudjz5Zkl50WqbBpK8CXpVajoulYrnZMFmcgRWsthFf2ZkWkTKNPAlL2ZGSekTXNe8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(366004)(136003)(396003)(1800799009)(186009)(451199024)(82960400001)(122000001)(38100700002)(38070700005)(26005)(107886003)(7696005)(6506007)(53546011)(9686003)(55016003)(83380400001)(478600001)(4326008)(8676002)(8936002)(66946007)(66556008)(76116006)(110136005)(5660300002)(66476007)(66446008)(33656002)(64756008)(52536014)(54906003)(86362001)(316002)(71200400001)(2906002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnoyU01qdE4rQkwrWWZONEg0eUU4UXpGdmwwaWlKVTJyS1ZlaURrVkc0THFs?=
 =?utf-8?B?L0tTMlRpWVZGZkdTVEVXUk41bWtlSXVyczVYdGdCQWRQbktoZ2RQSWR2cEFw?=
 =?utf-8?B?Q09MWG9qSDRCYmM4U1o3WElvMFpvcVpTdlR5RCt3eWJsdThQcUVhSjROSFRo?=
 =?utf-8?B?RXY3RzZ5OWNVa1ZhRzJwY3BYNDFTd3VsdUxvMUNaRTFjdENhVEtuTzdPNExt?=
 =?utf-8?B?OUxja1VtSjQvTVJha0RlSVRUY1ZNckhDb2lCS2E4OFFMVmZ5Y0l3SjY1Nlkz?=
 =?utf-8?B?NEROS2tjUVlha0FMbEhIcDZIM1pPVEphOXM1eVFhVkNsdnpXVjVDZGhTTjdY?=
 =?utf-8?B?TnlVQXFZazBETWNMZ3dvTU5hS1IrNHZMS25QRVV4S3NWVUI0Zy9vZUp6bHlX?=
 =?utf-8?B?QWQxdzZiNXlKMnFldnFtSU5tbncyR3EzYUpJRUVBODVhWkM4a2JTODAvdnpi?=
 =?utf-8?B?UWt0clMydDZ3RVdvVGdXeG1VVzFxNk16TWVFQkJOSVlRY0w1VXAxSEJoNm1Z?=
 =?utf-8?B?ckRUa1dVRDM2dFk4dzJCTy9iSTBXWUk0U2V6Y0pocytLK0FtL1JrRE5jWThp?=
 =?utf-8?B?enZ6VGJ1TG9KUW5sS1Z2TlJmQmtrWjlBeWk4dVhQM0Raa3pVcCt4RC9CZGpI?=
 =?utf-8?B?SmM1cnJCN0lOVGdJdHlvYmNGdlUzV01qei8wUEd1Lzd2K01TYy9oQU5oZVho?=
 =?utf-8?B?OExvQXQ1UG5RZDNmU0NWbCtpNzlMSmlPaHZLVFRqcjlobC9jY2l1K1k3U1Nl?=
 =?utf-8?B?VVhuTlNjTXV4eDlnSnAxdHFkWmg5a0ljU1QxM3o5ZlFCeU1RZXFUcWxzRjd1?=
 =?utf-8?B?NEZuOUNrTncyZ2sxMC9IekUydjE3Y093UGxDQnl6R1lWSjVFb0Z2TU5aUmpk?=
 =?utf-8?B?SjJqQXlrc2cwa1F2QTV2V01IbThjbEZnZGdHVUZsYUJJcHY2azl4N0lwNDFT?=
 =?utf-8?B?ZjdNbThCZld2RzRWVTN3OThjRnBTY29QTjN5bE1DempWQWtNbXg1aFlwTUd6?=
 =?utf-8?B?OXBoMi9hT2ZhWWkxc0xURGRoZzJTUU9zZDRBMjJWV0xKSnh4N2VDbTFDd1pm?=
 =?utf-8?B?Wk9IeEZYZUlIWHQ5SDBVaStYNmFUdWlCb3EzcDhFN2RxUjRGQzEyZ21Dd3Qy?=
 =?utf-8?B?UjhoNXcvV20wamZveHJ6QXhwOEZOV09hTFJPVFA1bGFEQk9GcjMxY21PM2tD?=
 =?utf-8?B?VFNSemtYS094Q1pRSFpBc0F1UlZxc2J4REEwU1NqdGMzVFJQei9uK1FBT01o?=
 =?utf-8?B?OGZpcHY3RVpDRTZTK1lvTCtacmppcHB3MlZqYVdubTFrRzcxYldiMEJiKzQx?=
 =?utf-8?B?dGdlQlJUdkhrMldPZUszM1o5TkpZN3pwTktySnUyU2FkeS9QOEw5MWoxQkVp?=
 =?utf-8?B?WjZ4LzRvQW9GNGtUMkE0MkZiYlBCVGdEdk5GVi96STZQdmFJSXhzcXhTTmhO?=
 =?utf-8?B?b09ENDdhYkxwU0NnbDFXOERocmZSaFUwSU1RWFhOSlBHNDJ0UVJtNG9rRFA1?=
 =?utf-8?B?cERJc1BCK2FUL0s0VGo4NmNFODhMMGZPU2hqTlp1NXgwaFRkQVdDVVZPQ2Nl?=
 =?utf-8?B?YUJSZkVBN3lJc2tXN0VIZlluY1ZNdnpJK3lSTDRPYjJJbDk5cFV6UUJmTVhv?=
 =?utf-8?B?N1hKa211dFhaZE1KQmxPRTIxUzhPOHBNeFVJZDFpSHdQQXBtSGtFOWpmYVpF?=
 =?utf-8?B?V05uVURITGNpVytwWC8yMGtFYk05TTcwZG43SFpuTlZuVFFMSzFpWUZqeGtp?=
 =?utf-8?B?QTVCSVpOeE1ZZFhuN2J2SVpESk83VU04NFl5K3M4SzRxYXFBYVdmNXNDaXVT?=
 =?utf-8?B?MTU5STZ1REFCakJPeXR2YnhzRis5UFpJUk1tN3JZZVJkb1JvVElZSFFkcFhU?=
 =?utf-8?B?Q2pQaEdHMnl2S1l4Z21PQ3hTQUtvV0J0T2VuUStaaFZjZUJ2ZXhuMXVMeW4w?=
 =?utf-8?B?ZXFSbFY5UEExQ1RVL3d6KzlNNldWQ3hqUloveXVGRjJpaVNmdWgyNGxlenpn?=
 =?utf-8?B?NlRhSHJIUml4cUhDY3NjRDRwei93MnRvRnBUeTUvYXpxRnB5YWxXV052NkRh?=
 =?utf-8?B?NWM1UkZQVWVFaUZWdEdtRmI4eDFtZ0xpNWFPNFpOZGZqclNmMmF5bm8wVkdz?=
 =?utf-8?Q?lel2v0khuTahS9J7RbsDCGPWL?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be82a1fc-ee3a-4445-9f51-08dbaeb79ccf
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2023 08:59:43.5641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ntlu+3OMG87BbQem+NkL+rjPGqsiaqFFFxp1UiU2E2f3649JTdhKpxqUF0JBezestCpIGBaOpzMbiS7UqX0hpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7877
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKaW0gTWF0dHNvbiA8am1hdHRz
b25AZ29vZ2xlLmNvbT4NCj4gU2VudDogU2F0dXJkYXksIFNlcHRlbWJlciAyLCAyMDIzIDI6NTcg
QU0NCj4gVG86IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IENocmlzdG9waGVyc29uLCwgU2VhbiA8c2Vh
bmpjQGdvb2dsZS5jb20+OyBQYW9sbw0KPiBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0K
PiBDYzogWHUsIExpa2UgPGxpa2V4dUB0ZW5jZW50LmNvbT47IE1pbmd3ZWkgWmhhbmcgPG1pemhh
bmdAZ29vZ2xlLmNvbT47DQo+IFJvbWFuIEthZ2FuIDxya2FnYW5AYW1hem9uLmRlPjsgTGlhbmcs
IEthbiA8a2FuLmxpYW5nQGludGVsLmNvbT47IE1pLA0KPiBEYXBlbmcxIDxkYXBlbmcxLm1pQGlu
dGVsLmNvbT47IEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBb
UEFUQ0ggMi8yXSBLVk06IHg4NjogTWFzayBMVlRQQyB3aGVuIGhhbmRsaW5nIGEgUE1JDQo+IA0K
PiBQZXIgdGhlIFNETSwgIldoZW4gdGhlIGxvY2FsIEFQSUMgaGFuZGxlcyBhIHBlcmZvcm1hbmNl
LW1vbml0b3JpbmcgY291bnRlcnMNCj4gaW50ZXJydXB0LCBpdCBhdXRvbWF0aWNhbGx5IHNldHMg
dGhlIG1hc2sgZmxhZyBpbiB0aGUgTFZUIHBlcmZvcm1hbmNlIGNvdW50ZXINCj4gcmVnaXN0ZXIu
Ig0KPiANCj4gQWRkIHRoaXMgYmVoYXZpb3IgdG8gS1ZNJ3MgbG9jYWwgQVBJQyBlbXVsYXRpb24s
IHRvIHJlZHVjZSB0aGUgaW5jaWRlbmNlIG9mDQo+ICJkYXplZCBhbmQgY29uZnVzZWQiIHNwdXJp
b3VzIE5NSSB3YXJuaW5ncyBpbiBMaW51eCBndWVzdHMgKGF0IGxlYXN0LCB0aG9zZSB0aGF0DQo+
IHVzZSBhIFBNSSBoYW5kbGVyIHdpdGggImxhdGVfYWNrIikuDQo+IA0KPiBGaXhlczogMjM5MzBm
OTUyMWM5ICgiS1ZNOiB4ODY6IEVuYWJsZSBOTUkgV2F0Y2hkb2cgdmlhIGluLWtlcm5lbCBQSVQg
c291cmNlIikNCj4gU2lnbmVkLW9mZi1ieTogSmltIE1hdHRzb24gPGptYXR0c29uQGdvb2dsZS5j
b20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL2xhcGljLmMgfCAyICsrDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2xh
cGljLmMgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBpbmRleA0KPiBhOTgzYTE2MTYzYjEuLjFhNzll
YzU0YWUxZSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL2xhcGljLmMNCj4gKysrIGIvYXJj
aC94ODYva3ZtL2xhcGljLmMNCj4gQEAgLTI3NDMsNiArMjc0Myw4IEBAIGludCBrdm1fYXBpY19s
b2NhbF9kZWxpdmVyKHN0cnVjdCBrdm1fbGFwaWMgKmFwaWMsIGludA0KPiBsdnRfdHlwZSkNCj4g
IAkJdmVjdG9yID0gcmVnICYgQVBJQ19WRUNUT1JfTUFTSzsNCj4gIAkJbW9kZSA9IHJlZyAmIEFQ
SUNfTU9ERV9NQVNLOw0KPiAgCQl0cmlnX21vZGUgPSByZWcgJiBBUElDX0xWVF9MRVZFTF9UUklH
R0VSOw0KPiArCQlpZiAobHZ0X3R5cGUgPT0gQVBJQ19MVlRQQykNCj4gKwkJCWt2bV9sYXBpY19z
ZXRfcmVnKGFwaWMsIGx2dF90eXBlLCByZWcgfA0KPiBBUElDX0xWVF9NQVNLRUQpOw0KDQpSZXZp
ZXdlZC1ieTogRGFwZW5nIE1pIDxkYXBlbmcxLm1pQGxpbnV4LmludGVsLmNvbT4NCg0KPiAgCQly
ZXR1cm4gX19hcGljX2FjY2VwdF9pcnEoYXBpYywgbW9kZSwgdmVjdG9yLCAxLCB0cmlnX21vZGUs
DQo+ICAJCQkJCU5VTEwpOw0KPiAgCX0NCj4gLS0NCj4gMi40Mi4wLjI4My5nMmQ5NmQ0MjBkMy1n
b29nDQoNCg==
