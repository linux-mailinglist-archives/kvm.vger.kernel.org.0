Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107A3741D69
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjF2A5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjF2A5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:57:19 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F002123;
        Wed, 28 Jun 2023 17:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688000238; x=1719536238;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h/nVDrsDF7Mjf/JYL2FBvTv4mhHApAgRQtSfRbmLyWM=;
  b=WTKvJ2f3tuBq2U0yta7w9GsY5GoCcTYHn5oZD+kziRnXfHYnw/yEsTtE
   BE/Ue4Gxb4OclAZufKsU3wnFHbW+F57mk7775rXufWqtwVtUtSZYwhicn
   VCaKhH1VKFw5K8C+4Z11502WYeO/SkHyckHYz7yKjo4d3/8aBplYO9d5g
   WYp6HrvVncf7CezHt56bUrYUwTgdVI6rNDZqQ0MHYQ0IBv23ws63pv8xG
   NordOZyGlX+Cy+JmuGqm4ckFavIYUQIy4/JhIfuSPi/K87mKo8wGUJD2a
   SzTO/0pZv39/6GAijAHMRbzUfPnLeuMJ8kCXgV6m26UKRjs3Rvi01hIuB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="360847813"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="360847813"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:57:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="717177555"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="717177555"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2023 17:57:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:57:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 17:57:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 17:57:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7ofBJLyMOzPugHGrWpBqs0HyukViSM5+cmI7zOMnnvr7JIFhXhl2GqR3BKkJADv9haY6V2GU8m6U0HYM9Mj/IpcoxZOE0zDuz49ur3G5LBJz2SEq9RNcjPQJbKe9e+cN4tbYtvBJ47Q7+94TjiWhCJAeJL3tTsr2WT/uFIBJzMTbtiSoO2Mj3s9ccC49VkYYpcq/XJpG/SKCQ9+gglHS9XF68OHKTNZyJ/8JDSrTgCKnS2ald8fcFKWlICdM7Lx2xaaMQXyQObtVj8KeBX9r3FYJu6qZ0262/KIq79lTXGz7+p0gBwHaAhZ2VJ9/hCYlxZiDiBnujA2UFJSra2R1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/nVDrsDF7Mjf/JYL2FBvTv4mhHApAgRQtSfRbmLyWM=;
 b=Sk4NA/xvOik/h0KhOT7TPkT+AHjZvhcee21mVqwlZQRy91dNluqzVKtaPktRdRYFd5N8eK7wQaP6iqJgESiiKYWMyrlb1IIgCkStShXMJIK1ks/G5X5D+zAq2Er3Yt2IUeuXD7zkjdLcIyhOfhsgbtsDCkoi1G22WIJ74cZNsCEWSXNT4usIrJkDcFAL44insPTFpVX4WsPlwVnaFPca0CmXlzXw1lxofGPKIyv/M7aqu5a9tnNSClESCmxeNcPjZ9kDw8rLRnr2l+03ytz4iDJ9eYx9RHDfGQWcjFDWD+v+6GhGBZaKsSWYDBgvrGdptQrlXn1gA1AlxdALwIhIOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7189.namprd11.prod.outlook.com (2603:10b6:8:137::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 29 Jun
 2023 00:57:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 00:57:13 +0000
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
Subject: Re: [PATCH v12 09/22] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v12 09/22] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZqDWtkbP5LQszokWyXqcsetG/aa+gRjmAgACynwA=
Date:   Thu, 29 Jun 2023 00:57:13 +0000
Message-ID: <08e4cfc22d5e7983d5c0973d25fd6ed2cb0e6fb2.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <999b47f30fbe2535c37a5e8d602c6c27ac6212dd.1687784645.git.kai.huang@intel.com>
         <20230628141751.GH2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628141751.GH2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7189:EE_
