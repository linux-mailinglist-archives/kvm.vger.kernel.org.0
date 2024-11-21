Return-Path: <kvm+bounces-32246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 48FF19D48DC
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 09:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBE2DB2099A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 08:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49081CB9E1;
	Thu, 21 Nov 2024 08:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v0Sidx3g"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3891CEAA2
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 08:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732177724; cv=none; b=E9JXwysuQdstUx97i/jkq8OFx8/IqTpN1Ey+IBlTelsn1bEvHc1C414Ce9jYjdqrIuMjEbxZZ1/y5bgp4i96JChe/YvDXH8cb88rBIES1b1QUBUY+ifvucumUiepyFbnebOflrmQI7CvPa4gnOFULA/EwnTgJJ0tDxKaMuFmXxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732177724; c=relaxed/simple;
	bh=GorewAyWgy/vb7LhHovGiyB0c1Zf/rgjVfaujNbVJ2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YZUfOd4i+NI3aWQMYAw0eDzQ2kSobfbrvRFk8yOMFiagq7A97ETAecquEQkf+fiCngLlOpli0qvGEZqV8GG5mrkqValranP2yNTCWtfXIfzmUXrFNOSqbC6Tr04i1cP8q1g+0EOWXAFeXB3H1V6e8HV3nV+Ub/kR3cwaC0Z08Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v0Sidx3g; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 21 Nov 2024 00:28:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732177720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=fT4mo2O/Kb+ZV5pjk+qO0dVmgLQ2yuX8rkuU8VvdTdw=;
	b=v0Sidx3gbqlMK99CiIv13DU+wmLmXE0x0mW2fTKlitOecIvt1WQe6UPv5j0/46ifT4ZQjY
	ucGsxuW7xnC9fAMGlY+ibQD4l5yCApI/TB1B9N7wiEkfsRLOPM7/Lo4Tk+v7ZjQHFEF4sr
	nTasJngcSrkS5D4w7JLpC/MAmDCpGdg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [GIT PULL] First batch of KVM/arm64 fixes for 6.13
Message-ID: <Zz7vLEbLFXuRSPeo@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Had a surprising amount of fixes turn up over the past few days so it is
probably best to send the first batch your way. The LPI invalidation and
compilation fix are particularly concerning, rest of the details found in
the tag.

Please pull.

-- 
Thanks,
Oliver

The following changes since commit 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df:

  KVM: arm64: Pass on SVE mapping failures (2024-11-12 11:04:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-6.13-1

for you to fetch changes up to 13905f4547b050316262d54a5391d50e83ce613a:

  KVM: arm64: Use MDCR_EL2.HPME to evaluate overflow of hyp counters (2024-11-20 17:23:32 -0800)

----------------------------------------------------------------
KVM/arm64 changes for 6.13, part #2

 - Constrain invalidations from GICR_INVLPIR to only affect the LPI
   INTID space

 - Set of robustness improvements to the management of vgic irqs and GIC
   ITS table entries

 - Fix compilation issue w/ CONFIG_CC_OPTIMIZE_FOR_SIZE=y where
   set_sysreg_masks() wasn't getting inlined, breaking check for a
   constant sysreg index

 - Correct KVM's vPMU overflow condition to match the architecture for
   hyp and non-hyp counters

----------------------------------------------------------------
Marc Zyngier (5):
      KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR
      KVM: arm64: vgic: Make vgic_get_irq() more robust
      KVM: arm64: vgic: Kill VGIC_MAX_PRIVATE definition
      KVM: arm64: vgic-its: Add stronger type-checking to the ITS entry sizes
      KVM: arm64: Mark set_sysreg_masks() as inline to avoid build failure

Oliver Upton (1):
      KVM: arm64: Use MDCR_EL2.HPME to evaluate overflow of hyp counters

Raghavendra Rao Ananta (1):
      KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status

 arch/arm64/kvm/nested.c            |  2 +-
 arch/arm64/kvm/pmu-emul.c          | 62 +++++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic-debug.c   |  5 ++-
 arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c     | 77 ++++++++++++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 12 +++---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 13 +++++--
 arch/arm64/kvm/vgic/vgic-mmio.c    | 38 +++++++++----------
 arch/arm64/kvm/vgic/vgic-v2.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-v4.c      |  4 +-
 arch/arm64/kvm/vgic/vgic.c         | 43 +++++++++++++--------
 arch/arm64/kvm/vgic/vgic.h         | 27 +------------
 include/kvm/arm_vgic.h             |  1 -
 14 files changed, 172 insertions(+), 118 deletions(-)

