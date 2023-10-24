Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C217D4E3C
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 12:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbjJXKtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 06:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJXKtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 06:49:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC60109;
        Tue, 24 Oct 2023 03:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698144588; x=1729680588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ghOLlt/RHp9gE0ho7AGboeKCmZKin1klnQm4obKCCgw=;
  b=i2qlanT9FMaaw7KznthdgNYrPtUuVPZoamggw+G1p2edJESFyeOhaSFm
   bM1dnMChPGzGMMsXEXzJU1im8CjPNHKuH2uzJtBJQop0G9no1LBCD0vkM
   /vzGMogMZJkOsH3R2X+lbjbIQ0RvkH1y8gmXUhb4zYtY/buZ7XZ9vjbQc
   SonSvUAXgZL4g/ej7ymYqCJ6TSPbad62NzPCKmZBpME0j69Yq7PkyKDGi
   +gC2PoB6CJYy38lLv81jbiSAw67bH/oKk1ZupqDmMfAg2hal2oexa1DQE
   hxKgEhPEjMVynkEnf0HiQ5PBldSfWQZhcwHxhLubZXN4p8rtA6zOifytO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="384231045"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="384231045"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 03:49:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="882084656"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="882084656"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2023 03:49:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 03:49:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 24 Oct 2023 03:49:46 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 24 Oct 2023 03:49:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAdnwTJKUzwGD+F1BexCEsA+d2d+/LCgDf1///SIA73bXuLm56y58OarkyNc0WMJBL/pJtaVCaEvSz60IcIYZiC3OgIaFQeRCQP5Mvt8ZUhLiB4w+lJ06Nyn8gb7EC3Uc2C6rQ5fIi1khh+uxypCnwi1E/rTK41C/vZQHjeOZLl6sI3Ln4uBALg8f7IOvQQgqAXxEVCjCpEkSB89X0ebkQETHJcb5tAcfpGg1W8kNmCobEO90+WucNe35Vy5YKOF0RTcuNhe4+82s9bqWmGC4GXVEmdBoL8zDOltOSiYDuaxExTP2s2aUrpUNU+Vnu/NLZbIJTUXJaJAThNDC2vAoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghOLlt/RHp9gE0ho7AGboeKCmZKin1klnQm4obKCCgw=;
 b=hw8bk3uOOKaxbgOUtKaA26kuw4wKazvWTGHQvzUHYeq4xb/ocPK1beEdLYhMLlISaZa4xoMDTIhZz9kgFnN/aGGHibaBCfvBw8CyGZBcgfRM5RD/4rmhsqP5OD8MbuByVl645wdAxsaTpx7EFh4jYwqn8pS8r6E6468gImXnu6uFPpHsuT6msIqd53wEqHZ+1GqM+30KpzRDQp1FO2vXoJZAdx77gvmpN1C3ntRXpd7kKG8O7VpM2eJh5mdm0wwfOYJVcEEpUpvrLRedq2gLhuKMimKHdOXP6rTlmYwynJkTfNS92X6u5Kps3McWs2qKFaEMIaS7SQVSSpv31zDJxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5783.namprd11.prod.outlook.com (2603:10b6:510:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 24 Oct
 2023 10:49:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f5cb:a40b:539a:2527%7]) with mapi id 15.20.6907.022; Tue, 24 Oct 2023
 10:49:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v14 12/23] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v14 12/23] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHaAOACAmV9xuSSU0i9N5uu0ci8crBYeyAAgABSmwA=
Date:   Tue, 24 Oct 2023 10:49:23 +0000
Message-ID: <457f0b5366134c2b09d6312c32e5c84b123e7911.camel@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
         <ac0e625f0a7a7207e1e7b52c75e9b48091a7f060.1697532085.git.kai.huang@intel.com>
         <33857df5-3639-4db4-acdd-7b692852b601@suse.com>
