Return-Path: <kvm+bounces-44285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8B5A9C472
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 11:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 615621BC1113
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9072356BA;
	Fri, 25 Apr 2025 09:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cLlY3RsX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7DF239090
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745574920; cv=none; b=SM0KQ4AU4PgUmtagZUbWcOBuihC6d/8K3mG4b5nFXbmCw6CeoF5+DnVW+w4cmmcmVaYm1L7Bf20ZZhAuDhzr74LZg0E0WL1DJoL3J/tdDp5QbwtxH450BSaVInLYQRiMyvmdc0zdVd7S60d2AfGKTv1bcBV9O22HDVLZtMgBObo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745574920; c=relaxed/simple;
	bh=NcWE1bJYcLRfud/TYBaEGj5sNWQY2z4fAnt1IKr2YXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZINXdU0cXj7y8MpCVSPIFWCgmSCwGJ3Yn3lcgYEcN4M3TQp6Sqzag+ejUDoeVzTJnZvio0JiC/T9UhRbn2wYZmkrf5QrbUgJxEV8/+MCxYFTp1XnDZiUsV2/DU6Ee1FS5wYDMW/YJbDJo/cPTkPjfAR9jA5AlQvZZGRLiaSAWQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cLlY3RsX; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso16570175e9.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 02:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745574916; x=1746179716; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NcWE1bJYcLRfud/TYBaEGj5sNWQY2z4fAnt1IKr2YXk=;
        b=cLlY3RsXlPeTvasPGFhVLZYUZYUji3IZ2EkeMmoArEbr/EXXNHvR/jmIou23N80taf
         wc7o8mmGWi7+ZSMi+pc9Ne2wWnHOtS76g0psoOVjZj7qFQ3gDOU13HoAXTgtZlt1hcLb
         ppxslYGeVQsNNXazU0pghIHu8WC0uuBGRKNpv2gzgJ9hHJKHxOA5mBafN/tgfNKoNuus
         QliAVyVp+VOvmCHtvrNryovV5+kcCcipBgFv0VYmaj1zqRUCvlia4kYxqyqL+mcwOvYp
         i4R8FamD4//qqXn/5eou0oiWzxJq6b+vBULY1hOSbZcMU1m3MEDKN9LgmS9KfQvEpJR0
         0Pfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745574916; x=1746179716;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NcWE1bJYcLRfud/TYBaEGj5sNWQY2z4fAnt1IKr2YXk=;
        b=eBJ1HnHHiqzJdlklQ49Bz/CwX7WQMqCTuLg5XOClYfeZOO4yosVkw0iVFRMjEQfftY
         IwcKpk5kWfNRYYYX39ExLu4rXpTFNMPY77c7iRxU6pm78owdbAT0wIKiUyLl0nTsRiW2
         4ujf25hOhNZrtMTfjus6OFW3Q7R72S3jm+oW+8SRABOMp1WEWywUqAwFELblvZ/Qp6YM
         EHTOJp3qWoPFxt1NSegLiJLzGNdD1IjxRD2lWtssdpIqMJFhTCWNbAxYs8x74Fsq//Ix
         kQB0yD/55AYvhpzIlByjolapJFWAFlpGwINiT0ZAIRrmlmwe0eTl9SFaoBvCiCo1eCEU
         l71g==
X-Forwarded-Encrypted: i=1; AJvYcCXadz+ICgenhB5wf7hMs6JEuv/hVydVT6GTGQ6+E+5rYILGgltEQX3mkIFU3A09jOiRU0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8nz3f5j6lXFGC4ccRxYxTo7RIt6jjZhj5cwDpTnXOT55M27aY
	gKP8R+rFKMIqXn5GkNdPhlQ5BMCdbBMmogEm+87HRmnR/N0XXrvphDQHRedfeos=
