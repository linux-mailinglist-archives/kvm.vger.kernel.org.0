Return-Path: <kvm+bounces-46132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 44070AB2EA2
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 07:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE9427A1A12
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 05:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785B4254B1B;
	Mon, 12 May 2025 05:03:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B3E19E7D0;
	Mon, 12 May 2025 05:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747026215; cv=none; b=JfUwBGgUe+SGhmVi/eJw9Ge5vtio/4N5T6J7uxK90PRUOLVprhGY5crZu1kWM7LTe6MxsKWnqEXlvHhxJ7jrH2fRWdVeBvzU0uio10iKje0+Rwawi2JuKNskkWH5jmNWDLOY3ng0yeDiWJ0fzCzSPd598cgpv/eR3JVkh5FXLgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747026215; c=relaxed/simple;
	bh=B4ajeP8LskIJXtYbB+ZGzyrSvo2XVWGdO8o/ypNXy6w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RlyW5sgjo6upzGoUSaGgnQurmyDDbyjMrQFbpUnWyPhvpWaKA1/JTR8mAPb2aaLPunZWXnUmMQY7hapgavtzWWZjEN1tkiaG/cDHVFwTm4xG0OuFpOPxPlfQ3/AYO9d10Rnk1YqC5zvoYpm+sDAO0V3rn3DXBd5sndTJPPuiyBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Li,Zhaoxin(ACG CCN)" <lizhaoxin04@baidu.com>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiA/PzogWz8/Pz9dIFJlOiBbUEFUQ0hdIEtWTTog?=
 =?gb2312?B?VXNlIGNhbGxfcmN1KCkgaW4ga3ZtX2lvX2J1c19yZWdpc3Rlcl9kZXY=?=
Thread-Topic: [????] Re: ??: [????] Re: [PATCH] KVM: Use call_rcu() in
 kvm_io_bus_register_dev
Thread-Index: AQHbtDGgrzSppzuzck+TBQD3uwy4MbOw0jWAgAFLEUCAFK4DgIAHwHEA
Date: Mon, 12 May 2025 05:03:17 +0000
Message-ID: <2d1f56370b644621b4e3bb8c0c47590e@baidu.com>
References: <20250423092509.3162-1-lirongqing@baidu.com>
 <aAkAY40UbqzQNr8m@google.com> <4bfe7a8f5020448e903e6335173afc75@baidu.com>
 <aBtgTnQU0JlNq2Y3@google.com>
In-Reply-To: <aBtgTnQU0JlNq2Y3@google.com>
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
X-FEAS-Client-IP: 172.31.50.15
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 52:10:53:SYSTEM

PiBBaCwgc28gdGhpcyBpc24ndCBhYm91dCBkZXZpY2UgY3JlYXRpb24gZnJvbSB1c2Vyc3BhY2Us
IHJhdGhlciBpdCdzIGFib3V0IHJlYWN0aW5nDQo+IHRvIHRoZSBndWVzdCdzIGNvbmZpZ3VyYXRp
b24gb2YgYSBkZXZpY2UsIGUuZy4gdG8gcmVnaXN0ZXIgZG9vcmJlbGxzIHdoZW4gdGhlDQo+IGd1
ZXN0IGluc3RhbnRpYXRlcyBxdWV1ZXMgZm9yIGEgZGV2aWNlPw0KPiANCg0KWWVzLCB0aGUgaW9l
dmVudGZkcyBhcmUgcmVnaXN0ZXJlZCB3aGVuIGd1ZXN0IGluc3RhbnRpYXRlcyBxdWV1ZXMNCg0K
DQo+ID4gY2FuIGlvZXZlbnRmZCB1c2VzIGNhbGxfc3JjdT8NCj4gDQo+IE5vLCBiZWNhdXNlIHRo
YXQgaGFzIHRoZSBzYW1lIHByb2JsZW0gb2YgS1ZNIG5vdCBlbnN1cmluZyB2Q1BVcyB3aWxsIG9i
c2VydmUNCj4gdGhlIHRoZSBjaGFuZ2UgYmVmb3JlIHJldHVybmluZyB0byB1c2Vyc3BhY2UuDQo+
IA0KPiBVbmZvcnR1bmF0ZWx5LCBJIGRvbid0IHNlZSBhbiBlYXN5IHNvbHV0aW9uLiAgQXQgYSBn
bGFuY2UsIGV2ZXJ5IGFyY2hpdGVjdHVyZQ0KPiBleGNlcHQgYXJtNjQgY291bGQgc3dpdGNoIHRv
IHByb3RlY3Qga3ZtLT5idXNlcyB3aXRoIGEgcndsb2NrLCBidXQgYXJtNjQgdXNlcw0KPiB0aGUg
TU1JTyBidXMgZm9yIHRoZSB2R0lDJ3MgSVRTLCBhbmQgSSBkb24ndCB0aGluayBpdCdzIGZlYXNp
YmxlIHRvIG1ha2UgdGhlIElUUw0KPiBzdHVmZiBwbGF5IG5pY2Ugd2l0aCBhIHJ3bG9jay4gIEUu
Zy4gdmdpY19pdHMuaXRzX2xvY2sgYW5kIHZnaWNfaXRzLmNtZF9sb2NrIGFyZQ0KPiBtdXRleGVz
LCBhbmQgdGhlcmUgYXJlIG11bHRpcGxlIElUUyBwYXRocyB0aGF0IGFjY2VzcyBndWVzdCBtZW1v
cnksIGkuZS4gbWlnaHQNCj4gc2xlZXAgZHVlIHRvIGZhdWx0aW5nLg0KPiANCj4gRXZlbiBpZiB3
ZSBkaWQgc29tZXRoaW5nIHg4Ni1jZW50cmljLCBlLmcuIGZ1dGhlciBzcGVjaWFsIGNhc2UNCj4g
S1ZNX0ZBU1RfTU1JT19CVVMgd2l0aCBhIHJ3bG9jaywgSSB3b3JyeSB0aGF0IHVzaW5nIGEgcnds
b2NrIHdvdWxkDQo+IGRlZ3JhZGUgc3RlYWR5IHN0YXRlIHBlcmZvcm1hbmNlLCBlLmcuIGR1ZSB0
byBjcm9zcy1DUFUgYXRvbWljIGFjY2Vzc2VzLg0KPiANCj4gRG9lcyB1c2luZyBhIGRlZGljYXRl
ZCBTUkNVIHN0cnVjdHVyZSByZXNvbHZlIHRoZSBpc3N1ZT8gIEUuZy4gYWRkIGFuZCB1c2UNCj4g
a3ZtLT5idXNlc19zcmN1IGluc3RlYWQgb2Yga3ZtLT5zcmN1PyAgeDg2J3MgdXNhZ2Ugb2YgdGhl
IE1NSU8vUElPIGJ1c2VzDQo+IGt2bS0+aXMNCj4gbGltaXRlZCB0byBrdm1faW9fYnVzX3tyZWFk
LHdyaXRlfSgpLCBzbyBpdCBzaG91bGQgYmUgZWFzeSBlbm91Z2ggdG8gZG8gYSBzdXBlcg0KPiBx
dWljayBhbmQgZGlydHkgUG9DLg0KDQpDb3VsZCB5b3Ugd3JpdGUgYSBwYXRjaCwgd2UgY2FuIHRl
c3QgaXQNCg0KVGhhbmtzDQoNCi1MaQ0K

