Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF642739A03
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 10:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjFVIhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 04:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjFVIhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 04:37:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A47FE;
        Thu, 22 Jun 2023 01:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687423055; x=1718959055;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=awafkDUD82W857tLIN+E6ABcjMvRwsyVcb5IJdFaMSg=;
  b=jGZ3TCs/YWilCsSkocKbZk4pKyLT/AhYUyK1I/zbxKjL/LC9nzScDB61
   Li4duyksHZk5WfK6dtzzSIGfqfLbeP1CLTmZV9lYpQEyWfljY8q17JFy3
   KnwLtBDDQakKNUEVEA5TQYX3r5BFgWOpURBU9bHf4bpCsB8x5BIdCvXix
   ZF6UlaMmC8PjzziXhJwRY8UjzMGQLXKWQSrPN5Nt994aMk1lEVvxzbN/J
   lV18BNnH4awKXhPIShuZ+LTdLWWyUxHwM+WuRaRHiUvuZiV0ACxpmBr2j
   Snhrk8ltTTV1BQ2CeBYV8NEB4or9fnOnWowjbHb38cEosjR0UIpWv4rJd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="340033330"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="340033330"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 01:37:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="888997109"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="888997109"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 22 Jun 2023 01:37:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 01:37:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 22 Jun 2023 01:37:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 22 Jun 2023 01:37:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FI4mlBBfZXEc5e6srEyGxW9uRsEgFTsYaCO6YQPFFe1/uA1LTUWNytR4CZhadOPy3zRXr/V54ACoVag94ORUdxtsgoS5Lt5RadcjijcnBEjO+Qpef5MGqdVYMvEijoDBck6FhMIfioHtFDCNVoc56c8qPFdimudoBJqdzmzeE+Hn0s5GKRae5Jg8rv41MnRZyJO7zaALtSy3Pb1bpBHVqm1hGSYPLMlNTb+qaX4YcjBYRfM1MBilQG+5kGF92Q52l3jvmcDvTCbahB0tXA37fvr3fHJ4Qs89ikI3GqlVovv/2DaHKFg3Z55rG/eTi6PyR8KMQzDVn0gEW9Fp8m+sjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awafkDUD82W857tLIN+E6ABcjMvRwsyVcb5IJdFaMSg=;
 b=OMSHU5qcR+T5//N75jgjiCq/ivfrdtH4mTz8CTzj/qSl+lBGBgO1CqoC+WDamIwjKN7K/OtZkwnJSkuk5LCu/Pk5T8BWtRNHrp5FvJ8iYWa9VBGTamBWWwtjGFAPr7mtJ6+rgKlClUvO9mWuJitDI31g9CMY0f4LgZS2m2PLGjH1dIyRG6zAaPTmfy7xMnbIlK/9w1IAEGxrye4ozzk93hziSaasb5Oq7WGNyhVdHNowJjVvZ38QTb59iioMRAWqK8KoNXg6XENEFJgL7gMUy96eZ6UWly+/WDBUvAV1PLt2DAbRkbYhEWlbPX/B8tda+o+gQ/ttaiLFUreeDN/yiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4778.namprd11.prod.outlook.com (2603:10b6:806:119::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Thu, 22 Jun
 2023 08:37:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.020; Thu, 22 Jun 2023
 08:37:28 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mizhang@google.com" <mizhang@google.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "bgardon@google.com" <bgardon@google.com>
Subject: Re: [PATCH 4/6] KVM: Documentation: Add the missing
 tdp_mmu_root_count into kvm_mmu_page
Thread-Topic: [PATCH 4/6] KVM: Documentation: Add the missing
 tdp_mmu_root_count into kvm_mmu_page
Thread-Index: AQHZoXlFKnoQhW5ytkWAaAY7wuJyyq+WhpgA
Date:   Thu, 22 Jun 2023 08:37:28 +0000
Message-ID: <1af0f4de320fd5ba96d63b7f0bdbbb061a7466f2.camel@intel.com>
References: <20230618000856.1714902-1-mizhang@google.com>
         <20230618000856.1714902-5-mizhang@google.com>
