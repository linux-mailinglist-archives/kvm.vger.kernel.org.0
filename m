Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060F742B6B2
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 08:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbhJMGSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 02:18:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:2505 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhJMGSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 02:18:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="214302429"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="214302429"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 23:16:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="570722877"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 12 Oct 2021 23:16:00 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 23:15:59 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 23:15:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 23:15:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 23:15:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikF+yXfjdUWdHLst/Ax9tuX4TQNbFk1WtpPRfHfMkHj47Ir2m36Lpth9HryZh9iZjwwfpqVUjWE1rjpn7eDel2I6Cnq6Ukhzt33iU2N4Q39f3VogkmdSeAqL2sVmT+TdVog96JF84AaQpwo+k68btiz3IckrtcDcxOYCVpoPehEuxlhofSWDFQncZN6TpXFpFGm9cP3C3bg1i42Oh9GPEge7kn/Bm6OLhz/pKencXlGlpJ4sT4ihM8sm5Kd9ojI61SrbJTJ1Bn8ejeKFzg7xXJGB4Jq5XfBQYVdq9kZLjK/3gt78tmE90Fh8QkQg9GUjeSrKL6oZtH+L7MZnA4Av7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIFQe7fmNhgj9oqpVmNcotXcmFgoad0+ibVl6LrS1Ps=;
 b=kZjLhsawvwpsafECfxKrRPYYxSccHM7e1z/7y98c0OGyDrCrI4AC2Rr7p6P1kG9JdRN6NcjyJ/MOs6PGSPpe3vd0zS6pkI1dGWALJHdRKwW6DDnpcF5u0WdJTWoaHyeF67sjLkggzKMZYKG4F/M/2HBIHFr1L9vjpnL/iwlUM+y/6Khz2qfidcAFW26a1u01JX2Lx7HI237CwucUk62jp7I+vdwaVo9Sn9BPY/K1Kl6O6AZYUcyZUvecBq1kyFWcpsl1v4prAJ3j5lQ2QTReh9hsaO7gQp7seHJgtQZ9T6riXC99RATomAw1CKVXUTsTdH3j0seaFajlHXQvj2W5+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIFQe7fmNhgj9oqpVmNcotXcmFgoad0+ibVl6LrS1Ps=;
 b=LX7m/0hIzQlSE/SkdOgBC9GtNtv1+8fd54tgetKzCAB5Ls2cb7XXGlBvtmVJslfsyE1MrSlk/UJ40oiG+OR67n0gKPZpIJNPVawFu/A6aIchaMSvJ2d/LZffm6FZSh/A1HnTyeM5TQj2oBOMo96fP3s5LWS9Zp9M0MG0OE+dShs=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB3446.namprd11.prod.outlook.com (2603:10b6:a03:1a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 06:15:56 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::d9e1:ed97:d0d9:d571]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::d9e1:ed97:d0d9:d571%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 06:15:56 +0000
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
        "seanjc@google.com" <seanjc@google.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTg
Date:   Wed, 13 Oct 2021 06:15:56 +0000
Message-ID: <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
 <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
