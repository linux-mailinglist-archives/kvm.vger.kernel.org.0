Return-Path: <kvm+bounces-65342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D37CA7354
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 11:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E460F3011394
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 10:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B83314D35;
	Fri,  5 Dec 2025 10:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IdUuPk6+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A230C62D
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 10:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764931187; cv=none; b=TpHe45C1hrELusEHS6R4xDoV5awOKitF8OVC+VnhWDjDQCMd80Hx1YrUO/i7j2liJD2jEcS7JoXHvAMfIUf19P+63dmf8f0WbRPhr2/9L1MMrTtHy6MzKwmKaWUajCJPD+55i02CSTkBQHBFqKXK7NFMK7zY6hfGGCWObjKv7cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764931187; c=relaxed/simple;
	bh=9B+3dLwVnmzdYLdGV3cJHf2Wnkmgl5s0/Gu9wogZSxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NF3bcr68DKMRq/NRLeJkGpq8q3cLfolpghkGyz38N2Qofns+vIsWPmE8IkgdKIDv2MfzhB5useTOFZo7hrB9XBgM7GqzmM2upI1zNm3bLBzuDMLDv5xN1dp3o+Y6svK2iBX2WF+r65p5Lq5cveTn0xPpxqI031heypdX6Bn9ZuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IdUuPk6+; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b735ce67d1dso307602366b.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 02:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764931179; x=1765535979; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9B+3dLwVnmzdYLdGV3cJHf2Wnkmgl5s0/Gu9wogZSxo=;
        b=IdUuPk6+iwTWRkc5Ib8XOZrtrZSE58hf+WyE7Bwn7wEWIne4JXkP8YohLu5IxgOjw+
         NL79QL/KiG8iAy/7IbsgCFMaWhSjZfX+7QKoSMDa0d6yb3AmAFI5gxZCao+Yml7uZbFR
         QnICxtQJyFTt5rW35HxKlPpUH+wkzS+M+rQAuLM0BXYO5IzRhkkd74GKqJy/rO4/mBRN
         h0HTFp9KOp+oFvZZayNOPO2OxjnTUN3hwDMZ6b1twf4hvsyZT58/7af8t11xTz8xUbtW
         jrdCchhDTF0DHntnFW1bc/AQIGuCo9mxR67RGgEaZWM8Q46cfk2WbJ6b6k8657dK6GfE
         82ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764931179; x=1765535979;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9B+3dLwVnmzdYLdGV3cJHf2Wnkmgl5s0/Gu9wogZSxo=;
        b=Ve3OG/GRXeIxEA1UqL2XZ5Oum4NSBuqVRpgmhQY0o4jSplSKhSRzENpN4odqqEBne3
         J6FiIedDO50bO9ZixAC+CVkBEjoSdThgDdV2aGzT7jef++4+kjB7YROHE8Z6SITQGSEr
         AM1iQBSkx40Ylt/MmvGNn5V0hhoE0Z1AdNboRUbTwVA05E6aG1ervmB148hRWweW+8yC
         E57xhKkL2zbBjuZc86qucMnp45q5XEuQs9CaI+OijUfXy7pLMY90ysjntWrzcdExIfw0
         okhTe6+KH020j8kcHeVO53J3VGqYyjyNroIVlq+iWgkEitrTdYBBl81QMMt8FDzhqeJA
         a2AQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIXxOWMtBr/i8OA8GkaUsHd/a/n7llav/9Y6C+QoEsM6ZBDUVPL4uAEoCUq/xAEGc5iMg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWUMes1/W30mBKXmeQDTlwNIDYrspRIvQiyzUPodKVviJzKtFc
	vgCAFZKCLcBcVUUgrby4SvwF+vBP/z0fIXlf4NvBKhfbU6mn6Bo6VewYKmoRJU0rhkY=
