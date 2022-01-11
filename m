Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363D948A577
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 03:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344038AbiAKCPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 21:15:22 -0500
Received: from mga06.intel.com ([134.134.136.31]:29975 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244058AbiAKCPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 21:15:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641867322; x=1673403322;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kdUnp91xRE98eZYxpWvmxzrG7GxKLNdQ74xZ0Hb19mY=;
  b=GMigbradbal5LjgaF+KWE3ZJBYoWLldh+CVpx+h5WizEqzQ/RvIYZS0M
   Hoej3kVKjqosf817eO9/uI6iO7fHnXFcVmfH4YOMWh9NK4nU7O5emKeAf
   ng4lz9WvZdPBpun3C+tMAMkauYZgVSDOQ87mSxGMn+HitjqklcoBA5W1m
   NKfPrPl9QWbBbpRkj/HNl/DzymtuqnYvz8uxfa5Dq8YueYqgJPD3Xv9cV
   FmqG/lkLOHfLQ1kBT0ihFsaqVhcdDXAG6V8vWrMBsSlgvzbwi8kJ8GnAm
   zcrzR9k4pFdGnXItgAHpDbPqv5ZZeYVkTDOMYypxLi7bpCSJnQ4zYcHnc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="304120767"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="304120767"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 18:15:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="490212130"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 10 Jan 2022 18:15:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 18:15:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 18:15:20 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 18:15:20 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 18:15:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aauMf+2X3eUn+EYkiG9k7Qnz5dfrWwDR1mwN3Ho4e/P1/t49ZgUKRcT5VsrAGohR4NrlStowMYQa8+hMPJsZ4JGDy1hN++mJvWIxm5ZQXwWGo6Eat3Ng1ZQZIDsD+Z2SC5U2qJSd2FUrCjiHFWUv31frvcQrt6NppKlZZzm0olJtDZuC7aKzhCGTveEBOsPgLC7tjSG2tV6m6VuFr4dpVlaMtdQ1b5VD7avevO3W1wTuSoy2P0Beq/L+2+Jl+Uzv69YX/+uXjXkhEXNe2Z8ACLJcYrNWJW+oNIqjzY/DsDCNAUxPbP/Z9QtZazR/1G0HMgw1X8c6AyJUPNZVkKmveQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdUnp91xRE98eZYxpWvmxzrG7GxKLNdQ74xZ0Hb19mY=;
 b=jIdown081qXxpKL9+7sQDPpxIkK3GyeiWQNZewEedzGwPt5p/5D5wYNzYwBBMBlkXNfrSMfjusFZTNax2LvtXkZ6U82D9c81fpkRUhU8L/4qUTwtEnPPYfXU5qmphAkeIJ5E5uSG9TdhTjn4fzlkaTH7Qg2YXUWyVIbXWyVtTfXd/7jE9iaq6i6Q4a8k1SbOE27StrKtYOJKc/0AUhBn1YqeMvviaumR6PmmwJ1WHaBRC5VYUJAE7BPmYbxjMz6z42buwVA5r9zLt+luikij8+okdvjG5ui9UmZLXBrn/YzaGPua363E/pNdrOKivJ+jov9VxwjYw+cMKEML/vkVPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2643.namprd11.prod.outlook.com (2603:10b6:406:b2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 02:15:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 02:15:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/6] KVM: x86: Remove WARN_ON in
 kvm_arch_check_processor_compat
Thread-Topic: [PATCH 5/6] KVM: x86: Remove WARN_ON in
 kvm_arch_check_processor_compat
Thread-Index: AQHX+vpCpIo7aqtk3U2/ek1vXCAFk6xc9ZgAgAAxSRA=
Date:   Tue, 11 Jan 2022 02:15:11 +0000
Message-ID: <BN9PR11MB5276DEA925C72AF585E7472C8C519@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-6-chao.gao@intel.com> <Ydy6aIyI3jFQvF0O@google.com>
In-Reply-To: <Ydy6aIyI3jFQvF0O@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff81b9b6-8df4-4c1b-d6dc-08d9d4a832c2
x-ms-traffictypediagnostic: BN7PR11MB2643:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN7PR11MB264360DC3E1304BF39ECEDC18C519@BN7PR11MB2643.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aPOhfgqPQPDINE/pZHl5ydG73e3JrjVnLNWM8WIY7GzsxHUW3S2SLEoYLgthWOl/O4UQzmue59f8jKWp82gAXm2sqdBNrs/QsnD+41+p/Ut/NTTakoFhUoK1UtI+lkPXMMQCAy11Pkz1sDdoM6o1D2zC3kH76KglaO+gqKn1SSNim2JFh774n0mdoti34+yylkIIyaZP9l0vka57kph1t3QbhvuePQLya1PFAdcs/LGuAQ6ZLmBenGnvLHlSbEu1Y2l1XZ5hV8BWW/gK548e8RU4b3XdsgRLYS+lIs79n+8d8RP9HBvwrPbArNCDQaLlqDkqmBWljYdC0ZV3cjgpSkrwwaufqyAQRNCzXYZwWIlTIRyIw7TUO8nequ7Z/kA9Lbgl7PyA9U43LwT9QY1OvQU2VkocC4GS2SI4KytW+gk1cxXl/S70gR2c5m1o0aVHaFULZe+/x0g0rY+9Gle1CEDOSFS6aP2hcY/LSXzlvx2edEh2F6bHxETpL0PdJ33jUwq5JvdM9IqeDC9dKU6uKIjk5xiJA14TkGpgYK7BwzBdbyAW3SveRJliXpIyx3aMh6jy85Ay+53ZFD4Ptus/qeSiYYHqvzoUQSADRPlh4o/rYMDcDLzdWwp3DK+xksCCsfWR+EOZoXGD485rK65RWJ1cF5PwNzQnncNSPKKqBAgMG160+wmtlhTekZW+xHTccja9SdyECyxs0TlJxYaKRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6636002)(26005)(33656002)(38070700005)(122000001)(54906003)(7416002)(6506007)(508600001)(83380400001)(7696005)(38100700002)(4326008)(55016003)(186003)(71200400001)(86362001)(52536014)(9686003)(110136005)(8676002)(2906002)(66946007)(66556008)(64756008)(66446008)(66476007)(82960400001)(8936002)(5660300002)(316002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTJnRkUzcXFKSXlTZTExMEV3TUppRm5vQ1FOWmRLVE12d2ovaU9BS3VlbWRq?=
 =?utf-8?B?ams4eGloT3hmL3c3STM1M25hYktiUWhOaWVaRFRDd2hwdzRaenZ5aUQvdlVJ?=
 =?utf-8?B?MzZWbFQ5d0FyRDQ3ZVJma0xYMkU4ZDIreWlnMmJnMmhDcmMzb09sR0hhMHFZ?=
 =?utf-8?B?bjFwUUhGRFB1cEFDenl6eGZOVzEveWJyRzdFVVQ4WWcxUk1DUVgzU1lxanVh?=
 =?utf-8?B?aFlLeUpPMFZSc2g2QUs2QjVpcWFWVldyalFGNzREQlBUdDkrdzhNSDQvTEYw?=
 =?utf-8?B?TmtEeURZZ0V3YVdFK1Y2Mnk5akRaSmx6MVdYOW56UjBNZ1VZYjc4NG1RQUph?=
 =?utf-8?B?S01vVjh3aWJqWHRIbnNBa0JLNlZqNTBtMEdvRDhxU1lLZThId3YwY2VLUlYz?=
 =?utf-8?B?OW5NNTRzZ1I3NUF1NXozVTVhUEo4Nm05R2c2bGRaQXlQVmV1bzR5cmpXc3Z2?=
 =?utf-8?B?TEx1RGpQM1RmaUxQelJLaCtYVm9iY0hNUWN0Witobm5yWlhLc2xpcnJGNXJu?=
 =?utf-8?B?NmcyTEpPRWs4TG51OTBtRlRpTjVwcWgvdW1icERmbjVyNUl3cjVIZUs4aEpl?=
 =?utf-8?B?b29XZThERmpIVEFkM0IvN0tRc1RFZHlnRmtCcnBpdjFwMW9BN09WakVEZmlQ?=
 =?utf-8?B?aktVU2dkNTlFRFZGdjVqZmk5eXJFOGN0ODBlby9NYXJ0eWZpcnp6eTZJRmVH?=
 =?utf-8?B?N2ZTNENCTlg3eEJ1dTNFRkhmQ2hkdkcwcDlIWit3cWtkY3NYSDR1b3FzL3lM?=
 =?utf-8?B?eHFKTDJkVCtGRXNPZVl3Y1p2UmdOM2prRExzYVJsaUhPbVhwdGFRbWtvSXU1?=
 =?utf-8?B?VHlwT3k4Q1NmdVhUdVlYNi9QcVFCK0xBNXp3L3BWM293di82VmI3WGhMTlh3?=
 =?utf-8?B?UXBHWGRpYWljbXR5RXoyZFZUMDhzWXEvWUN0cnpsSXIveDVSWVZ3RXk1TE9s?=
 =?utf-8?B?cGhFc2xxd3JQZnR6aStueWdjQU9zOXFHWXNDeC85N0FqZGFkZ211UUxldWcr?=
 =?utf-8?B?ZnN3RlRlU1JGL0lhVlRFY3hUdHpuMGlCLzhkSWhsNllXVytWZzM2eVROOWJH?=
 =?utf-8?B?VFkybXI2Q0M4YmVTb2V2TDcyMTdTMCsxL01VLytqQzdXbnEzYVBxVzFVQmZD?=
 =?utf-8?B?dkJHSE5FWUcyUlV3V2djaVUzYi9wa2xScHRBVndNQUNYaGFMdmM3Vk1vU05L?=
 =?utf-8?B?QVlJdW9nMHBwK09EK211b1F5eGJXMDN1dDZtRmduRGVTcmZPMi9WcEFEM1Qv?=
 =?utf-8?B?ejgxUGs3UFZ0UnBxVi9EUkl3TE9EME80L2wwVCtlK2hsQnlCdEhpR3ZUTjJo?=
 =?utf-8?B?dG5HVHh5TXl0QU16QjAzYSt0RDE4VERhZWI5L0d6MWZDeEZHWFY0Z3JWSjUz?=
 =?utf-8?B?WHNoV3JNNEZnS2dEYkxVdElVOWRtaExGa2VvMlVxN0RKQWRkeG0wWlRFT2E3?=
 =?utf-8?B?aklHY0NtYkxXZVl6RVBlNDFGUEZIYmJvL2lqSy9TYXlrMGtlMG9rNjZmVTZj?=
 =?utf-8?B?ZGdvUTdOaStOZXBYSE1VZURxZ2hSOVEyTHg1ZmtUOWFydDZEV2dLUGtXa1I0?=
 =?utf-8?B?SlhmUTZtOEkvNXg0OFNjTk8wNEc1b0hOdlBuc1FwZnpLT2JpdXpUSWNpcEJj?=
 =?utf-8?B?Rm9nL1dUQXRSdDFwVXV5TlUvTWltWXdGQSs5ZXlUcUlQRTBlUnB6UlFhRit5?=
 =?utf-8?B?N1ZUc0hNMzAxaEVFaDIwb3JNRkMrSkFOVVg2WUZsdE9nbmxXUjE2UkJ6VGtI?=
 =?utf-8?B?WmZEWUJWSGY3Z0xCMmFyL3o4RmhxZHJYNzE5ODA0Wk9vVDdFYlZ4NEpFelN3?=
 =?utf-8?B?NnUxMkJPZWFNb0NiY3ZRQjhzRU1pT1llVy9kWjJLMUJQa2p3bkhrb095aXJ5?=
 =?utf-8?B?YkcyTUkzdzhTSVBjZGVVYzZJUGJKS3psQ0RUcWp3SVIvMHhmbHhBYS9oY0JE?=
 =?utf-8?B?TnV4N0lOTjh5cFo4MGxXU1llV1BYQmlyQzRkV2x6aEhVNldPZHJKS28rSzZx?=
 =?utf-8?B?dmtoNmFGYWQ4WmE1eFNETE5QK3BqUGtraS9uUjZzcjZiYmI5b3Jid2E5ckxW?=
 =?utf-8?B?NEo5eWpJcDNJTmVpZlZaZW1FTmhvUGNLaHhOYTJ4Tlh1aEpXNmVIRHJtdkYz?=
 =?utf-8?B?TjdhMlljZ3BaTmdEeFF5QUNDTlRHdXQrS0RVSDJhd0FFYzFGS0o0dlZqem14?=
 =?utf-8?Q?tt7LShAkbpT22iGy4Q/Hthw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff81b9b6-8df4-4c1b-d6dc-08d9d4a832c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 02:15:11.9704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kvAe/sviEPszmA/0fdv6QuNnQ1WAGhb1nuQt46fmj46au2Q2evlqCAuVW3Yy+1cpIE8MtGq4x645x4daAZW5vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2643
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
VHVlc2RheSwgSmFudWFyeSAxMSwgMjAyMiA3OjAwIEFNDQo+IA0KPiBPbiBNb24sIERlYyAyNywg
MjAyMSwgQ2hhbyBHYW8gd3JvdGU6DQo+ID4ga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBh
dCgpIG5lZWRuJ3QgYmUgY2FsbGVkIHdpdGggaW50ZXJydXB0DQo+ID4gZGlzYWJsZWQsIGFzIGl0
IG9ubHkgcmVhZHMgc29tZSBDUnMvTVNScyB3aGljaCB3b24ndCBiZSBjbG9iYmVyZWQNCj4gPiBi
eSBpbnRlcnJ1cHQgaGFuZGxlcnMgb3Igc29mdGlycS4NCj4gPg0KPiA+IFdoYXQgcmVhbGx5IG5l
ZWRlZCBpcyBkaXNhYmxpbmcgcHJlZW1wdGlvbi4gTm8gYWRkaXRpb25hbCBjaGVjayBpcw0KPiA+
IGFkZGVkIGJlY2F1c2UgaWYgQ09ORklHX0RFQlVHX1BSRUVNUFQgaXMgZW5hYmxlZCwgc21wX3By
b2Nlc3Nvcl9pZCgpDQo+ID4gKHJpZ2h0IGFib3ZlIHRoZSBXQVJOX09OKCkpIGNhbiBoZWxwIHRv
IGRldGVjdCBhbnkgdmlvbGF0aW9uLg0KPiANCj4gSHJtLCBJSVJDLCB0aGUgYXNzZXJ0aW9uIHRo
YXQgSVJRcyBhcmUgZGlzYWJsZWQgd2FzIG1vcmUgYWJvdXQgZGV0ZWN0aW5nDQo+IGltcHJvcGVy
DQo+IHVzYWdlIHdpdGggcmVzcGVjdCB0byBLVk0gZG9pbmcgaGFyZHdhcmUgZW5hYmxpbmcgdGhh
biBpdCB3YXMgYWJvdXQNCj4gZW5zdXJpbmcgdGhlDQo+IGN1cnJlbnQgdGFzayBpc24ndCBtaWdy
YXRlZC4gIEUuZy4gYXMgZXhoaWJpdGVkIGJ5IHBhdGNoIDA2LCBleHRyYSBwcm90ZWN0aW9ucw0K
PiAoZGlzYWJsaW5nIG9mIGhvdHBsdWcgaW4gdGhhdCBjYXNlKSBhcmUgbmVlZGVkIGlmIHRoaXMg
aGVscGVyIGlzIGNhbGxlZCBvdXRzaWRlDQo+IG9mIHRoZSBjb3JlIEtWTSBoYXJkd2FyZSBlbmFi
bGluZyBmbG93IHNpbmNlIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSBkb2VzDQo+IGl0cyB0aGluZw0K
PiB2aWEgU01QIGZ1bmN0aW9uIGNhbGwuDQoNCkxvb2tzIHRoZSBXQVJOX09OKCkgd2FzIGFkZGVk
IGJ5IHlvdS4g8J+Yig0KDQpjb21taXQgZjFjZGVjZjU4MDdiMWE5MTgyOWEyZGM0ZjI1NGJmZTZi
YWZkNDc3Ng0KQXV0aG9yOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hyaXN0b3BoZXJz
b25AaW50ZWwuY29tPg0KRGF0ZTogICBUdWUgRGVjIDEwIDE0OjQ0OjE0IDIwMTkgLTA4MDANCg0K
ICAgIEtWTTogeDg2OiBFbnN1cmUgYWxsIGxvZ2ljYWwgQ1BVcyBoYXZlIGNvbnNpc3RlbnQgcmVz
ZXJ2ZWQgY3I0IGJpdHMNCg0KICAgIENoZWNrIHRoZSBjdXJyZW50IENQVSdzIHJlc2VydmVkIGNy
NCBiaXRzIGFnYWluc3QgdGhlIG1hc2sgY2FsY3VsYXRlZA0KICAgIGZvciB0aGUgYm9vdCBDUFUg
dG8gZW5zdXJlIGNvbnNpc3RlbnQgYmVoYXZpb3IgYWNyb3NzIGFsbCBDUFVzLg0KDQogICAgU2ln
bmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGlu
dGVsLmNvbT4NCiAgICBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRo
YXQuY29tPg0KDQpCdXQgaXQncyB1bmNsZWFyIHRvIG1lIGhvdyB0aGlzIFdBUk5fT04oKSBpcyBy
ZWxhdGVkIHRvIHdoYXQgdGhlIGNvbW1pdA0KbXNnIHRyaWVzIHRvIGV4cGxhaW4uIFdoZW4gSSBy
ZWFkIHRoaXMgY29kZSBpdCdzIG1vcmUgbGlrZSBhIHNhbml0eSBjaGVjayBvbg0KdGhlIGFzc3Vt
cHRpb24gdGhhdCBpdCBpcyBjdXJyZW50bHkgY2FsbGVkIGluIFNNUCBmdW5jdGlvbiBjYWxsIHdo
aWNoIHJ1bnMgDQp0aGUgc2FpZCBmdW5jdGlvbiB3aXRoIGludGVycnVwdCBkaXNhYmxlZC4NCg0K
PiANCj4gSXMgdGhlcmUgQ1BVIG9ubGluaW5nIHN0YXRlL21ldGFkYXRhIHRoYXQgd2UgY291bGQg
dXNlIHRvIGhhbmRsZSB0aGF0DQo+IHNwZWNpZmljIGNhc2U/DQo+IEl0J2QgYmUgbmljZSB0byBw
cmVzZXJ2ZSB0aGUgcGFyYW5vaWQgY2hlY2ssIGJ1dCBpdCdzIG5vdCBhIGJpZyBkZWFsIGlmIHdl
IGNhbid0Lg0KPiANCj4gSWYgd2UgY2FuJ3QgcHJlc2VydmUgdGhlIFdBUk4sIGNhbiB5b3UgcmV3
b3JrIHRoZSBjaGFuZ2Vsb2cgdG8gZXhwbGFpbiB0aGUNCj4gbW90aXZhdGlvbg0KPiBmb3IgcmVt
b3ZpbmcgdGhlIFdBUk4/DQo+IA0KPiBUaGFua3MhDQo+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IENo
YW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2t2bS94
ODYuYyB8IDIgLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+
ID4gaW5kZXggYWEwOWM4NzkyMTM0Li5hODBlM2IwYzExYTggMTAwNjQ0DQo+ID4gLS0tIGEvYXJj
aC94ODYva3ZtL3g4Ni5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gQEAgLTEx
Mzg0LDggKzExMzg0LDYgQEAgaW50IGt2bV9hcmNoX2NoZWNrX3Byb2Nlc3Nvcl9jb21wYXQodm9p
ZCkNCj4gPiAgew0KPiA+ICAJc3RydWN0IGNwdWluZm9feDg2ICpjID0gJmNwdV9kYXRhKHNtcF9w
cm9jZXNzb3JfaWQoKSk7DQo+ID4NCj4gPiAtCVdBUk5fT04oIWlycXNfZGlzYWJsZWQoKSk7DQo+
ID4gLQ0KPiA+ICAJaWYgKF9fY3I0X3Jlc2VydmVkX2JpdHMoY3B1X2hhcywgYykgIT0NCj4gPiAg
CSAgICBfX2NyNF9yZXNlcnZlZF9iaXRzKGNwdV9oYXMsICZib290X2NwdV9kYXRhKSkNCj4gPiAg
CQlyZXR1cm4gLUVJTzsNCj4gPiAtLQ0KPiA+IDIuMjUuMQ0KPiA+DQo=
