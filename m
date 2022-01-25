Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAB949B4F9
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386784AbiAYNZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576467AbiAYNWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 08:22:11 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9773EC06177F
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:22:10 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id p203so14550028oih.10
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DIZdKOVntrHNivrgeyNyjrvEE5HK8nFj+9d8ue+W9UI=;
        b=Y8Rq3AfgPDqXzFKT7ddTRyU3YPSy+h8XqrGJVpIaWPALow7SF1NYUjY9OzsmGch//Y
         oOlYR2gcgwWuUH/J3Mm37QUN5A0d7SHbtsFlkZJ1cxHfqqZ2zc8QHdfI8L1KAuBpOQlN
         HGtHhzJ/RSxDpc6qZ/4VP+TujTfXVGP1fni/NggDIugN/6PySpK/anof7BQRjhc4u6Z9
         HAKlBi0phRG5pB+B/wIu/TFuBnOX9nYoUlBFFdMNaRayJjG7tG6zZs5osg6j4Zj/IT+r
         jR5Q5JNGq9r8cHlO+sejl6Cw5h0oV1fcXLrSgNMR4eR70khNQA3U1v/Gns2h/lNpzJ2u
         RLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DIZdKOVntrHNivrgeyNyjrvEE5HK8nFj+9d8ue+W9UI=;
        b=l6F3qVz4SkJR8G+3U9r/Fd6cItNdWrA8jANX+zWr2aPw8+fUC6aoUjTy/D6DZIOKT6
         cXzMi46A8a6hwi5RnMDqhQZIChlioCFWgBOUryr/BdBYemZtdPOfHktQmPP52HRQN6vD
         7KL6sjBA3F1vfXAqNuWfzODdAkDwe54qDPi4jcUt0L+jysB7v8CnWhXYoRDxonluGXLo
         1PVoqVsk+XUamsa5Lqvz5NWWCzHy0We0y481UQDw/4FBNt+zVgcAGOvGZxwLjasYbwAY
         VqDsHWQwHzyOqN1uD2E1Fa0htZNdd9X8SUMTllWnEW7lRSTbnH1/Bb46x6/XD3WxJBOK
         IGfQ==
X-Gm-Message-State: AOAM5321+eWbZjhsRDh2/THSTJVgQzWD5aKlpobs5UELq3QSZJOaOaqs
        3fTSU2fGPqLSDkGuctor94+4gtjAaMWR65+aCPv9Vw==
X-Google-Smtp-Source: ABdhPJw73QNU1SoK95Ga6itnQQ5mRnTtANbJ4sNAfP3dixa4cg59oUV25yyAMk97f7TmM34Lljgsh/GSCQvcW58Qnds=
X-Received: by 2002:a05:6808:ec2:: with SMTP id q2mr618595oiv.124.1643116929640;
 Tue, 25 Jan 2022 05:22:09 -0800 (PST)
MIME-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
In-Reply-To: <20220118015703.3630552-1-jingzhangos@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 25 Jan 2022 13:21:33 +0000
Message-ID: <CA+EHjTwZsODk4pY9sYsUeyETUXQTLNDViPKjD_KbuaPF4sBu=A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ARM64: Guest performance improvement during dirty
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Tue, Jan 18, 2022 at 1:57 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> This patch is to reduce the performance degradation of guest workload during
> dirty logging on ARM64. A fast path is added to handle permission relaxation
> during dirty logging. The MMU lock is replaced with rwlock, by which all
> permision relaxations on leaf pte can be performed under the read lock. This
> greatly reduces the MMU lock contention during dirty logging. With this
> solution, the source guest workload performance degradation can be improved
> by more than 60%.
>
> Problem:
>   * A Google internal live migration test shows that the source guest workload
>   performance has >99% degradation for about 105 seconds, >50% degradation
>   for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
>   This shows that most of the time, the guest workload degradtion is above
>   99%, which obviously needs some improvement compared to the test result
>   on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
>   * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB, PageSize: 4K
>   * VM spec: #vCPU: 48, #Mem/vCPU: 4GB, PageSize: 4K, 2M hugepage backed
>
> Analysis:
>   * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
>     the number of contentions of MMU lock and the "dirty memory time" on
>     various VM spec. The "dirty memory time" is the time vCPU threads spent
>     in KVM after fault. Higher "dirty memory time" means higher degradation
>     to guest workload.
>     '-m 2' specifies the mode "PA-bits:48,  VA-bits:48,  4K pages".
>     By using test command
>     ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
>     Below are the results:
>     +-------+------------------------+-----------------------+
>     | #vCPU | dirty memory time (ms) | number of contentions |
>     +-------+------------------------+-----------------------+
>     | 1     | 926                    | 0                     |
>     +-------+------------------------+-----------------------+
>     | 2     | 1189                   | 4732558               |
>     +-------+------------------------+-----------------------+
>     | 4     | 2503                   | 11527185              |
>     +-------+------------------------+-----------------------+
>     | 8     | 5069                   | 24881677              |
>     +-------+------------------------+-----------------------+
>     | 16    | 10340                  | 50347956              |
>     +-------+------------------------+-----------------------+
>     | 32    | 20351                  | 100605720             |
>     +-------+------------------------+-----------------------+
>     | 64    | 40994                  | 201442478             |
>     +-------+------------------------+-----------------------+
>
>   * From the test results above, the "dirty memory time" and the number of
>     MMU lock contention scale with the number of vCPUs. That means all the
>     dirty memory operations from all vCPU threads have been serialized by
>     the MMU lock. Further analysis also shows that the permission relaxation
>     during dirty logging is where vCPU threads get serialized.

