Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8F039063B
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 18:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhEYQLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 12:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhEYQLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 12:11:08 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361C2C061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:09:38 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id e17so13369948pfl.5
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H3sWTarjnvX1yMAm2uYSNfwdZYeMBB25uCb5WK431zU=;
        b=C6qPA5FhSJHG3wI1WyKnxYEf2VjLBIwUjC5lyLlyCbbGo7PABplZ6kD1VBVKuYrGKE
         Ee9LqveN6PdkTNfi3V0/gTKUCaWs3ZP7nKWy3DwF59dGZxgvGR49b7K16rT1JANCw8V6
         sohJKwbhYJUECd1gqM1jZbP/2ClEo9ne1t6t4WS4Uf0QqDrn5Htadumd2Cf/RqOXGONE
         vfedwaUNIrDr6mBAHd0m8jLIsSFc5XHj2DaWrEXu4qqrgqJvU2O3OLidC8+9ZMmlYCxH
         Wd8DCv4Nwtg9yY+oFxk8WQBrL07JzSrZteALP77eoVa1cNoByn9vapZ7Q4gkOsD+7tlI
         WeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H3sWTarjnvX1yMAm2uYSNfwdZYeMBB25uCb5WK431zU=;
        b=XUcL3HhbKAqNW/S1+dowxIccJOIBJw/GH6zpVrnNlnBe0pBswWb3KDD6qB3Ko7NOBa
         sIS+nuCKt8TLMjoe/ws9Te+3pKjkuGGWptMot7BqAVI71Wq2d7avFcXKBLKEXmLjS+kf
         pV4b2mwIFYDxZ7cPdhduZDPEmBSa59t6xIPr/7DXc6fgwwRv9uRxgCNkVbPPsNp/lMKL
         R6giGQXdX1bU8OJpDzhOGNh8XWz2EFJtZjp0+N+CaQy2moorx5mKQmVZ6a9JKdVv0dsU
         gK8vw+yWWTNCW0O6EospcLaatFDn/U5Pk3+X/gtPhHJHMQzDRO0co6VvE/Ck2e6H8WbS
         g9vg==
X-Gm-Message-State: AOAM532BdW0bvBsVPG/J/wljx8Hsc9F7CQzXfGgo1icjZqV2cBneoryx
        H5OtpEIVVkwDIRH5H3iwrCRcyw==
X-Google-Smtp-Source: ABdhPJyUa1oamz+bNtxoEJrCmoVhnufYrp6eapK4+RUTD/BghM60I/51xnlaPjhjZfei9ha8rv78yw==
X-Received: by 2002:a62:7f51:0:b029:2dc:e1c9:ef71 with SMTP id a78-20020a627f510000b02902dce1c9ef71mr30816282pfd.33.1621958977566;
        Tue, 25 May 2021 09:09:37 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id ck21sm12873674pjb.24.2021.05.25.09.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 09:09:36 -0700 (PDT)
Date:   Tue, 25 May 2021 16:09:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove the repeated declaration
Message-ID: <YK0hPadppDR1sPaD@google.com>
References: <1621910615-29985-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621910615-29985-1-git-send-email-zhangshaokun@hisilicon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021, Shaokun Zhang wrote:
> Function 'is_nx_huge_page_enabled' is declared twice, remove the
> repeated declaration.
> 
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  arch/x86/kvm/mmu/mmu_internal.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index d64ccb417c60..54c6e6193ff2 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -158,8 +158,6 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
>  void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
>  				kvm_pfn_t *pfnp, int *goal_levelp);
>  
> -bool is_nx_huge_page_enabled(void);

Rather than simply delete the extra declaration, what about converting this to
static inline and opportunistically deleting the duplicate?  The implementation
is a single operation and this is MMU-internal, i.e. there's no need to export
and limited exposure of nx_huge_pages to other code.

> -
>  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  
>  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> -- 
> 2.7.4
> 
