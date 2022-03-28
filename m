Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E344D4E9DD8
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 19:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244716AbiC1RvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 13:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244709AbiC1RvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 13:51:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5873C705
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:49:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u22so13377295pfg.6
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8MCsBPpBoD29U6k6rEfjlGbRxzmLC6LeIyUcAUTlgXI=;
        b=GYFbw0+n24Bpt7HqJE3VsUtffGSMgXlkr2m2PF6agvHemn+Yf7nBK2ngclbCjC6RIn
         xWLF0e/+K/FOvEgdjbyPGwiIUN1ahOp4sRP+9wKOZPsMnOBQ6r9wpHoQkOl8crRDm7Fx
         0e4n94YUD0ldCVvnFkL25f+dh+c899tzIb84f+zaTjjzzG9LaIBTDnlO8PXYKlwE9bIR
         0AzWflkXpeFebJSKk9WTUQk7Z7I41l2JP4RP7IPbN2eCECAJeFCDxx54QkerMw3L2wPy
         hj340HBeyYfUEo2JML5CE/kAk611f54zY5gla0JHZom6ezh8ekWvuGNHjNcGYSl7Rjon
         ELUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8MCsBPpBoD29U6k6rEfjlGbRxzmLC6LeIyUcAUTlgXI=;
        b=Dk5IkA9S4okyFBfnW+JoftniqBF6Kopkmy4KPOfL7EqoWiv9VWATZR6sIzd+Jez8zb
         NHakPvZPhTe6ZKyZdkYTUqHPXCLFL8CcoMchoqpjAwv6N3wb9YUQSPV9tOtAHbmqzd85
         e1HqXv+Ue13lD0TPZ8rS++PedwHvKl0k2cI35tiY92L4ku8/W0ekcdlEWzxlilFMwLd+
         RPgUWv0JqE6JPfG9M1oD5iUWueAJc+OckpXfTbXRjoZVoX01wyWmr/nORbLvbgVXCO/6
         5IJ0demjYWq38jFK9rS7So5pVQyC29OccgcrdgQB0FtEleMIq8/+8l1TaAOzocrw9pYH
         pggw==
X-Gm-Message-State: AOAM532nhzTsgZ0wFQwJmzpSDuCR4GJWP04eebjA/2Dx1onRHtvhkOjr
        xTe5Xd+e8oYew0m06dRJUv/JLA==
X-Google-Smtp-Source: ABdhPJwtGB4B8y4JOhtFb1FTlgGTfD2O1LXa8pI7m/kxpB2c71DY2lXS9H87UnKEZhCzdQ+637Dq4g==
X-Received: by 2002:a05:6a00:8d4:b0:4f6:6da0:f380 with SMTP id s20-20020a056a0008d400b004f66da0f380mr24569850pfu.34.1648489762027;
        Mon, 28 Mar 2022 10:49:22 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a708300b001c7e8ae7637sm135006pjk.8.2022.03.28.10.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 10:49:20 -0700 (PDT)
