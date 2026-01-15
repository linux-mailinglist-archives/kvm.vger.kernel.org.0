Return-Path: <kvm+bounces-68167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C7E9D23A6F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 10:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F57230CB192
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 09:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AF235F8B3;
	Thu, 15 Jan 2026 09:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkDdcCVO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C87F35F8AA;
	Thu, 15 Jan 2026 09:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768469427; cv=none; b=lStsQEruo1qWP993fpt08pP1CBkBCzdK1LcCCPX80vqZ49JWGGVtWot/XrTX8dUP0AfLz/QsCYFLEVI8sPYeRnUAlgTC+Y0VuA21FBcUEPBNIkDtSpHuMaF7VWwxb2MMMAWfS2W4kGWKnaN8RBX2wH4ipVBbpOUz+aQSxVwrgQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768469427; c=relaxed/simple;
	bh=cJNKCP0S+IAx/bWZM2AbRlGc+iRV/rZqSadbifWheuY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kAl91iwTAQYleFndRNSgiTtkA1QtMvkbUXEfKtQwyR7yN6BN57yMq5o38YJj9k475UwXYnKDztaDcnrXODevIJGYuC6iVpWfG12rNuUHJwqhGnMW5LP0XRYanhFQugU0XJdjufOqHc5zEFYfQDjmPj9LZ++fCX8DdgmgwZ2bEmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkDdcCVO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9557C19423;
	Thu, 15 Jan 2026 09:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768469426;
	bh=cJNKCP0S+IAx/bWZM2AbRlGc+iRV/rZqSadbifWheuY=;
	h=Date:From:To:Cc:Subject:From;
	b=mkDdcCVOGHX77maeQl0UPb+8HF67I611jGweU7DWQ5BdkuM+zuO2caUQu0OHCZmdD
	 YLwrmF1/fCjbgOdDs9bkzZvN0n6pc62/9/xfaT3kbaIk7amDoWsh4qm06zDYcBfoWz
	 qes/pfXsxNHTdOQU5VpQLkRLQ3wb64hH5tT2U43wdxdEyYDvyTXDKlpPdqVyAHYC8q
	 VTZUSrUem/taulqsB4Lu93fNcgSXrgy8ipfPFG3o3T1PlivWCjTUxzgC8W8VyxEn6X
	 i7MP23VjojUvwaTiLVSbdODq7A1jTZ1u6vOpCTdWvR+MYFFvEMzjDkbApJICzQUq+W
	 3LZF/dQqxqsPw==
Date: Thu, 15 Jan 2026 01:30:25 -0800
From: Oliver Upton <oupton@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: KVM/arm64 fixes for 6.19
Message-ID: <aWizsSzD3fRWMsAc@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paolo,

Here is the first (and likely only) set of fixes for 6.19. Small batch
of changes fixing issues in non-standard configurations like pKVM, hVHE,
and nested.

Details are in the tag, please pull.

Thanks,
Oliver

The following changes since commit f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da:

  Linux 6.19-rc3 (2025-12-28 13:24:26 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-6.19-1

for you to fetch changes up to 19cffd16ed6489770272ba383ff3aaec077e01ed:

  KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers (2026-01-10 02:19:52 -0800)

----------------------------------------------------------------
KVM/arm64 fixes for 6.19

 - Ensure early return semantics are preserved for pKVM fault handlers

 - Fix case where the kernel runs with the guest's PAN value when
   CONFIG_ARM64_PAN is not set

 - Make stage-1 walks to set the access flag respect the access
   permission of the underlying stage-2, when enabled

 - Propagate computed FGT values to the pKVM view of the vCPU at
   vcpu_load()

 - Correctly program PXN and UXN privilege bits for hVHE's stage-1 page
   tables

 - Check that the VM is actually using VGICv3 before accessing the GICv3
   CPU interface

 - Delete some unused code

----------------------------------------------------------------
Alexandru Elisei (4):
      KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
      KVM: arm64: Inject UNDEF for a register trap without accessor
      KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
      KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()

Dongxu Sun (1):
      KVM: arm64: Remove unused vcpu_{clear,set}_wfx_traps()

Marc Zyngier (2):
      KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
      KVM: arm64: Don't blindly set set PSTATE.PAN on guest exit

Oliver Upton (1):
      KVM: arm64: nv: Respect stage-2 write permssion when setting stage-1 AF

Sascha Bischoff (1):
      KVM: arm64: gic: Check for vGICv3 when clearing TWI

Will Deacon (1):
      KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers

 arch/arm64/include/asm/kvm_asm.h        |  2 ++
 arch/arm64/include/asm/kvm_emulate.h    | 16 ----------------
 arch/arm64/include/asm/kvm_pgtable.h    | 16 ++++++++++++----
 arch/arm64/include/asm/sysreg.h         |  3 ++-
 arch/arm64/kernel/image-vars.h          |  1 +
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/at.c                     |  8 ++++++--
 arch/arm64/kvm/hyp/entry.S              |  4 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  3 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  1 -
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/pgtable.c            |  5 +++--
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 arch/arm64/kvm/mmu.c                    | 12 +++++-------
 arch/arm64/kvm/sys_regs.c               |  5 ++++-
 arch/arm64/kvm/va_layout.c              | 28 ++++++++++++++++++++++++++++
 17 files changed, 73 insertions(+), 38 deletions(-)

