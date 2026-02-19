Return-Path: <kvm+bounces-71337-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHSkNKmwlmmejgIAu9opvQ
	(envelope-from <kvm+bounces-71337-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 07:41:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4BB15C6AA
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 07:41:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5B08302EE98
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8AE305057;
	Thu, 19 Feb 2026 06:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V87+rnnd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AD93033FE
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 06:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483289; cv=none; b=d/OMQbfupjuvvyQZU1srVrtgvpNvP73ueYlxSyR6Wd+FRCcQYr7CMAGfhu7uZ0P3OtQOuaUHXEQJk/MfSbnGrwOy78p4jZyseemZnyBGPUYE3Qp1srsGnAi6icCtiqJKlOwHnZ0LFQvHfoGH3YPQ72z7oTFGUg5JTLDaUGizCac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483289; c=relaxed/simple;
	bh=T0U5exp921Fy+sxSnoFwm/V4crYgaMW56C4ebo4qsjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MrbntUyN4mVADMctVjsA3togZG/gpkRkpBBMjShTLv0jugMIwCRvKCDa546Jz08E9GD7Hev/3vGQ08jyXDPUaCWvVUeoCZ0yMvwlffRHK+9Tphpw2dyOOdIIdLePjxqISd3U+X3VsBwz4n4sxlKAxa8VFMHAxW1kmE5rTxw+WYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V87+rnnd; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8f96f6956aso83638266b.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 22:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771483287; x=1772088087; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T0U5exp921Fy+sxSnoFwm/V4crYgaMW56C4ebo4qsjk=;
        b=V87+rnndFutqimtVbE4ow+GIspBd/D6uY8shBauK1PEY2jMhROkMsbNnEuT6YyKKaF
         1JhfHRigbfZUIXbGFmV2DPnqc6qUnQsvTFz1Jke2jhTGqvLbX452sanON5ub5DcoFosl
         m4CH8roxDBK0zzYvQ1s4BlBjnAw0MT8tuu+PYg2ccyXOYbRPa17dJRyTAb3mPwpAk8lX
         8SV/aLlo2W1wSO3pEpz0jJJyFV7oLxk6+DjvP3juu9fg5Uv9M7+m7ULJC3Vf05YfPbUh
         RujsEC4LJkJ9ETXITXf1AvmvU/coPSb0pcPgA5NtqVWOCpJOlHIUUAXq9iv07tZ6G9p2
         FFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771483287; x=1772088087;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T0U5exp921Fy+sxSnoFwm/V4crYgaMW56C4ebo4qsjk=;
        b=FAl2aZimLGUdH+gbzAGBZvDAAyWPIp7ZusPFrye5cOIYzgvHoNr4IEb0iRP4/HU0KA
         LwhLnJ6ndzl9r6GiYZTSZa10PM0BsJggB5+6/VilIAGySONHQyy0A0UsxYumX1zeQqbJ
         PjDMB+0/MhPuDu8gon67xrdGKpQ2MTbd38FOWHKZKXTVHw9Kf8tvW9widP2l+pm1cfRY
         UUdCVMiE6pCZxxwuEy/C9/0AwLO+J4lmplrGpoMkiWl+VSRNoQiTbH6D4hrURAs5rsmM
         7E2dqq5vikq3D1RL7+zvqdYpujvrAKhjaR4d+Z5N90wwY8RFUT9plfKP3cSKJIOBPnVm
         WmWA==
X-Forwarded-Encrypted: i=1; AJvYcCXeQCRO53FwCpI6uxw7XHZ3Sl5cqgLOTsx4EhFtHDIATI8lIeY+h6FultmkNaTmldc9PQc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy581YInJ17sc+yR5bQwB61TZlacod7gpAkFQC7hLK1NFe6IqgX
	kSyKCReoBjeasAN7yGoVnJQDyTnNI0hBUIxmxmE0s461zAkJ9BIgzzA8MMebnjAtPMo=
X-Gm-Gg: AZuq6aICCauyUrx9BogLwvGg8Kfeh/G28m9vCzHacS6OInVpLzFP+grIMjVqEjQf/+N
	2C2htTDn7FqNsdKpw+zvjbagwJ8JJWox3A/WHRL9PYHsYzkQ6XkhS3xoT1jvUFSdF2hUvsqw+wj
	xqRP6b+qdJctJgt/Mlnp6szdC6ewkUnLjKPNBOLiAyAnqQGYSnQZq0efYkwwAVV4zPHRZiMEsSo
	y+OwAU9BLvNNGD8fz6EQZ+SFHZtRFIP1JdqC6n6VaeYqksn4JGRhcYqotv1nli9LFeLGAaXRuvz
	v6X3wJzPHBhNaLpWHX4HTICjGXJd5JDrYP7NQAGo5uLZla1MwiX4E3tdBY3qONZtNd49UC48hTq
	+w1zkb0CzTgsjgbWG0ar8SUttcIh20nBXH3MuGvFrzhfxjtb0718OoeZOzCwlc2uiaE/qfVsEXw
	unByoIDvKrqLDYTce/GZ/v3czr+dtTg1HvMjpIx4fRtv+yMFz6CqUtaFl6Pbq3UzZPirHHZCRVd
	iF+bJ7dPkEN/zEiyFZO6JZO38X9aXNJaAXyz9jkctdld6fx3A==
X-Received: by 2002:a17:907:8691:b0:b8f:a68a:e85d with SMTP id a640c23a62f3a-b903db1c880mr217263766b.23.1771483286690;
        Wed, 18 Feb 2026 22:41:26 -0800 (PST)
Received: from ?IPV6:2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1? (2a00-12d0-af5b-2f01-4042-c03-ce4d-a5a1.ip.tng.de. [2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc766459fsm545348066b.45.2026.02.18.22.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 22:41:26 -0800 (PST)
Message-ID: <fb1f688a-7e36-405c-879f-d786df99e367@suse.com>
Date: Thu, 19 Feb 2026 07:41:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/16] x86/msr: Use the alternatives mechanism for
 WRMSR
To: "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 llvm@lists.linux.dev, Xin Li <xin@zytor.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
References: <20260218082133.400602-1-jgross@suse.com>
 <20260218082133.400602-10-jgross@suse.com> <aZYoUE7CmrLg3SVe@google.com>
 <e05a65a7-bf8e-420b-8a36-2d76e56b43b0@intel.com>
 <7F627940-578D-4EDF-9812-41DDF3275B4F@zytor.com>
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
In-Reply-To: <7F627940-578D-4EDF-9812-41DDF3275B4F@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kpAtuAfZJCcVsepCeDiDvzPI"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.93 / 15.00];
	SIGNED_PGP(-2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	R_MIXED_CHARSET(0.63)[subject];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71337-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,lists.linux.dev,zytor.com,redhat.com,alien8.de,linux.intel.com,gmail.com,google.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	HAS_ATTACHMENT(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[jgross@suse.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,lkml];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: 5A4BB15C6AA
X-Rspamd-Action: no action

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kpAtuAfZJCcVsepCeDiDvzPI
Content-Type: multipart/mixed; boundary="------------8DtgFxijBgwKa2EaN60UBGBb";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 llvm@lists.linux.dev, Xin Li <xin@zytor.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Message-ID: <fb1f688a-7e36-405c-879f-d786df99e367@suse.com>
Subject: Re: [PATCH v3 09/16] x86/msr: Use the alternatives mechanism for
 WRMSR
References: <20260218082133.400602-1-jgross@suse.com>
 <20260218082133.400602-10-jgross@suse.com> <aZYoUE7CmrLg3SVe@google.com>
 <e05a65a7-bf8e-420b-8a36-2d76e56b43b0@intel.com>
 <7F627940-578D-4EDF-9812-41DDF3275B4F@zytor.com>
In-Reply-To: <7F627940-578D-4EDF-9812-41DDF3275B4F@zytor.com>

--------------8DtgFxijBgwKa2EaN60UBGBb
Content-Type: multipart/mixed; boundary="------------z2QX1vqw51KEnzEkLXEcOBho"

--------------z2QX1vqw51KEnzEkLXEcOBho
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTkuMDIuMjYgMDA6MzYsIEguIFBldGVyIEFudmluIHdyb3RlOg0KPiBPbiBGZWJydWFy
eSAxOCwgMjAyNiAxOjM3OjQyIFBNIFBTVCwgRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGlu
dGVsLmNvbT4gd3JvdGU6DQo+PiBPbiAyLzE4LzI2IDEzOjAwLCBTZWFuIENocmlzdG9waGVy
c29uIHdyb3RlOg0KPj4+IE9uIFdlZCwgRmViIDE4LCAyMDI2LCBKdWVyZ2VuIEdyb3NzIHdy
b3RlOg0KPj4+PiBXaGVuIGF2YWlsYWJsZSB1c2Ugb25lIG9mIHRoZSBub24tc2VyaWFsaXpp
bmcgV1JNU1IgdmFyaWFudHMgKFdSTVNSTlMNCj4+Pj4gd2l0aCBvciB3aXRob3V0IGFuIGlt
bWVkaWF0ZSBvcGVyYW5kIHNwZWNpZnlpbmcgdGhlIE1TUiByZWdpc3RlcikgaW4NCj4+Pj4g
X193cm1zcnEoKS4NCj4+PiBTaWxlbnRseSB1c2luZyBhIG5vbi1zZXJpYWxpemluZyB2ZXJz
aW9uIChvciBub3QpIHNlZW1zIGRhbmdlcm91cyAobm90IGZvciBLVk0sDQo+Pj4gYnV0IGZv
ciB0aGUga2VybmVsIGF0LWxhcmdlKSwgdW5sZXNzIHRoZSBydWxlIGlzIGdvaW5nIHRvIGJl
IHRoYXQgTVNSIHdyaXRlcyBuZWVkDQo+Pj4gdG8gYmUgdHJlYXRlZCBhcyBub24tc2VyaWFs
aXppbmcgYnkgZGVmYXVsdC4NCj4+DQo+PiBZZWFoLCB0aGVyZSdzIG5vIHdheSB3ZSBjYW4g
ZG8gdGhpcyBpbiBnZW5lcmFsLiBJdCdsbCB3b3JrIGZvciA5OSUgb2YNCj4+IHRoZSBNU1Jz
IG9uIDk5JSBvZiB0aGUgc3lzdGVtcyBmb3IgYSBsb25nIHRpbWUuIFRoZW4gdGhlIG9uZSBu
ZXcgc3lzdGVtDQo+PiB3aXRoIFdSTVNSTlMgaXMgZ29pbmcgdG8gaGF2ZSBvbmUgaGVsbCBv
ZiBhIGhlaXNlbmJ1ZyB0aGF0J2xsIHRha2UgeWVhcnMNCj4+IG9mZiBzb21lIHBvb3Igc2No
bXVjaydzIGxpZmUuDQo+Pg0KPj4gV2Ugc2hvdWxkIHJlYWxseSBlbmNvdXJhZ2UgKm5ldyog
Y29kZSB0byB1c2Ugd3Jtc3JucygpIHdoZW4gaXQgY2FuIGF0DQo+PiBsZWFzdCBmb3IgYW5u
b3RhdGlvbiB0aGF0IGl0IGRvZXNuJ3QgbmVlZCBzZXJpYWxpemF0aW9uLiBCdXQgSSBkb24n
dA0KPj4gdGhpbmsgd2Ugc2hvdWxkIGRvIGFueXRoaW5nIHRvIG9sZCwgd29ya2luZyBjb2Rl
Lg0KPiANCj4gQ29ycmVjdC4gV2UgbmVlZCB0byBkbyB0aGlzIG9uIGEgdXNlciBieSB1c2Vy
IGJhc2lzLg0KDQpUaGVuIEknZCBwcmVmZXIgdG8gaW50cm9kdWNlIGEgbmV3IHdybXNyX3N5
bmMoKSBmdW5jdGlvbiBmb3IgdGhlIHNlcmlhbGl6aW5nDQp2YXJpYW50IGFuZCB0byBzd2l0
Y2ggYWxsIGN1cnJlbnQgdXNlcnMgd2hpY2ggYXJlIG5vdCBrbm93biB0byB0b2xlcmF0ZSB0
aGUNCm5vbi1zZXJpYWxpemluZyBmb3JtIHRvIGl0LiBUaGUgbWFpbiBhZHZhbnRhZ2Ugb2Yg
dGhhdCBhcHByb2FjaCB3b3VsZCBiZSB0bw0KYmUgYWJsZSB0byB1c2UgdGhlIGltbWVkaWF0
ZSBmb3JtIHdoZXJlIHBvc3NpYmxlIGF1dG9tYXRpY2FsbHkuDQoNCg0KSnVlcmdlbg0K
--------------z2QX1vqw51KEnzEkLXEcOBho
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------z2QX1vqw51KEnzEkLXEcOBho--

--------------8DtgFxijBgwKa2EaN60UBGBb--

--------------kpAtuAfZJCcVsepCeDiDvzPI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmmWsJUFAwAAAAAACgkQsN6d1ii/Ey9Y
9Qf+NIsCS52E8MKeVl495IbqEKmWb+joxcS/dRJbVEkJvEipa1iq4qn641QGbJpvqstOnB2T6Qbo
eerca82gi72ySa3cZ2xqAwiVgc4dSWQyI3nbdSql2Bclm6sYwBGV/lDGe9AR2bul915d72OtpTlA
lmcrMMm2x4hBvmxdJffyYn9SsdQX+c23qorVIYYHf4MNMiIzWKaB40PExbKOTfDAR/R8Mx67ayAm
2mJFI7e9BxdDhmamuZ0zy1AIyjjY7TAyP2hcEZWc36+vFcJoWLgVA3NEilCXze7bwncTwPCnU9YR
Y+Ja6CjNYWGPFyHPV7F0WVvhgxpVcKaXPpKsriBmsA==
=77qz
-----END PGP SIGNATURE-----

--------------kpAtuAfZJCcVsepCeDiDvzPI--

