Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924295A607F
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 12:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiH3KQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 06:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiH3KQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 06:16:29 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6AFF4397
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 03:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661854404; x=1693390404;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KhYTU1Mz+eGkrotpxwFaNrDvAfjVM4SMgsY9tCs8t5c=;
  b=CqPtAAgMr21d2ofoG+Cwl325CTaOA8I34YIPd2Eb4ddnvsdGVlHu4MqP
   WiBeTMzCQ9THOnMBqXcej+qZA6/rGFjc3/hA9fPPI0oDgyJ+dbbhH43eY
   /GH6US0A7/CgpPfTVmkL61/aN/X6yd+HmgnZfmncp7/B3KdaAaaGXrGBx
   xG3njUn0KCPP03qTWL0iKMscmzHOmnE2jDXadd6AyL93KbPH+aHCykgor
   GxxqyqEzq1SWbeiDPLqN29NJktyuidC6Q5yV+FNOar3uHMJkYJ8YVVYCC
   ZgfsAZn/ncfDl72VY7N3oDkS8HHMCQbUPaKHPZKymbBU9jvCoC+aJON8+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="275537865"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="275537865"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 03:12:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="562588814"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 30 Aug 2022 03:12:49 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 03:12:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 03:12:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 03:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lifV5A5uuyWrOSjvZEaeQd8pOrpF2iMetPvsplEI7rSYIo1zrlL+uijFFzKxPdbiY5KWLjCqc7qr4FEPMGewXJ6yF/hj5rnwj8Sb9RN++tDOV4LK5QK6RnYkgevslJld1KrlKENQr8tMQv11tVOU1naPwxUHqXpB/L5Pc3EOHoWuBHdQoaU+CW1XnO9O4NAbrqNlbOlcp1YGCVrlqvzSg0Wni22X/ZWlr5n0D3lwTEOCulHFf/91N/JizKLrYkAx3y4JiX0kqqH8+ynZ9l/MhqI+UzwFuKn8OkCAD63CTa3kJm8+LBgqoFaZYmlEvgy9vCyzVy9KoA8DRB5YTjchIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhYTU1Mz+eGkrotpxwFaNrDvAfjVM4SMgsY9tCs8t5c=;
 b=E/srvU16d2+nFPldepQxV0Q+hTxMeUSUSoailRG4SrbrSK5M7Lsx2kLZwmqN4oSvKGke9n1cWU7DcO1EE0rNvSsNyFMUZUJXaIKEIix92ac8W6Ap1IU6koYx4++nnFcowBuZUTSY7/X7afulA2iJDkkCkWCR3KKlVLJ0IAmBBZtIQ0g/OATd1t+GgpncAW0eRXGD7EXkz/DNBwygSX626ESeQArWPGCE9r5m6svUL6u8BjqoTRX0wWYAUF1qdnGKtme4C9ZmLVPfitcK0lFlOylldYFtfB07DePpqKWNTiwc7R/xhNdEtAJAVnmCyLakuBnl6xN59wxGf5XNGKRc9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB3193.namprd11.prod.outlook.com (2603:10b6:5:57::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 10:12:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%9]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 10:12:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Topic: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Index: AQHYuaFVUKotwXOBH0if+KDdPORKha3HPtWA
Date:   Tue, 30 Aug 2022 10:12:46 +0000
Message-ID: <2433d3dba221ade6f3f42941692f9439429e0b6b.camel@intel.com>
References: <20220826231227.4096391-1-dmatlack@google.com>
         <20220826231227.4096391-2-dmatlack@google.com>
