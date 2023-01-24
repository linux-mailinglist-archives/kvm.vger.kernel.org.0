Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0216E679F2A
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbjAXQu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjAXQu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:50:27 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122D4EFAA
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:50:26 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k13so15362639plg.0
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SXUs7GAqNqJPG2nIfuCmTwdMZLfZBxygcYraNjWRyZI=;
        b=LkCOS9933Uk1hwgRR6zGDCGzyPu1rQYDKTNLbdlUrvqITGrp2QEgc13kuskTQ4kO6W
         QtafYUaXp8IADS4oC1GUHKyEQLrqXqBdqukFO7mEbdeCBdemx7B5nHS5NiWy5vQLmkix
         RYnsDRw+mkLLFJS/KuCO/HKec7oZkIsTvujVrOd6eLcrgcgkjeShOQ3Ts6GUfbTG3hoN
         Emeg/vqyfCpx08/iAotXJOaF8kyQQRVnuxF+adzLB/ILMxWo1eVCUQaF7rkqNeyvgGOG
         ggMKqCk4a8lYZz9yh3JjRVPXIMLIQ1cG8Dm6NPHPozoUbOvg4XISIE64HYFtc+fYlHnX
         6L6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXUs7GAqNqJPG2nIfuCmTwdMZLfZBxygcYraNjWRyZI=;
        b=s86bYwl408RawajDdmfiWeyuqYp3U0jSRkkH9GDKenILeyg23qJTK7w3dJCGoXXNfe
         ay6d7vSLxFOYYJQJyNPsLObe1qVmUpXuBTpgmkQQ/rDt2dG4JWVbTcZgh6SadAxFmp6L
         MHUTJhuzBivR1qXCq9uDA7t0Xkzsj2eLalWaUcz3I3b4A4gQsc/g4J/WiF7nt3j4178K
         XLjhcA2kIn2BLVO0cqxnUFi9oIwXyAG5dqPkslBP4snugQpta15RmoVsx1rUHay3lZpe
         n4ND1FUR4lyVw+L598ERFFg8ukz9LfVB66CQKlCyaPy6w4oU3hLSl8m0UJdG4ZyI+yui
         2R3Q==
X-Gm-Message-State: AO0yUKU9pK24lwn4ye/y7O/Mxi01qUN+yTE4H0oaA5Tkq1KvB8f416to
        7KCejlrfFZcISdQ+BPJ2+g9Skw==
X-Google-Smtp-Source: AK7set9GirGnwwlFtvzSkauQVN0c+DI0q+KdVL6cpbO93rLClrnDUy33SVzX0MV80tF3j69IH1JXiA==
X-Received: by 2002:a17:90a:300e:b0:227:679:17df with SMTP id g14-20020a17090a300e00b00227067917dfmr237681pjb.0.1674579025317;
        Tue, 24 Jan 2023 08:50:25 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id nk19-20020a17090b195300b002295298a2e4sm8780786pjb.36.2023.01.24.08.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:50:24 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:50:21 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 0/9] KVM: arm64: Eager Huge-page splitting for
 dirty-logging
Message-ID: <Y9AMTVJbVDMsrdv6@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <CANgfPd-zjCcV08qPVpbvqT+aYaaaWsdGuDbiFyYS9HM-KaDKug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-zjCcV08qPVpbvqT+aYaaaWsdGuDbiFyYS9HM-KaDKug@mail.gmail.com>
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

