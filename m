Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F57741CD2
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjF2APW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjF2APU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:15:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B361BC8;
        Wed, 28 Jun 2023 17:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687997719; x=1719533719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ya8pCabzF9NNI+QbpWyD/xzqrTXAFkg4c/LiRmgh43Y=;
  b=VQf8rd1AMM7G+Y9IHAj4PMmGFW17FZCdD6N/Psgt2V57ct6v08JnrGym
   pUyqoJojFUCpWwjp77A6pA40XNxR5xLW2VAme6GIEPeNUYfSMJHjtzm/d
   KJhRzCHfEmYEx9qxxmNMWImD5uMXJstJPZoUeo6deNVBL7L3kdqev5a3K
   E1hcGMcDPEUh+eRe0Jl6lf7NZJ9iBUxXJMEBE2S9qq1jXqP+tPnLd5Rgz
   eo30UEeGbQwUt2bpszHiTwJLsENUkaMDwKECCpdsmE9beYHuiX6bYktWL
   kVNKUhBkZEvY3bBg4e7G0bbUrPkdkCb/anYSdaHoNO1FDhiGzGjEjOQni
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="342327240"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="342327240"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="830333216"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="830333216"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2023 17:15:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:15:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 17:15:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 17:15:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TN+GRTO4EZNVpDGQeAO6nVXlQVxoDNs0Wij0pMObNI1dwnsRJGJh8VBpd4FxQ6xeBS/spWFRzeWTXW6CwmV1Y12dgim92nWSSlgXYvTFf3pO4g6jbPGeGPZJhT2fJvVNw1wnHL60ZIuqj6WEv+Q+3SDI9wut9mDMKMiqnLgKb+W8G239zQZM39zFG4JjitQ1joeb2GtdyspCun/Z/SANbjv/drMVMJZhbHPCYPRDS1ZATLC5+Agf+CkevROl5XMZLMBADkp1iejmx67KBpc9bPei2YzpFqfqvIzGveCzFi3mRdhCVuTcbKz+ipRy4783Nzk6z+8ir+zEwR7Ay+2TAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ya8pCabzF9NNI+QbpWyD/xzqrTXAFkg4c/LiRmgh43Y=;
 b=ZBmKljLExz3Yg+ttHYjjNc4FbPbLuyEqu1MgMBu2Txz1w1uImgR/R78rzKGCMe7WeunagO4rqnCuQ/YKod/g66jLHAFSBGrjXmS+0VYduXbGxEzzpWqYXvRk1bi5Gf8DSAMd/RAj0pz1QyEFhEXYhCouXPssmNe6FqXDXNXo+LIHtfrds5TBDEB1jmuahVXbEUiBE6rDp+5TrqxcoP/iY8MZsni0NK8dbVqWCEJndqrwgkcXMsB9E/iuB0XptujhjKkruAZ17oRYf/4re33P8FLxUSluvIhu97XZxRL02t14xfyISSQUOIpMwHlVviLzf1o2JWtgeloweKJiYRt7ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6806.namprd11.prod.outlook.com (2603:10b6:806:24d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 00:15:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 00:15:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+eaRwAgAAMPoCAAB1NgIAArPYAgAAey4CAANwJgIAAsqsA
Date:   Thu, 29 Jun 2023 00:15:13 +0000
Message-ID: <03def8b40a7db14f31d2ad67fb1a201e8ae8bce0.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
         <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
         <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
         <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
         <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
         <20230628133541.GF2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628133541.GF2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6806:EE_
x-ms-office365-filtering-correlation-id: 66ef647a-0abb-4f19-08b0-08db7835e884
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bBRE4km1YQXaM4yYSQrPhlLIpgIBG3xf5WRJ9U/173A4ultL+gO0Gho4urLBJSbr0k2L63ACRnlTLu0P9Gxm2WDjWBP3EQAXB/dFmbUNwc6vohiHG4OvwC/1D71A/+UwhK/BTM/KHfwTUs8x7ufjo13ac9BDA/Q5Q/dlZ9hYt2yglZrtwVScg8RncV0UGawPD17q/guWOJ/puLtcwyYR00ePRTa7c/Vo0A56Q6ETGytIfS/ovrChiY7FTXkXxAra8i5YfqQik1o73YPVCfXd+yk3fpR4LW96bsm8p1VwV5HypE21rOl/d5Z//C8otkabYPN+NijE5TS6ruDmaWgX6inTKl9XevBs+hGViAhm4yr2+3+B1GN5Z87hKMTAI46Op/j2C0JHutkYAIxYvMJ9xfRdFgEX3nT9uuVoUv1X7AbNAXoZO7HqEPg6kLzxvdvIZCqu/ewNDBFTqyp5SCsRcLJmhBd0hcu/KQc6+ly9xe6NtOTd4CtHB5iYx5XtV2/oN34BgjuOp0JeIBcPM8LxHKWPf0vZmqOsCHYy+mb2WrO37gdPA+tE3TkVJtGxlgyeQpRhrifnmaPS9vjh8B6TZVLjNMzNr0P2PWDWciv5oP7zL/tWrhi0cNsadNSZcwip
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199021)(66446008)(6512007)(38070700005)(4326008)(26005)(66556008)(66476007)(36756003)(122000001)(7416002)(66946007)(86362001)(6916009)(41300700001)(8936002)(316002)(8676002)(82960400001)(5660300002)(91956017)(64756008)(38100700002)(76116006)(6506007)(6486002)(186003)(2906002)(83380400001)(71200400001)(54906003)(478600001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2k0bDR3ekFQTVVGL3hYdVRiOVlCMXRtL1JXNlNGMFBzUmM2UUE5WjJ3ZEk2?=
 =?utf-8?B?alJsLzlNZ3NuSWQ1dFhHYXFVVDJaZnFFVjQ2a3N6TGlYYlQzSUpQYm5hOHc4?=
 =?utf-8?B?aERsLzFMeUw1NVRBQTgvdk5SMmpvWjlDRFpKOHRPek5wVzI5V1BGTTJRNlE5?=
 =?utf-8?B?UHVISFRRYjNiaFBkQWVFdjd2amt5ZG9nVmZYUkVzNndsRk9mRCtYS3FCL05h?=
 =?utf-8?B?TVlQcTY1MnpkQmt0RHdzL0pGSE8yQzU1L0c1cDZMNy9KQlNVdXVHYzlIVEFG?=
 =?utf-8?B?Mlo0UzE2bkQ4Y2N6ZEV5SiswWHdsTnhKbG1odzlSMWRoSStpZlRIY2kyT1dy?=
 =?utf-8?B?NlU3NXBDQzFNajNUM2JKZDQwbWZ5Vy9pNDVTdjRFNEo4M3J0dUIxNG9jcHpM?=
 =?utf-8?B?NFlUM1ZDU043WEV0Sk9GWTExWThCUC9PZEtYRlRhMnBPcEJndDJabUZCdlVM?=
 =?utf-8?B?cm1sdlFkR0JJTEY5WEc0eUVsU2hacmErQ1BJNGw0a3k2OUg0ckVsWnN0ZHNY?=
 =?utf-8?B?cEZBbGc0NnpiZ1U5OHg3RDNtMS9Za2ZMZWYvNnVOWngzOUk4VjJ0ZkJHclZM?=
 =?utf-8?B?MGNOUTdEVVUvV1lQYWp0MjFPNitNbXFMU1lSSklIaUEvYVEwKzIrMmFtWmd1?=
 =?utf-8?B?UXd3ZExnTEZMcFVRWkJHRWdwM1QwOEV3NUVxeEVCcUFqS2srcnJZbHBMM1JP?=
 =?utf-8?B?aDRFZnBVbWpVYmszN0pJcWQwNTYxbHVmQ3RtaEZOM3NDMlY5NGJ3Sk55OHRs?=
 =?utf-8?B?VDhLRHhVV3hXNG1mbk5semEyd0dVMVA3dDRncUI0WERCYUlpTXg4R1l6VEJC?=
 =?utf-8?B?Q3hLTnZ1K2o2OXltNnNkdE84cWE2aHo2akFGNnJpK0tRcStwK3JNQ1UrWHht?=
 =?utf-8?B?RlVIbGw1VWY4WFFSYVlaNGFaT2lDWkJLTzA5bjA0aEsvUzdkY0I0N21MU1U0?=
 =?utf-8?B?UUFQc3BqWXd5dWNRdXcvV0ZYbENPeWk2SzNib2tRR05TRjlPV29zdkd0bG42?=
 =?utf-8?B?bWhpMThVSHJYOWJkcU5wK3BpOWM2aWFmMzdVVDhpbkZKbUJIRGtCZDQvT3Vw?=
 =?utf-8?B?a2xudjgyQmFKdkJzTE1iQjJ4KzVXajBKdEVZK0JYZlBnUzgvL1NaazlyQ1A3?=
 =?utf-8?B?dC9PTGl6TENUYWgwSWJBWUw1ZTJ2SktxMWo0NkJuSmxhckFFMUF3ZGN6cGVm?=
 =?utf-8?B?bUNWYW83U3dWMjVSaGkzbU5pVFd5bVIxNjZqdExXU09qaTB6eTJLVHFQQXUx?=
 =?utf-8?B?bWVZUmFTcEpFdHdYTXpXdVZBNWkwWEN2QVhMMFBpOHhKYStmRzEzS3I4M290?=
 =?utf-8?B?SGdVM3Biem1qNlVZajBLMzhhTkh1cHN4cFFEOWt3K2ZRVWNpY0pUOHVHOU9X?=
 =?utf-8?B?Q1BUSytNNDdGYkVmQ3QwRXNVRWs3bzZsbW5CV1B1TmZsM0dQRGZtbzNFYUo2?=
 =?utf-8?B?eitGRlZXS1Frc0tnaGw1L1FiZ0lsaEljQ01XalZ5d1MwdmhLNHhZK3Z1Zk5n?=
 =?utf-8?B?QWNoUFQ1NVA5ajhqZ01hVENUaDExMlBjbWdLUFpDaXJYTW5BRS9wWGY2SURF?=
 =?utf-8?B?a2lvdlFCdHlJQmExR0tiQkFBSTk5azdRbUVZSmdlQU94S2t3RnRna1Y0R1FL?=
 =?utf-8?B?ZlFTSXBkaUJMSC9qeGhYV0FPcEtZWnBGKys1a0RqQkpqbEVlU2J6NUp5RXdB?=
 =?utf-8?B?RUxoWC9iRWEzcHI1aEdVU3RPbk14bjNUcGRFRmwxRWJUbXVzeXZpcHBVL0hM?=
 =?utf-8?B?a3J4LzByV0ZWM3FJRUFVckVnM1k1WnV6ZnJ6VzYvZFVRWUpaY1ZVY0MrRGgz?=
 =?utf-8?B?ZFFrVzZhVDlJWnhmc3ZKM2xGR1JNdWVXRm0wMDZhelFkVFlWbjZzdUI5Y0ln?=
 =?utf-8?B?b0phWk9yT0Zlbng1MzE5TEw1WExSV0tXRXJtZFpPVW0wMWhjVlk5UjlpN0lD?=
 =?utf-8?B?cGx5eG1qOWFxUjdvWm9MMDZ0ejd4blNva3QvOU1DNDRHZVhiTlQwWFpaWDRQ?=
 =?utf-8?B?NEN1ZzRVLzVpT0V5dUNsd3Ntb2JaVWVkbVNMWHg3bXBJd21GOFJBeU1FN0Fu?=
 =?utf-8?B?L3k5aDRYZW1PMDhkRjRmK1Z4clpJdWRaaFNzY2E4SXJ0WW5nOTBrUTgyb3Fp?=
 =?utf-8?B?Z3U2dzNobVoycDc5Z2I4M3VlUG1wekVrWXdBTDVKOFZpTU1tY1k2QnVLK2Fl?=
 =?utf-8?B?SGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21FF98FB81B66A40988CD6005655AE4F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ef647a-0abb-4f19-08b0-08db7835e884
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 00:15:13.2193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q4o2LgvVqZpC+Hr52S5GkLXzTbMYBEUPrdFCQXKdUjMf4H093x1mHUIIMZ59+33TgCNcm1JcLp/LfCjJa874ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6806
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE1OjM1ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdW4gMjgsIDIwMjMgYXQgMTI6Mjg6MTJBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBUdWUsIDIwMjMtMDYtMjcgYXQgMjI6MzcgKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gKy8qDQo+ID4gPiA+ID4gKyAqIERvIHRoZSBt
b2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0aW9uIGlmIG5vdCBkb25lIHlldC4NCj4gPiA+ID4gPiAr
ICogSXQncyBhbHdheXMgY2FsbGVkIHdpdGggaW50ZXJydXB0cyBhbmQgcHJlZW1wdGlvbiBkaXNh
YmxlZC4NCj4gPiA+ID4gPiArICovDQo+ID4gPiA+IA0KPiA+ID4gPiBJZiBpbnRlcnJ1cHRzIGFy
ZSBhbHdheXMgZGlzYWJsZWQgd2h5IGRvIHlvdSBuZWVkIF9pcnFzYXZlKCk/DQo+ID4gPiA+IA0K
PiA+ID4gDQo+ID4gPiBJJ2xsIHJlbW92ZSB0aGUgX2lycXNhdmUoKS4NCj4gPiA+IA0KPiA+ID4g
QUZBSUNUIElzYWt1IHByZWZlcnJlZCB0aGlzIGZvciBhZGRpdGlvbmFsIHNlY3VyaXR5LCBidXQg
dGhpcyBpcyBub3QNCj4gPiA+IG5lY2Vzc2FyeS4NCj4gPiA+IA0KPiA+ID4gDQo+ID4gDQo+ID4g
RGFtbi4gIEkgdGhpbmsgd2UgY2FuIGNoYW5nZSB0aGUgY29tbWVudCB0byBzYXkgdGhpcyBmdW5j
dGlvbiBpcyBjYWxsZWQgd2l0aA0KPiA+IHByZWVtcHRpb24gYmVpbmcgZGlzYWJsZWQsIGJ1dCBf
Y2FuXyBiZSBjYWxsZWQgd2l0aCBpbnRlcnJ1cHQgZGlzYWJsZWQuICBBbmQgd2UNCj4gPiBrZWVw
IHVzaW5nIHRoZSBfaXJxc2F2ZSgpIHZlcnNpb24uDQo+ID4gDQo+ID4gCS8qDQo+ID4gCSAqIERv
IHRoZSBtb2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0aW9uIGlmIG5vdCBkb25lIHlldC4gIEl0J3Mg
YWx3YXlzDQo+ID4gCSAqIGNhbGxlZCB3aXRoIHByZWVtcHRpb24gZGlzYWJsZWQgYW5kIGNhbiBi
ZSBjYWxsZWQgd2l0aCBpbnRlcnJ1cHRzDQo+ID4gCSAqIGRpc2FibGVkLg0KPiA+IAkgKi8NCj4g
DQo+IFRoYXQncyBzdGlsbCBub3QgZXhwbGFpbmluZyAqd2h5Kiwgd2hhdCB5b3Ugd2FudCB0byBz
YXkgaXM6DQo+IA0KPiAJQ2FuIGJlIGNhbGxlZCBsb2NhbGx5IG9yIHRocm91Z2ggYW4gSVBJIGZ1
bmN0aW9uIGNhbGwuDQo+IA0KDQpUaGFua3MuICBBcyBpbiBhbm90aGVyIHJlcGx5LCBpZiB1c2lu
ZyBzcGlubG9jayBpcyBPSywgdGhlbiBJIHRoaW5rIHdlIGNhbiBzYXkNCml0IHdpbGwgYmUgY2Fs
bGVkIGVpdGhlciBsb2NhbGx5IG9yIHRocm91Z2ggYW4gSVBJIGZ1bmN0aW9uIGNhbGwuICBPdGhl
cndpc2UsIHdlDQpkbyB2aWEgYSBuZXcgc2VwYXJhdGUgZnVuY3Rpb24gdGR4X2dsb2JhbF9pbml0
KCkgYW5kIG5vIGxvY2sgaXMgbmVlZGVkIGluIHRoYXQNCmZ1bmN0aW9uLiAgVGhlIGNhbGxlciBz
aG91bGQgY2FsbCBpdCBwcm9wZXJseS4NCg==
