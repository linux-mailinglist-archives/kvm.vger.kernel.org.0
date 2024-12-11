Return-Path: <kvm+bounces-33484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F859ECDB6
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 14:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCEA0285AF2
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 13:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E2C2336A1;
	Wed, 11 Dec 2024 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="hetyYy/u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3D11A83F4
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733925244; cv=none; b=idENBhu7FZl4cQjGFqJ/nHMQbdOBYvjErhAA2wQ5kiWbWn1+lA5mXPWPSmY7NaqoO5/EJWeIAESrcHSkOyvspQcZWN8Hzp2yO9LsrPalAI7+u+oWlM7G9j7j9Pe+4YpdR+xqQkelOUr4JF7DJz55g9AK4g4FJowAwSGb/cA/Ckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733925244; c=relaxed/simple;
	bh=AAxMcK/zOJpDjsCKvbb2kgxXM3y0700vA3GS29YOS3k=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LQ1QRA/K3704jakxNsqjw8/9fpmcjH3kHLZ9uXZ+tpwYUcWX99ROKQBO7ZEuPR9DLoqhMHIJ5jBSjl1xWJFZM6RFrOo65Eb2v+5Q0U7B7F8oTGzB0c/r23qiCsZ0BYpjnzsnJVbCB1N2VaNx3rg/BFybT5vZBZZibfkej9Q3HwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=hetyYy/u; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1733925243; x=1765461243;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=AAxMcK/zOJpDjsCKvbb2kgxXM3y0700vA3GS29YOS3k=;
  b=hetyYy/uGhjxoEl9npc4EfgIZrRSB4LzzsL42nlQM8StLvW00JcuQzvx
   fFarlYFNOfS5xYz+F7/WIWFGd+R2aawZMWTJjLrv9p52i5QgKJi+NyW7b
   KOIGEWyEi8bvPoKlDdI0Z7rmGZqNHKYoP2LHNidM3ZEJnMb2ACLvLKb93
   I=;
X-IronPort-AV: E=Sophos;i="6.12,225,1728950400"; 
   d="scan'208";a="152165265"
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2024-12-12
Thread-Topic: [Invitation] bi-weekly guest_memfd upstream call on 2024-12-12
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 13:54:01 +0000
Received: from EX19MTAUEB002.ant.amazon.com [10.0.29.78:27959]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.4.68:2525] with esmtp (Farcaster)
 id 9670fd6a-4c72-4943-be7c-90f9c3ccce4c; Wed, 11 Dec 2024 13:54:00 +0000 (UTC)
X-Farcaster-Flow-ID: 9670fd6a-4c72-4943-be7c-90f9c3ccce4c
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Dec 2024 13:54:00 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Dec 2024 13:53:59 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1258.034; Wed, 11 Dec 2024 13:53:59 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"david@redhat.com" <david@redhat.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>
CC: "Graf (AWS), Alexander" <graf@amazon.de>, "Woodhouse, David"
	<dwmw@amazon.co.uk>
Thread-Index: AQHbSw+rAieshI2T/k+hj7D4Kl92M7LhEhqA
Date: Wed, 11 Dec 2024 13:53:59 +0000
Message-ID: <7b5c8e67c48e082ed5c96bba2d536c9301fef8ef.camel@amazon.com>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
	 <3a544ba8-85cd-4b91-940f-85f6f07f2085@redhat.com>
	 <b9567cbf-8ad7-440a-8768-f4e7dbd2b5f7@redhat.com>
