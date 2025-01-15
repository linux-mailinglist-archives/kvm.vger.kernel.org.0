Return-Path: <kvm+bounces-35493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6BCDA11769
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FA127A4215
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C99622F395;
	Wed, 15 Jan 2025 02:41:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA6F22F14C;
	Wed, 15 Jan 2025 02:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736908869; cv=none; b=bXyb9wMbuBcY+B1EY93dA75S8VOtaBi0HD45DqvXdewy6/Cn1fndJ7DegzIVCKZpGbP1pWvOS0gCHgmbm8w9jFlYoRyXCtcokjYgdkaF35wnfeGz7J/vxY7NHaG7PqWIq5l2Bm2csFoq+FiEX0fIaWPjgQea+9b/VtajKgvVk70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736908869; c=relaxed/simple;
	bh=mXezzYPrWVP6C/CeuVPlU6hV5c8VGCFZ/3yUTN2Qm+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AjT1X8qWXEVShMHHcGUhRlyPj70cAIrLRYKzcclgUGneYE7FNBe1AelUI4kZJxf3cckCzvw5tRac2v5N8a+756YDPjJWao/75vZeMVfjFXDZ8inyPSIBU951nYD5qlR33Jh6lhK7ioerTjRDqyFncM87oV1dspxt3ucBdMlt28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.68.63])
	by gateway (Coremail) with SMTP id _____8CxieE_IIdnr6hjAA--.2529S3;
	Wed, 15 Jan 2025 10:41:03 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.68.63])
	by front1 (Coremail) with SMTP id qMiowMAxPMU5IIdnpwgjAA--.9762S2;
	Wed, 15 Jan 2025 10:41:01 +0800 (CST)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.14
Date: Wed, 15 Jan 2025 10:40:54 +0800
Message-ID: <20250115024054.147630-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxPMU5IIdnpwgjAA--.9762S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Aw45GF1rJF4kZw47JF4UWrX_yoW8Gw4UpF
	13urnxGrs5GryfArnaqryUuryrJr18Gr1Sqa17Gr1rAF47Ar1UJr18Wrn5WFyUJ348Jr10
	qF1rJwn0gF1UJ3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17
	McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_
	JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU
	0xZFpf9x07jepB-UUUUU=

The following changes since commit 5bc55a333a2f7316b58edc7573e8e893f7acb532:

  Linux 6.13-rc7 (2025-01-12 14:37:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.14

for you to fetch changes up to 2737dee1067c2fc02256b2b15dab158c5e840568:

  LoongArch: KVM: Add hypercall service support for usermode VMM (2025-01-13 21:37:17 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.14

1. Clear LLBCTL if secondary mmu mapping changed.
2. Add hypercall service support for usermode VMM.

This is a really small changeset, because the Chinese New Year
(Spring Festival) is coming. Happy New Year!

----------------------------------------------------------------
Bibo Mao (2):
      LoongArch: KVM: Clear LLBCTL if secondary mmu mapping is changed
      LoongArch: KVM: Add hypercall service support for usermode VMM

 arch/loongarch/include/asm/kvm_host.h      |  1 +
 arch/loongarch/include/asm/kvm_para.h      |  3 +++
 arch/loongarch/include/asm/kvm_vcpu.h      |  1 +
 arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
 arch/loongarch/kvm/exit.c                  | 30 ++++++++++++++++++++++++++++++
 arch/loongarch/kvm/main.c                  | 18 ++++++++++++++++++
 arch/loongarch/kvm/vcpu.c                  |  7 ++++++-
 7 files changed, 60 insertions(+), 1 deletion(-)