X-Gm-Gg: ASbGnctWdYkwx/Q6tiQvqUHmE+RJBEZCda4iINr+ur78H9RZ2APBZRXhKQsV8+dNioo
	tSjDoBdNZhpZXW14Wc2EineuQSY40dhfxaA6SlPhgiFoikgehiEuOVNCQtkx6aadgw/soQ4iNHn
	d5k2qYMrcCYgVbF5HotvXJJeeAKcAM+JMDb3yeWGM1Skle+I4Z8Y9IzWUnW6EcSDSKrq1B3174i
	CpZk2ynm5Yl5ujJcTF4AM4/asGvuzg+yuGr61d+3Qh77GQ1Keta0osvMFkbyMUdouohZjctumNS
	qa6uDaLyMo+V8O64cozm+z5RPe/iSWx1Zqp3Lm28AwiKw/WlP8jqOkQn5eSmHgAvnOLjnCKFkTs
	3CjDijDGPEJx1E7/fsf/u2c4xsRQk77D7n8ioEJEYKOJZwzUWsW3r2JCT+GGAAaeWSA==
X-Google-Smtp-Source: AGHT+IHtx1TOSgXcL+wm9ZIPfyr+4YgzzXRNPlhTDP9N/InsP2TFGU+fY9WmjuTgX4ibBWR0TYzRDw==
X-Received: by 2002:a05:600c:3491:b0:43b:ce3c:19d0 with SMTP id 5b1f17b1804b1-440a66b6fb1mr13860625e9.29.1745574915455;
        Fri, 25 Apr 2025 02:55:15 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a52f89b2sm19712325e9.8.2025.04.25.02.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 02:55:15 -0700 (PDT)
Message-ID: <524349a7-55da-42a2-b9cc-ec0d2ce66ae4@suse.com>
Date: Fri, 25 Apr 2025 11:55:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/14] x86/xen/msr: Remove calling
 native_{read,write}_msr{,_safe}() in pmu_msr_{read,write}()
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com, dapeng1.mi@linux.intel.com
References: <20250425083442.2390017-1-xin@zytor.com>
 <20250425083442.2390017-10-xin@zytor.com>
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
In-Reply-To: <20250425083442.2390017-10-xin@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------umyLmQJXz7NbwmBml0jM4Ng1"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------umyLmQJXz7NbwmBml0jM4Ng1
Content-Type: multipart/mixed; boundary="------------ILcDmpjOr8sgvBFsIPNfJu0U";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com, dapeng1.mi@linux.intel.com
Message-ID: <524349a7-55da-42a2-b9cc-ec0d2ce66ae4@suse.com>
Subject: Re: [PATCH v3 09/14] x86/xen/msr: Remove calling
 native_{read,write}_msr{,_safe}() in pmu_msr_{read,write}()
References: <20250425083442.2390017-1-xin@zytor.com>
 <20250425083442.2390017-10-xin@zytor.com>
In-Reply-To: <20250425083442.2390017-10-xin@zytor.com>

--------------ILcDmpjOr8sgvBFsIPNfJu0U
Content-Type: multipart/mixed; boundary="------------KIfLsXjXNDGJVTPgM3MpoiKp"