In-Reply-To: <33857df5-3639-4db4-acdd-7b692852b601@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5783:EE_
x-ms-office365-filtering-correlation-id: d06bf701-c75a-43c2-f1f9-08dbd47ee261
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8t7JZWo4QVLUdENBCCt4UYUbThsraU3ljWvyvCb/WospZgDHDkCMpKqtwipOrWYzj9NW3Ra1v4yd/eYtRVxN0yd5cknF9oMiF6jZHQZ856EfLRiFrbDRNGjDOUAEanG5k8eN/I8fFEyc5lfWNDEUpJ1+CmxhSp/UoAdm+DNcCDpLhvlYoxS63jNC/BNibmvsjvqtqBPtsH59f2stubQFFwUPkLg6HqAZhQBfZb/kEpSvjFUn3SZ5+HkCr7DNA+5pERzO2+XnaB037J5iy10d1kjkve8pPQqY6ADPrXovGYd8Z0aGv6zEoudifcPeFdt+T32UKDLc4aA9gpvduFi+4j1pug/a9ts5frFJulaSH7mMr/sZBmXPx/Yn26m7ED4UROX56Ztoz1Fg/NtKhBpMqvzXMi+ptKDuEdzm3+PaOQNF5Auuv6FG+Rp2dF7lZ2XqmsTHnkc9SPqKzqeK3nfg5SAObHo80RBTCbVrFYfbITSUNm6a2Ct0D2NJ2jJfes4Wiybpnq1DoaxHS1LkC4k8hvJWfB/PHndtNSBF7ohNuvbSq0vzFyllJd1m3hHCzQr5eZ2yeC+HMY/GBQJ5tcrZNAO+hEkERigk24k/MoC97hkxuGX/tlcsy2kEcup+PwsabdN8Zf3BqpngwyOBqn5hfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(136003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(86362001)(82960400001)(36756003)(316002)(38070700009)(66446008)(71200400001)(26005)(4001150100001)(76116006)(54906003)(66946007)(478600001)(66556008)(122000001)(2616005)(66476007)(64756008)(6486002)(5660300002)(8676002)(6512007)(91956017)(6506007)(110136005)(38100700002)(41300700001)(8936002)(7416002)(4326008)(83380400001)(2906002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEFsRUNSVytLeGgwcHVVUmRMUFlpd2hYT1lvZ3RXYjJLdnFydE5nTFJraVZL?=
 =?utf-8?B?OHdtSGlZc0dxc0VsYmJUdWZValQwSlZVMzAyMGZkeXhEM3R0WUlvMFZKU0hr?=
 =?utf-8?B?aFY3RTFBSnFPR2Zxd3AxVDh5SjhYWFpWaDhjVk5JWm45Q0w2bGo2SmJjU0Rs?=
 =?utf-8?B?YXpKazhteHBrTG9rSHBqNllRQ3k3TXJGZDFSVzJnOFdTSDFyQVNkdjRCTE1L?=
 =?utf-8?B?ZFlVd3ZBMVp4eGFjUXJLTG05dmYvZzg5ekpHR05LRFhJLzBIM2dXbWJtWUVG?=
 =?utf-8?B?SXplVlVJZ0Q5cEpRaTFDTjBsVkU4d2V2UWtQSEpCdnJXTEJPcjRhVGhnWGlW?=
 =?utf-8?B?NStmRHo5ZVBwM0VnUmpBYThNY3RtVmxQM2x5N0duTHVNancyRkE5Rmk5UXBC?=
 =?utf-8?B?SmZIbWdjSzlzRWh1RHIvNDhsbzNBdEtHaXdBT3NiU3ZNSjI3OTBCNjZBaEVm?=
 =?utf-8?B?eS9TNmZvQTFlaGxKTVZPNGFvbG94RTFjbG1pNThyT1hBdnNidVlPUDVBZ0t2?=
 =?utf-8?B?MmtZUmZCYmRkVDlSZG82WnBsNFhsWGRIUk9oelZPSHBOVjF3bUUrQ291aXRj?=
 =?utf-8?B?VDJ5UTB1T3A3UlI1VE1QUkRmSmgzWDBpZFBkTS9BbE9kbytzT2NKekM3dFQy?=
 =?utf-8?B?aENVMkk4NkNFZml6ekFSeDRKcGRFWnlTblVoRXF1VnRuY09ySmd2aVNTM3d3?=
 =?utf-8?B?K25nZjVoa3kwZU95K1QxUnRuUyt4SWVuVzE3U1RqL1E4SUVUb3ZIVGNBcFNB?=
 =?utf-8?B?QXp6ZVhaMjNjWVV1eWE0WlFMMi96L2xEN2Q1VlYzZk9yUHppeXpPLzBNSkhp?=
 =?utf-8?B?Vlp4cU4rUmN0ZWR0UXhNVlJNK3Y4N2R2RzNQelk4MGxjdFN4MWFCSENBVkpI?=
 =?utf-8?B?Z1Z2NjFzL09ydDdoaE1rNUk0cEtFT3B3QkN0NXlhSGFZNnNLVk9SSEdFSGRy?=
 =?utf-8?B?RXV5ZUlqaTNKNVJPelo1b1dPYlJ5SDJMR1NIL3AraVF2NFlRNEdhUE4wVFd1?=
 =?utf-8?B?V2ZPNnVJUCt3ZHBsZUQ0cDZDN2FFUjdDOHJkeXE4YVEvaVN1TWpzeWlPZkJm?=
 =?utf-8?B?a0VDUnVxbFYzeVNBT040RWlKQ05pc0hrMTA4SUMrcTEvTHBFQVd4ZEZWaGFB?=
 =?utf-8?B?cmhETGNoQTk2eXNFcVpyRWlhNU9URERsam1Kc3FFU2IyZGpiSlQvSEY5K1ZZ?=
 =?utf-8?B?c3lzcjcrVHd2OC9XM2ZTdGErcnpmZ3N6ME9ka1JaaEdnM3NQcWNiRnJEQnZK?=
 =?utf-8?B?bmppdFROT2xjU1l3c3hjRmxabTdrVHdzWUVCdWhRMXV5WjhkbkVIdG1wb2dn?=
 =?utf-8?B?RkRSTldzK1I4NEt0VUFhL2VNZm1Td3pZSHFNR2RRV0dmclRITnlBQ0FDN3oy?=
 =?utf-8?B?MmtMbDByOUdoM3pCZ09TNFlZdjE2b2g1eFhVT1VKSTQ5Q3lSVUJQSVN0VDJ0?=
 =?utf-8?B?ZTM4cGF2RzhpNHh2QnlPaTVqbStLNGdEVkpOVlBLN0ppOFZNU0g3bWcreU5M?=
 =?utf-8?B?MWdRekJZK2crVy9GbnUzWURSQkZ2M2UxUmkzYlhNT0h3eHRxOW11S2dnS2xV?=
 =?utf-8?B?TzBFNUsyalp4UHB1VVJOc2ZQaWdadDRCNzBPZWVZTjNKczhNQlZuMzJoejlS?=
 =?utf-8?B?aW5wem1YTjlFQ0RhZFA2R1lnZmhwdmpxQ0xEdVZQOFd5aVJtM2tjK0w1Z3I3?=
 =?utf-8?B?TXc5ME9BcUgwcitkTTFGTjBRbUE5MUJ5MVUwQkdCZldWTzJBMnI4TGxwUUkw?=
 =?utf-8?B?ZnNKVjkxQit5UXNtRUNLK0NrU2JWYTZzdXJqdXpSSVZaTkRpbENmajBnL1ph?=
 =?utf-8?B?OFJ3cDNQU0lCQmE2cmhwTnBoaUNkT0l0QmFsL2xsdnIxZ1VCZDZXL0tPRFRZ?=
 =?utf-8?B?MjJTZE9ReU1ST0kwU0xxdDdRSDM5L3dLQjE1ZHhlTnJZcDhtcHVJVlNCeVBl?=
 =?utf-8?B?dFpHaFdra3NsblFTM3h1WS8wVjZqZXUyMzFTU2VlYlZveERocjZDcnF3d2VU?=
 =?utf-8?B?ZGZZUDNsYUVIOG9oTzhOdndkQURxTVBjV3oyWTVZLzZoY0ZYelBZSmxwRkky?=
 =?utf-8?B?eTgwTTVOTG50SDM4VWxTWjlXRUVZbWRJdjN1WGM3dzIvaFdzRGdlSHpPZjB2?=
 =?utf-8?B?c3NOb2QvMWNSQjY2YUJCdFJLZ3AwWDlOcnBGTXNiQVVVZWlFbnVDNnBZRjVZ?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <119A0B9F6376224AB3F7DB6A6A4FA440@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06bf701-c75a-43c2-f1f9-08dbd47ee261
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 10:49:23.1814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SgQY8VW/IdzjYVoPNzQcIiRsB0GLIpy/XfhZN7RRniPM17m1GsSSvEFtq4G5nn4RNYCobtgkSb2VR6Qox6kNYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5783
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTEwLTI0IGF0IDA4OjUzICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxNy4xMC4yMyDQsy4gMTM6MTQg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+IA0K
PiA8c25pcD4NCj4gDQo+ID4gICBhcmNoL3g4Ni9LY29uZmlnICAgICAgICAgICAgICAgICAgfCAg
IDEgKw0KPiA+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vc2hhcmVkL3RkeC5oIHwgICAxICsNCj4g
PiAgIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyAgICAgICB8IDIxNSArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0NCj4gPiAgIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaCAgICAg
ICB8ICAgMSArDQo+ID4gICA0IGZpbGVzIGNoYW5nZWQsIDIxMyBpbnNlcnRpb25zKCspLCA1IGRl
bGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9LY29uZmlnIGIvYXJj
aC94ODYvS2NvbmZpZw0KPiA+IGluZGV4IDg2NGU0M2IwMDhiMS4uZWU0YWMxMTdhYTNjIDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gveDg2L0tjb25maWcNCj4gPiArKysgYi9hcmNoL3g4Ni9LY29uZmln
DQo+ID4gQEAgLTE5NDYsNiArMTk0Niw3IEBAIGNvbmZpZyBJTlRFTF9URFhfSE9TVA0KPiA+ICAg
CWRlcGVuZHMgb24gS1ZNX0lOVEVMDQo+ID4gICAJZGVwZW5kcyBvbiBYODZfWDJBUElDDQo+ID4g
ICAJc2VsZWN0IEFSQ0hfS0VFUF9NRU1CTE9DSw0KPiA+ICsJZGVwZW5kcyBvbiBDT05USUdfQUxM
T0MNCj4gPiAgIAloZWxwDQo+ID4gICAJICBJbnRlbCBUcnVzdCBEb21haW4gRXh0ZW5zaW9ucyAo
VERYKSBwcm90ZWN0cyBndWVzdCBWTXMgZnJvbSBtYWxpY2lvdXMNCj4gPiAgIAkgIGhvc3QgYW5k
IGNlcnRhaW4gcGh5c2ljYWwgYXR0YWNrcy4gIFRoaXMgb3B0aW9uIGVuYWJsZXMgbmVjZXNzYXJ5
IFREWA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaGFyZWQvdGR4Lmgg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaGFyZWQvdGR4LmgNCj4gPiBpbmRleCBhYmNjYTg2YjVh
ZjMuLmNiNTlmZTMyOWIwMCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9z
aGFyZWQvdGR4LmgNCj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaGFyZWQvdGR4LmgN
Cj4gPiBAQCAtNTgsNiArNTgsNyBAQA0KPiA+ICAgI2RlZmluZSBURFhfUFNfNEsJMA0KPiA+ICAg
I2RlZmluZSBURFhfUFNfMk0JMQ0KPiA+ICAgI2RlZmluZSBURFhfUFNfMUcJMg0KPiA+ICsjZGVm
aW5lIFREWF9QU19OUgkoVERYX1BTXzFHICsgMSkNCj4gDQo+IG5pdDogSSdkIHByZWZlciBpZiB5
b3UgdGhvc2UgZGVmaW5lcyBhcmUgdHVybmVkIGludG8gYW4gZW51bSBhbmQgDQo+IHN1YnNlcXVl
bnRseSB0aGlzIGVudW0gdHlwZSBjYW4gYmUgdXNlZCBpbiB0aGUgZGVmaW5pdGlvbiBvZiANCj4g
dGRtcl9nZXRfcGFtdF9zeigpLiBIb3dldmVyLCBhdCB0aGlzIHBvaW50IEkgY29uc2lkZXIgdGhp
cyBhIA0KPiBiaWtlc2hlZGRpbmcgYW5kIHlvdSBjYW4gZG8gdGhhdCBpZmYgeW91IGFyZSBnb2lu
ZyB0byByZXNwaW4gdGhlIHNlcmllcyANCj4gZHVlIHRvIG90aGVyIGZlZWRiYWNrIGFzIHdlbGwu
DQo+IA0KPiA8c25pcD4NCg0KVGhhbmtzIGZvciBjb21tZW50cy4gIEJ1dCB0byBiZSBob25lc3Qg
SSBkb24ndCBnZXQgd2h5IGVudW0gaXMgYmV0dGVyLCBhbmQgSQ0Kd291bGQgbGlrZSB0byBsZWF2
ZSB0aGlzIHRvIGZ1dHVyZSB3b3JrIGlmIHJlYWxseSBuZWVkZWQuICBQbGVhc2Ugbm90ZSB0aGVz
ZQ0KVERYX1BTX3h4IGFyZSBhbHNvIHVzZWQgYnkgVERYIGd1ZXN0IGNvZGUgKHNlZSBwYXRjaCAy
KS4NCg==
