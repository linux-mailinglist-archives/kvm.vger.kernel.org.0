Return-Path: <kvm+bounces-52893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E926AB0A549
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22F8616BCB5
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4B8199FBA;
	Fri, 18 Jul 2025 13:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IQIZwGDW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A74242058
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752845827; cv=none; b=tiUciT4fg2ATX9eg5YzyTyHZ30+j7PjyZ64R5U43ZikmVdU8Y3lT0Cz77kk1jM1Mu7NFLY4X3NeMMF5Ru5iM29aQuLS71m91R3+dWdBn28671xV+oGpbO+o37nzKFLIL/AJMZ4i/3zsfkB34xqrqvMCpRK52SAjGjYxXQOdqZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752845827; c=relaxed/simple;
	bh=qxr0lo1TN0HaCQ7Fgn8BLcctimnaTlHOFjPoqfSkCzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eYslgVuPa4jJweIw0yK0MZlRyqbZri2z2sPwH1uwD5rq9bVwnXimVNj44jqklFWJiFGVLQ2QvlkXPC0T0L2GFoTh987xJHlaAWD4ZO3Z3zR2XbFa2MciLagFzTTaJl2qQWDfHZxBRxBjFBG/7CYS2j/cKW47Ip4AG5jje/axz7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IQIZwGDW; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae3cd8fdd77so385967866b.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 06:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1752845822; x=1753450622; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qxr0lo1TN0HaCQ7Fgn8BLcctimnaTlHOFjPoqfSkCzg=;
        b=IQIZwGDWdFQxiuDguV1uvGYsuC8Oao1MnOV6TvN4EVmc/Hv5RVVqnw68/JcfQBrqJy
         1lMBxKv7NbZ8bjbXIkNVqRF/iYOx8wpGBHLan28dMCSof+lU/1zEPLbQ6KmmMJXi6Cru
         gT7wFo6JBhbgYT8zGBZy8LiNkkkpr9VI84bUSN7dJ/3+FpSlqmT7EggKDTyjRseWCgPG
         LyOTDbG4UeS8eZzzAXl0UvtuVb/AZXMjS5rv2NuVAJGc9BKGWjedcdgvg/b0UuUyO1Zr
         ghvDN37kLUm+9mPlO0bP0G2OmYb4idzd7+8h5F7uFFE1XFSyACUQs84FYWVbW7d5g6dk
         n4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752845822; x=1753450622;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qxr0lo1TN0HaCQ7Fgn8BLcctimnaTlHOFjPoqfSkCzg=;
        b=bMVOHcwSV8xvqZOiZR4VMX5LbCUpBBoI5oeZyidffVCeXvc6A8mm44pScKCjm+1yAJ
         qH0uo8SNV4JZfL9eFBgFgWh8YXtpjS0bIOOZM6mmnNEvFrUSw4sl80aubg4O/NWZUjX8
         RRIGKVK0P9QTEOPhhUtSayQaTBtSm3wiAIMzSqa7PaK4YMQ8QFO7jaOxWXHNdHH1Q/8x
         Yh5rqqc5Qb34Clhx9UL97+0glv3Z/XGIeu3Qtt0EERrUyu2k4oWLaWd0RxAVQA0N4F2C
         Da6lju8OqvhvucffTvtLIHmPAfnJDnYGnAHq37UTXV3AHap3asAlSTs3+ua4k/kiQOyo
         REcA==
X-Forwarded-Encrypted: i=1; AJvYcCWrn5+ghtI8da2f2jGukE2W0GBcuZ8t0eXViqMtLD9PxR8IGH1mU+xVnJq6EdFewAVOVwM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP7rutOc17tVgJ6OWX5h0nB8EbABfQmetR65k0VrjTzqUSzn7f
	ctNceNVPTL68iLpPeGzlPfzdLOGac3sI+tdmE18g/Aqa/r1t/1iCT3kM1Kf2xAYWOJU=
X-Gm-Gg: ASbGncvxp4bxgauoZbKMjopGoJO8EFD+Wfz19LQ6MoknrATlVlH/36pL6Ai7s7u7RPA
	Rn+iw8F6NrLRap/XZgUTzRhkEUUbu6dZuFXMVtRMYTkua6HH59XdYqzzxnNf51hkl59QtYSGaQ2
	pdGXtlIYRUoGdoIB2t+NJ5gBaqHFIU5UxMrqbVWlZAimHSiuuhe4tefnAsHa60RrjZtz8Qglxt4
	T2bHfFMEiLoFVaAWg7KVEWZEHiXv/eVNuA+jO3/wJdk3XCTO2EjnY+VcKs9zBGnMECVjfzcxFJF
	t9mbMdnKuXEO52g/ACs8BVQ/uxfhyss5kFDmTIGsn0nUJTSO/Z+Kx2/qLoHmSXzTHjkc3+MXUW/
	DHnycYZVTcG5xSksc9K56CtMuwp0OHy32R485EA0xW/lQirTKBGF0c5rNv4NRqkDoacXywmRTWf
	YXklzXM9FENRGn4DlNnsfcmg+jEfRYWUXbyqmIK06dmgoT
