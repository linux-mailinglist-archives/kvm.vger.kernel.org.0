Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354BF48D087
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 03:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiAMCuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 21:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiAMCuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 21:50:05 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0F2C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 18:50:04 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo8804042pjb.2
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 18:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ImhU/fmG/HToy1dr2YDqNHAIq2uq2Uny1Xfg58LVMDU=;
        b=Gigq102AAzuRtLukWWkUBX0D17ljeF9+2fsUkpCmhbJgmQkUkSKzzvCSbUiCBcHKeb
         y7TNSBhEeZ+YZ/ncbylr2ahjiafDpXtM+9VTFqpAsdirorLmP3+taH2Rkd/2sJ4bBlZM
         5NF65ElgZmuZrLnANwZouDTaEPq5WXtUxlwfj8nzgB6/12khDixcXKBmHVAK0lrNgb8v
         OI4XKGyy9TitatLLBjPfSxWwVozS2RX5bZsg+kkrVTOjmG2Qvd/u0UpZxgp879l6KxUs
         /wA1jJkCfBvCNla1Dfby1G+cFQsSS+qTCCrgb6VWeio4d31tEvOyeWV3vI/VJNV9z26R
         W+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ImhU/fmG/HToy1dr2YDqNHAIq2uq2Uny1Xfg58LVMDU=;
        b=lGdx8BqbQxm9Zz7n91XUN8+AGx+qbme7fdl3hI695r7gRFp/85kndDPS8H1H9/7guH
         Y1jz2XB1cOoWdOSLVJ70HIlcvW3P5ker008d4/f+iJHlaCoPmKy+oXUE4VGfUL8Lf2t1
         VuRKfpsUTer0+LYAFbX0Y7nxlaXbbML+kYTUNAluERqh+tC7fjoKnZxhHvvTihnk4qpe
         6gmyyHc2bTnoWWQxt6DdBy9/AR3w4tAvAkRgGJMahl4hRymAxIvxXvqQ+i9WRS15kFkq
         xEkd18KWP24ayt94LbcdPIlvozePsJCWrEopmuHFt1BI/x5ecudHrX+o1aqBGLvIQGEF
         iTgg==
X-Gm-Message-State: AOAM533xgl9xIk4DhTirpdPcRqXg4T8p+cUEPDFgDZyFxjpCahzzCrrb
        mk1HGN3HqByF2HqD2S/S4hgw1A==
X-Google-Smtp-Source: ABdhPJwOm8yJobDTRYmQRBuNHnS2U4QbUjj11RF+wet+br6fkzc7s74WO9DpP5GSP2MDEwKJtbONgQ==
X-Received: by 2002:a17:90b:4381:: with SMTP id in1mr2933797pjb.40.1642042204018;
        Wed, 12 Jan 2022 18:50:04 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id f125sm892919pfa.28.2022.01.12.18.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 18:50:03 -0800 (PST)
Date:   Wed, 12 Jan 2022 18:49:59 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH 0/3] ARM64: Guest performance improvement during dirty
Message-ID: <Yd+TV4Bkhzpnpx8N@google.com>
References: <20220110210441.2074798-1-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110210441.2074798-1-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Mon, Jan 10, 2022 at 09:04:38PM +0000, Jing Zhang wrote:
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
>   * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB
>   * VM spec: #vCPU: 48, #Mem/vCPU: 4GB
> 
> Analysis:
>   * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
>     the number of contentions of MMU lock and the "dirty memory time" on
>     various VM spec.
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
> 
> Solution:
>   * On ARM64, there is no mechanism as PML (Page Modification Logging) and
>     the dirty-bit solution for dirty logging is much complicated compared to
>     the write-protection solution. The straight way to reduce the guest
>     performance degradation is to enhance the concurrency for the permission
>     fault path during dirty logging.
>   * In this patch, we only put leaf PTE permission relaxation for dirty
>     logging under read lock, all others would go under write lock.
>     Below are the results based on the solution:
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

Just curious, do yo know why is time still doubling (roughly) with the
number of cpus? maybe you performed another experiment or have some
guess(es).

Thanks,
Ricardo

>     All "dirty memory time" have been reduced by more than 60% when the
>     number of vCPU grows.
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
>  arch/arm64/kvm/mmu.c                          | 86 +++++++++++++++----
>  .../selftests/kvm/dirty_log_perf_test.c       | 10 +++
>  3 files changed, 80 insertions(+), 18 deletions(-)
> 
> 
> base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
> -- 
> 2.34.1.575.g55b058a8bb-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