x-ms-office365-filtering-correlation-id: 3a2b626d-b3f5-4d9e-c05f-08db783bc6b5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3bM3mOlSD2eq0aBDIipLq6h13NL3edkrKRqy7LCug5sDZeWdJj3Kz4cAe1YxXi/8GO57x3BLsfhiO+IsMGpyF0jiBQzxCEaxo3MeRTGIoExv/RXzX4IjsTjXt0NMmgsHZtsbwcFaWUCixWo5A0rSX/1xyIDkRAeUh0hXlub5ANxyNRiInGsS/rPduqF2UXOCAlUoGl7nPV2rV1Bf7paI9Z1xwp4apHTo4XlO7zIf2La3Y4yzRWwARjXHw7oLIyNNskqW+XtMqxdaIh3du5n7S0WP/WSyR/ypSDIi61rShSyRNbBWmipuwb1jwp9M2rs03yVMJdiLcao13ilAd8d8jtmw+qQ+d250BWmn370++TgnpXmlgarcTMd0XpNoUX9ghe6iKxXlzH77zHe1BPUJ18Yvm5fuFIYtJUTAAynQsyjALOKeBtizGdkZ0zHty+r37AsluJPovVHMlkyMj8yIK5McOvRTMySWJw9j0VX7wZ/WU/lxFlOQVT0zjOFZd9MlGZ6X1z3msCsCveMeFWoW+O6bKjXxCRHsrB5wHJ51NQqG9LuA2zjqlip85njR9VSlsUQFX4i9YrgpNbaJo2cHOZSIMyq16jUcjPC5CUxcbwNm2qWqK1IGMyDdgSlJDkuD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(6512007)(2906002)(186003)(6486002)(71200400001)(122000001)(2616005)(83380400001)(38100700002)(82960400001)(6506007)(26005)(86362001)(41300700001)(54906003)(38070700005)(478600001)(316002)(36756003)(76116006)(66556008)(66446008)(4326008)(66946007)(91956017)(64756008)(6916009)(66476007)(7416002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2wrTHhKcFdsa3NLNjFxUWt6M2hrNjNQbG1iVDA5TFUxelY5WnZYaXhHMDVn?=
 =?utf-8?B?TzZRbXdaay9jQVhBeDB1NEgxcUx1VEtaek9XV0N5Mm9Ob01YeXFnVGxkOHZI?=
 =?utf-8?B?YjU1dkx3bDl4Tjc3WG9RV2pHUEF5OEFYSXh2aEF0dXFYM3J1Y1NuSlBnaWhG?=
 =?utf-8?B?UHVUWjdva2ZMTTY3eUdLWUI0TjZHeTNGQzBmdW5hdko1VmJKZHVoOHlDQVJG?=
 =?utf-8?B?VHA1TlpUSDRDUVNOOEdBT3YxcmxiN0RqNk9nOE5MVXAwQ1dlTTVzY0taK01I?=
 =?utf-8?B?aGtDd3Voa1pYU1dIdTF3c2RvTWZqQ1RGenNpc0JQbXBqN1pTWTk4U2E5NGt0?=
 =?utf-8?B?SC90TkFzV1FVTWNIZHVHU2JEWlNhaGk3ZWxwczJYRzZHdm1qRHFseWthbWJ2?=
 =?utf-8?B?Ty92OGxMUkZYN2lYSU9ab3VaV3ljclRXRWJMemJwaWJLOGJOaEl4QktSL3d4?=
 =?utf-8?B?WnlLMVZlVUg4RW83QTY3YnYzTjZZWGd2cjJGZ00yTzFlU1R0VUwreFFQOVhk?=
 =?utf-8?B?b2dvQ3UrczYzdFFhMGM2UHA4OFBtNVBSbWpDeStXYUkwSVUyUmp2WnlwNnpI?=
 =?utf-8?B?cVFITXlwYkZOOW54ZFpnRXNLVGtwaXRXYVJxRWUwWmFWdlZzYVhHb2NoUS9R?=
 =?utf-8?B?M3FyQUh5Rkt5aFJhYVIvZDQ4R0JiSTJCZ0NlazZKRzJ6WkVCOWlnNGJWK2Vr?=
 =?utf-8?B?K01wVWx4bjl6endzVHBiaXIwdGFISldKMXRsMmlGMjhZNFRpSlAxZXprdTk2?=
 =?utf-8?B?amZyc3ppc093bWV3MjdsUGtGT2psdTh1YWxOb3dVbFdWUkhLREZUdS80dmlG?=
 =?utf-8?B?cTdEYlBaT1pRRzJ4UE5rVDdWUGRUWEtWNFlnVlI3MFB5c0NEdXdoNk0vVW5p?=
 =?utf-8?B?VGhBbDRFNGlhK2QvV3JzN01tSmMvekViTDJ4RnJHUnpPS0tNeDR0ejk4K0Ey?=
 =?utf-8?B?Ty9xZ1NCendOWmN2RGtsUXNERHJ3dmZVMGMwZ203cDRmd2IxdDE5SnFRWi9p?=
 =?utf-8?B?V25ZS2QyOFFKRTBlQzFNTGxSZ1JYQ3lzd3Q2ZlgwK2MvZUxqUEl4VlcrZ1pY?=
 =?utf-8?B?NTVNeElDTFRReFRzdHN3eGZPNUZ2N2JHQjNueXY3L1BPNFpqVzlFakVZKzZP?=
 =?utf-8?B?aGhQanU2MHhuNzZzSTVOWFJ3SDNXa1VlWno3TC81cXNabVI5Z1FNNDR2TVZK?=
 =?utf-8?B?V1psNkxyV0FmUjJOL2lTa0s5cXgreVdLbFA4cnN1RjNxSStHQjUvNGhyNXBT?=
 =?utf-8?B?bG1GcW9jQ1dXZDV4cklYZEc3T1Byb2FlVmh0ek5xWFl6UEx4MVh2b0ZMNmE2?=
 =?utf-8?B?UXZsczVzOGlybjIwZXBFNTROV0R0a1V5THE1QXg1VjBsZ2IydUZzS2JCM2hn?=
 =?utf-8?B?VWh0d0tCSVJSN0Q4WmVWejVDMU9zaUE3ZG5mUDFBOWs5MGVLd24wdjErQ0Ju?=
 =?utf-8?B?d3dsZi83U1NHclk3TWhZSUd0U3NKNnlxOWg2U3JJTzVhZitGRVI5ZUdOR05P?=
 =?utf-8?B?NW5KUmhORUM5M1V0enBVb01RRGdlNFZGSjlIZGczc3Q4TjJoQlhyMkFHa2Jz?=
 =?utf-8?B?RnpXNEVzbVRtL0k3NmRSV0tFbkVNZDR5TitOai9MVjZQYUpwT0lLT0lJYlVP?=
 =?utf-8?B?b0pOME1uVmJwcGpPVjJvcFFjSEJlb1pnSjBPSzB2QXhReU1ZS3B4QXgyNmNp?=
 =?utf-8?B?aGRxL1lDcEFSWStRVm9sbWcwSEp1ZjczTU1KNytDNGxGZWZQb0FLdm5NWEUx?=
 =?utf-8?B?aThLVGhLSGEySDBQWDlka3g4VVJDOWt4YjRmS3ZOTC9vL0NBM05rQkpDb1Ba?=
 =?utf-8?B?dUVTZHI0b21KMkhJY2k1WklCQXNhWUw1UjFxbzNhSXBYc3k1NENFa0N2OFV5?=
 =?utf-8?B?Zm9jamUyRlZzdUVQZmpnQUpCSmV5eUl2bHRqeTRnRG5Fdjg1UGIzRUZPQ2sw?=
 =?utf-8?B?YzRhY29salZrbnFJMU92VUVjd1g0YjJlTjU2SnhtMXRhSjh4R1ArNGdCRDVG?=
 =?utf-8?B?YUVRbW1oZi8wSUdEUlA0UzQvbTVXVzFQQ3F0Y0gxZGc5dmo4cEl4TjV4TEVq?=
 =?utf-8?B?RGJpNm5VWE1vaEFONWVsTnJIM2FhL0ZoWDRqdGlyNmNhRHNvaUgxaFh3dHd2?=
 =?utf-8?B?cyt3MlJnVWNqZm14NXduWEwvcU1vWXdSclQ5L3p5V1ZFVVV3Q1JLYVRTNFVv?=
 =?utf-8?B?VWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E5CCE81EC248F43A5AD3E79F3C4369A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a2b626d-b3f5-4d9e-c05f-08db783bc6b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 00:57:13.4921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0eXzSml+Y+SU5+L5KgBWTXVdO7Z0d97fkdVv3vbvTVC6K4YRqh8xxcsbFw4UCoeP7VeBf/3d0RMzvGUKLfg15A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7189
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE2OjE3ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6MzlBTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiANCj4gPiArc3RhdGljIGludCB0ZHhfbWVtb3J5X25vdGlmaWVyKHN0cnVjdCBub3Rp
Zmllcl9ibG9jayAqbmIsIHVuc2lnbmVkIGxvbmcgYWN0aW9uLA0KPiA+ICsJCQkgICAgICAgdm9p
ZCAqdikNCj4gPiArew0KPiA+ICsJc3RydWN0IG1lbW9yeV9ub3RpZnkgKm1uID0gdjsNCj4gPiAr
DQo+ID4gKwlpZiAoYWN0aW9uICE9IE1FTV9HT0lOR19PTkxJTkUpDQo+ID4gKwkJcmV0dXJuIE5P
VElGWV9PSzsNCj4gDQo+IFNvIG9mZmxpbmluZyBURFggbWVtb3J5IGlzIG9rPw0KDQpZZXMuICBX
ZSB3YW50IHRvIHN1cHBvcnQgbm9ybWFsIHNvZnR3YXJlIG1lbW9yeSBob3RwbHVnIGxvZ2ljIGV2
ZW4gVERYIGlzDQplbmFibGVkLiAgVXNlciBjYW4gb2ZmbGluZSBwYXJ0IG9mIG1lbW9yeSBhbmQg
dGhlbiBvbmxpbmUgYWdhaW4uDQoNCj4gDQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIEVtcHR5
IGxpc3QgbWVhbnMgVERYIGlzbid0IGVuYWJsZWQuICBBbGxvdyBhbnkgbWVtb3J5DQo+ID4gKwkg
KiB0byBnbyBvbmxpbmUuDQo+ID4gKwkgKi8NCj4gPiArCWlmIChsaXN0X2VtcHR5KCZ0ZHhfbWVt
bGlzdCkpDQo+ID4gKwkJcmV0dXJuIE5PVElGWV9PSzsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJ
ICogVGhlIFREWCBtZW1vcnkgY29uZmlndXJhdGlvbiBpcyBzdGF0aWMgYW5kIGNhbiBub3QgYmUN
Cj4gPiArCSAqIGNoYW5nZWQuICBSZWplY3Qgb25saW5pbmcgYW55IG1lbW9yeSB3aGljaCBpcyBv
dXRzaWRlIG9mDQo+ID4gKwkgKiB0aGUgc3RhdGljIGNvbmZpZ3VyYXRpb24gd2hldGhlciBpdCBz
dXBwb3J0cyBURFggb3Igbm90Lg0KPiA+ICsJICovDQo+ID4gKwlyZXR1cm4gaXNfdGR4X21lbW9y
eShtbi0+c3RhcnRfcGZuLCBtbi0+c3RhcnRfcGZuICsgbW4tPm5yX3BhZ2VzKSA/DQo+ID4gKwkJ
Tk9USUZZX09LIDogTk9USUZZX0JBRDsNCj4gDQo+IAlpZiAoaXNfdGR4X21lbW9yeSguLi4pKQ0K
PiAJCXJldHVybiBOT1RJRllfT0s7DQo+IA0KPiAJcmV0dXJuIE5PVElGWV9CQUQ7DQo+IA0KDQpT
dXJlIHdpbGwgZG8uICBUaGFua3MhDQo+IA0K
