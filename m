Return-Path: <kvm+bounces-65954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF525CBCA6A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 07:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5A39B300C279
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 06:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2EF30C625;
	Mon, 15 Dec 2025 06:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XqQHKfAL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3852D1E7C23
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765780624; cv=none; b=Cr4uJzeRjogkVRN+Yd/osy+QfG1AdCJIydmF5drgaLXnDX8ZY41jREyWU7RP2XffrgCk0uD3ROXTIeltq5aqMEwwvb5vY8uQXQd7O8jASvO24Jgr1DdZsGdnasAoUsOSRqOFXKiSLP9OjxrP5e05UXOkYRRzM4du/9w/wn6dbq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765780624; c=relaxed/simple;
	bh=Flsp6Ih3FlMEVzRadHwRQZrT6qbOt0qkn7I0oYf7Qcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U4n/Ml/JD4636pqvG80gah7asbJD91Wo5qefl4lUR7KmW87s9YZVARUsfidDWqjwHXPDaUQAh6frhFML/Pjyo/ovI89I/nVJxi6Uo1cKU3bq/0qnVJnpOQVMFvlUxEUdcpAMOr6bYzC7yEjk8y51RUu3MhKHs1+e8JGmlUOjkn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XqQHKfAL; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so5877447a12.0
        for <kvm@vger.kernel.org>; Sun, 14 Dec 2025 22:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765780619; x=1766385419; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Flsp6Ih3FlMEVzRadHwRQZrT6qbOt0qkn7I0oYf7Qcc=;
        b=XqQHKfAL6c7x/ie+AeiZgcxzfsa3JFTgErvVKvTufKa8Cm+Z4EZdK/CsAPV9anbIeR
         rql37bUIx2KkISbYXA9AS8pd3acn7PGrBv9wUseOVsmrIpq7IU+DtnprmcQ5ipopg0R6
         dBWjf3b3Ml5R8WVfTMwAcNaxSZlJsx2qMxWFX3rJovwi+9pG5K+oruUlLh1hKNefT5+A
         Tey20XZHHtgS5MeYwsNvYBlYxkcsZc4DbOi4UKVcXQ6WlNteTiLCp+/6Sx4c8k/55vWt
         QXtZ3NGpD+CFzZpZmsP8HXra+PzvxCOrRQ5Ee1JxKjSno7YrRZ2PVQKUSpoSB3e7FriO
         SfVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765780619; x=1766385419;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Flsp6Ih3FlMEVzRadHwRQZrT6qbOt0qkn7I0oYf7Qcc=;
        b=tH7Q6iTQY5r2uWYgwGQJ1oIW4VEJO+LT2MVJJYwv4WRKQNp/zjxaUbmvhjcC8PudNI
         Bf64VLvpttSVxOtEz1y/t/YrInu/Vaxj+gJX6XmGrQ2SZbKYK3RpPDFaltspV0SzpTQg
         33Ivmj0i4a/XdIAxesCfZuylc9IhLMiVIV5GUm4yht5J44ZokacBQxl2uwBg1sL8dv0W
         9roLyaCjUGx+FEadJ86ezMVu1RfRuDKYb42MfkYztyNdHjTgU27VseZJGPWS0t4/UaWR
         ou5R1DEDZUia80XvF4WcEz014pbMBXUZDDWjagPmBZrldE8g3Dl9WsaGHSg+KWJ4Sc6+
         5hZA==
X-Forwarded-Encrypted: i=1; AJvYcCXXM73I3gAogMxVumSQBG5hicoplC1SKS4MfDx/w1L9qI7eLq7k2tzXnAs3SD8TNDPV2ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGptKy7hojMFB59Ud9Hy9DoJ8HioLQaWRi6UkuG4KXvZsq2E70
	B4ctcoPWRZHt1Mx9w+T2yuKtjStsRcbPct+60j2mun6PXP3mMaM1waOcppiqBU1Ft9M=
