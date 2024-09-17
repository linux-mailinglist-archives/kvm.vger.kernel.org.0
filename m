Return-Path: <kvm+bounces-27031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD1997AD0E
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 10:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2661B283866
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 08:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1889A1581F4;
	Tue, 17 Sep 2024 08:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="D5KaWB03"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BC9146D6B;
	Tue, 17 Sep 2024 08:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726563000; cv=none; b=E1hspCc3U8RljJBeSOQ6b0/IUDEJbs9ujAWBp0djvTgNwNdiLWDIJhSNvvDCP0bOCur3uAdMs4JPJJcSEP8IxbO5DtAufMx6HgkzGhfaBWMLuLi3Nbpvrec/bkPpHJZ2RYVl++UD26RFtMO8+DRyWsQO3HbVze1z3S6LHWkcMMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726563000; c=relaxed/simple;
	bh=LssHL0o8gqHlXpaUgFEYZYDWsFgM2dA16ib5MYaTLvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jP1xfEEnbYW0Bagp/zhxwzPXQrsCr6O9JNtUcv9dgi8a4iP/Itx/a/E0jOdyS7RJ8pOap6FDpS02YMgDPo/iOll+4riZ5Y70VHM2W6eiO9G9ANde6CimZKU9oGMAmmiTOGRXCGmrNdPIdRHD+BbPabgkF2EZW+H/V8z/P9nnc+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=D5KaWB03; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1726562953;
	bh=LssHL0o8gqHlXpaUgFEYZYDWsFgM2dA16ib5MYaTLvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=D5KaWB03cjATfV9q/yXc56NbLefmoAyEBdyO0aGWw9sbrJbqWswDSNORYVYt3ABrV
	 nHNQtBQrEaF+Q2AKXdNo3h26a8frvlGSr6nIz6ZjjRW2577R5y/Z2g9yPEFGxmapO2
	 H5kVKHwo6VReQQIum4Gzh4tylIpfMsEl4oiQPu64=
X-QQ-mid: bizesmtpip2t1726562946tqwms51
X-QQ-Originating-IP: G+YseKVbbTNQgJwSB8iy9v4u6ESfp3jPo6df9dsT3bo=
Received: from [IPV6:240e:36c:d18:fa00:4838:7a ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 17 Sep 2024 16:49:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6379166551292348725
Message-ID: <3E9630B3C9FBF09F+32098b9e-b18a-4252-b8c6-a766f3de84b4@uniontech.com>
Date: Tue, 17 Sep 2024 16:49:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6.10] LoongArch: KVM: Remove undefined a6 argument
 comment for kvm_hypercall()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, sashal@kernel.org, maobibo@loongson.cn,
 guanwentao@uniontech.com, zhangdandan@uniontech.com, chenhuacai@loongson.cn,
 zhaotianrui@loongson.cn, kernel@xen0n.name, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <5B13B2AF7C2779A7+20240916092857.433334-1-wangyuli@uniontech.com>
 <2024091647-absolve-wharf-f271@gregkh>
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
In-Reply-To: <2024091647-absolve-wharf-f271@gregkh>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HDUTo0wGYhCUeLHRnq3cTPTT"
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HDUTo0wGYhCUeLHRnq3cTPTT
Content-Type: multipart/mixed; boundary="------------TPiiqvvKxfu54ZhFQ02qlh8n";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, sashal@kernel.org, maobibo@loongson.cn,
 guanwentao@uniontech.com, zhangdandan@uniontech.com, chenhuacai@loongson.cn,
 zhaotianrui@loongson.cn, kernel@xen0n.name, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Message-ID: <32098b9e-b18a-4252-b8c6-a766f3de84b4@uniontech.com>
Subject: Re: [PATCH v2 6.10] LoongArch: KVM: Remove undefined a6 argument
 comment for kvm_hypercall()
References: <5B13B2AF7C2779A7+20240916092857.433334-1-wangyuli@uniontech.com>
 <2024091647-absolve-wharf-f271@gregkh>
In-Reply-To: <2024091647-absolve-wharf-f271@gregkh>

--------------TPiiqvvKxfu54ZhFQ02qlh8n
Content-Type: multipart/mixed; boundary="------------vt0AXiXzEA4MnK0wswNOi5e5"

--------------vt0AXiXzEA4MnK0wswNOi5e5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQpPbiAyMDI0LzkvMTYgMTk6MzksIEdyZWcgS0ggd3JvdGU6DQo+IEFnYWluLCB3aHkgaXMg
dGhpcyBuZWVkZWQ/DQo+DQpIbW0uLi4NCg0KSnVzdCBhIG1pbmkgJ2ZpeCcuDQoNClRoZSBy
ZWFzb24gb2YgDQonaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjQwOTE2MjgtZ2ln
YW50aWMtZmlsdGgtYjdiN0BncmVna2gnIGlzIHNhbWUuDQoNCj4gdGhhbmtzLA0KPg0KPiBn
cmVnIGstaA0KPg0KVGhhbmtzLA0KLS0gDQpXYW5nWXVsaQ0K
--------------vt0AXiXzEA4MnK0wswNOi5e5
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

--------------vt0AXiXzEA4MnK0wswNOi5e5--

--------------TPiiqvvKxfu54ZhFQ02qlh8n--

--------------HDUTo0wGYhCUeLHRnq3cTPTT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZulCgAUDAAAAAAAKCRDF2h8wRvQL7tVy
AP9MVhEXseSIS+VfhuY0FCwd0fhc6z2XDqNn6WlPwB/JRgEAgKIGARi2cYl/nSW/o/w3RsclJn16
NEjRYCfUQ98+tgI=
=7q2+
-----END PGP SIGNATURE-----

--------------HDUTo0wGYhCUeLHRnq3cTPTT--

