Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4E7626782
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 07:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbiKLGfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 01:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiKLGfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 01:35:44 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C0412639;
        Fri, 11 Nov 2022 22:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668234943; x=1699770943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0Nf8vJPHBoztI8XqTswYYv1Xzd3YZOK/pagCAD6V23k=;
  b=Q4MXUv+oCsMJkaYTsIP5QDFDPDwQjyrQ6bDh4pP5tFOyphRpwYsFVvwv
   2gmcPPGrspxgWo19tkk9Y0oniwfKnLcWM7qAPhCWRDtwgJR3mDt+qQBrD
   g8rSlp1m82TS8PvE7pV9bgyzbYLvxQNjV6lBvUBzJSQKkkyHRhPYkz1pg
   52SmU/j4k/4ylLhG/ksZxwRp5wnSXfwEZ9os4XHHtdfwUWKWmLrgeakft
   V3jccYmY/yqkG7Ed8iyQtbs7q15i/6kVizEwQWaeFujJpbLgIJQjF8mJ9
   iSMZUm3O7dIOXnHY3mQWVjaUY2n0TG76b7swDH1qJno4YjYZxUEwdKboK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="398001033"
X-IronPort-AV: E=Sophos;i="5.96,158,1665471600"; 
   d="scan'208";a="398001033"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 22:35:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="967011562"
