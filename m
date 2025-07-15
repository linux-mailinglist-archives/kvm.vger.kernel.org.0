Return-Path: <kvm+bounces-52441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FB9B053CF
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99E55178C8E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F31273D68;
	Tue, 15 Jul 2025 07:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="GvOUTcsQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12192376E4;
	Tue, 15 Jul 2025 07:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752566067; cv=none; b=juckqGqfEcoFd2bxlcGOzbD4N7kDMD9UdbM22yksQyFVl17sd5fXBhM/uFI/g6OOUGikPHNR4co41LVG+NDrInf/EvEpbxn1ubGB6V2sRRd6C+ml9CHV8vhf/Z1OvYgCS+vql+RcQlnosy5P4oKyJhG/6KzZd4SVCtAKYWtQ6O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752566067; c=relaxed/simple;
	bh=lCZvuab/16TaVwQ5rI7WJwbKeMlM/ItuANoajbv3L2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UcRjC+OxF7hQGeAEExwvz4hJudcqRTYV0gTKocxLdxRhSW4BWCPSXYE5ZZN5YYjOp52kl2cqGXSyBZB6KLhFyHvboq8jCY/7sKLID0ZK5ZFnzYg6j6x0g6vn/+QaIy6ryoOQnRBjrNCb6CMmJeCFREdEXG1bAjZXU/7z1rPejzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=GvOUTcsQ; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752566049;
	bh=lCZvuab/16TaVwQ5rI7WJwbKeMlM/ItuANoajbv3L2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=GvOUTcsQ0UoadDICiEt6+VJfaFPHzCh9gwbP0LkxbQZJyoBJZZUG/0Hymn8AqBYQm
	 DexfKsMAA1ubXMVqQOn9Lx4s5wgORGE7/ET+7RkNPjJnK+OoEcE+KBOdBc6SlB3SMc
	 yDiP22C7y3jJeGCwANgSu7M+r17s4RwAFGWh2Mqc=
X-QQ-mid: zesmtpip2t1752566003tb4774524
X-QQ-Originating-IP: jjkK/Vf4L74BdD9kpYPdRm9xTrp/Q9zcy1uOS8r9kg4=
Received: from [IPV6:240e:668:120a::212:232] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 15:53:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8211430334960576053
EX-QQ-RecipientCnt: 62
Message-ID: <5D06C25920559D71+06c9ce34-9867-495c-9842-dcfe9f1d51bb@uniontech.com>
Date: Tue, 15 Jul 2025 15:53:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] treewide: Fix typo "notifer"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, dave@stgolabs.net, jonathan.cameron@huawei.com,
 dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, dan.j.williams@intel.com, lucas.demarchi@intel.com,
 thomas.hellstrom@linux.intel.com, rodrigo.vivi@intel.com, airlied@gmail.com,
 simona@ffwll.ch, marcin.s.wojtas@gmail.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, arend.vanspriel@broadcom.com,
 ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
 jirislaby@kernel.org, jgross@suse.com, sstabellini@kernel.org,
 oleksandr_tyshchenko@epam.com, akpm@linux-foundation.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ming.li@zohomail.com,
 linux-cxl@vger.kernel.org, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, netdev@vger.kernel.org, kvalo@kernel.org,
 johannes.berg@intel.com, quic_ramess@quicinc.com, ragazenta@gmail.com,
 jeff.johnson@oss.qualcomm.com, mingo@kernel.org, j@jannau.net,
 linux@treblig.org, linux-wireless@vger.kernel.org,
 brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org,
 shenlichuan@vivo.com, yujiaoliang@vivo.com, colin.i.king@gmail.com,
 cvam0000@gmail.com, zhanjun@uniontech.com, niecheng1@uniontech.com,
 guanwentao@uniontech.com
References: <B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com>
 <2025071545-endnote-imprison-2b98@gregkh>
