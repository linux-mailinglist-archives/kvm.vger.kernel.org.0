Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D50A1BE02
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 21:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfEMTbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 15:31:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:59620 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbfEMTbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 15:31:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 12:31:12 -0700
X-ExtLoop1: 1
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 13 May 2019 12:31:11 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 13 May 2019 12:31:10 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.164]) by
 FMSMSX113.amr.corp.intel.com ([169.254.13.130]) with mapi id 14.03.0415.000;
 Mon, 13 May 2019 12:31:10 -0700
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jan.setjeeilers@oracle.com" <jan.setjeeilers@oracle.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "jwadams@google.com" <jwadams@google.com>
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
Thread-Topic: [RFC KVM 00/27] KVM Address Space Isolation
Thread-Index: AQHVCZo0+3UN0P2FyECwVvtVyp68J6ZpcaEA
Date:   Mon, 13 May 2019 19:31:10 +0000
Message-ID: <11F6D766-EC47-4283-8797-68A1405511B0@intel.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.19.0.190422
x-originating-ip: [10.254.35.195]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C5C1C4608577B4480BA83F49FC274F0@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNS8xMy8xOSwgNzo0MyBBTSwgImt2bS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxm
IG9mIEFsZXhhbmRyZSBDaGFydHJlIiB3cm90ZToNCg0KICAgIFByb3Bvc2FsDQogICAgPT09PT09
PT0NCiAgICANCiAgICBUbyBoYW5kbGUgYm90aCB0aGVzZSBwb2ludHMsIHRoaXMgc2VyaWVzIGlu
dHJvZHVjZSB0aGUgbWVjaGFuaXNtIG9mIEtWTQ0KICAgIGFkZHJlc3Mgc3BhY2UgaXNvbGF0aW9u
LiBOb3RlIHRoYXQgdGhpcyBtZWNoYW5pc20gY29tcGxldGVzIChhKSsoYikgYW5kDQogICAgZG9u
J3QgY29udHJhZGljdC4gSW4gY2FzZSB0aGlzIG1lY2hhbmlzbSBpcyBhbHNvIGFwcGxpZWQsIChh
KSsoYikgc2hvdWxkDQogICAgc3RpbGwgYmUgYXBwbGllZCB0byB0aGUgZnVsbCB2aXJ0dWFsIGFk
ZHJlc3Mgc3BhY2UgYXMgYSBkZWZlbmNlLWluLWRlcHRoKS4NCiAgICANCiAgICBUaGUgaWRlYSBp
cyB0aGF0IG1vc3Qgb2YgS1ZNICNWTUV4aXQgaGFuZGxlcnMgY29kZSB3aWxsIHJ1biBpbiBhIHNw
ZWNpYWwNCiAgICBLVk0gaXNvbGF0ZWQgYWRkcmVzcyBzcGFjZSB3aGljaCBtYXBzIG9ubHkgS1ZN
IHJlcXVpcmVkIGNvZGUgYW5kIHBlci1WTQ0KICAgIGluZm9ybWF0aW9uLiBPbmx5IG9uY2UgS1ZN
IG5lZWRzIHRvIGFyY2hpdGVjdHVhbGx5IGFjY2VzcyBvdGhlciAoc2Vuc2l0aXZlKQ0KICAgIGRh
dGEsIGl0IHdpbGwgc3dpdGNoIGZyb20gS1ZNIGlzb2xhdGVkIGFkZHJlc3Mgc3BhY2UgdG8gZnVs
bCBzdGFuZGFyZA0KICAgIGhvc3QgYWRkcmVzcyBzcGFjZS4gQXQgdGhpcyBwb2ludCwgS1ZNIHdp
bGwgYWxzbyBuZWVkIHRvIGtpY2sgYWxsIHNpYmxpbmcNCiAgICBoeXBlcnRocmVhZHMgdG8gZ2V0
IG91dCBvZiBndWVzdCAobm90ZSB0aGF0IGtpY2tpbmcgYWxsIHNpYmxpbmcgaHlwZXJ0aHJlYWRz
DQogICAgaXMgbm90IGltcGxlbWVudGVkIGluIHRoaXMgc2VyaWUpLg0KICAgIA0KICAgIEJhc2lj
YWxseSwgd2Ugd2lsbCBoYXZlIHRoZSBmb2xsb3dpbmcgZmxvdzoNCiAgICANCiAgICAgIC0gcWVt
dSBpc3N1ZXMgS1ZNX1JVTiBpb2N0bA0KICAgICAgLSBLVk0gaGFuZGxlcyB0aGUgaW9jdGwgYW5k
IGNhbGxzIHZjcHVfcnVuKCk6DQogICAgICAgIC4gS1ZNIHN3aXRjaGVzIGZyb20gdGhlIGtlcm5l
bCBhZGRyZXNzIHRvIHRoZSBLVk0gYWRkcmVzcyBzcGFjZQ0KICAgICAgICAuIEtWTSB0cmFuc2Zl
cnMgY29udHJvbCB0byBWTSAoVk1MQVVOQ0gvVk1SRVNVTUUpDQogICAgICAgIC4gVk0gcmV0dXJu
cyB0byBLVk0NCiAgICAgICAgLiBLVk0gaGFuZGxlcyBWTS1FeGl0Og0KICAgICAgICAgIC4gaWYg
aGFuZGxpbmcgbmVlZCBmdWxsIGtlcm5lbCB0aGVuIHN3aXRjaCB0byBrZXJuZWwgYWRkcmVzcyBz
cGFjZQ0KICAgICAgICAgIC4gZWxzZSBjb250aW51ZXMgd2l0aCBLVk0gYWRkcmVzcyBzcGFjZQ0K
ICAgICAgICAuIEtWTSBsb29wcyBpbiB2Y3B1X3J1bigpIG9yIHJldHVybg0KICAgICAgLSBLVk1f
UlVOIGlvY3RsIHJldHVybnMNCiAgICANCiAgICBTbywgdGhlIEtWTV9SVU4gY29yZSBmdW5jdGlv
biB3aWxsIG1haW5seSBiZSBleGVjdXRlZCB1c2luZyB0aGUgS1ZNIGFkZHJlc3MNCiAgICBzcGFj
ZS4gVGhlIGhhbmRsaW5nIG9mIGEgVk0tRXhpdCBjYW4gcmVxdWlyZSBhY2Nlc3MgdG8gdGhlIGtl
cm5lbCBzcGFjZQ0KICAgIGFuZCwgaW4gdGhhdCBjYXNlLCB3ZSB3aWxsIHN3aXRjaCBiYWNrIHRv
IHRoZSBrZXJuZWwgYWRkcmVzcyBzcGFjZS4NCiAgICANCk9uY2UgYWxsIHNpYmxpbmcgaHlwZXJ0
aHJlYWRzIGFyZSBpbiB0aGUgaG9zdCAoZWl0aGVyIHVzaW5nIHRoZSBmdWxsIGtlcm5lbCBhZGRy
ZXNzIHNwYWNlIG9yIHVzZXIgYWRkcmVzcyBzcGFjZSksIHdoYXQgaGFwcGVucyB0byB0aGUgb3Ro
ZXIgc2libGluZyBoeXBlcnRocmVhZHMgaWYgb25lIG9mIHRoZW0gdHJpZXMgdG8gZG8gVk0gZW50
cnk/IFRoYXQgVkNQVSB3aWxsIHN3aXRjaCB0byB0aGUgS1ZNIGFkZHJlc3Mgc3BhY2UgcHJpb3Ig
dG8gVk0gZW50cnksIGJ1dCBvdGhlcnMgY29udGludWUgdG8gcnVuPyBEbyB5b3UgdGhpbmsgKGEp
ICsgKGIpIHdvdWxkIGJlIHN1ZmZpY2llbnQgZm9yIHRoYXQgY2FzZT8NCiANCi0tLQ0KSnVuDQpJ
bnRlbCBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0KICAgIA0KDQo=
