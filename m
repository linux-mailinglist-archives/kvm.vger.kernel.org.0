Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF46FD067
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 23:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbjEIVA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 17:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbjEIVAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 17:00:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99025B8A
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 13:59:48 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-517bdc9e81dso3287017a12.1
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 13:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683665972; x=1686257972;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sRNwjF/QqX1epaJYQ7mB/uTWXlxaLNIreg4MF5XVAqs=;
        b=sJ6DYWOBIbP51DJb+vUESwI114MgJZhg3ivrKedeqIcHCpM2HidqvWx1Dmw66vxfzU
         T6lBSdj+pFXlK4RNDfpnAvuqFMEYKE7KmI+QlkIzL0ju+H0JtyyO5xztrWvRcYxUJefg
         1CckBbsd5GSg158H0y7CfpOgwjwMHeuDeZSxQqc7AGIjAd7tD89ZAdEbBUPknTSNsWBQ
         JHkTTMdF1tsQhT/UPG5NYM6aafgWohhTRUkf9OJWtTQEwf2YAtkYq+CYRYkvwEWPEjNB
         VYVglGktg1FuDvayxy7uvOBXafScMOp096/gFwUbTgiTiJn5gEB/fZ/zCunxblWI+b1B
         4Elw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683665972; x=1686257972;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRNwjF/QqX1epaJYQ7mB/uTWXlxaLNIreg4MF5XVAqs=;
        b=QEalw6gMUCQk32OHjfGFr8C0mA5NGhXV4HH8N1iAKpEYBIKI8glXULXNT+JzckDg8I
         vCvI1OfntMk+OiHBGsPdiKXl9MOkM5Xql815CW5nqp6SURbVeR/q5KX/PAEcbi1x5GQe
         ns8e4qcgiz6jRed5+SqNHXgGnpsg8HDurqpfQXqgJchSXPGr9y82WTC+PiQeUn3fcQdq
         p97LgSIFmQock4oosuFyErQhedvbeuNrLasX1xxn7ObtVWwOOfpk4dFTABoAWncrly1N
         j+LNtBL8Ia+QZgsZ+hDe2rzx2RsHd0V4cNxbH3FkUIgWf915AhzF89o26MxS/jKev8Lg
         DCQA==
X-Gm-Message-State: AC+VfDwZdB1kXUJD7waFzr9B3p4d01yvxBjLxjcGYwtftUJB/4/GqgRR
        NJ3QqHasWBX4fYKZ7uvhrst5lA==
X-Google-Smtp-Source: ACHHUZ42hHJlMBrNKSxQO840Ewm86ykfSWwmvnQEdv+Vcvvd1W4NaJnDUdGOkv/o60jkBbPOv96lUw==
X-Received: by 2002:a17:902:e54b:b0:1ac:712d:2032 with SMTP id n11-20020a170902e54b00b001ac712d2032mr11657454plf.50.1683665972390;
        Tue, 09 May 2023 13:59:32 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id s23-20020a170902a51700b001a1d553de0fsm2029485plq.271.2023.05.09.13.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 13:59:31 -0700 (PDT)
Date:   Tue, 09 May 2023 13:59:31 -0700 (PDT)
X-Google-Original-Date: Tue, 09 May 2023 13:59:02 PDT (-0700)
Subject:     Re: [PATCH -next v19 00/24] riscv: Add vector ISA support
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        andy.chiu@sifive.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-374502a5-c700-441d-925f-94fd5e3758aa@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 03:30:09 PDT (-0700), andy.chiu@sifive.com wrote:
> This patchset is implemented based on vector 1.0 spec to add vector support
> in riscv Linux kernel. There are some assumptions for this implementations.
>
> 1. We assume all harts has the same ISA in the system.
> 2. We disable vector in both kernel and user space [1] by default. Only
>    enable an user's vector after an illegal instruction trap where it
>    actually starts executing vector (the first-use trap [2]).
> 3. We detect "riscv,isa" to determine whether vector is support or not.
>
> We defined a new structure __riscv_v_ext_state in struct thread_struct to
> save/restore the vector related registers. It is used for both kernel space
> and user space.
>  - In kernel space, the datap pointer in __riscv_v_ext_state will be
>    allocated to save vector registers.
>  - In user space,
> 	- In signal handler of user space, the structure is placed
> 	  right after __riscv_ctx_hdr, which is embedded in fp reserved
> 	  aera. This is required to avoid ABI break [2]. And datap points
> 	  to the end of __riscv_v_ext_state.
> 	- In ptrace, the data will be put in ubuf in which we use
> 	  riscv_vr_get()/riscv_vr_set() to get or set the
> 	  __riscv_v_ext_state data structure from/to it, datap pointer
> 	  would be zeroed and vector registers will be copied to the
> 	  address right after the __riscv_v_ext_state structure in ubuf.
>
> This patchset is rebased to v6.4-rc1 and it is tested by running several
> vector programs simultaneously. It delivers signals correctly in a test
> where we can see a valid ucontext_t in a signal handler, and a correct V
> context returing back from it. And the ptrace interface is tested by
> PTRACE_{GET,SET}REGSET. Lastly, KVM is tested by running above tests in
> a guest using the same kernel image. All tests are done on an rv64gcv
> virt QEMU.

