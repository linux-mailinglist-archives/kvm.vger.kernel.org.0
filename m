Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B361568DC50
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjBGO6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbjBGO6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:58:39 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C0419F24
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 06:58:19 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id i38so4828230eda.1
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 06:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m9dXzspMSenNlI5oCamUoCDWEueYdcmA62RT2TViylY=;
        b=2moa32bRD5/aRbpTqfOpVvFxqg7F3DCkT6Wwjk1WD8tGYkbbmJD2dCA0NnLITyBwDW
         S9mZwGy8VJynNqb8rK2CZ9NNE502+WK61EqEs3OOMHe1+j3HZh80Pw30dIUGw/ccRwh+
         e7c5vhKdu0c0W4yGNb/Cb7ZT8V1sV5QZ7ksxme7irlkrEonCcyf4FlaoxQCZFvchNTm6
         h52Q7C4WR2MEzDjmVQoZGr3O5N+Z2gbBatLnTR9eYdSV8NUC6YMYNTrQHQYyjnu8BSTL
         xGL/HtFfuEKDGQ36ggD4tXyXntLsGSjQayEROksSwwAKdYzAnGouK+NjMykJdCAftYoi
         UAIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m9dXzspMSenNlI5oCamUoCDWEueYdcmA62RT2TViylY=;
        b=v4irisei4heIvrabA0nQ8+e8TpATEH8qu8Gzp4EwkLs8OCU6GMRb6eFo/RpTtaIgo6
         7XDjp/Zludtir9JygVQ/09E+LUhQyYEbfyN2UdVkILuy+z8orAnUTxYdpv0EYePRyEJi
         iUW/tAAYdWmIFpYUrknOo/14vR0cF+yz3RvYmoESRXq/IHj+u1/+pjUHqwWxoUhPa99Q
         qtWqcB6IMTwijxHBHEfeqYW/nZwKscDMzG6bSzQfIWvp2iBXr7xcasOe7LUVlRfFu7i5
         wvfk1J/NPpRTP0npW8z7/cTKce1+PqBUwhumDcZoONk9CDTs4SzNp0himJ/UhvEHCwih
         lH6Q==
X-Gm-Message-State: AO0yUKUGgbdK5XE1A2pA8exsGb7ruc2VriE9Dpm/OS1iBICIyHqEjbK0
        poNTnOP5hezuGgnPbihiHumyYWgeNwDVatCZJGo5bQFuKuaeaA==
X-Google-Smtp-Source: AK7set9ktBVamZDOe0rLwj4ElOxpqxvlknofQcBsPZjUtzWEjZj6aoCr5xhjGxwbLh0FKu5sHXjKgb9NqDrBX+NfYSs=
X-Received: by 2002:a50:cd17:0:b0:4aa:bb33:1368 with SMTP id
 z23-20020a50cd17000000b004aabb331368mr713976edi.3.1675781896444; Tue, 07 Feb
 2023 06:58:16 -0800 (PST)
