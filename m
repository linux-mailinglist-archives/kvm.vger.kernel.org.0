Return-Path: <kvm+bounces-45597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 670A5AAC727
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 15:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5A8B4A7CDB
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 13:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B09281369;
	Tue,  6 May 2025 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RLzfiBu3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524AB279350
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539910; cv=none; b=flaeaBN+psRwBNbk5sA2k4Vmy0mpRxP+tkoUY+ZnhCRnCDkFsEJ1e01qskUg5ZMoS2mFHYTK8jKfmFFQcBrKHjw0TNielXKcEaKk1Fc9oCneTWKrq2fcDR9daisUxH+i+CJk691yy1mV4TXZoWGUoGfhx5BcsfxMUgIvBdqebps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539910; c=relaxed/simple;
	bh=MMLqrEU8Ne2Uw7q6tTwQdp1zCuyDqRuNtGJ1tIIJcvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/1k6rOeEddaIZX6ln8Eyim20kEds0ywhxUutnHB1uw3/nYnMaD1qVD+Nofwzx+dJ2947v9e3PEJRpTooaLhJ1Pg1tB/KCsdgpQafskDd84zbrwYw4GLtsN4ToweYPNB5JMV9mIBkfs1/hGCAWyygXVnPaV5URcfmP9BfO5pBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RLzfiBu3; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so928739266b.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 06:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746539906; x=1747144706; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MMLqrEU8Ne2Uw7q6tTwQdp1zCuyDqRuNtGJ1tIIJcvU=;
        b=RLzfiBu3jwR18NwYBwiLkjCynwXBNXdcPqWTMoFyyNOw2V7kNCaAmXLgO7PdNn49Qi
         hEpBuKlUnSsoGZCIy+Tom+cITuuJaLiGHNE1/YlF2K9r3vfLET1dWe3Xbingaw+fatrs
         krLheT+HWlmgwyLqUVZlQAbl+zEYdECmM9kb0tWCIsusMSaGolTI1Z04w21QMO4RrpIb
         ywOMdqc5oGC49lD14Xmfk7jOJs9qwpTwk4V6xlBgaJuyFB6XGZjmUKhtaND0z+BnDRvI
         0zRGnySsaDCitdR+Swk/xEm0fxqf2xRIJWQ3MNr3HVEEhxfMPEjHavuKxVbmxZ4LSgjl
         Os4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539906; x=1747144706;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MMLqrEU8Ne2Uw7q6tTwQdp1zCuyDqRuNtGJ1tIIJcvU=;
        b=ao58f/jSbbVEc3k6jCHzQQXXPfpxIKAqyiT1a/siuuy86cgbrYUsSM+FbwuCF0uwBx
         SIT9H1y3ld3hpUbW6nNJPcoVR2ytLnOWyrP36jeMvSl8BsyR1QbT2Od/hqeV1qpF6Ujy
         GnmNU+r2o4ZyFoisnqz5/Jd61CaIO9HIlQVqVCOiqLmncumCiPu9vCx4WrINFP9HzsaO
         ils9rzO9/igGd8nMOx9DfBjSOndr2uXmVWh1rfyTnyMUzwUx20LQHLprgskWXQZCi13k
         5n983cLYr+FTOH//LoivEJneTjDP7at6QvKDT3N6f7myDIvMnAQF/D8DLG+p2BMKlN4V
         jGUA==
X-Forwarded-Encrypted: i=1; AJvYcCWRiWru3/lzaYryK0VIk0UqEFaED4Uixr7cFAdu2jMP/OoGaH1GnYtxDTPSiDwjqMuSD0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWBsHw4CtaL4aUk+2437mx222gIGJ7RkbnA7hnAJWCwaUAO7lO
	qUAd6RRPgsKc5LxBx//vtp/B9IsISkyz4f6uTcZDJFxZYUM1jU2JcSuX+ensBug=
X-Gm-Gg: ASbGnctp+IcXyuLxfrYtvG4DbOdgucLriSjYRQgxeiiCl7/ov8pZM+7VA6uU9B+wxCK
	RUUMZiCaxo4NqlTNhOljMI7cFKHJW4M8YiLoLP5lvsvunQ3b4gngA8heKPL4EN/v5iUXnXzo6tP
	u3+JAKl9Wn6/er2jz7VqGe1anJSplV346YPltDgTNTsHDUjh4mmNBBwl4y3A5MhPeF4swR7vYHV
	AtgvrmRFLwWHg2nwWucDOGfiyxeNPBCTe5HPXWDc3oySPTDCFodKzzQPZzyxQ/PNcd9v0Wf+VkX
	QVZqXfBkWBx+1n/hJx3CfUXshXvJ4Seowk51i3EUBgqksjKHib3DpIjS/+Ie6Czx/1SCTk3tJ9g
	1AHd6h0zenqsfTfioh9yoLdKO913n0SlFNNgrBQjPChHs8iphqjlyTYKdDL2WWEPLGw==
X-Google-Smtp-Source: AGHT+IEEXi1l8e77hkj4YdY5UoaIDCBO0k4nLwQqcAgOROzSTBQd1d7lqXzBZR0soj0DLWJ6A9KwSA==
X-Received: by 2002:a17:907:2d12:b0:ac1:dfab:d38e with SMTP id a640c23a62f3a-ad1d3499b80mr356265866b.15.1746539906232;
        Tue, 06 May 2025 06:58:26 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad189540478sm706876966b.169.2025.05.06.06.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 06:58:25 -0700 (PDT)
