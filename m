Return-Path: <kvm+bounces-53117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD12B0D8A7
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 13:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E95C86C2C9A
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2C92E424D;
	Tue, 22 Jul 2025 11:58:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0682A920;
	Tue, 22 Jul 2025 11:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753185496; cv=none; b=tTN+nzROB9P7CxhtE0CuDCh3ENG6g0pRu5YTloUm7eETyzAEycC+pp+/rE2chDB+N9duehZg2xa7+CmjlCEa6SiQkZZDR3g+2vl8z5MOD87s43QA5XdqvtuZKib0mzPgCG6TkvkQhWyWwMpdWm9R12xVC2PcQttn8mYxbB7QXbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753185496; c=relaxed/simple;
	bh=FYFNJZU/pShI/0xENZjgDKpYDZJS22uxFteKyrwwyQY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IIaq0KNylRtbcacV/BFrhjwrVAlwfuwmYEnV0HxIaJSqySADWQOsTs7plIgkdBTUvBWS5DyzQHKxLmcirha/jok+BsGjlDvlypH4ibaApGk1zjftBMiyiCFBdj2ETu8hbl6w0T3P0XAlUo4NGDNGf9Najs0P+QdGt/S7vmtZCNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.69.45])
	by gateway (Coremail) with SMTP id _____8BxnmtqfH9o5pIvAQ--.56009S3;
	Tue, 22 Jul 2025 19:56:26 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.69.45])
	by front1 (Coremail) with SMTP id qMiowJDxscJlfH9oBdYhAA--.19687S2;
	Tue, 22 Jul 2025 19:56:25 +0800 (CST)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.17
Date: Tue, 22 Jul 2025 19:56:09 +0800
Message-ID: <20250722115609.3754289-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxscJlfH9oBdYhAA--.19687S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7CFWrZF1kCw4DKFW3Kr4fCrX_yoW8ZrWxpr
	13urnrJFs8GrZ5Jryqq343uwnrAFn7CryxXF4UKFW8ur4UZr1UXry8Xrn3JFy5C3yrJry0
	vr1rGw1jqF1UAacCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y
	6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73
	UjIFyTuYvjxU2MKZDUUUU

The following changes since commit 89be9a83ccf1f88522317ce02f854f30d6115c41:

  Linux 6.16-rc7 (2025-07-20 15:18:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.17

for you to fetch changes up to 36d09b96d3e79518e2be31fc7960cc694702afb8:

  LoongArch: KVM: Add tracepoints for CPUCFG and CSR emulation exits (2025-07-21 09:26:35 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.17

1. Simplify some KVM routines.
2. Enhance in-kernel irqchip emulation.
3. Add stat information with kernel irqchip.
4. Add tracepoints for CPUCFG and CSR emulation exits.

----------------------------------------------------------------
Bibo Mao (8):
      LoongArch: KVM: Remove unnecessary local variable
      LoongArch: KVM: Remove unused parameter len
      LoongArch: KVM: Remove never called default case statement
      LoongArch: KVM: Use standard bitops API with eiointc
      LoongArch: KVM: Use generic function loongarch_eiointc_read()
      LoongArch: KVM: Use generic function loongarch_eiointc_write()
      LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
      LoongArch: KVM: Add stat information with kernel irqchip

Yulong Han (1):
      LoongArch: KVM: Add tracepoints for CPUCFG and CSR emulation exits

Yury Norov (NVIDIA) (2):
      LoongArch: KVM: Rework kvm_send_pv_ipi()
      LoongArch: KVM: Simplify kvm_deliver_intr()

 arch/loongarch/include/asm/kvm_host.h |  12 +-
 arch/loongarch/kvm/exit.c             |  33 +-
 arch/loongarch/kvm/intc/eiointc.c     | 553 +++++-----------------------------
 arch/loongarch/kvm/intc/ipi.c         |  28 +-
 arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
 arch/loongarch/kvm/interrupt.c        |  25 +-
 arch/loongarch/kvm/trace.h            |  14 +-
 arch/loongarch/kvm/vcpu.c             |   8 +-
 8 files changed, 132 insertions(+), 545 deletions(-)


