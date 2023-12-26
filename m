Return-Path: <kvm+bounces-5240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E51681E43A
	for <lists+kvm@lfdr.de>; Tue, 26 Dec 2023 01:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D0531C21BDD
	for <lists+kvm@lfdr.de>; Tue, 26 Dec 2023 00:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA41315A8;
	Tue, 26 Dec 2023 00:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjHlGvwN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E3DA29;
	Tue, 26 Dec 2023 00:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74847C433C8;
	Tue, 26 Dec 2023 00:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703550963;
	bh=NHdbFiqsifSTiK+myGWpMLxahvziN4vk1QnX3vAD/xI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rjHlGvwNgTOShocE/QLzg5emLQ8EoLisMuyX5Mgjrb/GFqLxEkjEue17lJevKsl3X
	 hgUrLrK5jghOZ2/+sGpLcaTF/d81n6XAgpeUDG4gZ8Ra7zq8GxkWhxA0AHHmlp5NsX
	 jPiGHnLAS05wXQ46MAgD33R9elmbS3hXtN9BZg1WinM1sLokQBzpsAyHTfpePYGc0h
	 94ys7niwqmjzucsIt7WGfn/HhoztH/u8CZKFkdTD0/mO27U9IXXaUgWKmRgei2sT3V
	 Bv6hG9gHMon3GM0rBsyXeWk1Dxqt/mM3WGSnbydIUqAGGrX6q3qnr5g1fer6LBh5sY
	 cs3pS6poIy2Lw==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-554cffbad2fso1114125a12.1;
        Mon, 25 Dec 2023 16:36:03 -0800 (PST)
X-Gm-Message-State: AOJu0YwbMY0BXwwxvzqRxf1OG5Tyo/qpSY6qwr/SiYKyFal5rwXUmfQy
	22Nkrhqa0Elr3y7x61+1cgZYdFW01fLfULsLON0=
X-Google-Smtp-Source: AGHT+IE/DGwHcZeEvOZIP8lchNXJdA2d9NxNnD9HVfrcsOGhHd6pzHxvV/RkMgS24DOoBI8q8XuLYEKI8vxwzqF1A68=
X-Received: by 2002:a50:8e49:0:b0:553:4257:969d with SMTP id
 9-20020a508e49000000b005534257969dmr3394385edx.66.1703550961867; Mon, 25 Dec
 2023 16:36:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231225125847.2778638-1-guoren@kernel.org>
In-Reply-To: <20231225125847.2778638-1-guoren@kernel.org>
From: Guo Ren <guoren@kernel.org>
Date: Tue, 26 Dec 2023 08:35:50 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRgd297NZqumBLMV0jmVqn2sQ3xjZ5sRuy9L7HXq+gU5Q@mail.gmail.com>
Message-ID: <CAJF2gTRgd297NZqumBLMV0jmVqn2sQ3xjZ5sRuy9L7HXq+gU5Q@mail.gmail.com>
Subject: Re: [PATCH V12 00/14] riscv: Add Native/Paravirt qspinlock support
To: Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	Guo Ren <guoren@linux.alibaba.com>, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	guoren@kernel.org, panqinglin2020@iscas.ac.cn, bjorn@rivosinc.com, 
	conor.dooley@microchip.com, leobras@redhat.com, peterz@infradead.org, 
	anup@brainfault.org, keescook@chromium.org, wuwei2016@iscas.ac.cn, 
	xiaoguang.xing@sophgo.com, chao.wei@sophgo.com, unicorn_wang@outlook.com, 
	uwu@icenowy.me, jszhang@kernel.org, wefu@redhat.com, atishp@atishpatra.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, I missed people on the list.
F.Y.I
Waiman Long <longman@redhat.com>
Boqun Feng <boqun.feng@gmail.com>

Here is Link:
https://lore.kernel.org/linux-riscv/20231225125847.2778638-1-guoren@kernel.=
org/


On Mon, Dec 25, 2023 at 8:59=E2=80=AFPM <guoren@kernel.org> wrote:
>
> From: Guo Ren <guoren@linux.alibaba.com>
>
> patch[1 - 8]: Native   qspinlock
> patch[9 -14]: Paravirt qspinlock
>
> This series based on:
>  - v6.7-rc7
>  - Rework & improve riscv cmpxchg.h and atomic.h
>    https://lore.kernel.org/linux-riscv/20230810040349.92279-2-leobras@red=
hat.com/
>
> You can directly try it:
> https://github.com/guoren83/linux/tree/qspinlock_v12
>
> Native qspinlock
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> WRITE_ONCE to solve this, which will be fixed in the next generation of
> hardware.
>
> We've tested the patch on SOPHGO sg2042 & th1520 and passed the stress
> test on Fedora & Ubuntu & OpenEuler ... Here is the performance
> comparison between qspinlock and ticket_lock on sg2042 (64 cores):
>
> sysbench test=3Dthreads threads=3D32 yields=3D100 lock=3D8 (+13.8%):
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
>
> System Benchmarks (+6.4%)
>   queued_spinlock:
>     System Benchmarks Index Values               BASELINE       RESULT   =
 INDEX