X-IronPort-AV: E=Sophos;i="5.96,158,1665471600"; 
   d="scan'208";a="967011562"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 11 Nov 2022 22:35:42 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 22:35:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 11 Nov 2022 22:35:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 11 Nov 2022 22:35:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ma3/vPi+qrYKWJw/F0uIGLGQ3ZZQQvkdtlDZipJM0zvEPe9sVpjs6TMIQak6le+Gk2KdmXbCsDNQ1RoT9ci0caLxakSNq79MpqcOe+dNoHvpwPCk9ylAnvjVF4B2N2Ob87oGeIzr9d8yYSmr+r/4CI3OvUu1NpkcH1JWBH6bmq15VidA27GxW9FdS5LQK5ty5mxXntnZDe/piAGiixRCRAyM5Hs7LuySOoBR4yct4wcnoFlPuBV52++2HnYUKq2qNA9klWKEkIFcSJGZpAZ2yegGa5Qqi+glRGNzlBOOYNKAVPv+j2j+bQhS3QwNlX1hvn/65ZTjRAXx0fq5AqedAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Nf8vJPHBoztI8XqTswYYv1Xzd3YZOK/pagCAD6V23k=;
 b=JQt3IsICJSxUTwSL/kS1SHKDgUK5A0pPXvYSf7lneg9iCl9FwauKCLosPaZKuyZtKyZ6l5n/+7bB8sldQSygRx0avgKRh8MJVU7/bfVw7ZdPV9Q8KSqRiJ/Q0TAMJ2A0QNpOJlfjF8lwP2FIVyAubO/u8zVl9CX9PQPghhWcTsZ1NLr9FQRUZAMiHWVjLpnajRa4/BXMoNHPN/aZhS0HMSnEiM4g4GJIfs3cFo7vk12E2AukJYzuEiCRkPDn1S0NTgJ2W2NcQ7ztMt/+Vm/rKFjlpwsl+09/ubV0WiMLcTMvgpVrxMcrQcUu9s/XsWKPG0+apDm/f0dDbSYEygWJrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by MN0PR11MB6208.namprd11.prod.outlook.com
 (2603:10b6:208:3c4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Sat, 12 Nov
 2022 06:35:39 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.015; Sat, 12 Nov
 2022 06:35:39 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHCAACERAIAAtwpQ
Date:   Sat, 12 Nov 2022 06:35:39 +0000
Message-ID: <BN6PR1101MB216163B12055F02E8C54D2BFA8039@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
In-Reply-To: <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|MN0PR11MB6208:EE_
x-ms-office365-filtering-correlation-id: 6b1748c3-c2d2-4427-628a-08dac4781d5e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j9NgkVkEuCxqAwcpx9//uSSLTFMGeEDa0QbPHVU5UBd7ajEBQd3iNNNTU/ie3k27VQyWaIYcj7B4A2g4q5jQ5eFU/UI/xsjCYhM0ggMau2dO6mHpUjNhQxEkIZgrxCCX18SjfcACdU7j7R11OgBGkNyK6sioZBIX4lXNMv+XlKhx02tWHvwCPRYg/WzdxAIJ4hpV9tmhahaMq8tnd5N9nUg6EosI+1ToMspznv9MAgdODE1E+mrnJA1Rdhx941YS9HjUjcQzCCCQ4ssXLlTi6AWXkJhhMjxZKsIh+UBorN3596rJnR2lu1ZyJy8dm09gkk8Y16M4A6bZ0/gJpBsemu+bkRpesWWMgMl2ha8SyelG9NBIjubwjaxKeExsJwTzlNBUTQ/oLJfdLwMA9C+cGHFJz5XeB11CeFaqsobn5wS4UeaHD6xrQ9BxoKUcObFtOlaldS4QeykGhsmPJu+YjBvWFbwvGU+BqbPP4yhJ+4hIyr2CdyjrVN2+y5meGndz8jIptt4GBeyAe5jQeN80IbdLzgafXfcXbbQmYXIufoAh5IyZHQsk+xKl5u22CqpWsmRcxvktZbdAC5wXFbyDIIVUsMuKfVA3EOonbJl2cv7zueEqKl+ZwISGn+qtU7AVILYy//TzpuZYM3k9OtNkeqxdISm+uQez1cazwvSL6gAANJeU51JDP5xDPVhciw86KaIRVr0og1+5AEcEZakKLQC7hIWsG+Ov48Pq4mYD4dHD7CalOIilFDY8KiKGSNGaOizHabls5UXKeKT9SG/evQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199015)(186003)(9686003)(38100700002)(83380400001)(7696005)(6506007)(8676002)(8936002)(66476007)(76116006)(26005)(7416002)(5660300002)(2906002)(71200400001)(6916009)(82960400001)(54906003)(66946007)(55016003)(478600001)(64756008)(316002)(66446008)(41300700001)(4326008)(52536014)(122000001)(33656002)(66556008)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L09PU1pXa1FLVGV5M2pXL08zTVdJUU5GNWdMY0twZHFFS0dqb2ZpSks3WTNr?=
 =?utf-8?B?KzZpVEJiYWlaak5XT2JUeURpS09OcVBmTFhDSEtZNGlPYmlqL1VQZ1RnUEE2?=
 =?utf-8?B?UzM2TUdYNHJ4YWkwbmc1KytsSHhsNUttbTZ4aWh4UkhQRmh6SjJJaHluSmtQ?=
 =?utf-8?B?b1kvN09SU0tZQmlYbTdnVkxENHJlZ1NpbTVXRXhBOFUzc2hGd1BTZHJza21x?=
 =?utf-8?B?MjJtbjN2TGd6MzdreUhhN250MlFNOTZ4STRlREl2S2JEc1I1ZjhOVTNaVU5J?=
 =?utf-8?B?enJCQXhoaEZvcnZYNE44d1d1SUdGVERBMmJLV2ZhUDk2QjJ5L0U5WTl6MU1Z?=
 =?utf-8?B?OWlPZnQ0d2ozNm1nNnZSR3Vjai80aktjWFpFVjRGbHoySlhROEp6Y1EwdFdW?=
 =?utf-8?B?YXVpMEU4YUl1Y1E5RWRWeDZBRlJnejlBZ04rUHA4MzBUdjhKWGpsd2pSOUpV?=
 =?utf-8?B?TWVBSVUzZnVCQVZ5VHNqYWw4ZXhybFl1Mzh6YU9YekV3cW14bU9iWUQ3Wk1K?=
 =?utf-8?B?dGRtSUxDOWNmSFRLMUtXeGQyNGRuQ2JnZEVvdG96SmJsb2svYm5sMlFnVmNI?=
 =?utf-8?B?OUE2cGFwQWdhSDdPWTJNY0hjYm1XV3ArRTBOS2daUjhUemFwNytnc1Fuc3hm?=
 =?utf-8?B?WE1sb0FSdDNmMWRlRzAxU01rMjlNZHNyOTdjdk5yZXQ0T04rMmRFZGtidUlq?=
 =?utf-8?B?bUpyU09BellXN002SXRJaFBlTzl6RFdxTEFpM3JEaEJyWE9JTHNTMWxiUHEr?=
 =?utf-8?B?SXlhSlpZRUgvelF0V05tUm9tdExWc3hEUGp5R0RqMUx5bzhDakhhSnluYzAy?=
 =?utf-8?B?MGp1SU43RzJnNGE2Zy81ZTJ4SGFoVjFiQVRROU4vTENDeUpDYjVqMmRSdDg1?=
 =?utf-8?B?SElEQjhHK25sTUlHVDlUaDh0MFpySnFPTHoyaklFbTd3ekFPVXZQZWsrY3Ix?=
 =?utf-8?B?dE83VGEzODMwYms4OTVwQVJ5MjkydGVOeUdxTFpoblpEeTI0M0RzK0N2bXVu?=
 =?utf-8?B?VEJZTVl5SEdxdHN2UTluMlF0ZlNieGtSVW15RE1YQy9kVmFlbzlPZVkvUUQ0?=
 =?utf-8?B?cWFEcWNkaHpZWEsvbTQxYmZRTkZ2eSs3ODJ0djdlU1VLcElFU01wYXM1RHFN?=
 =?utf-8?B?a053NmRVSWU0eGs4MGFpaDBwL2xYR0FZdFg5QWx5SVRyQXBvQlY1NkZ6SGdX?=
 =?utf-8?B?ZnZKTkJFbGlHTEY4T09vWGluV1BKb3RkelB0S2V0cWp5NFZrME80RlNtVitT?=
 =?utf-8?B?cElOb3FaTkpqZUpoR0d5TzVxNWo3Zlpwc3Ayc2RxbVpzR3VEUGV6QkZIY3JP?=
 =?utf-8?B?dTBuMm5yT254KzlUYVE4MlJQLzFzNkxzVXpBM3AzanZraGtOeVcySWRzeS9T?=
 =?utf-8?B?WGEyYktCWEJkNU5FaGlUblpNZlJtRnhYWkpUZGtxU2l5azVWdWRGZCt2T1lW?=
 =?utf-8?B?MVZJZWF3aGkwbGNGWGxqMmozT3dLN2ZMcTNiOEpKSkM2clBMc1ovdjRrU09H?=
 =?utf-8?B?S25id0NiYmpXeDBKdExjbDBxTEVFSWlSdGFQOGxoeUNlQ21JZElEbVZPeDQ1?=
 =?utf-8?B?YVdNa3NhYXhTYm1iNnBLcVBJQ3grc0taZzdNc2Z6RE93NVdsZUxXTVk4MGlB?=
 =?utf-8?B?UE5KeDFudzQ2aEJVQkRPUmFVWW9YQU40NWZXUFM3aTIwTmdEZW1hNVJpejEr?=
 =?utf-8?B?RXd4QnJTeWM4aXdkWm1qQ29qNXllMGxzL1dlaDJONGJGQ0Q2NlVXZVFRcUpW?=
 =?utf-8?B?UlQxQU5sZVdZNUtZU21heXU1eUJSSVJqWHk4RTQ2QTN4U04yQmVrUEFjWjNq?=
 =?utf-8?B?SnZLQTgvWUNRVkFBYkxlSGhhalZ0YVZGMDFQajZGSjd3cHNQaHFvYzVpUTd5?=
 =?utf-8?B?WjBvVEZ4UVhpNWhrMWpuc3J0cHBrNGlvL0VhNnFpSHVQK2N4cGxOQVY1aEg1?=
 =?utf-8?B?UDUyMlVRU3F0eUdzYlBDaHRteCtjUElKNUVwOFpBdjFXdE9WSGN0eHR6NHMx?=
 =?utf-8?B?Q1NtVTNGS2Ira1FhWk9VRzhRVDgrWEpNMUZpNWtVTHltbzF1UUNpLzhCUFlj?=
 =?utf-8?B?U0tuZG80cVNNWU9vamxQZkpsdmxkRjllc3FrN0JVVmNvRWYyRlEyQ3cyNllK?=
 =?utf-8?Q?5ndI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1748c3-c2d2-4427-628a-08dac4781d5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2022 06:35:39.3564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lSKHMNls36H+dPvUKmLPdBhjiqWlN3N+xijb3A3c51uDXT070lRULi63emjEGINyw/I2vWNcp9iiO1qla7hMDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6208
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ID4gU28gaW5zdGVhZCBvZiBmaXhpbmcgaXQsIHRoZXkgbWFkZSBpdCB3b3JzZSA6LSgNCj4g
PiA+DQo+ID4gPiBBbmQgbm93IEZSRUQgaXMgYXJndWFibHkgbWFraW5nIGl0IHdvcnNlIGFnYWlu
LCBhbmQgcGVvcGxlIHdvbmRlcg0KPiA+ID4gd2h5IEkgaGF0ZSB2aXJ0Li4uDQo+ID4NCj4gPiBN
YXliZSBJIHRha2UgaXQgd3JvbmcsIGJ1dCBGUkVEIGRvZXNuJ3QgbWFrZSBhbnl0aGluZyB3b3Jz
ZS4gRnJlZA0KPiA+IGVudHJ5IGNvZGUgd2lsbCBjYWxsIGV4dGVybmFsX2ludGVycnVwdCgpIGlt
bWVkaWF0ZWx5IGZvciBJUlFzLg0KPiANCj4gQnV0IHdoYXQgYWJvdXQgTk1JcywgYWZhaWN0IHRo
aXMgaXMgYWxsIGhvcnJpYmx5IGJyb2tlbiBmb3IgTk1Jcy4NCg0KTk1JcyBhcmUgTk9UIGhhbmRs
ZWQgYnkgZXh0ZXJuYWxfaW50ZXJydXB0KCksIHdoaWNoIGlzIGludHJvZHVjZWQgaW4gcGF0Y2gg
NC4NCg0KVGhlIE5NSSBoYW5kbGluZyBpcyBhZGRlZCB0byBrdm1fdm14X3JlaW5qZWN0X25taV9p
cnEoKSBpbiBwYXRjaCA1IHB1cmVseSBmb3IgVk1YIG9ubHkuDQoNCj4gDQo+IFNvIHRoZSB3aG9s
ZSBWTVggdGhpbmcgbGF0Y2hlcyB0aGUgTk1JICh3aGljaCBzdG9wcyBOTUkgcmVjdXJzaW9uKSwg
cmlnaHQ/DQo+IA0KPiBCdXQgdGhlbiB5b3UgZHJvcCBvdXQgb2Ygbm9pbnN0ciBjb2RlLCB3aGlj
aCBtZWFucyBhbnkgcmFuZG9tIGV4Y2VwdGlvbiBjYW4NCj4gaGFwcGVuIChrcHJvYmVzICNCUCwg
aHdfYnJlYWtwb2ludCAjREIsIG9yIGV2ZW4gI1BGIGR1ZSB0byByYW5kb20NCj4gbm9uc2Vuc2Ug
bGlrZSAqU0FOKS4gVGhpcyBleGNlcHRpb24gd2lsbCBkbyBJUkVUIGFuZCBjbGVhciB0aGUgTk1J
IGxhdGNoLCBhbGwNCj4gYmVmb3JlIHlvdSBnZXQgdG8gcnVuIGFueSBvZiB0aGUgTk1JIGNvZGUu
DQo+IA0KPiBOb3RlIGhvdyB0aGUgbm9ybWFsIE5NSSBjb2RlIGlzIHZlcnkgY2FyZWZ1bCB0byBj
bGVhciBEUjcgYW5kIGJvdGgga3Byb2Jlcw0KPiBhbmQgaHdfYnJlYWtwb2ludCBrbm93IG5vdCB0
byBhY2NlcHQgbm9pbnN0ciBjb2RlIGFzIHRhcmdldHMuDQo+IA0KPiBZb3UgdGhyZXcgYWxsIHRo
YXQgb3V0IHRoZSB3aW5kb3cuDQo+IA0KPiBBbHNvLCBOTUkgaXMgSVNULCBhbmQgd2l0aCBGUkVE
IGl0IHdpbGwgcnVuIG9uIGEgZGlmZmVyZW50IHN0YWNrIGFzIHdlbGwsIGRpcmVjdGx5DQo+IGNh
bGxpbmcgZXh0ZXJuYWxfaW50ZXJydXB0KCkgZG9lc24ndCBob25vdXIgdGhhdCBlaXRoZXIuDQo+
IA0KPiA+IFlvdSByZWFsbHkgcmVhbGx5IGRvbid0IGxpa2UgdGhlIGNvbnRleHQgaG93IFZNWCBk
aXNwYXRjaGVzIE5NSS9JUlFzDQo+ID4gKHdoaWNoIGhhcyBiZWVuIHRoZXJlIGZvciBhIGxvbmcg
dGltZSksIHJpZ2h0Pw0KPiANCj4gSSByZWFsbHkgcmVhbGx5IGhhdGUgdGhpcyB3aXRoIGEgcGFz
c2lvbi4gVGhlIGZhY3QgdGhhdCBpdCdzIGJlZW4gdGhpcyB3YXkgaXMgbm8NCj4ganVzdGlmaWNh
dGlvbiBmb3Iga2VlcGluZyBpdC4gQ3JhcCBpcyBjcmFwLg0KPiANCj4gSW50ZWwgc2hvdWxkIGhh
dmUgdGFrZW4gYW4gZXhhbXBsZSBvZiBTVk0gaW4gdGhpcyByZWdhcmQsIGFuZCBub3QgZG91Ymxl
ZA0KPiBkb3duIGFuZCBleHRlbmRlZCB0aGlzIE5NSSBob2xlIHRvIHJlZ3VsYXIgSVJRcy4gVGhl
c2UgYXJlIGV4YWN0bHkgdGhlIGtpbmQgb2YNCj4gZXhjZXB0aW9uIGRlbGl2ZXJ5IHRyYWlud3Jl
Y2tzIEZSRUQgaXMgc3VwcG9zZWQgdG8gZml4LCBleGNlcHQgaW4gdGhpcyBjYXNlIGl0DQo+IGFw
cGVhcnMgaXQgZG9lc24ndCA6Lw0K
