Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043AC695CD7
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjBNIYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjBNIYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:24:46 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E732724;
        Tue, 14 Feb 2023 00:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676363085; x=1707899085;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sZys/5dXxHqrAVR9eKkWg6aYc9zlk4g7IFrKvqnuM5U=;
  b=SCLlSbogS8UhJDHHxXVGHzfTBzW+8NLOJVxd5fhvQJIcESnWfEEP1c2y
   fOJY0yN4GgZ+5eUNkQvHTGosEGuEG19ObZI4BuybiACkpvIZzTPC1H6g/
   KGwXyTHHdMun6YAIxrOJk1JnnNXRKkupiB24QU+ehchhZJokGXdXHMw2c
   g1jYJdF0KaC8CGBZSltWH7DYtn4KQHNUwxje/yABa86g8LLYIL5kSNPRU
   jFaeoTJNA6sN1+DQ2d0jea/OG+QNArauenbjjtgq80bORMq9XnTIIPMbt
   5H41sAZjW749hsb1XqZWksFPobUa5f0uYi0j7X6EH34tDHyZMnH5D0BjK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314751681"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="314751681"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 00:24:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="662473206"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="662473206"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2023 00:24:41 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:24:41 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 00:24:41 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 00:24:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z53ph55fuJWdY5LzsvlphoxLVGTT11UCHix+GqipmTPIKpiBo7VYbn5mS+laVni/nVpKbywq4QDWfiCplRxuUn0GLPj0KE+PbnEoNNgjY4Odp4jdNFPHxepSOUjgh8anatqevWzBQko/MjoqVAF+C8fBovawUBCw69FNZLqCTLv2TSV2Rk4o2NRX8x+H2fBfDrJ/SwKMMeo376rgf9v8sF+ow40hnzJVnhZqUaq1F3J13U3Yi+Tzqlzxqt0bmi0Oy82CxokWXElfx4SjODEJY3FIrtIFPIppsmx3LOaPGlNQO+MXUR2ZkYuBmXmZ+8zRs5hW3GYLzeuMsTrsIMxyhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZys/5dXxHqrAVR9eKkWg6aYc9zlk4g7IFrKvqnuM5U=;
 b=eL+e5FX6E/1KS91I7z4P2+m+4LZ0OSyoaT46q8ADClemKAq+AbzYpelCZd+6SU8sJteX/aop52yIn+SeQzDrKD/OppbGFPWzmQmEiesHiFqMhTEsNgZCdLDIQbeUDd1HhpyLpUeeb3tOMGx8++9ve+a6LN55q7A1hLvf7SDicUhvw7AmeAuDPeHTjoONgj72Ulk0iyaCRwlU7Li8dUR2nZVRSshK3ZwKFqpimFRmLdm06qOlClSg/Mf0KKeWLei2Ey4HQ2Y2vXKlMVIoe7GE8faauPPSVKpjKY43RKdT9VT7OnF9YK4J9VTbige/QusmRKTNNSIwby5MGb+LMOdYgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB7952.namprd11.prod.outlook.com (2603:10b6:8:eb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Tue, 14 Feb 2023 08:24:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 08:24:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Huang, Ying" <ying.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 09/18] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v9 09/18] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZP5uyN43fJ2NGzEe/uVwwXTEwfK7NyoJ6gABRzoA=
Date:   Tue, 14 Feb 2023 08:24:36 +0000
Message-ID: <e1c717b36033caf8de9d7a448e06eff88ed0c9ae.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <d7696a456000a37d0059a885c8b197915773980a.1676286526.git.kai.huang@intel.com>
         <871qmsappm.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <871qmsappm.fsf@yhuang6-desk2.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB7952:EE_
x-ms-office365-filtering-correlation-id: 4e0ed894-6ab5-4c7f-ff54-08db0e64e897
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: szSKr4lYKyw/lYmzccf7frGxoPobhpn2eXi/hlLH/1+4SXKRxO2ruaj7WQtZRnWDXZGeD/Cj0TRlXkOEJgTR8oztQDdjui6kObqmGspgJh9kTIWg43KuuIgSg9xBzOu8eWwlSMG8ijFE3JjrprpOGOtjujpGlelr+xpxnq9cVVE8c+CyeyWH0c6U78Arl8u6OU3HD8tNL1aSyXMd0jwK/zDRbiiO3/lWaxUPaAa1+s1GEIYKsmvvmo+QkRwwNSG0yVgNbdKbVCe+Mcq20zEAgM/8++LYlddJckK0uFbpwKIIX2TSFs5h2Iipg9i7zEegBmy5MgWac+n0nYctotkKEJER/2V1qEd3AJR3NW0FgWdMluI5Js/FEZGOj5bpU+1psTaTBBpjac7cPcEuOvxyzn3AMXlwOeS463E4fFf3hoI4HmmGyOnr2dRUaG1f/SCu1tGoeAmddZL4eNnaDv7g/2tc7k3SQV4yqH/+TB+YlotDInAPyDzTuT36xVEZeN/HS+InxYvw4O+S6yhkkiMnA2hg0eoMPw56eTJ00pEmKOVFW1V02EBBFHNmllBwNiW53vK9dYytOePMUt5q/ourtWF7zoJp72YzuL1Frvf/Jy5Ec4DrcM91cx0PKlkmhZWhdz2EyLVuxI9IMioBMZy6eVvLhrVqlKs3ZNJGCCOB+hAKHP5yMqbzfhYjvoIyfzO6p65/921sHrCs6TQiLTSYCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199018)(316002)(38070700005)(6636002)(36756003)(37006003)(558084003)(6862004)(8936002)(41300700001)(66446008)(66556008)(54906003)(5660300002)(64756008)(66476007)(66946007)(2906002)(91956017)(7416002)(76116006)(8676002)(4326008)(38100700002)(71200400001)(86362001)(2616005)(478600001)(6486002)(122000001)(82960400001)(26005)(186003)(6506007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTUvZlZwYXFrZ1FDUk1neVNKZXZDUTA1Zk52NjN2NURVTzZ3MkdqeGNJcGk4?=
 =?utf-8?B?SFpjK3N6MjkrZ1pqVEVnN3ExZ0NQSHYyNVpmeVhjWURONUM1YmQ2bFBjNDJW?=
 =?utf-8?B?NTl0RlN4bVQzYnJheUtoOTVOV01CS1RJS2h2ZVBtdEU0akpTL01POGVKNlVM?=
 =?utf-8?B?MnNjQkxhNEFlZ2M5VzB1SFBwVU8vNFpWNmw5R0huc1hIc2pYU05qb3VERUFD?=
 =?utf-8?B?ek00czFsWDVINXd1UFgzZjhLNFRHNjNUZk4yb0hQM3ZDS3hUdk5wVXZnalFh?=
 =?utf-8?B?RWlFbjVaL3ZPNGhnd05ZQlVwL1BuMEEzUG1xK2xHeUt0SDNVN1FEY2MxTDdo?=
 =?utf-8?B?WGljMVBEVG9FdEJpSTduNWY5dzV1UVFQdFY2alpxMzZYREhrSGczaE1wb1R1?=
 =?utf-8?B?WW91MDRmS3h4dEt2b3c4WTI5TGZsNzNZa2lqdC9zVFJrR3Ewa1lYeVBMamJh?=
 =?utf-8?B?SGRid0MwWVdpaFhmcVFtNHVxY3pwSWE3WFpqUFlsYmdMT2h2QUIzVUNlTjhz?=
 =?utf-8?B?UkF2S2V2VElHVjVFTy9qSWhtRFMwZUZZY1RGelozQTlKb3Y1blhXK0hJNHJw?=
 =?utf-8?B?T3JWZVVZb3dUZlBwaFZPVDE2emFnKzhtcjNqZEU5ZEwwMHpkZlBHRkNYTmpq?=
 =?utf-8?B?VXdSZ0V3ZEFNMGFmVTNISE1KZ3N1MTlnd0VDeGRrbVRlcTJEVmNuVlpBWFM0?=
 =?utf-8?B?Zmp4U1FiN3M2bEpyM0hpdlJpcityWW8zQWNCKzBPZnJGbm4wREY5cHdiQm1E?=
 =?utf-8?B?MDFadC9ZOWF1T2RSeGszbW8zSEVYNjU3eSt2OVlmNzQzaHBCckd1NlhkVkxa?=
 =?utf-8?B?b2UydTlGYU0yellmU1EweXFOY2s4M2RrTFZYbmZWRXdneXBSRnRPMUNHbXZm?=
 =?utf-8?B?Y2duNkNwOHRNd1dVS0ZOMmNZY1Q1dWV1QzFXM2V5U255NE1YcE1hTmE2QzdC?=
 =?utf-8?B?aGhrbi9CQUd0U0pmbzBVaFVodkdoOXJCTGJiU0pUb1dUbjlKUWs5Q2p0aFJS?=
 =?utf-8?B?aEVoSDIzb2diSENLaVNNL3VFT2VwbndwUnJKeGVxMGlBakhHV3QrL0pxcU9O?=
 =?utf-8?B?dDlDRE14d0Nub1dybkFZY0VSQnNJL04xbStZaC9JM3Bxcm16OUpnL1hDSnRp?=
 =?utf-8?B?a3FsbUVocDE5YlVMNDZZbnRXUnVQZUhETzNPYUFxa2I3OHgxSTJTOHdNU1BF?=
 =?utf-8?B?YndVbVYxVU9ReWJXZEFqSHRXdUplYXVneTBKKzg4cEI5aTArUmFyRENOcDBx?=
 =?utf-8?B?bzd2cmRncHovUkNXaCs2SGpCeEFhQTRoOGtEbGQrTHJsWkFxVDR3T2k5a1JD?=
 =?utf-8?B?enJvc0F2UVFnZWE5OVJtc1hIUlVKcm8wYnExT3g3dkZRbzh5SmFqZEFNN0tP?=
 =?utf-8?B?eWJHN0JKZ3dSaUxiZTZNMEtEVUhEc2dQUUkyUDBPaFVGUGZ3S0c1Y05LZmNq?=
 =?utf-8?B?NE1Kbklwc28vdWM4ZXJRQnFZczFjMHJWc1VKUUU3WFdlcEZmdWtCSCt2eXRS?=
 =?utf-8?B?UnIvV2FzQ3lvdzgrOUxXYUZGWmJMcGRHUk5HdWsrdDJrcFA4MUs3TEpiZlBa?=
 =?utf-8?B?bUpXRmxyMHpvY1BPN1FNdVFOeFNNekIxcVNmN1M2RkNTTXVNOGVOTzBzVUNi?=
 =?utf-8?B?bGdFTFFpRW1VN2hsWGRnbkhLNDNNaHVCTTN5YWpFWVhOTDc1N2NvNTdVSk96?=
 =?utf-8?B?Q2ZOUUtLSGk4TW5HUmR5ZjgyQ0ZLWGlyZk9US3phVXVIVXdLMU1GcU05VVlN?=
 =?utf-8?B?Yy9td0dOSW1MT013ZUsrSDJicUJDbnBLNVBzK0hIRjl5aU1lb1lKWlZqRitB?=
 =?utf-8?B?Wm1lNUhIZi9LcE81MEZtNllIbXhCZVU3dTRvZ2daK2lyTVBPTXR3dlJja0Fw?=
 =?utf-8?B?Y2Q2WDdBSGFzRUQvdzM5Y05Mc2YzTndhUnpPdVlEQXRkZWdheFFqNlFmdVc5?=
 =?utf-8?B?Qm9kaDNIdmF0bGNBaDZZOFhuQ25NeUZaTXNnVFpPMVJPRk9PQlRBQU1Zc252?=
 =?utf-8?B?V0syK29JeWtScDluZUNzdFltMUUrMHROd1Jwa2tISGdIc1Fpa0M2OU9wbUVE?=
 =?utf-8?B?dnd1enRFbnlPeFo2VGZzL1huUkFhMm01RmNGQXpPV3dacVJmSTkwOFpuY0Mw?=
 =?utf-8?B?MFlIeG02WTBkSVQxd05qM3YrVjZUMTZtc1lyZGU5ekxkN1hMMWkzeitYNlcx?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48962D8DA28C464CB7F4BB102F089378@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0ed894-6ab5-4c7f-ff54-08db0e64e897
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:24:36.4382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NtxQoWMPDxqxpcT0rcSi9le1fgXQGUwzelLYR3D242kW6r29IK6ENt9H6Ba47dmTY1riGJtvcjbDlcmYv34hrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7952
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTE0IGF0IDExOjMwICswODAwLCBIdWFuZywgWWluZyB3cm90ZToNCj4g
TG9va3MgZ29vZCB0byBtZSHCoCBUaGFua3MhDQo+IA0KPiBSZXZpZXdlZC1ieTogIkh1YW5nLCBZ
aW5nIiA8eWluZy5odWFuZ0BpbnRlbC5jb20+DQoNClRoYW5rcyENCg==