X-Google-Smtp-Source: AGHT+IGRXSvT8NrU4jhoTjesWfENh9gKHP5kfnupJ/w3fqPHsnvgkcSRmM63jgcb144OZnu3MTsjnA==
X-Received: by 2002:a17:907:983:b0:ae0:54b9:dc17 with SMTP id a640c23a62f3a-ae9cdd8605amr976953266b.11.1752845822181;
        Fri, 18 Jul 2025 06:37:02 -0700 (PDT)
Received: from ?IPV6:2003:e5:8728:2b00:e047:1b8:d101:cf8e? (p200300e587282b00e04701b8d101cf8e.dip0.t-ipconnect.de. [2003:e5:8728:2b00:e047:1b8:d101:cf8e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6c7d4806sm123151766b.39.2025.07.18.06.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 06:37:01 -0700 (PDT)
Message-ID: <01dae2e9-dad7-465c-94ae-bcfbc2f96337@suse.com>
Date: Fri, 18 Jul 2025 15:36:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/8] xen/xenbus: Fix typo "notifer"
To: WangYuli <wangyuli@uniontech.com>
Cc: airlied@gmail.com, akpm@linux-foundation.org, alison.schofield@intel.com,
 andrew+netdev@lunn.ch, andriy.shevchenko@linux.intel.com,
 arend.vanspriel@broadcom.com, bp@alien8.de,
 brcm80211-dev-list.pdl@broadcom.com, brcm80211@lists.linux.dev,
 colin.i.king@gmail.com, cvam0000@gmail.com, dan.j.williams@intel.com,
 dave.hansen@linux.intel.com, dave.jiang@intel.com, dave@stgolabs.net,
 davem@davemloft.net, dri-devel@lists.freedesktop.org, edumazet@google.com,
 gregkh@linuxfoundation.org, guanwentao@uniontech.com, hpa@zytor.com,
 ilpo.jarvinen@linux.intel.com, intel-xe@lists.freedesktop.org,
 ira.weiny@intel.com, j@jannau.net, jeff.johnson@oss.qualcomm.com,
 jirislaby@kernel.org, johannes.berg@intel.com, jonathan.cameron@huawei.com,
 kuba@kernel.org, kvalo@kernel.org, kvm@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux@treblig.org, lucas.demarchi@intel.com, marcin.s.wojtas@gmail.com,
 ming.li@zohomail.com, mingo@kernel.org, mingo@redhat.com,
 netdev@vger.kernel.org, niecheng1@uniontech.com,
 oleksandr_tyshchenko@epam.com, pabeni@redhat.com, pbonzini@redhat.com,
 quic_ramess@quicinc.com, ragazenta@gmail.com, rodrigo.vivi@intel.com,
 seanjc@google.com, shenlichuan@vivo.com, simona@ffwll.ch,
 sstabellini@kernel.org, tglx@linutronix.de,
 thomas.hellstrom@linux.intel.com, vishal.l.verma@intel.com, x86@kernel.org,
 xen-devel@lists.xenproject.org, yujiaoliang@vivo.com, zhanjun@uniontech.com
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <906F22CD3C183048+20250715134407.540483-7-wangyuli@uniontech.com>
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
In-Reply-To: <906F22CD3C183048+20250715134407.540483-7-wangyuli@uniontech.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------cT4r0JNOUrsPfSEaUgW0eBEO"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------cT4r0JNOUrsPfSEaUgW0eBEO
Content-Type: multipart/mixed; boundary="------------oGJ4EHAKnSBOvFH3NUzTflx0";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: WangYuli <wangyuli@uniontech.com>
Cc: airlied@gmail.com, akpm@linux-foundation.org, alison.schofield@intel.com,
 andrew+netdev@lunn.ch, andriy.shevchenko@linux.intel.com,
 arend.vanspriel@broadcom.com, bp@alien8.de,
 brcm80211-dev-list.pdl@broadcom.com, brcm80211@lists.linux.dev,
 colin.i.king@gmail.com, cvam0000@gmail.com, dan.j.williams@intel.com,
 dave.hansen@linux.intel.com, dave.jiang@intel.com, dave@stgolabs.net,
 davem@davemloft.net, dri-devel@lists.freedesktop.org, edumazet@google.com,
 gregkh@linuxfoundation.org, guanwentao@uniontech.com, hpa@zytor.com,
 ilpo.jarvinen@linux.intel.com, intel-xe@lists.freedesktop.org,
 ira.weiny@intel.com, j@jannau.net, jeff.johnson@oss.qualcomm.com,
 jirislaby@kernel.org, johannes.berg@intel.com, jonathan.cameron@huawei.com,
 kuba@kernel.org, kvalo@kernel.org, kvm@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux@treblig.org, lucas.demarchi@intel.com, marcin.s.wojtas@gmail.com,
 ming.li@zohomail.com, mingo@kernel.org, mingo@redhat.com,
 netdev@vger.kernel.org, niecheng1@uniontech.com,
 oleksandr_tyshchenko@epam.com, pabeni@redhat.com, pbonzini@redhat.com,
 quic_ramess@quicinc.com, ragazenta@gmail.com, rodrigo.vivi@intel.com,
 seanjc@google.com, shenlichuan@vivo.com, simona@ffwll.ch,
 sstabellini@kernel.org, tglx@linutronix.de,
 thomas.hellstrom@linux.intel.com, vishal.l.verma@intel.com, x86@kernel.org,
 xen-devel@lists.xenproject.org, yujiaoliang@vivo.com, zhanjun@uniontech.com
Message-ID: <01dae2e9-dad7-465c-94ae-bcfbc2f96337@suse.com>
Subject: Re: [PATCH v2 7/8] xen/xenbus: Fix typo "notifer"
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <906F22CD3C183048+20250715134407.540483-7-wangyuli@uniontech.com>
In-Reply-To: <906F22CD3C183048+20250715134407.540483-7-wangyuli@uniontech.com>

--------------oGJ4EHAKnSBOvFH3NUzTflx0
Content-Type: multipart/mixed; boundary="------------iEXRbWM0AKXbkOVtyXZqSTc3"

--------------iEXRbWM0AKXbkOVtyXZqSTc3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTUuMDcuMjUgMTU6NDQsIFdhbmdZdWxpIHdyb3RlOg0KPiBUaGVyZSBpcyBhIHNwZWxs
aW5nIG1pc3Rha2Ugb2YgJ25vdGlmZXInIGluIHRoZSBjb21tZW50IHdoaWNoDQo+IHNob3Vs
ZCBiZSAnbm90aWZpZXInLg0KPiANCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
YWxsL0IzQzAxOUI2M0M5Mzg0NkYrMjAyNTA3MTUwNzEyNDUuMzk4ODQ2LTEtd2FuZ3l1bGlA
dW5pb250ZWNoLmNvbS8NCj4gU2lnbmVkLW9mZi1ieTogV2FuZ1l1bGkgPHdhbmd5dWxpQHVu
aW9udGVjaC5jb20+DQoNClJldmlld2VkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3Vz
ZS5jb20+DQoNCg0KSnVlcmdlbg0K
--------------iEXRbWM0AKXbkOVtyXZqSTc3
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------iEXRbWM0AKXbkOVtyXZqSTc3--

--------------oGJ4EHAKnSBOvFH3NUzTflx0--

--------------cT4r0JNOUrsPfSEaUgW0eBEO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmh6TfsFAwAAAAAACgkQsN6d1ii/Ey8c
Ygf/U0f6aO6tXuLVLY6fZvfaFWhIB7EB2CVm4zKF7LgVe0t84C2fovOiSsaEQZha5J86f+37KuMH
ahCur6raARzYTpUM//Os66LLW5nTG8yKd89CnE24MFDJsUdnv5qPqF4jb/wYDtr8xvuKwWEqWZz2
gWXCJNYry4wnZucm2Y0O4ylQXLJOzaDyc7Q3mnobvAJEuAbqPgoJCuMYaU2M9o7b4X4l2TO9lVAz
VaKGeVaTbiu8ys+JRy35HTdHyKboyr8Johi1iRtV42/+5rxr1fWIeQfGEBnOEXnzi6URr8HOKFSr
pdIJDp/rLD79JiOzGRZXBJZ2l8jybh7o7dN5y7z7Kg==
=9yKc
-----END PGP SIGNATURE-----

--------------cT4r0JNOUrsPfSEaUgW0eBEO--

