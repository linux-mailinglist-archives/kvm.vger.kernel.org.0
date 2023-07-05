Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B41747EA5
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 09:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbjGEHyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 03:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjGEHyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 03:54:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52C7E2;
        Wed,  5 Jul 2023 00:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688543690; x=1720079690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KHKWLXdGipMdjmvPUnyaV/3FsrBO8KN2JXlwjBHxuWw=;
  b=EeCrZg73TBuI27+ylJAFDz0j8y6PfWTYOT/GVNboMhcqyTB+HXabJB6c
   sXAMzl5kT58cZ4n5aX2wvvXHZdmLsf5QDGSgcjCtbXLMQyB1PODFFRD+4
   Qk25ByWX0IitS18Ijc7AhoIXpyDK4t7FBaspf+bNqzKrIAvK97dKZQBFG
   +J3J6tCscPcga3NNnylW4QsVCbCXkk8Cwue0SJk5jUGtWPB9GCpAWZetZ
   44qK1GiIBsP84IMMK14lvO5uDTOUBC42zbvdza/AJwNaCMpOoEIwj6Vms
   /Egsj5o+PMmYS4cKL6vpr98GY2+6bwA32ezIEOJ6BOGexALGrR3bka7Hf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="343608008"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="343608008"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 00:54:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="713106489"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="713106489"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 05 Jul 2023 00:54:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 00:54:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 00:54:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 00:54:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kil/YyxPZ3Lv0m/dnYEFUSp0OuEmo2G0qLP789JZX2EN3phb3dQ1EXV47YI517TuJJ/+jqqkcMM1cfw4/w7D7u+Sf1628MWgL+nT3w9ll6cT9Kfrf3mCwZTQA6Kno0UzNoVFs5N57IL2mCPf7JJ/gonZ6LGH35tCLB3inDnO6a4uWTTSx3FXk3PjYCLC7Kr/ly26g3UC7ELDdjf+H0vOmCCrejjJqLDJbPfdVtdonD+7LZPPECkYFlEOUwpQ35dM1QqHRXuFjff3XAOFNTSS/yaCP7pAwQnvuw2iSh+R3T6TPccWZi9+mxFAl9cSqbbk4z+DstK4O8jKta2Wsyvotg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHKWLXdGipMdjmvPUnyaV/3FsrBO8KN2JXlwjBHxuWw=;
 b=H2ScH+q196NBC4cZY/4KO1IIGZc6BEM7dW31CCEF48Ua6oUfI7GJU7ugnZiXfKmXmxo1gMIIdherElRcixZvNAuBF5q12tTxLwG7KhGgD1MIsmY1NpYaAfNsbkxNo3kqPjKfsGYq63yKDTMA5xqCCg3Jq17Ve/THiqhSE0qhAkgtex5+xmlTSesU4QmRWvFch7VHo4GA2HFVMW7219gV2Y5gbpJNBAit2JirQFk+28ridT0tnIQEpJVpoxhBdt0PbZRACN8NVMXzJQi915ulhG433l5XNf0iOfi6ukpPrkkId9SnhHhjJ6yk48Qe6xcmjDSCJB2ecnDfZaGN1Ul6ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5909.namprd11.prod.outlook.com (2603:10b6:303:168::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Wed, 5 Jul
 2023 07:54:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6565.016; Wed, 5 Jul 2023
 07:54:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+gNU2AgAC2WwCAAi3CgIAACCuAgACP2QCAAAnAAIAAJwgAgAX+6gCAAFGCAIAAnhoAgAAKw4A=
Date:   Wed, 5 Jul 2023 07:54:45 +0000
Message-ID: <09c7b69ca411e2edea6cbd10ae0c3388bee6dfce.camel@intel.com>
References: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
         <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
         <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
         <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
         <20230630183020.GA4253@hirez.programming.kicks-ass.net>
         <20230630190514.GH3436214@ls.amr.corp.intel.com>
         <ZJ9IKALhz1Q6ogu1@google.com>
         <20230704165836.GB462772@hirez.programming.kicks-ass.net>
         <0bd5a2f95a0f309ff35d511ce832c5f11abf6013.camel@intel.com>
         <20230705071612.GD462772@hirez.programming.kicks-ass.net>
In-Reply-To: <20230705071612.GD462772@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5909:EE_
x-ms-office365-filtering-correlation-id: e3691376-c24b-4f78-e4e6-08db7d2d1980
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NXCz9PPDuMsr2KdqDrvQQTKzT1tOhsPweooUnrul1OvTG9U9sgg3B3e9Ppd6bQKgkE1PQK15m+YYHMqgKHXAovAW4zeo5qEPBu0ZT56eYKi6ydfnjkyVZBx4ezHSgFX8ldjy5cYH+PL5yUVN5J7CiKM3oitYiV2EsOrvt9QF1jyoYZWKy5gqW5ogFyVgZnL37dfbGrQgMdmwKiV7ZvsTyjwo/LFm5iZA+zI7vZ1OEUF7sJGrbAN8iTUhKgGRmC92y9kALKwghjAJw0oED1VXzGNJJ5EQ1DavAXMPMLKIt6Wn2imUPwZLBaX9MTtGYV+/BNkvg5mk7c9pmZh/iQL9ondkqWw+zAfXIZBv1+KjERQP4xRYkVNuB8s34MnlYT3WvGrLpRY5iAU/IO3kll/CJx98HRXfjw9wcGOWWzgKmgTTt0A6zQ5Bf8MFixeHt9hx5fLQ/i0O2r1NxaDCeIug0oD3dsusyC07kozAKnUrkx+CzmoQ8IGBQfmC1f482cPYxlN9oxZaSTpJy1J6pWEOzewT6BVwsA1+MXfaHY1O9TTtdCdWF+80UxjP42hVR47v4/E0CMeB4as0TkzcaAwEcjZggs6LUvfTuqhkYk/hXo2fup0TxWDn7fiitCwYAjXm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199021)(6512007)(6486002)(54906003)(478600001)(83380400001)(2616005)(86362001)(36756003)(38070700005)(2906002)(6506007)(71200400001)(26005)(186003)(4326008)(82960400001)(122000001)(66446008)(38100700002)(76116006)(66946007)(316002)(66476007)(66556008)(91956017)(8936002)(64756008)(6916009)(41300700001)(5660300002)(7416002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDZEK0pxRG52YWJ3QkxZQ0JSeTgzN0Zkci9KUWFaUkNIdVJ2ZHllSTRrMm1s?=
 =?utf-8?B?ZzNyKy9tY1hkOURUd3lOMFlqc2V5SHRTWjM5MzZIUUUraXVRK2UvVHpqSVJU?=
 =?utf-8?B?eDlPQm5oeTJrdmV6L2FiVkVhbDNsZjBZVEdxdXBlU3VDRThtc0VaVEZZS1pU?=
 =?utf-8?B?a1VkbW5wT1lQU0JJR2MxMnJCSGZnVkFXY2VTZDhJUk5XMkl1bmljVmZ2MjZY?=
 =?utf-8?B?K21lYzdBNWpWRlphU2FBTW1vajkrOUlYaXZOc1Y5czVETjRXL3NKdVNlNXpE?=
 =?utf-8?B?M0tXS0xmUFJVb2Y2QW5aeVN1RmE0dnV6SEJhRlRvUWZNMVZwdWpOS0VMVy9p?=
 =?utf-8?B?dTV6d0h3K1JBVWFOUy8wOExMVFJ4d2xYaitrcUZZS3lxb09BV0tTRHIrZitW?=
 =?utf-8?B?Q1JjR1duTVA1ZjdCQ0Zoc0JDRXhCUGdLRzVYSzhiV1g0MkZ2c01vdEtkUzBV?=
 =?utf-8?B?NjI0TlliaWMxMldId2l6OTdmWFZ0aTNDUjdBcmNpR1FHVnFRVTVPRmJva0Jl?=
 =?utf-8?B?cktYUWdLc0NQSndKOElZbCt4cDc4QTd6b3ZxRkN2UXpHYnV0eHozUFVFa0FN?=
 =?utf-8?B?by83SnQwQlVXemtneEpZaXVqenp6MXBpcE85RHBnZzlVeEFSSE5IMHdGVURa?=
 =?utf-8?B?SUlCRjI1aG5WbHFYOUVvN2VFSUJLS3lNc2pXSWc1K3JSV01aWE02eHoxK2wv?=
 =?utf-8?B?Y3pYNzhtSTM5QXhCdVVWWWFXakpza1d0bzBZSjlBMEQzK3h5SnNsb1JoT2Q3?=
 =?utf-8?B?QXFtdFo5dE91RTkyYkszU1JHYnA1QklPa2ZWR0pIVm95RFptd3JpcHVQVytH?=
 =?utf-8?B?VytvbVJ0SUhiRzhBSVZWSDNjblNkVHMwTURyZWkwV2oyTVdrQ3JuUEE5c2FZ?=
 =?utf-8?B?THh4ZVo2b1ZRbnBGMmpFU3JHRGNFZDFpRS9FaWNYNEdEYXQyUFdwNUg4eE1P?=
 =?utf-8?B?MFVOdnkyYUZLZktDd0JTRzZucklGN2xZNUt6YVNLVmkyQVBUaWI1Z21TUjlI?=
 =?utf-8?B?Zk9FZlZDMyt1dzhzelA0UkhESjJLNFNCdDdWTkZvY25lbU85UmdzZGJvb0xO?=
 =?utf-8?B?L0kra3orZlIwVERYUlh5QnhjMnRVQ3VnSU9LbXE0WjhaQUFMMkhubkhyVUIz?=
 =?utf-8?B?QVgyQ2c2SGhwMUFJNnNHYllhVHExZWxsUW9uYkUwQ0l4Yzd5bVFRTWpSbU13?=
 =?utf-8?B?LzdYU3V2ODRNWThlUUw2RDVvMWZ3V2lNQ1VrVDBNMjZ5ejZCNUc3NGlReUQr?=
 =?utf-8?B?VFJFaDVPTjBFbDlFT1hESlU4Si9SSzZoWE5TaG1VcVpaNnJZWnQyaS8yY01j?=
 =?utf-8?B?YS85T0psQ0hRR1NWajAwSitXYmFoWkYyb0J3UTJ3SXFIQXZGMUNhUEdLWE00?=
 =?utf-8?B?L2tDYm1DSjlGMllJR20yMFJENC9DWEl2SmFvdHNZU3dLSlFjenlISzNJc3dL?=
 =?utf-8?B?SDl6NU5lQzJrMG1iWWs1eExud2txS254cjEzaWdtb3pWTVFsN0poeXB0SHYx?=
 =?utf-8?B?ckRwK1F0OER2Mm1GRHEwamFuL2tDT1R3ZURYUFhNYnFhWlNERStVSVZCUTJW?=
 =?utf-8?B?UnZJaERxMFNIZU9zWWdiYVdpTHNORW1FYUlET1JaTHF3aWlQTERCTnJmVENx?=
 =?utf-8?B?bVZFL01aY2E5bnpBcnV1OUw0L3FWUUFZMGRCL2t2ZFBoWDBId3pkU0VDdGIw?=
 =?utf-8?B?d0dGdUc3by9aZDlpT1lVcWtYNTFYOEtKejB3b0p1QytweUtKaWpySlNldUl0?=
 =?utf-8?B?WmVYQk1FTkM1czlTRlJOSnRDUEZza0hJeUJ3L2pGQnNiL3ZwakNEOTMwZ3do?=
 =?utf-8?B?RklaVTlkZUdyVzgxaWJEQUR1Rmwwd1R4UTdzTU1mamtKUGJqNXJVUVZkS1NN?=
 =?utf-8?B?TDZWdU83V09uRG5FWFE0VVZoNFpNeVdRMDRLSXhQcjkrWFNkVlk5cHhVL0hR?=
 =?utf-8?B?VHhLc1EvdC92aXBsSmxOaUsweW82b1pGVU5YcFM3QW90SlVhblY1OStaSVlQ?=
 =?utf-8?B?MmMwU2piNFd5YUdpNXVvS2s0ZmFVWVI5QTJNRk5OakczN3paaGF4UjVCSFVx?=
 =?utf-8?B?YWV5VFRTRjNEdzlxZ2NRRE1ZSTN6M0Izc01ZSEo5NUtWYVQyejJGMzQwcU5I?=
 =?utf-8?Q?d0w2LMqmSKzOt+5dJkoVZUUZC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D662D26C6BFDF4286082C4A00525CAA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3691376-c24b-4f78-e4e6-08db7d2d1980
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 07:54:45.7663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jN74SJiihvE7q6P34VvHmIYnFqPAi1bwZVvPlbQYLMdxhEdLoLJ7KcpA8ikmUTpSYHGUD2wFssOSxZjG9Yczxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5909
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

T24gV2VkLCAyMDIzLTA3LTA1IGF0IDA5OjE2ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdWwgMDQsIDIwMjMgYXQgMDk6NTA6MjJQTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBUdWUsIDIwMjMtMDctMDQgYXQgMTg6NTggKzAyMDAsIFBldGVyIFppamxz
dHJhIHdyb3RlOg0KPiA+ID4gT24gRnJpLCBKdW4gMzAsIDIwMjMgYXQgMDI6MjQ6NTZQTSAtMDcw
MCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gPiBXYWl0aW5nIHVu
dGlsIHVzZXJzcGFjZSBhdHRlbXB0cyB0byBjcmVhdGUgdGhlIGZpcnN0IFREWCBndWVzdCBhZGRz
IGNvbXBsZXhpdHkNCj4gPiA+ID4gYW5kIGxpbWl0cyB3aGF0IEtWTSBjYW4gZG8gdG8gaGFyZGVu
IGl0c2VsZi4gIEN1cnJlbnRseSwgYWxsIGZlYXR1cmUgc3VwcG9ydCBpbg0KPiA+ID4gPiBLVk0g
aXMgZWZmZWN0aXZlbHkgZnJvemVuIGF0IG1vZHVsZSBsb2FkLiAgRS5nLiBtb3N0IG9mIHRoZSBz
ZXR1cCBjb2RlIGlzDQo+ID4gPiA+IGNvbnRhaW5lZCBpbiBfX2luaXQgZnVuY3Rpb25zLCBtYW55
IG1vZHVsZS1zY29wZWQgdmFyaWFibGVzIGFyZSBlZmZlY3RpdmVseSANCj4gPiA+ID4gUk8gYWZ0
ZXIgaW5pdCAodGhvdWdoIHRoZXkgY2FuJ3QgYmUgbWFya2VkIGFzIHN1Y2ggdW50aWwgd2Ugc211
c2gga3ZtLWludGVsLmtvDQo+ID4gPiA+IGFuZCBrdm0tYW1kLmtvIGludG8ga3ZtLmtvLCB3aGlj
aCBpcyB0ZW50YXRpdmVseSB0aGUgbG9uZy10ZXJtIHBsYW4pLiAgQWxsIG9mDQo+ID4gPiA+IHRo
b3NlIHBhdHRlcm5zIHdvdWxkIGdldCB0b3NzZWQgYXNpZGUgaWYgS1ZNIHdhaXRzIHVudGlsIHVz
ZXJzcGFjZSBhdHRlbXB0cyB0bw0KPiA+ID4gPiBjcmVhdGUgdGhlIGZpcnN0IGd1ZXN0Lg0KPiA+
ID4gDQo+ID4gPiAuLi4uDQo+ID4gPiANCj4gPiA+IFBlb3BsZSBnb3QgcG9rZWQgYW5kIHRoZSBm
b2xsb3dpbmcgd2FzIHN1Z2dlc3RlZDoNCj4gPiA+IA0KPiA+ID4gT24gYm9vdCBkbzoNCj4gPiA+
IA0KPiA+ID4gIFRESC5TWVMuSU5JVA0KPiA+ID4gIFRESC5TWVMuTFAuSU5JVA0KPiA+ID4gIFRE
SC5TWVMuQ09ORklHDQo+ID4gPiAgVERILlNZUy5LRVkuQ09ORklHDQo+ID4gPiANCj4gPiA+IFRo
aXMgc2hvdWxkIGdldCBURFggbW9zdGx5IHNvcnRlZCwgYnV0IGRvZXNuJ3QgY29uc3VtZSBtdWNo
IHJlc291cmNlcy4NCj4gPiA+IFRoZW4gbGF0ZXIsIHdoZW4gc3RhcnRpbmcgdGhlIGZpcnN0IFRE
WCBndWVzdCwgZG8gdGhlIHdob2xlDQo+ID4gPiANCj4gPiA+ICBUREguVERNUi5JTklUDQo+ID4g
PiANCj4gPiA+IGRhbmNlIHRvIHNldCB1cCB0aGUgUEFNVCBhcnJheSAtLSB3aGljaCBpcyB3aGF0
IGdvYmJsZXMgdXAgbWVtb3J5LiBGcm9tDQo+ID4gPiB3aGF0IEkgdW5kZXJzdGFuZCB0aGUgVERI
LlRETVIuSU5JVCB0aGluZyBpcyBub3Qgb25lIG9mIHRob3NlDQo+ID4gPiBleGNlc3NpdmVseSBs
b25nIGNhbGxzLg0KPiA+IA0KPiA+IFRoZSBUREguVERNUi5JTklUIGl0c2VsZiBoYXMgaXQncyBv
d24gbGF0ZW5jeSByZXF1aXJlbWVudCBpbXBsZW1lbnRlZCBpbiB0aGUgVERYDQo+ID4gbW9kdWxl
LCB0aHVzIGl0IG9ubHkgaW5pdGlhbGl6ZXMgYSBzbWFsbCBjaHVuayAgKDFNIEkgZ3Vlc3MpIGlu
IGVhY2ggY2FsbC4gDQo+ID4gVGhlcmVmb3JlIHdlIG5lZWQgYSBsb29wIHRvIGRvIGJ1bmNoIG9m
IFRESC5URE1SLklOSVQgaW4gb3JkZXIgdG8gaW5pdGlhbGl6ZSBhbGwNCj4gPiBQQU1UIGVudHJp
ZXMgZm9yIGFsbCBURFgtdXNhYmxlIG1lbW9yeSwgd2hpY2ggY2FuIGJlIHRpbWUtY29uc3VtaW5n
Lg0KPiANCj4gWWVhaCwgc28geW91IGNhbiBwdXQgYSBjb25kX3Jlc2NoZWQoKSBpbiB0aGF0IGxv
b3AgYW5kIGFsbCBpcyB3ZWxsLCB5b3UNCj4gZG8gbm90IG5lZ2F0aXZlbHkgYWZmZWN0IG90aGVy
IHRhc2tzLiBCZWNhdXNlICp0aGF0KiB3YXMgdGhlIGNvbmNlcm4NCj4gcmFpc2VkLg0KDQpZZXMg
Y29uZF9yZXNjaGVkKCkgaGFzIGJlZW4gZG9uZS4gIEl0J3MgaW4gcGF0Y2ggMTYgKHg4Ni92aXJ0
L3RkeDogSW5pdGlhbGl6ZQ0KYWxsIFRETVJzKS4NCg==
