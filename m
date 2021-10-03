Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C637A420453
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 00:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhJCWhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 18:37:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:25849 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhJCWhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 18:37:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="248491957"
X-IronPort-AV: E=Sophos;i="5.85,344,1624345200"; 
   d="scan'208";a="248491957"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2021 15:35:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,344,1624345200"; 
   d="scan'208";a="710621424"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga006.fm.intel.com with ESMTP; 03 Oct 2021 15:35:28 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 3 Oct 2021 15:35:27 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 3 Oct 2021 15:35:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sun, 3 Oct 2021 15:35:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 3 Oct 2021 15:35:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmMjaSarVGM6BKTXjoqjZlBNTfhiWjbXxWw7eiacQFaxsIauGmgA1dgV9cXU7WQ11jMKbMAdqIqqQrsDF/HmiFqqsGHZWjxrdXUv0Qx2UbWiHItHSQPfFtKRfNkrIwRgHVqZE9QvZiafDhcR06S/lKYwqtbW1+3O/YMyy7I5LgtnNZC4nWlw8Fm0BEju0zFN6WwfxYCrcl+tdxS+FEh5ciUpG+cwgi8ZFUUfcvLNlAOwZNnJRnhxP0Etu+aolrPknAnWlGbc433eZhuULwoiDXCeyCuUJDbcu9MhSQsHTTNDO2d9qVZCaFhEKpEIwaZxmQepjo/obJvJJAOYPRQyiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBfsGn0RzX4bGcTVpvVtICmYRx8Y4Fbp5ShXqKuPVqo=;
 b=j7i44++5tFJ0F4+C9AN7xgePjlr4AooyABQ9fJJoZCWvr5hF/8VJnSTagPsTayOCfmj5pRHtVEWqmjPSdwxfP6cJ2Q/R3Y+i1W0rY6WKDUfu6UfOpgKxXMLRyu5Wqzo5eplUi0XobX7DKHjYGnsUHWNbZjNM8Y6O/pIYo5uhgL9ANVvd953f3OOJ9UoEdyFBzmimY3TElZtyMI+ROQNOu2gUnjBSvA91vf0ggEGkN6BSIZo/HzxVrJPPbPFQKMIVzCnpRiOFnPd2cwU7JgHhFMNMBf/fj1ZblHtxUIodPHy2fPVhNdw/mpWIK6f3DQTjjZ+i1OZuKsGqjgcSmFFx2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBfsGn0RzX4bGcTVpvVtICmYRx8Y4Fbp5ShXqKuPVqo=;
 b=QzgpgtxLvEcXooFJ9q03Qa2DKhO6rXYZo8NzdoxTPppLqou9sHkNMG5cAousfg16DMK/SZ6dYE7GmVrVptYuS0lDZeVqIvHicPhPjC80/f8tqNhzYJsZaL/CNiU1lFW1wgJJAFpvVktDxWqLXGHNd+hpopg38kR0pPdW1+aw42I=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB5159.namprd11.prod.outlook.com (2603:10b6:510:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Sun, 3 Oct
 2021 22:35:25 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::b427:a68a:7cb6:1983]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::b427:a68a:7cb6:1983%3]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 22:35:25 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "bp@suse.de" <bp@suse.de>, "Lutomirski, Andy" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Macieira, Thiago" <thiago.macieira@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 02/28] x86/fpu/xstate: Modify the initialization
 helper to handle both static and dynamic buffers
Thread-Topic: [PATCH v10 02/28] x86/fpu/xstate: Modify the initialization
 helper to handle both static and dynamic buffers
Thread-Index: AQHXmcpuOFhI48dD+EeWQj0WmdlQhKu+UNAAgAPJg4A=
Date:   Sun, 3 Oct 2021 22:35:25 +0000
Message-ID: <5767911A-6F1F-4EDE-92A4-D4C3E5A3AABF@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
 <20210825155413.19673-3-chang.seok.bae@intel.com> <87k0iw6hi5.ffs@tglx>
