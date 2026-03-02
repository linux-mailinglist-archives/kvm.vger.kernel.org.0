Return-Path: <kvm+bounces-72409-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CCeHA2TfpWkvHgAAu9opvQ
	(envelope-from <kvm+bounces-72409-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 20:05:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1F61DE9AE
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 20:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BD1E530406A4
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 19:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E196332906;
	Mon,  2 Mar 2026 19:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Mpm9WO8s"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74D7375ADC;
	Mon,  2 Mar 2026 19:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478276; cv=none; b=jNYT4RfspVatQMsMwjSvcug/8vN5sZxfUwWwLEvXr8yzEilpIgy0hil+1POTqeQLIBasvYzm49fbJHeq/LE7sdDN6CKDesrZXOpKI3y2GtMV4wPTKMCrci4vV9aRHwuDkJdZLmCqXyzYdOYr9/Mrm0FHGAXqstKWxP7Va7+T+Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478276; c=relaxed/simple;
	bh=LUQ9tY/9PUB2akCA2g4Nqja3pQ0wkFh1CmjA/J2R78o=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NnoMMnM6JgTOmp0ljvWjib4i2ggk2Y3BBP9UIai7jI8zouqvbSMNeHR5+iWhjSiWa9QqRwkPAsaj+6/qkDnJlPEZPGgDLQzX/ZGO21IxF5asFfrLNgZBZkDlJ8piMhUnnong5+eUcjxe231i0XesuX6k+syNf2ANJsTxyHEOpw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Mpm9WO8s; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772478270; x=1804014270;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LUQ9tY/9PUB2akCA2g4Nqja3pQ0wkFh1CmjA/J2R78o=;
  b=Mpm9WO8swXMYRuUpcdwbbUAjSOvDTcgPe/55Z+bTW74nv+Nvhp2kLfqY
   2/DZkmy4YSpOe/6mc0Nvy5vu+HgZCynxucb95w9tgZ8Kxp1p62Khi+H4w
   DYkfwhW1b/iOiKx2MqKyU2SoGrrx4HbJrQYaG/qRir1Lu9p3CuC65+dkq
   ELPrZmWURL9ZHvaU2tqexEl6H3ARdRCCfpp4W0pKSZ6wWfE7i4iyQfWkq
   Em7Fs79Otx31/IZdcaIrQ3xwYZ9m+lHQQqVUcPWRX26KWVF+OBJXHOmXf
   KySPBlF6ykx4Q18dHcjUAxT9WFQXg1uI+PDB18ObL+o35CerlwgpsC4pf
   g==;
X-CSE-ConnectionGUID: Zn+U0SiqSyGcwU0I3DWOgA==
X-CSE-MsgGUID: NdVVQds4TIiZdCBU2E3yBQ==
X-IronPort-AV: E=Sophos;i="6.21,320,1763424000"; 
   d="scan'208";a="14003273"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 19:04:28 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:11495]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.39:2525] with esmtp (Farcaster)
 id 6f655c0e-cf62-4b26-ba13-5634a37d9366; Mon, 2 Mar 2026 19:04:27 +0000 (UTC)
X-Farcaster-Flow-ID: 6f655c0e-cf62-4b26-ba13-5634a37d9366
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 2 Mar 2026 19:04:27 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 2 Mar 2026
 19:04:24 +0000