Content-Language: en-US
From: WangYuli <wangyuli@uniontech.com>
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <2025071545-endnote-imprison-2b98@gregkh>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FHPp0EXrNW93l6uPQg7ZugeB"
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NXYTmzXqcntChLNNnzN4csZx8cgiRqzAab7mDkQ5SlDkXhOmNCFVCvEj
	Dx61x+kPjQJaX9t8phqbJPfUdv6d3CG+FPs9el8Pq/QfYwtVEh/mKXycaD/CbXtYd9jBxqS
	/aqYhsRZwgXQP9P163hOL4VvtEkPPZHNh4xlo6VG7/WirT/dM0SMRCqM3ZYbCwKl0UbJR3m
	fxLLhzRUWFhFnUCCXhH/qM42vU407yPXXCo7m4RqoJrO8wCzo+49FmZpmy5zNzakA2zX93t
	6OkcCS1lVYGzPPqyLSd5PsmUWRjTnVen7x4uM4eZUfYFW0Zkyvh505XQY4nqpRw0hUitblu
	nx0gCSJXW9arSp006ZJpkZ5689NY8N9iRNRE9q5r3+nnQNJzIZ0sci/v9lt93nLMtRV5pv/
	6SnUdlZabxDEqG7tDPXoOhWzGAcPDrS8dwulrkTq80nRzclCtS+zZoDKQacEZ8GKv+Jz7cp
	hgYfDra/uQCp1KeZvDF53s0JkOV8iypG9ie0tqsEp0qXDeOm/vJB8zBFNT8CrejnCYrgg6G
	ud4w69CBtxUqTjKqrGOuFpb2/yh3udN3z4xjxbaVKmi4HHogyQig2svDaf580DL+BXgpfcF
	PWcbvH0RalyymDjfQmFcJqU9AV1cmkTbklD+N0mP5HvQZYitU42sRo/CcEvMn4r/zrwDrb0
	sFmllTQsurbto2TKbaFZqMCkeEPboH/E5JmtgOUHjWwMVcLYPCsKhZ8+6klk4HRHo7uZCoN
	TkAGkYO90X7mAH7Xs0grbWcYY3/TsStdFKaquMrJ5u9tGaARqPFCSLW7h7jca3wravyAdH9
	zLrV+u8Ss6oZBc+R+4OXlykT6MCTWo3D/Ammkk/H1RoTB2ETleM4xA4PUUXTzQXGX1NLGZd
	HRvSndyV01Bpgdk9ZvMqUQsJX7xXv5qLdfB5bKbYfEhFH0TG6jKi0s6vAzwJaB6c2aP8b3c
	8OPoYWjYZHpfNKbpSTKQ/6QIDvxDoz17+LxZUixuR6gltIRnxOTmxCjAgR6/HtWSZpB3nOZ
	jNRpvbotFiOP/oafyERSBz2ruA6j2PhgPuQMTkgrqUFQ3Xk/uEVru1X+AI1SHfZmfbhi7Py
	fHr2+ZsvlpE5BuwZ53ASLOJeJ21MEG9bYY2mOlf5FK2
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------FHPp0EXrNW93l6uPQg7ZugeB
Content-Type: multipart/mixed; boundary="------------Jc6hPek6M3VHoBxxe00gmN7f";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, dave@stgolabs.net, jonathan.cameron@huawei.com,
 dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, dan.j.williams@intel.com, lucas.demarchi@intel.com,
 thomas.hellstrom@linux.intel.com, rodrigo.vivi@intel.com, airlied@gmail.com,
 simona@ffwll.ch, marcin.s.wojtas@gmail.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, arend.vanspriel@broadcom.com,
 ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
 jirislaby@kernel.org, jgross@suse.com, sstabellini@kernel.org,
 oleksandr_tyshchenko@epam.com, akpm@linux-foundation.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ming.li@zohomail.com,
 linux-cxl@vger.kernel.org, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, netdev@vger.kernel.org, kvalo@kernel.org,
 johannes.berg@intel.com, quic_ramess@quicinc.com, ragazenta@gmail.com,
 jeff.johnson@oss.qualcomm.com, mingo@kernel.org, j@jannau.net,
 linux@treblig.org, linux-wireless@vger.kernel.org,
 brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org,
 shenlichuan@vivo.com, yujiaoliang@vivo.com, colin.i.king@gmail.com,
 cvam0000@gmail.com, zhanjun@uniontech.com, niecheng1@uniontech.com,
 guanwentao@uniontech.com
Message-ID: <06c9ce34-9867-495c-9842-dcfe9f1d51bb@uniontech.com>
Subject: Re: [PATCH] treewide: Fix typo "notifer"
References: <B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com>
 <2025071545-endnote-imprison-2b98@gregkh>
In-Reply-To: <2025071545-endnote-imprison-2b98@gregkh>

