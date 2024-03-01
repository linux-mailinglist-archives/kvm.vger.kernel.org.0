Return-Path: <kvm+bounces-10636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B51A586E097
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:46:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44C5C1F252F9
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9BC6D1BA;
	Fri,  1 Mar 2024 11:46:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1FF20315;
	Fri,  1 Mar 2024 11:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709293559; cv=none; b=rbTQTgUwOhBNvo0Chqe9TUA8svX0a3TbAJ4m3MBOOwtSDhY+Ae5++MoZLKcQLcIb8fhhYwEl5AVRqguS2casJAR1sSXJpUjvA9aPGrSodOxgKJpEeBmLjfkCHZUn4SnkACXjc6oHpooityF4GOcs/E5PNFrPcBE9YDD3+pO3my0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709293559; c=relaxed/simple;
	bh=7euRu9gC1qZwJ0nCZHbyU4FyH2aqHWlDJQgi7OX/OZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qvTtws3jJwIrnkmONS0/Y9E9ekLMl70iOhjF7HtYjVhCavohUXlSsRivPWrSrnxTji1/PINW8ewoxjN4e/hmywDd6QJ9j17G/daz9XGIottzWxBz1pOEaMlmUhmDjquEVMDfmu3mLVyK9K/Aev7rCsqOamARon8/fd38TtkpmmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TmR7D5q2Bz2Bf5g;
	Fri,  1 Mar 2024 19:43:36 +0800 (CST)
