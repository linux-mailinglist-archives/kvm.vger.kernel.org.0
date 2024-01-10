Return-Path: <kvm+bounces-6017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCBE82A4C1
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 00:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDC271F2739E
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 23:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CDE4F8A6;
	Wed, 10 Jan 2024 23:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ZQi4sYI4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5AC4F895
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 23:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bbec1d1c9dso245394639f.1
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 15:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1704928478; x=1705533278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8WUFVAAbHF+PmWAuLnMrVx+kQTLQoDfgHSLNtKZiPo8=;
        b=ZQi4sYI4LL6sRgefuPTGqvphZ+o4UMDqeFd/Jntp99pX58kRapWt+zdIC6aKn8t952
         sWQI3IfH7ziog3PEnuNvIwmM8CsS4LaAMwlMzVuPmkmMA4qw1KY2nwVIX+XCInxvsBc9
         Gxcle2kI8PP+AaIs9x+hS44svPECVpzVmQae9MRaoHVsYwk6eDj79KOO72Wub8HayLuc
         pLKmebOIvbw/zb1x+Bec8F7Taor/JKSqtl4+wPS7NaWYmw8c2A9HllZCBmASjri7mUkL
         sxZPiDVi2zD2NwxoVcPeyiZ/O/3spuRnYQ6uZt+7WF0Lq4S4aJ0mhGlElPGrKSFFRITM
         G0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704928478; x=1705533278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8WUFVAAbHF+PmWAuLnMrVx+kQTLQoDfgHSLNtKZiPo8=;
        b=bYTXgQdBfYS521KUajij3JOxDVG/5OhQvAJGNVdGxxzqHaZPaxWmImeySmOyn90qy2
         IlhOkaJZuLuJpNFTDiqSNgKvtBsdLu7D9C5xU03iRAq3K1PVx2HmFy/7S9QvXfFC5pOH
         D0FwkFLhGxDAOv6PxcA1PxtJAwdIRgMdnplUSCiALLRYXl1/LuaL6WLq40XxiRNv0F4K
         Lj4xSDZpppXTd58S+9+KFdB/kuBa7iC7YfCcPq0DIqkjTnznboI43fHU3CoUZnqKiHaH
         JNJaiihDtrVTAvy/svUOQWjvexayUlswB/awvhWf3kDNnEBxsVa6HDIjyKD9pZ/cws85
         AK0Q==
X-Gm-Message-State: AOJu0Yw3n/lg9GELnHrIqb4wREUIN+iorDumGdTzriO8phaW+hatHrzj
	WOYd23sf/GUCtU1++VayRfrrtnF1hf1uuQ==
X-Google-Smtp-Source: AGHT+IEp7thazljNeY9OzBk4iTp5bRzzo1Z7xTD3TDakP3AoXQn9uFVbKsFgyO4lZsLq96YzbsUb8A==
X-Received: by 2002:a6b:ea07:0:b0:7ba:95fc:5dd0 with SMTP id m7-20020a6bea07000000b007ba95fc5dd0mr400839ioc.18.1704928478620;
        Wed, 10 Jan 2024 15:14:38 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id co13-20020a0566383e0d00b0046e3b925818sm1185503jab.37.2024.01.10.15.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:14:38 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>,
	Vladimir Isaev <vladimir.isaev@syntacore.com>
Subject: [v3 00/10] RISC-V SBI v2.0 PMU improvements and Perf sampling in KVM guest
Date: Wed, 10 Jan 2024 15:13:49 -0800
Message-Id: <20240110231359.1239367-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series implements SBI PMU improvements done in SBI v2.0[1] i.e. PMU snapshot
and fw_read_hi() functions. 

SBI v2.0 introduced PMU snapshot feature which allows the SBI implementation
to provide counter information (i.e. values/overflow status) via a shared
memory between the SBI implementation and supervisor OS. This allows to minimize
the number of traps in when perf being used inside a kvm guest as it relies on
SBI PMU + trap/emulation of the counters. 

The current set of ratified RISC-V specification also doesn't allow scountovf
to be trap/emulated by the hypervisor. The SBI PMU snapshot bridges the gap
in ISA as well and enables perf sampling in the guest. However, LCOFI in the
guest only works via IRQ filtering in AIA specification. That's why, AIA
has to be enabled in the hardware (at least the Ssaia extension) in order to
use the sampling support in the perf. 

Here are the patch wise implementation details.

PATCH 1,6,7 : Generic cleanups/improvements.
PATCH 2,3,10 : FW_READ_HI function implementation
PATCH 4-5: Add PMU snapshot feature in sbi pmu driver
PATCH 6-7: KVM implementation for snapshot and sampling in kvm guests

The series is based on kvm-next and is available at:

https://github.com/atishp04/linux/tree/kvm_pmu_snapshot_v3

The kvmtool patch is also available at:
https://github.com/atishp04/kvmtool/tree/sscofpmf

