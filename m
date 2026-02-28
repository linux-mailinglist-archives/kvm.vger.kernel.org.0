Return-Path: <kvm+bounces-72272-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBa2H6+LommK3wQAu9opvQ
	(envelope-from <kvm+bounces-72272-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 07:31:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6971C093A
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 07:31:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F27A3086046
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 06:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C3234574B;
	Sat, 28 Feb 2026 06:30:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp37.cstnet.cn [159.226.251.37])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2471AE877;
	Sat, 28 Feb 2026 06:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772260254; cv=none; b=JGnq4/2g/FrK5aQ7KSfYdAaR4aCZtLyR9sdLOrewALOEEM8lI6bBdBYE0lv608LCwnvkxQSvGA/oBduAd/2PpJxV5j/FIl3ayoF/Hjq5wqdhZZh6MbFjPKH06HXJsWLNASXtjzu1fHVUSXpQaNa8PAbasxVyzbrmYTcCAq8+B0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772260254; c=relaxed/simple;
	bh=4G8Ov/J3yUqLsZRD35KOFvUNKf4mwcRFNuiNJkTmELQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=O2fnXEsHK+x/NVczsZ1yG+12f2dY5rDm9+wJwcf8tOQsz5iS0a6uCBRejaiQnjMkb2JX2Za5fpL66THXyc+md1NOWdPPy8H4auXAWrsj9o2STIiLVxETWeSraOH9mEFt/5w/J7792RplPFJWB6YW0Y5LWoyxDYR9PtsDp+c+MOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from xujiakai2025$iscas.ac.cn ( [210.73.43.101] ) by
 ajax-webmail-APP-12 (Coremail) ; Sat, 28 Feb 2026 14:30:25 +0800
 (GMT+08:00)
Date: Sat, 28 Feb 2026 14:30:25 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Jiakai Xu" <xujiakai2025@iscas.ac.cn>
To: "kernel test robot" <lkp@intel.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Paolo Bonzini" <pbonzini@redhat.com>, 
	"Shuah Khan" <skhan@linuxfoundation.org>, 
	"Paul Walmsley" <pjw@kernel.org>, 
	"Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, 
	"Atish Patra" <atish.patra@linux.dev>, 
	"Albert Ou" <aou@eecs.berkeley.edu>
Subject: Re: Re: [PATCH v9 2/3] KVM: selftests: Refactor UAPI tests into
 dedicated function
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.1-cmXT5 build
 20240627(e6c6db66) Copyright (c) 2002-2026 www.mailtech.cn cnic.cn
In-Reply-To: <202602280523.Y5Q8Pdft-lkp@intel.com>
References: <20260228005355.823048-3-xujiakai2025@iscas.ac.cn>
 <202602280523.Y5Q8Pdft-lkp@intel.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <6f5f1ca4.443dd.19ca2f0f358.Coremail.xujiakai2025@iscas.ac.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:tgCowABnc9OBi6Jp1RITAA--.46891W
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiDAgMCWmiU3VFgAABso
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72272-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	HAS_X_PRIO_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,01.org:url,iscas.ac.cn:mid,intel.com:email,git-scm.com:url]
X-Rspamd-Queue-Id: DE6971C093A
X-Rspamd-Action: no action

