Return-Path: <kvm+bounces-43702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A2EA94836
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 17:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A178171121
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 15:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C677F20B812;
	Sun, 20 Apr 2025 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ScZQM2Fd"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384EC2AD14;
	Sun, 20 Apr 2025 15:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745163713; cv=none; b=TrBxZKwhcNgWTMJuFCXcbHKzsSFherV7DU767vhcR+oQzYYhBT1HgNvFxt+l9YkQMyfFVb9fiV2IDN7ZuiUFBkWKJ2bBsVhvPdQvSkzimW71AqSFa9/bq3YHkfaxHVK5rVgE62rnTIi/6wZIN03IzPUwmlU3Pp1Z3OQvw7ceUIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745163713; c=relaxed/simple;
	bh=nhTglPnOAg08AHjqHpekaXKx6PVluJKvKK23RG4Rlf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EfU3XAJthIGrAa3O5qoBf31aGfq/XDuaqHTal5ZLkQW7bHUsvLuwmD56f5EBv6oQ3MzNNkEhYhpHTjZiRazcYJe2iuvuKaD3S6Mp5P5AU9SySDgx/thKqi0UwCxcvw8ashDK8tOJiqKSZleSUsHibCNADAs25xQ+S1g6G6N3FhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ScZQM2Fd; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1745163638;
	bh=nhTglPnOAg08AHjqHpekaXKx6PVluJKvKK23RG4Rlf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=ScZQM2Fdj/l0p9c6EB4i5+qPofkvZOoWnOHZe6st2J0VczliL2LyTc5QOOiQPnh8A
	 cNzfQ7ghNu6rhknIOnYDYZ1oEAQaCXa18GlHh7bBJywtiv6PvvOW3Won3Xys5e9x9h
	 Oxgs3lqiTXHEI9+y5T8xIJsCfrkevDjiM0bpFFgI=
X-QQ-mid: zesmtpip4t1745163634tcfca585c
X-QQ-Originating-IP: 1yYsjgPrP5ZdGz9cFI6f19bOjM0L3l3pDE04ebFc7b8=
Received: from [IPV6:240e:36c:de5:1600:ee7d:28 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 20 Apr 2025 23:40:32 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16990448463783898360
Message-ID: <B9FBAB180AE77BDB+52e0b4e7-58fa-4047-a35d-c2d00bc1f5bf@uniontech.com>
Date: Sun, 20 Apr 2025 23:40:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH] LoongArch: Fixed multiple typos of KVM code
To: Yulong Han <wheatfox17@icloud.com>, zhaotianrui@loongson.cn,
 Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>,
 WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev, Xianglai Li <lixianglai@loongson.cn>,
 Min Zhou <zhoumin@loongson.cn>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250420142208.2252280-1-wheatfox17@icloud.com>
