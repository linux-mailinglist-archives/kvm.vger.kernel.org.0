Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DCC48D11C
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 04:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiAMDvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 22:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiAMDvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 22:51:01 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69927C061756
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 19:51:01 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id m57so3000745vkf.9
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 19:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ktRaFtl7Smog1HtFyDxmtV/yehmwayBr7vLRYjoACxQ=;
        b=ekC19E7J1L18oenpr26vujAsD9aeLKD9f3kAtIYIcMpHt4e9MuDIRPaPHyibqcA11b
         K5ku4ScX+arP1OkaH0vvic4WXPpfKP4U1xi0luyJ2T42CapSQLJS9IzWgu/eWsDaajBJ
         jh/ulmCde9JCOCfPp9OduumFB4mWnsNgw7ybUuNUrcEqyduev3voispnIldwGimF/fMc
         Ax2fQcdc61aNmyFFiLsUkiHw8JrwYSA+KSebxNm5vnZVNDqIS9qVFEJfB42/o/qX7jB2
         Hrb6tIrxEWmtpzENB6rz7FHEn+GUVX0HTqHxKVOx+CqltlJeQtb0T3Y/JuXw/WMEE+VA
         eO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ktRaFtl7Smog1HtFyDxmtV/yehmwayBr7vLRYjoACxQ=;
        b=ivJMJC3t8HydB2AJwKzqgNn9KYIkIyonXpgPW31J/nRQzOzUCobwN6wMxUb7cpefLi
         sm3UOWRg24BKuhcp1I2y6XXPb9LKSzUv8vuckCdiMlVnb/riMNp5ddEEcIYfqXedX6X0
         ezGr01x8tyclkBc1F6k1QLgKO+PgsI+8muzNJGvO5IDBSQuRokHH47+80hVBOz+mneW/
         4rrFbh0JT+kzVx9vRw6+oeLCyJ4h2SrBIYt7XPZrbqF6zU0VRJTBoIynw0hRkLkfXd/d
         +/P2zPnSBO5n+kAeWkJL7ihwQfoOFKH4+7tJSOGadxz1KObzLWZuh3Q0sP6l/G/axGxT
         AkRg==
X-Gm-Message-State: AOAM533PN59K2B2O8WbrMh9NgR1ugrYFgbu3njhC22vsM416ubq1bzpp
        R/seBRzAHmMgYcMQqGO5py1FehTS5731g90Pj8Xqng==
X-Google-Smtp-Source: ABdhPJx7xoF2XFBJphbzmyDyf/r0Pxccmzf8jfBXrXYeJ/woj9eHUHs6Pa7k2+RUSRKStaK3ptIOdck7ZYpaibY/V2U=
X-Received: by 2002:a05:6122:554:: with SMTP id y20mr1396257vko.35.1642045860387;
 Wed, 12 Jan 2022 19:51:00 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com> <Yd+TV4Bkhzpnpx8N@google.com>
