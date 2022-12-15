Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7F464E477
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 00:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLOXGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 18:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLOXGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 18:06:31 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2AC220E8;
        Thu, 15 Dec 2022 15:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671145590; x=1702681590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3EDSJybtz6X2nZffTuywVrphzVosOqpmfHotlQklkXs=;
  b=EN4OHOgcnGVX6SJFkx3drYk9z//5/btEz3vzv8ob7/QT0/i1rzOtkdBG
   iW/xD1xzODY/xvX+gBb4/fO7LMCFXYGQYZTFGriQU2eI8CszIcEZBelnn
   5fO/d8bKX6LpRXIHvZZsEuISpyJtwqIl+uiKMkpJ10NzO28I0LTKoeuXy
   bt7w1lnSzgtRUzakjr7IEwNcrBhwplXu7opuIkA3hgvs82h0Cfj6rl9Ea
   HJ9aFbbZvx98w9R2U5IwmMNzOwj3mAQdw6Him+65Y57pSeq6LvOosdEwU
   w0dCt/e7rGuXfJRwHvHuzk3gyemeANeTlW7ooL/cUXf2nMEGOgwfrXy3r
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="319997669"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="319997669"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 15:04:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="682086916"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="682086916"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 15 Dec 2022 15:04:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 15:04:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 15:04:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 15:04:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFODu1I4grO7oU0gdTwNY7rKiV4lPp4cSG4uIh45eSVHGFSLC4oZ+7DfbTk+KuCu3vhxXkvQWkgC2c9+Kdbm06nab7kAOTMmFEAhKUxEOaTtMtHy/yuwaRpviVRsSY0pJVpkwRQNZm4csNE+L3T58HWOJDgu2dgyU2qn30ceOWTy9u20IUp1RIJPbW9XH9OF2OKDk0WBTS12ajawMia1bUdEhyOqI7mTYvESBxaNAghxh8+SI2C3DxBiQ1zBU8w/pMWTZCwYxwhnahadGL+96vZ9IGe9UGyPA4DIm8R7NEmhA4hFFFOXlXYxJusJOxFmchtIAAIASBuA8A4/vTRSOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EDSJybtz6X2nZffTuywVrphzVosOqpmfHotlQklkXs=;
 b=iFO9FQESdC0k9V4txPj4gYChTdkmpMduRo0ty/Z0zdz2OYlV65HKQWl0VQVihvIsfVNycqhajG4hT/Z2kk45yLhqiGSezax1Ce0iqCoEB8QTJb+v4aRn+9FM9VwVRyHpF7jcUOFpsoypbUIQLXrVQZ5fTTauC+/kFE2GZ+i1XHjMezvzKAawfGst91tURGmzSRmbwtzFcumwLocGfQTn/iyydTzAQPF1othXK5nIS/LYebpEP7UiqSeSUa7SK/2jJkXFiSmmNHvOFspSilwbAd4yG6NCwu2lrHm1XERnNHboZZO7dUbbPIPFReamA+9oOrm+af76tCVeYFkqsI2U3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6439.namprd11.prod.outlook.com (2603:10b6:930:34::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Thu, 15 Dec
 2022 23:03:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 23:03:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v10 047/108] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHY7CiGPKQ26x0OSk+nInOi8x3lUK5tgv+AgAJSvwCAAAT3AA==
Date:   Thu, 15 Dec 2022 23:03:59 +0000
Message-ID: <2568e8f578ef7c7e6a7bb9902ede7efb75305f04.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <9e8346b692eb377576363a028c3688c66f3c0bfe.1667110240.git.isaku.yamahata@intel.com>
         <f3cb9b24c24122c590dd4ba27434b5c069f00372.camel@intel.com>
         <20221215224612.GI3632095@ls.amr.corp.intel.com>
