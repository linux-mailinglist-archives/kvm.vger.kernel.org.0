Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892F86F5CC0
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjECRKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjECRK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:10:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB3276B4;
        Wed,  3 May 2023 10:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683133806; x=1714669806;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=kM7U3oypfTxoNPFBlbiiByQqa7pOk4VcC9QcTQ/hbGc=;
  b=BUrfKv6doBrEqgpPH1tv72XtlNTzo2YwPWzh2hsB6ong7p2MDy/Xm5Jh
   whwdCk08OZzqrTGQsTahCLyLZhi6ghnwUGBs52L93elYYLHJNg/0V4o1b
   FalBY7FF3goi90cJRkMOTHtQM+XBRx6EA0W8Uva3ccBgcoT466w0toWoy
   3W7RiDfSsUb4pZQ39CwPpOZ7iHy+W/Mf+b1I2sGZFMBDADBor1G6tV0XJ
   vyX9vnoGDeO++B9LL/IvupZMTKFoZIH77Xb/mPBInVctf62Q+b3Zh0iyT
   MVpjcmfadbyJiLBGK5rc7NGQwQyIf/HXFr5SzJNaHa7/pD6DB0TtWktlp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="376775796"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="376775796"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 10:07:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="699466088"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="699466088"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 03 May 2023 10:07:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 10:07:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 10:07:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 10:07:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeX538+prVV6et/+73QBVDrG9AxAHihv1rAmezrj3wfzADFWjdLoPIsxg0ZczZjmowbxAWk109WDu2qoo13obf+E1Yj+b9NgiFzEPzNvkZX7QtTjAPtea8+deh+vDKA+xQzVR4tEJh29vLPJvjPERweTLs920GsdcH2dLTE3wVTXnVW3c05I8KaQuADsxDxUt7Qmpewo6F1Mqu2wMIfe++u+jpmCbSMAhxThmAoWh6vuzArkWRVv7E5O/J79z18n8rzN/z/N6Vk9vK8seDP4CjglsWXy/cU1ttLD8eSjeWqNSwjv08+MaBo9dJHris5K8OaAHF+JlXhJYhaBP6vJ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kM7U3oypfTxoNPFBlbiiByQqa7pOk4VcC9QcTQ/hbGc=;
 b=CdhF7a0J3eCX4OnrLmbp2mn4+wq7ITECsZQJzlz2C2T+muxDJ+oMPhoJzEhbQf8Atlt1WIs9QmCHmIT6fMQ1YnV6DSAzDDCyV4c0ax0kraUKfBYIPVJaJZ2E5wbkK+9vejMUh8sK1n6Pa1kt+e4Lm4JwUMM9zuPn6YPDZicEIzac49estSTWrukIOmBJ1NlSSsPq307ZijUBp9jPhbJdLiSH+l1E7576Nh9cYokTKBAslVfaywbh9y+JNuua9Sz47QUkZc4dlxclgsbI2lFEQNoXLuS2s0qJongKfL+CPVdhnxicasyn8rSPR63YVvQ4XNqKaVeQh5FgDtFj1D9eMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5394.namprd11.prod.outlook.com (2603:10b6:610:b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 17:07:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::33bf:d30c:12fd:b7e3]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::33bf:d30c:12fd:b7e3%6]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 17:07:15 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack MSR
 access
Thread-Topic: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack
 MSR access
Thread-Index: AQHZdHFyi6vR/qt18UeCPYYHW6Q6nK9I2oYA
Date:   Wed, 3 May 2023 17:07:15 +0000
Message-ID: <175c826d59f1ac77fa588908d3768ffc2e79268e.camel@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
         <20230421134615.62539-22-weijiang.yang@intel.com>
