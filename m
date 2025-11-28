Return-Path: <kvm+bounces-64931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 90EDDC917DF
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 10:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C7F0834A62F
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 09:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841473054EC;
	Fri, 28 Nov 2025 09:44:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1E12FD667;
	Fri, 28 Nov 2025 09:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764323072; cv=none; b=mHcTW9K/n9mEBLNjgRBTKXsyDWso6kdCo8YYxL5Y56zOeTD24bq1e/5xqmPdgKG993OOgT2aqE1mIhHY7mrLnHC0GkFJH2H4iGSufZJbLH0GmatIeZkXwUKlxc4LVLcZYTM25ZlLr5uUKUC0AvScrsta5ASlGvl4bXeJua1VAZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764323072; c=relaxed/simple;
	bh=UNzCbSy2W2YDrIIKQDgzM+Oe91LtgyoMwXE5MdAHZ/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ctlcUnYpWxGeihQxrwd97ETaWdz9CfCk4n299Bts2+3XWIg09pcALNVJfO5PyQI5JoEpxnyrCR9t+H0AoXfcNUG2OuvPc08kYhFp78GTak3kmpX0OH5bJjk3wuHXS0Tdy0rhgeFxcEFGv4rxrNpr2MS9xnEaMGFX6g56zwwbnXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.68.219])
	by gateway (Coremail) with SMTP id _____8BxG9LlbilpKRApAA--.20584S3;
	Fri, 28 Nov 2025 17:44:05 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.68.219])
	by front1 (Coremail) with SMTP id qMiowJDxK8HXbilpRe5BAQ--.27776S2;
	Fri, 28 Nov 2025 17:44:01 +0800 (CST)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.19
Date: Fri, 28 Nov 2025 17:43:43 +0800
Message-ID: <20251128094343.621879-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxK8HXbilpRe5BAQ--.27776S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7WryDAry8try3tFWUXrykCrX_yoW5Jry5pa
	yfurnxKr4rGFy3Ar9rJ34kXryUtFn7Gr1Iv3W3try8Ar42vry8Jr1xKFykAFy3G3ykJry0
	vFyfGw15W3WUJacCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
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

The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.19

for you to fetch changes up to 0f90fa6e2e9d98349492d9968c11ceaf2f958c98:

  KVM: LoongArch: selftests: Add time counter test case (2025-11-28 14:49:48 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.19

1. Get VM PMU capability from HW GCFG register.
2. Add AVEC basic support.
3. Use 64-bit register definition for EIOINTC.
4. Add KVM timer test cases for tools/selftests.

----------------------------------------------------------------
Bibo Mao (8):
      LoongArch: KVM: Get VM PMU capability from HW GCFG register
      LoongArch: KVM: Use 64-bit register definition for EIOINTC
      KVM: LoongArch: selftests: Add system registers save/restore on exception
      KVM: LoongArch: selftests: Add basic interfaces
      KVM: LoongArch: selftests: Add exception handler register interface
      KVM: LoongArch: selftests: Add timer interrupt test case
      KVM: LoongArch: selftests: Add SW emulated timer test case
      KVM: LoongArch: selftests: Add time counter test case

Song Gao (1):
      LoongArch: KVM: Add AVEC basic support

 arch/loongarch/include/asm/kvm_eiointc.h           |  55 +-----
 arch/loongarch/include/asm/kvm_host.h              |   8 +
 arch/loongarch/include/asm/kvm_vcpu.h              |   1 +
 arch/loongarch/include/asm/loongarch.h             |   2 +
 arch/loongarch/include/uapi/asm/kvm.h              |   1 +
 arch/loongarch/kvm/intc/eiointc.c                  |  80 ++++-----
 arch/loongarch/kvm/interrupt.c                     |  15 +-
 arch/loongarch/kvm/vcpu.c                          |  19 +-
 arch/loongarch/kvm/vm.c                            |  40 +++--
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../selftests/kvm/include/loongarch/arch_timer.h   |  85 +++++++++
 .../selftests/kvm/include/loongarch/processor.h    |  81 ++++++++-
 .../selftests/kvm/lib/loongarch/exception.S        |   6 +
 .../selftests/kvm/lib/loongarch/processor.c        |  47 ++++-
 tools/testing/selftests/kvm/loongarch/arch_timer.c | 200 +++++++++++++++++++++
 15 files changed, 534 insertions(+), 107 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/loongarch/arch_timer.c