>     Dhrystone 2 using register variables         116700.0  628613745.4  5=
3865.8
>     Double-Precision Whetstone                       55.0     182422.8  3=
3167.8
>     Execl Throughput                                 43.0      13116.6   =
3050.4
>     File Copy 1024 bufsize 2000 maxblocks          3960.0    7762306.2  1=
9601.8
>     File Copy 256 bufsize 500 maxblocks            1655.0    3417556.8  2=
0649.9
>     File Copy 4096 bufsize 8000 maxblocks          5800.0    7427995.7  1=
2806.9
>     Pipe Throughput                               12440.0   23058600.5  1=
8535.9
>     Pipe-based Context Switching                   4000.0    2835617.7   =
7089.0
>     Process Creation                                126.0      12537.3   =
 995.0
>     Shell Scripts (1 concurrent)                     42.4      57057.4  1=
3456.9
>     Shell Scripts (8 concurrent)                      6.0       7367.1  1=
2278.5
>     System Call Overhead                          15000.0   33308301.3  2=
2205.5
>                                                                        =
=3D=3D=3D=3D=3D=3D=3D=3D
>     System Benchmarks Index Score                                       1=
2426.1
>
>   ticket_spinlock:
>     System Benchmarks Index Values               BASELINE       RESULT   =
 INDEX
>     Dhrystone 2 using register variables         116700.0  626541701.9  5=
3688.2
>     Double-Precision Whetstone                       55.0     181921.0  3=
3076.5
>     Execl Throughput                                 43.0      12625.1   =
2936.1
>     File Copy 1024 bufsize 2000 maxblocks          3960.0    6553792.9  1=
6550.0
>     File Copy 256 bufsize 500 maxblocks            1655.0    3189231.6  1=
9270.3
>     File Copy 4096 bufsize 8000 maxblocks          5800.0    7221277.0  1=
2450.5
>     Pipe Throughput                               12440.0   20594018.7  1=
6554.7
>     Pipe-based Context Switching                   4000.0    2571117.7   =
6427.8
>     Process Creation                                126.0      10798.4   =
 857.0