Received: from kwepemd100001.china.huawei.com (unknown [7.221.188.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 95F5514011A;
	Fri,  1 Mar 2024 19:45:53 +0800 (CST)
Received: from kwepemd100012.china.huawei.com (7.221.188.214) by
 kwepemd100001.china.huawei.com (7.221.188.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 1 Mar 2024 19:45:53 +0800
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemd100012.china.huawei.com (7.221.188.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 1 Mar 2024 19:45:52 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Fri, 1 Mar 2024 19:45:52 +0800
From: wangyunjian <wangyunjian@huawei.com>
To: Paolo Abeni <pabeni@redhat.com>, "mst@redhat.com" <mst@redhat.com>,
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "bjorn@kernel.org" <bjorn@kernel.org>,
	"magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
	"maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "davem@davemloft.net"
	<davem@davemloft.net>
CC: "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, xudingke
	<xudingke@huawei.com>, "liwei (DT)" <liwei395@huawei.com>
Subject: RE: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
Thread-Topic: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
Thread-Index: AQHaajYcNkJKJoTBfEqyMPzDlwSi+bEgpeYAgAIJPRA=
Date: Fri, 1 Mar 2024 11:45:52 +0000
Message-ID: <223aeca6435342ec8a4d57c959c23303@huawei.com>
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
 <7d478cb842e28094f4d6102e593e3de25ab27dfe.camel@redhat.com>
In-Reply-To: <7d478cb842e28094f4d6102e593e3de25ab27dfe.camel@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYW9sbyBBYmVuaSBbbWFpbHRv
OnBhYmVuaUByZWRoYXQuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMjksIDIwMjQg
NzoxMyBQTQ0KPiBUbzogd2FuZ3l1bmppYW4gPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+OyBtc3RA
cmVkaGF0LmNvbTsNCj4gd2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbTsgamFzb3dhbmdA
cmVkaGF0LmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBiam9ybkBrZXJuZWwub3JnOyBtYWdudXMu
a2FybHNzb25AaW50ZWwuY29tOyBtYWNpZWouZmlqYWxrb3dza2lAaW50ZWwuY29tOw0KPiBqb25h
dGhhbi5sZW1vbkBnbWFpbC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gQ2M6IGJwZkB2Z2Vy
Lmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHZpcnR1YWxpemF0aW9uQGxpc3Rz
LmxpbnV4LmRldjsgeHVkaW5na2UgPHh1ZGluZ2tlQGh1YXdlaS5jb20+OyBsaXdlaSAoRFQpDQo+
IDxsaXdlaTM5NUBodWF3ZWkuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYy
IDMvM10gdHVuOiBBRl9YRFAgVHggemVyby1jb3B5IHN1cHBvcnQNCj4gDQo+IE9uIFdlZCwgMjAy
NC0wMi0yOCBhdCAxOTowNSArMDgwMCwgWXVuamlhbiBXYW5nIHdyb3RlOg0KPiA+IEBAIC0yNjYx
LDYgKzI3NzYsNTQgQEAgc3RhdGljIGludCB0dW5fcHRyX3BlZWtfbGVuKHZvaWQgKnB0cikNCj4g
PiAgCX0NCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIHR1bl9wZWVrX3hzayhzdHJ1Y3Qg
dHVuX2ZpbGUgKnRmaWxlKSB7DQo+ID4gKwlzdHJ1Y3QgeHNrX2J1ZmZfcG9vbCAqcG9vbDsNCj4g
PiArCXUzMiBpLCBiYXRjaCwgYnVkZ2V0Ow0KPiA+ICsJdm9pZCAqZnJhbWU7DQo+ID4gKw0KPiA+
ICsJaWYgKCFwdHJfcmluZ19lbXB0eSgmdGZpbGUtPnR4X3JpbmcpKQ0KPiA+ICsJCXJldHVybjsN
Cj4gPiArDQo+ID4gKwlzcGluX2xvY2soJnRmaWxlLT5wb29sX2xvY2spOw0KPiA+ICsJcG9vbCA9
IHRmaWxlLT54c2tfcG9vbDsNCj4gPiArCWlmICghcG9vbCkgew0KPiA+ICsJCXNwaW5fdW5sb2Nr
KCZ0ZmlsZS0+cG9vbF9sb2NrKTsNCj4gPiArCQlyZXR1cm47DQo+ID4gKwl9DQo+ID4gKw0KPiA+
ICsJaWYgKHRmaWxlLT5uYl9kZXNjcykgew0KPiA+ICsJCXhza190eF9jb21wbGV0ZWQocG9vbCwg
dGZpbGUtPm5iX2Rlc2NzKTsNCj4gPiArCQlpZiAoeHNrX3VzZXNfbmVlZF93YWtldXAocG9vbCkp
DQo+ID4gKwkJCXhza19zZXRfdHhfbmVlZF93YWtldXAocG9vbCk7DQo+ID4gKwl9DQo+ID4gKw0K
PiA+ICsJc3Bpbl9sb2NrKCZ0ZmlsZS0+dHhfcmluZy5wcm9kdWNlcl9sb2NrKTsNCj4gPiArCWJ1
ZGdldCA9IG1pbl90KHUzMiwgdGZpbGUtPnR4X3Jpbmcuc2l6ZSwgVFVOX1hEUF9CQVRDSCk7DQo+
ID4gKw0KPiA+ICsJYmF0Y2ggPSB4c2tfdHhfcGVla19yZWxlYXNlX2Rlc2NfYmF0Y2gocG9vbCwg
YnVkZ2V0KTsNCj4gPiArCWlmICghYmF0Y2gpIHsNCj4gDQo+IFRoaXMgYnJhbmNoIGxvb2tzIGxp
a2UgYW4gdW5uZWVkZWQgIm9wdGltaXphdGlvbiIuIFRoZSBnZW5lcmljIGxvb3AgYmVsb3cNCj4g
c2hvdWxkIGhhdmUgdGhlIHNhbWUgZWZmZWN0IHdpdGggbm8gbWVhc3VyYWJsZSBwZXJmIGRlbHRh
IC0gYW5kIHNtYWxsZXIgY29kZS4NCj4gSnVzdCByZW1vdmUgdGhpcy4NCj4gDQo+ID4gKwkJdGZp
bGUtPm5iX2Rlc2NzID0gMDsNCj4gPiArCQlzcGluX3VubG9jaygmdGZpbGUtPnR4X3JpbmcucHJv
ZHVjZXJfbG9jayk7DQo+ID4gKwkJc3Bpbl91bmxvY2soJnRmaWxlLT5wb29sX2xvY2spOw0KPiA+
ICsJCXJldHVybjsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwl0ZmlsZS0+bmJfZGVzY3MgPSBiYXRj
aDsNCj4gPiArCWZvciAoaSA9IDA7IGkgPCBiYXRjaDsgaSsrKSB7DQo+ID4gKwkJLyogRW5jb2Rl
IHRoZSBYRFAgREVTQyBmbGFnIGludG8gbG93ZXN0IGJpdCBmb3IgY29uc3VtZXIgdG8gZGlmZmVy
DQo+ID4gKwkJICogWERQIGRlc2MgZnJvbSBYRFAgYnVmZmVyIGFuZCBza19idWZmLg0KPiA+ICsJ
CSAqLw0KPiA+ICsJCWZyYW1lID0gdHVuX3hkcF9kZXNjX3RvX3B0cigmcG9vbC0+dHhfZGVzY3Nb
aV0pOw0KPiA+ICsJCS8qIFRoZSBidWRnZXQgbXVzdCBiZSBsZXNzIHRoYW4gb3IgZXF1YWwgdG8g
dHhfcmluZy5zaXplLA0KPiA+ICsJCSAqIHNvIGVucXVldWluZyB3aWxsIG5vdCBmYWlsLg0KPiA+
ICsJCSAqLw0KPiA+ICsJCV9fcHRyX3JpbmdfcHJvZHVjZSgmdGZpbGUtPnR4X3JpbmcsIGZyYW1l
KTsNCj4gPiArCX0NCj4gPiArCXNwaW5fdW5sb2NrKCZ0ZmlsZS0+dHhfcmluZy5wcm9kdWNlcl9s
b2NrKTsNCj4gPiArCXNwaW5fdW5sb2NrKCZ0ZmlsZS0+cG9vbF9sb2NrKTsNCj4gDQo+IE1vcmUg
cmVsYXRlZCB0byB0aGUgZ2VuZXJhbCBkZXNpZ246IGl0IGxvb2tzIHdyb25nLiBXaGF0IGlmDQo+
IGdldF9yeF9idWZzKCkgd2lsbCBmYWlsIChFTk9CVUYpIGFmdGVyIHN1Y2Nlc3NmdWwgcGVla2lu
Zz8gV2l0aCBubyBtb3JlDQo+IGluY29taW5nIHBhY2tldHMsIGxhdGVyIHBlZWsgd2lsbCByZXR1
cm4gMCBhbmQgaXQgbG9va3MgbGlrZSB0aGF0IHRoZQ0KPiBoYWxmLXByb2Nlc3NlZCBwYWNrZXRz
IHdpbGwgc3RheSBpbiB0aGUgcmluZyBmb3JldmVyPz8/DQo+IA0KPiBJIHRoaW5rIHRoZSAncmlu
ZyBwcm9kdWNlJyBwYXJ0IHNob3VsZCBiZSBtb3ZlZCBpbnRvIHR1bl9kb19yZWFkKCkuDQoNCkN1
cnJlbnRseSwgdGhlIHZob3N0LW5ldCBvYnRhaW5zIGEgYmF0Y2ggZGVzY3JpcHRvcnMvc2tfYnVm
ZnMgZnJvbSB0aGUNCnB0cl9yaW5nIGFuZCBlbnF1ZXVlIHRoZSBiYXRjaCBkZXNjcmlwdG9ycy9z
a19idWZmcyB0byB0aGUgdmlydHF1ZXVlJ3F1ZXVlLA0KYW5kIHRoZW4gY29uc3VtZXMgdGhlIGRl
c2NyaXB0b3JzL3NrX2J1ZmZzIGZyb20gdGhlIHZpcnRxdWV1ZSdxdWV1ZSBpbg0Kc2VxdWVuY2Uu
IEFzIGEgcmVzdWx0LCBUVU4gZG9lcyBub3Qga25vdyB3aGV0aGVyIHRoZSBiYXRjaCBkZXNjcmlw
dG9ycyBoYXZlDQpiZWVuIHVzZWQgdXAsIGFuZCB0aHVzIGRvZXMgbm90IGtub3cgd2hlbiB0byBy
ZXR1cm4gdGhlIGJhdGNoIGRlc2NyaXB0b3JzLg0KDQpTbywgSSB0aGluayBpdCdzIHJlYXNvbmFi
bGUgdGhhdCB3aGVuIHZob3N0LW5ldCBjaGVja3MgcHRyX3JpbmcgaXMgZW1wdHksDQppdCBjYWxs
cyBwZWVrX2xlbiB0byBnZXQgbmV3IHhzaydzIGRlc2NzIGFuZCByZXR1cm4gdGhlIGRlc2NyaXB0
b3JzLg0KDQpUaGFua3MNCj4gDQo+IENoZWVycywNCj4gDQo+IFBhb2xvDQoNCg==

