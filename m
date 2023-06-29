Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2998F741CC3
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjF2AIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbjF2AIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:08:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE2210CC;
        Wed, 28 Jun 2023 17:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687997316; x=1719533316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZyoBup75/wc1NZ97AWpyIMWLik0sOJasT/e4lhsosnY=;
  b=Qx7XO2CTPKfmNfCxcKDoIMVh3NP8/MWW2VqdDK9nXGkJifmePrtiDHoc
   NWfpL7jxP+J4lp/4Jyf3aGiZUOnX8wXF+LSXNBYAcumVYYR1KGt+M+gD+
   9em3rfTDmSUCl3X8ziIAhcMHujPWV1CrqVLvvsPSjRU9eCnO/O0QVZRgQ
   feAC2cfElh89qHMwcFu6OgPP292QEibrpuZHVVWoWIH5HKcTv9O6faVy7
   Ag9K7ao5EdhHxq8CLifeV303JdOfW1jJn3dI8WamfUn9r0ghekuB8t45b
   o36KUAHV8cndQsgF7bmHSJxVGKNrSC3R4nsurxewFIg0ZK2EYMOZWmiEJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="425661162"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="425661162"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:08:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="717166298"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="717166298"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2023 17:08:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:08:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 17:08:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 17:08:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1zj3vHBnbWcm0akx8EnJLacs8FYtMJE1eo/bvfBF8wqYUVyOW3REWNmTgwq3HPUiYMqBxIYnBPLiYf7GCRkjK+JA8w0l9x2a3in6Qxskxim1AXqX7Y/+FGZ4q58J3b/oKq+gNjTjuuvkZ+XzwkKKNe3q3v66JzSXUNrFC/qZeisyclRuRDM1+POwy4tl/rznYVKSwnyX9TVwG68nd1heEoHB+FfUzzFp77+xzcx78eQF6elQ4BWPIm7tn/ERXR01qWFkfTV9m/l6lEinf7wiPilwzldblhwkD9xWCBV37zij6TXHP5rOZ2xEl5eF5OPP/+KvhmK62S6JjKgP78v5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZyoBup75/wc1NZ97AWpyIMWLik0sOJasT/e4lhsosnY=;
 b=V6NSKdjyjRB91el4bC4qTQ5E28rOA6d1RK7Ywmc8nm//kE4C+ROU3cB3fn3+RjanBt3Xle0Z8N0ICvvie8coketsb5rx0RyMDZon3AjqPIRrVtlp/2lEP+fn/DnyZj7/ENR7aOjv5CiDGM/Q7F23k4/2e8I3HDT6nVLpZ0ac0VNOcjK+RwSSxF7lcOQZYddfL65H2x4ILTOgB0n5CLOFJAIMkndGtHNZ7JG6wIy8xh3pFfGmBL1pvoAcjC1+CsImloGLmvOYMVnGkoW6Fn45KQdNSYT+QMusYnP+yH+JdYH14fweKkjH7vrp0JHrnPiSLvQMfllsHc1vLFi9bPHuCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8250.namprd11.prod.outlook.com (2603:10b6:510:1a8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 00:08:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 00:08:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
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
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+gMs8AgAC4a4A=
Date:   Thu, 29 Jun 2023 00:08:29 +0000
Message-ID: <c1c0f0283e8a1915231052c10ce7e16b5829a64e.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230628130822.GD2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628130822.GD2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB8250:EE_
x-ms-office365-filtering-correlation-id: 7cbebbff-da24-4ea2-cfd0-08db7834f7f8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Harg35XoadW/kweEshokEQVxcig8U9qDdF/YZEeUDUEllWT9/I7sPFRul30QG5HG0RhsG56KAVKXu4MgvhOPmYWnN5XAJUzSvAGiHDHaREKDIzgfk5S3vm4HBXDz2qwMsk2Jdcy0jRZ1lNRbXA0oqIF9F1+eZhJMdch0kLUQat9d6wtS/tNOh/ZsJGOUpGGiUVhHwhxCnSsw2Fo1drC2SzQNUrp8CqqJJPspbjGxtX66wuuu7Vgt/iervFRTpHLdUkZCBW//g4cVxPKjw/fGQ4A86w5G5qeHWIGtljkac+oVik1cSg2jeBPQABlEl5zrAKCK+P4pSIC9bQI78XDJI3BD/EOmirY+aeXCuizSbNKI8K3vscQLAgD45UeS8xy9VedgW0zE0HndiGyCBH55MWEFWiSKphNCOYaIo9Nk1nwMLUioT/qWR2ozSH7wLPmSeM2pPyEWh5ZBZ0BxC7JGixyOqIFf8V2bdX3vA5bTdes6OawhlPdSCsUzVZZkW1rVnih08N7dqy4ioUUiJwBFuKbuHcR4BhDiBP4a2CMUVXxCIMtDBb6Y4BJ6SfhS5cXUgN8PkPJM176kyTGkTQ2UWlhU72NdV84wX+PuajnaszXL0nS/8y1HiFjFpw39/42
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199021)(83380400001)(8936002)(6486002)(316002)(71200400001)(8676002)(54906003)(4326008)(41300700001)(36756003)(122000001)(86362001)(82960400001)(38100700002)(64756008)(2616005)(7416002)(6512007)(5660300002)(66556008)(66446008)(66946007)(66476007)(478600001)(6916009)(2906002)(91956017)(186003)(26005)(76116006)(38070700005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjErZHNBK3grdDd5V0NEYVczUWViY2VOanlnTi83bEZnMHN2eDc5SHRyb3Rz?=
 =?utf-8?B?czRGSUw0KzFlT1ZYMG9YVHVCbVFuVUdQRCt1UENQTkVMRUxwWWs5cmFod1hr?=
 =?utf-8?B?Q3ZxYzA5TWhadWlGYktZN01NZjdKS3RtU3VlUWhzYWhDVjRaaW8xWmV0WE9a?=
 =?utf-8?B?enNTRWU0S0hOOHlqb04xZkNlTjVkcEdsTXNSNTJ5TERjTVBnWWNTRzU5V2l1?=
 =?utf-8?B?VEUxU0g5all5Z3hsbENjMndBOGxXMnBPdUZPQyt3UDBiUUFVaTVxbE1sSXZY?=
 =?utf-8?B?N25DckxqcnlEV1E4czNkd09TcElJMEhlemFtVWdETlpENENmazhhRWVsczhk?=
 =?utf-8?B?LzZrNGxIUTg2eStiUmJEdHp6a29aOW9mVjdKWHdpYjVkK0llb053RGF6clZX?=
 =?utf-8?B?b3pLTkUwaERGTnFCOTZaaDdCMTdBYzFRQzJVVlYzczE0NkRiRlZhbkxzQXZr?=
 =?utf-8?B?M2RPbTRNdXp5eG1jS0NjMy96Z3VxdGw2aXNSZXlNSWtOWFNHTGpBNG9JSHl4?=
 =?utf-8?B?RnUxSGNHcmdSbTc0S1p1dk5GbkxEWmY1VkhqMGFzbTl2bUpxbUYrZFlKQmNE?=
 =?utf-8?B?VVhXR1Q4TGV6K2pQVUJ5QndYa1h4dmE2dytnWW8yZnpSNnF0R1U1ZjhjSDMz?=
 =?utf-8?B?Y2htNnBHSFJlMFBGSWlpa2ZMaVloOUJUanpOY0h6bjNmVFZMZHR1dXZkNHdn?=
 =?utf-8?B?YytKV0dWNWZuNTlrbkEyNExtb0tTWHhESVlRczJTdmVIcE5RYkV1clJ0dzI3?=
 =?utf-8?B?dDREUEdvdThlY0Q0WEhrb2dnRGl2L08zbjJ1cDVKNFNxZ3d6dCtZT1dQblly?=
 =?utf-8?B?ZjdCZUE3OFY2dGhzZkhiWE5LUkJTQ3p3dXFwNnFmNFFkRHNVODIwVjV5bGda?=
 =?utf-8?B?K2FkVVl1dHpha09YcXZIMGE3bkxVa2JtdktkUWwvZ0MvTXRIZEtYUmErU3Zh?=
 =?utf-8?B?NjF1QUJ5SDVHcU8relVWc2V0dG9xYVY4aEpod2EzY3hCWWcxOE5mSGdTV3lU?=
 =?utf-8?B?cDk3Z2lCa3BVN01LQjRpY0szOHczVWt5TTBjYzJJRGc3WVlFQ2x2Y1B0KzIw?=
 =?utf-8?B?VnBzL2NZdXBPNU9IL2pYYmFodEM1LytXNFFHd09LOU9CMzROOFlBUEp4UG5N?=
 =?utf-8?B?K1h0UElNR1dubStHdjViNWJLbVQzM29vUU9vNm54allxRk1Gd3NhZGI4c3Q5?=
 =?utf-8?B?clgxYXN0YjJsUXl4TGZuQ0JOQkpxTzh2WW9FWDhvdllkSEJWbGY0UHJOb1VK?=
 =?utf-8?B?dlFydTBwSHY0cVlWQzlHbDBPRWpjZzdFNllZdmZDaCs0c083ZUljMW5kTitv?=
 =?utf-8?B?VkREWnFPRVNEYitGcWd4ekFNVlJRR1B2MEIvdms5RGNLOTdYRmh5M2hoWUJD?=
 =?utf-8?B?QUxoN3lveDBON2wwOHA0RkJZRlVvc2h2WGdwdStNcTAwRlBkMjgzVDNtdFhW?=
 =?utf-8?B?d2hWOWo4UmE0SEhybmRhb0lXRytMWjFwTnJGci9Sd1JBcUxVeno0YUhMTDFl?=
 =?utf-8?B?SHdGL0F5MlFqbHg3K1hiV1ExSGE5SFpveTBPQTZCd3lENnl3UUNWdjNhQjJG?=
 =?utf-8?B?aHVnY05HM05ZOHlMdmVRM2VvcG50MFVMOWphbmpOdktKQ0lsdXpoakNCN3la?=
 =?utf-8?B?Y0o5NTlpdWR2aWgzK29KeEY5SjhJaldveGFleDJUM1o2MXQxYnNsVktIalJh?=
 =?utf-8?B?cFZPQTZldC9SbnViL2tRRGlSclJlOFBzaVJZWWthTFBaeDJ6VjExZFU3c3lP?=
 =?utf-8?B?SGNIYzVIMzVHU0V4U3hPajdCNnRQS1ZiY3htWW1RVTRXVzNlay9OeFhlRnhx?=
 =?utf-8?B?clprQXRNZ08xbnluRDRiNWpGSUxVbHg1RWJLcUdNcUlEY0tySGh3cTJaK2sw?=
 =?utf-8?B?K0h2QkphV1l3R2R2SzdzdTl4dVg5cWxxN1h0MnhIVzF3RW1aNjU5TzdhU1gz?=
 =?utf-8?B?Nnc1Snh2VkpOOXIxaVR5cHExckxUQnhzakU3NU9wMWswbHo1S2FTT0duczk4?=
 =?utf-8?B?ZExaOUsrYVVZTkp5MmhGM0NKMkZYbVBpWFdjMzZxZWJIR0NPc3pMZWoxdjJh?=
 =?utf-8?B?dE5KTlRQZGx0WWdlWEJPcHN4Y3labnRtMGUzNGluakxMMXV5NU90aUJ4d1BW?=
 =?utf-8?B?cFFNV3BqUE5hUmZhQ0dwZUdOSG43dlZjMlNOZk9EbEhBME1WY1FmN0dEY3Zv?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7B64181FEA86B47B235ADF6ECA96417@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbebbff-da24-4ea2-cfd0-08db7834f7f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 00:08:29.6621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kACK5t7lu3COcwodqbK5RFQb+9JiHxwPCNRs1KA+h+Zp90p7Xw4qptj1mqJDtHSM0wvIh1c2EzOXoaZpLUf9wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8250
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE1OjA4ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6MzdBTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiANCj4gPiArLyoNCj4gPiArICogRG8gdGhlIG1vZHVsZSBnbG9iYWwgaW5pdGlhbGl6
YXRpb24gaWYgbm90IGRvbmUgeWV0Lg0KPiA+ICsgKiBJdCdzIGFsd2F5cyBjYWxsZWQgd2l0aCBp
bnRlcnJ1cHRzIGFuZCBwcmVlbXB0aW9uIGRpc2FibGVkLg0KPiA+ICsgKi8NCj4gPiArc3RhdGlj
IGludCB0cnlfaW5pdF9tb2R1bGVfZ2xvYmFsKHZvaWQpDQo+ID4gK3sNCj4gPiArCXVuc2lnbmVk
IGxvbmcgZmxhZ3M7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBU
aGUgVERYIG1vZHVsZSBnbG9iYWwgaW5pdGlhbGl6YXRpb24gb25seSBuZWVkcyB0byBiZSBkb25l
DQo+ID4gKwkgKiBvbmNlIG9uIGFueSBjcHUuDQo+ID4gKwkgKi8NCj4gPiArCXJhd19zcGluX2xv
Y2tfaXJxc2F2ZSgmdGR4X2dsb2JhbF9pbml0X2xvY2ssIGZsYWdzKTsNCj4gPiArDQo+ID4gKwlp
ZiAodGR4X2dsb2JhbF9pbml0aWFsaXplZCkgew0KPiA+ICsJCXJldCA9IDA7DQo+ID4gKwkJZ290
byBvdXQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJLyogQWxsICcwJ3MgYXJlIGp1c3QgdW51c2Vk
IHBhcmFtZXRlcnMuICovDQo+ID4gKwlyZXQgPSBzZWFtY2FsbChUREhfU1lTX0lOSVQsIDAsIDAs
IDAsIDAsIE5VTEwsIE5VTEwpOw0KPiA+ICsJaWYgKCFyZXQpDQo+ID4gKwkJdGR4X2dsb2JhbF9p
bml0aWFsaXplZCA9IHRydWU7DQo+ID4gK291dDoNCj4gPiArCXJhd19zcGluX3VubG9ja19pcnFy
ZXN0b3JlKCZ0ZHhfZ2xvYmFsX2luaXRfbG9jaywgZmxhZ3MpOw0KPiA+ICsNCj4gPiArCXJldHVy
biByZXQ7DQo+ID4gK30NCj4gPiArDQo+ID4gKy8qKg0KPiA+ICsgKiB0ZHhfY3B1X2VuYWJsZSAt
IEVuYWJsZSBURFggb24gbG9jYWwgY3B1DQo+ID4gKyAqDQo+ID4gKyAqIERvIG9uZS10aW1lIFRE
WCBtb2R1bGUgcGVyLWNwdSBpbml0aWFsaXphdGlvbiBTRUFNQ0FMTCAoYW5kIFREWCBtb2R1bGUN
Cj4gPiArICogZ2xvYmFsIGluaXRpYWxpemF0aW9uIFNFQU1DQUxMIGlmIG5vdCBkb25lKSBvbiBs
b2NhbCBjcHUgdG8gbWFrZSB0aGlzDQo+ID4gKyAqIGNwdSBiZSByZWFkeSB0byBydW4gYW55IG90
aGVyIFNFQU1DQUxMcy4NCj4gPiArICoNCj4gPiArICogQ2FsbCB0aGlzIGZ1bmN0aW9uIHdpdGgg
cHJlZW1wdGlvbiBkaXNhYmxlZC4NCj4gPiArICoNCj4gPiArICogUmV0dXJuIDAgb24gc3VjY2Vz
cywgb3RoZXJ3aXNlIGVycm9ycy4NCj4gPiArICovDQo+ID4gK2ludCB0ZHhfY3B1X2VuYWJsZSh2
b2lkKQ0KPiA+ICt7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCWlmICghcGxhdGZvcm1f
dGR4X2VuYWJsZWQoKSkNCj4gPiArCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiArDQo+ID4gKwlsb2Nr
ZGVwX2Fzc2VydF9wcmVlbXB0aW9uX2Rpc2FibGVkKCk7DQo+ID4gKw0KPiA+ICsJLyogQWxyZWFk
eSBkb25lICovDQo+ID4gKwlpZiAoX190aGlzX2NwdV9yZWFkKHRkeF9scF9pbml0aWFsaXplZCkp
DQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIFRoZSBURFggbW9k
dWxlIGdsb2JhbCBpbml0aWFsaXphdGlvbiBpcyB0aGUgdmVyeSBmaXJzdCBzdGVwDQo+ID4gKwkg
KiB0byBlbmFibGUgVERYLiAgTmVlZCB0byBkbyBpdCBmaXJzdCAoaWYgaGFzbid0IGJlZW4gZG9u
ZSkNCj4gPiArCSAqIGJlZm9yZSB0aGUgcGVyLWNwdSBpbml0aWFsaXphdGlvbi4NCj4gPiArCSAq
Lw0KPiA+ICsJcmV0ID0gdHJ5X2luaXRfbW9kdWxlX2dsb2JhbCgpOw0KPiA+ICsJaWYgKHJldCkN
Cj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiArCS8qIEFsbCAnMCdzIGFyZSBqdXN0IHVu
dXNlZCBwYXJhbWV0ZXJzICovDQo+ID4gKwlyZXQgPSBzZWFtY2FsbChUREhfU1lTX0xQX0lOSVQs
IDAsIDAsIDAsIDAsIE5VTEwsIE5VTEwpOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlyZXR1cm4g
cmV0Ow0KPiANCj4gQW5kIGhlcmUgeW91IGRvICpOT1QqIGhhdmUgSVJRcyBkaXNhYmxlZC4uLiBz
byBhbiBJUlEgY2FuIGNvbWUgaW4gaGVyZQ0KPiBhbmQgZG8gdGhlIGFib3ZlIGFnYWluLg0KPiAN
Cj4gSSBzdXNwZWN0IHRoYXQncyBhIGNvbXBsZXRlbHkgaW5zYW5lIHRoaW5nIHRvIGhhdmUgaGFw
cGVuLCBidXQgdGhlIHdheQ0KPiB0aGUgY29kZSBpcyB3cml0dGVuIGRvZXMgbm90IHRlbGwgbWUg
dGhpcyBhbmQgbWlnaHQgZXZlbiBzdWdnZXN0IEkNCj4gc2hvdWxkIHdvcnJ5IGFib3V0IGl0LCBw
ZXIgdGhlIGFib3ZlIHRoaW5nIGFjdHVhbGx5IGRpc2FibGluZyBJUlFzLg0KPiANCg0KSSBjYW4g
Y2hhbmdlIGxvY2tkZXBfYXNzZXJ0X3ByZWVtcHRpb25fZGlzYWJsZWQoKSB0bw0KbG9ja2RlcF9h
c3NlcnRfaXJxc19kaXNhYmxlZCgpLCBtYWtpbmcgdGhpcyBmdW5jdGlvbiBvbmx5IGJlaW5nIGNh
bGxlZCBmcm9tIElQSS4NCkFzIEtpcmlsbCBhbHNvIHN1Z2dlc3RlZCB3ZSBjYW4gZG8gdGhpcyB3
YXkgYXMgZm9yIG5vdyBLVk0gaXMgdGhlIG9ubHkgdXNlciBvZg0KdGhpcyBmdW5jdGlvbiBhbmQg
aXQgZW5hYmxlcyBoYXJkd2FyZSBmb3IgYWxsIGNwdXMgdmlhIElQSS4NCj4gDQo=
