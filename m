Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D908D72B57B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 04:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbjFLCwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 22:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFLCwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 22:52:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31C1BF;
        Sun, 11 Jun 2023 19:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686538336; x=1718074336;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=81YkRR+uwzuYVvgVKJ1c3SlsS3cZnysrA/7ppy1yZuY=;
  b=JlsTnaE0fWy1NDfooMCKgE9K1JUk6BOO1onF5LTQORJx2LJ926cgjc4r
   QLKfOy0wXC9t63jr0tEglRjD70aU8n7WaTShXddrMkoB6RdApyCKveSiT
   1f1GCp8gTY8lDmU5jgFdMeoZoZQYbomqKroEEbLnlI6RyUHbBG1Bl1vho
   KJqc6ChSIGTaVXE/13T3aHV8Uxoi2IUjlp1aWU799OXoEdOh4lv2z6BIy
   S1NCx0kgguSiMbBirwiOesTG0GQN/xloeQJprPGm/mT1xmEp8FDiaVoeF
   GVMQ4AGuSZSwGcvde+cWAPBvP9oxRB6KZVYim9waxdW1/6gYEKs0gVDAy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="357926425"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="357926425"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 19:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="705217038"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="705217038"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 11 Jun 2023 19:52:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:52:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 19:52:15 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 19:52:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLq8NRUewuzuBEWRdeB6HqYc63ZNHkvpghveH+l37JggTpzKYqPE6yvb2KAlOHqNX5kdAz7OP9nI53fSu6LRcLq1Q9mZZyI7KLr4hkYVce2ik4hmIkG2vdRpdsFOqVoCH+hKS0/H02l9JU5fn3FajrA93PQ6MGvCXhR9yp2MLxuAEI7+QaswBRAsrgKUMLwg8pZz9V0cnRtrCd0kw0tXcnV/VOG/BA5/zrM+AccaxkfG4w2nZyWpBajKc3vKAm35QepGQgPhTDofIc4+SHMyJgMJDxThk2T5Gpjbgni50b1tW0T0FTEXWxWLs+TLxHkbmInu0HM5ZIb/If69RONK3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81YkRR+uwzuYVvgVKJ1c3SlsS3cZnysrA/7ppy1yZuY=;
 b=AF8F6N2L+8tBWCTKaVgnSh89Zg5ZaIoSk+6nRk6hsfYh5mpvc+7J5boT5SnY8S7FSHggQG3GKMAUUT2PvBVgVKFj4Ig+XsHBMtGiYn1CNUQG4TgauhfRqD3JOCP6SubXM4/nKx6UJrlXgmWAhkmeaztdblyD0yQvU8USLxIBxNbfCshd6kIFXS+mDG8tOVLD38642r2Is91QdezQCIqJK4vheJ2vfZwuhVg4lnOaIm1Hcd3ukMEF1qy6ZyQPdlSE7Z1CWJJgxwM9352tWR4k9+BSQdD7Wyk7hNK/aEaqyOgTSC/JbomhYEmqr9HzMh1CX4Ck0lBgdS0tKyK+2m2I2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5519.namprd11.prod.outlook.com (2603:10b6:5:39e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 02:52:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 02:52:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 12/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v11 12/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHZlu+5q5NS4Kj6PEufTtj99AOoBq+BkvoAgAAFRICABOumAA==
Date:   Mon, 12 Jun 2023 02:52:13 +0000
Message-ID: <19b612683cf190ab2eda55f83bee554e40c2233c.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <4e108968c3294189ad150f62df1f146168036342.1685887183.git.kai.huang@intel.com>
         <20230608232452.yrx2tekugkvral4z@box>
         <b456ea7c-18be-3397-0115-fa25007741bf@intel.com>
In-Reply-To: <b456ea7c-18be-3397-0115-fa25007741bf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5519:EE_
x-ms-office365-filtering-correlation-id: f922cd97-4e4f-41ed-9d57-08db6af0063b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2jf7urSK0mTNpbZ38Bfkgw3IG7qV2h9eRWEbGKxvYHzgih+mZ6NTiYHLgwG5m0II0cjimc3bhojAK1j+crOGmB9H6JimuakOPWvT+P5I4yrmiKc6qG4OpIiq2/zUa3l8b3gELIrcOsdrSVdea64yD+lMsk6P6sycycw6YWxPIDa7wd5ThA7v7D8BFSJRffJ2VCyYZ+pLnOqxZyRuPMR+HNhGxXfzG0pD7/BjojGlGIu7hQ95xTb2Fgc3tt1cYmV2VXShVe2+cYb7W5LLt6oWA8Kbc1IdEKJI8AUOpWt/f6C6wGyJeXN0yyMhtxSbEN9hVjysJYc95NwYGuBtq6WApTEwvbGuIFRh9TVi6gqEqnotKs7JJ0liO+IomJv99V2fvNuoBTCuBlQKAXsd6hbnqge/87he2lBDjeeoa0z7/xBiEWjcIrrDN0Ow1E9qAuimZj1VhvSKEL3MkPhTibpv/AXNt8XuJqSSbcU94biS16HxhOGiAWWMzMNrnMULWpRh1QKA6GhSqMepf5ZppjPCMYfKl1EufH96GQJsZ+G+yaCTmZsc7f/+p1QvBT+n5DoNM6hP3n/di5nQqBmwSG1pg0TH2Bt3fqnHHfc7NsL8J02qMfo9VSJlKKKAtGwmpI30E13hlKcdzvPtHMjmfL3rpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(346002)(396003)(39860400002)(451199021)(83380400001)(66946007)(66446008)(64756008)(53546011)(91956017)(76116006)(26005)(71200400001)(6486002)(6506007)(6512007)(478600001)(110136005)(54906003)(186003)(2616005)(7416002)(2906002)(8936002)(8676002)(5660300002)(86362001)(36756003)(4326008)(122000001)(6636002)(41300700001)(38070700005)(38100700002)(316002)(66476007)(66556008)(82960400001)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qzh2cjcrT09uV2lnNVJHQkhzWTVQSEMyYkxRMm1iZzdQeUh1dllLM0lPSDE4?=
 =?utf-8?B?dnV6d0tINWFKVFJybEZSOCtSZE1kd1NqWVdiRXJhZ3lvU3VKU2kwMERQQW9t?=
 =?utf-8?B?RHQzYTZxTURLRFA3V2pmajRUMlBnT1l2emM4S1RoOXNYOEdRdEhUQ25ndzJw?=
 =?utf-8?B?NmZ5Y0dzQkhDWThIVU9TRm9MZTRXWFRRMHBPZ1hZaXFYT0U4dU5iRW9oN1F1?=
 =?utf-8?B?Y3lWRzczYU1ZaGhlTmpZa3JOSUJMNDNHN0Q0aGZ3TGVJWENqd3NJWXZWU1Ev?=
 =?utf-8?B?OXhVMzNYQ0tDNWg2enJUTGZoMFg4b1Fob0RNU0RlUkhzdHdUeldBNnRCRkFC?=
 =?utf-8?B?R01QYkdQRkNpT2F0M3lpVlg4UWZ2bFBtSkRxMjJBam1HNGJyYTFHYW95QmVW?=
 =?utf-8?B?Qk9hT2JEanVpeXFBNDVsVEllRjUyVVdmb1h6WnpueDNYRjFZNGZtU3QvWi80?=
 =?utf-8?B?TnM4MnNLRXNVZG03elFDeEI0UWlPbW9tWUVGdjkvc0VoODhLWGZFSVZOMkhU?=
 =?utf-8?B?ZnFFYjVEeUY0QlJ1ZktBR0lsRitSTkN4RWxpcUovRTg2Q2hHRzhpQkZvRHlI?=
 =?utf-8?B?QnJvWExmOVhIK2hnR1RGTVBBRFd5Z28wUm9aVGVUUmhrU1VsNHMweGVPMUw1?=
 =?utf-8?B?VGlYUTh5NFFoMXF0R1ZzWVBFREhYRjZCMWNmWDVNZWl1QlNDRVI5TG1qSG5X?=
 =?utf-8?B?Vmw3OG5udDMzYXpIUjVQVjlCeWx5YVlsWUVZbXM1NjhtZzJmQnE0d0xGV3FM?=
 =?utf-8?B?NVpydEN5a3VSQnJrU3VVWjVPelVnQ29TN2ZpS28yMVc5S08yVm8yUjdHYUNE?=
 =?utf-8?B?cTFCS0dOWnpxRHBkd1pmeno3S25QdGdBMnRPaDVtNFl4b3lYR3BwbEdZZFlC?=
 =?utf-8?B?ZFZnSXJoUUswR3JTektYalFMTUpQZE9qUHYxUjJULzRFTGowY2dVWUh4QVR1?=
 =?utf-8?B?WlozS2dZRW1OWGZmUTB3QWtHRTM1Zm9ZMERlU1NTajNTSXNhTkw2SHhFdE45?=
 =?utf-8?B?N05EOXc3Q0U0ZTA0MDBNWlczVlZKQS9GUzlLZk5mOEprMDNHUHl0S1VOYitx?=
 =?utf-8?B?RStYY3dCckVSZk9YK0pMVTgzVVMvMmExcTZ5d0ZjRHRKb0pFZDRhcUVoazBh?=
 =?utf-8?B?YjhQazlMUjIxZHRTQ2ExVThJYS94OUJ4bk1pSkczak9McXVhWVRNcG1yNEll?=
 =?utf-8?B?b3lMTnM2UjRxbUtBUnZ0S1BYK3pJT0ZEeFdNWmRwaUF3QUVHTkVPWFM0Z1pB?=
 =?utf-8?B?d3R1MEZYWkxBOFprWHh2cXBqWVFlUm83U3paSFFoNE1kbjU3Mk04bTZqcFF5?=
 =?utf-8?B?YVFoWHZxa3FBMXFjU1pvRDFoR2N3UlRGSVNjQS9kcmtXaU02UE92bWlyRlRp?=
 =?utf-8?B?MTBMVVRMUDFkU2toNlFWbWZEam9NZ2FrTlgrd0NiR0RrMzRXM3lpLzVveGZo?=
 =?utf-8?B?RWFvN1B4NHZTSHFrd3dySGZQc3YxWGozZENBdzB2Um5JS2YwVjd4aDREQUFU?=
 =?utf-8?B?Zk9Wa1UyZ0E1UW95OW9ySktRUTNqY0VRU0t5c2VmSVBjeFpVZVFHZGVRR3Vm?=
 =?utf-8?B?aDFlR3JCUG9hdXVWeEF1cjFSY2F6WFlWSmdpcGN6ZHVjT1ZuM0FPRDQzTWN0?=
 =?utf-8?B?RjNtNlFaQXIwSmFXd0VteEowS2dNVWxaYU5qSmVHZkNYRTNoRjlOWkkycm12?=
 =?utf-8?B?MExtS0JCV0pzWTRQWjFQNE5iTWpUOTlYRTQzOHJ1R0ZmT1RXQnVwQ0F4RmNs?=
 =?utf-8?B?OUppQ2FQa0NjUElMUzZLbldnNE1tOEpyYXA3VHhXZkJjZG5OMVczUSt3ZXVR?=
 =?utf-8?B?TUV4dzRpcUNkSlcyUlYvTW1UOVlDTFJWbmRETGFKM3RmVGEvRmsvb3l0ajB4?=
 =?utf-8?B?b2dlcXREcndMb1BzV3NCYnU1MktiWk1SRThlWGdWbEZ5bUJRblVnZVhya0Yr?=
 =?utf-8?B?bGFPd2VVQUUwOVlTZ1cyWWpBWHNZakxLbndxbkY3NGVDU0ZUN3JoMDR0RWdy?=
 =?utf-8?B?L0I4SUphSEIrOXRFME0rSlFxdjlXdmgrL1BHT3RGZHFnOVZBaUZIUDkyT1ZN?=
 =?utf-8?B?d2E0ZEExNU13czhCUFZkd3pjU3l6TFYxS1c5c3Yya0VEVmZmVHF2dU1hNjFh?=
 =?utf-8?Q?UK4a282xlMs3dUzzT3zCpXxUc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30F4A24E0D3D22488680527623E0E06D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f922cd97-4e4f-41ed-9d57-08db6af0063b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 02:52:13.1710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C3fRFHLrv/5AGo/1U585zaYkRdm/3Oq/2uZINsnHgFbGa1WRaLtQTW8Z1aMWWy+2Ozp1rzuckxFxw70NQ7S3Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5519
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

T24gVGh1LCAyMDIzLTA2LTA4IGF0IDE2OjQzIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi84LzIzIDE2OjI0LCBraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwuY29tIHdyb3RlOg0K
PiA+ID4gIAlyZXQgPSAtRUlOVkFMOw0KPiA+ID4gKwlpZiAocmV0KQ0KPiA+ID4gKwkJdGRtcnNf
ZnJlZV9wYW10X2FsbCgmdGR4X3RkbXJfbGlzdCk7DQo+ID4gPiArCWVsc2UNCj4gPiA+ICsJCXBy
X2luZm8oIiVsdSBLQnMgYWxsb2NhdGVkIGZvciBQQU1ULlxuIiwNCj4gPiA+ICsJCQkJdGRtcnNf
Y291bnRfcGFtdF9wYWdlcygmdGR4X3RkbXJfbGlzdCkgKiA0KTsNCj4gPiAiKiA0Ij8gVGhpcyBp
cyB2ZXJ5IGNyeXB0aWMuIHByb2NmcyB1c2VzICI8PCAoUEFHRV9TSElGVCAtIDEwKSIgd2hpY2gN
Cj4gPiBzbGlnaHRseSBsZXNzIG1hZ2ljIHRvIG1lLiBBbmQganVzdCBtYWtlIHRoZSBoZWxwZXIg
dGhhdCByZXR1cm5zIGtpbG9ieXRlcw0KPiA+IHRvIGJlZ2luIHdpdGgsIGlmIGl0IGlzIHRoZSBv
bmx5IGNhbGxlci4NCj4gDQo+IExldCdzIGxvb2sgYXQgd2hlcmUgdGhpcyBkYXRhIGNvbWVzIGZy
b206DQo+IA0KPiArc3RhdGljIHVuc2lnbmVkIGxvbmcgdGRtcnNfY291bnRfcGFtdF9wYWdlcyhz
dHJ1Y3QgdGRtcl9pbmZvX2xpc3QNCj4gKnRkbXJfbGlzdCkNCj4gK3sNCj4gKwl1bnNpZ25lZCBs
b25nIHBhbXRfbnBhZ2VzID0gMDsNCj4gKwlpbnQgaTsNCj4gKw0KPiArCWZvciAoaSA9IDA7IGkg
PCB0ZG1yX2xpc3QtPm5yX2NvbnN1bWVkX3RkbXJzOyBpKyspIHsNCj4gKwkJdW5zaWduZWQgbG9u
ZyBwZm4sIG5wYWdlczsNCj4gKw0KPiArCQl0ZG1yX2dldF9wYW10KHRkbXJfZW50cnkodGRtcl9s
aXN0LCBpKSwgJnBmbiwgJm5wYWdlcyk7DQo+ICsJCXBhbXRfbnBhZ2VzICs9IG5wYWdlczsNCj4g
Kwl9DQo+IA0KPiBPSywgc28gdGRtcl9nZXRfcGFtdCgpIGlzIGdldHRpbmcgaXQgaW4gcGFnZXMu
ICBIb3cgaXMgaXQgKnN0b3JlZCo/DQo+IA0KPiArc3RhdGljIHZvaWQgdGRtcl9nZXRfcGFtdChz
dHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLCB1bnNpZ25lZCBsb25nICpwYW10X3BmbiwNCj4gKwkJCSAg
dW5zaWduZWQgbG9uZyAqcGFtdF9ucGFnZXMpDQo+ICt7DQo+IC4uLg0KPiArCXBhbXRfc3ogPSB0
ZG1yLT5wYW10XzRrX3NpemUgKyB0ZG1yLT5wYW10XzJtX3NpemUgKyB0ZG1yLT5wYW10XzFnX3Np
emU7DQo+ICsrCSpwYW10X3BmbiA9IFBIWVNfUEZOKHBhbXRfYmFzZSk7DQo+ICsJKnBhbXRfbnBh
Z2VzID0gcGFtdF9zeiA+PiBQQUdFX1NISUZUOw0KPiArfQ0KPiANCj4gT2gsIGl0J3MgYWN0dWFs
bHkgc3RvcmVkIGluIGJ5dGVzLiAgU28gdG8gcHJpbnQgaXQgb3V0IHlvdSBhY3R1YWxseQ0KPiBj
b252ZXJ0IGl0IGZyb20gYnl0ZXMtPnBhZ2VzLT5rYnl0ZXMuICBOb3QgdGhlIGJlc3QuDQo+IA0K
PiBJZiB0ZG1yX2dldF9wYW10KCkganVzdCByZXR1cm5lZCAncGFtdF9zaXplX2J5dGVzJywgeW91
IGNvdWxkIGRvIG9uZQ0KPiBjb252ZXJzaW9uIGF0Og0KPiANCj4gCWZyZWVfY29udGlnX3Jhbmdl
KHBhbXRfcGZuLCBwYW10X3NpemVfYnl0ZXMgPj4gUEFHRV9TSVpFKTsNCg0KSSB0aG91Z2h0IG1h
a2luZyB0ZG1yX2dldF9wYW10KCkgcmV0dXJuIHBhbXRfcGZuIGFuZCBwYW10X25wYWdlcyB3b3Vs
ZCBiZSBtb3JlDQpjbGVhciB0aGF0IFBBTVRzIG11c3QgYmUgaW4gNEsgZ3JhbnVsYXJpdHksIGJ1
dCBJIGd1ZXNzIGl0IGRvZXNuJ3QgbWF0dGVyDQphbnl3YXkuDQoNCklmIHdlIHJldHVybiBieXRl
cyBmb3IgUEFNVCBzaXplLCBJIHRoaW5rIHdlIHNob3VsZCBhbHNvIHJldHVybiBwaHlzaWNhbCBh
ZGRyZXNzDQppbnN0ZWFkIG9mIFBGTiBmb3IgUEFNVCBzdGFydD8NCg0KSSdsbCBjaGFuZ2UgdGRt
cl9nZXRfcGFtdCgpIHRvIHJldHVybiBwaHlzaWNhbCBhZGRyZXNzIGFuZCBieXRlcyBmb3IgUEFN
VA0KbG9jYXRpb24gYW5kIHNpemUgcmVzcGVjdGl2ZWx5LiAgUGxlYXNlIGxldCBtZSBrbm93IGlm
IHlvdSBoYXZlIGFueSBjb21tZW50cy4gDQoNCj4gDQo+IGFuZCBzaW5jZSB0ZG1yc19jb3VudF9w
YW10X3BhZ2VzKCkgaGFzIG9ubHkgb25lIGNhbGxlciB5b3UgY2FuIGp1c3QgbWFrZQ0KPiBpdDog
IHRkbXJzX2NvdW50X3BhbXRfa2IoKS4gIFRoZSBwcmludCBiZWNvbWVzOg0KPiANCj4gCXByX2lu
Zm8oIiVsdSBLQnMgYWxsb2NhdGVkIGZvciBQQU1ULlxuIiwNCj4gCQl0ZG1yc19jb3VudF9wYW10
X2tiKCZ0ZHhfdGRtcl9saXN0KSAqIDQpOw0KPiANCj4gYW5kIHRkbXJzX2NvdW50X3BhbXRfa2Io
KSBkb2VzIHNvbWV0aGluZyBzdXBlciBmYW5jeSBsaWtlOg0KPiANCj4gCXJldHVybiBwYW10X3Np
emVfYnl0ZXMgLyAxMDI0Ow0KPiANCj4gd2hpY2ggbWFrZXMgdG90YWwgY29tcGxldGUgb2J2aW91
cyBzZW5zZSBhbmQgbmVlZHMgemVybyBleHBsYW5hdGlvbi4NCg0KV2lsbCBkby4NCg0KVGhhbmtz
IGZvciB0aGUgZmVlZGJhY2suDQoNCg==
