Return-Path: <kvm+bounces-65034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AE6C98F78
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 21:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5A6743452FF
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 20:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6A825D209;
	Mon,  1 Dec 2025 20:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OpoGnI7p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31C9248F6A;
	Mon,  1 Dec 2025 20:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764619857; cv=none; b=qU6kILpmOjdsiOtfs9MScrQCaPeO1wg7pztYNjhY8pvVxOlHmgDe8PHYiyz0AoCb6yNMKvVsK89aTUTWQ9JtnoX8qGrTGSyWnVCqWazh+j6Owyv40BGz1ACep32+GEXwboqr2sFQVkmgwC2RrTBy3xPlXrSGfBmIHF9V+1RlyOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764619857; c=relaxed/simple;
	bh=rY4efxw1ZxhhV5xEW4DI/gzUAdUFghbdjtNe8WA+b1U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SnQ5AxS3J3QI5aXsmoJGFk8H7SL0FVRdPtrbJfmdSwwpcNLD/QDmtI8QU0GNsTAOIu+AcoEKTvKbU96mswDSTi9vSVNs3j698u9MW6s27EvF5OKHWJyc2blPzPxDh83JCMksoLSJ0UyUwrzq705wHnC7oRSdjCpw6ECnDREJ+nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OpoGnI7p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345AEC4CEF1;
	Mon,  1 Dec 2025 20:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764619857;
	bh=rY4efxw1ZxhhV5xEW4DI/gzUAdUFghbdjtNe8WA+b1U=;
	h=Date:From:To:Cc:Subject:From;
	b=OpoGnI7pZDVa02dbu+O/wuCGRNlTbliW1qjSbosj95dSGS8vsEBj6tNHFdRpvbTyg
	 HI6P2K7CiaDWoLWvdiiXUcvwgbSJt8nsTP3suAFE9MaWWWAF6MIoFkm0YNUFbUA5TS
	 Ga/MLoMsARWOURMgpfTOKL4CUlomdd2GyUla8CtcgIFnV92N3p4xF2uTBJwE5wOdph
	 kakoBsp3Fi2K5V3keXV6i92UDsaaJgrGJE6F0cYvhLty71Sr4UEQ2cQlzI0cyXTE1A
	 am1u0EYwLHrnHmxeae9SJQLIOm8YKkrK1IU2Pg5hLd9/dNxuaI7Xh9bVsuLP0yrYrC
	 8KfRA4mxr9QCw==
Date: Mon, 1 Dec 2025 12:10:55 -0800
From: Oliver Upton <oupton@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 updates for 6.19
Message-ID: <aS32T_UxeEfbeJx6@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paolo,

Now that I'm back from the holiday, here's the bulk of the 6.19 content. The
MMU changes look a little newer than they actually are (have been sitting in -next
for more than a week) because I squashed a fixup to avoid introducing bisection
issues.

As always, details can be found in the tag. There's an extremely minor conflict with
fixes that Marc queued in 6.18, my resolution is included at the end. Sorry about the
wrinkle, will try to avoid next time.

Please pull.

Thanks,
Oliver

