Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A502E129953
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 18:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLWR1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 12:27:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:15605 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbfLWR1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 12:27:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 09:27:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,348,1571727600"; 
   d="scan'208";a="223058323"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2019 09:27:05 -0800
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.30]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.176]) with mapi id 14.03.0439.000;
 Mon, 23 Dec 2019 09:27:04 -0800
From:   "Andersen, John S" <john.s.andersen@intel.com>
To:     "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@alien8.de" <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
Thread-Topic: [RESEND RFC 0/2] Paravirtualized Control Register pinning
Thread-Index: AQHVt2uK2a8jsyPFKUGPuWHWZO4ZBqfIV12AgAAnYgCAAAVQgA==
Date:   Mon, 23 Dec 2019 17:27:04 +0000
Message-ID: <26f2b7e58fd45eede50f845a57761d1f01aff3f7.camel@intel.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
         <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
         <15b57d6b-0f46-01f5-1f75-b9b55db0611a@redhat.com>
In-Reply-To: <15b57d6b-0f46-01f5-1f75-b9b55db0611a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.9.42]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B040A5A2AB5A1E48A05E92B1630C4E15@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTEyLTIzIGF0IDE4OjA5ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAyMy8xMi8xOSAxNTo0OCwgTGlyYW4gQWxvbiB3cm90ZToNCj4gPiA+IFNob3VsZCB1c2Vy
c3BhY2UgZXhwb3NlIHRoZSBDUiBwaW5pbmcgQ1BVSUQgZmVhdHVyZSBiaXQsIGl0IG11c3QNCj4g
PiA+IHplcm8gQ1INCj4gPiA+IHBpbm5lZCBNU1JzIG9uIHJlYm9vdC4gSWYgaXQgZG9lcyBub3Qs
IGl0IHJ1bnMgdGhlIHJpc2sgb2YgaGF2aW5nDQo+ID4gPiB0aGUNCj4gPiA+IGd1ZXN0IGVuYWJs
ZSBwaW5uaW5nIGFuZCBzdWJzZXF1ZW50bHkgY2F1c2UgZ2VuZXJhbCBwcm90ZWN0aW9uDQo+ID4g
PiBmYXVsdHMgb24NCj4gPiA+IG5leHQgYm9vdCBkdWUgdG8gZWFybHkgYm9vdCBjb2RlIHNldHRp
bmcgY29udHJvbCByZWdpc3RlcnMgdG8NCj4gPiA+IHZhbHVlcw0KPiA+ID4gd2hpY2ggZG8gbm90
IGNvbnRhaW4gdGhlIHBpbm5lZCBiaXRzLg0KPiA+IA0KPiA+IFdoeSByZXNldCBDUiBwaW5uZWQg
TVNScyBieSB1c2Vyc3BhY2UgaW5zdGVhZCBvZiBLVk0gSU5JVCBoYW5kbGluZz8NCj4gDQo+IE1v
c3QgTVNScyBhcmUgbm90IHJlc2V0IGJ5IElOSVQsIGFyZSB0aGV5Pw0KPiANCg0KQXMgZmFyIGFz
IEkgY2FuIHRlbGwsIEtWTSBkb2Vzbid0IGtub3cgaWYgdGhlIGd1ZXN0IGlzIHJlYm9vdGVkLg0K
VXNlcnNwYWNlIHVzZXMgdGhlIHNyZWdzIGFuZCBzZXQgTVNScyBpb2N0bHMgdG8gcmVzZXQgc3Rh
dGUuDQprdm1fdmNwdV9yZXNldCBpcyBjYWxsZWQgb24gbm9uLWJvb3QgQ1BVcy4ga3ZtX3ZjcHVf
aW5pdCBpc24ndCBjYWxsZWQNCm9uIHJlYm9vdC4NCg==
