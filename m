Return-Path: <kvm+bounces-2547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 084137FAF96
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 02:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A852FB21166
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 01:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0411875;
	Tue, 28 Nov 2023 01:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U7yLgYA1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6C1E4;
	Mon, 27 Nov 2023 17:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701135255; x=1732671255;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cvwu+Ow9usHqo3nhcXFflY9E5upuTTAWjCftFLkJgYY=;
  b=U7yLgYA1kUoAkk6ojZiqnn7rrrm5Q+aWZEbqFKolAeZjVT4y5D8JvinF
   C61QjoaYepEUvlvadS3O5haun5HNCaOR+HXazlzMVqXqhVMoG6Eg7MzpH
   eHwkw+2tnq+XlVHyt8F8DxPQxK+cgrsEWsoSvdbvDXgHiGZXct3MmKrD7
   gqyqa4ZTyubj/DhEu/TkALYVpR2z1eRJW6TcbFgBf7IF8Wjfyx6P74bGh
   23zAE3LMD2TlwHaOXk5ZiyG6vhaqUjeZ68DN32JaJSrVgWmN5l0s1FEzR
   kU93WcII8vW4I3wRNfzPsN6th0zZhP5QuDM3oD9xfm8Dg8/C7QkLyUmjR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="372995477"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="372995477"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 17:34:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="16460416"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 17:34:15 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 17:34:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 17:34:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 17:34:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9HTYxOGE3TR1mCYSA+7qBpxiI88smIT3bLadmhNe1kNcYoOeCiqQHOVwFuz97rLzltb+6Jwb7MyCZ2PuJ7nnoySR+X2q4L6HiFxCAN6hQYxGYR6tqWnSGDj0xbTZN8PqBmoMVXo/8LPMuNftSQPY0ui+OSvFFhwMams4PuNpNmjWlDggnYrR419cy9No966NocI21gvqHByyGVZnaEXthF7reTdIMuvgSXtaxborPjSlGuOQYX4tysI6s4zMV5gRcHpO+XxOqBm2IxC8O9zWu4qIH42NZMVfja+HRHmAVS94g5Bb9slEGrVFYpcnxGUXhQDglNjsDMYwJ86wjyydg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvwu+Ow9usHqo3nhcXFflY9E5upuTTAWjCftFLkJgYY=;
 b=eXT4a0e6hAImgXiScfsLMem49ZlK4oafAMT+BCprUqiz7XZevhAuuBdShsI0wDwP9QRfagND8lpeB8Nyf11JhkvauUmdnhmyYUr4Gn/AxfLOQZZqyRB/eKwMhk6CTFRuk2q0EH8R5xYWDk/1TTSZACg4jXuT2irn5jw0Amol84BEuZBlbD2A6rvj52xeFNnHXV7UL/xu5cVcBeGGg7hpbgA2stvT2LZFIDKyyxpd9O7eKNF5ybOzuCARNvt74zHifEni2SAWzIL8NEutuRAo61KEVblvkzQ+7l6nwIyvrrZWpYlX83n+PnRf3vEJmzExcfUTXy0ea0uCKItCNlqrhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4564.namprd11.prod.outlook.com (2603:10b6:5:2a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Tue, 28 Nov
 2023 01:34:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9%6]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 01:34:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
