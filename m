Return-Path: <kvm+bounces-21822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7EF934C5B
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 13:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3F8928117A
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 11:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893181386C9;
	Thu, 18 Jul 2024 11:24:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240FC84DF5;
	Thu, 18 Jul 2024 11:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721301843; cv=none; b=qTfZ4o5+UvQ0P3uFAQPSMc8G0urBrS62oV+gVkuolk1UfMPjIglZTbwGGIQmqGJeqP39XSpHH8ZuJrtHsawOxR9p7IOCuuUqU6SO7mMxqCYQQmsmv5mC9SCfFus88wYlqrVOy+4UismJzPMdW4GDPJcazoZG+JyeCjMii/to5/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721301843; c=relaxed/simple;
	bh=Von70e325NTMhrdRJlBmZTpEzJqO3hoYObIgLIfWjLU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oSd5mWooiqpUiTQNEl3SRJpDUxFsCJrIfEVVnEtUaFPE0Uren+vtA3WwMkPrYd7m2u3QTD/z62L5f4Kk2hDQ22a/cY5HXfQwYJLAtFVh4dqF3mLr0KeHJCENaT59TU0sYZ56qMFzqPLgymzsKnymTEPvn2/xK7bzRcpSiDLaiXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ThinkPad-T480s.. (unknown [180.110.112.93])
	by APP-03 (Coremail) with SMTP id rQCowABXXNQ1+5hmHaZgFg--.36655S2;
	Thu, 18 Jul 2024 19:23:35 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-perf-users@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH 0/2] Add perf support to collect KVM guest statistics from host side
Date: Thu, 18 Jul 2024 19:23:33 +0800
Message-Id: <cover.1721271251.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABXXNQ1+5hmHaZgFg--.36655S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJw17AFy7Gr4UGF1rCr1xKrg_yoWrtr17pr
	43CrsxtF4rAryIqw1Svr1YkryUJ397XrnxGrnxJr4rAr4jvaykXwn2gr1xZ3y0qrykKryr
	Xw1ktFy2kas0yFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwAKzVCY07xG64k0F24l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUe6pBDUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAUCBmaY7wwhDAAAs9

From: Quan Zhou <zhouquan@iscas.ac.cn>

Add basic guest support to RISC-V perf, enabling it to distinguish
whether PMU interrupts occur in the host or the guest, and then
collect some basic guest information from the host side
(guest os callchain is not supported for now).

Based on the x86/arm implementation, tested with kvm-riscv.
test env:
- host: qemu-9.0.0
- guest: qemu-9.0.0 --enable-kvm (only start one guest and run top)

-----------------------------------------
1) perf kvm top
./perf kvm --host --guest \
  --guestkallsyms=/root/repo/shared/kallsyms \
  --guestmodules=/root/repo/shared/modules top

PerfTop:      41 irqs/sec  kernel:97.6% us: 0.0% guest kernel: 0.0% guest us: 0.0% exact:  0.0% [250Hz cycles:P],  (all, 4 CPUs)
-------------------------------------------------------------------------------

    64.57%  [kernel]        [k] default_idle_call
     3.12%  [kernel]        [k] _raw_spin_unlock_irqrestore
     3.03%  [guest.kernel]  [g] mem_serial_out
     2.61%  [kernel]        [k] handle_softirqs
     2.32%  [kernel]        [k] do_trap_ecall_u
     1.71%  [kernel]        [k] _raw_spin_unlock_irq
     1.26%  [guest.kernel]  [g] do_raw_spin_lock
     1.25%  [kernel]        [k] finish_task_switch.isra.0
     1.16%  [kernel]        [k] do_idle
     0.77%  libc.so.6       [.] ioctl
     0.76%  [kernel]        [k] queue_work_on
     0.69%  [kernel]        [k] __local_bh_enable_ip
     0.67%  [guest.kernel]  [g] __noinstr_text_start
     0.64%  [guest.kernel]  [g] mem_serial_in
     0.41%  libc.so.6       [.] pthread_sigmask
     0.39%  [kernel]        [k] mem_cgroup_uncharge_skmem
     0.39%  [kernel]        [k] __might_resched
     0.39%  [guest.kernel]  [g] _nohz_idle_balance.isra.0
     0.37%  [kernel]        [k] sched_balance_update_blocked_averages
     0.34%  [kernel]        [k] sched_balance_rq

