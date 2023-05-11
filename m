Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A736FEA00
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 05:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjEKDFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 23:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjEKDFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 23:05:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD13B1FCE;
        Wed, 10 May 2023 20:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683774333; x=1715310333;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A8HDmNrQGummi2QAy/a76R+8pHjEJK8jfFYUNHLVAC0=;
  b=TUZ3vFndmKfJ3u9UB5mWbGNLnaIC0W0/IgCTCyATtlP8fA+ODrAc/3Su
   NpiH7Nyxs6JgMI4fnwiVxgSGPX3XoWdKDCSMhUIkG+t/vujDU1mWFfkrA
   58Ixpihouhd8uHJCRbS6HwpY3PUvArkwsdEY+C0lpWVHsA+H/xizqkcqr
   n3gvOwjpynZEgyTYp3OHAIILCg5+bIbCiaDtwK50nG53HFV4wFLvIk9r+
   RMki7jupccqVpLqAU50w8h+9vFlvxLSwnEyubrxwaohsM9weA9Ds5UD8S
   L868YSqmDZ9E9k9PVVTXVRLELAq29KpPgsNTTNB8nvLLk+MwkicCZxY4h
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="330739614"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="330739614"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 20:05:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="702556565"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="702556565"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 10 May 2023 20:05:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 20:05:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 20:05:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 20:05:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2prKUlmmU5nVcmVdrmMCitWo0o4Nka7vjWPV2zFi0rfvdTHOdd0hMvuoibBjeudftO0QpMLyJjpX6twSYL8urqqc64s9TxqriPU/6Or36eK8H3Ui/l8eJqu+trqOT5bAvOy/yux+ZwNV1pY0TausMgwQnjOf/B8d5jMcp2iY+hVHiOMGGVA1phZMKh0Uqi1018lKIuDS42SwShawo+BpmqaboVlsQMLjj6Wjimvpry6Ph7lDswu3D8qjFjUQncgJfAgXSAspU8rXpVSIXlmaxOUrcOn5CGhIianbMIBS+fkmTAG5PRZUXcWcNl+drBr1CKv5ML09wxRCgaUj3OkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8HDmNrQGummi2QAy/a76R+8pHjEJK8jfFYUNHLVAC0=;
 b=T0GokjBR4CtaG28an17eXSjiEHOIWD7AeCKl57HIf8Q1kA2uA/9vzwir5WpyMCWtSpPWvuxm4Wk1k11bFonmMNPuuFF45DVxERGD4/UMjd+amJNJWSi6Z7w7tM1Pz/goM8So84bnGNsswY2cHAhcFIyxKeYg8kmprvznZby7j6rVps5GkQiJQ6LneRR9jfOBHEKvUg1CTM6NyMQmWpUn16oN/eruVJyxGvWt8pRE9RWCJ6+9XMMkAN/vNeYS0DW2E9jsR7QeeifRm3LVboZnPJL+DmQPgaNma7MxLpKqjkCEUcUvOz+jhz6LxypkPl/YzQLdyqGXzepR45fh3Qnrwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4901.namprd11.prod.outlook.com (2603:10b6:510:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 03:05:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 03:05:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR changes
Thread-Topic: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR
 changes
Thread-Index: AQHZgoDvHvtjWxAbgUSEtQq61PPuVa9S/o2AgAAndwCAADCnAIAA38GAgAAo8AD///z/gIAACYKA
Date:   Thu, 11 May 2023 03:05:29 +0000
Message-ID: <d2b96bff30facf7f62e387a1e0f2acffe3e9b9c2.camel@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
         <20230509135143.1721-1-yan.y.zhao@intel.com> <ZFsuDWwoKRA0W2/j@chao-email>
         <ZFtPKLvblLcxPvZQ@yzhao56-desk.sh.intel.com>
         <99c982ed53f0dd7e0723f566b5527091b7e4e54c.camel@intel.com>
         <ZFwzq/833QX3n9xc@yzhao56-desk.sh.intel.com>
         <077fbb11f0a74850fb46abe4fda31414db66539a.camel@intel.com>
         <ZFxTfaWRCfswMzMv@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZFxTfaWRCfswMzMv@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4901:EE_
x-ms-office365-filtering-correlation-id: a1bcb0b5-1563-4f2f-74a8-08db51cc93cd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XmlkhZS0F0ffUujwtDdAORBVagXju58YTzKcdrCUg7AyuqQFKXPO9BMtcZ++vH7klFg6iI3KCS0fhmRWCSdK04pa+lHzAxUWKLSFboY2VBqsafQzrtA/SPGvvP6PRZg+8ckkL8dwamWIz6gn4Ta5tWiwtvF2DOgWIZZT2t2kkTBfaxljVKIVSLmWBmWOFkAIoYZAZ96P3n5IAiX9RMPRKlmM7ENryWOpUglZ9roApAwqdyEzSTfzRptIN94UenuIg7sj5pmkbQVqAf2beCfqVCaICWUVt5hDmXlqhvkIpZxUVqcOIUVYefM2yJMtMCp4MwaR3BfcxLsHwnC4b9BRSkhQEGUf5ys5QhBWh9cSH1ybZxJ6Fkkd9smGUx/QwkYxlBDbU6xM1qL/lgK+ZOVkHCPt3WXAuazrT2nXsu7VvZA/7rcTXluNR6H0qBmbEkNJg0Ddn1b1UO7mR5VrHCKjBZpLHMJwm4mMoH3Vol58RiX8arLDglLbaiRHjdSV4vdTh6ZrZDKQkCGxobReJs/AvSaI/JIR6bsjfIRsakwpCYQjuEGPGJcPuMbJgBJQxZSyr6xY5rO2pbAw6jJI4ctd06VkwpMYybQbNWMuqRVbu5qfEJSngi/Vh0kKUgo5NS8d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199021)(6862004)(8676002)(71200400001)(6486002)(4326008)(66946007)(36756003)(66556008)(66446008)(91956017)(76116006)(64756008)(66476007)(54906003)(37006003)(2906002)(82960400001)(41300700001)(316002)(38100700002)(86362001)(38070700005)(5660300002)(8936002)(122000001)(6636002)(478600001)(6512007)(6506007)(186003)(2616005)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFRjQW4wRkp2cDlHb1dvZXNoQW4vMUJZd2lmby9nalhTUXdCTkQ5TDEvMTZm?=
 =?utf-8?B?MlBVQzFMQVFsMTNhazQranNwMUsrdDlTYnFvL2lRbk1OYzA5WFpCanFLcDhX?=
 =?utf-8?B?NkI1aENTY0tHWlJuRitsUjBwTC9nRnpwcSsxdjZkSllPdkVEc3RqWHRneEFl?=
 =?utf-8?B?NlJSbDd0WUhGMHFqNXNicWpOMG5qQXRHTkxWZVlWWWIxSUM0bHZSYm1NaFV0?=
 =?utf-8?B?bUVPODhYMi9Ba0lCYkRUVHNrZytzVWEzMXBpckpLTnROMXg0Z3YrSkhnOGRk?=
 =?utf-8?B?eDlLc0Jzcm1DVHk3VjF4WDFpQy93REE5OHRNaFBEUWlSeEk3Z3N1VENkZS95?=
 =?utf-8?B?V05VMGNGd0FTR1BDZTVjN0wwWXE1cnEvY21ROXpONk1XM0kyTHdlMEdJeW5z?=
 =?utf-8?B?YkN2V2U0QjNkeUJmd0ViNXpkakx5ditYRVMvUmhIY09FcG9iK3hiMUd0THZn?=
 =?utf-8?B?KzdnQWxMelkrWjNDWndWNnpMZ3FxNWtLN3AzelpMblpkbkYzbjJtUnhDL2FS?=
 =?utf-8?B?a2NWaHNxbDBrTU84THdmTnppRXNXTGYxM3Z0VjZkT2xERlZVUTcyTzRsSUdY?=
 =?utf-8?B?UlBub0NMZ2lzL3FGY0NEVnRUSUJxMFZGc0l2U1pHcTBFMXZML0J5YzR0U0ll?=
 =?utf-8?B?Zitnd3h2c2ZmSlFlcEdHbitWVFJBSjZFeTVvKzgyOU9OeHRvV2VzVFFWb2Jq?=
 =?utf-8?B?bm8rZTM2VnlPN0ZyM29lendSQTEwWkg1U2ppd3Z1Rmc2VWVVZHlqcURCWUdH?=
 =?utf-8?B?NmkwemtpQjhQRmhzVGJVcVdFcysvOW0zNnUxTTJkaTF1bnI3OE9nOHdRWW0v?=
 =?utf-8?B?eGw3Y3NnYUllazlmNWNCMWhJUGZveEczY2paelNEczlXeC9kb21qakRYRXkv?=
 =?utf-8?B?Z1BINTFiT3VkNUgybERlTlhhNnR1N0hDdUljeTR6YjJxWk0wOEl5UFNmMkEw?=
 =?utf-8?B?eWx6M1Jhc2czOTg5dVdpNVdNZUszdzNqN3VRYnN3QkZmcDBpVlEwR0ZQdEx0?=
 =?utf-8?B?a2k0ZzVLMFdLU3dxY0luR2J4WGh4UWlkRGZOcldJTnBic1lqdi82YkdXcXNt?=
 =?utf-8?B?V2xRVDhOd1RTNVExS1JvUndoVHp2NkZvdEJ5OGJsOXZ4T3FVbjA0STdOZmdo?=
 =?utf-8?B?OEx0M1p3NHBBQ1plK3pTajA5dUF3YmgySXI5b0h3VEZ0ai9sd3pQc2dOcHdo?=
 =?utf-8?B?T29qT1R4QVR2YlE1dnZrMGwveXF2ZXUzU0Z1R3RYNVBySUlMeVMvUGEvbFVv?=
 =?utf-8?B?R2JuK3Z6a0UwMDhMZHdZenR1RXgxeWI5Vk1pNFlXYkRiUTNzZFVRS0ZnME9W?=
 =?utf-8?B?YnpNL0ZXU2RJUTRScU5ZSkVUcWlEMXV6WDhRbEVpT0h0SnA5NVF1S2VMUCtY?=
 =?utf-8?B?bi9DRGlRQVNwcmRWVHNLSjMwaVljVUFvSGpwb05oazVqOG1wSlZac2k1Qllw?=
 =?utf-8?B?VE12Vm4zNHJTUEV5NTB1bktFM0d0cXlJSGgraEg0cjN5Rks3dUZKcDVXU2ZV?=
 =?utf-8?B?N1duU1BwYkJiZUQ1Q0d1T2t5NjNyL2N1bk1Oc0c5cUlvTGlLSHhPTDhkQ1dC?=
 =?utf-8?B?bFk5R0l2VUQ2eklCQ2Q2clNDOTFwNDFNRWxHOTFNYmkwTmZVak9XSEgzbEZH?=
 =?utf-8?B?eFU3K1FIOHE4Mm9Zd3YwL1V0aVB0c0tTVnBtQ2lIbG5RdEEzMXBtZ04wRklj?=
 =?utf-8?B?azYwaEdIWTB5ZVF5dElSMEhtTFdNcnh3bmVGbEQ2RC9SZUhOSE1SakZYSldv?=
 =?utf-8?B?a0JhWFQ4cFk1SGFBWTNUV1B2M0p2SDJTUVY1NDVQaU5ienNDRUNJVjV5Ujgw?=
 =?utf-8?B?UGZKOHJ5TUplMkJEUWRmQk03MXA5U05Eb1EwWHNYZHVady9CNG91ZW5nUmNK?=
 =?utf-8?B?bG8xeWYrSDlrc296TEdVVDdUVzRxNy9qRGs3dWZQR29HbGV1U2IrL2VyOXhU?=
 =?utf-8?B?SXlVclA5aXB4c2pScHJwc3ZGejJwTyt1ZU1qLzE0SXRzUkxKTFhWa2ZHRE8y?=
 =?utf-8?B?azMxSGJMcDZIZG1uaFNaOUU4N2NCMVZTZm5PbUp3WUpnVm5mWmpXVVc0bHNL?=
 =?utf-8?B?MGxzVG5hRVE5Nzk0WVJMQ0drUldlRkVoZUY5Ni9XRWNzZVcrM3pRNkI0Qlpt?=
 =?utf-8?Q?TPrqIlY4K/uhiGBbSCqy0Fvg9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A31D48150914E4C9B0BAC37A072347E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bcb0b5-1563-4f2f-74a8-08db51cc93cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 03:05:29.7446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QiwEIqO3W8i/k2ssHWNYwftahaqrBbSbrGVUSQaLyg5HsBkmYXs/Dwn4uNr7XLY1isD+npO9ePb+XLLGzuFpeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4901
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

