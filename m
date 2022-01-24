Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDF049795C
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 08:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241800AbiAXHWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 02:22:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:59031 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229829AbiAXHWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 02:22:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643008968; x=1674544968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zk60BwDyODT5zSZ6CztJxjNGV76Z9t61D1qLorZLSOg=;
  b=GLxOdnrSP20rElg3zsBcvcGNXJ9Hg3ZieoYQkzwxNs8R8iVH3GE+cZXI
   BdOHNRPoqhiEzqPyGyNfc2cA0nSXIjjSRB4gjNcIn+s7KRZsZ56cIfv+v
   DRknjstn33uo9dL9U4v0VZlDkHnRZJwZYk/8JItkNZIEMvuC3dVdPrAnA
   3P9w5QqsfyO+FHcKKaWdAJ9Prga8UUmdzbI4HIB976l9b94VWwQGIbe2C
   fjHXfBK7WRzKl8g8/Fl6Nz0PvojgJgwcIrP+j7H7eNTWyQ0Ke4KhVB9cl
   hnGawurY5+tyLnnoF0RKVcIlp69Q21aY42ZL60PmTybcpon/ife1yvEMM
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="243579308"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="243579308"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 23:18:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="534104700"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga008.jf.intel.com with ESMTP; 23 Jan 2022 23:18:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 23 Jan 2022 23:18:28 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 23 Jan 2022 23:18:28 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 23 Jan 2022 23:18:28 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 23 Jan 2022 23:18:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=af0uGxVuX3qT8VCq5bqvLU2kNtKeCezX/lrarSSr+ODEtNW2cYpZ4U6CSXjOg8Qv2XUchbxVZNpH9TSfjOZj1NmeMlx0hpRnWvIFQTeHMYSwLG9ravdCZduIqVVR1bF38TFMb9/KHRfgYOSVN8NcdrYuZJyZhRKUy39AiLwuIEy7gbSQGg9pyuV5sIf0WsAEUdBtYuPjfrKvcmeK4NXWkO9XGz510lnJx0COtIqyU1V5t/smTo8LaWHIHeyF91yfwAcoSegT+5DRXkfygaVGuJQjMxPaI1dNo1jk82Nsr8Ymd9cvhOvKmiw12cabvKneD+MSae1ToJr7Dq/1cSlnsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zk60BwDyODT5zSZ6CztJxjNGV76Z9t61D1qLorZLSOg=;
 b=gZ6eshbNRV1o4fT23yXsnfLJiWGvkMR63sM+V6CuzWLmaJlRpdroQYjmzh7DETqqvE+vUFQgqio8HOzoe/ffn69PvcRwQbZzrL5T2dYRF/PvWHgViIc6ZpzPOFyLZgsLQ4FrFVNni8BS6tTKbWvXoM5RdgsjZwsKFykkkpPOLGMPT9nWxX69gXemRzIcTSrn90io44J1Bd0l98uzgruhVxKdtsCIox2VSbxYb//97juMzEFmy5As43Y2y2T9nu09XD4YXUfd2SoscEH0p8TajzHU0WW41h5SxLTPmhCjTdBK47s+kDq+2SKoJVz0BTE9/YpNWaFsZ1+zLm/ioaJdtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5680.namprd11.prod.outlook.com (2603:10b6:a03:305::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Mon, 24 Jan
 2022 07:18:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%5]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 07:18:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>
CC:     "Zeng, Guang" <guang.zeng@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 04/21] kvm: x86: Exclude unpermitted xfeatures at
 KVM_GET_SUPPORTED_CPUID
Thread-Topic: [PATCH v6 04/21] kvm: x86: Exclude unpermitted xfeatures at
 KVM_GET_SUPPORTED_CPUID
Thread-Index: AQHYA/gp2KQMv9WIrk+FB2q8dC89bKxwOz8AgAGhbJA=
Date:   Mon, 24 Jan 2022 07:18:20 +0000
Message-ID: <BN9PR11MB5276A817FEC26CAFCCE11CEA8C5E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-5-pbonzini@redhat.com>
 <75fe2317-4159-adbe-30f8-5bbd2f5e9d11@gmail.com>
