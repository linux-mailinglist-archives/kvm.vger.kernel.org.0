Return-Path: <kvm+bounces-65223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1634FC9FC65
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 17:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1F5583006717
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 15:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7072633A70D;
	Wed,  3 Dec 2025 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FFEaKLUd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F166A3370EB
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777371; cv=none; b=R3k0qJe5JQbvsJH4pIpe2XT+MZdKJH2840HR24yOYtetzbao6S2ckbWfw3MUuN+ugBh9xPX776v+6boqK9vUf6JgfoUpdj+fWD96X0CVZHJdxvf/ka3CxLZJ5rO1Os9vcU8b30bqHCS84deWxgZYd74Mbl1ixor+PFo07+Nf+PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777371; c=relaxed/simple;
	bh=rGwUVR+Yo8u1COwzMDod6hKjMoB7taY0GEiWuVQTc1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IHjA86ZmoExapbI2mlr7EVDki45iL77XcLsN17kd5A3DmS/BB/TvZEgUXjRx7aOzvjK4LWwuSVkR/g3a7b1P9DXgQwqI/yb7Jgz4tw0Nar8PTFEAOYZTm3NnfupItaJ48Q9aWut3mV/FE1XvYkY6ePM+FsXFGQZUaS2usH3Pk6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FFEaKLUd; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so4980195a12.0
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 07:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764777363; x=1765382163; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rGwUVR+Yo8u1COwzMDod6hKjMoB7taY0GEiWuVQTc1o=;
        b=FFEaKLUdDy0DSd4xT0fPRdGFJX0iBhDtrdmWRRILcTkx+/v6sbSG1gPOCfcweww6Tz
         oN83XYRQLG0S7o2HQ9g46/PeQDsHKqAzNH1S7i4D+1TCS7yTxZvWOSSHgSJI6yTmsgta
         SA7HFjtSDGajzdO2y0D3/fUzHJDJ99VCKfAXmoYJlHymxGxfq3aF5WhJ1WNT0T5b9gKy
         emekpEEzT1L9pVQobIqKVTxENeRzvn02HbMbU26IUEFFzt3bQEs1K3Cl+F7kyA1IOhn0
         YZj6Ai/VjHr/BOYHtrxLdn4DoAs9VUyAxngC5J+sxia8ScG7uPBYspSqQOp+8n5snEDD
         ei0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764777363; x=1765382163;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGwUVR+Yo8u1COwzMDod6hKjMoB7taY0GEiWuVQTc1o=;
        b=QNT7Xwv5w6WfiKxok0TW1DKKFUuRC5Cloyw4KZmpbvJ9e033C1kYJ7WOHlePdZ8Cwh
         Lz8sJJBWeCrClTfzVD5QE9FWlFRryaqO/g4mkT42aU5/o6umUwkU16+IG9mFDsutUf0o
         p+avpQIZq1lsZcQtzuqz00Jkc1BIOsRqakc8WUYqbSQmbTX/8BxrQJGBgiEAbsjMnLZt
         WurJ4pAPE35aHPWrQP5UdNz2yE9AEwBCijNT0k9BATTVsZ1f2gMVxm+hSZ6LCqVvXtsy
         W++XTP5KjPrQzmXb9kEqPQGu4n1VxToIYFwv2C4geVmipFRvmf8UpoHxMNNP9uV7UHU5
         ytIQ==
X-Gm-Message-State: AOJu0Yw6ddiuw6y7WxtKAenDM2asYxr3+Em8JVXj338NQflerE/eQxET
	HNQJWy2dwQs0JbXlBYVpHQgM4wzwrQgjSCOU/0dX7NyGmodG+kM0cb0bNXaWkD1nu/U=
X-Gm-Gg: ASbGnctXa1hpm/1m7GEDUCSj8+cIsgQExHPipp+k1MFSv/D0R8AGY3/oYJJcUi9BHHm
	3Y95dL+JZDTsjEi0rr6f3Y6n1TqJrl71TNLOF+Xt4gVWJKuutPhHUyO6pO2ww9xYuB95/ZmKVVQ
	mbHZYHvcFFyHd1+PvqtPqlrhRacCCY9/OGg4b4SUWm9mxP1Oq0kTHliDTNEHUzuHiS5sI6jqGCJ
	Xwg4J1IZ37PEnMAmkKQSjUPJEfS9XDoMwR/80q2o25a/AOBM8rilPakDkn8UCQVPyzKlckas6xF
	Z2/v7V28IVyBqnrO/unHhUN3TA8TUSeBev8w9/ccTVl60GHShp4tjIj9h9lHjnQChcfV4nF6a+S
	HWt+ccBtBfQnd6Nodh5fGCHQO9Hncn0e4vpit2HncSArlm/yb9kgXsoQ1zXu/RAYHWxytOvzbAY
	QQCctR1UergHVhC2Fdp/enPzRK/kCcrIbe5AA7lgQZTyXdxP3oPvn6eZ8SN2OuTerzE0lELZEwn
	O2lRmt7jSxHENHx0wOzeMV6zZ0A3N+m8xbnBMJVK0/jS2o=
