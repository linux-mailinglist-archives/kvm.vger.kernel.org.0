Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7717A2AE0
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 01:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbjIOXL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 19:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbjIOXK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 19:10:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F64A186;
        Fri, 15 Sep 2023 16:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694819451; x=1726355451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eI2qERF9VjreKd+9JuEhV+yRtUn1voKxcjwiNDy8H6U=;
  b=frZ/hgR57Cqi3ABI0avlWPD6kFyy3RnxsPHS0rViHXBTiKcqzVjiZYpw
   cNLE4ZAe4df3TYUIRXmO138NPL+5sYhopZ8Ymbl8iX1urNNVJSYo2GmbA
   nwmMu9v/nlot9rwSGqB85cRmz8r748IXhBuIazkin5X2GuJasQAdf+G1S
   Gb/rPFGFxRhRhJRXN4PSQkUI6J26xtoqNvXh8weQqndRMe5B8lhA7F+Eq
   4nMjXzxDmrtwVrSTk8mxZ9y57IoIj97vH3/MXZmJnca6acwi0b5uGHAlF
   Y2h+SmAmCeL/YIrn1CdHNQ9cPuGylbYF9xuv9/uPSWM/BHWqUn7IG33AP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="445831459"
X-IronPort-AV: E=Sophos;i="6.02,150,1688454000"; 
   d="scan'208";a="445831459"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 16:10:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="694881772"
