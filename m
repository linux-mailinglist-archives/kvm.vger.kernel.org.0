Return-Path: <kvm+bounces-57572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF030B57C9D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 15:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EA694878EB
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240FD3112A1;
	Mon, 15 Sep 2025 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="OpGTjdSX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D60242A82
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942301; cv=none; b=WaVanvMP9K9QWd6ODGFeQM+3g3vYjYLG9eQuxvdRhiqTzRKtvPVDass60dvOQWrILsKH40hGLss5s7IjaDq1ZrjpPu2a1A0+fHZXy9cJxydhbeWGp9FDyhge11LLrMdmAGEW8Tx+Vrr9R8AGvZMPQ6eiSmxoCGkAgc1Yh9RtzT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942301; c=relaxed/simple;
	bh=0RcAsUV24yUDznAMeuxHRPsiGRsI8fv5Zds6fy6i9Uk=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=ORdKsYyiYYGH+HUpM6twZwubCGOJR8o9J0HuhKKkaLRO09TcKPiw7pQW6D1ImT/kf9iRlVeJTeiBiIX01ejsYMTYnU18b6qV8uHZrMU5rubrCQIZHVGc4oGX2KaKsqDjSOTBzpJlaJzK9e4FOdzzgVmetPXCymg9FtmmdN3VgyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=OpGTjdSX; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b38d4de61aso34974731cf.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 06:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757942298; x=1758547098; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hKFloG2OMskyg6q1OeWWQ+GyNGPMMa+n6Zu3PGiVpJQ=;
        b=OpGTjdSX8hgFCcYz9G9o/gTP9Cqw/gO3xOE4pX3rvOFQjXuqkFmXEVU88/S7puaY3g
         TtRfpxlWngW/AHLhE2OdxGtT1d4SGUpdW471cFJ9qiwD1M48RZN7f8krKHQ7x+FHoysE
         k5XLyt+73qciHMjeQGXYQAWylIQ1EB1o8KlpqmnxM163TztGD6YizI4n5dM37lx3dZjR
         +q2XGIulte1i0WH8/iUL16z6xXLZlphBoD6DwTcQqzFyajbiz9FKb081Idv5DalzeT4C
         T8KYaxjBnmc01FS0CwfdIgNwFYcmBzzjNKHGbZ2uQEtkxfj0iScrJyTMi5r3gc/3j1UB
         DSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757942298; x=1758547098;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hKFloG2OMskyg6q1OeWWQ+GyNGPMMa+n6Zu3PGiVpJQ=;
        b=bGtYAQBHl1qhvCnQzt05N7VPJIEGJP4z3kX4s+cDlNg3kgD23hSNcxTmKYmqAFOLZk
         NzYmH3dfB+Nwehmnr2ujej7TykUkgEFpwsXV4OvYenUFjsX63I8AI7SWKQi4PbH347zq
         ZZVtPEWvWRmFPKwtRpaAWj1CQapZ2tgbt/KQ0US9+oGBKxaqxud2efY+P+2WW5dD5ofi
         Ix0G4i/6QUaxuP+OSutgjKM0QK0GfUEbJMLej+EDaBxYaNi/gUlljnWs1A6VVgYGVQ7e
         n8ylJNpsKkcN8XFaebfiwlyBmE0I7uKlvAyxctqnUM3Jdkbt5WsENRm0TzbFM+8UtfXw
         tIKQ==
X-Gm-Message-State: AOJu0YwiYS1bhe56T6nvEciFbuN8oyYqLYZuqw+JN48QOtR9fM5CMuD4
	ZWtf7OGsstdCF6LqI83atveksX6VhJ+NgM09eBsrXO3K2FPhwvWxcg9Mx/s2r41KD/8=
