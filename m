Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BA716E9DB
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbgBYPTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:19:19 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:30238 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730753AbgBYPTT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 10:19:19 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-181-PygZP9mHNwW0TQKcmdPTxQ-1; Tue, 25 Feb 2020 15:19:14 +0000
X-MC-Unique: PygZP9mHNwW0TQKcmdPTxQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 25 Feb 2020 15:19:14 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 25 Feb 2020 15:19:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Bonzini' <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 43/61] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as
 not-reserved
Thread-Topic: [PATCH 43/61] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as
 not-reserved
Thread-Index: AQHV6+4E9BqMh7ePK0SVXxTqp0vBfqgsBIsQ
Date:   Tue, 25 Feb 2020 15:19:14 +0000
Message-ID: <5c0282a66ae54d36af674a568b58071b@AcuMS.aculab.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-44-sean.j.christopherson@intel.com>
 <8736azocyp.fsf@vitty.brq.redhat.com>
 <66467dd7-09f0-7975-5c4e-c0404d779d8d@redhat.com>
In-Reply-To: <66467dd7-09f0-7975-5c4e-c0404d779d8d@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGFvbG8gQm9uemluaQ0KPiBTZW50OiAyNSBGZWJydWFyeSAyMDIwIDE1OjEyDQo+IE9u
IDI0LzAyLzIwIDIzOjA4LCBWaXRhbHkgS3V6bmV0c292IHdyb3RlOg0KPiA+PiArDQo+ID4+ICtz
dGF0aWMgX19hbHdheXNfaW5saW5lIGJvb2wga3ZtX2NwdV9jYXBfaGFzKHVuc2lnbmVkIHg4Nl9m
ZWF0dXJlKQ0KPiA+PiArew0KPiA+PiArCXJldHVybiBrdm1fY3B1X2NhcF9nZXQoeDg2X2ZlYXR1
cmUpOw0KPiA+PiArfQ0KPiA+IEkga25vdyB0aGlzIHdvcmtzIChhbmQgSSBldmVuIGNoZWNrZWQg
Qzk5IHRvIG1ha2Ugc3VyZSB0aGF0IGl0IHdvcmtzIG5vdA0KPiA+IGJ5IGFjY2lkZW50KSBidXQg
SSBoYXZlIHRvIGFkbWl0IHRoYXQgZXhwbGljaXQgJyEhJyBjb252ZXJzaW9uIHRvIGJvb2wNCj4g
PiBhbHdheXMgbWFrZXMgbWUgZmVlbCBzYWZlciA6LSkNCj4gDQo+IFNhbWUgaGVyZSwgSSBkb24n
dCByZWFsbHkgbGlrZSB0aGUgYXV0b21hZ2ljIGJvb2wgYmVoYXZpb3IuLi4NCg0KSSBqdXN0IGRp
c2xpa2UgJ2Jvb2wnLg0KDQpDb252ZXJzaW9uIG9mIDAvbm9uLXplcm8gdG8gMC8xIGlzbid0IGNv
bXBsZXRlbHkgZnJlZS4NCkFuZCBzb21ldGhpbmcgaGFzIHRvICdnaXZlJyB3aGVuIHRoZSByZWZl
cmVuY2VkIG1lbW9yeSBsb2NhdGlvbg0KZG9lc24ndCBjb250YWluIDAgb3IgMS4NCg0KT25lIHZl
cnkgb2xkIHZlcnNpb24gb2YgZ2NjIG1hZGUgYSBjb21wbGV0ZSBoYXNoIG9mOg0KCWJvb2xfdmFy
IHw9IGZ1bmN0aW9uX3JldHVybmluZ19ib29sKCk7DQoNCkknbSBub3Qgc3VyZSB3aGF0IHRoZSBz
dGFuZGFyZCByZXF1aXJlcyBub3Igd2hhdCBjdXJyZW50IGdjYw0KZ2VuZXJhdGVzIC0gYnV0IHlv
dSB3YW50IGEgJ2xvZ2ljYWwgb3InIGluc3RydWN0aW9uLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0
ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBL
ZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