In-Reply-To: <b9567cbf-8ad7-440a-8768-f4e7dbd2b5f7@redhat.com>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE8E7B53D8855E4792D309777CC1F650@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDI0LTEyLTEwIGF0IDE1OjI1ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gSW4gdGhpcyBtZWV0aW5nIHdlJ2xsIGxpa2VseSBkaXNjdXNzOg0KPiDCoCAqIFBhdHJp
Y2s6IEtWTSBnbWVtIE1NSU8gYWNjZXNzIGNoYWxsZW5nZXMgYW5kIEtWTV9YODZfU1dfUFJPVEVD
VEVEX1ZNDQo+IMKgwqDCoCBmb3IgYXJtDQo+IMKgICogQW5lZXNoOiBGZWFzaWJpbGl0eSBvZiA0
IEtpQiBndWVzdHMgb24gNjQgS2lCIGhvc3QNCj4gwqAgKiBQZXJzaXN0aW5nIGd1ZXN0X21lbWZk
IGFjcm9zcyByZWJvb3QgLyBndWVzdF9tZW1mcyAoaWYgSmFtZXMgaXMgYXJvdW5kKQ0KDQpJIHNo
b3VsZCBiZSBhcm91bmQgYW5kIHdpbGwgYmUga2VlbiB0byBkaXNjdXNzIHRoaXMuIFdoZXJlIHdl
IGxhbmRlZA0KbGFzdCBvbiB0aGlzIHRvcGljIHdhcyB0aGF0IGd1ZXN0bWVtZnMgc2hvdWxkIGJl
IG1vZGlmaWVkIHRvIHVzZSB0aGUNCmd1ZXN0X21lbWZkIGxpYnJhcnkgY29kZSB0byBpbnN0YW50
aWF0ZSBhIHJlYWwgZ3Vlc3RfbWVtZmQgZmlsZSB3aGVuIGENCmd1ZXN0bWVtZnMgZmlsZSBpcyBv
cGVuZWQuIEVzc2VudGlhbGx5IHRoZSBndWVzdG1lbWZzIHBlcnNpc3RlbmNlIHdpbGwNCm1vc3Rs
eSBiZSBhIGN1c3RvbSBhbGxvY2F0b3IgYmVoaW5kIHRoZSBpbi1kZXZlbG9wbWVudCBndWVzdF9t
ZW1mZA0KbGlicmFyeSBjb2RlLCBpbmNsdWRpbmcgdGhlIGFiaWxpdHkgdG8gcmVzdG9yZSBndWVz
dF9tZW1mZCBtYXBwaW5ncyB3aGVuDQpyZS1vcGVuaW5nIHRoZSBmaWxlIGFmdGVyIGtleGVjLg0K
DQpUaGUgbWFpbiBkZXBlbmRlbmN5IGhlcmUgaXMgb24gdGhlIGd1ZXN0X21lbWZkIGxpYnJhcnkg
ZWZmb3J0Lg0KRGlzY3Vzc2lvbiBvbiBob3cgdGhhdCdzIGdvaW5nIGFuZCBtYWtpbmcgc3VyZSB0
aGF0IHRoZSBndWVzdG1lbWZzDQpwZXJzaXN0ZW5jZSB1c2UgY2FzZSBpcyBjb3ZlcmVkIHdpbGwg
YmUgdXNlZnVsLiANCg0KV2UgbmVlZCB0byBtYWtlIHN1cmUgdGhhdCB0aGUgZ3Vlc3RfbWVtZmQg
bGlicmFyeSBzdXBwb3J0czoNCjEuIERlZmluaW5nIGEgY3VzdG9tIGFsbG9jYXRvciBvdGhlciB0
aGFuIGJ1ZGR5LWxpc3QgbWFuYWdlZCBwYWdlcyBzbw0KdGhhdCBhIHBlcnNpc3RlbnQgcmVzZXJ2
ZWQgbWVtb3J5IHBvb2wgY2FuIGJlIHVzZWQuDQoyLiBCZWluZyBhYmxlIHRvIHJlLWRyaXZlIG9y
IGZhdWx0IGluIG1hcHBpbmdzIGZvciBhIGZpbGUgYWZ0ZXIga2V4ZWMuDQpJbiBhbGwgbGlrZWxp
aG9vZCB0aGUgYWxsb2NhdG9yIGNvZGUgcGF0aCBhbmQgZXF1YWxseSByZXN0b3JlIHByZXZpb3Vz
bHkNCmFsbG9jYXRlZCBwYWdlcy4NCjMuIFN1cHBvcnQgaHVnZS9naWdhbnRpYyBtYXBwaW5ncw0K
NC4gU3VwcG9ydCBtbWFwaW5nIHRoZSBndWVzdF9tZW1mZCBmaWxlOyBmb3Igbm9uLUNvQ28gVk1z
IHRoaXMgd2lsbCBiZQ0KbmVjZXNzYXJ5IGZvciBQViBkZXZpY2VzLiBJIHJlYWxpc2UgdGhhdCB0
aGlzIGlzIGEgd2hvbGUgY2FuIG9mIHdvcm1zDQpjdXJyZW50bHkgdW5kZXIgZGlzY3Vzc2lvbiBh
bmQgbm90IHNwZWNpZmljIHRvIHRoaXMgdXNlIGNhc2UuDQoNClNvLCBsZXQncyBzb2NpYWxpc2Ug
dGhpcyByZXZpc2VkIGd1ZXN0bWVtZnMgYXBwcm9hY2gsIGFuZCBuZXh0IHN0ZXBzIGZvcg0KdGhl
IGxpYnJhcnkgZGV2ZWxvcG1lbnQuDQoNCj4gDQo+IEFuZCB3ZSdsbCBjb250aW51ZSBvdXIgZGlz
Y3Vzc2lvbiBvbjoNCj4gwqAgKiBDaGFsbGVuZ2VzIHdpdGggc3VwcG9ydGluZyBodWdlIHBhZ2Vz
DQo+IMKgICogQ2hhbGxlbmdlcyB3aXRoIHNoYXJlZCB2cy4gcHJpdmF0ZSBjb252ZXJzaW9uDQo+
IMKgICogZ3Vlc3RfbWVtZmQgYXMgYSAibGlicmFyeSINCg0KDQpKRw0KCgoKQW1hem9uIERldmVs
b3BtZW50IENlbnRyZSAoU291dGggQWZyaWNhKSAoUHJvcHJpZXRhcnkpIExpbWl0ZWQKMjkgR29n
b3NvYSBTdHJlZXQsIE9ic2VydmF0b3J5LCBDYXBlIFRvd24sIFdlc3Rlcm4gQ2FwZSwgNzkyNSwg
U291dGggQWZyaWNhClJlZ2lzdHJhdGlvbiBOdW1iZXI6IDIwMDQgLyAwMzQ0NjMgLyAwNwo=