T24gVGh1LCAyMDIzLTA1LTExIGF0IDEwOjMxICswODAwLCBaaGFvLCBZYW4gWSB3cm90ZToNCj4g
T24gVGh1LCBNYXkgMTEsIDIwMjMgYXQgMTA6NDI6MTNBTSArMDgwMCwgSHVhbmcsIEthaSB3cm90
ZToNCj4gPiA+ID4gDQo+ID4gPiANCj4gPiA+IEkgYWdyZWUgc2hhZG93X21lbXR5cGVfbWFzayBp
cyB0aGUgcmlnaHQgdmFsdWUgdG8gY2hlY2sgYnV0IGl0J3MgaW5kZWVkDQo+ID4gPiBpbnRlcm5h
bCB0byBrdm0gbW11Lg0KPiA+ID4gSW5jbHVkaW5nICJtbXUvc3B0ZS5oIiB3aWxsIGZ1cnRoZXIg
aW5jbHVkZSAibW11L21tdV9pbnRlcm5hbC5oIg0KPiA+ID4gDQo+ID4gPiBXaGF0IGFib3V0IGlu
dHJvZHVjZSBrdm1fbW11X21lbXR5ZV9lZmZlY3RpdmUoKSBpbnN0ZWFkIGFzIGJlbG93Pw0KPiA+
ID4gDQo+ID4gDQo+ID4gWy4uLl0NCj4gPiANCj4gPiA+ICANCj4gPiA+ICtib29sIGt2bV9tbXVf
bWVtdHllX2VmZmVjdGl2ZShzdHJ1Y3Qga3ZtICprdm0pDQo+ID4gPiArew0KPiA+ID4gKyAgICAg
ICByZXR1cm4gc2hhZG93X21lbXR5cGVfbWFzazsNCj4gPiA+ICt9DQo+ID4gDQo+ID4gSSBkb24n
dCB0aGluayBpdCdzIGEgZ29vZCBuYW1lLiAgc2hhZG93X21lbXR5cGVfbWFzayBkb2Vzbid0IG1l
YW4gYW55IGFjdHVhbA0KPiA+IGVmZmVjdGl2ZSBtZW10eXBlLCBidXQganVzdCByZXByZXNlbnQg
dGhvc2UgYml0cyB0aGF0IEtWTSBjYW4gbWFuaXB1bGF0ZSB0byBnZXQNCj4gPiBhbiBlZmZlY3Rp
dmUgbWVtdHlwZSBmb3IgdGhlIGd1ZXN0IGFjY2Vzcy4NCj4gPiANCj4gPiBJbnN0ZWFkLCBpdCBz
aG91bGQgcmVwcmVzZW50IHRoZSBoYXJkd2FyZSBjYXBhYmlsaXR5IHRvIGJlIGFibGUgdG8gZW11
bGF0ZQ0KPiA+IGd1ZXN0J3MgTVRSUiBpbmRlcGVuZGVudCBmcm9tIGhvc3QncyBNVFJSLiAgU28s
IHBlcmhhcHMgc29tZXRoaW5nIGxpa2U6DQo+ID4gDQo+ID4gCWJvb2wga3ZtX21tdV9ndWVzdF9t
dHJyX2VtdWxhdGFibGUoKTsNCj4gDQo+IFdoYXQgYWJvdXQga3ZtX21tdV9jYXBfZWZmZWN0aXZl
X2d1ZXN0X210cnIoKT8NCj4gR3Vlc3QgTVRSUiBpcyBhbHdheXMgZW11bGF0ZWQgd2l0aCB2TVRS
Ui4NCg0KRmluZSB0byBtZSwgYnV0IGFnYWluIGl0J3MgYmV0dGVyIGlmIFNlYW4gY2FuIHByb3Zp
ZGUgaW5wdXQuDQoNCj4gDQo+ID4gDQo+ID4gSXQncyBiZXR0ZXIgaWYgU2VhbiBjYW4gcHJvdmlk
ZSBpbnB1dCBoZXJlLg0KPiA+IA0KPiA+IChCdHcsIG9mZiB0aGlzIHRvcGljLCBJIHRoaW5rIGl0
J3MgZXZlbiBtb3JlIHJlYXNvbmFibGUgdG8gbWFrZQ0KPiA+IHNoYWRvd19tZW10eXBlX21hc2sg
b25seSBiZSBtZWFuaW5nZnVsIHdoZW4gdGRwX2VuYWJsZWQgaXMgdHJ1ZSwgYmVjYXVzZSB0aGUN
Cj4gPiBjYXBhYmlsaXR5IHRvIG92ZXJyaWRlIGhvc3QgTVRSUiBhbmQgZW11bGF0ZSBndWVzdCBN
VFJSIHNob3VsZCBiZSBvbmx5IGF2YWlsYWJsZQ0KPiA+IHdoZW4gc2Vjb25kYXJ5IE1NVSBpcyB0
dXJuZWQgb24pLg0KPiA+ICANCg0K
