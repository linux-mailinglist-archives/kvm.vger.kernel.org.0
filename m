Return-Path: <kvm+bounces-23477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADA5949FB6
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 08:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45C352816ED
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 06:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C931B1428;
	Wed,  7 Aug 2024 06:18:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8B91AE051
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 06:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723011504; cv=none; b=oIx8Fv3ry7WHL6wFGu2wXrMALL5mYPAwEFZXuZ7Aheq6tl69DRi6RMK9UVdphA6Qd+eooT4dSTK7/yaIvFkJrrr3gJ7naXNTM9MGwJyGEjjHGoXnjX2ZwtxmZC3VqzM48IzTDCZCgUWyrhAc373fm9qdKzgEvYmI9vUgx0PsO7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723011504; c=relaxed/simple;
	bh=osHDsM5Z8DaffQH7RfphXG6spDDOnwPVnZnuNG16tx8=;
	h=From:Subject:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=NXzQr5m5wY0+HZWX0xlrUpNUlQJYH9Rs7Vwm6PFR23bY8HI0KOs3iOaLrhDTx692m+CBuTdtGD0E4lBNTer2f0Ey+JpXtl01f8G7VMZjcodZNipDFHoVMjfBBqXvAsN9ZhcrREPq2Ubyd2EjRWyh2G3MIKoYHjKUPnesH/9ufMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d2173e90548411efa216b1d71e6e1362-20240807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:d2c3d42f-b50f-46a5-a29c-c52deec59e83,IP:0,U
	RL:0,TC:13,Content:-25,EDM:0,RT:0,SF:0,FILE:5,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-7
X-CID-META: VersionHash:82c5f88,CLOUDID:8538a742d9752adafdde4ed71e59ca3d,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:0,Content:0,EDM:-3,IP:nil,URL:0,F
	ile:2,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,D
	KR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: d2173e90548411efa216b1d71e6e1362-20240807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <leixiang@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 882340828; Wed, 07 Aug 2024 14:18:10 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id AD32AE000EB9;
	Wed,  7 Aug 2024 14:18:10 +0800 (CST)
Received: by mail.kylinos.cn (NSMail, from userid 0)
	id 9921EE000EB9; Wed,  7 Aug 2024 14:18:10 +0800 (CST)
From: =?UTF-8?B?6Zu357+U?= <leixiang@kylinos.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0ga3ZtIHRvb2xzOkZpeCBtZW1vcnkgbGVha2FnZSBpbiBvcGVuIGFsbCBkaXNrcw==?=
To: 	=?UTF-8?B?QWxleGFuZHJ1IEVsaXNlaQ==?= <alexandru.elisei@arm.com>,
	=?UTF-8?B?V2lsbCBEZWFjb24=?= <will@kernel.org>,
Cc: 	=?UTF-8?B?anVsaWVuLnRoaWVycnkua2Rldg==?= <julien.thierry.kdev@gmail.com>,
	=?UTF-8?B?a3Zt?= <kvm@vger.kernel.org>,
	=?UTF-8?B?6LCi5piO?= <xieming@kylinos.cn>,
Date: Wed, 07 Aug 2024 14:18:10 +0800
X-Mailer: NSMAIL 7.0.0
Message-ID: <ek8d72armd-ek9n4vptg6@nsmail7.0.0--kylin--1>
X-Israising: 0
X-Seclevel-1: 0
X-Seclevel: 0
X-Delaysendtime: Wed, 07 Aug 2024 14:18:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=nsmail-li29ugwhg8-li3jsabja1
X-ns-mid: webmail-66b311a2-hbhff4wv
X-ope-from: <leixiang@kylinos.cn>

This message is in MIME format.