2) perf kvm record
./perf kvm --host --guest \
  --guestkallsyms=/root/repo/shared/kallsyms \
  --guestmodules=/root/repo/shared/modules record -a sleep 60

[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 1.292 MB perf.data.kvm (17990 samples) ]

3) perf kvm report (the data shown here is not complete)
./perf kvm --host --guest \
  --guestkallsyms=/root/repo/shared/kallsyms \
  --guestmodules=/root/repo/shared/modules report -i perf.data.kvm

# Total Lost Samples: 0
#
# Samples: 17K of event 'cycles:P'
# Event count (approx.): 269968947184
#
# Overhead  Command          Shared Object            Symbol                                        
# ........  ...............  .......................  ..............................................
#
    61.86%  swapper          [kernel.kallsyms]        [k] default_idle_call
     2.93%  :6463            [guest.kernel.kallsyms]  [g] do_raw_spin_lock
     2.82%  :6462            [guest.kernel.kallsyms]  [g] mem_serial_out
     2.11%  sshd             [kernel.kallsyms]        [k] _raw_spin_unlock_irqrestore
     1.78%  :6462            [guest.kernel.kallsyms]  [g] do_raw_spin_lock
     1.37%  swapper          [kernel.kallsyms]        [k] handle_softirqs
     1.36%  swapper          [kernel.kallsyms]        [k] do_idle
     1.21%  sshd             [kernel.kallsyms]        [k] do_trap_ecall_u
     1.21%  sshd             [kernel.kallsyms]        [k] _raw_spin_unlock_irq
     1.11%  qemu-system-ris  [kernel.kallsyms]        [k] do_trap_ecall_u
     0.93%  qemu-system-ris  libc.so.6                [.] ioctl
     0.89%  sshd             [kernel.kallsyms]        [k] __local_bh_enable_ip
     0.77%  qemu-system-ris  [kernel.kallsyms]        [k] _raw_spin_unlock_irqrestore
     0.68%  qemu-system-ris  [kernel.kallsyms]        [k] queue_work_on
     0.65%  sshd             [kernel.kallsyms]        [k] handle_softirqs
     0.44%  :6462            [guest.kernel.kallsyms]  [g] mem_serial_in
     0.42%  sshd             libc.so.6                [.] pthread_sigmask
     0.34%  :6462            [guest.kernel.kallsyms]  [g] serial8250_tx_chars
     0.30%  swapper          [kernel.kallsyms]        [k] finish_task_switch.isra.0
     0.29%  swapper          [kernel.kallsyms]        [k] sched_balance_rq
     0.29%  sshd             [kernel.kallsyms]        [k] __might_resched
     0.26%  swapper          [kernel.kallsyms]        [k] tick_nohz_idle_exit
     0.26%  swapper          [kernel.kallsyms]        [k] sched_balance_update_blocked_averages
     0.26%  swapper          [kernel.kallsyms]        [k] _nohz_idle_balance.isra.0
     0.24%  qemu-system-ris  [kernel.kallsyms]        [k] finish_task_switch.isra.0
     0.23%  :6462            [guest.kernel.kallsyms]  [g] __noinstr_text_start


Quan Zhou (2):
  riscv: perf: add guest vs host distinction
  riscv: KVM: add basic support for host vs guest profiling

 arch/riscv/include/asm/kvm_host.h   |  6 +++++
 arch/riscv/include/asm/perf_event.h |  7 ++++++
 arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
 arch/riscv/kvm/Kconfig              |  1 +
 arch/riscv/kvm/main.c               | 12 +++++++--
 arch/riscv/kvm/vcpu.c               |  7 ++++++
 6 files changed, 69 insertions(+), 2 deletions(-)


base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
-- 
2.34.1