In-Reply-To: <20230618000856.1714902-5-mizhang@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4778:EE_
x-ms-office365-filtering-correlation-id: 21c53a76-7fc9-4b5c-dcbf-08db72fbe9c0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ACXBaJweVwyGb3hQ0Yp+ocpUDVgx9XqXx+jWROk5WPImFtvd5OmC/PhsBjlt6i5RIqCFeHIi8XDEFcR5jlJodffRif8m/4HNEJfoXWQ4S1CxlTxkx9j0uj8nnu161qKM+S8JrLeIyxCqIONB9VH+k0GInS5LLmB/s5+UBrEWHfJwsQLwO24CkSSA/poe6NDNkoMbiZqnRvcQEw9/6s1qNO4kVKhSl3Alusq7yYDK4fldOfv5g+x/HDPcoBXJhpKAhXLQqIq3DbfxsxI50gG66JMwjAuYuqIM0II3FQmX3IKdj0lfVPYTurZNTyWJx0pOqdpL7QcmSdcXUcipzZO7FE9qSmP9jNm7JmrlykVtL5Od5kpPcBZIcARxikjFHgx4SJ7nU4syPWP/V+Pm+fx0Ck+LlfLInOW38ctprPcIHcI3NftyXxJHMosnhLqr/D8K1TR9eBZg1npxKz9TKClIBcTu/tj/g4y9LxkftawgNx2wicN30LMhLkK48yokrss4IIykCxoUlFClI8GlD0w9+G257SflEMmEMmepgNrJCb4l53NVG1ZYmYTyATUrwrW2E9Ts5dn7CUwb370fNjajG6ZL83/bvXCNrEbQSBoRgqFVUaTEI72zQlhzXm/3rKCE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199021)(5660300002)(2906002)(8936002)(83380400001)(38070700005)(86362001)(36756003)(122000001)(38100700002)(26005)(82960400001)(64756008)(66946007)(66446008)(4326008)(66556008)(66476007)(6486002)(8676002)(91956017)(71200400001)(110136005)(478600001)(186003)(54906003)(6512007)(41300700001)(2616005)(316002)(76116006)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2Fxd2NKTEFsSEJCekZoYXN1VW1DWnN0S3pmUjE2QW5IalZsSnZLZTVrOFNC?=
 =?utf-8?B?Q29heXRUblhzTlU3di9ZWlRac2t1eUVndkppKzAweDl6WTdoZUxNY3QwL2wz?=
 =?utf-8?B?R0syVXdpZ0xwT3FGUmVyVkZuVEtMMzErRGh6V0Jqd21zTldZREsreWhHcXZM?=
 =?utf-8?B?MFphQkZ2VitycU9zU0JCdjhFYzNNaGhUNjBpdEJyU3V5QmFMZ2hNSEZtTWN1?=
 =?utf-8?B?YmZyYXRMSUpHdGUxcU1uYXBrUzBrbWhsbzZ1djBBeHNHZEltTUdVcjJoeE5w?=
 =?utf-8?B?NWpCTHdyOS9zclROMWFleDlOV1RGVERqaWxYNTYvOHBCY3EzQ1JURnBhR1pC?=
 =?utf-8?B?QkVQcVZFQ05CdkNEM0Y1VDJXSWlVSUgyRFJVNElVWXdBK29iYkNoem1oYnlI?=
 =?utf-8?B?Tmx0aUtYbTFPMFlRWUFsY2FaL2kxRGhtNkJPc1crY1BuOUNLbFlDekd6emJZ?=
 =?utf-8?B?UW0xSmxHcG1wOERueEcydjRhaGhZMWlqelVoaFNSdVhRd3NZKzVrbHpSa1R1?=
 =?utf-8?B?ekxsZzRmTWpYeTU4UktlVldndEozRkM5WnJMRkpPdVoyR1h6TVdXcnVXTkNz?=
 =?utf-8?B?TWJXdFQwampneS9Ed3RyTlNxY2pwRUhZcnZZUnBlUzhrWXpvcFREdEd0ajNV?=
 =?utf-8?B?cXdEZkJiYVg0MXNpckZvUi9aTm04L2RUTWYzeGxsM1hkOFJtRHRCYzBiTlJD?=
 =?utf-8?B?eGVvOXJCYlBOTVdCZHNPamFwbWN0OVVsemd6WHFMbDNQazdjWmMycmtPeUtE?=
 =?utf-8?B?ckJjRElOUnlPU2dlbXphQlRnSitLb1Q5UCt5a0tZVERYa01JYTBWYlJMTzla?=
 =?utf-8?B?M2VoY251dU83MTkyelVWb05vODI2V0U2RWFJRVdWUTVwendxVnRDb05xdmNs?=
 =?utf-8?B?R1d0TmpVems2QUx2S1VHTkZpL2FUSXE0a2tqajJKOUYrM2NPZk5DeElhNVMw?=
 =?utf-8?B?czdwTllaQ1BNR2VOSi9NRnE0aEJGZ3A0ZmJ6dzdRMHk4TkdkZFF2TjJyQy8x?=
 =?utf-8?B?TUpVM0ZVOGNOSDA5ODVVNFgvaFVmUHZabWI0ays1dmJFSUVjQWc0NGxZSDhv?=
 =?utf-8?B?NkZUVzVRRSt0d2FXQ0pTS2V6UjR4cnoxa1BQZVNSUmhoakxZZjFZK0NpcTUv?=
 =?utf-8?B?ZXVwSy8yZzdNeVRpU1Z0Y2o5Nk1tVkJUbTB0ME5OY1pHNkQ1bzgwQ0ZYY2U3?=
 =?utf-8?B?OG5abWdZamdkbk82cEkwcFdOOE11NDdyRFNpVjlwUGhIeUc0VHl0bmUyNnBo?=
 =?utf-8?B?QlpIUGJHczVOcWdmRHFkbUJRTU1aNUhwcERVZUpienlxNXVCaVhvNDQ0U0Nh?=
 =?utf-8?B?R0haNVZDR3RhdDZSeTE3UWhyK1RGWkt4bG1NZUVIaDBOV0pQRW9QTjBEbmRM?=
 =?utf-8?B?MFZTTXNrcENrNjRBOGVHbWozVmZPc2cwZ2d4WnFFZHpuL1orNEIrc0NwYXpJ?=
 =?utf-8?B?bDQ0VHU2MFREZEZwQlZVWGlBRHdzR2ozaGRsdjA3SzZvaFl6WW9Va2s2SjhK?=
 =?utf-8?B?TWZrd3FTWWdXaklneGM1S213QTJRWERqZG9rMlBqWVRTTkJZRXljcjBGZHd2?=
 =?utf-8?B?aEV4bURZemF6K3F2QTY2dG5iNW9mSlFCaDlWWGRMWDBWb3I4WlhjUmZiYWk4?=
 =?utf-8?B?MXhpU0tTZTR0OU1UT0FqaWk2YlNiYStadm1KRVpTZEhwQ3YraG9TdGowZ0pC?=
 =?utf-8?B?NVcrS0hJdjU3YWgyMFYrOW9kUSthaHVsRjFJOHZYd2RJcTV4NXJVT0VYd29y?=
 =?utf-8?B?UWlwYks2VkttNmhGMTd1cHFtRnNjQno0bTFGMUwxTStiRHRWUFhSUmlHcTNP?=
 =?utf-8?B?TDZ0TkJHREtXNFk0U0hkMEl3MVRMeXRoWGhmQlhPVDJ2cEJzcW9USjNrdmFS?=
 =?utf-8?B?aVA3NHBTbkVLVWJTRitqNXJVdERkRjJMSHJkbE9hVzhYbnRhQkx6d2hpRmkv?=
 =?utf-8?B?ejcwSWFLeXdsQTcvVjZlODgvVG5sYlZQTVBSNEZWcjBlcDQzVEZKY3Zad1lL?=
 =?utf-8?B?dFVSaFdBaUoxaWdPVGdGTTNxMXVETHpRaytvOFFOVGxLcDk2clBiKzBzcXRR?=
 =?utf-8?B?R0t1YzdpQmNSQXZsRlBKYmljL0NFa0dHcjUxZWplaGU2SzVNaElQYnJOREVQ?=
 =?utf-8?Q?91WkCIHN7sJKyTVWXCRx4xSDA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B9A4A5981D07548824CE43D7C324C07@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c53a76-7fc9-4b5c-dcbf-08db72fbe9c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2023 08:37:28.6851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gUQLGvWTjVqoMqCYY3dTV3YX+4+wbKPo1H2hqgcn97i5juYJE45medBOr8o86YD0AdGfkN55zw360oxL+LK45Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4778
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTA2LTE4IGF0IDAwOjA4ICswMDAwLCBNaW5nd2VpIFpoYW5nIHdyb3RlOg0K
PiBBZGQgdGRwX21tdV9yb290X2NvdW50IGludG8ga3ZtX21tdV9wYWdlIGRlc2NyaXB0aW9uLiB0
ZHBfbW11X3Jvb3RfY291bnQgaXMNCj4gYW4gYXRvbWljIGNvdW50ZXIgdXNlZCBvbmx5IGluIFRE
UCBNTVUuIEl0cyB1c2FnZSBhbmQgbWVhbmluZyBpcyBzbGlnaHRseQ0KPiBkaWZmZXJlbnQgd2l0
aCByb290X2NvdW50ZXIgaW4gc2hhZG93IE1NVS4gVXBkYXRlIHRoZSBkb2MuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBNaW5nd2VpIFpoYW5nIDxtaXpoYW5nQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAg
RG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvbW11LnJzdCB8IDYgKysrKysrDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlv
bi92aXJ0L2t2bS94ODYvbW11LnJzdCBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0veDg2L21tdS5y
c3QNCj4gaW5kZXggMzZiZmUwZmUwMmJiLi4zZGNlMjQyNmFkNmQgMTAwNjQ0DQo+IC0tLSBhL0Rv
Y3VtZW50YXRpb24vdmlydC9rdm0veDg2L21tdS5yc3QNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi92
aXJ0L2t2bS94ODYvbW11LnJzdA0KPiBAQCAtMjMwLDYgKzIzMCwxMiBAQCBTaGFkb3cgcGFnZXMg
Y29udGFpbiB0aGUgZm9sbG93aW5nIGluZm9ybWF0aW9uOg0KPiAgICAgIEEgY291bnRlciBrZWVw
aW5nIHRyYWNrIG9mIGhvdyBtYW55IGhhcmR3YXJlIHJlZ2lzdGVycyAoZ3Vlc3QgY3IzIG9yDQo+
ICAgICAgcGRwdHJzKSBhcmUgbm93IHBvaW50aW5nIGF0IHRoZSBwYWdlLiAgV2hpbGUgdGhpcyBj
b3VudGVyIGlzIG5vbnplcm8sIHRoZQ0KPiAgICAgIHBhZ2UgY2Fubm90IGJlIGRlc3Ryb3llZC4g
IFNlZSByb2xlLmludmFsaWQuDQo+ICsgIHRkcF9tbXVfcm9vdF9jb3VudDoNCj4gKyAgICBBbiBh
dG9taWMgcmVmZXJlbmNlIGNvdW50ZXIgaW4gVERQIE1NVSB0aGF0IGFsbG93cyBmb3IgcGFyYWxs
ZWwNCgkJCQkJICAgICBeDQpQbGVhc2UgZXhwbGljaXRseSBzYXkgIlREUCBNTVUgcm9vdCBwYWdl
IiA/DQoJCQkNCj4gKyAgICBhY2Nlc3Nlcy4gIEFjY2Vzc2luZyB0aGUgcGFnZSByZXF1aXJlcyBs
aWZ0aW5nIHRoZSBjb3VudGVyIHZhbHVlLiBUaGUNCj4gKyAgICBpbml0aWFsIHZhbHVlIGlzIHNl
dCBhcyAyIGluZGljYXRpbmcgb25lIHJlZmVyZW5jZSBmcm9tIHZDUFUgYW5kIG9uZQ0KCQkJICAg
IF4NCgkJCSAgICB0byA/DQoNCj4gKyAgICBmcm9tIFREUCBNTVUgaXRzZWxmLsKgDQo+IA0KDQoN
Cj4gV2hpbGUgdGhpcyBjb3VudGVyIGlzIG5vbnplcm8sIHRoZSBwYWdlIGNhbm5vdCBiZQ0KPiAr
ICAgIGRlc3Ryb3llZC7CoA0KPiANCg0KSSBndWVzcyB0aGlzIHNlbnRlbmNlIGlzIGltcGxpZWQg
YnkgInJlZmVyZW5jZSBjb3VudGVyIiBtZW50aW9uZWQgaW4gdGhlIGZpcnN0DQpzZW50ZW5jZS4N
Cg0KPiBOb3RlIHRoaXMgZmllbGQgaXMgYSB1bmlvbiB3aXRoIHJvb3RfY291bnQuDQo+IA0KDQoN
Cg==
