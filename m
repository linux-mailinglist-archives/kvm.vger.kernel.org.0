Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17858590853
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 23:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiHKVty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 17:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiHKVtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 17:49:53 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EA99F77A
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:49:51 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 24so1763430pgr.7
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc;
        bh=a6547274K2iHeQNpwwXuIMlyGaHvz13NtJhgq6J2+CU=;
        b=0eEqkfey7J4G19PaVOI/piHoBJuBvI0VNHZvD59Ma+ludVEtEC8D3xz5dU8dWCU861
         WNxZnA83yYBS2kbC0O8fsTwoCR5QpFaCZB8pHTnCAZ0h/eoofy5djcnzBjZVA/I82OOL
         UVZ/nF3TmDov/7R5SfGsqn94Ms8wGGaVLDBt1ULekYRHENIKuUNBC1nnBq+up9Q4rnia
         oyAyidS17Hm3JkJK8fWY6UXioTj3jErFXKs/lFSlucN39J0YgySyLzeZAWrcML+FBQIU
         DY0MZZ0KeGCIxXcYFMN7EmUFGmH4XTRxTEk9yevc58KuX/iGdWnnaZEoHBMKycNAdft/
         Dtyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc;
        bh=a6547274K2iHeQNpwwXuIMlyGaHvz13NtJhgq6J2+CU=;
        b=6KMBNaB9ZBEMhlUUz+Ge+Cz0YbN6lgR86qw0dxNA6B7GOwHA/p9NOZpk03xFS0NN0l
         f85JxND8CBzKL0kkycwEDi9xO91RQndLUgRJXMtotR1aIlDsfJHfQfB1no+a73+9B49C
         25m5s7Cx6MWPiSjCEwNVprKAyXvMrdUbKPJidBGlBWv7rLCLDvLtMHnOk8/eaLhyaMIP
         PxMTC/Gb1YO6iq6Vm/K0PhfGk95xtj02b9gyPTua7CcTMnnSh/9MGSgqzjCANok9Nlwu
         FpCOugCrOjCe2qH0WgT5Oq80R6myJNe3UF7PE6HdyyAgArrJIcbEd7cFWeDhcIfpvf+4
         dCDw==
X-Gm-Message-State: ACgBeo1pP6v/tNWWenGAHkj1YBZoREFEcZUAxVBIsxWDBOAca3rTBmPT
        fKko1KZrJUWrLmTC4xBWsruBnw==
X-Google-Smtp-Source: AA6agR4dInN19yKFsA3LGylGiOASG3Dp6LBKaYH3f0WnCSF91Nk9WeBWvRzf+9+x0ZP4WM+mrQ0b1A==
X-Received: by 2002:a63:5947:0:b0:41d:d4ea:6c87 with SMTP id j7-20020a635947000000b0041dd4ea6c87mr752298pgm.528.1660254591255;
        Thu, 11 Aug 2022 14:49:51 -0700 (PDT)
Received: from localhost ([50.221.140.186])
        by smtp.gmail.com with ESMTPSA id r1-20020aa79ec1000000b0053249b67215sm161690pfq.131.2022.08.11.14.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 14:49:50 -0700 (PDT)
Date:   Thu, 11 Aug 2022 14:49:50 -0700 (PDT)
X-Google-Original-Date: Thu, 11 Aug 2022 14:49:38 PDT (-0700)
Subject:     Re: [PATCH v7 0/4] Add Sstc extension support
In-Reply-To: <CAAhSdy2UDwZYK+EaKHPXLxyKUMv-OX02EdaBDBgjNF0jdDJ7xQ@mail.gmail.com>
CC:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        aou@eecs.berkeley.edu, atishp@atishpatra.org,
        daniel.lezcano@linaro.org, guoren@kernel.org, heiko@sntech.de,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, pbonzini@redhat.com,
        Paul Walmsley <paul.walmsley@sifive.com>, robh@kernel.org,
        tglx@linutronix.de, research_trasio@irq.a4lg.com, wefu@redhat.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     anup@brainfault.org
