Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5D46BF894
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 08:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCRHzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Mar 2023 03:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCRHzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Mar 2023 03:55:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05783E1E4;
        Sat, 18 Mar 2023 00:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679126113; x=1710662113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zprK8QlvOXAc0TsESMyu7asPfV6Itp9IovifSd7nwOU=;
  b=ZGxAbGkWvg96NPVClEKXkJzL59O1eteQ0Kib8FdJPrTq3OM7TAwuqvM1
   SRiqfiyYl6bRanO+nfvHqwXJCPb7Ro5s4hvwrQsiEYsFltoyPtw4WqRVy
   S+Km5ZO86b3OC3o3ZH6N/b8AJ0dGiAMaS8z9aHD0KjCJKjtV7AbkcTy1T
   +EsSGdeExURNO+FFMB9EIsLcKF3FzMqM0ltKWMDpr4QKtbueQ4yt1FZVA
   e68rOi/Edh81o0WP8zCqE8RsgxqyXafbr78Y6O+AaCKwqGUTDGhwAd2jh
   eVplkW5jUKTxLtRqwtfq7bE5yyPxsJqOqx8e7Cty7yk73fyzumaoQ4zEf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="424691409"
X-IronPort-AV: E=Sophos;i="5.98,271,1673942400"; 
   d="scan'208";a="424691409"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2023 00:55:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="680540267"
X-IronPort-AV: E=Sophos;i="5.98,271,1673942400"; 
   d="scan'208";a="680540267"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 18 Mar 2023 00:55:11 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 18 Mar 2023 00:55:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 18 Mar 2023 00:55:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 18 Mar 2023 00:55:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBfxabd+ZANP2vF+SaFhAYq+izY7k66rgM4dQB4kLK6g0TM6oaOtC/gzGDD0b70U0StMAUhA+C9Vk/f83xnzkwOraiTHLe6Sn2iXSzwhYS6Dsl4/dF1lpMtT1bcCQmlpu8OviLdNlDbXGedl/r4e1cLYzVQo7RvmXhCNVx3a6yVKl006bUFy8lsq6H3lHGaCpLqekGk0tTphPiDtZCp+BaWpI64dH7uMKsGRoVSWBckJxw/Z99z+4zeXZjCga+pH2QRKzLxVl1vPy4Ruf/xtmpeJ77PrClSAfE1s3aih1nX/c5xdpktRqhdmWg7c1cqumG6NMK+3QT3RKm8QiPM4bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zprK8QlvOXAc0TsESMyu7asPfV6Itp9IovifSd7nwOU=;
 b=FuoEuxx9iLGDu07NbQdMdJTmP0BaiB9nGpohQhBVJPAKH8GHH7RpVlsKzqx0MNKl8Tyr6MrOT46sXZR0fMVB5d0NrCJCBMoUIsdr/fRSY0g/PiiCLA+539vExssvAiENmy9yUf4drFVkWa7JrfDi+F1/b2HJyar7iHMZEuAQTXGQ+JBH2gdQFYkmRA458g33XFf9bB3dMWSOnN5fpXArS05oVnV3OyPOtYz273gqEU0lk5pW/0i9e4FWcmqu6cL/Fh5wbZwiEfkPZqZ2qG4keoiYUQ8Fn2NlIBwcT1v3Pxm+Zextw8cDTtj8E32bdvXJEr2av6GEgG2E8h8b4nfqyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DS7PR11MB5991.namprd11.prod.outlook.com (2603:10b6:8:72::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 07:55:08 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Sat, 18 Mar 2023
 07:55:08 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 28/34] x86/fred: fixup fault on ERETU by jumping to
 fred_entrypoint_user
Thread-Topic: [PATCH v5 28/34] x86/fred: fixup fault on ERETU by jumping to
 fred_entrypoint_user