Message-ID: <9cf55cbe-68e0-423c-9d2b-dfae582ae175@suse.com>
Date: Tue, 6 May 2025 15:58:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] x86/kvm: Rename the KVM private read_msr() function
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 xin@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20250506092015.1849-1-jgross@suse.com>
 <20250506092015.1849-3-jgross@suse.com> <aBoUdApwSgnr3r9V@google.com>
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
In-Reply-To: <aBoUdApwSgnr3r9V@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------u0Beh8xVW9F9s8Z9nV9leUTX"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------u0Beh8xVW9F9s8Z9nV9leUTX
Content-Type: multipart/mixed; boundary="------------RJTDCcZDVUmLySfPw5Gz88U0";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 xin@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <9cf55cbe-68e0-423c-9d2b-dfae582ae175@suse.com>
Subject: Re: [PATCH 2/6] x86/kvm: Rename the KVM private read_msr() function
References: <20250506092015.1849-1-jgross@suse.com>
 <20250506092015.1849-3-jgross@suse.com> <aBoUdApwSgnr3r9V@google.com>
In-Reply-To: <aBoUdApwSgnr3r9V@google.com>

--------------RJTDCcZDVUmLySfPw5Gz88U0
Content-Type: multipart/mixed; boundary="------------a3gQF394fltzNm6XIVotVOeV"

--------------a3gQF394fltzNm6XIVotVOeV
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDYuMDUuMjUgMTU6NTMsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE9uIFR1
ZSwgTWF5IDA2LCAyMDI1LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gQXZvaWQgYSBuYW1l
IGNsYXNoIHdpdGggYSBuZXcgZ2VuZXJhbCBNU1IgYWNjZXNzIGhlbHBlciBhZnRlciBhIGZ1
dHVyZQ0KPj4gTVNSIGluZnJhc3RydWN0dXJlIHJld29yayBieSByZW5hbWluZyB0aGUgS1ZN
IHNwZWNpZmljIHJlYWRfbXNyKCkgdG8NCj4+IGt2bV9yZWFkX21zcigpLg0KPj4NCj4+IFNp
Z25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4+IC0tLQ0K
Pj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgMiArLQ0KPj4gICBhcmNo
L3g4Ni9rdm0vdm14L3ZteC5jICAgICAgICAgIHwgNCArKy0tDQo+PiAgIDIgZmlsZXMgY2hh
bmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC94ODYvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaA0KPj4gaW5kZXggOWM5NzFmODQ2MTA4Li4zMDhmNzAyMGRjOWQg
MTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+PiAr
KysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+PiBAQCAtMjI3NSw3ICsy
Mjc1LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIGt2bV9sb2FkX2xkdCh1MTYgc2VsKQ0KPj4g
ICB9DQo+PiAgIA0KPj4gICAjaWZkZWYgQ09ORklHX1g4Nl82NA0KPj4gLXN0YXRpYyBpbmxp
bmUgdW5zaWduZWQgbG9uZyByZWFkX21zcih1bnNpZ25lZCBsb25nIG1zcikNCj4gDQo+IEV3
d3d3LiAgRXd3LCBld3csIGV3dy4gIEkgZm9yZ290IHRoaXMgdGhpbmcgZXhpc3RlZC4NCj4g
DQo+IFBsZWFzZSBqdXN0IGRlbGV0ZSB0aGlzIGFuZCB1c2UgcmRtc3JxKCkgZGlyZWN0bHkg
KG9yIGlzIGl0IHN0aWxsIHJkbXNybCgpPyBhdA0KPiB0aGlzIHBvaW50PykuDQoNCnJkbXNy
cSgpIGl0IGlzLg0KDQpGaW5lIHdpdGggbWUuDQoNCg0KSnVlcmdlbg0K
--------------a3gQF394fltzNm6XIVotVOeV
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------a3gQF394fltzNm6XIVotVOeV--

--------------RJTDCcZDVUmLySfPw5Gz88U0--

--------------u0Beh8xVW9F9s8Z9nV9leUTX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgaFYEFAwAAAAAACgkQsN6d1ii/Ey+R
+AgAhJeqYMflbNuK2+s6+/XQfXtYdJgLapDt5pFlTMsuG1DGv5fMMbI9p2x+CdNemPKjW4ZlGDQ1
snNHvUDimKLZf22GHqjTZb7NsUv/uqP3DS/3mx9Wq/2Jswdm+Ejk1A8Upnaqf9UU4yagvLz+C3co
59+qB7IlxXChLqYZrhOlxKx3pkTCCczL02ESlMk2yrBP3h8wPezY5KVGxzCOCvoDC4rcUg5EWKke
TKluwxxLtO4FBOhSTW8cfPQ+QxgcfJyzYS3nYO5QWAeNaSt9C65q71X6fOzaxFkgt9CsrIKqK1BW
8bJF8EKeyuONjjgLMf29DUPhHVcl9YMF5eGaMcdi/g==
=I4mo
-----END PGP SIGNATURE-----

--------------u0Beh8xVW9F9s8Z9nV9leUTX--

