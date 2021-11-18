Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82A44560EB
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 17:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhKRQwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 11:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbhKRQwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 11:52:45 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33B3C06173E
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 08:49:44 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 206so850404pgb.4
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 08:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d+draVXuiToCJFuznv+X75lB2WMBUcaNE7FlgHWC0MU=;
        b=DxgdGAKhzq3iyj9XYWSp808CqbmkOFGPmgg7YVZtMyxOrUGFfeUX+VPM+3VtI6PeNC
         mXntPnVXxiJXKkwh4rQDq4nKwcob/ZyifgYpaCy36N+l4YM6TOIEi9xQ9mi8f82KU/5+
         P1htAxvVenSKqKBPral+lxCJbRMW+uKe2giLruhAivHxRNXdEzvrXZbq9B6menVhBjfW
         EYhuV5V8Hl/Zs3zYtlECxcptXXILpTecglTra9i+xPqyVG/x9HlgiiGVNLMJZhOtehTr
         jCM3VEJN4P8HXBOJdbaAmlaaPkmd4AOyS2ykk8z6jSJiW2UJP7uifEbRy0Yv7Ig6c6Ze
         eH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d+draVXuiToCJFuznv+X75lB2WMBUcaNE7FlgHWC0MU=;
        b=OxkKDBkn/3T3digE7f4EbiKby09bAPyCL9hAA/owXrqX27nsT+msDvy6y/D1VtL4DD
         5w3Kb6aQYjLM40BYvXq3P/dJejFxgsC/C3ox+OPtdFqR5qcnnnSl0zjiX9QoDuzpEW2b
         8DSN5yc3ULx2FZSyGLUgPJ0TC1WGRNpXffsGth04wqYX0L26PUhzBnkiTkmYymbvznq+
         /YDDLCAjk9PQc5HYTkKKC3flk51uwu8EDWcl32KmSSbIxzhxkS1/+kXpy8PEiFafunCX
         qEqGLWG8mHiEpggVnBps/ewj/s6sh3TyqytX0/W4p07UoiT/XEg3cDi4m/Gqri8EAmAt
         5aJQ==
X-Gm-Message-State: AOAM530VMRVNVbFdqSbUVYS9fRf5T6iHpnYFFUpYwKo3j4bQBP4PP9iD
        EF+1BUYsWnsf8GhDGuw//CWQEw==
X-Google-Smtp-Source: ABdhPJxizezP7GB1Qdiu6Zf7X61r6zIjOCTHRhTJXDFWIfg4vKlgMcTpvhOOyCHc3QgSDAozqFQ7Mw==
X-Received: by 2002:a63:7d0f:: with SMTP id y15mr12032460pgc.446.1637254184220;
        Thu, 18 Nov 2021 08:49:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g21sm181147pfc.95.2021.11.18.08.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 08:49:43 -0800 (PST)
Date:   Thu, 18 Nov 2021 16:49:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [PATCH v3] KVM: MMU: update comment on the number of page role
 combinations
Message-ID: <YZaEJDRXrN5W20sk@google.com>
References: <20211118114039.1733976-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118114039.1733976-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Paolo Bonzini wrote:
> Fix the number of bits in the role, and simplify the explanation of
> why several bits or combinations of bits are redundant.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6ac61f85e07b..55f280e96b59 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -291,19 +291,27 @@ struct kvm_kernel_irq_routing_entry;
>   * the number of unique SPs that can theoretically be created is 2^n, where n
>   * is the number of bits that are used to compute the role.
>   *
> - * But, even though there are 18 bits in the mask below, not all combinations
> - * of modes and flags are possible.  The maximum number of possible upper-level
> - * shadow pages for a single gfn is in the neighborhood of 2^13.
> + * There are 19 bits in the mask below, and the page tracking code only uses
> + * 16 bits per gfn in kvm_arch_memory_slot to count whether a page is tracked.
> + * However, not all combinations of modes and flags are possible.  First
> + * of all, invalid shadow pages pages are not accounted, and "smm" is constant
> + * in a given memslot (because memslots are per address space, and SMM uses
> + * a separate address space).  Of the remaining 2^17 possibilities:
>   *
> - *   - invalid shadow pages are not accounted.
> - *   - level is effectively limited to four combinations, not 16 as the number
> - *     bits would imply, as 4k SPs are not tracked (allowed to go unsync).
> - *   - level is effectively unused for non-PAE paging because there is exactly
> - *     one upper level (see 4k SP exception above).
> - *   - quadrant is used only for non-PAE paging and is exclusive with
> - *     gpte_is_8_bytes.
> - *   - execonly and ad_disabled are used only for nested EPT, which makes it
> - *     exclusive with quadrant.
> + *   - quadrant will only be used if gpte_is_8_bytes=0 (non-PAE paging);
> + *     execonly and ad_disabled are only used for nested EPT which has
> + *     gpte_is_8_bytes=1.  Therefore, 2 bits are always unused.

Since we're already out behind the bikeshed... :-) 

Maybe instead of "always unused", pharse it as "Therefore, 2 bits (quadrant or
execonly+ad_disabled) are constant".  The bits are still used in the sense that
they do key the role, they're just guaranteed to be zero.

> + *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
> + *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
> + *     paging has exactly one upper level, making level completely redundant
> + *     when gpte_is_8_bytes=0.
> + *
> + *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
> + *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.

Ah, I missed the opportunity to shave those bits.  Nice!

> + *
> + * Therefore, the maximum number of possible upper-level shadow pages for a
> + * given (as_id, gfn) pair is a bit less than 2^12.

With the unused/constant change,

Reviewed-by: Sean Christopherson <seanjc@google.com>

>   */
>  union kvm_mmu_page_role {
>  	u32 word;
> -- 
> 2.27.0
> 
