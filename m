Return-Path: <kvm+bounces-44635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0A7A9FF8F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F8A8464531
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6413E253F08;
	Tue, 29 Apr 2025 02:14:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F72253B4D;
	Tue, 29 Apr 2025 02:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892852; cv=none; b=Hq59t6EXOKnnaN05dgLLpFi6g+fel1A9G+crmY52oVhybHXNQ9OT9wCAIybC+spZHwadOhhS+tN8CLfXL4G14Y4XnTzxgOu1/nq2yDJHN4Wo5AFdHz/NW8saA4rG4L0qr9MWJCwWU0B3EswkR/XzFPybhS2n0mfgqQLo9C15yvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892852; c=relaxed/simple;
	bh=5Bc0Li5v9Skg+lsdo6IebZ6J22Qw3u8rSW58H9On/5c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ECVEaGsOI3CaqIo3HnXgqVQ/nTnLqRLySoLfA4YNrP1vvpephteuHAyUFk9+EVOP5w12Oa+clhsrl9QUI8xcrz5y6n2iNov67sTFQjHee6N9LgKMffYUROUpkDB3ZTGMaA5exmQixHGPW2t030qfbxuQ9rB4ytPREXDrmNSSdAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIEtWTTogRml4IG9ic29sZXRlIGNv?=
 =?gb2312?B?bW1lbnQgYWJvdXQgbG9ja2luZyBmb3Iga3ZtX2lvX2J1c19yZWFkL3dyaXRl?=
Thread-Topic: [????] Re: [PATCH] KVM: Fix obsolete comment about locking for
 kvm_io_bus_read/write
Thread-Index: AQHbuGi4glF6La7rkUKyWtZpTnfB6LO558Jg
Date: Tue, 29 Apr 2025 02:13:50 +0000
Message-ID: <212c590c8538497795213dbebf08a600@baidu.com>
References: <20250418115504.17155-1-lirongqing@baidu.com>
 <aA_EY8CR2kxi3X5T@google.com>
In-Reply-To: <aA_EY8CR2kxi3X5T@google.com>
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
X-FEAS-Client-IP: 172.31.51.55
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 52:10:53:SYSTEM

DQo+IA0KPiBPbiBGcmksIEFwciAxOCwgMjAyNSwgTGkgUm9uZ1Fpbmcgd3JvdGU6DQo+ID4gTm9i
b2R5IGlzIGFjdHVhbGx5IGNhbGxpbmcgdGhlc2UgZnVuY3Rpb25zIHdpdGggc2xvdHNfbG9jayBo
ZWxkLg0KPiA+IFRoZSBzcmN1IHJlYWQgbG9jayBpcyByZXF1aXJlZC4NCj4gDQo+IEkgdm90ZSB0
byBkZWxldGUgdGhlIGNvbW1lbnRzIGVudGlyZWx5LCB0aGUgc3JjdV9kZXJlZmVyZW5jZSgpIHBy
ZWNpc2VseQ0KPiBjb21tdW5pY2F0ZXMgYm90aCB3aGF0IGlzIGJlaW5nIHByb3RlY3RlZCwgYW5k
IHdoYXQgcHJvdmlkZXMgdGhlIHByb3RlY3Rpb24uDQoNCg0KT2ssIEkgd2lsbCByZXNlbmQgdGhp
cyBwYXRjaA0KDQpUaGFuaw0KDQotTGkNCg==