X-IronPort-AV: E=Sophos;i="6.02,150,1688454000"; 
   d="scan'208";a="694881772"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Sep 2023 16:10:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 16:10:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 15 Sep 2023 16:10:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 15 Sep 2023 16:10:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMCmY1yKoequkQxfCXndfQS4Nw6eE8s86ByXTVO/vwEfJogB1WbA/tC1Z7nzaYV7Yd0A5HAlLFxouT4x/cgUT+dipHrnQ56oeVhEnbAc0r98gYTVdK43VEozikbXeHc1+E8VfqoLwtFVr/Zd+8C5y17ilKK3942Qgyhppwzo8P7QKwpi5mF+VzlTBqLJYRnlU8RwBpMOD6SWk14ogIVIZ6LqVSFUgW2hZDHp/zE9KGcQXJS8IsHwaGE0rk/CrxWNK2+1Nk8veVue6Rejis5vTbEipMqXyPrTMbyNZyGC3Xy5+T1/UHqMNGwgiClvBTp7Lpj8vuE7u5opIJsuOsBPdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eI2qERF9VjreKd+9JuEhV+yRtUn1voKxcjwiNDy8H6U=;
 b=FI/v9j8qIusWLtiZlVLahiHw/if8yCLHJJ9ViE9Iq4pXzOKrKGYuwAbWArLHLzt1e4LG1RY0iPjG3s+y3lJlgV13HYxr1AdTy9iwoRmGi/TwD7C1O4rk87fnWClV4V/1Nmwy/wCiufKVWTXvmucQBWPan4b3J+JMZHYWFts7t+vROk1NRkmXLfQbVazPcuV6OR7ITjzlD0bHe9DiobYMIELD0jeKKknyIvvlnAg1aYumhdSEEXuf0aCI+8Qm5h65AVuokjYmU4xRQ6vC7haUwLu9xWy62KLoK2SsO4K5E1wqrq/OoeOumhOyXbBVM7ecdTSGYCHPkrdorIZb59lS/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Fri, 15 Sep
 2023 23:10:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 23:10:47 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Thread-Topic: [PATCH v13 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Thread-Index: AQHZ6Cnc8f7tdP2uq0mIGYpLUGkF/g==
Date:   Fri, 15 Sep 2023 23:10:47 +0000
Message-ID: <1f780a1ba109378aa3ca41f2e609b88439df9bca.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <ee8019b33d57f2a4398a55cc5ebfdf21d918f811.1692962263.git.kai.huang@intel.com>
In-Reply-To: <ee8019b33d57f2a4398a55cc5ebfdf21d918f811.1692962263.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6763:EE_
x-ms-office365-filtering-correlation-id: d656baaa-fd8e-4511-12b0-08dbb640feed
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QjXNHMPdbsh1lzMeTg+/eBA5fTGK250HB8r0Uk2SjQLloc+weVzregKMpOMZgmVnfmiGWGO/yf0deR1QAx8QA5QQ4fs9EbhIsADq9OC+qi39MS+lJcfYq9KrDlYbYi3b/wZN60h57wc4YPnmQlOUXAPCbbgT6fDjkUMWly8dHYMw67oH1O9P2NTBhhjqHCXVknZqRaBKCW2DTh2MrlbLw6qVfpMHUxSfTFCnmyomZBJglVsYr3kL4C5EkoEVn2IcOrhKdAZdMyDBAcUcsGvH2gkS7WoCJqixNkjGuyMhBc/Xd/LFxmhOxcASB0WPCGXa4Q+NNU5Yhorp6ZPsDA9ty2pmGq7do1a6k49Wkcand66zV+9NChxlaNuC1wWdOJKWpHPJ2UB29ieSebOhdAQVFg3PIMcBixAKSdlp7hk0ma/smion4IisYBfSJtsqQ9CMo0q0WnyVpacniLPmr1qhxCWFKnd7Kd+HpYYF+k/kLCYqgZhm7iLHsqLPP8997lD0npUsY4TLL9PYovoTKltay7DB64yCGv988xum90LQCfqiN2uQwokGdYtCIujxlj68B/4Iaw/lobKBh+yxHB5DAqCe6/dpvc3eoMiUt7N567F9V06XgsCyxfxvw9GCP+2k
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199024)(1800799009)(186009)(66946007)(110136005)(66476007)(54906003)(316002)(66446008)(82960400001)(2906002)(66556008)(5660300002)(76116006)(4744005)(41300700001)(7416002)(36756003)(64756008)(8676002)(6636002)(38100700002)(86362001)(4326008)(122000001)(91956017)(8936002)(38070700005)(6512007)(71200400001)(6506007)(6486002)(2616005)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWFBeGlvYUJJaEZ0Sjl4NzhCMGZuanh2VHRQa05Eb0pkNTU0ZDNwRUIrMHJo?=
 =?utf-8?B?WlJWREMrN0FPWHJVRFowNHNJamNZbyttcWJWVHJvcmJieU9tMTU5NS91Vk9C?=
 =?utf-8?B?YTFzaDl5ZGxOb3VTRS9BSTY2N1JYWWFUNUlBdnV4U0pYTEtXd0RvSnNaT2pC?=
 =?utf-8?B?SFJuUzNHb3BsK3FWYnNKTVVTdExHeCtwZlNBMlRiaWk0eHJpUkM5V0NKQ2sr?=
 =?utf-8?B?K0RYZkxFS3VjWC9yZVV1TzNreTF3aDVMWTd3Y2N3NHFiLzB1K1lWcUgyU2JP?=
 =?utf-8?B?WEJBbVBXZCsyTm5PTm9ua3dhaU1iSWNJcHM1NER5RWZkV2Z3aWRyOHU2azNK?=
 =?utf-8?B?cXRlQzJwTlVRUGxiQnd1VHAyZDc2OU02cHRCWGh5ekZWUytxa2x1NURsaVht?=
 =?utf-8?B?SzZqYVU3QVpHNFNhYmJXWStkL1JaaW5SR1N3aGtrNlhrYnZXeG1nQlJ0eU4y?=
 =?utf-8?B?K0pDdGthT3Azb0J1NllKdW55b2xCL3pBTVJKUTVhN3I4SzhheDdZQWthZnlo?=
 =?utf-8?B?UzVTRURkd3EwdWMwQWJhRmQ5TngyZFo5WlVENndTODJHc0I4dFpFTURaRkNU?=
 =?utf-8?B?TWZpQ2dyL3pVOFVYZUNEUTl5UGZCTU5PekRPQkRCczE1RGZRZjBFNTVBa3ky?=
 =?utf-8?B?cXh2b0hKZjJXR3JISlVTMFluN1FveWpoeEltQk9VUW1MWXlvOUk4YTh0Wmtu?=
 =?utf-8?B?a1ZtTzhRYVV6SmlqZ2pPU09mZzM1Z1RRZUU3aXgwYTI0NFQwLzdWd2hURlhL?=
 =?utf-8?B?STI0dEVBVjB6c3htKzQ0dXB4bDRyZVcxTkN5c055emVLWENKbGF1bHZseWRh?=
 =?utf-8?B?eUdSaWEvZEp4T0QxQUYvRWxOdmdVcDZqbmpYRm5xamxQUFRuUjh1aWo0TklJ?=
 =?utf-8?B?K295TUJuNnVzMVdpSVpIM1hiS2cwa2JQTmZ0ZHlaN3E2TkJqK0RHb2NRUFpE?=
 =?utf-8?B?Vmd5RnV2VnF6VXJzUVhVeFJHRm1xZlpGT2JWSW43Sm5kYW5STTVId29LZDVU?=
 =?utf-8?B?VlZFdG5ubWdDQlhhVS91bGlEWWl0WmV4eXRUUVRLMnZRb2o3QjBSTmFNV1BW?=
 =?utf-8?B?OWl2Q1pqNHVmd3dCbERSVUJFb0xzMmNBalkraFlROXduN0hweUJvRnVOS2RH?=
 =?utf-8?B?V0MyeTdjSXJiOU90ZlVhaVhPYXBNck5sbE5ZNFVIS3hBYitiaCt6cXJFNVUy?=
 =?utf-8?B?bEtqOVJmVkZveE1JdzhmYlRPTTJGZE9tYUQyYU9YaTNjU3J3UnRsT2w1NGNS?=
 =?utf-8?B?TklNck1vdHdmUTMvY09LM1dLcmdwUllaMmNRb25NK21Xd3A1aFdtQVJxSGJ5?=
 =?utf-8?B?Zjd5VVlMa3J1OUVPSVVQc0swN01vM3QvR3FLZzlHUmt0c2gwdEcxZi94azJL?=
 =?utf-8?B?SWZOQm9ad1FZMTcwc0Z4eXVqNFZsVWh1OEJ0T2dwRkRTUTV1ek5NR3RtaTlU?=
 =?utf-8?B?WkttYlhDQUFPR3BSQ09rOUtWTXlXVUs4b2psZHlHeEovK0cyZmtMS3A4WGhN?=
 =?utf-8?B?V1ltaVFUaDIyOExzUHhRaW5iaWwxTHlja3BmWURJdWNMV3VKUGRKOVZ6Sk5i?=
 =?utf-8?B?amxod1k5U1h2UkJCVjBQdTRMWW81QXRROVNiVXlRUTdVdGZBQ2VvNDAzQjM2?=
 =?utf-8?B?dndyU2ROc2pRYU9jVWhybnlmdVR2UmlqUmloK1dIUTFlNkhjdkU2bG53Njk2?=
 =?utf-8?B?ODFvS0dOT2Z0eTQwL1BzZTNtczVFczBpRWlPWll2MVltWkF0cjN4WUw2dnE1?=
 =?utf-8?B?RitWSm03aThkak83MWJ0MzBPTGNBdHNlVDV3N3hzdE55aDl5ekx4QkdVYTR4?=
 =?utf-8?B?eFR0R2FjM0dzaTlJU1UrdWNDb0oyaGorZmlaWXoxaWNpcmxhenJYZG8weS9j?=
 =?utf-8?B?VWl0OFI1QWRjZTdFRlEzYW5WS0VIdHhtdEF3dE1oMThuamRVQUJTbHBEamtV?=
 =?utf-8?B?RDdoMlVVK1hOWndicHJMT0N2dUdnMkVsV1lXbFFyNHBTR0YrZnhMSmprdjhy?=
 =?utf-8?B?RUxabnRSSWJnMWVPT1M2cW5Qd1BGT3JLSnEzR3RlNkRTbG5uWkFxamNrVUdm?=
 =?utf-8?B?SEVZWU00Z2ZNeVp4ZlRDSXpoZ1lNWElPbVBkNWpKYzlWL1c4TEQ5dlpOREt0?=
 =?utf-8?B?OFg3WnhucTF1Mk11OWdJQkpVZ2JQc0w4L0Rqa3dpVDBVd1JNYlRnQzYrb0U3?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <947F3B1CED2D9241904CAB851F898278@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d656baaa-fd8e-4511-12b0-08dbb640feed
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 23:10:47.4023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WW2USnC9O/2vj+kiiBLI7IdYZ+buj/H5zKDIFMgZuPEFnhxFqwko8vtIKkHomzzdNL2UuAYlyF9yjcmcaJlgRPd9VKPxfJH9EC7QJTPVSQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6763
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIzLTA4LTI2IGF0IDAwOjE0ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9u
IHRoZSBwbGF0Zm9ybXMgd2l0aCB0aGUgInBhcnRpYWwgd3JpdGUgbWFjaGluZSBjaGVjayIgZXJy
YXR1bSwgdGhlDQo+IGtleGVjKCkgbmVlZHMgdG8gY29udmVydCBhbGwgVERYIHByaXZhdGUgcGFn
ZXMgYmFjayB0byBub3JtYWwgYmVmb3JlDQo+IGJvb3RpbmcgdG8gdGhlIG5ldyBrZXJuZWwuwqAg
T3RoZXJ3aXNlLCB0aGUgbmV3IGtlcm5lbCBtYXkgZ2V0DQo+IHVuZXhwZWN0ZWQNCj4gbWFjaGlu
ZSBjaGVjay4NCj4gDQo+IFRoZXJlJ3Mgbm8gZXhpc3RpbmcgaW5mcmFzdHJ1Y3R1cmUgdG8gdHJh
Y2sgVERYIHByaXZhdGUgcGFnZXMuwqANCj4gQ2hhbmdlDQo+IHRvIGtlZXAgVERNUnMgd2hlbiBt
b2R1bGUgaW5pdGlhbGl6YXRpb24gaXMgc3VjY2Vzc2Z1bCBzbyB0aGF0IHRoZXkNCj4gY2FuDQo+
IGJlIHVzZWQgdG8gZmluZCBQQU1Ucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8
a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNr
LnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg==