On Mon, Jan 23, 2023 at 04:48:02PM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Implement Eager Page Splitting for ARM.
> >
> > Eager Page Splitting improves the performance of dirty-logging (used
> > in live migrations) when guest memory is backed by huge-pages.  It's
> > an optimization used in Google Cloud since 2016 on x86, and for the
> > last couple of months on ARM.
> >
> > Background and motivation
> > =========================
> > Dirty logging is typically used for live-migration iterative copying.
> > KVM implements dirty-logging at the PAGE_SIZE granularity (will refer
> > to 4K pages from now on).  It does it by faulting on write-protected
> > 4K pages.  Therefore, enabling dirty-logging on a huge-page requires
> > breaking it into 4K pages in the first place.  KVM does this breaking
> > on fault, and because it's in the critical path it only maps the 4K
> > page that faulted; every other 4K page is left unmapped.  This is not
> > great for performance on ARM for a couple of reasons:
> >
> > - Splitting on fault can halt vcpus for milliseconds in some
> >   implementations. Splitting a block PTE requires using a broadcasted
> >   TLB invalidation (TLBI) for every huge-page (due to the
> >   break-before-make requirement). Note that x86 doesn't need this. We
> >   observed some implementations that take millliseconds to complete
> >   broadcasted TLBIs when done in parallel from multiple vcpus.  And
> >   that's exactly what happens when doing it on fault: multiple vcpus
> >   fault at the same time triggering TLBIs in parallel.
> >
> > - Read intensive guest workloads end up paying for dirty-logging.
> >   Only mapping the faulting 4K page means that all the other pages
> >   that were part of the huge-page will now be unmapped. The effect is
> >   that any access, including reads, now has to fault.
> >
> > Eager Page Splitting (on ARM)
> > =============================
> > Eager Page Splitting fixes the above two issues by eagerly splitting
> > huge-pages when enabling dirty logging. The goal is to avoid doing it
> > while faulting on write-protected pages. This is what the TDP MMU does
> > for x86 [0], except that x86 does it for different reasons: to avoid
> > grabbing the MMU lock on fault. Note that taking care of
> > write-protection faults still requires grabbing the MMU lock on ARM,
> > but not on x86 (with the fast_page_fault path).
> >
> > An additional benefit of eagerly splitting huge-pages is that it can
> > be done in a controlled way (e.g., via an IOCTL). This series provides
> > two knobs for doing it, just like its x86 counterpart: when enabling
> > dirty logging, and when using the KVM_CLEAR_DIRTY_LOG ioctl. The
> > benefit of doing it on KVM_CLEAR_DIRTY_LOG is that this ioctl takes
> > ranges, and not complete memslots like when enabling dirty logging.
> > This means that the cost of splitting (mainly broadcasted TLBIs) can
> > be throttled: split a range, wait for a bit, split another range, etc.
> > The benefits of this approach were presented by Oliver Upton at KVM
> > Forum 2022 [1].
> >
> > Implementation
> > ==============
> > Patches 1-3 add a pgtable utility function for splitting huge block
> > PTEs: kvm_pgtable_stage2_split(). Patches 4-8 add support for eagerly
> > splitting huge-pages when enabling dirty-logging and when using the
> > KVM_CLEAR_DIRTY_LOG ioctl. Note that this is just like what x86 does,
> > and the code is actually based on it.  And finally, patch 9:
> >
> >         KVM: arm64: Use local TLBI on permission relaxation
> >
> > adds support for using local TLBIs instead of broadcasts when doing
> > permission relaxation. This last patch is key to achieving good
> > performance during dirty-logging, as eagerly breaking huge-pages
> > replaces mapping new pages with permission relaxation. Got this patch
> > (indirectly) from Marc Z.  and took the liberty of adding a commit
> > message.
> >
> > Note: this applies on top of 6.2-rc3.
> >
> > Performance evaluation
> > ======================
> > The performance benefits were tested using the dirty_log_perf_test
> > selftest with 2M huge-pages.
> >
> > The first test uses a write-only sequential workload where the stride
> > is 2M instead of 4K [2]. The idea with this experiment is to emulate a
> > random access pattern writing a different huge-page at every access.
> > Observe that the benefit increases with the number of vcpus: up to
> > 5.76x for 152 vcpus.
> >
> > ./dirty_log_perf_test_sparse -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2
> >
> >         +-------+----------+------------------+
> >         | vCPUs | 6.2-rc3  | 6.2-rc3 + series |
> >         |       |    (ms)  |             (ms) |
> >         +-------+----------+------------------+
> >         |    1  |    2.63  |          1.66    |
> >         |    2  |    2.95  |          1.70    |
> >         |    4  |    3.21  |          1.71    |
> >         |    8  |    4.97  |          1.78    |
> >         |   16  |    9.51  |          1.82    |
> >         |   32  |   20.15  |          3.03    |
> >         |   64  |   40.09  |          5.80    |
> >         |  128  |   80.08  |         12.24    |
> >         |  152  |  109.81  |         15.14    |
> >         +-------+----------+------------------+
> 
> This is the average pass time I assume? Or the total or last? Or whole
> test runtime?