In-Reply-To: <75fe2317-4159-adbe-30f8-5bbd2f5e9d11@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68b558e4-e72d-4628-c15d-08d9df09b36b
x-ms-traffictypediagnostic: SJ0PR11MB5680:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR11MB5680FC9FCF99FCA5B0A9CBA48C5E9@SJ0PR11MB5680.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pRSA1cbroH9049KS8TrmK2cAc0JE+F2RuK2VS5WB/7a+MeR5/gYrO/brQo+FDszi1dyAoGUvepwgL3dOABE+gMtIIa3CwOG4D8uu3SeUJk9A/c75TDlFXZRIo730Gdaez5dTmcbVGt7hKASIsUmmjfDXZauffmoyQDfmKuOu5EHeSC0riEYwWraoqbxo2WWqMAK4MUKDbLOJeJ6LgFzGsgvUnHwZSi7gYTvURoscgHYyBBJnUNNSHdTufWh/lgyahC31xWRkkVIP4TrT4cg2HGp1PNtlVdeafnJllvPGaJ9j8hq5DByVsV77f9BDPl03v64ZRPa3d+oAuzIERfY/+hl6GSKg85LZlDOFmgtPM3R9w9F/m5Jl+YY9u/rV3kSTgnh4BpZqjEQyZ+NGqyvKYUOx5Yk0DBqO6MS+4uCWmBaNyWL86dxEZYRX+9vx2xbCaQGF1ej9vAB+Ouwkkzhy1CCgJPcF0ttrXMBryLMI5sF2kF3Y6cX3YPNPkaTN0Xc/dEPteFJHo3C57DOQvIc9KVnHkUhQEU+eIByGfPye8zaXEQt+gN+wbqlTbBg4ZjYgFEgeMg86CxU9OoXSuI9wPt75fOCJBmRsOFgJJ9eeFZZCglu+/fhFQP42YUsmkZbBSRgtd78+1A9AY0y6rdJ+qgR1dXEsLPW7T4lznCGM70gPUe2/qSxU60/05oZpWVEjqvKmYLo+lyy5mBYNB2nIEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(2906002)(5660300002)(76116006)(64756008)(66446008)(186003)(110136005)(4326008)(55016003)(8936002)(83380400001)(33656002)(66946007)(66556008)(71200400001)(52536014)(508600001)(8676002)(122000001)(53546011)(86362001)(6506007)(82960400001)(7696005)(316002)(54906003)(26005)(6636002)(38070700005)(38100700002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTdjL2F4ODB1aDZqeStUUnRQbXR3TTFpWE0yZExUejY2QkNMQTZsUjIzUGhx?=
 =?utf-8?B?dkpkUEtYMXlNMTdYZmVFZXhERWt2R3VwUm10SmJmSzNWYTBCOGpCN0RoQWdw?=
 =?utf-8?B?N0tMNythSGRGUEpVN2sxQVVWVHpHU2FDOXdyMk5xd25mSHJzd0dxRS9yUDhk?=
 =?utf-8?B?MGdKb1JlWVBOYndCYmpnQ2thb2dnOGdheGNMcnRjMXA3Z0p5S3JibUx5V0Nm?=
 =?utf-8?B?NC9ZRmdWT3UwdFhXVWpkV1RNQ0tKeVJEVWovRTNHVlA5c0hTcm9SZG9SVVp3?=
 =?utf-8?B?K1RyWTV4U2pMbVpURDdra2o0dTVraFYwMnNpbUF1alNVRlEyNE13QzcvRkVk?=
 =?utf-8?B?aEV3YmtiL1pobHNOaHRpOVpVUTJsYmJDc1NPRnpPa3dyVUhrczZPcHUxL1Bi?=
 =?utf-8?B?VVZ1blZVY2ZKeVVldVh4TTRnc1VHUW1qZEJqQjZ6VHY5TFphTjJMSHJLNkhK?=
 =?utf-8?B?S1F2blBBRGxsdk1QcFdURnJEclF6ZXY5TGlNRHRtdks4M245WmhWNVZ1UTA4?=
 =?utf-8?B?Y2RrMzNYL1VxRmhiOFVaTlFHOVVEY0UyUmtBbmNzQnF0bnA0YkQ3Rkp1STdK?=
 =?utf-8?B?SUp2c0NpS0l5ZzJwN3hHa0JMZm15cWNXWVlrb2NjTzBrZXlkSml5ODhGTTRh?=
 =?utf-8?B?Z3B1TzhIRUc4aGJBV0UrdzRQTkw3S3A1SWpOQXRFUjljL3hqQWpuVFhjejI0?=
 =?utf-8?B?RzNETGNoMXNGQTk5UExuNGxRY3VCeG9TbnBwaDBhbk9wTmlzVUFQUncrdzNY?=
 =?utf-8?B?dEpJazFvNVZLSkllcW1McTVmbTBTNmdnYXN5U0J2WTB1UTZwQmFPZVU5OVU3?=
 =?utf-8?B?RGYxV2F5TnVIaVhZQ0haM3BCQ2FBNXhhZkFWNmQ5b0ZCY3l4WWFLN29mMm92?=
 =?utf-8?B?d0tEZVdwY3VWVEhQR1prb1ZkNGJzbnh1QXZiSU1PL3doQXFsVm9pNXVNVm9Q?=
 =?utf-8?B?MUtMNEZDb0dWTXhvaDlRcElXN2g0OTlXVjlYWC9yNm1WQll2QWh6QWppT1Zt?=
 =?utf-8?B?WEZ5QkRiSENlRWFiQ3p1S010alFLVkVjREErTzFpcGtnQzFPeHdkcGdvVzVo?=
 =?utf-8?B?S1l0WDZkd3FtemZxL0pGOW9JSXp0eUpucE5JU3BuS0F4U1RSRG5XWjNob3dz?=
 =?utf-8?B?Qis4NzcxS3NNK3JET01NNlZJdEFuNGsyWGp4MUMvVDBNandlaUczaXEwdG5Z?=
 =?utf-8?B?VmRsRlVEM0I0ZDFwUnZybFkrVUhFOXVVNm5rVHJiYWhJU3JUWEQvT01JMEdl?=
 =?utf-8?B?OU1lNHV1NDJ2WWNQK0xPUXMvR0VYTmJSdFhnenJKMkc0UkF5d2VtV1dHb0g3?=
 =?utf-8?B?aVIydmJESm5NN3VkbklxSktsbkFkbWV1ZE10UTk3a2YyejBrWVFJWWs5ZGFv?=
 =?utf-8?B?R0VieFdrb0hER2lpNnhNRkVvaGwySkkxakFKSDRPYk9xYTJIeDAwamFIY0R1?=
 =?utf-8?B?T3pFTldhanY2Z2lYUVU5TEZUTzdVM1c1RnBoWEZreTBETHV2U1gzS3BBRHhT?=
 =?utf-8?B?Y2xRSHdVTWd2bHFRVGsxaEU0RWM4UVZ6RW1UblpZWVV0RTBoa2c0SWNtSVAy?=
 =?utf-8?B?ZlloVjJzOTBjeWN3SVdGejUxQmM3Y0dFellmdmtuWG1LYUVlRlg5UVArVmVz?=
 =?utf-8?B?ZDBqUTgyZi83ZU5NbTgrNGQ5YWI1bVY5bkNlUmF5Tk5ncStFTzJIS2JKdmcr?=
 =?utf-8?B?UTZuaTRaTHVPcjNMWURqTG12WVdBb1ZjUDQzTWJxY0JhVnZ5ZUJ3M3JzNG1H?=
 =?utf-8?B?R01kY3NBbHFXSlVoQTZ3cUNVOW1KZWVqaWJnbm9PRXJNOVpoK0lvN3VGY2Jk?=
 =?utf-8?B?MU5NQkVvaWs4UnRsci81MWVVTVZid0l0M0xBNms3Z1cxM1M4MUIxTVd5dlVm?=
 =?utf-8?B?b0M0L25WV2VSNTBybmM1Tnc0TmVYMFpLTmVlaDRvaTFPbnkwV2JzcjVQTWpt?=
 =?utf-8?B?REQ4WUNCemVTdjhTUHI0ei9RMDUyWEdLSTQ3Umk3c2ZSeFFjM0doK1crck5P?=
 =?utf-8?B?T0plRFV4N2VQYThCMEUzK1oyWVN3eTJ0RkR5bElsWmF2ZkRRd3NjNnI5bWZI?=
 =?utf-8?B?dGlzdGdvd2lMOFR6emJUWXN3b3QvM3BGUWVKTGlqV1RvSEl3Q2VhcklDcEFC?=
 =?utf-8?B?RmFhcDhUQy80WVRYMnpOcXFJUXY4TXBadWhSTlUzcEdseHNVaVY4dmtxbFpt?=
 =?utf-8?Q?Upl4K2QN6Sc+TljDhJ6ShPw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b558e4-e72d-4628-c15d-08d9df09b36b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 07:18:20.5638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /C/egI32GO5FDB1ar62ZioV3HQA9WyNLdTU8Im5hADrDmZuQe8M4iAOvyNl7T0RcLEnbFWjXwg6O7BdHkwZt3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5680
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaWtlIFh1IDxsaWtlLnh1LmxpbnV4QGdtYWlsLmNvbT4NCj4gU2VudDogU3VuZGF5
LCBKYW51YXJ5IDIzLCAyMDIyIDI6MjIgUE0NCj4gDQo+IE9uIDgvMS8yMDIyIDI6NTQgYW0sIFBh
b2xvIEJvbnppbmkgd3JvdGU6DQo+ID4gRnJvbTogSmluZyBMaXUgPGppbmcyLmxpdUBpbnRlbC5j
b20+DQo+ID4NCj4gPiBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRCBzaG91bGQgbm90IGluY2x1ZGUg
YW55IGR5bmFtaWMgeHN0YXRlcyBpbg0KPiA+IENQVUlEWzB4RF0gaWYgdGhleSBoYXZlIG5vdCBi
ZWVuIHJlcXVlc3RlZCB3aXRoIHByY3RsLiBPdGhlcndpc2UNCj4gPiBhIHByb2Nlc3Mgd2hpY2gg
ZGlyZWN0bHkgcGFzc2VzIEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlEIHRvDQo+ID4gS1ZNX1NFVF9D
UFVJRDIgd291bGQgbm93IGZhaWwgZXZlbiBpZiBpdCBkb2Vzbid0IGludGVuZCB0byB1c2UgYQ0K
PiA+IGR5bmFtaWNhbGx5IGVuYWJsZWQgZmVhdHVyZS4gVXNlcnNwYWNlIG11c3Qga25vdyB0aGF0
IHByY3RsIGlzDQo+ID4gcmVxdWlyZWQgYW5kIGFsbG9jYXRlID40SyB4c3RhdGUgYnVmZmVyIGJl
Zm9yZSBzZXR0aW5nIGFueSBkeW5hbWljDQo+ID4gYml0Lg0KPiA+DQo+ID4gU3VnZ2VzdGVkLWJ5
OiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlhbmcg
WmhvbmcgPHlhbmcuemhvbmdAaW50ZWwuY29tPg0KPiA+IE1lc3NhZ2UtSWQ6IDwyMDIyMDEwNTEy
MzUzMi4xMjU4Ni01LXlhbmcuemhvbmdAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBh
b2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQo+ID4gLS0tDQo+ID4gICBEb2N1bWVu
dGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgfCA0ICsrKysNCj4gPiAgIGFyY2gveDg2L2t2bS9jcHVp
ZC5jICAgICAgICAgICB8IDkgKysrKysrLS0tDQo+ID4gICAyIGZpbGVzIGNoYW5nZWQsIDEwIGlu
c2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1l
bnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0DQo+IGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGku
cnN0DQo+ID4gaW5kZXggNmI2ODNkZmVhOGYyLi5mNGVhNWU0MWE0ZDAgMTAwNjQ0DQo+ID4gLS0t
IGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlv
bi92aXJ0L2t2bS9hcGkucnN0DQo+ID4gQEAgLTE2ODcsNiArMTY4NywxMCBAQCB1c2Vyc3BhY2Ug
Y2FwYWJpbGl0aWVzLCBhbmQgd2l0aCB1c2VyDQo+IHJlcXVpcmVtZW50cyAoZm9yIGV4YW1wbGUs
IHRoZQ0KPiA+ICAgdXNlciBtYXkgd2lzaCB0byBjb25zdHJhaW4gY3B1aWQgdG8gZW11bGF0ZSBv
bGRlciBoYXJkd2FyZSwgb3IgZm9yDQo+ID4gICBmZWF0dXJlIGNvbnNpc3RlbmN5IGFjcm9zcyBh
IGNsdXN0ZXIpLg0KPiA+DQo+ID4gK0R5bmFtaWNhbGx5LWVuYWJsZWQgZmVhdHVyZSBiaXRzIG5l
ZWQgdG8gYmUgcmVxdWVzdGVkIHdpdGgNCj4gPiArYGBhcmNoX3ByY3RsKClgYCBiZWZvcmUgY2Fs
bGluZyB0aGlzIGlvY3RsLiBGZWF0dXJlIGJpdHMgdGhhdCBoYXZlIG5vdA0KPiA+ICtiZWVuIHJl
cXVlc3RlZCBhcmUgZXhjbHVkZWQgZnJvbSB0aGUgcmVzdWx0Lg0KPiA+ICsNCj4gPiAgIE5vdGUg
dGhhdCBjZXJ0YWluIGNhcGFiaWxpdGllcywgc3VjaCBhcyBLVk1fQ0FQX1g4Nl9ESVNBQkxFX0VY
SVRTLCBtYXkNCj4gPiAgIGV4cG9zZSBjcHVpZCBmZWF0dXJlcyAoZS5nLiBNT05JVE9SKSB3aGlj
aCBhcmUgbm90IHN1cHBvcnRlZCBieSBrdm0gaW4NCj4gPiAgIGl0cyBkZWZhdWx0IGNvbmZpZ3Vy
YXRpb24uIElmIHVzZXJzcGFjZSBlbmFibGVzIHN1Y2ggY2FwYWJpbGl0aWVzLCBpdA0KPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vY3B1aWQuYyBiL2FyY2gveDg2L2t2bS9jcHVpZC5jDQo+
ID4gaW5kZXggZjNlNmZkYTZiODU4Li5lYjUyZGRlNWRlZWMgMTAwNjQ0DQo+ID4gLS0tIGEvYXJj
aC94ODYva3ZtL2NwdWlkLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vY3B1aWQuYw0KPiA+IEBA
IC04MTUsMTEgKzgxNSwxMyBAQCBzdGF0aWMgaW5saW5lIGludCBfX2RvX2NwdWlkX2Z1bmMoc3Ry
dWN0DQo+IGt2bV9jcHVpZF9hcnJheSAqYXJyYXksIHUzMiBmdW5jdGlvbikNCj4gPiAgIAkJCQln
b3RvIG91dDsNCj4gPiAgIAkJfQ0KPiA+ICAgCQlicmVhazsNCj4gPiAtCWNhc2UgMHhkOg0KPiA+
IC0JCWVudHJ5LT5lYXggJj0gc3VwcG9ydGVkX3hjcjA7DQo+ID4gKwljYXNlIDB4ZDogew0KPiA+
ICsJCXU2NCBndWVzdF9wZXJtID0geHN0YXRlX2dldF9ndWVzdF9ncm91cF9wZXJtKCk7DQo+ID4g
Kw0KPiA+ICsJCWVudHJ5LT5lYXggJj0gc3VwcG9ydGVkX3hjcjAgJiBndWVzdF9wZXJtOw0KPiA+
ICAgCQllbnRyeS0+ZWJ4ID0geHN0YXRlX3JlcXVpcmVkX3NpemUoc3VwcG9ydGVkX3hjcjAsIGZh
bHNlKTsNCj4gDQo+IElmIHdlIGNob29zZSB0byBleGNsdWRlIHVucGVybWl0dGVkIHhmZWF0dXJl
cyBpbiB0aGUgZW50cnktPmVheCwgd2h5IGRvDQo+IHdlIGNob29zZSB0byBleHBvc2UgdGhlIHNp
emUgb2YgdW5wZXJtaXR0ZWQgeGZlYXR1cmVzIGluIGVieCBhbmQgZWN4Pw0KPiANCj4gVGhpcyBz
ZWVtcyB0byBiZSBhbiBpbmNvbnNpc3RlbmN5LCBob3cgYWJvdXQ6DQo+IA0KPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL2NwdWlkLmMgYi9hcmNoL3g4Ni9rdm0vY3B1aWQuYw0KPiBpbmRleCAx
YmQ0ZDU2MGNiZGQuLjE5M2NiZjU2YTVmYSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL2Nw
dWlkLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL2NwdWlkLmMNCj4gQEAgLTg4OCwxMiArODg4LDEy
IEBAIHN0YXRpYyBpbmxpbmUgaW50IF9fZG9fY3B1aWRfZnVuYyhzdHJ1Y3QNCj4ga3ZtX2NwdWlk
X2FycmF5DQo+ICphcnJheSwgdTMyIGZ1bmN0aW9uKQ0KPiAgIAkJfQ0KPiAgIAkJYnJlYWs7DQo+
ICAgCWNhc2UgMHhkOiB7DQo+IC0JCXU2NCBndWVzdF9wZXJtID0geHN0YXRlX2dldF9ndWVzdF9n
cm91cF9wZXJtKCk7DQo+ICsJCXU2NCBzdXBwb3J0ZWRfeGNyMCA9IHN1cHBvcnRlZF94Y3IwICYN
Cj4geHN0YXRlX2dldF9ndWVzdF9ncm91cF9wZXJtKCk7DQo+IA0KPiAtCQllbnRyeS0+ZWF4ICY9
IHN1cHBvcnRlZF94Y3IwICYgZ3Vlc3RfcGVybTsNCj4gKwkJZW50cnktPmVheCAmPSBzdXBwb3J0
ZWRfeGNyMDsNCj4gICAJCWVudHJ5LT5lYnggPSB4c3RhdGVfcmVxdWlyZWRfc2l6ZShzdXBwb3J0
ZWRfeGNyMCwgZmFsc2UpOw0KPiAgIAkJZW50cnktPmVjeCA9IGVudHJ5LT5lYng7DQo+IC0JCWVu
dHJ5LT5lZHggJj0gKHN1cHBvcnRlZF94Y3IwICYgZ3Vlc3RfcGVybSkgPj4gMzI7DQo+ICsJCWVu
dHJ5LT5lZHggJj0gc3VwcG9ydGVkX3hjcjAgPj4gMzI7DQo+ICAgCQlpZiAoIXN1cHBvcnRlZF94
Y3IwKQ0KPiAgIAkJCWJyZWFrOw0KPiANCj4gSXQgYWxzbyBoZWxwcyB0byBmaXggdGhlIENQVUlE
X0RfMV9FQlggYW5kIGxhdGVyIGZvciAoaSA9IDI7IGkgPCA2NDsgKytpKTsNCj4gDQo+IElzIHRo
ZXJlIGFueXRoaW5nIEkndmUgbWlzc2VkID8NCg0KTm8sIHlvdSBhcmUgY29ycmVjdC4gV291bGQg
eW91IHBsZWFzZSBzZW5kIG91dCBhIGZvcm1hbCBmaXg/DQoNCj4gDQo+ID4gICAJCWVudHJ5LT5l
Y3ggPSBlbnRyeS0+ZWJ4Ow0KPiA+IC0JCWVudHJ5LT5lZHggJj0gc3VwcG9ydGVkX3hjcjAgPj4g
MzI7DQo+ID4gKwkJZW50cnktPmVkeCAmPSAoc3VwcG9ydGVkX3hjcjAgJiBndWVzdF9wZXJtKSA+
PiAzMjsNCj4gPiAgIAkJaWYgKCFzdXBwb3J0ZWRfeGNyMCkNCj4gPiAgIAkJCWJyZWFrOw0KPiA+
DQo+ID4gQEAgLTg2Niw2ICs4NjgsNyBAQCBzdGF0aWMgaW5saW5lIGludCBfX2RvX2NwdWlkX2Z1
bmMoc3RydWN0DQo+IGt2bV9jcHVpZF9hcnJheSAqYXJyYXksIHUzMiBmdW5jdGlvbikNCj4gPiAg
IAkJCWVudHJ5LT5lZHggPSAwOw0KPiA+ICAgCQl9DQo+ID4gICAJCWJyZWFrOw0KPiA+ICsJfQ0K
PiA+ICAgCWNhc2UgMHgxMjoNCj4gPiAgIAkJLyogSW50ZWwgU0dYICovDQo+ID4gICAJCWlmICgh
a3ZtX2NwdV9jYXBfaGFzKFg4Nl9GRUFUVVJFX1NHWCkpIHsNCg==