--------------KIfLsXjXNDGJVTPgM3MpoiKp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDQuMjUgMTA6MzQsIFhpbiBMaSAoSW50ZWwpIHdyb3RlOg0KPiBocGEgZm91bmQg
dGhhdCBwbXVfbXNyX3dyaXRlKCkgaXMgYWN0dWFsbHkgYSBjb21wbGV0ZWx5IHBvaW50bGVz
cw0KPiBmdW5jdGlvbiBbMV06IGFsbCBpdCBkb2VzIGlzIHNodWZmbGUgc29tZSBhcmd1bWVu
dHMsIHRoZW4gY2FsbHMNCj4gcG11X21zcl9jaGtfZW11bGF0ZWQoKSBhbmQgaWYgaXQgcmV0
dXJucyB0cnVlIEFORCB0aGUgZW11bGF0ZWQgZmxhZw0KPiBpcyBjbGVhciB0aGVuIGRvZXMg
KmV4YWN0bHkgdGhlIHNhbWUgdGhpbmcqIHRoYXQgdGhlIGNhbGxpbmcgY29kZQ0KPiB3b3Vs
ZCBoYXZlIGRvbmUgaWYgcG11X21zcl93cml0ZSgpIGl0c2VsZiBoYWQgcmV0dXJuZWQgdHJ1
ZS4gIEFuZA0KPiBwbXVfbXNyX3JlYWQoKSBkb2VzIHRoZSBlcXVpdmFsZW50IHN0dXBpZGl0
eS4NCj4gDQo+IFJlbW92ZSB0aGUgY2FsbHMgdG8gbmF0aXZlX3tyZWFkLHdyaXRlfV9tc3J7
LF9zYWZlfSgpIHdpdGhpbg0KPiBwbXVfbXNyX3tyZWFkLHdyaXRlfSgpLiAgSW5zdGVhZCBy
ZXVzZSB0aGUgZXhpc3RpbmcgY2FsbGluZyBjb2RlDQo+IHRoYXQgZGVjaWRlcyB3aGV0aGVy
IHRvIGNhbGwgbmF0aXZlX3tyZWFkLHdyaXRlfV9tc3J7LF9zYWZlfSgpIGJhc2VkDQo+IG9u
IHRoZSByZXR1cm4gdmFsdWUgZnJvbSBwbXVfbXNyX3tyZWFkLHdyaXRlfSgpLiAgQ29uc2Vx
dWVudGx5LA0KPiBlbGltaW5hdGUgdGhlIG5lZWQgdG8gcGFzcyBhbiBlcnJvciBwb2ludGVy
IHRvIHBtdV9tc3Jfe3JlYWQsd3JpdGV9KCkuDQo+IA0KPiBXaGlsZSBhdCBpdCwgcmVmYWN0
b3IgcG11X21zcl93cml0ZSgpIHRvIHRha2UgdGhlIE1TUiB2YWx1ZSBhcyBhIHU2NA0KPiBh
cmd1bWVudCwgcmVwbGFjaW5nIHRoZSBjdXJyZW50IGR1YWwgdTMyIGFyZ3VtZW50cywgYmVj
YXVzZSB0aGUgZHVhbA0KPiB1MzIgYXJndW1lbnRzIHdlcmUgb25seSB1c2VkIHRvIGNhbGwg
bmF0aXZlX3dyaXRlX21zcnssX3NhZmV9KCksIHdoaWNoDQo+IGhhcyBub3cgYmVlbiByZW1v
dmVkLg0KPiANCj4gWzFdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzBlYzQ4Yjg0
LWQxNTgtNDdjNi1iMTRjLTM1NjNmZDE0YmNjNEB6eXRvci5jb20vDQo+IA0KPiBTdWdnZXN0
ZWQtYnk6IEguIFBldGVyIEFudmluIChJbnRlbCkgPGhwYUB6eXRvci5jb20+DQo+IFNpZ24t
b2ZmLWJ5OiBYaW4gTGkgKEludGVsKSA8eGluQHp5dG9yLmNvbT4NCg0KUmV2aWV3ZWQtYnk6
IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCg0KDQpKdWVyZ2VuDQo=
--------------KIfLsXjXNDGJVTPgM3MpoiKp
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------KIfLsXjXNDGJVTPgM3MpoiKp--

--------------ILcDmpjOr8sgvBFsIPNfJu0U--

--------------umyLmQJXz7NbwmBml0jM4Ng1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgLXAEFAwAAAAAACgkQsN6d1ii/Ey88
Cgf+MAp/YWFiSmqylTxTDIt7kHncN7KNk+/Iat64QmjTwZbgOO6Ol0/EWdPH9IKncht38/BsQQbc
Kpm8hyi72Q8JqBJXFbhsZQPFShJWtlgXy8oJ5o96+HR0j/BUlj+kUU3qjrxzFb6wsaLjo8j/guKM
cj9Vi4kIRazqWp0L8GIURgfnQIvtQdY5C1IU6+wR1JzSKlUZKDTXkc+aYaCRheR7pXHyHxMk1zsC
z31EStqcPz83sn9uj3GfIrGzroOELJyGJYGQm+6pJlaQDKSnOQGmdJWd5v0HysMQB2kYSTn/8I8T
Owl3spzB9/MRmcopaSWd/n53lPf8oXlOAiI/Wh2UcA==
=/QzV
-----END PGP SIGNATURE-----

--------------umyLmQJXz7NbwmBml0jM4Ng1--