X-Gm-Gg: ASbGncsoMhApEaClV+iLRI/2H16tB2Xefpeso6JfSGQl+wBel3JjxyVhvzMJRe+bg5U
	sJdcoVwTlmx6plevBVE3HYhl4NsAbmIVJdSwnHP2gySFQY+prmVmlWzWYF79e1biJR0qvT8na4f
	/B3+Bc+GkfUfA0UY1LTNSuMNFCe+VQIERZBTHy+tMdccJ4/imQtpVzwIuhYyjeoxm2+mLR77TEh
	WLf9EKdID6Utt/c39Wer91GvCPfPjIJ4dLjx0cjR8pkAVzuybQAKzQmkIKBcAqeF02ELkYphPJZ
	xTdEj/Yhz/1UH02R6cs9rsDRvHHPMWSudbQsMP5AfSZAZoCvOx9CdrLtDw9tHF/fvS5DkMR7NSw
	NH1Jh7kbabiq7dvrdI4tjzTytS88tXHf9vO9QkvfrT+KO1PlpDTT8Vb3deFhkhqhxkTyqdZmxvg
	S/eLF8FZzn2UNCcUjz7m7ssY0n5Hmnyy2Bww0rzeQGSPqUUtb3V4T4Y65QWKVImZVGe+TNzfivf
	um1VUTEB5bhVQXgCwcB0osRb1ONP2YWaEkK
X-Google-Smtp-Source: AGHT+IEnDJKOYtCe1U8bEfZE7EQ1FIcEEVEzzTkn64YbJgXgBiREOFEKDoxxkDElV64ZpADT83347Q==
X-Received: by 2002:a17:907:5c8:b0:b73:21af:99d4 with SMTP id a640c23a62f3a-b79ec473903mr567760166b.24.1764931179338;
        Fri, 05 Dec 2025 02:39:39 -0800 (PST)
Received: from ?IPV6:2003:e5:8721:bb00:9139:4e25:a543:997? (p200300e58721bb0091394e25a5430997.dip0.t-ipconnect.de. [2003:e5:8721:bb00:9139:4e25:a543:997])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f449b160sm347699566b.23.2025.12.05.02.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 02:39:38 -0800 (PST)
Message-ID: <34048508-8ddd-4183-9d0d-f495af1984ab@suse.com>
Date: Fri, 5 Dec 2025 11:39:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] KVM/x86: Add KVM_MSR_RET_* defines for values 0 and
 1
To: Vitaly Kuznetsov <vkuznets@redhat.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
References: <20251205074537.17072-1-jgross@suse.com>
 <20251205074537.17072-6-jgross@suse.com> <877bv1kz1a.fsf@redhat.com>
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
In-Reply-To: <877bv1kz1a.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------dPOptghetN6C3RHzYnzRIqGb"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------dPOptghetN6C3RHzYnzRIqGb
Content-Type: multipart/mixed; boundary="------------999wVyxoBptiSNE7vjkn1qIw";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <34048508-8ddd-4183-9d0d-f495af1984ab@suse.com>
Subject: Re: [PATCH 05/10] KVM/x86: Add KVM_MSR_RET_* defines for values 0 and
 1
References: <20251205074537.17072-1-jgross@suse.com>
 <20251205074537.17072-6-jgross@suse.com> <877bv1kz1a.fsf@redhat.com>
In-Reply-To: <877bv1kz1a.fsf@redhat.com>

--------------999wVyxoBptiSNE7vjkn1qIw
Content-Type: multipart/mixed; boundary="------------kLc4z9sQJhwkBr3tr9GiSQi3"

