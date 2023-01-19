Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9CC673711
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjASLjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjASLis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:38:48 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B17F11E86;
        Thu, 19 Jan 2023 03:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674128257; x=1705664257;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uf4R187MRHOI+QYKenHhAHbfJo70UBFMpq7sVajCTvg=;
  b=QWoWuOqlBKEqX4DeLpTlD1y0c9uMrvtJVurJtskIEBAsgZrork6VVFp2
   +NMVN5hWYbnlTUzPyMW4N/KX1YQVFZsy/uXaJugJYVsIk+//UHlaJmnge
   axQHnrFGa17TYi/TkFPqjDibftsTRnwmRxVm/GwQFHAiDR67ZbhBbC2TS
   pyXWeo6ZIsN1U762Scz2zy71UgKzJ2THZrtRbjWjFlxCWIRQq+/KHd9LB
   Rxy0k0cXsvN95XOUKI++JFMy/YH/9k/CznLRmL3ZFitmScWimfL+H9A8r
   Guug32PA1gib1fwV0/3GEu3csAbrC4vHbuT1snGvPaCu+AD6+2J9EuWtQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="326523250"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="326523250"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 03:37:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="723464506"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="723464506"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jan 2023 03:37:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 03:37:33 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 03:37:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 03:37:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giCNTLEYWhASZ9q6X3bcILdQlc5N4xr/R3FS20664wTRNut5jM8fCOZCQAdaNaNxrs4g+gSbxsKtozoTWkkDK6Sqft3sU+GSITjLZDEjLKaCFGbQpy4tpOiswJdDLO34S+fEsXvvAdHgcnh3+sANdsO8TALzpgctf4+5EWElPnyRdQCkCaJOP7IRfJTK6JUyljIJEu99Oo0Tgb0FscdnPTMT8wTI1DjVVt5kseHkWuN9wIf7kd487W+8RwGwFhBObB+KwnqaImoRRN5WvmQOXr2LJk6Vk8SgBwACCG6ny2JwffS/9eMjgqSfDGFYHrkuayxFt0AoyEnbdfehBS4OQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uf4R187MRHOI+QYKenHhAHbfJo70UBFMpq7sVajCTvg=;
 b=ktSs/erpAWWGaOBHfGIedKOfW2dlQv/vRsNXVsfScFFddDnk8EwQzX9FmsFvmCW9d5q8w2ZlQAUCkNioqmYbtIi7n//Xbl4mTk0yUvvhyD8xGelclIV0zFOmi6ExwDL3sxTG2/Z+lOld9tOTs2kvV8F6tqq4PwNf00sc1qNlkZcCK0gGUHyX/6Ey6DPzrB2e2gD5j6pLQsMOhNWmx1HwGcL7jV79azRJNZsMet0X5jvm8KfKyQgsLHgEPLhOfI2ZT1swULchJU3jWwb0VkHJFgbKmm2QydklrRn1Ud87/Vp4+cna3NuME2B6IALvLQUXUe6kSQH2T7WkmYytvcIHMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7872.namprd11.prod.outlook.com (2603:10b6:208:3fe::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 11:37:25 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 11:37:25 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 039/113] KVM: x86/mmu: Require TDP MMU for TDX
