Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A9D391B5B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhEZPOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbhEZPN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 11:13:59 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E49AC061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 08:12:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 27so1213291pgy.3
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 08:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C/5Ranwu7HE2azcEa+hmqg/JtITqxBdUr04hyDgXo7Y=;
        b=ndyt9cVyj0vt7XDYJcvhr3wMSts7A20RTAgpXxfjGBGWutTLIvv6BynFy8jDmhGZs7
         DbG0YdnGY31/nLUT2oD0sURr0TWGZ5KTkc6xWPF0bYz09u1tdlFBD++mqihDNMueX5Jc
         HOrQVpFLAmwJ8r+2oLu14ebbFzTtHFuOWVJtXCAUXyy5zT+8aS12qGVZZzw3rQxBkjvN
         GuoQj2FFlvcBFcRww/hoVGC/NvltIiZ1ERXwbf12WM6WA3HVsL5WP26NaNhyf73CoEvB
         Q5uz6N0F6nljq7UMi7cazOHrT9lu1iMiJEjkRl2qUgzUdKSRHSMftrH9ICcGOnF9g/AO
         nAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C/5Ranwu7HE2azcEa+hmqg/JtITqxBdUr04hyDgXo7Y=;
        b=RK4nStqPmxrDFEgugQEJWuP67gD8yx/bHbtGTEkb4f2LUOxlSFSge1QVS4uzbt3P/a
         hA31XZC+STp8UZLNigwgG5GPntN+EpLMGFx6loICkzThN7A/VvLvg8dspUVKb7cOHD7+
         dVAFm904EVXdYpL6gvlG5crH9gJnzvma3zeXOgWwzlEZYXvKdK4WwmeOfvWj7PqYyT81
         wUVCLc1jmtWd7eIL5KPOBl4Vw2YbU/6lPljbnIhNDTz8pEsjv6k8YTDmTFNLPObxPCr7
         Jpx25xenKOwauUokith2IU4p74/lH80tRZQcjoe508dgGatTT5tl0M+vfIdOPPvow4tU
         sP4w==
X-Gm-Message-State: AOAM5339lycQN5dq9FuOVcsgt/LKTogzH8QsgfSSg4fMJX/wMZKaq646
        j99iZwldBirGiwrbt0VznYluhS/aaWVuHg==
X-Google-Smtp-Source: ABdhPJxHMH2I2J6atI3x0gLMWLb35yVa5lseO/JuO36JJabwZfZnQSfPpL8ygRdxQfTXXgsk2TM/TA==
X-Received: by 2002:a62:52d5:0:b029:2e9:1faa:20d1 with SMTP id g204-20020a6252d50000b02902e91faa20d1mr6331096pfb.39.1622041944561;
        Wed, 26 May 2021 08:12:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i8sm14458028pjs.54.2021.05.26.08.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:12:24 -0700 (PDT)
Date:   Wed, 26 May 2021 15:12:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove stale comment mentioning skip_4k
Message-ID: <YK5lVHARaeNfCJ5L@google.com>
References: <20210525223447.2724663-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525223447.2724663-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021, David Matlack wrote:
> This comment was left over from a previous version of the patch that
> introduced wrprot_gfn_range, when skip_4k was passed in instead of
> min_level.
> 
> Remove the comment (instead of fixing it) since wrprot_gfn_range has
> only one caller and min_level is documented there.

That would be ok-ish if there were no comment whatsoever, but the function comment
is now flat out wrong, which is bad.

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 95eeb5ac6a8a..97f273912764 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1192,8 +1192,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  }
>  
>  /*
> - * Remove write access from all the SPTEs mapping GFNs [start, end). If
> - * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
> + * Remove write access from all the SPTEs mapping GFNs [start, end).

If the goal is to avoid churn on the last sentence, what about:

    * Write protect SPTEs mapping GFNs [start, end) at or above min_level.

>   * Returns true if an SPTE has been changed and the TLBs need to be flushed.
>   */
>  static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -- 
> 2.32.0.rc0.204.g9fa02ecfa5-goog
> 
