Return-Path: <kvm+bounces-819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC547E2E5C
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 21:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D834C280D77
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 20:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6172C857;
	Mon,  6 Nov 2023 20:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxnJXSmH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D2629D11
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 20:42:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1956D7D
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 12:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699303373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nIbeoR7FArvGosJRrKLNWkopuKKdjMraBxoXduHpSoU=;
	b=CxnJXSmHJDp72jgVusH9oGKgEsLBXdl9RaFi1u6y1y7Y3iue1m08u1Q2m3yr5rAsL4eFU9
	JP3Qhv9WmpnuFj6hpvVPD3L/x6D8ydXZzVnhyP3fMjQ4GC8So653u5aTyr40jR83XH8ROs
	1A8UYGMGZb+Iy0NbIL9TgdK1T3iTk44=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-ZqEKth-MNrao1Zb8m4zF-A-1; Mon, 06 Nov 2023 15:42:50 -0500
X-MC-Unique: ZqEKth-MNrao1Zb8m4zF-A-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-5b1ff96d5b9so67910987b3.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 12:42:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699303370; x=1699908170;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIbeoR7FArvGosJRrKLNWkopuKKdjMraBxoXduHpSoU=;
        b=LRzPFOYMCDHqTQr0BATRRUOyQ2bKye9VZFJ5XhvC9epzT4UmWiheEMQQPBIayXY2AX
         wp5jbmO/WroE4C081OiF9Wbco11G7Og23WrTTWhHRnOcz59vk3nh8cFPHmPiCUsTmPU4
         ARFd6m8pFg0cp1h2/ZoeQZqRl7KwRraiCOS70Xdbo9C/Qzr5IOOA7M8+vp4nmKurluGA
         DR73SQtQWpivf3hPHqowPQ03Cp868XbbyQUJbVs9ObVoPTbuPTaHBPUVOp6OfjojBFDb
         /3OEDuL0rwigNYHbdrVX0HwQIsml8/NuIdGQfYo5iItPcvJsY3dYvgQEqWgeMKWWAwn+
         DcPg==
X-Gm-Message-State: AOJu0YyWtAwUt1keib+tgVitnP8SBcsGYKZi/+idJ70lhtwvcZanUafJ
	t/wsVCPAqyOA8d8xQWa4oRbIEsrUuKAbsQtq+LeQXVBOasWXKsl9eN7Su+2yrTioiCAT4veiUoD
	ZRXzGATC62BD+
X-Received: by 2002:a0d:e20c:0:b0:5a7:db27:7794 with SMTP id l12-20020a0de20c000000b005a7db277794mr11573837ywe.25.1699303370233;
        Mon, 06 Nov 2023 12:42:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwtd2X6F7/R7ZrTLh3R6r1mZwDFf6I2+lQzpb1LF3XnOH0G65oHruWj+GCEutdN8FtocsRJA==
X-Received: by 2002:a0d:e20c:0:b0:5a7:db27:7794 with SMTP id l12-20020a0de20c000000b005a7db277794mr11573819ywe.25.1699303369879;
        Mon, 06 Nov 2023 12:42:49 -0800 (PST)
Received: from redhat.com ([2804:1b3:a801:5cb:ba24:b17c:ecf0:ca67])
        by smtp.gmail.com with ESMTPSA id g3-20020a0ddd03000000b00594fff48796sm4754710ywe.75.2023.11.06.12.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 12:42:49 -0800 (PST)
Date: Mon, 6 Nov 2023 17:42:41 -0300
From: Leonardo Bras <leobras@redhat.com>
To: guoren@kernel.org
Cc: paul.walmsley@sifive.com, anup@brainfault.org, peterz@infradead.org,
	mingo@redhat.com, will@kernel.org, palmer@rivosinc.com,
	longman@redhat.com, boqun.feng@gmail.com, tglx@linutronix.de,
	paulmck@kernel.org, rostedt@goodmis.org, rdunlap@infradead.org,
	catalin.marinas@arm.com, conor.dooley@microchip.com,
	xiaoguang.xing@sophgo.com, bjorn@rivosinc.com,
	alexghiti@rivosinc.com, keescook@chromium.org,
	greentime.hu@sifive.com, ajones@ventanamicro.com,
	jszhang@kernel.org, wefu@redhat.com, wuwei2016@iscas.ac.cn,
	linux-arch@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-doc@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-csky@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V11 00/17] riscv: Add Native/Paravirt qspinlock support
Message-ID: <ZUlPwQVG4OTkighB@redhat.com>
References: <20230910082911.3378782-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230910082911.3378782-1-guoren@kernel.org>