X-Google-Smtp-Source: AGHT+IFzMoHXMvPnvPGUzvn/vx6+nfEiLoC9s5Ug4YFQdJmhDa4LIG8rBroQF9b6s48OOMZFczAzww==
X-Received: by 2002:a05:6402:3490:b0:645:dc63:d467 with SMTP id 4fb4d7f45d1cf-6479c4d07f2mr2302837a12.31.1764777363026;
        Wed, 03 Dec 2025 07:56:03 -0800 (PST)
Received: from ?IPV6:2003:e5:8721:bb00:9139:4e25:a543:997? (p200300e58721bb0091394e25a5430997.dip0.t-ipconnect.de. [2003:e5:8721:bb00:9139:4e25:a543:997])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647510615c0sm18955089a12.30.2025.12.03.07.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 07:56:02 -0800 (PST)
Message-ID: <032a028f-9fe5-4839-a596-f4e6317d7946@suse.com>
Date: Wed, 3 Dec 2025 16:56:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
To: Bibo Mao <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, x86@kernel.org
References: <20251202024833.1714363-1-maobibo@loongson.cn>
 <20251202024833.1714363-3-maobibo@loongson.cn>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20251202024833.1714363-3-maobibo@loongson.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------EZw1MvBXaSvkPDo4EOD01VVW"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------EZw1MvBXaSvkPDo4EOD01VVW
Content-Type: multipart/mixed; boundary="------------a5fJUwHmYWdNLGNpd1wdClpm";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Bibo Mao <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, x86@kernel.org
Message-ID: <032a028f-9fe5-4839-a596-f4e6317d7946@suse.com>
Subject: Re: [PATCH v3 2/2] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
References: <20251202024833.1714363-1-maobibo@loongson.cn>
 <20251202024833.1714363-3-maobibo@loongson.cn>
In-Reply-To: <20251202024833.1714363-3-maobibo@loongson.cn>

--------------a5fJUwHmYWdNLGNpd1wdClpm
Content-Type: multipart/mixed; boundary="------------K000PKIClv4O3gxWiudeC0FG"

--------------K000PKIClv4O3gxWiudeC0FG
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDIuMTIuMjUgMDM6NDgsIEJpYm8gTWFvIHdyb3RlOg0KPiBGdW5jdGlvbiB2Y3B1X2lz
X3ByZWVtcHRlZCgpIGlzIHVzZWQgdG8gY2hlY2sgd2hldGhlciB2Q1BVIGlzIHByZWVtcHRl
ZA0KPiBvciBub3QuIEhlcmUgYWRkIGltcGxlbWVudGF0aW9uIHdpdGggdmNwdV9pc19wcmVl
bXB0ZWQoKSB3aGVuIG9wdGlvbg0KPiBDT05GSUdfUEFSQVZJUlQgaXMgZW5hYmxlZC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEJpYm8gTWFvIDxtYW9iaWJvQGxvb25nc29uLmNuPg0KDQpB
Y2tlZC1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KDQoNCkp1ZXJnZW4N
Cg==
--------------K000PKIClv4O3gxWiudeC0FG
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------K000PKIClv4O3gxWiudeC0FG--

--------------a5fJUwHmYWdNLGNpd1wdClpm--

--------------EZw1MvBXaSvkPDo4EOD01VVW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmkwXZEFAwAAAAAACgkQsN6d1ii/Ey/A
6gf+OzJ1GuN+i4gYgw0rrRsFkDE/iIZ8rlg42muTU7O5Tzj6EbOcKdgP3hhuMhwAUvSdnaGzSJfL
K5hTIUpAfhOzdDwf4e3Rn8vzQ8v1iWjDHn4K9bcwWLtNBCho22cW/7tJNvD6f+JFHzinFQKXcb0W
9z2VLGlEqA+4DaMysNBzgBM7h8gIqnOUgUv2v7AyuPRtNj5aytgVzcqkmBOQRN0VRlHtZbtV43Bn
5CnrZzSkIsNC1cd6C9t/7GIyjNGR6O/3eCx0oWVFhDJ4N9ljeB6N8dYl1d12s6Pv8qI9YTfUkdA7
Q//lMusSKlMF2p8IjOK1oMgATLlqclqubyE/llgPaQ==
=n+FE
-----END PGP SIGNATURE-----

--------------EZw1MvBXaSvkPDo4EOD01VVW--

