Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C206977ED4B
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 00:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346991AbjHPWlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 18:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346990AbjHPWkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 18:40:39 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DD61BEE
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:40:34 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-26b29b33f0cso395726a91.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 15:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692225634; x=1692830434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jA3LctHZ//tnRkpcHda/4Rh45gvRjuYg1xEZKS7S7Bo=;
        b=32dUWbILQO8YE5D9AxRrUQmoYj1xR2mqkk59trzaCfr8gMXlmkXgt0YB/ipi7Pv6DF
         5bLBCbapMD6pOP6yHe/N00pe1BU8XROvpB5jCe7fWu7FHhfH8Ko/vdPik2SoaOyJNBY5
         hNX01Aow4snrAtOFv75E/990Unu2EqCE4we2EDksfRNchEgjObeFtJptcOMDDbovV11n
         ZOJ0PH1FCX8w3+eE+NWA0sxbITnDxkxGD4c+WGOKMZt4FF7gBueS4fsmwzODgjidWbx+
         SAFeVBPo4LNKxpROkAKq1xUmDcVO2j++XH9V7ICMd8sdX/7m02wpAyYfWJ0JWy+kF0Lx
         yjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692225634; x=1692830434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jA3LctHZ//tnRkpcHda/4Rh45gvRjuYg1xEZKS7S7Bo=;
        b=O/6v5xL1f+hRv/PtjvJuSbB1EYIsnTeNbugqfgtXPMPHDFiB7lDYqzchGNiBIKK+Oa
         5cDf6oOTbtoxvoH5Tvspv1QuygsMVfw3SpTBTIFwC7ew5ZPYYgVsJRRkxwAQWbjbCStm
         Sf5vpmhlgnPlL12Yb49fzmiME3+OqcyQhGoNPmAb3Q9tZV5xy1qMzqwJip1zTjx8DG/y
         SVLWL/qZeeQ3vSDuCe+JGdpspqq6ujQFND5ywuelaYBBh/3mTNGM5EDVuGkOj47tJ+sS
         V1WULvd8lDdyL8eE+gMXIOKi2CjTekbFkHGAvGlruqMMuu//vJXnvOGCM8rbmieMZBuH
         n/Ow==
X-Gm-Message-State: AOJu0YwU1iIWfh795s9JvlB+ovrKMHvf+5vyL9j8Zk1cgPFKZisfY0Tl
        WFTK4Y3Cer3ZOzqlLXD6gFSOP7fIbyU=
X-Google-Smtp-Source: AGHT+IHZIEEtE0GTE23hrMSOZRsQix/uiiI7scukL34ZuU1W2Rj1Z0AwHWpwqX7Ay7qh17KF/20rEq5PwgQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:120a:b0:268:38e3:34f0 with SMTP id
 gl10-20020a17090b120a00b0026838e334f0mr237100pjb.2.1692225634418; Wed, 16 Aug
 2023 15:40:34 -0700 (PDT)
Date:   Wed, 16 Aug 2023 15:40:32 -0700
In-Reply-To: <20230801002127.534020-6-mizhang@google.com>
Mime-Version: 1.0
References: <20230801002127.534020-1-mizhang@google.com> <20230801002127.534020-6-mizhang@google.com>
Message-ID: <ZN1QYGfFuzlyjECm@google.com>
Subject: Re: [PATCH v3 5/6] KVM: Documentation: Add the missing description
 for mmu_valid_gen into kvm_mmu_page
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Mingwei Zhang wrote:
> Add the description for mmu_valid_gen into kvm_mmu_page description.
> mmu_valid_gen is used in shadow MMU for fast zapping. Update the doc to
> reflect that.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> ---
>  Documentation/virt/kvm/x86/mmu.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> index 40daf8beb9b1..581e53fa00a2 100644
> --- a/Documentation/virt/kvm/x86/mmu.rst
> +++ b/Documentation/virt/kvm/x86/mmu.rst
> @@ -208,6 +208,16 @@ Shadow pages contain the following information:
>      The page is not backed by a guest page table, but its first entry
>      points to one.  This is set if NPT uses 5-level page tables (host
>      CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=1).
> +  mmu_valid_gen:
> +    The MMU generation of this page, used to fast zap of all MMU pages within a
> +    VM without blocking vCPUs.

KVM still blocks vCPUs, just for far less time.  How about this?

     The MMU generation of this page, used to determine whether or not a shadow
     page is obsolete, i.e. belongs to a previous MMU generation.  KVM changes
     the MMU generation when all shadow pages need to be invalidated, e.g. if a
     memslot is deleted, and so effectively marks all shadow pages as obsolete
     without having to touch each page.  Marking shadow pages obsolete allows
     KVM to zap them in the background, i.e. so that vCPUs can run while the
     zap is ongoing (using a root from the new generation).  The MMU generation
     is only ever '0' or '1' (slots_lock must be held until all pages from the
     previous generation are zapped).

     Note, the TDP MMU...

> Specifically, KVM updates the per-VM valid MMU
> +    generation which causes the mismatch of mmu_valid_gen for each mmu page.
> +    This makes all existing MMU pages obsolete. Obsolete pages can't be used.
> +    Therefore, vCPUs must load a new, valid root before re-entering the guest.
> +    The MMU generation is only ever '0' or '1'.  
