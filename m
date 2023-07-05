Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2506A7482F1
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 13:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjGELfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 07:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjGELfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 07:35:14 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431591703;
        Wed,  5 Jul 2023 04:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688556913; x=1720092913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=63LVW9NXyZYFLyMFTEu4eAd+HXp0yx/YSe97qqAV6ow=;
  b=CGj2Qgim/EsK1sLw0V4srhlfEhbTaspKA1fkW3PHYCIFTO/x5uFxtLp8
   ARLrLXM/epG4EylF99RopgTBV7jNWodR7vC/xUl/gZ+YC7xhociTBEJqR
   CDF/DJejmnen+NDcTyxjmp40CB7yEEJXIrEnBy+JNx1+hM+f/QR9h2ufB
   opAoqBhvJCoP2QyoL+orgzDQ9rHxcI/zrfRxyUxj+SDqON9lvveM2uAc3
   5MiLxQusBGKNfz9ppp4op6Cp42b3nTrVb3AMnADnKpdk5lGgo6MARv8DL
   Rtk4/RtQH1dpMu1mcq0ZknFIeyEVDDrFQAOR6hMM06X8mipxE/GP06Anj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="365885839"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="365885839"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 04:34:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="843266409"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="843266409"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 05 Jul 2023 04:34:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 04:34:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 04:34:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 04:34:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZG7AKStIYT95/D17z/DxkHtMk4lXNojNV7VAjrnAv+MHR2+uxbGu8C+takEAuW6aAZvKsY+IaLzoceD+8T4wZI43SL7VmAUMZHNRlD9y9rMCnoeiq7AGV+N5PoFZ4xcDFr4uAwemht64EdeBepQAgKDbIXelRB7cC2QsnkQ6oTZ26izjEc5Z+TydxTlnStgWn850MBUiydYKaAHSke6LxSE30iUAiuAau6lpASpdmAPAU6tMRaE4wE1xGabYu3DKevVk3gqCua12LUVVtoDNidalUvDjbfe0r1GW1UGf4cPXsXiSdTl5IeYBq5DIvJ7MYh6GGu/ghqwWOZr0hC1kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63LVW9NXyZYFLyMFTEu4eAd+HXp0yx/YSe97qqAV6ow=;
 b=QMXQmUqw4TFDzzQ+Q8Y7TAfTBOEXAl5oO/qqg82/fusrbPqXAx0mYkdzWGV/d03LfW/XnStOAO46cX3Mjmqf6wKfHgtfnhAcTNXbsMN2LJXzelmNswwaKkCoJg7Iw9piOr05U1g724pYUDZEqFlocDDafVQGpBUJVumYi8Qjpyuxj4jXyOrcitJOdRJTK9HgnTiicYtEJhr+/2Y0J9Idf6ZrOP0qukwFITQ2s1iIzwLfQ6lCWTSD2KXR+HGz5xFRaUlNfh8pg71prd6fEdW8lxTIXzQE4Ur56pBlkQJGUAxUiDhzMq2jRlNJmaQwsVeBPZg9nH9BeaTk/aIvAp5V3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6950.namprd11.prod.outlook.com (2603:10b6:510:226::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Wed, 5 Jul
 2023 11:34:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6565.016; Wed, 5 Jul 2023
 11:34:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAOlagIABiuaAgAAEHICAAB1gAIAEuVMAgAME8ICAABRuAA==
Date:   Wed, 5 Jul 2023 11:34:53 +0000
Message-ID: <ab3dea02892920cd6640a31a9c846afd6c6a9d54.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
         <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
         <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
         <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
         <20230630120650.GB2534364@hirez.programming.kicks-ass.net>
         <fdd81fbd2424d8da04f98d156668cad5e73c740b.camel@intel.com>
         <20230705102137.GX4253@hirez.programming.kicks-ass.net>
In-Reply-To: <20230705102137.GX4253@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6950:EE_
x-ms-office365-filtering-correlation-id: 41053bc9-d5c9-4d0f-9579-08db7d4bd9db
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t0aiC6BLkObZPLf9mo4WMd7rGRdJrTrp9brwIVNF5zriE6p23vvV3IvlCJNipZWfl3VmRlNwwmOUftfzHF682QQSlUAa/j15fuoMIUaTqCVZYD9EtSw371089lDGaLTrhetyLkiJe5MTQrXF9rs18iqoYtmBOPdzQxKdd9tsngK+qSOpivnTfOLLo0R8cLKd8lLLUM0RihAmQjXLcouPGlFiFUU9Sq/nAok4R2BrqmwRPmhSUe0b/KC7/6JySHQW9+494sA44Bk8ojAxWk0H2u9gunj1CMBIIBxIHwNbvkl98nVL52fmhQ74w7PyjWO8UDDLRI37wXz9wciXxkkUipSK4yovcSbDNRlrLU5MGbjMgIt+goFr995wQQCwrgxL3lhZhXiYFb1HVYOmjW4hlcx6OI7TF+OT7SHnRwx7/+VMQLnXDgbCzhwKNSkPZzWcDlAK1LoZ90QE3AdaKlKxYQG3q4Q0Pl+q4ekSayGjOPT5iHM/xkX3iXkcOB938fKIA5i1q1VgtjxUk46YZFRnzQEul2auROQb/uTxcC3LlFSiEThWxVHKHUXl5JHcLiJwsj8fzo6TsJVbpEN70qDipwjeq4X0M9kDYTvW76pvhghzhr+COvOHQYmePA/ftrwa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199021)(8936002)(8676002)(2906002)(2616005)(91956017)(76116006)(5660300002)(66899021)(6506007)(7416002)(26005)(186003)(41300700001)(122000001)(6486002)(82960400001)(71200400001)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(36756003)(316002)(83380400001)(6916009)(54906003)(38070700005)(478600001)(6512007)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGR2T3ZtWjQxcjZEeGhOZmIrWEhqdTlKaWRQUUxmc0wxSXNYQnhJZlhiQ0lV?=
 =?utf-8?B?Rk1IbWxoNk0rM2RGUmdzQ09UMDJhMFhISTJEcUJuOW51cTFidlBHYUFJalNI?=
 =?utf-8?B?dHFQN2Q3RUZGSUZTRHptSkxSa29LMS8yVFk5Sk9TVzlYR1RRS0l6REY3dG96?=
 =?utf-8?B?UWpXZlVUd3VQZWh0S3FVN3BwMHhiYi9kb2hCbkw5V3orcEtCdys2UVhxNnBt?=
 =?utf-8?B?YllpaS9ua0xucVRLQ1JJRmM4bmxIK3hvS1pWQ1llVFQ0SzZQZjZ2RHcxdTBY?=
 =?utf-8?B?dS95UE9kckF4Ylc3Tkl4TU92dW05Nzc4ZEE4a20xSHR4bUtoaEMvc0drNkcr?=
 =?utf-8?B?di9kTjlLRm5FZnJMdnNWUDlpUFJuK3l5cmR1OTZ6ZVg2STZjZE9yK3N5UmdJ?=
 =?utf-8?B?YWVlcnk2cngwNUNlVS90VVlsS01oblRlT3diS0RsSHBiQWRJVnpnV0wydzZp?=
 =?utf-8?B?WlBUckgzd2J4WmpZTUdDbzBRWTg5amRmaVNpaEdGdXcyMlZKVXZTSnRMRCtk?=
 =?utf-8?B?QldaME5oNnM3VzVMQlRpc1ZwQy9pWDR4SGc2Q3BhdWRKRlJFcEdYMVlFNlMz?=
 =?utf-8?B?Y202WG5pcEg3WlEwNjZYY0ZHYXFWd25nU1dzcWpTU1I0M3VoZnp1dUczNm5S?=
 =?utf-8?B?TXh3Zmx2VGZmcjJHTXlkV3dNVU5UaDBaYXJyYVEwUGdyaGdxZFVOdDNwOWI5?=
 =?utf-8?B?Q2dPTjNrMDhmZG5ERXFLZHltQThLcm51NmJQVGtJVUsxWjJiZ1NwNHN0WVNH?=
 =?utf-8?B?WTVBTlV2bXZrTFRrN1RwY0xCbW1oZU1ldzAvd01tK3E1cGR1QTNRVnpjMzFj?=
 =?utf-8?B?VnorR3cyL2gxeFZVNnZ1eFN4cnJXSXl3cStxeWJRemR4L0xUdHJXb0t6OXcz?=
 =?utf-8?B?eEZ4dkk4TFRlOUdRRjRoTFQ1SE42bkg4TkF6bkJDa0lWOVVMaW4yUVJyL29v?=
 =?utf-8?B?UTZ3TlNNUTlzYmlzZ1h6MG1adUc2Qm9UZmFPVExMb0EwbWVpOWJmT3VFdDFi?=
 =?utf-8?B?SGJQRHBSc2duY250Sy9NNHo2eURmNjdWVlZ1Y2t2MGFxZlpQbUxVMlYwbmtH?=
 =?utf-8?B?aTNHdFNJRDY2U1BkeHBwS0VGcFBMY3FxV1A4clBQdHdyNTU2a01peCs3QzhK?=
 =?utf-8?B?UTloM0RjT0twQ2pJUmVneDIzOVhLYURaUFhicnQ2TFlUbUdsTEhoajlnelpm?=
 =?utf-8?B?c3RnMjA3dmorQ2tDYVlQVk9mY1MrTDVOMkRreHgvdXdEVW1mUitNV0VUdVZT?=
 =?utf-8?B?clZPbzF2ZzNwMkFJNHlLZjlhS2tNWGVvOGJGTTc2WTBqeXRaU1ZqZmRiaXFR?=
 =?utf-8?B?V0E2c2Rnblc2TWVCbEI1OFgzczA4VVBnb3ZaR2puUVA5NW1taGRqTDBhZC9n?=
 =?utf-8?B?MHAwNGR1TTdKYkpHS2FqQzE1eUp0UUwwWGZqb2U0SG50YUlJODIxVGw5aGlT?=
 =?utf-8?B?T0U0bXozYlhrdnQxckZNMmRtOUlYK1kzZEhYU1IrbVNJK1c1NUxoQ0ZjREpH?=
 =?utf-8?B?dTJFSm9PcjhlWXEvdUtLOENoZnY0b2tuTGhhMzllaXltVkp3Y0ZORVk2OXM5?=
 =?utf-8?B?MDA1eGVXWFNGNFQxaHArY2hHZkJOSVIyWUZPTEZ2N0VaZzNuV1dlVisxYXlh?=
 =?utf-8?B?QjYyTU5SdnhPZFoyNllOaXArRjE4MUppMGIxWkpLSERSVUdYd212SXFrS0Fn?=
 =?utf-8?B?eVQ3d2VkYm05c0lpdGJvMlh5REovVlhsT2NyNytWRzZTQTk0SzJMUGU0OXVk?=
 =?utf-8?B?NFJuZkk0RTRMSHNmeGttWXhjOVRNQ3lOVk1FRVdpU1RYMHp4WWFzU29XOUc3?=
 =?utf-8?B?QTB4eUtVbDB1KzRNQURabktwVk90UGJMRHI0RWJLK0NjM25hZ1RxT1ZMWC81?=
 =?utf-8?B?K3Y1Q0RPZW1hdUtaRWpNeU9MVEozaEJEdFNONk1hTHBuTjJjMDZGNWR2Z3Yx?=
 =?utf-8?B?d0FzR0JyQk92bHBIWHpxWUxLcGREMUpmOFc0T0V5VlFxc0ttNlNiYUY5bUg2?=
 =?utf-8?B?TXBaRXllSGZFWk9kQ1o4MlZkS25VK1FoYW9OSUpseVhFTlVON1ZLbW1LdWcx?=
 =?utf-8?B?UGY5UDVudUlmNFEzQVNkQ0ZtWTRwNmsvNDNIaDhzRlN1K0JmbmNwY1RUaEhJ?=
 =?utf-8?Q?8LglOg2Y6s/E2BYrVbzwQBOAW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A47E43567375D44B03FB0211E60E014@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41053bc9-d5c9-4d0f-9579-08db7d4bd9db
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 11:34:53.3541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5eHdUF54jqLCT9LIKEFegJFkTwjhUAKB4Ps4gy6beSI8WxwmNWuJwuvxA9QgOncy7D5VCx7FXVlpfYRz/5xTLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6950
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA3LTA1IGF0IDEyOjIxICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gTW9uLCBKdWwgMDMsIDIwMjMgYXQgMTI6MTU6MTNQTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiANCj4gPiA+IA0KPiA+ID4gU28gSSB0aGluayB0aGUgYmVsb3cgZGVhbHMgd2l0
aCBldmVyeXRoaW5nIGFuZCB1bmlmaWVzIF9fdGR4X2h5cGVyY2FsbCgpDQo+ID4gPiBhbmQgX190
ZHhfbW9kdWxlX2NhbGwoKSwgc2luY2UgYm90aCBzaWRlcyBuZWVkcyB0byBkZWFsIHdpdGggZXhh
Y3RseSB0aGUNCj4gPiA+IHNhbWUgdHJhaW53cmVjay4NCj4gPiANCj4gPiBIaSBQZXRlciwNCj4g
PiANCj4gPiBKdXN0IHdhbnQgdG8gbWFrZSBzdXJlIEkgdW5kZXJzdGFuZCB5b3UgY29ycmVjdGx5
Og0KPiA+IA0KPiA+IFlvdSB3YW50IHRvIG1ha2UgX190ZHhfbW9kdWxlX2NhbGwoKSBsb29rIGxp
a2UgX190ZHhfaHlwZXJjYWxsKCksIGJ1dCBub3QgdG8NCj4gPiB1bmlmeSB0aGVtIGludG8gb25l
IGFzc2VtYmx5IChhdCBsZWFzdCBmb3Igbm93KSwgcmlnaHQ/DQo+IA0KPiBXZWxsLCBnaXZlbiB0
aGUgaG9ycmVuZG91cyB0cmFpbndyZWNrIHRoaXMgaXMgYWxsIHR1cm5pbmcgaW50bywgSQ0KPiB0
aHJvdWdoIGl0IHBydWRlbnQgdG8gaGF2ZSBpdCBhbGwgaW4gYSBzaW5nbGUgcGxhY2UuIFRoZSBt
b21lbnQgeW91IGdvDQo+IHBsYXkgZ2FtZXMgd2l0aCBjYWxsZWUtc2F2ZWQgcmVnaXN0ZXJzIHlv
dSdyZSByZWFsbHkgY2xvc2UgdG8gd2hhdA0KPiBoeXBlcmNhbGwgZG9lcyBzbyB0aGVuIHRoZXkg
bWlnaHQgYXMgd2VsbCBiZSB0aGUgc2FtZS4NCg0KT0sgSSB1bmRlcnN0YW5kIHlvdSBub3cuICBU
aGFua3MuDQoNClllYWggSSB0aGluayBmcm9tIGxvbmctdGVybSdzIHZpZXcsIHNpbmNlIFNFQU1D
QUxMcyB0byBzdXBwb3J0IGxpdmUgbWlncmF0aW9uDQpwcmV0dHkgbXVjaCB1c2VzIGFsbCBSQ1gv
UkRYL1I4LVIxNSBhcyBpbnB1dC9vdXRwdXQsIGl0IHNlZW1zIHJlYXNvbmFibGUgdG8NCnVuaWZ5
IGFsbCBvZiB0aGVtLCBhbHRob3VnaCBJIGd1ZXNzIHRoZXJlIG1pZ2h0IGJlIHNvbWUgc3BlY2lh
bCBoYW5kbGluZyB0bw0KVlAuVk1DQUxMIGFuZC9vciBWUC5FTlRFUiwgZS5nLiwgYmVsb3c6DQoN
CiAgICAgICAgLyogVERWTUNBTEwgbGVhZiByZXR1cm4gY29kZSBpcyBpbiBSMTAgKi8gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgbW92cSAlcjEwLCAlcmF4DQoNClNvIGxv
bmctdGVybWx5LCBJIGRvbid0IGhhdmUgb2JqZWN0aW9uIHRvIHRoYXQuICBCdXQgbXkgdGhpbmtp
bmcgaXMgZm9yIHRoZQ0KZmlyc3QgdmVyc2lvbiBvZiBURFggaG9zdCBzdXBwb3J0LCB3ZSBkb24n
dCBoYXZlIHRvIHN1cHBvcnQgYWxsIFNFQU1DQUxMcyBidXQNCm9ubHkgdGhvc2UgaW52b2x2ZWQg
aW4gYmFzaWMgVERYIHN1cHBvcnQuICBUaG9zZSBTRUFNQ0FMTHMgKGV4Y2VwdCBWUC5FTlRFUikN
Cm9ubHkgdXNlcyBSQ1gvUkRYL1I4L1I5IGFzIGlucHV0IGFuZCBSQ1gvUkRYL1I4LVIxMSBhcyBv
dXRwdXQsIHNvIHRvIG1lIGl0IGxvb2tzDQpmaW5lIHRvIG9ubHkgbWFrZSBfX3RkeF9tb2R1bGVf
Y2FsbCgpIGxvb2sgbGlrZSBfX3RkeF9oeXBlcmNhbGwoKSBhcyB0aGUgZmlyc3QNCnN0ZXAuDQoN
CkFsc28sIHRoZSBuZXcgU0VBTUNBTExzIHRvIGhhbmRsZSBsaXZlIG1pZ3JhdGlvbiBhbGwgc2Vl
bSB0byBoYXZlIGJlbG93DQpzdGF0ZW1lbnQ6DQoNCglBVlgsIEFWWDIJTWF5IGJlIHJlc2V0IHRv
IHRoZSBhcmNoaXRlY3R1cmFsIElOSVQgc3RhdGUNCglhbmQNCglBVlg1MTINCglzdGF0ZQ0KDQpX
aGljaCBtZWFucyB0aG9zZSBTRUFNQ0FMTHMgbmVlZCB0byBwcmVzZXJ2ZSBBVlgqIHN0YXRlcyB0
b28/DQoNCkFuZCByZWFkaW5nIHRoZSBzcGVjLCB0aGUgVlAuVk1DQUxMIGFuZCBWUC5FTlRFUiBh
bHNvIGNhbiB1c2UgWE1NMCAtIFhNTTE1IGFzDQppbnB1dC9vdXRwdXQuICBMaW51eCBWUC5WTUNB
TEwgc2VlbXMgZG9lc24ndCBzdXBwb3J0IHVzaW5nIFhNTTAgLSBYTU0xNSBhcw0KaW5wdXQvb3V0
cHV0LCBidXQgS1ZNIGNhbiBydW4gb3RoZXIgZ3Vlc3QgT1NlcyB0b28gc28gSSB0aGluayBLVk0g
VlAuRU5URVIgbmVlZHMNCnRvIGhhbmRsZSBYTU0wLVhNTTE1IGFzIGlucHV0L291dHB1dCB0b28u
DQoNClRoYXQgYmVpbmcgc2FpZCwgSSB0aGluayBhbHRob3VnaCB3ZSBjYW4gcHJvdmlkZSBhIGNv
bW1vbiBhc20gbWFjcm8gdG8gY292ZXINClZQLkVOVEVSLCBJIHN1c3BlY3QgS1ZNIHN0aWxsIG5l
ZWRzIHRvIGRvIGFkZGl0aW9uYWwgYXNzZW1ibHkgYXJvdW5kIHRoZSBtYWNybw0KdG9vLiAgU28g
SSBhbSBub3Qgc3VyZSB3aGV0aGVyIHdlIHNob3VsZCB0cnkgdG8gY292ZXIgVlAuRU5URVIuDQoN
CkFuZCBJIGRvbid0IHdhbnQgdG8gc3BlYWsgZm9yIEtWTSBtYWludGFpbmVycy4gOikNCg0KSGkg
U2Vhbi9QYW9sbywgZG8geW91IGhhdmUgYW55IGNvbW1lbnRzIGhlcmU/DQoNCj4gDQo+ID4gSSBh
bSBjb25mdXNlZCB5b3UgbWVudGlvbmVkIFZQLlZNQ0FMTCBiZWxvdywgd2hpY2ggaXMgaGFuZGxl
ZCBieQ0KPiA+IF9fdGR4X2h5cGVyY2FsbCgpLg0KPiANCj4gQnV0IHdoeT8gSXQgcmVhbGx5IGlz
bid0ICp0aGF0KiBzcGVjaWFsIGlmIHlvdSBjb25zaWRlciB0aGUgb3RoZXIgY2FsbHMNCj4gdGhh
dCBhcmUgdXNpbmcgY2FsbGVlLXNhdmVkIHJlZ3MsIHllcyBpdCBoYXMgdGhlIHJkaS9yc2kgZXh0
cmEsIGJ1dCBtZWgsDQo+IGl0IHJlYWxseSBqdXN0IGlzIHRkY2FsbC0wLg0KDQpBcyBtZW50aW9u
ZWQgYWJvdmUgSSBkb24ndCBoYXZlIG9iamVjdGlvbiB0byB0aGlzIDopDQoNCj4gDQo+IA0KPiA+
ID4gICotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gPiAgKiBURENBTEwvU0VBTUNBTEwgQUJJOg0KPiA+
ID4gICotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gPiAgKiBJbnB1dCBSZWdpc3RlcnM6DQo+ID4gPiAg
Kg0KPiA+ID4gICogUkFYICAgICAgICAgICAgICAgICAtIExlYWYgbnVtYmVyLg0KPiA+ID4gICog
UkNYLFJEWCxSOC1SMTEgICAgICAtIExlYWYgc3BlY2lmaWMgaW5wdXQgcmVnaXN0ZXJzLg0KPiA+
ID4gICogUkRJLFJTSSxSQlgsUjExLVIxNSAtIFZQLlZNQ0FMTCBWUC5FTlRFUg0KPiA+ID4gICoN
Cj4gPiA+ICAqIE91dHB1dCBSZWdpc3RlcnM6DQo+ID4gPiAgKg0KPiA+ID4gICogUkFYICAgICAg
ICAgICAgICAgICAtIGluc3RydWN0aW9uIGVycm9yIGNvZGUuDQo+ID4gPiAgKiBSQ1gsUkRYLFI4
LVIxMSAgICAgIC0gTGVhZiBzcGVjaWZpYyBvdXRwdXQgcmVnaXN0ZXJzLg0KPiA+ID4gICogUkRJ
LFJTSSxSQlgsUjEyLVIxNSAtIFZQLlZNQ0FMTCBWUC5FTlRFUg0KPiA+IA0KPiA+IEFzIG1lbnRp
b25lZCBhYm92ZSwgVlAuVk1DQUxMIGlzIGhhbmRsZWQgYnkgX190ZHhfaHlwZXJjYWxsKCkuICBB
bHNvLCBWUC5FTlRFUg0KPiA+IHdpbGwgYmUgaGFuZGxlZCBieSBLVk0ncyBvd24gYXNzZW1ibHku
ICBUaGV5IGJvdGggYXJlIG5vdCBoYW5kbGVkIGluIHRoaXMNCj4gPiBURFhfTU9EVUxFX0NBTEwg
YXNzZW1ibHkuDQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoZXkgc2hvdWxkIGJlIHNwZWNpYWwsIHRo
ZXkncmUgcmVhbGx5IGp1c3QgeWV0IGFub3RoZXINCj4gbGVhZiBjYWxsLiBZZXMsIHRoZXkgaGF2
ZSBhIHNoaXQgY2FsbGluZyBjb252ZW50aW9uLCBhbmQgeWVzIFZQLkVOVEVSIGlzDQo+IHRlcm1p
bmFsbHkgYnJva2VuIGZvciB1bmNvbmRpdGlvbmFsbHkgY2xvYmJlcmluZyBCUCA6LSgNCj4gDQo+
IFRoYXQgcmVhbGx5ICptdXN0KiBiZSBmaXhlZC4NCg0KU3VyZSBJIGRvbid0IGhhdmUgb2JqZWN0
aW9uIHRvIHRoaXMsIGFuZCBmb3IgVlAuRU5URVIgcGxlYXNlIHNlZSBhYm92ZS4NCg0KQnV0IEkn
ZCBsaWtlIHRvIHNheSB0aGF0LCBnZW5lcmFsbHkgc3BlYWtpbmcsIGZyb20gdmlydHVhbGl6YXRp
b24ncyBwb2ludCBvZg0KdmlldywgZ3Vlc3QgaGFzIGl0cyBvd24gQlAgYW5kIGNvbmNlcHR1YWxs
eSB0aGUgaHlwZXJ2aXNvciBuZWVkcyB0byByZXN0b3JlDQpndWVzdCdzIEJQIGJlZm9yZSBqdW1w
aW5nIHRvIHRoZSBndWVzdC4gIEUuZy4sIGZvciBub3JtYWwgVk1YIGd1ZXN0LCBLVk0gYWx3YXlz
DQpyZXN0b3JlcyBndWVzdCdzIEJQIGJlZm9yZSBWTUVOVEVSIChhcmNoL3g4Ni9rdm0vdm14L3Zt
ZW50ZXIuUyk6DQoNClNZTV9GVU5DX1NUQVJUKF9fdm14X3ZjcHVfcnVuKQ0KICAgICAgICBwdXNo
ICVfQVNNX0JQDQogICAgICAgIG1vdiAgJV9BU01fU1AsICVfQVNNX0JQDQoJDQoJLi4uDQoJbW92
IFZDUFVfUkJQKCVfQVNNX0FYKSwgJV9BU01fQlANCgkuLi4NCgl2bWVudGVyL3ZtcmVzdW1lDQoJ
Li4uDQpTWU1fSU5ORVJfTEFCRUwodm14X3ZtZXhpdCwgU1lNX0xfR0xPQkFMKQ0KCS4uLi4uDQoJ
bW92ICVfQVNNX0JQLCBWQ1BVX1JCUCglX0FTTV9BWCkNCgkuLi4NCglwb3AgJV9BU01fQlANCiAg
ICAgICAgUkVUDQoNCj4gDQo+ID4gPiAuTGNhbGw6DQo+ID4gPiAuaWYgXGhvc3QNCj4gPiA+IAlz
ZWFtY2FsbA0KPiA+ID4gCS8qDQo+ID4gPiAJICogU0VBTUNBTEwgaW5zdHJ1Y3Rpb24gaXMgZXNz
ZW50aWFsbHkgYSBWTUV4aXQgZnJvbSBWTVggcm9vdA0KPiA+ID4gCSAqIG1vZGUgdG8gU0VBTSBW
TVggcm9vdCBtb2RlLiAgVk1mYWlsSW52YWxpZCAoQ0Y9MSkgaW5kaWNhdGVzDQo+ID4gPiAJICog
dGhhdCB0aGUgdGFyZ2V0ZWQgU0VBTSBmaXJtd2FyZSBpcyBub3QgbG9hZGVkIG9yIGRpc2FibGVk
LA0KPiA+ID4gCSAqIG9yIFAtU0VBTUxEUiBpcyBidXN5IHdpdGggYW5vdGhlciBTRUFNQ0FMTC4g
UkFYIGlzIG5vdA0KPiA+ID4gCSAqIGNoYW5nZWQgaW4gdGhpcyBjYXNlLg0KPiA+ID4gCSAqLw0K
PiA+ID4gCWpjCS5Mc2VhbWZhaWwNCj4gPiA+IA0KPiA+ID4gLmlmIFxzYXZlZCAmJiBccmV0DQo+
ID4gPiAJLyoNCj4gPiA+IAkgKiBWUC5FTlRFUiBjbGVhcnMgUlNJIG9uIG91dHB1dCwgdXNlIGl0
IHRvIHJlc3RvcmUgc3RhdGUuDQo+ID4gPiAJICovDQo+ID4gPiAJcG9wcQklcnNpDQo+ID4gPiAJ
eG9yCSVlZGksJWVkaQ0KPiA+ID4gCW1vdnEJJXJkaSwgVERYX01PRFVMRV9yZGkoJXJzaSkNCj4g
PiA+IAltb3ZxCSVyZGksIFREWF9NT0RVTEVfcnNpKCVyc2kpDQo+ID4gPiAuZW5kaWYNCj4gPiA+
IC5lbHNlDQo+ID4gPiAJdGRjYWxsDQo+ID4gPiANCj4gPiA+IAkvKg0KPiA+ID4gCSAqIFJBWCE9
MCBpbmRpY2F0ZXMgYSBmYWlsdXJlLCBhc3N1bWUgbm8gcmV0dXJuIHZhbHVlcy4NCj4gPiA+IAkg
Ki8NCj4gPiA+IAl0ZXN0cQklcmF4LCAlcmF4DQo+ID4gPiAJam5lCS5MZXJyb3INCj4gPiANCj4g
PiBGb3Igc29tZSBTRUFNQ0FMTC9URENBTEwgdGhlIG91dHB1dCByZWdpc3RlcnMgbWF5IGNvbnRh
aW4gYWRkaXRpb25hbCBlcnJvcg0KPiA+IGluZm9ybWF0aW9uLiAgV2UgbmVlZCB0byBqdW1wIHRv
IGEgbG9jYXRpb24gd2hlcmUgd2hldGhlciByZXR1cm5pbmcgdGhvc2UNCj4gPiBhZGRpdGlvbmFs
IHJlZ3MgdG8gJ3N0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MnIGRlcGVuZHMgb24gXHJldC4NCj4gDQo+
IEkgc3VwcG9zZSB3ZSBjYW4gbW92ZSB0aGlzIGludG8gdGhlIGJlbG93IGNvbmRpdGlvbmFsIDot
KCBUaGUgW0RTXUkNCj4gcmVnaXN0ZXIgc3R1ZmYgcmVxdWlyZXMgYSBzY3JhdGNoIHJlZyB0byBy
ZWNvdmVyLCBBWCBiZWluZyB6ZXJvIHByb3ZpZGVzDQo+IHRoYXQuDQoNClllYWggdGhpcyBjYW4g
Y2VydGFpbmx5IGJlIGRvbmUgaW4gb25lIHdheSBvciBhbm90aGVyLg0KDQo+IA0KPiA+ID4gLmlm
IFxzYXZlZCAmJiBccmV0DQo+ID4gPiAJLyoNCj4gPiA+IAkgKiBTaW5jZSBSQVg9PTAsIGl0IGNh
biBiZSB1c2VkIGFzIGEgc2NyYXRjaCByZWdpc3RlciB0byByZXN0b3JlIHN0YXRlLg0KPiA+ID4g
CSAqDQo+ID4gPiAJICogWyBhc3N1bWVzIFxzYXZlZCBpbXBsaWVzIFxyZXQgXQ0KPiA+ID4gCSAq
Lw0KPiA+ID4gCXBvcHEJJXJheA0KPiA+ID4gCW1vdnEJJXJkaSwgVERYX01PRFVMRV9yZGkoJXJh
eCkNCj4gPiA+IAltb3ZxCSVyc2ksIFREWF9NT0RVTEVfcnNpKCVyYXgpDQo+ID4gPiAJbW92cQkl
cmF4LCAlcnNpDQo+ID4gPiAJeG9yCSVlYXgsICVlYXg7DQo+ID4gPiAuZW5kaWYNCj4gPiA+IC5l
bmRpZiAvLyBcaG9zdA0KPiANCj4gU28gdGhlIHJlYXNvbiBJIHdhbnQgdGhpcywgaXMgdGhhdCBJ
IGZlZWwgdmVyeSBzdHJvbmdseSB0aGF0IGlmIHlvdQ0KPiBjYW5ub3Qgd3JpdGUgYSBzaW5nbGUg
Y29oZXJlbnQgd3JhcHBlciBmb3IgYWxsIHRoaXMsIGl0cyBjYWxsaW5nDQo+IGNvbnZlbnRpb24g
aXMgZnVuZGFtZW50YWxseSAqdG9vKiBjb21wbGV4IC8gYnJva2VuLg0KDQpJbiBnZW5lcmFsIEkg
YWdyZWUsIGJ1dCBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhlcmUncyBhbnkgZGV0YWlsIGhvbGRp
bmcgdXMNCmJhY2suICA6KQ0KDQo=
