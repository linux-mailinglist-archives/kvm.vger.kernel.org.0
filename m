Return-Path: <kvm+bounces-44637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93F84A9FFC8
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17FC91A871AD
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2BAA29B791;
	Tue, 29 Apr 2025 02:28:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE342FB2;
	Tue, 29 Apr 2025 02:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745893727; cv=none; b=nnDfBWZa411H0obPndfm5AGW7yH6UC7pZFhai06s5C50MIQnOagxUnmNrCnt2KAJSJtk5WFJR18wU02w9Uu6R6CSiuop0hMuulRtc7ixj6UkQ0PKqXdDK+niUP2fcAzTG3V2faG2eOH/CAnWU/rcw81DAOb1gY37wcY48dtPF4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745893727; c=relaxed/simple;
	bh=/lS51eLH5B2l1r0Sda86Z8wgfaHGDJSQEORw3wgDVZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QI+YK5jUA3SSj3vansd5xMROxCLaok9ymBvV1Fx8pRqDHMoOQsXH2uE/XBSO//JPZE5n4U5DmKodVu3B4Ex0GgWe5KrZGz1jJDY/PZlM1qtnPA9OXMhH8uTOcvwQITdkA83qJAJ1Aw3se+bXLJcuH228Y3isxTEMJV5wro8pGOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Li,Zhaoxin(ACG CCN)" <lizhaoxin04@baidu.com>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIEtWTTogVXNlIGNhbGxfcmN1KCkg?=
 =?gb2312?B?aW4ga3ZtX2lvX2J1c19yZWdpc3Rlcl9kZXY=?=
Thread-Topic: [????] Re: [PATCH] KVM: Use call_rcu() in
 kvm_io_bus_register_dev
Thread-Index: AQHbtDGgrzSppzuzck+TBQD3uwy4MbOw0jWAgAka1pA=
Date: Tue, 29 Apr 2025 02:13:17 +0000
Message-ID: <774b6e32c4674a6a85a7a90aabdc2234@baidu.com>
References: <20250423092509.3162-1-lirongqing@baidu.com>
 <aAkAY40UbqzQNr8m@google.com>
In-Reply-To: <aAkAY40UbqzQNr8m@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.50.17
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 52:10:53:SYSTEM

PiA+ICAJcmN1X2Fzc2lnbl9wb2ludGVyKGt2bS0+YnVzZXNbYnVzX2lkeF0sIG5ld19idXMpOw0K
PiA+IC0Jc3luY2hyb25pemVfc3JjdV9leHBlZGl0ZWQoJmt2bS0+c3JjdSk7DQo+ID4gLQlrZnJl
ZShidXMpOw0KPiA+ICsNCj4gPiArCWNhbGxfc3JjdSgma3ZtLT5zcmN1LCAmYnVzLT5yY3UsIGZy
ZWVfa3ZtX2lvX2J1cyk7DQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoaXMgaXMgc2FmZSBmcm9tIGEg
ZnVuY3Rpb25hbCBjb3JyZWN0bmVzcyBwZXJzcGVjdGl2ZSwgYXMgS1ZNIG11c3QNCj4gZ3VhcmFu
dGVlIGFsbCByZWFkZXJzIHNlZSB0aGUgbmV3IGRldmljZSBiZWZvcmUgS1ZNIHJldHVybnMgY29u
dHJvbCB0bw0KPiB1c2Vyc3BhY2UuDQo+IEUuZy4gSSdtIHByZXR0eSBzdXJlIEtWTV9SRUdJU1RF
Ul9DT0FMRVNDRURfTU1JTyBpcyB1c2VkIHdoaWxlIHZDUFVzIGFyZQ0KPiBhY3RpdmUuDQo+IA0K
PiBIb3dldmVyLCBJJ20gcHJldHR5IHN1cmUgdGhlIG9ubHkgcmVhZGVycyB0aGF0IGFjdHVhbGx5
IHJlbHkgb24gU1JDVSBhcmUgdkNQVXMsDQo+IHNvIEkgX3RoaW5rXyB0aGUgc3luY2hyb25pemVf
c3JjdV9leHBlZGl0ZWQoKSBpcyBuZWNlc3NhcnkgaWYgYW5kIG9ubHkgaWYgdkNQVXMNCj4gaGF2
ZSBiZWVuIGNyZWF0ZWQuDQo+IA0KDQpUaGlzIHBhdGNoIGRvZXMgbm90IGNoYW5nZSByY3VfYXNz
aWduX3BvaW50ZXIoKSwgYW5kIHNyY3VfZGVyZWZlcmVuY2Ugd2lsbCBiZSB1c2VkIHdoZW4gdkNQ
VSByZWFkIHRoaXMgYnVzZXMsIHNvIEkgdGhpbmsgc3luY2hyb25pemVfc3JjdV9leHBlZGl0ZWQg
aXMgbm90IGEgbXVzdD8gDQoNCg0KDQo+IFRoYXQgY291bGQgcmFjZSB3aXRoIGNvbmN1cnJlbnQg
dkNQVSBjcmVhdGlvbiBpbiBhIGZldyBmbG93cyB0aGF0IGRvbid0IHRha2UNCj4ga3ZtLT5sb2Nr
LCBidXQgdGhhdCBzaG91bGQgYmUgb2sgZnJvbSBhbiBBQkkgcGVyc3BlY3RpdmUuICBGYWxzZQ0K
PiBrdm0tPnBvc2l0aXZlcyAodkNQVQ0KPiBjcmVhdGlvbiBmYWlscykgYXJlIGJlbmlnbiwgYW5k
IGZhbHNlIG5lZ2F0aXZlcyAodkNQVSBjcmVhdGVkIGFmdGVyIHRoZSBjaGVjaykgYXJlDQo+IGlu
aGVyZW50bHkgcmFjeSwgaS5lLiB1c2Vyc3BhY2UgY2FuJ3QgZ3VhcmFudGVlIHRoZSB2Q1BVIHNl
ZXMgYW55IHBhcnRpY3VsYXINCj4gb3JkZXJpbmcuDQo+IA0KPiBTbyB0aGlzPw0KPiANCj4gCWlm
IChSRUFEX09OQ0Uoa3ZtLT5jcmVhdGVkX3ZjcHVzKSkgew0KPiAJCXN5bmNocm9uaXplX3NyY3Vf
ZXhwZWRpdGVkKCZrdm0tPnNyY3UpOw0KPiAJCWtmcmVlKGJ1cyk7DQo+IAl9IGVsc2Ugew0KPiAJ
CWNhbGxfc3JjdSgma3ZtLT5zcmN1LCAmYnVzLT5yY3UsIGZyZWVfa3ZtX2lvX2J1cyk7DQo+IAl9
DQo=