Message-ID: <27dcad4e-d658-4b6b-93b2-44c64fcbeb11@amazon.com>
Date: Mon, 2 Mar 2026 20:04:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vsock: Enable H2G override
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa
	<vishnu.dasa@broadcom.com>, Broadcom internal kernel review list
	<bcm-kernel-feedback-list@broadcom.com>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<kvm@vger.kernel.org>, <eperezma@redhat.com>, Jason Wang
	<jasowang@redhat.com>, <mst@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, <nh-open-source@amazon.com>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat> <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
 <aaW2FgoaXIJEymyR@sgarzare-redhat>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <aaW2FgoaXIJEymyR@sgarzare-redhat>
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: 7C1F61DE9AE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.06 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-72409-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[graf@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

Ck9uIDAyLjAzLjI2IDE3OjI1LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4gT24gTW9uLCBN
YXIgMDIsIDIwMjYgYXQgMDQ6NDg6MzNQTSArMDEwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+
Cj4+IE9uIDAyLjAzLjI2IDEzOjA2LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4+PiBDQ2lu
ZyBCcnlhbiwgVmlzaG51LCBhbmQgQnJvYWRjb20gbGlzdC4KPj4+Cj4+PiBPbiBNb24sIE1hciAw
MiwgMjAyNiBhdCAxMjo0NzowNVBNICswMTAwLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4+
Pj4KPj4+PiBQbGVhc2UgdGFyZ2V0IG5ldC1uZXh0IHRyZWUgZm9yIHRoaXMgbmV3IGZlYXR1cmUu
Cj4+Pj4KPj4+PiBPbiBNb24sIE1hciAwMiwgMjAyNiBhdCAxMDo0MTozOEFNICswMDAwLCBBbGV4
YW5kZXIgR3JhZiB3cm90ZToKPj4+Pj4gVnNvY2sgbWFpbnRhaW5zIGEgc2luZ2xlIENJRCBudW1i
ZXIgc3BhY2Ugd2hpY2ggY2FuIGJlIHVzZWQgdG8KPj4+Pj4gY29tbXVuaWNhdGUgdG8gdGhlIGhv
c3QgKEcySCkgb3IgdG8gYSBjaGlsZC1WTSAoSDJHKS4gVGhlIGN1cnJlbnQgCj4+Pj4+IGxvZ2lj
Cj4+Pj4+IHRyaXZpYWxseSBhc3N1bWVzIHRoYXQgRzJIIGlzIG9ubHkgcmVsZXZhbnQgZm9yIENJ
RCA8PSAyIGJlY2F1c2UgCj4+Pj4+IHRoZXNlCj4+Pj4+IHRhcmdldCB0aGUgaHlwZXJ2aXNvci7C
oCBIb3dldmVyLCBpbiBlbnZpcm9ubWVudHMgbGlrZSBOaXRybyAKPj4+Pj4gRW5jbGF2ZXMsIGFu
Cj4+Pj4+IGluc3RhbmNlIHRoYXQgaG9zdHMgdmhvc3RfdnNvY2sgcG93ZXJlZCBWTXMgbWF5IHN0
aWxsIHdhbnQgdG8gCj4+Pj4+IGNvbW11bmljYXRlCj4+Pj4+IHRvIEVuY2xhdmVzIHRoYXQgYXJl
IHJlYWNoYWJsZSBhdCBoaWdoZXIgQ0lEcyB0aHJvdWdoIAo+Pj4+PiB2aXJ0aW8tdnNvY2stcGNp
Lgo+Pj4+Pgo+Pj4+PiBUaGF0IG1lYW5zIHRoYXQgZm9yIENJRCA+IDIsIHdlIHJlYWxseSB3YW50
IGFuIG92ZXJsYXkuIEJ5IAo+Pj4+PiBkZWZhdWx0LCBhbGwKPj4+Pj4gQ0lEcyBhcmUgb3duZWQg
YnkgdGhlIGh5cGVydmlzb3IuIEJ1dCBpZiB2aG9zdCByZWdpc3RlcnMgYSBDSUQsIGl0IAo+Pj4+
PiB0YWtlcwo+Pj4+PiBwcmVjZWRlbmNlLsKgIEltcGxlbWVudCB0aGF0IGxvZ2ljLiBWaG9zdCBh
bHJlYWR5IGtub3dzIHdoaWNoIENJRHMgaXQKPj4+Pj4gc3VwcG9ydHMgYW55d2F5Lgo+Pj4+Pgo+
Pj4+PiBXaXRoIHRoaXMgbG9naWMsIEkgY2FuIHJ1biBhIE5pdHJvIEVuY2xhdmUgYXMgd2VsbCBh
cyBhIG5lc3RlZCBWTSAKPj4+Pj4gd2l0aAo+Pj4+PiB2aG9zdC12c29jayBzdXBwb3J0IGluIHBh
cmFsbGVsLCB3aXRoIHRoZSBwYXJlbnQgaW5zdGFuY2UgYWJsZSB0bwo+Pj4+PiBjb21tdW5pY2F0
ZSB0byBib3RoIHNpbXVsdGFuZW91c2x5Lgo+Pj4+Cj4+Pj4gSSBob25lc3RseSBkb24ndCB1bmRl
cnN0YW5kIHdoeSBWTUFERFJfRkxBR19UT19IT1NUIChhZGRlZCAKPj4+PiBzcGVjaWZpY2FsbHkg
Zm9yIE5pdHJvIElJUkMpIGlzbid0IGVub3VnaCBmb3IgdGhpcyBzY2VuYXJpbyBhbmQgd2UgCj4+
Pj4gaGF2ZSB0byBhZGQgdGhpcyBjaGFuZ2UuwqAgQ2FuIHlvdSBlbGFib3JhdGUgYSBiaXQgbW9y
ZSBhYm91dCB0aGUgCj4+Pj4gcmVsYXRpb25zaGlwIGJldHdlZW4gdGhpcyBjaGFuZ2UgYW5kIFZN
QUREUl9GTEFHX1RPX0hPU1Qgd2UgYWRkZWQ/Cj4+Cj4+Cj4+IFRoZSBtYWluIHByb2JsZW0gSSBo
YXZlIHdpdGggVk1BRERSX0ZMQUdfVE9fSE9TVCBmb3IgY29ubmVjdCgpIGlzIAo+PiB0aGF0IGl0
IHB1bnRzIHRoZSBjb21wbGV4aXR5IHRvIHRoZSB1c2VyLiBJbnN0ZWFkIG9mIGEgc2luZ2xlIENJ
RCAKPj4gYWRkcmVzcyBzcGFjZSwgeW91IG5vdyBlZmZlY3RpdmVseSBjcmVhdGUgMiBzcGFjZXM6
IE9uZSBmb3IgVE9fSE9TVCAKPj4gKG5lZWRzIGEgZmxhZykgYW5kIG9uZSBmb3IgVE9fR1VFU1Qg
KG5vIGZsYWcpLiBCdXQgZXZlcnkgdXNlciBzcGFjZSAKPj4gdG9vbCBuZWVkcyB0byBsZWFybiBh
Ym91dCB0aGlzIGZsYWcuIFRoYXQgbWF5IHdvcmsgZm9yIHN1cGVyIAo+PiBzcGVjaWFsLWNhc2Ug
YXBwbGljYXRpb25zLiBCdXQgcHJvcGFnYXRpbmcgdGhhdCBhbGwgdGhlIHdheSBpbnRvIAo+PiBz
b2NhdCwgaXBlcmYsIGV0YyBldGM/IEl0J3MganVzdCBjcmVhdGluZyBmcmljdGlvbi4KPgo+IE9r
YXksIEkgd291bGQgbGlrZSB0byBoYXZlIHRoaXMgKG9yIHBhcnQgb2YgaXQpIGluIHRoZSBjb21t
aXQgbWVzc2FnZSAKPiB0byBiZXR0ZXIgZXhwbGFpbiB3aHkgd2Ugd2FudCB0aGlzIGNoYW5nZS4K
Pgo+Pgo+PiBJTUhPIHRoZSBtb3N0IG5hdHVyYWwgZXhwZXJpZW5jZSBpcyB0byBoYXZlIGEgc2lu
Z2xlIENJRCBzcGFjZSwgCj4+IHBvdGVudGlhbGx5IG1hbnVhbGx5IHNlZ21lbnRlZCBieSBsYXVu
Y2hpbmcgVk1zIG9mIG9uZSBraW5kIHdpdGhpbiBhIAo+PiBjZXJ0YWluIHJhbmdlLgo+Cj4gSSBz
ZWUsIGJ1dCBhdCB0aGlzIHBvaW50LCBzaG91bGQgdGhlIGtlcm5lbCBzZXQgVk1BRERSX0ZMQUdf
VE9fSE9TVCBpbiAKPiB0aGUgcmVtb3RlIGFkZHJlc3MgaWYgdGhhdCBwYXRoIGlzIHRha2VuICJh
dXRvbWFnaWNhbGx5IiA/Cj4KPiBTbyBpbiB0aGF0IHdheSB0aGUgdXNlciBzcGFjZSBjYW4gaGF2
ZSBhIHdheSB0byB1bmRlcnN0YW5kIGlmIGl0J3MgCj4gdGFsa2luZyB3aXRoIGEgbmVzdGVkIGd1
ZXN0IG9yIGEgc2libGluZyBndWVzdC4KPgo+Cj4gVGhhdCBzYWlkLCBJJ20gY29uY2VybmVkIGFi
b3V0IHRoZSBzY2VuYXJpbyB3aGVyZSBhbiBhcHBsaWNhdGlvbiBkb2VzIAo+IG5vdCBldmVuIGNv
bnNpZGVyIGNvbW11bmljYXRpbmcgd2l0aCBhIHNpYmxpbmcgVk0uCgoKSWYgdGhhdCdzIHJlYWxs
eSBhIHJlYWxpc3RpYyBjb25jZXJuLCB0aGVuIHdlIHNob3VsZCBhZGQgYSAKVk1BRERSX0ZMQUdf
VE9fR1VFU1QgdGhhdCB0aGUgYXBwbGljYXRpb24gY2FuIHNldC4gRGVmYXVsdCBiZWhhdmlvciBv
ZiAKYW4gYXBwbGljYXRpb24gdGhhdCBwcm92aWRlcyBubyBmbGFncyBpcyAicm91dGUgdG8gd2hh
dGV2ZXIgeW91IGNhbiAKZmluZCI6IElmIHZob3N0IGlzIGxvYWRlZCwgaXQgcm91dGVzIHRvIHZo
b3N0LiBJZiBhIHZzb2NrIGJhY2tlbmQgZHJpdmVyIAppcyBsb2FkZWQsIGl0IHJvdXRlcyB0aGVy
ZS4gQnV0IHRoZSBhcHBsaWNhdGlvbiBoYXMgbm8gc2F5IGluIHdoZXJlIGl0IApnb2VzOiBJdCdz
IHB1cmVseSBhIHN5c3RlbSBjb25maWd1cmF0aW9uIHRoaW5nLgoKCj4gVW50aWwgbm93LCBpdCBr
bmV3IHRoYXQgYnkgbm90IHNldHRpbmcgdGhhdCBmbGFnLCBpdCBjb3VsZCBvbmx5IHRhbGsgCj4g
dG8gbmVzdGVkIFZNcywgc28gaWYgdGhlcmUgd2FzIG5vIFZNIHdpdGggdGhhdCBDSUQsIHRoZSBj
b25uZWN0aW9uIAo+IHNpbXBseSBmYWlsZWQuIFdoZXJlYXMgZnJvbSB0aGlzIHBhdGNoIG9ud2Fy
ZHMsIGlmIHRoZSBkZXZpY2UgaW4gdGhlIAo+IGhvc3Qgc3VwcG9ydHMgc2libGluZyBWTXMgYW5k
IHRoZXJlIGlzIGEgVk0gd2l0aCB0aGF0IENJRCwgdGhlIAo+IGFwcGxpY2F0aW9uIGZpbmRzIGl0
c2VsZiB0YWxraW5nIHRvIGEgc2libGluZyBWTSBpbnN0ZWFkIG9mIGEgbmVzdGVkIAo+IG9uZSwg
d2l0aG91dCBoYXZpbmcgYW55IGlkZWEuCgoKSSdkIHNheSBhbiBhcHBsaWNhdGlvbiB0aGF0IGF0
dGVtcHRzIHRvIHRhbGsgdG8gYSBDSUQgdGhhdCBpdCBkb2VzIG5vdyAKa25vdyB3aGV0aGVyIGl0
J3Mgdmhvc3Qgcm91dGVkIG9yIG5vdCBpcyBydW5uaW5nIGludG8gInVuZGVmaW5lZCIgCnRlcnJp
dG9yeS4gSWYgeW91IHJtbW9kIHRoZSB2aG9zdCBkcml2ZXIsIGl0IHdvdWxkIGFsc28gdGFsayB0
byB0aGUgCmh5cGVydmlzb3IgcHJvdmlkZWQgdnNvY2suCgoKPiBTaG91bGQgd2UgbWFrZSB0aGlz
IGZlYXR1cmUgb3B0LWluIGluIHNvbWUgd2F5LCBzdWNoIGFzIHNvY2tvcHQgb3IgCj4gc3lzY3Rs
PyAoSSB1bmRlcnN0YW5kIHRoYXQgdGhlcmUgaXMgdGhlIHByZXZpb3VzIHByb2JsZW0sIGJ1dCAK
PiBob25lc3RseSwgaXQgc2VlbXMgbGlrZSBhIHNpZ25pZmljYW50IGNoYW5nZSB0byB0aGUgYmVo
YXZpb3Igb2YgCj4gQUZfVlNPQ0spLgoKCldlIGNhbiBjcmVhdGUgYSBzeXNjdGwgdG8gZW5hYmxl
IGJlaGF2aW9yIHdpdGggZGVmYXVsdD1vbi4gQnV0IEknbSAKYWdhaW5zdCBtYWtpbmcgdGhlIGN1
bWJlcnNvbWUgZG9lcy1ub3Qtd29yay1vdXQtb2YtdGhlLWJveCBleHBlcmllbmNlIAp0aGUgZGVm
YXVsdC4gV2lsbCBpbmNsdWRlIGl0IGluIHYyLgoKCj4KPj4KPj4gQXQgdGhlIGVuZCBvZiB0aGUg
ZGF5LCB0aGUgaG9zdCB2cyBndWVzdCBwcm9ibGVtIGlzIHN1cGVyIHNpbWlsYXIgdG8gCj4+IGEg
cm91dGluZyB0YWJsZS4KPgo+IFllYWgsIGJ1dCB0aGUgcG9pbnQgb2YgQUZfVlNPQ0sgaXMgcHJl
Y2lzZWx5IHRvIGF2b2lkIGNvbXBsZXhpdGllcyAKPiBzdWNoIGFzIHJvdXRpbmcgdGFibGVzIGFz
IG11Y2ggYXMgcG9zc2libGU7IG90aGVyd2lzZSwgQUZfSU5FVCBpcyAKPiBhbHJlYWR5IHRoZXJl
IGFuZCByZWFkeSB0byBiZSB1c2VkLiBJbiB0aGVvcnksIHdlIG9ubHkgd2FudCAKPiBjb21tdW5p
Y2F0aW9uIGJldHdlZW4gaG9zdCBhbmQgZ3Vlc3QuCgoKWWVzLCBidXQgbmVzdGluZyBpcyBhIHRo
aW5nIGFuZCBub2JvZHkgdGhvdWdodCBhYm91dCBpdCA6KS4gSW4gCnJldHJvc3BlY3QsIGl0IHdv
dWxkIGhhdmUgYmVlbiB0byBhbm5vdGF0ZSB0aGUgQ0lEIHdpdGggdGhlIGRpcmVjdGlvbjogCkg1
IGdvZXMgdG8gQ0lENSBvbiBob3N0IGFuZCBHNSBnb2VzIHRvIENJRDUgb24gZ3Vlc3QuIEJ1dCBJ
IHNlZSBubyAKY2hhbmNlIHRvIGNoYW5nZSB0aGF0IGJ5IG5vdy4KCgpBbGV4CgoKCgpBbWF6b24g
V2ViIFNlcnZpY2VzIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKVGFtYXJhLURhbnot
U3RyLiAxMwoxMDI0MyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RvZiBIZWxsbWlz
LCBBbmRyZWFzIFN0aWVnZXIKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1
cmcgdW50ZXIgSFJCIDI1Nzc2NCBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDM2NSA1MzggNTk3
Cg==


