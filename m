Return-Path: <kvm+bounces-62-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA617DB774
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 11:08:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88DD0B20DA6
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 10:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E575F10A19;
	Mon, 30 Oct 2023 10:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3E02CA8
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 10:08:18 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C6C8A62
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 03:08:16 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-3-Zuw0VAkjMoGz3HawsfyiRw-1; Mon, 30 Oct 2023 10:08:14 +0000
X-MC-Unique: Zuw0VAkjMoGz3HawsfyiRw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 30 Oct
 2023 10:08:28 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 30 Oct 2023 10:08:28 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'David Woodhouse' <dwmw2@infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: selftests: add -MP to CFLAGS
Thread-Topic: [PATCH] KVM: selftests: add -MP to CFLAGS
Thread-Index: AQHaCdXc3e78bpbjnkOmWxrFAzERRLBhRPEwgADTCoCAAAV0YA==
Date: Mon, 30 Oct 2023 10:08:28 +0000
Message-ID: <aae76a24900444b7a812a21815a0b212@AcuMS.aculab.com>
References: <9fc8b5395321abbfcaf5d78477a9a7cd350b08e4.camel@infradead.org>
         <3fa5bdded7504d6582cf01f4db4cd6b4@AcuMS.aculab.com>
 <213451dcf8036133426aa04b6f377a16c6b53ff5.camel@infradead.org>
In-Reply-To: <213451dcf8036133426aa04b6f377a16c6b53ff5.camel@infradead.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

RnJvbTogRGF2aWQgV29vZGhvdXNlDQo+IFNlbnQ6IDMwIE9jdG9iZXIgMjAyMyAwOTo0Ng0KPiAN
Cj4gT24gU3VuLCAyMDIzLTEwLTI5IGF0IDIxOjEzICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6
DQo+ID4gRnJvbTogRGF2aWQgV29vZGhvdXNlDQo+ID4gPiBTZW50OiAyOCBPY3RvYmVyIDIwMjMg
MjA6MzUNCj4gPiA+DQo+ID4gPiBVc2luZyAtTUQgd2l0aG91dCAtTVAgY2F1c2VzIGJ1aWxkIGZh
aWx1cmVzIHdoZW4gYSBoZWFkZXIgZmlsZSBpcyBkZWxldGVkDQo+ID4gPiBvciBtb3ZlZC4gV2l0
aCAtTVAsIHRoZSBjb21waWxlciB3aWxsIGVtaXQgcGhvbnkgdGFyZ2V0cyBmb3IgdGhlIGhlYWRl
cg0KPiA+ID4gZmlsZXMgaXQgbGlzdHMgYXMgZGVwZW5kZW5jaWVzLCBhbmQgdGhlIE1ha2VmaWxl
cyB3b24ndCByZWZ1c2UgdG8gYXR0ZW1wdA0KPiA+ID4gdG8gcmVidWlsZCBhIEMgdW5pdCB3aGlj
aCBubyBsb25nZXIgaW5jbHVkZXMgdGhlIGRlbGV0ZWQgaGVhZGVyLg0KPiA+DQo+ID4gV29uJ3Qg
YSBwaG9ueSB0YXJnZXQgc3RvcCBhIGhlYWRlciBiZWluZyBidWlsdCBpZiB0aGVyZSBpcw0KPiA+
IGFuIGFjdHVhbCBydWxlIHRvIGJ1aWxkIGl0Pw0KPiANCj4gSXQgcHJvYmFibHkgd291bGQgaGF2
ZSB0YWtlbiB5b3UgYWJvdXQgdGhlIHNhbWUgdGltZSB0byBmaW5kIHRoZSBhbnN3ZXINCj4gZm9y
IHlvdXJzZWxmLCBhcyBpdCB0b29rIHRvIHdyaXRlIHRoYXQgZW1haWwuIFdoeSBkb24ndCB5b3Ug
dHJ5IGl0Pw0KDQpJIHdhcyBzdXJlIHRoYXQganVzdCBhZGRpbmcNCg0KZm9vLmg6DQoNCndvdWxk
IGdlbmVyYXRlIGEgJ25vIHJ1bGVzIHRvIGJ1aWxkJyBlcnJvci4NCk1heWJlIHRoYXQgd2FzIEJT
RCBtYWtlIG9yIFNZUy1WIG1ha2UuDQoNCkJ1dCBjYWxsaW5nIHRoZSAncGhvbnknIGlzIHByb2Jh
Ymx5IHdyb25nLg0KUEhPTlkgaGFzIGEgdmVyeSBzcGVjaWZpYyBtZWFuaW5nIHRvIG1ha2UgLSBh
bmQgdGhlc2UgYXJlbid0IFBIT05ZLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K