I am curious about any changes to performance for this case (the base
case) with the changes in patch 3.

Thanks,
/fuad



>
> Solution:
>   * On ARM64, there is no mechanism as PML (Page Modification Logging) and
>     the dirty-bit solution for dirty logging is much complicated compared to
>     the write-protection solution. The straight way to reduce the guest
>     performance degradation is to enhance the concurrency for the permission
>     fault path during dirty logging.
>   * In this patch, we only put leaf PTE permission relaxation for dirty
>     logging under read lock, all others would go under write lock.
>     Below are the results based on the fast path solution:
>     +-------+------------------------+
>     | #vCPU | dirty memory time (ms) |
>     +-------+------------------------+
>     | 1     | 965                    |
>     +-------+------------------------+
>     | 2     | 1006                   |
>     +-------+------------------------+
>     | 4     | 1128                   |
>     +-------+------------------------+
>     | 8     | 2005                   |
>     +-------+------------------------+
>     | 16    | 3903                   |
>     +-------+------------------------+
>     | 32    | 7595                   |
>     +-------+------------------------+
>     | 64    | 15783                  |
>     +-------+------------------------+
>
>   * Furtuer analysis shows that there is another bottleneck caused by the
>     setup of the test code itself. The 3rd commit is meant to fix that by
>     setting up vgic in the test code. With the test code fix, below are
>     the results which show better improvement.
>     +-------+------------------------+
>     | #vCPU | dirty memory time (ms) |
>     +-------+------------------------+
>     | 1     | 803                    |
>     +-------+------------------------+
>     | 2     | 843                    |
>     +-------+------------------------+
>     | 4     | 942                    |
>     +-------+------------------------+
>     | 8     | 1458                   |
>     +-------+------------------------+
>     | 16    | 2853                   |
>     +-------+------------------------+
>     | 32    | 5886                   |
>     +-------+------------------------+
>     | 64    | 12190                  |
>     +-------+------------------------+
>     All "dirty memory time" has been reduced by more than 60% when the
>     number of vCPU grows.
>   * Based on the solution, the test results from the Google internal live
>     migration test also shows more than 60% improvement with >99% for 30s,
>     >50% for 58s and >10% for 76s.
>
> ---
>
> * v1 -> v2
>   - Renamed flag name from use_mmu_readlock to logging_perm_fault.
>   - Removed unnecessary check for fault_granule to use readlock.
> * RFC -> v1
>   - Rebase to kvm/queue, commit fea31d169094
>     (KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event)
>   - Moved the fast path in user_mem_abort, as suggested by Marc.
>   - Addressed other comments from Marc.
>
> [v1] https://lore.kernel.org/all/20220113221829.2785604-1-jingzhangos@google.com
> [RFC] https://lore.kernel.org/all/20220110210441.2074798-1-jingzhangos@google.com
>
> ---
>
> Jing Zhang (3):
>   KVM: arm64: Use read/write spin lock for MMU protection
>   KVM: arm64: Add fast path to handle permission relaxation during dirty
>     logging
>   KVM: selftests: Add vgic initialization for dirty log perf test for
>     ARM
>
>  arch/arm64/include/asm/kvm_host.h             |  2 +
>  arch/arm64/kvm/mmu.c                          | 49 ++++++++++++-------
>  .../selftests/kvm/dirty_log_perf_test.c       | 10 ++++
>  3 files changed, 43 insertions(+), 18 deletions(-)
>
>
> base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
> --
> 2.34.1.703.g22d0c6ccf7-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
