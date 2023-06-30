Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EFE743938
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbjF3KSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjF3KSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:18:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ABA2694;
        Fri, 30 Jun 2023 03:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688120316; x=1719656316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i/kSJDz6yN+btJm5M+/nN++3oJfT9vW3TScFth9283c=;
  b=FF+XeJZ25zpPHe9TwCszjJMZ5d7a78/sbthYzJAgCzkZADKDr5jqEv6A
   tAy2X9/QEE312IEhpB++ldwLmgKvHh+rPfkm1XlNRnbZdi4JA5NGD388J
   jgtms+erIf6bm7L/8VsBtSzMpnJbGL01ctDMPr9ZgCTWMuUH2bZy65uRo
   SKb32gGMCEJpcBupM6flLsmTHRlcNWJxYUhlfFTnRvtYduqbikHUOrknP
   b0goh+VEHYnVXkesHZGowJWn29v/K5Lu5einqoVSL57KMtf/gtvYnv9/3
   CE10uvD0/rPAOskXpn0/Rr+z79J7nWCL1uvKVepu8mgCaDG5h7btzgdIa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="359842489"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="359842489"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 03:18:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="807724787"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="807724787"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Jun 2023 03:18:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 03:18:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 03:18:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 03:18:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LO/gpCb5QQAA/l3FvgVQn1VzwrSCm3WZTLmAHMfTdRlRoU8tFdgJnTy10vPySAUnXc5fqdJxNFOSv6q5ieKo2wzVATTSQ5ekProEhq1qJlaVMGtyPzsqazaaW0cb8m6u41D8mx5CFNQl7NQB33fACOsuJgOdJyqyM1Mu0oizDjCZT8jMym7/DdFL1CJRruYm7/NfKqTaampi5feblgcW0tvh02fK+PYl05WG01y7a1CIf/DpmwnsVt0V5oOTzXZsbf6HQfULWU7JOzEhBuH60GA9VqEahCjsA41z4b4q/64pFmtWxUeud22OlEkbzHUFOvCDKWmhCTAjm91Fk4RoQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/kSJDz6yN+btJm5M+/nN++3oJfT9vW3TScFth9283c=;
 b=b6lK3UXrnoTuB3iQ+2sz2G609Wj88++Pt13r7t5fe0VsNAeBa/2UI7fcRiGtOCTMIMDShdK00c3sodiGdZ0JmonZJTI1Ur+SGLI23YrxmLAjnnNIVizKLhv8W4lDTkUoD394GOoU+dDa73WyddrfK1pF+eig0+GOVKff6rOuhJyd8etWzv+i3xY79prLOyylGZja+ODRTNVptREhx9T1Hjl/E6whm0Qq+8RFuDwe84LNJ6fDJHyQ3kxiBcNdBJIQRqaNu6+gWXGXdbC9iEqJyQE8FNkAHtRNAzb24mE2u/4XWRMOZVy3wZrHXy6HMTjleu/tr4Rg8iRRldDPkBnkwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 10:18:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 10:18:28 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAOlagIABiuaAgAADMoA=
Date:   Fri, 30 Jun 2023 10:18:28 +0000
Message-ID: <88de636ed40786f40c153b392070357f8b3d6948.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
         <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
         <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
