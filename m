Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC6A739950
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 10:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjFVIWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 04:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjFVIWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 04:22:22 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2285EA4;
        Thu, 22 Jun 2023 01:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687422141; x=1718958141;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Mb/iX7QQ0p/i6cqMSx2C0Sv08YaBIoUBc80SgSiU2Yo=;
  b=ICJAQSzjasbvrLaAhu6MdOpH/XD2ixicaMGZsmf33xgt/0fV7/dKmT+F
   2E1Iz39WQlLKQIw2frjtnAI+tLfQTgFiNXSDfTFTpasRiM4Y6sXMvQ30P
   +85hBtpHeiirJuYOfHtV3bFexZ8SrjVmOVe7+KAWhebvOd0ezAJA+B3XE
   +R5kht/9qEY2NOS7dsn6BCdr4OqCOmBTeogRdl+dNPxiiodhaDRKJYT0X
   SXlUqgiK7RTWD4BnPZLPjJofEBFDAnYam9lM6A9LejDmvb8K+lztZ1a6r
   7nzBxZN5oTajbHWQ11rKNVCfwak+ak4BKdWUXvjCbRZJOTyeLUMpzg8zT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="345156733"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="345156733"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 01:22:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="692161563"
X-IronPort-AV: E=Sophos;i="6.00,263,1681196400"; 
   d="scan'208";a="692161563"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 22 Jun 2023 01:22:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 01:22:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 22 Jun 2023 01:22:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 22 Jun 2023 01:22:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MamtCDJfpS/fBBX2O9vQ3AL5pY2oypyT85kNNSpts8TgQax96N7CUmxydlISFEm+wtgKf3Hkx1W3zvDA0FTm93i3vnkaCwHRc5QFh3IxlbNfvoFRVGIRl2bHhkpLS/DD0FY3JxDe7eAOXH9HjMO7IwumNyiHlJSVF46r80NkSfA/OQShXIn60hdLYeQhmfpCe5kjXCzbwCir6TDbHZfK6y9nzthrPUnY+PLnRXdnXKNRSZKxvrO+ElH71EUmSI8ANdhDtW+3p6n+tMgxDVcBRs7rArepBfFYy1AFAeZ1dqcFne9caLIjIZEUSvWgNAhuNc/7WurYueQx4VzBrGDnWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mb/iX7QQ0p/i6cqMSx2C0Sv08YaBIoUBc80SgSiU2Yo=;
 b=hlc2DFMZ9OaGuemApxgjEe7Kw3dGvQVEWLWGJAmmRWAD+YarQlIP+swkWJhBgNN9C6Jy+t6b2IBoXjt7GqeX9ENQ+sFM88rNOCIi/4u+KQSicnVmdwKsu43QpMJ3ldq2rbq5OFPghbXt+lN4osaI4DmkosW4LeayoXHxVGkueT3zUi5LUbGJy61glcTJu27JfE0TsPv250uqlxhaCY6lcMCHOdDhjgJLRfnjgQO/gXEDFmx474FCei0ghCO66NmdEc8MdYV4ysszfsDo+MRZnsK7C1Gm/FBg1bb/HAzwbn1HJ2+fDcQz+drqXu0oFf7r5/ctIE3wjcrDkwyn7lhGBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV3PR11MB8601.namprd11.prod.outlook.com (2603:10b6:408:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 08:22:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.020; Thu, 22 Jun 2023
 08:22:12 +0000
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
Subject: Re: [PATCH 1/6] KVM: Documentation: Add the missing guest_mode in
 kvm_mmu_page_role
Thread-Topic: [PATCH 1/6] KVM: Documentation: Add the missing guest_mode in
 kvm_mmu_page_role
Thread-Index: AQHZoXksdVx2AU18N0Gkd+AksjfMPK+WglGA
Date:   Thu, 22 Jun 2023 08:22:12 +0000
Message-ID: <a19d0dbafa96704e0696820b3e51179dd45088bd.camel@intel.com>
References: <20230618000856.1714902-1-mizhang@google.com>
         <20230618000856.1714902-2-mizhang@google.com>
In-Reply-To: <20230618000856.1714902-2-mizhang@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|LV3PR11MB8601:EE_
x-ms-office365-filtering-correlation-id: 20260f71-8e7e-4d24-f337-08db72f9c7be
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 150P0R0DYJuD6kkUzeTIKaUpfYHS0TB9Zc1KE3+CnX/dVY9a0R6nQ3os99eE11htZhZfYeTppnBm5qo+2NmTn0Z9au4wkHT07msvdU7wk8mR4iB+mqASpQbD0ae/nvJtmpP8pFAr8mZQ4/Of3WjBGHpOuI+Hb1RO7+JOUzQJPyEcUiHyzysthjLYjlfPNy3/owwlJycivlYEb4Cw6Iv6l5IoWtPLcbqgJIFZFIiAK7Kfea2TdFQSen2pTGPRsbFqJYWQqu4wk/THivvrlZdbYDlRRzZ34h4e3091TRxtT6ZkzO+kNd38wuvPHwJqeMs5+YIHoQV6RU262M2XO9s+jKT1UsG25z5aqiJgWIkch7JXA1vdmVbSBbeWti3LsQ/W1FovxkfZYSKxTf9PaNTjOL5v4cHjTKq876uyKmucEDZCTJOOa8ys0hGeClQr3HvuyDLyN5nZO+WxeUiL0QErjH+P6FhL5tu5G1BMSrq2Rq494KWwrsZzJLmWjE6iu862puCeng3O4Nd9yoLlHeQl34gNmD/3wdrv+mLrKPuq7PAHkTWSoZBVmOTZu7sCWydf3N/aX/LN3KO2aGnD44wVbtIuJnGgl9xBF/Zpu76/3vHQVRsYzF1G67nuuqSPsAIZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199021)(41300700001)(5660300002)(316002)(8936002)(4326008)(91956017)(66446008)(66556008)(66946007)(64756008)(76116006)(66476007)(8676002)(2906002)(2616005)(83380400001)(186003)(6506007)(6512007)(26005)(71200400001)(36756003)(38070700005)(86362001)(82960400001)(38100700002)(122000001)(6486002)(54906003)(110136005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGxBZG1XV3JreFJFRkJ4LzdwK2ErQVM0WjlpcHJmczEvUTY1bmFJdXMvaW5l?=
 =?utf-8?B?TXhtQVlaMWM3eXZRQjd1QTJtVWk2N0R6U2xXTzJmNUwvNmR6TzAxcXdTelc3?=
 =?utf-8?B?Uk0rSExIck54SXJ6bFY5SStaMlBVRklmKzh1TkcvWTMzN3NUTkc0QURzaVZv?=
 =?utf-8?B?bUFaeW5YZWVSUGszam4wQTMzTmtWYzdva1IzdEhxZURwVlh2dTA4VTB5MHJY?=
 =?utf-8?B?WVJoa250YmlWbGtjdVk3dlhORTZubGpiVnpXNjl6MTcydzAwbmdzMU9HbFpI?=
 =?utf-8?B?a3Jkdk5vY2s5WVd3WTdjd29yanhzWXRadkFDY0EzU2JpMHVSMFRXZzFUd1lt?=
 =?utf-8?B?a3RhdHA4d0Nlb3NLME8ySXFTK0xhdzlsTDhHc1ZJZ1hsemt1NktiWDdPSjVh?=
 =?utf-8?B?LzArMG9JSzhZMVJLeHdSSzJlUlo0WWJ3eFBFQm83M3dZdEhVWEpHdXU1RnBK?=
 =?utf-8?B?Q2FFYXVjaVl4bkpuYlpUNnRpbHMyTzBtN0doQkU1TEw3VmZ0TG5IaXh6Mlh3?=
 =?utf-8?B?Nzl1NC9KK20wWFg5ZlI1R1VJeGE0d0Q0WG4wUGRJVmFMaEtXUnVpQ3YrYkpO?=
 =?utf-8?B?MWlmT3pSZGtQSkMrNEhwR0RtUWhJM1gwamtLQVhnUFZqYjh0cXI2ZW5NMGVC?=
 =?utf-8?B?Rm12NXAzZTl5TnlKU3pUYVVGL29PMENTeitOS29URG1QVThiQS9HTXUyRUNa?=
 =?utf-8?B?dGNFY3NKSFRxbU93aXFWVmUxRG1FZDJEdmhpRlRSZVptVWk4K20xdHVMN0xx?=
 =?utf-8?B?TjV0V0xOcjFTbXZjR3ZTODFUd3lkd2NacjMvWEhpaFpZQVpseXJUTWdtdXRT?=
 =?utf-8?B?OXpub3ZGM0VXZ3pkTWRkMFJib04xMDZzRUFpUkVSQlNEeW1hdU1FMDVnTEJD?=
 =?utf-8?B?OWpZZ3RFaVFXV3l3dzMyOElqTEpVV29oRVFsZjFaKzVBaEdrbkowZUlPWXRO?=
 =?utf-8?B?cmFGMForS2ZCOHB1VEI4ZVNZQmFFcHNQalVJWHBNQnhBV0w0MGwyNVdDTVRF?=
 =?utf-8?B?QTN2UGx2bVFaQW9IY1N2UHJhRHJUZDdQUzFJSjZEZ09SRGxUaktaeFVkZ2Vp?=
 =?utf-8?B?UFkyclVqKzF5cFdGM25qSE0rTDRJZmIydloyRk5FdmYyeUg3VFNkNCtpcTlw?=
 =?utf-8?B?eVA2eGFnbHF6ekRPVnQ0RHpMSVFLRERNNmEwcjAxYVhLemcvWHJ3NCt6ZmZn?=
 =?utf-8?B?dHpPWW1XL01namdjQ0hTSEJBSFhoYkt0VVRnYnBFTGZlL1NKeWErS0pSSXJ6?=
 =?utf-8?B?QnBZSU5vaTlRS3gxVW9OdmlkZ3ZPZ0huUnlOVzFENUZpN0ZlWHd4aG1LVnlB?=
 =?utf-8?B?cXQ0aEtIaDZYM2N4K1NsNWRLOFB1NlZMWUIvckFiV0VJTVJIVm15MVlBeEdY?=
 =?utf-8?B?cGFuczM1NGdQRWJQR1pUQXZSRUpJcDVRekpodUQydm1pU3pMbEJnUThhRTF1?=
 =?utf-8?B?OHhzdGJOaWRJdTJOU1ZlM2lYMmtOVzRMT0hHYWR2NVdmaTRQdWRpNURkbnNp?=
 =?utf-8?B?dExDdEJIdnJiR0F0cTBvSWNxa2N5aTVuZVJsN3pPU3JsSE9xWkFLZHl2UlhF?=
 =?utf-8?B?OFh1bHpWNHhmNUFIaWtJbEMyMm9vTGprQzdOZTdhUkFvd2dwVnM1YnZJVFNL?=
 =?utf-8?B?enNhbFpYRFhQSUV1MTZZVWtPdzNPQW8rZUhWS01Pc1M2M2t5TnF6R1pTZHZQ?=
 =?utf-8?B?azM3TG80US8vNFhBenlDK3d5VVl2byt0aTdIelBKR0RtSDhTVk5VZldBRmk1?=
 =?utf-8?B?U1U3dWMrcWE3ZGVHblhjY2drODUrZ09QLzIvb2VkbEFQUTVsa3VRVEVJbzNw?=
 =?utf-8?B?aGNPZTJZb1B2SlBpVnd4QVRVN2ZSdlordGczd0c0Z29UMEhoc0JMOGFzUTdx?=
 =?utf-8?B?NWR2NUR0VDJ1UVZPSGVkeUVSRVp0R0NKcjlzc2JaVXhha1hscThJeXJuR01k?=
 =?utf-8?B?NFhSVWtNbHZNeUdYbjJ4d0xMVVlBanBqUTBDL0hDd2hzZVBESXkwQ09KRFo4?=
 =?utf-8?B?UXhVWWtZaDY3aVBNaElEejFjaFNpRTNYMWJrQ3orR0RSMGlrb1BYeEliOGFr?=
 =?utf-8?B?TnFUTHFOdVlNVVlhYXdCaXdqYkJBQ0xmcG1YeVZXNndNUHJ4Mzczc2dNdit6?=
 =?utf-8?Q?LG/rdKtDsaP2CnUSXA353oA7D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B734FB2D0C33B543AEB25810BFBF4BD1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20260f71-8e7e-4d24-f337-08db72f9c7be
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2023 08:22:12.6449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EJ9XrefmAoZTl7/ObOVt8Ln9AVNETK264BDwyh3UxiwB69XrArZ01xjuJ+Y0qEWmjFcNie7OqFziG01s/ipjgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8601
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTA2LTE4IGF0IDAwOjA4ICswMDAwLCBNaW5nd2VpIFpoYW5nIHdyb3RlOg0K
PiBBZGQgdGhlIG1pc3NpbmcgZ3Vlc3RfbW9kZSBpbiBrdm1fbW11X3BhZ2Vfcm9sZSBkZXNjcmlw
dGlvbi4gZ3Vlc3RfbW9kZQ0KPiB0ZWxscyBLVk0gd2hldGhlciBhIHNoYWRvdyBwYWdlIGlzIHVz
ZWQgZm9yIHRoZSBMMSBvciBhbiBMMi4gVXBkYXRlIHRoZQ0KPiBtaXNzaW5nIGZpZWxkIGluIGRv
Y3VtZW50YXRpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNaW5nd2VpIFpoYW5nIDxtaXpoYW5n
QGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvbW11LnJz
dCB8IDIgKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL3g4Ni9tbXUucnN0IGIvRG9jdW1lbnRhdGlv
bi92aXJ0L2t2bS94ODYvbW11LnJzdA0KPiBpbmRleCA4MzY0YWZhMjI4ZWMuLjU2MWVmYThlYzdk
NyAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvbW11LnJzdA0KPiAr
KysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL3g4Ni9tbXUucnN0DQo+IEBAIC0yMDIsNiArMjAy
LDggQEAgU2hhZG93IHBhZ2VzIGNvbnRhaW4gdGhlIGZvbGxvd2luZyBpbmZvcm1hdGlvbjoNCj4g
ICAgICBJcyAxIGlmIHRoZSBNTVUgaW5zdGFuY2UgY2Fubm90IHVzZSBBL0QgYml0cy4gIEVQVCBk
aWQgbm90IGhhdmUgQS9EDQo+ICAgICAgYml0cyBiZWZvcmUgSGFzd2VsbDsgc2hhZG93IEVQVCBw
YWdlIHRhYmxlcyBhbHNvIGNhbm5vdCB1c2UgQS9EIGJpdHMNCj4gICAgICBpZiB0aGUgTDEgaHlw
ZXJ2aXNvciBkb2VzIG5vdCBlbmFibGUgdGhlbS4NCj4gKyAgcm9sZS5ndWVzdF9tb2RlOg0KPiAr
ICAgIEluZGljYXRlcyB0aGUgc2hhZG93IHBhZ2UgaXMgY3JlYXRlZCBmb3IgYSBuZXN0ZWQgZ3Vl
c3QuDQo+ICAgIHJvbGUucGFzc3Rocm91Z2g6DQo+ICAgICAgVGhlIHBhZ2UgaXMgbm90IGJhY2tl
ZCBieSBhIGd1ZXN0IHBhZ2UgdGFibGUsIGJ1dCBpdHMgZmlyc3QgZW50cnkNCj4gICAgICBwb2lu
dHMgdG8gb25lLiAgVGhpcyBpcyBzZXQgaWYgTlBUIHVzZXMgNS1sZXZlbCBwYWdlIHRhYmxlcyAo
aG9zdA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo=
