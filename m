Return-Path: <kvm+bounces-69776-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id rb+pKbf0fWmBUgIAu9opvQ
	(envelope-from <kvm+bounces-69776-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 13:25:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BA2C1C6F
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 13:25:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 730AE300B9D6
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 12:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB1132720C;
	Sat, 31 Jan 2026 12:25:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9C2C145
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769862318; cv=none; b=E+9mqTF6qAHImLqu53jORqfaskhJ9ilnAnuwnhrkmhTFQTTGJzPkXjRx4o7Uxm+5wQpXCWhQkDinAJO2HQPX2pGCL2XM1hydLsGFIPVpsLPsv1KppvrdSVf68vbn/xhpBsdHjPyvvGYPD0am5MNnwSRhvjBU4Mcoq6BjQInb6Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769862318; c=relaxed/simple;
	bh=4ctMkL/gSAgW5WvV404JjvicxVQg/XOMmAPQeLMR5do=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wei3kvO7INiKLrHa7nNIq8qqi96CqJS1BGh2wJTJJ0019Bkfg8QkFaFbs0V03IslmxI5LLxdtnpT7XaXl+eovsYaSL8ZBTh3mLOVqIZNyXzVU9pYH7BXIhXfBkSje+E8zPyMxYORR/va5Z0i1psDuu1hcnh6LUmiZaEI1nczufQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H . Peter
 Anvin" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIEtWTTogU1ZNOiBBZGQgX19yZWFk?=
 =?gb2312?Q?=5Fmostly_to_frequently_read_module_parameters?=
Thread-Topic: [????] Re: [PATCH] KVM: SVM: Add __read_mostly to frequently
 read module parameters
Thread-Index: AQHckik//SzTiR5R9UKGyqy9HU4trLVqq8KAgAGIy/A=
Date: Sat, 31 Jan 2026 12:24:15 +0000
Message-ID: <3f6524d3104843baad92c1741f6c061e@baidu.com>
References: <20260130204424.1867-1-lirongqing@baidu.com>
 <aX0bT-sKOSEVHHC8@google.com>
In-Reply-To: <aX0bT-sKOSEVHHC8@google.com>
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
X-FEAS-Client-IP: 172.31.3.12
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.14 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[baidu.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69776-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lirongqing@baidu.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 27BA2C1C6F
X-Rspamd-Action: no action

DQo+IE9uIEZyaSwgSmFuIDMwLCAyMDI2LCBsaXJvbmdxaW5nIHdyb3RlOg0KPiA+IEZyb206IExp
IFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPg0KPiA+IE1hcmsgc3RhdGljIGds
b2JhbCB2YXJpYWJsZXMgdGhhdCBhcmUgcHJpbWFyaWx5IHJlYWQtb25seSB3aXRoDQo+ID4gX19y
ZWFkX21vc3RseSB0byBvcHRpbWl6ZSBjYWNoZSB1dGlsaXphdGlvbiBhbmQgcGVyZm9ybWFuY2Uu
DQo+ID4NCj4gPiBUaGUgbW9kaWZpZWQgdmFyaWFibGVzIGFyZSBtb2R1bGUgcGFyYW1ldGVycyBh
bmQgY29uZmlndXJhdGlvbiBmbGFncw0KPiA+IHRoYXQgYXJlOg0KPiA+IC0gSW5pdGlhbGl6ZWQg
YXQgYm9vdCB0aW1lDQo+IA0KPiBQbGVhc2UgbWFrZSB0aGVzZSBfX3JvX2FmdGVyX2luaXQgd2hl
cmUgcG9zc2libGUsIG5vdCBfX3JlYWRfbW9zdGx5LiAgRS5nLg0KPiBmb3JjZV9hdmljIGlzIGRl
ZmluaXRlbHkgcmVhZC1vbmx5IGFmdGVyIGluaXQuDQoNCk9rLCBJIHdpbGwgc2VuZCB2Mg0KDQpU
aGFua3MNCg0KDQpbTGksUm9uZ3FpbmddIA0K

