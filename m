Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D233757948
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjGRKc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjGRKcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:32:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF321B6;
        Tue, 18 Jul 2023 03:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689676344; x=1721212344;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3EKHm1wj7OVif5FBW2vJgqLI40RJHWYmkHDBdQqzxok=;
  b=msffFaqXH0JaHmxCXvzdZcAt/4wuPTztI+nfwX8vmwaWIPR6Xek9tt+e
   2AXelFUUmLQ+ngmkXdCVPFhb2TTNFSXNGLPt3BzKcRMJ4YqH+NJCXKzst
   9ppUt01C1nR+e2KIulLZwiGf58PTa9TfwKDOQPn9FXVy2tqMA99IZDuUy
   Z82R51GEZFDHYHrnm3CYoF+nA2zhUngrANwGwMStrzMU3vB9f6GyI58NM
   uov4DG9jRUaucvflN62dvek6nabo4bLeJESdLy6K10fuh+iNdqkfANddw
   wfFI7j3rvHfB/U0o9r4GbJdQfWWrnhjIfyxl7NweHbiKeHsU3eywhHwQl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="452548906"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452548906"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 03:32:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="813695472"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="813695472"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jul 2023 03:32:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 18 Jul 2023 03:32:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 18 Jul 2023 03:32:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 18 Jul 2023 03:32:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GX74LaojKwlLJ1nMLk17kZ5y7a4CXLMg/q/3PbAW+Lm8VyEKGnGF7P12N8o0QSbphOgk40Tj6VJAc3KXrzquxbwoC6kYbO5CEbRQ0xPMrvlSLulx7C6SCWFNvfKYs5rcD71RXI2SmUTDWTLvVvFuIvLYF60Ww9vhjdvjszzqwiBCcEl1mcejkY6eP4wL5kQEZigARVQ95ncnBjZ4E39LelxBhyCU7kZmKFaeopatOXWpUzHCM+vQED7b9VMDhpq9tRp/EzOC1g+OcxY5WJ2Y8wFwR0qFlvlxCaTIphXinTUDh8MeTNkuGLMJxRK5EyNLc8kLehgLwbJjQ1dkj6u/Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EKHm1wj7OVif5FBW2vJgqLI40RJHWYmkHDBdQqzxok=;
 b=hSQNEumjn/350zmx1u/2EB9k7mumrPjkzPk7ILDRjCNGc8D2Y9qLaTd9kn3d0OzzBEK7OdDEnIHsJMJWm6qRExIsc06R/LwRFwt9rL3z6dYEq/ObTFspbNab21rxB6zIM6gx5G7AgsEzzys8DcFGIavQN7pDvUgRx2h/6zji0J/1l+bO0q2EsWD32BHrOd+6qB/SB3urIMP30wxyAGan7gPviBmkYvtZxiVEY/B74jgZatR/R2Oz/nmbU27ada90XSU8/BFK6JNDo9INmrlaqVfFRjW+ckCReX+MmsPEPjtJb1w5CLHaBcPwGNTaGwH16Ha9R5zZBr/y96hIXV018A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB8272.namprd11.prod.outlook.com (2603:10b6:a03:47d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.29; Tue, 18 Jul
 2023 10:32:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 10:32:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL
 assembly
Thread-Topic: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL
 assembly
Thread-Index: AQHZtJ1x/DXmlypIv0ScbAwPZVWO1q+6np8AgALp8gCAAAdfgIAAD7KggAG9YoA=
Date:   Tue, 18 Jul 2023 10:32:20 +0000
Message-ID: <0cb00d72e7ebb0969a7ac10f6ade9eea20deaef5.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <c22a4697cfe90ab4e1de18d27aa48ea2152dbcfa.1689151537.git.kai.huang@intel.com>
         <b95c4169-88c8-219e-87b7-6c4e058c246a@suse.com>
         <71396c8928a5596be70482a467e9ba612286d659.camel@intel.com>
         <6b425468-3aac-0123-c690-df8d750ce29e@suse.com>
         <BL1PR11MB59788B70FC74249D9F45E066F73BA@BL1PR11MB5978.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB59788B70FC74249D9F45E066F73BA@BL1PR11MB5978.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB8272:EE_
x-ms-office365-filtering-correlation-id: 50c62513-751a-4dcb-ac88-08db877a4445
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z8DNoJ3JjuRhOn1hih87U/BXkNKUjLogvFLNqkoyrEWLd+cY1eNdfhP8kUmsSpzJ0h3TzJkRLDZWaaeGg5GcHVONg4lDin78fQyEvxt7SyJRktbDfwvk/DFYMlJCww7fFtkRxLg+c4xTjXPpi9X8V6rGL9yKpVFAYRmMCNaiSGCPY84388L3B6F07CSNqlcHw0VFtmEExqBu71YLbsHY+qHvnwaNRdDaVmseTPQoAPLnywiM0Fq5NebHMb/YFVTrEvjdZaBdwEJ1gkzgwsikcvf26pqcIG5iBMEEpYjACdrhaLsKy5J+CWYdzSh9qnRyZAD1oOFui8T8DO2gX1wy9I40bm+kweJ5tpnShhfZp5uieB50zb0G/ivHGF/WBH43TsnepNo6UN/lIyoyb+oU6e8W7dh5tStxESW7FkuEJXcZtr+/dVNcCd50/nPxNSnyh3jcsIGUuvDZlGuni+GL00fLppclticG750hFvTJy4uFtRdUxpfPO8mXe9PHAYF7kGUByXC4W6Um4jv/KvAq/rLVTXFeXObyIqEyUdkmDQF+KhDJfRaBmTFxd9Vtm7lZsthPo6Ga21lHY/nYXo+okveOS0EQsHud/926Hgde1UfpwU+hdA+NPJOjHhkZqcCK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199021)(38100700002)(82960400001)(38070700005)(86362001)(66899021)(66556008)(71200400001)(110136005)(91956017)(122000001)(54906003)(36756003)(6486002)(6512007)(76116006)(186003)(83380400001)(2906002)(6506007)(2616005)(66946007)(66446008)(478600001)(7416002)(316002)(66476007)(26005)(4326008)(8936002)(8676002)(64756008)(5660300002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3dvSVc4Z1ZKcEgyekt0RVhHUVFsYkxTREM3TkZQeUhqU2J0d2paOHNoTjQ5?=
 =?utf-8?B?M1Vqd0pPcVFOdUNROHBUNXZ0dnJid2dnRnM1N0RzRnFuSysvQ3dkaG5YbG82?=
 =?utf-8?B?eUFaN01ZUS9FQTBJcVpzL3RqUXBjMElFV290dnF1d3hOUUJGbDE0Q2JMY1lE?=
 =?utf-8?B?R0cyMDhyVnhqZDhBc1dwVXRTTE1MQjhnSlRGdFZOdjVPc1ZCY0lXV0dCM29K?=
 =?utf-8?B?WGxhRkUxKzd6Z0Z6c1dvb0NTUEszamtRTnlmV2h0LzZTWDJFT1RhWmN6cnVu?=
 =?utf-8?B?VXBYSzh1MlR2LzBkQlpWZDY0WXppZktaU2NNQjcrcXV5dGpNdUxudHl1Unlv?=
 =?utf-8?B?bytMbm96SG9LQkYvMHU1b1NwbnV1YXMvSVlIQ0YrSVczb3RSNmRJZ3dtMTB2?=
 =?utf-8?B?ZU5pUnNHOVVIRFE4R1YwRCtVeThpWkxXcGUrRVBkSEV2VHN6KzI5aGxicE95?=
 =?utf-8?B?SzJQRXdUbDdLLy9lK1M4ZUdFTGRWNDM0S0prcHdheUUvczFlTW9kMFpPVU1k?=
 =?utf-8?B?OEFsRVhVS3JZSmZMaWpoNXhlc25TZFNrREgxb1dESnIyazFwQm9Mb3l5RDRK?=
 =?utf-8?B?cUJBdHBONHFIbHIrQ1BlQU1YeHhLOVBia3p3cmNZS0lUR1ZaOElkWWR4LzFw?=
 =?utf-8?B?amt6MVVYVDZwYUlTclRYZW9GZEJUd0lBWGRvMlFGR2IzZXdmZmxFYUtWK1Zx?=
 =?utf-8?B?RDZOcWlOV1RqWm5vcWIrNjZ3ZmRUOTVvRWtrVCs5Ry8vR1VwUGh1MnMxcml3?=
 =?utf-8?B?bS9WWktYWEU2em41NmE2VFN0bmM0TkUzdWdLc1Z2WTZLZ0YveHI4OGU5T2pj?=
 =?utf-8?B?K0Q2UTdMVjAvdnpNS0d6T0cyRndGVUcwcTEzSXlFek1SdHhMVERUMEdvbXZv?=
 =?utf-8?B?T2ZhU0ZHc09lMUFUdHo3T3lqYTJwRllkVnQ5UzhjZjZqcVpBcURpZ29nRFUw?=
 =?utf-8?B?Wjh5d0VSYnphY011dUxyZXhUUkFKbjdWdVg3M2I3T1dtUmNDMUs2VGRQTTF1?=
 =?utf-8?B?T0xTYnhLSTFXdGRZZUFzSEY4bzh4TDlzWW5kN2dzNXNqVFFJVEtsN1llMm9L?=
 =?utf-8?B?SDg1MHVabnp0eGd4b2tyRTF4YU9nb0IzWmV1WUdhakNiQ24xTjFGZzZ5cW5q?=
 =?utf-8?B?YmJKM3E4SmtLa1JBZWlLeGJybm44bnZZQktNbzNFdzN6YUt2bkVHMHY3Z1VF?=
 =?utf-8?B?NFdIK00rMTFPKzJMeGlxVmVZc0xQOFhxWml3OTkzallpeTB0MlFoZFhTU2VG?=
 =?utf-8?B?NC9LQ1RCVmZHVmRsQm5HMXVuODNESzl6bldPUmxPQTVJM1NuckVmTUJQaGFr?=
 =?utf-8?B?Ukl6c0wwZWtKS3VVdUUvc0Y5Mml3aTdiRWFUL29qQTE4R2RJQWNYSk1Jb2pp?=
 =?utf-8?B?OFNhQTl6WEdPZkxrVkV6dEpFOTdBYllkdE9vaDlKUW5GMlRIZENaRFhjQngw?=
 =?utf-8?B?UFdFVVdMUm96WDNsU2R2SDRENENROEpKazRuOWM4UHpkcWlJSGR2ckc3N1FP?=
 =?utf-8?B?WTlrcHNUbFRwL0dYeGdWbXdramVSNHVYZFpOTE5mZ0hsMng3MitnaWR5NnlY?=
 =?utf-8?B?OUZDaFIvODRWeDVoUEM4Zk96RmhYeXJHS1lDbit2SU9hSjArOXRZU0F4M0R1?=
 =?utf-8?B?aTRoRVUvTDJLUTZxYTBVUVZ1L0Nrb3NzR3RSMVNRMWMrTmNHYjljaFpidkI0?=
 =?utf-8?B?NVF6UHFmVkswRmlNTlplRTVtMnZEVitockFUNVk0VXY3QUJvWU54YnBXbHFv?=
 =?utf-8?B?Mjh0aDl0bmkwcEEybXU2cWo5T0RBQXE0bCtZVlVObzNzRVFKR2oyVThDdlp6?=
 =?utf-8?B?T2FtQnYrV0hBV0k3dUJDQ2ovaE5WeWJFUWluN2pNbXJiaGRUSUVvZ1hBZVVJ?=
 =?utf-8?B?QTlKWCtiMFNWSzRYSXZyN1NFTWJYWW5rczRlYXhxbVY2Y3ZUYWRsNFpFd0JW?=
 =?utf-8?B?ZzRkU3dHeCs3MiswWk16NTB1bEhRMTZVY2pleWhpSTZBdTE0TEFIZ1lYeC9y?=
 =?utf-8?B?Nnl0QTFsbnE1Q1hQKzhrR1RWRjd1Q0I0QkVxUXVtNzZkb2E4YWNoUmw0TWdY?=
 =?utf-8?B?bEtkMGd5ekh3WmZyR0R1S3pqWWxPdkZFT2gzQ0xnR1RhNEZ6UkVUYXB5czBm?=
 =?utf-8?Q?0WUkWI+v+FISZxJ0BVxm/So7h?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <681A6B9BA17A5A489C05E9FCCCB80EE3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c62513-751a-4dcb-ac88-08db877a4445
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 10:32:20.3846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +lW7hbFs669BhB+LN30EdhSDwCLAC1oPP42Lcds3QkpdbdWcm+nCInjbuivimsOnW3fTzJt1h1y+NTbHYfr9Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8272
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA3LTE3IGF0IDA3OjU4ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IE9uIDE3LjA3LjIzINCzLiA5OjM1INGHLiwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IA0KPiA+
ID4gPiA+ICsvKiBDYWxsZWQgZnJvbSBfX3RkeF9oeXBlcmNhbGwoKSBmb3IgdW5yZWNvdmVyYWJs
ZSBmYWlsdXJlICovDQo+ID4gPiA+ID4gK3N0YXRpYyBub2luc3RyIHZvaWQgX190ZHhfaHlwZXJj
YWxsX2ZhaWxlZCh2b2lkKSB7DQo+ID4gPiA+ID4gKwlpbnN0cnVtZW50YXRpb25fYmVnaW4oKTsN
Cj4gPiA+ID4gPiArCXBhbmljKCJURFZNQ0FMTCBmYWlsZWQuIFREWCBtb2R1bGUgYnVnPyIpOyB9
DQo+ID4gPiA+IA0KPiA+ID4gPiBTbyB3aGF0J3MgdGhlIGRlYWwgd2l0aCB0aGlzIGluc3RydW1l
bnRhdGlvbiBoZXJlLiBUaGUgaW5zdHJ1Y3Rpb24gaXMNCj4gPiA+ID4gbm9pbnN0ciwgc28geW91
IHdhbnQgdG8gbWFrZSBqdXN0IHRoZSBwYW5pYyBjYWxsIGl0c2VsZg0KPiA+ID4gPiBpbnN0cnVt
ZW50YWJsZT8sIGlmIHNvIHdoZXJlJ3MgdGhlIGluc3RydW1lbnRhdGlvbl9lbmQoKSBjYWw7P05v
DQo+ID4gPiA+IGluc3RydW1lbnRhdGlvbl9lbmQoKSBjYWxsLiBBY3R1YWxseSBpcyB0aGlzIGNv
bXBsZXhpdHkgcmVhbGx5IHdvcnRoIGl0IGZvciB0aGUNCj4gPiBmYWlsdXJlIGNhc2U/DQo+ID4g
PiA+IA0KPiA+ID4gPiBBRkFJQ1MgdGhlcmUgaXMgYSBzaW5nbGUgY2FsbCBzaXRlIGZvciBfX3Rk
eF9oeXBlcmNhbGxfZmFpbGVkIHNvIHdoeQ0KPiA+ID4gPiBub290IGNhbGwgcGFuaWMoKSBkaXJl
Y3RseSA/DQo+ID4gPiANCj4gPiA+IFcvbyB0aGlzIHBhdGNoLCB0aGUgX190ZHhfaHlwZXJjYWxs
X2ZhaWxlZCgpIGlzIGNhbGxlZCBmcm9tIHRoZQ0KPiA+ID4gVERYX0hZUEVSQ0FMTCBhc3NlbWJs
eSwgd2hpY2ggaXMgaW4gLm5vaW5zdHIudGV4dCwgYW5kDQo+ID4gPiAnaW5zdHJ1bWVudGF0aW9u
X2JlZ2luKCknIHdhcyBuZWVkZWQgdG8gYXZvaWQgdGhlIGJ1aWxkIHdhcm5pbmcgSSBzdXBwb3Nl
Lg0KPiA+ID4gDQo+ID4gPiBIb3dldmVyIG5vdyB3aXRoIHRoaXMgcGF0Y2ggX190ZHhfaHlwZXJj
YWxsX2ZhaWxlZCgpIGlzIGNhbGxlZCBmcm9tDQo+ID4gPiBfX3RkeF9oeXBlcmNhbGwoKSB3aGlj
aCBpcyBhIEMgZnVuY3Rpb24gdy9vICdub2luc3RyJyBhbm5vdGF0aW9uLCB0aHVzDQo+ID4gPiBJ
IGJlbGlldmUNCj4gPiA+IGluc3RydW1lbnRhdGlvbl9iZWdpbigpIGFuZCAnbm9pbnN0cicgYW5u
b3RhdGlvbiBhcmUgbm90IG5lZWRlZCBhbnltb3JlLg0KPiA+ID4gDQo+ID4gPiBJIGRpZG4ndCBu
b3RpY2UgdGhpcyB3aGlsZSBtb3ZpbmcgdGhpcyBmdW5jdGlvbiBhcm91bmQgYW5kIG15IGtlcm5l
bA0KPiA+ID4gYnVpbGQgdGVzdCBkaWRuJ3Qgd2FybiBtZSBhYm91dCB0aGlzLiAgSSdsbCBjaGFu
Z2UgaW4gbmV4dCB2ZXJzaW9uLg0KPiA+ID4gDQo+ID4gPiBJbiBmYWN0LCBwZXJoYXBzIHRoaXMg
cGF0Y2ggcGVyaGFwcyBpcyB0b28gYmlnIGZvciByZXZpZXcuICBJIHdpbGwNCj4gPiA+IGFsc28g
dHJ5IHRvIHNwbGl0IGl0IHRvIHNtYWxsZXIgb25lcy4NCj4gPiANCj4gPiBDYW4ndCB5b3Ugc2lt
cGx5IGNhbGwgcGFuaWMoKSBkaXJlY3RseT8gTGVzcyBnb2luZyBhcm91bmQgdGhlIGNvZGUgd2hp
bGUgc29tZW9uZQ0KPiA+IGlzIHJlYWRpbmcgaXQ/DQo+IA0KPiBJIGNhbiBhbmQgd2lsbCBkby4N
Cg0KQWZ0ZXIgcmViYXNpbmcgdG8gdGhlIGxhdGVzdCBURFggY29kZSwgSSBmb3VuZCB3ZSBzaG91
bGQga2VlcCB0aGUNCl9fdGR4X2h5cGVyY2FsbF9mYWlsZWQoKS4gIFRoZSByZWFzb24gaXMgYm90
aCB0aGUgY29yZS1rZXJuZWwgKHZtbGludXgpIGFuZCB0aGUNCmNvbXByZXNzZWQgY29kZSBuZWVk
IHRoZSBfX3RkeF9oeXBlcmNhbGwoKSBpbXBsZW1lbnRhdGlvbi4gIEltcGxlbWVudGluZyB0aGUN
Cl9fdGR4X2h5cGVyY2FsbF9mYWlsZWQoKSBpbiBib3RoIGNvcmUta2VybmVsIGFuZCBjb21wcmVz
c2VkIGNvZGUgc2VwYXJhdGVseQ0KYWxsb3dzIHRoZSBfX3RkeF9oeXBlcmNhbGwoKSB0byBiZSBz
aGFyZWQgYnkgYm90aCBjb2RlLCBvdGhlcndpc2UgYm90aCBvZiB0aGVtDQpuZWVkIHRvIGltcGxl
bWVudCB0aGVpciBvd24gX190ZHhfaHlwZXJjYWxsKCkuDQoNCk5vdGUgX190ZHhfaHlwZXJjYWxs
X2ZhaWxlZCgpIGluIHRoZSB2bWxpbnV4IGNhbGxzIHBhbmljKCksIGJ1dCB0aGUgb25lIGluIHRo
ZQ0KY29tcHJlc3NlZCBjb2RlIGNhbGxzIGVycm9yKCkuDQo=