Date:   Mon, 28 Mar 2022 17:49:17 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 0/9] KVM: x86/MMU: Optimize disabling dirty logging
Message-ID: <YkH1HbuUcY4JH5tT@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 03:43:49PM -0700, Ben Gardon wrote:
> Currently disabling dirty logging with the TDP MMU is extremely slow.
> On a 96 vCPU / 96G VM it takes ~256 seconds to disable dirty logging
> with the TDP MMU, as opposed to ~4 seconds with the legacy MMU. This
> series optimizes TLB flushes and introduces in-place large page
> promotion, to bring the disable dirty log time down to ~3 seconds.
> 
> Testing:
> Ran KVM selftests and kvm-unit-tests on an Intel Haswell. This
> series introduced no new failures.
> 
> Performance:
> 
> Without this series, TDP MMU:
> > ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
> Test iterations: 2
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fe7c0000000
> Populate memory time: 4.972184425s
> Enabling dirty logging time: 0.001943807s
> 
> Iteration 1 dirty memory time: 0.061862112s
> Iteration 1 get dirty log time: 0.001416413s
> Iteration 1 clear dirty log time: 1.417428057s
> Iteration 2 dirty memory time: 0.664103656s
> Iteration 2 get dirty log time: 0.000676724s
> Iteration 2 clear dirty log time: 1.149387201s
> Disabling dirty logging time: 256.682188868s
> Get dirty log over 2 iterations took 0.002093137s. (Avg 0.001046568s/iteration)
> Clear dirty log over 2 iterations took 2.566815258s. (Avg 1.283407629s/iteration)
> 
> Without this series, Legacy MMU:
> > ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
> Test iterations: 2
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fe7c0000000
> Populate memory time: 4.892940915s
> Enabling dirty logging time: 0.001864603s
> 
> Iteration 1 dirty memory time: 0.060490391s
> Iteration 1 get dirty log time: 0.001416277s
> Iteration 1 clear dirty log time: 0.323548614s
> Iteration 2 dirty memory time: 29.217064826s
> Iteration 2 get dirty log time: 0.000696202s
> Iteration 2 clear dirty log time: 0.907089084s
> Disabling dirty logging time: 4.246216551s
> Get dirty log over 2 iterations took 0.002112479s. (Avg 0.001056239s/iteration)
> Clear dirty log over 2 iterations took 1.230637698s. (Avg 0.615318849s/iteration)
> 
> With this series, TDP MMU:
> (Updated since RFC. Pulling out patches 1-4 could have a performance impact.)
> > ./dirty_log_perf_test -v 96 -s anonymous_hugetlb_1gb
> Test iterations: 2
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0x3fe7c0000000
> Populate memory time: 4.878083336s
> Enabling dirty logging time: 0.001874340s
> 
> Iteration 1 dirty memory time: 0.054867383s
> Iteration 1 get dirty log time: 0.001368377s
> Iteration 1 clear dirty log time: 1.406960856s
> Iteration 2 dirty memory time: 0.679301083s
> Iteration 2 get dirty log time: 0.000662905s
> Iteration 2 clear dirty log time: 1.138263359s
> Disabling dirty logging time: 3.169381810s
> Get dirty log over 2 iterations took 0.002031282s. (Avg 0.001015641s/iteration)
> Clear dirty log over 2 iterations took 2.545224215s. (Avg 1.272612107s/iteration)
> 
> Patch breakdown:
> Patches 1-4 remove the need for a vCPU pointer to make_spte
> Patches 5-8 are small refactors in preparation for in-place lpage promotion
> Patch 9 implements in-place largepage promotion when disabling dirty logging
> 
> Changelog:
> RFC -> v1:
> 	Dropped the first 4 patches from the series. Patch 1 was sent
> 	separately, patches 2-4 will be taken over by Sean Christopherson.
> 	Incorporated David Matlack's Reviewed-by.
> v1 -> v2:
> 	Several patches were queued and dropped from this revision.
> 	Incorporated feedback from Peter Xu on the last patch in the series.
> 	Refreshed performance data
> 		Between versions 1 and 2 of this series, disable time without
> 		the TDP MMU went from 45s to 256, a major regression. I was
> 		testing on a skylake before and haswell this time, but that
> 		does not explain the huge performance loss.
> 
> Ben Gardon (9):
>   KVM: x86/mmu: Move implementation of make_spte to a helper
>   KVM: x86/mmu: Factor mt_mask out of __make_spte
>   KVM: x86/mmu: Factor shadow_zero_check out of __make_spte
>   KVM: x86/mmu: Replace vcpu argument with kvm pointer in make_spte
>   KVM: x86/mmu: Factor out the meat of reset_tdp_shadow_zero_bits_mask
>   KVM: x86/mmu: Factor out part of vmx_get_mt_mask which does not depend
>     on vcpu
>   KVM: x86/mmu: Add try_get_mt_mask to x86_ops
>   KVM: x86/mmu: Make kvm_is_mmio_pfn usable outside of spte.c
>   KVM: x86/mmu: Promote pages in-place when disabling dirty logging

Use () after function names to make it clear you are referring to a
function and not something else. e.g.

  KVM: x86/mmu: Move implementation of make_spte to a helper

becomes

  KVM: x86/mmu: Move implementation of make_spte() to a helper

This applies throughout the series, in commit messages and comments.

> 
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  2 +
>  arch/x86/kvm/mmu/mmu.c             | 21 +++++----
>  arch/x86/kvm/mmu/mmu_internal.h    |  6 +++
>  arch/x86/kvm/mmu/spte.c            | 39 +++++++++++-----
>  arch/x86/kvm/mmu/spte.h            |  6 +++
>  arch/x86/kvm/mmu/tdp_mmu.c         | 73 +++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c             |  9 ++++
>  arch/x86/kvm/vmx/vmx.c             | 25 ++++++++--
>  9 files changed, 155 insertions(+), 27 deletions(-)
> 
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
