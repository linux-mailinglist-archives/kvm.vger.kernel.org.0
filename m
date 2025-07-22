Return-Path: <kvm+bounces-53088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90461B0D2D2
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:26:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEFBD1888CE6
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6912D3757;
	Tue, 22 Jul 2025 07:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="pyn8oqxM"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1AA2D3731;
	Tue, 22 Jul 2025 07:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169011; cv=none; b=UJb3rj+CS0GeMvKHvwIQoEgTsWMKo5ch9a6cFEjaL9f/BotCiGGV9Yewf22Hs41T1X0qwkcqvV1AHVmbLjZ2p0nmwrTAy9lNj3yzaNevfX12zOoGL58jwI7tn5wLmd2v8SzIMNcAl1s7XSWNC93KHvSKDytyRiz4yzaGHh4GZno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169011; c=relaxed/simple;
	bh=4HhP2iNixfpmY9GA50RldzfymFrP5PRb/ex2XnKjRrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUuVR85o9QllVSKZeiybnqBL/B5mWkoxjZMfmZ6IxpJeAEudUQ/SNlwg1h4bXJRwQg/OI91qzwZmUCvQhc/UX+ugatosuP7l4DmsoCtg8BP2rAPaZoqLPM8G2hg0KReitnnJ6oqPtfokj8CkLH9US28Udll32dgDU7iQx3E2Puo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=pyn8oqxM; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753168997;
	bh=4HhP2iNixfpmY9GA50RldzfymFrP5PRb/ex2XnKjRrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=pyn8oqxMFVyi5/6u5O+odRk6o68nQVzc/WsLV6rpP1XwkSHdeghCjlBGJ8RN3lpSF
	 K43Aw/Bx0veG9oUwOUKjGuCFBSP6OWdAIfRtQlZpIztGfODuJwBO6t8aCQlu2ogtXt
	 FGaywg7Lu9sq115FB56KRtDlohLn9P3ayQOFCz0Y=
