Return-Path: <kvm+bounces-72512-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cK6ONBevpmn9SgAAu9opvQ
	(envelope-from <kvm+bounces-72512-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 10:51:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E4D21EC1A3
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 10:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03402308979B
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 09:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEAD38E5E1;
	Tue,  3 Mar 2026 09:49:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36AB38C408;
	Tue,  3 Mar 2026 09:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772531389; cv=none; b=OEFSTtjJ9U9ijv/7LebgU/HbzcPcUT54kYDleS99JYPOaFf8QRQJLGexfpTOOi0qJPpaiAKlvucy3EgVsjAW/HL5VWJCxaVBAS4GOQN6b2nArgjJHeJvLQJmkyVDBHX07bVVddukCUpyNVzDWKZ1nYSfIokAZYNOqUQu1WRKgfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772531389; c=relaxed/simple;
	bh=UPCa3+KwUWTSn7dTox9bKP+AeoHdtpML1e/wDp1beOk=;
	h=Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=DnyeF2X++rnWOmqf2etFtjOqeClwFyQvztC5KqYJk/A1acaNubuIHlR4ICcMgQJoZJmMjpv6igZFRd+22ai2fLJS/hui7sxbp8vpOakRRpm2dRh0Lghrz8P9n8I2PnrIr3hjEJEKzJoYm5ENoOL0N9G5qBsBhvc5nEKAHktrHkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fQ9xt5McQz8Xs70;
	Tue, 03 Mar 2026 17:49:38 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
	by mse-fl1.zte.com.cn with SMTP id 6239nV73099331;
	Tue, 3 Mar 2026 17:49:31 +0800 (+08)
	(envelope-from wang.yechao255@zte.com.cn)
Received: from mapi (szxl2zmapp07[null])
	by mapi (Zmail) with MAPI id mid12;
	Tue, 3 Mar 2026 17:49:33 +0800 (CST)
X-Zmail-TransId: 2b0969a6aeadcc7-5b7ad
X-Mailer: Zmail v1.0
Message-ID: <202603031749338756i9Zk0ksst2fK2aco8bo5@zte.com.cn>
In-Reply-To: <CAAhSdy2uJxYX6r1K=EWEqqYoZ1BjJDqkYC+Byv_3Wy65xDyCaw@mail.gmail.com>
References: 20260226172245358qVZavIykLL2QC0KoqTO-I@zte.com.cn,CAAhSdy2uJxYX6r1K=EWEqqYoZ1BjJDqkYC+Byv_3Wy65xDyCaw@mail.gmail.com
Date: Tue, 3 Mar 2026 17:49:33 +0800 (CST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <wang.yechao255@zte.com.cn>
To: <anup@brainfault.org>
Cc: <atish.patra@linux.dev>, <pjw@kernel.org>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFJJU0MtVjogS1ZNOiBGaXggaHVnZXBhZ2UgbWFwcGluZyBoYW5kbGluZyBkdXJpbmcgZGlydHkgbG9nZ2luZw==?=
Content-Type: multipart/mixed;
	boundary="=====_001_next====="
X-MAIL:mse-fl1.zte.com.cn 6239nV73099331
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: wang.yechao255@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Mar 2026 17:49:38 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69A6AEB2.000/4fQ9xt5McQz8Xs70
X-Rspamd-Queue-Id: 1E4D21EC1A3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.74 / 15.00];
	SUBJ_EXCESS_BASE64(1.50)[];
	CTYPE_MIXED_BOGUS(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,multipart/related,multipart/alternative,text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[zte.com.cn : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wang.yechao255@zte.com.cn,kvm@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72512-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	NEURAL_HAM(-0.00)[-0.964];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,zte.com.cn:mid,zte.com.cn:email]
X-Rspamd-Action: no action



--=====_001_next=====
Content-Type: multipart/related;
	boundary="=====_002_next====="


--=====_002_next=====
Content-Type: multipart/alternative;
	boundary="=====_003_next====="


--=====_003_next=====
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: base64

PiBPbiBUaHUsIEZlYiAyNiwgMjAyNiBhdCAyOjUy4oCvUE0gPHdhbmcueWVjaGFvMjU1QHp0ZS5j
b20uY24+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogV2FuZyBZZWNoYW8gPHdhbmcueWVjaGFvMjU1
QHp0ZS5jb20uY24+DQo+ID4NCj4gPiBXaGVuIGRpcnR5IGxvZ2dpbmcgaXMgZW5hYmxlZCwgdGhl
IGdzdGFnZSBwYWdlIHRhYmxlcyBtdXN0IGJlIG1hcHBlZA0KPiA+IGF0IFBBR0VfU0laRSBncmFu
dWxhcml0eSB0byB0cmFjayBkaXJ0eSBwYWdlcyBhY2N1cmF0ZWx5LiBDdXJyZW50bHksDQo+ID4g
aWYgYSBodWdlIFBURSBpcyBlbmNvdW50ZXJlZCBkdXJpbmcgdGhlIHdyaXRlLXByb3RlY3QgZmF1
bHQsIHRoZSBjb2RlDQo+ID4gcmV0dXJucyAtRUVYSVNULCB3aGljaCBicmVha3MgVk0gbWlncmF0
aW9uLg0KPiA+DQo+ID4gSW5zdGVhZCBvZiByZXR1cm5pbmcgYW4gZXJyb3IsIGRyb3AgdGhlIGh1
Z2UgUFRFIGFuZCBtYXAgb25seSB0aGUgcGFnZQ0KPiA+IHRoYXQgaXMgY3VycmVudGx5IGJlaW5n
IGFjY2Vzc2VkLiBUaGlzIG9u4oCRZGVtYW5kIGFwcHJvYWNoIGF2b2lkcyB0aGUNCj4gPiBvdmVy
aGVhZCBvZiBzcGxpdHRpbmcgdGhlIGVudGlyZSBodWdlIHBhZ2UgaW50byBzbWFsbCBwYWdlcyB1
cGZyb250Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogV2FuZyBZZWNoYW8gPHdhbmcueWVjaGFv
MjU1QHp0ZS5jb20uY24+DQo+ID4gLS0tDQo+ID4gIGFyY2gvcmlzY3Yva3ZtL2dzdGFnZS5jIHwg
MiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2t2bS9nc3RhZ2UuYyBiL2FyY2gvcmlz
Y3Yva3ZtL2dzdGFnZS5jDQo+ID4gaW5kZXggYjY3ZDYwZDcyMmMyLi4xNmM4YWZkYWZiZmIgMTAw
NjQ0DQo+ID4gLS0tIGEvYXJjaC9yaXNjdi9rdm0vZ3N0YWdlLmMNCj4gPiArKysgYi9hcmNoL3Jp
c2N2L2t2bS9nc3RhZ2UuYw0KPiA+IEBAIC0xMzQsNyArMTM0LDcgQEAgaW50IGt2bV9yaXNjdl9n
c3RhZ2Vfc2V0X3B0ZShzdHJ1Y3Qga3ZtX2dzdGFnZSAqZ3N0YWdlLA0KPiA+DQo+ID4gICAgICAg
ICB3aGlsZSAoY3VycmVudF9sZXZlbCAhPSBtYXAtPmxldmVsKSB7DQo+ID4gICAgICAgICAgICAg
ICAgIGlmIChnc3RhZ2VfcHRlX2xlYWYocHRlcCkpDQo+ID4gLSAgICAgICAgICAgICAgICAgICAg
ICAgcmV0dXJuIC1FRVhJU1Q7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgc2V0X3B0ZShw
dGVwLCBfX3B0ZSgwKSk7DQo+IA0KPiBNYWtpbmcgYSBsZWFmIFBURSBpbnZhbGlkIG11dCBiZSBm
b2xsb3dlZCBieSBUTEIgaW52YWxpZGF0aW9uDQo+IHVzaW5nIGdzdGFnZV90bGJfZmx1c2goKS4N
Cj4gDQpUaGFuayB5b3UgZm9yIHRoZSByZXZpZXcuIFlvdSBhcmUgcmlnaHQsIEkgbWlzc2VkIHRo
ZSByZXF1aXJlZCBUTEIgaW52YWxpZGF0aW9uLg0KDQo+IEkgdGhpbmsgcmV0dXJuaW5nIC1FRVhJ
U1QgaXMgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvIGhlcmUgYmVjYXVzZQ0KPiBjYWxsZXIgaGFzIHRv
IHNwbGl0IGEgaHVnZSBQVEUgd2l0aCBwcm9wZXIgVExCIGludmFsaWRhdGlvbi4NCj4gDQo+IFJl
Z2FyZHMsDQo+IEFudXANCg0Kb2ssIGxldCB0aGUgY2FsbGVyIHNwbGl0IHRoZSBodWdlIFBURSB3
aXRoIHByb3BlciBUTEIgaW52YWxpZGF0aW9uLg0KSSB3aWxsIHVwZGF0ZSB0aGUgcGF0Y2ggYWNj
b3JkaW5nbHkgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KUmVnYXJkcywNClllY2hhbw==


--=====_003_next=====
Content-Type: text/html ;
	charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBjbGFzcz0iemNvbnRlbnRSb3ciPjxwPiZndDsgT24gVGh1LCBGZWIgMjYsIDIwMjYgYXQg
Mjo1MuKAr1BNICZsdDt3YW5nLnllY2hhbzI1NUB6dGUuY29tLmNuJmd0OyB3cm90ZTo8L3A+PHA+
Jmd0OyAmZ3Q7PC9wPjxwPiZndDsgJmd0OyBGcm9tOiBXYW5nIFllY2hhbyAmbHQ7d2FuZy55ZWNo
YW8yNTVAenRlLmNvbS5jbiZndDs8L3A+PHA+Jmd0OyAmZ3Q7PC9wPjxwPiZndDsgJmd0OyBXaGVu
IGRpcnR5IGxvZ2dpbmcgaXMgZW5hYmxlZCwgdGhlIGdzdGFnZSBwYWdlIHRhYmxlcyBtdXN0IGJl
IG1hcHBlZDwvcD48cD4mZ3Q7ICZndDsgYXQgUEFHRV9TSVpFIGdyYW51bGFyaXR5IHRvIHRyYWNr
IGRpcnR5IHBhZ2VzIGFjY3VyYXRlbHkuIEN1cnJlbnRseSw8L3A+PHA+Jmd0OyAmZ3Q7IGlmIGEg
aHVnZSBQVEUgaXMgZW5jb3VudGVyZWQgZHVyaW5nIHRoZSB3cml0ZS1wcm90ZWN0IGZhdWx0LCB0
aGUgY29kZTwvcD48cD4mZ3Q7ICZndDsgcmV0dXJucyAtRUVYSVNULCB3aGljaCBicmVha3MgVk0g
bWlncmF0aW9uLjwvcD48cD4mZ3Q7ICZndDs8L3A+PHA+Jmd0OyAmZ3Q7IEluc3RlYWQgb2YgcmV0
dXJuaW5nIGFuIGVycm9yLCBkcm9wIHRoZSBodWdlIFBURSBhbmQgbWFwIG9ubHkgdGhlIHBhZ2U8
L3A+PHA+Jmd0OyAmZ3Q7IHRoYXQgaXMgY3VycmVudGx5IGJlaW5nIGFjY2Vzc2VkLiBUaGlzIG9u
4oCRZGVtYW5kIGFwcHJvYWNoIGF2b2lkcyB0aGU8L3A+PHA+Jmd0OyAmZ3Q7IG92ZXJoZWFkIG9m
IHNwbGl0dGluZyB0aGUgZW50aXJlIGh1Z2UgcGFnZSBpbnRvIHNtYWxsIHBhZ2VzIHVwZnJvbnQu
PC9wPjxwPiZndDsgJmd0OzwvcD48cD4mZ3Q7ICZndDsgU2lnbmVkLW9mZi1ieTogV2FuZyBZZWNo
YW8gJmx0O3dhbmcueWVjaGFvMjU1QHp0ZS5jb20uY24mZ3Q7PC9wPjxwPiZndDsgJmd0OyAtLS08
L3A+PHA+Jmd0OyAmZ3Q7Jm5ic3A7IGFyY2gvcmlzY3Yva3ZtL2dzdGFnZS5jIHwgMiArLTwvcD48
cD4mZ3Q7ICZndDsmbmJzcDsgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pPC9wPjxwPiZndDsgJmd0OzwvcD48cD4mZ3Q7ICZndDsgZGlmZiAtLWdpdCBhL2FyY2gv
cmlzY3Yva3ZtL2dzdGFnZS5jIGIvYXJjaC9yaXNjdi9rdm0vZ3N0YWdlLmM8L3A+PHA+Jmd0OyAm
Z3Q7IGluZGV4IGI2N2Q2MGQ3MjJjMi4uMTZjOGFmZGFmYmZiIDEwMDY0NDwvcD48cD4mZ3Q7ICZn
dDsgLS0tIGEvYXJjaC9yaXNjdi9rdm0vZ3N0YWdlLmM8L3A+PHA+Jmd0OyAmZ3Q7ICsrKyBiL2Fy
Y2gvcmlzY3Yva3ZtL2dzdGFnZS5jPC9wPjxwPiZndDsgJmd0OyBAQCAtMTM0LDcgKzEzNCw3IEBA
IGludCBrdm1fcmlzY3ZfZ3N0YWdlX3NldF9wdGUoc3RydWN0IGt2bV9nc3RhZ2UgKmdzdGFnZSw8
L3A+PHA+Jmd0OyAmZ3Q7PC9wPjxwPiZndDsgJmd0OyZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDt3aGlsZSAoY3VycmVudF9sZXZlbCAhPSBtYXAtJmd0O2xldmVsKSB7PC9wPjxwPiZn
dDsgJmd0OyZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7aWYgKGdzdGFnZV9wdGVfbGVhZihwdGVwKSk8L3A+PHA+Jmd0OyAmZ3Q7IC0m
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO3JldHVybiAtRUVYSVNUOzwvcD48cD4mZ3Q7ICZndDsg
KyZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7c2V0X3B0ZShwdGVwLCBfX3B0ZSgwKSk7PC9wPjxw
PiZndDsmbmJzcDs8L3A+PHA+Jmd0OyBNYWtpbmcgYSBsZWFmIFBURSBpbnZhbGlkIG11dCBiZSBm
b2xsb3dlZCBieSBUTEIgaW52YWxpZGF0aW9uPC9wPjxwPiZndDsgdXNpbmcgZ3N0YWdlX3RsYl9m
bHVzaCgpLjwvcD48cD4mZ3Q7Jm5ic3A7PC9wPjxwPlRoYW5rIHlvdSBmb3IgdGhlIHJldmlldy4g
WW91IGFyZSByaWdodCwgSSBtaXNzZWQgdGhlIHJlcXVpcmVkIFRMQiBpbnZhbGlkYXRpb24uPC9w
PjxwPjxicj48L3A+PHA+Jmd0OyBJIHRoaW5rIHJldHVybmluZyAtRUVYSVNUIGlzIHRoZSByaWdo
dCB0aGluZyB0byBkbyBoZXJlIGJlY2F1c2U8L3A+PHA+Jmd0OyBjYWxsZXIgaGFzIHRvIHNwbGl0
IGEgaHVnZSBQVEUgd2l0aCBwcm9wZXIgVExCIGludmFsaWRhdGlvbi48L3A+PHA+Jmd0OyZuYnNw
OzwvcD48cD4mZ3Q7IFJlZ2FyZHMsPC9wPjxwPiZndDsgQW51cDxicj48YnI+PC9wPjxwPm9rLCBs
ZXQgdGhlIGNhbGxlciBzcGxpdCB0aGUgaHVnZSBQVEUgd2l0aCBwcm9wZXIgVExCIGludmFsaWRh
dGlvbi48L3A+PHA+SSB3aWxsIHVwZGF0ZSB0aGUgcGF0Y2ggYWNjb3JkaW5nbHkgaW4gdGhlIG5l
eHQgdmVyc2lvbi48L3A+PHA+PGJyPjwvcD48cD5SZWdhcmRzLDwvcD48cD5ZZWNoYW88L3A+PC9k
aXY+


--=====_003_next=====--

--=====_002_next=====--

--=====_001_next=====--