MIME-Version: 1.0
References: <20230207095529.1787260-1-atishp@rivosinc.com>
In-Reply-To: <20230207095529.1787260-1-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 7 Feb 2023 20:28:05 +0530
Message-ID: <CAAhSdy2jfD6ieiwkO7Mcdsb7DeCE4A86H6usTSmuWKpnHter_A@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] KVM perf support
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 7, 2023 at 3:26 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> This series extends perf support for KVM. The KVM implementation relies
> on the SBI PMU extension and trap n emulation of hpmcounter CSRs.
> The KVM implementation exposes the virtual counters to the guest and internally
> manage the counters using kernel perf counters.
>
> This series doesn't support the counter overflow as the Sscofpmf extension
> doesn't allow trap & emulation mechanism of scountovf CSR yet. The required
> changes to allow that are being under discussions. Supporting overflow interrupt
> also requires AIA interrupt filtering support.
>
> perf stat works in kvm guests with this series.
>
> Here is example of running perf stat in a guest running in KVM.
>
> ===========================================================================
> / # /host/apps/perf stat -e instructions -e cycles -e r8000000000000005 \
> > -e r8000000000000006 -e r8000000000000007 -e r8000000000000008 \
> > -e r800000000000000a perf bench sched messaging -g 10 -l 10
>
> # Running 'sched/messaging' benchmark:
> # 20 sender and receiver processes per group
> # 10 groups == 400 processes run
>
>      Total time: 7.769 [sec]
>
>  Performance counter stats for 'perf bench sched messaging -g 10 -l 10':
>
>        73556259604      cycles
>        73387266056      instructions              #    1.00  insn per cycle
>                  0      dTLB-store-misses
>                  0      iTLB-load-misses
>                  0      r8000000000000005
>               2595      r8000000000000006
>               2272      r8000000000000007
>                 10      r8000000000000008
>                  0      r800000000000000a
>
>       12.173720400 seconds time elapsed
>
>        1.002716000 seconds user
>       21.931047000 seconds sys
>
>
> Note: The SBI_PMU_FW_SET_TIMER (eventid : r8000000000000005) is zero
> as kvm guest supports sstc now.
>
> This series can be found here as well.
> https://github.com/atishp04/linux/tree/kvm_perf_v6
>
> TODO:
> 1. Add sscofpmf support.
> 2. Add One reg interface for the following operations:
>         1. Enable/Disable PMU (should it at VM level rather than vcpu ?)
>         2. Number of hpmcounter and width of the counters
>         3. Init PMU
>         4. Allow guest user to access cycle & instret without trapping
> 3. Move counter mask to a bitmask instead of unsigned long so that it can work
>    for RV32 systems where number of total counters are more than 32.
>    This will also accomodate future systems which may define maximum counters
>    to be more than 64.
>
> Changes from v5->v6:
> 1. Addressed remainig RB tags.
> 2. Rebased on kvm-queue which already has merged first 6 patches from v5.
> 3. Added static time compilation checks for max counters.
> 4. Addressed other nit comments.
>
> Changes from v4->v5:
> 1. Few checkpatch --strict error fixes.
> 2. Some other minor nit comment addressed.
> 3. Fixed an issue around counter indexing.
>
> Changes from v3->v4:
> 1. Addressed all the comments on v3.
> 2. Modified the vcpu_pmu_init to void return type.
> 3. Redirect illegal instruction trap to guest for invalid hpmcounter access
>    instead of exiting to the userpsace.
> 4. Got rid of unecessary error messages.
>
> Changes v2->v3:
> 1. Changed the exported functions to GPL only export.
> 2. Addressed all the nit comments on v2.
> 3. Split non-kvm related changes into separate patches.
> 4. Reorgainze the PATCH 11 and 10 based on Drew's suggestions.
>
> Changes from v1->v2:
> 1. Addressed comments from Andrew.
> 2. Removed kvpmu sanity check.
> 3. Added a kvm pmu init flag and the sanity check to probe function.
> 4. Improved the linux vs sbi error code handling.
>
>
> Atish Patra (8):
> RISC-V: KVM: Add skeleton support for perf
> RISC-V: KVM: Add SBI PMU extension support
> RISC-V: KVM: Make PMU functionality depend on Sscofpmf
> RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
> RISC-V: KVM: Implement trap & emulate for hpmcounters
> RISC-V: KVM: Implement perf support without sampling
> RISC-V: KVM: Support firmware events
> RISC-V: KVM: Increment firmware pmu events

I have queued this series for Linux-6.3

Thanks,
Anup

>
> arch/riscv/include/asm/kvm_host.h     |   4 +
> arch/riscv/include/asm/kvm_vcpu_pmu.h | 108 +++++
> arch/riscv/kvm/Makefile               |   1 +
> arch/riscv/kvm/main.c                 |   3 +-
> arch/riscv/kvm/tlb.c                  |   4 +
> arch/riscv/kvm/vcpu.c                 |   7 +
> arch/riscv/kvm/vcpu_insn.c            |   4 +-
> arch/riscv/kvm/vcpu_pmu.c             | 630 ++++++++++++++++++++++++++
> arch/riscv/kvm/vcpu_sbi.c             |  11 +
> arch/riscv/kvm/vcpu_sbi_pmu.c         |  86 ++++
> arch/riscv/kvm/vcpu_sbi_replace.c     |   7 +
> 11 files changed, 863 insertions(+), 2 deletions(-)
> create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
> create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
>
> --
> 2.25.1
>