In-Reply-To: <20221215224612.GI3632095@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6439:EE_
x-ms-office365-filtering-correlation-id: a80cbd08-ae3c-4171-4abb-08dadef0a6a3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HIvEZBbdI8xGpn3xcuM1wdXGwta8H6miioRZ4q3fLEhmqN0598GYQnJAVIXsq8fFI8LSeQDY64HQcR3q1hwXrusyxm+Sk4DzvmxUgtmYFmEWhqOgEYyzRcVKqDxI06/jM0EQpuGQYgchkvGtTv8DADXoROAlLFaexEYe8Wl8TXivsdZSeO4VdoSlPUUrNrIHxXYJi46hhzehZFQ4VhzEIgLURHW7ctKppobRWnxjz24gCAkIayTwm5h+ZQHMLPeYk1ibU9K4l8uNzuGFud4VMl77mkL5nD/a1KDN7uRZZ5PSlfxB1EGMB6qBAEYBnjwhNtswCPsAcdQ3B8n7hT3UW3+2fMu/BCeOiQ1GscAzJ/M8KTDRwLhcmkyMY0jSNBleOeIuBhSd6upl+pHuvkaxRWvBBtJJeE4CnJbStBep1QjO2emJZQUH/ObMRQrhcyaYOLscpS762RcGcN44UOrhqL9OLJ9OVWM0XlUrmSq3uAxeUFEQXo8+AmP41Kehzd7oyNgd072SJxkN6iEXAcWbKnP59D4cINEu2xmNhG1uVS/YFteAeUZynZVDJ51+bG8GskrNBY6oCyGbjnIJCAJwJ7MHMeyzv8LcNhi9d4HAYLYm8O8vZz75txNYagwU69qxsHfQn1RRkrBN6GoxVFzCQ3vy3Mc0pzPOw4rJlazKI/I5FXOAWGMWr74PuRMcRmA6YKIyyFhBrHJwlk85k5QgxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199015)(8936002)(41300700001)(4001150100001)(82960400001)(38100700002)(122000001)(5660300002)(83380400001)(64756008)(66476007)(66556008)(66446008)(91956017)(2616005)(4326008)(66946007)(76116006)(8676002)(6916009)(36756003)(26005)(316002)(38070700005)(6512007)(186003)(478600001)(2906002)(6506007)(6486002)(71200400001)(86362001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjB6V0ZIamN2dk5mK0pTU3Q3YVhPK2hjL2YybnVGMmdFUGVUa2lCVmxuVEZB?=
 =?utf-8?B?NkZjWGNXWUhxbUpxdXNyMkdWZWlhSmRVN3FwV2dGRnh0QnhEaXR5T3pOdHAx?=
 =?utf-8?B?TWpGSlhudVR6YzlDU01LTXp4dzVnUlNqRDlxdm54WXIxQXRaOVpPUXVWWk81?=
 =?utf-8?B?MldkejVNNjlxL25SQTVRTm1sQXJSL0YvMVIyVGpEZFN1QmF0ei9hMW9jbHFR?=
 =?utf-8?B?YlpYd0M4dEpLNXpuWXYySDQrV3RPMmZOTWpGWWRWdXp0V3d0azJaYS9TNVd1?=
 =?utf-8?B?N1pLRmpKOVl4bWF6UHZ1UXpoeVd5cFJ3N01zZGxSY2dEMVpzMWU4RGFrMXc0?=
 =?utf-8?B?Q05WUm1wc2MxMkJvS3UxeWVnQUtHT3hEeUxrZ0kyZU9xOERXcjhodk5FVDJa?=
 =?utf-8?B?UlJsTEdFVWNMMEJ2L3pWU3UvcjJQS3JUTnZOZWh4OHg0cGJ2MWZHVmtmdEdn?=
 =?utf-8?B?Y1dNNVdGeWJ0QXUreDhRMHNlUi9idjNUeHZqKy81dW4zRjc1Umkwa2pxVnlo?=
 =?utf-8?B?MzVnSVJJS1BxbGE0aC9RTWlnMEtNK1M5MnZpT1JBOHM1VFhmR0kxQTFsR2pi?=
 =?utf-8?B?QVdRMVRZbkxFNVRGTll4TnVNbzlUNnZCeHc0ajlUcENERUd5Z0E1aHpHdXBB?=
 =?utf-8?B?THpMeUg2a01RUzI1Ly96UWdERlh2K091ZUhkVlVqQXJ3SlJ4TDJqTGRDbk9B?=
 =?utf-8?B?aGEvMkNGei9mbEdPeUs5SStkL2c4Vytndys5S0dUcDMvUHoyZzh3S3FqMzVD?=
 =?utf-8?B?YzA1ak9ucXk2aGs1UDJSR0xzKzMzb1k4cTZFcmVSc241MTlnbnNDSEpnaGJK?=
 =?utf-8?B?Qmk3NkFsWW8xVWVjMzFLdVQ1VS9UQTMzYWxhUUh4K1AweHNhV1AwcFZQaFNp?=
 =?utf-8?B?R0g2cG9oN1g0TG8xUkdKYkIrMmo1UWVNQWp0YnlDSVdtUlhaODhqcUxTSFdF?=
 =?utf-8?B?VkdKTDV0REYrdGNlNEQwWXF1bGhXZ3JqQTBPTnlYdWFGUGdoRXhUZ0ZOQXoz?=
 =?utf-8?B?NGU1ZDM1bWUwY201cnBlNlpwVEpBQ1paQ3VBcWNxbVBVMGhmNTRuamJQeW1r?=
 =?utf-8?B?cVFPd25sbWNnNFdGOFkzNDhpWHdYT0lpbzhtVDlERDNUQytKZWErMFRDMFNM?=
 =?utf-8?B?YUlkRzFpZ0RPekQ1U2psMzljL2lsUjkzY1VNelVvZjB2ZUpyb2s3cnBHdjY5?=
 =?utf-8?B?ZVV4K1dteEd6YUpYcGs3NlFSdXFjYld3Vm5za3hEeVMzL044Y3ZjNE5tM0wz?=
 =?utf-8?B?R2VJYVl0VHZVZkpVUVorR2lMaXZ0OHFrcjV2Zm50UElLLzBBUEF5a1NNUTM4?=
 =?utf-8?B?ZndvT1VmQmdYNTk2TGNRVmhsc0JVSTAyNEVneGsweDd3Q0VuTWlHWmhZREYv?=
 =?utf-8?B?MnBEdDRuWkd6Qy82ak1DcnpvR05xVE9XbGdqcUdoWUVRNk5TMVUycTJaS3Y4?=
 =?utf-8?B?cEM3SkNHVDQ3MStqN2k3c3VIS1ZoZU5WTERUK3BxRC8rRUYzakFrUlRGMHI3?=
 =?utf-8?B?N3Rjc0ROM3JlN1RtaFhrMVRVNGxrMUtqSm9YTWVLbXlsczh3eERBUStEM0la?=
 =?utf-8?B?VmN1Wi9hTUhDRklpc0ZUZDRHaTNDazVKWmdNd29pVEVzdDdyb1M0dmxMZlBC?=
 =?utf-8?B?YU9ZRW04UEJEb2dydkQ1ekQxOExzNDE4eFJjSTZod0xPcTI4R2tpeDEwMWhi?=
 =?utf-8?B?YnRYbXV3VEEwTU8wVVNNTVVITWJ1UVlqWGRzU2o3a2h6R05iR3dmRW1obG9U?=
 =?utf-8?B?QlVMSGdnVzYwQkNmU0EzKzBCcnYrY2I1N2xCa2N6Yzk1OTViYkZrN3JDZzdO?=
 =?utf-8?B?RVV0LzR0ZlNRTktVb2NNelgzQk9kaXdISTgvbGJSOSs3S2daYUExdTNvSVJr?=
 =?utf-8?B?QzJUY1BndHY1S3NDc0J1cjlPR1Y1cXhaOFlFTW5ldDMvcTUrMzVVdVBqMHN5?=
 =?utf-8?B?alIrbVRycnVzcE5TZ2NzQUxtUHFNL0ZkY3YxbUpUdnZTRkRHM1RZYzl1QUZU?=
 =?utf-8?B?MXNtQmJkSVhEblZVcisvWURwaGJXVW5jY3dyS1dRVjRIYjJEMlJaRlZXOGFL?=
 =?utf-8?B?akRpSXpwUUZKa0lYOXlkNFVrZ2VEZ20zOG9WUWhuaW11RW1ZZ3QrTHEvSWdq?=
 =?utf-8?B?bEo3T3UzVldOL3d4S3lJb05XYVpDL05rNTE4V1dCMUQvbm9TMC93dlFpLzAy?=
 =?utf-8?B?OWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD4EE4BF714EDB49A1289D059FAA5E1A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80cbd08-ae3c-4171-4abb-08dadef0a6a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 23:03:59.5270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bbVJlxVpYdMYqPN88vgQHMCu39Fvmotl7VxucmXGO5tETBuOb3cabbvjmBLhh6xEZdvD2ezN5wkiPuSviQCdpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6439
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTE1IGF0IDE0OjQ2IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBCdHcsIGFzIHlvdSBtZW50aW9uZWQgaW4gdGhlIGNoYW5nZWxvZywgcHJpdmF0ZSBtZW1v
cnkgYWx3YXlzIGhhcyBXQiBtZW1vcnkNCj4gPiB0eXBlLCB0aHVzIGNhbm5vdCBiZSB2aXJ0dWFs
aXplZC7CoCBJcyBpdCBiZXR0ZXIgdG8gbW9kaWZ5IHVwZGF0ZV9tdHJyKCkgdG8NCj4gPiBqdXN0
DQo+ID4gcmV0dXJuIGVhcmx5IGlmIHRoZSBnZm4gcmFuZ2UgaXMgcHVyZWx5IHByaXZhdGU/DQo+
IA0KPiBNVFJSIHN1cHBvcnQgaW4gY3B1aWQgaXMgZml4ZWQgdG8gMSwgUEFUIGluIGNwdWlkIGlz
IG5hdGl2ZS4NCj4gTVRSUiBhbmQgUEFUIGFyZSBzdXBwb3J0ZWQgb24gc2hhcmVkIHBhZ2VzLg0K
PiANCg0KQnV0IG5vbmUgb2YgdGhvc2UgYXJlIG1lbnRpb25lZCBpbiB0aGUgY2hhbmdlbG9nIG9y
IHdoYXRldmVyLiAgVGhleSBhcmUgaGlkZGVuDQppbiB0aGUgc3BlYyBvciBpbiB0aGUgbGF0ZXIg
cGF0Y2hlcyBmYXIgYXdheS4gIA0KDQpBTHNvLCB0aGUgaGFuZGxpbmcgb2YgImxvYWQvc2F2ZSBJ
QTMyX1BBVCIgaW4gVk1FWElUL1ZNRU5UUlkgVk1DUyBjb250cm9sIGlzDQpkaWZmZXJlbnQgYmV0
d2VlbiBURFggbW9kdWxlIGFuZCBLVk0uICBOb25lIG9mIHRob3NlIGFyZSBtZW50aW9uZWQuDQoN
CkFsbCB0aG9zZSBtYWtlIHRoZSBwYXRjaCByZXZpZXcgc28gaGFyZC4NCg0KPiANCj4gPiBJTUhP
IHRoZSBoYW5kbGluZyBvZiBNVFJSL1BBVCB2aXJ0dWFsaXphdGlvbiBmb3IgVERYIGd1ZXN0IGRl
c2VydmVzDQo+ID4gZGVkaWNhdGVkDQo+ID4gcGF0Y2goZXMpIHRvIHB1dCB0aGVtIHRvZ2V0aGVy
IHNvIGl0J3MgZWFzaWVyIHRvIHJldmlldy7CoCBOb3cgdGhlIHJlbGV2YW50DQo+ID4gcGFydHMN
Cj4gPiBzcHJlYWQgaW4gbXVsdGlwbGUgaW5kZXBlbmRlbnQgcGF0Y2hlcyAoTVNSIGhhbmRsaW5n
LCB2dF9nZXRfbXRfbWFzaygpLA0KPiA+IGV0YykuDQo+IA0KPiBPaywgbGV0IG1lIGNoZWNrIGl0
Lg0KDQpZZXMuICBJTUhPIHlvdSBzaG91bGQgcHV0IGFsbCByZWxldmFudCBwYXJ0cyB0b2dldGhl
ciBhbmQgbWFrZSBhIGNsZWFyIGNoYW5nZWxvZw0KdG8ganVzdGlmeSB0aGUgcGF0Y2goZXMpLg0K
DQo=
