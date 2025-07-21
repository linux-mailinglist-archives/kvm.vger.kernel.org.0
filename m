Return-Path: <kvm+bounces-53006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD895B0C821
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D81646C07F8
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11D62E11AB;
	Mon, 21 Jul 2025 15:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="sqLEvvQi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3391C2E091B
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 15:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753113096; cv=none; b=WeMwQ8T7i7KDK3V64VYIfZeAffx+9QgCVPJHP+29wnceCTzVu3ILFBLoKp5uRQF+QCQs7wptE3JpWlg58RQodfcyx1I4cTvPubzaeyL1a3Jzvu3BJmI+0gxwxUUqMaH2M+TPEW7mTGIe227q98qqk+9WSq2wm/yTRzux0cvvd+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753113096; c=relaxed/simple;
	bh=bQZV0S04MJzMxbCWk+hmI4yXsJfzml5ZDo2zQ6hDazY=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=Q7LCc3XZLX9q1XIy7I9YGSF5tKp+z1IqHAJ7grKCY7vgfvTxb02OPwh73PstrZ0Cmdwric/txicwC3FdQHVlme66uttOJqcGioNzWKpZo4/o01sQp6s0KTW66BhuJZWggXTtGbRIYzrF+NYG6lrfRfQ0t/RscOJzJOkHhfbHkI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=sqLEvvQi; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a4f72cba73so3355137f8f.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 08:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753113092; x=1753717892; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KFWL93RyBl7UkGOR9kTMAodWgKd2y0VtlkHf5YIiBp4=;
        b=sqLEvvQia0mUxP09PqzYfzvP3JsyHIT7o2yZNrebl01RgsdHkDtYBmqB9pLDuuyR39
         jcXykUh78w6snvWruav0CBaFSA8vP+DVX988UEdnXxLGyCkVfRaSnKuHZPsiEKLZRLUv
         HhBTBQ7MiA+gjpWXr/CeY1hMwegjJa/hZJCVcRgNIqKkeHPf8+k7NqjAcJsIJHmYon7x
         tsUxHDKqIbStqN/l3aen8jlb9g74FSQNAsIZz+VxsTYiYAX9qs5yj/ctE+vCOyVa/z73
         qcSkpbgcsWHIluFAlO0cNpNGC/BOfTbFalm5jtB2OrGBE13vJMW2w4TLRApaSrBtXkga
         gq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753113092; x=1753717892;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KFWL93RyBl7UkGOR9kTMAodWgKd2y0VtlkHf5YIiBp4=;
        b=JRkn9eu4r03JDBzPLtDtGUzcfupHLjVwhj/jBI2SAGqqhCxlXwT3aB09moh1t1aE8J
         fWxvS8/9Win6pasO3MAh5RvYCJMSOd6aFflFY8mN1BuogCM7PIrAy5I1CUhzybHtihJ+
         xSuN07Qq9ZnVoKjCzjpy9Jexu0bkMu3BWn+dq2GJE/CwxZjKf9k0HEEOWx0RiRkhIg6V
         88dHdEpaGhxZIaaVD5sUJ5HMvlbJQkWsoxwwaQQJdUzFCwO93+pPwHaxntFoSG1XXcQh
         G20BGbF9q4uAPVPlTZC7Tg7R7+sOdRZ21pM9XqBtktWcjLWRdYFPsvkpfi3SiNfjdPhf
         dvpA==
X-Forwarded-Encrypted: i=1; AJvYcCXd/G5FMzlRULuzBP9tks3mCd/NhfLFVdcHqaFLRYgsRRePASvq8VhrP6d7tIDjCi3cxQk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9ceYAUtk3NHxqbIS2PmLf8XKU3LtFjuq78kjvElxHkUlbZJOb
	TGdEv86HjSRwqJAKRlJBPZ66j0mU0Uvsbz6uN5zRu+hegufY5iJlrRnQz2K/AmzYmPM=
X-Gm-Gg: ASbGncsT1wzO/PhysdNivCddNDM3tGUNMxkvzjHm3WnAzGl/AZU1gL6ykquwsS4H/Fp
	RR9uZ3DlHfunfqVajHhIfYGS0wkokj+6+9U7kWJHYgm7sJ7sJn6NDQ510iooql7E5knQIFm97gv
	2HRlwG6gWS4oM0QXJJntIXR1biw4Eexsj29fb8yEuEaUHI0dXQz+PmywV1HFD1UmwoN0bA5LLJ9
	3tWKKnuuYH2MKZbbS/Sxnng79IgWg+iaDb0issajaNVxhSyE0qsSzw91npCgatD6vebFV4o5/D5
	ZBrTkygmPCrEA+vSRCLeQI3y3XY7KH+bqYRCX1EDX5KJZGOpsgF4aWyLYzIP2aHIQEjOFS5fY4N
	PJdIkuL8RLELw5GNuQGdH2x62Gptujis0mIQ6D4wxKsjKIKn8JYkpK4zhTCx74N9sXvi14jwjKp
	ZEEbjEpSD/GkEF//vu00WLZuSVsY5da3Lg1WlXi+sP/h9pZER/tcTdVE8=
X-Google-Smtp-Source: AGHT+IEVWQpmYENTettxXxwuGiCIJu9NooR0/WM1zbqZ6AqYX8TnAgOIo7DY1LzVS5UWGM+Othm1UQ==
X-Received: by 2002:a05:6000:2311:b0:3a5:2b1e:c49b with SMTP id ffacd0b85a97d-3b7634fa6e2mr34516f8f.29.1753113092352;
        Mon, 21 Jul 2025 08:51:32 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2bf82sm10865052f8f.26.2025.07.21.08.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 08:51:31 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------5p0OIsFs8UdPa9j8yIoVSwAu"
