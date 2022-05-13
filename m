Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007EF525E85
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 11:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378941AbiEMJLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378952AbiEMJLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:11:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FAA2716C
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 02:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652433066; x=1683969066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m0ZOnyXcMO45+pJlP1xjngj1TN7mnb77bhZI623LQyM=;
  b=DsQxrb4baULvSuIVyxL0zOYAybcDoggUNfVjEcSCPiOiY2GnC/9NsVin
   +rFT44CMbm3uCDXh5uqg8l94POPKH2IhHvXGdfA84pIt5Xq6k87sk4C+H
   9IA+MWrNseQMvRYFM1GeiuK+9zKlbkk0reFyi9703+rBr+UEBMucPIV5b
   ZRv3NCyoQD8yj8f7na50DDukwO0LA4/0Cjfh0rrDMd9DepEnvOIp1FODE
   NafFxeW0Lcb35bEX8zr7BrDfxSyVKSYaI32K/xfdOkbDJrdQ70LgUmAOP
   caYS/npwqjMVWqd8AGITf4oqKrrRqSeC/P0PbeuBBfqXKqMN6EupXbCwK
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="356687121"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="356687121"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:11:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="595134311"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 13 May 2022 02:11:06 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 02:11:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 13 May 2022 02:11:05 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 13 May 2022 02:11:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ey5nCVHwHWjEolRxDJTdKZrsw5E0VfMAqtr+H52OAmiw4s+Zaqyjiom4VCZhC2SMMkQon9Mm8E8gNA65Xx3FtZQ8EVx6SDcR8sLGFw2sZXZW1QJTYKmiuMgfiTWVees1GsCq0TjB8sS5WtCgfN5jyD+t2omFNZFfxvyXfjk9T7wZEEuQh7damy6cdtpUa5OX5EM5Tu2/z+itIQ7pm1oxyeCHhkUHlDJzbCXRfrh8BDyexec40xauP4YHqwiLEF3N0ZctF/0XmBD8kHYTzm3K/ilrnPK75+2Fd58zVVh66pMv8+t0TSzzQnisDYwEXybOvAAUSNEgyT95+ooPjFvUvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0ZOnyXcMO45+pJlP1xjngj1TN7mnb77bhZI623LQyM=;
 b=il3qPoOeCYkUTM8cXR0CEZyILUxRe8VYRFNFWrBBs39NWp6M2Ko8VfoRQP8rsRbj47X2OMO+zg4p/XI8Js/shnRL9K4wKKrb9oSFl+FrGR7sTz/VHHRkKuz576aRxKiuwEwBwMg2W4s3NTrxdCaCh6OERoENPw9MZQkk8lSQskcjjbsKRjaO4359Ap0aEguWylrypPoI/I/mfVOP63kPKsR5LPTInFb1Z5cCMRfJOHNlwk3lZRs3fdh/HtSvdOlFvB/L+PEQycZD4C9BWPTrCZDtX/ijn1NRKrzik0kKvFf0w0tPUCIqaYS2StlvyxoqayljUkobDUMUgmsHBchBDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW5PR11MB5809.namprd11.prod.outlook.com (2603:10b6:303:197::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 09:10:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5250.013; Fri, 13 May 2022
 09:10:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH 2/6] vfio: Change struct vfio_group::opened from an atomic
 to bool
Thread-Topic: [PATCH 2/6] vfio: Change struct vfio_group::opened from an
 atomic to bool
