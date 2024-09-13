Return-Path: <kvm+bounces-26790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB5F977BB4
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 10:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0294F1C21826
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 08:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2461D6C79;
	Fri, 13 Sep 2024 08:58:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CBD1BCA19;
	Fri, 13 Sep 2024 08:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726217907; cv=none; b=s8lX6RU2O7KHRoiaLRDH7MlWeLVT2nDpX5/QhCKlWmuYgfFxmpLKnQSy7DIj9XUOxtOyuNR6zzM0P5E8mRvEbJU7MH8JkhGp94B83Crx9Vxpi67uERcWLq++P0FH2SpdHCXQVfMRrS1cO4jxJ8cMZ4VGqkI64xQBJLWkqShji1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726217907; c=relaxed/simple;
	bh=Yv0iyO0UW2UAeKCgOTz1Nbm9Qzb5EKZbJShs5oHwKwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OiuVjRY8BPgUrZjEqHhDRfxPLKnkzZQgnAZ0rHFzs428C0t2bjHv3BhfzzewE+YzUaU6MYRa3VtxbggTcuMRzG74PL5q2g9boWP2wVdSCGBtmISbrA9/YPUB/t/FqM29lEl+SWPKyo3WthTEHPWK43RvnaIIwwv8XItEDZ+H7PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58209C4CEC0;
	Fri, 13 Sep 2024 08:58:24 +0000 (UTC)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.12
Date: Fri, 13 Sep 2024 16:58:12 +0800
Message-ID: <20240913085812.1030686-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following changes since commit da3ea35007d0af457a0afc87e84fddaebc4e0b63:

  Linux 6.11-rc7 (2024-09-08 14:50:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.12

for you to fetch changes up to 3abb708ec0be25da16a1ee9f1ab5cbc93f3256f3:

  LoongArch: KVM: Implement function kvm_para_has_feature() (2024-09-12 22:56:14 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.12

1. Revert qspinlock to test-and-set simple lock on VM.
2. Add Loongson Binary Translation extension support.
3. Add PMU support for guest.
4. Enable paravirt feature control from VMM.
5. Implement function kvm_para_has_feature().

----------------------------------------------------------------
Bibo Mao (6):
      LoongArch: Revert qspinlock to test-and-set simple lock on VM
      LoongArch: KVM: Add VM feature detection function
      LoongArch: KVM: Add Binary Translation extension support
      LoongArch: KVM: Add vm migration support for LBT registers
      LoongArch: KVM: Enable paravirt feature control from VMM
      LoongArch: KVM: Implement function kvm_para_has_feature()

Song Gao (1):
      LoongArch: KVM: Add PMU support for guest

 arch/loongarch/include/asm/Kbuild          |   1 -
 arch/loongarch/include/asm/kvm_csr.h       |   6 +
 arch/loongarch/include/asm/kvm_host.h      |  37 +++-
 arch/loongarch/include/asm/kvm_para.h      |  12 +
 arch/loongarch/include/asm/kvm_vcpu.h      |  11 +
 arch/loongarch/include/asm/loongarch.h     |  11 +-
 arch/loongarch/include/asm/paravirt.h      |   7 +
 arch/loongarch/include/asm/qspinlock.h     |  41 ++++
 arch/loongarch/include/uapi/asm/Kbuild     |   2 -
 arch/loongarch/include/uapi/asm/kvm.h      |  20 ++
 arch/loongarch/include/uapi/asm/kvm_para.h |  21 ++
 arch/loongarch/kernel/paravirt.c           |  47 ++--
 arch/loongarch/kernel/setup.c              |   2 +
 arch/loongarch/kernel/smp.c                |   4 +-
 arch/loongarch/kvm/exit.c                  |  46 ++--
 arch/loongarch/kvm/vcpu.c                  | 340 ++++++++++++++++++++++++++++-
 arch/loongarch/kvm/vm.c                    |  69 +++++-
 17 files changed, 616 insertions(+), 61 deletions(-)
 create mode 100644 arch/loongarch/include/asm/qspinlock.h
 create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h

