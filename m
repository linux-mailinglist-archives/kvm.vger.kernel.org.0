Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37682670DEE
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 00:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjAQXql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 18:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjAQXqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 18:46:02 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB84A47EF1;
        Tue, 17 Jan 2023 14:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673995962; x=1705531962;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EOVMFATs8KribQ7qxsHN+vMAxxXZFneEMm7yrVBnxM4=;
  b=II9I19pPX83jU2EE0ZAjHAMBh+Mwc4YkGTargjr9Hkvk3D7SNB6RT4Gp
   HvaEHuak3FfdXI4+jfvk9dBW+w5CFRC4z795wzJG7I10Btqk+31B+7zhz
   eTC51fkLu+6tUXq7uhvUKuZGPfwoiKOX2x+mJvJVr/rkqPPeeLXinchmu
   yRjwAPHWZHX3Vc+HwZFm03hdIjg6Z3dhSkPqsAf0fYMejKOh/cOGauP/7
   7hXqhNA9gi7HZG0gp7h0cvjuBWq1sDHZh9XhjuxuUfnDMkPAPeVW4qRVJ
   q1FD7C2B2wVjWGXjWrhix3TUXbat5mtpvVJ78114i6bmL54rghRUB3hBM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="389341432"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="389341432"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 14:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="652682216"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652682216"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 14:52:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 14:52:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 14:52:39 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 14:52:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpJokKYfU/UgKjWetGq+w7geltSgu23E0J1o0MkcSmGAW6dpMtZ1TuUqetnJLxZBdpRVM/tIz6kdG3c8WB7gzX6boWC62rZxp4ZRw6GefTob5foAx0K+ccaa01X4DDJE8TH6IOCf/4MoXScw8P7YucUxaXpgc0dYsa3vnv/l5RXBFEH+gFwgDTtt8Myev5KvERUv8s5Y/CfBHKTAlR/dTzrZCXfoIa1RNw8X1dMiV7OS4/sCDxp4eictapV8kHRVMp1J8Z9pXm/eyA7p/MTiqIoI3e79QMc++rMVoKYAHDbwj5XeTerOL3CqORtJmkzhrMo4ITk3xWyHJ5CG7SrlIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOVMFATs8KribQ7qxsHN+vMAxxXZFneEMm7yrVBnxM4=;
 b=QlakC2wjcWTAylOErhI3GmGHwyJQBi4yrI52bxSbnaZzIS9i8JL9Ctg3xcpbthRkaL9Bhtb0+YR4QarDXwLEv5yym73g/JV4p3syPqHk5CMBR7ItsnHPoA0idzd24/nv97+u0f3ZCLQveCDkTr7BlaV9jBKKWqicoD1qCZ3nq/3AC0N44qmf8iqu2FDcfTmCkWhVKtEJfoqXtxvITMssZmCXhkIgZTIQiNvEWWUplayQ8DlDEaEdPiGNbo88AS4RAKPf9vX7Yw7n2y1yxQgu4Ei2kw3ET0zsZ53IBso3rl0UV4573N4O4DnRi/Olw+9HmWzr8ZKHzM1O2negs7puqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6340.namprd11.prod.outlook.com (2603:10b6:208:3b4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 17 Jan
 2023 22:52:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Tue, 17 Jan 2023
 22:52:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "dmatlack@google.com" <dmatlack@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 025/113] KVM: TDX: Use private memory for TDX
Thread-Topic: [PATCH v11 025/113] KVM: TDX: Use private memory for TDX
Thread-Index: AQHZJqT1W9twA85zy0OECuWgQSx4RK6g4goAgAH1mgCAAGfXgA==
Date:   Tue, 17 Jan 2023 22:52:35 +0000
Message-ID: <9fa4473f76f20b94a8ba516defb3b33ac3e86e96.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <4c3f5462852af9fd0957bb7db0b04a6f2d5639ee.1673539699.git.isaku.yamahata@intel.com>
         <b8f88a7b9b2ab00379e6b1afd6a7fdb409d35492.camel@intel.com>
         <Y8bPljsAF+lSnWtC@google.com>
