Return-Path: <kvm+bounces-47340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 138AEAC02B3
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 05:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F7E83B0D91
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 03:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D65A1494D9;
	Thu, 22 May 2025 03:07:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ED827718;
	Thu, 22 May 2025 03:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747883235; cv=none; b=p0GNGCWF6/dX6l54xIfndYz0s1dPFdDuxQ5NIK7+zZoXJEyizf64ecg6cMvu5Iee4yQOzokxvzojkwGQkxLaIVDA7QtGwqOtr/UpgchvXNqua3L7jhYVBkHOU30OfwSWNFyCaAgR88yW2mjRD5cq2vwNwBV+BbcUW7+1vuZ48J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747883235; c=relaxed/simple;
	bh=/tFrh5QqKOL4ygIBBWFi3Vw9SPY03/r3IMgvMlztlNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=He+0ocS8kcu9dQ3xzp3W3947suoo3a5aoAcKSQgZ0r2fxUL62hh2gpwTEEVICAylhx3EspFXzPjc5cf4ZR6ooG573AngrJQ978uwMTC3zsx8kIOC6HCjbEwH83+UyPs6dHNOExZIpcK7QIzjjVqQYXbnN/7n0K89PUC52eTid3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.69.3])
	by gateway (Coremail) with SMTP id _____8CxLGvWlC5oo9v1AA--.4475S3;
	Thu, 22 May 2025 11:07:02 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.69.3])
	by front1 (Coremail) with SMTP id qMiowMDxesTIlC5orADnAA--.58454S2;
	Thu, 22 May 2025 11:06:59 +0800 (CST)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.16
Date: Thu, 22 May 2025 11:06:28 +0800
Message-ID: <20250522030628.1924833-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxesTIlC5orADnAA--.58454S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxAFy7Gr4rZr47Kr4kCFyrXwc_yoW5GrWUp3
	WSvrn3Kr18KF17Ar97J34kXryft3WkGr4Iv3Waqry8Cr1jyry8Jr1xKF95Aa43Z395XryF
	va4xGwn8WF1UJacCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_
	JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU
	0xZFpf9x07j5xhLUUUUU=

The following changes since commit a5806cd506af5a7c19bcd596e4708b5c464bfd21:

  Linux 6.15-rc7 (2025-05-18 13:57:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.16

for you to fetch changes up to a867688c8cbb1b83667a6665362d89e8c762e820:

  KVM: selftests: Add supported test cases for LoongArch (2025-05-20 20:20:26 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.16

1. Don't flush tlb if HW PTW supported.
2. Add LoongArch KVM selftests support.

----------------------------------------------------------------
Bibo Mao (7):
      LoongArch: KVM: Add ecode parameter for exception handlers
      LoongArch: KVM: Do not flush tlb if HW PTW supported
      KVM: selftests: Add VM_MODE_P47V47_16K VM mode
      KVM: selftests: Add KVM selftests header files for LoongArch
      KVM: selftests: Add core KVM selftests support for LoongArch
      KVM: selftests: Add ucall test support for LoongArch
      KVM: selftests: Add supported test cases for LoongArch

 MAINTAINERS                                        |   2 +
 arch/loongarch/include/asm/kvm_host.h              |   2 +-
 arch/loongarch/include/asm/kvm_vcpu.h              |   2 +-
 arch/loongarch/kvm/exit.c                          |  37 +--
 arch/loongarch/kvm/mmu.c                           |  15 +-
 tools/testing/selftests/kvm/Makefile               |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm           |  17 +
 tools/testing/selftests/kvm/include/kvm_util.h     |   6 +
 .../kvm/include/loongarch/kvm_util_arch.h          |   7 +
 .../selftests/kvm/include/loongarch/processor.h    | 141 +++++++++
 .../selftests/kvm/include/loongarch/ucall.h        |  20 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   3 +
 .../selftests/kvm/lib/loongarch/exception.S        |  59 ++++
 .../selftests/kvm/lib/loongarch/processor.c        | 346 +++++++++++++++++++++
 tools/testing/selftests/kvm/lib/loongarch/ucall.c  |  38 +++
 .../testing/selftests/kvm/set_memory_region_test.c |   2 +-
 16 files changed, 674 insertions(+), 25 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/processor.h
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/ucall.h
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
 create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c


