Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5056531D22B
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 22:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhBPVe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 16:34:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:24687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhBPVet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 16:34:49 -0500
IronPort-SDR: lABltlwQpaEkNxrSDhKCSZUv6EgEprMOFIbufmPYUJev++voJsICUOvpKwJnNnbUg3dUy/mhCF
 VazsHi3o5KKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="183098787"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="183098787"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 13:34:05 -0800
IronPort-SDR: sdn1W8u9d+h3dj+bFYTi9oUPLGyRdxKDYzzrNqFJayJBgkS6s2kX77BiKp9YPATtay7SI1Zmz7
 o+aqGuO4Pw/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="384820977"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2021 13:34:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 13:34:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 13:34:04 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 13:34:04 -0800
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
Subject: RE: [RFC PATCH v5 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Thread-Topic: [RFC PATCH v5 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Thread-Index: AQHXAgqDJqyGy35FR0GtJTdCjOjmr6pbp+0A//+ohfA=
Date:   Tue, 16 Feb 2021 21:34:04 +0000
Message-ID: <321918254f444631bd06c8f1a6627947@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <4813545fa5765d05c2ed18f2e2c44275bd087c0a.1613221549.git.kai.huang@intel.com>
 <eafcdcae-ae66-e717-2f8b-2bdfb8e7d0d5@intel.com>
In-Reply-To: <eafcdcae-ae66-e717-2f8b-2bdfb8e7d0d5@intel.com>
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

PiBPbiAyLzEzLzIxIDU6MjggQU0sIEthaSBIdWFuZyB3cm90ZToNCj4gPiBTR1ggZHJpdmVyIHVz
ZXMgbWlzYyBkZXZpY2UgL2Rldi9zZ3hfZW5jbGF2ZSB0byBzdXBwb3J0IHVzZXJzcGFjZSB0bw0K
PiA+IGNyZWF0ZSBlbmNsYXZlLiAgRWFjaCBmaWxlIGRlc2NyaXB0b3IgZnJvbSBvcGVuaW5nIC9k
ZXYvc2d4X2VuY2xhdmUNCj4gPiByZXByZXNlbnRzIGFuIGVuY2xhdmUuDQo+IA0KPiBJcyB0aGlz
IHN0cmljdGx5IHRydWU/ICBEb2VzIGR1cCgyKSBjcmVhdGUgYSBuZXcgZW5jbGF2ZT8NCg0KSSBk
b24ndCB0aGluayBkdXAoKSB3aWxsIGNyZWF0ZSBhIG5ldyBlbmNsYXZlLiBFbmNsYXZlIGRhdGEg
c3RydWN0dXJlIGlzIGtlcHQgaW4gZmlsZXAtPnByaXZhdGVfZGF0YSwgYW5kIG9ubHkgJ29wZW4n
IHdpbGwgY3JlYXRlIGEgbmV3IG9uZS4NCg0KPiANCj4gPiBVbmxpa2UgU0dYIGRyaXZlciwgS1ZN
IGRvZXNuJ3QgY29udHJvbCBob3cgZ3Vlc3QgdXNlcyBFUEMsIHRoZXJlZm9yZQ0KPiA+IEVQQyBh
bGxvY2F0ZWQgdG8gS1ZNIGd1ZXN0IGlzIG5vdCBhc3NvY2lhdGVkIHRvIGFuIGVuY2FsdmUsIGFu
ZA0KPiA+IC9kZXYvc2d4X2VuY2xhdmUgaXMgbm90IHN1aXRhYmxlIGZvciBhbGxvY2F0aW5nIEVQ
QyBmb3IgS1ZNDQo+IA0KPiAgIF4gZW5jbGF2ZQ0KDQpPcHMuIFRoYW5rcy4NCg0KPiANCj4gPiBn
dWVzdC4NCj4gDQo+IA0KPiA+IEhhdmluZyBzZXBhcmF0ZSBkZXZpY2Ugbm9kZXMgZm9yIFNHWCBk
cml2ZXIgYW5kIEtWTSB2aXJ0dWFsIEVQQyBhbHNvDQo+ID4gYWxsb3dzIHNlcGFyYXRlIHBlcm1p
c3Npb24gY29udHJvbCBmb3IgcnVubmluZyBob3N0IFNHWCBlbmNsYXZlcyBhbmQNCj4gPiBLVk0g
U0dYIGd1ZXN0cy4NCj4gDQo+IFNwZWNpZmljYWxseSwgJ3NneF92ZXBjJyBpcyBhIGxlc3MgcmVz
dHJpY3RpdmUgaW50ZXJmYWNlLiAgSXQgd291bGQgbWFrZSBhIGxvdCBvZg0KPiBzZW5zZSB0byBt
b3JlIHRpZ2h0bHkgY29udHJvbCBhY2Nlc3MgY29tcGFyZWQgdG8gJ3NneF9lbmNsYXZlJy4NCg0K
U2VhbiBtZW50aW9uZWQgdGhlIG9wcG9zaXRlIGlzIGFsc28gbGlrZWx5LCBhbmQgSSBhZ3JlZS4g
UGxlYXNlIHNlZSBteSByZXBseSB0byBTZWFuJ3MuDQoNCj4gDQo+ID4gTW9yZSBzcGVjaWZpY2Fs
bHksIHRvIGFsbG9jYXRlIGEgdmlydHVhbCBFUEMgaW5zdGFuY2Ugd2l0aCBwYXJ0aWN1bGFyDQo+
ID4gc2l6ZSwgdGhlIHVzZXJzcGFjZSBoeXBlcnZpc29yIG9wZW5zIC9kZXYvc2d4X3ZlcGMsIGFu
ZCB1c2VzIG1tYXAoKQ0KPiA+IHdpdGggdGhlIGludGVuZGVkIHNpemUgdG8gZ2V0IGFuIGFkZHJl
c3MgcmFuZ2Ugb2YgdmlydHVhbCBFUEMuICBUaGVuDQo+ID4gaXQgbWF5IHVzZSB0aGUgYWRkcmVz
cyByYW5nZSB0byBjcmVhdGUgb25lIEtWTSBtZW1vcnkgc2xvdCBhcyB2aXJ0dWFsDQo+ID4gRVBD
IGZvciBndWVzdC4NCj4gDQo+IFRoaXMgcGFyYWdyYXBoIGRvZXNuJ3QgcmVhbGx5IGV4cGxhaW4g
YW55dGhpbmcgaW1wb3J0YW50IHRvIG1lLiAgQm90aCBkZXZpY2VzDQo+IHJlcXVpcmUgdXNpbmcg
bW1hcCgpLg0KDQpUaGlzIHBhcmFncmFwaCB3YXMgcmVxdWVzdGVkIGJ5IEphcmtrbyB0byBleHBs
YWluIGhvdyB0byB1c2UgdGhpcyAvZGV2L3NneF92ZXBjLiANCg0KUGVyaGFwcyBJIGNhbiByZW1v
dmUgaXQ/DQoNCk9yIHBlcmhhcHMgSSBjYW4gcmVmaW5lIHRvICJUbyB1c2UgL2Rldi9zZ3hfdmVw
YyB0byBhbGxvY2F0ZSBhIHZpcnR1YWwgRVBDIGluc3RhbmNlIHdpdGggcGFydGljdWxhciBzaXpl
LCB0aGUgdXNlcnNwYWNlIGh5cGVydmlzb3IuLi4iPw0KDQo+IA0KPiBXaXRoIHR5cG9zIGluIHRo
ZSBjaGFuZ2Vsb2cgZml4ZWQsIEknbSBPSyB3aXRoIHRoZSByZXN0Og0KPiANCj4gQWNrZWQtYnk6
IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IA0KPiBCVFcuLi4gIEEgbG90
IG9mIHRoaXMgcGF0Y2ggaXMganVzdCBhIHNrZWxldGFsIGRldmljZSBkcml2ZXIuICBJJ20gYSBo
b3JyaWJsZSBkZXZpY2UNCj4gZHJpdmVyIHdyaXRlciwgc28gdGFrZSB0aGlzIGFjayBhcyAiZXZl
cnl0aGluZyBzZWVtcyBleHBsYWluZWQgd2VsbCIgdmVyc3VzICJJDQo+IHByb21pc2UgdGhpcyB3
aWxsIHBhc3MgbXVzdGVyIHdpdGggdGhlIGd1eXMgd2hvIHJldmlldyBkZXZpY2UgZHJpdmVycyBh
bGwgZGF5DQo+IGxvbmcuIg0KDQpUaGFua3MuIA0K
