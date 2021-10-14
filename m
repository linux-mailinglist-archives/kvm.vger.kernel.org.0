Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3BF42D80F
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 13:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhJNLXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 07:23:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:19106 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhJNLXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 07:23:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="214818927"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="214818927"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 04:21:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="442070395"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 14 Oct 2021 04:21:39 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 04:21:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 04:21:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 04:21:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dP1GX7YiVTX7h+UgNxNTcca/dSGjqAHxnccPOTF39WX/5eWXLxSLnVOl1gsq1QJ3g4yFdfCWHaRLIRC/7rwtMNoMtv85XhGgaxwxBQ3yUfWjlaJjpkBD5/FF7hCIfV1VrpGYcppiuW79i5N42gKJFhhFS1BXl2EACWkcoc26wk0n/s1CKGKH1s0eRXWWhcQsPQQqBM8PmncIuvIN4yWsJGje9D43wVPt0VhHxxa1EsuojPlnWOYSArIwV0URAqAj/CQzjZRPhurpY2O8cqc6YkFy+s4rgEHOYFh3H+MI+O4q1HhOjE2a2useEm1bZsVubptYvfALcnnoosSTfzyikg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6v+VtCKBZkh7vuOA8nhXoUmpWNJUTGvKVsLy8GcQ1g=;
 b=cdaZx7c25elf+GOqJzVhBmmoH2BaFjRzBYPnnvxXgCw11uBiA39lLZcWj+M76ECRC82XygM0DCB43uGmf4wHEnF2jdDVAZwYoSMnw/mriGlTt6bsFfDo4vY7ysKNtrWkwogss02uTZhI/PVN2ynjhHTaFMfgKT2jX+I42C223KKqCrpkABIAtnZ9iWRqmWgvDwYJEErV1Cj3io/lzBcv76doV8fQ5hUIMLOol6YDK9twprJdwkVYiwVL4bNbxuPlHSkJrVM7STuF9/mniWeNmw/XyFCJqTRzT5Nmk8Kl0N+fHtX/h0utu4+ZPf/84Fuu2MXt8rAvgdyK/xlCXkhvog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6v+VtCKBZkh7vuOA8nhXoUmpWNJUTGvKVsLy8GcQ1g=;
 b=BvtMrm8fkaB63FWBw0gaAtgpOWedaljsXfb2eglO+SqvO1UIuJD0E9hCR5QTAS0DCX/Cx+skqZyJ42N1gwBQvDlZ2/e8h/HmtLA9MlF0qyrY7UN+q0NMAiOTeK9cH8PuYVWMI1hP4TqtPkVZ/nG6whxdNAnkZPTOeYiVMjKQXhI=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB3816.namprd11.prod.outlook.com (2603:10b6:a03:f8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 11:21:37 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf%6]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 11:21:37 +0000
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
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgABafQCAARh7AIAACH/AgAAb+oCAABaWkA==
Date:   Thu, 14 Oct 2021 11:21:37 +0000
Message-ID: <BYAPR11MB3256A20F6BB9218BDB5B7988A9B89@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
In-Reply-To: <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
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
x-ms-office365-filtering-correlation-id: 7537d315-e0a0-413f-2a0d-08d98f04c9c0
x-ms-traffictypediagnostic: BYAPR11MB3816:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB381696875962DD3D05A7EE34A9B89@BYAPR11MB3816.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D1TsdA0NqxShJ+bI/rZXanfMg0ka16jdO+BQd7rxD3gSpUGkuMLlvSEuxH8dqX0y2KTfKkFG2EA3A99u2MvxVLbL1xS6xSYTK1eSNvL5L+wxunxWKnILIHyYDmJHtScUNo2mqKjW+V2JAX4tUW3kTU95lGWh6z0YqvJQANCqOCmuqt5P6f55G2V4FZd4/JPcxb7UR/v5EdaZ7Mr/xdr77dzy8fX8G1yTii8U3PAh8df9yFl/o5XmlJiIGFAf3v052GU4hxUnDQhSAz3oh3l1XJ38A/nExXVNrcPktdEtMRaaChWe3DHV5A7L6fYYWrhiNdyhjWTPxhkCtrCH9oEN2Fq0gLe+CMp9v6zwssbI23IFN5ANyd/jT+f2YL6DBM9FM/BDUzvR++gl3rtdYB+ZA8ojvHPlk6IY6hKJyIE8dqKaGgVfCJSPo3/N+5k6YjAYK+eUUVdcZWC7DAwWSmpbaJA31zunOcQP0vgC91ofGG4EwPNMsQlUi898bW2NL5he0PehyScqyO5ePE+3xDVt+BskCqmt/TMbQMPlkXVAH+6GjcSXjFAiX6FaZuadzMmIZQF4pspKCOT/zigWs8FWYppyU8BWGaQm8ovS+fIx6cwNnT28OIRxdFUXHHIs5phR5Of2iUD9kEEiUCXdSSjWys7MW7/jDzqLRXDEEr+HAL3xO3cTGfbrX7Jnzju56CcvwjgP/+IOegc/owcije2qBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(26005)(186003)(4326008)(66476007)(55016002)(38070700005)(86362001)(71200400001)(7696005)(8676002)(66446008)(6506007)(64756008)(82960400001)(5660300002)(33656002)(52536014)(2906002)(508600001)(66556008)(8936002)(122000001)(83380400001)(66946007)(38100700002)(9686003)(7416002)(316002)(54906003)(110136005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODFMWFBBcU1iZTFSd252aS9jVU9Bc2E4NmNrQlRuQy92a0pXRnZqNlRJbVRE?=
 =?utf-8?B?YTkzRmdJMXVlR3B0NWQzNXdyNTNvNUpKME1pVXZLU09oRHEwSnVKUlcxWG14?=
 =?utf-8?B?eWpaeUJMMlVJRjRMNUk5ZG1WdmVxL0Q5NVR4Ym9NY2k1L1NuT0JHY2JLd2I4?=
 =?utf-8?B?OVJYeU5CNjNIRDVYeTNSRW5xaHo5SnAyNytMRnFqZ1h3ZUxOWVdwUmJoTzRD?=
 =?utf-8?B?YUFvQWo0YkpIWnlMQ0NyeUw5ZXBVOWNOTkFqV2krNjFQcVpqNlRJbTBqeVNm?=
 =?utf-8?B?ZDNhTnNwUkd6VE9XN2lGVnBUY3k4N3hzK2VMN01XaVRnOFFOTlc3c2NpL2tl?=
 =?utf-8?B?Mms2eCtDR2JjMEdyb3BFN01VWVZBVXFtRkVaaXdUa1ozVStXUGlyWEx5WTRv?=
 =?utf-8?B?OEdIN084WFk4bW1URkdRU3RIK0tYUmNHMzZ1dG9PQ21LMUI4OXhUdTdsSXhI?=
 =?utf-8?B?ZURoakVaOHRjUElxWktLUEJ0S2RmN0VUY09YaXdiQmtuV2c4MHlrY0tGUEow?=
 =?utf-8?B?a2RHa3NWQlh4M2N3S0pIYTllRkMwU2x4R2dNVEkwdkhweGdjdTFjMjUzeVlU?=
 =?utf-8?B?Mys1aDFKTzdpMVMrV3l0WWRKSXZuQXAvQ01mRm9PQnRWellzNlN0ZHY0M0xL?=
 =?utf-8?B?cFE3OGYyUlJDblpwajlWaUpQTFpDT2IwNTBySGpYZVV3bytWcitxbG1wa1E3?=
 =?utf-8?B?dG5FZUJ1Y0EzUFN3TzBCQVlJZGtkbWhqRHZpcTlsMGxUckM5Z01IVUVkWkMx?=
 =?utf-8?B?c1lQZUcwNmxMUGdWOEc0QnhvVGVtVDdUU0UxV3dKSlpMbGxKWEZGVHZMb0Fp?=
 =?utf-8?B?eitQcVRwVEdYcVhKR2tVdU5zT3QwWjNicERNWitHRk9qRWZsMitwalR5Q1Jn?=
 =?utf-8?B?aEMzSXBUSVI3SkVlMllFUWh0NFFYanRrdWF1MEN1QzJVZ1BscU10TUNCN255?=
 =?utf-8?B?ZkUxazYyOTcvdzkyZDlyM1NENE5ZTjZqWHlyRCtDZFg3OUtYc1Y5a21NM3JK?=
 =?utf-8?B?VmRaY3N1a0lZU0VTQVVpNnBTTk9vZVZnMGFrMm1Cb1hPNGdlQ1g3ZzFSTUN3?=
 =?utf-8?B?SEpDWFZYN1dLbE9SRk1xM29zNktWL1ZlaWNDR3dTaytUd05WWUcvWERuWTgy?=
 =?utf-8?B?SjhnVGUwdnllZVF2ek1OYVdzSUl5eElTamtUVk1USWx6QVVTcUZnNE91NVBy?=
 =?utf-8?B?YUxiNEZ3amJxVm1aMUNMazdFUysrL1UybkJrMmpTMXhIR204MWJVZG9xaER2?=
 =?utf-8?B?ZEloVmZvalVjQSttSmVja3N1Z2FWa0ZsZys2Wk91MEk2Y0VaZ1dnNlBmMXBN?=
 =?utf-8?B?WVUrcDZFMVV6VFlZSm5DVTdTYktRUzhyY1NMNmNEaTF3bmV0NU9vSU5PK0Ur?=
 =?utf-8?B?MXYyMHJSOERUcmtDVDdYdDE5Z3NwOXJINGorWHhRejJNejgrYjY4MGorblJT?=
 =?utf-8?B?cVRvbW1zYUlUc1dZMWtySDRFYXlRS3dLWk5ob3phSUJwb1liNGR0bkhZU0Ri?=
 =?utf-8?B?ekl2c0lRb29GSnNkTWViMjVPczcvNms5N1k1eDA1bEwxZnJ2eEE2RmVvdU9l?=
 =?utf-8?B?OVlRSHBXUElwTndkTXNURFR0MW8vMVFVaFBQbDYwVTEvNXdzQWVqYnpvdUtv?=
 =?utf-8?B?ZytJTlZyWFpUWTFNb05KdlNZbDN6ZkhtdmFjS1V6eVVmZDRJNjZEa1N6Y2lv?=
 =?utf-8?B?ODlBS3NtMjNGZzJYS3R0aGdZaFg2YWtyL28vUWlTaDVMOHVUeHR2UEY2T1Bi?=
 =?utf-8?Q?MD2YxlEYm6Zci9f62RBwmh9whqjJreKhHaltE27?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7537d315-e0a0-413f-2a0d-08d98f04c9c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 11:21:37.5891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SZ6XQAI402+HbeQPKTUWnh7w0Ch1RBOAVEuMAGBzUrcaxsKSM/8S7zsi5mQ5XzVVc4RekTDuEG8HEz3aPZGBzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3816
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTAvMTQvMjAyMSA1OjAxIFBNLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KDQo+IE9uIDE0LzEw
LzIxIDEwOjAyLCBMaXUsIEppbmcyIHdyb3RlOg0KPiA+PiBJbiBwcmluY2lwbGUgSSBkb24ndCBs
aWtlIGl0IHZlcnkgbXVjaDsgaXQgd291bGQgYmUgbmljZXIgdG8gc2F5ICJ5b3UNCj4gPj4gZW5h
YmxlIGl0IGZvciBRRU1VIGl0c2VsZiB2aWEgYXJjaF9wcmN0bChBUkNIX1NFVF9TVEFURV9FTkFC
TEUpLCBhbmQNCj4gPj4gZm9yIHRoZSBndWVzdHMgdmlhIGlvY3RsKEtWTV9TRVRfQ1BVSUQyKSIu
ICBCdXQgSSBjYW4gc2VlIHdoeSB5b3UNCj4gPj4gd2FudCB0byBrZWVwIHRoaW5ncyBzaW1wbGUs
IHNvIGl0J3Mgbm90IGEgc3Ryb25nIG9iamVjdGlvbiBhdCBhbGwuDQo+ID4NCj4gPiBEb2VzIHRo
aXMgbWVhbiB0aGF0IEtWTSBhbGxvY2F0ZSAzIGJ1ZmZlcnMgdmlhDQo+ID4gMSkgUWVtdSdzIHJl
cXVlc3QsIGluc3RlYWQgb2YgdmlhIDIpIGd1ZXN0IFhDUjAgdHJhcD8NCj4gDQo+IEJhc2VkIG9u
IHRoZSBpbnB1dCBmcm9tIEFuZHkgYW5kIFRob21hcywgdGhlIG5ldyB3YXkgd291bGQgYmUgbGlr
ZSB0aGlzOg0KPiANCj4gMSkgaG9zdF9mcHUgbXVzdCBhbHdheXMgYmUgY2hlY2tlZCBmb3IgcmVh
bGxvY2F0aW9uIGluIGt2bV9sb2FkX2d1ZXN0X2ZwdQ0KPiAob3IgaW4gdGhlIEZQVSBmdW5jdGlv
bnMgdGhhdCBpdCBjYWxscywgdGhhdCBkZXBlbmRzIG9uIHRoZSByZXN0IG9mIFRob21hcydzDQo+
IHBhdGNoZXMpLiAgVGhhdCdzIGJlY2F1c2UgYXJjaF9wcmN0bCBjYW4gZW5hYmxlIEFNWCBmb3Ig
UUVNVSBhdCBhbnkgcG9pbnQNCj4gYWZ0ZXIgS1ZNX0NSRUFURV9WQ1BVLg0KDQpGb3IgUWVtdSdz
IFhGRCwgSSdkIGxpa2UgdG8gY29uZmlybSB0aGF0Og0KU2luY2UgdGhlIGFyY2hfcHJjdGwoKSBv
bmx5cyBhZGQgY3VycmVudC0+Z3JvdXBfbGVhZGVyLT50aHJlYWQuZnB1J3MgIHN0YXRlX3Blcm0s
DQpfX3N0YXRlX3NpemUsIChjdXJyZW50LT50aHJlYWQuZnB1LiogaXMgbm90IGNoYW5nZWQpLCB0
aHVzIGluDQprdm1fbG9hZF9ndWVzdF9mcHUsIGhvc3RfZnB1LT54ZmQgaXMgYWx3YXlzIDEuIFRo
YXQgaXMgdG8gc2F5LCBRZW11J3MgYXJjaF9wcmN0bCgpDQpkb2Vzbid0IGNoYW5nZSBhbnkgY29w
aWVzIG9mIFhGRC4NCg0KPiANCj4gMikgZXZlcnkgdXNlIG9mIHZjcHUtPmFyY2guZ3Vlc3Rfc3Vw
cG9ydGVkX3hjcjAgaXMgY2hhbmdlZCB0byBvbmx5IGluY2x1ZGUNCj4gdGhvc2UgZHluYW1pYy1m
ZWF0dXJlIGJpdHMgdGhhdCB3ZXJlIGVuYWJsZWQgdmlhIGFyY2hfcHJjdGwuDQo+IFRoYXQgaXMs
IHNvbWV0aGluZyBsaWtlOg0KPiANCj4gc3RhdGljIHU2NCBrdm1fZ3Vlc3Rfc3VwcG9ydGVkX2Ny
MChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHsNCj4gCXJldHVybiB2Y3B1LT5hcmNoLmd1ZXN0X3N1
cHBvcnRlZF94Y3IwICYNCj4gCQkofnhmZWF0dXJlc19tYXNrX3VzZXJfZHluYW1pYyB8IFwNCj4g
CQkgY3VycmVudC0+dGhyZWFkLmZwdS5keW5hbWljX3N0YXRlX3Blcm0pOw0KPiB9DQo+IA0KPiAz
KSBFdmVuIHdpdGggcGFzc3Rocm91Z2ggZGlzYWJsZWQsIHRoZSBndWVzdCBjYW4gcnVuIHdpdGgg
WEZEIHNldCB0bw0KPiB2Y3B1LT5hcmNoLmd1ZXN0X3hmZCAoYW5kIGxpa2V3aXNlIGZvciBYRkRf
RVJSKSB3aGljaCBpcyBtdWNoIHNpbXBsZXINCj4gdGhhbiB0cmFwcGluZyAjTk0uICBUaGUgdHJh
cHMgZm9yIHdyaXRpbmcgWENSMCBhbmQgWEZEIGFyZSB1c2VkIHRvIGFsbG9jYXRlDQo+IGR5bmFt
aWMgc3RhdGUgZm9yIGd1ZXN0X2ZwdSwgYW5kIHN0YXJ0IHRoZSBwYXNzdGhyb3VnaCBvZiBYRkQg
YW5kIFhGRF9FUlIuDQo+IFdoYXQgd2UgbmVlZCBpczoNCj4gDQo+IC0gaWYgYSBkeW5hbWljIHN0
YXRlIGhhcyBYQ1IwW25dPTAsIGJpdCBuIHdpbGwgbmV2ZXIgYmUgc2V0IGluIFhGRF9FUlIgYW5k
IHRoZQ0KPiBzdGF0ZSB3aWxsIG5ldmVyIGJlIGRpcnRpZWQgYnkgdGhlIGd1ZXN0Lg0KPiANCj4g
LSBpZiBhIGR5bmFtaWMgc3RhdGUgaGFzIFhDUjBbbl09MSwgYnV0IGFsbCBlbmFibGVkIGR5bmFt
aWMgc3RhdGVzIGhhdmUNCj4gWEZEW25dPTEsIHRoZSBndWVzdCBpcyBub3QgYWJsZSB0byBkaXJ0
eSBhbnkgZHluYW1pYyBYU0FWRSBzdGF0ZSwgYmVjYXVzZQ0KPiB0aGV5IGFsbCBoYXZlIGVpdGhl
ciBYQ1IwW25dPTAgb3IgWEZEW25dPTEuICBBbiBhdHRlbXB0IHRvIGRvIHNvIHdpbGwgY2F1c2Ug
YW4NCj4gI05NIHRyYXAgYW5kIHNldCB0aGUgYml0IGluIFhGRF9FUlIuDQo+IA0KPiAtIGlmIGEg
ZHluYW1pYyBzdGF0ZSBoYXMgWENSMFtuXT0xIGFuZCBYRkRbbl09MCwgdGhlIHN0YXRlIGZvciBi
aXQgbiBpcw0KPiBhbGxvY2F0ZWQgaW4gZ3Vlc3RfZnB1LCBhbmQgaXQgY2FuIGFsc28gZGlzYWJs
ZSB0aGUgdm1leGl0cyBmb3IgWEZEIGFuZA0KPiBYRkRfRVJSLg0KPiANCg0KR290IGl0LCB0aGUg
cHJpbmNpcGxlIGlzIG9uY2UgWENSMFtuXT0xIGFuZCBYRkRbbl09MCwgdGhlbiBndWVzdCBpcyBh
bGxvd2VkDQp0byB1c2UgdGhlIGR5bmFtaWMgWFNBVkUgc3RhdGUsIHRodXMgS1ZNIG11c3QgcHJl
cGFyZSBhbGwgdGhpbmdzIHdlbGwNCmJlZm9yZS4gVGhpcyBwcm9iYWJseSBoYXBwZW5zIHNob3J0
bHkgYWZ0ZXIgZ3Vlc3QgI05NLg0KDQpPbmx5IG9uZSB0aGluZzogaXQgc2VlbXMgd2UgYXNzdW1l
IHRoYXQgdmNwdS0+YXJjaC54ZmQgaXMgZ3Vlc3QgcnVudGltZQ0KdmFsdWUuIEFuZCBiZWZvcmUg
Z3Vlc3QgaW5pdGlhbGl6ZXMgWEZELCBLVk0gcHJvdmlkZXMNCnZjcHUtPmFyY2gueGZkWzE4XT0x
LCByaWdodD8gQnV0IHRoZSBzcGVjIGFza3MgWEZEIHJlc2V0IHZhbHVlIGFzIHplcm8uDQpJZiBz
bywgYmV0d2VlbiBndWVzdCBpbml0IFhDUjAgdG8gMSBhbmQgaW5pdCBYRkQgdG8gMSwgaXQncyBY
Q1IwW25dPTEgYW5kDQpYRkRbbl09MC4gSWYgYSBndWVzdCBuZXZlciBpbml0IFhGRCBhbmQgZGly
ZWN0bHkgdXNlIGR5bmFtaWMgc3RhdGUuLi4NCg0KT3IgZG8gd2Ugd2FudCB0byBwcm92aWRlIGd1
ZXN0IGEgWEZEWzE4XT0xIHZhbHVlIGF0IHRoZSB2ZXJ5IGJlZ2lubmluZz8NCg0KPiBUaGVyZWZv
cmU6DQo+IA0KPiAtIGlmIHBhc3N0aHJvdWdoIGlzIGRpc2FibGVkLCB0aGUgWENSMCBhbmQgWEZE
IHdyaXRlIHRyYXBzIGNhbiBjaGVjaw0KPiBndWVzdF94Y3IwICYgfmd1ZXN0X3hmZC4gIElmIGl0
IGluY2x1ZGVzIGEgZHluYW1pYyBzdGF0ZSBiaXQsIGR5bmFtaWMgc3RhdGUgaXMNCj4gYWxsb2Nh
dGVkIGZvciBhbGwgYml0cyBlbmFibGVkIGluIGd1ZXN0X3hjcjAgYW5kIHBhc3N0aHJvdWdoIGlz
IHN0YXJ0ZWQ7IHRoaXMNCj4gc2hvdWxkIGhhcHBlbiBzaG9ydGx5IGFmdGVyIHRoZSBndWVzdCBn
ZXRzIGl0cyBmaXJzdCAjTk0gdHJhcCBmb3IgQU1YLg0KPiANCj4gLSBpZiBwYXNzdGhyb3VnaCBp
cyBlbmFibGVkLCB0aGUgWENSMCB3cml0ZSB0cmFwIG11c3Qgc3RpbGwgZW5zdXJlIHRoYXQNCj4g
ZHluYW1pYyBzdGF0ZSBpcyBhbGxvY2F0ZWQgZm9yIGFsbCBiaXRzIGVuYWJsZWQgaW4gZ3Vlc3Rf
eGNyMC4NCj4gDQo+IFNvIHNvbWV0aGluZyBsaWtlIHRoaXMgcHNldWRvY29kZSBpcyBjYWxsZWQg
YnkgYm90aCBYQ1IwIGFuZCBYRkQgd3JpdGVzOg0KPiANCj4gaW50IGt2bV9hbGxvY19mcHVfZHlu
YW1pY19mZWF0dXJlcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHsNCj4gCXU2NCBhbGxvd2VkX2R5
bmFtaWMgPSBjdXJyZW50LT50aHJlYWQuZnB1LmR5bmFtaWNfc3RhdGVfcGVybTsNCj4gCXU2NCBl
bmFibGVkX2R5bmFtaWMgPQ0KPiAJCXZjcHUtPmFyY2gueGNyMCAmIHhmZWF0dXJlc19tYXNrX3Vz
ZXJfZHluYW1pYzsNCj4gDQo+IAkvKiBBbGwgZHluYW1pYyBmZWF0dXJlcyBoYXZlIHRvIGJlIGFy
Y2hfcHJjdGwnZCBmaXJzdC4gICovDQo+IAlXQVJOX09OX09OQ0UoZW5hYmxlZF9keW5hbWljICYg
fmFsbG93ZWRfZHluYW1pYyk7DQo+IA0KPiAJaWYgKCF2Y3B1LT5hcmNoLnhmZF9wYXNzdGhyb3Vn
aCkgew0KPiAJCS8qIEFsbCBkeW5hbWljIHN0YXRlcyB3aWxsICNOTT8gIFdhaXQgYW5kIHNlZS4g
ICovDQo+IAkJaWYgKChlbmFibGVkX2R5bmFtaWMgJiB+dmNwdS0+YXJjaC54ZmQpID09IDApDQpI
ZXJlLCB3aGVuIGd1ZXN0IGluaXQgWENSMCB0byAxLCB2Y3B1LT5hcmNoLnhmZCBzaG91bGQgYmUg
MQ0Kb3RoZXJ3aXNlIFhDUjAgdHJhcCBtYWtlcyBwYXNzdGhyb3VnaCBhbmQgYWxsb2NhdGVzIGJ1
ZmZlciwgd2hpY2gNCmlzIG5vdCB3aGF0IHdlIHdhbnQuDQoNCj4gCQkJcmV0dXJuIDA7DQo+IA0K
PiAJCWt2bV94ODZfb3BzLmVuYWJsZV94ZmRfcGFzc3Rocm91Z2godmNwdSk7DQo+IAl9DQo+IA0K
PiAJLyogY3VycmVudC0+dGhyZWFkLmZwdSB3YXMgYWxyZWFkeSBoYW5kbGVkIGJ5IGFyY2hfcHJj
dGwuICAqLw0KSXQgc2VlbXMgc28gZmFyLCBhcmNoX3ByY3RsIGRvZXMgbm90IGNoYW5nZSBjdXJy
ZW50LT50aHJlYWQuZnB1LA0Kb25seSAjTk0gaGFuZGxlciBpdHNlbGYgZG9lcyBpdC4gV2UgaGVy
ZSBhbGxvYyBjdXJyZW50IHRvby4NCg0KVGhhbmtzLA0KSmluZw0KPiAJcmV0dXJuIGZwdV9hbGxv
Y19mZWF0dXJlcyh2Y3B1LT5ndWVzdF9mcHUsDQo+IAkJdmNwdS0+Z3Vlc3RfZnB1LmR5bmFtaWNf
c3RhdGVfcGVybSB8IGVuYWJsZWRfZHluYW1pYyk7IH0NCj4gDQo+IFBhb2xvDQoNCg==