>     Shell Scripts (1 concurrent)                     42.4      57227.5  1=
3497.1
>     Shell Scripts (8 concurrent)                      6.0       7329.2  1=
2215.3
>     System Call Overhead                          15000.0   30766778.4  2=
0511.2
>                                                                        =
=3D=3D=3D=3D=3D=3D=3D=3D
>     System Benchmarks Index Score                                       1=
1670.7
>
> The qspinlock has a significant improvement on SOPHGO SG2042 64
> cores platform than the ticket_lock.
>
> Paravirt qspinlock
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> We implemented kvm_kick_cpu/kvm_wait_cpu and add tracepoints to observe
> the behaviors and introduce a new SBI extension SBI_EXT_PVLOCK.
>
> Changlog:
> V12:
>  - Remove force thead qspinlock with errata
>  - Separate Zicbop patch from this series
>  - Remove cpus >=3D 16 patch
>  - Cleanup rebase and move it on v6.7-rc7
>  - Reorder the coding struct with the last version's advice.
>
> V11:
> https://lore.kernel.org/linux-riscv/20230910082911.3378782-1-guoren@kerne=
l.org/
>  - Based on Leonardo Bras's cmpxchg_small patches v5.
>  - Based on Guo Ren's Optimize arch_spin_value_unlocked patch v3.
>  - Remove abusing alternative framework and use jump_label instead.
>  - Introduce prefetch.w to improve T-HEAD processors' LR/SC forward
>    progress guarantee.
>  - Optimize qspinlock xchg_tail when NR_CPUS >=3D 16K.
>
> V10:
> https://lore.kernel.org/linux-riscv/20230802164701.192791-1-guoren@kernel=
.org/
>  - Using an alternative framework instead of static_key_branch in the
>    asm/spinlock.h.
>  - Fixup store merge buffer problem, which causes qspinlock lock
>    torture test livelock.
>  - Add paravirt qspinlock support, include KVM backend
>  - Add Compact NUMA-awared qspinlock support
>
> V9:
> https://lore.kernel.org/linux-riscv/20220808071318.3335746-1-guoren@kerne=
l.org/
>  - Cleanup generic ticket-lock code, (Using smp_mb__after_spinlock as
>    RCsc)
>  - Add qspinlock and combo-lock for riscv
>  - Add qspinlock to openrisc
>  - Use generic header in csky
>  - Optimize cmpxchg & atomic code
>
> V8:
> https://lore.kernel.org/linux-riscv/20220724122517.1019187-1-guoren@kerne=
l.org/
>  - Coding convention ticket fixup
>  - Move combo spinlock into riscv and simply asm-generic/spinlock.h
>  - Fixup xchg16 with wrong return value
>  - Add csky qspinlock
>  - Add combo & qspinlock & ticket-lock comparison
>  - Clean up unnecessary riscv acquire and release definitions
>  - Enable ARCH_INLINE_READ*/WRITE*/SPIN* for riscv & csky
>
> V7:
> https://lore.kernel.org/linux-riscv/20220628081946.1999419-1-guoren@kerne=
l.org/
>  - Add combo spinlock (ticket & queued) support
>  - Rename ticket_spinlock.h
>  - Remove unnecessary atomic_read in ticket_spin_value_unlocked
>
> V6:
> https://lore.kernel.org/linux-riscv/20220621144920.2945595-1-guoren@kerne=
l.org/
>  - Fixup Clang compile problem Reported-by: kernel test robot
>  - Cleanup asm-generic/spinlock.h
>  - Remove changelog in patch main comment part, suggested by
>    Conor.Dooley
>  - Remove "default y if NUMA" in Kconfig
>
> V5:
> https://lore.kernel.org/linux-riscv/20220620155404.1968739-1-guoren@kerne=
l.org/
>  - Update comment with RISC-V forward guarantee feature.
>  - Back to V3 direction and optimize asm code.
>
> V4:
> https://lore.kernel.org/linux-riscv/1616868399-82848-4-git-send-email-guo=
ren@kernel.org/
>  - Remove custom sub-word xchg implementation
>  - Add ARCH_USE_QUEUED_SPINLOCKS_XCHG32 in locking/qspinlock
>
> V3:
> https://lore.kernel.org/linux-riscv/1616658937-82063-1-git-send-email-guo=
ren@kernel.org/
>  - Coding convention by Peter Zijlstra's advices
>
> V2:
> https://lore.kernel.org/linux-riscv/1606225437-22948-2-git-send-email-guo=
ren@kernel.org/
>  - Coding convention in cmpxchg.h
>  - Re-implement short xchg
>  - Remove char & cmpxchg implementations
>
> V1:
> https://lore.kernel.org/linux-riscv/20190211043829.30096-1-michaeljclark@=
mac.com/
>  - Using cmpxchg loop to implement sub-word atomic
>
> Guo Ren (14):
>   asm-generic: ticket-lock: Reuse arch_spinlock_t of qspinlock
>   asm-generic: ticket-lock: Add separate ticket-lock.h
>   riscv: errata: Move errata vendor func-id into vendorid_list.h
>   riscv: qspinlock: errata: Add ERRATA_THEAD_WRITE_ONCE fixup
>   riscv: qspinlock: Add basic queued_spinlock support
>   riscv: qspinlock: Introduce combo spinlock
>   riscv: qspinlock: Add virt_spin_lock() support for VM guest
>   riscv: qspinlock: Force virt_spin_lock for KVM guests
>   RISC-V: paravirt: Add pvqspinlock KVM backend
>   RISC-V: paravirt: Add pvqspinlock frontend skeleton
>   RISC-V: paravirt: pvqspinlock: Add SBI implementation
>   RISC-V: paravirt: pvqspinlock: Add nopvspin kernel parameter
>   RISC-V: paravirt: pvqspinlock: Add kconfig entry
>   RISC-V: paravirt: pvqspinlock: Add trace point for pv_kick/wait
>
>  .../admin-guide/kernel-parameters.txt         |   8 +-
>  arch/riscv/Kconfig                            |  35 ++++++
>  arch/riscv/Kconfig.errata                     |  19 ++++
>  arch/riscv/errata/thead/errata.c              |  20 ++++
>  arch/riscv/include/asm/Kbuild                 |   3 +-
>  arch/riscv/include/asm/errata_list.h          |  18 ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h         |   1 +
>  arch/riscv/include/asm/qspinlock.h            |  35 ++++++
>  arch/riscv/include/asm/qspinlock_paravirt.h   |  29 +++++
>  arch/riscv/include/asm/rwonce.h               |  31 ++++++
>  arch/riscv/include/asm/sbi.h                  |  14 +++
>  arch/riscv/include/asm/spinlock.h             |  88 +++++++++++++++
>  arch/riscv/include/asm/vendorid_list.h        |  19 ++++
>  arch/riscv/include/uapi/asm/kvm.h             |   1 +
>  arch/riscv/kernel/Makefile                    |   1 +
>  arch/riscv/kernel/qspinlock_paravirt.c        |  83 ++++++++++++++
>  arch/riscv/kernel/sbi.c                       |   2 +-
>  arch/riscv/kernel/setup.c                     |  68 ++++++++++++
>  .../kernel/trace_events_filter_paravirt.h     |  60 ++++++++++
>  arch/riscv/kvm/Makefile                       |   1 +
>  arch/riscv/kvm/vcpu_sbi.c                     |   4 +
>  arch/riscv/kvm/vcpu_sbi_pvlock.c              |  57 ++++++++++
>  include/asm-generic/qspinlock.h               |   2 +
>  include/asm-generic/rwonce.h                  |   2 +
>  include/asm-generic/spinlock.h                |  87 +--------------
>  include/asm-generic/spinlock_types.h          |  12 +-
>  include/asm-generic/ticket_spinlock.h         | 105 ++++++++++++++++++
>  27 files changed, 688 insertions(+), 117 deletions(-)
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
> 2.40.1
>
>


--
Best Regards
 Guo Ren

