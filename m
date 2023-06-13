Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514E072EFE9
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 01:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjFMXT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 19:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241688AbjFMXT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 19:19:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7E719A7;
        Tue, 13 Jun 2023 16:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686698394; x=1718234394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0Do0YMB150GJFRITzPsM/ZbLj1IP44p0ARQb4wq2VgA=;
  b=W8vJzkflQmFSQpcFgRe/v1r0xB945eSg4CwRT9UE814H6pmmTTBo2qxe
   vkIsbU6EUkLk8yZqGrq6+5uQ6Lc4h0gKDljBK9xnCOKJ7owIUfECprWlr
   YkEDq4LrGz5M9GoSAmDtRUeOqrJv8XWbPWFdUJdJuKtRLGUpRTsMNKuSM
   nvfsVIp3lbp2gH6nDkLC3N7Y1m+kwWORnGbC7TYOAej5myZd65QFRw+Ea
   RUCZy4nDzEi6cufgVm1FvWOnp+QDamIatG2z24+iYAZvryttOE4y/d2++
   KR1/Wzg+w0zqvZIMbCkzB2FWwfAy8VBpsOTZ4KZtOe5lZneqLonmYPHQv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="338106133"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="338106133"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 16:19:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="714975672"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="714975672"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2023 16:19:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 16:19:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 16:19:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 16:19:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKoVUL158AtjSmcka09x+AdtIwVa7Hj4VWN8x74VEfW/lQl720nO4/yzPMupdHO7ZecPuvEq+NhUP0Lvndsh9qAMEsw5R9NrW+bBknmeiZaCDs44A8SQkj0mIDl3ZQAhQm73MaqDWZe8tT5y7fHXvu8hiEb8Wt/JKe/Y0ksmkDr0dWz6+X7yl+AE1aqvu9a/iHP6sUeT1Ak7Y3eTlCb64iOgckaWobOf99q5rAlfhGmK7AUATpuL7KWdrMLQhRjX/tYjMIHFRdFmzTSiWeIewJD1L/njsa21ZoCFgjKzYGOc4ztEno8/GlkIJ87YrJjZuchq7ZQAHvB4T8Jw9IssbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Do0YMB150GJFRITzPsM/ZbLj1IP44p0ARQb4wq2VgA=;
 b=klRt7cvFpCeiJvxSh1Q3lZXlt2BIcUgT8/1w6rdynzGrzcr9AsqTNRzGkiBQnKuLktXdY+Sbcdwv0xRKk1BM6Q3zNgQwL3Isv0zlHu3D/0z8oCi7YR32rFD5SYbnbjiwsffreQO902tTimMDVFf4TS2UIHXx3MEKS+MxYbsr3OUpILI95/F5Lq1E9NBxdbYfwRWb0UxeSDTvGLAupUDMsLIc3Z7qStDZ9qQsXC2rDVeOFRtb1OdgPzfzzFAXeaVv1XcCoZfqJmZe8z8FBuvzOoIXF1gY+SIHrUvFg0ivBtUfxs+Jhus3CIkG9q5EB5yXgfWpPk0rGfBAgRUPtMU9+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6683.namprd11.prod.outlook.com (2603:10b6:510:1c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 23:19:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Tue, 13 Jun 2023
 23:19:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Topic: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Thread-Index: AQHZlu+2r84uqtF1H0SFKn93tuC1FK9/hdAAgAE59ICAACfHgIAFl0EAgADJKYCAAH+agIAAy4CAgADaI4A=
Date:   Tue, 13 Jun 2023 23:19:45 +0000
Message-ID: <e027617f9a4da63ab27639dcac5f1dcf07a4d628.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
         <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
         <ddbcadf36016bb60a695f54b28f5c9e9af53a07f.camel@intel.com>
         <201af662-f700-9145-c113-563e378074ad@intel.com>
         <89c99e7360dc2acfe5fb56c2bbb40e074e1f94d5.camel@intel.com>
         <20230612143355.sur7zc7byu7omxal@box.shutemov.name>
         <3e188621d97af794f03072e5261dcc9f589900aa.camel@intel.com>
         <20230613101859.lwqlwa4t72sthvwk@box.shutemov.name>
In-Reply-To: <20230613101859.lwqlwa4t72sthvwk@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6683:EE_
x-ms-office365-filtering-correlation-id: fdff9f44-3f5f-410d-3417-08db6c64acc7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f0LctEtvkBcVB71KbPuiRE/oR8QFs+E/9Zp0GQq9fGBRY8Lcm977XCBVF9gVIv0mE9CdAtzhAQ8a4j6pZB9ZlQZw+e34RfvoypbPbKLjJm911o7HW2EahWpkYVbM4SZMXLre5CfRfs9OGpdHIq8g2m1wR7xZMbeaR4RG5iwamHMeMRFJVMncbftAZ7+fCshj99pTUVToMkSY/id/3L1LHpQxM8jb5YJIyxPAsVZGJMwuy5tViAG2s9CQqUOkw9EOZWDqKRen+nYh6Psd/NVrLvNTs9BOwOdsjhLY6ebXZrwdoAmP6Ln//ThLbnlP4amtXVf+w/dQ1gBWjr7QvMThYObSGR4/jmP32K5DZsfs7fufNiDAWTq6/E6BGjpLyDv3r2/CxLqKl9PZUUvP6z1+E4mAy21ZuqGsfqLLLgwLMThykpEy4wRi02ZE7Ph8uiLXphPSK8E0NCHbT52qP5x8jrneK0ocgmfLLgF2F+OyWCGbW1TzEt5df2xGLZlKZW78a0wmyYqahR7/jvVrGwsGlt4ujrPtzHOa4x4Vo02Uso5oqGdW8kRmzMcyptsjYYzU1QwruBFfJ4BSNNGAwb2yRqccuRg8vj6fLd4iji6X5qrIWvwSYHLt2P+FkC3NLzAH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199021)(38070700005)(83380400001)(122000001)(38100700002)(86362001)(82960400001)(478600001)(6486002)(54906003)(71200400001)(5660300002)(64756008)(8676002)(91956017)(2906002)(66446008)(66556008)(6916009)(41300700001)(8936002)(66476007)(4326008)(7416002)(76116006)(316002)(66946007)(4744005)(66899021)(2616005)(6506007)(6512007)(26005)(36756003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ym9CT3ZvWTJTYmZ1ZGFBM3RDNE84TTNuZmJPOXJBbzhYWExNY25hU2hCSThE?=
 =?utf-8?B?bDN2YXZHcVVwSS9LNDdqSHpkVmZWL1NRazQvOFBEbDd3aUExc1VBSHhDaXR5?=
 =?utf-8?B?bksyRjBqbVBHcmFpbitjeFR6Y0xadjBCdUlzSE0xd2ZJZVNVT1F6OVkrMGcy?=
 =?utf-8?B?RGs3eEhCenZaRWsrc3RuMjI0Z2pLTmY5WDcrNXo3TkgzN3dDUTBBTkV4Tjgz?=
 =?utf-8?B?UXdBMkhOd040RGFITHFHTlMwYkhEeU1KRXZFUTY1aHhvZTM4NmJkSVUwRkdW?=
 =?utf-8?B?VlRReVpWYm5xMEJsZzVleXNacElnd2tMTUtQdi9kdDE0WVRpOEFGelpFNml1?=
 =?utf-8?B?bXNFbFRJYUsySTNORzVHNEZsY2MxOTQxUFU0WFBZMU5xRWtINTFmTENDcFhG?=
 =?utf-8?B?MG5sazJFWWV5amtWeTd5Q0kvRnlRS2k1VDVRVUVMVXZCbUVidmNCQTkzeVVX?=
 =?utf-8?B?ZmJoY09TeUpoYUhDTjJmZ2tlN2VoMVhsbndCeEdISGMwR21seENVOEZLeU55?=
 =?utf-8?B?by8vSGdBSnhYanNnZzNsTmF2Z0hxSUVGQUdWR2I4akNoQmMybjBPdDcxdUUw?=
 =?utf-8?B?cDBIZUk5Z2IyVnRFTEx0MTJyRnk4UVZLa2h2VG9Ca1MzVnRpMEdta2xUUzM1?=
 =?utf-8?B?MGo4VFNWaUlvTVYvN1RYd2tFRkFheU1GcVNpVUdyMm50YUFkTzVsZ1UxRE4z?=
 =?utf-8?B?eVVRTkowbkVoR1ovcXU1eXVzbi9YdTgwZjc2OGN0ZkU2NUpzVVB0d0xCMXp0?=
 =?utf-8?B?elFEYnJQY0hCRmk3T0hWYjhUQkkrYlYwQU56ZlpnSUFJQVBtZmxUTG5yWXNQ?=
 =?utf-8?B?TEkvdkxlOVg0Q3hnOVFVWEt6bTJPUHpZOTBqZnM4NEF0dzZkWElYeXE3Sm41?=
 =?utf-8?B?aTlrMFZwT0g1eE1jNmxKRDFWcCtkMXdkZzNiM1BpbkhHcFdpNFNiSVdaSTc1?=
 =?utf-8?B?bjJLZzNZU0ZJSWZJNHFrZUpiMEJJSTB2RUl5Q1dlTWJUN0VhZHZiMk9ZM3Fw?=
 =?utf-8?B?U280a3JBSS9MNzhSQlBsT0VnVG5PTTFCTlVRZHcxS0kyKzQ1aUhCZ2VzUFJh?=
 =?utf-8?B?Y2xLSEw3cDhaaUdPTkxPZ3cwTUc3NWVpUjVXYVhYUW1oOHFPNTNLNXYreEJ4?=
 =?utf-8?B?YkEvQWphQ00rN0dvcE50Q29ES1FyOGR1SzB1RnpOQVlQbnNnUmVaSmpiVGQw?=
 =?utf-8?B?M01QbGZGb3U4ZWE2WVczUVh2VTAzNEJDNWV4dHZSSnRHZk9Rd1ZBYVg1Q2xt?=
 =?utf-8?B?WXN1TUtzaVJhZWN4ZVloQkp0TjdDOWRHbHNrekF4SkNBRmRIV0JubWRTRmNv?=
 =?utf-8?B?cGdFMCs1dE9xbitEbktxMWNxczJISHBQRTh1SzZxaWRGNGJ2WTdpQVdBVW54?=
 =?utf-8?B?NUo2ZTUrTW1pWXhYRVh2RHZCdzcxVGxJRTkvcWJLS0VQcmdBZEJ6ck5zaUJw?=
 =?utf-8?B?MXlScFJORzJ0bDRqNFEyWjk1cFpCd0E4WFp2NE0ycFZwT0ljZlo0V0R5cFo1?=
 =?utf-8?B?b2RWU01pTG5hTmFsRTFvaWd6SnhnZWFnTEJ6T0RhV1pNT055L2JIeWlic3FO?=
 =?utf-8?B?cllxR2pDUStKWURmTWh3aVN4Z3BFWXZlM2FjdThhR0NIc3E1TlhzWFVsNDJl?=
 =?utf-8?B?bWk0UkExekMyVGVYdWRVOFpJQlZSWnRreFlSeGdmZStOMFhMY0o2cTdncTNn?=
 =?utf-8?B?VGRqczhVengzTmIyOHFsM1dNbEh5Z2lBWit4eGlIWXI4bVkrRTl2NEZQTUxV?=
 =?utf-8?B?SFVEeUsrT3NKaWQ1MERpWVQ4STllamxPR1lFcit3WXplWnVIMExJU3MyRUYv?=
 =?utf-8?B?QkhoN3B4ZTBFTjVWYTg3dkRJQ1NTRTIvZjJGS2s1cGN2MWhDeFRoQTk3c3p0?=
 =?utf-8?B?RXdvbC9EM1h5OFZJZ2JQVmhYZlZpOVhXdXR3TXJ5dkdmbEUwUG9yWVhkNk5v?=
 =?utf-8?B?aC9lcko3bDZBZ1IzRzVtU2JoVkh2YUc4dFVKKzhteHZsZldqYzB5TnF1eEZu?=
 =?utf-8?B?cldwdkFkUTEzR2daSm4rVkdGOG1YUHB6MVZ2bVI3Z2U3Ylh6eDBYZWFlYXdo?=
 =?utf-8?B?eDJlMU9lbXdQbjNwWEtSZnZmNVNaV3EzakJkTHlPakwzbWI2aVpxQWVrc3Zj?=
 =?utf-8?Q?DGxvdnwQ9kApqHY69PWxqq5dG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <857BA1B87BA9E34B932A5F25DA59BD48@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdff9f44-3f5f-410d-3417-08db6c64acc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 23:19:45.3784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dBEjXfN45wcbtwNeQck0zSI8S30EXGoddiXvW5zZrD3J4u67JLPt+sclK8KxwFRsftuR6H2Yap9xRfjQgGEd4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6683
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTEzIGF0IDEzOjE4ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAxMiwgMjAyMyBhdCAxMDoxMDozOVBNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMy0wNi0xMiBhdCAxNzozMyAr
MDMwMCwga2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbSB3cm90ZToNCj4gPiA+IE9uIE1v
biwgSnVuIDEyLCAyMDIzIGF0IDAyOjMzOjU4QU0gKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+
ID4gPiA+IA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE1heWJlIG5vdCBldmVuIGEgcHJfd2Fybigp
LCBidXQgc29tZXRoaW5nIHRoYXQncyBhIGJpdCBvbWlub3VzIGFuZCBoYXMgYQ0KPiA+ID4gPiA+
IGNoYW5jZSBvZiBnZXR0aW5nIHVzZXJzIHRvIGFjdC4NCj4gPiA+ID4gDQo+ID4gPiA+IFNvcnJ5
IEkgYW0gbm90IHN1cmUgaG93IHRvIGRvLiAgQ291bGQgeW91IGdpdmUgc29tZSBzdWdnZXN0aW9u
Pw0KPiA+ID4gDQo+ID4gPiBNYXliZSBzb21ldGhpbmcgbGlrZSB0aGlzIHdvdWxkIGRvPw0KPiA+
ID4gDQo+ID4gPiBJJ20gc3RydWdnbGUgd2l0aCB0aGUgd2FybmluZyBtZXNzYWdlLiBBbnkgc3Vn
Z2VzdGlvbiBpcyB3ZWxjb21lLg0KPiA+IA0KPiA+IEkgZ3Vlc3MgaXQgd291bGQgYmUgaGVscGZ1
bCB0byBwcmludCBvdXQgdGhlIGFjdHVhbCBjb25zdW1lZCBURE1Scz8NCj4gPiANCj4gPiAJcHJf
d2FybigiY29uc3VtZWQgVERNUnMgcmVhY2hpbmcgbGltaXQ6ICVkIHVzZWQgKG91dCBvZiAlZClc
biIsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRk
bXJfaWR4LCB0ZG1yX2xpc3QtPm1heF90ZG1ycyk7DQo+IA0KPiBJdCBpcyBvZmYtYnktb25lLiBJ
dCBzdXBwb3NlZCB0byBiZSB0ZG1yX2lkeCArIDEuDQo+IA0KDQpJbiB5b3VyIGNvZGUsIHllcy4g
IFRoYW5rcyBmb3IgcG9pbnRpbmcgb3V0LiAgSSBjb3BpZWQgaXQgZnJvbSBteSBjb2RlLg0KDQo=
