Return-Path: <kvm+bounces-70587-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILUBOOukiWlU/wQAu9opvQ
	(envelope-from <kvm+bounces-70587-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 10:12:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8E610D650
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 10:12:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 965B4301875C
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 09:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E809344059;
	Mon,  9 Feb 2026 09:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YLbDW51u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0173446AD
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 09:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770628312; cv=none; b=ovKJAzrglva1k05HiXHQ+znEhUIFCBsYLx/4SRdHUauP9024exmDcdCM2TIe+R2AMsyYR6un3yi7FmVIdk2STy/O4OjSb1WMjFJ1QPGmUWuWNyIIbeCKMKBxP3kXp3+4GhNje7/HvLCG6HmUtXgEIM215FrMKq9x2otRRWGcpoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770628312; c=relaxed/simple;
	bh=6Rf0FYjkPu0tVX2FfB/cW3xLBvBaQoo5kGcbjmkcKgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5sqcremq2En2Vkwu4n7m8PKxvooIZafJ/wemjhoqRqGBO9buUCxUe3jrK1s8121MXuo/5D9OlmuFauhPlBewXcdqDBnzwLU0L9o3I3/7JkR2q0jcDrfozciMrx+ABfUKMP4+7VI530hoqGyPxXZscX2te+LLbigFEYvmQggC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YLbDW51u; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b9cb94ff5so5350201a12.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 01:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770628310; x=1771233110; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6Rf0FYjkPu0tVX2FfB/cW3xLBvBaQoo5kGcbjmkcKgM=;
        b=YLbDW51u3mZkh8fKm0n4RG0SFMCARezL6zz8M/LcVlzPepI8fPR6dQpV9+uCPxSOuA
         0P5HLOC35QUf+M64xPz1S2dkbzzxSDGdS8A0YZbDDPsgHubFNtd33Z74/3/eSu6RVQLq
         a/JkiO32gn+OzausMmeDRl9JWCcE1HgvU54QS5oONDaCRjxbT+YkPa6sS3VLQxKdZky/
         xkeaVZUQKXqT3+NhXySbRtLE2s6hp2IRDYpo8+U+SDwufePQvw1k7pt4gG3LQgqNgDwj
         gs81InYdErdBviT8Hm5MSBMi/EcQS6WDjj8UjrUJcErhTiWzVO1N7fMA7h507WuY7vXL
         xYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770628310; x=1771233110;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Rf0FYjkPu0tVX2FfB/cW3xLBvBaQoo5kGcbjmkcKgM=;
        b=J0dCS/jlhFz/KHVMrKR63PT/dlZns3x2ss8gB4UqrSv0d9jLC4QoScsL0tpaAeUnQt
         Rb1t619nIWj6u8hrKqFGbNVNSLz8HCF9yT+c6qxAkZ/yy7W+jbXW6PnW+uO6oVWPHoJ3
         if13NVk6BRxKh4H27ziY36CpO9qttoIVmS7RvpZsKModkp3RudIMv53iVIcnjEIOjHw7
         8z6xLho8jBQPlmLLUdE1FzEqLyAn25SnK66Ur7nPK1EOsu9CsoF+taFj1MoofW5YgBfp
         E6jnnlMV7amFfAisaOLFVjo7X/dUiTGGydOIEawo8hTpnUSfnf4WW+paN1N3LSPdcZS5
         hc/g==
X-Forwarded-Encrypted: i=1; AJvYcCUvfeqiS35OLJ/Y28FAzJYvY8NxzXfkMI6sQTFIUStjRh7pyjsuf99ZkqXFE6PI1m2rlz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxneQXgomd9kBeF/2Ht9QOHFrgHaioJovdndODnXk2ntNxlH+No
	LPSzBWyIHm7TWNpNG7RKpTJTHgtTuPnICZmcrD1fVtoBTHkxzBV4wulbxa4CmqdWNaw=
X-Gm-Gg: AZuq6aKlfvJ7e0zfIpEFtDeITPz7Tzq1o3o/CdwXPglXSC8kABD3nIE9UiaqvCnO2EG
	io9aC2w66Z0/KYXZGQVuLtS0r0VR1wlRMuMD6xR5P4RXtE5TZa9wyZps1goYN/d2KKK5a1r5A/i
	pyHHB1LKfVcca1bxyIC2egW/wjS156blEVlcZwqvteO9K/RMgKgaIgSorz6zUx1ptJ2uAfC0ZXv
	VTj3CxrdKElMjk1Qu6wQWw5MufapAjM1ZXP/u4AFYOriRlcUNIo0ySKD2LWfx2wFlWnnJkqcvyL
	VErWQ7zzPWvw2YGIdzNJVVdhuN0rHpx6r6hcbAxPyOcwnhzgH0QeUkaT698LhzxU1ZBNWGwOn7Z
	E7NaaIo/C251x+8ojKZ8UmEKhxOLWUBBEQzfyo2DJTGo/zdtEcwUXs3HDyYCyWWnKFEymUqHW6A
	CVEfmiz0AmPPuRRShUAHC2V6vVGssNL3TOmEhK0rA24XczhYXcs1waaq2eJs9JLos04fMamgrNW
	yMKBiVeCQdgiYdPqqY7MFZeu8gC8T3v2sTltg==
X-Received: by 2002:a05:6402:518f:b0:658:bd60:43e2 with SMTP id 4fb4d7f45d1cf-659841692cdmr5396289a12.17.1770628310369;
        Mon, 09 Feb 2026 01:11:50 -0800 (PST)
Received: from ?IPV6:2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1? (2a00-12d0-af5b-2f01-4042-c03-ce4d-a5a1.ip.tng.de. [2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-659840238fdsm2659958a12.30.2026.02.09.01.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 01:11:49 -0800 (PST)
Message-ID: <6ee93510-1f43-4cd2-952e-8ed3ce7ba0e5@suse.com>
Date: Mon, 9 Feb 2026 10:11:49 +0100
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
 boundary="------------CRkOi8Dd1YqtQXNyzdN5KBGQ"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-3.06 / 15.00];
	SIGNED_PGP(-2.00)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70587-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[jgross@suse.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 5C8E610D650
X-Rspamd-Action: no action

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------CRkOi8Dd1YqtQXNyzdN5KBGQ
Content-Type: multipart/mixed; boundary="------------34IehBIppGcxVnrgQ2weG0lj";
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
Message-ID: <6ee93510-1f43-4cd2-952e-8ed3ce7ba0e5@suse.com>
Subject: Re: [PATCH v4 0/6] x86: Cleanups around slow_down_io()
References: <20260119182632.596369-1-jgross@suse.com>
In-Reply-To: <20260119182632.596369-1-jgross@suse.com>

--------------34IehBIppGcxVnrgQ2weG0lj
Content-Type: multipart/mixed; boundary="------------gSU4Siyeh4zHWGT3RiPM5v62"

--------------gSU4Siyeh4zHWGT3RiPM5v62
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UElORz8NCg0KTm93IDMgd2Vla3Mgd2l0aG91dCBhbnkgcmVhY3Rpb24uLi4NCg0KT24gMTku
MDEuMjYgMTk6MjYsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+IFdoaWxlIGxvb2tpbmcgYXQg
cGFyYXZpcnQgY2xlYW51cHMgSSBzdHVtYmxlZCBvdmVyIHNsb3dfZG93bl9pbygpIGFuZA0K
PiB0aGUgcmVsYXRlZCBSRUFMTFlfU0xPV19JTyBkZWZpbmUuDQo+IA0KPiBEbyBzZXZlcmFs
IGNsZWFudXBzLCByZXN1bHRpbmcgaW4gYSBkZWxldGlvbiBvZiBSRUFMTFlfU0xPV19JTyBh
bmQgdGhlDQo+IGlvX2RlbGF5KCkgcGFyYXZpcnQgZnVuY3Rpb24gaG9vay4NCj4gDQo+IFBh
dGNoIDQgaXMgcmVtb3ZpbmcgdGhlIGNvbmZpZyBvcHRpb25zIGZvciBzZWxlY3RpbmcgdGhl
IGRlZmF1bHQgZGVsYXkNCj4gbWVjaGFuaXNtIGFuZCBzZXRzIHRoZSBkZWZhdWx0IHRvICJu
byBkZWxheSIuIFRoaXMgaXMgaW4gcHJlcGFyYXRpb24gb2YNCj4gcmVtb3ZpbmcgdGhlIGlv
X2RlbGF5KCkgZnVuY3Rpb25hbGl0eSBjb21wbGV0ZWx5LCBhcyBzdWdnZXN0ZWQgYnkgSW5n
bw0KPiBNb2xuYXIuDQo+IA0KPiBQYXRjaCA1IGlzIGFkZGluZyBhbiBhZGRpdGlvbmFsIGNv
bmZpZyBvcHRpb24gYWxsb3dpbmcgdG8gYXZvaWQNCj4gYnVpbGRpbmcgaW9fZGVsYXkuYyAo
ZGVmYXVsdCBpcyBzdGlsbCB0byBidWlsZCBpdCkuDQo+IA0KPiBDaGFuZ2VzIGluIFYyOg0K
PiAtIHBhdGNoZXMgMiBhbmQgMyBvZiBWMSBoYXZlIGJlZW4gYXBwbGllZA0KPiAtIG5ldyBw
YXRjaGVzIDQgYW5kIDUNCj4gDQo+IENoYW5nZXMgaW4gVjM6DQo+IC0gcmViYXNlIHRvIHRp
cC9tYXN0ZXIga2VybmVsIGJyYW5jaA0KPiANCj4gQ2hhbmdlcyBpbiBWNDoNCj4gLSBhZGQg
cGF0Y2ggMSBhcyBwcmVyZXEgcGF0Y2ggdG8gdGhlIHNlcmllcw0KPiANCj4gSnVlcmdlbiBH
cm9zcyAoNik6DQo+ICAgIHg4Ni9pcnFmbGFnczogRml4IGJ1aWxkIGZhaWx1cmUNCj4gICAg
eDg2L3BhcmF2aXJ0OiBSZXBsYWNlIGlvX2RlbGF5KCkgaG9vayB3aXRoIGEgYm9vbA0KPiAg
ICBibG9jay9mbG9wcHk6IERvbid0IHVzZSBSRUFMTFlfU0xPV19JTyBmb3IgZGVsYXlzDQo+
ICAgIHg4Ni9pbzogUmVtb3ZlIFJFQUxMWV9TTE9XX0lPIGhhbmRsaW5nDQo+ICAgIHg4Ni9p
b19kZWxheTogU3dpdGNoIGlvX2RlbGF5KCkgZGVmYXVsdCBtZWNoYW5pc20gdG8gIm5vbmUi
DQo+ICAgIHg4Ni9pb19kZWxheTogQWRkIGNvbmZpZyBvcHRpb24gZm9yIGNvbnRyb2xsaW5n
IGJ1aWxkIG9mIGlvX2RlbGF5Lg0KPiANCj4gICBhcmNoL3g4Ni9LY29uZmlnICAgICAgICAg
ICAgICAgICAgICAgIHwgIDggKysrDQo+ICAgYXJjaC94ODYvS2NvbmZpZy5kZWJ1ZyAgICAg
ICAgICAgICAgICB8IDMwIC0tLS0tLS0tLS0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9m
bG9wcHkuaCAgICAgICAgIHwgMzEgKysrKysrKystLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUv
YXNtL2lvLmggICAgICAgICAgICAgfCAxOSArKysrLS0tDQo+ICAgYXJjaC94ODYvaW5jbHVk
ZS9hc20vaXJxZmxhZ3MuaCAgICAgICB8ICA2ICstDQo+ICAgYXJjaC94ODYvaW5jbHVkZS9h
c20vcGFyYXZpcnQtYmFzZS5oICB8ICA2ICsrDQo+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20v
cGFyYXZpcnQuaCAgICAgICB8IDExIC0tLS0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9w
YXJhdmlydF90eXBlcy5oIHwgIDIgLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9NYWtlZmlsZSAg
ICAgICAgICAgICAgfCAgMyArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmMg
ICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9pb19kZWxheS5jICAgICAg
ICAgICAgfCA4MSArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gICBhcmNoL3g4Ni9r
ZXJuZWwva3ZtLmMgICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAgYXJjaC94ODYva2Vy
bmVsL3BhcmF2aXJ0LmMgICAgICAgICAgICB8ICAzICstDQo+ICAgYXJjaC94ODYva2VybmVs
L3NldHVwLmMgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJjaC94ODYveGVuL2VubGln
aHRlbl9wdi5jICAgICAgICAgICB8ICA2ICstDQo+ICAgZHJpdmVycy9ibG9jay9mbG9wcHku
YyAgICAgICAgICAgICAgICB8ICAyIC0NCj4gICAxNiBmaWxlcyBjaGFuZ2VkLCA2MyBpbnNl
cnRpb25zKCspLCAxNTkgZGVsZXRpb25zKC0pDQo+IA0KDQo=
--------------gSU4Siyeh4zHWGT3RiPM5v62
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------gSU4Siyeh4zHWGT3RiPM5v62--

--------------34IehBIppGcxVnrgQ2weG0lj--

--------------CRkOi8Dd1YqtQXNyzdN5KBGQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmmJpNUFAwAAAAAACgkQsN6d1ii/Ey8j
qQf7Bg+qPPnREAQQ4FK1hd4m2YZs0u9VS/xDnH/zOwWH5hkNgmRIQMvwV3d4YvP1jkhVXNcGzqyt
mS6tcQVuRNpSrvWmzT1N58G6PZ7MCb003jylOa177f0zVFFrYtaAV03j7X8jlfpca3vMfjFAh4mF
1bqFtbbiqiWbqV4p8R4XEmEUPICcGinAPRNF/NH90Q6huR90gRaBk+KxOM0P3xIU5lxOfX9IO1yn
TnSXXFc0fycQ1QYdfQ9m2IaA+RqdvwOYzCdlS0pNV6ma79NEVpt57FqCmxQn3yUUd4xiH1ZXUGiX
qYWqHU467Y5uoUe0Cx/CwEoazfjVpOvElk0GH00bHA==
=520A
-----END PGP SIGNATURE-----

--------------CRkOi8Dd1YqtQXNyzdN5KBGQ--