On Sun, Sep 10, 2023 at 04:28:54AM -0400, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> patch[1 - 10]: Native   qspinlock
> patch[11 -17]: Paravirt qspinlock
> 
> patch[4]: Add prefetchw in qspinlock's xchg_tail when cpus >= 16k
> 
> This series based on:
>  - [RFC PATCH v5 0/5] Rework & improve riscv cmpxchg.h and atomic.h
>    https://lore.kernel.org/linux-riscv/20230810040349.92279-2-leobras@redhat.com/
>  - [PATCH V3] asm-generic: ticket-lock: Optimize arch_spin_value_unlocked
>    https://lore.kernel.org/linux-riscv/20230908154339.3250567-1-guoren@kernel.org/ 
> 
> I merge them into sg2042-master branch, then you could directly try it on
> sg2042 hardware platform:
> 
> https://github.com/guoren83/linux/tree/sg2042-master-qspinlock-64ilp32_v5
> 
> Use sophgo_mango_ubuntu_defconfig for sg2042 64/128 cores hardware
> platform.
> 
> Native qspinlock
> ================
> 
> This time we've proved the qspinlock on th1520 [1] & sg2042 [2], which
> gives stability and performance improvement. All T-HEAD processors have
> a strong LR/SC forward progress guarantee than the requirements of the
> ISA, which could satisfy the xchg_tail of native_qspinlock. Now,
> qspinlock has been run with us for more than 1 year, and we have enough
> confidence to enable it for all the T-HEAD processors. Of causes, we
> found a livelock problem with the qspinlock lock torture test from the
> CPU store merge buffer delay mechanism, which caused the queued spinlock
> becomes a dead ring and RCU warning to come out. We introduce a custom
> WRITE_ONCE to solve this. Do we need explicit ISA instruction to signal
> it? Or let hardware handle this.
> 
> We've tested the patch on SOPHGO sg2042 & th1520 and passed the stress
> test on Fedora & Ubuntu & OpenEuler ... Here is the performance
> comparison between qspinlock and ticket_lock on sg2042 (64 cores):
> 
> sysbench test=threads threads=32 yields=100 lock=8 (+13.8%):
>   queued_spinlock 0.5109/0.00
>   ticket_spinlock 0.5814/0.00
> 
> perf futex/hash (+6.7%):
>   queued_spinlock 1444393 operations/sec (+- 0.09%)
>   ticket_spinlock 1353215 operations/sec (+- 0.15%)
> 
> perf futex/wake-parallel (+8.6%):
>   queued_spinlock (waking 1/64 threads) in 0.0253 ms (+-2.90%)
>   ticket_spinlock (waking 1/64 threads) in 0.0275 ms (+-3.12%)
> 
> perf futex/requeue (+4.2%):
>   queued_spinlock Requeued 64 of 64 threads in 0.0785 ms (+-0.55%)
>   ticket_spinlock Requeued 64 of 64 threads in 0.0818 ms (+-4.12%)
> 
> System Benchmarks (+6.4%)
>   queued_spinlock:
>     System Benchmarks Index Values               BASELINE       RESULT    INDEX
>     Dhrystone 2 using register variables         116700.0  628613745.4  53865.8
>     Double-Precision Whetstone                       55.0     182422.8  33167.8
>     Execl Throughput                                 43.0      13116.6   3050.4
>     File Copy 1024 bufsize 2000 maxblocks          3960.0    7762306.2  19601.8
>     File Copy 256 bufsize 500 maxblocks            1655.0    3417556.8  20649.9
>     File Copy 4096 bufsize 8000 maxblocks          5800.0    7427995.7  12806.9
>     Pipe Throughput                               12440.0   23058600.5  18535.9
>     Pipe-based Context Switching                   4000.0    2835617.7   7089.0
>     Process Creation                                126.0      12537.3    995.0
>     Shell Scripts (1 concurrent)                     42.4      57057.4  13456.9
>     Shell Scripts (8 concurrent)                      6.0       7367.1  12278.5
>     System Call Overhead                          15000.0   33308301.3  22205.5
>                                                                        ========
>     System Benchmarks Index Score                                       12426.1
> 
>   ticket_spinlock:
>     System Benchmarks Index Values               BASELINE       RESULT    INDEX
>     Dhrystone 2 using register variables         116700.0  626541701.9  53688.2
>     Double-Precision Whetstone                       55.0     181921.0  33076.5
>     Execl Throughput                                 43.0      12625.1   2936.1
>     File Copy 1024 bufsize 2000 maxblocks          3960.0    6553792.9  16550.0
>     File Copy 256 bufsize 500 maxblocks            1655.0    3189231.6  19270.3
>     File Copy 4096 bufsize 8000 maxblocks          5800.0    7221277.0  12450.5
>     Pipe Throughput                               12440.0   20594018.7  16554.7
>     Pipe-based Context Switching                   4000.0    2571117.7   6427.8
>     Process Creation                                126.0      10798.4    857.0
>     Shell Scripts (1 concurrent)                     42.4      57227.5  13497.1
>     Shell Scripts (8 concurrent)                      6.0       7329.2  12215.3
>     System Call Overhead                          15000.0   30766778.4  20511.2
>                                                                        ========
>     System Benchmarks Index Score                                       11670.7
> 
> The qspinlock has a significant improvement on SOPHGO SG2042 64
> cores platform than the ticket_lock.
> 
> Paravirt qspinlock
> ==================
> 
> We implemented kvm_kick_cpu/kvm_wait_cpu and add tracepoints to observe the
> behaviors. Also, introduce a new SBI extension SBI_EXT_PVLOCK (0xAB0401). If the
> name and number are approved, I will send a formal proposal to the SBI spec.
> 