In-Reply-To: <87k0iw6hi5.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22c52daa-3b57-46da-aded-08d986be17f6
x-ms-traffictypediagnostic: PH0PR11MB5159:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB51591E1908E4C4A9D68F5524D8AD9@PH0PR11MB5159.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K//U6LC3DFvhr0r9En0zjZE7GhGrpoy3pF/AWlxb8LiJx0vwSNEQ/VLeUMSxyR9NzSjomblDg2+Qz6NO9EeqEmLNmc1U6JEoOVTXz1aeVVrl7Y42rpOJov+5796AiE6zd8uWI/TIntAhO2gPvvET0QSE6DPbNNSoErfrslpuFIJv6X7znFAYhLclRFYGsU7wVk7aGWDXachwVq5ErjJ977IRBd+q63zf2voF32R9dE6ocioRMvk8ZBV/gwBsbbAVsr3foacNCBteN6/j+XjXqBxZUHs5MgLa4jt1Xer4tT8EOBqDNtEj1QCWfO0GW2AD0VRl+c0EefuXmgsYO8QpaMawSiAlO6j/UMlIsxxJ8JkejooCqNiiQiS4pxeTY3IZqsSXGaL+KpzQTaP7ZDbvd0gojqcwrzNkMKR6B0wsWZ6RFkVBaVi1N91BsaaA092YgHLnUvBRlDbebJLwMpey4NsUPevDNUwCA5EVfvrPmF4qK2vSS+tFvW9fZVUQ8WuDAuNv4k0GnMh62JT/X2RQ2xpMBNKVhswQIzWfh/e3PnVota3vQ7keUy6423aYih32+QazMHQ4iTmpeP6h7Hjb+8sKrweHhQY+25jykrpRcjFcycjcsO4TxFjPpek2Iv8+mk4iBdNJkTL9Q47eP/ekE4LkHqa3Bm6Go4ZZFEkPeY+kNElCtT28naFudigrwBw6RWVtIu/FZXFSYZLdHBXanOW46FCo403VoamaYDUS0RiA16NiFfFK/K8G9FygKNn2u/L8TsVwumP+3FLx4D/hvAco8rqB1wNFoWgkXznETnmbbs19INsJtz0+657GvpJfUqdoUx1RcYKEgpC75666PLjm5BHGJbPJv7nIbpjDWOuSIGGdLzEbj07pJm/wKOZY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(76116006)(86362001)(4326008)(6916009)(71200400001)(26005)(6486002)(2616005)(38070700005)(2906002)(508600001)(966005)(5660300002)(6512007)(316002)(8936002)(66476007)(66556008)(64756008)(54906003)(38100700002)(8676002)(36756003)(66946007)(53546011)(6506007)(122000001)(33656002)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFNJOXYzcFZWL05kcVBLU0VCUEduMzRwVXVHOFg0Rittc21xS2lDdlM4T2Nh?=
 =?utf-8?B?OStzc1IzL3R2dVFMU1BudDk1dC9HNFplZFdndFkzaE9tT3AvNmhQRTlpdlFD?=
 =?utf-8?B?b3k5QlNQNXk5UHh6V2trdllXayt3RGl4Y1F3WWNFM1hUb3JxakVDcHZXTFdj?=
 =?utf-8?B?bGdDWTB3MXlScnkvSjFkbmI3QzNmTmczVjBTU0JqaFF4dWJoZmxXUUdJZDFH?=
 =?utf-8?B?c3NwWlNNdUNhVGl0V29FaEhsUFl5UXVya0JHTzVOdnRrdThHRU1mTWFxMGlj?=
 =?utf-8?B?cFNLVy9GdkIydkJIYWVRTmlVdVJYL1ZwQ1dPY2FSWHA1S05ka0pwTkx0Tmo3?=
 =?utf-8?B?SU42dWxLU2dvMTJvWElORllqMHczU2gwY2hLd2tremJxakowbjd6SDdmZnJt?=
 =?utf-8?B?VXZsRnNXYjU4b3Bod3Vpbks1empUT2lWaGdFaVRnTDZNU0ZybTI4czVNZkMz?=
 =?utf-8?B?Y256YmxkSDd0Wk5XTGNvdlREc05jYTljVDdHazRIQVVxeE1vdDJONDRLdjgr?=
 =?utf-8?B?dmtjTUdLSTgxN3BwcEJ5T1d2cGtJdHJUbzJJQS9xRDNlZEljaXBVNGx5OHZC?=
 =?utf-8?B?K3YxcWN2ZU5KUDZTcE1YeTBPQ2JOMm9Fcm1EbW81VE5aUTZheU1MTzlWYUlN?=
 =?utf-8?B?dkZwaWJPSTBneHRHSWlzNHlKQWdENUF6eWszSlJvVzl0KzFzT1RmaHpvRG96?=
 =?utf-8?B?R0VxWTErVHIrTUZUSVJEanp1NmRVa3VCRXlxNlR0d3EwUFhQdTNCUUdEZEx6?=
 =?utf-8?B?aFVzSzFIQXlLS1M2b09IT3JTZTQ5RVM5dnV2QnZNUStMdVJXVC9xVVFxNlBr?=
 =?utf-8?B?Y3paY1NaTlNsRTlxU3JveDJTZGdya0wvQkNaczBhMUpNd3FNTmd3eitDcStN?=
 =?utf-8?B?QzUxR2hBZTJqWFh3L09pS0JhcXdIcys3MUJGRFFDVkxENXVrNXlBYjJjSnUw?=
 =?utf-8?B?UFhuSGgrNi9RRGlDeGFvMXRZbSthOUZFeHUzR1U4aXcxY3lpL0tucW02dGJY?=
 =?utf-8?B?dERZSzR4eVR4NldteGwwRW1PdDdHc0d2WnRmdWdBZEM1UnBlTVF6SWNTSDJh?=
 =?utf-8?B?Z1NCbXlLN1lrb1U2SlgzYUp2SEtNby95VjJicllFRXJDZWx5dDRHVFlXN1dy?=
 =?utf-8?B?cmRBbDBPSFRvWWptUVgvM3dqLzZaUzgra04weGtvVjhaaEs5SG80QXloaENh?=
 =?utf-8?B?bWd2R1BxQi92ejVIa05YMVNWZWR1VnROU0NMS3IyNDZ5OENzcTNCV2Mxa25x?=
 =?utf-8?B?ejR6Z0t0bW9hS1o5Mmowd09HSG5SKzFjT09Pd1VQK0Z5Y2htZE9XdU1lN2FS?=
 =?utf-8?B?VzVuNk1zNGY5cHZYSGJRVFBBZ3FSOXhGQkdNc0wyMERielpaNmpoTVdNcGNW?=
 =?utf-8?B?Tlh5Ry9xWUIzem9WdDZ0U3I4NTluV1VZb3NPOHdkeGM5SU9jenkvTWxnS3B1?=
 =?utf-8?B?dHhrcll5eDJFbEFPZW9hbmNYV2xlR3RzUWhHYVk0R05Jc2d3RllNSEMyNEdJ?=
 =?utf-8?B?MGcyNGxQeEV1VEljN01XczFMMlhscTdTekpZWXhDa3JxSytFNDMzaWRQWUZo?=
 =?utf-8?B?bytFemllOGFSanlFY1VyTGt2RVBzc1BuQ1RxRllHVGdSTmtzYXJvcmlSVFFC?=
 =?utf-8?B?d3BRTWR4NUREc0YzNlNyOFdiZlhjWG9hZ1Z5WlI0YmdoODYwRGZBMWZJcFg0?=
 =?utf-8?B?RVd4amZuQW9oVWdDL0o1c0tlQ0hJS0dUSGw2SmFyMlRSeG9QdEQvZUhjblNZ?=
 =?utf-8?Q?purKasO+qhT+hqg3/C0iFASFFEBroD8PI4nRr5y?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0ED072A7C7F2784EBCA75110C805897B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c52daa-3b57-46da-aded-08d986be17f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 22:35:25.2550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JLbNjLRdIRYK/mNfzEjaBg/Jta80Elg3It77kWyuKqBBpuHlOG5+jeMSPdO2NjrYw88RYeioomy96lV//cGRNlav1yXpFlD8lCu0L/HeVI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5159
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gT2N0IDEsIDIwMjEsIGF0IDA1OjQ1LCBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25p
eC5kZT4gd3JvdGU6DQo+IE9uIFdlZCwgQXVnIDI1IDIwMjEgYXQgMDg6NTMsIENoYW5nIFMuIEJh
ZSB3cm90ZToNCj4+IEhhdmUgdGhlIGZ1bmN0aW9uIGluaXRpYWxpemluZyB0aGUgWFNUQVRFIGJ1
ZmZlciB0YWtlIGEgc3RydWN0IGZwdSAqDQo+PiBwb2ludGVyIGluIHByZXBhcmF0aW9uIGZvciBk
eW5hbWljIHN0YXRlIGJ1ZmZlciBzdXBwb3J0Lg0KPj4gDQo+PiBpbml0X2Zwc3RhdGUgaXMgYSBz
cGVjaWFsIGNhc2UsIHdoaWNoIGlzIGluZGljYXRlZCBieSBhIG51bGwgcG9pbnRlcg0KPj4gcGFy
YW1ldGVyIHRvIGZwc3RhdGVfaW5pdCgpLg0KPj4gDQo+PiBBbHNvLCBmcHN0YXRlX2luaXRfeHN0
YXRlKCkgbm93IGFjY2VwdHMgdGhlIHN0YXRlIGNvbXBvbmVudCBiaXRtYXAgdG8NCj4+IGN1c3Rv
bWl6ZSB0aGUgY29tcGFjdGVkIGZvcm1hdC4NCj4gDQo+IFRoYXQncyBub3QgYSBjaGFuZ2Vsb2cu
IENoYW5nZWxvZ3MgaGF2ZSB0byBleHBsYWluIHRoZSBXSFkgbm90IHRoZSBXSEFULg0KPiANCj4g
SSBjYW4gc2VlIHRoZSBXSFkgd2hlbiBJIGxvb2sgYXQgdGhlIGxhdGVyIGNoYW5nZXMsIGJ1dCB0
aGF0J3Mgbm90IGhvdw0KPiBpdCB3b3Jrcy4NCg0KVGhlIHNhbWUgZmVlZGJhY2sgd2FzIHJhaXNl
ZCBiZWZvcmUgWzFdLiBJIHRob3VnaHQgdGhpcyBjaGFuZ2Vsb2cgaGFzIGJlZW4NCnNldHRsZWQg
ZG93biB3aXRoIEJvcmlzIFsyXS4NCg0KSG93IGFib3V0Og0KDQogICAg4oCcVG8gcHJlcGFyZSBk
eW5hbWljIGZlYXR1cmVzLCBjaGFuZ2UgZnBzdGF0ZV9pbml0KCnigJlzIGFyZ3VtZW50IHRvIGEg
c3RydWN0DQogICAgIGZwdSAqIHBvaW50ZXIgaW5zdGVhZCBvZiBhIHN0cnVjdCBmcHJlZ3Nfc3Rh
dGUgKiBwb2ludGVyLiAgQSBzdHJ1Y3QgZnB1DQogICAgIHdpbGwgaGF2ZSBuZXcgZmllbGRzIHRv
IGhhbmRsZSBkeW5hbWljIGZlYXR1cmVzLiINCg0KV2l0aCBmcHN0YXRlX2luaXRfeHN0YXRlKCkg
Y2hhbmdlcyBpbiBhIHNlcGFyYXRlIHBhdGNoIGFuZCBkZWZpbmluZyBpbml0X2ZwdSwNCnRoZSBs
YXN0IHR3byBzZW50ZW5jZXMgc2hhbGwgYmUgcmVtb3ZlZC4NCg0KPiBBbHNvIHRoZSBzdWJqZWN0
IG9mIHRoaXMgcGF0Y2ggaXMganVzdCB3cm9uZy4gSXQgZG9lcyBub3QgbWFrZSB0aGUNCj4gZnVu
Y3Rpb25zIGhhbmRsZSBkeW5hbWljIGJ1ZmZlcnMsIGl0IHByZXBhcmVzIHRoZW0gdG8gYWRkIHN1
cHBvcnQgZm9yDQo+IHRoYXQgbGF0ZXIuDQoNCkhvdyBhYm91dCDigJxQcmVwYXJlIGZwc3RhdGVf
aW5pdCgpIHRvIGhhbmRsZSBkeW5hbWljIGZlYXR1cmVzIg0KDQo+PiArc3RhdGljIGlubGluZSB2
b2lkIGZwc3RhdGVfaW5pdF94c3RhdGUoc3RydWN0IHhyZWdzX3N0YXRlICp4c2F2ZSwgdTY0IG1h
c2spDQo+PiArew0KPj4gKwkvKg0KPj4gKwkgKiBYUlNUT1JTIHJlcXVpcmVzIHRoZXNlIGJpdHMg
c2V0IGluIHhjb21wX2J2LCBvciBpdCB3aWxsDQo+PiArCSAqIHRyaWdnZXIgI0dQOg0KPj4gKwkg
Ki8NCj4+ICsJeHNhdmUtPmhlYWRlci54Y29tcF9idiA9IFhDT01QX0JWX0NPTVBBQ1RFRF9GT1JN
QVQgfCBtYXNrOw0KPj4gK30NCj4gDQo+IFRoaXMgd2FudHMgdG8gYmUgYSBzZXBhcmF0ZSBjbGVh
bnVwIHBhdGNoIHdoaWNoIHJlcGxhY2VzIHRoZSBvcGVuIGNvZGVkDQo+IHZhcmlhbnQgaGVyZToN
Cg0KT2theSwgbWF5YmUgdGhlIGNoYW5nZSBiZWNvbWVzIHRvIGJlIHRoZSBuZXcgcGF0Y2gxLg0K
DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2ZwdS94c3RhdGUuYyBiL2FyY2gveDg2
L2tlcm5lbC9mcHUveHN0YXRlLmMNCj4+IGluZGV4IGZjMWQ1Mjk1NDdlNi4uMGZlZDdmYmNmMmU4
IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2ZwdS94c3RhdGUuYw0KPj4gKysrIGIv
YXJjaC94ODYva2VybmVsL2ZwdS94c3RhdGUuYw0KPj4gQEAgLTM5NSw4ICszOTUsNyBAQCBzdGF0
aWMgdm9pZCBfX2luaXQgc2V0dXBfaW5pdF9mcHVfYnVmKHZvaWQpDQo+PiAJcHJpbnRfeHN0YXRl
X2ZlYXR1cmVzKCk7DQo+PiANCj4+IAlpZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1hTQVZF
UykpDQo+PiAtCQlpbml0X2Zwc3RhdGUueHNhdmUuaGVhZGVyLnhjb21wX2J2ID0gWENPTVBfQlZf
Q09NUEFDVEVEX0ZPUk1BVCB8DQo+PiAtCQkJCQkJICAgICB4ZmVhdHVyZXNfbWFza19hbGw7DQo+
PiArCQlmcHN0YXRlX2luaXRfeHN0YXRlKCZpbml0X2Zwc3RhdGUueHNhdmUsIHhmZWF0dXJlc19t
YXNrX2FsbCk7DQoNClRoYW5rcywNCkNoYW5nDQoNClsxXSBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9sa21sLzIwMjAxMjA3MTcxMjUxLkdCMTY2NDBAem4udG5pYy8NClsyXSBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9sa21sLzIwMjEwMTE1MTI0MDM4LkdBMTEzMzdAem4udG5pYy8NCg0KDQo=
