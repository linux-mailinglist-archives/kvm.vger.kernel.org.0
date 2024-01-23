Return-Path: <kvm+bounces-6715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F9E18385CA
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 03:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82A1B1C29876
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D261102;
	Tue, 23 Jan 2024 02:56:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB1C810
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 02:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.101.248.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705978587; cv=none; b=e5qsmUSE9EOHbh4T6F5UzzdJitfyienuA50c6xjnoc7razvyhImD1ylvHvkorGSDQ7JiWP156a1EDTSPObRY4T5zUmPCZ/gQAAL1MRu/Em+FdrgJZVcbpt70qDCljreJy1AznbRuU3MVBXbAPno51DoLD5hRy85KCX5wvuLezIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705978587; c=relaxed/simple;
	bh=8RyX1FMeq4gj1VC4buYen3xH7DsH2q46t1Wh/+dVfU0=;
	h=Date:From:To:Cc:Subject:Content-Type:MIME-Version:Message-ID; b=iSQNaTXIpciuwoRQND5XZ3GjPyX76Ks/PbLoWt+6GUfFJTNWZxS5/afoIR3kok965gA5BDhGe/ogtAur1CyBWhCG6XjoHxKkPblFlS/ll84qXkBIj6ngaFEXkYj1vl8Fjo9qINqdY2OPZgbJfcLhDxVZiDgMvmz6t3XJbuAyNas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bosc.ac.cn; spf=pass smtp.mailfrom=bosc.ac.cn; arc=none smtp.client-ip=46.101.248.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bosc.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bosc.ac.cn
Received: from qinshaoqing$bosc.ac.cn ( [123.114.53.210] ) by
 ajax-webmail-mail (Coremail) ; Tue, 23 Jan 2024 10:55:51 +0800 (GMT+08:00)
Date: Tue, 23 Jan 2024 10:55:51 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?56em5bCR6Z2S?= <qinshaoqing@bosc.ac.cn>
To: Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org
Cc: Bonzini <pbonzini@redhat.com>, Patra <atishp@atishpatra.org>, 
	Jones <ajones@ventanamicro.com>, Patel <anup@brainfault.org>, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Patel <apatel@ventanamicro.com>, 
	=?UTF-8?B?546L54S2?= <wangran@bosc.ac.cn>, 
	=?UTF-8?B?5byg5YGl?= <zhangjian@bosc.ac.cn>
Subject: [kvmtool PATCH 0/1] riscv: Add zacas extension
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT5 build
 20230627(00751abc) Copyright (c) 2002-2024 www.mailtech.cn
 mispb-76b96e3b-3ecc-44d5-9200-de81e6d4c242-
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <5b92b0c6.94.18d343eddde.Coremail.qinshaoqing@bosc.ac.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:AQAAfwBX8Ea3Kq9lA26sAA--.987W
X-CM-SenderInfo: ptlq2xpdrtx03j6e02nfoduhdfq/1tbiAQAGAWWukV4CHgAAse
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

Cj4gVGhlIGZ1bmN0aW9uYWxpdHkgaGFzIGJlZW4gdGVzdGVkIG9uIFFFTVUsIHRoZSB0ZXN0cyBy
ZWx5IG9uIGtlcm5lbCBhbmQgcWVtdQo+IHN1cHBvcnQgZm9yIHphY2FzLgo+IEN1cnJlbnRseSwg
dGhlcmUgaXMgbm8gcGF0Y2ggZm9yIHphY2FzIG9uIHRoZSB1cHN0cmVhbS4KPiBJZiB5b3Ugd2Fu
dCB0byB0ZXN0LCB5b3UgY291bGQgdXNlIHRoZSBmb2xsb3dpbmcgdmVyc2lvbiB3ZSByZWxlYXNl
ZCBmb3IgdGVzdGluZy4KCkFib3V0IGFvYnZlIG1lc3NhZ2UgYWJvdXQ6CgpUaGlzIHBhdGNoIGlz
IHRvIGVuYWJsZSBaYWNhcyBJU0EgZXh0ZW5zaW9uIGZvciBWTS4KCllvdSBjb3VsZCB0cnkgdGhp
cyBwYXRjaCB3aXRoIGJlbG93IGRlcGVuZGVuY2llczoKCmtlcm5lbDogCmh0dHBzOi8vZ2l0aHVi
LmNvbS9PcGVuWGlhbmdTaGFuL3Jpc2N2LWxpbnV4L3RyZWUvcmlzY3YtemFjYXMKcWVtdToKaHR0
cHM6Ly9naXRodWIuY29tL09wZW5YaWFuZ1NoYW4vcWVtdS90cmVlL3Jpc2N2LXphY2FzCgpxaW5z
aGFvcWluZyAoMSk6CiAgQWRkIHN1cHBvcnQgZm9yIChyYXRpZmllZCkgWmFjYXMgZXh0ZW5zaW9u
CgogcmlzY3YvZmR0LmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAxICsKIHJpc2N2L2luY2x1
ZGUvYXNtL2t2bS5oICAgICAgICAgICAgIHwgMSArCiByaXNjdi9pbmNsdWRlL2t2bS9rdm0tY29u
ZmlnLWFyY2guaCB8IDMgKysrCiAzIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQoKLS0g
CjIuNDMuMAo=