Thread-Index: AQHZUKIRh0ubgTRve0KnKMOFsdbTqa7+x1eAgAFzSPA=
Date:   Sat, 18 Mar 2023 07:55:08 +0000
Message-ID: <SA1PR11MB67343400BB7EAB081513F04EA8829@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-29-xin3.li@intel.com>
 <CAJhGHyC6LgCwdDTkiy2TaQ8wzBQQfrx8ni7fY8vH-bUT2kR8pg@mail.gmail.com>
In-Reply-To: <CAJhGHyC6LgCwdDTkiy2TaQ8wzBQQfrx8ni7fY8vH-bUT2kR8pg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DS7PR11MB5991:EE_
x-ms-office365-filtering-correlation-id: aa8f027e-ea13-497c-6100-08db278617be
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IUuTOUscOBhcm2G6F2delbuuo51w1dfeCWnKDXyoy0gxmm6kgJLAtaL/bKpIbjRmZvmRK0xYrYxNorKUjS9O+6eGYCNkP28ESOJPqs91wOCnatxUcjQI7yT1H6tmGomWSeI/EvtjsvNvSIOww9JMeCRsTpijTZolTQDPArLua245xtwMEiJe1BwDDs7WS8+T9EwYQWecqEhvxQlGt1hZQZO173LN4nY7xRf+5zJqHWY/elhpUsVF2et8C+irq1H7FePCTsqPHlmf7+s2zZKRJJ+Uhy5CtDgnKlQ6ph+OslarB2yweKQkLXK9UkcjQDIcLFIJdCwMfy9a4oEVtMYjwsQiDY3L+wbtTLFdoZ2ey579Iwaul/2860mi/kOG5t+x3K4AjDdBkzGBa68Occ0Z7nI/82k65NRJJqzuLjJoSirNKnK1K6CJuv/FlCoUgJB2eLGdJW9DJO+Lhf0u4Ms3WKyRXQhz8Qtf1Gd/WJhS1cRgzOGFOARC9YwSGxbsoZ+rm4QXFq5NO2DwciOPNNelzv4yk6TEzRAvI9xmib5SH5QQQ+YQ3WdjrNH77QKq18xFUWecQkuirKOATT+c6b/NWbn/iOYsIIvi9pvGcGHhZTI54LPcOUGJz813GhO7XBrD/AQlr6jo+nYMC200y22kcmR4chXuW6fMcYyxQrDhmzQ5NvcEV3SSpu9EfpU8p9HC92+eFt70+xVtYoU8B8ONsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199018)(86362001)(33656002)(55016003)(71200400001)(7696005)(316002)(64756008)(76116006)(66946007)(66476007)(66446008)(8676002)(6916009)(4326008)(66556008)(83380400001)(478600001)(9686003)(186003)(26005)(6506007)(54906003)(38100700002)(38070700005)(8936002)(52536014)(4744005)(5660300002)(7416002)(41300700001)(82960400001)(122000001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REFIVEhtaEdFQ24vSGdlcnM3RnhRUEpLSThLUFBqa2MxMGtqT21QdFZIS0lE?=
 =?utf-8?B?U1ptL25md0puZVVPMXBscGlQc3BhUUwvaTErMjVhR3MvKzN4em44d1dmUmpL?=
 =?utf-8?B?ZE95MmN4U1lieTgwcUhhTE1YbGhjaFRZUy9uODZIMEkwbXdZbk16Q21mVEdR?=
 =?utf-8?B?V3NHSmxodTgxRFNQeTM2R1ZhNXQxOE9nSnRUNTJFNTMyU1E0dWwwS0J6c0dL?=
 =?utf-8?B?bXZuTThWRmRzNURjclBCT1JENEhsQ1phQ2dTbFl6WFZvS05ydG9zdlgvUTNF?=
 =?utf-8?B?RjFtd05jMHlqLzBtQk1zZlFCRXQzcWh0dFp6N3dDVkhmZE9DcGg4Sk16U0ZR?=
 =?utf-8?B?TSthM3JEaFR3NExuVThIQWR0cFUxdHgwNG5pY3p6QVdTYTIxcmlYTDhoN3R6?=
 =?utf-8?B?aUhJZ2ttQnVPbSt6bVVNQm1tYXdSbGZvVXVucVVoL1hES0FEZm5nNE9xUit2?=
 =?utf-8?B?ZE9zRDIrdFAzYnRLMWQvL2UzSVcrT2VYSUVsdkJrQXRKUytqTzYxSitCeENo?=
 =?utf-8?B?NWtDUW5Lc0drdjVhM2RyRk1pLzcwM2t3WC93MEJMNmZDS1VLWEhQSEVsTjlC?=
 =?utf-8?B?Mk9mV3VPZUQzaWdSRm80blk0eDhOdnpwNFA0RCtlODlZWDVFaXJmZVZSODR0?=
 =?utf-8?B?dlkwVXkyQURSd24wYllFUVZpOEdIQmJNYXZObElhWE4vOHZab2tqeE5FRXNO?=
 =?utf-8?B?NW9HSWdjVjFqL2JuOWtkaTZlZ25rM3RDbXVIbG9YSUVyWGswT0M2Z1N2MlNm?=
 =?utf-8?B?dUZjelB6WEdYWTRZMWRySEJmNlFMWHFnRFVGN0hOVmxaMUx6ZWxIKy9nYlRL?=
 =?utf-8?B?TS85ekwvOXVGSFpub2tkZkUwZ0tpRjJzamFQVjlDM2k3K3FFVkZpdTBDK1hD?=
 =?utf-8?B?TVFRSjdkUGo5VzFxSW9BdTIxalQyNkZGREpwTmlSSU9MUDNTeFA1WkRhVXR5?=
 =?utf-8?B?M2FLWktaRGQwdGg2K3A1VFk4d0swYldRdEV0L3hVUzVHNnJLenhudGd4R1pZ?=
 =?utf-8?B?Q0RZRUpIYjZtYzlMTFJ0bFRKY2dqVG4vN0g3cXRMVjdVOFJuTFRXb3FBRnRv?=
 =?utf-8?B?WmFqUk5lN2RCaEZrcG42dS9KdytkeUh4Rjl2dWR0eTExM0Q5cUFuUlZTL0xG?=
 =?utf-8?B?djdqUy81cDZWcWxUa1ZZQWJIdGtHaHlsS093Yi93MkE3VENXbzVTOUkrS0Rp?=
 =?utf-8?B?dUNacGJ3Ym94dFMyNUxmVENPVzJUcXdNMnl6ejRMSmllL2J0MFlVUU5qTTV0?=
 =?utf-8?B?YjdPeFdzT0dmcDgxUUtpUE42MVdmcGRZMzRaMkFEelQ2b3psdDB4TFZwZnNn?=
 =?utf-8?B?dXRSOE4rcGhyRFJVRGNIQlBRdnNNL01admdKaVNHMnNhdWdhd2VmZmdJK0U3?=
 =?utf-8?B?TXJBYVo2enNDNHU4MXZ5b2JaSjFjUHdwNDhSRG1pck5OMGxXT2oxQy90Unh3?=
 =?utf-8?B?NnB0VFhTZnd0RVlqbWF2YU4zUXowdDNnOUk2b00yZVZMbVVWR1NxNGpZcmxu?=
 =?utf-8?B?eTNDazFqOEJyTFI4NHlYdjVENHlyNkc2WldhZGRQWkt5cmk2RXROaDRwSnla?=
 =?utf-8?B?dWN0UTRhT0JLZ2h1Q1hhSUZsZVQxaUVlN3dhNjl3TWdQSGNKZTlDdUZabHdt?=
 =?utf-8?B?NU1UOGgxdXBMVUNjcnV6Vkx2SklNQ3VSdHJWVVFIdUQ5MXZvV1orQ3U2cG5R?=
 =?utf-8?B?NUFrejdDNXdOQWRDOTVZTEswY2NKZVFWT0lsSkdTZjY4N3RYYmNVT01sN2g4?=
 =?utf-8?B?ZStFcng1OTRwQUxDQndBQ1dWNklJc1hXS0NxQkdSdU9VRmwySXN4UmVZMjIw?=
 =?utf-8?B?RFp3TTdmL0JpNFEyVk5UeXlLeVJUdXZGbE5JeFF6clBpTERwa2l5WUM2dUpo?=
 =?utf-8?B?b3YveVBuN1g5OUVIZFY0Rnp2MEJXZHZhdGdmTE5zN0kvZHlnOGdmak4vdytv?=
 =?utf-8?B?eW9FRWU0MVJzVmNMRDMvQmdibmhFeFNyaFFEemZoV013enFLZ1FJS0tPR2RI?=
 =?utf-8?B?a1FsTDUzWFd0VXlYenBKVkRlK2o0OHEwb2JzTjF1eFBBeG5XVEZBZXdTeUNJ?=
 =?utf-8?B?Q1lEWmFHNDduZm5FOFZZbUE3bWN6b3NVZU9mdDNIamsvMTd1RXlxSDZlRWtk?=
 =?utf-8?Q?T9rY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8f027e-ea13-497c-6100-08db278617be
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2023 07:55:08.0355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WpuXzW4hyv7Lgh+mJBYFzpI+k90u/RWX/3QbKJDjn/xiM64rmCuAaxkNLTh9uhwHVUGDMailftPmiCIIClQsew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5991
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ICsjaWZkZWYgQ09ORklHX1g4Nl9GUkVEDQo+ID4gK3N0YXRpYyBib29sIGV4X2hhbmRsZXJf
ZXJldHUoY29uc3Qgc3RydWN0IGV4Y2VwdGlvbl90YWJsZV9lbnRyeSAqZml4dXAsDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgcHRfcmVncyAqcmVncywgdW5zaWduZWQg
bG9uZw0KPiA+ICtlcnJvcl9jb2RlKSB7DQo+ID4gKyAgICAgICBzdHJ1Y3QgcHRfcmVncyAqdXJl
Z3MgPSAoc3RydWN0IHB0X3JlZ3MgKikocmVncy0+c3AgLSBvZmZzZXRvZihzdHJ1Y3QgcHRfcmVn
cywNCj4gaXApKTsNCj4gPiArICAgICAgIHVuc2lnbmVkIHNob3J0IHNzID0gdXJlZ3MtPnNzOw0K
PiA+ICsgICAgICAgdW5zaWduZWQgc2hvcnQgY3MgPSB1cmVncy0+Y3M7DQo+ID4gKw0KPiA+ICsg
ICAgICAgZnJlZF9pbmZvKHVyZWdzKS0+ZWRhdGEgPSBmcmVkX2V2ZW50X2RhdGEocmVncyk7DQo+
ID4gKyAgICAgICB1cmVncy0+c3N4ID0gcmVncy0+c3N4Ow0KPiA+ICsgICAgICAgdXJlZ3MtPnNz
ID0gc3M7DQo+ID4gKyAgICAgICB1cmVncy0+Y3N4ID0gcmVncy0+Y3N4Ow0KPiA+ICsgICAgICAg
dXJlZ3MtPmN1cnJlbnRfc3RhY2tfbGV2ZWwgPSAwOw0KPiA+ICsgICAgICAgdXJlZ3MtPmNzID0g
Y3M7DQo+IA0KPiBIZWxsbw0KPiANCj4gSWYgdGhlIEVSRVRVIGluc3RydWN0aW9uIGhhZCB0cmll
ZCB0byByZXR1cm4gZnJvbSBOTUkgdG8gcmluZzMgYW5kIGp1c3QgZmF1bHRlZCwgaXMNCj4gTk1J
IHN0aWxsIGJsb2NrZWQ/DQoNCkRvIHlvdSBtZWFuIHRoZSBOTUkgRlJFRCBzdGFjayBmcmFtZSBj
b250YWlucyBhbiBpbnZhbGlkIHJpbmczIGNvbnRleHQ/DQo=
