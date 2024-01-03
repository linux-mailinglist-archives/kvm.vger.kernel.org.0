Return-Path: <kvm+bounces-5513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCEF0822964
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 09:15:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D69AD1C2061E
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8143182D2;
	Wed,  3 Jan 2024 08:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hlu1+viZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hlu1+viZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDF618AF8;
	Wed,  3 Jan 2024 08:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3642A21CF2;
	Wed,  3 Jan 2024 08:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704269665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDdWEV0J6pdwUgb7/0Pphdvrp0QTuRvZvpPA+yFA0vo=;
	b=hlu1+viZDWuEqHlOdyjUeeW6oT6T1wiOUwvU3olybG6SVWScKv06pGXYKltLXyULoBZ9Od
	1xTIX84/WQ3LYFUvLhYHO5QMaDOYC0WehLi9bz0mBTIv0M19vqHTOTCC3D7b955aAX98bo
	SYeLpav7v7xhOS8/22LynHSImakbXUE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704269665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDdWEV0J6pdwUgb7/0Pphdvrp0QTuRvZvpPA+yFA0vo=;
	b=hlu1+viZDWuEqHlOdyjUeeW6oT6T1wiOUwvU3olybG6SVWScKv06pGXYKltLXyULoBZ9Od
	1xTIX84/WQ3LYFUvLhYHO5QMaDOYC0WehLi9bz0mBTIv0M19vqHTOTCC3D7b955aAX98bo
	SYeLpav7v7xhOS8/22LynHSImakbXUE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F380B1340C;
	Wed,  3 Jan 2024 08:14:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XNIqOmAXlWW2WgAAD6G6ig
	(envelope-from <jgross@suse.com>); Wed, 03 Jan 2024 08:14:24 +0000
Message-ID: <df32d011-49c8-4bdb-a695-41cb6fbdf854@suse.com>
Date: Wed, 3 Jan 2024 09:14:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] LoongArch: Add paravirt interface for guest kernel
Content-Language: en-US
To: maobibo <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240103071615.3422264-1-maobibo@loongson.cn>
 <20240103071615.3422264-5-maobibo@loongson.cn>
 <66c15a1b-fb28-4653-982f-37494a01cd4f@suse.com>
 <4240d67f-1e5d-f865-c16e-32b64aea8099@loongson.cn>
