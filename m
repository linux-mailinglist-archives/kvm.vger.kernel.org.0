Return-Path: <kvm+bounces-68311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC54D329AF
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7FD6430754C4
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 14:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AFD337118;
	Fri, 16 Jan 2026 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eseynUaW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4316819AD5C
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768573596; cv=none; b=p6BJSayHugX+bk82Ae5DtzdpMyIn52Sh0wjxg9Hv9Mg/SJdmL9LAn7tVCqvKszbR/iKtmGaosulyxI//4iSH5Sm7Um9CkcaDCkZC+1O1gesosZOlNaHRTDA/Kk9el9NZw8J0Ujao2+0NpuSRioMtqg5pMKJkjxfgQvRpwTPD2/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768573596; c=relaxed/simple;
	bh=LtHpOhhSML+LKSk0z1CA1ruBS7MkRP4zu4zJa7j4/Aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hUocgl46vMXpRrRqIZ2tnFl1I2tO4sHrFc+6WeI2FbK10yeVY69yWuDdQu95bfC/SHqnFxtlVdnS7Fv5+SaF8Q3jOaLcQmteI1zW7eZf16kYzmdlEc3uozjMOELtpM/hzCtDCO8otOn23w6rn0LLSI4d+yBo3afTpx/z2BnXEMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eseynUaW; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59b77ff32feso276831e87.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 06:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768573593; x=1769178393; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CovPvWzL9Wgw5DrqjAwztat3FcX1o7MgbClex8ex/tE=;
        b=eseynUaW2Ls3wPVsuOWRyBSYzGfWJlk1XPM4TTyOC6Ss/8qgsQCKVlDmpltabiC/K4
         W42Xz4rZJliEPTd8JzlwnayLvfaUXGT+gygrrgWErJSRy0GVWAr40fnsQ9+mVqY4MTYN
         yl3gJpV6gIau55646UWoeuwPNGT9qntVuB5eyPyAR3YIB8W3Lu2sTlk27BVWzaXXrIQr
         hJITjQWBHoPcdAW+RqQyjhd7VQ0iwlMHA/U9OTxDr/Js3/J/NhHcNtPd5T+hTgE4JSKP
         381UxQfkYSb7NLoylG7Uaz031M5SRkxzPyp38MwWqk4GI2yA33rHAJLsv0OhUuR4x8x8
         wHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768573593; x=1769178393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CovPvWzL9Wgw5DrqjAwztat3FcX1o7MgbClex8ex/tE=;
        b=GTugnoY9Dnic5L7WrG4JoSfE2C94WYNFtgwnA5Au8ofDBuCneftAujOWp1hC5uqOve
         W+0kcvbOTg8n8yLRXn0SM5UT1TFPN9/qaPouu+EfAE1nVaP7NTxI62i1Qh4/1yc0aASH
         XvrcFlOx2fDwO75O3ZZFFQKnGlMIBvWuir5gxgll1e4lP5eEPCExmoA2K7dkc1Cg+7AF
         SZFwHldzUOxPXZAC/HfBuokXAXQGu9V4/KQZuhYgqNwlfwyhz+sTEFK3SgE3vvDC7Jn1
         XdvRglKZa3sZqVWMPiXkGAlKgvQrUR51Fh42PTDQ+tV6FE4dbx/N6ny/zlvsQ9wKbA0h
         H/FQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyqDB7TWuzV8EnI5vgdZTj+oHvoEKhIVxn+ajNKMo2RWkd+7ceCMSwjZGLg0MsZ++Jt7k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS6SQ0vAweWwDFVpLlcj/KwvreinipQF9AHIWkS1b65w/OtN6T
	Cvg0saXuRdl313vQRsZ3eGik3/0MtMFMUwZN6GGZqLzEKGuCPJKDvCaY
