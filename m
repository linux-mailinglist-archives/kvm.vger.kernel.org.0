Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BBD581C31
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 00:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239726AbiGZW7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 18:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239766AbiGZW7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 18:59:32 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3A131DCC
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 15:59:27 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r186so14414075pgr.2
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 15:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zbVXlu6UhBmMUMJUc0Rw/2q53XiX6KTAIy7xuAJ3dG0=;
        b=rEKJuTh/Thka6m0TqPre8N2tFPzGA9XJE0UQ7TivADKYQJpHI29/fAoOEePHzH9LaH
         dLIvmQ4zNxfbaExYhjSKSAmXy++XNI6Ez5U60BWQK8RVCB597K226L7SHOZ7Us3+Ym2u
         mzyWeVcr5NQXCsNJr2J7F3nn5SrEKeWPTVSKFKRqeseNuSXvo/O54PDhTTK8mrQLZtaB
         gX0RAZpgVrXcre6PVeAqxu63NJ+Jp9JMT/FGH4N5FgCAHKfF+5kWciFEnXm+tmKn2H1K
         /hRit8SQniqezllABN8SLrL4gXYQuug/bSAXOQ2AILOFx1jVSSkyfwj5KOTkZ3YysEN6
         gRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zbVXlu6UhBmMUMJUc0Rw/2q53XiX6KTAIy7xuAJ3dG0=;
        b=cz6UJXfyTU8ybApL78SG2mnNNF8SOheQWdp+gMZXC2RRXSh5ZuN/JOyrmLZ0Nm0EVJ
         8Ed6kqA/Ytt1sJ1CNdxxgZBKA5BeKxOBhGctfDyvUlMZZF9RneAWhr5D7HbyF2QsWWMw
         s0JigEei5QBTwptUZ3m3HB+RKr3fzute0Al/ey/583xjxbjEwx78EvykPnbRaffFWm38
         nTyplo01UvBS/3Ua8iOJOMMPZMP5UbXxkkkDQYdXpkPtWrZCQF82rcRye/N6c++4dK5i
         hCOUyH3XYRWp9Pnby1DP8kV0B1c7usnzRcZq/lcAzzn1FdCTjIoS3BcomtS5/+S6rOOi
         vS8A==
X-Gm-Message-State: AJIora8ckZ/mejDNEcqNbA5Be/1FKzOueY4qZD99K823y27fMnUNOCrS
        z2zwTpz2EEs4bXOZ2BufaEgZCaHD1DTNvQ==
X-Google-Smtp-Source: AGRyM1tcNOvsTsKBInI9tPP1Sdini2FyTaW/Iwc+RU3s2k+KCCuKosaVfizI2CGFv6AUeI8RuVhLig==
X-Received: by 2002:a63:594f:0:b0:412:96c7:26f7 with SMTP id j15-20020a63594f000000b0041296c726f7mr17165596pgm.110.1658876366419;
        Tue, 26 Jul 2022 15:59:26 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id a24-20020aa79718000000b005255f5d8f9fsm12151891pfg.112.2022.07.26.15.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 15:59:24 -0700 (PDT)
Date:   Tue, 26 Jul 2022 15:59:20 -0700
From:   David Matlack <dmatlack@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix wrong gfn range of tlb flushing with range
Message-ID: <YuBxyPl9W9mWaBRS@google.com>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 11:36:56AM +0800, Hou Wenlong wrote:
> Commit c3134ce240eed
> ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> replaces old tlb flush function with kvm_flush_remote_tlbs_with_address()
> to do tlb flushing. However, the gfn range of tlb flushing is wrong in
> some cases. E.g., when a spte is dropped, the start gfn of tlb flushing
> should be the gfn of spte not the base gfn of SP which contains the spte.
> So this patchset would fix them and do some cleanups.

One thing that would help prevent future buggy use of
kvm_flush_remote_tlbs_with_address(), and clean up this series, would be to
introduce some helper functions for common operations. In fact, even if
there is only one caller, I still think it would be useful to have helper
functions because it makes it clear the author's intent.

For example, I think the following helpers would be useful in this series:

/* Flush the given page (huge or not) of guest memory. */
static void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
{
        u64 pages = KVM_PAGES_PER_HPAGE(level);

        kvm_flush_remote_tlbs_with_address(kvm, gfn, pages);
}

/* Flush the range of guest memory mapped by the given SPTE. */
static void kvm_flush_remote_tlbs_sptep(struct kvm *kvm, u64 *sptep)
{
        struct kvm_mmu_page *sp = sptep_to_sp(sptep);
        gfn_t gfn = kvm_mmu_page_get_gfn(sp, spte_index(sptep));

        kvm_flush_remote_tlbs_gfn(kvm, gfn, sp->role.level);
}

/* Flush all memory mapped by the given direct SP. */
static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
{
        WARN_ON_ONCE(!sp->role.direct);
        kvm_flush_remote_tlbs_gfn(kvm, sp->gfn, sp->role.level + 1);
}

> 
> Hou Wenlong (5):
>   KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
>     validate_direct_spte()
>   KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
>     kvm_set_pte_rmapp()
>   KVM: x86/mmu: Reduce gfn range of tlb flushing in
>     tdp_mmu_map_handle_target_level()
>   KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
>   KVM: x86/mmu: Use 1 as the size of gfn range for tlb flushing in
>     FNAME(invlpg)()
> 
>  arch/x86/kvm/mmu/mmu.c         | 15 +++++++++------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c     |  4 ++--
>  3 files changed, 12 insertions(+), 9 deletions(-)
> 
> --
> 2.31.1
> 
