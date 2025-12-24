Return-Path: <kvm+bounces-66674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF81CDBCED
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 10:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA10A303C803
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 09:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400DF332EDD;
	Wed, 24 Dec 2025 09:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Jtl8KoSg"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D1B26158B;
	Wed, 24 Dec 2025 09:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766568733; cv=none; b=nBFC1WSHW6pLGLS1MfRYQLMu6Fo+G6ohnMZuYIq/UWLNDAeiDba8QaGWmIK97AkcQ6+Nw4sM/CKm2EJeUAsVDQK4dwSOzdySs6qeW9pWf4A1O9H5A7i22wDPbZFeE1mo8ffkHTQeANFP/z+AT+eTzQpjmZA8loo9dnXOgvAYDJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766568733; c=relaxed/simple;
	bh=nhHyg+t961aJHJbAm/Wg5bGGE6tLKeEXZl9GG7dPNWw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=ZcxjmKYt5wOE7zZNjNVjOrtHpnyM54LRUEQvEFMmjs/DXMiXKu8KCbvp9P3YmXIdo1VZbd8TbpyKOdKwL7RI7fFWBojFEoJb3OGxaQcQZ5yJu1YdJ5CI0qvHiwW6ZZMOeVvR/iIaRxjre2wlNlDTPm9gw0AU+zkFnUtT4XoVfgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Jtl8KoSg; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=nhHyg+t961aJHJbAm/Wg5bGGE6tLKeEXZl9GG7dPNWw=; b=J
	tl8KoSgEissdfyOASt7H4ntzEhdDs/8PjieKbLPdwX1WZjogvQpMF0eW+p8XKGJi
	bS+s+BiKOpkbKqgAERAQ2zQqKOvJqzxx7Wv629MPf3HaNHj3H/iGvOmzWnA6r1Rs
	6EfMtjabTkdty1iSE5QCtjppdHuKl/1XqZf11GDhrk=
Received: from 15927021679$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-107 (Coremail) ; Wed, 24 Dec 2025 17:31:09 +0800
 (CST)
Date: Wed, 24 Dec 2025 17:31:09 +0800 (CST)
From: =?UTF-8?B?54aK5Lyf5rCRICA=?= <15927021679@163.com>
To: "Jason Wang" <jasowang@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
	"David Hildenbrand" <david@redhat.com>,
	"Stefano Garzarella" <sgarzare@redhat.com>,
	"Thomas Monjalon" <thomas@monjalon.net>,
	"David Marchand" <david.marchand@redhat.com>,
	"Luca Boccassi" <bluca@debian.org>,
	"Kevin Traynor" <ktraynor@redhat.com>,
	"Christian Ehrhardt" <christian.ehrhardt@canonical.com>,
	"Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	"Xueming Li" <xuemingl@nvidia.com>,
	"Maxime Coquelin" <maxime.coquelin@redhat.com>,
	"Chenbo Xia" <chenbox@nvidia.com>,
	"Bruce Richardson" <bruce.richardson@intel.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re:Re: Implement initial driver for virtio-RDMA device(kernel)
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20250723(a044bf12) Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <CACGkMEvbrF=g0_yedXKsccVN6vmfm+oQVbRkR1PGtQgFHH+v3g@mail.gmail.com>
References: <20251218091050.55047-1-15927021679@163.com>
 <CACGkMEvbrF=g0_yedXKsccVN6vmfm+oQVbRkR1PGtQgFHH+v3g@mail.gmail.com>
X-NTES-SC: AL_Qu2dBPmdt04t7ymcYekfmU0VgOc9XsWwu/Uk2YRXc+AEvhn91i0NcGBfB13x3/C3Cw2orgSHdD9v4+NFc5Zj9iPwoTSwvc7hOedZq9nBkQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <3a4733b.8bcf.19b4fb2b303.Coremail.15927021679@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:aygvCgD3t_vesktpP9tIAA--.2616W
X-CM-SenderInfo: jprvmjixqsilmxzbiqqrwthudrp/xtbC0h0RmWlLst08-wAA3J
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgoKCgoKCgoKCgoKCgoKCgoKQXQgMjAyNS0xMi0yMyAwOToxNjo0MCwgIkphc29uIFdhbmciIDxq
YXNvd2FuZ0ByZWRoYXQuY29tPiB3cm90ZToKPk9uIFRodSwgRGVjIDE4LCAyMDI1IGF0IDU6MTHi
gK9QTSBYaW9uZyBXZWltaW4gPDE1OTI3MDIxNjc5QDE2My5jb20+IHdyb3RlOgo+Pgo+PiBIaSBh
bGwsCj4+Cj4+IFRoaXMgdGVzdGluZyBpbnN0cnVjdGlvbnMgYWltcyB0byBpbnRyb2R1Y2UgYW4g
ZW11bGF0aW5nIGEgc29mdCBST0NFCj4+IGRldmljZSB3aXRoIG5vcm1hbCBOSUMobm8gUkRNQSks
IHdlIGhhdmUgZmluaXNoZWQgYSB2aG9zdC11c2VyIFJETUEKPj4gZGV2aWNlIGRlbW8sIHdoaWNo
IGNhbiB3b3JrIHdpdGggUkRNQSBmZWF0dXJlcyBzdWNoIGFzIENNLCBRUCB0eXBlIG9mCj4+IFVD
L1VEIGFuZCBzbyBvbi4KPj4KPgo+SSB0aGluayB3ZSBuZWVkCj4KPjEpIHRvIGtub3cgdGhlIGRp
ZmZlcmVuY2UgYmV0d2VlbiB0aGlzIGFuZCBbMV0KPjIpIHRoZSBzcGVjIHBhdGNoCj4KPlRoYW5r
cwo+Cgo+WzFdIGh0dHBzOi8veWhidC5uZXQvbG9yZS92aXJ0aW8tZGV2L0NBQ3ljVDNzU2h4T1I0
MUtrMXpueEM3TXB3NzNOMExBUDY2Y0MzLWlxZVNfanA4dHJ2d0BtYWlsLmdtYWlsLmNvbS9ULyNt
MDYwMmVlNzFkZTBmZTM4OTY3MWNiZDgxMjQyYjVmM2NlZWFiMDEwMQoKClNvcnJ5LCBJIGNhbid0
IGFjY2VzcyB0aGlzIHdlYnBhZ2UgbGluay4gSXMgdGhlcmUgYW5vdGhlciB3YXkgdG8gdmlldyBp
dD8=

