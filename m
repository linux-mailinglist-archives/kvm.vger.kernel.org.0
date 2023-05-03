Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDC36F6204
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjECXYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjECXYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:24:07 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29CE9029;
        Wed,  3 May 2023 16:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683156244; x=1714692244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=STdAOgqa9ELunq/AlN+xzk6foa6N+J1oKFBEdFxKnok=;
  b=JJaJsXQOnh6sOgxKepNdA1yVcmvaUggSbSez7b2A8vrP3y3YJCvlEKhc
   fTHMk2cvMv6a/5fDKkNwby2czItmZdidyc3YKSlOkwP7eTWjGRMVLAAmh
   U9N2b84vmS6wtCIBpn/YWRDiGl6Tj/Nc8iOhW5RQCUIrYYFyRKY1GVqH6
   C0PWB/h4+9d53MnF6IYArQBy0n96YAgPSE72DDIK2Xw1Aa0TZb9yzjhlL
   iVXKRbCLvEtGf7f9ZUcu/FFiAgxymmQFUA9R98xD7+XpiJ+N3Kk+jRZfI
   d8mPLa6YgtPvR3aFpmiqXEe3U/A8O6WZZfOxhiGY6GJqUET7SHzoU2m3f
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="411953712"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="411953712"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 16:24:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="727329899"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="727329899"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 03 May 2023 16:24:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:24:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 16:24:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 16:24:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaEa1KpHdYjE+6VDspf4NgA6Rk8soXxNGL4Mh9GFwfBdKpuqPzAYlrNh1DFsRDM2wAx1xOz/lO392kLuiH3o3bbH5g1ZYSQqIpcebyI3Fe4OP3Jr/A+ZOH2TvzGRKm/3A8L5nae/tLmmpdd7p2rOZDZnp+uChEmve1TlnVyntthS+JgSq4muJcSBd+YIEe6n7vjus24g0/1PWLEpKsZRX2G1YE9XJJIPitL4vNGN37eu8YW9rFr83uW/Tx1BWz2fMIeZDXIN4E3vFkhd+zEeO9uOtFDRDX5nXP63jYM3BawC7m6Avbzn5mP4M6Slcl5eU5QDcuvQOxNHlF1hFidrdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STdAOgqa9ELunq/AlN+xzk6foa6N+J1oKFBEdFxKnok=;
 b=SOJPjO6YpBRlVFYhnql+xi60ItfiiLdX0X0bmzfQfdB1qyRsp47Bf+9BFVkhiBEbYWJhmTmdJN6z14MmOSYt4f2t61hQPB2R+FBSGPikJrdFqd+u9ETCmVUhTlxDlzmB68AHyOUJEKyub3yRhhh9JKhj2XXK4K60N5zvbp7ui0y2yb0NqplZgV+Ik5qDVHRbDEajGe9JmMvrEb4+iZu/JLHJoVYWlm9dZp1KpkpQqF2daBfxFSdymCbBlL0EPXJA2EZLXq+dh626CEbKToNEutl5X6ccog4NiccRwWn/SxY7vUr/1fPJZ9PEbc3RuNqNxn152eWpxE1cali3idOsag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5468.namprd11.prod.outlook.com (2603:10b6:408:101::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 23:24:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 23:24:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH 3/5] KVM: x86: Use MTRR macros to define possible MTRR MSR
 ranges
Thread-Topic: [PATCH 3/5] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Thread-Index: AQHZfe1ov2lIQfXQHEGWFmfB/aS7ZK9JMM2A
Date:   Wed, 3 May 2023 23:23:59 +0000
Message-ID: <b57efeeb80319183e93d5a10bc8a812ff891bd53.camel@intel.com>
References: <20230503182852.3431281-1-seanjc@google.com>
         <20230503182852.3431281-4-seanjc@google.com>
