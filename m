Return-Path: <kvm+bounces-17023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B608C008E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 17:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FEE8B242BC
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B60B126F04;
	Wed,  8 May 2024 15:03:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21218626D;
	Wed,  8 May 2024 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715180583; cv=none; b=kH/PxC847GxTv29dqJPMOAlPyCerCPscGA5GnKSyrOVAoFjWt8J85pz40A2NvkOyPtlcFp1efkO1I/FPstrQ0WeWsrEH0FVHxB+Camf5iWuqFC03YWTI1iy0tCbRFfj2E+BfScAZVZcN/BDeiZY+z1hAxq46wGGUBeFr+9xeL8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715180583; c=relaxed/simple;
	bh=YmVwwD29BaB0nxCNkc9kQIER7FM7cJMCW4mogzEXRN8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TqutMGjjiNldG3s7mumv1EJlBBeGBNTWdAgpKE7Ac48DEqk06xF6EAvtUR4695BtjIlEIlT8eKR6fF3A2i4HmZ8/0Fz/XbIhfhLH+NJYPlk2g765uazDG8+HvUedmm6r/03DMEqyLrrURO1sPAqX3KJH8wtU+d6n4jFdRvK1BPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46FDC113CC;
	Wed,  8 May 2024 15:02:58 +0000 (UTC)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xuerui Wang <kernel@xen0n.name>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [GIT PULL] LoongArch KVM changes for v6.10
Date: Wed,  8 May 2024 23:02:40 +0800
Message-ID: <20240508150240.225429-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following changes since commit dd5a440a31fae6e459c0d6271dddd62825505361:

  Linux 6.9-rc7 (2024-05-05 14:06:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.10

for you to fetch changes up to 7b7e584f90bf670d5c6f2b1fff884bf3b972cad4:

  LoongArch: KVM: Add mmio trace events support (2024-05-06 22:00:47 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.10

1. Add ParaVirt IPI support.
2. Add software breakpoint support.
3. Add mmio trace events support.

----------------------------------------------------------------
Bibo Mao (8):
      LoongArch/smp: Refine some ipi functions on LoongArch platform
      LoongArch: KVM: Add hypercall instruction emulation
      LoongArch: KVM: Add cpucfg area for kvm hypervisor
      LoongArch: KVM: Add vcpu mapping from physical cpuid
      LoongArch: KVM: Add PV IPI support on host side
      LoongArch: KVM: Add PV IPI support on guest side
      LoongArch: KVM: Add software breakpoint support
      LoongArch: KVM: Add mmio trace events support

 arch/loongarch/Kconfig                          |   9 ++
 arch/loongarch/include/asm/Kbuild               |   1 -
 arch/loongarch/include/asm/hardirq.h            |   6 +
 arch/loongarch/include/asm/inst.h               |   2 +
 arch/loongarch/include/asm/irq.h                |  11 +-
 arch/loongarch/include/asm/kvm_host.h           |  33 +++++
 arch/loongarch/include/asm/kvm_para.h           | 161 ++++++++++++++++++++++++
 arch/loongarch/include/asm/kvm_vcpu.h           |  11 ++
 arch/loongarch/include/asm/loongarch.h          |  12 ++
 arch/loongarch/include/asm/paravirt.h           |  30 +++++
 arch/loongarch/include/asm/paravirt_api_clock.h |   1 +
 arch/loongarch/include/asm/smp.h                |  22 ++--
 arch/loongarch/include/uapi/asm/kvm.h           |   4 +
 arch/loongarch/kernel/Makefile                  |   1 +
 arch/loongarch/kernel/irq.c                     |  24 +---
 arch/loongarch/kernel/paravirt.c                | 151 ++++++++++++++++++++++
 arch/loongarch/kernel/perf_event.c              |  14 +--
 arch/loongarch/kernel/smp.c                     |  52 +++++---
 arch/loongarch/kernel/time.c                    |  12 +-
 arch/loongarch/kvm/exit.c                       | 151 +++++++++++++++++++---
 arch/loongarch/kvm/trace.h                      |  20 ++-
 arch/loongarch/kvm/vcpu.c                       | 105 +++++++++++++++-
 arch/loongarch/kvm/vm.c                         |  11 ++
 23 files changed, 746 insertions(+), 98 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_para.h
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 create mode 100644 arch/loongarch/kernel/paravirt.c