Thread-Topic: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
Thread-Index: AQHaHqwJULeSyPNy2ked8P3TPERS8LCO+KAA
Date: Tue, 28 Nov 2023 01:34:11 +0000
Message-ID: <246979fa097245cf1626bbc2d83147a5367219e7.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-4-weijiang.yang@intel.com>
In-Reply-To: <20231124055330.138870-4-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4564:EE_
x-ms-office365-filtering-correlation-id: ea02cea2-a2f8-4e62-720e-08dbefb21f62
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AUCZQqkmzSLv4U+nswSYStjaHJydQ74r2e6UfNQZu31ScF2oZ+jtybOKi96vY25oQKEmrPEkYFbTJLaklHT7o1Z4BeW2nZV88ejNKVA/3KfbErA8RN1YQ4TA9EmXZbnrZb9XY6wYAJRmKCpaJgQN4lzZjMC0IYN/lyvztBpRAuvPfKZSvjc/FV8Iadf0vl9mV5mcHH5+2HjPrqtOKqK6UZS9B7+lZ6tVouMXeHx6xODdU9EfHY1g/X2ZJDMiW8GiYuPyNGUHRghcVDAvS+Msitj21/Aw/nM6fUgEwjZAHxydIVRou8MWBMGvIsx++yHf0c4lGs8PoWmniJ/rELNp/njORakfTFHZisby+Poycz48qeJX89C3Ip170OYdKD8eQiacdyUgfxXKelFMfScYVf8/61yOc315gjrb/l0ToBZp9phwoArX/ttLy7tUWIA+kFkbyG0qZ5X8cqWaVdyNMHcflpxS5l+aJkqI5jMDP91TcH/qD8/W0oKf4SUASDOasHbFuAQgwVmfprT5EBykgFj192Jd5A9qpGNUFmAqSn4Q++UTwUdYUN6Q7VzMYjiVdOmU8+X7uDEFh9MbzDz0z0Nq/Cjsbiec2dKCBnBQLn4Vy5I+whhLm4UMf4sx1EuYGA+VCtmlgIX38NDnZPJkhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(39860400002)(366004)(396003)(230922051799003)(230273577357003)(230173577357003)(1800799012)(186009)(64100799003)(451199024)(38100700002)(41300700001)(36756003)(86362001)(4001150100001)(38070700009)(122000001)(83380400001)(5660300002)(82960400001)(26005)(2616005)(2906002)(71200400001)(6512007)(6506007)(8676002)(4326008)(8936002)(478600001)(6486002)(966005)(66446008)(66946007)(64756008)(54906003)(110136005)(76116006)(91956017)(66476007)(66556008)(6636002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEJsYzZXQ0YvSnRVZUxQYnlHRnRobFBPYUNsOWN3ejVqQzNiMzhxWnljV0I5?=
 =?utf-8?B?SFZXTnQ2OFhyWi9YSWJvZ1I4TkQ0N1ZFWk9wa2htaTFXSE1qdDdFczlZM2hN?=
 =?utf-8?B?OEhnRk1SZUlXUHhZYjNyMEE3M3IwT3QrMG1XM3l1WUw4NDNhVllkdyt4QjVi?=
 =?utf-8?B?cjVQdUJqUWJwek1aQUhIN0RXM2xMWlBTZXpQaDlhdm1SSnVERzQ5eXBudnhi?=
 =?utf-8?B?VlZyQ01hRThyR1ovUG9qV01zYTQzNWNRQklvQ1YwYzI0MFR0U2hQR05VUER6?=
 =?utf-8?B?OVRINEZQenpMQjlCcXFWVW5pQVBLb2dBRWNQYnhqTGV6YUlUekJnQmtabG1j?=
 =?utf-8?B?VUlXditlcHI3VU5qQlNTemRTUC82QXRKOGF3V3BZejlqeStVL0RkbFVtZUVY?=
 =?utf-8?B?UVFWZ21xREtjWXhzL082MHIreklCQ3QxYXpYQVp2eDhJYnVnaXloOHNwMk5v?=
 =?utf-8?B?UElNRTdWWkhGbi9TNjJmajBnZXdhN2JxakFOR3VSZDZEWGRhMkxVSVJKWmkr?=
 =?utf-8?B?YXlLaDJZbjV3Nm01emU4NzZsNlptN3VlL0JiOEpaZmNOQzVFbkJYc0YxdTVt?=
 =?utf-8?B?MjNuc3dvZmk2TG00dGFaSVpMaGJzamNYREkrNVNYOTQyQ1NHcGdSQ1k2dVdo?=
 =?utf-8?B?RnJkNGJmZGc2V25sM3lRbEhjRE5DeVVrMTFoYXorS2U3Z1ZzeDljQXZzZndV?=
 =?utf-8?B?RTV6RTRWdGhBc1prOXBXYnBScE82NjBoNE52UVduZmFEOFZUZVoxdVpUVGNG?=
 =?utf-8?B?ajZZanovN1FkZ2lBa2FwOFc2cjArTkZROTltZk1manMwZ2NTMEdYQ1BrT0wv?=
 =?utf-8?B?anBDUWZLYngvQ2pVeGpqUnlBejlIZDhaemFWQ2tMTXF1YXhJS0lTNXlMSzYr?=
 =?utf-8?B?QVRpbnU0aUQ1dzRrOVVuRXBzM0V0a2R5eXhOZmJualNHcTRoRmJTVjBhZmht?=
 =?utf-8?B?bXhrYUZlaW12YWdHREp5Rk14NTV6QjJmWUwxNDQ4M3RYZm1ieXZuc3ZaWVpR?=
 =?utf-8?B?ei84aVp3ZXZMYklyTTVuTUdwWjZYREh6OFpwRjA2YzRWN2VENytLRUQvZDhm?=
 =?utf-8?B?YlNqMm9JWVBkR3FFRDFVK1dWbElhOHJFNEpDZERvY2RLREc5VE0xa3BHeGJ4?=
 =?utf-8?B?aG5pbVE2a3ZXemNod0ZJZ0JweFVLSUk0K2NLaGd5TGtIQi9HaWlrZ2YwSXBI?=
 =?utf-8?B?c2FIRmYrZklwUGMyWjVpUWM2a3hVREtCL2RUQ1FZUlVYVktpSHpJSHl4bVJG?=
 =?utf-8?B?Z0lJczR1ckJMRXY3Vll1cUFsb0pvbmNGVGRvSHBGa0pTQ0hXKzhBM0hsaVp2?=
 =?utf-8?B?MGI5eGhzMHNOY1dsWmZNNmhURHdpcitCc09vRWhWWGRtVVpJOElqcGhnS1Vh?=
 =?utf-8?B?RUZRNkY4eDUrL0R4MnJLN3M0NWEwYWxnQ3lRaU5vV084U2N2aC9kMXdRSjQx?=
 =?utf-8?B?ZUw5a3lkWFlDUVBKbkV4UG5WVWhXby9sSzBSdlRRSmtyREdOVUt3WXh4cUk3?=
 =?utf-8?B?WlQxM24xeTluL3ZEM25BRUdlMTBFcEZ5K2ZQNlBrNkVTbVRLT0ZzZk5GWlZY?=
 =?utf-8?B?S0sxUlA5WHFRbDMzbHphS0graFZMSTdPSU9Jc2FzOUxhek95MzcvRlUyb3I3?=
 =?utf-8?B?c2tzWlhtUnVRUnlvZi9hb2JTV2YxRmxLaDhKM1hJRkdpVXhOalFoeXZKbHM4?=
 =?utf-8?B?V3BEandqUTRJZEtJRU9KaUFKODh0dkNzMlQvWDI1dzlnbkptb0sxYW9rS0tM?=
 =?utf-8?B?Ry83N2ZmM0ZKNitueGljVHZFQk44ZWYyaVh0NE5QZ0RrcXFUTEd3WmdXdGxX?=
 =?utf-8?B?WWF0ZjFVbzdVbWNWc0M0WktHemdhZVgyM1phdGJOdkF4c05VWDZpayswVkF1?=
 =?utf-8?B?VW0valhjMStHZTdQYnZVdUJXUlRWZ3pRKy9yV0F3c2JlVWRUMlFqSjhmWXV1?=
 =?utf-8?B?ckVzaVhYT3FUeGltZEUxWmhDS09jMHptSzgzcnl6VTNKNUVreFRZRnNZb0Ew?=
 =?utf-8?B?Nk5BVEJKMjI3QnJxTW5SaDh6Y2ViY3FGZDY2L1RxTy9wYnhUeUxyTUR6UUpZ?=
 =?utf-8?B?TDcyVnNpZVRrNmVHNmJHeG11OGlWTCtIdm1td0dKTjFlZ2RPUk8xMkYvb3Rn?=
 =?utf-8?B?UlBRL2pZWDBRL2dDSU0rQUJtNFRGRW16bDhmb1pKUHhTRkpNditzVys2UlhD?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B73075F69318C4DB5F233E5B2CA02DE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea02cea2-a2f8-4e62-720e-08dbefb21f62
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 01:34:11.2257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2/xI7Jo51MNpZfNahrk2pWezsWJm0DImZ80UZaWCsdqY2Vu0/9Qh4HMlL7oH25MTjUBcuklpuYqzh5D4oQYTfXNmFKlxWxN3IUlhPio554A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4564
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTExLTI0IGF0IDAwOjUzIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBBZGQgc3VwZXJ2aXNvciBtb2RlIHN0YXRlIHN1cHBvcnQgd2l0aGluIEZQVSB4c3RhdGUgbWFu
YWdlbWVudA0KPiBmcmFtZXdvcmsuDQo+IEFsdGhvdWdoIHN1cGVydmlzb3Igc2hhZG93IHN0YWNr
IGlzIG5vdCBlbmFibGVkL3VzZWQgdG9kYXkgaW4NCj4ga2VybmVsLEtWTQ0KPiByZXF1aXJlcyB0
aGUgc3VwcG9ydCBiZWNhdXNlIHdoZW4gS1ZNIGFkdmVydGlzZXMgc2hhZG93IHN0YWNrIGZlYXR1
cmUNCj4gdG8NCj4gZ3Vlc3QsIGFyY2hpdGVjdHVyYWxseSBpdCBjbGFpbXMgdGhlIHN1cHBvcnQg
Zm9yIGJvdGggdXNlciBhbmQNCj4gc3VwZXJ2aXNvcg0KPiBtb2RlcyBmb3IgZ3Vlc3QgT1NlcyhM
aW51eCBvciBub24tTGludXgpLg0KPiANCj4gQ0VUIHN1cGVydmlzb3Igc3RhdGVzIG5vdCBvbmx5
IGluY2x1ZGVzIFBMezAsMSwyfV9TU1AgYnV0IGFsc28NCj4gSUEzMl9TX0NFVA0KPiBNU1IsIGJ1
dCB0aGUgbGF0dGVyIGlzIG5vdCB4c2F2ZS1tYW5hZ2VkLiBJbiB2aXJ0dWFsaXphdGlvbiB3b3Js
ZCwNCj4gZ3Vlc3QNCj4gSUEzMl9TX0NFVCBpcyBzYXZlZC9zdG9yZWQgaW50by9mcm9tIFZNIGNv
bnRyb2wgc3RydWN0dXJlLiBXaXRoDQo+IHN1cGVydmlzb3INCj4geHN0YXRlIHN1cHBvcnQsIGd1
ZXN0IHN1cGVydmlzb3IgbW9kZSBzaGFkb3cgc3RhY2sgc3RhdGUgY2FuIGJlDQo+IHByb3Blcmx5
DQo+IHNhdmVkL3Jlc3RvcmVkIHdoZW4gMSkgZ3Vlc3QvaG9zdCBGUFUgY29udGV4dCBpcyBzd2Fw
cGVkIDIpIHZDUFUNCj4gdGhyZWFkIGlzIHNjaGVkIG91dC9pbi4NCj4gDQo+IFRoZSBhbHRlcm5h
dGl2ZSBpcyB0byBlbmFibGUgaXQgaW4gS1ZNIGRvbWFpbiwgYnV0IEtWTSBtYWludGFpbmVycw0K
PiBOQUtlZA0KPiB0aGUgc29sdXRpb24uIFRoZSBleHRlcm5hbCBkaXNjdXNzaW9uIGNhbiBiZSBm
b3VuZCBhdCBbKl0sIGl0IGVuZGVkDQo+IHVwDQo+IHdpdGggYWRkaW5nIHRoZSBzdXBwb3J0IGlu
IGtlcm5lbCBpbnN0ZWFkIG9mIEtWTSBkb21haW4uDQo+IA0KPiBOb3RlLCBpbiBLVk0gY2FzZSwg
Z3Vlc3QgQ0VUIHN1cGVydmlzb3Igc3RhdGUgaS5lLiwNCj4gSUEzMl9QTHswLDEsMn1fTVNScywN
Cj4gYXJlIHByZXNlcnZlZCBhZnRlciBWTS1FeGl0IHVudGlsIGhvc3QvZ3Vlc3QgZnBzdGF0ZXMg
YXJlIHN3YXBwZWQsDQo+IGJ1dA0KPiBzaW5jZSBob3N0IHN1cGVydmlzb3Igc2hhZG93IHN0YWNr
IGlzIGRpc2FibGVkLCB0aGUgcHJlc2VydmVkIE1TUnMNCj4gd29uJ3QNCj4gaHVydCBob3N0Lg0K
PiANCj4gWypdOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvODA2ZTI2YzItOGQyMS05
Y2M5LWEwYjctNzc4N2RkMjMxNzI5QGludGVsLmNvbS8NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFlh
bmcgV2VpamlhbmcgPHdlaWppYW5nLnlhbmdAaW50ZWwuY29tPg0KDQpSZXZpZXdlZC1ieTogUmlj
ayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K