Message-ID: <mhng-368a1ddb-43d3-4d61-934b-3916c63005d4@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jul 2022 21:47:06 PDT (-0700), anup@brainfault.org wrote:
> Hi Palmer,
>
> On Fri, Jul 22, 2022 at 10:20 PM Atish Patra <atishp@rivosinc.com> wrote:
>>
>> This series implements Sstc extension support which was ratified recently.
>> Before the Sstc extension, an SBI call is necessary to generate timer
>> interrupts as only M-mode have access to the timecompare registers. Thus,
>> there is significant latency to generate timer interrupts at kernel.
>> For virtualized enviornments, its even worse as the KVM handles the SBI call
>> and uses a software timer to emulate the timecomapre register.
>>
>> Sstc extension solves both these problems by defining a stimecmp/vstimecmp
>> at supervisor (host/guest) level. It allows kernel to program a timer and
>> recieve interrupt without supervisor execution enviornment (M-mode/HS mode)
>> intervention.
>>
>> KVM directly updates the vstimecmp as well if the guest kernel invokes the SBI
>> call instead of updating stimecmp directly. This is required because KVM will
>> enable sstc extension if the hardware supports it unless the VMM explicitly
>> disables it for that guest. The hardware is expected to compare the
>> vstimecmp at every cycle if sstc is enabled and any stale value in vstimecmp
>> will lead to spurious timer interrupts. This also helps maintaining the
>> backward compatibility with older kernels.
>>
>> Similary, the M-mode firmware(OpenSBI) uses stimecmp for older kernel
>> without sstc support as STIP bit in mip is read only for hardware with sstc.
>>
>> The PATCH 1 & 2 enables the basic infrastructure around Sstc extension while
>> PATCH 3 lets kernel use the Sstc extension if it is available in hardware.
>> PATCH 4 implements the Sstc extension in KVM.
>>
>> This series has been tested on Qemu(RV32 & RV64) with additional patches in
>> Qemu[2]. This series can also be found at [3].
>>
>> Changes from v6->v7:
>> 1. Fixed a compilation error reported by 0-day bot.
>>
>> Changes from v5->v6:
>> 1. Moved SSTC extension enum below SVPBMT.
>>
>> Changes from v4->v5:
>> 1. Added RB tag.
>> 2. Changed the pr-format.
>> 3. Rebased on 5.19-rc7 and kvm-queue.
>> 4. Moved the henvcfg modification from hardware enable to vcpu_load.
>>
>> Changes from v3->v4:
>> 1. Rebased on 5.18-rc6
>> 2. Unified vstimemp & next_cycles.
>> 3. Addressed comments in PATCH 3 & 4.
>>
>> Changes from v2->v3:
>> 1. Dropped unrelated KVM fixes from this series.
>> 2. Rebased on 5.18-rc3.
>>
>> Changes from v1->v2:
>> 1. Separate the static key from kvm usage
>> 2. Makde the sstc specific static key local to the driver/clocksource
>> 3. Moved the vstimecmp update code to the vcpu_timer
>> 4. Used function pointers instead of static key to invoke vstimecmp vs
>>    hrtimer at the run time. This will help in future for migration of vms
>>    from/to sstc enabled hardware to non-sstc enabled hardware.
>> 5. Unified the vstimer & timer to 1 timer as only one of them will be used
>>    at runtime.
>>
>> [1] https://drive.google.com/file/d/1m84Re2yK8m_vbW7TspvevCDR82MOBaSX/view
>> [2] https://github.com/atishp04/qemu/tree/sstc_v6
>> [3] https://github.com/atishp04/linux/tree/sstc_v7
>>
>> Atish Patra (4):
>> RISC-V: Add SSTC extension CSR details
>> RISC-V: Enable sstc extension parsing from DT
>> RISC-V: Prefer sstc extension if available
>> RISC-V: KVM: Support sstc extension
>
> The PATCH4 is dependent on the KVM patches in queue for 5.20.
>
> I suggest you take PATCH1, PATCH2 and PATCH3. I will send
> PATCH4 in second batch/PR for 5.20 assuming you will send the
> first three patches in your first PR for 5.20
>
> Does this sound okay to you ?

Sorry for being slow here, I just merged the non-KVM ones onto 
riscv/for-next.  LMK if you want me to try and sort out the KVM bits, 
the branch base is at palmer/riscv-sstc assuming that's easier for you 
to just merge in locally.

>
> Regards,
> Anup
>
>>
>> arch/riscv/include/asm/csr.h            |   5 +
>> arch/riscv/include/asm/hwcap.h          |   1 +
>> arch/riscv/include/asm/kvm_vcpu_timer.h |   7 ++
>> arch/riscv/include/uapi/asm/kvm.h       |   1 +
>> arch/riscv/kernel/cpu.c                 |   1 +
>> arch/riscv/kernel/cpufeature.c          |   1 +
>> arch/riscv/kvm/vcpu.c                   |   8 +-
>> arch/riscv/kvm/vcpu_timer.c             | 144 +++++++++++++++++++++++-
>> drivers/clocksource/timer-riscv.c       |  25 +++-
>> 9 files changed, 185 insertions(+), 8 deletions(-)
>>
>> --
>> 2.25.1
>>