From: WangYuli <wangyuli@uniontech.com>
Content-Language: en-US
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <20250420142208.2252280-1-wheatfox17@icloud.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qLiP73nPuROm2ta6KfVvNMdZ"
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: MYxAV9ScJiquo4ocg0NsHT2EFg58XvEML16CV5UKOtkQYgcjEq3G0DZE
	LMAmbqB7exV901y6yEXmSQ7LigFwH3YtwFkOR2DBw7CEmKcUK1I6YVxsiAfERSi8UgonXHV
	mBUkoS6b/LUcJ+yEsQ8WKNdBqeltWKzs4Uuj+9mD2rr0NDDFV7jY3pRmfP8l4DuCc7nAWUX
	qAr0A7JBeQBBO+28Zzv0B7JlSKcMFX2sUgCLw8MBKOoGol5S677vswT3350Fo5ff32xLMfL
	/U5FnNJD+bVAiZ4/UIBlA0xtZ5gKy9PkrTw67hFtudQBW/OKDvsO7U2TZNyTuMZAcuId/GX
	T6hGLV8B1VhnxmzzyLbOyz0nz/Mr/Vrw5YR2xFZuze2Ljt1QYWDhJEUud0aN8qgytAIAEaA
	+3FsUlPaBoSNIK9hs6nrsOz7HzANbEiS2/4HyaI+xBq8rb6+ncOjQL3tKbbCBShbeYiMXge
	9Dst5fX93Qepq+z5kKX5cPEzRypdRplJ+A2e0m30691Ac2R9l+mbT53cy3lUt7BcWMQy/Zg
	NTDSqHH8msMqMKf/EnSkgHBdo+sSZPhkI156FiHVJ5dcJKohCfuk+i6hhm+zjkzujsO+dl2
	dEGFBCgodQf/+TN4BsJ5hYX2mMoI+zIMQRWFO9EzuYMHRr36UGQygD8cwhFUrT5c0b1jAjX
	xT58vBmSG9Tdti/tcinLM5DgirOfH28kXrRapQi1GOWN/JqqUnKQh/1eiCblcRSn5sNYBpm
	a0wI8CAxfGWMSMltPpdxtj3GGUO1/OgKPuCsOv6hwcAJJ/2Sz+Ynxuj+ud3zI4d4KiFiyPg
	Ms7IvY83WJHZh/FkXZa3skYFOXruiTqF8CHYssYZmfJ4W6N27UPccEa2tUzE3CGOwIM68EV
	tvZ2FCU7yHatt5+j8PE+bN1zFPUZzSBNbCFrxhG2TDWReBKNdQitwbuVtz+SlAKod8gxA4Z
	0giDkb7JeE4/mSrD/Q7Ywfejuc0Qbo08AGecUcHxAsfblEcgSW0rTcPSt9a0faixgWxAZow
	n0kqY6Rm9rGFfGqM/8MZhLYtYG5QI=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------qLiP73nPuROm2ta6KfVvNMdZ
Content-Type: multipart/mixed; boundary="------------iiPgVCIWWmMhxp9ZmuRv0Sug";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Yulong Han <wheatfox17@icloud.com>, zhaotianrui@loongson.cn,
 Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>,
 WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev, Xianglai Li <lixianglai@loongson.cn>,
 Min Zhou <zhoumin@loongson.cn>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <52e0b4e7-58fa-4047-a35d-c2d00bc1f5bf@uniontech.com>
Subject: Re: [PATCH] LoongArch: Fixed multiple typos of KVM code
References: <20250420142208.2252280-1-wheatfox17@icloud.com>
In-Reply-To: <20250420142208.2252280-1-wheatfox17@icloud.com>

--------------iiPgVCIWWmMhxp9ZmuRv0Sug
Content-Type: multipart/mixed; boundary="------------wrV00aSyKd0gd7bLn3pf6ovz"

--------------wrV00aSyKd0gd7bLn3pf6ovz
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