Hello Guo Ren,

Any update on this series?

Thanks!
Leo


> Changlog:
> V11:
>  - Based on Leonardo Bras's cmpxchg_small patches v5.
>  - Based on Guo Ren's Optimize arch_spin_value_unlocked patch v3.
>  - Remove abusing alternative framework and use jump_label instead.
>  - Introduce prefetch.w to improve T-HEAD processors' LR/SC forward progress
>    guarantee.
>  - Optimize qspinlock xchg_tail when NR_CPUS >= 16K.
> 
> V10:
> https://lore.kernel.org/linux-riscv/20230802164701.192791-1-guoren@kernel.org/
>  - Using an alternative framework instead of static_key_branch in the
>    asm/spinlock.h.
>  - Fixup store merge buffer problem, which causes qspinlock lock
>    torture test livelock.
>  - Add paravirt qspinlock support, include KVM backend
>  - Add Compact NUMA-awared qspinlock support 
> 
> V9:
> https://lore.kernel.org/linux-riscv/20220808071318.3335746-1-guoren@kernel.org/
>  - Cleanup generic ticket-lock code, (Using smp_mb__after_spinlock as
>    RCsc)
>  - Add qspinlock and combo-lock for riscv
>  - Add qspinlock to openrisc
>  - Use generic header in csky
>  - Optimize cmpxchg & atomic code
> 
> V8:
> https://lore.kernel.org/linux-riscv/20220724122517.1019187-1-guoren@kernel.org/
>  - Coding convention ticket fixup
>  - Move combo spinlock into riscv and simply asm-generic/spinlock.h
>  - Fixup xchg16 with wrong return value
>  - Add csky qspinlock
>  - Add combo & qspinlock & ticket-lock comparison
>  - Clean up unnecessary riscv acquire and release definitions
>  - Enable ARCH_INLINE_READ*/WRITE*/SPIN* for riscv & csky
> 
> V7:
> https://lore.kernel.org/linux-riscv/20220628081946.1999419-1-guoren@kernel.org/
>  - Add combo spinlock (ticket & queued) support
>  - Rename ticket_spinlock.h
>  - Remove unnecessary atomic_read in ticket_spin_value_unlocked  
> 
> V6:
> https://lore.kernel.org/linux-riscv/20220621144920.2945595-1-guoren@kernel.org/
>  - Fixup Clang compile problem Reported-by: kernel test robot
>  - Cleanup asm-generic/spinlock.h
>  - Remove changelog in patch main comment part, suggested by
>    Conor.Dooley
>  - Remove "default y if NUMA" in Kconfig
> 
> V5:
> https://lore.kernel.org/linux-riscv/20220620155404.1968739-1-guoren@kernel.org/
>  - Update comment with RISC-V forward guarantee feature.
>  - Back to V3 direction and optimize asm code.
> 
> V4:
> https://lore.kernel.org/linux-riscv/1616868399-82848-4-git-send-email-guoren@kernel.org/
>  - Remove custom sub-word xchg implementation
>  - Add ARCH_USE_QUEUED_SPINLOCKS_XCHG32 in locking/qspinlock
> 
> V3:
> https://lore.kernel.org/linux-riscv/1616658937-82063-1-git-send-email-guoren@kernel.org/
>  - Coding convention by Peter Zijlstra's advices
> 
> V2:
> https://lore.kernel.org/linux-riscv/1606225437-22948-2-git-send-email-guoren@kernel.org/
>  - Coding convention in cmpxchg.h
>  - Re-implement short xchg
>  - Remove char & cmpxchg implementations
> 
> V1:
> https://lore.kernel.org/linux-riscv/20190211043829.30096-1-michaeljclark@mac.com/
>  - Using cmpxchg loop to implement sub-word atomic
> 
> 
> Guo Ren (17):
>   asm-generic: ticket-lock: Reuse arch_spinlock_t of qspinlock
>   asm-generic: ticket-lock: Move into ticket_spinlock.h
>   riscv: Use Zicbop in arch_xchg when available
>   locking/qspinlock: Improve xchg_tail for number of cpus >= 16k
>   riscv: qspinlock: Add basic queued_spinlock support
>   riscv: qspinlock: Introduce combo spinlock
>   riscv: qspinlock: Introduce qspinlock param for command line
>   riscv: qspinlock: Add virt_spin_lock() support for KVM guest
>   riscv: qspinlock: errata: Add ERRATA_THEAD_WRITE_ONCE fixup
>   riscv: qspinlock: errata: Enable qspinlock for T-HEAD processors
>   RISC-V: paravirt: pvqspinlock: Add paravirt qspinlock skeleton
>   RISC-V: paravirt: pvqspinlock: Add nopvspin kernel parameter
>   RISC-V: paravirt: pvqspinlock: Add SBI implementation
>   RISC-V: paravirt: pvqspinlock: Add kconfig entry
>   RISC-V: paravirt: pvqspinlock: Add trace point for pv_kick/wait
>   RISC-V: paravirt: pvqspinlock: KVM: Add paravirt qspinlock skeleton
>   RISC-V: paravirt: pvqspinlock: KVM: Implement
>     kvm_sbi_ext_pvlock_kick_cpu()
> 
>  .../admin-guide/kernel-parameters.txt         |   8 +-
>  arch/riscv/Kconfig                            |  50 ++++++++
>  arch/riscv/Kconfig.errata                     |  19 +++
>  arch/riscv/errata/thead/errata.c              |  29 +++++
>  arch/riscv/include/asm/Kbuild                 |   2 +-
>  arch/riscv/include/asm/cmpxchg.h              |   4 +-
>  arch/riscv/include/asm/errata_list.h          |  13 --
>  arch/riscv/include/asm/hwcap.h                |   1 +
>  arch/riscv/include/asm/insn-def.h             |   5 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h         |   1 +
>  arch/riscv/include/asm/processor.h            |  13 ++
>  arch/riscv/include/asm/qspinlock.h            |  35 ++++++
>  arch/riscv/include/asm/qspinlock_paravirt.h   |  29 +++++
>  arch/riscv/include/asm/rwonce.h               |  24 ++++
>  arch/riscv/include/asm/sbi.h                  |  14 +++
>  arch/riscv/include/asm/spinlock.h             | 113 ++++++++++++++++++
>  arch/riscv/include/asm/vendorid_list.h        |  14 +++
>  arch/riscv/include/uapi/asm/kvm.h             |   1 +
>  arch/riscv/kernel/Makefile                    |   1 +
>  arch/riscv/kernel/cpufeature.c                |   1 +
>  arch/riscv/kernel/qspinlock_paravirt.c        |  83 +++++++++++++
>  arch/riscv/kernel/sbi.c                       |   2 +-
>  arch/riscv/kernel/setup.c                     |  60 ++++++++++
>  .../kernel/trace_events_filter_paravirt.h     |  60 ++++++++++
>  arch/riscv/kvm/Makefile                       |   1 +
>  arch/riscv/kvm/vcpu_sbi.c                     |   4 +
>  arch/riscv/kvm/vcpu_sbi_pvlock.c              |  57 +++++++++
>  include/asm-generic/rwonce.h                  |   2 +
>  include/asm-generic/spinlock.h                |  87 +-------------
>  include/asm-generic/spinlock_types.h          |  12 +-
>  include/asm-generic/ticket_spinlock.h         | 103 ++++++++++++++++
>  kernel/locking/qspinlock.c                    |   5 +-
>  32 files changed, 739 insertions(+), 114 deletions(-)
>  create mode 100644 arch/riscv/include/asm/qspinlock.h
>  create mode 100644 arch/riscv/include/asm/qspinlock_paravirt.h
>  create mode 100644 arch/riscv/include/asm/rwonce.h
>  create mode 100644 arch/riscv/include/asm/spinlock.h
>  create mode 100644 arch/riscv/kernel/qspinlock_paravirt.c
>  create mode 100644 arch/riscv/kernel/trace_events_filter_paravirt.h
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_pvlock.c
>  create mode 100644 include/asm-generic/ticket_spinlock.h
> 
> -- 
> 2.36.1
> 