From: Juergen Gross <jgross@suse.com>
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
In-Reply-To: <4240d67f-1e5d-f865-c16e-32b64aea8099@loongson.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------tgzca4fSYt0BHi3AQme6SbFR"
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-5.20 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[99.98%];
	 MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	 HAS_ATTACHMENT(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 DKIM_TRACE(0.00)[suse.com:+];
	 MIME_BASE64_TEXT(0.10)[];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim];
	 SIGNED_PGP(-2.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 MIME_UNKNOWN(0.10)[application/pgp-keys]
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hlu1+viZ
X-Spam-Score: -5.20
X-Rspamd-Queue-Id: 3642A21CF2

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------tgzca4fSYt0BHi3AQme6SbFR
Content-Type: multipart/mixed; boundary="------------fLpkBrtKh70ZrwL421D0x3h5";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: maobibo <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
Message-ID: <df32d011-49c8-4bdb-a695-41cb6fbdf854@suse.com>
Subject: Re: [PATCH 4/5] LoongArch: Add paravirt interface for guest kernel
References: <20240103071615.3422264-1-maobibo@loongson.cn>
 <20240103071615.3422264-5-maobibo@loongson.cn>
 <66c15a1b-fb28-4653-982f-37494a01cd4f@suse.com>
 <4240d67f-1e5d-f865-c16e-32b64aea8099@loongson.cn>
In-Reply-To: <4240d67f-1e5d-f865-c16e-32b64aea8099@loongson.cn>

--------------fLpkBrtKh70ZrwL421D0x3h5
Content-Type: multipart/mixed; boundary="------------fypVqc05097krRrRwVoYEHZc"

--------------fypVqc05097krRrRwVoYEHZc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDMuMDEuMjQgMDk6MDAsIG1hb2JpYm8gd3JvdGU6DQo+IA0KPiANCj4gT24gMjAyNC8x
LzMg5LiL5Y2IMzo0MCwgSsO8cmdlbiBHcm/DnyB3cm90ZToNCj4+IE9uIDAzLjAxLjI0IDA4
OjE2LCBCaWJvIE1hbyB3cm90ZToNCj4+PiBUaGUgcGF0Y2ggYWRkIHBhcmF2aXJ0IGludGVy
ZmFjZSBmb3IgZ3Vlc3Qga2VybmVsLCBpdCBjaGVja3Mgd2hldGhlcg0KPj4+IHN5c3RlbSBy
dW5zIG9uIFZNIG1vZGUuIElmIGl0IGlzLCBpdCB3aWxsIGRldGVjdCBoeXBlcnZpc29yIHR5
cGUuIEFuZA0KPj4+IHJldHVybnMgdHJ1ZSBpdCBpcyBLVk0gaHlwZXJ2aXNvciwgZWxzZSBy
ZXR1cm4gZmFsc2UuIEN1cnJlbnRseSBvbmx5DQo+Pj4gS1ZNIGh5cGVydmlzb3IgaXMgc3Vw
cG9ydGVkLCBzbyB0aGVyZSBpcyBvbmx5IGh5cGVydmlzb3IgZGV0ZWN0aW9uDQo+Pj4gZm9y
IEtWTSB0eXBlLg0KPj4NCj4+IEkgZ3Vlc3MgeW91IGFyZSB0YWxraW5nIG9mIHB2X2d1ZXN0
X2luaXQoKSBoZXJlPyBPciBkbyB5b3UgbWVhbg0KPj4ga3ZtX3BhcmFfYXZhaWxhYmxlKCk/
DQo+IHllcywgaXQgaXMgcHZfZ3Vlc3RfaW5pdC4gSXQgd2lsbCBiZSBiZXR0ZXIgaWYgYWxs
IGh5cGVydmlzb3IgZGV0ZWN0aW9uDQo+IGlzIGNhbGxlZCBpbiBmdW5jdGlvbiBwdl9ndWVz
dF9pbml0LiBDdXJyZW50bHkgdGhlcmUgaXMgb25seSBrdm0gaHlwZXJ2aXNvciwgDQo+IGt2
bV9wYXJhX2F2YWlsYWJsZSBpcyBoYXJkLWNvZGVkIGluIHB2X2d1ZXN0X2luaXQgaGVyZS4N
Cg0KSSB0aGluayB0aGlzIGlzIG5vIHByb2JsZW0gYXMgbG9uZyBhcyB0aGVyZSBhcmUgbm90
IG1vcmUgaHlwZXJ2aXNvcnMNCnN1cHBvcnRlZC4NCg0KPiANCj4gSSBjYW4gc3BsaXQgZmls
ZSBwYXJhdmlydC5jIGludG8gcGFyYXZpcnQuYyBhbmQga3ZtLmMsIHBhcmF2aXJ0LmMgaXMg
dXNlZCBmb3IgDQo+IGh5cGVydmlzb3IgZGV0ZWN0aW9uLCBhbmQgbW92ZSBjb2RlIHJlbGF0
aXZlIHdpdGggcHZfaXBpIGludG8ga3ZtLmMNCg0KSSB3b3VsZG4ndCBkbyB0aGF0IHJpZ2h0
IG5vdy4NCg0KSnVzdCBiZSBhIGxpdHRsZSBiaXQgbW9yZSBzcGVjaWZpYyBpbiB0aGUgY29t
bWl0IG1lc3NhZ2UgKHVzZSB0aGUgcmVsYXRlZA0KZnVuY3Rpb24gbmFtZSBpbnN0ZWFkIG9m
ICJpdCIpLg0KDQoNCkp1ZXJnZW4NCg==
--------------fypVqc05097krRrRwVoYEHZc
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------fypVqc05097krRrRwVoYEHZc--

--------------fLpkBrtKh70ZrwL421D0x3h5--

--------------tgzca4fSYt0BHi3AQme6SbFR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmWVF2AFAwAAAAAACgkQsN6d1ii/Ey8o
NAf/TZh0SORN6LHRYHBW4FSRkcv9hEr7CxuYSngXeDuBjnRwBXjKQZY/pyZyfmn8cQwt2ZbccDI0
cFbU2kZaOsNwQ0VNGrh9DhmDquw0ocpaAEBphjq3UB40uxIvBI64MdCUV4ob/nHxyLfBhrFrWIvY
wLJl58AuU9zGYYIt52yluHmj1dN8dWyXfxG2FM0O2DBEaZMsw2e/Hr4DHAIYu7XDXDs4F4Z3PaGP
7HyqaNJnBbseoyQpAdEaTGzNZ6Fc9grau+Q7uZ4EfHKKpt3AyldGJ7M/g6X43BrR1KtC10qVbOl8
XKjUNxhO7X/U9jx4U0x6kxrd/g28IaVmE/2SX+tTJw==
=AnNf
-----END PGP SIGNATURE-----

--------------tgzca4fSYt0BHi3AQme6SbFR--

