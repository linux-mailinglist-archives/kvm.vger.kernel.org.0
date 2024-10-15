Return-Path: <kvm+bounces-28832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0836599DC7A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 04:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC0D12827D2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 02:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA3B16EB7C;
	Tue, 15 Oct 2024 02:59:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF0E16190C;
	Tue, 15 Oct 2024 02:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728961161; cv=none; b=d/zsSuHr/qjoztyIdMdxsuHz6eu/HnQmv2GouKNKuDw2/hRpaSWMfWr9mZS3eHCUGdXOfIsE0plD0tW7TGsY58ycxVYWyQEdU6fyW7iYX4NuYLUQo1Sw5NbHmJLfF2dwU1UA/BMShiwF5RMV7gXae/GmmHhYVcn4e23ZoKiFyDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728961161; c=relaxed/simple;
	bh=+b+elXxAVVxfj8rJTcv5UBxWvX8Yo0n65x7WAh9G9ok=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JGvytbpvXrpxehPPSBv/EFeDZjujqrbqsKzCXpH/LXvSR2WHH00H+9wsF6uM0vTLdhzxWMhHqty5Wjr2RIU7YWp/mlKpKKrtAkBW6lORLdVt4z84yy68M2bsyDo2rQ7hXPBhLYt5fyixD+FwhcRewK9FrQw7ui5F0g54JGKMfos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [121.237.44.89])
	by APP-01 (Coremail) with SMTP id qwCowABXXipl2g1nHjicBw--.43054S2;
	Tue, 15 Oct 2024 10:58:46 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH v4 0/2] riscv: Add perf support to collect KVM guest statistics from host side
Date: Tue, 15 Oct 2024 10:58:05 +0800
Message-Id: <cover.1728957131.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABXXipl2g1nHjicBw--.43054S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuw1xJw15CF13uryDCF45KFg_yoW7XrWrpr
	43Crsxtr4YyryIqw4Iyr1Y9ry5J397Xrn3GrnxXw4rAr4jvaykZwnFgw4xZrW0qryvgryf
	Xr1vqFy3Kas0yFUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7Cj
	xVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwV
	W8JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUXBM_UUUUU
	=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAgLBmcNsJGSrAAAs8

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
  --guestkallsyms=/<path-to-kallsyms> \
  --guestmodules=/<path-to-modules> top

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
  --guestkallsyms=/<path-to-kallsyms> \
  --guestmodules=/<path-to-modules> record -a sleep 60

[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 1.292 MB perf.data.kvm (17990 samples) ]

3) perf kvm report
./perf kvm --host --guest \
  --guestkallsyms=/<path-to-kallsyms> \
  --guestmodules=/<path-to-modules> report -i perf.data.kvm

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

---
Change since v3:
- Rebased on v6.12-rc3

Change since v2:
- Rebased on v6.11-rc7
- Keep the misc type consistent with other architectures as `unsigned long` (Andrew)
- Add the same comment for `kvm_arch_pmi_in_guest` as in arm64. (Andrew)

Change since v1:
- Rebased on v6.11-rc3
- Fix incorrect misc type (Andrew)

---
v3 link:
https://lore.kernel.org/all/cover.1726126795.git.zhouquan@iscas.ac.cn/
v2 link:
https://lore.kernel.org/all/cover.1723518282.git.zhouquan@iscas.ac.cn/
v1 link:
https://lore.kernel.org/all/cover.1721271251.git.zhouquan@iscas.ac.cn/

Quan Zhou (2):
  riscv: perf: add guest vs host distinction
  riscv: KVM: add basic support for host vs guest profiling

 arch/riscv/include/asm/kvm_host.h   | 10 ++++++++
 arch/riscv/include/asm/perf_event.h |  6 +++++
 arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
 arch/riscv/kvm/Kconfig              |  1 +
 arch/riscv/kvm/main.c               | 12 +++++++--
 arch/riscv/kvm/vcpu.c               |  7 ++++++
 6 files changed, 72 insertions(+), 2 deletions(-)


base-commit: 8e929cb546ee42c9a61d24fae60605e9e3192354
-- 
2.34.1