In-Reply-To: <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2659e3e6-a6c5-47c5-1bcc-08d98e10eaf3
x-ms-traffictypediagnostic: BYAPR11MB3446:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB34464E341BC1B05A44894993A9B79@BYAPR11MB3446.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lpyASHmA8Ea4m5cPXTJQn3kVMTw4HmIweELVkWIO9ousoWbJxYVWVIHf3XQVuXRZNTpeTXoP7R3sh92oZWhRlsyArBDCNmcBZqXzZcctWFlWWf0tN3rZJ0jcp5eeeTear0v5w2OKnfRy/66qGb00Y9psaH6S9VrMQAdoaano93MRopMPVdnF/zrfUIeCnKfipdS64H2wJgQtoHC6t73TE/A1PEdhyOZ900tssykf4sM7KGjm2xp1qcodAQS1+6sUK3UvAOjxWnxLSRgtCTFV+VLrEkXY/JCZJI5z0xAfovIaBOhMoC/4WDi4Tt5Lxj9AovfOQ4nJULSSLap95bSR76iFXRJHNw/CDsIL7E9Axg2Gew6RYnHKzzNZyoJvcMD+3iIS8Qn9tpnmdwbdcu25avXKTyIS+p/UhYjUlPE9gHQQlzwL4QfcwDpMHCXnIlawaBEznHDV+Bev9BMv9dxZrbX6NCESvrmx7JfX4yHH5v9/NyVq5RJB8g0rdu1xCTOnxKb3fGSBJ402I9uO2VRq05q0uthjfuyVQyVReRdK4x2+CM3w1Hs1qpv+wiZLXGcYXfU2Mb3eOPuWQCI+BEZNiAd07vw+Ei6xoPez/mflWa0ez6ZCDd08Uny9We2ToxqyfID/Zgz3rLmTHv4iLMBFocSBqG84ZmXmatVOhBVzfuAoXS01Tnd2D24q3B3EA6mFBrs9Afp4xuFjN1y7SdZqgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(86362001)(110136005)(122000001)(6506007)(8936002)(33656002)(9686003)(7696005)(316002)(5660300002)(53546011)(83380400001)(38070700005)(2906002)(76116006)(186003)(8676002)(55016002)(38100700002)(508600001)(66946007)(82960400001)(66556008)(71200400001)(26005)(64756008)(4326008)(54906003)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3J1OWZFQ1JtWCtsSWZTemx3dTY3SEh2ZWdFVUU5RmtMelNUQ1FwUmpPT3BF?=
 =?utf-8?B?cmFrQkE2N1NjaUJQTFZtdjBMNXQ0RHVaUnRpR1dCU0E4aG5PYVRzRFJ5Rm5M?=
 =?utf-8?B?YkRlNzBjbGtvVzJ4N0RBZjVLckZIWWx5eWZ6OXBKMWVsYXBTRDY2RHNtZ213?=
 =?utf-8?B?Y3lyU3ZtQktUVFlYMjB0Z2M4dnpYZUVpNUdBdUVxWmUrY0hzdHRLdmtsdW9F?=
 =?utf-8?B?b0FUeU0wTEdNaDRxTTl1cjBUbHE1QjIyL0ZDYVlXaU4rcVFERWtIWXdGdGc5?=
 =?utf-8?B?TjVGYlRNRXFFSDhjSFk4azY3Vk9CQXV6cktEQ1ZNRkJNWGdGM2twdWlYMlNo?=
 =?utf-8?B?NHhBTkU3MW9BdWFlL1kvU0NQeStBeFhPVHluL0JoZmJTRkZxaVN0SzJxc0ND?=
 =?utf-8?B?ZWhRenVPQVJ5VDYxN1VzV1Q5RG5BZjZaKzVmaUszalF5UU9LenlRUzg3Z0E2?=
 =?utf-8?B?K055YUJzSFkzOG12ajZZaVN3aGV3MG10TG1HcTYwRlFWbFRlb2hYTEs1dk5P?=
 =?utf-8?B?cXBuQllENnc4NUJTNVNGN1F4bW8rMzE1OUZQcGN4RmVTdy9jQ2RjamtqbGxW?=
 =?utf-8?B?SnE3bytHcFpVQTl6S004NXo5SDBkMEthOWRjYzZ5c0Y3TGIrVUU4dWRoMVdE?=
 =?utf-8?B?Z1V2Y2paSk55cHFtUkRaaERESzNqQUl0VmR4b05LbHIreDFEV3pMeGhhd3ov?=
 =?utf-8?B?MWxGS0lRc3JBUXlUbkp5T2NXbW9zZ1p3WXFjd2tVMjNhT3VuaFcydWIxNktp?=
 =?utf-8?B?WGtFQndwUmdpc1BuSy9IQzZPbElKZTJXaU95dmFaYWZxK2Nwczc1QUpERXpW?=
 =?utf-8?B?RUVUb2U4djlrdjA3L1hLNGpUeGY4MWdaaGpVYTI5ZUpZTHJWMTZBSk1ZZWVn?=
 =?utf-8?B?aVM4YTlJVC9TUytCM1lqVjNDNGVpaVFLYUcxOERyYmlvV2JaRmtYZEJ3My9W?=
 =?utf-8?B?cHZuak5RTVVrVU50NFU2T1JOUUhyVDNXNndGNFRkOEluL0dIeGYwbndoaWk0?=
 =?utf-8?B?YUpFTWtOdCt0OU5YY1g0L084blViRjJOWUdjekt1YUU2TE9HbmQrRmg3ejI3?=
 =?utf-8?B?OUhCdEdqL0pIWFFMdHRVU0gveTFNaWt1TVZDc01iMStsQkV0anFHN3gwY1VS?=
 =?utf-8?B?MUdScHNrcHpYK2VDaDQ1ZUI0Zm5CcEV2N25rWUZwOUh4cFNNc3ltOThEU25r?=
 =?utf-8?B?OFY4NUVaQzdpa1JuUHNIU0NQRTZKTmNxNk13TTE4ck9VUU1sYmdQak9KK0Zi?=
 =?utf-8?B?WFhOUlY2ZHEvcTdWSEdrS0ZZTm5LZ1ltMWM5RXdGK1FheGgrMUllSXFNNlZR?=
 =?utf-8?B?TFZyMzAydFgwbmF4Tm03dWl4OU5IalViY1V6L0pPL1dXRm0rdVhFZlBUaFNq?=
 =?utf-8?B?djFzK2NVU2gyb2ZNeHZuZzJRY0Y5Y2hmUXNrRUpob1dGazJOWVVHNWFNWEk0?=
 =?utf-8?B?Y0FPY3JlNnZ5NW8xNVRBbjQ5SFJMdzEwQmtnZ29YVEx6SEhSMjV1UVRyTlpy?=
 =?utf-8?B?RjdVaDZlWnNycXhEQjBucC9rRWFnMUJJNzFrUjlvSUxTcWtsRXNVa3JIRm01?=
 =?utf-8?B?bTE5eE12OWF0Rlk2Q3IzMDRVRzZZNndKaGoyVzl1bjRFUW5kRCt1Zjl3dnA0?=
 =?utf-8?B?ODh3Q3VqeUFQSTlrekxFYXgwVXRMSjNCYWRKWXVpei8zTGVEWVUzbEhlc1lO?=
 =?utf-8?B?VXE2WWlGcVFSaU9SUHpaWVRMb3hidlJISk5ZMENkcWx5OFFObEdGTHdSd0Rw?=
 =?utf-8?Q?+u1oemoKaEb5JNsqwNAKunD/e1dL3i1uI+53GMt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2659e3e6-a6c5-47c5-1bcc-08d98e10eaf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 06:15:56.0948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tEMBNQHOmyxLEsD2aqAvT0O6h2IaLB8cAjIR9gugt08TlSam3x0c1oetsDhIWKjJoLvkaoJq68vu/COc+JrfXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3446
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAxMi8xMC8yMSAwMjowMCwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOg0KPiA+IFN3YXBwaW5n
IHRoZSBob3N0L2d1ZXN0IEZQVSBpcyBkaXJlY3RseSBmaWRkbGluZyB3aXRoIEZQVSBpbnRlcm5h
bHMNCj4gPiB3aGljaCByZXF1aXJlcyA1IGV4cG9ydHMuIFRoZSB1cGNvbWluZyBzdXBwb3J0IG9m
IGR5bWFuaWNhbGx5IGVuYWJsZWQNCj4gPiBzdGF0ZXMgd291bGQgZXZlbiBuZWVkIG1vcmUuDQo+
ID4NCj4gPiBJbXBsZW1lbnQgYSBzd2FwIGZ1bmN0aW9uIGluIHRoZSBGUFUgY29yZSBjb2RlIGFu
ZCBleHBvcnQgdGhhdCBpbnN0ZWFkLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogVGhvbWFzIEds
ZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+DQo+ID4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPiBDYzogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gPiAtLS0NCj4g
PiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL2ZwdS9hcGkuaCAgICAgIHwgICAgOCArKysrKw0KPiA+
ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vZnB1L2ludGVybmFsLmggfCAgIDE1ICstLS0tLS0tLS0N
Cj4gPiAgIGFyY2gveDg2L2tlcm5lbC9mcHUvY29yZS5jICAgICAgICAgIHwgICAzMCArKysrKysr
KysrKysrKysrKystLS0NCj4gPiAgIGFyY2gveDg2L2tlcm5lbC9mcHUvaW5pdC5jICAgICAgICAg
IHwgICAgMQ0KPiA+ICAgYXJjaC94ODYva2VybmVsL2ZwdS94c3RhdGUuYyAgICAgICAgfCAgICAx
DQo+ID4gICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgICAgICB8ICAgNTEgKysrKysr
Ky0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gICBhcmNoL3g4Ni9tbS9leHRhYmxl
LmMgICAgICAgICAgICAgICB8ICAgIDIgLQ0KPiA+ICAgNyBmaWxlcyBjaGFuZ2VkLCA0OCBpbnNl
cnRpb25zKCspLCA2MCBkZWxldGlvbnMoLSkNCj4gPg0KDQpXaGVuIGxvb2tpbmcgaW50byB0aGUg
dGdseC9kZXZlbC5naXQgeDg2L2ZwdSBmb3IgdGhlIGZ1bGwgIzEtIzQgDQpzZXJpZXMgYW5kIHRo
ZSBLVk0gQU1YIHN1cHBvcnQsIEknZCBsaWtlIHRvIHRhbGsgdHdvIHRoaW5ncw0KIGFzIGZvbGxv
d3MsDQoNCjEuIEtWTSBkeW5hbWljIGFsbG9jYXRpb24gQVBJOg0KU2luY2UgS1ZNIGFsc28gdXNl
cyBkeW5hbWljIGFsbG9jYXRpb24sIGFmdGVyIEtWTSBkZXRlY3RzIGd1ZXN0DQpyZXF1ZXN0aW5n
IEFNWCBieSAjTk0gdHJhcCwgS1ZNIG5lZWQgYWxsb2MgZXh0cmEgYnVmZmVyIGZvcg0KdGhpcyB2
Y3B1J3MgY3VycmVudC0+dGhyZWFkLmZwdS5mcHN0YXRlIGFuZCBndWVzdF9mcHUgcmVsYXRlZC4N
ClNvIGZhciwgdGhlIGtlcm5lbCBpdHNlbGYgaGFzIHN1Y2ggQVBJIGxpa2UgZnBzdGF0ZV9yZWFs
bG9jKCksIGJ1dCBpdCdzDQpzdGF0aWMuIEhvdyBhYm91dCBtYWtpbmcgYSBjb21tb24gZnVuY3Rp
b24gdXNhYmxlIGZvciBLVk0/DQoNCg0KMi4gVGhlcmUgZXhpc3RzIGEgY2FzZSB0aGF0ICpndWVz
dCBBTVggc3RhdGUgY2FuIGJlIGxvc3QqOg0KDQpBZnRlciBLVk0gcGFzc3Rocm91Z2ggWEZEIHRv
IGd1ZXN0LCB3aGVuIHZtZXhpdCBvcGVuaW5nDQppcnEgd2luZG93IGFuZCBLVk0gaXMgaW50ZXJy
dXB0ZWQsIGtlcm5lbCBzb2Z0aXJxIHBhdGggY2FuIGNhbGwNCmtlcm5lbF9mcHVfYmVnaW4oKSB0
byB0b3VjaCB4c2F2ZSBzdGF0ZS4gVGhpcyBmdW5jdGlvbiBkb2VzDQpYU0FWRVMuIElmIGd1ZXN0
IFhGRFsxOF0gaXMgMSwgYW5kIHdpdGggZ3Vlc3QgQU1YIHN0YXRlIGluIHJlZ2lzdGVyLA0KdGhl
biBndWVzdCBBTVggc3RhdGUgaXMgbG9zdCBieSBYU0FWRVMuDQoNClRoZSBkZXRhaWxlZCBleGFt
cGxlIGNhbGwgdHJhY2UgaW4gY29tbWl0DQpjb21taXQgMjYyMGZlMjY4ZTgwZDY2N2E5NDU1M2Nk
MzdhOTRjY2FhMmNiOGM4Mw0KQXV0aG9yOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4NCkRhdGU6ICAgRnJpIEphbiAxNyAxMTozMDo1MSAyMDIwIC0wODAwDQoNCiAgICBL
Vk06IHg4NjogUmV2ZXJ0ICJLVk06IFg4NjogRml4IGZwdSBzdGF0ZSBjcmFzaCBpbiBrdm0gZ3Vl
c3QiDQoNCiAgICBSZWxvYWQgdGhlIGN1cnJlbnQgdGhyZWFkJ3MgRlBVIHN0YXRlLCB3aGljaCBj
b250YWlucyB0aGUgZ3Vlc3QncyBGUFUNCiAgICBzdGF0ZSwgdG8gdGhlIENQVSByZWdpc3RlcnMg
aWYgbmVjZXNzYXJ5IGR1cmluZyB2Y3B1X2VudGVyX2d1ZXN0KCkuDQogICAgVElGX05FRURfRlBV
X0xPQUQgY2FuIGJlIHNldCBhbnkgdGltZSBjb250cm9sIGlzIHRyYW5zZmVycmVkIG91dCBvZg0K
ICAgIEtWTSwNCiAgICBlLmcuIGlmIEkvTyBpcyB0cmlnZ2VyZWQgZHVyaW5nIGEgS1ZNIGNhbGwg
dG8gZ2V0X3VzZXJfcGFnZXMoKSBvciBpZiBhDQogICAgc29mdGlycSBvY2N1cnMgd2hpbGUgS1ZN
IGlzIHNjaGVkdWxlZCBpbi4NCiAgICAuLi4NCiAgIEEgc2FtcGxlIHRyYWNlIHRyaWdnZXJlZCBi
eSB3YXJuaW5nIGlmIFRJRl9ORUVEX0ZQVV9MT0FEIGlzIHNldCB3aGlsZQ0KICAgIHZjcHUgc3Rh
dGUgaXMgbG9hZGVkOg0KDQogICAgIDxJUlE+DQogICAgICBnY21hZXNfY3J5cHRfYnlfc2cuY29u
c3Rwcm9wLjEyKzB4MjZlLzB4NjYwDQogICAgICA/IDB4ZmZmZmZmZmZjMDI0NTQ3ZA0KICAgICAg
PyBfX3FkaXNjX3J1bisweDgzLzB4NTEwDQogICAgICA/IF9fZGV2X3F1ZXVlX3htaXQrMHg0NWUv
MHg5OTANCiAgICAgIC4uLg0KICAgICAgPyBkb19JUlErMHg3Zi8weGQwDQogICAgICA/IGNvbW1v
bl9pbnRlcnJ1cHQrMHhmLzB4Zg0KICAgICAgPC9JUlE+DQogICAgICA/IGlycV9lbnRyaWVzX3N0
YXJ0KzB4MjAvMHg2NjANCiAgICAgID8gdm14X2dldF9pbnRlcnJ1cHRfc2hhZG93KzB4MmYwLzB4
NzEwIFtrdm1faW50ZWxdDQogICAgICA/IGt2bV9zZXRfbXNyX2NvbW1vbisweGZjNy8weDIzODAg
W2t2bV0NCiAgICAgID8gcmVjYWxpYnJhdGVfY3B1X2toeisweDEwLzB4MTANCiAgICAgID8ga3Rp
bWVfZ2V0KzB4M2EvMHhhMA0KICAgICAgPyBrdm1fYXJjaF92Y3B1X2lvY3RsX3J1bisweDEwNy8w
eDU2MCBba3ZtXQ0KICAgICAgPyBrdm1faW5pdCsweDZiZi8weGQwMCBba3ZtXQ0KDQpGb3IgdGhp
cyBjYXNlLCBJIHRoaW5rIG9uZSB3YXkgaXMga2VybmVsIGRvaW5nIHNvbWV0aGluZyBiZWZvcmUg
WFNBVkVTDQpmb3IgS1ZNIHRocmVhZDsgYW5vdGhlciB3YXkgaXMgbGV0IEtWTSBmaXg6IG1haW50
YWluaW5nIGEgemVybyBYRkQNCnZhbHVlIChieSBjdXJyZW50LT5zdGF0ZS5mcHUuZnBzdGF0ZS0+
eGZkID0gMCkgYWZ0ZXIgdmNwdSBmcHUgc3RhdGUgaXMgDQpsb2FkZWQgYW5kIHJlc3RvcmUgcmVh
bCBndWVzdCBYRkQgdmFsdWUgYmVmb3JlIHZtZW50ZXIuIA0KTG9naWMgYXMgZm9sbG93cy4NCg0K
YWZ0ZXIgdm1leGl0Og0KaWYgWEZEIGlzIHBhc3N0aHJvdWdoDQp0aGVuDQoJc3luYyBndWVzdCBY
RkQgdG8gdm14LT54ZmQ7DQoJc2V0IFhGRCB0byBjdXJyZW50LT5zdGF0ZS5mcHUuZnBzdGF0ZS0+
eGZkICg9IDApDQoJX190aGlzX2NwdV93cml0ZSh4ZmRfc3RhdGUsIDApOw0KDQpiZWZvcmUgdm1l
bnRlciAoaXJxIGlzIGRpc2FibGVkKToNCmlmIHBhc3N0aHJvdWdoDQp0aGVuDQoJcmVzdG9yZSB0
byByZWFsIGd1ZXN0IFhGRCBieSB2bXgtPnhmZDsNCg0KdmNwdV9ydW46IChpZiBYRkQgaXMgcGFz
c3Rocm91Z2gpDQpsb2FkOiBzd2FwIGZyb20gcWVtdSdzIHRvIGEgemVybyBYRkQNCnB1dDogc3dh
cCB6ZXJvIHRvIHFlbXUncw0KDQoNClRoYW5rcywNCkppbmcNCg0KWy4uLl0NCg==