Oops, forgot to provide any detail, sorry for that. This is the length
of the first guest pass ("Iteration 2 dirty memory time").

> Was this run with MANUAL_PROTECT or do the split during the CLEAR
> IOCTL or with the splitting at enable time?

The CLEAR IOCTL (with MANUAL_PROTECT). Just to double check, without the
'-g' argument.

> 
> >
> > This second test measures the benefit of eager page splitting on read
> > intensive workloads (1 write for every 10 reads). As in the other
> > test, the benefit increases with the number of vcpus, up to 8.82x for
> > 152 vcpus.
> >
> > ./dirty_log_perf_test -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2 -f 10
> >
> >         +-------+----------+------------------+
> >         | vCPUs | 6.2-rc3  | 6.2-rc3 + series |
> >         |       |   (sec)  |            (sec) |
> >         +-------+----------+------------------+
> >         |    1  |    0.65  |          0.07    |
> >         |    2  |    0.70  |          0.08    |
> >         |    4  |    0.71  |          0.08    |
> >         |    8  |    0.72  |          0.08    |
> >         |   16  |    0.76  |          0.08    |
> >         |   32  |    1.61  |          0.14    |
> >         |   64  |    3.46  |          0.30    |
> >         |  128  |    5.49  |          0.64    |
> >         |  152  |    6.44  |          0.63    |
> >         +-------+----------+------------------+
> >
> > Changes from the RFC:
> > https://lore.kernel.org/kvmarm/20221112081714.2169495-1-ricarkol@google.com/
> > - dropped the changes to split on POST visits. No visible perf
> >   benefit.
> > - changed the kvm_pgtable_stage2_free_removed() implementation to
> >   reuse the stage2 mapper.
> > - dropped the FEAT_BBM changes and optimization. Will send this on a
> >   different series.
> >
> > Thanks,
> > Ricardo
> >
> > [0] https://lore.kernel.org/kvm/20220119230739.2234394-1-dmatlack@google.com/
> > [1] https://kvmforum2022.sched.com/event/15jJq/kvmarm-at-scale-improvements-to-the-mmu-in-the-face-of-hardware-growing-pains-oliver-upton-google
> > [2] https://github.com/ricarkol/linux/commit/f78e9102b2bff4fb7f30bee810d7d611a537b46d
> > [3] https://lore.kernel.org/kvmarm/20221107215644.1895162-1-oliver.upton@linux.dev/
> >
> > Marc Zyngier (1):
> >   KVM: arm64: Use local TLBI on permission relaxation
> >
> > Ricardo Koller (8):
> >   KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
> >   KVM: arm64: Add helper for creating removed stage2 subtrees
> >   KVM: arm64: Add kvm_pgtable_stage2_split()
> >   KVM: arm64: Refactor kvm_arch_commit_memory_region()
> >   KVM: arm64: Add kvm_uninit_stage2_mmu()
> >   KVM: arm64: Split huge pages when dirty logging is enabled
> >   KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
> >   KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
> >
> >  arch/arm64/include/asm/kvm_asm.h     |   4 +
> >  arch/arm64/include/asm/kvm_host.h    |  30 +++++
> >  arch/arm64/include/asm/kvm_mmu.h     |   1 +
> >  arch/arm64/include/asm/kvm_pgtable.h |  62 ++++++++++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  10 ++
> >  arch/arm64/kvm/hyp/nvhe/tlb.c        |  54 +++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 143 +++++++++++++++++++++--
> >  arch/arm64/kvm/hyp/vhe/tlb.c         |  32 +++++
> >  arch/arm64/kvm/mmu.c                 | 168 ++++++++++++++++++++++-----
> >  9 files changed, 466 insertions(+), 38 deletions(-)
> >
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