Thread-Topic: [PATCH v11 039/113] KVM: x86/mmu: Require TDP MMU for TDX
Thread-Index: AQHZJqVxgDYvReg14E6maat642wN266lp38A
Date:   Thu, 19 Jan 2023 11:37:25 +0000
Message-ID: <6e7d04537f65a7ea6597e8e1ecda87fe1bb9b546.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <c67b3702c8721d4164eaf5f56474747aeeefd426.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <c67b3702c8721d4164eaf5f56474747aeeefd426.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7872:EE_
x-ms-office365-filtering-correlation-id: 2f593396-ad8f-4553-de0d-08dafa118978
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vr9RF5omiBzjWt68xVQUdTGKRLNYiqrsfsZ3XXw43RklZ4l+viSHvS+D5EdF8C7Jbc08JuBd19ltR6Qkxphc69evedQjZIYLl2KsW3FiXQ3K1ccZS7z7AExyUqeO0tSShIWpddjUFfgiDAY1xHfVrflinrfCk3woq4FGk/BK3cao1vpkCINITWI3H4YjtPlRS9ufRWBE6ZTr0gjcN0Tj6jjl9GdAv7TPb0ubJy7pfwSUM64+b0J4Jq/rqmjDWtD+rHRzRfintdti/gthCuliD8rP/yvq0gEafpnWX9g2hDZ/x4WI4FEVIFK2EmCsW9SnbgXGuI4P7AFVDp5DSVepHhtE45FVLxowoBYWvFHBI8TE+diAOyzki2Met6ITagBM77zKu3P5kmCAPnZc3dPeHFkOUpRh79l2bSlCjzjubDPRVFO4Ytob8tZwk9HuqLMnW+pbaVJaGhBUJ8eUcrdoDF/vMwnrig+MAnw/LRu3/eey5VWN89k4u84R1lyvRvF5ReVlWdPhabR4iZe6E/0drHmW/1VJYoPhTCKC8QLza0PNt0SdaxKXy/La2g7x75P7etQGgsuQGSDfEEdech5JQGGWvTs0O4amdtxZfU/HsVkPfLAGubma0Pjvwt5I/Ke1pmmOI//+3YmRV7J8HdjS7/W1oMDCioxHFokAfrcFNQwoFEQiUVVjRv5xLvE+HKo6vGOA2amyZUc4lngVr9KhyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199015)(6506007)(6486002)(6512007)(186003)(26005)(2616005)(478600001)(6636002)(110136005)(54906003)(66446008)(66476007)(66556008)(66946007)(91956017)(76116006)(64756008)(8676002)(4326008)(316002)(41300700001)(8936002)(5660300002)(2906002)(122000001)(38070700005)(38100700002)(86362001)(82960400001)(71200400001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0t0czkwU1drcGM2a1c4dGZCSHlPSVJhNzNJcmNXOUhRaEd4U3BlN24wcEpi?=
 =?utf-8?B?bUhXVkRjdzJPVmxhZFhCVGRBRWxUVTBtanRvZGFLVkRaM1lpbmpXbHRlQXpr?=
 =?utf-8?B?ZHFYc2RjWm1CSElCMWVudFRLWUhRdStoR3Z0REU4Vy9HNndSS3dtK2NGVE1X?=
 =?utf-8?B?UDR2K2VHZDc4S3U5MkZVSko5aFliS0tCVUtmQnc4dFJ4OXNtRFNKVFRwQWdC?=
 =?utf-8?B?UGl2bHFIemZMd0tydWM4VHNVNjU0cnUyOGxkckFMd3lSNWk2eVhiU2taY20r?=
 =?utf-8?B?TW0zdlRxQk0vdVZIUU1xOEk2THl0SEx3MHNjZWpKSEtFSFBhMVZLWmMyWjMx?=
 =?utf-8?B?RktxTWtsWWpxb2V4VVBZT2p1RXV1TDVIT1NZYlUzeDRyWFUxUDNPTFdmcTF4?=
 =?utf-8?B?L1E2K0c0RmhVTm0vbmdWdTRVN3lTRlhOM1hKaG8ybHIzZ1VPdDJoMm9kRFQ0?=
 =?utf-8?B?ckJQNHFKS1kzVHZrdDl5UmZ5eWRmL2NCMzJHTm5yWU91QXVjNU1aQmtLekdP?=
 =?utf-8?B?QkNzVnBzcnVKT1lSYmVOQnpBemFVcDdJVU1rczBCK2JqVnZNcDNJKzBmRHNX?=
 =?utf-8?B?RUxKd2VkN3FWb3NqeCtGYnVaa3pQampVY3EvampyR25WWnVWdlc5SkFxbTJP?=
 =?utf-8?B?cEl3T09HenhOK0tIT0UzZXFIbXlJbXN4R2NsWGx6cVBIcElkYjhmbFZpNE9I?=
 =?utf-8?B?WXQrZUVrNG5aZVZQUStpbktla3Z3cmdTM0w3S3NydTZ0VjM2VkRpS2RBU21m?=
 =?utf-8?B?a1l5UitYNzYyOWhZeGVFbERaWXA3VVdTT1M1Yndib011bEwrWHc5UDZKYW9C?=
 =?utf-8?B?ckJPRUtQQU1HTUM4cUhoT2Jid1NabjNNSnNWZjQ3NE9IYzBHMXAvQXJLejJM?=
 =?utf-8?B?Y2ZSODkzY0ZJQ2lkdVNHQ3B3dU5FU0tyZHE4dXBLRG83TVdPZDFYcUNWakJw?=
 =?utf-8?B?VjFCUEpMa2pmTE9CdWU5a1d6Ujc1S1hweUNCNlBiam9zbDlXY2NmM3kwdCtR?=
 =?utf-8?B?OG5xekN2TEY2VnBEcTcrVFhLaHZTUnpodVhueVFsa2tDdEZNbWVGaENSS3lp?=
 =?utf-8?B?WnZCYzMreWkyYzczM3NDWmhqNW94aCtxYVZYenY1Z1dnY0t3Z01zUzh4N2dv?=
 =?utf-8?B?WWx5dUNXTTdFWXhxRk45V0E3MFpnQTFyNWk0KytZTEhrVkk0SFRFMWgxUEFh?=
 =?utf-8?B?UFBPWGUwUDd6VmZ4OFRoUTduZ0FqM1NPcWR3TnJiQUJzYjAvTURmZitTU21a?=
 =?utf-8?B?cXFZT0lNWnA0VUx3UU14REFicmszRFpvbnZjL0oxdjdOajlJUzZ3ajYvMFVo?=
 =?utf-8?B?dHIyNFdNYzYrR3ArYUZXdGJsUGVkaEtpYWZDRUYxZmVsYXhwUVNSdE11NFg0?=
 =?utf-8?B?WCsybTM0bmduOFpESHhCLzNJUHBNN0owdnJGN3hYRnR1djBIZEdUVnBPVVVH?=
 =?utf-8?B?bXB2b3lGMUlGalkzdDIreVowZktlaStuaXViQkIwNGtKd2F3MzNMQk04WEda?=
 =?utf-8?B?T1pIekVQUXdWd09SUHNTRmlOU3VWdUxoWmhWMXBxVFJNTEFnbExSWUxicFE1?=
 =?utf-8?B?WDFJTVl0UDNOc3hBMmVreXRZdDlHY2lwdzkxOFo2b2k5WTl1eHI4ejJYTHdq?=
 =?utf-8?B?c2RLcjBMdFQzUitxemRRM0EyZTV3L25xaW9zTkJJWHpNbTFIMEtJZnlwbWRH?=
 =?utf-8?B?OThQSm5DMzBXbHZMa1oyM0Fma1JFSk5jU1RuTWEyQVdrRVVnaVllcGprUmpL?=
 =?utf-8?B?ZTlaNlc1OGo1MVFqdWh3U2Z1NHJldzQ1SXk0UlF3T21JeDYxSWVEZkxrTm9m?=
 =?utf-8?B?K3ZDYUFpNy9PWndXNlkzS09IaUdFRFZ1L0E2UUtkc0NwS25nTnhMeVVxak1P?=
 =?utf-8?B?SEc5NFVRcTJNMlhVUkJsV3ptQ0Q3VUplV21CQjM0ZWJud0p4V2dYblZnUVpU?=
 =?utf-8?B?cno4NWZXSXZYd0hHOVFwQTE5VVRhMWhrYThPMVhBSTVKUndidkJ6YVRJVEl5?=
 =?utf-8?B?ODFpVVFJNHpsYWRHOHl1aVdDK1JHQnQ4SlpDcGUyTzMzYnpGMCtKMW1yZVhQ?=
 =?utf-8?B?K09vQmE1QTJTdXMwaHphdjlBQ0lZMUF6L3FEckY3YlVTK1V6cGhhQzZieXgz?=
 =?utf-8?B?TVBmVEpzaGRrN3drL2xTd2JRQ2lGSjlHWHdkQkpuMXgzbUp5V0hxZUxteE14?=
 =?utf-8?B?SWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FC7281C5ED0404AAECE638A1D8D9DFF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f593396-ad8f-4553-de0d-08dafa118978
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 11:37:25.3977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: No7zoCUHKqtdAFo4YGjxkDHjZhkWNQWvC98IN8s1HmO0KnJahkkxgbOgS1gsfoATA22EVWD5UZXCA6ME3AgyeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBSZXF1aXJlIHRoZSBURFAgTU1VIGZvciBndWVzdCBURHMsIHRoZSBzbyBjYWxs
ZWQgInNoYWRvdyIgTU1VIGRvZXMgbm90DQo+IHN1cHBvcnQgbWFwcGluZyBndWVzdCBwcml2YXRl
IG1lbW9yeSwgaS5lLiBkb2VzIG5vdCBzdXBwb3J0IFNlY3VyZS1FUFQuDQoNCkl0J3Mgbm90IGFj
Y3VyYXRlLiAgTGVnYWN5IE1NVSB1c2luZyBFUFQgY2FuIGFsc28gc3VwcG9ydC4gIFdlIGp1c3Qg
Y2hvb3NlIHRvDQpub3Qgc3VwcG9ydC4gIFBsZWFzZSByZXZpc2l0Lg0KDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0N
Cj4gIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIHwgNyArKysrKysrDQo+ICAxIGZpbGUgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21t
dS90ZHBfbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiBpbmRleCBmZGNmZjM5
MGViYzIuLjZjM2NlNDEyMWE0NiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL21tdS90ZHBf
bW11LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMNCj4gQEAgLTI3LDYgKzI3
LDEzIEBAIGludCBrdm1fbW11X2luaXRfdGRwX21tdShzdHJ1Y3Qga3ZtICprdm0pDQo+ICAJaWYg
KGt2bS0+YXJjaC52bV90eXBlID09IEtWTV9YODZfVERYX1ZNICYmICFlbmFibGVfbW1pb19jYWNo
aW5nKQ0KPiAgCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICANCj4gKwkvKg0KPiArCSAqIEJlY2F1
c2Ugb25seSB0aGUgVERQIE1NVSBzdXBwb3J0cyBURFgsIHJlcXVpcmUgdGhlIFREUCBNTVUgZm9y
IGd1ZXN0DQo+ICsJICogVERzLg0KPiArCSAqLw0KPiArCWlmIChrdm0tPmFyY2gudm1fdHlwZSA9
PSBLVk1fWDg2X1REWF9WTSAmJiAhdGRwX2VuYWJsZWQpDQo+ICsJCXJldHVybiAtRU9QTk9UU1VQ
UDsNCj4gKw0KPiAgCWlmICghdGRwX2VuYWJsZWQgfHwgIVJFQURfT05DRSh0ZHBfbW11X2VuYWJs
ZWQpKQ0KPiAgCQlyZXR1cm4gMDsNCj4gIA0KDQo=