In-Reply-To: <20220826231227.4096391-2-dmatlack@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8cbad16-d404-436a-499e-08da8a702f9d
x-ms-traffictypediagnostic: DM6PR11MB3193:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: akd45EZaWLPR11Q7aNPfrbTsw3gGc/O74S+lGuPoFX877AITDIaSpPMab37uHeqoqKE7h3oFaZA5fQjN5NfhcB063BSTg5c28ejihvm+CC5cC9FMld79HIBIqpKK2cNr6gzmGDjT+lbSlVQyIjT3TmSFXlEvSPYDHsPiCdlUOsi01wzzksP3ajfyv/S8LPyJtknwQU2hPVoxJdsFc2BTH7y29Uka5Kd9X26G+4u0u6UL7EdhtYKETZe76/k3B1pdNH0eQMMS/JKtJDE4VGegNBl9cjs1ompLbvZU6Hs+F/ietIm4Zk9/T5rP49vfzhzIFHO7r1nTkeuhviF/7C655WDvm4mdNQCtwATGkRGD6Vg6B9oDAyivMQGcCCk8rvBFvvYYixv/ACleOO9Mx3CHsEgNfzCBYJcW23s37i+mtLANBpl9hpNZkYHh/QOD+AesF53X+y/JDha9+ozfDT+2BnX4NeZEkTDzPptEhH+Uv0dW6zK5+ODRZfo6I9ZuKjX5wD/x8WWd/AKbsdUAkK9l3D6Xc0k2ephStW7KsDpWlDJaYoTpCUlxlYyoE8+CuDEhWnV6XB44q6pcZBLRPvPzCSQCLEZV07myfelww9DyxXECKVZJy+vXf+SqX1R/RVEAbryhvuAT8CsuTjYkz9ckg31XE20sDTlqK7QvG9WfzFKejrJBua9V3qhLbbx7FAh4Ml49Bmof8Wo1vs76EtDAmW2+vqDABhC7AxAcnLynpWicVVOgiZxPzPPHDnPPaXJN7f3o8k/2PnBG8b7yjwnVew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(376002)(396003)(366004)(122000001)(38100700002)(26005)(6512007)(82960400001)(316002)(41300700001)(5660300002)(478600001)(86362001)(8936002)(38070700005)(6506007)(2906002)(6486002)(64756008)(8676002)(4326008)(66476007)(66446008)(76116006)(66946007)(66556008)(91956017)(54906003)(110136005)(2616005)(186003)(83380400001)(36756003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1Y3bFFZRXdHNUtSNlZyNi9TZkZ0cUhOMDEyZklWY2EwbVNPcXRncHFQNjhG?=
 =?utf-8?B?dFFRUDhmTlNPREp4b01acTJUaWc3Z3dsdHB5Rzd1K0dFNXpRK3V5MGNiem04?=
 =?utf-8?B?Rmk3Ynp4NDFaOHQyTUlHTEJmamFRbjRqdVBoN05RYUZNMS9PdTZGcU5iRkZp?=
 =?utf-8?B?Tk5OSmRXY255ZmxQZkJlWlZQTkFLK2NtYU9lQlRiclZxY3RZVDkwKytpcW5G?=
 =?utf-8?B?emlqRk0rNGR2TEJHQ3BCMk53MkE3RjVOcURFUGdKL1VHb1ZOd0ZyaVNBcTZV?=
 =?utf-8?B?UHhJKzlYUnNmeGlRcWdxeERQUmRxdEpTUCs1NHRBaFh3dGFLREkzcmhOMEU5?=
 =?utf-8?B?WUNDOGxCbzFRSkxMcnp6aXIyVDFiRWRwVlloUFF6ZlJYcTRvdWZnZXpXQW1K?=
 =?utf-8?B?RXR5ZnlBanFLQ05la25iVzRudzQyckVpTVRwN21Oa2xDSFNzNHhobE5FVHlD?=
 =?utf-8?B?aDlxcTEwTWNPckxJRWoxRGYzaWk1NzZOS1o4anN5SG14V3V6V0dqMUZaaVAx?=
 =?utf-8?B?M1k2VWZVWE1iblhnVkYrRTFUaFF0bHBFdEdIRzJBN2p5MVZrdkFKS3lYdkxo?=
 =?utf-8?B?ZFRuWXh5WkllRnBkWDlENlhLVmZ1aWdQcEpBU0h6Y1NBclgxcHdQTFhMZmM4?=
 =?utf-8?B?WU9EMFJIOGtpeTY4cHZhNGt6UXdCZ2VyRnRuWkpHWU9wQk1sQ09QS1ZRT3dH?=
 =?utf-8?B?N2dSS2RNa1JsRXRuTWVlRTdLQUdGajJIV3k2NVp4a1VORG5ZK2c0cHoyVmZG?=
 =?utf-8?B?YklRNnpFcmdtSUJFR2NSNm8xcmFTOW1uVWtWN2ZDSytzNktmekNtSFpVVjFt?=
 =?utf-8?B?M2V2VTdEMCsxMWh4QVdRZ0ZRbEUrVUtKQVpwSG1BdUtiZ3dHekt2ZndlYytt?=
 =?utf-8?B?ZkwvZFQ1bHhqSi92akhzV0RUUFo0UitPNy9vdkNFeDU0NnYxR3NSUUs5VTNI?=
 =?utf-8?B?Y1U2U3lNaFZNdUFqTjdXZncrbCsyUEZ2UDlZYXFDaFV1Y2RSVWhubUVvRE9k?=
 =?utf-8?B?LzcrYnlhUk1MOVpuL0RqUUh0YlUxVWl5d0NYOUdsb3Y2Tm4wSzdCYjVidSs3?=
 =?utf-8?B?c1NjZGlOY08rUkkvM3JVUTR0RDJVVU9jRURUSFBad1c5ZUx3M2NxRndoM3FF?=
 =?utf-8?B?SW16cm9rMmlxYVo1UkFhODlxYWdkYll0WE45aS81aDVDVEJncmlKS2VWQyt1?=
 =?utf-8?B?amFBUVlRcnEvU3BCK0RJb0R4dmpvREVrTTloQnp3QUd4NjZCSnlUd09aanNz?=
 =?utf-8?B?WENQdFVjWnFKM2hmQWltY2lYL3VHak53TVpYVXcxYW1VVm9RWUczWGkrZ3FZ?=
 =?utf-8?B?QTJrZW9OdkQ1SWd3aFNxQmNQeXdTVWhjMi82OE9NNHJ1VGI2Q0FNRU5rSmlC?=
 =?utf-8?B?cEJDZ2hCNHZLOURmUnpRbDZtTmZibk11d1Jjekg5QmYreU4rR1BBb3V2YWtK?=
 =?utf-8?B?NWdSak9SdUUzbWxWclBYaEZRSlhoMzdMMnhIV0w4eFJzSEV2SUYzNUM1TzVN?=
 =?utf-8?B?elJpQXVlRGlsOGpYd25Ibk5FcmFKYXR3T2ZaZGU5MFljcmUyVS8zVW5PdnlF?=
 =?utf-8?B?c3lrczdEZ2lBTWNVZW5FWkwrSnRRNlpmRVVtblM3S2tQRzNYVkh2UVRDMkRu?=
 =?utf-8?B?b1Z4NTROd0hLV3pYSkJ1UjAxcXlhZEZkVk4vZDZKeWQwbVZTdTBnUXRoQWRs?=
 =?utf-8?B?b3ZjQ0t6aS94dVo0N25TT2wzMXVHaWYwMFpNR0hndlZseVBwenFPK2NHclBy?=
 =?utf-8?B?SlFXbmN4ZDVpQU0yS3hMK3RRWitBVTdOTFh1dWpZZGd4aUFnbHBtN1hTTUdE?=
 =?utf-8?B?bkJWVW9hQXFlQkRaKzhLMWtQd2hiYjVuTU9veW40ZlZIVUtyemZZWThhclZO?=
 =?utf-8?B?eDFGcW8xNEtlTFRwM0F4c2dab2R0eXFDVWI3bS9tbHRIOWZrc256RkFPeG5O?=
 =?utf-8?B?MlM5aTJwMEhsVkZ2Z3pyT2ZTY21XK3pud1Q2NjRLWURzL1pGNXcrWXBJZnVE?=
 =?utf-8?B?eDlzTmNPUGszNllveUp6VjJaY2V2MExOTzNPY0dZZU40Y3orVGVmK2F1bEFD?=
 =?utf-8?B?bFpLTTVDcFlWcENTcjZGKzhJSjR1RGNYS3V4KzlTYzhXWVczTjJVTjlKaW1R?=
 =?utf-8?B?TERkak5Pd2RWby9XOUlwS1R3eVQ2QnNBTytYbm0zR1c1eHZISkVkY0dnQTdk?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39C5C2165292C9449CEDFA58A0A5C647@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8cbad16-d404-436a-499e-08da8a702f9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 10:12:46.5528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1NMnMqzzOiLr2ZQTZlJoHkP6icatgMu3srXiwteTqiatCK6GezfeLHG8VZ3fHsjxoh1ts8k3NVHlN/lmBcWYpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3193
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

T24gRnJpLCAyMDIyLTA4LTI2IGF0IDE2OjEyIC0wNzAwLCBEYXZpZCBNYXRsYWNrIHdyb3RlOg0K
PiBDaGFuZ2UgdGRwX21tdSB0byBhIHJlYWQtb25seSBwYXJhbWV0ZXIgYW5kIGRyb3AgdGhlIHBl
ci12bQ0KPiB0ZHBfbW11X2VuYWJsZWQuIEZvciAzMi1iaXQgS1ZNLCBtYWtlIHRkcF9tbXVfZW5h
YmxlZCBhIGNvbnN0IGJvb2wgc28NCj4gdGhhdCB0aGUgY29tcGlsZXIgY2FuIGNvbnRpbnVlIG9t
aXR0aW5nIGNhbGxzIHRvIHRoZSBURFAgTU1VLg0KPiANCj4gVGhlIFREUCBNTVUgd2FzIGludHJv
ZHVjZWQgaW4gNS4xMCBhbmQgaGFzIGJlZW4gZW5hYmxlZCBieSBkZWZhdWx0IHNpbmNlDQo+IDUu
MTUuIEF0IHRoaXMgcG9pbnQgdGhlcmUgYXJlIG5vIGtub3duIGZ1bmN0aW9uYWxpdHkgZ2FwcyBi
ZXR3ZWVuIHRoZQ0KPiBURFAgTU1VIGFuZCB0aGUgc2hhZG93IE1NVSwgYW5kIHRoZSBURFAgTU1V
IHVzZXMgbGVzcyBtZW1vcnkgYW5kIHNjYWxlcw0KPiBiZXR0ZXIgd2l0aCB0aGUgbnVtYmVyIG9m
IHZDUFVzLiBJbiBvdGhlciB3b3JkcywgdGhlcmUgaXMgbm8gZ29vZCByZWFzb24NCj4gdG8gZGlz
YWJsZSB0aGUgVERQIE1NVSBvbiBhIGxpdmUgc3lzdGVtLg0KPiANCj4gRG8gbm90IGRyb3AgdGRw
X21tdT1OIHN1cHBvcnQgKGkuZS4gZG8gbm90IGZvcmNlIDY0LWJpdCBLVk0gdG8gYWx3YXlzDQo+
IHVzZSB0aGUgVERQIE1NVSkgc2luY2UgdGRwX21tdT1OIGlzIHN0aWxsIHVzZWQgdG8gZ2V0IHRl
c3QgY292ZXJhZ2Ugb2YNCj4gS1ZNJ3Mgc2hhZG93IE1NVSBURFAgc3VwcG9ydCwgd2hpY2ggaXMg
dXNlZCBpbiAzMi1iaXQgS1ZNLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgTWF0bGFjayA8
ZG1hdGxhY2tAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1f
aG9zdC5oIHwgIDkgLS0tLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11LmggICAgICAgICAgICAgIHwg
MTEgKysrLS0tLQ0KPiAgYXJjaC94ODYva3ZtL21tdS9tbXUuYyAgICAgICAgICB8IDU0ICsrKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KPiAgYXJjaC94ODYva3ZtL21tdS90ZHBfbW11
LmMgICAgICB8ICA5ICsrLS0tLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCA0NCBpbnNlcnRpb25zKCsp
LCAzOSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9rdm1faG9zdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiBpbmRleCAy
Yzk2YzQzYzMxM2EuLmQ3NjA1OTI3MGE0MyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5o
DQo+IEBAIC0xMjYyLDE1ICsxMjYyLDYgQEAgc3RydWN0IGt2bV9hcmNoIHsNCj4gIAlzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKm54X2xwYWdlX3JlY292ZXJ5X3RocmVhZDsNCj4gIA0KPiAgI2lmZGVmIENP
TkZJR19YODZfNjQNCj4gLQkvKg0KPiAtCSAqIFdoZXRoZXIgdGhlIFREUCBNTVUgaXMgZW5hYmxl
ZCBmb3IgdGhpcyBWTS4gVGhpcyBjb250YWlucyBhDQo+IC0JICogc25hcHNob3Qgb2YgdGhlIFRE
UCBNTVUgbW9kdWxlIHBhcmFtZXRlciBmcm9tIHdoZW4gdGhlIFZNIHdhcw0KPiAtCSAqIGNyZWF0
ZWQgYW5kIHJlbWFpbnMgdW5jaGFuZ2VkIGZvciB0aGUgbGlmZSBvZiB0aGUgVk0uIElmIHRoaXMg
aXMNCj4gLQkgKiB0cnVlLCBURFAgTU1VIGhhbmRsZXIgZnVuY3Rpb25zIHdpbGwgcnVuIGZvciB2
YXJpb3VzIE1NVQ0KPiAtCSAqIG9wZXJhdGlvbnMuDQo+IC0JICovDQo+IC0JYm9vbCB0ZHBfbW11
X2VuYWJsZWQ7DQo+IC0NCj4gIAkvKg0KPiAgCSAqIExpc3Qgb2Ygc3RydWN0IGt2bV9tbXVfcGFn
ZXMgYmVpbmcgdXNlZCBhcyByb290cy4NCj4gIAkgKiBBbGwgc3RydWN0IGt2bV9tbXVfcGFnZXMg
aW4gdGhlIGxpc3Qgc2hvdWxkIGhhdmUNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUu
aCBiL2FyY2gveDg2L2t2bS9tbXUuaA0KPiBpbmRleCA2YmRhYWNiNmZhYTAuLmRkMDE0YmVjZTdm
MCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL21tdS5oDQo+ICsrKyBiL2FyY2gveDg2L2t2
bS9tbXUuaA0KPiBAQCAtMjMwLDE1ICsyMzAsMTQgQEAgc3RhdGljIGlubGluZSBib29sIGt2bV9z
aGFkb3dfcm9vdF9hbGxvY2F0ZWQoc3RydWN0IGt2bSAqa3ZtKQ0KPiAgfQ0KPiAgDQo+ICAjaWZk
ZWYgQ09ORklHX1g4Nl82NA0KPiAtc3RhdGljIGlubGluZSBib29sIGlzX3RkcF9tbXVfZW5hYmxl
ZChzdHJ1Y3Qga3ZtICprdm0pIHsgcmV0dXJuIGt2bS0+YXJjaC50ZHBfbW11X2VuYWJsZWQ7IH0N
Cj4gLSNlbHNlDQo+IC1zdGF0aWMgaW5saW5lIGJvb2wgaXNfdGRwX21tdV9lbmFibGVkKHN0cnVj
dCBrdm0gKmt2bSkgeyByZXR1cm4gZmFsc2U7IH0NCj4gLSNlbmRpZg0KPiAtDQo+ICtleHRlcm4g
Ym9vbCB0ZHBfbW11X2VuYWJsZWQ7DQo+ICBzdGF0aWMgaW5saW5lIGJvb2wga3ZtX21lbXNsb3Rz
X2hhdmVfcm1hcHMoc3RydWN0IGt2bSAqa3ZtKQ0KPiAgew0KPiAtCXJldHVybiAhaXNfdGRwX21t
dV9lbmFibGVkKGt2bSkgfHwga3ZtX3NoYWRvd19yb290X2FsbG9jYXRlZChrdm0pOw0KPiArCXJl
dHVybiAhdGRwX21tdV9lbmFibGVkIHx8IGt2bV9zaGFkb3dfcm9vdF9hbGxvY2F0ZWQoa3ZtKTsN
Cj4gIH0NCj4gKyNlbHNlDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wga3ZtX21lbXNsb3RzX2hhdmVf
cm1hcHMoc3RydWN0IGt2bSAqa3ZtKSB7IHJldHVybiB0cnVlOyB9DQo+ICsjZW5kaWYNCj4gIA0K
PiAgc3RhdGljIGlubGluZSBnZm5fdCBnZm5fdG9faW5kZXgoZ2ZuX3QgZ2ZuLCBnZm5fdCBiYXNl
X2dmbiwgaW50IGxldmVsKQ0KPiAgew0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9t
bXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gaW5kZXggZTQxOGVmM2VjZmNiLi43Y2Fm
NTEwMjNkNDcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gKysrIGIv
YXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiBAQCAtOTgsNiArOTgsMTYgQEAgbW9kdWxlX3BhcmFt
X25hbWVkKGZsdXNoX29uX3JldXNlLCBmb3JjZV9mbHVzaF9hbmRfc3luY19vbl9yZXVzZSwgYm9v
bCwgMDY0NCk7DQo+ICAgKi8NCj4gIGJvb2wgdGRwX2VuYWJsZWQgPSBmYWxzZTsNCj4gIA0KPiAr
Ym9vbCBfX3JlYWRfbW9zdGx5IHRkcF9tbXVfYWxsb3dlZDsNCg0KVGhpcyBjYW4gYmUgX19yb19h
ZnRlcl9pbml0IHNpbmNlIGl0IGlzIG9ubHkgc2V0IGluIGt2bV9tbXVfeDg2X21vZHVsZV9pbml0
KCkNCndoaWNoIGlzIHRhZ2dlZCB3aXRoIF9faW5pdC4NCg0KPiArDQo+ICsjaWZkZWYgQ09ORklH
X1g4Nl82NA0KPiArYm9vbCBfX3JlYWRfbW9zdGx5IHRkcF9tbXVfZW5hYmxlZCA9IHRydWU7DQo+
ICttb2R1bGVfcGFyYW1fbmFtZWQodGRwX21tdSwgdGRwX21tdV9lbmFibGVkLCBib29sLCAwNDQ0
KTsNCj4gKyNlbHNlDQo+ICsvKiBURFAgTU1VIGlzIG5vdCBzdXBwb3J0ZWQgb24gMzItYml0IEtW
TS4gKi8NCj4gK2NvbnN0IGJvb2wgdGRwX21tdV9lbmFibGVkOw0KPiArI2VuZGlmDQo+ICsNCg0K
SSBhbSBub3Qgc3VyZSBieSB1c2luZyAnY29uc3QgYm9vbCcgdGhlIGNvbXBpbGUgd2lsbCBhbHdh
eXMgb21pdCB0aGUgZnVuY3Rpb24NCmNhbGw/ICBJIGRpZCBzb21lIGV4cGVyaW1lbnQgb24gbXkg
NjQtYml0IHN5c3RlbSBhbmQgaXQgc2VlbXMgaWYgd2UgZG9uJ3QgdXNlDQphbnkgLU8gb3B0aW9u
IHRoZW4gdGhlIGdlbmVyYXRlZCBjb2RlIHN0aWxsIGRvZXMgZnVuY3Rpb24gY2FsbC4NCg0KSG93
IGFib3V0IGp1c3QgKGlmIGl0IHdvcmtzKToNCg0KCSNkZWZpbmUgdGRwX21tdV9lbmFibGVkIGZh
bHNlDQoNCj8NCg0KLS0gDQpUaGFua3MsDQotS2FpDQoNCg0K
