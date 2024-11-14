Return-Path: <kvm+bounces-31843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA17B9C865A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 10:42:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE1E92834D4
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 09:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839531F755A;
	Thu, 14 Nov 2024 09:41:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38BD1DE2B5;
	Thu, 14 Nov 2024 09:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731577316; cv=none; b=XVL7podmZtnrZnMIhEptgtugrJumF/aIODcwWXcAIYGbWLgy22kR35RH7cnfWu40wVOo/tYOev5BbY7uKMC37tixezd1VHIFWI3l2U/hG25Kp6fLneIkhy+ddRll/3KseBNQbGwfCW+lAvX2kdGNJ2DfxDyvZOIfsGzjY1inllc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731577316; c=relaxed/simple;
	bh=i5t5uoZkJk//79g6cG/+3RQtJAGUYWU8qA/tQ9zZyqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BsG+WmNBRzN0pyVeH2hImEooI0586MIVY7vL8swVemtOhoOI3+ZiLoQi1PwFwrD6qFDqGHjITGz/eyrTLO2ImrBq84Y43Y0vaVDT79p7aKm/ae0uicSjhirUaDe96108Y1Dfun+aTtv8bbJzPZPs/mEGAWnU97HQ2PVDWLlOg+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A566C4CECD;
	Thu, 14 Nov 2024 09:41:52 +0000 (UTC)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.13
Date: Thu, 14 Nov 2024 17:41:28 +0800
Message-ID: <20241114094128.2198306-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following changes since commit 2d5404caa8c7bb5c4e0435f94b28834ae5456623:

  Linux 6.12-rc7 (2024-11-10 14:19:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.13

for you to fetch changes up to 9899b8201025d00b23aee143594a30c55cc4cc35:

  irqchip/loongson-eiointc: Add virt extension support (2024-11-13 16:18:27 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.13

1. Add iocsr and mmio bus simulation in kernel.
2. Add in-kernel interrupt controller emulation.
3. Add virt extension support for eiointc irqchip.

----------------------------------------------------------------
Bibo Mao (1):
      irqchip/loongson-eiointc: Add virt extension support

Xianglai Li (11):
      LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
      LoongArch: KVM: Add IPI device support
      LoongArch: KVM: Add IPI read and write function
      LoongArch: KVM: Add IPI user mode read and write function
      LoongArch: KVM: Add EIOINTC device support
      LoongArch: KVM: Add EIOINTC read and write functions
      LoongArch: KVM: Add EIOINTC user mode read and write functions
      LoongArch: KVM: Add PCHPIC device support
      LoongArch: KVM: Add PCHPIC read and write functions
      LoongArch: KVM: Add PCHPIC user mode read and write functions
      LoongArch: KVM: Add irqfd support

 Documentation/arch/loongarch/irq-chip-model.rst    |   64 ++
 .../zh_CN/arch/loongarch/irq-chip-model.rst        |   55 ++
 arch/loongarch/include/asm/irq.h                   |    1 +
 arch/loongarch/include/asm/kvm_eiointc.h           |  123 +++
 arch/loongarch/include/asm/kvm_host.h              |   18 +-
 arch/loongarch/include/asm/kvm_ipi.h               |   45 +
 arch/loongarch/include/asm/kvm_pch_pic.h           |   62 ++
 arch/loongarch/include/uapi/asm/kvm.h              |   20 +
 arch/loongarch/kvm/Kconfig                         |    5 +-
 arch/loongarch/kvm/Makefile                        |    4 +
 arch/loongarch/kvm/exit.c                          |   82 +-
 arch/loongarch/kvm/intc/eiointc.c                  | 1027 ++++++++++++++++++++
 arch/loongarch/kvm/intc/ipi.c                      |  475 +++++++++
 arch/loongarch/kvm/intc/pch_pic.c                  |  519 ++++++++++
 arch/loongarch/kvm/irqfd.c                         |   89 ++
 arch/loongarch/kvm/main.c                          |   19 +-
 arch/loongarch/kvm/vcpu.c                          |    3 +
 arch/loongarch/kvm/vm.c                            |   21 +
 drivers/irqchip/irq-loongson-eiointc.c             |  108 +-
 include/linux/kvm_host.h                           |    1 +
 include/trace/events/kvm.h                         |   35 +
 include/uapi/linux/kvm.h                           |    8 +
 22 files changed, 2735 insertions(+), 49 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_eiointc.h
 create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
 create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
 create mode 100644 arch/loongarch/kvm/intc/eiointc.c
 create mode 100644 arch/loongarch/kvm/intc/ipi.c
 create mode 100644 arch/loongarch/kvm/intc/pch_pic.c
 create mode 100644 arch/loongarch/kvm/irqfd.c

