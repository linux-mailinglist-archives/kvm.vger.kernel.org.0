Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D63740C0F
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbjF1I6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:58:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:41487 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235574AbjF1IcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687941129; x=1719477129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SKfb7cFh3qNIGvweS0gifIhEAkpjr9pZHFihNiIQlIo=;
  b=ereUe0GudYoajtgHloZGQHXCMtYJZ2Cs/ySpVIJ6K6LFgqjqcNwvA7cq
   /7fyvX7tCP3jdgEpX43Z123n0fRBPpFIIbeLQjzf/QgvZZ1fpcV12yXn+
   +KV+pjBq9bw6Rk7bB84E0FYypMJMLT2wOZCg7HUNepidRTltNRAjXjeez
   cXOW1NI4tPNQ1diW7YFBXrqXrUQeL0obUBvq69mrivLEn3oRPbiQbJynU
   wWlf3Ws5/nQvGuSSsWXx3KLV3dS1Tab1zC/kyPORSSYXxHEnQHjZ4nLlm
   vbo7w58kLl4lILRByM/FsXwJgQRtjLoRb/5U1nmPLanvgNPtdehg6BPvd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="361824630"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="361824630"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 01:13:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="716854504"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="716854504"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2023 01:13:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 01:12:59 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 01:12:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 01:12:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 01:12:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ne1+SrItLbIbgD6wiYn0f9mZgLhVb0uTKnY5/ggyxwVtlsq1eC32x07NpjApQ2KGrTYjuu6MAngUAzRLe7Bo9IXZdtT5lMD4gckyfSbfjXiRzbdDSVnwQy7F4Uw/dqRnGKACD4UftLeVkGtS6lym+j7CnXLDAVNuxQIO+G9mWxcwsjoByi0m0QwIev97Y3vftUXav+C5NzY1YLHePF4UOeP6lX9Hj9zR3Nak/gmwrRwoRr9iHLejEnyey8wkqny1TLYp00jxK0cdxhCPCYvE49285jmQI3Fp311WMU15ReQuQjomDva6Tcn6n7/uWPXPQ99TuOxI9rAmGzIeAspk5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKfb7cFh3qNIGvweS0gifIhEAkpjr9pZHFihNiIQlIo=;
 b=lwI+qfeup/2k6KNcYaAsiQbx3XyoLq4Fa5do1A7IwT75QUdUsl4aF1BVlVrJA4GBJXQp8vCuojOvt7Rxo66/e2q0YGeImIBmw96WbDn4igti/A7vT/ohJtm7UZA2mvq9BfIfz3D8MudTsX6W9tcpnJkBh46DEffYcYRexrI3nrMPwDE766KSvJsShSlL15dnhyGXmFRlVeZLd8nmBqssIrh061BIcLBIrM0zwwyNUYndRGm6bH4hfQW2fFWvomki2/HHSR62xIdjj4Sq5l4FYyfEqN9UY2T/L6886SCuJ/3JYbEqsmC/LiHfbEUFKiTUgyL3hmEo+paeE0x3j/LmAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6705.namprd11.prod.outlook.com (2603:10b6:510:1c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 08:12:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 08:12:55 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 00/22] TDX host kernel support
