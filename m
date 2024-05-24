Return-Path: <kvm+bounces-18099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE5F8CDF94
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 04:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D179F1C20B4B
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 02:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3972C694;
	Fri, 24 May 2024 02:50:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmty3ljk5ljewns4xndka.icoremail.net (zg8tmty3ljk5ljewns4xndka.icoremail.net [167.99.105.149])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5906E23D2
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 02:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.99.105.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716519054; cv=none; b=ZmbaBIzkrXhbLG74jsi6KkXpL5hhAMQdVeYVdmF7Y5H959lc/W3JpVOq/cCcEBMK1LvvK4QmAAp6wnkecnYbW3a93h9bCucX1CHXY+4uYxIuh8j90FhWVAaFdNx0ZJzm4id0m6wH9m+5hATao2gqO4X8gSb5pabdqvWr5Waouss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716519054; c=relaxed/simple;
	bh=D1u79UWVxouCmeSi+UKFOAciqIYkpYJjEmMBnmf2LZA=;
	h=Date:From:To:Cc:Subject:Content-Type:MIME-Version:Message-ID; b=WElOpNF5ksZMnzgRUc1/x/aP3BO+KDZQmeXeVjEUxyMQ17j6vgM1KA8zcjlVR8PHvAri6VcyjYgyBu5dHUVKVhi9hN6OEl+z+FfGmRJ9vrhsxnFSp59CqE5Xlcq2Pt+3vMjMZ/im40jblOqWrnGpsLnD/X/NeaGCgkj7ZvGvpGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bosc.ac.cn; spf=pass smtp.mailfrom=bosc.ac.cn; arc=none smtp.client-ip=167.99.105.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bosc.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bosc.ac.cn
Received: from qinshaoqing$bosc.ac.cn ( [123.114.53.210] ) by
 ajax-webmail-mail (Coremail) ; Fri, 24 May 2024 10:50:26 +0800 (GMT+08:00)
Date: Fri, 24 May 2024 10:50:26 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Shaoqing Qin" <qinshaoqing@bosc.ac.cn>
To: Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org
Cc: Bonzini <pbonzini@redhat.com>, Patra <atishp@atishpatra.org>, 
	Jones <ajones@ventanamicro.com>, Patel <anup@brainfault.org>, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Patel <apatel@ventanamicro.com>, 
	=?UTF-8?B?546L54S2?= <wangran@bosc.ac.cn>, 
	=?UTF-8?B?5byg5YGl?= <zhangjian@bosc.ac.cn>
Subject: [v2][kvmtool PATCH 0/1] riscv: Add zacas extension
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT5 build
 20230627(00751abc) Copyright (c) 2002-2024 www.mailtech.cn
 mispb-4edfefde-e422-4ddc-8a36-c3f99eb8cd32-icoremail.net
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <5a455c13.48.18fa881bf58.Coremail.qinshaoqing@bosc.ac.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:AQAAfwD3p9hyAFBmA563AA--.2146W
X-CM-SenderInfo: ptlq2xpdrtx03j6e02nfoduhdfq/1tbiAQAIAWZPVcACfQADsI
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

T24gMjAyNC81LzI0IDEwOjEwLCBTaGFvcWluZyBRaW4gd3JvdGU6Cj4gCj4+IFRoZSBmdW5jdGlv
bmFsaXR5IGhhcyBiZWVuIHRlc3RlZCBvbiBRRU1VLCB0aGUgdGVzdHMgcmVseSBvbiBrZXJuZWwo
Ni45KSBhbmQgcWVtdQo+PiBzdXBwb3J0IGZvciB6YWNhcy4KPj4gSWYgeW91IHdhbnQgdG8gdGVz
dCwgeW91IGNvdWxkIHVzZSB0aGUgZm9sbG93aW5nIHZlcnNpb24gd2UgcmVsZWFzZWQgZm9yIHRl
c3RpbmcuCj4gCj4gQWJvdXQgYW9idmUgbWVzc2FnZSBhYm91dDoKPiAKPiBUaGlzIHBhdGNoIGlz
IHRvIGVuYWJsZSBaYWNhcyBJU0EgZXh0ZW5zaW9uIGZvciBWTS4KPiAKPiBZb3UgY291bGQgdHJ5
IHRoaXMgcGF0Y2ggd2l0aCBiZWxvdyBkZXBlbmRlbmNpZXM6Cj4gCj4ga2VybmVsOgo+IG1haW5s
aW5lICA2LjkKPiBxZW11Ogo+IGh0dHBzOi8vZ2l0aHViLmNvbS9PcGVuWGlhbmdTaGFuL3FlbXUv
dHJlZS9yaXNjdi16YWNhcwo+IAo+IAogPgogPiBBYm91dCBhb2J2ZSBtZXNzYWdlIGFib3V0Ogog
PgogPiBUaGlzIHBhdGNoIGlzIHRvIGVuYWJsZSBaYWNhcyBJU0EgZXh0ZW5zaW9uIGZvciBWTS4K
ID4KID4gWW91IGNvdWxkIHRyeSB0aGlzIHBhdGNoIHdpdGggYmVsb3cgZGVwZW5kZW5jaWVzOgog
PgogPiBrZXJuZWw6CiA+IG1haW5saW5lICA2LjkKID4gcWVtdToKID4gaHR0cHM6Ly9naXRodWIu
Y29tL09wZW5YaWFuZ1NoYW4vcWVtdS90cmVlL3Jpc2N2LXphY2FzCgpUaGlzIGZlYXR1cmUgaGFz
IGJlZW4gdmVyaWZpZWQgb24gUUVNVSB3aXRoIHphY2FzIHN1cHBvcnRlZCBbMV0gKyAKdXBzdHJl
YW0ga2VybmVsKHY2LjkpCgpMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vT3BlblhpYW5nU2hhbi9x
ZW11L3RyZWUvcmlzY3YtemFjYXMgWzFdCi0tLQoKPiBxaW5zaGFvcWluZyAoMSk6Cj4gICAgQWRk
IHN1cHBvcnQgZm9yIChyYXRpZmllZCkgWmFjYXMgZXh0ZW5zaW9uCj4gCj4gICByaXNjdi9mZHQu
YyAgICAgICAgICAgICAgICAgICAgICAgICB8IDEgKwo+ICAgcmlzY3YvaW5jbHVkZS9hc20va3Zt
LmggICAgICAgICAgICAgfCAxICsKPiAgIHJpc2N2L2luY2x1ZGUva3ZtL2t2bS1jb25maWctYXJj
aC5oIHwgMyArKysKPiAgIDMgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCj4gCgo=