WyBFeHBhbmRlZCB0aGUgcmVjaXBpZW50IGxpc3QuwqAgXQ0KDQpIaSBZdWxvbmcsDQoNCk9u
IDIwMjUvNC8yMCAyMjoyMiwgWXVsb25nIEhhbiB3cm90ZToNCj4gRml4ZWQgbXVsdGlwbGUg
dHlwb3MgaW5zaWRlIGFyY2gvbG9vbmdhcmNoL2t2bS4NCj4NCj4gU2lnbmVkLW9mZi1ieTog
WXVsb25nIEhhbiA8d2hlYXRmb3gxN0BpY2xvdWQuY29tPg0KPiAtLS0NCj4gICBhcmNoL2xv
b25nYXJjaC9rdm0vaW50Yy9pcGkuYyB8IDQgKystLQ0KPiAgIGFyY2gvbG9vbmdhcmNoL2t2
bS9tYWluLmMgICAgIHwgNCArKy0tDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9hcmNoL2xvb25nYXJj
aC9rdm0vaW50Yy9pcGkuYyBiL2FyY2gvbG9vbmdhcmNoL2t2bS9pbnRjL2lwaS5jDQo+IGlu
ZGV4IDkzZjRhY2Q0NC4uZmU3MzRkYzA2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL2xvb25nYXJj
aC9rdm0vaW50Yy9pcGkuYw0KPiArKysgYi9hcmNoL2xvb25nYXJjaC9rdm0vaW50Yy9pcGku
Yw0KPiBAQCAtMTExLDcgKzExMSw3IEBAIHN0YXRpYyBpbnQgc2VuZF9pcGlfZGF0YShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGFkZHIsIHVpbnQ2NF90IGRhdGEpDQo+ICAgCQly
ZXQgPSBrdm1faW9fYnVzX3JlYWQodmNwdSwgS1ZNX0lPQ1NSX0JVUywgYWRkciwgc2l6ZW9m
KHZhbCksICZ2YWwpOw0KPiAgIAkJc3JjdV9yZWFkX3VubG9jaygmdmNwdS0+a3ZtLT5zcmN1
LCBpZHgpOw0KPiAgIAkJaWYgKHVubGlrZWx5KHJldCkpIHsNCj4gLQkJCWt2bV9lcnIoIiVz
OiA6IHJlYWQgZGF0ZSBmcm9tIGFkZHIgJWxseCBmYWlsZWRcbiIsIF9fZnVuY19fLCBhZGRy
KTsNCj4gKwkJCWt2bV9lcnIoIiVzOiA6IHJlYWQgZGF0YSBmcm9tIGFkZHIgJWxseCBmYWls
ZWRcbiIsIF9fZnVuY19fLCBhZGRyKTsNCj4gICAJCQlyZXR1cm4gcmV0Ow0KPiAgIAkJfQ0K
PiAgIAkJLyogQ29uc3RydWN0IHRoZSBtYXNrIGJ5IHNjYW5uaW5nIHRoZSBiaXQgMjctMzAg
Ki8NCj4gQEAgLTEyNyw3ICsxMjcsNyBAQCBzdGF0aWMgaW50IHNlbmRfaXBpX2RhdGEoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFfdCBhZGRyLCB1aW50NjRfdCBkYXRhKQ0KPiAgIAly
ZXQgPSBrdm1faW9fYnVzX3dyaXRlKHZjcHUsIEtWTV9JT0NTUl9CVVMsIGFkZHIsIHNpemVv
Zih2YWwpLCAmdmFsKTsNCj4gICAJc3JjdV9yZWFkX3VubG9jaygmdmNwdS0+a3ZtLT5zcmN1
LCBpZHgpOw0KPiAgIAlpZiAodW5saWtlbHkocmV0KSkNCj4gLQkJa3ZtX2VycigiJXM6IDog
d3JpdGUgZGF0ZSB0byBhZGRyICVsbHggZmFpbGVkXG4iLCBfX2Z1bmNfXywgYWRkcik7DQo+
ICsJCWt2bV9lcnIoIiVzOiA6IHdyaXRlIGRhdGEgdG8gYWRkciAlbGx4IGZhaWxlZFxuIiwg
X19mdW5jX18sIGFkZHIpOw0KPiAgIA0KPiAgIAlyZXR1cm4gcmV0Ow0KPiAgIH0NCj4gZGlm
ZiAtLWdpdCBhL2FyY2gvbG9vbmdhcmNoL2t2bS9tYWluLmMgYi9hcmNoL2xvb25nYXJjaC9r
dm0vbWFpbi5jDQo+IGluZGV4IGQxNjVjZDM4Yy4uODBlYTYzZDQ2IDEwMDY0NA0KPiAtLS0g
YS9hcmNoL2xvb25nYXJjaC9rdm0vbWFpbi5jDQo+ICsrKyBiL2FyY2gvbG9vbmdhcmNoL2t2
bS9tYWluLmMNCj4gQEAgLTI5NiwxMCArMjk2LDEwIEBAIGludCBrdm1fYXJjaF9lbmFibGVf
dmlydHVhbGl6YXRpb25fY3B1KHZvaWQpDQo+ICAgCS8qDQo+ICAgCSAqIEVuYWJsZSB2aXJ0
dWFsaXphdGlvbiBmZWF0dXJlcyBncmFudGluZyBndWVzdCBkaXJlY3QgY29udHJvbCBvZg0K
PiAgIAkgKiBjZXJ0YWluIGZlYXR1cmVzOg0KPiAtCSAqIEdDST0yOiAgICAgICBUcmFwIG9u
IGluaXQgb3IgdW5pbXBsZW1lbnQgY2FjaGUgaW5zdHJ1Y3Rpb24uDQo+ICsJICogR0NJPTI6
ICAgICAgIFRyYXAgb24gaW5pdCBvciB1bmltcGxlbWVudGVkIGNhY2hlIGluc3RydWN0aW9u
Lg0KPiAgIAkgKiBUT1JVPTA6ICAgICAgVHJhcCBvbiBSb290IFVuaW1wbGVtZW50Lg0KPiAg
IAkgKiBDQUNUUkw9MTogICAgUm9vdCBjb250cm9sIGNhY2hlLg0KPiAtCSAqIFRPUD0wOiAg
ICAgICBUcmFwIG9uIFByZXZpbGVnZS4NCj4gKwkgKiBUT1A9MDogICAgICAgVHJhcCBvbiBQ
cml2aWxlZ2UuDQo+ICAgCSAqIFRPRT0wOiAgICAgICBUcmFwIG9uIEV4Y2VwdGlvbi4NCj4g
ICAJICogVElUPTA6ICAgICAgIFRyYXAgb24gVGltZXIuDQo+ICAgCSAqLw0KUmV2aWV3ZWQt
Ynk6IFl1bGkgV2FuZyA8d2FuZ3l1bGlAdW5pb250ZWNoLmNvbT4NCg0KUGxlYXNlIG5vdGUg
dGhhdCBpZiB5b3Ugd2lzaCBmb3IgYSB0aW1lbHkgcmVzcG9uc2UgdG8geW91ciBwYXRjaCwg
eW91IA0Kc2hvdWxkIGVuc3VyZSB0aGF0IGFsbCBtYWludGFpbmVycyBvdXRwdXQgYnkgLi9z
Y3JpcHRzL2dldF9tYWludGFpbmVyLnBsIA0KYW5kIHRoZSByZWxldmFudCBvcGVuIG1haWxp
bmcgbGlzdHMgYXJlIGZ1bGx5IHByZXNlbnQgaW4geW91ciByZWNpcGllbnQgDQpsaXN0Lg0K
DQpUaGFua3MsDQotLSANCldhbmdZdWxpDQo=
--------------wrV00aSyKd0gd7bLn3pf6ovz
Content-Type: application/pgp-keys; name="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSK
P+nX39DNIVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAx
FiEEa1GMzYeuKPkgqDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMB
AAAKCRDF2h8wRvQL7g0UAQCH3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfP
bwD/SrncJwwPAL4GiLPEC4XssV6FPUAY0rA68eNNI9cJLArOOARmgSyJEgorBgEE
AZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7VTL0dvPDofBTjFYDAQgHwngE
GBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIbDAAKCRDF2h8wRvQL
7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkUo9ERi7qS
/hbUdUgtitI89efbY0TVetgDsyeQiwU=3D
=3DBlkq
-----END PGP PUBLIC KEY BLOCK-----

--------------wrV00aSyKd0gd7bLn3pf6ovz--

--------------iiPgVCIWWmMhxp9ZmuRv0Sug--

--------------qLiP73nPuROm2ta6KfVvNMdZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCaAUVawUDAAAAAAAKCRDF2h8wRvQL7rKP
AQDgmCXxwbXKb46wPrUJdmVltSb51mvqb+EA5426+hYlygD+JxxdnIuLpu0tdhPZlDBlBxlrsopH
/orCwLlmlPBPAQ0=
=HNz+
-----END PGP SIGNATURE-----

--------------qLiP73nPuROm2ta6KfVvNMdZ--