Thread-Topic: [PATCH v12 00/22] TDX host kernel support
Thread-Index: AQHZqDWrNDU9h1kHYkaiWgAIZm82j6+fzRiAgAATKYA=
Date:   Wed, 28 Jun 2023 08:12:55 +0000
Message-ID: <cd5dbba41bee8ad679607a18409863054e5fbdcc.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <20230628070418.6dky65allycok4us@yy-desk-7060>
In-Reply-To: <20230628070418.6dky65allycok4us@yy-desk-7060>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6705:EE_
x-ms-office365-filtering-correlation-id: 7a7dc460-5c6e-4e67-ddd4-08db77af7a39
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NqlhGz97KmCbVi6UucwRizO4FXVwsdIC324p0B7Royo/WGJsQ31Qg9ZmdHeZ+XW1Bz3LLQBQv7RB+5P4lpyZN1cmagIoUjjWBaLSrMFkqHZ1ay8xfPISuDJStj91o9GWAt6xEE5n/wk7Ao3YLUzCI5KOZ5aWJOtCywmrKQ5QXraq4FYRgzjt+PuiIxTMoRNdgNxIMLADx0TSGad+OCuCScRfTmRu9wMJ1HjU0HerI9U8DeMUfqgY7BCJwP+t5WO9wxjoKkQyeCo9x0o/k7M2aZXAUjW6xUeigpgdZOW2XNLCRJuFOJZsVxj58+6rFWaXII3mfRuNRBxD9glCDB9AofRKatVls2fgEFyH0K9frcXis4mTdLni1h36WPdymjg4J9Wd3l9AjQA9ahtAy2MkVJZPMuoXQJCl3qThpERbioh7Mw1yoNN9e16sG3PHwSkd41xArFNIFuUk9SVwZh2h/cVw1U6N1T5RrU+UWrK+PqhRsYaQg6+9cC1FmB58Jj4PZMSbieB7KpZhAuz4uIfCgC2aPZx4gnvIGtDPTA/6u+RjY5pU7CNaX7zEo6G5E1Mcqe3DGm9oZhkb2lBTMhQrIBeaDJ1Co9NSHKCvzG2CnCCTAUT00+Mn4JQ4YyQHpFsb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6512007)(36756003)(54906003)(71200400001)(2616005)(478600001)(6506007)(186003)(26005)(6486002)(2906002)(5660300002)(6916009)(7416002)(76116006)(66556008)(316002)(38100700002)(82960400001)(122000001)(91956017)(38070700005)(8936002)(66946007)(8676002)(66446008)(4326008)(64756008)(86362001)(41300700001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGhVNXBGNmlCQysrUmJ4NTIzZ2ZRSVRheXoweUR3Rk9mRXpUQ1pKYUcrL3Vh?=
 =?utf-8?B?aGNPallvTEJYcmI4bld3WmRRLzJvMlMwcW1TWlRqa0hBZkpVK0UwT3Y0Z0dX?=
 =?utf-8?B?VFUzLzk1V2R6cElrbWZWKzVNRDFJTzhqWklBTzJhcjJPY2hWbTkyRVBtRGhN?=
 =?utf-8?B?TzV6VFdJUzdJQkQrSy9NckRMcE4xQU1XN3ZYYVBTNm9VU0lXTVYwR0gwVmdw?=
 =?utf-8?B?K2FheFhTVGJGSnM5U0hJZndhZGxneWx3c1JTcCtyREFmb1QyeFY3cktlSnV5?=
 =?utf-8?B?RGNpN3Q3YzFaZDFUMWVvOWdiNUM0aXJEcjRGZTA3YkNlbkV0MUtBQ1FrZTVk?=
 =?utf-8?B?TWNLQmd1MXM0amVoczErR1RNb0RkZTFVNTBKM0JnZDhUbGtLbGlnYVlMeEZO?=
 =?utf-8?B?OUtsaWlyeXhZS1hPSUZ4bmtiL3FwYW5ST0hqd2prSjRJYUUxcXhXb1JmdDVL?=
 =?utf-8?B?bVF0OG1ncThGbjNnWUlSVlhoTjFQaXlaWjVzTEhBYlhaZjcwczhOTzJZL01G?=
 =?utf-8?B?c3RPMjVrZ2FWV0sxakphbXlDZmUvQ0tzMmY5RDVCRnZiKzRxOS90Y2tta3Fr?=
 =?utf-8?B?Z3pJOE11Y3RHYmlqQXhXNy8raEVoaXVMWTNEWXZ3NFdTR1MwNmF2ZHc0dFRR?=
 =?utf-8?B?RTA2T2puTlVLRzVyZzFrU2NDSU5jU1FNaWV1VXRrZFhuQm5wRDJiMWM0WnJm?=
 =?utf-8?B?dWtodFNzTHNYc21jWGFEWXhjdHkrUER0cVJrVWE1Z0l4elpHRWZYaXVjSUxp?=
 =?utf-8?B?Nko4L0M2V0FUaGZrZ3VwVjgxQThObXhTMzg1RmF1c0R3TFRkUzBqVFZXaGZq?=
 =?utf-8?B?RFI0UjVwdDBQVmJSNXlQNFEwY3BaWWIzcG5JRUVrQUJJK1N2b08zR0Z2WVVn?=
 =?utf-8?B?UTc4U1lXZDE0QXk4Q1NmbDZ1eVdwSEJaU05LNW41a1h4UCs0NDA1Tjg0Yi9T?=
 =?utf-8?B?aUFZdnhXQ1FZcUowVm52TXlxSGhlUXY0UnFGMW96aVZlQzZuNU8rVDYrUFd4?=
 =?utf-8?B?YnRVUDFwVklQVGdhVXpYQ3M4dkxTQ2dkZWhEQU51M2tEUEtFMWtkV0huM1ZI?=
 =?utf-8?B?eDJvRkE4dE4vOUxaWnpjcDV3dkI5bTgwbDZVU3NaelhXSlpsOEZvRkZYdXN2?=
 =?utf-8?B?WWdheXlNb1grWDVMNlVMNVMyZE0rSjFSTzFNNGlrWDVrTFJtK21UOWFjYTMv?=
 =?utf-8?B?N3ViSkc5ckJBdkxJVjROWnlPYnE3YTBabXlLUVN5aVVDdWNqSUtsYWFFYThL?=
 =?utf-8?B?QlBaaDBJWTlicHRaMm5vUERPYkFtZnhvbWQ1dHJxUVlNUWt5L2tVS2xDS3JP?=
 =?utf-8?B?ZDdPb01ZcTlvU0JSZnJKYmYzTHRWaURsM0lNaDhNNTJoSU4vaTZ6czRpM3NS?=
 =?utf-8?B?MEVnRWtka1dvMTRvdHR2clBFOVQzS0Q2R25yMUtsMTMydU4yanB5Z3NWSDR1?=
 =?utf-8?B?eG5sQ2hJMlhVTGlEb0xuUVc1T3l0cHQzY21CRjhIQVlMbEFYaEdTSjVrdTc3?=
 =?utf-8?B?NUs1dW5FZFBYNHBWcnZla01NbEg1U1RSY1dIbjZFV1R1ckpSZ0xVL0FQbklG?=
 =?utf-8?B?TzZpaHVqdmFzL0dneWFEMExPSWI2eE1FdGZ4dktVVklRN2tYQXR1b2NiTWMr?=
 =?utf-8?B?YnRydU04SHF5RExvUXhjUk5wU1ZWYWg4STJSVTBCQ0RGdStiSTVMMk1Pa3JI?=
 =?utf-8?B?cGduOGU0bDJ4OWlWaTZrNVEya0xwbTVIdlpKN0ZMa1NTVmd0c3BOL3ZtVEhV?=
 =?utf-8?B?K1VwNTRneTd0U0FlZDdGcTdqZll1K0ZpWHdYM2o4bUVtUDl0RHV5VEtUWTNK?=
 =?utf-8?B?enJYYWxIQW1IZW5yWEtydnpzYTI1WGlEVXZZK0VPQjcxQm9ZUXpRU2ZQNERW?=
 =?utf-8?B?aVFwT3c3bzQybE4rak5HTzB0Y3p1TDIycU9EakFvbGVRT2F0SWtjaEhqNVVW?=
 =?utf-8?B?YUE1K0Z2dXBnSEpGRTg4L0FTN2NZeVpGUk51SVdhdlpCaDhNVXF3NFdFNmhu?=
 =?utf-8?B?TDM2SDNBeExZUUphV3pQTDZESTQzd045UVQ2dWlsV1BPSndoZS9sRnN5anQ5?=
 =?utf-8?B?SVNFVjFWSk90V29OTGN2bjBuVGN3SlJoTlRqeDhNNTUvbFlOcWwrR01vb1Vt?=
 =?utf-8?B?QVlzOTUvVEY3VXpWWDl0MG5rR0tGQVF1WmVPN1NhcTE0bXdmZDdKa1I4T0hC?=
 =?utf-8?B?Rnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1ADDDCA121876F448CB5A309DF8A68A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7dc460-5c6e-4e67-ddd4-08db77af7a39
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 08:12:55.6097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7gAX9+d54wxgJVWxHzSCqjfE78xzkFLkW5H5dvaYZ9Qa2sfpxtm/LYksMANPgRziYlY6wAjxJWBOHh4KR3hmMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6705
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IA0KPiA+IDIuIENQVSBob3RwbHVnDQo+ID4gDQo+ID4gRFggZG9lc24ndCBzdXBwb3J0IHBo
eXNpY2FsIChBQ1BJKSBDUFUgaG90cGx1Zy4gIEEgbm9uLWJ1Z2d5IEJJT1Mgc2hvdWxkDQo+ICAg
Xl4NCj4gDQo+IE5lZWQgVCBoZXJlLg0KDQpUaGFua3MhDQoNCj4gDQpbLi4uXQ0KDQo+ID4gNC4g
TWVtb3J5IEhvdHBsdWcNCj4gPiANCj4gPiBBZnRlciB0aGUga2VybmVsIHBhc3NlcyBhbGwgIlRE
WC11c2FibGUiIG1lbW9yeSByZWdpb25zIHRvIHRoZSBURFgNCj4gPiBtb2R1bGUsIHRoZSBzZXQg
b2YgIlREWC11c2FibGUiIG1lbW9yeSByZWdpb25zIGFyZSBmaXhlZCBkdXJpbmcgbW9kdWxlJ3MN
Cj4gPiBydW50aW1lLiAgTm8gbW9yZSAiVERYLXVzYWJsZSIgbWVtb3J5IGNhbiBiZSBhZGRlZCB0
byB0aGUgVERYIG1vZHVsZQ0KPiA+IGFmdGVyIHRoYXQuDQo+ID4gDQo+ID4gVG8gYWNoaWV2ZSBh
Ym92ZSAidG8gZ3VhcmFudGVlIGFsbCBwYWdlcyBpbiB0aGUgcGFnZSBhbGxvY2F0b3IgYXJlIFRE
WA0KPiA+IHBhZ2VzIiwgdGhpcyBzZXJpZXMgc2ltcGx5IGNob29zZSB0byByZWplY3QgYW55IG5v
bi1URFgtdXNhYmxlIG1lbW9yeSBpbg0KPiA+IG1lbW9yeSBob3RwbHVnLg0KPiA+IA0KPiA+IDUu
IFBoeXNpY2FsIE1lbW9yeSBIb3RwbHVnDQo+ID4gDQo+ID4gTm90ZSBURFggYXNzdW1lcyBjb252
ZXJ0aWJsZSBtZW1vcnkgaXMgYWx3YXlzIHBoeXNpY2FsbHkgcHJlc2VudCBkdXJpbmcNCj4gPiBt
YWNoaW5lJ3MgcnVudGltZS4gIEEgbm9uLWJ1Z2d5IEJJT1Mgc2hvdWxkIG5ldmVyIHN1cHBvcnQg
aG90LXJlbW92YWwgb2YNCj4gPiBhbnkgY29udmVydGlibGUgbWVtb3J5LiAgVGhpcyBpbXBsZW1l
bnRhdGlvbiBkb2Vzbid0IGhhbmRsZSBBQ1BJIG1lbW9yeQ0KPiA+IHJlbW92YWwgYnV0IGRlcGVu
ZHMgb24gdGhlIEJJT1MgdG8gYmVoYXZlIGNvcnJlY3RseS4NCj4gPiANCj4gPiBBbHNvLCBpZiBz
b21ldGhpbmcgaW5zYW5lIHJlYWxseSBoYXBwZW5lZCwgNCkgbWFrZXMgc3VyZSBlaXRoZXIgVERY
DQo+IA0KPiBQbGVhc2UgcmVtb3ZlICI0KSIgaWYgaGF2ZSBubyBzcGVjaWZpYyBtZWFuaW5nIGhl
cmUuDQo+IA0KDQpJdCBtZWFucyB0aGUgbWVjaGFuaXNtIG1lbnRpb25lZCBpbiAiNC4gTWVtb3J5
IGhvdHBsdWciLg0KPiANCg==