X-Gm-Gg: ASbGncua93tjvY2S5nfEit3wgqRdmzAp5yuSMvdtbLGCjjo0/okTDLwRBz6kmIFu5e4
	w5fxRf4AshpocddDaDIhhAjs7q9VHfH5QeYIoBpMiNQiLq2XRJyZVAhTF8QRYUkeIKGqRsFFkoJ
	1VYwx1PG4dsnZ06kFEb86Jg7YHtQjwT+5JXyV/3iFfOfs8XJLbVG1wRhU45wBcVbqBKq17FigYm
	r1UvNS+Hy327MbhsKdcwVumcPQB266uVMwtqM2dyEz0Ezw9+HdLwD85mb7IY2uH3myoKBrsQgnS
	PL/HwT52wbkYe+rWlHLRM6AQk5jAX7ILdaAUBSHkNnrO8uDKhfMCPlJx7CVs84Nbv4ZdthpjC9O
	/hSCAx2w9QvJgoL5PA69PRqyGw/NfBFXnoajfdryI5Rg5phKCMFOtzYhBpqvRvaF93KTT7nz/Ch
	OkCtGqnvZc98O748Nps6y6DXDTWjMfYfHl1LU2/Eq4vol23VdjelL1cDM42w==
X-Google-Smtp-Source: AGHT+IGhTCub12nlTzC/2ydYvMUFyaPaJp+cpRW8Vimb0YoCXu36wiRFpkqRncfi2zn9N0Fljc1+3w==
X-Received: by 2002:a05:622a:2593:b0:4b7:9fc2:d9ba with SMTP id d75a77b69052e-4b79fc2ea42mr61050811cf.41.1757942298293;
        Mon, 15 Sep 2025 06:18:18 -0700 (PDT)
Received: from ?IPV6:2003:fa:af00:da00:8e63:e663:d61a:1504? (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-82a0d349ca3sm161109385a.64.2025.09.15.06.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 06:18:17 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------4i2MyFr7Y8HFl0Kd5nqzyczP"
Message-ID: <cf87742b-2f6f-42a2-9d75-b2c766b8b275@grsecurity.net>
Date: Mon, 15 Sep 2025 15:18:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 00/41] KVM: x86: Mega-CET
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>

This is a multi-part message in MIME format.
--------------4i2MyFr7Y8HFl0Kd5nqzyczP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Am 13.09.25 um 01:22 schrieb Sean Christopherson:
> This series is (hopefully) all of the in-flight CET virtualization patches
> in one big bundle.  Please holler if I missed a patch or three as this is what
> I am planning on applying for 6.18 (modulo fixups and whatnot), i.e. if there's
> something else that's needed to enable CET virtualization, now's the time...
> 
> Patches 1-3 probably need the most attention, as they are new in v15 and I
> don't have a fully working SEV-ES setup (don't have the right guest firmware,
> ugh).  Though testing on everything would be much appreciated.
> 
> I kept almost all Tested-by tags even for patches that I massaged a bit, and
> only dropped tags for the "don't emulate CET stuff" patch.  In theory, the
> changes I've made *should* be benign.  Please yell, loudly, if I broken
> something and/or you want me to drop your Tested-by.