SGkgYWxsLAoKSSByZWNlaXZlZCBhIG5vdGlmaWNhdGlvbiBmcm9tIHRoZSBrZXJuZWwgdGVzdCBy
b2JvdCByZWdhcmRpbmcgbXkgcGF0Y2guIEl0IGluZGljYXRlcyB0aGF0IHZvaWQgY2hlY2tfc3Rl
YWxfdGltZV91YXBpKCkgc2hvdWxkIGJlIGNoYW5nZWQgdG8gdm9pZCBjaGVja19zdGVhbF90aW1l
X3VhcGkodm9pZCkgdG8gYXZvaWQgYSBjb21waWxlciB3YXJuaW5nLgoKSSB3b3VsZCBsaWtlIHRv
IHdhaXQgZm9yIHRoZSByZXZpZXdlcnPigJkgZmVlZGJhY2sgb24gdGhpcyBwYXRjaC4gSWYgdGhl
cmUgYXJlIG5vIGlzc3VlcyBhc2lkZSBmcm9tIHRoaXMgd2FybmluZywgSSB3aWxsIHN1Ym1pdCB0
aGUgZmluYWwgdmVyc2lvbiBhZGRyZXNzaW5nIHRoZSBjb21waWxlciB3YXJuaW5nLiBJZiB0aGVy
ZSBhcmUgb3RoZXIgc3VnZ2VzdGlvbnMsIEkgd2lsbCBpbmNvcnBvcmF0ZSB0aGVtIGFjY29yZGlu
Z2x5LgoKVGhhbmtzLApKaWFrYWkKCiZxdW90O2tlcm5lbCB0ZXN0IHJvYm90JnF1b3Q7ICZsdDts
a3BAaW50ZWwuY29tJmd0O+WGmemBk++8mgo+IEhpIEppYWthaSwNCj4gDQo+IGtlcm5lbCB0ZXN0
IHJvYm90IG5vdGljZWQgdGhlIGZvbGxvd2luZyBidWlsZCB3YXJuaW5nczoNCj4gDQo+IFthdXRv
IGJ1aWxkIHRlc3QgV0FSTklORyBvbiB2Ni4xOV0NCj4gW2Nhbm5vdCBhcHBseSB0byBrdm0vcXVl
dWUga3ZtL25leHQgbGludXMvbWFzdGVyIGt2bS9saW51eC1uZXh0IHY3LjAtcmMxIG5leHQtMjAy
NjAyMjddDQo+IFtJZiB5b3VyIHBhdGNoIGlzIGFwcGxpZWQgdG8gdGhlIHdyb25nIGdpdCB0cmVl
LCBraW5kbHkgZHJvcCB1cyBhIG5vdGUuDQo+IEFuZCB3aGVuIHN1Ym1pdHRpbmcgcGF0Y2gsIHdl
IHN1Z2dlc3QgdG8gdXNlICctLWJhc2UnIGFzIGRvY3VtZW50ZWQgaW4NCj4gaHR0cHM6Ly9naXQt
c2NtLmNvbS9kb2NzL2dpdC1mb3JtYXQtcGF0Y2gjX2Jhc2VfdHJlZV9pbmZvcm1hdGlvbl0NCj4g
DQo+IHVybDogICAgaHR0cHM6Ly9naXRodWIuY29tL2ludGVsLWxhYi1sa3AvbGludXgvY29tbWl0
cy9KaWFrYWktWHUvUklTQy1WLUtWTS1WYWxpZGF0ZS1TQkktU1RBLXNobWVtLWFsaWdubWVudC1p
bi1rdm1fc2JpX2V4dF9zdGFfc2V0X3JlZy8yMDI2MDIyOC0wODU2NDgNCj4gYmFzZTogICB2Ni4x
OQ0KPiBwYXRjaCBsaW5rOiAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYwMjI4MDA1
MzU1LjgyMzA0OC0zLXh1amlha2FpMjAyNSU0MGlzY2FzLmFjLmNuDQo+IHBhdGNoIHN1YmplY3Q6
IFtQQVRDSCB2OSAyLzNdIEtWTTogc2VsZnRlc3RzOiBSZWZhY3RvciBVQVBJIHRlc3RzIGludG8g
ZGVkaWNhdGVkIGZ1bmN0aW9uDQo+IGNvbmZpZzogYXJtNjQtYWxsbm9jb25maWctYnBmIChodHRw
czovL2Rvd25sb2FkLjAxLm9yZy8wZGF5LWNpL2FyY2hpdmUvMjAyNjAyMjgvMjAyNjAyMjgwNTIz
Llk1UThQZGZ0LWxrcEBpbnRlbC5jb20vY29uZmlnKQ0KPiBjb21waWxlcjogYWFyY2g2NC1saW51
eC1nbnUtZ2NjIChEZWJpYW4gMTQuMi4wLTE5KSAxNC4yLjANCj4gcmVwcm9kdWNlICh0aGlzIGlz
IGEgVz0xIGJ1aWxkKTogKGh0dHBzOi8vZG93bmxvYWQuMDEub3JnLzBkYXktY2kvYXJjaGl2ZS8y
MDI2MDIyOC8yMDI2MDIyODA1MjMuWTVROFBkZnQtbGtwQGludGVsLmNvbS9yZXByb2R1Y2UpDQo+
IA0KPiBJZiB5b3UgZml4IHRoZSBpc3N1ZSBpbiBhIHNlcGFyYXRlIHBhdGNoL2NvbW1pdCAoaS5l
LiBub3QganVzdCBhIG5ldyB2ZXJzaW9uIG9mDQo+IHRoZSBzYW1lIHBhdGNoL2NvbW1pdCksIGtp
bmRseSBhZGQgZm9sbG93aW5nIHRhZ3MNCj4gfCBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9i
b3QgPGxrcEBpbnRlbC5jb20+DQo+IHwgQ2xvc2VzOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9v
ZS1rYnVpbGQtYWxsLzIwMjYwMjI4MDUyMy5ZNVE4UGRmdC1sa3BAaW50ZWwuY29tLw0KPiANCj4g
QWxsIHdhcm5pbmdzIChuZXcgb25lcyBwcmVmaXhlZCBieSA+Pik6DQo+IA0KPiA+PiBzdGVhbF90
aW1lLmM6MjA3OjEzOiB3YXJuaW5nOiBmdW5jdGlvbiBkZWNsYXJhdGlvbiBpc24ndCBhIHByb3Rv
dHlwZSBbLVdzdHJpY3QtcHJvdG90eXBlc10NCj4gICAgICAyMDcgfCBzdGF0aWMgdm9pZCBjaGVj
a19zdGVhbF90aW1lX3VhcGkoKQ0KPiAgICAgICAgICB8ICAgICAgICAgICAgIF5+fn5+fn5+fn5+
fn5+fn5+fn5+fg0KPiAgICBjYzE6IG5vdGU6IHVucmVjb2duaXplZCBjb21tYW5kLWxpbmUgb3B0
aW9uICctV25vLWdudS12YXJpYWJsZS1zaXplZC10eXBlLW5vdC1hdC1lbmQnIG1heSBoYXZlIGJl
ZW4gaW50ZW5kZWQgdG8gc2lsZW5jZSBlYXJsaWVyIGRpYWdub3N0aWNzDQo+IA0KPiAtLSANCj4g
MC1EQVkgQ0kgS2VybmVsIFRlc3QgU2VydmljZQ0KPiBodHRwczovL2dpdGh1Yi5jb20vaW50ZWwv
bGtwLXRlc3RzL3dpa2kNCg==

