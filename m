Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A2231D1AF
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 21:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBPUnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 15:43:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:59650 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhBPUnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 15:43:16 -0500
IronPort-SDR: pUwqDX4NKpsvnukQWTr1omr9GEr9WCA5c8cjMu/ZmBc+pQ4bRuMABUOKz6MsI58hm5jAqrNn6n
 +zlt4jewX7qQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="202210025"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="202210025"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 12:42:35 -0800
IronPort-SDR: BTyRH5s5DawYWw83+42XssVfBwuJiCsvK0VDwAjUffP72fMFSNkH5qJxgPXKBRMNHCFZO5o1Oy
 kX1Cv1e5Hfcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="399666836"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 16 Feb 2021 12:42:35 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 12:42:34 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 12:42:34 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 12:42:34 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [RFC PATCH v5 03/26] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Thread-Topic: [RFC PATCH v5 03/26] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Thread-Index: AQHXAgqCiMCWrYnrK0Whc7d+icsirqpbjZWA//+2gGA=
Date:   Tue, 16 Feb 2021 20:42:34 +0000
Message-ID: <679324c4b4644ed4a6419718252d318c@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <f6f9867642505d90968a260538c90444b3fe3809.1613221549.git.kai.huang@intel.com>
 <57878292-69d0-2234-d732-131318795726@intel.com>
In-Reply-To: <57878292-69d0-2234-d732-131318795726@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ICsvKg0KPiA+ICsgKiBQbGFjZSB0aGUgcGFnZSBpbiB1bmluaXRpYWxpemVkIHN0YXRlLiAg
T25seSB1c2FibGUgYnkgY2FsbGVycw0KPiA+ICt0aGF0DQo+ID4gKyAqIGtub3cgdGhlIHBhZ2Ug
aXMgaW4gYSBjbGVhbiBzdGF0ZSBpbiB3aGljaCBFUkVNT1ZFIHdpbGwgc3VjY2VlZC4NCj4gPiAr
ICovDQo+ID4gK3N0YXRpYyB2b2lkIHNneF9yZXNldF9lcGNfcGFnZShzdHJ1Y3Qgc2d4X2VwY19w
YWdlICplcGNfcGFnZSkgew0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlXQVJOX09OX09O
Q0UoZXBjX3BhZ2UtPmZsYWdzICYNCj4gU0dYX0VQQ19QQUdFX1JFQ0xBSU1FUl9UUkFDS0VEKTsN
Cj4gPiArDQo+ID4gKwlyZXQgPSBfX2VyZW1vdmUoc2d4X2dldF9lcGNfdmlydF9hZGRyKGVwY19w
YWdlKSk7DQo+ID4gKwlpZiAoV0FSTl9PTkNFKHJldCwgIkVSRU1PVkUgcmV0dXJuZWQgJWQgKDB4
JXgpIiwgcmV0LCByZXQpKQ0KPiA+ICsJCXJldHVybjsNCj4gPiArfQ0KPiANCj4gU2hvdWxkbid0
IHRoaXMganVzdCBiZToNCj4gDQo+IC4uLg0KPiAJcmV0ID0gX19lcmVtb3ZlKHNneF9nZXRfZXBj
X3ZpcnRfYWRkcihlcGNfcGFnZSkpOw0KPiAJV0FSTl9PTkNFKHJldCwgIkVSRU1PVkUgcmV0dXJu
ZWQgJWQgKDB4JXgpIiwgcmV0LCByZXQpOyB9DQo+IA0KPiBTb21ldGltZXMsIHlvdSBhY3R1YWxs
eSBuZWVkIHRvIGxvb2sgYXQgdGhlIGNvZGUgdGhhdCB5b3UgY3V0IGFuZCBwYXN0ZS4gOykNCg0K
Q29ycmVjdCEgVGhhbmtzIGZvciBjYXRjaGluZy4gSSdsbCByZW1vdmUgdGhpcyB1c2VsZXNzICdy
ZXR1cm4nIGluIG5leHQgdmVyc2lvbi4NCg0K
