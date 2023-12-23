Return-Path: <kvm+bounces-5194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7279C81D3ED
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 13:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13DECB22DBB
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 12:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E1AD277;
	Sat, 23 Dec 2023 12:07:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8242CA58;
	Sat, 23 Dec 2023 12:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F56C433C8;
	Sat, 23 Dec 2023 12:07:06 +0000 (UTC)
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
Subject: [GIT PULL] LoongArch KVM changes for v6.8
Date: Sat, 23 Dec 2023 20:06:42 +0800
Message-Id: <20231223120642.1067728-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following changes since commit ceb6a6f023fd3e8b07761ed900352ef574010bcb:

  Linux 6.7-rc6 (2023-12-17 15:19:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.8

for you to fetch changes up to 118e10cd893d57df55b3302dfd188a981b6e6d1c:

  LoongArch: KVM: Add LASX (256bit SIMD) support (2023-12-19 10:48:28 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.8

1. Optimization for memslot hugepage checking.
2. Cleanup and fix some HW/SW timer issues.
3. Add LSX/LASX (128bit/256bit SIMD) support.

----------------------------------------------------------------
Bibo Mao (5):
      LoongArch: KVM: Optimization for memslot hugepage checking
      LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
      LoongArch: KVM: Allow to access HW timer CSR registers always
      LoongArch: KVM: Remove kvm_acquire_timer() before entering guest
      LoongArch: KVM: Fix timer emulation with oneshot mode

Tianrui Zhao (2):
      LoongArch: KVM: Add LSX (128bit SIMD) support
      LoongArch: KVM: Add LASX (256bit SIMD) support

 arch/loongarch/include/asm/kvm_host.h |  24 ++-
 arch/loongarch/include/asm/kvm_vcpu.h |  21 ++-
 arch/loongarch/include/uapi/asm/kvm.h |   1 +
 arch/loongarch/kernel/fpu.S           |   2 +
 arch/loongarch/kvm/exit.c             |  50 ++++--
 arch/loongarch/kvm/main.c             |   1 -
 arch/loongarch/kvm/mmu.c              | 124 +++++++++-----
 arch/loongarch/kvm/switch.S           |  31 ++++
 arch/loongarch/kvm/timer.c            | 129 ++++++++------
 arch/loongarch/kvm/trace.h            |   6 +-
 arch/loongarch/kvm/vcpu.c             | 307 ++++++++++++++++++++++++++++++----
 11 files changed, 551 insertions(+), 145 deletions(-)

