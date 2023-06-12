Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B0472B540
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 04:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjFLCAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 22:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjFLCAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 22:00:42 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78B91BB;
        Sun, 11 Jun 2023 19:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686535237; x=1718071237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cBsoEEcn1DiOb0m099mbHR+eIVfgykKkYRejPvbQhV4=;
  b=XVeLFTnyuaO8k+traLe/a9El7/3Zlxmi7Se7j7Ll/3PPYUJE9NTx3imC
   9W9Pap4TjToARrfOjA3wxj8BHAlD5kiCh5dTUd36YurQNFetMNV/NMg7T
   KmL1o1452nbxQFBko8GlFWf9Tk1OUn2SfkLNBAaKanHU7pkPf3dlKOqoF
   xcsOBHNbSdMTinHvX+lAqQmS/+s3cJE0B4ocd/gRL9XDbdQgBqAuO0ZeR
   4259s7sDaahE2Km9PyWUm7yNhL82+PbrdgWduq9XkfRnvpx0tNkc6hAuq
   vXAmPq4fIv5/n6fSQe1wRNczxmj6R4SSSSLbcrai8pY9fpsl6uZFNtlDc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="361287287"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="361287287"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 19:00:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="711032216"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="711032216"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 11 Jun 2023 19:00:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 19:00:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 19:00:34 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 19:00:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca6sQqVABdwfWwoqjt/D5a1mQIV184AEviJSOjp8gHVc5WLnxBO2vcrbCZ/CU7ro3CYuvT2wtalbmdje6KmhtdaXs1IFjr0pNKkoU+T+NDjSNr+nKY7O27WXsy7Gqcgl+gpQkxLB2ywLCDRZ0Ws12K5Mvly3vcRLzVC3qkKwf1uaeCOvawHnuzLVueah41axT5cXdXSVCJJH0T4O4qVovO/maqrUHmRHfnl56V6MHK83jseEsRfv5607FdrAB2/vIXrHXs3eeNo+aoNdnyLA1FcJ6SLg87Uqiyu0bl4raR/mywuRjYy4Adv9tM5acS86wlazYxhAr2ZcFqFYAQ4mOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBsoEEcn1DiOb0m099mbHR+eIVfgykKkYRejPvbQhV4=;
 b=TbgXdLb99h+DhdW+gMMAKOEUf2S+Bjzue5BEkwobKIH7G0G2ascCTGh1/WK3vAo3PABDMTsw8KRvR4DJHz3C8w+TqkGufCaIaH3QgpGvNfOjgrDe6/OgVbo6XILKSfa3lSAC3LIino5bP83lJaL/BQPXnRIQAw++qlIvmo9V58IwhOQ5Ht1Y93FEPQv9In5518OttMlEAdF55oy1M2SJLHv0dQSv9dw05Vlo1qCVLHzJO72BjL0PAJFgev9a/LaqhRvNoVcKLOfhFAM/ItbGppRMv7+Ox7Wmh+yB3YDzatoPnEMk80i82KvbbvyPifkSbLRP5ywF1uHoSgOAdiukmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5063.namprd11.prod.outlook.com (2603:10b6:510:3d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 02:00:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 02:00:30 +0000
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHZlu+wT+VnAmvfKka8EfWTldC51a+AEh+AgAAlKYCAAJcrAIAAGZ8AgAWNX4A=
Date:   Mon, 12 Jun 2023 02:00:29 +0000
Message-ID: <29eaa4179ea8f6509b62d513f14932cfbd5b0a82.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
         <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
         <19ea7470e9d6fa698f9ad7caff3279873e530a0b.camel@intel.com>
         <20230608114128.vu75wlcojpyjak22@box.shutemov.name>
         <c185d685-4a07-6260-57c8-e36b4671beb8@intel.com>
In-Reply-To: <c185d685-4a07-6260-57c8-e36b4671beb8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5063:EE_
x-ms-office365-filtering-correlation-id: e96ffd3a-3b79-4358-3638-08db6ae8cc8d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JoasCXyWwEHE4wHatmVEPPdAl0O9HKwg/QxtOoR5ToDswG3XDergTm7G2dW/l5J1R0psvDmcVwmC5yD52z6kZF3wKrmq1sok7MgO1/HFHOY/gA0RktlU/EAH7c73WX85OrqnsvtVdaDSSc29nMzk+cb1+t+hDRQYM8UESDYU1ggyxmtdzp5zJEFZdyyGbUhHScnQBvMlwisbl06KSh1EWqryvdOqhPZcJqNLAq8YSf/wlj4oy+8MyOQ4TVkd/mBoZmhJrJOx2aNDd6jTEyiheYPBalx9IJp83q/HneAuauv7GPdsZLVjKgejNJeJA5Q+1i3/sIKUAVbIjE5FCeK/DWQt2VmMCRa2HxyM/aG3LCudQ8URoRiN9kIvxwNGcADMF8bBLJPXY91dGL6AHa3QlkWT/BJxLXHomkSoSkLGN7rNlecD/y6me75P54kNy4YMOtV1LzRJ7nyaRk/z7uSldaHLfRm2VzusEIa+0i2HR0qW/2mAu/5tga+XMjqwgKLkWz91dXUZAd/GytLV4nTu3NCtTPfmMk2By+tb1Dnq7Nsv6Z6Ni8ofsqfRN4HyY/LV8IFWKidUj8y1DaCym/CYSSlXc1UPMevx7ClhYMJi8xpovaqH/mgwW0llRHOm5qNL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(316002)(6486002)(41300700001)(83380400001)(2616005)(86362001)(38070700005)(53546011)(6512007)(6506007)(26005)(186003)(7416002)(2906002)(4744005)(122000001)(82960400001)(38100700002)(8676002)(36756003)(5660300002)(8936002)(76116006)(66556008)(66476007)(66946007)(91956017)(478600001)(110136005)(54906003)(4326008)(71200400001)(6636002)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXBkZHgwNG5UTXNyMjBCeTNLWlFoUnJ3UE5qMkV2YTRqWTFJREZrbTVRZ1pE?=
 =?utf-8?B?bjVGYlFXcTVZTTlIQlRJZXAvcEdxcEtwcnh5SDV6SCtXOVdORDJmQnBlOVJL?=
 =?utf-8?B?K2tjVkRQRzZocXdmVUdHSkw4TlNwcDR0bDEzY1dZWlVRUHVram9QU05wSXA0?=
 =?utf-8?B?c0ZPS1l0Qk5PbXpkdlNrdEFPWkgyUWExdTQ0WUVvZGJWUWx1ckUzclc0MHdR?=
 =?utf-8?B?andLaEN4T0M3Szc0WTQ0OE1SaUE4NlF3QlZpVDgzRFhPbDFWaXpRNmhZUzJm?=
 =?utf-8?B?QWwzeVhJN0VRSzVtMG9GRmxnMmJkSmV4YmNzZ1JwcHU5VHA5djdtZHZmb09v?=
 =?utf-8?B?Y2RLTTBFUGpiUjMzYVVyY3lPOFd6N0d5Q09BSGRGT2RCQUV1cFpHcTN4Z2Q3?=
 =?utf-8?B?WURTL201bTZaa2tQR01tOEhaTys4YVFNZG12L3Y4VmVmK2VaWnhNSkZsOVBl?=
 =?utf-8?B?M0tySHl2UGwySG45YjlGVzYxVThvbDZRRDJKK21mcE0zbjhick5ZTzBaTG5z?=
 =?utf-8?B?Wi9zaDVGNEh2NjM2eFk5TllZaUQ0ZFlmREloN2hEYk1rOFNzVEpjV2YxZ3dF?=
 =?utf-8?B?QTVUQkh6UUxQdzN5WkgvME5nSTJRM1ZwOWVvNkt4YVNoUDFBcTRvM0h5QU9Y?=
 =?utf-8?B?b0ZmMDZBamJ3ZXZ6Z0xTWWVPSkVRdDk2OW8zSGVSQVd3KzdoZ25ZZU8rRGNY?=
 =?utf-8?B?bE00WFBvRS9MZ3hzSDRxMlI4WWJ1UDhkY3MzeWloSVY2SnJkSHVnSnM2RVJN?=
 =?utf-8?B?K1RzVmxaR1JKVWU0S3hjSHhNS1orNm45clgwNkZJbjdPZEE4cVAxdFdwWmhN?=
 =?utf-8?B?MFdhN29aazY3RlNTUEo4YWIyM3dtUDhUWjNRQlVvcDFVa29kWWl4elRLTWhE?=
 =?utf-8?B?RFNvZE9XYUxQd3VUZnd3VFc4T01RTms2WmNyeHNYKzRNeGhYQ3JkTU9lS3lB?=
 =?utf-8?B?SytseDVCWk9EcGdoU2FLcnVVZDg3S1g5SWF4QUxHbmpEbWIwSkZlVk05SG44?=
 =?utf-8?B?bnpMbU02eHdGSXJYK3lIcnN0WEhpdHVLWnpWRXN0ZHN2NFhwaTZtYnVGTmdC?=
 =?utf-8?B?bWViamIwMVh4eVhTNzkvYTNhTi94TWhLVHNrSlRtWS9xK0JUdXlCTU4yUktS?=
 =?utf-8?B?ZlJvN3NYVkhCMm5Lc3ZoZmR5UVNHanYzd1B2ajcxZGhEanJLb285TEJTNklY?=
 =?utf-8?B?aENCWlFDT21vVGFtcGJYZ29zNiswOVFxK0RvWTlyRlZ6bTZNNWsrSTRONUUr?=
 =?utf-8?B?TG91TzBzbkJlQVNDOFlGb2NWQkZ6QlJ0NmN3a1o0R092ZGRYdXhqNUJwOE5m?=
 =?utf-8?B?TnBLcGt6RUl1cWpIWXRtSkEyOUdyM0ZKTStXNDBId3ZHbVlUd3JobE5Jb1Zx?=
 =?utf-8?B?bmg1WkVjNHY1a283SWF0RHlHN1RROFRPRVBoTlhldFRQSzdobTR2bEJZRkU2?=
 =?utf-8?B?TXY4SjdVWmpsbTdpNVVKRFcrbHNDejg1OVlmUHJqWERlRHdSbEMzM2EwQ0Zz?=
 =?utf-8?B?bnFpU2c2aXFYWk8rWFBJTTJWSHhwNkR6UkxsTkkwWjExU1d4V21KdTNOdi90?=
 =?utf-8?B?WE5pcDgyMFFuYUNXNGQwSWM2M1QwQ1NTcm1UVFN5MjlPWFBpb3BMMGVBQXls?=
 =?utf-8?B?bkVjTWsreFVXRVJXQWFjS1BEeVhjeW9wWkFYWUFaWUQzc1ljVGdrcFh2dmtB?=
 =?utf-8?B?dmthY0VSZHdsNUZ0Ym9VSmI1cFZpVTVmLzcwaFlzM1hkMHhlYjVjQ1B5K05D?=
 =?utf-8?B?aXBrWkMzRVFJTTZLRHhzbDh1MTJVbkQ4c3FqSU40Tk1PNUQxUkI2TG1TYTJo?=
 =?utf-8?B?NFFuR2lMTTB2U1ZjK1BqT1FaQXFuQUhuSUY5bXRQYzVJZWc4aHJmUHdnMjZV?=
 =?utf-8?B?eUFPdEdMeVU0OHVDNjFhdTloeTFqeW5DczRtRlFtVjJXQWt2WWRVT0pmb3cy?=
 =?utf-8?B?V1dLQ0IvR2ttU24yd0lWRnhNNmRhYlBid1htSWVhbzRvTWFSelVBVFdQZERx?=
 =?utf-8?B?QllPbHdpc1htbVRkd0J3Rm9ValNyTHFlR0k5T2E1dHNJQU9sMlV5QXc4Ymhy?=
 =?utf-8?B?eG50OU9LeDhxTnh3U1ZsdmNKc3MxdzJVbVU2c3RZTURuZXQ3TDM4Ui9DQ2hk?=
 =?utf-8?Q?rTjLbtIp9kBFObrTFaTMR1qW9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5AC47DF5A5E2749B6B6A77A646CA2C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e96ffd3a-3b79-4358-3638-08db6ae8cc8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 02:00:29.9572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yLvAbhExtYnk1LGZ89TOFgPkd7roROAsax86hUxmTSFfJssOdUX4Q1UL16o/8r7Vsix1NUH1pT5ih7mjAepypw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5063
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

T24gVGh1LCAyMDIzLTA2LTA4IGF0IDA2OjEzIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi84LzIzIDA0OjQxLCBraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwuY29tIHdyb3RlOg0K
PiA+IFRoZXNlIHN0cnVjdHVyZXMgdGFrZSAxLjVLIG9mIG1lbW9yeSBhbmQgdGhlIG1lbW9yeSB3
aWxsIGJlIGFsbG9jYXRlZCBmb3INCj4gPiBhbGwgbWFjaGluZXMgdGhhdCBib290cyB0aGUga2Vy
bmVsIHdpdGggVERYIGVuYWJsZWQsIHJlZ2FyZGxlc3MgaWYgdGhlDQo+ID4gbWFjaGluZSBoYXMg
VERYIG9yIG5vdC4gSXQgc2VlbXMgdmVyeSB3YXN0ZWZ1bCB0byBtZS4NCj4gDQo+IEFjdHVhbGx5
LCB0aG9zZSB2YXJpYWJsZXMgYXJlIGluIC5ic3MuICBUaGV5J3JlIGFsbG9jYXRlZCBmb3JldmVy
IGZvcg0KPiBhbnlvbmUgdGhhdCBydW5zIGEga2VybmVsIHRoYXQgaGFzIFREWCBzdXBwb3J0Lg0K
PiANCg0KSGkgRGF2ZS9LaXJpbGwsDQoNClRoYW5rcyBmb3IgZmVlZGJhY2suDQoNCk15IHVuZGVy
c3RhbmRpbmcgaXMgeW91IGJvdGggcHJlZmVyIGR5bmFtaWMgYWxsb2NhdGlvbi4gIEknbGwgY2hh
bmdlIHRvIHVzZQ0KdGhhdC4gIEFsc28gSSB3aWxsIGZyZWXCoHRoZW0gYWZ0ZXIgbW9kdWxlIGlu
aXRpYWxpemF0aW9uIGFzIGZvciBub3cgdGhleSBhcmUNCm9ubHkgdXNlZCBieSBtb2R1bGUgaW5p
dGlhbGl6YXRpb24uDQoNClBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3UgaGF2ZSBhbnkgY29tbWVu
dHMuDQo=