In-Reply-To: <20230421134615.62539-22-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5394:EE_
x-ms-office365-filtering-correlation-id: 85c9b918-363c-45ad-ad9d-08db4bf8d838
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ELKZDB3JE6qEZJ9mWq/i67+UF2iOYVkOORTyQ2Ydhtl724AJJz7vhsfYakvJiFImS9jB0Ci/LY7DjsEdUeH3aBhXGPm2T+HzfLABlLg/jWA/jU8ZzoeH+Tkab77sa7WUkSFiiM1IWY3RFZynKmvozYpGgeagSTH69EX0W9LXGExWffIN+sQxtnemD2sB1yZc7AhNPgc+pIch+WmzuAU8lic19q6PQljbLKmSDwjH5lPqUrn0w3aCJt4DA/n+lLAxsCn8M05zVz3eztOIDgPhnwYiQhQMYFBrg160u2MedaKgmNnUTzIaTDQtxT9082IYEFcBlQXD+H2LpNUIkA8rHZv36oVb4d/Wv+WQYs/gqX8ln0LELVHzvnNRVcGfZntXRkGKUOpqjAvsfN2tQDl4ckRdQB4ESWu8xtUCwWrn3T86VhCCosESYC+cmU3V/8apa9kqNdI7rJ7j8ve95vUXgyfVMN1CSuNEzr6IA6idchpg8jQ3iOcTElYDeYlL2fdhYeOxuZH9Q25Yc7Nem4v9GNAFB7y6Du1E2dzk9IO2ZYwp9MsjvLSEnHgjIc4heBbDuO4RzT1/EaHqoORz8CG61Cfs+QPGMeQv5WWDvxmnvY0XT/qkjrpaLTqW3CFqgvTM2mlLIDbG3cXFSFYt5gSxfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199021)(36756003)(86362001)(91956017)(110136005)(316002)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(6486002)(478600001)(71200400001)(41300700001)(5660300002)(8676002)(8936002)(2906002)(4744005)(38100700002)(38070700005)(82960400001)(122000001)(921005)(186003)(26005)(6506007)(6512007)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVIzanJWYnJtRFA2azlQZUFEdmpKd01ZTm9xSi9VMWFIOGEwMVo0S09sUmNa?=
 =?utf-8?B?cG5peXZYQ2VsYnFjelBpRnZrTGNxWDQ2WFdsNHJDTU9xeDQ3a2VaaUxhL1Ax?=
 =?utf-8?B?QmZ3d0twclJ5UDhZMElxRks0WWRNOTZJZzVTUnpoUzJPNExsazlSTktpUUt1?=
 =?utf-8?B?TTNtU0FKOWxCRmlNY0ovN3ZDUWNaR2FhcVIvbEliMWhPbDRuMGZUOWlCQW9r?=
 =?utf-8?B?QnRaTG9YT2duVDB0Zkl1UHRvSC95a0xlZmp2MlRadTIwbXF6ODRBSjloNCto?=
 =?utf-8?B?dkIwZ3ZiQ000WjNjdFNMaU80bHhsM3YxNGpNT3ovTmVFL0krVHQxRGhoTGRM?=
 =?utf-8?B?Q0VqSWk3UitlWDNCT1B3Q09IcHlUc0FPVGYyMU5sUmxaNWhiR25yTUZtb29j?=
 =?utf-8?B?VmFSMVo0VWtha3VnVGt4Rnh6bDN6UjFZTjlUZDdRQjVadXNkZEtPU0xHQ09S?=
 =?utf-8?B?WGlWNjNUMTlWNzhnTm5ydW9EZzZOeGJ1YlVpTWdXemczRFhoTkNuZVFHZ2N4?=
 =?utf-8?B?amdMVzdYNk96MmFWS3dJL0lkZWtPOUgrcmpVR1N0Z3pGNEgwVi82bjFxdThH?=
 =?utf-8?B?am1oakRqU0ZldFFsQ0dBUDZtMzcrU1o4VFZtUlhrOXFQVjY2ZTJhQkZ2WXpv?=
 =?utf-8?B?WEZhSFlMUG4reXFwY2RZUm9lbjVOSWFjUVpLTmcvZHQ5OVNzMk5aS2ZYUjVJ?=
 =?utf-8?B?QVZ6dGhaRzRIbFBnODRYR3p3RWNleER0LzNMQWo3am9QTC9IcHhUN0M5OHVr?=
 =?utf-8?B?TzRvaU9uUVl3WnRYOWdQTGpYZHc0SjdpWlN6WXRLSmRlaWwrVi9tWnZtRml5?=
 =?utf-8?B?SHVnRE0rSXpaclhkOUNJaTFGVjhKMlR6SjF5dzk4RndvV3JWRUNiOGE4eS93?=
 =?utf-8?B?TXZ4N2g5MktzZ1d3bFk3REtFWTBiSnB0Z29vd0pGWmdRclBqaUFxSVFtdFQ2?=
 =?utf-8?B?ZW9VS1RkcE1tWVc3VmVmQXBaaVdQYXBqMVBaOGFkbE9HQUdwOEdyVFM2SXNa?=
 =?utf-8?B?cHVOZXhLTm14OFVHSGNyWXM2c29DUCtsTENUSWR1UkltaFdYd0trc2dyY2FN?=
 =?utf-8?B?TTE1QnZhemdQcjZ5b2RzWTFKeWVweXEvdzJZdGlRR3hNM0dlaVBLc3IrdHJj?=
 =?utf-8?B?ZnhBeGVqMjk1WXdKWFVPWTlOcHNwNVAzbW5VbkFkUSs3RUFlOFBrYlZLMngr?=
 =?utf-8?B?bE0zbzRkN05YTTFiNFU2aGZ5SlpHMTBLZVR5TlVuOVhqSXgyOFhWV21HZDFT?=
 =?utf-8?B?aEd2OEJ2eTlXZFdFTUpmSlRWOTlyOHNZTFkyNW5BUTNNQWRKaE1PS21tdkQz?=
 =?utf-8?B?MjRoNjlVODEwcUhjeGpEVUJtMEdCSGE5SmNkNWU1NjkxTlBXN09ndm5aSlh2?=
 =?utf-8?B?a01kd0VnMkZjaGFQVk5TL2lmdHdRWk5OWnZNU1JNMWo4L2VoQ0s5MmVDMFh4?=
 =?utf-8?B?UThobjdZd0xiS014Y0NDMTdpZEhaWUN4Ykx6LzRmVTJnSmM1ekh6TzJ5ZzdT?=
 =?utf-8?B?VUtCeEFwV1lYUmYzTDNDamE0SGltZGgrTG11THNSdFM4NzJBaVdVY0NSWXpF?=
 =?utf-8?B?dXJ5OFpBb3NCVS85U1k5WnMwWG95SWhFYkcvV1hmL0E3MDBoLzZiRFRubFo1?=
 =?utf-8?B?YXRQbStmNUZJVDdrMW9vdDlWVDZvNEJTcldHcC9vd1RrZ0ZhMmg1L1NKb1l2?=
 =?utf-8?B?TmIrTS9oeEVlUHpIUEMxY3A3cENlYldJZFcvaGdtUXh4V0pPaUVBOVlnSDQ1?=
 =?utf-8?B?QWE1cEdSbE93KzRXbkg2ZEtIOEJ4MjlaMTg5ZjVhQi9yT1lxYSthcEVwZjlT?=
 =?utf-8?B?SlZXOStBVDlyYVRLMTZOdkZJNzA0V244dHBSUXBzamFIWFFpNDZTM0ZRem9L?=
 =?utf-8?B?NmN0SE5rZmZ2TDVGRDk1ZDBLeGxwSXFPcGdBM0VHNnVwNDFhU1Q3SFhUbUd1?=
 =?utf-8?B?bElmWkVGSVp5WTNRWXFIc0RjcHVoK0dYdFRVZXl6bUUzMnBJR1JDT05VQnE3?=
 =?utf-8?B?U00wd0ZON01sOC9VN0ZyLytkancycU1FNVh6Y2VjSkZYM1R4cXE1R0hJMytn?=
 =?utf-8?B?dWo5S3FZUm5paTk0RXNqeVhHblArb2dReU1OQis2cUdXWWpvWkVtYlVoTk0z?=
 =?utf-8?B?TExWcFl5UStjQ2NwRHZaV0c0UjdzSmlhemJCQ1ZQT2paazNZKzkwamU2U0dF?=
 =?utf-8?B?QkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1EFAB63CFB0F142B51D794A130D48CF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c9b918-363c-45ad-ad9d-08db4bf8d838
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 17:07:15.4584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s7P/spM/L4bUzvcZwsl0uPfa/4VpbATDn+ik2dmNC3J5Z8mvty2s+GWIWyPMoDodkVEvKLCemA66hQgoPU0r7J0owvM+o1DsOqPdzZF0UF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5394
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA0LTIxIGF0IDA5OjQ2IC0wNDAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiArDQo+ICvCoMKgwqDCoMKgwqDCoGluY3B0ID0gIWlzX2NldF9zdGF0ZV9zdXBwb3J0ZWQodmNw
dSwNCj4gWEZFQVRVUkVfTUFTS19DRVRfS0VSTkVMKTsNCj4gK8KgwqDCoMKgwqDCoMKgaW5jcHQg
fD0gIWd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9TSFNUSyk7DQo+ICsNCj4gK8Kg
wqDCoMKgwqDCoMKgdm14X3NldF9pbnRlcmNlcHRfZm9yX21zcih2Y3B1LCBNU1JfSUEzMl9JTlRf
U1NQX1RBQiwNCj4gTVNSX1RZUEVfUlcsIGluY3B0KTsNCj4gK8KgwqDCoMKgwqDCoMKgdm14X3Nl
dF9pbnRlcmNlcHRfZm9yX21zcih2Y3B1LCBNU1JfSUEzMl9QTDBfU1NQLA0KPiBNU1JfVFlQRV9S
VywgaW5jcHQpOw0KPiArwqDCoMKgwqDCoMKgwqB2bXhfc2V0X2ludGVyY2VwdF9mb3JfbXNyKHZj
cHUsIE1TUl9JQTMyX1BMMV9TU1AsDQo+IE1TUl9UWVBFX1JXLCBpbmNwdCk7DQo+ICvCoMKgwqDC
oMKgwqDCoHZteF9zZXRfaW50ZXJjZXB0X2Zvcl9tc3IodmNwdSwgTVNSX0lBMzJfUEwyX1NTUCwN
Cj4gTVNSX1RZUEVfUlcsIGluY3B0KTsNCj4gwqB9DQoNCldoeSBpcyB0aGlzIHRpZWQgdG8gWEZF
QVRVUkVfTUFTS19DRVRfS0VSTkVMPyBJIGRvbid0IGtub3cgaG93IHRoZSBTVk0NCnNpZGUgd29y
a3MsIGJ1dCB0aGUgaG9zdCBrZXJuZWwgZG9lc24ndCB1c2UgdGhpcyB4ZmVhdHVyZS4gSnVzdCBu
b3QNCmNsZWFyIG9uIHdoYXQgdGhlIGludGVudGlvbiBpcy4gV2h5IG5vdCB1c2UNCmt2bV9jZXRf
a2VybmVsX3Noc3RrX3N1cHBvcnRlZCgpIGFnYWluPw0K