I retested this series on my Alder Lake NUC (i7-1260P) and with the
attached hacky patch on top of Chao's QEMU branch[1] -- which points to
commit 02364ef48c96 ("fixup! target/i386: Enable XSAVES support for CET
states") for me right now -- the KUT CET tests[2] pass just fine on the
host as well as within a guest, i.e. nested. Therefore my Tested-by
still stands -- at least for the Intel/VMX part.

Thanks,
Mathias

[1] https://github.com/gaochaointel/qemu-dev#qemu-cet
[2]
https://lore.kernel.org/kvm/20250626073459.12990-1-minipli@grsecurity.net/
--------------4i2MyFr7Y8HFl0Kd5nqzyczP
Content-Type: text/x-patch; charset=UTF-8; name="qemu_cet_v15.diff"
Content-Disposition: attachment; filename="qemu_cet_v15.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3RhcmdldC9pMzg2L2t2bS9rdm0uYyBiL3RhcmdldC9pMzg2L2t2bS9r
dm0uYwppbmRleCBjZTNjNTJmZDBmN2QuLmQwN2RmYzcxNGEzYyAxMDA2NDQKLS0tIGEvdGFy
Z2V0L2kzODYva3ZtL2t2bS5jCisrKyBiL3RhcmdldC9pMzg2L2t2bS9rdm0uYwpAQCAtNTMy
MCw4ICs1MzIwLDcgQEAgc3RhdGljIGludCBrdm1fZ2V0X25lc3RlZF9zdGF0ZShYODZDUFUg
KmNwdSkKICAgICByZXR1cm4gcmV0OwogfQogCi0jZGVmaW5lIEtWTV9YODZfUkVHX1NZTlRI
RVRJQ19NU1IgICBCSVRfVUxMKDM1KQotI2RlZmluZSBSRUdfTVNSX0lOREVYKHgpICAgICAg
ICAgICAgKEtWTV9YODZfUkVHX1NZTlRIRVRJQ19NU1IgfCB4KQorI2RlZmluZSBLVk1fWDg2
X1JFR19TU1AgICAgICgweDIwMzAwMDAzVUxMIDw8IDMyIHwgMHgwMDAwMDAwMCkKIAogc3Rh
dGljIGJvb2wgaGFzX2NldF9zc3AoQ1BVU3RhdGUgKmNwdSkKIHsKQEAgLTU0MDksOSArNTQw
OCw5IEBAIGludCBrdm1fYXJjaF9wdXRfcmVnaXN0ZXJzKENQVVN0YXRlICpjcHUsIGludCBs
ZXZlbCwgRXJyb3IgKiplcnJwKQogICAgIH0KIAogICAgIGlmIChoYXNfY2V0X3NzcChjcHUp
KSB7Ci0gICAgICAgIHJldCA9IGt2bV9zZXRfb25lX3JlZyhjcHUsIFJFR19NU1JfSU5ERVgo
MHVsbCksICZlbnYtPmd1ZXN0X3NzcCk7CisgICAgICAgIHJldCA9IGt2bV9zZXRfb25lX3Jl
ZyhjcHUsIEtWTV9YODZfUkVHX1NTUCwgJmVudi0+Z3Vlc3Rfc3NwKTsKICAgICAgICAgaWYg
KHJldCkgewotICAgICAgICAgICAgZXJyb3JfcmVwb3J0KCJGYWlsZWQgdG8gc2V0IEtWTV9S
RUdfTVNSLCByZXQgPSAlZFxuIiwgcmV0KTsKKyAgICAgICAgICAgIGVycm9yX3JlcG9ydCgi
RmFpbGVkIHRvIHNldCBLVk1fUkVHX01TUiwgcmV0ID0gJWQiLCByZXQpOwogICAgICAgICB9
CiAgICAgfQogCkBAIC01NDg5LDkgKzU0ODgsOSBAQCBpbnQga3ZtX2FyY2hfZ2V0X3JlZ2lz
dGVycyhDUFVTdGF0ZSAqY3MsIEVycm9yICoqZXJycCkKICAgICAgICAgZ290byBvdXQ7CiAg
ICAgfQogICAgIGlmIChoYXNfY2V0X3NzcChjcykpIHsKLSAgICAgICAgcmV0ID0ga3ZtX2dl
dF9vbmVfcmVnKGNzLCBSRUdfTVNSX0lOREVYKDB1bGwpLCAmZW52LT5ndWVzdF9zc3ApOwor
ICAgICAgICByZXQgPSBrdm1fZ2V0X29uZV9yZWcoY3MsIEtWTV9YODZfUkVHX1NTUCwgJmVu
di0+Z3Vlc3Rfc3NwKTsKICAgICAgICAgaWYgKHJldCkgewotICAgICAgICAgICAgICAgIGVy
cm9yX3JlcG9ydCgiRmFpbGVkIHRvIGdldCBLVk1fUkVHX01TUiwgcmV0ID0gJWRcbiIsIHJl
dCk7CisgICAgICAgICAgICAgICAgZXJyb3JfcmVwb3J0KCJGYWlsZWQgdG8gZ2V0IEtWTV9S
RUdfTVNSLCByZXQgPSAlZCIsIHJldCk7CiAgICAgICAgIH0KICAgICB9CiAgICAgcmV0ID0g
a3ZtX2dldF9hcGljKGNwdSk7Cg==

--------------4i2MyFr7Y8HFl0Kd5nqzyczP--