In-Reply-To: <Yd+TV4Bkhzpnpx8N@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 12 Jan 2022 19:50:48 -0800
Message-ID: <CAAdAUtgk7y6WA4YO96ZTX6ZUPPzfLtJWnToBVPHtLG89vJ-y2g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] ARM64: Guest performance improvement during dirty
To:     Ricardo Koller <ricarkol@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 6:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Hi Jing,
>
> On Mon, Jan 10, 2022 at 09:04:38PM +0000, Jing Zhang wrote:
> > This patch is to reduce the performance degradation of guest workload during
> > dirty logging on ARM64. A fast path is added to handle permission relaxation
> > during dirty logging. The MMU lock is replaced with rwlock, by which all
> > permision relaxations on leaf pte can be performed under the read lock. This
> > greatly reduces the MMU lock contention during dirty logging. With this
> > solution, the source guest workload performance degradation can be improved
> > by more than 60%.
> >
> > Problem:
> >   * A Google internal live migration test shows that the source guest workload
> >   performance has >99% degradation for about 105 seconds, >50% degradation
> >   for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
> >   This shows that most of the time, the guest workload degradtion is above
> >   99%, which obviously needs some improvement compared to the test result
> >   on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
> >   * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB
> >   * VM spec: #vCPU: 48, #Mem/vCPU: 4GB
> >
> > Analysis:
> >   * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
> >     the number of contentions of MMU lock and the "dirty memory time" on
> >     various VM spec.
> >     By using test command
> >     ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
> >     Below are the results:
> >     +-------+------------------------+-----------------------+
> >     | #vCPU | dirty memory time (ms) | number of contentions |
> >     +-------+------------------------+-----------------------+
> >     | 1     | 926                    | 0                     |
> >     +-------+------------------------+-----------------------+
> >     | 2     | 1189                   | 4732558               |
> >     +-------+------------------------+-----------------------+
> >     | 4     | 2503                   | 11527185              |
> >     +-------+------------------------+-----------------------+
> >     | 8     | 5069                   | 24881677              |
> >     +-------+------------------------+-----------------------+
> >     | 16    | 10340                  | 50347956              |
> >     +-------+------------------------+-----------------------+
> >     | 32    | 20351                  | 100605720             |
> >     +-------+------------------------+-----------------------+
> >     | 64    | 40994                  | 201442478             |
> >     +-------+------------------------+-----------------------+
> >
> >   * From the test results above, the "dirty memory time" and the number of
> >     MMU lock contention scale with the number of vCPUs. That means all the
> >     dirty memory operations from all vCPU threads have been serialized by
> >     the MMU lock. Further analysis also shows that the permission relaxation
> >     during dirty logging is where vCPU threads get serialized.
> >
> > Solution:
> >   * On ARM64, there is no mechanism as PML (Page Modification Logging) and
> >     the dirty-bit solution for dirty logging is much complicated compared to
> >     the write-protection solution. The straight way to reduce the guest
> >     performance degradation is to enhance the concurrency for the permission
> >     fault path during dirty logging.
> >   * In this patch, we only put leaf PTE permission relaxation for dirty
> >     logging under read lock, all others would go under write lock.
> >     Below are the results based on the solution:
> >     +-------+------------------------+
> >     | #vCPU | dirty memory time (ms) |
> >     +-------+------------------------+
> >     | 1     | 803                    |
> >     +-------+------------------------+
> >     | 2     | 843                    |
> >     +-------+------------------------+
> >     | 4     | 942                    |
> >     +-------+------------------------+
> >     | 8     | 1458                   |
> >     +-------+------------------------+
> >     | 16    | 2853                   |
> >     +-------+------------------------+
> >     | 32    | 5886                   |
> >     +-------+------------------------+
> >     | 64    | 12190                  |
> >     +-------+------------------------+
>
> Just curious, do yo know why is time still doubling (roughly) with the
> number of cpus? maybe you performed another experiment or have some
> guess(es).
Yes. it is from the serialization caused by TLB flush whenever the
permission is relaxed. I tried test by removing the TLB flushes (of
course it shouldn't be removed), the time would be close to a constant
no matter the number of vCPUs.
>
> Thanks,
> Ricardo
>
> >     All "dirty memory time" have been reduced by more than 60% when the
> >     number of vCPU grows.
> >
> > ---
> >
> > Jing Zhang (3):
> >   KVM: arm64: Use read/write spin lock for MMU protection
> >   KVM: arm64: Add fast path to handle permission relaxation during dirty
> >     logging
> >   KVM: selftests: Add vgic initialization for dirty log perf test for
> >     ARM
> >
> >  arch/arm64/include/asm/kvm_host.h             |  2 +
> >  arch/arm64/kvm/mmu.c                          | 86 +++++++++++++++----
> >  .../selftests/kvm/dirty_log_perf_test.c       | 10 +++
> >  3 files changed, 80 insertions(+), 18 deletions(-)
> >
> >
> > base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
> > --
> > 2.34.1.575.g55b058a8bb-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
Thanks,
Jing