X-Gm-Gg: AY/fxX4agR6ddxxrOQlZYlQF5EOz9QLy0qf3iOisCUifWM4n/ofP0LLuC60asBP4BD6
	G3L8TEv0C2JLNK34TX7PD04citbaeDyzI5wW2iJnWXXMgTFN4cdevP6TZIVRE4trvc8a449rpvQ
	9OY84qYiTAXe/DjgquM8LTI20edxlQr5zFCvpYBMDt0sEi5yGABv7L4lev3Xm/Ut4KUxY48L93L
	CKOrvv8q53u8AaHP7H3fRjt9vYipQ2kJ2HJLtI4pQ+m5eXN7c/oC4y+BMq7nIRBdp+0rIeYTt+R
	svaCudZlur+LOVPmcKtRXaTjzx+fibe8J+ApDcy1X/eYf0zCEfVGSHViMQCbVzcVFc+ui8OPpMb
	J8Xmc6fsURNZlfgm9lGUJUCJq8wGR5lMOktKg/DiA15HRAxco1PLQq0Y6bF6H24nQ9Wdja6SuIu
	PCbrwjILGHrCI3olX2fg==
X-Received: by 2002:a05:6512:2c93:b0:59b:af9e:a16c with SMTP id 2adb3069b0e04-59baf9ea1f2mr386637e87.0.1768573593262;
        Fri, 16 Jan 2026 06:26:33 -0800 (PST)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf33f00fsm826443e87.12.2026.01.16.06.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 06:26:32 -0800 (PST)
Message-ID: <2968b97c-5d71-4c05-9013-f275bdbd9cd5@gmail.com>
Date: Fri, 16 Jan 2026 15:25:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/14] x86/mm: LAM compatible non-canonical definition
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, kvm <kvm@vger.kernel.org>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
 <0347c61eccf739ad15ec62600f009c212d52e761.1768233085.git.m.wieczorretman@pm.me>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <0347c61eccf739ad15ec62600f009c212d52e761.1768233085.git.m.wieczorretman@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/12/26 6:28 PM, Maciej Wieczor-Retman wrote:
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> 
> For an address to be canonical it has to have its top bits equal to each
> other. The number of bits depends on the paging level and whether
> they're supposed to be ones or zeroes depends on whether the address
> points to kernel or user space.
> 
> With Linear Address Masking (LAM) enabled, the definition of linear
> address canonicality is modified. Not all of the previously required
> bits need to be equal, only the first and last from the previously equal
> bitmask. So for example a 5-level paging kernel address needs to have
> bits [63] and [56] set.
> 
> Change the canonical checking function to use bit masks instead of bit
> shifts.
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Acked-by: Alexander Potapenko <glider@google.com>
> ---
> Changelog v7:
> - Add Alexander's acked-by tag.
> - Add parentheses around vaddr_bits as suggested by checkpatch.
> - Apply the bitmasks to the __canonical_address() function which is used
>   in kvm code.
> 
> Changelog v6:
> - Use bitmasks to check both kernel and userspace addresses in the
>   __is_canonical_address() (Dave Hansen and Samuel Holland).
> 
> Changelog v4:
> - Add patch to the series.
> 
>  arch/x86/include/asm/page.h | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index bcf5cad3da36..b7940fa49e64 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -82,9 +82,22 @@ static __always_inline void *pfn_to_kaddr(unsigned long pfn)
>  	return __va(pfn << PAGE_SHIFT);
>  }
>  
> +#ifdef CONFIG_KASAN_SW_TAGS
> +#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL((vaddr_bits) - 1))

why is the choice of CANONICAL_MASK() gated at compile time? Shouldn’t this be a
runtime decision based on whether LAM is enabled or not on the running system?
 
> +#else
> +#define CANONICAL_MASK(vaddr_bits) GENMASK_ULL(63, vaddr_bits)
> +#endif
> +
> +/*
> + * To make an address canonical either set or clear the bits defined by the
> + * CANONICAL_MASK(). Clear the bits for userspace addresses if the top address
> + * bit is a zero. Set the bits for kernel addresses if the top address bit is a
> + * one.
> + */
>  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)

+Cc KVM

This is used extensively in KVM code. As far as I can tell, it may be used to determine
whether a guest virtual address is canonical or not. If that’s the case, the result should
depend on whether LAM is enabled for the guest, not the host (and certainly not a host's compile-time option).

>  {
> -	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
> +	return (vaddr & BIT_ULL(63)) ? vaddr | CANONICAL_MASK(vaddr_bits) :
> +				       vaddr & ~CANONICAL_MASK(vaddr_bits);
>  }
>  
>  static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)