Message-ID: <4114d399-8649-41de-97bf-3b63f29ec7e8@grsecurity.net>
Date: Mon, 21 Jul 2025 17:51:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 19/23] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com,
 weijiang.yang@intel.com, xin@zytor.com, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-20-chao.gao@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250704085027.182163-20-chao.gao@intel.com>

This is a multi-part message in MIME format.
--------------5p0OIsFs8UdPa9j8yIoVSwAu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04.07.25 10:49, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Expose CET features to guest if KVM/host can support them, clear CPUID
> feature bits if KVM/host cannot support.
> [...]

Can we please make CR4.CET a guest-owned bit as well (sending a patch in
a second)? It's a logical continuation to making CR0.WP a guest-owned
bit just that it's even easier this time, as no MMU role bits are
involved and it still makes a big difference, at least for grsecurity
guest kernels.

Using the old test from [1] gives the following numbers (perf stat -r 5
ssdd 10 50000):

* grsec guest on linux-6.16-rc5 + cet patches:
  2.4647 +- 0.0706 seconds time elapsed  ( +-  2.86% )

* grsec guest on linux-6.16-rc5 + cet patches + CR4.CET guest-owned:
  1.5648 +- 0.0240 seconds time elapsed  ( +-  1.53% )

Not only is it ~35% faster, it's also more stable, less fluctuation due
to less VMEXITs, I believe.

Thanks,
Mathias

[1]
https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
--------------5p0OIsFs8UdPa9j8yIoVSwAu
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-KVM-VMX-Make-CR4.CET-a-guest-owned-bit.patch"
Content-Disposition: attachment;
 filename="0001-KVM-VMX-Make-CR4.CET-a-guest-owned-bit.patch"
Content-Transfer-Encoding: base64

RnJvbSAxNGVmNWQ4Yjk1Mjc0NGM0NmMzMmYxNmZlYTNiMjkxODRjZGUzZTY1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXRoaWFzIEtyYXVzZSA8bWluaXBsaUBncnNlY3Vy
aXR5Lm5ldD4KRGF0ZTogTW9uLCAyMSBKdWwgMjAyNSAxMzo0NTo1NSArMDIwMApTdWJqZWN0
OiBbUEFUQ0hdIEtWTTogVk1YOiBNYWtlIENSNC5DRVQgYSBndWVzdCBvd25lZCBiaXQKClRo
ZXJlJ3Mgbm8gbmVlZCB0byBpbnRlcmNlcHQgY2hhbmdlcyBvZiBDUjQuQ0VULCBtYWtlIGl0
IGEgZ3Vlc3Qtb3duZWQKYml0IHdoZXJlIHBvc3NpYmxlLgoKVGhpcyBjaGFuZ2UgaXMgVk1Y
LXNwZWNpZmljLCBhcyBTVk0gaGFzIG5vIHN1Y2ggZmluZS1ncmFpbmVkIGNvbnRyb2wKcmVn
aXN0ZXIgaW50ZXJjZXB0IGNvbnRyb2wuCgpTaWduZWQtb2ZmLWJ5OiBNYXRoaWFzIEtyYXVz
ZSA8bWluaXBsaUBncnNlY3VyaXR5Lm5ldD4KLS0tCiBhcmNoL3g4Ni9rdm0va3ZtX2NhY2hl
X3JlZ3MuaCB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2t2bV9jYWNoZV9yZWdzLmgg
Yi9hcmNoL3g4Ni9rdm0va3ZtX2NhY2hlX3JlZ3MuaAppbmRleCAzNmE4Nzg2ZGIyOTEuLjhk
ZGIwMTE5MWQ2ZiAxMDA2NDQKLS0tIGEvYXJjaC94ODYva3ZtL2t2bV9jYWNoZV9yZWdzLmgK
KysrIGIvYXJjaC94ODYva3ZtL2t2bV9jYWNoZV9yZWdzLmgKQEAgLTcsNyArNyw4IEBACiAj
ZGVmaW5lIEtWTV9QT1NTSUJMRV9DUjBfR1VFU1RfQklUUwkoWDg2X0NSMF9UUyB8IFg4Nl9D
UjBfV1ApCiAjZGVmaW5lIEtWTV9QT1NTSUJMRV9DUjRfR1VFU1RfQklUUwkJCQkgIFwKIAko
WDg2X0NSNF9QVkkgfCBYODZfQ1I0X0RFIHwgWDg2X0NSNF9QQ0UgfCBYODZfQ1I0X09TRlhT
UiAgXAotCSB8IFg4Nl9DUjRfT1NYTU1FWENQVCB8IFg4Nl9DUjRfUEdFIHwgWDg2X0NSNF9U
U0QgfCBYODZfQ1I0X0ZTR1NCQVNFKQorCSB8IFg4Nl9DUjRfT1NYTU1FWENQVCB8IFg4Nl9D
UjRfUEdFIHwgWDg2X0NSNF9UU0QgfCBYODZfQ1I0X0ZTR1NCQVNFIFwKKwkgfCBYODZfQ1I0
X0NFVCkKIAogI2RlZmluZSBYODZfQ1IwX1BEUFRSX0JJVFMgICAgKFg4Nl9DUjBfQ0QgfCBY
ODZfQ1IwX05XIHwgWDg2X0NSMF9QRykKICNkZWZpbmUgWDg2X0NSNF9UTEJGTFVTSF9CSVRT
IChYODZfQ1I0X1BHRSB8IFg4Nl9DUjRfUENJREUgfCBYODZfQ1I0X1BBRSB8IFg4Nl9DUjRf
U01FUCkKLS0gCjIuNDcuMgoK

--------------5p0OIsFs8UdPa9j8yIoVSwAu--

