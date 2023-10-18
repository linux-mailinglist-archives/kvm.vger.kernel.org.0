Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26547CD7B2
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 11:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjJRJRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 05:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJRJRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 05:17:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F43F9;
        Wed, 18 Oct 2023 02:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697620656; x=1729156656;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ghpV4x9evw+OGVuCD+GPYxPlznQbhyJMvccUZmTsyqU=;
  b=OpOTJZeqHBivAzb8kqfkboS4fIKOjgKWO9Ljtz1sC2amiRgrGW4uQ/Nd
   3HH+CBbZKOqH2pq10NUmbU2phgHYTQIuv7uFEb2FTJVuAywDFyFRtWrGO
   USmG5Hsx9LY+xmyegtxKFbMdfdnaTwnxCoI+ljYSCXCSjyleA9BtEOYdW
   EpgxexjLNYYwP3wbe3dSLGHGC+HKHzewlD7ZqzATFSdXS01QosN0rE1FW
   1TdlfWOA5id7XM0JJBEbrwkptw6OWkqN/2sL8uhtw8v57BuVFXDVNr3WY
   3yLLC6+0x70wJAtcs7cO632yobIY91h6begcDMnbFLJu91cuSeLgmJRuZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="384855749"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="384855749"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 02:17:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="785827775"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="785827775"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2023 02:17:33 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 02:17:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 18 Oct 2023 02:17:32 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 18 Oct 2023 02:17:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvdxdQYMuky4RGybwhY98iqd67gkf++Cp+PoZXoZM/9Bb34C0uJYPr23clwbIagtnPdZNNnGbPDlLYyciY91mnYUd/XDjIWzOxgFT6dBsLCBgSpQKPNUrXMA3KWOy0KVuRM6Do4sZCKsQe3ykRYuZEO4tFiXzZhJvJkuS2y4GN0T7XZFA4qSGgBPh5emmRGLNoSFylrMf7PuPq3z7zax/mQBdAhpCEimJzPl+EaCugfnE8tMFQ1S4qYB0ZLsvjrRjVaZJ3ZrC7gDsNyEDW8ODvEQrmf0sqBAu7iGX1brLLeko6zzCnCM8mORljhJ9PkGuUJgJi0yPod4lbOXM0/nWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghpV4x9evw+OGVuCD+GPYxPlznQbhyJMvccUZmTsyqU=;
 b=aXRxXpg4PxeYnGlTxVSmdiemxoIvS98WPksqBC8JMIn6Kxrpd4/N9J1NB5nlsNqcVFJkZfwkq/jLq+OJHUwsdMA+2DGCPJECgPR+5srYPkWC9E2h60rNTboj+SRsXxP/2pPLgR8M9DQtFHwUW7HgfhC8CzYtOy709kNMZCbA0+lzpwF0XWLcaMVfrqCGcmZCvIMjr8SHeBTVlZplxMV+wIgaCWIS1kIXsytQo1y7E2QwPc/g7EDQ4u8wwbR1tJClfGQcuZRCb8o2vEgn7tip5JzyUZz1vtJCXiEAEFKBIFcrwnm1nIrMYgH/T9ycprQlofvtylcxoAfHNsbm33F56A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5643.namprd11.prod.outlook.com (2603:10b6:510:d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 09:17:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 09:17:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHaAN//ldkr1S527EC3GXo/nVXwQ7BPRVAAgAAAwQA=
Date:   Wed, 18 Oct 2023 09:17:28 +0000
Message-ID: <78725d8ddabf062be6ccafcc82ca48661f8bb974.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
         <4a8b6084-bd4b-46cf-b0b1-396684e7a7b3@suse.com>
In-Reply-To: <4a8b6084-bd4b-46cf-b0b1-396684e7a7b3@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5643:EE_
x-ms-office365-filtering-correlation-id: 34a8c55d-228c-44e8-2353-08dbcfbb0d27
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nCdXiR8Q0Uvzrd88DVM8uiK36yEu8vu9ykuy6i0V/zXvfiGQqbwLhja+g8n6CvCurJbUmZIOuDtOAMiNVJQit7AI0FY/DX6Cvy2Be9+ln9njeQk8yskUzldq0rCmP0L51gF0ieyToYTUPjARmS4rktYWDZg6sa4nn0Ak929IsmYCUQKd/C9jADgrQeFqpvBlVAdx4VN40MwDgHnu3GYZ/tcuMR3JY3fNcBa2JAJO/FwSR+jvhWtmNv8AIC28f6czvTN3amQ4lWhbXuSL3KDEhNDFzR+Zf+f3A85AduCDnWT1+0c47gbjhdtrLwoZ+G/9fDVVnt0SjT4H8sdOwFnl2i9qOgzmry9drjPPdqpsxVNAEIl2bxwRbYtlvlXv12+32cq1Dzppy5jNcKo1wJOHcVRHLFNQjKB5/7Hz8gAYqJuYiVMOkfMb0S93LLuR0bIcTCV0xSL9MH8vboNuvNLBHVy+Vd1NuCvWfiMOadJTk1JMYQCbMKL3OM8ELnObjJurNlt7M3ur/BzubmZCzo7W5+sYWAA/Rmi0lwhlpWvlHYvqZgC5oLZsuZrDAHmPlY/G1z2FpH13f/+pu/9i41Y8kWSjytHM+1nDH3JDQ0FTHIXIXmi+hplqmsEC6UX627ai
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(366004)(346002)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(122000001)(110136005)(71200400001)(2616005)(6506007)(91956017)(6512007)(83380400001)(2906002)(41300700001)(4001150100001)(4326008)(8936002)(7416002)(6486002)(8676002)(478600001)(66446008)(66556008)(76116006)(5660300002)(316002)(66946007)(54906003)(64756008)(66476007)(38100700002)(26005)(36756003)(82960400001)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnN3TlJxaytyNDRBL3NSdkNQTUsvNjVSbFRjUkhRUzlNUWQwSUNmbWs0TDdn?=
 =?utf-8?B?RDdPU0l4QUxGUzlYNWtGcDhtdzhjZWZKd1gvYmVVTFR5WjBSbTFKRSs3NVFr?=
 =?utf-8?B?STNSenB4L3N6THd3OVFNK3RIY3NKdnR4YnlKcFZUcDc2SDhXNGdNZWhEMDIv?=
 =?utf-8?B?MXVPUkdjY0R0Mm1VN0NpL0tUQXA3MFpSTmkvVFBOSzR1L0FYQU1TODhPZXZL?=
 =?utf-8?B?QkQ3c2FNVGZmWGZQbHAxZS9PdGIvc0c4eTN2RXhDVER2ZU5WQjA0OWllMVBk?=
 =?utf-8?B?ZkVnc2hqNEZldTNhcENmdUd1Y2srREpYRjFjbnJBa0VVUU5FS2ZVQ1k5MHJp?=
 =?utf-8?B?TktqelFGZzlFTWtCczltSTJ3eUdEVVM0N2w5a3BRc2huTit6TVpBOFE5MCtZ?=
 =?utf-8?B?VFhFWTN6SHJrWCtpYld0WTYyR25PZmJGeFdoQ2oza1MvbldFTWppU3d6WEdY?=
 =?utf-8?B?SGNNTXVveTlQL3ZpZjhzTzNyd296bzFGN2h2RnVFWHJTQVdSVEdsOStIQXlB?=
 =?utf-8?B?TkwyVjY3OTFiMmdUNGpGU3hzYmlLMVRUdXJFQ2tJVzJQajhlREpQd2ZTbXM4?=
 =?utf-8?B?WnNFS2w1VllSV0dwMkVUY0M3SlZ4QzlMWkhCaVl2Y1lFZzl1S3F4cllaL21X?=
 =?utf-8?B?a1B5eGxiS1FjVVhSTFFnZFpZeHNVV0JRdHFiZjVJQ0crREwwS0paUG1pWG1i?=
 =?utf-8?B?UUZ5S2VhcENtcTB6SG1hcG1GTXk5bC8wYU5haUViSXI3aUdrWFdYYTRxQkFv?=
 =?utf-8?B?czQwL09vUjM4eHBoRTRrTVBEc1l1YnZxQVZYWndXZ3Y4SUYwc2FwTUQvQzRO?=
 =?utf-8?B?eTl1ZVJOZEtPODFTVmRDQ1ZxaTFEN05EUXBwZE1LTkpnOWlYVVNoTWtTSm1h?=
 =?utf-8?B?YW1PeVFpejZaRGhpa0NkWHFaSDM5WURoQXFrWmE2djhNcDZtQUJLNC9KalVI?=
 =?utf-8?B?Y3djbGFIQmhFbk0vK2lid0ZCcmhES3dkSG9VMUNnQlIwcnF0Rmo4ZlVxQWUr?=
 =?utf-8?B?TkNvTzZ4YjEzMlZDdGFjaFU2c1BNN1grZzNaRm54U0RWci9qb01uWmtGajNa?=
 =?utf-8?B?SDJnNmtFNXVuWmxPdFZ4ZkR6eWgyWnVTR2x2WlVCMWhnaGlHaXFkQmdjeWRl?=
 =?utf-8?B?a2dTS0VCZzFJS1FrZU1ObGNMMU85M2ZDT3NiRmdQZnpJbHpqL0JCOXJDQWNY?=
 =?utf-8?B?bHZNa1FvZ1BWbTZnK1gwMStRUmd6UitnZDdjRzRONnBFWU9LaUJnaWdnckx1?=
 =?utf-8?B?UWtCaXV2dWphRTI5MUtBQk9JK0tHcE85b0dmRmkra3lQNzJnYW13Q21WUE1u?=
 =?utf-8?B?Ti8vRGdxL0VYY0ppWXJORGl0M1NaUTJqUlgxZHBIelRLUEgrYlM4ZVkzM3Jl?=
 =?utf-8?B?SE0wN0dRTnRrR0wwMzBubFRUQTU0aEVzUVVIMjVYaHRKaXlLUnI2bkhlYWN2?=
 =?utf-8?B?RjVwU1JpK2dHa2sya1dOTHA4VHpiZFNpL043NktLTlRUZzVmUFF2TldKeDk2?=
 =?utf-8?B?dWczakpHTDEvVDFpT1hMcDBDcVVVdWtacGVWSE9HTGhha091OWFvZlA3clZK?=
 =?utf-8?B?N3pYQ2F1VXpQbUkyenpySHcwUjBhWFJjaVRNdXc2QjVpWkF1N005WFAyWk80?=
 =?utf-8?B?dmFmeWdycUV5Rm16YmtWNUdHTnI5a1Jsd0hIMy85dml5Skxib2ZMNEdjUVpX?=
 =?utf-8?B?R1JEWHB1TkdSNHVlaXI3Z0FVYjBPVm5lN0dQWWNjOHNWbjFWbEVtYmpOaXhw?=
 =?utf-8?B?TU9tQ0M4eWZHOEtsZm4zMTRabTBFbUR4S2pCYnF3VEtZMmxCWjBaTkdZWHNF?=
 =?utf-8?B?UzExTzdEM004WTR5UGoyekU3cWlVVHZPeWp5SitLRk9CTXpqbnJSUHMxTXp6?=
 =?utf-8?B?aTFNYy9DaXpyQUFDdnFYL1cxWGg1SmNoa09Lemt0MUNmaHg0ZjYxbnV6ZDVs?=
 =?utf-8?B?ZWxlWmVWaG8vcmVQaFFPNkVITzlhcHc5S1hJOGdWU0cvbW16d1VFVjdkNER3?=
 =?utf-8?B?QXBKMFFvbmdMdk1tazVMdFpVQnNXb1BOZjdFVzg5Z1VVVGRkeTBnNlpUQVBy?=
 =?utf-8?B?Zmh6NVlQZjBHKzNsVFA5VUU4MlFMNTM0VVpFU0E2NnNPQnRoZ3NYSVNCOE5K?=
 =?utf-8?B?SlkwaVVjMXMyRzl3VXVnTVFuRFRJSEhUK25JSXZudFNDVHJFNG1SYWhGamZY?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BF07DF85658904F8E33B446B5A7C0F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a8c55d-228c-44e8-2353-08dbcfbb0d27
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2023 09:17:28.9054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aUhtPDwqQDWrUaWQweYy4aXIGeuX8W4eNCV7FuKUYhw03EV0zatU7hRxjDyschyXGX7qgF/iHCMsT3a6rSzkTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5643
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTEwLTE4IGF0IDEyOjE0ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxNy4xMC4yMyDQsy4gMTM6MTQg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
VG8gZW5hYmxlIFREWCB0aGUga2VybmVsIG5lZWRzIHRvIGluaXRpYWxpemUgVERYIGZyb20gdHdv
IHBlcnNwZWN0aXZlczoNCj4gPiAxKSBEbyBhIHNldCBvZiBTRUFNQ0FMTHMgdG8gaW5pdGlhbGl6
ZSB0aGUgVERYIG1vZHVsZSB0byBtYWtlIGl0IHJlYWR5DQo+ID4gdG8gY3JlYXRlIGFuZCBydW4g
VERYIGd1ZXN0czsgMikgRG8gdGhlIHBlci1jcHUgaW5pdGlhbGl6YXRpb24gU0VBTUNBTEwNCj4g
PiBvbiBvbmUgbG9naWNhbCBjcHUgYmVmb3JlIHRoZSBrZXJuZWwgd2FudHMgdG8gbWFrZSBhbnkg
b3RoZXIgU0VBTUNBTExzDQo+ID4gb24gdGhhdCBjcHUgKGluY2x1ZGluZyB0aG9zZSBpbnZvbHZl
ZCBkdXJpbmcgbW9kdWxlIGluaXRpYWxpemF0aW9uIGFuZA0KPiA+IHJ1bm5pbmcgVERYIGd1ZXN0
cykuDQo+ID4gDQo+ID4gVGhlIFREWCBtb2R1bGUgY2FuIGJlIGluaXRpYWxpemVkIG9ubHkgb25j
ZSBpbiBpdHMgbGlmZXRpbWUuICBJbnN0ZWFkDQo+ID4gb2YgYWx3YXlzIGluaXRpYWxpemluZyBp
dCBhdCBib290IHRpbWUsIHRoaXMgaW1wbGVtZW50YXRpb24gY2hvb3NlcyBhbg0KPiA+ICJvbiBk
ZW1hbmQiIGFwcHJvYWNoIHRvIGluaXRpYWxpemUgVERYIHVudGlsIHRoZXJlIGlzIGEgcmVhbCBu
ZWVkIChlLmcNCj4gPiB3aGVuIHJlcXVlc3RlZCBieSBLVk0pLiAgVGhpcyBhcHByb2FjaCBoYXMg
YmVsb3cgcHJvczoNCj4gPiANCj4gPiAxKSBJdCBhdm9pZHMgY29uc3VtaW5nIHRoZSBtZW1vcnkg
dGhhdCBtdXN0IGJlIGFsbG9jYXRlZCBieSBrZXJuZWwgYW5kDQo+ID4gZ2l2ZW4gdG8gdGhlIFRE
WCBtb2R1bGUgYXMgbWV0YWRhdGEgKH4xLzI1NnRoIG9mIHRoZSBURFgtdXNhYmxlIG1lbW9yeSks
DQo+ID4gYW5kIGFsc28gc2F2ZXMgdGhlIENQVSBjeWNsZXMgb2YgaW5pdGlhbGl6aW5nIHRoZSBU
RFggbW9kdWxlIChhbmQgdGhlDQo+ID4gbWV0YWRhdGEpIHdoZW4gVERYIGlzIG5vdCB1c2VkIGF0
IGFsbC4NCj4gPiANCj4gPiAyKSBUaGUgVERYIG1vZHVsZSBkZXNpZ24gYWxsb3dzIGl0IHRvIGJl
IHVwZGF0ZWQgd2hpbGUgdGhlIHN5c3RlbSBpcw0KPiA+IHJ1bm5pbmcuICBUaGUgdXBkYXRlIHBy
b2NlZHVyZSBzaGFyZXMgcXVpdGUgYSBmZXcgc3RlcHMgd2l0aCB0aGlzICJvbg0KPiA+IGRlbWFu
ZCIgaW5pdGlhbGl6YXRpb24gbWVjaGFuaXNtLiAgVGhlIGhvcGUgaXMgdGhhdCBtdWNoIG9mICJv
biBkZW1hbmQiDQo+ID4gbWVjaGFuaXNtIGNhbiBiZSBzaGFyZWQgd2l0aCBhIGZ1dHVyZSAidXBk
YXRlIiBtZWNoYW5pc20uICBBIGJvb3QtdGltZQ0KPiA+IFREWCBtb2R1bGUgaW1wbGVtZW50YXRp
b24gd291bGQgbm90IGJlIGFibGUgdG8gc2hhcmUgbXVjaCBjb2RlIHdpdGggdGhlDQo+ID4gdXBk
YXRlIG1lY2hhbmlzbS4NCj4gPiANCj4gPiAzKSBNYWtpbmcgU0VBTUNBTEwgcmVxdWlyZXMgVk1Y
IHRvIGJlIGVuYWJsZWQuICBDdXJyZW50bHksIG9ubHkgdGhlIEtWTQ0KPiA+IGNvZGUgbXVja3Mg
d2l0aCBWTVggZW5hYmxpbmcuICBJZiB0aGUgVERYIG1vZHVsZSB3ZXJlIHRvIGJlIGluaXRpYWxp
emVkDQo+ID4gc2VwYXJhdGVseSBmcm9tIEtWTSAobGlrZSBhdCBib290KSwgdGhlIGJvb3QgY29k
ZSB3b3VsZCBuZWVkIHRvIGJlDQo+ID4gdGF1Z2h0IGhvdyB0byBtdWNrIHdpdGggVk1YIGVuYWJs
aW5nIGFuZCBLVk0gd291bGQgbmVlZCB0byBiZSB0YXVnaHQgaG93DQo+ID4gdG8gY29wZSB3aXRo
IHRoYXQuICBNYWtpbmcgS1ZNIGl0c2VsZiByZXNwb25zaWJsZSBmb3IgVERYIGluaXRpYWxpemF0
aW9uDQo+ID4gbGV0cyB0aGUgcmVzdCBvZiB0aGUga2VybmVsIHN0YXkgYmxpc3NmdWxseSB1bmF3
YXJlIG9mIFZNWC4NCj4gPiANCj4gPiBTaW1pbGFyIHRvIG1vZHVsZSBpbml0aWFsaXphdGlvbiwg
YWxzbyBtYWtlIHRoZSBwZXItY3B1IGluaXRpYWxpemF0aW9uDQo+ID4gIm9uIGRlbWFuZCIgYXMg
aXQgYWxzbyBkZXBlbmRzIG9uIFZNWCBiZWluZyBlbmFibGVkLg0KPiA+IA0KPiA+IEFkZCB0d28g
ZnVuY3Rpb25zLCB0ZHhfZW5hYmxlKCkgYW5kIHRkeF9jcHVfZW5hYmxlKCksIHRvIGVuYWJsZSB0
aGUgVERYDQo+ID4gbW9kdWxlIGFuZCBlbmFibGUgVERYIG9uIGxvY2FsIGNwdSByZXNwZWN0aXZl
bHkuICBGb3Igbm93IHRkeF9lbmFibGUoKQ0KPiA+IGlzIGEgcGxhY2Vob2xkZXIuICBUaGUgVE9E
TyBsaXN0IHdpbGwgYmUgcGFyZWQgZG93biBhcyBmdW5jdGlvbmFsaXR5IGlzDQo+ID4gYWRkZWQu
DQo+ID4gDQo+ID4gRXhwb3J0IGJvdGggdGR4X2NwdV9lbmFibGUoKSBhbmQgdGR4X2VuYWJsZSgp
IGZvciBLVk0gdXNlLg0KPiA+IA0KPiA+IEluIHRkeF9lbmFibGUoKSB1c2UgYSBzdGF0ZSBtYWNo
aW5lIHByb3RlY3RlZCBieSBtdXRleCB0byBtYWtlIHN1cmUgdGhlDQo+ID4gaW5pdGlhbGl6YXRp
b24gd2lsbCBvbmx5IGJlIGRvbmUgb25jZSwgYXMgdGR4X2VuYWJsZSgpIGNhbiBiZSBjYWxsZWQN
Cj4gPiBtdWx0aXBsZSB0aW1lcyAoaS5lLiBLVk0gbW9kdWxlIGNhbiBiZSByZWxvYWRlZCkgYW5k
IG1heSBiZSBjYWxsZWQNCj4gPiBjb25jdXJyZW50bHkgYnkgb3RoZXIga2VybmVsIGNvbXBvbmVu
dHMgaW4gdGhlIGZ1dHVyZS4NCj4gPiANCj4gPiBUaGUgcGVyLWNwdSBpbml0aWFsaXphdGlvbiBv
biBlYWNoIGNwdSBjYW4gb25seSBiZSBkb25lIG9uY2UgZHVyaW5nIHRoZQ0KPiA+IG1vZHVsZSdz
IGxpZmUgdGltZS4gIFVzZSBhIHBlci1jcHUgdmFyaWFibGUgdG8gdHJhY2sgaXRzIHN0YXR1cyB0
byBtYWtlDQo+ID4gc3VyZSBpdCBpcyBvbmx5IGRvbmUgb25jZSBpbiB0ZHhfY3B1X2VuYWJsZSgp
Lg0KPiA+IA0KPiA+IEFsc28sIGEgU0VBTUNBTEwgdG8gZG8gVERYIG1vZHVsZSBnbG9iYWwgaW5p
dGlhbGl6YXRpb24gbXVzdCBiZSBkb25lDQo+ID4gb25jZSBvbiBhbnkgbG9naWNhbCBjcHUgYmVm
b3JlIGFueSBwZXItY3B1IGluaXRpYWxpemF0aW9uIFNFQU1DQUxMLiAgRG8NCj4gPiBpdCBpbnNp
ZGUgdGR4X2NwdV9lbmFibGUoKSB0b28gKGlmIGhhc24ndCBiZWVuIGRvbmUpLg0KPiA+IA0KPiA+
IHRkeF9lbmFibGUoKSBjYW4gcG90ZW50aWFsbHkgaW52b2tlIFNFQU1DQUxMcyBvbiBhbnkgb25s
aW5lIGNwdXMuICBUaGUNCj4gPiBwZXItY3B1IGluaXRpYWxpemF0aW9uIG11c3QgYmUgZG9uZSBi
ZWZvcmUgdGhvc2UgU0VBTUNBTExzIGFyZSBpbnZva2VkDQo+ID4gb24gc29tZSBjcHUuICBUbyBr
ZWVwIHRoaW5ncyBzaW1wbGUsIGluIHRkeF9jcHVfZW5hYmxlKCksIGFsd2F5cyBkbyB0aGUNCj4g
PiBwZXItY3B1IGluaXRpYWxpemF0aW9uIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB0aGUgVERYIG1v
ZHVsZSBoYXMgYmVlbg0KPiA+IGluaXRpYWxpemVkIG9yIG5vdC4gIEFuZCBpbiB0ZHhfZW5hYmxl
KCksIGRvbid0IGNhbGwgdGR4X2NwdV9lbmFibGUoKQ0KPiA+IGJ1dCBhc3N1bWUgdGhlIGNhbGxl
ciBoYXMgZGlzYWJsZWQgQ1BVIGhvdHBsdWcsIGRvbmUgVk1YT04gYW5kDQo+ID4gdGR4X2NwdV9l
bmFibGUoKSBvbiBhbGwgb25saW5lIGNwdXMgYmVmb3JlIGNhbGxpbmcgdGR4X2VuYWJsZSgpLg0K
PiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4N
Cj4gPiBSZXZpZXdlZC1ieTogS2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZAbGlu
dXguaW50ZWwuY29tPg0KPiANCj4gDQo+IFdpdGggdGhlIGxhdGVzdCBleHBsYW5hdGlvbiBmcm9t
IEthaSA6DQo+IA0KPiBSZXZpZXdlZC1ieTogTmlrb2xheSBCb3Jpc292IDxuaWsuYm9yaXNvdkBz
dXNlLmNvbT4NCg0KVGhhbmtzIQ0K
