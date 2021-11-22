Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F77B458ABC
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 09:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhKVIxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 03:53:43 -0500
Received: from mga18.intel.com ([134.134.136.126]:42977 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhKVIxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 03:53:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10175"; a="221630738"
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="scan'208";a="221630738"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 00:50:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="scan'208";a="508867937"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 22 Nov 2021 00:50:36 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 22 Nov 2021 00:50:35 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 22 Nov 2021 00:50:35 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 22 Nov 2021 00:50:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPB+Pn4A/7IDCXxlKfpxFHThERoCRVlD8uRMpQnOtvkCNTZzGfb7bHKYEQDSPv5/kyxU4H8L/uITvnn4zR4aQzQMtN7u+7QpdIDdDTwenQtApUBnH7/pvRsTVGhukdNH8rlzCsth5UiEUR7ok55KpFR8ur4JMmCyeR2QfBdIBiiDNWFd1EGzm1t5nrhKi9uUiJP/A94AQusXJUkOqq1XzCcNcZ8cchRu8WJsNzr7PehhqGUIbSxyLhhptJDPbuxShp2j38DznSUmqkRFzj2WKzjtSu9jnCIxqctxA3rNjxTHydrYOeCSngGQMrIchjJQM6HJ0ezBp5guNjOG1ov+SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIA0t5Bc/jrddxAgGKhwTghe422kfbHGL5h2ylS9aGw=;
 b=MXgs3VoOtVPOV4qDC3CrosXzXwVohc2+nv/ZiBnkitXMU17pujlYUSNeNX3eeyOe6+iy0Uzbj7jEAombwUMr9h0Qm91g1Dm/7O2BTxQjzCqsMVcoSVI4ZfI/NSD2BRdsxu0x8GVmHJdpA+PwByZ1BGKWKPlD/nCX/XxZPfRnNWx0mk2mmL6J5cudrJ3R64R4G6DTGGthTyK+VXV7e87lO8LkVLK0hUEQcaWOJX3lrWnhP1koIQPR0ytqNiF3Ob5Ec1jl5JYU9BAtmmARxXFHLc0tJ89nLJXtv02fl1a0gTGf3BQpEHxL5p9L0qZMOKkm6PEDtekMav5cCGIilJF2xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIA0t5Bc/jrddxAgGKhwTghe422kfbHGL5h2ylS9aGw=;
 b=MTz7r/O+nL6sf81CseL9jJr1AhubDHDZ/otlyIZz4higQ4PzWJktsd2FP0QDZlm7DJ1Mt1mUyPW2uPdTziER8O5TwVbCsIPXxMERbtqCswNxZYBgAn/lVkpDQwZez5omvjFT7RlYTKDqKuNSUEvhIz+Mc52EJOa2Gw8pfBbNgzk=
Received: from BL0PR11MB3252.namprd11.prod.outlook.com (2603:10b6:208:6e::18)
 by MN2PR11MB4189.namprd11.prod.outlook.com (2603:10b6:208:139::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18; Mon, 22 Nov
 2021 08:50:33 +0000
Received: from BL0PR11MB3252.namprd11.prod.outlook.com
 ([fe80::3d12:2a53:23d3:c581]) by BL0PR11MB3252.namprd11.prod.outlook.com
 ([fe80::3d12:2a53:23d3:c581%7]) with mapi id 15.20.4713.022; Mon, 22 Nov 2021
 08:50:33 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgABafQCAARh7AIAACH/AgAAb+oCAACdDgIAABPiAgD0YODA=
Date:   Mon, 22 Nov 2021 08:50:33 +0000
Message-ID: <BL0PR11MB3252E976B4A300F1AADA37A6A99F9@BL0PR11MB3252.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
 <BYAPR11MB32565A69998A2D3C26054D3EA9B89@BYAPR11MB3256.namprd11.prod.outlook.com>
 <9c2e202b-4e15-2728-4c61-a2f74adac444@redhat.com>
In-Reply-To: <9c2e202b-4e15-2728-4c61-a2f74adac444@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aca7dfcb-5aa5-4421-e3f2-08d9ad952510
x-ms-traffictypediagnostic: MN2PR11MB4189:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MN2PR11MB41891B4B70853A78BD804ADEA99F9@MN2PR11MB4189.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yeql7LVKa8QM40XwdqMilYAYLA7SwAjpxv4dWq5+jHpTon3JIJ7UPI50Puwy44rh2THUr4q0El3f2HjA09WqigqmT2e2KPUpQWbPQu8c5JWm+RxSlro8sQ6sQhhIYnlvmxX3DP1D2taSH03ONpBXuMryXY9nNWpzbmifna4QVIdnMfsr6VJ98WOn7b2iP8+9tjcco3Rnbd1+NqlmBSRcFBIDaB49Q7r/UiQLto73F8QpyjAOeiytc6rE9EIuORcA6GOjZmvPAjA1vBYmT2axafsF6qeZ3ypeazs+33fVDtEpii0Xm4m0uhqWiA+jvXq0s1YsCC3OPDB4VeKT7lezj84Jo1oHmHzoGqir1SWrmFrosbPChLleUgCAc4aSL1bV9WN11EmZVd1GbXqYbXfmqZLw3e4ZS52JW8Xz0MGXgpoqB5FTScIZICRQcW1xs5Rb4yV5aMhC2cM7y/JxdvIfRKl1KPI3MPKZsjjXTuI/s4yOMTcXKqVmF6MDmBz5FRnmYs2Iz081w357pAB0mMZw0JohqfYpAURUqga8zQj7yInu3FsTIW5dRAEVFOmK0DTDda/Ueoore6gWWbHa9/RJjjrpL3TtVYy6WrkDIWTEahIte/39fQCJBfHpYYgjZD11U9rTLS/B/ZPIjhqJtEaMgNta4LXLiN77T2gCU6LiDbGXfucUOs1EoZeLMIYJlQaUOzyD4JVRoAJ/9VCrjHyyaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3252.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(38070700005)(7416002)(54906003)(9686003)(52536014)(71200400001)(8936002)(38100700002)(508600001)(8676002)(6506007)(53546011)(110136005)(7696005)(186003)(2906002)(82960400001)(86362001)(316002)(122000001)(55016002)(76116006)(66446008)(5660300002)(26005)(66556008)(66476007)(64756008)(33656002)(66946007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVowMzVDMDBsWEpickt6VUQ1dFJTVW5LUlk2ZHdyYUlEMUhWUnYyLzlvVGVo?=
 =?utf-8?B?T1VZZWluTkxZMmU2Zk00OWJ2WHp4UG9QL0YvOUN0bkYrYTlhT09KOUlRTVIr?=
 =?utf-8?B?cG5XVG4xRkkyOWxHQmF0anhiZlJIT1lqVUVuWDRKWDdNNjJzeWNhTnozaksr?=
 =?utf-8?B?bVNWMG1obm8xRnEyd2dCRUdXVFlLZkw2MXk3NEt3ZGROdkJlc2pWNlg2bFh2?=
 =?utf-8?B?WnQ4cVFLbWcvemR1aFNXVzZHMFVMd2pwVHZZVGdMdjZOc0t6dXlHQ3BhOEJp?=
 =?utf-8?B?T2tLakljbFExT1dMN3NZdUpwd21nNmFJOUNuSmowT2p0MHBTTEQ5Vk5VN1V2?=
 =?utf-8?B?dTREL3R5cWNvdmIwVzBLdWZZNllvTlRiTUVnUGoybjdKWnFBUmNpZWVSL2RB?=
 =?utf-8?B?U2ZoRENsK0JRamZDZ0NVNTJSRnNyZXFaU0NUOWFJb2N3c3RCaktNbmpoQ2Fn?=
 =?utf-8?B?TEdjWkJkaVIyWHFONmM3ZzNPY3NNc1pRbGxJcUIzZzZuRzdlbDlsY3B0djFW?=
 =?utf-8?B?c05Mbm85cXAxUituREphRW4wWm5vQ1l5MStsSVdlVUY3M2ZxaXNvZCtlSFUz?=
 =?utf-8?B?ME9yY3JxK0xUcmFmdHpMUkUranVGVzJCK3hTRnZSaHVoMHpPejIvL3lmbFM2?=
 =?utf-8?B?UFlZR3IvNm5Hb1BQcFZhTVplOHpSMitoenhrK3NTdXE0TWtOVit0VjR4OFlO?=
 =?utf-8?B?UEJaLzd1YllNN1dOVFV6WGU5S3l5Q1dPZWR0ei94L09Kd3MwTnVlNm9TZHZF?=
 =?utf-8?B?eGdxLzdTSDdLcmptdGlDNVEvVytyQzVkZGV4QklzV3FrVi9VLzYxZUErSWt2?=
 =?utf-8?B?UHNSYVRGNEZ6aGcrcTB6TlJZNnZhOG5oMjIraTMrS0lDSDBJWFQ0M1krYzVm?=
 =?utf-8?B?YnZTTkNYY3gwcXZLaHZvU0tpR25lYU82a0VPeUxBeVllcWVOSHlPcDhuNGVn?=
 =?utf-8?B?ZUY1Wk8rN0FJU05mR3R3SWNjOTJybG9lVkNUSTRhZUY1QWxPM0lKcmtCek55?=
 =?utf-8?B?aGNjWEh5WXM1T1RxOHFrMXhycU5RcVloQlhrd1lFVnRrQnYvTFZCdkVoRVJl?=
 =?utf-8?B?UndwL1dlMzgxV1hydHlLQS9rc2RzR3Jncml4SUdwQW54d3BpTVNJKzJuMExS?=
 =?utf-8?B?VjlaanNVZ0lZOEE1SFVMdGFSMU91UHdCY2pGV0VhZzlXdkRXN1VqVWUyUGJZ?=
 =?utf-8?B?MklRdjhtK0JvNC9Hb2dXV3JuOVBYaStkVGowTHMwZi9WSnRUOHI0MG9FcmVh?=
 =?utf-8?B?d0Q4eVdQTCtjR1AwdElrYnljNkdsNVVoN2o3R3J0Uno5Z2xINGQ0WWZkVnBO?=
 =?utf-8?B?UEJyZWpCM3BMRXlickhtVjhhdTF3VkcxL1FjYW5KRU03SUlmbmN3SytLTmZF?=
 =?utf-8?B?Rkp0OHR5WkRSY3dsR3FvVi9pOUdFWXJyNkRlZjgxRlFaZ3V5MjFjbFViN0xC?=
 =?utf-8?B?czNKdWU4UTFaaTJDMXdTVXYxaVB1YlltRlB4aCtvZWZvbSs4RGc1NlhlcnhJ?=
 =?utf-8?B?a0VqeGxmaUdqMzlHRkhNMk5tQkJkQUVYNEdnRCtGZjcreUJGdVN4MTZxb0Q3?=
 =?utf-8?B?YTVjVnNYa3kzR3pjd3R6RVBTY3Q0c28zamplUTF5QUowNlRodXltMm4vWFM2?=
 =?utf-8?B?S1kxUHY5a2ovZjFkc1NQcVk5MDI0ZkRLaFNqZFNNMGZiR29KSXhwblk5dS9v?=
 =?utf-8?B?RE12N0lsWVk5dCsyaXJnZkZZR08weTRWdnZRZlAyREVQV3ZXOTdldFZxTU5Y?=
 =?utf-8?B?SlMrd0ZOZ0JrNk00NEVSOWhVR25tKzFCaVlrUWdwZ013cGYvMEhnWFhKL3pH?=
 =?utf-8?B?VU5TaVpPY2NiM21hVWhHYkVtL0hVTnpiSE1qZUVrVm1DSzV3MnBKYnh6MW9j?=
 =?utf-8?B?dkVhYXhXNmEySTdscldnb1V0ZEhNS0FycGdDRzlqSitoV016UmlxYkxXSlpL?=
 =?utf-8?B?TUpxQkoxeXNUbTd5ZW52OU5YYjl3RSt5TDI2U1hpakpYQ3ZFaEg3ckt2Nmc5?=
 =?utf-8?B?cXoyazlPNURBbGhEb1RWMVFxUFlXdzMrT2Jzc1JscHpxOWZ1STdhRXlGTzFO?=
 =?utf-8?B?VFhycUluU0R3YjFFVFhHdGNNU3MyU3EwNEowaEI5SEkvSkZJZy9kVEdQdE9j?=
 =?utf-8?B?VjRqY3IyRVhVTTZhWU9sN3p6dVpFR3NhNTNlTWRWU2FDc1BsaGtibGtBY09F?=
 =?utf-8?Q?T+zhiFwQHK8rt4K7l/dAS5A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3252.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca7dfcb-5aa5-4421-e3f2-08d9ad952510
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 08:50:33.2702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: syrC9rWG12pBmmDViG/GJZNe4c5qPBLM1MGtSCfz+ludnAUZSHil/Qh82UBbDNVAyRj6DNOwata2SjwvhhB/MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4189
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gT24gMTAvMTQvMjAyMSA3OjM5IFBNLCBQYW9sbyBCb256aW5pIHdyb3Rl
Og0KPiANCj4gT24gMTQvMTAvMjEgMTM6MzAsIExpdSwgSmluZzIgd3JvdGU6DQo+ID4gSSBndWVz
cyB3ZSdyZSB3b3JyeWluZyBhYm91dCBpcyB3aGVuIEtWTSBpcyBzY2hlZF9vdXQsIGEgbm9uemVy
bw0KPiA+IFhGRF9FUlIgY2FuIGJlIGxvc3QgYnkgb3RoZXIgaG9zdCB0aHJlYWQuIFdlIGNhbiBz
YXZlIGd1ZXN0IFhGRF9FUlIgaW4NCj4gPiBzY2hlZF9vdXQgYW5kIHJlc3RvcmUgYmVmb3JlIG5l
eHQgdm1lbnRlci4gS2VybmVsIGlzIGFzc3VtZWQgbm90IHVzaW5nDQo+ID4gQU1YIHRodXMgc29m
dGlycSB3b24ndCBtYWtlIGl0IGxvc3QuDQo+ID4gSSB0aGluayB0aGlzIHNvbHZlcyB0aGUgcHJv
YmxlbS4gU28gd2UgY2FuIGRpcmVjdGx5IHBhc3N0aHJvdWdoIFJXIG9mDQo+ID4gaXQsIGFuZCBu
byBuZWVkIHRvIHJkbXNyKFhGRF9FUlIpIGluIHZtZXhpdC4NCj4gDQo+IENvcnJlY3Q7IHlvdSBj
YW4gYWxzbyB1c2UgdGhlICJ1c2VyLXJldHVybiBNU1JzIiBtYWNoaW5lcnkgKHVudGlsIExpbnV4
DQo+IHN0YXJ0cyB1c2luZyBBTVggaW4gdGhlIGtlcm5lbCwgYnV0IHRoYXQgc2hvdWxkbid0IGhh
cHBlbiB0b28gc29vbikuDQo+IA0KVGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4gRm9yIHVzZXIt
cmV0dXJuIE1TUiBtZWNoYW5pc20gdXNpbmcgYnkgZW11bGF0ZWQgDQpNU1JzLCBpdCBjYWxscyBr
dm1fc2V0X3VzZXJfcmV0dXJuX21zcigpIHRvIHdybXNyIG9mIGd1ZXN0IHZhbHVlLCB1cGRhdGUg
Y3Vycg0KdmFsdWUgYW5kIHN3aXRjaCBob3N0IG9uY2Uga2VybmVsIGV4aXQgdG8gdXNlcnNwYWNl
LiANCg0KRm9yIFhGRF9FUlIsIGl0J3MgYXV0b21hdGljYWxseSBjaGFuZ2VkIGJ5IEgvVyBpbiBn
dWVzdCwgc28gS1ZNIG5lZWQgY29ycmVjdGx5IA0KdXBkYXRlIGd1ZXN0IFhGRF9FUlIgdmFsdWUg
YXQgYSB0aW1lLCB3aGljaCBpcyBkaWZmZXJlbnQgZnJvbSBvdGhlciB1c2VyLXJldHVybg0KTVNS
cywgZS5nLiwgYXQgS1ZNIHByZWVtcHRpb24gYW5kIGt2bV9wdXRfZ3Vlc3RfZnB1KCkgdGltZSwg
YW5kIGJvdGggY2FzZXMgDQpuZWVkIG5vdCBkbyB3cm1zci4gQW5kIGZvciBrdm1fcHV0X2d1ZXN0
X2ZwdSgpLCBpdCBkb2VzIHJldHVybiB0byB1c2Vyc3BhY2UuDQpBbHNvLCBYRkRfRVJSIGNhbm5v
dCByZWZlciB0byB2bXgtPmd1ZXN0X3VyZXRfbXNyc19sb2FkZWQgdG8gdXBkYXRlIGJlZm9yZSAN
CnZtZW50ZXIsIHNpbmNlIGN1cnIgbWF5IG5vdCBhbiB1cC10by1kYXRlIHZhbHVlLiBNeSBmZWVs
aW5nIGlzIHRoZSBtZWNoYW5pc20NCm1heSBub3QgbXVjaCBzdWl0YWJsZSBmb3IgdGhpcyBjYXNl
IGFuZCBuZWVkIHNwZWNpYWwgaGFuZGxpbmcuDQoNClNpbmNlIGd1ZXN0IG5vbi16ZXJvIFhGRF9F
UlIgaXMgcmFyZSBjYXNlIGF0IHZtZXhpdCwgaG93IGFib3V0IHNhdmluZyBYRkRfRVJSDQp3aGVu
IHByZWVtcHRpb24sIG1hcmsgZmxhZz10cnVlIGFuZCByZXN0b3JlIGlmIG5vbi16ZXJvIGJlZm9y
ZSB2Y3B1IGVudGVyPyBUaGlzIA0Kc2VlbXMgc2ltcGxlIGFuZCBkaXJlY3Qgd2F5LCBkcmF3YmFj
ayBpcyBpZiBYRkRfRVJSIGlzIG5vdCBjaGFuZ2VkIHdoZW4gc2NoZWR1bGUNCm91dCwgS1ZNIG5l
ZWQgYSB3cm1zciwgYnV0IHRoaXMgb25seSBoYXBwZW5zIHdoZW4gaXQncyBub24temVybyYmZmxh
Zz10cnVlLg0KDQpUaGFua3MsDQpKaW5nDQoNCj4gUGFvbG8NCg0K
