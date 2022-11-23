Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD2636CAD
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 22:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbiKWV6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 16:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbiKWV6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 16:58:42 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C819682B5;
        Wed, 23 Nov 2022 13:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669240721; x=1700776721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=//QNVKvaBlQpONm+TQqX/6e6AhssPRuwJMETfZKy5xA=;
  b=A99e8GPpQ7E8odiMrtNy+xb1dxuuwbMVf6nAl9M6dbAZXPBOthBmn1CP
   tj6lGwBMpmwUtorIwvVF5mYQy1ZBgLnwGd2cF5GlAYKkgONs6HbAL7BfC
   IUU3yZ3/YBNWsHWUUbdH5mfNbHi/0w22agwshOYEFpb6ePDxu7T8riJW8
   7dUPgXx2baIxk55fADbHANRiKrNtpeeRgDs1ySqACda9/EJKuAVSHf8NW
   0XrsKL6yufTkjEle3lvcFbRBLU8ZNfENeO2funWqxKbTXX3BVo9B8+4rK
   CwqtITTnTVE3mCP6zTL47XdEnEF/Iw+JJPX6XPPsaWe7uJOC1CkbKEnI8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315986646"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315986646"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 13:58:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="673020587"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="673020587"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 23 Nov 2022 13:58:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 13:58:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 13:58:40 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 13:58:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9/BBZCY2fW95GkJXU7mWTr2WlhoKPczWpKz6marokRoVcq1i1hXt9Km0wfhtY8W/gn/N0rW305WpIpPIC262vOR0Wp9cmvAjlEv5zbpZzqkrkNK0L87dhkHUl/Nm4yui4XOuaztsqFvqPWUf3itMfE1w8jF1GdHUpJ1kc86oqluCZhZpT8pvovC6HCgWSN7IAZIhd0Jx+2mM2wrOrF5on6nGtuD5L2WrkaDU7Lz2z9S6VATj4CfmkQHTAwqR76oHu9snLxVnkpydObV7fNIabJKytgLzowo0R8CiZBkteZaBHuXFOXqe10rSjMIuEDkqoZsp+IpCvf/CqAtbk6FPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//QNVKvaBlQpONm+TQqX/6e6AhssPRuwJMETfZKy5xA=;
 b=IRYvn/syUAz9lPeTRso82P9b0H7akp9mTyNE9jNhQHe07Z83KwablxYaQjA5Emq5yjpStUaw8aPNCRTR4QcajmM2L8agOeEDB2vSnDwFZfjBXp0E/IBhUOBR03JiNQz6npKzU7CsWwaewEDCjKYauXAtwv+m53do/wkyGUS6PEyAxZCUN0z5H9feANcHl4nUCcXLCCe8zHyl2TEZ4k4YChgnxPS5PyklD0huccufDo8WBVf+1GLSwl5ZcvqcHnI1wGcP9EupAfHoddUXLs3HV6dYzgf/w2DOfO7PKnBm6KrxzABo4ryFpGwxFZv9XeiiR+GhKMhoUvMjgPT+QmKUNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5820.namprd11.prod.outlook.com (2603:10b6:510:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 21:58:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 21:58:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Topic: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Index: AQHY/T29USV2IuUHCEyPQthCEbaZH65LP6iAgAEPmQCAAHACAIAAU7oA
Date:   Wed, 23 Nov 2022 21:58:37 +0000
Message-ID: <c70d614c66982bde591aa075946322b9225bb17e.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
         <ea588f69-3b9e-b0ec-e5e1-a174d6031681@intel.com>
         <f9bff97abe68cc09aecfd96226ba91e972e5a2e8.camel@intel.com>
         <e87b68ed-c51c-85aa-1cf9-7a67b8eebe00@intel.com>
In-Reply-To: <e87b68ed-c51c-85aa-1cf9-7a67b8eebe00@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5820:EE_
x-ms-office365-filtering-correlation-id: 9803e6a3-401b-4dd2-0d88-08dacd9ddf9d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 11PD/dPZpLIc5ieRWNUoDvivR9WY71Y8iVdbPPr+4oQ+7cH9v5uVuj/ca5I7PkqQ8Bbo9e+ZrB9JbgXFvDX7uoIXqCYqj7idewj96+IS2dfCSlXwD63jXmC2y3avfxzl+EDCbM71gvp3aD47tRY60xqZwrh+xhyGgQeGhspQ+1EEXHfH37KEfGIEJDsfR4cgxN9LtRnjPxJv08Cl2HS/IwY/u+szd6XjRc25Br9dy0yrSrnUgPKdP6y3aoeawPVr959YSf7uAua3snK8fJyYITkPd7o15ntzC78JhNki34bM6/vDDKgabaZbBMNLGCk0gEI6vWqWRkGm0JAF9HNFig89Bv0lbmrCjzrGqKdScW5tgw+NlTRTKfWjlFSExtbXSJjGmSgr7Ou0RWkf7HxvRc/karAn+9flrKxvIVwjAp0Gv91sST1lZjHbt70sw2AeEP2mK2+BVAUtJwiIlA4lmQWAvlP+pQ8KExQF5rL3E4c5R6rEiFh7EULgaE8jYzJ/yLDXSqO38Yzi2ZvklDpSErcse0wwqjggO14bWBM0CPQyzVs4MmwAoSzzABxDQaUe99bhIt4EI8b9V4FeWWO0WJxf5qF4EXvA/BF1itO6OyXq8de7uNKKf/4FP/oCYZv/X35dopllcYxjrPNBiKjesInPevTtlgK0zsQDxHR14MWShKVzTEgxe6zpG5W8FX+bp9qLQvdmPzXIcCnaIkGASA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(6486002)(82960400001)(38100700002)(122000001)(4001150100001)(2906002)(41300700001)(66446008)(8676002)(66556008)(76116006)(66476007)(4326008)(316002)(66946007)(64756008)(91956017)(110136005)(54906003)(7416002)(38070700005)(36756003)(478600001)(6506007)(6512007)(86362001)(5660300002)(8936002)(53546011)(71200400001)(186003)(26005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzZtcVEvSldTTEQrNHJuL1JpenRZV1BnR0NmVEhoU0RtM2dpWjhCbFpOanhF?=
 =?utf-8?B?VnZ1MGRla3hQcEhSaDUvOUh6dUh6MW11YVdteHkxTmJEQnBZaFptWU55Q3hS?=
 =?utf-8?B?ZWVQUzVnL2gxZUpRZDVCQlA3SnFxenNYQWQ5WEJLanhKTnQ2dTM5WS9uTERw?=
 =?utf-8?B?NWl4NTVPRTFlZHJaZmZyZ0lOQmVhSFFiOURkSnpjaUM5VXdhd0Fnd280dnFH?=
 =?utf-8?B?eThib0FNZWlVQUx1S3J0LzFxK0pwciszR3ZoVm9Wb1VHTkxsaG9GS25RNWJQ?=
 =?utf-8?B?TmVlbWRmVHArTUFJaVB3c2J6K0RSOXR6OTNGTGpNek9BbUZPSTZRR2dlQVJ4?=
 =?utf-8?B?UThmMnE4TFo4aUFwL0x2M3IvMVVzNjhCaVJvaHBBbXExdGNKUHRRY2k1cTBm?=
 =?utf-8?B?VVhMS3daZTBJazgvcEhwTStobVJXTUZBaHltVTIwaGE2TmZDaWVVUUg5U3J6?=
 =?utf-8?B?WVl2cTMwTUpCclljbnpPVGw0cTdMbWhLcHJpNkt6MDNEdk8vUnUvTVhMa1Fo?=
 =?utf-8?B?b3RjNVA1ZWVGbFVqL3dSSFJDQ3NHUWErWHVHZU9WbEJFbmpjSm9sQmd0MlNE?=
 =?utf-8?B?ek9JYTNRSWM2bzB0WldhL1N4RVBRSUhINlVnWlZuWmZZMUh4Yy9lZFhtV3Zu?=
 =?utf-8?B?VGwwKzBnSjdSTjQ5QVljMFJ0TEVteVphNWsyYU5keTFqVHNRZnFVM1Qvc2hZ?=
 =?utf-8?B?M21PL3p3d3ptd1crMHBSbE1NUmFyYStWZ0QyYlk1YmpGMlBiMFRWeHdCTnpE?=
 =?utf-8?B?Ymk5OUpISGY0VjZmQ1JZYzRJLzVHZElSV0R3OWQzTWloY0ZLYjdUeVY3OUhI?=
 =?utf-8?B?SUl4dytYbU1EN0lzZFVwcTRiV0M2M0xxRlpzNElJRlBLWUFPbExXWEt4eE5X?=
 =?utf-8?B?VEM2ZlZHT1J2L2JaWE8wNTlVOE9hckhocVkxNWxtbVpmcnhuM3dTUzVrOE5i?=
 =?utf-8?B?YWNwV3NYT1BLUWQ2MjF3WTBEV1g5SWs5SHQxV3pKWnkrclJwQ1BBSWc3TTIy?=
 =?utf-8?B?NGRPY005SDFVblE3UnBNdHJiUTRGRStxSTJld1lORU5hOHZyd292TDZCK1JN?=
 =?utf-8?B?SndlRFFtbDFnbktwMzBwK2RWa09QOW8vKzlpMEZ1ZGpVUlVnMFJoclEvcjln?=
 =?utf-8?B?YkFSWWJUZlFQa2JjUGVaaWhoM01KM2FjSHczZjlRdEYrYjRVRHJiaVpSbWpq?=
 =?utf-8?B?NTFTZ3h6YVBXU2EweHorY0crcUl3T2x3TGNwTG94NnFHVTFKWHFOeDd4amo4?=
 =?utf-8?B?K1JoSUdpM3pBYkV5RGltUFdNa1k2blVSajZBcnJRSjZET3ZVZ3ZHV2MvVXkr?=
 =?utf-8?B?LzBRMFQ2am9tL2dkNHdWaXVTSE56cllUVVpManVkQkRJMHhvOE1NUDV0bUZq?=
 =?utf-8?B?cVZ0UnBEd0xtbE5IcFRNVVFrYzI0RG5pUnRHajBFMmkwT0ZEMWZ4YVR1aTFH?=
 =?utf-8?B?RUhNSGtvV092OEhoTlNjSFNmMmcvL1ZoWVJVLzR5TTNuQ25hRkRPbktDMzVE?=
 =?utf-8?B?SDUwdmVReGdGRzZhWUJjZmdqUmRMTlZQRGpaY21DNFFtYVltMStmZEZFM2or?=
 =?utf-8?B?ZFpxTGhaSlpZVkM1eDhsZFdHRXkydUR3K25SNkJiS2NvT25jWnNJV1RHVTV0?=
 =?utf-8?B?b0ZxT2hDdGtxV3Y1NEY0bE05UTQxUmd5K3FwZ0hIbjBxb2JhR1hleTE5R1Jo?=
 =?utf-8?B?KzZ5cGpNcW5URzM5MTNwb1lQZkR1amM1SEVHbkxEMUdXNk50Tjc5ZmREM3Nx?=
 =?utf-8?B?NXp0L3p4ZWJMNHZWU2hKN3p2SGszZXhpZk45bWlGVXZWckpjbW5rYUFDWjkx?=
 =?utf-8?B?WktneVlNWUJCMjV3a1dFT1o0M3B3a21PWUxjekdaRlEyK0JMeURGeDliSnU4?=
 =?utf-8?B?alpkNW5BUGorZnZVOWJDRTd1M25kMGJ1cEg5ZHo2UDFYRURBQVNwYnJlYnky?=
 =?utf-8?B?dE1vbTdhQmZOdVNBR1NyU0lwRERYR1R6aGthQ3NFN016c083L0ozOVZ4c0ZN?=
 =?utf-8?B?THVXTkdscUJaQzFRb1k2dXlyLy85STRlNnRVWVdQd3hMaTcrUGp0VjM3UmlL?=
 =?utf-8?B?MFNGMVFUbHd6RHduTDNIeFVGOVBqMnNGY3hwMjdHNHdJMjJBU002Z2dKVXFs?=
 =?utf-8?B?cGFvdndNQkpqS1lsZmRLRGJBTHlBWGZoTEF6RHdvQk9wc2xwTThrUTFDdVQ1?=
 =?utf-8?B?TWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ECFF3C08BDB5CC4BB51CC82EFE17AE55@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9803e6a3-401b-4dd2-0d88-08dacd9ddf9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 21:58:37.0892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rR7/Ba2s5FQ47HzirRtUtJh3NzmwTcxuAfUP6x1FJeiUktJDABAGgCj7AMfIUIkp4TPYD+lZV/nj90/gAeIU7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5820
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDA4OjU4IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjMvMjIgMDI6MTgsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBBZ2FpbiwgdGhlcmUg
YXJlIGEgbG90IG9mIHdvcmRzIGluIHRoYXQgY29tbWVudCwgYnV0IEknbSBub3Qgc3VyZSB3aHkN
Cj4gPiA+IGl0J3MgaGVyZS4gIERlc3BpdGUgYWxsIHRoZSB3aGluZ2luZyBhYm91dCBBQ1BJLCBk
b2Vzbid0IGl0IGJvaWwgZG93biB0bzoNCj4gPiA+IA0KPiA+ID4gICAgICAgVGhlIFREWCBtb2R1
bGUgaXRzZWxmIGVzdGFibGlzaGVzIGl0cyBvd24gY29uY2VwdCBvZiBob3cgbWFueQ0KPiA+ID4g
ICAgICAgbG9naWNhbCBDUFVzIHRoZXJlIGFyZSBpbiB0aGUgc3lzdGVtIHdoZW4gaXQgaXMgbG9h
ZGVkLg0KPiA+ID4gDQo+ID4gVGhpcyBpc24ndCBhY2N1cmF0ZS4gIFREWCBNQ0hFQ0sgcmVjb3Jk
cyB0aGUgdG90YWwgbnVtYmVyIG9mIGxvZ2ljYWwgQ1BVcyB3aGVuDQo+ID4gdGhlIEJJT1MgZW5h
YmxlcyBURFguICBUaGlzIGhhcHBlbnMgYmVmb3JlIHRoZSBURFggbW9kdWxlIGlzIGxvYWRlZC4g
IEluIGZhY3QNCj4gPiB0aGUgVERYIG1vZHVsZSBvbmx5IGdldHMgdGhpcyBpbmZvcm1hdGlvbiBm
cm9tIGEgc2VjcmV0IGxvY2F0aW9uLg0KPiANCj4gS2FpLCB0aGlzIGlzIHRoZSBwb2ludCB3aGVy
ZSBJIGxvc2UgcGF0aWVuY2Ugd2l0aCB0aGUgY29udmVyc2F0aW9uDQo+IGFyb3VuZCB0aGlzIHNl
cmllcy4gIEknbGwgeW91IHBhc3RlIHlvdSB0aGUgbGluZSBvZiBjb2RlIHdoZXJlIHRoZSBURFgN
Cj4gbW9kdWxlIGxpdGVyYWxseSAiZXN0YWJsaXNoZXMgaXRzIG93biBjb25jZXB0IG9mIGhvdyBt
YW55IGxvZ2ljYWwgQ1BVcw0KPiB0aGVyZSBhcmUgaW4gdGhlIHN5c3RlbSI6DQo+IA0KPiA+ICAg
ICAvL05VTV9MUFMNCj4gPiAgICAgdGR4X2dsb2JhbF9kYXRhX3B0ci0+bnVtX29mX2xwcyA9IHN5
c2luZm9fdGFibGVfcHRyLT5tY2hlY2tfZmllbGRzLnRvdF9udW1fbHBzOw0KPiANCj4gWWVzLCB0
aGlzIGlzIGRlcml2ZWQgZGlyZWN0bHkgZnJvbSBNQ0hFQ0suICBCdXQsIHRoaXMgY29uY2VwdCBp
cw0KPiBzZXBhcmF0ZSBmcm9tIE1DSEVDSy4gIFdlIGhhdmUgc2VlbiB6ZXJvIGFjdHVhbCBmYWN0
cyBmcm9tIHlvdSBvciBvdGhlcg0KPiBmb2xrcyBhdCBJbnRlbCB0aGF0IHRoaXMgaXMgYW55dGhp
bmcgb3RoZXIgdGhhbiBhbiBhcmJpdHJhcnkgY2hvaWNlIG1hZGUNCj4gZm9yIHRoZSBjb252ZW5p
ZW5jZSBvZiB0aGUgVERYIG1vZHVsZS4gIEl0IF9taWdodF8gbm90IGJlIHRoaXMgd2F5LiAgSSdt
DQo+IG9wZW4gdG8gaGVhcmluZyB0aG9zZSBmYWN0cyBhbmQgY2hhbmdpbmcgbXkgcG9zaXRpb24g
b24gdGhpcy4NCj4gDQo+IEJ1dCwgcGxlYXNlIGJyaW5nIGZhY3RzLCBub3QgcmFuZG9tIHJlZmVy
ZW5jZXMgdG8gInNlY3JldCBsb2NhdGlvbnMiDQo+IHRoYXQgYXJlbid0IHRoYXQgc2VjcmV0Lg0K
DQpBZ3JlZWQuICBUaGFua3MgZm9yIHByb3ZpZGluZyB0aGUgY29tbWVudCBhbmQgd2lsbCB1c2Ug
aXQuDQo=
