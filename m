Return-Path: <kvm+bounces-41482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E736FA687F2
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 10:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5526C189ADCA
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 09:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922AB25332F;
	Wed, 19 Mar 2025 09:29:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC372512C4;
	Wed, 19 Mar 2025 09:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742376575; cv=none; b=QX1sJODtdv/YXoSQ62gnocZir+EfAPEJ532XHDxAohbsuc5EkrJE+Ka+YtZc/1IG+YatdJIH5bBEEcvkMSuZkQn724YOIJl+FVBa5Pb/Y5fJP+t5RpfElubW2J+rHnKxB1aZ36GPfnOJ89v6y3p+OURYj74tsmCgZqTiVsWIAZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742376575; c=relaxed/simple;
	bh=4LRZMLzksZxps+TGcvXFGHIVLoGo+zW1O+tuIaJMRns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SAC0N/es9dYWM/o2sPl2vr1h+s7UrlhSyYVJREEvoRP3ldohoqt0OgskWePg+AR0xKp9tPXk3hYE3wS9SdYLX96QRDSYQlPchQbshRFKsddmhJlKRtGtBDyPjRc4+zSgCSAl4odoeP/mqAmNdthuwd138rTfZqGM3aV5z8o8RR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.68.198])
	by gateway (Coremail) with SMTP id _____8BxIK90jtpnH+WcAA--.874S3;
	Wed, 19 Mar 2025 17:29:24 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.68.198])
	by front1 (Coremail) with SMTP id qMiowMDxesRrjtpnSmdTAA--.21474S2;
	Wed, 19 Mar 2025 17:29:18 +0800 (CST)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.15
Date: Wed, 19 Mar 2025 17:29:04 +0800
Message-ID: <20250319092904.3644227-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxesRrjtpnSmdTAA--.21474S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7AFy7ZF48Wr4fAr1fWry5ZFc_yoW8XF47pr
	1a9rnxKr4DGrnxJwnxt34Uurn8JFy8Gr1IqF42yw18AryUAw1UXr18Wrn5XFy5J3yrJry0
	qr18Jw1j9FyUJ3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_
	JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
	UjIFyTuYvjxU466zUUUUU

The following changes since commit 4701f33a10702d5fc577c32434eb62adde0a1ae1:

  Linux 6.14-rc7 (2025-03-16 12:55:17 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.15

for you to fetch changes up to 6bfb3a715de924f8ddd4d782e2e2fdd2f5966fc7:

  LoongArch: KVM: Register perf callbacks for guest (2025-03-18 16:48:08 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.15

1. Remove unnecessary header include path.
2. Remove PGD saving during VM context switch.
3. Add perf events support for guest VM.

----------------------------------------------------------------
Bibo Mao (4):
      LoongArch: KVM: Remove PGD saving during VM context switch
      LoongArch: KVM: Add stub for kvm_arch_vcpu_preempted_in_kernel()
      LoongArch: KVM: Implement arch-specific functions for guest perf
      LoongArch: KVM: Register perf callbacks for guest

Masahiro Yamada (1):
      LoongArch: KVM: Remove unnecessary header include path

 arch/loongarch/include/asm/kvm_host.h |  6 ++++++
 arch/loongarch/kernel/asm-offsets.c   |  1 +
 arch/loongarch/kvm/Kconfig            |  1 +
 arch/loongarch/kvm/Makefile           |  2 --
 arch/loongarch/kvm/main.c             |  3 +++
 arch/loongarch/kvm/switch.S           | 12 ++----------
 arch/loongarch/kvm/vcpu.c             | 37 +++++++++++++++++++++++++++++++++++
 7 files changed, 50 insertions(+), 12 deletions(-)


