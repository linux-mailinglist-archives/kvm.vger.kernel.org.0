Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3563B4B1
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiK1WN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiK1WNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:13:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7E7B1EA;
        Mon, 28 Nov 2022 14:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669673605; x=1701209605;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=L5G18QTNwrzjrl6MzL4mmBpbIY87NqG53mxawqphLf0=;
  b=hAmdWy72B2DGOEdn+e8RyAm7QIcP2zT2eonowt7I9qD5UuPw9hhvAU8q
   egDkEKaVWprr0WjM56shZybTHCcWCSFitVF41d3xGFDlBMM51fEAxMz5B
   nl9d7KchVNhJWYqWTVNDGKygXm5xsRIUDD7TNAdeflJN4SmJ42YcS5s9q
   27MlmB5uMaj7xHXyRUIyrzQ4VMYunT1GLvDyuRTVirHi06K6RPWMCT8I3
   HCvC18b9DUkvxJ32F5NwQsMEy9OAANRX8kvNQpmfZ2iT01lVHdyyko+/S
   aIvW9QlzcF9l3LDCPGrPbSk0OPHzHiXvFSKeIFVdwWddjwJ1EwZ/ECqBw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="341876820"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="341876820"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:13:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732313652"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732313652"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Nov 2022 14:13:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:13:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 14:13:24 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 14:13:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAV8WRcijpStlpZjHpxP79Xy/ZAG6jBquA2sP1lpfuuKPAO8G80vWJvjwoFI9FwHJYvCi71y/IrZU7Qtj4Chs1b3dKm5DxeZa10gjfimiZCzl/9UKyR49l/6TYGtyScuo5YlpD5NzePaV90/5gMDri416d0xcvCUci7ZRrDWZrym+GU0sHExpDIu0/g+PrZ5ejH0L+bMmfJMSLAD7UeZqrTFRVmwNQrmnOV0PvAt5AlfYd8xlFRe7ctsjBelN4NtDTDOGs3W2bXSsQ/Um79KSxYxz/78TWmSM6LWwBd8d45IP1hf0WD0G2uMsKvvt8M439Ku3THZzpqYimD2D2YLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5G18QTNwrzjrl6MzL4mmBpbIY87NqG53mxawqphLf0=;
 b=QrxZwHwbk87hnzo1uP4CMtMkW2Jdkr8R48IKA6EMsHGzbGoZ+OrfzJJgazQgmGsBpLirqFLgxB9/hVSiBFcFhwRPqEpgxGo6KEx1i0Jb1D9LpgtLNW8lLRkLbm4YhT/RXJCKUw8u7+3KyQRqdI70gN4zNTHEU+kIvor3ME9YOOxUxHURYmCjQqOufq/+d3x8nzlI8+Y8PDd+M689ez/QBxO3pwUvHNTfyYsWkdliTPorXE7b8LN/UiVnHnTfjXWHUlNBRNPgGUp+cHPQYYyf4t5G+TRHB+c/grheM+/8qrm287I/Wz+MchYyP7L3R7ToHhkw22gF6wpyXg213QUGnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6063.namprd11.prod.outlook.com (2603:10b6:8:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 22:13:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 22:13:19 +0000
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
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY/T3ORWilVlKW4kyc0A5kdGk0eq5NGDiAgADmkYCABotngIAAaI+A
Date:   Mon, 28 Nov 2022 22:13:18 +0000
Message-ID: <60deb2ffe15e71bc91727aa04298c79f21a58c83.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
         <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
         <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
         <9a653cd2-70df-8c55-ac7d-5ddcb3b18b0c@intel.com>
In-Reply-To: <9a653cd2-70df-8c55-ac7d-5ddcb3b18b0c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6063:EE_
x-ms-office365-filtering-correlation-id: 301d7def-2285-435e-e2cb-08dad18dc13e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NQfyyeA1qt2MjTsP9dNrVlSh83W0VK24xi8LDINaeFOOoQkRB085nPk7f9kGI6bZZHv6SyKAaf6MEwz7DroPFP48+ciF2MMGRimyINaps/y7kgRObj7tGaUiVk0V61VbM8J8WEFExxHTD1rie576aK1uWp4loNTvydxsQusSPVgyLaOwjyLrpjgED2tP3y2baAG9ilMFN6abP++jXq+UMnXvtKzbXNwVVwhu0HaSLg/Pv+MpP7vx4iQMQlJEYxee0dFVToSO0Qx0WrScZnp2by0TkUV28ZveqTu24zPp/4rJSylwLx3rg4dXrPF/760gzjzcu30f+c2ohevEa1jqa6Z4RXnTw77vrv1ye/e2JvVdUiVMpZwpfbY7mCWzjJOwp3NvwUBjGyFLf0ECqznhv93MzKqibSvOaqjAsVIfTjMVAUbIb4Bvpb7BEVfG3ZcxIZNASlo8TgRMCIYfSE8M+fP4kXAz0I+7VbpioZUlYqsU46plf3Y9viAPhE63Iy3RUpOxZ4WEdwTAyZBU0+bETBPzOXCZhOuQ1Kr7MQjB+yoVgY75wthjwzcKoSpNq467rwpX7LPjddOGUNuKfVCTyYEcXbE8hoVN/X7ZpUwU4RljoQumlkl+l8u3G2+qGmde1s3uOHvKpXTHPOCPc9dqI/xVSsLfstG4+D/KGWU/3XR+zcMtHLy+OOhC2btyTYLmtywfkPkn21OtDfK99gs4q0nqi5uyFe28YTndYv4ByVk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(6506007)(186003)(41300700001)(82960400001)(38100700002)(8936002)(5660300002)(91956017)(53546011)(7416002)(36756003)(2616005)(122000001)(6512007)(26005)(38070700005)(966005)(6486002)(110136005)(86362001)(316002)(71200400001)(66476007)(478600001)(54906003)(4326008)(66946007)(66446008)(76116006)(64756008)(8676002)(66556008)(83380400001)(2906002)(4001150100001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azdRT2ZTZnlXWHRzWm1ScGxOdmFoZFVTbSsxNHlvaHVQd0tRZm04OTducWFa?=
 =?utf-8?B?N2ZOb0hkZFN2czFPUzhnSGRpbURqSXB3OGtrVEJ2cWtwY0gvUkxWMlRLQ0dX?=
 =?utf-8?B?ZkRIRFVudmVjb3ZkZ1NPYkxvbkJQdVVpZWtTZGx0MHliUjF4dWc3akZIdXRL?=
 =?utf-8?B?K0RoL3dEQmpUV3FRekp1OFIxcGtzaU1VTDNlTHRucGlML1ozZmhBMlFZVVoz?=
 =?utf-8?B?ZXR1UkJJNDJhY3NVbEo1WmlVZ1JrV2hiUFFLN1hVM1pseUZHejd3MnNkb0M5?=
 =?utf-8?B?bHVzTFArRDAydDh1aHMxNGR2NCtzTXlxb2cvQU5sN1NZMm5KOTAyTWtQSUIr?=
 =?utf-8?B?OXBDbStac0o1UWlnLytvVkFhaVFVeEtrTTd2Z1hLVnN6UjcwWWlhN1g3V3Vq?=
 =?utf-8?B?cm5uQmUySlk2aHBXeEx1dVM1dGkyMWgxWGlEVG10WnVOVHNEbnpmZHRzVFow?=
 =?utf-8?B?b1k0WWsxZG43MStKUU1kZFo0WS9NMXhWM2pCQ3dGWEF5N3ZycHJBZ3Q2VjJG?=
 =?utf-8?B?cG0xMEExSE03SXVFbjVJdm1MaFlNVjVNcmxKeUlhTkcvKzc4M2w5RjJGTEhV?=
 =?utf-8?B?YlFYRDBDeXcwN2ppWS8rU1hhNHp5N3M3bU1RNmw3UWJGQlllN3gxVWttd0FB?=
 =?utf-8?B?VWl0dkI4ZGV5N2t0L2VlK2l5THU5cTdkUU9meUtoS2NHa0QvZWFGMlQvODM2?=
 =?utf-8?B?U0hiQWVGZkdyOTRhaklnMWQyd29RdzNFaFgwMnRyUWloekRyZEgvU1FvcWJC?=
 =?utf-8?B?bXUrR1FPRWMzRzB3WlllSFZsOWNQZ3RNTENqWHRXS3NwdGtpMGRmRHpKcHV0?=
 =?utf-8?B?TFVNRjFtSC9PbmFuZXRiWkZmMjFLYnE1c05WY2psQ01mTXhTSysxSGtYb21V?=
 =?utf-8?B?YjJuVkZVNERTdWVrbk9tWVhsZXNBWHEvVFduVG1BSlN3NkJ3T3gvNjBiMTds?=
 =?utf-8?B?b0U0cjJLbExHKzFqN3BKS2Z1dFZkN0VBUkl0VWRHUXNMdUh2OUpyMzRJTytk?=
 =?utf-8?B?RXdZTVlUM1JLWjcvZEQ2c3Z6ZXhPWWExMFMyeFNvMld1bXpFUG03eTR6ZjBv?=
 =?utf-8?B?S05OZkVhbURZOXpTeTdJa0tFaVNRQnQraVJSMStDeS9xeUNsK3hEL0pOUXpZ?=
 =?utf-8?B?bFMvTHZ1VTlOTHZ3V21nTHJ4YlpoNFV4NVNsNDBoOHBVaytwSnoyNSsvOENa?=
 =?utf-8?B?RGRYTnBsYUlUWmRtTVlRaFlNakhwSDk5MmExYTV4b0N3dEQrZkxXeFZBdkJj?=
 =?utf-8?B?SDNJbFg3UWdJZzMwbWxleEt6TjJZR2gxUzhkWGI1SGJlTU9kYmhXbWVYZS9v?=
 =?utf-8?B?RDZCUGZSclRJcWhEd3RiTlpvV2pQQnJiV2x5L254czRFTFJXZSt0SzJ0b21r?=
 =?utf-8?B?UDVhWGxjNmVEcHN2V3FSa1M4QUU3azZPeHRQRjZieUxMeW5VUEZOSVZQeVhr?=
 =?utf-8?B?YUhyMkNyKzc1dEZ1ZW5IWC9KQkl4NWljN0NlcW9uNnQwR0cxZmYvWnNvVkcz?=
 =?utf-8?B?Nm1EMEs5YTR5UEpEajBKbXp6eStoRXhtbkdCZlpWY3FoRjk5aWkwZk9NMlJx?=
 =?utf-8?B?S1llejRSeUIva2hPb3FrTkNBTmNVZHBHYlR6TkZoWldZaTNiTDI0OGdEcHJ6?=
 =?utf-8?B?a3hxdzRZbUg5TFhnSWVISFlLOUFSWW8xcHhTZXRoWE1FT0QzYWdoZzRLZjZD?=
 =?utf-8?B?TGkrb1M2RC8rbHl0V2pGYlgrNU1PNi9yZEptcStYdHhwY1B4bUZYakJYSkpW?=
 =?utf-8?B?K01qSGhVME5rc2ljRFg5NUsvY2pqMGxxMThLMGhhR1VBcU9VbW5QSHVWSllU?=
 =?utf-8?B?dTdEUjVHTmNnNWx2a2w0UUFUaUROS09QdytzTVkveDdXSCt1MFJPV1lTYkIx?=
 =?utf-8?B?RVN4SzdxMG1aeWd6WUVyc0FkQjlSVi81NXBIQVZYMnhFT1JpeElYSkdTRWVQ?=
 =?utf-8?B?QzhHUk5uaVJZKzR6ZmFJMW9TY0hEdStDeFJGMTBwbGpNT1VVSmpka0hLKzBz?=
 =?utf-8?B?YXRnaVdFamdKek9iSjdrelJUeTdNWDVKdEJIaWdBdEgzKzMrZXE3RmR6NkdG?=
 =?utf-8?B?eEpPeGJjbE1LeHArRUtIZ0pHUnZRaVJNVWxEUUR3cVdaNysrTXJrQmZ3Mk9x?=
 =?utf-8?B?RHUzME5PUWtKSm9KWlY4RW42YlZkOVJxU01vMlBiQTRQU3hiaWMvd1RTT1ZJ?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <312D910D9577E045BA4D1B134E4F9E7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301d7def-2285-435e-e2cb-08dad18dc13e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 22:13:18.8751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 21hwpZN7Bdv4O3RTgwdXib4+g/JevpBe2Z1tqK1XURxCp9GsMJ0uJT+2bGf4CoStnD8cfnV4wi1LCcyg9WA3Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6063
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDA3OjU5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjQvMjIgMDQ6MDIsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gV2VkLCAyMDIyLTEx
LTIzIGF0IDE0OjE3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiA+IEZpcnN0LCBJIHRo
aW5rICd0ZHhfc3lzaW5mbycgc2hvdWxkIHByb2JhYmx5IGJlIGEgbG9jYWwgdmFyaWFibGUgaW4N
Cj4gPiA+IGluaXRfdGR4X21vZHVsZSgpIGFuZCBoYXZlIGl0cyBhZGRyZXNzIHBhc3NlZCBpbiBo
ZXJlLiAgSGF2aW5nIGdsb2JhbA0KPiA+ID4gdmFyaWFibGVzIGFsd2F5cyBtYWtlcyBpdCBtb3Jl
IG9wYXF1ZSBhYm91dCB3aG8gaXMgaW5pdGlhbGl6aW5nIGl0Lg0KPiA+IFNvcnJ5IEkgbWlzc2Vk
IHRvIHJlc3BvbmQgdGhpcy4NCj4gPiANCj4gPiBVc2luZyBsb2NhbCB2YXJpYWJsZSBmb3IgJ3Rk
eF9zeXNpbmZvJyB3aWxsIGNhdXNlIGEgYnVpbGQgd2FybmluZzoNCj4gPiANCj4gPiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9sa21sL2E2Njk0YzgxYjRlOTZhMjI1NTdmZDBhZjcwYTgxYmQyYzJl
NGUzZTcuY2FtZWxAaW50ZWwuY29tLw0KPiANCj4gSGF2aW5nIGl0IGJlIGxvY2FsIHNjb3BlIGlz
IGEgbG90IG1vcmUgaW1wb3J0YW50IHRoYW4gaGF2aW5nIGl0IGJlIG9uDQo+IHN0YWNrLiAgSnVz
dCBkZWNsYXJlIGl0IGxvY2FsIHRvIHRoZSBmdW5jdGlvbiBidXQga2VlcCBpdCBvZmYgdGhlIHN0
YWNrLg0KPiAgTm8gbmVlZCB0byBkeW5hbWljYWxseSBhbGxvY2F0ZSBpdCwgZXZlbi4NCg0KQXBv
bG9naXplIEkgYW0gbm90IGVudGlyZWx5IHN1cmUgd2hldGhlciBJIGZ1bGx5IGdvdCB5b3VyIHBv
aW50LiAgRG8geW91IG1lYW4NCnNvbWV0aGluZyBsaWtlIGJlbG93Pw0KDQpzdGF0aWMgc3RydWN0
IHRkc3lzaW5mb19zdHJ1Y3QgdGR4X3N5c2luZm87DQoNCnN0YXRpYyBpbnQgdGRtcl9zaXplX3Np
bmdsZShpbnQgbWF4X3Jlc2VydmVkX3Blcl90ZG1yKQ0Kew0KCS4uLg0KfQ0KDQpzdGF0aWMgaW50
IHRkbXJfYXJyYXlfc2l6ZShzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCAqc3lzaW5mbykNCnsNCgly
ZXR1cm4gdGRtcl9zaXplX3NpbmdsZShzeXNpbmZvLT5tYXhfcmVzZXJ2ZWRfcGVyX3RkbXIpICoN
CgkJCXN5c2luZm8tPm1heF90ZG1yczsNCn0NCg0Kc3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUo
dm9pZCkNCnsNCgkuLi4NCgl0ZHhfZ2V0X3N5c2luZm8oJnRkeF9zeXNpbmZvLCAuLi4pOw0KCS4u
Lg0KDQoJdGRtcl9hcnJheSA9IGFsbG9jX3BhZ2VzX2V4YWN0KHRkbXJfYXJyYXlfc2l6ZSgmdGR4
X3N5c2luZm8pLA0KCQkJCQkJR0ZQX0tFUk5FTCB8IF9fR0ZQX1pFUk8pOw0KCS4uLg0KDQoJY29u
c3RydWN0X3RkbXJzKHRkbXJfYXJyYXksICZucl90ZG1ycywgJnRkeF9zeXNpbmZvKTsNCgkuLi4N
Cn0NCg0KDQo=