--------------kLc4z9sQJhwkBr3tr9GiSQi3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDUuMTIuMjUgMTE6MjMsIFZpdGFseSBLdXpuZXRzb3Ygd3JvdGU6DQo+IEp1ZXJnZW4g
R3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4gd3JpdGVzOg0KPiANCj4+IEZvciBNU1IgZW11bGF0
aW9uIHJldHVybiB2YWx1ZXMgb25seSAyIHNwZWNpYWwgY2FzZXMgaGF2ZSBkZWZpbmVzLA0K
Pj4gd2hpbGUgdGhlIG1vc3QgdXNlZCB2YWx1ZXMgMCBhbmQgMSBkb24ndC4NCj4+DQo+PiBS
ZWFzb24gc2VlbXMgdG8gYmUgdGhlIG1hemUgb2YgZnVuY3Rpb24gY2FsbHMgb2YgTVNSIGVt
dWxhdGlvbg0KPj4gaW50ZXJ0d2luZWQgd2l0aCB0aGUgS1ZNIGd1ZXN0IGV4aXQgaGFuZGxl
cnMsIHdoaWNoIGFyZSB1c2luZyB0aGUNCj4+IHZhbHVlcyAwIGFuZCAxIGZvciBvdGhlciBw
dXJwb3Nlcy4gVGhpcyBldmVuIGxlZCB0byB0aGUgY29tbWVudCBhYm92ZQ0KPj4gdGhlIGFs
cmVhZHkgZXhpc3RpbmcgZGVmaW5lcywgd2FybmluZyB0byB1c2UgdGhlIHZhbHVlcyAwIGFu
ZCAxIChhbmQNCj4+IG5lZ2F0aXZlIGVycm5vIHZhbHVlcykgaW4gdGhlIE1TUiBlbXVsYXRp
b24gYXQgYWxsLg0KPj4NCj4+IEZhY3QgaXMgdGhhdCBNU1IgZW11bGF0aW9uIGFuZCBleGl0
IGhhbmRsZXJzIGFyZSBpbiBmYWN0IHJhdGhlciB3ZWxsDQo+PiBkaXN0aW5jdCwgd2l0aCBv
bmx5IHZlcnkgZmV3IGV4Y2VwdGlvbnMgd2hpY2ggYXJlIGhhbmRsZWQgaW4gYSBzYW5lDQo+
PiB3YXkuDQo+Pg0KPj4gU28gYWRkIGRlZmluZXMgZm9yIDAgYW5kIDEgdmFsdWVzIG9mIE1T
UiBlbXVsYXRpb24gYW5kIGF0IHRoZSBzYW1lDQo+PiB0aW1lIGNvbW1lbnRzIHdoZXJlIGV4
aXQgaGFuZGxlcnMgYXJlIGNhbGxpbmcgaW50byBNU1IgZW11bGF0aW9uLg0KPj4NCj4+IFRo
ZSBuZXcgZGVmaW5lcyB3aWxsIGJlIHVzZWQgbGF0ZXIuDQo+Pg0KPj4gTm8gY2hhbmdlIG9m
IGZ1bmN0aW9uYWxpdHkgaW50ZW5kZWQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSnVlcmdl
biBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KPj4gLS0tDQo+PiAgIGFyY2gveDg2L2t2bS94
ODYuYyB8ICAyICsrDQo+PiAgIGFyY2gveDg2L2t2bS94ODYuaCB8IDEwICsrKysrKysrLS0N
Cj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9r
dm0veDg2LmMNCj4+IGluZGV4IGU3MzNjYjkyMzMxMi4uZTg3OTYzYTQ3YWE1IDEwMDY0NA0K
Pj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0veDg2
LmMNCj4+IEBAIC0yMTMwLDYgKzIxMzAsNyBAQCBzdGF0aWMgaW50IF9fa3ZtX2VtdWxhdGVf
cmRtc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgbXNyLCBpbnQgcmVnLA0KPj4gICAJ
dTY0IGRhdGE7DQo+PiAgIAlpbnQgcjsNCj4+ICAgDQo+PiArCS8qIENhbGwgTVNSIGVtdWxh
dGlvbi4gKi8NCj4+ICAgCXIgPSBrdm1fZW11bGF0ZV9tc3JfcmVhZCh2Y3B1LCBtc3IsICZk
YXRhKTsNCj4+ICAgDQo+PiAgIAlpZiAoIXIpIHsNCj4+IEBAIC0yMTcxLDYgKzIxNzIsNyBA
QCBzdGF0aWMgaW50IF9fa3ZtX2VtdWxhdGVfd3Jtc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCB1MzIgbXNyLCB1NjQgZGF0YSkNCj4+ICAgew0KPj4gICAJaW50IHI7DQo+PiAgIA0KPj4g
KwkvKiBDYWxsIE1TUiBlbXVsYXRpb24uICovDQo+PiAgIAlyID0ga3ZtX2VtdWxhdGVfbXNy
X3dyaXRlKHZjcHUsIG1zciwgZGF0YSk7DQo+PiAgIAlpZiAoIXIpIHsNCj4+ICAgCQl0cmFj
ZV9rdm1fbXNyX3dyaXRlKG1zciwgZGF0YSk7DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL3g4Ni5oIGIvYXJjaC94ODYva3ZtL3g4Ni5oDQo+PiBpbmRleCBmM2RjNzdmMDA2Zjku
LmU0NGI2MzczYjEwNiAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuaA0KPj4g
KysrIGIvYXJjaC94ODYva3ZtL3g4Ni5oDQo+PiBAQCAtNjM5LDE1ICs2MzksMjEgQEAgZW51
bSBrdm1fbXNyX2FjY2VzcyB7DQo+PiAgIC8qDQo+PiAgICAqIEludGVybmFsIGVycm9yIGNv
ZGVzIHRoYXQgYXJlIHVzZWQgdG8gaW5kaWNhdGUgdGhhdCBNU1IgZW11bGF0aW9uIGVuY291
bnRlcmVkDQo+PiAgICAqIGFuIGVycm9yIHRoYXQgc2hvdWxkIHJlc3VsdCBpbiAjR1AgaW4g
dGhlIGd1ZXN0LCB1bmxlc3MgdXNlcnNwYWNlIGhhbmRsZXMgaXQuDQo+PiAtICogTm90ZSwg
JzEnLCAnMCcsIGFuZCBuZWdhdGl2ZSBudW1iZXJzIGFyZSBvZmYgbGltaXRzLCBhcyB0aGV5
IGFyZSB1c2VkIGJ5IEtWTQ0KPj4gLSAqIGFzIHBhcnQgb2YgS1ZNJ3MgbGlnaHRseSBkb2N1
bWVudGVkIGludGVybmFsIEtWTV9SVU4gcmV0dXJuIGNvZGVzLg0KPj4gKyAqIE5vdGUsIG5l
Z2F0aXZlIGVycm5vIHZhbHVlcyBhcmUgcG9zc2libGUgZm9yIHJldHVybiB2YWx1ZXMsIHRv
by4NCj4+ICsgKiBJbiBjYXNlIE1TUiBlbXVsYXRpb24gaXMgY2FsbGVkIGZyb20gYW4gZXhp
dCBoYW5kbGVyLCBhbnkgcmV0dXJuIHZhbHVlIG90aGVyDQo+PiArICogdGhhbiBLVk1fTVNS
X1JFVF9PSyB3aWxsIG5vcm1hbGx5IHJlc3VsdCBpbiBhIEdQIGluIHRoZSBndWVzdC4NCj4+
ICAgICoNCj4+ICsgKiBPSwkJLSBFbXVsYXRpb24gc3VjY2VlZGVkLiBNdXN0IGJlIDAsIGFz
IGluIHNvbWUgY2FzZXMgcmV0dXJuIHZhbHVlcw0KPj4gKyAqCQkgIG9mIGZ1bmN0aW9ucyBy
ZXR1cm5pbmcgMCBvciAtZXJybm8gd2lsbCBqdXN0IGJlIHBhc3NlZCBvbi4NCj4+ICsgKiBF
UlIJCS0gU29tZSBlcnJvciBvY2N1cnJlZC4NCj4+ICAgICogVU5TVVBQT1JURUQJLSBUaGUg
TVNSIGlzbid0IHN1cHBvcnRlZCwgZWl0aGVyIGJlY2F1c2UgaXQgaXMgY29tcGxldGVseQ0K
Pj4gICAgKgkJICB1bmtub3duIHRvIEtWTSwgb3IgYmVjYXVzZSB0aGUgTVNSIHNob3VsZCBu
b3QgZXhpc3QgYWNjb3JkaW5nDQo+PiAgICAqCQkgIHRvIHRoZSB2Q1BVIG1vZGVsLg0KPj4g
ICAgKg0KPj4gICAgKiBGSUxURVJFRAktIEFjY2VzcyB0byB0aGUgTVNSIGlzIGRlbmllZCBi
eSBhIHVzZXJzcGFjZSBNU1IgZmlsdGVyLg0KPj4gICAgKi8NCj4+ICsjZGVmaW5lICBLVk1f
TVNSX1JFVF9PSwkJCTANCj4+ICsjZGVmaW5lICBLVk1fTVNSX1JFVF9FUlIJCTENCj4+ICAg
I2RlZmluZSAgS1ZNX01TUl9SRVRfVU5TVVBQT1JURUQJMg0KPj4gICAjZGVmaW5lICBLVk1f
TVNSX1JFVF9GSUxURVJFRAkJMw0KPiANCj4gSSBsaWtlIHRoZSBnZW5lcmFsIGlkZWEgb2Yg
dGhlIHNlcmllcyBhcyAxLzAgY2FuIGluZGVlZCBiZQ0KPiBjb25mdXNpbmcuIFdoYXQgSSdt
IHdvbmRlcmluZyBpcyBpZiB3ZSBjYW4gZG8gYmV0dGVyIGJ5IGNoYW5naW5nICdpbnQnDQo+
IHJldHVybiB0eXBlIHRvIHNvbWV0aGluZyBlbHNlLiBJLmUuIGlmIHRoZSByZXN1bHQgb2Yg
dGhlIGZ1bmN0aW9uIGNhbiBiZQ0KPiAncGFzc2VkIG9uJyBhbmQgS1ZNX01TUl9SRVRfT0sv
S1ZNX01TUl9SRVRfRVJSIGhhdmUgb25lIG1lYW5pbmcgd2hpbGUNCj4gS1ZNX01TUl9SRVRf
VU5TVVBQT1JURUQvS1ZNX01TUl9SRVRfRklMVEVSRUQgaGF2ZSBhbm90aGVyLCBtYXliZSB3
ZSBjYW4NCj4gZG8gYmV0dGVyIGJ5IGNoYW5naW5nIHRoZSByZXR1cm4gdHlwZSB0byBzb21l
dGhpbmcgYW5kIHRoZW4sIHdoZW4gdGhlDQo+IHZhbHVlIG5lZWRzIHRvIGJlIHBhc3NlZCBv
biwgZG8gcHJvcGVyIGV4cGxpY2l0IHZldHRpbmcgb2YgdGhlIHJlc3VsdA0KPiAoZS5nLiB0
byBtYWtlIHN1cmUgb25seSAxLzAgcGFzcyB0aHJvdWdoKT8gSnVzdCBhIHRob3VnaHQsIEkg
dGhpbmsgdGhlDQo+IHNlcmllcyBhcy1pcyBtYWtlcyB0aGluZ3MgYmV0dGVyIGFuZCB3ZSBj
YW4gZ28gd2l0aCBpdCBmb3Igbm93Lg0KDQpUaGUgcGFzcyB0aHJvdWdoIGNhc2UgaXMgYWx3
YXlzIDAgb3IgLWVycm5vLCBuZXZlciB0aGUgIjEiIChhbmQgb2YgY291cnNlDQpLVk1fTVNS
X1JFVF8qLy1lcnJubykuDQoNCkNoYW5naW5nIGZyb20gaW50IHRvIHNvbWV0aGluZyBlbHNl
IHdvdWxkIHByb2JhYmx5IHJlcXVpcmUgc29tZSBoZWxwZXJzDQpmb3IgZS5nLiBzdHVmZmlu
ZyBzb21ldGhpbmcgbGlrZSAtRUlOVkFMIGludG8gaXQuIEFuIGVudW0gYWxvbmUgd291bGRu
J3QNCndvcmsgZm9yIHRoaXMsIHNvIGl0IHdvdWxkIG5lZWQgdG8gYmUgYSBzcGVjaWZpYyBu
ZXcgdHlwZSwgbGlrZSBhIHVuaW9uDQpvZiBhbiBpbnQgKGZvciB0aGUgLWVycm5vKSBhbmQg
YW4gZW51bSwgYnV0IEkgYmVsaWV2ZSB0aGlzIHdvdWxkIG1ha2UgdGhlDQpjb2RlIGhhcmRl
ciB0byByZWFkIGluc3RlYWQgb2YgaW1wcm92aW5nIGl0Lg0KDQoNCkp1ZXJnZW4NCg==
--------------kLc4z9sQJhwkBr3tr9GiSQi3
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------kLc4z9sQJhwkBr3tr9GiSQi3--

--------------999wVyxoBptiSNE7vjkn1qIw--

--------------dPOptghetN6C3RHzYnzRIqGb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmkytmoFAwAAAAAACgkQsN6d1ii/Ey8j
3gf/QdFvSdQNdVtaEygN0JDFkqIjnz1S47QBTKbvUUoh8SPihHCWK2VdRs2s9BEohLwBmWIOE1Ww
6sq84KaxAyGtVPsNiohDHfPNtmofa1UpmRWY4fViFi/YjkdVB1zebaAj8SY1xVuSl5ZpNljgI9G4
VTj3KM0pgycKqyb8riRdnNqwepQMniG0OVJ59r8sZvkmFJscT8swsePbNRBYgD8IxYjmaLK5wP7W
sRSfGjqybvoapl1B1uZPdHr/+jd9cHyHt+EnhyuwHa/PzN4hASXlskv9wPW5qrpxGm9UUm1YWt5w
/MtECk+WB2rJnVZBmr+esU1FwMMucfoRL4PAx4lVxQ==
=L5PL
-----END PGP SIGNATURE-----

--------------dPOptghetN6C3RHzYnzRIqGb--