Thanks for handling these.  Looks like there's some minor comments 
already, with at least the hwprobe issue being a proper bug.  I'll try 
to take a look through the rest of this ASAP, with any luck we can get 
this into linux-next early in the cycle.

>
> Source tree:
> https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v19
>
> Links:
>  - [1] https://lore.kernel.org/all/20220921214439.1491510-17-stillson@rivosinc.com/
>  - [2] https://lore.kernel.org/all/73c0124c-4794-6e40-460c-b26df407f322@rivosinc.com/T/#u
>  - [3] https://lore.kernel.org/all/20230128082847.3055316-1-apatel@ventanamicro.com/
>
> Updated patches: 6, 8, 14 (conflict), 15 (conflict), 19 (conflict), 23
> New patches: 3, 20, 21, 24
> Unchanged patches: 1, 2, 4, 5, 7, 9, 10, 11, 12, 13, 16, 17, 18, 22
>
> ---
> Changelog V19
>  - Rebase to the latest -next branch (at 6.4-rc1 ac9a786). Solve
>    conflicts at patch 14, 15, and 19.
>  - Add a sysctl, and prctl intefaces for userspace Vector control, and a
>    document for it. (patch 20, 21, 24)
>  - Add a Kconfig RISCV_V_DISABLE to set the default value of userspace
>    Vector enablement status at compile-time. (patch 23)
>  - Allow hwprobe interface to probe Vector. (patch 3)
>  - Fix typos and commit msg at patch 6 and 8.
>
> Changelog V18
>  - Rebase to the latest -next branch (at 9c2598d)
>  - patch 7: Detect inconsistent VLEN setup on an SMP system (Heiko).
>  - patch 10: Add blank lines (Heiko)
>  - patch 10: Return immediately in insn_is_vector() if an insn matches (Heiko)
>  - patch 11: Use sizeof(vstate->datap) instead of sizeof(void*) (Eike)
>
> Changelog V17
>  - Rebase to the latest -next branch (at e45d6a5):
>    - Solve conflicts at 9 and 13 due to generic entry
>    - Use generic entry in do_trap_insn_illegal() trap handler
>
> Changelog V16
>  - Rebase to the latest for-next (at 4b74077):
>  - Solve conflicts at 7, and 17
>  - Use as-instr to detect if assembler supports .option arch directive
>    and remove dependency from GAS, for both ZBB and V.
>  - Cleanup code in KVM vector
>  - Address issue reported by sparse
>  - Refine code:
>    - Fix a mixed-use of space/tab
>    - Remove new lines at the end of file
>
> Changelog V15
>  - Rebase to risc-v -next (v6.3-rc1)
>  - Make V depend on FD in Kconfig according to the spec and shut off v
>    properly.
>  - Fix a syntax error for clang build. But mark RISCV_ISA_V GAS only due
>    to https://reviews.llvm.org/D123515
>  - Use scratch reg in inline asm instead of t4.
>  - Refine code.
>  - Cleanup per-patch changelogs.
>
> Changelog V14
>  - Rebase to risc-v -next (v6.2-rc7)
>  - Use TOOLCHAIN_HAS_V to detect if we can enable Vector. And refine
>    KBUILD_CFLAGS to remove v from default compile option.
>  - Drop illegal instruction handling patch in kvm and leave it to a
>    independent series[3]. The series has merged into 6.3-rc1
>  - Move KVM_RISCV_ISA_EXT_V to the end of enum to prevent potential ABI
>    breaks.
>  - Use PT_SIZE_ON_STACK instead of PT_SIZE to fit alignment. Also,
>    remove panic log from v13 (15/19) because it is no longer relevant.
>  - Rewrite insn_is_vector for better structuring (change if-else chain to
>    a switch)
>  - Fix compilation error in the middle of the series
>  - Validate size of the alternative signal frame if V is enabled
>    whenever:
>      - The user call sigaltstack to update altstack
>      - A signal is being delivered
>  - Rename __riscv_v_state to __riscv_v_ext_state.
>  - Add riscv_v_ prefix and rename rvv appropriately
>  - Organize riscv_v_vsize setup code into vector.c
>  - Address the issue mentioned by Heiko on !FPU case
>  - Honor orignal authors that got changed accidentally in v13 4,5,6
>
> Changelog V13
>  - Rebase to latest risc-v next (v6.2-rc1)
>  - vineetg: Re-organize the series to comply with bisect-ability
>  - andy.chiu: Improve task switch with inline assembly
>  - Re-structure the signal frame to avoid user ABI break.
>  - Implemnt first-use trap and drop prctl for per-task V state
>    enablement. Also, redirect this trap from hs to vs for kvm setup.
>  - Do not expose V context in ptrace/sigframe until the task start using
>    V. But still reserve V context for size ofsigframe reported by auxv.
>  - Drop the kernel mode vector and leave it to another (future) series.
>
> Changelog V12 (Chris)
>  - rebases to some point after v5.18-rc6
>  - add prctl to control per-process V state
>
> Chnagelog V10
>  - Rebase to v5.18-rc6
>  - Merge several patches
>  - Refine codes
>  - Fix bugs
>  - Add kvm vector support
>
> Changelog V9
>  - Rebase to v5.15
>  - Merge several patches
>  - Refine codes
>  - Fix a kernel panic issue
>
> Changelog V8
>  - Rebase to v5.14
>  - Refine struct __riscv_v_ext_state with struct __riscv_ctx_hdr
>  - Refine has_vector into a static key
>  - Defined __reserved space in struct sigcontext for vector and future extensions
>
> Changelog V7
>  - Add support for kernel mode vector
>  - Add vector extension XOR implementation
>  - Optimize task switch codes of vector
>  - Allocate space for vector registers in start_thread()
>  - Fix an illegal instruction exception when accessing vlenb
>  - Optimize vector registers initialization
>  - Initialize vector registers with proper vsetvli then it can work normally
>  - Refine ptrace porting due to generic API changed
>  - Code clean up
>
> Changelog V6
>  - Replace vle.v/vse.v instructions with vle8.v/vse8.v based on 0.9 spec
>  - Add comments based on mailinglist feedback
>  - Fix rv32 build error
>
> Changelog V5
>  - Using regset_size() correctly in generic ptrace
>  - Fix the ptrace porting
>  - Fix compile warning
>
> Changelog V4
>  - Support dynamic vlen
>  - Fix bugs: lazy save/resotre, not saving vtype
>  - Update VS bit offset based on latest vector spec
>  - Add new vector csr based on latest vector spec
>  - Code refine and removed unused macros
>
> Changelog V3
>  - Rebase linux-5.6-rc3 and tested with qemu
>  - Seperate patches with Anup's advice
>  - Give out a ABI puzzle with unlimited vlen
>
> Changelog V2
>  - Fixup typo "vecotr, fstate_save->vstate_save".
>  - Fixup wrong saved registers' length in vector.S.
>  - Seperate unrelated patches from this one.
>
> Andy Chiu (8):
>   riscv: hwprobe: Add support for RISCV_HWPROBE_BASE_BEHAVIOR_V
>   riscv: Allocate user's vector context in the first-use trap
>   riscv: signal: check fp-reserved words unconditionally
>   riscv: signal: validate altstack to reflect Vector
>   riscv: Add prctl controls for userspace vector management
>   riscv: Add sysctl to set the default vector rule for new processes
>   riscv: detect assembler support for .option arch
>   riscv: Add documentation for Vector
>
> Greentime Hu (9):
>   riscv: Add new csr defines related to vector extension
>   riscv: Clear vector regfile on bootup
>   riscv: Introduce Vector enable/disable helpers
>   riscv: Introduce riscv_v_vsize to record size of Vector context
>   riscv: Introduce struct/helpers to save/restore per-task Vector state
>   riscv: Add task switch support for vector
>   riscv: Add ptrace vector support
>   riscv: signal: Add sigcontext save/restore for vector
>   riscv: prevent stack corruption by reserving task_pt_regs(p) early
>
> Guo Ren (4):
>   riscv: Rename __switch_to_aux() -> fpu
>   riscv: Extending cpufeature.c to detect V-extension
>   riscv: Disable Vector Instructions for kernel itself
>   riscv: Enable Vector code to be built
>
> Vincent Chen (3):
>   riscv: signal: Report signal frame size to userspace via auxv
>   riscv: kvm: Add V extension to KVM ISA
>   riscv: KVM: Add vector lazy save/restore support
>
>  Documentation/riscv/hwprobe.rst          |  10 +
>  Documentation/riscv/index.rst            |   1 +
>  Documentation/riscv/vector.rst           | 128 +++++++++++
>  arch/riscv/Kconfig                       |  39 +++-
>  arch/riscv/Makefile                      |   6 +-
>  arch/riscv/include/asm/csr.h             |  18 +-
>  arch/riscv/include/asm/elf.h             |   9 +
>  arch/riscv/include/asm/hwcap.h           |   1 +
>  arch/riscv/include/asm/hwprobe.h         |   2 +-
>  arch/riscv/include/asm/insn.h            |  29 +++
>  arch/riscv/include/asm/kvm_host.h        |   2 +
>  arch/riscv/include/asm/kvm_vcpu_vector.h |  82 +++++++
>  arch/riscv/include/asm/processor.h       |  16 ++
>  arch/riscv/include/asm/switch_to.h       |   9 +-
>  arch/riscv/include/asm/thread_info.h     |   3 +
>  arch/riscv/include/asm/vector.h          | 184 ++++++++++++++++
>  arch/riscv/include/uapi/asm/auxvec.h     |   1 +
>  arch/riscv/include/uapi/asm/hwcap.h      |   1 +
>  arch/riscv/include/uapi/asm/hwprobe.h    |   3 +
>  arch/riscv/include/uapi/asm/kvm.h        |   8 +
>  arch/riscv/include/uapi/asm/ptrace.h     |  39 ++++
>  arch/riscv/include/uapi/asm/sigcontext.h |  16 +-
>  arch/riscv/kernel/Makefile               |   1 +
>  arch/riscv/kernel/cpufeature.c           |  13 ++
>  arch/riscv/kernel/entry.S                |   6 +-
>  arch/riscv/kernel/head.S                 |  41 +++-
>  arch/riscv/kernel/process.c              |  19 ++
>  arch/riscv/kernel/ptrace.c               |  70 ++++++
>  arch/riscv/kernel/setup.c                |   3 +
>  arch/riscv/kernel/signal.c               | 220 ++++++++++++++++---
>  arch/riscv/kernel/smpboot.c              |   7 +
>  arch/riscv/kernel/sys_riscv.c            |   9 +
>  arch/riscv/kernel/traps.c                |  26 ++-
>  arch/riscv/kernel/vector.c               | 266 +++++++++++++++++++++++
>  arch/riscv/kvm/Makefile                  |   1 +
>  arch/riscv/kvm/vcpu.c                    |  25 +++
>  arch/riscv/kvm/vcpu_vector.c             | 186 ++++++++++++++++
>  include/uapi/linux/elf.h                 |   1 +
>  include/uapi/linux/prctl.h               |  11 +
>  kernel/sys.c                             |  12 +
>  40 files changed, 1474 insertions(+), 50 deletions(-)
>  create mode 100644 Documentation/riscv/vector.rst
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_vector.h
>  create mode 100644 arch/riscv/include/asm/vector.h
>  create mode 100644 arch/riscv/kernel/vector.c
>  create mode 100644 arch/riscv/kvm/vcpu_vector.c