--nsmail-li29ugwhg8-li3jsabja1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBjbGFzcz0idmlld2VyX3BhcnQiIHN0eWxlPSJwb3NpdGlvbjogcmVs
YXRpdmU7Ij4KPGRpdj5JIGFsc28gdGhpbmsgdGhpcyBtb2RpZmljYXRpb24g
c3VnZ2VzdGlvbiBpcyBiZXR0ZXIuPGJyPlNvIEkgaW5jb3Jwb3JhdGVkIHRo
ZSBtb2RpZmljYXRpb24gc3VnZ2VzdGlvbnMgaW50byB0aGUgcGF0Y2gsPGJy
PmhvcGluZyB0byBiZSBhY2NlcHRlZC48YnI+PGJyPk9uIDIwMjQvOC82IDIw
OjQ4LCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOjxicj4mZ3Q7IEhpIFdpbGws
PGJyPiZndDsgPGJyPiZndDsgT24gTW9uLCBBdWcgMDUsIDIwMjQgYXQgMDE6
Mjc6NDlQTSArMDEwMCwgV2lsbCBEZWFjb24gd3JvdGU6PGJyPiZndDsmZ3Q7
IE9uIFdlZCwgSnVsIDEwLCAyMDI0IGF0IDA2OjAwOjUzUE0gKzA4MDAsIGxl
aXhpYW5nIHdyb3RlOjxicj4mZ3Q7Jmd0OyZndDsgRnJvbSA1NmI2MGNmNzBh
MGM1ZjdjZGFmZTY4MDRkYWJiZTcxMTJjMTBmN2ExIE1vbiBTZXAgMTcgMDA6
MDA6MDAgMjAwMTxicj4mZ3Q7Jmd0OyZndDsgRnJvbTogbGVpeGlhbmcgPGJy
PiZndDsmZ3Q7Jmd0OyBEYXRlOiBXZWQsIDEwIEp1bCAyMDI0IDE3OjQ1OjUx
ICswODAwPGJyPiZndDsmZ3Q7Jmd0OyBTdWJqZWN0OiBbUEFUQ0ggdjNdIGt2
bXRvb2w6ZGlzay9jb3JlOkZpeCBtZW1vcnkgbGVha2FnZSBpbiBvcGVuIGFs
bCBkaXNrczxicj4mZ3Q7Jmd0OyZndDs8YnI+Jmd0OyZndDsmZ3Q7IEZpeCBt
ZW1vcnkgbGVha2FnZSBpbiBkaXNrL2NvcmUgZGlza19pbWFnZV9fb3Blbl9h
bGwgd2hlbiBtYWxsb2MgZGlzayBmYWlsZWQsPGJyPiZndDsmZ3Q7Jmd0OyBz
aG91bGQgZnJlZSB0aGUgZGlza3MgdGhhdCBhbHJlYWR5IG1hbGxvY2VkLjxi
cj4mZ3Q7Jmd0OyZndDsgQW5kIHRvIGF2b2lkIGZpZWxkcyBub3QgYmVpbmcg
aW5pdGlhbGl6ZWQgaW4gc3RydWN0IGRpc2tfaW1hZ2UsPGJyPiZndDsmZ3Q7
Jmd0OyByZXBsYWNlIG1hbGxvYyB3aXRoIGNhbGxvYy48YnI+Jmd0OyZndDsm
Z3Q7PGJyPiZndDsmZ3Q7Jmd0OyBTaWduZWQtb2ZmLWJ5OiBMZWkgWGlhbmcg
PGJyPiZndDsmZ3Q7Jmd0OyBTdWdnZXN0ZWQtYnk6IFhpZSBNaW5nIDxicj4m
Z3Q7Jmd0OyZndDsgLS0tPGJyPiZndDsmZ3Q7Jmd0OyBkaXNrL2NvcmUuYyB8
IDggKysrKystLS08YnI+Jmd0OyZndDsmZ3Q7IDEgZmlsZSBjaGFuZ2VkLCA1
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pPGJyPiZndDsmZ3Q7Jmd0
Ozxicj4mZ3Q7Jmd0OyZndDsgZGlmZiAtLWdpdCBhL2Rpc2svY29yZS5jIGIv
ZGlzay9jb3JlLmM8YnI+Jmd0OyZndDsmZ3Q7IGluZGV4IGIwMGIwYzAuLmEw
ODRjZDQgMTAwNjQ0PGJyPiZndDsmZ3Q7Jmd0OyAtLS0gYS9kaXNrL2NvcmUu
Yzxicj4mZ3Q7Jmd0OyZndDsgKysrIGIvZGlzay9jb3JlLmM8YnI+Jmd0OyZn
dDsmZ3Q7IEBAIC0xNzAsOSArMTcwLDExIEBAIHN0YXRpYyBzdHJ1Y3QgZGlz
a19pbWFnZSAqKmRpc2tfaW1hZ2VfX29wZW5fYWxsKHN0cnVjdCBrdm0gKmt2
bSk8YnI+Jmd0OyZndDsmZ3Q7IHd3cG4gPSBwYXJhbXNbaV0ud3dwbjs8YnI+
Jmd0OyZndDsmZ3Q7IDxicj4mZ3Q7Jmd0OyZndDsgaWYgKHd3cG4pIHs8YnI+
Jmd0OyZndDsmZ3Q7IC0gZGlza3NbaV0gPSBtYWxsb2Moc2l6ZW9mKHN0cnVj
dCBkaXNrX2ltYWdlKSk7PGJyPiZndDsmZ3Q7Jmd0OyAtIGlmICghZGlza3Nb
aV0pPGJyPiZndDsmZ3Q7Jmd0OyAtIHJldHVybiBFUlJfUFRSKC1FTk9NRU0p
Ozxicj4mZ3Q7Jmd0OyZndDsgKyBkaXNrc1tpXSA9IGNhbGxvYygxLCBzaXpl
b2Yoc3RydWN0IGRpc2tfaW1hZ2UpKTs8YnI+Jmd0OyZndDsmZ3Q7ICsgaWYg
KCFkaXNrc1tpXSkgezxicj4mZ3Q7Jmd0OyZndDsgKyBlcnIgPSBFUlJfUFRS
KC1FTk9NRU0pOzxicj4mZ3Q7Jmd0OyZndDsgKyBnb3RvIGVycm9yOzxicj4m
Z3Q7Jmd0OyZndDsgKyB9PGJyPiZndDsmZ3Q7Jmd0OyBkaXNrc1tpXS0mZ3Q7
d3dwbiA9IHd3cG47PGJyPiZndDsmZ3Q7Jmd0OyBjb250aW51ZTs8YnI+Jmd0
OyZndDs8YnI+Jmd0OyZndDsgSG1tLCBJJ20gc3RpbGwgbm90IHN1cmUgYWJv
dXQgdGhpcy4gSSBkb24ndCB0aGluayB3ZSBzaG91bGQgY2FsbDxicj4mZ3Q7
Jmd0OyBkaXNrX2ltYWdlX19jbG9zZSgpIGZvciBkaXNrcyB0aGF0IHdlcmVu
J3QgYWxsb2NhdGVkIHZpYTxicj4mZ3Q7Jmd0OyBkaXNrX2ltYWdlX19vcGVu
KCkuIFVzaW5nIGNhbGxvYygpIG1pZ2h0IHdvcmssIGJ1dCBpdCBmZWVscyBm
cmFnaWxlLjxicj4mZ3Q7Jmd0Ozxicj4mZ3Q7Jmd0OyBJbnN0ZWFkLCBjYW4g
d2UgY2hhbmdlIHRoZSBlcnJvciBoYW5kbGluZyB0byBkbyBzb21ldGhpbmcg
bGlrZSBiZWxvdz88YnI+Jmd0OyZndDs8YnI+Jmd0OyZndDsgV2lsbDxicj4m
Z3Q7Jmd0Ozxicj4mZ3Q7Jmd0OyAtLS0mZ3Q7ODxicj4mZ3Q7Jmd0Ozxicj4m
Z3Q7Jmd0OyBkaWZmIC0tZ2l0IGEvZGlzay9jb3JlLmMgYi9kaXNrL2NvcmUu
Yzxicj4mZ3Q7Jmd0OyBpbmRleCBiMDBiMGMwLi5iNTQzZDQ0IDEwMDY0NDxi
cj4mZ3Q7Jmd0OyAtLS0gYS9kaXNrL2NvcmUuYzxicj4mZ3Q7Jmd0OyArKysg
Yi9kaXNrL2NvcmUuYzxicj4mZ3Q7Jmd0OyBAQCAtMTcxLDggKzE3MSwxMSBA
QCBzdGF0aWMgc3RydWN0IGRpc2tfaW1hZ2UgKipkaXNrX2ltYWdlX19vcGVu
X2FsbChzdHJ1Y3Qga3ZtICprdm0pPGJyPiZndDsmZ3Q7IDxicj4mZ3Q7Jmd0
OyBpZiAod3dwbikgezxicj4mZ3Q7Jmd0OyBkaXNrc1tpXSA9IG1hbGxvYyhz
aXplb2Yoc3RydWN0IGRpc2tfaW1hZ2UpKTs8YnI+Jmd0OyZndDsgLSBpZiAo
IWRpc2tzW2ldKTxicj4mZ3Q7Jmd0OyAtIHJldHVybiBFUlJfUFRSKC1FTk9N
RU0pOzxicj4mZ3Q7Jmd0OyArIGlmICghZGlza3NbaV0pIHs8YnI+Jmd0OyZn
dDsgKyBlcnIgPSBFUlJfUFRSKC1FTk9NRU0pOzxicj4mZ3Q7Jmd0OyArIGdv
dG8gZXJyb3I7PGJyPiZndDsmZ3Q7ICsgfTxicj4mZ3Q7Jmd0OyArPGJyPiZn
dDsmZ3Q7IGRpc2tzW2ldLSZndDt3d3BuID0gd3dwbjs8YnI+Jmd0OyZndDsg
Y29udGludWU7PGJyPiZndDsmZ3Q7IH08YnI+Jmd0OyZndDsgQEAgLTE5MSw5
ICsxOTQsMTUgQEAgc3RhdGljIHN0cnVjdCBkaXNrX2ltYWdlICoqZGlza19p
bWFnZV9fb3Blbl9hbGwoc3RydWN0IGt2bSAqa3ZtKTxicj4mZ3Q7Jmd0OyA8
YnI+Jmd0OyZndDsgcmV0dXJuIGRpc2tzOzxicj4mZ3Q7Jmd0OyBlcnJvcjo8
YnI+Jmd0OyZndDsgLSBmb3IgKGkgPSAwOyBpICZndDsmZ3Q7IC0gaWYgKCFJ
U19FUlJfT1JfTlVMTChkaXNrc1tpXSkpPGJyPiZndDsmZ3Q7ICsgZm9yIChp
ID0gMDsgaSAmZ3Q7Jmd0OyArIGlmIChJU19FUlJfT1JfTlVMTChkaXNrc1tp
XSkpPGJyPiZndDsmZ3Q7ICsgY29udGludWU7PGJyPiZndDsmZ3Q7ICs8YnI+
Jmd0OyZndDsgKyBpZiAoZGlza3NbaV0tJmd0O3d3cG4pPGJyPiZndDsmZ3Q7
ICsgZnJlZShkaXNrc1tpXSk7PGJyPiZndDsmZ3Q7ICsgZWxzZTxicj4mZ3Q7
Jmd0OyBkaXNrX2ltYWdlX19jbG9zZShkaXNrc1tpXSk7PGJyPiZndDsmZ3Q7
ICsgfTxicj4mZ3Q7Jmd0OyA8YnI+Jmd0OyZndDsgZnJlZShkaXNrcyk7PGJy
PiZndDsmZ3Q7IHJldHVybiBlcnI7PGJyPiZndDsmZ3Q7PGJyPiZndDsmZ3Q7
PGJyPiZndDsmZ3Q7Jmd0OyB9PGJyPiZndDsgPGJyPiZndDsgVGhpcyBsb29r
cyBtdWNoIGJldHRlciB0aGFuIG15IHN1Z2dlc3Rpb24uPGJyPiZndDsgPGJy
PiZndDsgVGhhbmtzLDxicj4mZ3Q7IEFsZXg8L2Rpdj4KPC9kaXY+CjxwPiZu
YnNwOzwvcD4KPHA+Jm5ic3A7PC9wPgo8cD4tLS0tPC9wPgo8ZGl2IGlkPSJj
czJjX21haWxfc2lnYXR1cmUiPjwvZGl2Pgo8cD4mbmJzcDs8L3A+CjxwPiZu
YnNwOzwvcD4KPHA+Jm5ic3A7PC9wPg==

