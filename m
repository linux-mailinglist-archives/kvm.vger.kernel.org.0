Return-Path: <kvm+bounces-70446-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OK+qDkIBhmlhJAQAu9opvQ
	(envelope-from <kvm+bounces-70446-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:57:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B62FF59D
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3BE853010783
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3040842315D;
	Fri,  6 Feb 2026 14:56:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D61D4218B6;
	Fri,  6 Feb 2026 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770389805; cv=none; b=FvaCLPGzXfrV55FFHAgyGPEIw8DGUgVfBKQzfohV7Ym48jf6YS7iebjaKBOvAZCI1OvTWxb4BuwSyqc0o/Ec0uSUzcXoBOGu1pnMXg77OYI9qKJKRPVBks2PhQSsnlIoLzKyHOn+uzShuEeaFAIfvabPbwDvOUn6OCZmwgVnonA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770389805; c=relaxed/simple;
	bh=AON4s7gGNul3vm4e7beL4pwbpsd9djRz8f0TOTDxqws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OdCkUZg6LOlI7VnYNuh77uPzvpS0PNF58mxJ7ZYwvH27vjcFXb5CHhKIInpVohSrpeilm/EI8VDiFJ2b4xnBajS9q2pJ+90pDjemLZNwhbdhYEumyoIPGpvrqQvgovC5xz1yJYnBP6gCIbrJgWxyV6o3fvJmp0ZHfWN/O2UJjvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.69.42])
	by gateway (Coremail) with SMTP id _____8CxZcEoAYZpqoAQAA--.5935S3;
	Fri, 06 Feb 2026 22:56:40 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.69.42])
	by front1 (Coremail) with SMTP id qMiowJBx58AgAYZpphBBAA--.23473S2;
	Fri, 06 Feb 2026 22:56:38 +0800 (CST)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.20
Date: Fri,  6 Feb 2026 22:56:22 +0800
Message-ID: <20260206145622.2433924-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx58AgAYZpphBBAA--.23473S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxWF1rCr1DXFWUXrWUGFyUArc_yoW5Gw15pF
	y3Crn3Ar4rGr4fZrnxt34Uur13Jr1xGF1aqayayry8Cr4jvF1UJr48JrykXFy5CayrJry0
	vF1rGw1j9F1UJacCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v2
	6r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIev
	Ja73UjIFyTuYvjxUc0eHDUUUU
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70446-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.882];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,loongson.cn:mid]
X-Rspamd-Queue-Id: E9B62FF59D
X-Rspamd-Action: no action

The following changes since commit 18f7fcd5e69a04df57b563360b88be72471d6b62:

  Linux 6.19-rc8 (2026-02-01 14:01:13 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.20

for you to fetch changes up to 2d94a3f7088b69ae25e27fb98d7f1ef572c843f9:

  KVM: LoongArch: selftests: Add steal time test case (2026-02-06 09:28:01 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.20

1. Add more CPUCFG mask bits.
2. Improve feature detection.
3. Add FPU/LBT delay load support.
4. Set default return value in KVM IO bus ops.
5. Add paravirt preempt feature support.
6. Add KVM steal time test case for tools/selftests.

----------------------------------------------------------------
Bibo Mao (13):
      LoongArch: KVM: Add more CPUCFG mask bits
      LoongArch: KVM: Move feature detection in kvm_vm_init_features()
      LoongArch: KVM: Add msgint registers in kvm_init_gcsr_flag()
      LoongArch: KVM: Check VM msgint feature during interrupt handling
      LoongArch: KVM: Handle LOONGARCH_CSR_IPR during vCPU context switch
      LoongArch: KVM: Move LSX capability check in exception handler
      LoongArch: KVM: Move LASX capability check in exception handler
      LoongArch: KVM: Move LBT capability check in exception handler
      LoongArch: KVM: Add FPU/LBT delay load support
      LoongArch: KVM: Set default return value in KVM IO bus ops
      LoongArch: KVM: Add paravirt preempt feature in hypervisor side
      LoongArch: KVM: Add paravirt vcpu_is_preempted() support in guest side
      KVM: LoongArch: selftests: Add steal time test case

 arch/loongarch/include/asm/kvm_host.h      |   9 +++
 arch/loongarch/include/asm/kvm_para.h      |   4 +-
 arch/loongarch/include/asm/loongarch.h     |   1 +
 arch/loongarch/include/asm/qspinlock.h     |   4 +
 arch/loongarch/include/uapi/asm/kvm.h      |   1 +
 arch/loongarch/include/uapi/asm/kvm_para.h |   1 +
 arch/loongarch/kernel/paravirt.c           |  21 ++++-
 arch/loongarch/kvm/exit.c                  |  21 ++++-
 arch/loongarch/kvm/intc/eiointc.c          |  43 ++++------
 arch/loongarch/kvm/intc/ipi.c              |  26 ++----
 arch/loongarch/kvm/intc/pch_pic.c          |  31 ++++---
 arch/loongarch/kvm/interrupt.c             |   4 +-
 arch/loongarch/kvm/main.c                  |   8 ++
 arch/loongarch/kvm/vcpu.c                  | 125 +++++++++++++++++++++++------
 arch/loongarch/kvm/vm.c                    |  39 +++++----
 tools/testing/selftests/kvm/Makefile.kvm   |   1 +
 tools/testing/selftests/kvm/steal_time.c   |  96 ++++++++++++++++++++++
 17 files changed, 319 insertions(+), 116 deletions(-)