It also requires Ssaia ISA extension to be present in the hardware in order to
get perf sampling support in the guest. In Qemu virt machine, it can be done
by the following config.

```
-cpu rv64,sscofpmf=true,x-ssaia=true
```

There is no other dependencies on AIA apart from that. Thus, Ssaia must be disabled
for the guest if AIA patches are not available. Here is the example command.

```
./lkvm-static run -m 256 -c2 --console serial -p "console=ttyS0 earlycon" --disable-ssaia -k ./Image --debug 
```

The series has been tested only in Qemu.
Here is the snippet of the perf running inside a kvm guest.

===================================================
$ perf record -e cycles -e instructions perf bench sched messaging -g 5
...
$ Running 'sched/messaging' benchmark:
...
[   45.928723] perf_duration_warn: 2 callbacks suppressed
[   45.929000] perf: interrupt took too long (484426 > 483186), lowering kernel.perf_event_max_sample_rate to 250
$ 20 sender and receiver processes per group
$ 5 groups == 200 processes run

     Total time: 14.220 [sec]
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.117 MB perf.data (1942 samples) ]
$ perf report --stdio
$ To display the perf.data header info, please use --header/--header-only optio>
$
$
$ Total Lost Samples: 0
$
$ Samples: 943  of event 'cycles'
$ Event count (approx.): 5128976844
$
$ Overhead  Command          Shared Object                Symbol               >
$ ........  ...............  ...........................  .....................>
$
     7.59%  sched-messaging  [kernel.kallsyms]            [k] memcpy
     5.48%  sched-messaging  [kernel.kallsyms]            [k] percpu_counter_ad>
     5.24%  sched-messaging  [kernel.kallsyms]            [k] __sbi_rfence_v02_>
     4.00%  sched-messaging  [kernel.kallsyms]            [k] _raw_spin_unlock_>
     3.79%  sched-messaging  [kernel.kallsyms]            [k] set_pte_range
     3.72%  sched-messaging  [kernel.kallsyms]            [k] next_uptodate_fol>
     3.46%  sched-messaging  [kernel.kallsyms]            [k] filemap_map_pages
     3.31%  sched-messaging  [kernel.kallsyms]            [k] handle_mm_fault
     3.20%  sched-messaging  [kernel.kallsyms]            [k] finish_task_switc>
     3.16%  sched-messaging  [kernel.kallsyms]            [k] clear_page
     3.03%  sched-messaging  [kernel.kallsyms]            [k] mtree_range_walk
     2.42%  sched-messaging  [kernel.kallsyms]            [k] flush_icache_pte

===================================================

[1] https://github.com/riscv-non-isa/riscv-sbi-doc

Changes from v2->v3:
1. Fixed a patchwork warning on patch6.
2. Fixed a comment formatting & nit fix in PATCH 3 & 5.
3. Moved the hvien update and sscofpmf enabling to PATCH 9 from PATCH 8.

Changes from v1->v2:
1. Fixed warning/errors from patchwork CI.
2. Rebased on top of kvm-next.
3. Added Acked-by tags.

Changes from RFC->v1:
1. Addressed all the comments on RFC series.
2. Removed PATCH2 and merged into later patches.
3. Added 2 more patches for minor fixes.
4. Fixed KVM boot issue without Ssaia and made sscofpmf in guest dependent on
   Ssaia in the host.

Atish Patra (10):
RISC-V: Fix the typo in Scountovf CSR name
RISC-V: Add FIRMWARE_READ_HI definition
drivers/perf: riscv: Read upper bits of a firmware counter
RISC-V: Add SBI PMU snapshot definitions
drivers/perf: riscv: Implement SBI PMU snapshot function
RISC-V: KVM: No need to update the counter value during reset
RISC-V: KVM: No need to exit to the user space if perf event failed
RISC-V: KVM: Implement SBI PMU Snapshot feature
RISC-V: KVM: Add perf sampling support for guests
RISC-V: KVM: Support 64 bit firmware counters on RV32

arch/riscv/include/asm/csr.h          |   5 +-
arch/riscv/include/asm/errata_list.h  |   2 +-
arch/riscv/include/asm/kvm_vcpu_pmu.h |  14 +-
arch/riscv/include/asm/sbi.h          |  12 ++
arch/riscv/include/uapi/asm/kvm.h     |   1 +
arch/riscv/kvm/aia.c                  |   5 +
arch/riscv/kvm/vcpu.c                 |   8 +-
arch/riscv/kvm/vcpu_onereg.c          |   9 +-
arch/riscv/kvm/vcpu_pmu.c             | 244 ++++++++++++++++++++++++--
arch/riscv/kvm/vcpu_sbi_pmu.c         |  15 +-
drivers/perf/riscv_pmu.c              |   1 +
drivers/perf/riscv_pmu_sbi.c          | 229 ++++++++++++++++++++++--
include/linux/perf/riscv_pmu.h        |   6 +
13 files changed, 507 insertions(+), 44 deletions(-)

--
2.34.1