--nsmail-li29ugwhg8-li3jsabja1
Content-Type: application/octet-stream; name="=?UTF-8?B?djQtMDAwMS1rdm10b29sLWRpc2stY29yZS1GaXgtbWVtb3J5LWxlYWthZ2UtaW4tb3Blbi1hbGwtLnBhdGNo?="
Content-Transfer-Encoding: base64
Content-Disposition: attachment; size=2028; seclevel=1; filename="=?UTF-8?B?djQtMDAwMS1rdm10b29sLWRpc2stY29yZS1GaXgtbWVtb3J5LWxlYWthZ2UtaW4tb3Blbi1hbGwtLnBhdGNo?="
X-Seclevel-1: 1
X-Seclevel: 0

RnJvbSBmOWViYmU0MTJjZmZhZmJmMDZjNzM4MzM2ZWU0NTk0MmQ3YzE5NzdmIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBsZWl4aWFuZyA8bGVpeGlhbmdAa3lsaW5vcy5jbj4K
RGF0ZTogV2VkLCAxMCBKdWwgMjAyNCAxNzo0NTo1MSArMDgwMApTdWJqZWN0OiBbUEFUQ0gg
djRdIGt2bXRvb2w6ZGlzay9jb3JlOkZpeCBtZW1vcnkgbGVha2FnZSBpbiBvcGVuIGFsbCBk
aXNrcwoKRml4IG1lbW9yeSBsZWFrYWdlIGluIGRpc2svY29yZSBkaXNrX2ltYWdlX19vcGVu
X2FsbCB3aGVuIG1hbGxvYyBkaXNrIGZhaWxlZCwKc2hvdWxkIGZyZWUgdGhlIGRpc2tzIHRo
YXQgYWxyZWFkeSBtYWxsb2NlZC4KClNpZ25lZC1vZmYtYnk6IExlaSBYaWFuZyA8bGVpeGlh
bmdAa3lsaW5vcy5jbj4KU3VnZ2VzdGVkLWJ5OiBYaWUgTWluZyA8eGllbWluZ0BreWxpbm9z
LmNuPgpTdWdnZXN0ZWQtYnk6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlA
YXJtLmNvbT4KU3VnZ2VzdGVkLWJ5OiBXaWxsIERlYWNvbiA8d2lsbEBrZXJuZWwub3JnPgot
LS0KIGRpc2svY29yZS5jIHwgMTcgKysrKysrKysrKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAxMiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Rpc2sv
Y29yZS5jIGIvZGlzay9jb3JlLmMKaW5kZXggYjAwYjBjMC4uOTFkYjI3NyAxMDA2NDQKLS0t
IGEvZGlzay9jb3JlLmMKKysrIGIvZGlzay9jb3JlLmMKQEAgLTE3MSw4ICsxNzEsMTAgQEAg
c3RhdGljIHN0cnVjdCBkaXNrX2ltYWdlICoqZGlza19pbWFnZV9fb3Blbl9hbGwoc3RydWN0
IGt2bSAqa3ZtKQogCiAJCWlmICh3d3BuKSB7CiAJCQlkaXNrc1tpXSA9IG1hbGxvYyhzaXpl
b2Yoc3RydWN0IGRpc2tfaW1hZ2UpKTsKLQkJCWlmICghZGlza3NbaV0pCi0JCQkJcmV0dXJu
IEVSUl9QVFIoLUVOT01FTSk7CisJCQlpZiAoIWRpc2tzW2ldKSB7CisJCQkJZXJyID0gRVJS
X1BUUigtRU5PTUVNKTsKKwkJCQlnb3RvIGVycm9yOworCQkJfQogCQkJZGlza3NbaV0tPnd3
cG4gPSB3d3BuOwogCQkJY29udGludWU7CiAJCX0KQEAgLTE5MSwxMCArMTkzLDE1IEBAIHN0
YXRpYyBzdHJ1Y3QgZGlza19pbWFnZSAqKmRpc2tfaW1hZ2VfX29wZW5fYWxsKHN0cnVjdCBr
dm0gKmt2bSkKIAogCXJldHVybiBkaXNrczsKIGVycm9yOgotCWZvciAoaSA9IDA7IGkgPCBj
b3VudDsgaSsrKQotCQlpZiAoIUlTX0VSUl9PUl9OVUxMKGRpc2tzW2ldKSkKLQkJCWRpc2tf
aW1hZ2VfX2Nsb3NlKGRpc2tzW2ldKTsKKwlmb3IgKGkgPSAwOyBpIDwgY291bnQ7IGkrKykg
eworCQlpZiAoSVNfRVJSX09SX05VTEwoZGlza3NbaV0pKQorCQkJY29udGludWU7CiAKKwkJ
aWYgKGRpc2tzW2ldLT53d3BuKQorCQkJZnJlZShkaXNrc1tpXSk7CisJCWVsc2UKKwkJCWRp
c2tfaW1hZ2VfX2Nsb3NlKGRpc2tzW2ldKTsKKwl9CiAJZnJlZShkaXNrcyk7CiAJcmV0dXJu
IGVycjsKIH0KLS0gCjIuMzQuMQoK

--nsmail-li29ugwhg8-li3jsabja1--

