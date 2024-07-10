Return-Path: <kvm+bounces-21282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10DB592CD66
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A73091F213FB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1C113B597;
	Wed, 10 Jul 2024 08:46:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B63AC0C;
	Wed, 10 Jul 2024 08:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720601204; cv=none; b=hwQzOFIPj3K1uwPzZ14whK0YJ6mWNVPe8jJhqFXuepjew80Ag6PSbOGKUQFH+T/Fd7gI0dslWFgaRb7+wSFKMbPf5fAs+B50rO6jzcGlPymQHBfvj54mpmzVWkLL0JHdi9AkAYvxajmi6OBGmrqf/u29pNNAFDt4vHvvcFlASkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720601204; c=relaxed/simple;
	bh=Cmo/AXaenWF8sdqaQkQAQdmAJ2X7SEE2lgcGXtbm0po=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dx52qy+pRs3Jyv2lJ2R42BTb3+rlGraOiZmjW5TI/AH8uAkyL2lahy9gVRQNjCd6AMvHODfBWX8RWTQoYLqp4FrClGuDBpZ4GH1vitjkH8/NfaKECAg5+eWOtYJf7h2+oTEvML7Ysc5hd7yJl//c/xjxdi16fJjvy/Wi2PgkYUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC47FC32781;
	Wed, 10 Jul 2024 08:46:41 +0000 (UTC)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.11
Date: Wed, 10 Jul 2024 16:46:30 +0800
Message-ID: <20240710084630.2553263-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following changes since commit 256abd8e550ce977b728be79a74e1729438b4948:

  Linux 6.10-rc7 (2024-07-07 14:23:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.11

for you to fetch changes up to b3403f8d3c3fd8398bb5f23fe4f69faa738f1399:

  perf kvm: Add kvm-stat for loongarch64 (2024-07-09 16:25:51 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.11

1. Add ParaVirt steal time support.
2. Add some VM migration enhancement.
3. Add perf kvm-stat support for loongarch.

----------------------------------------------------------------
Bibo Mao (10):
      LoongArch: KVM: Sync pending interrupt when getting ESTAT from user mode
      LoongArch: KVM: Delay secondary mmu tlb flush until guest entry
      LoongArch: KVM: Select huge page only if secondary mmu supports it
      LoongArch: KVM: Discard dirty page tracking on readonly memslot
      LoongArch: KVM: Add memory barrier before update pmd entry
      LoongArch: KVM: Add dirty bitmap initially all set support
      LoongArch: KVM: Mark page accessed and dirty with page ref added
      LoongArch: KVM: Add PV steal time support in host side
      LoongArch: KVM: Add PV steal time support in guest side
      perf kvm: Add kvm-stat for loongarch64

Jia Qingtong (1):
      LoongArch: KVM: always make pte young in page map's fast path

 Documentation/admin-guide/kernel-parameters.txt |   6 +-
 arch/loongarch/Kconfig                          |  11 ++
 arch/loongarch/include/asm/kvm_host.h           |  13 ++
 arch/loongarch/include/asm/kvm_para.h           |  11 ++
 arch/loongarch/include/asm/kvm_vcpu.h           |   5 +
 arch/loongarch/include/asm/loongarch.h          |   1 +
 arch/loongarch/include/asm/paravirt.h           |   5 +
 arch/loongarch/include/uapi/asm/kvm.h           |   4 +
 arch/loongarch/kernel/paravirt.c                | 145 ++++++++++++++++++++++
 arch/loongarch/kernel/time.c                    |   2 +
 arch/loongarch/kvm/Kconfig                      |   1 +
 arch/loongarch/kvm/exit.c                       |  38 +++++-
 arch/loongarch/kvm/main.c                       |   1 +
 arch/loongarch/kvm/mmu.c                        |  72 +++++++----
 arch/loongarch/kvm/tlb.c                        |   5 +-
 arch/loongarch/kvm/vcpu.c                       | 154 +++++++++++++++++++++++-
 tools/perf/arch/loongarch/Makefile              |   1 +
 tools/perf/arch/loongarch/util/Build            |   2 +
 tools/perf/arch/loongarch/util/header.c         |  96 +++++++++++++++
 tools/perf/arch/loongarch/util/kvm-stat.c       | 139 +++++++++++++++++++++
 20 files changed, 680 insertions(+), 32 deletions(-)
 create mode 100644 tools/perf/arch/loongarch/util/header.c
 create mode 100644 tools/perf/arch/loongarch/util/kvm-stat.c

