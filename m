Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE096484903
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiADTyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiADTyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:54:15 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE82C061784
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:54:14 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g2so33588837pgo.9
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cdmT5rfhNkWWjGcnFD7NuwPzzDkVYzXEr/P8sZKTqps=;
        b=C129iTBGi8h6CtSob4CAxpAQiIkOcQ2FLgoMbKSA9DIAafCrkRlwq+5Qfsn/GP1s+B
         xikZmG/3k+WSgN+5ZaLdmvqeTzfwgj8TplXAilI8TNQDeSi/tNPUjlGPn4NSfy1UxENO
         i//ZI+GivXS5RUK7yDPzkN3qRs0Ym+9smT3g1qsuN95Ea87FjdxwDGuODadrif1G+SpH
         4LKSBfFbXxaABx9uP3nsoBW97Tvvsz/RNEV3kGvBaSrnZf0bIAwYvNoStL07EcIsnfIX
         XxcMb0PUauPFMPljnZKY+wTE66PWFaw3LHM5P7i9/xxcVK6NHuuuW91h4vh9Tqwde1gu
         AFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cdmT5rfhNkWWjGcnFD7NuwPzzDkVYzXEr/P8sZKTqps=;
        b=tbjCl+id+h1NWzIxDLK6V3m1uthzVDrdS2oCRPV5qhLazN5kISZSPn8TkvnGNC3DOl
         YrT8sfo8S30CvbXx1tKR2nWD7DjGJPXKcBscS7FO+OFJMys8bJhxHMo8RrVURIAAeVLx
         FyRdqAGjYLHvUYg+z9HJid5ZWIfpRDqK7Rw9q/Wktc/eqAPx/tnHFdjBxqIFqNSxr319
         xWvG0JXHRmj8rMmTv2a20le88kTpTIIvYr1NTAlvoKSu7qA2IZ46er+JTPvOVoCExsr5
         Wq4uoC896NUU0AN50R46ueJV05Z2Z9ErlV9rKEGmw1OdkbvunH0vI75xs+AM2jPmMdRF
         nG7Q==
X-Gm-Message-State: AOAM530LTs9MdWf+Gm18dwRAakQnV2w6AZBAik7dyuBhiT2/JGK4rZVs
        mZjv9QgWXvaFPp+NF2q5CT9Epg==
X-Google-Smtp-Source: ABdhPJwbHVoGQWJnx4oFw2JlmF2TRIpvegfLjVIjVehkyjeU2NKQZtaHKzgL82XoXSOhYW8/Eew9aA==
X-Received: by 2002:a63:207:: with SMTP id 7mr45574965pgc.624.1641326054197;
        Tue, 04 Jan 2022 11:54:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p37sm40318945pfh.97.2022.01.04.11.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 11:54:13 -0800 (PST)
Date:   Tue, 4 Jan 2022 19:54:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com, corbet@lwn.net,
        shuah@kernel.org, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v4 03/21] kvm: x86: Fix xstate_required_size() to follow
 XSTATE alignment rule
Message-ID: <YdSl4s78kj/U/5Bl@google.com>
References: <20211229131328.12283-1-yang.zhong@intel.com>
 <20211229131328.12283-4-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229131328.12283-4-yang.zhong@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 29, 2021, Yang Zhong wrote:
> From: Jing Liu <jing2.liu@intel.com>
> 
> CPUID.0xD.1.EBX enumerates the size of the XSAVE area (in compacted
> format) required by XSAVES. If CPUID.0xD.i.ECX[1] is set for a state
> component (i), this state component should be located on the next
> 64-bytes boundary following the preceding state component in the
> compacted layout.
> 
> Fix xstate_required_size() to follow the alignment rule. AMX is the
> first state component with 64-bytes alignment to catch this bug.
> 
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 07e9215e911d..148003e26cbb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -42,7 +42,8 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  		if (xstate_bv & 0x1) {
>  		        u32 eax, ebx, ecx, edx, offset;
>  		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
> -			offset = compacted ? ret : ebx;
> +			/* ECX[1]: 64B alignment in compacted form */
> +			offset = compacted ? ((ecx & 0x2) ? ALIGN(ret, 64) : ret) : ebx;

That is impressively difficult to read.

			if (compacted)
				offset = (ecx & 0x2) ? ALIGN(ret, 64) : ret;
			else
				offset = ebx;

>  			ret = max(ret, offset + eax);
>  		}
>  
