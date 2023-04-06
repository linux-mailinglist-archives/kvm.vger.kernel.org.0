Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720DE6D928D
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 11:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbjDFJUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 05:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236418AbjDFJT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 05:19:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0C783;
        Thu,  6 Apr 2023 02:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680772797; x=1712308797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2Ndd9eYvHtuw4/kdHjXbP6o1T8qdp9oz4UzviUlNknM=;
  b=nEs7xCJGxxTNHYnCyuDGg07GCvG+ehLS4X5VqqYjmrlDiTPYdQqIh0R3
   qv/F1RDXyAn9bP8IOTqI3n6w/HUOpfQvqqxWq2AT81BB3klZ3DCoskARY
   gg//fIWtr6pWjD6yh7L07KI5fFxObXhQJufNzNXnZddNOOJow6u68BrYP
   w7jCFcHk6SBmIr/Mc5YXORjy+m9oHfZdmIXzJMfnIJseksEfqdYjhrOSP
   XlhWKb46FcTjRjS+TmMzf6CUBnF21G6oPNJJBUcJwuzCr27SNA0N4tOws
   JmCenKJJmuGqQrCOAHAF8aYEhMSJOiiuJKfQ65Flgv1KhgL9SNXGUFycW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="322341954"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="322341954"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 02:19:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="810933243"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="810933243"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 06 Apr 2023 02:19:56 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 02:19:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 02:19:56 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 02:19:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnTmSKMAuzsB669RmdePPIBwabD50NCJnZkeIxl3qsWtAkKa/rfeyfKWBJx+tAAmDgWT/IjpQ8faS0XV4Ew0FHfQktksBRYTpa09dGCojE7Qm+Ou3EvWhYir/Fm1S2zfB84kEzwBeojkTVwjweI0pi+at6SPO1SnrNqOCAQ+u6rtsyXPaC3I3r2EVjyH3ZXuezHKFmIzarJCkpqDW/EWurm+retNc0NrDUGx0t5mmQ8MlGQ18Euvf+8Bi5dcCscgz3H/V3o3CEJ9rds1F+6IP56eZ+2jxBYkMUVU3kmdJwNq5ELY5w7cWjRJSByfd5rvYZBU9LgEc1td8rzb9fViRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ndd9eYvHtuw4/kdHjXbP6o1T8qdp9oz4UzviUlNknM=;
 b=iT2bzVkKz6o32hHDgFOuTuTalXBmxYPAS/yS+N3v7GQfcYmRkAcI9/Q+xC3cDRlKC3uPMy5d4NvkLFBOHKV/gr7OnDIWSgNBHVQHE8X2iUJB/2J0iv59R51qviJI9erVvRuDaHFdvJAWfxp1CangDlzrpfRcNqeO429TZlo1iXDuCS3TR3H9Q8Uretdk/WBC4S2fPVfVmegxN0P/JRHhkt0yhV1oFhwPKY2CnCIkF9w38gtCf/i5wc3y8G62uiEr8qiHhuM8dtOHGU6a3Xts8nDfSQNs8FgPxP2+cDlglx8kfIk36u380OQ2i5BjH6lIzPfLfHaUTTqF1BbRAPpZOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7532.namprd11.prod.outlook.com (2603:10b6:8:147::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 09:19:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 09:19:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 0/2] KVM: VMX: Fixes for faults on ENCLS emulation