X-QQ-mid: zesmtpip4t1753168943tb2aa8fc1
X-QQ-Originating-IP: jlkPh//3cQuVzne1YV9Hj8c3k19VYTQ4PPPWu+FTW/A=
Received: from [IPV6:240e:668:120a::212:232] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 15:22:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3880468087656715595
EX-QQ-RecipientCnt: 62
Message-ID: <634BA467821D37FE+0b2ace38-07d9-4500-8bb7-5a4fa65c4b9f@uniontech.com>
Date: Tue, 22 Jul 2025 15:22:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] serial: 8250_dw: Fix typo "notifer"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: airlied@gmail.com, akpm@linux-foundation.org, alison.schofield@intel.com,
 andrew+netdev@lunn.ch, andriy.shevchenko@linux.intel.com,
 arend.vanspriel@broadcom.com, bp@alien8.de,
 brcm80211-dev-list.pdl@broadcom.com, brcm80211@lists.linux.dev,
 colin.i.king@gmail.com, cvam0000@gmail.com, dan.j.williams@intel.com,
 dave.hansen@linux.intel.com, dave.jiang@intel.com, dave@stgolabs.net,
 davem@davemloft.net, dri-devel@lists.freedesktop.org, edumazet@google.com,
 guanwentao@uniontech.com, hpa@zytor.com, ilpo.jarvinen@linux.intel.com,
 intel-xe@lists.freedesktop.org, ira.weiny@intel.com, j@jannau.net,
 jeff.johnson@oss.qualcomm.com, jgross@suse.com, jirislaby@kernel.org,
 johannes.berg@intel.com, jonathan.cameron@huawei.com, kuba@kernel.org,
 kvalo@kernel.org, kvm@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux@treblig.org, lucas.demarchi@intel.com,
 marcin.s.wojtas@gmail.com, ming.li@zohomail.com, mingo@kernel.org,
 mingo@redhat.com, netdev@vger.kernel.org, niecheng1@uniontech.com,
 oleksandr_tyshchenko@epam.com, pabeni@redhat.com, pbonzini@redhat.com,
 quic_ramess@quicinc.com, ragazenta@gmail.com, rodrigo.vivi@intel.com,
 seanjc@google.com, shenlichuan@vivo.com, simona@ffwll.ch,
 sstabellini@kernel.org, tglx@linutronix.de,
 thomas.hellstrom@linux.intel.com, vishal.l.verma@intel.com, x86@kernel.org,
 xen-devel@lists.xenproject.org, yujiaoliang@vivo.com, zhanjun@uniontech.com
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com>
 <2025071607-outbid-heat-b0ba@gregkh>
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
In-Reply-To: <2025071607-outbid-heat-b0ba@gregkh>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------1TBt0IFfjz321DLdIVEctMps"
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: MVMPUihGUVea5jC3xP71FloNgLs8c4GIbCy1lVegKOJGtyiH/TtMX/UO
	5TjeFrsS0OTJUZa6dpCWlkanhO5MPxx9iMnxogCbZfODUw+ib83N47qt29EpEG8Krd6tKIR
	FJTnraw/TquVA9OP3CmZUx8xIKgFUX4/1YZ+IJE88UcpS2W5wmhdW2//7czYTQzafSpYgxW
	XE4xJC2ukspya/nvLIOUfxdrj54Lt4DSzPUy5xO4ylS8K3J0PkjbCTMo7dvByLIjp41vwVe
	DsToiutuoxZEWKhrAnrG2jp4YhgVSYWEingT2tw1mTRHcCoJPIGNPlaLlczLmI4uu5vddgb
	ZYNjWakNh0yxkNmU/0TsAflRRlVBhKjDClQosa+htxmarTLE7imj6YmEykr5fj1kGnYt2Vq
	mqsrpEpwoES4bUcM6H1AzLAUijkizu0mUEVB+fxEVdrOB8iQe6xkDkodf2PlbQaAH3Ca/wz
	Y2Q6VhC1L47CvMeMK5qAJ7SD473Gsc3bezOfo7WFS8Ez5lu7Gh8Elu5GsWFXdhH9eShp3L8
	Fohcycdr8WjvxakwXIj7LupCwM2zytQQ9LqajGpKRJgJs3HVspzutijsVzwoCD1shfI+WAM
	X0oLSTTeJjvFyELfZy8YkyJq3k6n67CMQ0vknFXTUwtgIQbk9YHI2ScEg4Xd40GovymLubn
	bXp+aLh4o39SCjTTxt41RChCfUZHVsgVwbW6w68G9XnPojegPOe5Z6TYCvM/TVPnaZKWoeS
	PTxWgREgrmjejdqSc5J9O+OhouoVgw5EG7RHm4hwIaCgRx2hpXIGlYjkz/3Pd0UtdJ2ryFH
	Ytxmd2kqCiZ5PDah7j3W/oqLoD5c/YwIPRKWDWnX2hsKWo3LwBCHiOdirphtdazK64oywSy
	GUV1D68DYcMBcagXma4UBx8o4WBHko9Mij75waKlNdehxEgDHuESjcm4rUGm5ywAnaN8fjk
	VgOzj5ff6Wg9yxrf0dWtIcwNI6N88u0jfDrJWjyNnqbofuJAbudmmEhNphPpLfhf/zn9kPF
	aarl2LPW/rtiHIgPqPdYfLOrFdtTVjR0Uch9gvPRRKIgRIEMafbhGxUFc2viKZvB1GA1mOc
	ag52OeWY+km5YpVFUwDHLr0BSsN9SiKI083dmne+7JQ
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------1TBt0IFfjz321DLdIVEctMps
Content-Type: multipart/mixed; boundary="------------7NzxUd2CIcc1X22DyUWciByd";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: airlied@gmail.com, akpm@linux-foundation.org, alison.schofield@intel.com,
 andrew+netdev@lunn.ch, andriy.shevchenko@linux.intel.com,
 arend.vanspriel@broadcom.com, bp@alien8.de,
 brcm80211-dev-list.pdl@broadcom.com, brcm80211@lists.linux.dev,
 colin.i.king@gmail.com, cvam0000@gmail.com, dan.j.williams@intel.com,
 dave.hansen@linux.intel.com, dave.jiang@intel.com, dave@stgolabs.net,
 davem@davemloft.net, dri-devel@lists.freedesktop.org, edumazet@google.com,
 guanwentao@uniontech.com, hpa@zytor.com, ilpo.jarvinen@linux.intel.com,
 intel-xe@lists.freedesktop.org, ira.weiny@intel.com, j@jannau.net,
 jeff.johnson@oss.qualcomm.com, jgross@suse.com, jirislaby@kernel.org,
 johannes.berg@intel.com, jonathan.cameron@huawei.com, kuba@kernel.org,
 kvalo@kernel.org, kvm@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux@treblig.org, lucas.demarchi@intel.com,
 marcin.s.wojtas@gmail.com, ming.li@zohomail.com, mingo@kernel.org,
 mingo@redhat.com, netdev@vger.kernel.org, niecheng1@uniontech.com,
 oleksandr_tyshchenko@epam.com, pabeni@redhat.com, pbonzini@redhat.com,
 quic_ramess@quicinc.com, ragazenta@gmail.com, rodrigo.vivi@intel.com,
 seanjc@google.com, shenlichuan@vivo.com, simona@ffwll.ch,
 sstabellini@kernel.org, tglx@linutronix.de,
 thomas.hellstrom@linux.intel.com, vishal.l.verma@intel.com, x86@kernel.org,
 xen-devel@lists.xenproject.org, yujiaoliang@vivo.com, zhanjun@uniontech.com