In-Reply-To: <20230503182852.3431281-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5468:EE_
x-ms-office365-filtering-correlation-id: 2650c6fe-37c7-4911-5736-08db4c2d7991
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UZc2ylP/tzC2u+oFcO/f0tnkdNr6ux17sZlH+szui4JQFRSIIpC4JG7TNv56xqwmzrnogCKGvn8ttXz9+m+VE71/Pu6QjYZ0jXtAhvfWaTwRjLyj6R4h3mAnoE3HzQoITaUT1shb8gO5fX7ORHG1W0pikDWKSORRcQvc9QfLZvBR8O6KUuLNA4oIhVkFWcWM07M9eRkKcf5Uom2DWTrg381Wur6J4/0JtNntbuAmzwki5AyyN+fLcBNsMA/E71s3KNXUn71v9qOicPvBQL1Zm+GI4BVrxBe5Jcrgu8GVU6oyvxLCWhDjMgY1gB/vR1KKUcRq9Gr30sxHfADfBQKyIksBfQydDR6qGUZXLx1oV7p8Rx0mTN/TupKRej3Ezu0IaN4DHg/YC6HP0RsPC/HCv0gSl/ozvUGKI4t6qXPpJVyEOgakHovZNs1kyomD3i4IKOivq0Ebc124jSRj2sVVuApFLpJtttNZ4RySPeKql3zfD8nFozBzl7l0rtJBKlHOLVs5aRCM8E64t9gOhe1LBitUP1JD2KK5dXpiU6rlTmdVQ+R8odeYz2W+KbMk62MSu2pUHMeuiRscefWRPMrngwTrbCbOcfsB6ozo/ruUUyFy0hDkpn+doHl5JWAnwRsw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199021)(2906002)(8936002)(66446008)(4326008)(64756008)(66476007)(66556008)(316002)(91956017)(8676002)(76116006)(66946007)(54906003)(110136005)(5660300002)(41300700001)(478600001)(6486002)(83380400001)(71200400001)(6512007)(6506007)(26005)(82960400001)(2616005)(186003)(36756003)(38070700005)(86362001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dE5TZzE5YUxtMmduVG9RTlBabldFaTJYWGk2dUQwaHJlSFc4RGo4T0NVTEZN?=
 =?utf-8?B?MVowV2VXcFo1TFZzMzFFNlJldzlkNG1MTUdEcVhWajdUWk93NjJIL0dkMm93?=
 =?utf-8?B?MmRzdUZtZDd0a2w3RVE4V2VGWE11bUdoNkdYaUtRajdvSUw4Q013SjU2WEIy?=
 =?utf-8?B?QjRacEZrZ2VDVlNGTTNFclB0THBmZ1d4aXdjWWVxM2piYS9QSUlLUzBhOWMy?=
 =?utf-8?B?R2k1aklBMVBtN2wrbUtPUjRnZTFoNWd5QVYzbGZCY0xXYUJaOEthQnYzNmxY?=
 =?utf-8?B?clhWMkNoV080V2c1bEY0aGtQSnBvMG81a0N0ZUk2emkwUjhDWlVQaUx5RGMy?=
 =?utf-8?B?aFNEQjJFNE94ZmdlY052cTZkcGxzWGhHQ1hJT2xQc1RlVFJ3dHZVYk5hOVNs?=
 =?utf-8?B?aTZiVWFPZ005Q2dFSzMzL1F6bC94UkdHVUZRbXNIMFQ5Y3lNV0NsMy9tR2ly?=
 =?utf-8?B?YlpnQjN4TUxSMXRxN0hadDJjdURFSi9pR0NLT09nNUZqZWtWZUtIY1Z5d1VG?=
 =?utf-8?B?NkpNTjNKUVpkUjJBNEcvOTEzTHR0Y21yOVdNdnU5SnhGWkRSK05uYjVmTVY1?=
 =?utf-8?B?UnRleU1Ed1RYZjJXM0ZzMGR6UTVlcEFvbGk2Z2ZzMEkwT0ZGZFBCZ2FpZHRq?=
 =?utf-8?B?U0JINUlUN2IxZldYK05XVXY4SHJjREpLei8yc2NFbW5LeEpKVzJsN2RKNVRQ?=
 =?utf-8?B?ZTEzbktLZkFMRU92YWZPNXN2T09QM2ZZbk9CZTFFcjFYQ095Q3RxZHZqdE9B?=
 =?utf-8?B?WHRoT2ZKVFVjMWpHVHdieWtLMEJINnBKeThyNWxuSmRpYytiVmV5VUVoekVZ?=
 =?utf-8?B?VEtSRnRxSXpTd05idERTd0ZlRkpackl4WUk2TDNaWTFoVG4zUFdhTGhPQTd3?=
 =?utf-8?B?ZDhERk9kQVJaK0s5djUvMUphODlXLzNVOERtSlpEVXlvQldkVlFpd2MwaGhz?=
 =?utf-8?B?WFpjRzcwZVdwMld1ZEhXZ1N6MTMzeWdJWGkvendEZk5mQmxFRmM2bVhsOVYv?=
 =?utf-8?B?ZElPQll0SWUyUWZFZUJkY2xLMjBDZUpRMTliNXNoQllWbzl4Tk1Wb1RzdW93?=
 =?utf-8?B?d0NCRGsvRFdoSEZxU3B6bjdkODJaRzN5SUFxSGxWbWJGT1Z1cjBsYmsvcFJ3?=
 =?utf-8?B?Smtocnc3WVpiRVpWTS9zQUt3Yk93ODZ5MGdBTSsyOWNCNzF5R01mVWY4TE9S?=
 =?utf-8?B?L21xSWJaVGlKemE3N2w4U3NQSENHaEdNdVN2U25mclk3NkRwTjdWbll2Q0tL?=
 =?utf-8?B?L0lDNi9SK1hXeDV1S0VVWE1zZWhZQjRYNWZ3TGhxbS9hN1RUTTM3V2ExVTUx?=
 =?utf-8?B?QXNaTE8wWXF3NkNodVU2T0hQNFNMcDJUemllSStWVURlTGwxbWh2ckNQRnd1?=
 =?utf-8?B?dEpJKzY1YjBpWWg5cGh0aVpMbjdndmtWWCtqa014UkxwQU03ZEhYMWttc240?=
 =?utf-8?B?czUrZ0dNNWNzQzlRQnpndUxtYUcxYSs0dTBlSHFhczh6NUFndXR5Z3pDWkpC?=
 =?utf-8?B?VkE1bVpZeTBBMHg3RkN3ck9uMFNKZWk4NkErWUprZjltcEpENEl6K2FnSUpt?=
 =?utf-8?B?cllNV1NDblpwRWNDaHFYSTRjY2xSYTF1MURUd2Z5a2k3R3haQWVBbkZMdDdw?=
 =?utf-8?B?N2x0bmtzOFNtcnRlMDFJQW0rTE5yaS84aDNBcXg3bUFCbTN4aDIvTTBoZkRR?=
 =?utf-8?B?VlV3WVdNeUZWd3p3VWlNM3FwZU9hb2d3Rjl3MllFNTQ4VUxsbjJPaE9CZFBE?=
 =?utf-8?B?NC9Vd1o5L2hFZU1VM1ZHT0ZxcFVZWENNRU4zS2tmWUdyTnBPaFE1ZTArbFk5?=
 =?utf-8?B?blY5UDBJZ1BZY3cvd2pyNUp1QjEyT3pQaldWVGZkUlFNNlQ2ZkM0NHBuMzdP?=
 =?utf-8?B?M0xuckVFUklPWmljbStXcVg4U0VxYkVOMmx4U2oybXFaRDhuZHBGcXhyVFVn?=
 =?utf-8?B?MHpGeTJlMEFxYUJvNDdIekkwbkFLSWM2ZUZVOHVoNEVPaThhY1JHUG9DaXdL?=
 =?utf-8?B?akV6Y2xLNW5XdHU4ZklBc3dkQ2IrSndvbGR1cWxaS25yQXlGQ3ovQ3Z2NnJV?=
 =?utf-8?B?anZuV05iRHhHOUpMNEtjZm92dUtSRDJ5ZlBWcnUvMU1INVUrYU16MmdsWGk1?=
 =?utf-8?Q?fIi1PgZvu23kMdsK+8wRV4qSI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70B4F76442E0BE4485B3801F75679A54@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2650c6fe-37c7-4911-5736-08db4c2d7991
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 23:23:59.9304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E5BEoDHHQ+MFK8TArZJZrA6cXHSy7jfCHZ52SaFsvdzvF8cSUcRylfAYGp8dsmPgDtfYtt9pvuXpeX23mvYAXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5468
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTAzIGF0IDExOjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgdGhlIE1UUlIgbWFjcm9zIHRvIGlkZW50aWZ5IHRoZSByYW5nZXMgb2YgcG9z
c2libGUgTVRSUiBNU1JzIGluc3RlYWQNCj4gb2YgYm91bmRpbmcgdGhlIHJhbmdlcyB3aXRoIGEg
bWlzbWFzaCBvZiBvcGVuIGNvZGVkIHZhbHVlcyBhbmQgdW5yZWxhdGVkDQo+IE1TUiBpbmRpY2Vz
LiAgQ2FydmluZyBvdXQgdGhlIGdhcCBmb3IgdGhlIG1hY2hpbmUgY2hlY2sgTVNScyBpbiBwYXJ0
aWN1bGFyDQo+IGlzIGNvbmZ1c2luZywgYXMgaXQncyBlYXN5IHRvIGluY29ycmVjdGx5IHRoaW5r
IHRoZSBjYXNlIHN0YXRlbWVudCBoYW5kbGVzDQo+IE1DRSBNU1JzIGluc3RlYWQgb2Ygc2tpcHBp
bmcgdGhlbS4NCj4gDQo+IERyb3AgdGhlIHJhbmdlLWJhc2VkIGZ1bm5lbGluZyBvZiBNU1JzIGJl
dHdlZW4gdGhlIGVuZCBvZiB0aGUgTUNFIE1TUnMNCj4gYW5kIE1UUlJfREVGX1RZUEUsIGkuZS4g
MHgyQTAtMHgyRkYsIGFuZCBpbnN0ZWFkIGhhbmRsZSBNVFRSX0RFRl9UWVBFIGFzDQo+IHRoZSBv
bmUtb2ZmIGNhc2UgdGhhdCBpdCBpcy4NCj4gDQo+IEV4dHJhY3QgUEFUICgweDI3NykgYXMgd2Vs
bCBpbiBhbnRpY2lwYXRpb24gb2YgZHJvcHBpbmcgUEFUICJoYW5kbGluZyINCj4gZnJvbSB0aGUg
TVRSUiBjb2RlLg0KPiANCj4gS2VlcCB0aGUgcmFuZ2UtYmFzZWQgaGFuZGxpbmcgZm9yIHRoZSB2
YXJpYWJsZStmaXhlZCBNVFJScyBldmVuIHRob3VnaA0KPiBjYXB0dXJpbmcgdW5rbm93biBNU1Jz
IDB4MjE0LTB4MjRGIGlzIGFyZ3VhYmx5ICJ3cm9uZyIuICBUaGVyZSBpcyBhIGdhcCBpbg0KPiB0
aGUgZml4ZWQgTVRSUnMsIDB4MjYwLTB4MjY3LCBpLmUuIHRoZSBNVFJSIGNvZGUgbmVlZHMgdG8g
ZmlsdGVyIG91dA0KPiB1bmtub3duIE1TUnMgYW55d2F5cyzCoA0KPiANCg0KTG9va3MgYSBsaXR0
bGUgYml0IGhhbGYgbWVhc3VyZSwgYnV0IC4uLg0KDQo+IGFuZCB1c2luZyBhIHNpbmdsZSByYW5n
ZSBnZW5lcmF0ZXMgbWFyZ2luYWxseSBiZXR0ZXINCj4gY29kZSBmb3IgdGhlIGJpZyBzd2l0Y2gg
c3RhdGVtZW50Lg0KDQpjb3VsZCB5b3UgZWR1Y2F0ZSB3aHkgYmVjYXVzZSBJIGFtIGlnbm9yYW50
IG9mIGNvbXBpbGVyIGJlaGF2aW91cj8gOikNCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBD
aHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3Zt
L210cnIuYyB8ICAyICstDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmMgIHwgMTAgKysrKysrLS0tLQ0K
PiAgMiBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL210cnIuYyBiL2FyY2gveDg2L2t2bS9tdHJyLmMN
Cj4gaW5kZXggOWZhYzFlYzAzNDYzLi5kMmM0MjhmNGFlNDIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gv
eDg2L2t2bS9tdHJyLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL210cnIuYw0KPiBAQCAtMjgsNyAr
MjgsNyBAQA0KPiAgc3RhdGljIGJvb2wgbXNyX210cnJfdmFsaWQodW5zaWduZWQgbXNyKQ0KPiAg
ew0KPiAgCXN3aXRjaCAobXNyKSB7DQo+IC0JY2FzZSAweDIwMCAuLi4gMHgyMDAgKyAyICogS1ZN
X05SX1ZBUl9NVFJSIC0gMToNCj4gKwljYXNlIE1UUlJwaHlzQmFzZV9NU1IoMCkgLi4uIE1UUlJw
aHlzTWFza19NU1IoS1ZNX05SX1ZBUl9NVFJSIC0gMSk6DQo+ICAJY2FzZSBNU1JfTVRSUmZpeDY0
S18wMDAwMDoNCj4gIAljYXNlIE1TUl9NVFJSZml4MTZLXzgwMDAwOg0KPiAgCWNhc2UgTVNSX01U
UlJmaXgxNktfQTAwMDA6DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNo
L3g4Ni9rdm0veDg2LmMNCj4gaW5kZXggZTdmNzhmZTc5YjMyLi44YjM1NmM5ZDhhODEgMTAwNjQ0
DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMN
Cj4gQEAgLTM3MDAsOCArMzcwMCw5IEBAIGludCBrdm1fc2V0X21zcl9jb21tb24oc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QgbXNyX2RhdGEgKm1zcl9pbmZvKQ0KPiAgCQkJcmV0dXJuIDE7
DQo+ICAJCX0NCj4gIAkJYnJlYWs7DQo+IC0JY2FzZSAweDIwMCAuLi4gTVNSX0lBMzJfTUMwX0NU
TDIgLSAxOg0KPiAtCWNhc2UgTVNSX0lBMzJfTUN4X0NUTDIoS1ZNX01BWF9NQ0VfQkFOS1MpIC4u
LiAweDJmZjoNCj4gKwljYXNlIE1TUl9JQTMyX0NSX1BBVDoNCj4gKwljYXNlIE1UUlJwaHlzQmFz
ZV9NU1IoMCkgLi4uIE1TUl9NVFJSZml4NEtfRjgwMDA6DQo+ICsJY2FzZSBNU1JfTVRSUmRlZlR5
cGU6DQo+ICAJCXJldHVybiBrdm1fbXRycl9zZXRfbXNyKHZjcHUsIG1zciwgZGF0YSk7DQo+ICAJ
Y2FzZSBNU1JfSUEzMl9BUElDQkFTRToNCj4gIAkJcmV0dXJuIGt2bV9zZXRfYXBpY19iYXNlKHZj
cHUsIG1zcl9pbmZvKTsNCj4gQEAgLTQxMDgsOSArNDEwOSwxMCBAQCBpbnQga3ZtX2dldF9tc3Jf
Y29tbW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykN
Cj4gIAkJbXNyX2luZm8tPmRhdGEgPSBrdm1fc2NhbGVfdHNjKHJkdHNjKCksIHJhdGlvKSArIG9m
ZnNldDsNCj4gIAkJYnJlYWs7DQo+ICAJfQ0KPiArCWNhc2UgTVNSX0lBMzJfQ1JfUEFUOg0KPiAg
CWNhc2UgTVNSX01UUlJjYXA6DQo+IC0JY2FzZSAweDIwMCAuLi4gTVNSX0lBMzJfTUMwX0NUTDIg
LSAxOg0KPiAtCWNhc2UgTVNSX0lBMzJfTUN4X0NUTDIoS1ZNX01BWF9NQ0VfQkFOS1MpIC4uLiAw
eDJmZjoNCj4gKwljYXNlIE1UUlJwaHlzQmFzZV9NU1IoMCkgLi4uIE1TUl9NVFJSZml4NEtfRjgw
MDA6DQo+ICsJY2FzZSBNU1JfTVRSUmRlZlR5cGU6DQo+ICAJCXJldHVybiBrdm1fbXRycl9nZXRf
bXNyKHZjcHUsIG1zcl9pbmZvLT5pbmRleCwgJm1zcl9pbmZvLT5kYXRhKTsNCj4gIAljYXNlIDB4
Y2Q6IC8qIGZzYiBmcmVxdWVuY3kgKi8NCj4gIAkJbXNyX2luZm8tPmRhdGEgPSAzOw0KDQo=
