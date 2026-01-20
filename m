Return-Path: <kvm+bounces-68556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 83232D3C103
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8F6DC50609F
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 07:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49483AEF21;
	Tue, 20 Jan 2026 07:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MXvO+kDY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417B63A9625
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 07:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768895329; cv=none; b=kZl/DiR4222rQkuw6KxKd0QAkT8EvBb2RoIXkIF6SqiWXWaeEBwzIr1ypc/yP0SHYCLESkmMqzbV5X5vQZw5+QLE531hOMmZDlDMg5qrW0WIV6JU0Ji91mHZBvB1GOx4atz+PDphsGWTwpFN2bqd+Ii+by/475QwJgzgFPk3UMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768895329; c=relaxed/simple;
	bh=Vfv0ZXDI9NMxKa0UB+mr5aB3FRbPOsdsuHFkDSeSj3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tc6OGaT4qhoXOXgelYEdQWCFyfFfMzSFVEcx+yE7C2Ku9BYXtMw4yrFXWA2PFACH05T4A/S9zz9FtgPx+fxKOcdtrOr7WSYO3zVry2KEPoKYaCiLeJtwhVkijU/Pev9tGquAhg7hqPVwAf9k8BPRmB3HkAgVI23Pz2NxazEZ+wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MXvO+kDY; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b8708930695so782592966b.3
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 23:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768895324; x=1769500124; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vfv0ZXDI9NMxKa0UB+mr5aB3FRbPOsdsuHFkDSeSj3M=;
        b=MXvO+kDYx0i5Uw7xmBwNvZowqSz9VbIv8yzk2Xl+8CYJHE+jyhb6QfqMw9ZE/0KjKD
         WP76XGd13IgF5aEUcjtIviWuO1wB6I0+3bS197KFGsVP4lO6AyHEIGUkKWn3njswuONo
         zg9ZBvxIyZV3+fB4Mo+L+TF+QPl2x3OO0GQk0xdm7dmwXvrs9MZbgpLIdkU0b1GCaaYG
         xAFELjhm7faGqyS3nLEwK6hVZ9gNMo6XGC8LA+/hIe+4KiSc8mXLd78C4zc+ASIJIBYH
         +3zs3NF9NrKhBGBXE5q18PJFJ5QfQ4cAomAsFoDsC1W/PR63Pj6/6WUrDXm+AyBHvBzE
         ozjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768895324; x=1769500124;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vfv0ZXDI9NMxKa0UB+mr5aB3FRbPOsdsuHFkDSeSj3M=;
        b=Bo1FjSugfocZUScssvZhafR+VnxYfrQIKvURzqh7AKVS3Hx5XhbZnurzhymdUk5GXf
         GJ1C3CxKJJPUvdJnZasUv19TQXb6THFOvXv8hUHjlAdRoDTYOtZzpa6Z2MpyVmigaIY7
         eTOnt0U9QWBplpzKjRE8K9o/YeF7MTpOo3McgCY/E9Q+v/n9HWmZLzHjFOhB6jSQhK5f
         B+xVIdnXV6uhBOlIQ38YlD5XFl/6Osp77u59O4Wc8NbHgTxVHvAhUGIb0rFl8tdfzNzI
         Ig9eKO9tjHPgFXqLmDIt9JWYkl9ttQZv0miXjuRqlB0cqXshm6WzK4yHuM86B7jQ30qx
         bUVw==
X-Forwarded-Encrypted: i=1; AJvYcCXH9V/7+Z+msiSNwEgQTvI1boG5d8j9qdAt6q/EHlAa5u9T2KVaBRTujNKm7XET7mJCW0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyISaz05myMZsdHBKA1u+nngNC76oPE4yXFDe3ptALsVpVZJoxm
	tBE+X81bffwIJEUDuHlxA5nAWF7hA4R/c9Bm4T0daOoiQqSwF826EgqlmeP2IzBl3H0=
X-Gm-Gg: AZuq6aKmVUy/XwAeksa9jYoMuKLrl+bhMzQ3fqMz9cxQljiKFtLnExedSrETGUCjg6n
	XVYK/B5ZryemgsBaVe5NaaqhJvIrOF3P4kU+NlEhuygU8G+FLs5Oisqhp7QZgzA7qt6Ub86KmjW
	VN47coMC8cmLsb/RqZwYMegU/J94Q+j0Nt3NIIsoIu8Eezzw8lxTNaSW/krVqIxqkMUiyL2Gdhr
	CGGPzP4yl0BQ6KexfP+djIXWozaJw2hddLw6WGc/Y0Q/LaSaFUj+UQp2wboc3/bog/aN3RqvoBQ
	aPngjJausKDfjfALOY4uDcEfEprs6T0jNwO5DYkB07ePwiDSE2Fa8OAuIkij1WVezZU3MrT9qQM
	Ra/+IMXjyvA3+nQXnv/UC8OyGQjdwk4TQtlAP5lOk484zf781ozGZclOK0cP2iwngU194FTIIIF
	4MuiUkVARhIPQ5TLqKVQZFd+VfBRCF7SW/pZvLkYKZe/IEW6ybZm4FHtiL41zy2Qn+TRi3f4gT2
	WDKG9X9UROeOhMtcrpNOmUtdtopKcGLyxsRzw==