--------------Jc6hPek6M3VHoBxxe00gmN7f
Content-Type: multipart/mixed; boundary="------------sUIOFoVilt68TT8Wt0dx0iNl"

--------------sUIOFoVilt68TT8Wt0dx0iNl
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZ3JlZyBrLWgsDQoNCk9uIDIwMjUvNy8xNSAxNToyMiwgR3JlZyBLSCB3cm90ZToNCj4g
UGxlYXNlIGJyZWFrIHRoaXMgdXAgaW50byBvbmUtcGF0Y2gtcGVyLXN1YnN5c3RlbSwgbGlr
ZSBpcyByZXF1aXJlZCBmb3INCj4gdGhpbmdzIGxpa2UgdGhpcy4NCj4NCj4gdGhhbmtzLA0K
Pg0KPiBncmVnIGstaA0KPg0KSG9uZXN0bHksIEkndmUgYWx3YXlzIGJlZW4gcXVpdGUgdW5z
dXJlIGhvdyB0byBoYW5kbGUgc2l0dWF0aW9ucyBsaWtlIHRoaXMuDQoNCkl0IHNlZW1zIGV2
ZXJ5IHN1YnN5c3RlbSBtYWludGFpbmVyIGhhcyBkaWZmZXJlbnQgcHJlZmVyZW5jZXMuIEkn
dmUgDQpwcmV2aW91c2x5IGVuY291bnRlcmVkIHNvbWUgbWFpbnRhaW5lcnMgd2hvIHN1Z2dl
c3RlZCBJIHNwbGl0IHN1Y2ggDQpwYXRjaGVzIGJ5IHN1YnN5c3RlbSBzbyBlYWNoIG1haW50
YWluZXIgY291bGQgbWVyZ2UgdGhlbSBpbnRvIHRoZWlyIHRyZWUgDQp3aXRob3V0IGNvbnRl
bnRpb24uIEhvd2V2ZXIsIG90aGVyIG9uZXMgaGF2ZSBhcmd1ZWQgdGhhdCBmaXhpbmcgc3Bl
bGxpbmcgDQplcnJvcnMgaXNuJ3Qgd29ydGggbXVsdGlwbGUgY29tbWl0cywgY2xhaW1pbmcg
aXQgd291bGQgY3JlYXRlIGNoYW9zLg0KDQpTaW5jZSBJIGdlbnVpbmVseSBkaXNjb3ZlciB0
aGVzZSBzcGVsbGluZyBlcnJvcnMgYnkgY2hhbmNlIGVhY2ggdGltZSwgDQphbmQgdG8gYXZv
aWQgZ2l2aW5nIHRoZSBpbXByZXNzaW9uIEknbSAic3BhbW1pbmciIHRoZSBrZXJuZWwgdHJl
ZSBmb3IgDQpzb21lIHVsdGVyaW9yIG1vdGl2ZSwgSSd2ZSBvcHRlZCB0byBzcXVhc2ggdGhl
bSBpbnRvIGEgc2luZ2xlIGNvbW1pdC4NCg0KVGhhdCBzYWlkLCBJIHBlcnNvbmFsbHkgZG9u
J3QgaGF2ZSBhbnkgc3Ryb25nIGZlZWxpbmdzIG9yIHByZWZlcmVuY2VzIG9uIA0KdGhpcyBt
YXR0ZXIuIFNpbmNlIHlvdSd2ZSByZXF1ZXN0ZWQgaXQsIEknbGwgZ28gYWhlYWQgYW5kIHNw
bGl0IGl0IHVwIA0KYW5kIHNlbmQgYSB2MiBwYXRjaHNldC4NCg0KVGhhbmtzLA0KDQotLSAN
CldhbmdZdWxpDQo=
--------------sUIOFoVilt68TT8Wt0dx0iNl
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

--------------sUIOFoVilt68TT8Wt0dx0iNl--

--------------Jc6hPek6M3VHoBxxe00gmN7f--

--------------FHPp0EXrNW93l6uPQg7ZugeB
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCaHYI7gUDAAAAAAAKCRDF2h8wRvQL7oEn
AP9MLViBb0RqjK9xx+PcIi0hiZmUC/37qYH8rnmPBkSAXQEAtm2V/wO2Wv0JvbeWgMrpl99ZvtNN
kg8rYtwbJwIkrA4=
=lTpo
-----END PGP SIGNATURE-----

--------------FHPp0EXrNW93l6uPQg7ZugeB--

