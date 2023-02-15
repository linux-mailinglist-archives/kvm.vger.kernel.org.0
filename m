Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6A469793F
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 10:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjBOJqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 04:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbjBOJqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 04:46:23 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB8536466;
        Wed, 15 Feb 2023 01:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676454375; x=1707990375;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=alT7iaZmR4qivN5HFxeqLJaFIsgvbl2uRKStE/zHlFs=;
  b=jLfVFp7llFH7g3VoLijk44+ID1ELGtKCFamsBlmeDEjjkSZqm5KmgV/f
   dZ16A4VEPuZxK/mfQV5qIAxNbzLaJSMr2A+Tv7o+Vj2BWdhuxM/BBoqAH
   p3aev1+pX0K8tArAU4/3tFhr5Ska3Ho9JquiHd1NI8Ebku3qREb9pMKnC
   ufx3A0kucIOmf3UphaWJOebmC+3U30cdn9TofsX4bmdTcFXI4qmrbmmLG
   R1ze4rcxkZRqx0C9eY+eiKUf8vig+K43hMh/wDORTAanIx3R/SpdARka6
   lZnRis+tpIxMkvPz+AbRQClVbwX8ZJ3uA2gfDHkNkPP1F7F0Pk4uXOTXH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="333526165"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="333526165"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 01:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="671568755"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="671568755"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 15 Feb 2023 01:46:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 01:46:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 01:46:13 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 01:46:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BC/tDQ+DcREojomsj5S0uSWMd3PTLR/AhXCVi6Slgb0lq0pxc9WphHOs5pSbWjbr8IW/BfNs0SUVtmxGyxirGyiNhJjuPP3Yc2P2XdX0iNqHrB8a7e+aE10IQonH6ThcWL/SluSv2JR8Dyk2+zqiaL7B3sBotZZTIKSupuKV8v6w/ddMYZoAFdCZgEdwpFl0k9dw2Kg2EnYu8dS5V3SUpT5PDW9oqSEzXwgQ7Tc8t0zEIHVH3z//ONpt6CR0AAcg+WJU3s8cQet3nawJANqZVSRl/W9vJZfSlDgEOYZ9ilotxci+ZqmcjgKivM9d3R4QyHOXDI7ImBEnC7TkfQCWzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alT7iaZmR4qivN5HFxeqLJaFIsgvbl2uRKStE/zHlFs=;
 b=ECV7vxugmlBiP7/Occ44ZIvPfk8Z0jEJ2Cn3TD5yvyzx+8hk/iuyKJzs8w2/sZDrIX9OdN+x2Fj9EKxjbfFDPi5TLoPlXSQHd9PvATZ/D6hLuk+0mPmyF9M31IWvBCuUi8RTCnsYSV8VbS/rXYgeNXkI8CC0BaNqP8hF4rX9s3JkuwTasQweHa4+xevrFCzbup6QOkJWDFYIO6JfvdLNCqvwoGXoarOu7VjmcUDcANk+0BCJjts+Yy5Hcr573EywuPpQriduA00iBa58pfL0FIMDRZ9Y5Ox4eY94to9gHMGg5yrY17X0HA8N5DoezIg2G/uel7AyITWFcjsrvy1Mmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB7046.namprd11.prod.outlook.com (2603:10b6:510:216::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 09:46:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 09:46:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NKpCAgAA2qfCAABiqAIAAFhiAgADtdoCAAJGdgIAArgoAgAAIV4A=
Date:   Wed, 15 Feb 2023 09:46:10 +0000
Message-ID: <24bd9d546d07b57387ecd990746061ae35ce5fa5.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
         <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
         <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
         <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
         <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
         <Y+uWu9hLMZ35JHlY@hirez.programming.kicks-ass.net>
         <0795f69fd0ff8ccdd40cc7a3d6cc32da47e6d929.camel@intel.com>
         <Y+yi4B+P9K2FXNqt@hirez.programming.kicks-ass.net>
In-Reply-To: <Y+yi4B+P9K2FXNqt@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB7046:EE_
x-ms-office365-filtering-correlation-id: b71f1284-957b-492a-8dde-08db0f397814
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GkV58hTkmogpKsAEUFEcHxWjWx5EZFBLdjYifXgSZfo/XJU9lYbzUUyG0al46Cb5+VKoTb05hZEZwNPbOHswcA7ql3gGQ4nr5d65VTWB6rFIJ7j2c3sf5nRz9GAEYMtGnJJGut4hrTeEijuuqU3LqPy+EL66/Rw1CKdht4jQ4aBYImCi4MfRYriQt9HXsNwbZEuj9B9iRSXsDxdrU6BGv934ShD7tjgWY2T8+DSqZjpkCQuPy2lMV5dazit61JtR+9AzzgZ1bspLMDvqoxA49VcF8x8dYHMnSXT19ym1sQQEz1c17VVXbuyPqdJSFfbCbKeGOVnMA41hKVaXbaeaDkaHg+svuLgg3K5x7V7+C+uUp5cY4UMTjU9yttC9DP2lVQvu0V2WL5cG7T6z6wYk8tzBSaPiNvqGkvHRFGGtj069jkDAo7424tooqNfzJy9mKDCfh/w5eMHV914nwvVDt236uVOWAk0lZ6hIIavOpln+0QFkn2RFmNuc+Rbxpqobm40rM+CtYb9hBFx14XV5xkP1QX/NbVHk2WEu0+EKRrM/jDVDU/9Pv7wjQFxQt466+4i/u94tQQT3teohrtffInvIpHoTgY+VSrYK06Cslgzul7g2lX8BcPX45lFySqCUbBh/js1MQzG3W6zCvUZQW5pZeII5I0DiGoN9fB/OKRDFq96IazaJGUblnsVLejsmCHhOxQBZQTW9AIZ9CCTnWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(6506007)(186003)(26005)(82960400001)(6512007)(86362001)(38100700002)(122000001)(2616005)(478600001)(6486002)(38070700005)(2906002)(71200400001)(7416002)(5660300002)(41300700001)(8936002)(8676002)(66946007)(64756008)(36756003)(6916009)(4326008)(76116006)(66556008)(66476007)(66446008)(91956017)(54906003)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWptQll6YUxrOGNkVkJ3UWkvNjZWSFRoSlVyQmIwZlppcXdOSjNLN0U4Yzkr?=
 =?utf-8?B?ZEZ0VG5McERXaC84N3FFd3F5K2ZHdTBRYVlEUUFZSlBJVjZCRlJuTTR0SmlB?=
 =?utf-8?B?ZktCUWJQbEtmVkZ1aVBhWGZIajYva2p2YlNURitkd0ZUU1lTKzQ3VWxvZTd0?=
 =?utf-8?B?U29pQUZnMk1OVlcrZ243YkFlWXZ4WXJGWjZxczlaUS9sUW5EcE1uelJsRU9y?=
 =?utf-8?B?ZW1DdElTbThDbTl6b1h0dEp4MHVBaXliSHI4Nk9xNXpOUVBHZzhGNFpzZXh0?=
 =?utf-8?B?bVoyT1VhMlJkcVBVOVI1bGl1SjU5czlTUGQvalBBak9VYlAwYnBObmd4U2kr?=
 =?utf-8?B?emNhejU1ZVZ2ZDNkaTV4SWs3Z2o0YWsvUXYwdFBTQ2UvZ1Nma3NRYTU3MDVM?=
 =?utf-8?B?K3F1TGFUTmlnc0xNVGRnWldhNG1SNnA5RHFpUnNyd3dqRUxTd2Rxa09BbzFv?=
 =?utf-8?B?NkNYWHVBQm5IRzRaajdlbnh5NkxmcUZZVFppcVJvYlByUXhCL2g5R3FKdU5t?=
 =?utf-8?B?OHRzU3BkekZ4K00yM2t2Y3EvUTZCTmswNEVIMGR5RnRuZy9UQ1VqRTJDTi9u?=
 =?utf-8?B?WVIzdzJWcm5JRmliNGNCSFhzTlF6SnBreFhlKzBka1BuRnVkVi8zZzFXZTVz?=
 =?utf-8?B?L1Y2Zlp6K1ZnNjM4U2lwa2hmbmd4RXFIYkFSWXRZZ2pTcUtDWVV1cXFhUDRm?=
 =?utf-8?B?T3ZOOUJabnlNMjRaNjNvQnBGRlBWVEZQQm80NjZIUmZqWmV2T2x3VCszMHZ0?=
 =?utf-8?B?SGdodjRQQmx5RHg3cy9Na0YrT0pSa3Vic2ZQaG9MTzdic3dpNjY5dWNNV0Fm?=
 =?utf-8?B?U0hrWkhUd3VxU0FDaGIyZVRRVmt3cFZmOGNubGhHdHFwNExzellkaWRKY29n?=
 =?utf-8?B?YllLMnRSZWM0RC9vTHBCNWVzYzA1TXNjbzN3bW9GSHBqa2NsbG04Nkx1OGJE?=
 =?utf-8?B?b09RdC84ZUdaYWxuY3lwTzhlZnJzS1hYak5TcGtReHltdXIvQzQzMnNHUXFX?=
 =?utf-8?B?ekNSRzVtV0dOOHZScWpkN0c0ZmROTmFjS2JHZjdrd05wU1RQZFo0eEViUW5P?=
 =?utf-8?B?bGt6dm13QmV0VTM0Q1QwaGRacExDTk5VWVFmb01HTGZRNW1nbTMvQm5OQjJR?=
 =?utf-8?B?NGh5SC9XOFJ5ZCtHWkxRV0dnY3VZOHJIK2dycVJDU2xUd25Vd2ZJRUFYanlT?=
 =?utf-8?B?U0RtZHVVYmV4NmJOS0pjYkp0UGpFK1o4VkVETHZkS081bjloZCtOU1BGMm9K?=
 =?utf-8?B?K3FpbHg0Z2diZ1JkQXo4VFJtY2NJd2EvWkZPY1VIeU0vbDdydXpTcXFOV0t1?=
 =?utf-8?B?RStLQmxncExIVGJTWDJTQ1VUb2dzUHZpeW9UZitra3ZZM3p1ZmtTZ3NBVGxn?=
 =?utf-8?B?K3BpVng3QkxzUlpJdmh1THFsbkZ4bTRjeVB6alRTWTZHMmxPcVF5MHR5ZUFt?=
 =?utf-8?B?UlF3SXFic01QUGZoVHpEQkZENDIzVFd1L2o5SkhMZ1lBTnRKcitFcTNhT3Qw?=
 =?utf-8?B?UXJKVjY4SUFUcHVOd3NXSktwNHdoaE1nc2F1amhZUW4waEVxNkY2OFpQWVBF?=
 =?utf-8?B?SXRWQkhSNEVON3BjUW93MmtxNXNVMUNvYWNJVXJScGRqaU1uZi8vMy9qZkFj?=
 =?utf-8?B?eHR6d09oczNteEJWamVGSTdTYkN0QU1VMkV0dXNqQlY0dUxIRStGbkpsRGlH?=
 =?utf-8?B?OW9IOFBMUmdDL2MrU3o4SUJlQjZvSHYwUFNmNWMvUWxWWWUyckNBdjVMcDh3?=
 =?utf-8?B?QlNFWDBvUU1GTUtWRlN6ZTFtUFNWYTh1SGFqTE13bWp6YWF0ZnlkNlZwYUlT?=
 =?utf-8?B?bk9TU3JoUm9Zb3ltMkoyeE5oVnpJMHNENU02M01YZHpuOUNITFJ5cnp6aks5?=
 =?utf-8?B?aW90TDdrVEw5d2E3VlFhMDN1Yll0MGtrTUNyRThmUlE0TVBXelZqVXFlTkx5?=
 =?utf-8?B?eHEwd29QT0YyVkFiUUZXMkllR3QyUkd6Sm1nRXlScjRTaFE5djhTZkZtbTdr?=
 =?utf-8?B?VlJoSTl4SUR1cmNmN1pjdVhPd3NvOGVMaXR2TGlCQUtud3NETk9Jb2h2cXJI?=
 =?utf-8?B?Wm9rcDJ0N2p4SlJXQk5Ed2VJVzdzVjNOWWg2bGxFQXBrVmlrcUdDZUpYUmtn?=
 =?utf-8?B?YXF0djdBZzNnamN0L1pXRHUzOTlRK0xCQ0U4VjRxL3hzcVRqVlNQM3NJWWlD?=
 =?utf-8?B?N0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E375BDFAB808A8478C42AFD25D970BD4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71f1284-957b-492a-8dde-08db0f397814
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 09:46:10.4910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VYlVCSsVwjJrKohSFm1SVbPWEnlYhnRuHsyQ/z9+UaGvf+yiJn7/FsMe7FrSuA9cixUmGav8sQ5XfrAcdrsNOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7046
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gKw0KPiA+ICsgICAgICAgZm9yX2VhY2hfb25saW5lX2NwdShjcHUpDQo+IA0KPiBJIHRo
aW5rIHlvdSBuZWVkIHRvIHNraXAgc29tZSBmbHVzaGVzIHRvby4gR2l2ZW4gd2Ugc2tpcCBzZXR0
aW5nDQo+IHdvcmstPmZ1bmMsIHRoaXMgd2lsbCBnbyBXQVJOLCBzZWUgX19mbHVzaF93b3JrKCku
DQoNCkkgbWlzc2VkLiAgVGhhbmtzIGZvciBwb2ludGluZyBvdXQuDQoNCj4gDQo+ID4gKyAgICAg
ICAgICAgICAgIGZsdXNoX3dvcmsocGVyX2NwdV9wdHIod29ya3MsIGNwdSkpOw0KPiA+ICsNCj4g
DQoNClsuLi5dDQoNCj4gVGhhdCBzYWlkLCBJIGZpbmQgaXQgamFycmluZyB0aGF0IHRoZSBzY2hl
ZHVsZV9vbiooKSBmYW1pbHkgZG9lc24ndCBoYXZlDQo+IGEgdm9pZCogYXJndW1lbnQgdG8gdGhl
IGZ1bmN0aW9uLCBsaWtlIHRoZSBzbXBfKigpIGZhbWlseSBoYXMuIFNvIGhvdw0KPiBhYm91dCBz
b21ldGhpbmcgbGlrZSB0aGUgYmVsb3cgKGVxdWFsbHkgdW50ZXN0ZWQpLiBJdCBwcmVzZXJ2ZXMg
dGhlDQo+IGN1cnJlbnQgc2VtYW50aWNzLCBidXQgYWxsb3dzIGEgd29yayBmdW5jdGlvbiB0byBj
YXN0IHRvIHNjaGVkdWxlX3dvcmsNCj4gYW5kIGFjY2VzcyAtPmluZm8gaWYgaXQgc28gZGVzaXJl
cy4NCg0KWWVzIGFncmVlZC4gIFlvdXIgY29kZSBiZWxvdyBsb29rcyBpbmRlZWQgYmV0dGVyLiAg
VGhhbmtzIQ0KDQpXb3VsZCB5b3UgbWluZCBzZW5kIG1lIGEgcGF0Y2ggc28gSSBjYW4gaW5jbHVk
ZSB0byB0aGlzIHNlcmllcywgb3Igd291bGQgeW91DQptaW5kIGdldCBpdCBtZXJnZWQgdG8gdGlw
L3g4Ni90ZHggKG9yIG90aGVyIGJyYW5jaCBJIGFtIG5vdCBzdXJlKSBzbyBJIGNhbg0KcmViYXNl
Pw0KDQpBcHByZWNpYXRlIHlvdXIgaGVscCENCg0KPiANCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L3dvcmtxdWV1ZS5oIGIvaW5jbHVkZS9saW51eC93b3JrcXVldWUuaA0KPiBpbmRl
eCBhMDE0M2RkMjQ0MzAuLjVlOTcxMTEzMjJiMiAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51
eC93b3JrcXVldWUuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L3dvcmtxdWV1ZS5oDQo+IEBAIC0x
MDMsNiArMTAzLDExIEBAIHN0cnVjdCB3b3JrX3N0cnVjdCB7DQo+ICAjZW5kaWYNCj4gIH07DQo+
ICANCj4gK3N0cnVjdCBzY2hlZHVsZV93b3JrIHsNCj4gKwlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgd29y
azsNCj4gKwl2b2lkICppbmZvOw0KPiArfTsNCj4gKw0KPiAgI2RlZmluZSBXT1JLX0RBVEFfSU5J
VCgpCUFUT01JQ19MT05HX0lOSVQoKHVuc2lnbmVkIGxvbmcpV09SS19TVFJVQ1RfTk9fUE9PTCkN
Cj4gICNkZWZpbmUgV09SS19EQVRBX1NUQVRJQ19JTklUKCkJXA0KPiAgCUFUT01JQ19MT05HX0lO
SVQoKHVuc2lnbmVkIGxvbmcpKFdPUktfU1RSVUNUX05PX1BPT0wgfCBXT1JLX1NUUlVDVF9TVEFU
SUMpKQ0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL3dvcmtxdWV1ZS5jIGIva2VybmVsL3dvcmtxdWV1
ZS5jDQo+IGluZGV4IDA3ODk1ZGVjYTI3MS4uYzczYmI4ODYwYmJjIDEwMDY0NA0KPiAtLS0gYS9r
ZXJuZWwvd29ya3F1ZXVlLmMNCj4gKysrIGIva2VybmVsL3dvcmtxdWV1ZS5jDQo+IEBAIC01MSw2
ICs1MSw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvc2NoZWQvaXNvbGF0aW9uLmg+DQo+ICAjaW5j
bHVkZSA8bGludXgvbm1pLmg+DQo+ICAjaW5jbHVkZSA8bGludXgva3ZtX3BhcmEuaD4NCj4gKyNp
bmNsdWRlIDxsaW51eC9zbXAuaD4NCj4gIA0KPiAgI2luY2x1ZGUgIndvcmtxdWV1ZV9pbnRlcm5h
bC5oIg0KPiAgDQo+IEBAIC0zMzAyLDQzICszMzAzLDY0IEBAIGJvb2wgY2FuY2VsX2RlbGF5ZWRf
d29ya19zeW5jKHN0cnVjdCBkZWxheWVkX3dvcmsgKmR3b3JrKQ0KPiAgfQ0KPiAgRVhQT1JUX1NZ
TUJPTChjYW5jZWxfZGVsYXllZF93b3JrX3N5bmMpOw0KPiAgDQo+IC0vKioNCj4gLSAqIHNjaGVk
dWxlX29uX2VhY2hfY3B1IC0gZXhlY3V0ZSBhIGZ1bmN0aW9uIHN5bmNocm9ub3VzbHkgb24gZWFj
aCBvbmxpbmUgQ1BVDQo+IC0gKiBAZnVuYzogdGhlIGZ1bmN0aW9uIHRvIGNhbGwNCj4gLSAqDQo+
IC0gKiBzY2hlZHVsZV9vbl9lYWNoX2NwdSgpIGV4ZWN1dGVzIEBmdW5jIG9uIGVhY2ggb25saW5l
IENQVSB1c2luZyB0aGUNCj4gLSAqIHN5c3RlbSB3b3JrcXVldWUgYW5kIGJsb2NrcyB1bnRpbCBh
bGwgQ1BVcyBoYXZlIGNvbXBsZXRlZC4NCj4gLSAqIHNjaGVkdWxlX29uX2VhY2hfY3B1KCkgaXMg
dmVyeSBzbG93Lg0KPiAtICoNCj4gLSAqIFJldHVybjoNCj4gLSAqIDAgb24gc3VjY2VzcywgLWVy
cm5vIG9uIGZhaWx1cmUuDQo+IC0gKi8NCj4gLWludCBzY2hlZHVsZV9vbl9lYWNoX2NwdSh3b3Jr
X2Z1bmNfdCBmdW5jKQ0KPiAraW50IHNjaGVkdWxlX29uX2VhY2hfY3B1X2NvbmRfbG9ja2VkKHdv
cmtfZnVuY190IGZ1bmMsIHNtcF9jb25kX2Z1bmNfdCBjb25kX2Z1bmMsIHZvaWQgKmluZm8pDQo+
ICB7DQo+ICsJc3RydWN0IHNjaGVkdWxlX3dvcmsgX19wZXJjcHUgKndvcmtzOw0KPiAgCWludCBj
cHU7DQo+IC0Jc3RydWN0IHdvcmtfc3RydWN0IF9fcGVyY3B1ICp3b3JrczsNCj4gIA0KPiAtCXdv
cmtzID0gYWxsb2NfcGVyY3B1KHN0cnVjdCB3b3JrX3N0cnVjdCk7DQo+ICsJd29ya3MgPSBhbGxv
Y19wZXJjcHUoc3RydWN0IHNjaGVkdWxlX3dvcmspOw0KPiAgCWlmICghd29ya3MpDQo+ICAJCXJl
dHVybiAtRU5PTUVNOw0KPiAgDQo+IC0JY3B1c19yZWFkX2xvY2soKTsNCj4gLQ0KPiAgCWZvcl9l
YWNoX29ubGluZV9jcHUoY3B1KSB7DQo+IC0JCXN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayA9IHBl
cl9jcHVfcHRyKHdvcmtzLCBjcHUpOw0KPiArCQlzdHJ1Y3Qgc2NoZWR1bGVfd29yayAqd29yayA9
IHBlcl9jcHVfcHRyKHdvcmtzLCBjcHUpOw0KPiAgDQo+IC0JCUlOSVRfV09SSyh3b3JrLCBmdW5j
KTsNCj4gLQkJc2NoZWR1bGVfd29ya19vbihjcHUsIHdvcmspOw0KPiArCQlpZiAoY29uZF9mdW5j
ICYmICFjb25kX2Z1bmMoY3B1LCBpbmZvKSkNCj4gKwkJCWNvbnRpbnVlOw0KPiArDQo+ICsJCUlO
SVRfV09SSygmd29yay0+d29yaywgZnVuYyk7DQo+ICsJCXdvcmstPmluZm8gPSBpbmZvOw0KPiAr
CQlzY2hlZHVsZV93b3JrX29uKGNwdSwgJndvcmstPndvcmspOw0KPiAgCX0NCj4gIA0KPiAtCWZv
cl9lYWNoX29ubGluZV9jcHUoY3B1KQ0KPiAtCQlmbHVzaF93b3JrKHBlcl9jcHVfcHRyKHdvcmtz
LCBjcHUpKTsNCj4gKwlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkgew0KPiArCQlzdHJ1Y3Qgc2No
ZWR1bGVfd29yayAqd29yayA9IHBlcl9jcHVfcHRyKHdvcmtzLCBjcHUpOw0KPiArDQo+ICsJCWlm
ICh3b3JrLT53b3JrLmZ1bmMpDQo+ICsJCQlmbHVzaF93b3JrKCZ3b3JrLT53b3JrKTsNCj4gKwl9
DQo+ICANCj4gLQljcHVzX3JlYWRfdW5sb2NrKCk7DQo+ICAJZnJlZV9wZXJjcHUod29ya3MpOw0K
PiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICtpbnQgc2NoZWR1bGVfb25fZWFjaF9jcHVfY29u
ZCh3b3JrX2Z1bmNfdCBmdW5jLCBzbXBfY29uZF9mdW5jX3QgY29uZF9mdW5jLCB2b2lkICppbmZv
KQ0KPiArew0KPiArCWludCByZXQ7DQo+ICsNCj4gKwljcHVzX3JlYWRfbG9jaygpOw0KPiArCXJl
dCA9IHNjaGVkdWxlX29uX2VhY2hfY3B1X2NvbmRfbG9ja2VkKGZ1bmMsIGNvbmQsIGluZm8pOw0K
PiArCWNwdXNfcmVhZF91bmxvY2soKTsNCj4gKw0KPiArCXJldHVybiByZXQ7DQo+ICt9DQo+ICsN
Cj4gKy8qKg0KPiArICogc2NoZWR1bGVfb25fZWFjaF9jcHUgLSBleGVjdXRlIGEgZnVuY3Rpb24g
c3luY2hyb25vdXNseSBvbiBlYWNoIG9ubGluZSBDUFUNCj4gKyAqIEBmdW5jOiB0aGUgZnVuY3Rp
b24gdG8gY2FsbA0KPiArICoNCj4gKyAqIHNjaGVkdWxlX29uX2VhY2hfY3B1KCkgZXhlY3V0ZXMg
QGZ1bmMgb24gZWFjaCBvbmxpbmUgQ1BVIHVzaW5nIHRoZQ0KPiArICogc3lzdGVtIHdvcmtxdWV1
ZSBhbmQgYmxvY2tzIHVudGlsIGFsbCBDUFVzIGhhdmUgY29tcGxldGVkLg0KPiArICogc2NoZWR1
bGVfb25fZWFjaF9jcHUoKSBpcyB2ZXJ5IHNsb3cuDQo+ICsgKg0KPiArICogUmV0dXJuOg0KPiAr
ICogMCBvbiBzdWNjZXNzLCAtZXJybm8gb24gZmFpbHVyZS4NCj4gKyAqLw0KPiAraW50IHNjaGVk
dWxlX29uX2VhY2hfY3B1KHdvcmtfZnVuY190IGZ1bmMpDQo+ICt7DQo+ICsJcmV0dXJuIHNjaGVk
dWxlX29uX2VhY2hfY3B1X2NvbmQoZnVuYywgTlVMTCwgTlVMTCk7DQo+ICt9DQo+ICsNCj4gIC8q
Kg0KPiAgICogZXhlY3V0ZV9pbl9wcm9jZXNzX2NvbnRleHQgLSByZWxpYWJseSBleGVjdXRlIHRo
ZSByb3V0aW5lIHdpdGggdXNlciBjb250ZXh0DQo+ICAgKiBAZm46CQl0aGUgZnVuY3Rpb24gdG8g
ZXhlY3V0ZQ0KDQo=