Message-ID: <0b2ace38-07d9-4500-8bb7-5a4fa65c4b9f@uniontech.com>
Subject: Re: [PATCH v2 6/8] serial: 8250_dw: Fix typo "notifer"
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com>
 <2025071607-outbid-heat-b0ba@gregkh>
In-Reply-To: <2025071607-outbid-heat-b0ba@gregkh>

--------------7NzxUd2CIcc1X22DyUWciByd
Content-Type: multipart/mixed; boundary="------------3ELnNhbpHyc90r6KiSkcbbdY"

--------------3ELnNhbpHyc90r6KiSkcbbdY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZ3JlZyBrLWgsDQoNCk9uIDIwMjUvNy8xNiAxNjowOCwgR3JlZyBLSCB3cm90ZToNCj4+
IFNpZ25lZC1vZmYtYnk6IFdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPg0KPiBJ
cyB5b3VyIG5hbWUgYWxsIG9uZSB3b3JkIGxpa2UgdGhhdCwgb3Igc2hvdWxkIHRoZXJlIGJl
IGEgIiAiIGJldHdlZW4NCj4gdGhlbT8NCg0KSWYgSSB3ZXJlIHRvIGZvbGxvdyBXZXN0ZXJu
IG5hbWluZyBjb252ZW50aW9ucywgbXkgbmFtZSB3b3VsZCBiZSB3cml0dGVuIA0KYXMgJ1l1
bGkgV2FuZycuDQoNCkhvd2V2ZXIsIGZyYW5rbHksIEkgZmluZCBpdCB1bm5lY2Vzc2FyeSBh
bmQgY2FuJ3QgYmUgYm90aGVyZWQgdG8gZm9sbG93IA0KdGhlaXIgY3VzdG9tcywgdW5sZXNz
IGEgbWFpbnRhaW5lciBzdHJvbmdseSBpbnNpc3RzLiAoRm9yIGV4YW1wbGUsIHlvdSANCmNh
biBzZWUgdGhhdCBteSBzaWduYXR1cmUgb24gY29tbWl0cyBmb3IgdGhlIExvb25nQXJjaCBz
dWJzeXN0ZW0gaXMgDQpkaWZmZXJlbnQgZnJvbSBteSBvdGhlciBjb250cmlidXRpb25zKS4N
Cg0KU2luY2UgQ2hpbmVzZSBuYW1lcyBhcmUgd3JpdHRlbiB3aXRob3V0IGFueSBzcGFjZXMg
aW4gQ2hpbmVzZSANCmNoYXJhY3RlcnMsIEkgZG9uJ3QgdGhpbmsgaXQgbWF0dGVycy4NCg0K
PiBBbHNvLCBhcyBvdGhlcnMgc2FpZCwgZG9uJ3QgbGluayB0byB5b3VyIG93biBwYXRjaC4N
Ck9LLCBJJ2xsIHNlbmQgdGhlIHBhdGNoc2V0IHYzLg0KDQoNClRoYW5rcywNCg0KLS0gDQrn
jovmmLHlipsNCg==
--------------3ELnNhbpHyc90r6KiSkcbbdY
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

--------------3ELnNhbpHyc90r6KiSkcbbdY--

--------------7NzxUd2CIcc1X22DyUWciByd--

--------------1TBt0IFfjz321DLdIVEctMps
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCaH88KgUDAAAAAAAKCRDF2h8wRvQL7pms
AP9jnuV1Ar3880YbizkuBFljgc3bOdOu/RxLmWu2LJmNBAD/S6F38qLfKIrdjJNkNGO7V3LvW7p0
ssmAK5aDMMRZzAI=
=fJ9f
-----END PGP SIGNATURE-----

--------------1TBt0IFfjz321DLdIVEctMps--