X-Gm-Gg: AY/fxX72n4dKMGIKsnAL/RtmVuLH0f82Oc4XVxTR6p4p7V97pEtbNkVivGqYaKyjjt1
	mJUJErGmVR276UqCAg9uxVxy0aJKPCaD7pdM5gCisv0ifm6WNeGkxk2af4ep0tTAlJz2ULXTOsr
	UPQhdZqRrGzCFR60Dj+SG/09v0Y+sK9YusbWaFCMkRGPUzlKRDhBP3cOqKTxXNcqrQfpFNUjFrz
	n3AKtncZrRb5Xmv0IrfffPYLgBKp0rCzpVkWNkdbBPFb8zYBFE7/iJQFhg6iub7dkyMFJd8X3jq
	QOD6YNAlOR6xWeHYQSKrW0upLD5RDikHemlJgjtD0YggegZn34XDljzGbvHy1SW08pL1p+BRU25
	a/m2973XaJdQOJUEwCc5ObBl5t7P1MeOzGVj6Ck7CAuooq1yRnRmarrjysmvzH6tYwthTLEgknX
	NdFkCfNi9rFzqWApjsexKsOTnULNkzYs/feRVP7cwK2Gxwuwbrub8jrXKGki7hoBYVtOW7J2BTu
	2s41fivAdDRvr/iR94NRsXr/jW7md0LwP7u834=
X-Google-Smtp-Source: AGHT+IGo/GqgVXtCzeCvo1UWjbyI/0K/pid4ihpAfElEjp1P5X9LqCIs4JAGA1cU0Oaa8OlI6Xu5Vg==
X-Received: by 2002:a17:907:9617:b0:b73:8f33:eed3 with SMTP id a640c23a62f3a-b7d23a9c866mr953872766b.26.1765780619499;
        Sun, 14 Dec 2025 22:36:59 -0800 (PST)
