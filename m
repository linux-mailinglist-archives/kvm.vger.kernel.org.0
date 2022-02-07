Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485034ACD64
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiBHBFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245516AbiBGXIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 18:08:55 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7142C0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 15:08:53 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id e28so15644776pfj.5
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 15:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=COLGZEfjt348jGmBnJRdmOjdGrLy5Lqfl3tXt8RO/Bw=;
        b=NWOKc9j/i8mNnF4B8FOxSgv1lyc/4uvzCIyafuDOxuHPaElJs+tG9g5kwfiIcsypGx
         3K43NeNl5rQgVeSeb1d6/l0QDVu/+hqYleVcqsvMbTSyJT1JRjmNL+xIB1T9nPv071W7
         Co9vhnYQKOFE9aVnmHQVuwQWo7gi2op7F8SUxzRlOCyorG6aY6VT3O+jvBYI/QnzCHlH
         SjxJFT7WwRgOGIq+zjEsmUgfU83YKe1MlD/kZWceYQS8agTpXRezkvoMiT3CsBDT8IpT
         UiVpqCHXPh6Y08sjOJLlYJxLzfOCsZURGAzJEHj4UZQ86P+3BJV3O3VCN2JpMvQ2IfdS
         +AHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=COLGZEfjt348jGmBnJRdmOjdGrLy5Lqfl3tXt8RO/Bw=;
        b=wlRDaPJGJf31cqHUg1dhS8Oi53n/MgtGVNSfrzeN+VfncoY0WdDrtLnZNImZolM2YV
         Xz5L2lejEDPHoAZjAOkxFVAt4a/eBBr6KTO3lvFbmzQWU2A0GRmbMV5iT8dab72hrWP2
         cO5smQay9bRoJoqPappg2gc6cNYaRZ4kf/YcFPn5qG5Fa1RIEwUnfyxtecpmgfZZGBlQ
         yjGy0Lq+RbizD8xSjIpiHyuzTvAfmiHPbE3yDYUiFA8DreC5Y1P+W2GMSy6LXyz7uoDF
         d1Zg/CabWSw4M4g+/Menw2AyYlE5xbeRrjU583o+IfFSsOT/fdlFzYzBGdsW0E2J9Otu
         QIew==
X-Gm-Message-State: AOAM530fqfNKZ0aslC9jijJfBe/dY723h0ONg9jJyoJesTF+kq9+oXYp
        OhDFVczcddAK8/CJJ7McSz25Ag==
X-Google-Smtp-Source: ABdhPJyMVli8H0BXFTzAsJe0jCjSE/qgoa5UAP8K08opjFe52BW5U4esrqnCWmVDGDeEpK+Ad6BZ/g==
X-Received: by 2002:aa7:8484:: with SMTP id u4mr1596327pfn.70.1644275333079;
        Mon, 07 Feb 2022 15:08:53 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id t2sm13073667pfj.211.2022.02.07.15.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 15:08:52 -0800 (PST)
Date:   Mon, 7 Feb 2022 23:08:48 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 00/23] KVM: MMU: MMU role refactoring
Message-ID: <YgGmgMMR0dBmjW86@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:56:55AM -0500, Paolo Bonzini wrote:
> The TDP MMU has a performance regression compared to the legacy
> MMU when CR0 changes often.  This was reported for the grsecurity
> kernel, which uses CR0.WP to implement kernel W^X.  In that case,
> each change to CR0.WP unloads the MMU and causes a lot of unnecessary
> work.  When running nested, this can even cause the L1 to hardly
> make progress, as the L0 hypervisor it is overwhelmed by the amount
> of MMU work that is needed.
> 
> The root cause of the issue is that the "MMU role" in KVM is a mess
> that mixes the CPU setup (CR0/CR4/EFER, SMM, guest mode, etc.)
> and the shadow page table format.  Whenever something is different
> between the MMU and the CPU, it is stored as an extra field in struct
> kvm_mmu---and for extra bonus complication, sometimes the same thing
> is stored in both the role and an extra field.
> 
> So, this is the "no functional change intended" part of the changes
> required to fix the performance regression.  It separates neatly
> the shadow page table format ("MMU role") from the guest page table
> format ("CPU role"), and removes the duplicate fields.

What do you think about calling this the guest_role instead of cpu_role?
There is a bit of a precedent for using "guest" instead of "cpu" already
for this type of concept (e.g. guest_walker), and I find it more
intuitive.

> The next
> step then is to avoid unloading the MMU as long as the MMU role
> stays the same.
> 
> Please review!
> 
> Paolo
> 
> Paolo Bonzini (23):
>   KVM: MMU: pass uses_nx directly to reset_shadow_zero_bits_mask
>   KVM: MMU: nested EPT cannot be used in SMM
>   KVM: MMU: remove valid from extended role
>   KVM: MMU: constify uses of struct kvm_mmu_role_regs
>   KVM: MMU: pull computation of kvm_mmu_role_regs to kvm_init_mmu
>   KVM: MMU: load new PGD once nested two-dimensional paging is
>     initialized
>   KVM: MMU: remove kvm_mmu_calc_root_page_role
>   KVM: MMU: rephrase unclear comment
>   KVM: MMU: remove "bool base_only" arguments
>   KVM: MMU: split cpu_role from mmu_role
>   KVM: MMU: do not recompute root level from kvm_mmu_role_regs
>   KVM: MMU: remove ept_ad field
>   KVM: MMU: remove kvm_calc_shadow_root_page_role_common
>   KVM: MMU: cleanup computation of MMU roles for two-dimensional paging
>   KVM: MMU: cleanup computation of MMU roles for shadow paging
>   KVM: MMU: remove extended bits from mmu_role
>   KVM: MMU: remove redundant bits from extended role
>   KVM: MMU: fetch shadow EFER.NX from MMU role
>   KVM: MMU: simplify and/or inline computation of shadow MMU roles
>   KVM: MMU: pull CPU role computation to kvm_init_mmu
>   KVM: MMU: store shadow_root_level into mmu_role
>   KVM: MMU: use cpu_role for root_level
>   KVM: MMU: replace direct_map with mmu_role.direct
> 
>  arch/x86/include/asm/kvm_host.h |  13 +-
>  arch/x86/kvm/mmu.h              |   2 +-
>  arch/x86/kvm/mmu/mmu.c          | 408 ++++++++++++--------------------
>  arch/x86/kvm/mmu/mmu_audit.c    |   6 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |  12 +-
>  arch/86/kvm/mmu/tdp_mmu.c      |   4 +-
>  arch/x86/kvm/svm/svm.c          |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |   2 +-
>  arch/x86/kvm/x86.c              |  12 +-
>  10 files changed, 178 insertions(+), 284 deletions(-)
> 
> -- 
> 2.31.1
> 