In-Reply-To: <Y8bPljsAF+lSnWtC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL3PR11MB6340:EE_
x-ms-office365-filtering-correlation-id: 8f581f52-252a-40eb-9999-08daf8dd86c7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5vX9TRXV+JK6YxCUx6G+7CoGW6TdrTDOUxfst333Gyy++Q8E7JdPrgHi122hMmeGLU2n/68CKZyvBdBexmK3o6LD4DLrz7zZrlRcQPpbPwpowe/V322RTEKMfFdFvVSJKNzInf0/A8iiIlC0AcD6uSGd3wR6iD8t6yKFtVY/7pAP13XYD4N+A9aDVBNTC6pap5tHSohe0tK9TFwH8Uiag+Yw/EERbvrSeWT0ScWGh94mVGCLP1kTWAaXVGbDyQYxxrLeN2n3m9Y0bTLUx87szadiI2f844jF0UjdPJ/rl6X3rJJTxMLmTAh7yf9IW68bieP/my16n0VAzKsmwg2ocIMB64DmZlFun47UsvEOK36BIi4vyBD8WaAmMAvt3xrVsASujJIBCw2+NQDwMPhwfB6qffqPKzhaf9Mz3Bb87iQRI6mgTdXUgSwyD59Q6XU/hscKCdOZgbOHQHF0N9yoc4p3FCWVipFs0XbtITtbd/oTfBoTnfUya1wD0msJHkUz6prV0RWbVQUho7/y+UeZIOjQFTrCArr+ecOewEF7Tgc+jtmE4oKp0FBf4Qq0KsL+Hln47bVdtrst47V6oj0uJi7mmHaEsnKPnbqfTtGxBI2f9tYdeNs7/o7AEV89LhkpvNj5G7b5fcFWnYJWWe0KyomK+NZy7PBaOFH+uIy/UIeo93pNcLn+U3PJxmQaNJxKMEZ8leluu2/DY5o5qMiRxyIPFbVckN+9eipq2WH3htc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(346002)(39860400002)(396003)(451199015)(38070700005)(2906002)(54906003)(5660300002)(316002)(66446008)(36756003)(86362001)(8936002)(66476007)(91956017)(82960400001)(4326008)(76116006)(122000001)(66946007)(66556008)(26005)(64756008)(38100700002)(6916009)(966005)(83380400001)(6506007)(41300700001)(8676002)(6512007)(2616005)(6486002)(478600001)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDRUeHpLS2IwbGdDL01mSVVTQ3dNMFRSR1p4b2tyZkdBS1NZbnhVOEpJeVFB?=
 =?utf-8?B?aFJyZjVac2szV3hhYnhmeklLN1gvSFZTYkliUnBjVVZnOGQ5Ujh4OFBsNzM1?=
 =?utf-8?B?YnYxelBnRnBjb0dJVmVZZFc2U2gxSWg0QkVTY1h5aWJNRFRocTN0STJuY1JR?=
 =?utf-8?B?d3dyazdOYi9QUjh4RFJSdzhVZUNkc040eC93TnJ0YUV0MWZtMVRzVUN2OHAw?=
 =?utf-8?B?cit6MjlVT09lTzV2S0hxeWEwSytsVUZHY3BVaDl5ZnQzQjRuaUE5VmMyK0NT?=
 =?utf-8?B?YzVHWHVvbVVhU2JLY21CbXNHaWhwNWpvUHEydFI0ZFpnd2FjL09CVEUrTERD?=
 =?utf-8?B?WlpLU05Ic3pnazhORHhWblVkL1dYSFd4TGRKeXNibkxPczUzNmU3cStERGhr?=
 =?utf-8?B?SHJYYzRPaWFjb3BwSE4xdmE0ZnpXSXhXZmpMbmtBOUd3VWkza1Fpckg4bkNQ?=
 =?utf-8?B?ampVRThjQkdaMldzRkI2MjdzSjBZSEZ4TG1QbDBKY0RNRnJyenZJbXpoN3J6?=
 =?utf-8?B?d0xSb0ltNEZtUzBJaHZYUk1Ka2lFTCtVMWlmcWR2OFgrNUU5MnVKZjBDQUdk?=
 =?utf-8?B?aGhTZEZtL21jQ0g0NnNBM002bnZoRGZyci9IcURGOU8vK2R1c0wwK2lMMlc4?=
 =?utf-8?B?OUgrV05QL1ZrMXVwM2M4VkZPWDloRmRBK08rYmF3aGtBblFhTjcxa3NoWXlM?=
 =?utf-8?B?M2IzV0Q2OXdOay90cG9zdDFkNll0ZnpncHhEYU1oekFrc01JR2JBSmpxVUZC?=
 =?utf-8?B?M0w2aEJEalV6eVB2NnlMdm9DbHYzMnB6akV0R0NFUVI5ZzEwTnBRUG5hTkpQ?=
 =?utf-8?B?enBCb3RmemNrZndzYm4xZW9EVFZLSFR0YjVwWVFGK0txcWoybWRETjVWY096?=
 =?utf-8?B?ZVlwYUFkblZYc1QrL2hTVkxRVlQybDRtMXNLZjl2M25PZ2t6UENudW5lT042?=
 =?utf-8?B?UTB5M01weUNyUEdJTUM5Zk1WMlMwZHFEVk11SFJqemxjaGQ4WDVORERyTU1G?=
 =?utf-8?B?QlJpbzRveUNUbk1hZ1dudms2STg3R2FqVy9rUlNGaS82QnI3SUxwUnQwY08v?=
 =?utf-8?B?ZXlZdlhSU2c4SUJhOXdNQitpcGlCVkFjWk5sS0pMbFdudGIzUXpLSTZLSW1D?=
 =?utf-8?B?SldwUDFEVHZwOUFMcnAwaFhDMEZqbnN4Ry9JVys5OE9kNTNQR0hJWkYyQWpF?=
 =?utf-8?B?OS8yUmYyVzlBSVl1UUZ4Zm05bFA5bTdqUEZBT3lqMytrZWtMRjQ1QnBXaWE5?=
 =?utf-8?B?WnFPelFMcVBIUUVBS054eFNJZys0MWJzeXZYaE9TV1dJWDZJUFJ5a2VMb2t0?=
 =?utf-8?B?OHZSVEk2OFdxL21iWW5EM3h1dkQzOTZLZXptT1pJZllaK090STZOSTU0NVRa?=
 =?utf-8?B?VTZxMWJ2T3Rhdi96MGJtZ2VPMlZlcENTdkZSRHY0WFZLRmlCREIwcStYcFM3?=
 =?utf-8?B?UGV6Y2JMR3h0cmkxcnRNYmhJcmk5R0Qzb3RiTnEwQ2JzU1B2MXk5NGxJcUdi?=
 =?utf-8?B?WHBFZFJhRDRFZC9MZnJWZ3FJQWZlbnQvWTFhWEdUZ0NUSTNYb1BPOWFVeUJs?=
 =?utf-8?B?Kzl6YmdhTW1SWm1zQU1CNG5sbXZkeUdsaXJFVVEybkd1N1B5ZGUwbjAxQmFy?=
 =?utf-8?B?alg1MDBqMDNjUHpDa1VzWi9RcFc3elhuSGY5ZDRqK1l1Y3B3ckpBTmlsY3Nj?=
 =?utf-8?B?SHd1TWxiMW9KMFczcEM0ejUzTHpHa05rcUZnQnRRMFBCZGxzbmJTeUprd0Rn?=
 =?utf-8?B?R0tjRFhsY25xaHd5NDhCc0x6dWlsSEIwelFwSlUzRDNIZ0NmbUtobDVCTEZh?=
 =?utf-8?B?cUhxNkxCazBheVVlMk9IQ3pJa3Z0SjlmZzYvWVBoWTdkSVFHUVZVN3YxZXJ0?=
 =?utf-8?B?QWExUVU3aFkxWXZRcXZ3dXd5M3F3NDdqZHR2Y20rOTBXaXRWdmx4TnV1aGR3?=
 =?utf-8?B?U09rUFNJR05qQTVxOHVyV0puVFZrbG9KQ3dMSS9vNmp3bmNRUEVBcE5nbit0?=
 =?utf-8?B?UmZkZUZ3TVNZN1FBL05XdnZDdExvZGp4TGREYWtzVm01N0pQc1pzdXpBNnpD?=
 =?utf-8?B?enkwVjNuNTFoa0NwVmZjK2dSUGRscnNGOWh6V05mNndjTlZ2M2U4dS90MXNU?=
 =?utf-8?B?OVRsYzFRVHRnOWRSQmtZNmpkQmRaYnhHejhXbzVWTUl1UEplOGRVQ2I1cWpI?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C8FB64850465D498F5760236FB99998@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f581f52-252a-40eb-9999-08daf8dd86c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 22:52:35.8879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afrXcj8QA32GHf6PFhEO8QyynWqblyTYrEsKfZogDXiys0n+8L5QhjR7eMZWLE8jnc+zU/EVp+SXTmoDrJQXXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6340
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTE3IGF0IDE2OjQwICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIEphbiAxNiwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
aHUsIDIwMjMtMDEtMTIgYXQgMDg6MzEgLTA4MDAsIGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbSB3
cm90ZToNCj4gPiA+IEZyb206IENoYW8gUGVuZyA8Y2hhby5wLnBlbmdAbGludXguaW50ZWwuY29t
Pg0KPiA+ID4gDQo+ID4gPiBPdmVycmlkZSBrdm1fYXJjaF9oYXNfcHJpdmF0ZV9tZW0oKSB0byB1
c2UgZmQtYmFzZWQgcHJpdmF0ZSBtZW1vcnkuDQo+ID4gPiBSZXR1cm4gdHJ1ZSB3aGVuIGEgVk0g
aGFzIGEgdHlwZSBvZiBLVk1fWDg2X1REWF9WTS4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1i
eTogQ2hhbyBQZW5nIDxjaGFvLnAucGVuZ0BsaW51eC5pbnRlbC5jb20+DQo+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiA+ID4g
LS0tDQo+ID4gPiAgYXJjaC94ODYva3ZtL3g4Ni5jIHwgNSArKysrKw0KPiA+ID4gIDEgZmlsZSBj
aGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiA+ID4gaW5kZXggZDU0OGQzYWY2
NDI4Li5hOGI1NTU5MzVmZDggMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMN
Cj4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiA+ID4gQEAgLTEzNDk4LDYgKzEzNDk4
LDExIEBAIGludCBrdm1fc2V2X2VzX3N0cmluZ19pbyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVu
c2lnbmVkIGludCBzaXplLA0KPiA+ID4gIH0NCj4gPiA+ICBFWFBPUlRfU1lNQk9MX0dQTChrdm1f
c2V2X2VzX3N0cmluZ19pbyk7DQo+ID4gPiAgDQo+ID4gPiArYm9vbCBrdm1fYXJjaF9oYXNfcHJp
dmF0ZV9tZW0oc3RydWN0IGt2bSAqa3ZtKQ0KPiA+ID4gK3sNCj4gPiA+ICsJcmV0dXJuIGt2bS0+
YXJjaC52bV90eXBlID09IEtWTV9YODZfVERYX1ZNOw0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiAN
Cj4gPiBBTUQncyBzZXJpZXMgaGFzIGEgZGlmZmVyZW50IHNvbHV0aW9uOg0KPiA+IA0KPiA+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMjEyMTQxOTQwNTYuMTYxNDkyLTMtbWljaGFl
bC5yb3RoQGFtZC5jb20vDQo+ID4gDQo+ID4gSSB0aGluayBzb21laG93IHRoaXMgbmVlZHMgdG8g
Z2V0IGFsaWduZWQuDQo+IA0KPiBZYS4gIE15IHRob3VnaHQgaXMNCj4gDQo+ICBib29sIGt2bV9h
cmNoX2hhc19wcml2YXRlX21lbShzdHJ1Y3Qga3ZtICprdm0pDQo+ICB7DQo+IAlyZXR1cm4ga3Zt
LT5hcmNoLnZtX3R5cGUgIT0gS1ZNX1g4Nl9ERUZBVUxUX1ZNOw0KPiAgfQ0KPiANCj4gd2hlcmUg
dGhlIFZNIHR5cGVzIGVuZCB1cCBiZWluZzoNCj4gDQo+ICAjZGVmaW5lIEtWTV9YODZfREVGQVVM
VF9WTQkwDQo+ICAjZGVmaW5lIEtWTV9YODZfUFJPVEVDVEVEX1ZNCTENCj4gICNkZWZpbmUgS1ZN
X1g4Nl9URFhfVk0JCTINCj4gICNkZWZpbmUgS1ZNX1g4Nl9TTlBfVk0JCTMNCg0KV2hhdCdzIHRo
ZSAgZGlmZmVyZW5jZSBiZXR3ZWVuICBQUk9URUNURURfVk0gdnMgVERYX1ZNL1NOUF9WTSwgbWF5
IEkgYXNrPw0KDQo+IA0KPiBEb24ndCBzcGVuZCB0b28gbXVjaCB0aW1lIHJld29ya2luZyB0aGUg
VERYIHNlcmllcyBhdCB0aGlzIHBvaW50LCBJJ20gZ29pbmcgdG8gZG8NCj4gYSB0cmlhbCBydW4g
b2YgY29tYmluaW5nIFVQTStURFgrU05QIHNvbWV0aW1lIGluIHRoZSBuZXh0IGZldyB3ZWVrcyB0
byBzZWUgaG93IGFsbA0KPiB0aGUgcGllY2VzIGZpdCB0b2dldGhlciwgdGhpcyBpcyBvbmUgb2Yg
dGhlIGNvbW1vbiB0b3VjaHBvaW50cyB0aGF0IEknbGwgbWFrZSBzdXJlDQo+IHRvIGxvb2sgYXQu
ICBUaG91Z2ggaWYgeW91IGhhdmUgaWRlYXMgb24sIGJ5IGFsbCBtZWFucyBwb3N0IHRoZW0uDQoN
CkdsYWQgdG8ga25vdy4gIFRoYW5rcyBmb3IgeW91ciB0aW1lLg0K