The following changes since commit dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa:

  Linux 6.18-rc3 (2025-10-26 15:59:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-6.19

for you to fetch changes up to 3eef0c83c3f3e58933e98e678ddf4e95457d4d14:

  Merge branch 'kvm-arm64/nv-xnx-haf' into kvmarm/next (2025-12-01 00:47:41 -0800)

----------------------------------------------------------------
KVM/arm64 updates for 6.19

 - Support for userspace handling of synchronous external aborts (SEAs),
   allowing the VMM to potentially handle the abort in a non-fatal
   manner.

 - Large rework of the VGIC's list register handling with the goal of
   supporting more active/pending IRQs than available list registers in
   hardware. In addition, the VGIC now supports EOImode==1 style
   deactivations for IRQs which may occur on a separate vCPU than the
   one that acked the IRQ.

 - Support for FEAT_XNX (user / privileged execute permissions) and
   FEAT_HAF (hardware update to the Access Flag) in the software page
   table walkers and shadow MMU.

 - Allow page table destruction to reschedule, fixing long need_resched
   latencies observed when destroying a large VM.

 - Minor fixes to KVM and selftests

----------------------------------------------------------------
Alexandru Elisei (3):
      KVM: arm64: Document KVM_PGTABLE_PROT_{UX,PX}
      KVM: arm64: at: Use correct HA bit in TCR_EL2 when regime is EL2
      KVM: arm64: at: Update AF on software walk only if VM has FEAT_HAFDBS

Colin Ian King (1):
      KVM: arm64: Fix spelling mistake "Unexpeced" -> "Unexpected"

Jiaqi Yan (3):
      KVM: arm64: VM exit to userspace to handle SEA
      KVM: selftests: Test for KVM_EXIT_ARM_SEA
      Documentation: kvm: new UAPI for handling SEA

Marc Zyngier (51):
      irqchip/gic: Add missing GICH_HCR control bits
      irqchip/gic: Expose CPU interface VA to KVM
      irqchip/apple-aic: Spit out ICH_MISR_EL2 value on spurious vGIC MI
      KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant
      KVM: arm64: vgic-v3: Fix GICv3 trapping in protected mode
      KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping
      KVM: arm64: Repack struct vgic_irq fields
      KVM: arm64: Add tracking of vgic_irq being present in a LR
      KVM: arm64: Add LR overflow handling documentation
      KVM: arm64: GICv3: Drop LPI active state when folding LRs
      KVM: arm64: GICv3: Preserve EOIcount on exit
      KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
      KVM: arm64: GICv3: Extract LR folding primitive
      KVM: arm64: GICv3: Extract LR computing primitive
      KVM: arm64: GICv2: Preserve EOIcount on exit
      KVM: arm64: GICv2: Decouple GICH_HCR programming from LRs being loaded
      KVM: arm64: GICv2: Extract LR folding primitive
      KVM: arm64: GICv2: Extract LR computing primitive
      KVM: arm64: Compute vgic state irrespective of the number of interrupts
      KVM: arm64: Eagerly save VMCR on exit
      KVM: arm64: Revamp vgic maintenance interrupt configuration
      KVM: arm64: Turn kvm_vgic_vcpu_enable() into kvm_vgic_vcpu_reset()
      KVM: arm64: Make vgic_target_oracle() globally available
      KVM: arm64: Invert ap_list sorting to push active interrupts out
      KVM: arm64: Move undeliverable interrupts to the end of ap_list
      KVM: arm64: Use MI to detect groups being enabled/disabled
      KVM: arm64: GICv3: Handle LR overflow when EOImode==0
      KVM: arm64: GICv3: Handle deactivation via ICV_DIR_EL1 traps
      KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
      KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR capacity
      KVM: arm64: GICv3: Add SPI tracking to handle asymmetric deactivation
      KVM: arm64: GICv3: Handle in-LR deactivation when possible
      KVM: arm64: GICv3: Avoid broadcast kick on CPUs lacking TDIR
      KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early for better MI emulation
      KVM: arm64: GICv3: nv: Plug L1 LR sync into deactivation primitive
      KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
      KVM: arm64: GICv2: Handle LR overflow when EOImode==0
      KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps
      KVM: arm64: GICv2: Always trap GICV_DIR register
      KVM: arm64: selftests: gic_v3: Add irq group setting helper
      KVM: arm64: selftests: gic_v3: Disable Group-0 interrupts by default
      KVM: arm64: selftests: vgic_irq: Fix GUEST_ASSERT_IAR_EMPTY() helper
      KVM: arm64: selftests: vgic_irq: Change configuration before enabling interrupt
      KVM: arm64: selftests: vgic_irq: Exclude timer-controlled interrupts
      KVM: arm64: selftests: vgic_irq: Remove LR-bound limitation
      KVM: arm64: selftests: vgic_irq: Perform EOImode==1 deactivation in ack order
      KVM: arm64: selftests: vgic_irq: Add asymmetric SPI deaectivation test
      KVM: arm64: selftests: vgic_irq: Add Group-0 enable test
      KVM: arm64: selftests: vgic_irq: Add timer deactivation test
      KVM: arm64: Convert ICH_HCR_EL2_TDIR cap to EARLY_LOCAL_CPU_FEATURE
      KVM: arm64: Add endian casting to kvm_swap_s[12]_desc()

Maximilian Dittgen (2):
      KVM: selftests: Assert GICR_TYPER.Processor_Number matches selftest CPU number
      KVM: selftests: SYNC after guest ITS setup in vgic_lpi_stress

Nathan Chancellor (1):
      KVM: arm64: Add break to default case in kvm_pgtable_stage2_pte_prot()

Oliver Upton (23):
      KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
      KVM: arm64: Use kvzalloc() for kvm struct allocation
      KVM: arm64: Only drop references on empty tables in stage2_free_walker
      arm64: Detect FEAT_XNX
      KVM: arm64: Add support for FEAT_XNX stage-2 permissions
      KVM: arm64: nv: Forward FEAT_XNX permissions to the shadow stage-2
      KVM: arm64: Teach ptdump about FEAT_XNX permissions
      KVM: arm64: nv: Advertise support for FEAT_XNX
      KVM: arm64: Call helper for reading descriptors directly
      KVM: arm64: nv: Stop passing vCPU through void ptr in S2 PTW
      KVM: arm64: Handle endianness in read helper for emulated PTW
      KVM: arm64: nv: Use pgtable definitions in stage-2 walk
      KVM: arm64: Add helper for swapping guest descriptor
      KVM: arm64: Propagate PTW errors up to AT emulation
      KVM: arm64: Implement HW access flag management in stage-1 SW PTW
      KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW
      KVM: arm64: nv: Expose hardware access flag management to NV guests
      KVM: arm64: selftests: Add test for AT emulation
      KVM: arm64: Fix compilation when CONFIG_ARM64_USE_LSE_ATOMICS=n
      Merge branch 'kvm-arm64/misc' into kvmarm/next
      Merge branch 'kvm-arm64/sea-user' into kvmarm/next
      Merge branch 'kvm-arm64/vgic-lr-overflow' into kvmarm/next
      Merge branch 'kvm-arm64/nv-xnx-haf' into kvmarm/next

Raghavendra Rao Ananta (2):
      KVM: arm64: Split kvm_pgtable_stage2_destroy()
      KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables

 Documentation/virt/kvm/api.rst                     |  47 +++
 arch/arm64/include/asm/kvm_arm.h                   |   1 +
 arch/arm64/include/asm/kvm_asm.h                   |   8 +-
 arch/arm64/include/asm/kvm_host.h                  |   3 +
 arch/arm64/include/asm/kvm_hyp.h                   |   3 +-
 arch/arm64/include/asm/kvm_nested.h                |  40 +-
 arch/arm64/include/asm/kvm_pgtable.h               |  49 ++-
 arch/arm64/include/asm/kvm_pkvm.h                  |   4 +-
 arch/arm64/include/asm/virt.h                      |   7 +-
 arch/arm64/kernel/cpufeature.c                     |  59 +++
 arch/arm64/kernel/hyp-stub.S                       |   5 +
 arch/arm64/kernel/image-vars.h                     |   1 +
 arch/arm64/kvm/arm.c                               |  14 +-
 arch/arm64/kvm/at.c                                | 196 +++++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   7 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   3 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   5 +
 arch/arm64/kvm/hyp/pgtable.c                       | 122 +++++-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   4 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  96 +++--
 arch/arm64/kvm/mmu.c                               | 132 ++++++-
 arch/arm64/kvm/nested.c                            | 123 ++++--
 arch/arm64/kvm/pkvm.c                              |  11 +-
 arch/arm64/kvm/ptdump.c                            |  35 +-
 arch/arm64/kvm/sys_regs.c                          |  28 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   9 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |  24 ++
 arch/arm64/kvm/vgic/vgic-mmio.h                    |   1 +
 arch/arm64/kvm/vgic/vgic-v2.c                      | 291 ++++++++++----
 arch/arm64/kvm/vgic/vgic-v3-nested.c               | 104 ++---
 arch/arm64/kvm/vgic/vgic-v3.c                      | 426 ++++++++++++++++-----
 arch/arm64/kvm/vgic/vgic-v4.c                      |   5 +-
 arch/arm64/kvm/vgic/vgic.c                         | 298 ++++++++------
 arch/arm64/kvm/vgic/vgic.h                         |  43 ++-
 arch/arm64/tools/cpucaps                           |   2 +
 drivers/irqchip/irq-apple-aic.c                    |   7 +-
 drivers/irqchip/irq-gic.c                          |   3 +
 include/kvm/arm_vgic.h                             |  29 +-
 include/linux/irqchip/arm-gic.h                    |   6 +
 include/linux/irqchip/arm-vgic-info.h              |   2 +
 include/uapi/linux/kvm.h                           |  10 +
 tools/arch/arm64/include/asm/esr.h                 |   2 +
 tools/testing/selftests/kvm/Makefile.kvm           |   2 +
 tools/testing/selftests/kvm/arm64/at.c             | 166 ++++++++
 tools/testing/selftests/kvm/arm64/sea_to_user.c    | 331 ++++++++++++++++
 tools/testing/selftests/kvm/arm64/vgic_irq.c       | 285 ++++++++++++--
 .../testing/selftests/kvm/arm64/vgic_lpi_stress.c  |   4 +
 tools/testing/selftests/kvm/include/arm64/gic.h    |   1 +
 .../selftests/kvm/include/arm64/gic_v3_its.h       |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h     |   1 +
 tools/testing/selftests/kvm/lib/arm64/gic.c        |   6 +
 .../testing/selftests/kvm/lib/arm64/gic_private.h  |   1 +
 tools/testing/selftests/kvm/lib/arm64/gic_v3.c     |  22 ++
 tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c |  10 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  11 +
 55 files changed, 2575 insertions(+), 531 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/at.c
 create mode 100644 tools/testing/selftests/kvm/arm64/sea_to_user.ca

-- 
diff --cc arch/arm64/kvm/vgic/vgic-v3.c
index 968aa9d89be6,2f75ef14d339..1d6dd1b545bd
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@@ -507,9 -301,21 +507,10 @@@ void vcpu_set_ich_hcr(struct kvm_vcpu *
                return;
  
        /* Hide GICv3 sysreg if necessary */
-       if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+       if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2 ||
 -          !irqchip_in_kernel(vcpu->kvm)) {
++          !irqchip_in_kernel(vcpu->kvm))
                vgic_v3->vgic_hcr |= (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_TALL1 |
                                      ICH_HCR_EL2_TC);
 -              return;
 -      }
 -
 -      if (group0_trap)
 -              vgic_v3->vgic_hcr |= ICH_HCR_EL2_TALL0;
 -      if (group1_trap)
 -              vgic_v3->vgic_hcr |= ICH_HCR_EL2_TALL1;
 -      if (common_trap)
 -              vgic_v3->vgic_hcr |= ICH_HCR_EL2_TC;
 -      if (dir_trap)
 -              vgic_v3->vgic_hcr |= ICH_HCR_EL2_TDIR;
  }
  
  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)

