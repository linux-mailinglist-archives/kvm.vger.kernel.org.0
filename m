Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDD3477282
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 14:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbhLPNBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 08:01:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:62304 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234499AbhLPNBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 08:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639659680; x=1671195680;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=wc4+dOmgWfWkfRqjX1FYxJeEA/4tXlfJyUvnBBDkUlk=;
  b=B8s0llefla2SJbf6YL8mDqNcvvMflCVEurBQ0Yl0i43S5TVw5fD2P8HI
   ifJ+yBDQQ6lwwcLDPs/H/juQTOTfrtViEDMri9V85jU5P/LqQjUGHEUW2
   QLynWQO0JMbrRdfCTLMIwSD9BfmRQoze5h63dw+iXGNWwKSwjGEJwXogz
   285+lxYhFptmYgWlt/00UP+WEHdSFeeyZim99b8UJhmfDqRZQkhDLmb2C
   0bN93+DsM1ULwfj9ghtv4FfzUk+BbywUEU2tF6mbLC9zikJivsFnBNqkK
   jFp1BoCPeo5xfmIigRJOZnq2jiIwzbIDKy+BlIGoKFVjk/SjLnoCCubGy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239291864"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="239291864"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 05:01:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="615139986"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 16 Dec 2021 05:01:11 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 05:01:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 16 Dec 2021 05:01:00 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 16 Dec 2021 05:01:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzqQbxBnrXtqNZsyTooSV4cXu5RCtYXN6Wy1IOKInqZY+wX0BQVnMeh/8DOARRhLQn4RCZFB6zy3fWm5YA+V8HhpvXMeQCz/9zQPqw0ieOyagPC7iO8R5O9JpWGFzkpGFgIo/G7henSKMa5Qw1MKiNmhOhyDFkaesgwNeM+49A6KnH5ucEDEBI5rGIQYT6hUEclKgY8kFFzoGvHaob2sP2bkbK0Z4McqRf9+xPWGxiPHka8TlMr4LoJ7GvUV2tXC2DWT4UCKxQDYPhNLQ5DPFfLKlU3mhC94r5zkzjImhQU7N/vkA5Xx5s2n8COLUAasq7OqV/wfGazGl8Ki+tsEOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wc4+dOmgWfWkfRqjX1FYxJeEA/4tXlfJyUvnBBDkUlk=;
 b=lGw/dC75Pa2yV5628YVPXwcfL74piCcDjz4qygAQunNl5p3EJIviLiPkWzRNVj+e8eQZrBsG2tMNXfCWFwe03FpHX2eSLPXpYg4bmvrBHueP9er/lACUiuQ1Jf4X0514sf/zTFW0qStb2sFK6e0x9j1EBYPlI3vEeveW+pNyXV+ROGeZ36DvU6WquYetb1pVsZCZOUimZaICgdMAlKO7zOaqZ3wHmPZBc9nyw2YOyONWF4L2K3II0zsqw8uhS7TgRNtDzaHhnJFIToMjTEq/9DZ24BKgcorvoS5df9HrEPGZnUUtmb+9iuz1Q4MUkW3s3jNlRsXKCJkuHCfNb6ARXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3716.namprd11.prod.outlook.com (2603:10b6:408:8a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Thu, 16 Dec
 2021 13:00:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 13:00:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wyGCEAgAAIi4CAAAi/gIAAH5YAgAAT0FyAABRSAIAAEuhSgABOroCAAIPaAIAABQ6AgAADz4CAAO8l0IAAA8PQgADEu0A=
Date:   Thu, 16 Dec 2021 13:00:43 +0000
Message-ID: <BN9PR11MB52768B84B24664A756CDF2C48C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com>  
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e463bb2-abc3-4108-dd2d-08d9c09411d2
x-ms-traffictypediagnostic: BN8PR11MB3716:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN8PR11MB3716B17732F529F32170FA848C779@BN8PR11MB3716.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: csnl6D/Zk/iqmBxMVVXavkdjvZjwNgxz+UzttojWTJrJwWq2J5CnMV2BDXhzsulsURvfMOIeFaLfHwCaNh5Gj7bPplLdwTtB9cVf5wGy4ZukoEzMXxN7g0mJCQodz15+8Dq+BS3xmmI2L7PzgBCpYEYf+XL49cQpEpsldqyaKatzFLW+YrZzACpu8FkZpCvSkXHb+s8YgZNKVOWf5tdCeSG48ToyF5xMtfJIfcDOiDbKSOuPwQG9ZB8PzRP2IEHBakVSdm5v+N60xGIpKBm2sBwJGTZrYkkDmOehVn8L6wdrI8K4g1aZkuAvxmRFsFn/BMqJY8KHR87F7dONpIb+suRYb6AB9B8pWpSaoOo8MsSbmVl2HuQa5z3DbUdL2TEa7EFpZ7nWQoIm386MstORdoXQHmM/KQn2jHrimSQRg2toP3Z+KClsNy45INj+swc+rwj3+dOL3jqNtWyrJIS/A1ra1xeVMhmRCAOZz4qWeObfIOkajLdfPlAVewqgd4EL7piuhYzfWQ0hyv1quUVbjwDs2JeMeqQlaFxzWNLMO3TvmfY2O0IZ/kZgo4nlbUN0Qwthaso+qOu5/KaBfOVEu9LS8BTpI0aW/B6WORe7GAg1Ofqq+gWN8GtHVpHfCR7dKDq0dP4KHlDpoSe8Wx+j9luqpDPN5zPgXdbIYuam/7hlprsF6xP06BS1hjsu45ed/3KtMclLaGLR3TtbJzH75A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(84040400005)(71200400001)(508600001)(33656002)(66946007)(55016003)(4326008)(86362001)(9686003)(8676002)(76116006)(316002)(66476007)(82960400001)(6506007)(54906003)(38100700002)(83380400001)(26005)(64756008)(66446008)(8936002)(38070700005)(110136005)(186003)(122000001)(66556008)(2906002)(5660300002)(52536014)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czZNM0dhcVVETndwYm9XSU5TVlpDRFNxRnNhVGRHMittdkdzd0Z2MGdpRm5R?=
 =?utf-8?B?V3lmOC9leXJ1cWFBZUViU2ZnbUIxbUJsMDZlUGVMckZpVi9zWHpoN2krUVlJ?=
 =?utf-8?B?YnBxcmxjM0tNcmVKN25UbkJwc1VoTzlOY2VwazhtQjhmVDRiRGE3aE9rVk5B?=
 =?utf-8?B?RFJhUmtldTVRT1NyTnlrRWlabmVDZnh3RGJ2ZGNGaW1vckNUVEJUWm5iK2VH?=
 =?utf-8?B?dW13QW1DYStnLzBsanNDT0hFZzFwZTczcVRST0EwM3hsNnlhYTA0bUsrcGFo?=
 =?utf-8?B?MWNWUDU4V29rVDRXWjdXNEwzeURKMWxMTW0reXc1cDFZd2pGSUdreUg5ZzYx?=
 =?utf-8?B?Zk4vMEZrTkxyZFFUUG9wWkYvbzJzYWwxMDJIdWZPcmI1dHIyVTU5WTl3VFY4?=
 =?utf-8?B?RFZBczl1Q1RZMWo0V2F1eWI2S0k4eXdWcGQrUWZPVk00Uzlncm9IT0pxZUZw?=
 =?utf-8?B?VEgrTEFXSlFrUXlFTW9QeUFyQnhOeUhhdHk1alVEclZ4cUgyRmsxNWNqaDZK?=
 =?utf-8?B?S0RXRUhsb21iNjZjN3l1VDh0QkRtSzl4R3hDRHZGK2RyUUJlMk5jUzdRYlUv?=
 =?utf-8?B?cWlxSEpiZmhOWVlQQXZJZ3BNNENtYXZqUCt5L1hTWXNTTkZNNlhGczFWSlFj?=
 =?utf-8?B?RS9wZ29Ncm02ZjlDTWtkUm5xR0lWY056UzhDUmZEV0hBZkhhdFBqa2UvMG9Y?=
 =?utf-8?B?N1F3QUg0ejVjQmd5VU5yUDJyVXpDYThwYlgra3djbU93dml2eFZKUk93MDVK?=
 =?utf-8?B?RkNNZTU0OEZ2SzZsYVdWTFRSR2wwVFFzaGRzMkFocXBEVEpac1ppVXFlU09R?=
 =?utf-8?B?d1lKUEdFL1piMS9MaktUcFduQXVIVEhYUDBGQXBicHo1b0xVb2V3NjNoQlpn?=
 =?utf-8?B?T0xEenFBNUQxQkVXUWNPa280c3NTUkNYTWlmZkZMMmtGUE1xZW5KdEZDdjNv?=
 =?utf-8?B?YVFkNlZEVmFzSFpzU3JpMytUbWZNL2lwYVQ2UEI5VzRLZFFZWEtxWXdrVnVj?=
 =?utf-8?B?V3NhbERrMjFPSXczZUw4RUZrMzRnYTZyS0ZORkJrTm1oUlJUVEJaM1E5UXNC?=
 =?utf-8?B?dWZDNnB1dURpM2J5OW9qWUZBRUp5aDJHSXFjcVRCaW9XY25Na0NOb3IyWGhO?=
 =?utf-8?B?bE1KVUxhQm5hREhBZFVybnZNaHRVQ2NzdGpnYkVremhsdWZwZDdhdmdIUFFH?=
 =?utf-8?B?NTlodEFOWUc5V0R5SDI3bk1PcHdNblhBYVpaL1NpMTlZYzBmUzMzcWV6bFN5?=
 =?utf-8?B?S1lxQXYweHpmYWpiZ0haUEZ6RWtncmRsRDZIZTFzK3ZnMmZPSTdLS2NxWFcv?=
 =?utf-8?B?TkJvNy9sSjROZzFuL2ZOVHJOYXFyREhnMjN6WDhoZmRGMUpCbWtsaDE0TTFP?=
 =?utf-8?B?empLQUxYcUFDdWhVWGZBeEpwOEtXRW4vQ1dJbVZPeWYxanhNRkNudTZTZ3ha?=
 =?utf-8?B?WEJwbzcwM1gyd09NYWo3SkxPOFdadDk2UWRSVC91UHJVZ0Z5WERvajJQem1C?=
 =?utf-8?B?NW5nMjY3dkx2SjJ4OTUvdFlUd1lrOXZZMkhPWksxRUliTlRMTzN6VEkwS1Fj?=
 =?utf-8?B?OTIzVTJJL2I1ZUZ6RXo2d2hmUFgzUDE1c1kvNVorZmZPMzUrYVFOTExlQTdB?=
 =?utf-8?B?ZDJvdnhLNHNEQ1M1UVRIZzhhOEJpSTFWYUswbENsYzF1MGhQejRUNmRaY0p5?=
 =?utf-8?B?NVhkaXdGTHdWc29Ya1hlWnhPSE4rVEhFRllVbU1DWWxuVzBGNmVtSmpZZ3lm?=
 =?utf-8?B?MzhZbmtpZk1oSTdtdjV2L1BrSE1XYzVTbmNZQXR3RC9ib3lRZFA4eEtDSWJS?=
 =?utf-8?B?aVBsdzdGaW9FNFQvNjRnZGZMTjVFY3NsOVJmMk5lTExkWXhxZnZoOVh3emlC?=
 =?utf-8?B?dTNqYUFsM2lGbVRlc09HSXFVdkZqcVJ5b0Z6R1gzZmMvN01VTWYzekJIQUZW?=
 =?utf-8?B?RG1keVRQZS8yUWZSSGR3bThXS2xTd1Bzanp4elo3ZVZsbVRZSUtzb1ZkN0hi?=
 =?utf-8?B?REZEQjdjUExKNkkyN3RzUkUyalp3dmxQUXc2Y1dUZWRMNS9vL0o1dWhYdkpq?=
 =?utf-8?B?d01zbDlpcFlYQWRPWm9FcnJuaE01Y1BsMnFRc0sxTHZiUURBdDFHdzRQdnQv?=
 =?utf-8?B?V0Rpb0xQQnhqT3lzZ1BSK1JlbnhWYU5WOGFZeWpUNmQrNUxhZEZFSWlFVDJ2?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e463bb2-abc3-4108-dd2d-08d9c09411d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 13:00:43.4299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LhZPueUUeOzibmxy7z5qIqWh50lKOQ8odqpUJIZYwj+QfAFHtzIIXppHFVJbhUopleNBIwHY95n7vZZveIxDSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3716
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksIFBhb2xvL1Rob21hcywNCg0KQW55IGNvbW1lbnQgb24gZm9sbG93aW5nIG9wZW5zPyBJbiBn
ZW5lcmFsIGRvaW5nIHN0YXRpYyBidWZmZXIgDQpleHBhbnNpb24gZGVmaW5pdGVseSBzaW1wbGlm
aWVzIHRoZSBsb2dpYywgYnV0IHN0aWxsIG5lZWQgeW91ciBoZWxwIHRvIA0KZmluYWxpemUgaXRz
IGltcGFjdCBvbiB0aGUgb3ZlcmFsbCBkZXNpZ24uIPCfmIoNCg0KVGhhbmtzDQpLZXZpbg0KDQo+
IEZyb206IFRpYW4sIEtldmluDQo+IFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciAxNiwgMjAyMSAx
OjM2IFBNDQo+IA0KPiA+IEZyb206IFRpYW4sIEtldmluDQo+ID4gU2VudDogVGh1cnNkYXksIERl
Y2VtYmVyIDE2LCAyMDIxIDk6MDAgQU0NCj4gPiA+DQo+ID4gPiBPZmYtbGlzdCwgVGhvbWFzIG1l
bnRpb25lZCBkb2luZyBpdCBldmVuIGF0IHZDUFUgY3JlYXRpb24gYXMgbG9uZyBhcyB0aGUNCj4g
PiA+IHByY3RsIGhhcyBiZWVuIGNhbGxlZC4gIFRoYXQgaXMgYWxzbyBva2F5IGFuZCBldmVuIHNp
bXBsZXIuDQo+ID4NCj4gPiBNYWtlIHNlbnNlLiBJdCBhbHNvIGF2b2lkcyB0aGUgI0dQIHRoaW5n
IGluIHRoZSBlbXVsYXRpb24gcGF0aCBpZiBqdXN0IGR1ZQ0KPiA+IHRvIHJlYWxsb2NhdGlvbiBl
cnJvci4NCj4gPg0KPiA+IFdlJ2xsIGZvbGxvdyB0aGlzIGRpcmVjdGlvbiB0byBkbyBhIHF1aWNr
IHVwZGF0ZS90ZXN0Lg0KPiA+DQo+IA0KPiBBZnRlciBzb21lIHN0dWR5IHRoZXJlIGFyZSB0aHJl
ZSBvcGVucyB3aGljaCB3ZSdkIGxpa2UgdG8gc3luYyBoZXJlLiBPbmNlDQo+IHRoZXkgYXJlIGNs
b3NlZCB3ZSdsbCBzZW5kIG91dCBhIG5ldyB2ZXJzaW9uIHZlcnkgc29vbiAoaG9wZWZ1bGx5IHRv
bW9ycm93KS4NCj4gDQo+IDEpIEhhdmUgYSBmdWxsIGV4cGFuZGVkIGJ1ZmZlciBhdCB2Q1BVIGNy
ZWF0aW9uDQo+IA0KPiBUaGVyZSBhcmUgdHdvIG9wdGlvbnMuDQo+IA0KPiBPbmUgaXMgdG8gZGly
ZWN0bHkgYWxsb2NhdGUgYSBiaWctZW5vdWdoIGJ1ZmZlciB1cG9uIGd1ZXN0X2ZwdTo6cGVybSBp
bg0KPiBmcHVfYWxsb2NfZ3Vlc3RfZnBzdGF0ZSgpLiBUaGVyZSBpcyBubyByZWFsbG9jYXRpb24g
cGVyLXNlIHRodXMgbW9zdCBjaGFuZ2VzDQo+IGluIHRoaXMgc2VyaWVzIGFyZSBub3QgcmVxdWly
ZWQuDQo+IA0KPiBUaGUgb3RoZXIgaXMgdG8ga2VlcCB0aGUgcmVhbGxvY2F0aW9uIGNvbmNlcHQg
KHRodXMgYWxsIHByZXZpb3VzIHBhdGNoZXMgYXJlDQo+IGtlcHQpIGFuZCBzdGlsbCBjYWxsIGEg
d3JhcHBlciBhcm91bmQgX194ZmRfZW5hYmxlX2ZlYXR1cmUoKSBldmVuIGF0IHZDUFUNCj4gY3Jl
YXRpb24gKGUuZy4gcmlnaHQgYWZ0ZXIgZnB1X2luaXRfZ3Vlc3RfcGVybWlzc2lvbnMoKSkuIFRo
aXMgbWF0Y2hlcyB0aGUNCj4gZnB1IGNvcmUgYXNzdW1wdGlvbiB0aGF0IGZwc3RhdGUgZm9yIHhm
ZCBmZWF0dXJlcyBhcmUgZHluYW1pY2FsbHkgYWxsb2NhdGVkLA0KPiB0aG91Z2ggdGhlIGFjdHVh
bCBjYWxsaW5nIHBvaW50IG1heSBub3QgYmUgZHluYW1pYy4gVGhpcyBhbHNvIGFsbG93cyB1cw0K
PiB0byBleHBsb2l0IGRvaW5nIGV4cGFuc2lvbiBpbiBLVk1fU0VUX0NQVUlEMiAoc2VlIG5leHQp
Lg0KPiANCj4gMikgRG8gZXhwYW5zaW9uIGF0IHZDUFUgY3JlYXRpb24gb3IgS1ZNXyBTRVRfQ1BV
SUQyPw0KPiANCj4gSWYgdGhlIHJlYWxsb2NhdGlvbiBjb25jZXB0IGlzIHN0aWxsIGtlcHQsIHRo
ZW4gd2UgZmVlbCBkb2luZyBleHBhbnNpb24gaW4NCj4gS1ZNX1NFVF9DUFVJRDIgbWFrZXMgc2xp
Z2h0bHkgbW9yZSBzZW5zZS4gVGhlcmUgaXMgbm8gZnVuY3Rpb25hbA0KPiBkaWZmZXJlbmNlIGJl
dHdlZW4gdHdvIG9wdGlvbnMgc2luY2UgdGhlIGd1ZXN0IGlzIG5vdCBydW5uaW5nIGF0IHRoaXMN
Cj4gcG9pbnQuIEFuZCBpbiBnZW5lcmFsIFFlbXUgc2hvdWxkIHNldCBwcmN0bCBhY2NvcmRpbmcg
dG8gdGhlIGNwdWlkIGJpdHMuDQo+IEJ1dCBzaW5jZSBhbnl3YXkgd2Ugc3RpbGwgbmVlZCB0byBj
aGVjayBndWVzdCBjcHVpZCBhZ2FpbnN0IGd1ZXN0IHBlcm0gaW4NCj4gS1ZNX1NFVF9DUFVJRDIs
IGl0IHJlYWRzIGNsZWFyZXIgdG8gZXhwYW5kIHRoZSBidWZmZXIgb25seSBhZnRlciB0aGlzDQo+
IGNoZWNrIGlzIHBhc3NlZC4NCj4gDQo+IElmIHRoaXMgYXBwcm9hY2ggaXMgYWdyZWVkLCB0aGVu
IHdlIG1heSByZXBsYWNlIHRoZSBoZWxwZXIgZnVuY3Rpb25zIGluDQo+IHRoaXMgcGF0Y2ggd2l0
aCBhIG5ldyBvbmU6DQo+IA0KPiAvKg0KPiAgKiBmcHVfdXBkYXRlX2d1ZXN0X3Blcm1fZmVhdHVy
ZXMgLSBFbmFibGUgeGZlYXR1cmVzIGFjY29yZGluZyB0byBndWVzdA0KPiBwZXJtDQo+ICAqIEBn
dWVzdF9mcHU6CQlQb2ludGVyIHRvIHRoZSBndWVzdCBGUFUgY29udGFpbmVyDQo+ICAqDQo+ICAq
IEVuYWJsZSBhbGwgZHluYW1pYyB4ZmVhdHVyZXMgYWNjb3JkaW5nIHRvIGd1ZXN0IHBlcm0uIElu
dm9rZWQgaWYgdGhlDQo+ICAqIGNhbGxlciB3YW50cyB0byBjb25zZXJ2YXRpdmVseSBleHBhbmQg
ZnBzdGF0ZSBidWZmZXIgaW5zdGVhZCBvZiB3YWl0aW5nDQo+ICAqIHVudGlsIGEgZ2l2ZW4gZmVh
dHVyZSBpcyBhY2Nlc3NlZC4NCj4gICoNCj4gICogUmV0dXJuOiAwIG9uIHN1Y2Nlc3MsIGVycm9y
IGNvZGUgb3RoZXJ3aXNlDQo+ICAqLw0KPiAraW50IGZwdV91cGRhdGVfZ3Vlc3RfcGVybV9mZWF0
dXJlcyhzdHJ1Y3QgZnB1X2d1ZXN0ICpndWVzdF9mcHUpDQo+ICt7DQo+ICsJdTY0IGV4cGFuZDsN
Cj4gKw0KPiArCWxvY2tkZXBfYXNzZXJ0X3ByZWVtcHRpb25fZW5hYmxlZCgpOw0KPiArDQo+ICsJ
aWYgKCFJU19FTkFCTEVEKENPTkZJR19YODZfNjQpKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiAr
CWV4cGFuZCA9IGd1ZXN0X2ZwdS0+cGVybSAmIH5ndWVzdF9mcHUtPnhmZWF0dXJlczsNCj4gKwlp
ZiAoIWV4cGFuZCkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwlyZXR1cm4gX194ZmRfZW5hYmxl
X2ZlYXR1cmUoZXhwYW5kLCBndWVzdF9mcHUpOw0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwo
ZnB1X3VwZGF0ZV9ndWVzdF9mZWF0dXJlcyk7DQo+IA0KPiAzKSBBbHdheXMgZGlzYWJsZSBpbnRl
cmNlcHRpb24gb2YgZGlzYWJsZSBhZnRlciAxc3QgaW50ZXJjZXB0aW9uPw0KPiANCj4gT25jZSB3
ZSBjaG9vc2UgdG8gaGF2ZSBhIGZ1bGwgZXhwYW5kZWQgYnVmZmVyIGJlZm9yZSBndWVzdCBydW5z
LCB0aGUNCj4gcG9pbnQgb2YgaW50ZXJjZXB0aW5nIFdSTVNSKElBMzJfWEZEKSBiZWNvbWVzIGxl
c3Mgb2J2aW91cyBzaW5jZQ0KPiBubyBkeW5hbWljIHJlYWxsb2NhdGlvbiBpcyByZXF1aXJlZC4N
Cj4gDQo+IE9uZSBvcHRpb24gaXMgdG8gYWx3YXlzIGRpc2FibGUgV1JNU1IgaW50ZXJjZXB0aW9u
IG9uY2UNCj4gS1ZNX1NFVF9DUFVJRDIgc3VjY2VlZHMsIHdpdGggdGhlIGNvc3Qgb2Ygb25lIFJE
TVNSIHBlciB2bS1leGl0Lg0KPiBCdXQgZG9pbmcgc28gYWZmZWN0cyBsZWdhY3kgT1Mgd2hpY2gg
ZXZlbiBoYXMgbm8gWEZEIGxvZ2ljIGF0IGFsbC4NCj4gDQo+IFRoZSBvdGhlciBvcHRpb24gaXMg
dG8gY29udGludWUgdGhlIGN1cnJlbnQgcG9saWN5IGkuZS4gZGlzYWJsZSB3cml0ZQ0KPiBlbXVs
YXRpb24gb25seSBhZnRlciB0aGUgMXN0IGludGVyY2VwdGlvbiBvZiBzZXR0aW5nIFhGRCB0byBh
IG5vbi16ZXJvDQo+IHZhbHVlLiBUaGVuIHRoZSBSRE1TUiBjb3N0IGlzIGFkZGVkIG9ubHkgZm9y
IGd1ZXN0IHdoaWNoIHN1cHBvcnRzIFhGRC4NCj4gDQo+IEluIGVpdGhlciBjYXNlIHdlIG5lZWQg
YW5vdGhlciBoZWxwZXIgdG8gdXBkYXRlIGd1ZXN0X2ZwdS0+ZnBzdGF0ZS0+eGZkDQo+IGFzIHJl
cXVpcmVkIGluIHRoZSByZXN0b3JlIHBhdGguIEZvciB0aGUgMm5kIG9wdGlvbiB3ZSBmdXJ0aGVy
IHdhbnQNCj4gdG8gdXBkYXRlIE1TUiBpZiBndWVzdF9mcHUgaXMgY3VycmVudGx5IGluIHVzZToN
Cj4gDQo+ICt2b2lkIHhmZF91cGRhdGVfZ3Vlc3RfeGZkKHN0cnVjdCBmcHVfZ3Vlc3QgKmd1ZXN0
X2ZwdSwgdTY0IHhmZCkNCj4gK3sNCj4gKwlmcHJlZ3NfbG9jaygpOw0KPiArCWd1ZXN0X2ZwdS0+
ZnBzdGFlLT54ZmQgPSB4ZmQ7DQo+ICsJaWYgKGd1ZXN0X2ZwdS0+ZnBzdGF0ZS0+aW5fdXNlKQ0K
PiArCQl4ZmRfdXBkYXRlX3N0YXRlKGd1ZXN0X2ZwdS0+ZnBzdGF0ZSk7DQo+ICsJZnByZWdzX3Vu
bG9jaygpOw0KPiArfQ0KPiANCj4gVGhvdWdodHM/DQo+IC0tDQo+IHAucy4gY3VycmVudGx5IHdl
J3JlIHdvcmtpbmcgb24gYSBxdWljayBwcm90b3R5cGUgYmFzZWQgb246DQo+ICAgLSBFeHBhbmQg
YnVmZmVyIGluIEtWTV9TRVRfQ1BVSUQyDQo+ICAgLSBEaXNhYmxlIHdyaXRlIGVtdWxhdGlvbiBh
ZnRlciBmaXJzdCBpbnRlcmNlcHRpb24NCj4gdG8gY2hlY2sgYW55IG92ZXJzaWdodC4NCj4gDQo+
IFRoYW5rcw0KPiBLZXZpbg0K