Thread-Index: AQHYYN/b98DKy6iW6UKTXoOAfFmyuK0ckD0A
Date:   Fri, 13 May 2022 09:10:58 +0000
Message-ID: <BN9PR11MB5276C8089D066673235B8F8C8CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <2-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <2-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10ada009-7863-4b84-49f4-08da34c07e51
x-ms-traffictypediagnostic: MW5PR11MB5809:EE_
x-microsoft-antispam-prvs: <MW5PR11MB5809F3F84D5A901D5699530B8CCA9@MW5PR11MB5809.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DIuAYVT+vdh/xlwBeRvLaxjgIz7b7LGE6fk9u2O1if5nzW4srdZiRdXkvdBXqE+OnZKQoj4whgCl8MlqUFbFWKfiKUJ8Tiz2nkC4B2fTlcQV5xgo3vj5iVCdvZUP47x8R6G8y/DlAzX7ej60UxVEevJoC0Kf10ngR7buKrUxprVqNo0leWVyjClEVffrFXjCfrLUm8ZXpa63GzQWHJL2oUc0GKA+OhZiVYeNYljddtNVM1B0PLYUQlSR2pZ4ikCZoDU2YGggtrTjzQX1Og29xrOZaJ8McwrMR6vII76o1DUXrdxyuMGUBo46XCPTV2uK5mnejz1cAzRxXVnhLY9osxKjyewJTB6oPNGlNUz84LxQYWUjHd9pCV2ETfD/155WggpEhbN9LdT8M2uNYor6XNIpZmkEDhrCO7IM8lrDsgzxE3Np/UznY8bVO81jN414wyaxaL4i9DSXu7stAig6l/6YazoWIdhZw0dnh4YDhxMBvVSb6oH7AQ8it+CkheB/+Hu9NKbF8DJDSjQ5uaiL/olQQyiXp9zoZtzQDlwrc9KedJO5KPhbmSf7Y+WtU345Gu/yqBBdkgy8Fn+1NgQSaG9Y1qlxA5vVJEdlU3DGhs+qMn8wRCvYhFMpdbnujLIv5OSWl+dFxvJKxkuMc9VCwWqfzBVjYpb8r7oqfgyiVAONpSpIIKteo0pq59qRnUHAwiDSXPIwEPGmQnmjr3m0xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(122000001)(38100700002)(8936002)(71200400001)(7696005)(5660300002)(86362001)(82960400001)(110136005)(66476007)(6506007)(9686003)(316002)(76116006)(66556008)(64756008)(54906003)(66446008)(66946007)(4326008)(8676002)(52536014)(38070700005)(33656002)(186003)(55016003)(4744005)(2906002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1BYdHl3VjExeHIvTDZmOTVVOHVCb3hGVzUvdTdEYmxKUGNlMU9qZlBCSWNz?=
 =?utf-8?B?T0xQcGs2M25xdmlIOHpKckN6ZlVOWG1pVGlNUUl0TFhmZGpQamVqYlo0ODlP?=
 =?utf-8?B?U2hKczFyTk1tWG9EOGdCenVrYmg0TGVXQ3NRYWhlS0wrY203Vk5BcElQalc3?=
 =?utf-8?B?Ym9TN0hTdSsvRHRWZjZSVnVtZXh0WGlUbzB2SFc5NUxEUlhkbWZCbDE5V1NU?=
 =?utf-8?B?QVFhOVZEcitwZ2NHOUJmMThyeG1DWGg0cjRuNWxSckpRdWh0c24wRnowMERj?=
 =?utf-8?B?WDJ6ZHdjV0F4aXFCUHZjaXlqNE54bkk0TmI3SnZqRU1PbnRDZkxLV0kxLzFx?=
 =?utf-8?B?cW03ZnZTbWg1WEpCVjlsQlBOMWNmdDlyWllFVEtRV3RWQ3FhakhlUE9tWWkw?=
 =?utf-8?B?akRhb3RYVDZ3bGtLbDl5M0cxaUhadm9qN1ZYMHV1R2p0aEZXVzZ1ZGdGaEty?=
 =?utf-8?B?S1FLUk5uWUNmSlA1c3FLVS9CNWZBSS9TMlVPKzl6OERuZi9nSExuUG5Jb3Ju?=
 =?utf-8?B?YkhpUENCNFR3UU4yNUxCRlAvOUE4Z2dhSHl6VWpXd01PZVFlaHJZZnZDeXBF?=
 =?utf-8?B?K1RwYThRSkRLd2swQjVNWGkvTjUvK0RNZVl0SENkclRTanRCay81anhuSzZN?=
 =?utf-8?B?eHFOaUxHZDJUQUNPVnFRSmNJWVQrMEpXZDVBYWI2Sng2Y3lOQVVUQXBHVDBI?=
 =?utf-8?B?bVFIdllsdWN1Vmx5ZEdpeC83WXRLSU5QUVFoZVhJdFY0eTlMSGxwWGZXUmdH?=
 =?utf-8?B?bEpEOEFBU0FkYW9tNkJrRUtBVnZxNnZxeDZsZU1LL25XbTdqSWcvTEJ0TFpT?=
 =?utf-8?B?dzVkWGtYYmcxeWxYTHhMMlZhcnpKN0FLNUp6MkY4TFlta1ppRmJZQUpFL2xV?=
 =?utf-8?B?ZVpLSTFlV0p3QisybkpGekF0S0ZKU2NjNEpWOVJUNk50RGExREdPbGFUS1RG?=
 =?utf-8?B?aCt0MmVPZXI3ZnE2c1orR0V4bGN0UmxRQzZ5RkdxWUlUQTFhZGgzaklsd3p6?=
 =?utf-8?B?emhIbmxyR0xHaDFuU2VCV01DVzZna2dtdW4ycUs1NzE1c3lVdGJKRGV0QkJr?=
 =?utf-8?B?RDJnTGM0ZmQxWUxpdnF0OFVBdExLSHZnV1hUVHp1NlNoaGxSZWNkYjJIZG5E?=
 =?utf-8?B?YkdiaUV5VHhpWEZ6T1UwY3FHaE12L1MxRk4yN2hCZWUvTm5SWUhUbCs5U2gx?=
 =?utf-8?B?NDQ1ZW8zVjNCYlkyRXFxbi8zbWlERmJFcjRMSEhOcjc4TzliRzhIb1FVUFc4?=
 =?utf-8?B?UHNrSy9scjBvY2psdUhRZmlBai9NQ2NYdytTRTlPdksyVXNsYmhFZlIyMFNY?=
 =?utf-8?B?UlRZaGNmTUg4MHZzeWtxRjQ1M2dCMjhpTHZ1L1VTTW5tRERGU3F6MUVHbTF6?=
 =?utf-8?B?elI1UG9WMDMxNUhOd2JEOVpRbVBoMjhwZGN6S2x6cFZZU1F6YXo1bjJiNExF?=
 =?utf-8?B?UnZzUlBDZnZIdnIrZW9STlpiem5nVnR3Mk5oaFN3bHZzVUppaGw3RjE4aGpY?=
 =?utf-8?B?WmYzWTFWQksxMTdqcS9yOHphaGdTL3RaMkU2R1JEYnd0MnhhQmNWUEJRamFn?=
 =?utf-8?B?K2xJTmh2ZHZvOUR6WS9wUnNwSEIzZTcyd3NKaEdBejBzRkNEWE92dFFhN1Vl?=
 =?utf-8?B?c0Rpa0RZZVBBTWpscUdJQlQ2bGxKNlcyeU1vWnlzU3JNaVZvQk04dGkwWWRO?=
 =?utf-8?B?dTN1bU04S3ZGUFRHa2RlZ3M3QkNyODRsMGhaMmVFbDZWblEydzJTWVozL3RN?=
 =?utf-8?B?bjdGYTd3a09pdG5mU0lFaVNyaTV5dGFpUUdHMi9LQmxIV2djUWtYQW5zbith?=
 =?utf-8?B?NFFuNUtHby9Kd3hveGdUZ251R3JpWWJSVk5Va1VuTEo4QjdqY2JYclpXWXBJ?=
 =?utf-8?B?bkNJV0x3UWtYV29Gc1gxY0NhcTV0OFNuVU1oemNIYjhmdGEzOEFNaWdzME1r?=
 =?utf-8?B?VDE0c1ZjaUVmak9DbWYwMnQ0ejNtN3pQWDAxTTRIL3BxY0JTU3VWNXh3WSsw?=
 =?utf-8?B?YXFPRnE3Wi95RTB3VURIcnEwUEwzUEZXbytBQTVhUTQxUkhwamlldy9OVnNC?=
 =?utf-8?B?YmNXUTYvSXlLWTl2Tm4vMFRnZVM0VVg2VVh1VDR5dVR3cEdqbnlsVkEvdHNS?=
 =?utf-8?B?UDdLay9GMTF5U3dONWFNeW45K1FjQnZIQUJNNWFuSkRBcmZwSDZ6dnJJNXZJ?=
 =?utf-8?B?VlU0Z0ZydE5UNHlDeS80VDJkZENXQTJJTEFIY2djcXJ4YUhNR3RhWjRibjdl?=
 =?utf-8?B?WG9HREt5R2I5RDhzdUxKNG9VbUUwRkRmVkdCVXRJS21ra1VzazR0QXJOWTVE?=
 =?utf-8?B?NE9hcnRHRHRyV2NQWHJlUUdiYmprU0lFTDBtSVozSkJJNElMaWF3dz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ada009-7863-4b84-49f4-08da34c07e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 09:10:58.3655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d4Pjf2qm6OHqv7Y6tZ97bb93DdW/zjoAgcQl+3oM5hLINKr0y0BTex0y6OFFbssbMuFqUJQfwQKO20kg2NfjYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5809
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IE1heSA2LCAyMDIyIDg6MjUgQU0NCj4gDQo+IFRoaXMgaXMgbm90IGEgcGVyZm9ybWFuY2UgcGF0
aCwganVzdCB1c2UgdGhlIGdyb3VwX3J3c2VtIHRvIHByb3RlY3QgdGhlDQo+IHZhbHVlLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCg0KUmV2
aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KDQo+ICsJLyoNCj4g
KwkgKiBEbyB3ZSBuZWVkIG11bHRpcGxlIGluc3RhbmNlcyBvZiB0aGUgZ3JvdXAgb3Blbj8gIFNl
ZW1zIG5vdC4NCj4gKwkgKiBJcyBzb21ldGhpbmcgc3RpbGwgaW4gdXNlIGZyb20gYSBwcmV2aW91
cyBvcGVuPw0KPiArCSAqLw0KPiArCWlmIChncm91cC0+b3BlbmVkIHx8IGdyb3VwLT5jb250YWlu
ZXIpIHsNCj4gKwkJcmV0ID0gLUVCVVNZOw0KPiArCQlnb3RvIGVycl9wdXQ7DQo+ICAJfQ0KDQpJ
IHdhcyBhYm91dCB0byBzdWdnZXN0IHRoYXQgcHJvYmFibHkgYWJvdmUgdHdvIGNoZWNrcyBjYW4g
YmUNCnNwbGl0IHNvIGVhY2ggaGFzIGl0cyBvd24gY29tbWVudCwgYnV0IHRoZW4gbm90ZWQgdGhl
IDJuZCBvbmUNCmlzIHNvb24gcmVtb3ZlZCBieSBwYXRjaDA1LiBTbyBpdCdzIGp1c3QgZmluZS4g
8J+Yig0KDQo=
