Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6885743A4F
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 13:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjF3LH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 07:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbjF3LH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 07:07:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12313AB6;
        Fri, 30 Jun 2023 04:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688123245; x=1719659245;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q7LjnzJ+grSbeJ7TLG7ILDQuqC1om02YeMw6vw0QCO0=;
  b=JVdE0pJGjFDHnipquvkOTOfwZTAVCXVhM/J6MyKVDjGvFe/qEnc7NT3X
   XFz2uKy/+vTwogCrN8+BgkJxFhWhSNQHH46lbrCzaUwztfQ9nLYCAIgJI
   Xsjz3psDLuy6YjjErjkK5YecN59iMU/5ypbjd8A16IfCGkG3qexoVu88/
   FkyYcE3Ck7kyd14ni2LXDmjGZ18N1Z/vsUz83HHDb6IBWdRhPXqdS0/DV
   MlH/gnS3AVgGASC/iy0hRvtZ7EdrAY0FLy56fiKuWRE4jsREOOCR0FYk9
   vRzg8GdQujegIjWq48MgjQGMxPRVASiVxMADjmerBp8O3p2foq30XKV7q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="361215753"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="361215753"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 04:06:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="1048192167"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="1048192167"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jun 2023 04:06:40 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 04:06:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 04:06:39 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 04:06:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7McvjfaYVvVTkpdDmK1m4aInUsDzjcZyUG3h6inLm+2PCbb00Zj6vaP8Hja0bOGP51gpepI7E2g2uB0xbSRJ61H9a1t1tJipZw4Ib2lQFlE5eOLKEVSFhtLTgl4tXddQa5LeiLspqwDzWoo0AEtS8js6Xpq6oHbtD5aYLiaXMbm+aM87lGEH2d4LlwocUlxiiB8YLRWRj/dbcEZodaoQlb6cCyLedhOXH7Ah1iZZG+zb7EOTn2N00RJkU6dKrZ0eT3UfvyBaRIcT+zR69rrVjMaPSGwjfR7nI6Cf8rWXOb8w6cuC9gwXEtIVE0weMjzrYlymikm7RjFEkz3UuNqyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7LjnzJ+grSbeJ7TLG7ILDQuqC1om02YeMw6vw0QCO0=;
 b=mxwmneit31zF7YGinY9ubR3KNxVrvkZWLSqUaQg0FAb8B4dva2FJm7n6l0OuIKX0fXVpVcwNCJxo3KOP3r5lz2kTBssPkN+W790lWRpkyNVgMvNPMCodQF9+OlrEnkZFfKDRwidAm4Q5rxu3sesGEvTkxYU67u8/79RPL/LtCz7h80h/Q5FaYR6Y8vmfJ1fpFmt136xmkqG5rgM+4yHFBdUX6hjcC0nllw9ImTycLyTm+uEUCoILbI+/K4bZnOTqQfkYHLAUh3dWJEbcXOWwqpTpmpCID6rwZe9Hs6TKtIo2m5jaTr1leyMTFxMKB7FTogSOxy79p8whBCkRDySvoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8538.namprd11.prod.outlook.com (2603:10b6:a03:578::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Fri, 30 Jun
 2023 11:06:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 11:06:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAAlDAIAAAXCAgAJXt4CAABCVAIAABbQAgAAMLgA=
Date:   Fri, 30 Jun 2023 11:06:33 +0000
Message-ID: <7e6d6ab222861bef6e871f0092e97b9da1b9ab1f.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
         <20230628211132.GS38236@hirez.programming.kicks-ass.net>
         <20230628211641.GT38236@hirez.programming.kicks-ass.net>
         <20230630090309.6mnsvfhcptekmzfu@box.shutemov.name>
         <84e13c5e32f001b8c79f0f18fe18f3225cf47dfb.camel@intel.com>
         <20230630102254.gb36e77w4m4obx4b@box.shutemov.name>
In-Reply-To: <20230630102254.gb36e77w4m4obx4b@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8538:EE_
x-ms-office365-filtering-correlation-id: a1997613-1b83-4863-08da-08db795a106c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y373t1tg27OaS0oizeKwwXXCH4rM6JcGKIUlJCWXZbpbRR6qFG291ldQgQ8rlovM9L1j0GqZOGdCTtzpKkG2wS+NBMTIepabIO8RBk6IeUUgoZgsyOg29lvGBTiIl+LBuUPUdVjQLErx90zKqho0VdJa+aPr+87162RHPxLLTS1nOUUOlJvUMndpEjcMYRcM2jYPbvIlSC4aW8m54lHhAOeExQubhWSENIxVLvcyviZ/RKZCU08PuxehJ13Bqjjt7nlUZ+DvOl0RdshqCfdynjqbq2Duk1qfDCjUaCTuxFO4gBtEtCyNV407yJrKit/E9mX2dMp/zGtKfv3y7mSRWnpj7o5LcVhvQeAUsn7wp6f672o1NB07Wc1fbAqiX5Rp8IDB9+vCWv4MugrqzCZiP+RTZtktZYUw6rcUABxBJKhRRrlXLrCca/b8M2q+zvcKLzQLc5tMsPM2L/79DHHS9CQcYAjiulot76ylzD2aGhUcPYEo7UvxvHFQHOeg9PNPTw31FbJu8E6eStduG68oLrUUJLQ/HoOfzDZ1pPBcwpoMBdIqsGNcLr2ydpsfVcyLb2cD0HlWHE2sbzUye7inbH250YmM8LVLByMrcMMecX7TWdsIK+tmLTVqAJEZm1Mh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199021)(5660300002)(7416002)(64756008)(66556008)(66446008)(66946007)(316002)(36756003)(4326008)(478600001)(6916009)(91956017)(66476007)(76116006)(6506007)(8936002)(8676002)(86362001)(4744005)(2906002)(6512007)(26005)(54906003)(41300700001)(6486002)(186003)(38070700005)(71200400001)(122000001)(38100700002)(82960400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3VZRFp1ZlZQcVlRWmVNdzJrU1N4dTFibUoyQ0tQK28vb0tsU1FKN1N6RzVh?=
 =?utf-8?B?R3pxeU5acnBxZGVnZ3I0U1Q5UWp5VFQrK08rZ0lxOU9iallkTUczenF5Mnlu?=
 =?utf-8?B?NVJPQS8yU2dJKzN2dHN5THdrbnVoci9QS3IvQnNNSEEwZy9aRkdNRWYwdkt3?=
 =?utf-8?B?WE1XNFQ2SjYycnJTMkFMcGdFUm1HNnFFQTFRTFNRNUlzQzVJNlAwZW9Kb1dy?=
 =?utf-8?B?M2pzVE1mUksxaDhpNkpkRUI4dDU4dG11N1lVa21OQWdyR1NZSEVkcUZpVytM?=
 =?utf-8?B?ZStsSDhyZFRTMXBaMWRHRndwYVdoRG5YWXcxbEhkMWd0VWdJUHNISVd0Ulgx?=
 =?utf-8?B?cC8xc0VrL2tWclRRbU03L1kvTUZ2VGdROU1qWE1DMjU3QWg0MVdlQTdoV2Zy?=
 =?utf-8?B?c3ZUSHlIVVJRK0RLdENka0ZEOS9GQndEaTN4NXZvbENpbkh5NmpzQWRFSWdY?=
 =?utf-8?B?TC93cGRsaG5XR2pSejh0REFyYTZTblVxREJ0ano2UnRhUlBuV3hWbnJ1SzFW?=
 =?utf-8?B?czFZVGF2eE8rSDRIVXByOHk1cnUzSjlWREFKZlZiSjNybC9BTm5nYVJ4WHhU?=
 =?utf-8?B?TXU0ZmxRLyt2Z3FxVXlOVzRycXJEeWpNWlhFUHF0RjhGa2pyZGtDNUdZaVBK?=
 =?utf-8?B?Smk0ZGdaSXNnY0FIKzRSZFYrazdOQWFHS0pVbzRTN041SjVFeHR3OW4rSFY5?=
 =?utf-8?B?ak00b2xWUGVpSFlXT2xGSmd1L1pLRTJSYUhGc05RMjl6a2x0TWlETFh4bzlr?=
 =?utf-8?B?SDNzanFKQUYxNzlGVGN1NjVuSWxvZEk4TG53eW93Vmp5R0krVGlwai9sZmpB?=
 =?utf-8?B?V29oRHcvZklRNGlRTkxqcmxZQi9nQjdTaGw2aTFVVjFUajd1RHVOSWxodW9s?=
 =?utf-8?B?V1FuNStCVGpWVmMvcHNNSUd2bHFSR1ZNMjEweFBqSUU4Z1NFYnpGa2thUXBM?=
 =?utf-8?B?Q1RhV0JrTFdwVi9mWThCRXF3VlV0RHgvR0VkRjV2OGxqbkJqSFREcHJndzFT?=
 =?utf-8?B?cURCYVZRTGtXRERodzdZMWFHdEZad2paTUZrN0ZkOTdUMlFvTHB3US9pcmFB?=
 =?utf-8?B?SExLNkpCVUo3b0tueWI2VVNGMlBZUHYvMHhVellsNXQzZ3l0UVJuNUJpenV5?=
 =?utf-8?B?Z01DUzl2dUZoM3dSR1lBMDFyQlBQckhsUERIN21ZKzhKOXR3dmU5QXdXaCtL?=
 =?utf-8?B?NFZPN0J2NW5sQ2gvdzdWR2dIdDVWdjZwMU51aDZyVFVjZ0lqUU5MVGU3RVQz?=
 =?utf-8?B?M1F6Y2lwQ2dhL0FTWnJxSnc1bWJZb2xnRUxYaGNSMmVxeU1hR0tkdWJKL3l0?=
 =?utf-8?B?Ykd1TG1TOVc2MUhqcFlTcDdpcUFyeFk3Sk9SZ1FhM1d5cEhtSWVOSEVsOEMy?=
 =?utf-8?B?LzRhZVVQSjlyKzc4dDZEb2NBUXV3aWNnU0I4d1VJV1cxT3p1R1ZpSmZ6SFpu?=
 =?utf-8?B?bDB1ekt5V29oanF1RXB6cVZrUjFNK05BOWF2TkhZVnl0OS95K05OQ3JFZWNv?=
 =?utf-8?B?d0E3cmkyM0I5UWdJM2taNndWdGlMZXhhbHZtZWlNRXZnaE5ORDd0UlRQU0gx?=
 =?utf-8?B?bERtL2haeE9yNi9VTUN3aGFsV0d0RUJrSUQyc1NPTDI2NHdGMkdNOTQ0Nisv?=
 =?utf-8?B?QzhCL3BySitaNjM1Wm44U20zQklPL1JrOTNzZmZHYlpaZkdVc2FrRklFZUU1?=
 =?utf-8?B?Q2RmMnhEWUJlU01LRzFaQkFDWC9wbm9EWkRhQVdYdXE3blRJUGVuNzJmdEpq?=
 =?utf-8?B?d3FXNmRFVjVDV3duc1BpYUNjK1NTY2N1bU1aY0lPMXliTmNJODZ5TTRlaW9v?=
 =?utf-8?B?dXNKTjNBMzJ1UHlmbmZRd3dBQW9TcERMMW9NMHlJTG50RFF0NGxIR2lEcUxn?=
 =?utf-8?B?cXVpMVRIYmVsWUdQMjFJdTN3R0tYK09YdmYyVjJXbGdZMk9DR2NubnhRUlhB?=
 =?utf-8?B?RGRFQ1paOGJMUU1ITnBtdzJSZlM1YTJrRUlvMmRYRXR1VlUrVHRETGEwZDdn?=
 =?utf-8?B?enJUVnUwMWxWMDF2NmFjRmtsRkg0dDBCVkU2Rm5Vc2kranJCc1NiOFZJSllB?=
 =?utf-8?B?Vlc0aFIwNUJXUzNnSXJnMENWeHp0S3Q2alEwTHNWVVJiV01RRm50ZzJQVzZT?=
 =?utf-8?B?YnNPdGl1WjFFYXBYeDVrbVRLNXUrd0tIU1ZvTHE4bndwenI3eSs0VVFxQkdn?=
 =?utf-8?B?OUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAFEC9F50D0DE449AC18D35B541ECCE9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1997613-1b83-4863-08da-08db795a106c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 11:06:33.2000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WBe7N3XloBF7tv9kLBVZaBuFDdOTjqHAoFfW5Looby0BXapTgiP4jUsgSZ0RLW1WgVIaCE58tLpVwpKx8AKm+w==
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

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDEzOjIyICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBGcmksIEp1biAzMCwgMjAyMyBhdCAxMDowMjozMkFNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IA0KPiA+ID4gDQo+ID4gPiBJJ20gb2theSBlaXRo
ZXIgd2F5Lg0KPiA+ID4gDQo+ID4gPiBPYnZpb3VzbHksIGFyY2gveDg2L2NvY28vdGR4L3RkY2Fs
bC5TIGhhcyB0byBiZSBwYXRjaGVkIHRvIHVzZSB0aGUgbmV3DQo+ID4gPiBURFhfTU9EVUxFX0NB
TEwgbWFjcm8uDQo+ID4gPiANCj4gPiANCj4gPiBDb29sIHRoZW4gd2UgaGF2ZSBjb25zZW5zdXMu
DQo+ID4gDQo+ID4gS2lyaWxsIHdpbGwgeW91IGRvIHRoZSBwYXRjaChlcyksIG9yIHlvdSB3YW50
IG1lIHRvIGRvPw0KPiANCj4gUGxlYXNlLCBkby4NCj4gDQoNCk9LIEknbGwgZG8uDQo=
