Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4373F751D0B
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbjGMJU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjGMJUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:20:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBCDB4;
        Thu, 13 Jul 2023 02:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689240021; x=1720776021;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uCRmyem0S0t9jfhWPiYZXF5FPN3shFLLbkDlTxvMl4Q=;
  b=cElqxLujysXSJOL3Bn48DTHshZ3KSnbqrnqFGSZoMwmalj6qftV1sqeL
   hOT7i+cqODIA/kLYF+fcqswSFFceAFbv/eUwTglccJSnPkIhWcgHDWfgQ
   LmCocXoYL5A7sUc5MduF0SiUZCmMFH5rjb6W2IgFuCYDpw8ARTp+/63sZ
   CEdG/hRfAdZenreenR6o6Xpn5km8twt9aGVQs0YqU5j67S8xGRfaqvyXh
   1yiR1bRgCrPoGo4q82aCmBdH/KuS0OukxJzW2PuKG6wVxA3BBIOjVuKqU
   e+8bADHgEEUSjZJ3Sj/kXEgVtjjwjCVkgE8efrtAYymysFqGj8RkTYMjt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="395938511"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="395938511"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 02:20:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="715885852"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="715885852"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 13 Jul 2023 02:20:07 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 02:20:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 13 Jul 2023 02:20:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 13 Jul 2023 02:20:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIE/Ik8/fu4rpGp6LXyRgFBRT2FyLC0lXgTUwD7f25Mp0Cjgfklef0730h8KJmCz87EKVEvsR+vrM7g/w4zE1Yr0xqCFFBsMl2vdevmTTwfYR2dt6r669RTkUtYyZmwY1LgDaV59m4YK9nE5xe+H8VFnr+L+6vTEaoD+EoPQiCmpNtyifXUdTPC28cuPJ25RnOaAewuCJjrmzYMJ6p7s0RonxBVUQLHPNkz5W1hp/Oca1KA7sNx6aK+h+Scl+uMKmtEP1uYg6uEKdHQ05KJu1WTfuyMh8bLoyhk/xhspzY8dMl2ePZMedO/HVrYPsGWoztczrfkjbKKRzm42GkTS/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCRmyem0S0t9jfhWPiYZXF5FPN3shFLLbkDlTxvMl4Q=;
 b=VjgEuRzoakCt267DOwJPiCsDepVIh0kYwcD2pJ8seSRfc2k6Cz7ylUa0QP6O+j8yoREXQGIf+eEt/WLdwQNj8+pSsVX9OpDmfC2ph9V4Teep09vS/+L9jj/YGk5zILRIdfzAb9fEvpbMb+EoWHYFs1LDq6ZKox9xuQ036WWIAgnNM+W3Cg+CQmnnq/MDM8IAyxlUjxuSeYdY2nmrwZqN7Uh5r1VYrLWeXBP/tnaE0SXd4HZSgUzzG9oh3/PSkdsrzpy+Vf72PYw/8S5dLKZo+usT19LAMOFD7+6bzkmGRTaLY1Kv/+tv0KCS76jVOOSAlIdTitUcKxWhJdxB3BkukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6137.namprd11.prod.outlook.com (2603:10b6:930:2b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Thu, 13 Jul
 2023 09:20:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 09:20:03 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Thread-Topic: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Thread-Index: AQHZtJ11LVNzaBLM3EiCxikVoFiXz6+2s2kAgABcqoCAAEG6AIAAChOAgAAMr4CAAASagA==
Date:   Thu, 13 Jul 2023 09:20:03 +0000
Message-ID: <f3911e98aa56060012b9cf28c0cf904e895decf7.camel@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
         <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
         <20230712221510.GG3894444@ls.amr.corp.intel.com>
         <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
         <20230713074204.GA3139243@hirez.programming.kicks-ass.net>
         <d4887818532e1716b5dd8a08819c656ab4e4c5bf.camel@intel.com>
         <20230713090331.GD3138667@hirez.programming.kicks-ass.net>
In-Reply-To: <20230713090331.GD3138667@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6137:EE_
x-ms-office365-filtering-correlation-id: 3d38587d-f544-4663-c03e-08db8382571e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BG7OGDhFUGY94Wd4qe1FCjSQluf3iinNXZApXqtt6GSlNPpaZbEOSJBA8DR4pZgqjqsvhywVTx2t/b0Kz0KlQhCA7q4b2o4pAiabgkayAlMXf1RdgZLp2fzYkAoT+umU1t4idfhLwMMfCcNu0iauWb+75GxUd4WpR5JNFt8hkZyxPkC0glZK+985O83NnI8qLwioqwdKygCSHq9A2S9YtW8iA0jbq0LISkG4QcGE83NRraNKwBxhzX2N/ZPFq+qBZT3UulqKXf8QXJQWcRuWimOhFrGb4fM7X2yS1IKi+LQcvcFBQlKcaC+Sw7rNVODUOKcRT/4V9khB4y0F//K1uIKd7SY0JASHNKZ/pbVTcyCPjoa6MH9vcuIXy0XQoy3B026Wbr/RmFoLcwbIfNrWph0qvyucXmdno1HlHEAGUjVkrLkwP4s27jXNzFh4LFmWX7T7scGniR6VEEnVgOM9p/rzvc0AkkivaTkAJBdbd9hovs/R/3R4RMg4K7wFEeOR+xWOhHBjhr9kZa5IJIlrWsgeiRT/HoZF5PV4LDRC5tIdYh6im5FLAvFra8KK12lApQlpQB3yWExb9Y1+2JIqNoGTqRCfAQ/YAaujjdmyVkS49qKe58TlP8zyU3OcfBZE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199021)(8676002)(8936002)(478600001)(5660300002)(186003)(2616005)(83380400001)(7416002)(6506007)(86362001)(26005)(41300700001)(66899021)(6486002)(71200400001)(316002)(6512007)(82960400001)(66446008)(36756003)(66556008)(64756008)(66946007)(6916009)(2906002)(76116006)(4326008)(54906003)(66476007)(122000001)(91956017)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjhVUDdpa3JyeXAwR29wWE42Yzh5WGdMdDVQaHpSbzdtRTk5WnU0RCtxNUh1?=
 =?utf-8?B?bFFmSFlTNWRUMGJoVkJPS2E3bkhxTDJnMkRBOWRsOXhPVkZpU3hWcEVMWWhk?=
 =?utf-8?B?UUtGdytaVkNWVUZTd0Jub3lkOU43bVFpZDNRczA5SXV6WjBoc29EcGtQV0Iy?=
 =?utf-8?B?ZVBHczZFZkpXQ3ZBUERpdnRmMWFOMElYb2JCbi9DVVpRclB2NmlTbGFJT2dP?=
 =?utf-8?B?VW1Xa2RZOTV5czVvOHRRWnoyRHRiaWhqMEkzMFQrcUdXazVVWE1BajJ1NTVB?=
 =?utf-8?B?WTZLSTRtNXZQeVE5T2JlMTJnRXdCVCtmTWo4Z1VDRlA0RFN1ZW15RnBBS1VO?=
 =?utf-8?B?dkRUazZIbzFSODVyVERlZDFvRm5jSUdpVEo0bDhRNjVGNWorWGlzVlNhNENK?=
 =?utf-8?B?QkRhejAwKzR6VnBFV2NtbTJiUFlFbnczNzc1ODJtV2UveFF2dUpHU3E1ZjNS?=
 =?utf-8?B?bHd6U3E0NjNvZTRRK281SndFL2trakRFVHBOTEdWbytSYXRXa0wrT3NOZXU0?=
 =?utf-8?B?Q1JsNHoyejh3M2NCTFRiVXJpUTBOeDhQZURqaEF6VHNsMGpuKytVSkFsamJ2?=
 =?utf-8?B?SmxNSEJQVUVUbDBTOHUxM205RGlBcnBLS2lvSzFYbDJiQng3SGc5UGFFNXEy?=
 =?utf-8?B?R2JDVUhGN2YvY3daYm1SczR0MTdBTWd4RG9YeC9RTWtVdktwRWgwbkR2aExR?=
 =?utf-8?B?MGxkTEtRUk5Rbk9ua05zckpvR2VDUzBCSU1lL0RaQ1hZZXgycFp1cFRTTFB6?=
 =?utf-8?B?ZFR1RlBtdkhxak4ycFBFNFBaVE5mMm5pV2RBN2graTFrdHFraGVyV1RudllL?=
 =?utf-8?B?Rm82UmxkSGpNYjFBQ3lMYzhNSDU3RmZyaElBTzM1SW9PcngwcDNmcWJ2czdy?=
 =?utf-8?B?RjdYQ0RxM0hzU3FpZHJ6WllicGM0NXk5bjhLNXFGc3E2N24xbXF1ZmhaM2ZF?=
 =?utf-8?B?VDltblNkTFlTcVpNSXNZaGxzYXk4eGhjSGp2djh0WWFkMzUrN3NpcW9lRXNP?=
 =?utf-8?B?cE0zb0hXV1VtV2xkVTV0czR3RkRMMlJES3ZCVkdnRlJPeGlEdEpNWXU3MmEv?=
 =?utf-8?B?dzdCUnRDUEFGMFJhMUxrb1dpN1N5QlFzKzRZaHBadGZYL3ZtZXNlMjJvSlpX?=
 =?utf-8?B?WkV6d0VCSVhzWG5sNTRrTy84RFZ3UTJReEZWYVdyb3UyNFcxYndEbVhyMXdp?=
 =?utf-8?B?SmYzdkwyTlFzMnplZmFncU54WXhXYVQrSVJUWXpML01sd0VBRnNpNEhaOU1w?=
 =?utf-8?B?NFRRY05sOVJGanZ5WXM1ODNMdk1Xb2dBc2VicTlMaVptdlVPU0NiZnBwT0ow?=
 =?utf-8?B?cVpaWFdsdUExYmcrcXRQdFAxZUtRRGhPVEFiY3NwdEVuV1dOdks5eUo0c3pJ?=
 =?utf-8?B?bmlxTHg4U0xlTE5WUC9XbnpBbjRpRzEvU1FmVktPdGI0S3NMaEFjSVlGWXl0?=
 =?utf-8?B?WDN5RFRvcFh2VzM2ek1JV2o1ajQ2NmxzcnB3Q2ppbEIyeE5HOVpKN2xHV2Qv?=
 =?utf-8?B?YTRDM1dEbG9zUzJWOXFvK045blBLbnQvUVMvdjEwYUZaSUd5TVB4cEFPNHVl?=
 =?utf-8?B?cnM2VnVqa2FVT3dSbml4UUFqMFByWFdRUmRVTTFXcjFvVTQyY3lnMmxDRnlT?=
 =?utf-8?B?K1d3bkdZNkdrdmwwY1F4N29uNTgwNGRSbW1QbldpekxhTDd6dVBxSkFTOTYr?=
 =?utf-8?B?dUpPWHUrMmU2K3JZeDNodEFoL3pwMVdnOXlFZ05mMW9Qay9XaUV5VDlhcUZj?=
 =?utf-8?B?RHpzUjAzLzY2bHhYdm9LZ2R5ck9aSkR1S25OVXhVTUpOeFVFUDVPTEc5bUtx?=
 =?utf-8?B?WlFOZ1FTSFhXYitQTDRvWWk4S0U1V2lJWkYxWlN3WSt1WWVLeUVPVEVaU1VK?=
 =?utf-8?B?eUZENGR5bjV3eDMrb1JDMkxPYSt3Z3hwUkd5SHBLWjF3aG9JbzFCT3ZiQy9n?=
 =?utf-8?B?d1d1ajMvQnU2OHJ0V1FPb0JYK1h4VEsvRDVKNmVSYW5SdGxZNnJ2RG9Nd3F0?=
 =?utf-8?B?aGFBUG80Nk1Qd1RZZ0NFQjVxWHlMS1pkYnJOaGIwOGxsVGdRdXVXc0EwMkJC?=
 =?utf-8?B?KzVzQXVGV3JIOG5kWHdReXlPMkQ1aXVlMWo1N1dLejJhVWVxNHh6UVViOGdU?=
 =?utf-8?B?WEpkdmVPNHhPbUtwRy9MOWZwcWREK3ZJV3BFREJZMmhhR3IyN1NXVEdZc21i?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFC56711CF8A1D4F8A9E03893D6A335E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d38587d-f544-4663-c03e-08db8382571e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 09:20:03.3204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GO8RaS6dUN5qmj/VvfYclI5DJCdmVJ4v/fF+XmxJb7MuGviIanHHRqsreO9fWedX9jVaeKZnY21Jny6m0DCqOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6137
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA3LTEzIGF0IDExOjAzICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDg6MTg6MDlBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBUaHUsIDIwMjMtMDctMTMgYXQgMDk6NDIgKzAyMDAsIFBldGVyIFppamxz
dHJhIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBKdWwgMTMsIDIwMjMgYXQgMDM6NDY6NTJBTSArMDAw
MCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gT24gV2VkLCAyMDIzLTA3LTEyIGF0IDE1OjE1
IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+ID4gPiA+IFRoZSBTRUFNQ0FMTCBB
QkkgaXMgdmVyeSBzaW1pbGFyIHRvIHRoZSBURENBTEwgQUJJIGFuZCBsZXZlcmFnZXMgbXVjaA0K
PiA+ID4gPiA+ID4gVERDQUxMIGluZnJhc3RydWN0dXJlLsKgIFdpcmUgdXAgYmFzaWMgZnVuY3Rp
b25zIHRvIG1ha2UgU0VBTUNBTExzIGZvcg0KPiA+ID4gPiA+ID4gdGhlIGJhc2ljIFREWCBzdXBw
b3J0OiBfX3NlYW1jYWxsKCksIF9fc2VhbWNhbGxfcmV0KCkgYW5kDQo+ID4gPiA+ID4gPiBfX3Nl
YW1jYWxsX3NhdmVkX3JldCgpIHdoaWNoIGlzIGZvciBUREguVlAuRU5URVIgbGVhZiBmdW5jdGlv
bi4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBIaS7CoCBfX3NlYW1jYWxsX3NhdmVkX3JldCgpIHVz
ZXMgc3RydWN0IHRkeF9tb2R1bGVfYXJnIGFzIGlucHV0IGFuZCBvdXRwdXQuwqAgRm9yDQo+ID4g
PiA+ID4gS1ZNIFRESC5WUC5FTlRFUiBjYXNlLCB0aG9zZSBhcmd1bWVudHMgYXJlIGFscmVhZHkg
aW4gdW5zaWduZWQgbG9uZw0KPiA+ID4gPiA+IGt2bV92Y3B1X2FyY2g6OnJlZ3NbXS7CoCBJdCdz
IHNpbGx5IHRvIG1vdmUgdGhvc2UgdmFsdWVzIHR3aWNlLsKgIEZyb20NCj4gPiA+ID4gPiBrdm1f
dmNwdV9hcmNoOjpyZWdzIHRvIHRkeF9tb2R1bGVfYXJncy7CoCBGcm9tIHRkeF9tb2R1bGVfYXJn
cyB0byByZWFsIHJlZ2lzdGVycy4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJZiBUREguVlAuRU5U
RVIgaXMgdGhlIG9ubHkgdXNlciBvZiBfX3NlYW1jYWxsX3NhdmVkX3JldCgpLCBjYW4gd2UgbWFr
ZSBpdCB0bw0KPiA+ID4gPiA+IHRha2UgdW5zaWduZWQgbG9uZyBrdm1fdmNwdV9hcmdoOjpyZWdz
W05SX1ZDUFVfUkVHU10/wqAgTWF5YmUgSSBjYW4gbWFrZSB0aGUNCj4gPiA+ID4gPiBjaGFuZ2Ug
d2l0aCBURFggS1ZNIHBhdGNoIHNlcmllcy4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoZSBhc3NlbWJs
eSBjb2RlIGFzc3VtZXMgdGhlIHNlY29uZCBhcmd1bWVudCBpcyBhIHBvaW50ZXIgdG8gJ3N0cnVj
dA0KPiA+ID4gPiB0ZHhfbW9kdWxlX2FyZ3MnLiAgSSBkb24ndCBrbm93IGhvdyBjYW4gd2UgY2hh
bmdlIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCkgdG8NCj4gPiA+ID4gYWNoaWV2ZSB3aGF0IHlvdSBz
YWlkLiAgV2UgbWlnaHQgY2hhbmdlIHRoZSBrdm1fdmNwdV9hcmdoOjpyZWdzW05SX1ZDUFVfUkVH
U10gdG8NCj4gPiA+ID4gbWF0Y2ggJ3N0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MnJ3MgbGF5b3V0IGFu
ZCBtYW51YWxseSBjb252ZXJ0IHBhcnQgb2YgInJlZ3MiIHRvDQo+ID4gPiA+IHRoZSBzdHJ1Y3R1
cmUgYW5kIHBhc3MgdG8gX19zZWFtY2FsbF9zYXZlZF9yZXQoKSwgYnV0IGl0J3MgdG9vIGhhY2t5
IEkgc3VwcG9zZS4NCj4gPiA+IA0KPiA+ID4gSSBzdXNwZWN0IHRoZSBrdm1fdmNwdV9hcmNoOjpy
ZWdzIGxheW91dCBpcyBnaXZlbiBieSBoYXJkd2FyZTsgc28gdGhlDQo+ID4gPiBvbmx5IG9wdGlv
biB3b3VsZCBiZSB0byBtYWtlIHRkeF9tb2R1bGVfYXJncyBtYXRjaCB0aGF0LiBJdCdzIGEgc2xp
Z2h0bHkNCj4gPiA+IHVuZm9ydHVuYXRlIGxheW91dCwgYnV0IG1laC4NCj4gPiA+IA0KPiA+ID4g
VGhlbiB5b3UgY2FuIHNpbXBseSBkbzoNCj4gPiA+IA0KPiA+ID4gCV9fc2VhbWNhbGxfc2F2ZWRf
cmV0KGxlYWYsIChzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICopdmNwdS0+YXJjaC0+cmVncyk7DQo+
ID4gPiANCj4gPiA+IA0KPiA+IA0KPiA+IEkgZG9uJ3QgdGhpbmsgdGhlIGxheW91dCBtYXRjaGVz
IGhhcmR3YXJlLCBlc3BlY2lhbGx5IEkgdGhpbmsgdGhlcmUncyBubw0KPiA+ICJoYXJkd2FyZSBs
YXlvdXQiIGZvciBHUFJzIHRoYXQgYXJlIGNvbmNlcm5lZCBoZXJlLiAgVGhleSBhcmUganVzdCBm
b3IgS1ZNDQo+ID4gaXRzZWxmIHRvIHNhdmUgZ3Vlc3QncyByZWdpc3RlcnMgd2hlbiB0aGUgZ3Vl
c3QgZXhpdHMgdG8gS1ZNLCBzbyB0aGF0IEtWTSBjYW4NCj4gPiByZXN0b3JlIHRoZW0gd2hlbiBy
ZXR1cm5pbmcgYmFjayB0byB0aGUgZ3Vlc3QuDQo+IA0KPiBFaXRoZXIgd2F5IGFyb3VuZCBpdCBz
aG91bGQgYmUgcG9zc2libGUgdG8gbWFrZSB0aGVtIG1hdGNoIEkgc3VwcG9zZS4NCj4gSWRlYWxs
eSB3ZSBnZXQgdGhlIGNhbGxlZS1jbG9iYmVyZWQgcmVncyBmaXJzdCwgYnV0IGlmIG5vdCwgSSBk
b24ndA0KPiB0aGluayB0aGF0J3MgdG9vIGJpZyBvZiBhIHByb2JsZW0uDQo+IA0KDQpZZWFoIHdl
IGNhbi4gIEknbGwgbGVhdmUgdGhpcyB0byBLVk0gVERYIHBhdGNoZXMuDQo=