Thread-Topic: [PATCH 0/2] KVM: VMX: Fixes for faults on ENCLS emulation
Thread-Index: AQHZaBjWozzCyrMLl0ON9MsJ9EAU5K8eAa4A
Date:   Thu, 6 Apr 2023 09:19:53 +0000
Message-ID: <0a7d019d98058a119eff9f12ea185855f4e1e02b.camel@intel.com>
References: <20230405234556.696927-1-seanjc@google.com>
In-Reply-To: <20230405234556.696927-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7532:EE_
x-ms-office365-filtering-correlation-id: 4f15c9f1-1b57-4dd9-60b0-08db368014ac
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GA2wsYyqVJ4kzUIU19snd88XxWfm3ZdrkIgKICCHKoWkPvsvvobpINzLBavYfG6+xKXxDY8UqhowMrhGTmWJqXphdA6Nu3yIwmdKAcz6BWV3FtQDbqrH3QqPOI7/QoCih3l1dSoIQU4/ref7DVJ0jfoF9eXFzKrTzA7cFpU/RDw52E1GB4QjTY0mMmo+VEBwkl3aGr4TsRJl7WsXEGngewr5GKaElNPMs0FYgvTebHosKTDBimbPjMHO8NFuuz02bC8oq5hZqWOiyS/5Xi6BDI6soEbJVWl4OHRO1kmCqH3OggCoGq5F/Ij3eDH1YilNBdkfpL96Z02DQVZ6VAIv+mqxI+3dBdQztFhgw8Vrm+4616B6jhKJ9mQzk7x34gv6GuBmUTOt22aUfPREydt9p9qRJAF0wVAg1ygClWHsDFurG9chWCM2RawPkrMIZPJUljJIX7qt0/gpSSiY3rq5eeLAxwbbataBvULQL9PWeAMlslmj6kn7QgW/id0NeBwYWn6+zeQ/nGS7zlj1LyD14BPVmrGUTbpv508TK6RZfDEhopJPaF1P75ztM8+sZmPhta4T8Im1w92kEBH4p5T2/pE4yF80ObV617ozlwf44dFObo0elln+n1DoIagihErW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199021)(5660300002)(66556008)(186003)(86362001)(36756003)(316002)(478600001)(6486002)(110136005)(71200400001)(54906003)(38100700002)(91956017)(41300700001)(8676002)(2906002)(8936002)(76116006)(82960400001)(4326008)(66946007)(66446008)(64756008)(38070700005)(26005)(122000001)(4744005)(66476007)(6512007)(6506007)(83380400001)(66899021)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZENFV0tsbGtjWmZyVmtQOUdidjhlYy9YVENXR1QvSkltT2lWOHBTUUR3Mkpx?=
 =?utf-8?B?TkxaSWpWbTdCWTJnNkY4cjl0Nk1lQW80RFMwTVZLSEIxUGJnTFJVMStNN0lw?=
 =?utf-8?B?eWN4aW44Rk5adHdpZk92b0FPVlJ6OGcza2hQTFovbTM0ZUJleklGOFo0ZFpp?=
 =?utf-8?B?MWVoSFBHTER2MDdHaGZOdDgzejI2RkJVVjh4TEZvdXU2eDVCR0F1UVV1SkFQ?=
 =?utf-8?B?alhDaklORjNpaFlTWHNsZERyN2l0dTc3aDgrRTJmdVR6RThOUis0UVYwdUp5?=
 =?utf-8?B?WkNHNUNIRy9tNXBQWlUwZzJqTzB6ZFZ3Ry9JT2psOGVBUDNPSFprbDFNa29O?=
 =?utf-8?B?SlBEcjlpcktNQ2lLbFE5VFdiVFpRcU5XQVVTdmJEUk1LTDFxSk45MC9NK0d2?=
 =?utf-8?B?RlVRQmd5N1liaDhvVHlyNW9hazM3YitTV3BsNk5CRXJxc2lSUzROUnJmQjhW?=
 =?utf-8?B?dEFjcmZZOW1CUnQvUDJ3NkRwb1RRRmFKZjJEL2lJMnRNQXlmeUJkTXpLMC9D?=
 =?utf-8?B?M3Q5MnZMSlEzek5XZGh5c3BwZm1FRE5zN2dXaXpwclBUUjlEcE1PRkRxTEZo?=
 =?utf-8?B?ZjcrN1JNSjR0NGZxY2N3L01SallMR0MyRU4yTmJ1bGlYbmpwMVZCd1pBcktZ?=
 =?utf-8?B?bG5FQ1pYSWJVOGlMYXE0NXRPai9KdFhkUzltTUF2eSt3NGhQUW9BU0E0a1hL?=
 =?utf-8?B?SDhQMnpJdUpMTnBIbmdJY0QyUUI1WnVxRHUvSEtjd0srdjlkZWg0ampCSklL?=
 =?utf-8?B?OEtpbTY1aURwQUhhQ3lwWXhXMkdkd3pweTVELzF3RXh4VzVxODlFdlBIZ1VL?=
 =?utf-8?B?V0Nqa3BibjdxZ3Q1RTVQTnlHaFIrV2xmaHlFemlMMEVrUi9XTi84Y2RsRDJE?=
 =?utf-8?B?dDBBNEFjd25JRVZYODNYQ1FBa0czR1BSaENJeDhyR0JVdmR0RGlwT3puVzVa?=
 =?utf-8?B?WlBTdXVXbXhuaWsrQzdtV29yZ1RrVVM5d0NDZVo4OEJhOGF0TXRqcFgwOFpj?=
 =?utf-8?B?VkZHRHRQNlJWT3hqUENhZENRZ2FDckoxQ25FenNGb3NIRjJsN1pOOTdvVk9h?=
 =?utf-8?B?ODd2VHBxYWFWWmd5LzQ1ekVCV0lZc3QvcVZJRXI4TjBnakl6YzM5c2piQ0hS?=
 =?utf-8?B?eHBid24rT2hGVE1LWUtFTnZGbGNRcnMwZ0g5UVpTMm1zNE9IR0x2R2lPZGpi?=
 =?utf-8?B?TW1iRWk1TGRIeEdqeHpNMm5ZZzc4Vk1oOHpFajk5Y2tsL1oweEZqakRzaVEw?=
 =?utf-8?B?SmRWaTk5M0xFSm5TbjhyVnJuNVR3czZSUlJwWVplUkVDS1FTVlpFUmE0elNK?=
 =?utf-8?B?TlJmcDRkMjY0Snk4ZzhNK1QvMDRtUWdpQ3NBd1M0QjNzYUhIaDJpdkRkRUtC?=
 =?utf-8?B?eEJDZDh0Ym1VMFdmVXNFQTcyWnplVTNKSGZUTW0wd0s5RmZlRnRDaCtZUy96?=
 =?utf-8?B?eDZjOHdXdisyajRUcVBrMmt6SkdHMkc4V1NkZ3dqMk1Zek1kQWRIcDhHL1Qw?=
 =?utf-8?B?TXdlUXpQbzFwV3d3TkVZVzYzQmtWanJCajRoS1p3OC9xWUpFc3h4akRhMXB6?=
 =?utf-8?B?OVFsekoxa3FaSmVIR1B5YkF1WDAyL3RqL0xnWTB0bmZFdTZmMHlaaE1vVlYv?=
 =?utf-8?B?WXJ3MThUTTc0RUdHeHNuQ3lCVkdiM01yb0ZjMTRmQ3NWNWt3aUh0QWNaZzAv?=
 =?utf-8?B?TFRWQTJvMEpIejVUWGdBbExldDIwUVkydnBCZHlxRVhNd1ROSVhTM041ZVcr?=
 =?utf-8?B?cmNYYkszZmRucVdpV3JPU1I4ZUJKZG13ZS91aElWdlQ4WFQ2elpuZ1hqTjNr?=
 =?utf-8?B?WU1BdnJweGVpWGFaMmRVeHM0ZVpmQWVYdXJhc3BrRXh4Q0FDdmNXLzJNdkJU?=
 =?utf-8?B?T25aZnZObGcxUHB4R280Uzk5Vk5HTTRjeUJLa0JsanZMMGRTZ3RpT24vcSta?=
 =?utf-8?B?SlJjbXhMMlRiL3JteElvWHYwb2JHeUgvSUhkNFpHNmQ0M2pYNUZ4eW1wU3lq?=
 =?utf-8?B?OHRrckNPOUpGQ3NzeEk1RzlIbjh4Vk5VWUZCbnNJWWkrV1NGU0tZRzlDZWtY?=
 =?utf-8?B?dEhKQ3RIZXF3SXJ0cVJHME5DdFFlNm5McG5RdEhtSjNqTDZXeVlUNWkzeDJN?=
 =?utf-8?Q?/dIURVhCgUPE2YzstwpKuGbnL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1ABC77A18C50A54881C5B209DBB7473A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f15c9f1-1b57-4dd9-60b0-08db368014ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 09:19:53.3094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KC0C4OlpXfIyf/U1kp6+cCPnISWCRe46Z6CEq8WZ0xwVohsWQoZ3F1RWd1o0QWvyYKVE5UHEHnnjLsMK9VlsYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7532
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTA1IGF0IDE2OjQ1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGb3VuZC1ieS1pbnNwZWN0aW9uICh3aGVuIHJldmlld2luZyBCaW5iaW4ncyBwYXRj
aCkgZml4ZXMgZm9yIGluY29ycmVjdA0KPiBlbXVsYXRpb24gb2YgZmF1bHRzIHdoZW4gS1ZNaW50
ZXJjZXB0cyBhbmQgZW11bGF0ZXMgKHNvcnQgb2YpIEVOQ0xTLg0KPiANCj4gVmVyeSBtdWNoIGNv
bXBpbGUgdGVzdGVkIG9ubHkuICBJZGVhbGx5LCBzb21lb25lIHdpdGggU0dYIGhhcmR3YXJlIGNh
bg0KPiBjb25maXJtIHRoYXQgdGhlc2UgcGF0Y2hlcyBhcmUgY29ycmVjdCwgZS5nLiBteSBhc3Nl
c3NtZW50IHRoYXQgS1ZNIG5lZWRzDQo+IHRvIG1hbnVhbGx5IGNoZWNrIENSMC5QRyBpcyBiYXNl
ZCBwdXJlbHkgb2YgU0RNIHBzZXVkb2NvZGUuDQoNClRoYW5rcyBmb3IgdGhlIHBhdGNoZXMuICBJ
IGRvbid0IGhhdmUgYSAicmVhZHkiIFNHWCBlbnZpcm9ubWVudCBhdCBoYW5kLCBidXQNCkknbGwg
dHJ5IHRvIHRlc3Qgb3IgYXNrIHNvbWVvbmUgZWxzZSB0byB0ZXN0IGFmdGVyIEVhc3RlciBob2xp
ZGF5Lg0KDQo+IA0KPiBTZWFuIENocmlzdG9waGVyc29uICgyKToNCj4gICBLVk06IFZNWDogSW5q
ZWN0ICNHUCBvbiBFTkNMUyBpZiB2Q1BVIGhhcyBwYWdpbmcgZGlzYWJsZWQgKENSMC5QRz09MCkN
Cj4gICBLVk06IFZNWDogSW5qZWN0ICNHUCwgbm90ICNVRCwgaWYgU0dYMiBFTkNMUyBsZWFmcyBh
cmUgdW5zdXBwb3J0ZWQNCj4gDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3NneC5jIHwgMTUgKysrKysr
KysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9u
cygtKQ0KPiANCj4gDQo+IGJhc2UtY29tbWl0OiAyN2Q2ODQ1ZDI1OGI2N2Y0ZWIzZGViZTA2MmI3
ZGFjYzY3ZTBjMzkzDQo+IC0tIA0KPiAyLjQwLjAuMzQ4LmdmOTM4YjA5MzY2LWdvb2cNCj4gDQoN
Cg==
