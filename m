Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9109743A49
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 13:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbjF3LHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 07:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjF3LGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 07:06:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37503A96;
        Fri, 30 Jun 2023 04:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688123157; x=1719659157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rTRGtYrAvY/P/1jBuAmyRBtXezY0iEb0PpHFNlC3AIY=;
  b=MQZQGAzQBXZ0gX6igTpA2oM8va59aqMt+aLxShMGqBRoOAhTHfnVLX3u
   puIu/1rZzxf6uux9rE/f6cYt+dbTL+IVDg1Bsp97yOiMdmZuUcK//N4qR
   vyAHa+FHtybHmGHp5dD6WKVLkR03hiciSzjf77BxBRFMLGWeenXwKRGk6
   u1Q6hKNRpvbPfyDoEnQLiOW4wXm8tvmfCM7t6G5RZJzd11nwEf/pnja7X
   ttxQikDeZNYZi6REYji6vBKBCCDleTBCjfqBevzVSi5UL+voVqRxsiGkZ
   hH/wbo0wo2CojH632XQ7z+xTQOXk4kIyfkDIApbZs+t6MtfrKswhVtNFw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="428412638"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="428412638"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 04:05:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="964347085"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="964347085"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2023 04:05:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 04:05:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 04:05:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 04:05:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbeVeElb3Hq/Qzho0cHwtfXcWBvlWqmjViiGXofr9CEAzVMSdCh0bjiU0pxUstU0f57Cp+E1b8hSkMODdLRSIjzIuCZ53hdiE+qqFZ5n/HDFH8R3PoWxjQX1A30R8ntosg5KsOKBAC8gZCfVXivdnma1hb2JxYDnaIk7TrGp3vKGDZa6SZABgLgc17dl4XFq2ZUrVYFQia+hyU+msSf7EbqdWpJBnjv5e1pWF6tKgGuP/vD6IsIDZ9nBLmp89hVJD7brTUfPfvV/1NbYQU3OfgvWQdxR+IiAA+kgPxdc5qNd5jmmpWScKSUnJ6vLnWrFpIRHEi7Tdi9FB6dYh2gKtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rTRGtYrAvY/P/1jBuAmyRBtXezY0iEb0PpHFNlC3AIY=;
 b=RyDOYRgnU13d5yXww3IwhFfM7C7sjRUxXudBTB0btY6o3QmIR7TKXd1cCl+3a1ZIRwCLGjlGcZ1R/5pzDBUP5CW+nMZAAFtZOgwBACDEqknz/XOEjTzwQDsS5P+UrgGOhNeRwUgpFWVEVvIuOZPLbvc7nNZSTw71aN4FZNgB7O3/YSI3jkGMAoKN3igjIk+I4rfAXgAgit6qlwQJwsSayRstXVANPBavWAgzGEbtyNcGpfdkWV9VFNelKjOaAu1BnFAUm1h6IwV1wVkyFplhP6lq6pn7XZP0jfAPDp8maYhVXtHi79NXKhOMPKm+ltqaXMIpT/wMma8hQEIFmjg66A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8538.namprd11.prod.outlook.com (2603:10b6:a03:578::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Fri, 30 Jun
 2023 11:05:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 11:05:32 +0000
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
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAOlagIABiuaAgAAEHICAAAw8gA==
Date:   Fri, 30 Jun 2023 11:05:32 +0000
Message-ID: <ff41dda010796585400828e6db12f875bfd8d00a.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
         <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
         <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
         <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
In-Reply-To: <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8538:EE_
x-ms-office365-filtering-correlation-id: 8469b952-42f6-41b6-bb3c-08db7959ec48
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lFl0O9vIXVE3WqDIKGd7I/INcQap8bFMLV9ESpoPMWkRO9TxS2lPVuBMRdxclYUG9IQJyx3qiMLEnogx+Jw4tk8nZ3NurdD0oDxH54+JV00OiOyYmrFpdNXMmePQCnM6h21de1VuzgXBqVV4ADmCdgVyArLJMK5987ZH4OCmLqWRvayrU+BZ2d/Ncxl1qyXY2xyfEqkf9Uo81L/Gq/12xte2dVGpsAi1aORzVnAUebiYA2S6kcwuYboFaA2MTMFIbin7ltfPOYRU3nIoKRxO73yVuKkZoEBgzcHI78SWIlq5feMPpvqlNVOSx54pqKD2EaABhAeDza42TRAkq5sBeIlikQ1HpIC+fxF0frT5WDHOiuwAu7YdaT47CAFxnCgFysgMjw4SiSWvr4T3bcQRv7TR6ImCj4MdkpuaE3SXICXLOEU1wOk7IUJqGMiRu2Jcy/jO2MtU7Bmi9Jfx6qpRs1906ooBkT94UGMHxb9hGZMkirvjcs937KAU7jCBIZxFwLLRIlY3o5xvvywkWakniVMRT6vnE4Vd8tU7lS5VtttM/MWYi10/WG/fDm5w7kRDgEdZuWjXupJ1QSTWVR86PcdMz0TZ34+YWOLF4qVlLKY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199021)(5660300002)(7416002)(64756008)(66556008)(66446008)(66946007)(316002)(36756003)(4326008)(478600001)(6916009)(91956017)(66476007)(76116006)(6506007)(8936002)(8676002)(86362001)(2906002)(6512007)(26005)(966005)(54906003)(41300700001)(6486002)(186003)(38070700005)(71200400001)(83380400001)(122000001)(38100700002)(82960400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1NsdC9wdGdlZmJ0Smx3cXJVZ2thS2N3RUJVVEdJcmNOREs1SXF2K2lSUFZ4?=
 =?utf-8?B?Z3FHT3VQUVFRM1FKUlg4bDFadXoxQVhyUE1JYzBJUUpUdXNuVDEzU052STl5?=
 =?utf-8?B?NmQ4Q0ljVnNsQzdVUVlhSGthNThRZHRkR0dkUGsvRGtQaHY1VUNPRmJValNz?=
 =?utf-8?B?MEIvN0VqTlovZ3ZCeEFjK3RwUVBoMHgxaUVOeWxGb210ZnIrcVZISkF2SW1m?=
 =?utf-8?B?bEJlUHFzdWJSZUtBUXBIWU1QZS9lSW5wbllORDMvRHVxUDFXbW43emk3OVhr?=
 =?utf-8?B?dlNwWXV3RVg0UU12eWtQT3hBMjFoWWw1RVhMcHRxU0l6NkdiRWZKV1oxSlg4?=
 =?utf-8?B?UStZSklscFJzNkZFTWlFNnA3MmttZGxwaUdESlBEdkY3dzNPMWVZUWNsS3BJ?=
 =?utf-8?B?dzZEN0k5MXZPZlBqbE4xeTVlVDFjRDBuYU9ITG9SRE8zTnNPdG5vZnF0NDVD?=
 =?utf-8?B?dEV1UzZyNWlqNHBTemwrL3RqaWZkVGVWaFZZWjZtWDE0VUJOT2lDb3BxSlkv?=
 =?utf-8?B?Mk1SUnA0T2xZdCtsR1VoQ01UL3lnL0xUL2RPRDZaS2h5akQ0alZWVzZZaW5I?=
 =?utf-8?B?LzBGYXFiV05PNHJaV1JiMmt4TnNsekhNOVg4dGMyZmEzUmZsS2N5NlVWa2lr?=
 =?utf-8?B?Z0kwUXlUQlZXcVBVc2U2V3BsRXhuVHlaTFRSemF0MkVHK0cwelRHdy9BWmdr?=
 =?utf-8?B?bG9Rdkppdzd6eGYwKzlWMnhEdWdWdjdBN3lmQmUrWWNuMEJseVJOS3QwSUdL?=
 =?utf-8?B?N3A3eXV2dk9iQjBtbmE4V1RzZ1dyN3hqRHJjU0IvZ3MyR05pU255WUFOQ2lT?=
 =?utf-8?B?OE1ZeVBUekRNTXpKenN2N3dqMjhuNk82ZmNyeWh0bHVZUkRlZVhjNjJhVkUy?=
 =?utf-8?B?UXZUbmlJN2RyQUVlUVVNVmloK0w2b0JjanN6RTFKU0FhQ0RPNlAya3pPeG1m?=
 =?utf-8?B?dzhJdm5IR21zTXVEYWlRcnRkbzVDNlg2dzlHaXltYjU5dVhHUm5wR3VHaVhE?=
 =?utf-8?B?WGZoakh1NHZnZXhZU0hadFFuOGpYamE4ZDJHSUpLL3dVSlpZMW9IMGNjQkxp?=
 =?utf-8?B?dFd6M09mWGFmNi9jTHpobkhqYUNBZ2YzK0dIZDMwRUE2ZUVrRnJvNWs5Vjd3?=
 =?utf-8?B?MjJOcE1IdktFaWpSd2NEQ3pKdjMvWjRmVFBSM2RXZ3JNNGdNOWhZdG1tTU5a?=
 =?utf-8?B?ZmkxbFBaUDVtQ1NSNnIyK050WWVCcXhTMmtGdzZJZ3B2d2FqQjVaVThHYks0?=
 =?utf-8?B?MFRoeDBOeTlEbEVBOHhVMDVWYWE5K25TaG52OGpWNk84VkFIbHo2dXBDWjZi?=
 =?utf-8?B?V0ZjUFEzdEJOcU9uKytxSzZyaElZVjUzY0NyYnErNXl0RGd1b2VyeWZIdnNa?=
 =?utf-8?B?NFFRVDBVR2NkYUZ1dDJ3eVhqNFkzZkRIbTBCOEN1UHFBVzI0ZmxpMUNDRWNX?=
 =?utf-8?B?Qmx6WFAyV25XYUcrM0ZnVHhSMXE4MmZMOGRtWjhaRmNrQmJGbTVwY29pdkJr?=
 =?utf-8?B?TWl6L1FLdllNOHV4Q25adUNseEdTd3FlOFpmUUVoajRmakxzaVpMMll5MTFi?=
 =?utf-8?B?RmNXN2FwS2xUeXV6dGFTUlNrQXk0Yk5XR0U5M2lmTkJYQlQ0dVoxQ0UxS2lL?=
 =?utf-8?B?TlBrM2FLeC9DMHlLUkhqeTlHd2RxNjIzY2dwZFRlbjFYTkpTNjE3NWFQazJ5?=
 =?utf-8?B?TDJ0M3IzQ1ltcjRCUEJuSmpxejFtSUUyWHY0RmNGdStrOFBES3BQTHF5ZTh5?=
 =?utf-8?B?VGZjOG1rU2pncktXcXdGeURPdG05b0Vwa0ZCaXBHRk8rL2FOcXdjd21oclhU?=
 =?utf-8?B?aWZXSW9IK1NsOWNBREtFTDEySERZWjU1WjNObVRuWkR4NjNOaGFyQUcyRGQ1?=
 =?utf-8?B?ZGNwSVpmeGVFSUxjYTgyNWhaRGhQVUZlYS90L1dyYW5CbnM2UVlNdEdtS014?=
 =?utf-8?B?WEYzUXNwUXVqbjNkc3hhdHQyOXp5V25zN1d1SWlFUEdGWWNadlJsaVRKamlh?=
 =?utf-8?B?QTdYN1NnQUNWUU1SK3dOSmZ3cVZ1bHJCM2duMDBSTCs1MTJBY0ZxcDBZWEt3?=
 =?utf-8?B?clY2OFNWNGQ2MlVHMzI1ZjQ5VWZOR3dtdHZ5cWtxTmlsNFdYM0RVWWVxRncx?=
 =?utf-8?B?WFZKL1BTU0xtdnU3NmpGSnRCV2Qva2ZOazhQcDcyMHhJMHhTZTJqbG9YeUpl?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F255FF5E2101B42B967FF2466577B33@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8469b952-42f6-41b6-bb3c-08db7959ec48
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 11:05:32.5967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GXOl0OsX8S87V4Kq0NEkI7Wcrpy25gt/AvkD7TO0NmFt7Xgt9Qw2n0rXaX8oZfBX1iOHaT8vVhgH5aYildMjvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8538
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

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDEyOjIxICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gRnJpLCBKdW4gMzAsIDIwMjMgYXQgMTI6MDc6MDBQTSArMDIwMCwgUGV0ZXIgWmlqbHN0
cmEgd3JvdGU6DQo+ID4gT24gVGh1LCBKdW4gMjksIDIwMjMgYXQgMTA6MzM6MzhBTSArMDAwMCwg
SHVhbmcsIEthaSB3cm90ZToNCj4gDQo+ID4gPiBMb29raW5nIGF0IHRoZSBsYXRlciB2ZXJzaW9u
cyBvZiBURFggc3BlYyAod2l0aCBURCBsaXZlIG1pZ3JhdGlvbiwgZXRjKSwgaXQNCj4gPiA+IHNl
ZW1zIHRoZXkgYXJlIGFscmVhZHkgdXNpbmcgUjEyLVIxMyBhcyBTRUFNQ0FMTCBvdXRwdXQ6DQo+
ID4gPiANCj4gPiA+IGh0dHBzOi8vY2RyZHYyLmludGVsLmNvbS92MS9kbC9nZXRDb250ZW50Lzcz
MzU3OQ0KPiA+IA0KPiA+IFVyZ2guLiBJIHRoaW5rIEkgcmVhZCBhbiBvbGRlciB2ZXJzaW8gYmVj
YXVzZSBJIGdvdCBibGVlZGluZyBleWVzIGZyb20NCj4gPiBhbGwgdGhpcyBjb2xvdXIgY29kZWQg
Y3JhcC4NCj4gPiANCj4gPiBBbGwgdGhpcyByZWQgaXMgdW5yZWFkYWJsZSA6LSggSGF2ZSB0aGV5
IGJlZW4gdG9sZCBhYm91dCB0aGUgZ2xvcmllcyBvZg0KPiA+IFRlWCBhbmQgZGlmZiA/DQo+ID4g
DQo+ID4gPiBFLmcuLCA2LjMuMTUuIE5FVzogVERILklNUE9SVC5NRU0gTGVhZg0KPiA+ID4gDQo+
ID4gPiBJdCB1c2VzIFIxMiBhbmQgUjEzIGFzIGlucHV0Lg0KPiA+IA0KPiA+IDEyIGFuZCAxNC4g
VGhleSBza2lwcGVkIDEzIGZvciBzb21lIG15c3RlcmlvdXMgcmFpc2luLg0KPiANCj4gVGhpbmdz
IGxpa2UgVERILlNFUlZURC5CSU5EIGRvIHVzZSBSMTMuDQo+IA0KPiA+IEJ1dCBhbHNvLCAxMCwx
MSBhcmUgZnJlcXVlbnRseSB1c2VkIGFzIGlucHV0IHdpdGggdGhpcyBuZXcgc3R1ZmYsIHdoaWNo
DQo+ID4gYWxyZWFkeSBzdWdnZXN0cyB0aGUgc2V0dXAgZnJvbSB5b3VyIHBhdGNoZXMgaXMgbm90
IHRlbmFibGUuDQo+IA0KPiANCj4gVERHLlNFUlZURC5SRCAqd2h5KiBjYW4ndCB0aGV5IHBhc3Mg
dGhhdCBURF9VVUlEIGFzIGEgcG9pbnRlcj8gVXNpbmcgKjQqDQo+IHJlZ2lzdGVycyBsaWtlIHRo
YXQgaXMgcXVpdGUgaW5zYW5lLg0KDQpJIGNhbiBhc2sgVERYIG1vZHVsZSB0ZWFtIHdoZXRoZXIg
dGhleSBjYW4gY2hhbmdlIHRvIHVzZSBhIGJ1ZmZlciBpbnN0ZWFkIG9mIDQNCnJlZ2lzdGVycy4N
Cg0KPiANCj4gVERHLlZQLkVOVEVSIDotKCgoKCB0aGF0IGhhcyBiLDE1LHNpLGRpIGFzIGFkZGl0
aW9uYWwgb3V0cHV0Lg0KPiANCj4gVGhhdCBtZWFucyB0aGVyZSdzIG5vdCBhIHNpbmdsZSByZWdp
c3RlciBsZWZ0IHVudXNlZC4gQ2FuIHdlIHN0aWxsIGdldA0KPiB0aGlzIGNoYW5nZWQsIHBsZWFz
ZT8hPw0KPiANCg0KSSBhc3N1bWUgaXQncyBUREguVlAuRU5URVIuDQoNClRESC5WUC5FTlRFUiBp
cyBhIHNwZWNpYWwgU0VBTUNBTEwgYmVjYXVzZSBpdCBnb2VzIGludG8gVERYIGd1ZXN0IHRvIHJ1
bi4gIEtWTQ0Kc2hvdWxkIGJlIHRoZSBvbmx5IHBsYWNlIHRoYXQgaGFuZGxlcyBpdC4gIEFuZCBL
Vk0gd29uJ3QgdXNlIHRoZSBfX3NlYW1jYWxsKCkNCmhlcmUgdG8gaGFuZGxlIGl0IGJ1dCB3aWxs
IGhhdmUgaXQncyBvd24gYXNzZW1ibHkuDQoNCkZvciBub3JtYWwgVk1YIGd1ZXN0cywgc2luY2Ug
bW9zdCBHUFJzIGFyZSBub3Qgc2F2ZWQvcmVzdG9yZWQgYnkgaGFyZHdhcmUsIEtWTQ0KYWxyZWFk
eSBoYXMgc3VmZmljaWVudCBjb2RlIHRvIHNhdmUvcmVzdG9yZSByZWxldmFudCBHUFJzIGR1cmlu
ZyBWTUVOVEVSL1ZNRVhJVC4NCkhhbmRsaW5nIFREWCBjYW4ganVzdCBmb2xsb3cgdGhhdCBwYXR0
ZXJuLg0KDQpTbyBsb29rcyBmaW5lIHRvIG1lLg0KDQoNCg==
