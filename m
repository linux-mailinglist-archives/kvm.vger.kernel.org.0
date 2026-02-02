Return-Path: <kvm+bounces-69835-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YFj4Nct9gGnE8wIAu9opvQ
	(envelope-from <kvm+bounces-69835-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:34:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 353DACB0B0
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67826305F3E1
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 10:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830572D781F;
	Mon,  2 Feb 2026 10:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fc+gT21m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E05286415
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 10:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770028044; cv=none; b=Ft9NB8LDJ1m07J4CkXgE01TTA7XsjROc+uv877hj9UN1ytR7XUckc8oVHaOkfTVblkJP88xSeemSd+CQtPJynh+0uBnnA7ahYKDJI1nFvLmjNoDHqrqNbVLzh5rnK3f8A2zdZYzFDzXyTam98Yvgr5ud7V3TEdIJ4bqyssNeL2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770028044; c=relaxed/simple;
	bh=l+3o+MHKL82BTRKdVCIUQ3bcYUyRbNh1DNTmf0Cc978=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMSUus6mB8EJ9ud3iFmosm4nLybCkYzDEEUFvpb64aol+ErAu35AcN500WS7nlohyMQXkrD0QZaZHTGd1zuFNXIT+mYuQ/CVPQxh6pEL33+5/rbgDCs+SP8D3omL/nsjR08bcESNAH6RN9ZuaEglOcvJwCt0JpUpHG7xbVjWLFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fc+gT21m; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8710c9cddbso524202066b.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 02:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770028041; x=1770632841; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l+3o+MHKL82BTRKdVCIUQ3bcYUyRbNh1DNTmf0Cc978=;
        b=Fc+gT21mVznTk2tolfmxT2eK3lW6gjHtP5t+Y1zBjZFWkgZzzlOesI8xPA9SlUiR3L
         WHpLTtcYoYNUh0VZ15CLxglwbgbMjZdGHWNoUGx7aRne+ZAIUDoF7hCdXwewS9QQvyjS
         w78puVlMIuJPh+Z4Ti2IkreBJZFCFU9bRrhehlVt8J64E6dArw8FJe0citFEcBTugLpa
         1XHRIeOb1Gj6Ca74Hj0ehRu3CAIE0DzXahUTK2CGkCAFGVWJban6f8lwDdM30QeshafW
         OQI6+3r6j/AlNN1mnUCzA9YaWsR+fjyCSaxq83xgKOGN0+wTKDOE8VZoooVoWUmu3g/q
         RWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770028041; x=1770632841;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+3o+MHKL82BTRKdVCIUQ3bcYUyRbNh1DNTmf0Cc978=;
        b=uOYKHYJb/QCKpAYrrjDyGxC4I2udw0GpYctT6nU85lZD4g7ibiWo/t1Vyitagxy8os
         TOuKHq1U2Luux7vQjedV6+K/DHyuKCPmxhePLoRgCZjok09k2auDY8QnJMK8d10l8ZuM
         4ObHBTYYo0gu+bBwClMHapWIFfiyLHlwRcx0IXq/13NuN9hqFhJgVs/bvul2VOfkCozy
         M787cPVd8N2wge5L13bBOwOoT2u8JU6Je2lUb4Nc7zed1EOB8rJ2iQ7t7McNBVdCfTJq
         k+J2M/9cVwksOdSSYdQ2JvKsPqQA7HkmEfmtoAo355pyRt6UFBHjTTZjCqBPFrXq207f
         BNcQ==
X-Forwarded-Encrypted: i=1; AJvYcCV43V+aXpE8Y8+vqOhUxQTLvabKRrP43tPlUarHFizm6WbJ5I0ByKj1FzDikp9N/WwCrKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAy0CfTRzI+/2wHM2UJkkJCDcethhj+oEagaMjT/TW8lLlqQjq
	ipMFnOkgNZ1XYNPy13whKHk3BTdBwvLZvkSm4SBXkF/DyBUlmhc1oZjIjt0/CXZnNOc=
X-Gm-Gg: AZuq6aJ401F+rBTFQ9XCgemypzcAxroSFAt/8UuDK4YBxOC8Ocq2nmLzsOpsBvIX4UR
	5SGD4XO/f96EpRxZhVlcHHVJf9/h4wtS8T8K1RdETCxfvPFtjUi8o/AegZ/rwQVvSJyfT1INX2Y
	kjbbD9urwOy7JF3V+2ii8hlNoV2VBh48uUl+No1EqJVJZfsDXO7nxXwWLdFWoMbecEafWSG1evF
	wdOxCnO/gW5biV6av7Go5ZAQnMPa5+qeb6uQdfiemXeG0DNdfHmJC7Atv1mJAf373CEZNFHkwsX
	5oVqcfiRz3xyl89BgM9sGTvhhVhO5XE/RAa6Z6cZlrjEZFoVonTkb5a652F277T9hIGsJy/TVzG
	tibHc1rNg0j8abIcTVlmIRG++BrYFzs/mb+lXvsUYeECBpZ8A4Ua6fIR8/vpXkCjZfD+WZ/P2a6
	NY0+8Wt/moSdvEudVDAR+zJirADo+vI70TRH1GuffE1OIhgkGKuZz5T1WWLvws2GfuIm4ORdx00
	KNfOfKN1v+F4MGsYjWoSU3H1mvO+c+/RDHFGQ==
X-Received: by 2002:a17:906:d54e:b0:b87:6af7:c186 with SMTP id a640c23a62f3a-b8dff8674d3mr755283566b.54.1770028041362;
        Mon, 02 Feb 2026 02:27:21 -0800 (PST)
Received: from ?IPV6:2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1? (2a00-12d0-af5b-2f01-4042-c03-ce4d-a5a1.ip.tng.de. [2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8de3d734aesm688456966b.7.2026.02.02.02.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 02:27:21 -0800 (PST)
Message-ID: <0afb8dc5-6ab9-4f61-af3a-8424835386e4@suse.com>
Date: Mon, 2 Feb 2026 11:27:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] x86: Cleanups around slow_down_io()
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-block@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Denis Efremov <efremov@linux.com>,
 Jens Axboe <axboe@kernel.dk>
References: <20260119182632.596369-1-jgross@suse.com>
Content-Language: en-US
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
In-Reply-To: <20260119182632.596369-1-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------EFFtuyAw2mxdAKPsAqPioBPH"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-3.06 / 15.00];
	SIGNED_PGP(-2.00)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_FROM(0.00)[bounces-69835-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	FORGED_SENDER_MAILLIST(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[jgross@suse.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:mid,suse.com:dkim]
X-Rspamd-Queue-Id: 353DACB0B0
X-Rspamd-Action: no action

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------EFFtuyAw2mxdAKPsAqPioBPH
Content-Type: multipart/mixed; boundary="------------DPiBTuW4WhK0KFF1cKCxJjmg";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-block@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Denis Efremov <efremov@linux.com>,
 Jens Axboe <axboe@kernel.dk>
Message-ID: <0afb8dc5-6ab9-4f61-af3a-8424835386e4@suse.com>
Subject: Re: [PATCH v4 0/6] x86: Cleanups around slow_down_io()
References: <20260119182632.596369-1-jgross@suse.com>
In-Reply-To: <20260119182632.596369-1-jgross@suse.com>

--------------DPiBTuW4WhK0KFF1cKCxJjmg
Content-Type: multipart/mixed; boundary="------------liiRpZ2LGHl5C0gioM2bJdPR"

--------------liiRpZ2LGHl5C0gioM2bJdPR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UGluZz8NCg0KT24gMTkuMDEuMjYgMTk6MjYsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+IFdo
aWxlIGxvb2tpbmcgYXQgcGFyYXZpcnQgY2xlYW51cHMgSSBzdHVtYmxlZCBvdmVyIHNsb3df
ZG93bl9pbygpIGFuZA0KPiB0aGUgcmVsYXRlZCBSRUFMTFlfU0xPV19JTyBkZWZpbmUuDQo+
IA0KPiBEbyBzZXZlcmFsIGNsZWFudXBzLCByZXN1bHRpbmcgaW4gYSBkZWxldGlvbiBvZiBS
RUFMTFlfU0xPV19JTyBhbmQgdGhlDQo+IGlvX2RlbGF5KCkgcGFyYXZpcnQgZnVuY3Rpb24g
aG9vay4NCj4gDQo+IFBhdGNoIDQgaXMgcmVtb3ZpbmcgdGhlIGNvbmZpZyBvcHRpb25zIGZv
ciBzZWxlY3RpbmcgdGhlIGRlZmF1bHQgZGVsYXkNCj4gbWVjaGFuaXNtIGFuZCBzZXRzIHRo
ZSBkZWZhdWx0IHRvICJubyBkZWxheSIuIFRoaXMgaXMgaW4gcHJlcGFyYXRpb24gb2YNCj4g
cmVtb3ZpbmcgdGhlIGlvX2RlbGF5KCkgZnVuY3Rpb25hbGl0eSBjb21wbGV0ZWx5LCBhcyBz
dWdnZXN0ZWQgYnkgSW5nbw0KPiBNb2xuYXIuDQo+IA0KPiBQYXRjaCA1IGlzIGFkZGluZyBh
biBhZGRpdGlvbmFsIGNvbmZpZyBvcHRpb24gYWxsb3dpbmcgdG8gYXZvaWQNCj4gYnVpbGRp
bmcgaW9fZGVsYXkuYyAoZGVmYXVsdCBpcyBzdGlsbCB0byBidWlsZCBpdCkuDQo+IA0KPiBD
aGFuZ2VzIGluIFYyOg0KPiAtIHBhdGNoZXMgMiBhbmQgMyBvZiBWMSBoYXZlIGJlZW4gYXBw
bGllZA0KPiAtIG5ldyBwYXRjaGVzIDQgYW5kIDUNCj4gDQo+IENoYW5nZXMgaW4gVjM6DQo+
IC0gcmViYXNlIHRvIHRpcC9tYXN0ZXIga2VybmVsIGJyYW5jaA0KPiANCj4gQ2hhbmdlcyBp
biBWNDoNCj4gLSBhZGQgcGF0Y2ggMSBhcyBwcmVyZXEgcGF0Y2ggdG8gdGhlIHNlcmllcw0K
PiANCj4gSnVlcmdlbiBHcm9zcyAoNik6DQo+ICAgIHg4Ni9pcnFmbGFnczogRml4IGJ1aWxk
IGZhaWx1cmUNCj4gICAgeDg2L3BhcmF2aXJ0OiBSZXBsYWNlIGlvX2RlbGF5KCkgaG9vayB3
aXRoIGEgYm9vbA0KPiAgICBibG9jay9mbG9wcHk6IERvbid0IHVzZSBSRUFMTFlfU0xPV19J
TyBmb3IgZGVsYXlzDQo+ICAgIHg4Ni9pbzogUmVtb3ZlIFJFQUxMWV9TTE9XX0lPIGhhbmRs
aW5nDQo+ICAgIHg4Ni9pb19kZWxheTogU3dpdGNoIGlvX2RlbGF5KCkgZGVmYXVsdCBtZWNo
YW5pc20gdG8gIm5vbmUiDQo+ICAgIHg4Ni9pb19kZWxheTogQWRkIGNvbmZpZyBvcHRpb24g
Zm9yIGNvbnRyb2xsaW5nIGJ1aWxkIG9mIGlvX2RlbGF5Lg0KPiANCj4gICBhcmNoL3g4Ni9L
Y29uZmlnICAgICAgICAgICAgICAgICAgICAgIHwgIDggKysrDQo+ICAgYXJjaC94ODYvS2Nv
bmZpZy5kZWJ1ZyAgICAgICAgICAgICAgICB8IDMwIC0tLS0tLS0tLS0NCj4gICBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9mbG9wcHkuaCAgICAgICAgIHwgMzEgKysrKysrKystLQ0KPiAgIGFy
Y2gveDg2L2luY2x1ZGUvYXNtL2lvLmggICAgICAgICAgICAgfCAxOSArKysrLS0tDQo+ICAg
YXJjaC94ODYvaW5jbHVkZS9hc20vaXJxZmxhZ3MuaCAgICAgICB8ICA2ICstDQo+ICAgYXJj
aC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQtYmFzZS5oICB8ICA2ICsrDQo+ICAgYXJjaC94
ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaCAgICAgICB8IDExIC0tLS0NCj4gICBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5oIHwgIDIgLQ0KPiAgIGFyY2gveDg2L2tl
cm5lbC9NYWtlZmlsZSAgICAgICAgICAgICAgfCAgMyArLQ0KPiAgIGFyY2gveDg2L2tlcm5l
bC9jcHUvdm13YXJlLmMgICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9p
b19kZWxheS5jICAgICAgICAgICAgfCA4MSArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Cj4gICBhcmNoL3g4Ni9rZXJuZWwva3ZtLmMgICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+
ICAgYXJjaC94ODYva2VybmVsL3BhcmF2aXJ0LmMgICAgICAgICAgICB8ICAzICstDQo+ICAg
YXJjaC94ODYva2VybmVsL3NldHVwLmMgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJj
aC94ODYveGVuL2VubGlnaHRlbl9wdi5jICAgICAgICAgICB8ICA2ICstDQo+ICAgZHJpdmVy
cy9ibG9jay9mbG9wcHkuYyAgICAgICAgICAgICAgICB8ICAyIC0NCj4gICAxNiBmaWxlcyBj
aGFuZ2VkLCA2MyBpbnNlcnRpb25zKCspLCAxNTkgZGVsZXRpb25zKC0pDQo+IA0KDQo=
--------------liiRpZ2LGHl5C0gioM2bJdPR
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------liiRpZ2LGHl5C0gioM2bJdPR--

--------------DPiBTuW4WhK0KFF1cKCxJjmg--

--------------EFFtuyAw2mxdAKPsAqPioBPH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmmAfAgFAwAAAAAACgkQsN6d1ii/Ey/2
zAf+IkVIvbIONVNOIsFijpcb0ksuCVfDZvIq2cPAb9rfEt4SV/Fv87G1BkwNCtKbrpMKsTjK2E8V
YxPglU6me8lcaWM/t2j74OrYLM0B0yfhTzS6I5AbtpGIMsQxiITsr//ZP64nl5N5/YvNKpLhvAkG
rqdkNYFQh4GB5FgSl079/ebN9POZERI4nOBDWTiJ69297xhtHXPambNil4kLLpNyi+I0vETf6+05
0pPWs7hQsNqqHWfyCdehYqc+H8ZZkY2Jg0uanT5Qv1kWieoCWahhlRcpKyz9tMoIofilTuPuAkGu
XnCl3azsTfUBNhgwDBPjw50R1tSidPTjMLavCd43jA==
=T21t
-----END PGP SIGNATURE-----

--------------EFFtuyAw2mxdAKPsAqPioBPH--