In-Reply-To: <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4771:EE_
x-ms-office365-filtering-correlation-id: 26648fbe-4c7d-4993-7862-08db795358ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BIFdsEiaupHuY2zWx+htLgzz1WjCEX8H9auCsMnV5sh40+Wl/vW1sewZlCbJisy/iDqU6sSFOsKureLp6WxHjlIoxDTG2FvJyF5O822JKJcgQYfPlNrUyd4wWFsmRtMfxhB0bKmUQu0pjqhBwGOZ2/CUXrSVkSb40Gfs1hzMmzKByKK3vaMknmv+WiJLVNW+34FJUS6sKda0IS5uoJblNvHGwxXnIc6cMEkQ+ufyn3ez0FJZ/nmibw1nAyf3Kk7HDnuJux7j35K8YfmOXVmZZklvbIuNXkJf3gk38L3dHElzrO2XF9Q90GXhVBTIQ3OqjVT9EQ3cJv80up74aLrJlePjxCn0fZ3pymf1278FP4akmtDz7cv6xrzZCaShotdw6hEakWGJH1uqQiiy63512mx6g8kTiQe0q/d6QMmozzEELDmDoeK2KcxHqeyWrhvVrDTOT3k80hzbGggFXcnU2knNvMafvJWgw3/usYTFd7s3sAPMPqv39/4hzxrfJ4bnLpziCAZEnpDIpaLyAgHq8YFT6xFhdf4okdy6wcyo2WdDAVRh9TED7NruTGi41HwZeEos9qVXvLLlb5smtRNUu8yaqHo3IVNb4HQZt7y44ZQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199021)(71200400001)(54906003)(8676002)(8936002)(5660300002)(36756003)(478600001)(6916009)(4326008)(91956017)(6486002)(64756008)(66556008)(66446008)(66476007)(76116006)(66946007)(316002)(41300700001)(6512007)(966005)(38100700002)(82960400001)(122000001)(186003)(2616005)(7416002)(6506007)(26005)(83380400001)(38070700005)(86362001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVo1c0o2eUcrZnBlNkpIYXB5VWZ5bmo0WFp2L1lqVkZpNEkyUDBQRW1XaXRG?=
 =?utf-8?B?YXFEajl2UWJ5eDg3V3ZNSWdzRDkxWm9TbXMrL0tyMDZncE9GMWxqTk5OMWhi?=
 =?utf-8?B?b3FFbUxUYnp4dzliWGNlcm5Udjc1Nlo3bXhnb0VYUlQ5Q3paNUdGUk1DNk1C?=
 =?utf-8?B?R1BVTTJsdnJoL2FNeHRYMG5SUzhSUFJtd0Njc1ZEYWxYNkZ1S0R4ZVk4emdm?=
 =?utf-8?B?RGFER2NzYmtQSkJzUEkrYWtocHIrOHFWMWRiSHRjbFZPbEgzSnozUDJZOFUx?=
 =?utf-8?B?VDdVcmJid3pLQ3M5eG1TUVV3c081YTNOR0lQc0w3Wm9Zb29OL0xOQnh6MHVF?=
 =?utf-8?B?RHJ0M205RlVCVHduMGJQMTdRTUxvS0kvUktMSEVQYzk2MFpGNHk4a1M1UHkz?=
 =?utf-8?B?MXVNZ2hRTCtZcDByUks2MFFOQzNYSUFuRTVtdk8wTys4WmV4MTFrcmcvK1Er?=
 =?utf-8?B?WTJIeUptelJMWVZrRStSSDhna3YwaDRzVjJPbzRsejdyMUZrRkdSclpROVNI?=
 =?utf-8?B?UEJ2QndubDVWMWlUV2tvMVJRQzVNVTcvTmtxOTA0MzJ5eVRXMXN1U09ZWDdU?=
 =?utf-8?B?bUhEUFdnMFljNWY4THBGL1VnNmQzeHlydGd1RXdoQWxXekVQNVZyL2lCYnlF?=
 =?utf-8?B?Rys2SGdDeUpzRVVTemVjV29OY2tGNGY1cXJjOFJZUzdLeXliRnNudmZJeXhC?=
 =?utf-8?B?QkNiTW8xaGN0RVptVjRVemYxdEpYRXpTeEIxTnp4VDRLVnZVekNuR3FpNzIv?=
 =?utf-8?B?WmZpdGtXYjVOd0V1V1ZRcHdLUldVMUgvTDlkaDhIa2g0UDZTNFJxbUFNUEFX?=
 =?utf-8?B?VE5qbXpsL01LNkN5NzNBb3NLTEVyT0MxY0N1WUNJR1lhazA1NlkxN0pGM2FW?=
 =?utf-8?B?RjVsRTJZamFweEpKRWpmOEJreWxkR1M5ZGk1NFZwczRTSUczbXV2clB5Q2tU?=
 =?utf-8?B?SVBjeEVvTmFYNDRUNnZEajRvMWpNMkpJMzBGZ01CUm5OM1Y2QjNrT2N4YlB1?=
 =?utf-8?B?dkZvdVZmY3BxOW9LSHRFNm1DbE42eXllMWpCeWt5d0VVeTE2Ujg5T0RTWUoy?=
 =?utf-8?B?N1oyNWZpWk9QUGhtYjVLMEdvdkZEUDY0RUFGNlc3aXZPMWRPVmVsbGpkd0gx?=
 =?utf-8?B?amRVSDBaQy9RSkRRZVVQdkZ0SzlFMnFiaVdXZzRtNHFsUG9kM0J5aW9lclF1?=
 =?utf-8?B?bkRjSlE4QW81N0JYMTZQZ0tvcHBXSXQrS2Eyb0l0ZVZQTzVBZEdqYjBUSHZE?=
 =?utf-8?B?ZzNKVnRhRjhsTlVIWjUxYmdCeXgyNzFnRE1zK1JKV1RIUzllTDU2TjFWLzZ2?=
 =?utf-8?B?MXhsL0J0L1pXQlpuOG12Vmt5WjhpZ0ZueTVBOFplb1R1MGFGbStPTTFNajBP?=
 =?utf-8?B?WW9iaVNrSGFVYW9BcFhTOTNJTHpVa2hkdWg0UUttL2llUGdPQU1BaCtaaHVR?=
 =?utf-8?B?ZGJZbUM1b2R4SWc5NGdRM3BpQjUxVDMwbDQrOTlPTCtUcnQvWnFaQ1Voc0ZO?=
 =?utf-8?B?QSs1TllmRWJMSGErUk04OS9JeEtJMmFpSFdEV0ltZUs0VzQ0WkJsNHY5Z2Uz?=
 =?utf-8?B?V29TVDFhRGludE1yKzNGZDBtdVdmVlRBNkZmR2dhWWNzc2NtMnRsbGZwa3J6?=
 =?utf-8?B?cnJmVGpSbmVkbDJvR2lDMHdkcUVienJxblo2d2hnSCtiRUNuREZTbStISkR0?=
 =?utf-8?B?bTJBQlpLczY5eHc3MUptQmwrQXpkVGs3OFA3RTkyczk2c1o2L2VKbmR3bnRF?=
 =?utf-8?B?QzRXMXZmVy9DRGJJWjFVbmYrQ05mQ1dNRjFoZ3h6ZmtEWGZvWW1qK0hxUGlE?=
 =?utf-8?B?RTF3MEhxN2N1OEpkTFdKc3ZiMlFlZ2k4Q0NDU1NZTHFYWDVwTmI4a09qUVNm?=
 =?utf-8?B?Qkg0blRDOUxoSGM4VldLVWZTTmRxVFBYU3lQL1NkNS9reVZVci9IaHdxVmNN?=
 =?utf-8?B?N09TYThjQ2VMcWhyZU9GZEpwV2hhQjhZR04yVWYyUGhXNEZ2ZzVWdk5SaFc2?=
 =?utf-8?B?cFZUdDZHYUV6Rmx5NmhPV01KNGplaUxZOWx5YmtFcmhkbFZBWk0rUFhHK3lu?=
 =?utf-8?B?ckY4UE5LWlBhVFRvb0JzMzI3TjBlclNVTTBid05XMnd0MWJPSWNXWXZCZWZR?=
 =?utf-8?B?OVpIWEdKZlkrRFhvVWI4ZS9UUU9DUUhibGYxRktJeW15bU5HRDlXbmlQZUtl?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAB0D95CB6B8924E894C5094DDE27AEE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26648fbe-4c7d-4993-7862-08db795358ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 10:18:28.0361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g7h/tac101WHHpSMBgOFUePaipJHghPOvNFVJAJFElggQ8zHyddPIUsIdokYpBbyJQrUPWWA5SsZZnWGnr7N4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4771
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDEyOjA2ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMjksIDIwMjMgYXQgMTA6MzM6MzhBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBXZWQsIDIwMjMtMDYtMjggYXQgMjI6MzggKzAyMDAsIFBldGVyIFppamxz
dHJhIHdyb3RlOg0KPiA+ID4gT24gV2VkLCBKdW4gMjgsIDIwMjMgYXQgMDU6Mjk6MDFQTSArMDIw
MCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgSnVuIDI3LCAyMDIzIGF0
IDAyOjEyOjUwQU0gKzEyMDAsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+ID4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeGNhbGwuUyBiL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHhjYWxsLlMNCj4gPiA+ID4gPiBpbmRleCA0OWE1NDM1NmFlOTkuLjc1N2IwYzM0YmUxMCAx
MDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4Y2FsbC5TDQo+
ID4gPiA+ID4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeGNhbGwuUw0KPiA+ID4gPiA+
IEBAIC0xLDYgKzEsNyBAQA0KPiA+ID4gPiA+ICAvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMCAqLw0KPiA+ID4gPiA+ICAjaW5jbHVkZSA8YXNtL2FzbS1vZmZzZXRzLmg+DQo+ID4g
PiA+ID4gICNpbmNsdWRlIDxhc20vdGR4Lmg+DQo+ID4gPiA+ID4gKyNpbmNsdWRlIDxhc20vYXNt
Lmg+DQo+ID4gPiA+ID4gIA0KPiA+ID4gPiA+ICAvKg0KPiA+ID4gPiA+ICAgKiBURENBTEwgYW5k
IFNFQU1DQUxMIGFyZSBzdXBwb3J0ZWQgaW4gQmludXRpbHMgPj0gMi4zNi4NCj4gPiA+ID4gPiBA
QCAtNDUsNiArNDYsNyBAQA0KPiA+ID4gPiA+ICAJLyogTGVhdmUgaW5wdXQgcGFyYW0gMiBpbiBS
RFggKi8NCj4gPiA+ID4gPiAgDQo+ID4gPiA+ID4gIAkuaWYgXGhvc3QNCj4gPiA+ID4gPiArMToN
Cj4gPiA+ID4gPiAgCXNlYW1jYWxsDQo+ID4gPiA+IA0KPiA+ID4gPiBTbyB3aGF0IHJlZ2lzdGVy
cyBhcmUgYWN0dWFsbHkgY2xvYmJlcmVkIGJ5IFNFQU1DQUxMID8gVGhlcmUncyBhDQo+ID4gPiA+
IGRpc3RpbmN0IGxhY2sgb2YgaXQgaW4gU0RNIFZvbC4yIGluc3RydWN0aW9uIGxpc3QgOi0oDQo+
ID4gPiANCj4gPiA+IFdpdGggdGhlIGV4Y2VwdGlvbiBvZiB0aGUgYWJvbWluYXRpb24gdGhhdCBp
cyBUREguVlAuRU5URVIgYWxsIFNFQU1DQUxMcw0KPiA+ID4gc2VlbSB0byBiZSBsaW1pdGVkIHRv
IHRoZSBzZXQgcHJlc2VudGVkIGhlcmUgKGMsZCw4LDksMTAsMTEpIGFuZCBhbGwNCj4gPiA+IG90
aGVyIHJlZ2lzdGVycyBzaG91bGQgYmUgYXZhaWxhYmxlLg0KPiA+IA0KPiA+IFJBWCBpcyBhbHNv
IHVzZWQgYXMgU0VBTUNBTEwgcmV0dXJuIGNvZGUuDQo+ID4gDQo+ID4gTG9va2luZyBhdCB0aGUg
bGF0ZXIgdmVyc2lvbnMgb2YgVERYIHNwZWMgKHdpdGggVEQgbGl2ZSBtaWdyYXRpb24sIGV0Yyks
IGl0DQo+ID4gc2VlbXMgdGhleSBhcmUgYWxyZWFkeSB1c2luZyBSMTItUjEzIGFzIFNFQU1DQUxM
IG91dHB1dDoNCj4gPiANCj4gPiBodHRwczovL2NkcmR2Mi5pbnRlbC5jb20vdjEvZGwvZ2V0Q29u
dGVudC83MzM1NzkNCj4gDQo+IFVyZ2guLiBJIHRoaW5rIEkgcmVhZCBhbiBvbGRlciB2ZXJzaW8g
YmVjYXVzZSBJIGdvdCBibGVlZGluZyBleWVzIGZyb20NCj4gYWxsIHRoaXMgY29sb3VyIGNvZGVk
IGNyYXAuDQo+IA0KPiBBbGwgdGhpcyByZWQgaXMgdW5yZWFkYWJsZSA6LSggSGF2ZSB0aGV5IGJl
ZW4gdG9sZCBhYm91dCB0aGUgZ2xvcmllcyBvZg0KPiBUZVggYW5kIGRpZmYgPw0KPiANCj4gPiBF
LmcuLCA2LjMuMTUuIE5FVzogVERILklNUE9SVC5NRU0gTGVhZg0KPiA+IA0KPiA+IEl0IHVzZXMg
UjEyIGFuZCBSMTMgYXMgaW5wdXQuDQo+IA0KPiAxMiBhbmQgMTQuIFRoZXkgc2tpcHBlZCAxMyBm
b3Igc29tZSBteXN0ZXJpb3VzIHJhaXNpbi4NCj4gDQo+IEJ1dCBhbHNvLCAxMCwxMSBhcmUgZnJl
cXVlbnRseSB1c2VkIGFzIGlucHV0IHdpdGggdGhpcyBuZXcgc3R1ZmYsIHdoaWNoDQo+IGFscmVh
ZHkgc3VnZ2VzdHMgdGhlIHNldHVwIGZyb20geW91ciBwYXRjaGVzIGlzIG5vdCB0ZW5hYmxlLg0K
PiANCj4gPiA+IENhbiB3ZSBwbGVhc2UgbWFrZSB0aGF0IGEgaGFyZCByZXF1aXJlbWVudCwgU0VB
TUNBTEwgbXVzdCBub3QgdXNlDQo+ID4gPiByZWdpc3RlcnMgb3V0c2lkZSB0aGlzPyBXZSBjYW4g
aGFyZGx5IHByb2dyYW0gdG8gcmFuZG9tIGZ1dHVyZQ0KPiA+ID4gZXh0ZW50aW9uczsgd2UgbmVl
ZCBoYXJkIEFCSSBndWFyYW50ZWVzIGhlcmUuDQo+ID4gDQo+ID4gDQo+ID4gSSBiZWxpZXZlIGFs
bCBvdGhlciBHUFJzIGFyZSBqdXN0IHNhdmVkL3Jlc3RvcmVkIGluIFNFQU1DQUxML1NFQU1SRVQs
IHNvIGluDQo+ID4gcHJhY3RpY2UgYWxsIG90aGVyIEdQUnMgbm90IHVzZWQgYXMgaW5wdXQvb3V0
cHV0IHNob3VsZCBub3QgYmUgY2xvYmJlcmVkLiAgQnV0IEkNCj4gPiB3aWxsIGNvbmZpcm0gd2l0
aCBURFggbW9kdWxlIGd1eXMuICBBbmQgZXZlbiBpdCdzIHRydWUgaW4gcHJhY3RpY2UgaXQncyBi
ZXR0ZXINCj4gPiB0byBkb2N1bWVudCBpdC4gIA0KPiA+IA0KPiA+IEJ1dCBJIHRoaW5rIHdlIGFs
c28gd2FudCB0byBhc2sgdGhlbSB0byBzdG9wIGFkZGluZyBtb3JlIHJlZ2lzdGVycyBhcw0KPiA+
IGlucHV0L291dHB1dC4NCj4gPiANCj4gPiBJJ2xsIHRhbGsgdG8gVERYIG1vZHVsZSB0ZWFtIG9u
IHRoaXMuDQo+IA0KPiBQbGVhc2UsIGJlY2F1c2UgMTIsMTQgYXJlIGNhbGxlZS1zYXZlZCwgd2hp
Y2ggbWVhbnMgd2UgbmVlZCB0byBnbyBhZGQNCj4gcHVzaC9wb3AgdG8gcHJlc2VydmUgdGhlbSA6
LSgNCg0KWWVzLg0KDQpIb3dldmVyIHRob3NlIG5ldyBTRUFNQ0FMTHMgYXJlIGZvciBURFggZ3Vl
c3QgbGl2ZSBtaWdyYXRpb24gc3VwcG9ydCwgIHdoaWNoIGlzDQphdCBhIHllYXIocyktbGF0ZXIg
dGhpbmcgZnJvbSB1cHN0cmVhbWluZydzIHBvaW50IG9mIHZpZXcuICBNeSB0aGlua2luZyBpcyB3
ZQ0KY2FuIGRlZmVyIHN1cHBvcnRpbmcgdGhvc2UgbmV3IFNFQU1DQUxscyB1bnRpbCB0aGF0IHBo
YXNlLiAgWWVzIHdlIG5lZWQgdG8gZG8NCnNvbWUgYXNzZW1ibHkgY2hhbmdlIGF0IHRoYXQgdGlt
ZSwgYnV0IGFsc28gbG9va3MgZmluZSB0byBtZS4NCg0KSG93IGRvZXMgdGhpcyBzb3VuZD8NCg==