Received: from ?IPV6:2003:e5:8704:4800:66fd:131f:60bd:bc29? (p200300e58704480066fd131f60bdbc29.dip0.t-ipconnect.de. [2003:e5:8704:4800:66fd:131f:60bd:bc29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa29beabsm1330300666b.4.2025.12.14.22.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Dec 2025 22:36:59 -0800 (PST)
Message-ID: <bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com>
Date: Mon, 15 Dec 2025 07:36:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] x86: Cleanups around slow_down_io()
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-block@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Jean Delvare <jdelvare@suse.com>,
 Guenter Roeck <linux@roeck-us.net>, Denis Efremov <efremov@linux.com>,
 Jens Axboe <axboe@kernel.dk>
References: <20251126162018.5676-1-jgross@suse.com>
 <aT5vtaefuHwLVsqy@gmail.com>
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
In-Reply-To: <aT5vtaefuHwLVsqy@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3mgjNgxNLw3aXEpCS8syparo"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3mgjNgxNLw3aXEpCS8syparo
Content-Type: multipart/mixed; boundary="------------uocwPUAwg06DHItKBfr8MkI0";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-block@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Jean Delvare <jdelvare@suse.com>,
 Guenter Roeck <linux@roeck-us.net>, Denis Efremov <efremov@linux.com>,
 Jens Axboe <axboe@kernel.dk>
Message-ID: <bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com>
Subject: Re: [PATCH 0/5] x86: Cleanups around slow_down_io()
References: <20251126162018.5676-1-jgross@suse.com>
 <aT5vtaefuHwLVsqy@gmail.com>
In-Reply-To: <aT5vtaefuHwLVsqy@gmail.com>

--------------uocwPUAwg06DHItKBfr8MkI0
Content-Type: multipart/mixed; boundary="------------0K40Sw4HjMWfuWdkxRcyXR0R"

--------------0K40Sw4HjMWfuWdkxRcyXR0R
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTQuMTIuMjUgMDk6MDUsIEluZ28gTW9sbmFyIHdyb3RlOg0KPiANCj4gKiBKdWVyZ2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+IHdyb3RlOg0KPiANCj4+IFdoaWxlIGxvb2tpbmcg
YXQgcGFyYXZpcnQgY2xlYW51cHMgSSBzdHVtYmxlZCBvdmVyIHNsb3dfZG93bl9pbygpIGFu
ZA0KPj4gdGhlIHJlbGF0ZWQgUkVBTExZX1NMT1dfSU8gZGVmaW5lLg0KPj4NCj4+IEVzcGVj
aWFsbHkgUkVBTExZX1NMT1dfSU8gaXMgYSBtZXNzLCB3aGljaCBpcyBwcm92ZW4gYnkgMiBj
b21wbGV0ZWx5DQo+PiB3cm9uZyB1c2UgY2FzZXMuDQo+Pg0KPj4gRG8gc2V2ZXJhbCBjbGVh
bnVwcywgcmVzdWx0aW5nIGluIGEgZGVsZXRpb24gb2YgUkVBTExZX1NMT1dfSU8gYW5kIHRo
ZQ0KPj4gaW9fZGVsYXkoKSBwYXJhdmlydCBmdW5jdGlvbiBob29rLg0KPj4NCj4+IFBhdGNo
ZXMgMiBhbmQgMyBhcmUgbm90IGNoYW5naW5nIGFueSBmdW5jdGlvbmFsaXR5LCBidXQgbWF5
YmUgdGhleQ0KPj4gc2hvdWxkPyBBcyB0aGUgcG90ZW50aWFsIGJ1ZyBoYXMgYmVlbiBwcmVz
ZW50IGZvciBtb3JlIHRoYW4gYSBkZWNhZGUNCj4+IG5vdywgSSB3ZW50IHdpdGgganVzdCBk
ZWxldGluZyB0aGUgdXNlbGVzcyAiI2RlZmluZSBSRUFMTFlfU0xPV19JTyIuDQo+PiBUaGUg
YWx0ZXJuYXRpdmUgd291bGQgYmUgdG8gZG8gc29tZXRoaW5nIHNpbWlsYXIgYXMgaW4gcGF0
Y2ggNS4NCj4+DQo+PiBKdWVyZ2VuIEdyb3NzICg1KToNCj4+ICAgIHg4Ni9wYXJhdmlydDog
UmVwbGFjZSBpb19kZWxheSgpIGhvb2sgd2l0aCBhIGJvb2wNCj4+ICAgIGh3bW9uL2xtNzg6
IERyb3AgUkVBTExZX1NMT1dfSU8gc2V0dGluZw0KPj4gICAgaHdtb24vdzgzNzgxZDogRHJv
cCBSRUFMTFlfU0xPV19JTyBzZXR0aW5nDQo+PiAgICBibG9jay9mbG9wcHk6IERvbid0IHVz
ZSBSRUFMTFlfU0xPV19JTyBmb3IgZGVsYXlzDQo+PiAgICB4ODYvaW86IFJlbW92ZSBSRUFM
TFlfU0xPV19JTyBoYW5kbGluZw0KPj4NCj4+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vZmxv
cHB5LmggICAgICAgICB8IDI3ICsrKysrKysrKysrKysrKysrKysrKystLS0tLQ0KPj4gICBh
cmNoL3g4Ni9pbmNsdWRlL2FzbS9pby5oICAgICAgICAgICAgIHwgMTIgKysrKystLS0tLS0t
DQo+PiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmggICAgICAgfCAxMSArLS0t
LS0tLS0tLQ0KPj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5oIHwg
IDMgKy0tDQo+PiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmMgICAgICAgICAgfCAg
MiArLQ0KPj4gICBhcmNoL3g4Ni9rZXJuZWwva3ZtLmMgICAgICAgICAgICAgICAgIHwgIDgg
Ky0tLS0tLS0NCj4+ICAgYXJjaC94ODYva2VybmVsL3BhcmF2aXJ0LmMgICAgICAgICAgICB8
ICAzICstLQ0KPj4gICBhcmNoL3g4Ni94ZW4vZW5saWdodGVuX3B2LmMgICAgICAgICAgIHwg
IDYgKy0tLS0tDQo+PiAgIGRyaXZlcnMvYmxvY2svZmxvcHB5LmMgICAgICAgICAgICAgICAg
fCAgMiAtLQ0KPj4gICBkcml2ZXJzL2h3bW9uL2xtNzguYyAgICAgICAgICAgICAgICAgIHwg
IDUgKysrLS0NCj4+ICAgZHJpdmVycy9od21vbi93ODM3ODFkLmMgICAgICAgICAgICAgICB8
ICA1ICsrKy0tDQo+PiAgIDExIGZpbGVzIGNoYW5nZWQsIDM5IGluc2VydGlvbnMoKyksIDQ1
IGRlbGV0aW9ucygtKQ0KPiANCj4gSSB0aGluayB3ZSBzaG91bGQgZ2V0IHJpZCBvZiAqYWxs
KiBpb19kZWxheSBoYWNrcywgdGhleSBtaWdodCBoYXZlIGJlZW4NCj4gcmVsZXZhbnQgaW4g
dGhlIGRheXMgb2YgaTM4NiBzeXN0ZW1zLCBidXQgd2UgZG9uJ3QgZXZlbiBzdXBwb3J0IGkz
ODYNCj4gQ1BVcyBhbnltb3JlLiBTaG91bGQgaXQgY2F1c2UgYW55IHJlZ3Jlc3Npb25zLCBp
dCdzIGVhc3kgdG8gYmlzZWN0IHRvLg0KPiBUaGVyZSdzIGJlZW4gZW5vdWdoIGNoYW5nZXMg
YXJvdW5kIGFsbCB0aGVzZSBmYWNpbGl0aWVzIHRoYXQgdGhlDQo+IG9yaWdpbmFsIHRpbWlu
Z3MgYXJlIHByb2JhYmx5IHdheSBvZmYgYWxyZWFkeSwgc28gd2UndmUganVzdCBiZWVuDQo+
IGNhcmdvLWN1bHQgcG9ydGluZyB0aGVzZSB0byBuZXdlciBrZXJuZWxzIGVzc2VudGlhbGx5
Lg0KDQpGaW5lIHdpdGggbWUuDQoNCldoaWNoIHBhdGggdG8gcmVtb3ZhbCBvZiBpb19kZWxh
eSB3b3VsZCB5b3UgKGFuZCBvdGhlcnMpIHByZWZlcj8NCg0KMS4gUmlwcGluZyBpdCBvdXQg
aW1tZWRpYXRlbHkuDQoNCjIuIEhpZGluZyBpdCBiZWhpbmQgYSBkZWZhdWx0LW9mZiBjb25m
aWcgb3B0aW9uIGZvciBhIGZldyBrZXJuZWwgdmVyc2lvbnMNCiAgICBiZWZvcmUgcmVtb3Zp
bmcgaXQuDQoNCjMuIFVzaW5nIENPTkZJR19JT19ERUxBWV9OT05FIGFzIHRoZSBkZWZhdWx0
IGlvX2RlbGF5X3R5cGUgYmVmb3JlIHJpcHBpbmcgaXQNCiAgICBvdXQuDQoNCjQuIFVzaW5n
IENPTkZJR19JT19ERUxBWV9OT05FIGFzIHRoZSBkZWZhdWx0IGlvX2RlbGF5X3R5cGUgYmVm
b3JlIGhpZGluZyBpdA0KICAgIGJlaGluZCBhIGRlZmF1bHQtb2ZmIGNvbmZpZyBvcHRpb24s
IHRoZW4gcmlwIGl0IG91dCBsYXRlci4NCg0KSW4gY2FzZXMgMi00IEknZCBzdGlsbCBsaWtl
IHRvIGhhdmUgcGF0Y2ggMSBvZiBteSBzZXJpZXMgYXBwbGllZCwgYXMgaXQgd2lsbA0KbWFr
ZSBwYXJhdmlydCByZXdvcmsgZWFzaWVyLg0KDQoNCkp1ZXJnZW4NCg==
--------------0K40Sw4HjMWfuWdkxRcyXR0R
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------0K40Sw4HjMWfuWdkxRcyXR0R--

--------------uocwPUAwg06DHItKBfr8MkI0--

--------------3mgjNgxNLw3aXEpCS8syparo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmk/rIkFAwAAAAAACgkQsN6d1ii/Ey+O
KAf/RhuC6z7N89eI1LFebQgpxz6ipUoaEJLE3iPD9BIa8MC4hAK9upc0Be1ulp8clrSuz3rdpIw7
3FUaPR9cZlvGMCV4Z+IHHjhwmCaWOcpppBqiVsNGhvT47rDwA2VkaikY3Ehl9quAQpn1CC1hhkJ1
01WuZBXoh2YzULEZSQtLiB/SNUhY/giSrXVDYqFcRdmTVicw/Obw/Xlvx6pXR3h7j5JxemXi9/Fj
iKUX4frjdzsmdQotNBCZcdFf37mdeUIi3KWRenk5jma77pmhc8v1kpf/IJcf8U5SvVaz2LnLN+pw
GgFVUcHrV+iMB8ern+6AKait3RZBMNm2dCjJdLk6bg==
=WEIE
-----END PGP SIGNATURE-----

--------------3mgjNgxNLw3aXEpCS8syparo--