X-Received: by 2002:a17:907:1c1f:b0:b87:2abc:4a26 with SMTP id a640c23a62f3a-b87968e2de0mr1185632466b.14.1768895324078;
        Mon, 19 Jan 2026 23:48:44 -0800 (PST)
Received: from ?IPV6:2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1? (2a00-12d0-af5b-2f01-4042-c03-ce4d-a5a1.ip.tng.de. [2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b879513e951sm1295535466b.7.2026.01.19.23.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 23:48:43 -0800 (PST)
Message-ID: <409f5119-7dc1-4f45-a099-281db82254f3@suse.com>
Date: Tue, 20 Jan 2026 08:48:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v2] x86/xen/pvh: Enable PAE mode for 32-bit guest
 only when CONFIG_X86_PAE is set
To: Hou Wenlong <houwenlong.hwl@antgroup.com>, linux-kernel@vger.kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>
References: <d09ce9a134eb9cbc16928a5b316969f8ba606b81.1768017442.git.houwenlong.hwl@antgroup.com>
 <20260120073927.GA119722@k08j02272.eu95sqa>
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
In-Reply-To: <20260120073927.GA119722@k08j02272.eu95sqa>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------OSdmLCKJYpfSNxq0Wx4JLpwK"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------OSdmLCKJYpfSNxq0Wx4JLpwK
Content-Type: multipart/mixed; boundary="------------cpNzhBrcuTPLokogMcDomDeY";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>, linux-kernel@vger.kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>
Message-ID: <409f5119-7dc1-4f45-a099-281db82254f3@suse.com>
Subject: Re: [PATCH RESEND v2] x86/xen/pvh: Enable PAE mode for 32-bit guest
 only when CONFIG_X86_PAE is set
References: <d09ce9a134eb9cbc16928a5b316969f8ba606b81.1768017442.git.houwenlong.hwl@antgroup.com>
 <20260120073927.GA119722@k08j02272.eu95sqa>
In-Reply-To: <20260120073927.GA119722@k08j02272.eu95sqa>

--------------cpNzhBrcuTPLokogMcDomDeY
Content-Type: multipart/mixed; boundary="------------z8FoFp1Kx6hLnTOula8pTlkv"

--------------z8FoFp1Kx6hLnTOula8pTlkv
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjAuMDEuMjYgMDg6MzksIEhvdSBXZW5sb25nIHdyb3RlOg0KPiAra3ZtLCBJJ20gbm90
IHN1cmUgd2hldGhlciBpdCBpcyBuZWVkZWQuDQoNCkkgaGF2ZSBxdWV1ZWQgaXQgaW4gdGhl
IFhlbiB0cmVlIGZvciB0aGUgbmV4dCBtZXJnZSB3aW5kb3cuDQoNCg0KSnVlcmdlbg0KDQo+
IA0KPiBPbiBTYXQsIEphbiAxMCwgMjAyNiBhdCAxMjowMDowOFBNICswODAwLCBIb3UgV2Vu
bG9uZyB3cm90ZToNCj4+IFRoZSBQVkggZW50cnkgaXMgYXZhaWxhYmxlIGZvciAzMi1iaXQg
S1ZNIGd1ZXN0cywgYW5kIDMyLWJpdCBLVk0gZ3Vlc3RzDQo+PiBkbyBub3QgZGVwZW5kIG9u
IENPTkZJR19YODZfUEFFLiBIb3dldmVyLCBta19lYXJseV9wZ3RibF8zMigpIGJ1aWxkcw0K
Pj4gZGlmZmVyZW50IHBhZ2V0YWJsZXMgZGVwZW5kaW5nIG9uIHdoZXRoZXIgQ09ORklHX1g4
Nl9QQUUgaXMgc2V0Lg0KPj4gVGhlcmVmb3JlLCBlbmFibGluZyBQQUUgbW9kZSBmb3IgMzIt
Yml0IEtWTSBndWVzdHMgd2l0aG91dA0KPj4gQ09ORklHX1g4Nl9QQUUgYmVpbmcgc2V0IHdv
dWxkIHJlc3VsdCBpbiBhIGJvb3QgZmFpbHVyZSBkdXJpbmcgQ1IzDQo+PiBsb2FkaW5nLg0K
Pj4NCj4+IFNpZ25lZC1vZmYtYnk6IEhvdSBXZW5sb25nIDxob3V3ZW5sb25nLmh3bEBhbnRn
cm91cC5jb20+DQo+PiBSZXZpZXdlZC1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2Uu
Y29tPg0KPj4gLS0tDQo+PiBJIHJlc2VuZCB0aGlzIGJlY2F1c2UgSSBlbmNvdW50ZXJlZCB0
aGUgMzItYml0IEtWTSBndWVzdCBQVkggYm9vdGluZyBmYWlsdXJlIGFnYWluLiBJDQo+PiBo
b3BlIHRoaXMgY2FuIGJlIGZpeGVkLg0KPj4gb3JpZ2luYWwgdjI6DQo+PiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9hbGwvMDQ2OWMyNzgzM2JlNThhYTY2NDcxOTIwYWE3NzkyMjQ4OWQ4
NmM2My4xNzEzODczNjEzLmdpdC5ob3V3ZW5sb25nLmh3bEBhbnRncm91cC5jb20NCj4+IC0t
LQ0KPj4gICBhcmNoL3g4Ni9wbGF0Zm9ybS9wdmgvaGVhZC5TIHwgMiArKw0KPj4gICAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L3BsYXRmb3JtL3B2aC9oZWFkLlMgYi9hcmNoL3g4Ni9wbGF0Zm9ybS9wdmgvaGVhZC5T
DQo+PiBpbmRleCAzNDQwMzBjMWE4MWQuLjUzZWUyZDUzZmNmOCAxMDA2NDQNCj4+IC0tLSBh
L2FyY2gveDg2L3BsYXRmb3JtL3B2aC9oZWFkLlMNCj4+ICsrKyBiL2FyY2gveDg2L3BsYXRm
b3JtL3B2aC9oZWFkLlMNCj4+IEBAIC05MSwxMCArOTEsMTIgQEAgU1lNX0NPREVfU1RBUlQo
cHZoX3N0YXJ0X3hlbikNCj4+ICAgDQo+PiAgIAlsZWFsIHJ2YShlYXJseV9zdGFja19lbmQp
KCVlYnApLCAlZXNwDQo+PiAgIA0KPj4gKyNpZiBkZWZpbmVkKENPTkZJR19YODZfNjQpIHx8
IGRlZmluZWQoQ09ORklHX1g4Nl9QQUUpDQo+PiAgIAkvKiBFbmFibGUgUEFFIG1vZGUuICov
DQo+PiAgIAltb3YgJWNyNCwgJWVheA0KPj4gICAJb3JsICRYODZfQ1I0X1BBRSwgJWVheA0K
Pj4gICAJbW92ICVlYXgsICVjcjQNCj4+ICsjZW5kaWYNCj4+ICAgDQo+PiAgICNpZmRlZiBD
T05GSUdfWDg2XzY0DQo+PiAgIAkvKiBFbmFibGUgTG9uZyBtb2RlLiAqLw0KPj4NCj4+IGJh
c2UtY29tbWl0OiBiN2RjY2FjNzg2MDcxYmJhOThiMGQ4MzRjNTE3ZmQ0NGEyMmM1MGY5DQo+
PiBwcmVyZXF1aXNpdGUtcGF0Y2gtaWQ6IDU5MGZhN2U5NmM2YmI4ZTBiOWQxNTAxN2NmYTVj
ZTFlYjMxNDk1N2ENCj4+IC0tIA0KPj4gMi4zMS4xDQo+Pg0KPj4NCg0K
--------------z8FoFp1Kx6hLnTOula8pTlkv
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------z8FoFp1Kx6hLnTOula8pTlkv--

--------------cpNzhBrcuTPLokogMcDomDeY--

--------------OSdmLCKJYpfSNxq0Wx4JLpwK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmlvM1sFAwAAAAAACgkQsN6d1ii/Ey8F
ZggAjfK1eJLe5u9/O9EA3z93OQQw5lN40pfpxszFlL4tFvgwSpqAZMon0+JqESjUioOIzTx5hKsg
840jb4pL4c7OEjZp7sgECXKEdBvnliJXZKiCvCYsRACZySc4n6gtODy6lQnpyiOsjkWti4tGB+K0
Mstqy95yt8nb//S4uBDGZAw+1/PeBL5TEUONg237MpwyaP+MHkCABQ1cQo1rOTCytgDOnVpaP4o9
Gu010J9UH6mJ4NCogIYDv3zsmFhaB15RUSWG+PhcXSD2U2shk3bMvLI5Kzb4sA6p5NJ8V5YNj5pg
YMYfQqgxiELIVYfZl3gXPOZoh7DWbcrrvesHRZHWHg==
=k6ZX
-----END PGP SIGNATURE-----

--------------OSdmLCKJYpfSNxq0Wx4JLpwK--

