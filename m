Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFFE4963FB
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 18:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379053AbiAUReb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 12:34:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239235AbiAURe3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 12:34:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642786468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hkX7uanX/Wp74da1Lk0w8ws9FYTadAX92yNlbrUgWq8=;
        b=ee3caPdEwDwzb0jkXXrrt/LEbIAbWcbSK/8RBfI6dMPW8bDFxufvDKKpTPmmx+aw1if63I
        n+mgityaEF+y3NrW6WLstsdEoDqRhzVuZSSGgP16tlpT7S8jGSB/9gs2C07Wm5C5Kh4Dh0
        xihLDq9ZN/PO2UtQvz9m/7MrF+KsINI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-1kZHIu-5PvaVftp4Uk21zA-1; Fri, 21 Jan 2022 12:34:24 -0500
X-MC-Unique: 1kZHIu-5PvaVftp4Uk21zA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A30F94EEE;
        Fri, 21 Jan 2022 17:34:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1C6210A48C4;
        Fri, 21 Jan 2022 17:34:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 5.17
Date:   Fri, 21 Jan 2022 12:34:22 -0500
Message-Id: <20220121173422.2056022-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit c862dcd199759d4a45e65dab47b03e3e8a144e3a:

  x86/fpu: Fix inline prefix warnings (2022-01-14 13:48:38 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e2e83a73d7ce66f62c7830a85619542ef59c90e4:

  docs: kvm: fix WARNINGs from api.rst (2022-01-20 12:13:35 -0500)

----------------------------------------------------------------
Generic:
- selftest compilation fix for non-x86

- KVM: avoid warning on s390 in mark_page_dirty

x86:
- fix page write-protection bug and improve comments

- use binary search to lookup the PMU event filter, add test

- enable_pmu module parameter support for Intel CPUs

- switch blocked_vcpu_on_cpu_lock to raw spinlock

- cleanups of blocked vCPU logic

- partially allow KVM_SET_CPUID{,2} after KVM_RUN (5.16 regression)

- various small fixes

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: avoid warning on s390 in mark_page_dirty

David Matlack (4):
      KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU
      KVM: x86/mmu: Clear MMU-writable during changed_pte notifier
      KVM: x86/mmu: Document and enforce MMU-writable and Host-writable invariants
      KVM: x86/mmu: Improve TLB flush comment in kvm_mmu_slot_remove_write_access()

Jim Mattson (6):
      KVM: x86/pmu: Use binary search to check filtered events
      selftests: kvm/x86: Parameterize the CPUID vendor string check
      selftests: kvm/x86: Introduce is_amd_cpu()
      selftests: kvm/x86: Export x86_family() for use outside of processor.c
      selftests: kvm/x86: Introduce x86_model()
      selftests: kvm/x86: Add test for KVM_SET_PMU_EVENT_FILTER

Jinrong Liang (2):
      selftests: kvm/x86: Fix the warning in pmu_event_filter_test.c
      selftests: kvm/x86: Fix the warning in lib/x86_64/processor.c

Like Xu (3):
      KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event
      KVM: x86: Making the module parameter of vPMU more common
      KVM: x86/cpuid: Clear XFD for component i if the base feature is missing

Marcelo Tosatti (1):
      KVM: VMX: switch blocked_vcpu_on_cpu_lock to raw spinlock

Muhammad Usama Anjum (1):
      selftests: kvm: add amx_test to .gitignore

Paolo Bonzini (3):
      Merge branch 'kvm-pi-raw-spinlock' into HEAD
      kvm: selftests: sync uapi/linux/kvm.h with Linux header
      kvm: selftests: Do not indent with spaces

Sean Christopherson (20):
      KVM: VMX: Reject KVM_RUN if emulation is required with pending exception
      KVM: selftests: Add a test to force emulation with a pending exception
      KVM: VMX: Handle PI descriptor updates during vcpu_put/load
      KVM: Drop unused kvm_vcpu.pre_pcpu field
      KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
      KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
      KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
      KVM: x86: Remove defunct pre_block/post_block kvm_x86_ops hooks
      KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
      KVM: SVM: Don't bother checking for "running" AVIC when kicking for IPIs
      KVM: SVM: Remove unnecessary APICv/AVIC update in vCPU unblocking path
      KVM: SVM: Use kvm_vcpu_is_blocking() in AVIC load to handle preemption
      KVM: SVM: Skip AVIC and IRTE updates when loading blocking vCPU
      KVM: VMX: Don't do full kick when triggering posted interrupt "fails"
      KVM: VMX: Pass desired vector instead of bool for triggering posted IRQ
      KVM: VMX: Fold fallback path into triggering posted IRQ helper
      KVM: VMX: Don't do full kick when handling posted interrupt wakeup
      KVM: SVM: Drop AVIC's intermediate avic_set_running() helper
      KVM: SVM: Move svm_hardware_setup() and its helpers below svm_x86_ops
      KVM: SVM: Nullify vcpu_(un)blocking() hooks if AVIC is disabled

Vitaly Kuznetsov (4):
      KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries
      KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
      KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
      KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN

Wei Wang (2):
      kvm: selftests: conditionally build vm_xsave_req_perm()
      docs: kvm: fix WARNINGs from api.rst

 .mailmap                                           |   2 +
 .../admin-guide/blockdev/drbd/figures.rst          |   4 +-
 .../drbd/{node-states-8.dot => peer-states-8.dot}  |   5 -
 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Documentation/conf.py                              |  15 +-
 .../devicetree/bindings/i2c/apple,i2c.yaml         |   8 +-
 .../bindings/iio/adc/samsung,exynos-adc.yaml       |   2 +-
 .../devicetree/bindings/input/gpio-keys.yaml       |   2 +-
 .../bindings/media/nxp,imx7-mipi-csi2.yaml         |  14 +-
 .../devicetree/bindings/net/ethernet-phy.yaml      |   8 +
 .../devicetree/bindings/phy/xlnx,zynqmp-psgtr.yaml |   2 +-
 .../devicetree/bindings/power/supply/bq25980.yaml  |   2 +-
 .../bindings/regulator/samsung,s5m8767.yaml        |  25 +
 .../devicetree/bindings/sound/wlf,wm8962.yaml      |   3 +
 .../devicetree/bindings/spi/cdns,qspi-nor.yaml     |   1 +
 .../devicetree/bindings/spi/spi-rockchip.yaml      |   1 +
 Documentation/i2c/summary.rst                      |   8 +-
 Documentation/locking/locktypes.rst                |   9 +-
 Documentation/networking/bonding.rst               |  11 +-
 .../ethernet/freescale/dpaa2/overview.rst          |   1 +
 .../device_drivers/ethernet/intel/ixgbe.rst        |  16 +
 Documentation/networking/ip-sysctl.rst             |   6 +-
 Documentation/networking/timestamping.rst          |   4 +-
 Documentation/process/changes.rst                  |  11 +
 Documentation/process/submitting-patches.rst       |   3 +-
 Documentation/sound/hd-audio/models.rst            |   2 +
 Documentation/virt/kvm/api.rst                     |   6 +-
 MAINTAINERS                                        |  37 +-
 Makefile                                           |  14 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |   2 +
 arch/arm/boot/dts/bcm283x.dtsi                     |   2 +
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi           |   1 +
 arch/arm/boot/dts/imx6qp-prtwd3.dts                |   2 +
 arch/arm/boot/dts/imx6ull-pinfunc.h                |   2 +-
 arch/arm/boot/dts/ls1021a-tsn.dts                  |   2 +
 arch/arm/boot/dts/socfpga.dtsi                     |   2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi             |   2 +-
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts   |   2 +-
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts      |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts    |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts       |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts |   4 +-
 arch/arm/include/asm/efi.h                         |   1 -
 arch/arm/kernel/entry-armv.S                       |   8 +-
 arch/arm/kernel/head-nommu.S                       |   1 +
 arch/arm/mach-rockchip/platsmp.c                   |   2 +-
 arch/arm64/Kconfig.platforms                       |   1 -
 .../dts/allwinner/sun50i-h5-orangepi-zero-plus.dts |   2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   2 +-
 .../dts/amlogic/meson-axg-jethome-jethub-j100.dts  |  30 +-
 arch/arm64/boot/dts/apple/t8103-j274.dts           |   2 +-
 arch/arm64/boot/dts/apple/t8103.dtsi               |  11 +-
 .../arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts |   2 -
 .../boot/dts/freescale/fsl-lx2160a-bluebox3.dts    |   4 +
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |   4 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   2 -
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi      |   2 +-
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts     |   2 +-
 .../boot/dts/rockchip/rk3399-khadas-edge.dtsi      |   1 -
 .../boot/dts/rockchip/rk3399-kobol-helios64.dts    |   1 +
 arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi |   2 +-
 arch/arm64/include/asm/efi.h                       |   1 -
 arch/arm64/kernel/machine_kexec_file.c             |   1 +
 arch/csky/kernel/traps.c                           |   4 +-
 arch/mips/include/asm/mach-ralink/spaces.h         |   2 +
 arch/mips/include/asm/pci.h                        |   4 -
 arch/mips/net/bpf_jit_comp.h                       |   2 +-
 arch/mips/pci/pci-generic.c                        |   2 +
 arch/parisc/Kconfig                                |   5 -
 arch/parisc/include/asm/futex.h                    |   4 +-
 arch/parisc/kernel/syscall.S                       |   2 +-
 arch/parisc/kernel/traps.c                         |   2 +
 arch/powerpc/kernel/module_64.c                    |  42 +-
 arch/powerpc/mm/ptdump/ptdump.c                    |   2 +-
 arch/powerpc/platforms/85xx/smp.c                  |   4 +-
 .../riscv/boot/dts/sifive/hifive-unleashed-a00.dts |   1 +
 .../riscv/boot/dts/sifive/hifive-unmatched-a00.dts | 113 ++--
 arch/riscv/include/asm/efi.h                       |   1 -
 arch/s390/configs/debug_defconfig                  |   2 +
 arch/s390/configs/defconfig                        |   2 +
 arch/s390/kernel/ftrace.c                          |   2 -
 arch/s390/kernel/irq.c                             |   9 +-
 arch/s390/kernel/machine_kexec_file.c              |  38 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/efi.h                         |   2 -
 arch/x86/include/asm/kvm-x86-ops.h                 |   3 +-
 arch/x86/include/asm/kvm_host.h                    |  13 +-
 arch/x86/include/asm/pkru.h                        |   4 +-
 arch/x86/kernel/setup.c                            |  72 +--
 arch/x86/kernel/smpboot.c                          |  14 +
 arch/x86/kvm/cpuid.c                               |  79 ++-
 arch/x86/kvm/debugfs.c                             |   3 +
 arch/x86/kvm/lapic.c                               |   2 -
 arch/x86/kvm/mmu/mmu.c                             |  31 +-
 arch/x86/kvm/mmu/spte.c                            |   1 +
 arch/x86/kvm/mmu/spte.h                            |  42 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   6 +-
 arch/x86/kvm/pmu.c                                 |  33 +-
 arch/x86/kvm/svm/avic.c                            | 123 ++--
 arch/x86/kvm/svm/pmu.c                             |   2 +-
 arch/x86/kvm/svm/sev.c                             |   2 +-
 arch/x86/kvm/svm/svm.c                             | 490 ++++++++--------
 arch/x86/kvm/svm/svm.h                             |  17 +-
 arch/x86/kvm/vmx/capabilities.h                    |   4 +
 arch/x86/kvm/vmx/pmu_intel.c                       |  20 +-
 arch/x86/kvm/vmx/posted_intr.c                     | 183 +++---
 arch/x86/kvm/vmx/posted_intr.h                     |   8 +-
 arch/x86/kvm/vmx/vmx.c                             |  68 ++-
 arch/x86/kvm/vmx/vmx.h                             |   3 +
 arch/x86/kvm/x86.c                                 |  70 ++-
 arch/x86/kvm/x86.h                                 |   1 +
 arch/x86/net/bpf_jit_comp.c                        |  51 +-
 arch/x86/platform/efi/quirks.c                     |   3 +-
 arch/x86/tools/relocs.c                            |   2 +-
 block/blk-iocost.c                                 |   9 +-
 block/fops.c                                       |   4 +-
 block/ioprio.c                                     |   3 +
 drivers/Makefile                                   |   3 +-
 drivers/android/binder.c                           |  21 +-
 drivers/android/binder_alloc.c                     |   2 +-
 drivers/ata/ahci_ceva.c                            |   3 +-
 drivers/ata/libata-core.c                          |   2 +
 drivers/ata/libata-scsi.c                          |  15 +-
 drivers/auxdisplay/charlcd.c                       |   5 +-
 drivers/base/power/main.c                          |   2 +-
 drivers/block/xen-blkfront.c                       |  15 +-
 drivers/bus/mhi/core/pm.c                          |  21 +-
 drivers/bus/mhi/pci_generic.c                      |   2 +-
 drivers/bus/sunxi-rsb.c                            |   8 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  21 +-
 drivers/char/ipmi/ipmi_ssif.c                      |   7 +-
 drivers/clk/clk.c                                  |  15 +-
 drivers/clk/imx/clk-imx8qxp-lpcg.c                 |   2 +-
 drivers/clk/imx/clk-imx8qxp.c                      |   2 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   9 +
 drivers/clk/qcom/clk-regmap-mux.c                  |   2 +-
 drivers/clk/qcom/common.c                          |  12 +
 drivers/clk/qcom/common.h                          |   2 +
 drivers/clk/qcom/gcc-sm6125.c                      |   4 +-
 drivers/clk/versatile/clk-icst.c                   |   2 +-
 drivers/clocksource/arm_arch_timer.c               |   9 +-
 drivers/clocksource/dw_apb_timer_of.c              |   2 +-
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c     |   7 +
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   4 +-
 drivers/dma/dw-edma/dw-edma-pcie.c                 |  10 +-
 drivers/dma/idxd/irq.c                             |   2 +-
 drivers/dma/idxd/submit.c                          |  18 +-
 drivers/dma/st_fdma.c                              |   2 +-
 drivers/dma/ti/k3-udma.c                           | 157 +++--
 drivers/edac/i10nm_base.c                          |   9 +
 drivers/firmware/scpi_pm_domain.c                  |  10 +-
 drivers/firmware/tegra/bpmp-debugfs.c              |   5 +-
 drivers/gpio/gpio-aspeed-sgpio.c                   |   2 +-
 drivers/gpio/gpio-dln2.c                           |  19 +-
 drivers/gpio/gpio-virtio.c                         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  76 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  55 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          | 134 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c           |   1 -
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c           |   1 -
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c           |   1 -
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   8 +
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c            |   2 -
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |   7 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 .../amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c   |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   5 +-
 drivers/gpu/drm/amd/display/dc/dc_link.h           |   2 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   2 +-
 .../drm/amd/display/dc/dcn201/dcn201_resource.c    |   2 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   2 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |   2 +-
 .../drm/amd/display/dc/dcn301/dcn301_resource.c    |   2 +-
 .../drm/amd/display/dc/dcn302/dcn302_resource.c    |   2 +-
 .../drm/amd/display/dc/dcn303/dcn303_resource.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c  |   2 +
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |  27 +-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.h  |  31 +
 drivers/gpu/drm/amd/include/discovery.h            |  49 ++
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   7 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  15 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c     |   6 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   3 +
 drivers/gpu/drm/ast/ast_mode.c                     |   5 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   8 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   1 +
 drivers/gpu/drm/drm_syncobj.c                      |  11 +-
 drivers/gpu/drm/i915/display/intel_dmc.c           |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   3 +-
 drivers/gpu/drm/i915/gt/intel_gtt.c                |   1 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |  18 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |   6 +-
 drivers/gpu/drm/i915/i915_request.c                |   1 +
 drivers/gpu/drm/lima/lima_device.c                 |   1 +
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |  12 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |   1 +
 drivers/gpu/drm/nouveau/nouveau_fence.c            |  28 +-
 drivers/gpu/drm/tiny/simpledrm.c                   |   2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   3 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |   1 +
 drivers/hid/Kconfig                                |  10 +-
 drivers/hid/hid-asus.c                             |   6 +-
 drivers/hid/hid-bigbenff.c                         |   2 +-
 drivers/hid/hid-chicony.c                          |   3 +
 drivers/hid/hid-corsair.c                          |   7 +-
 drivers/hid/hid-elan.c                             |   2 +-
 drivers/hid/hid-elo.c                              |   3 +
 drivers/hid/hid-ft260.c                            |   3 +
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-holtek-kbd.c                       |   9 +-
 drivers/hid/hid-holtek-mouse.c                     |  24 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-input.c                            |   2 +
 drivers/hid/hid-lg.c                               |  10 +-
 drivers/hid/hid-logitech-dj.c                      |   2 +-
 drivers/hid/hid-prodikeys.c                        |  10 +-
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-roccat-arvo.c                      |   3 +
 drivers/hid/hid-roccat-isku.c                      |   3 +
 drivers/hid/hid-roccat-kone.c                      |   3 +
 drivers/hid/hid-roccat-koneplus.c                  |   3 +
 drivers/hid/hid-roccat-konepure.c                  |   3 +
 drivers/hid/hid-roccat-kovaplus.c                  |   3 +
 drivers/hid/hid-roccat-lua.c                       |   3 +
 drivers/hid/hid-roccat-pyra.c                      |   3 +
 drivers/hid/hid-roccat-ryos.c                      |   3 +
 drivers/hid/hid-roccat-savu.c                      |   3 +
 drivers/hid/hid-samsung.c                          |   3 +
 drivers/hid/hid-sony.c                             |  24 +-
 drivers/hid/hid-thrustmaster.c                     |   3 +
 drivers/hid/hid-u2fzero.c                          |   2 +-
 drivers/hid/hid-uclogic-core.c                     |   3 +
 drivers/hid/hid-uclogic-params.c                   |   3 +-
 drivers/hid/hid-vivaldi.c                          |   3 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   6 +-
 drivers/hid/wacom_sys.c                            |  19 +-
 drivers/hv/Kconfig                                 |   1 +
 drivers/hwmon/corsair-psu.c                        |   2 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   7 +-
 drivers/hwmon/lm90.c                               | 106 ++--
 drivers/hwmon/nct6775.c                            |   2 +-
 drivers/hwmon/pwm-fan.c                            |   2 -
 drivers/hwmon/sht4x.c                              |   4 +-
 drivers/i2c/busses/i2c-mpc.c                       |  17 +-
 drivers/i2c/busses/i2c-virtio.c                    |  32 +-
 drivers/i2c/i2c-core-base.c                        |  95 ----
 drivers/i2c/i2c-dev.c                              |   3 +
 drivers/iio/accel/kxcjk-1013.c                     |   5 +-
 drivers/iio/accel/kxsd9.c                          |   6 +-
 drivers/iio/accel/mma8452.c                        |   2 +-
 drivers/iio/adc/Kconfig                            |   2 +-
 drivers/iio/adc/ad7768-1.c                         |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   3 +-
 drivers/iio/adc/axp20x_adc.c                       |  18 +-
 drivers/iio/adc/dln2-adc.c                         |  21 +-
 drivers/iio/adc/stm32-adc.c                        |   3 +-
 drivers/iio/gyro/adxrs290.c                        |   5 +-
 drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
 drivers/iio/industrialio-trigger.c                 |   1 -
 drivers/iio/light/ltr501.c                         |   2 +-
 drivers/iio/light/stk3310.c                        |   6 +-
 drivers/iio/trigger/stm32-timer-trigger.c          |   2 +-
 drivers/infiniband/core/uverbs_marshall.c          |   2 +-
 drivers/infiniband/core/uverbs_uapi.c              |   3 +
 drivers/infiniband/hw/hfi1/chip.c                  |   2 +
 drivers/infiniband/hw/hfi1/driver.c                |   2 +
 drivers/infiniband/hw/hfi1/init.c                  |  40 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  78 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   8 +
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
 drivers/infiniband/hw/irdma/hw.c                   |   7 +-
 drivers/infiniband/hw/irdma/main.h                 |   1 +
 drivers/infiniband/hw/irdma/pble.c                 |   8 +-
 drivers/infiniband/hw/irdma/pble.h                 |   1 -
 drivers/infiniband/hw/irdma/utils.c                |  24 +-
 drivers/infiniband/hw/irdma/verbs.c                |  23 +-
 drivers/infiniband/hw/irdma/verbs.h                |   2 +
 drivers/infiniband/hw/qib/qib_user_sdma.c          |   2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  16 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   1 +
 drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c       |   9 +-
 drivers/input/joystick/spaceball.c                 |  11 +-
 drivers/input/misc/iqs626a.c                       |  21 +-
 drivers/input/mouse/appletouch.c                   |   4 +-
 drivers/input/mouse/elantech.c                     |   8 +-
 drivers/input/serio/i8042-x86ia64io.h              |  21 +
 drivers/input/serio/i8042.c                        |  54 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/input/touchscreen/elants_i2c.c             |  46 +-
 drivers/input/touchscreen/goodix.c                 |  31 +-
 drivers/input/touchscreen/goodix.h                 |   1 +
 drivers/input/touchscreen/goodix_fwupload.c        |   2 +-
 drivers/input/touchscreen/zinitix.c                |  18 +-
 drivers/irqchip/irq-apple-aic.c                    |   2 +-
 drivers/irqchip/irq-armada-370-xp.c                |  16 +-
 drivers/irqchip/irq-aspeed-scu-ic.c                |   4 +-
 drivers/irqchip/irq-bcm7120-l2.c                   |   1 +
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/irqchip/irq-mips-gic.c                     |   4 +-
 drivers/irqchip/irq-nvic.c                         |   2 +-
 drivers/isdn/mISDN/core.c                          |   6 +-
 drivers/isdn/mISDN/core.h                          |   4 +-
 drivers/isdn/mISDN/layer1.c                        |   4 +-
 drivers/md/bcache/super.c                          |   3 +-
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/md.c                                    |   4 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   2 +-
 drivers/md/raid1.c                                 |   3 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   4 -
 drivers/misc/eeprom/at25.c                         |  38 +-
 drivers/misc/fastrpc.c                             |  10 +-
 drivers/mmc/core/core.c                            |   7 +-
 drivers/mmc/core/core.h                            |   1 +
 drivers/mmc/core/host.c                            |   9 +
 drivers/mmc/host/meson-mx-sdhc-mmc.c               |  16 +
 drivers/mmc/host/mmci_stm32_sdmmc.c                |   2 +
 drivers/mmc/host/mtk-sd.c                          |   4 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   2 +-
 drivers/mmc/host/sdhci-tegra.c                     |  43 +-
 drivers/mtd/devices/mtd_dataflash.c                |   8 +
 drivers/mtd/nand/raw/Kconfig                       |   2 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |  36 +-
 drivers/mtd/nand/raw/nand_base.c                   |   6 +-
 drivers/net/bonding/bond_alb.c                     |  14 +-
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/can/kvaser_pciefd.c                    |   8 +-
 drivers/net/can/m_can/m_can.c                      |  42 +-
 drivers/net/can/m_can/m_can.h                      |   3 +
 drivers/net/can/m_can/m_can_pci.c                  |  62 +-
 drivers/net/can/pch_can.c                          |   2 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |   7 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 101 +++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  89 +--
 drivers/net/dsa/mv88e6xxx/port.c                   |   4 +-
 drivers/net/dsa/mv88e6xxx/serdes.c                 |   8 +-
 drivers/net/dsa/ocelot/felix.c                     |   5 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   9 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  49 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |   8 +
 drivers/net/ethernet/atheros/ag71xx.c              |  23 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |   4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   5 +-
 drivers/net/ethernet/broadcom/bcmsysport.h         |   1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   2 +
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   2 +-
 drivers/net/ethernet/freescale/fec.h               |   3 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/freescale/fman/fman_port.c    |  12 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |   1 -
 drivers/net/ethernet/google/gve/gve_adminq.c       |   8 +-
 drivers/net/ethernet/google/gve/gve_utils.c        |   3 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  20 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   3 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |   1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   8 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  60 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 115 ++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   2 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  43 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  11 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  17 +
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c        |  18 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |   4 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   7 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h     |   3 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  32 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  13 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |   6 +
 drivers/net/ethernet/intel/ice/ice_switch.c        |  19 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |  30 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  19 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   1 -
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   6 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  66 ++-
 drivers/net/ethernet/intel/igb/igb_main.c          |  47 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_i225.c          |   2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   6 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  15 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |   3 +
 drivers/net/ethernet/lantiq_xrx200.c               |  36 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |   2 +
 .../net/ethernet/marvell/prestera/prestera_main.c  |  35 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.h    |   2 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  35 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  48 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  33 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   6 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |   9 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   3 +-
 drivers/net/ethernet/micrel/ks8851_par.c           |   2 +
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |  10 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   7 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  19 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h  |   2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |  12 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |   4 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |   3 +
 drivers/net/ethernet/sfc/falcon/rx.c               |  10 +-
 drivers/net/ethernet/sfc/rx_common.c               |  10 +-
 drivers/net/ethernet/smsc/smc911x.c                |   5 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  17 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  16 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  86 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  29 +-
 drivers/net/fjes/fjes_main.c                       |   5 +
 drivers/net/hamradio/mkiss.c                       |   4 +-
 drivers/net/ieee802154/atusb.c                     |  10 +-
 drivers/net/netdevsim/bpf.c                        |   1 +
 drivers/net/netdevsim/ethtool.c                    |   5 +-
 drivers/net/phy/mdio_bus.c                         |   3 +
 drivers/net/phy/phylink.c                          |   1 +
 drivers/net/tun.c                                  | 115 ++--
 drivers/net/usb/asix_common.c                      |   8 +-
 drivers/net/usb/cdc_ncm.c                          |   2 +
 drivers/net/usb/lan78xx.c                          |   6 +
 drivers/net/usb/pegasus.c                          |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/r8152.c                            |  52 +-
 drivers/net/usb/rndis_host.c                       |   5 +
 drivers/net/veth.c                                 |   8 +-
 drivers/net/virtio_net.c                           |   9 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  13 +-
 drivers/net/vrf.c                                  |   8 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |   6 +-
 drivers/net/wireless/broadcom/brcm80211/Kconfig    |  14 +-
 .../wireless/broadcom/brcm80211/brcmsmac/Makefile  |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/led.h |   2 +-
 drivers/net/wireless/intel/iwlegacy/Kconfig        |   4 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   5 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c              |  26 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.h              |   4 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |   7 +-
 drivers/net/xen-netback/common.h                   |   1 +
 drivers/net/xen-netback/rx.c                       |  77 ++-
 drivers/net/xen-netfront.c                         | 125 +++-
 drivers/nfc/st21nfca/i2c.c                         |  29 +-
 drivers/nvme/host/core.c                           |  23 +-
 drivers/nvme/host/multipath.c                      |   3 +-
 drivers/nvme/host/nvme.h                           |   2 +-
 drivers/nvme/host/zns.c                            |   5 +-
 drivers/nvme/target/tcp.c                          |   9 +-
 drivers/of/irq.c                                   |  27 +-
 drivers/pci/controller/Kconfig                     |   4 +-
 drivers/pci/controller/dwc/pci-exynos.c            |   1 +
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |   1 +
 drivers/pci/controller/pci-aardvark.c              |   9 -
 drivers/pci/controller/pcie-apple.c                |  14 +-
 drivers/pci/msi.c                                  |  15 +-
 drivers/phy/hisilicon/phy-hi3670-pcie.c            |   4 +-
 drivers/phy/marvell/phy-mvebu-cp110-utmi.c         |   4 +-
 drivers/phy/qualcomm/phy-qcom-ipq806x-usb.c        |  26 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |   3 +
 drivers/phy/qualcomm/phy-qcom-usb-hsic.c           |   2 +-
 drivers/phy/st/phy-stm32-usbphyc.c                 |   2 +-
 drivers/phy/ti/phy-am654-serdes.c                  |   2 +-
 drivers/phy/ti/phy-j721e-wiz.c                     |   2 +-
 drivers/phy/ti/phy-omap-usb2.c                     |   6 +-
 drivers/phy/ti/phy-tusb1210.c                      |   2 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |  29 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |   8 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   8 +-
 drivers/platform/mellanox/mlxbf-pmc.c              |   4 +-
 drivers/platform/x86/Makefile                      |   2 +-
 drivers/platform/x86/amd-pmc.c                     |   5 +-
 drivers/platform/x86/apple-gmux.c                  |   2 +-
 drivers/platform/x86/intel/Kconfig                 |  15 -
 drivers/platform/x86/intel/hid.c                   |   7 +
 drivers/platform/x86/intel/pmc/pltdrv.c            |   2 +-
 drivers/platform/x86/lg-laptop.c                   |  12 +
 drivers/platform/x86/system76_acpi.c               |  58 +-
 drivers/platform/x86/thinkpad_acpi.c               |   6 +-
 drivers/platform/x86/touchscreen_dmi.c             |  18 +
 drivers/power/reset/ltc2952-poweroff.c             |   4 +-
 drivers/power/supply/bq25890_charger.c             |   4 +-
 drivers/power/supply/power_supply_core.c           |   4 +
 drivers/reset/reset-rzg2l-usbphy-ctrl.c            |   7 +-
 drivers/reset/tegra/reset-bpmp.c                   |   9 +-
 drivers/scsi/libiscsi.c                            |   6 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   4 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   6 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  38 +-
 drivers/scsi/qedi/qedi_fw.c                        |  37 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |   2 +-
 drivers/scsi/qedi/qedi_iscsi.h                     |   2 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   3 +
 drivers/scsi/scsi_debug.c                          |   2 +-
 drivers/scsi/vmw_pvscsi.c                          |   7 +-
 drivers/soc/imx/imx8m-blk-ctrl.c                   |  19 +
 drivers/soc/imx/soc-imx.c                          |   4 +
 drivers/soc/tegra/fuse/fuse-tegra.c                |   2 +-
 drivers/soc/tegra/fuse/fuse.h                      |   2 +-
 drivers/spi/spi-armada-3700.c                      |   2 +-
 drivers/tee/amdtee/core.c                          |   5 +-
 drivers/tee/optee/core.c                           |   6 +-
 drivers/tee/optee/smc_abi.c                        |   2 +
 drivers/tee/tee_shm.c                              | 174 +++---
 .../intel/int340x_thermal/processor_thermal_rfim.c |   2 +-
 drivers/tty/hvc/hvc_xen.c                          |  30 +-
 drivers/tty/n_hdlc.c                               |  23 +-
 drivers/tty/serial/8250/8250_fintek.c              |  20 -
 drivers/usb/cdns3/cdnsp-gadget.c                   |  12 +
 drivers/usb/cdns3/cdnsp-ring.c                     |  11 +-
 drivers/usb/cdns3/cdnsp-trace.h                    |   4 +-
 drivers/usb/cdns3/host.c                           |   1 +
 drivers/usb/core/config.c                          |   6 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc2/platform.c                        |   3 +
 drivers/usb/dwc3/dwc3-qcom.c                       |  15 -
 drivers/usb/early/xhci-dbc.c                       |  15 +-
 drivers/usb/gadget/composite.c                     |  14 +-
 drivers/usb/gadget/function/f_fs.c                 |   9 +-
 drivers/usb/gadget/function/u_ether.c              |  16 +-
 drivers/usb/gadget/legacy/dbgp.c                   |  15 +-
 drivers/usb/gadget/legacy/inode.c                  |  16 +-
 drivers/usb/host/xhci-hub.c                        |   1 +
 drivers/usb/host/xhci-mtk-sch.c                    |   2 +-
 drivers/usb/host/xhci-pci.c                        |  11 +-
 drivers/usb/host/xhci-ring.c                       |   1 -
 drivers/usb/host/xhci.c                            |  26 +-
 drivers/usb/mtu3/mtu3_gadget.c                     |  12 +-
 drivers/usb/mtu3/mtu3_qmu.c                        |   7 +-
 drivers/usb/serial/cp210x.c                        |   6 +-
 drivers/usb/serial/option.c                        |   8 +
 drivers/usb/typec/tcpm/tcpm.c                      |  18 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   4 +-
 drivers/vdpa/vdpa.c                                |   3 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   6 +-
 drivers/vhost/vdpa.c                               |   2 +-
 drivers/video/fbdev/core/fbmem.c                   |  47 ++
 drivers/virt/nitro_enclaves/ne_misc_dev.c          |   5 +-
 drivers/virtio/virtio_ring.c                       |   2 +-
 drivers/xen/events/events_base.c                   |   6 +
 fs/afs/file.c                                      |   5 +-
 fs/afs/super.c                                     |   1 +
 fs/aio.c                                           | 186 ++++--
 fs/btrfs/ctree.c                                   |  17 +-
 fs/btrfs/ctree.h                                   |   7 +-
 fs/btrfs/delalloc-space.c                          |  12 +-
 fs/btrfs/disk-io.c                                 |   8 +
 fs/btrfs/extent-tree.c                             |  16 +-
 fs/btrfs/extent_io.c                               |  22 +
 fs/btrfs/free-space-tree.c                         |   4 +-
 fs/btrfs/ioctl.c                                   |  16 +-
 fs/btrfs/qgroup.c                                  |   3 +-
 fs/btrfs/root-tree.c                               |   3 +-
 fs/btrfs/tree-log.c                                |   7 +-
 fs/btrfs/volumes.c                                 |   6 +-
 fs/btrfs/zoned.c                                   |   2 +
 fs/ceph/caps.c                                     |  16 +-
 fs/ceph/file.c                                     |  20 +-
 fs/ceph/mds_client.c                               |   3 +-
 fs/cifs/connect.c                                  |   7 +
 fs/cifs/fs_context.c                               |  38 +-
 fs/cifs/inode.c                                    |  13 -
 fs/cifs/sess.c                                     |  54 +-
 fs/file.c                                          |  72 ++-
 fs/io-wq.c                                         |  31 +-
 fs/io_uring.c                                      |  16 +-
 fs/ksmbd/ndr.c                                     |   2 +-
 fs/ksmbd/smb2ops.c                                 |   3 -
 fs/ksmbd/smb2pdu.c                                 |  29 +-
 fs/namespace.c                                     |   9 +-
 fs/netfs/read_helper.c                             |  21 +-
 fs/nfsd/nfs3proc.c                                 |  11 +-
 fs/nfsd/nfs4recover.c                              |   1 +
 fs/nfsd/nfs4state.c                                |   9 +-
 fs/nfsd/nfsctl.c                                   |  14 +-
 fs/nfsd/nfsproc.c                                  |   8 +-
 fs/signalfd.c                                      |  12 +-
 fs/smbfs_common/cifs_arc4.c                        |  13 -
 fs/tracefs/inode.c                                 |  76 +++
 fs/xfs/xfs_ioctl.c                                 |   3 +-
 fs/xfs/xfs_super.c                                 |  14 +-
 fs/zonefs/super.c                                  |   1 +
 include/linux/bpf.h                                |  17 +-
 include/linux/btf.h                                |  14 +-
 include/linux/cacheinfo.h                          |   1 -
 include/linux/compiler.h                           |   4 +-
 include/linux/delay.h                              |  14 +-
 include/linux/device/driver.h                      |   1 +
 include/linux/efi.h                                |   6 +
 include/linux/fb.h                                 |   1 +
 include/linux/filter.h                             |   5 +-
 include/linux/gfp.h                                |   2 +-
 include/linux/hid.h                                |   5 +
 include/linux/instrumentation.h                    |   4 +-
 include/linux/ipv6.h                               |   2 +
 include/linux/kvm_host.h                           |   3 -
 include/linux/memblock.h                           |   4 +-
 include/linux/mhi.h                                |  13 +
 include/linux/mmzone.h                             |   1 +
 include/linux/netdevice.h                          |   2 +-
 include/linux/pagemap.h                            |   1 -
 include/linux/percpu-refcount.h                    |   2 +-
 include/linux/phy.h                                |  11 +-
 include/linux/pm_runtime.h                         |   2 +-
 include/linux/regulator/driver.h                   |  14 +-
 include/linux/skbuff.h                             |   3 +-
 include/linux/tee_drv.h                            |   4 +-
 include/linux/virtio_net.h                         |  25 +-
 include/linux/wait.h                               |  26 +
 include/net/bond_alb.h                             |   2 +-
 include/net/busy_poll.h                            |  13 +
 include/net/netfilter/nf_conntrack.h               |   6 +-
 include/net/pkt_sched.h                            |  16 +
 include/net/sch_generic.h                          |   2 -
 include/net/sctp/sctp.h                            |   9 +-
 include/net/sctp/structs.h                         |   3 +-
 include/net/seg6.h                                 |  21 +
 include/net/sock.h                                 |   2 +-
 include/trace/events/vmscan.h                      |   4 +-
 include/uapi/asm-generic/poll.h                    |   2 +-
 include/uapi/linux/byteorder/big_endian.h          |   1 +
 include/uapi/linux/byteorder/little_endian.h       |   1 +
 include/uapi/linux/mptcp.h                         |  18 +-
 include/uapi/linux/nfc.h                           |   6 +-
 include/uapi/linux/resource.h                      |  13 +-
 include/xen/events.h                               |   1 +
 kernel/audit.c                                     |  21 +-
 kernel/bpf/btf.c                                   |  11 +-
 kernel/bpf/verifier.c                              |  55 +-
 kernel/cgroup/cgroup-internal.h                    |  19 +
 kernel/cgroup/cgroup-v1.c                          |  33 +-
 kernel/cgroup/cgroup.c                             |  88 ++-
 kernel/crash_core.c                                |  11 +
 kernel/locking/rtmutex.c                           |   2 +-
 kernel/sched/wait.c                                |   7 +
 kernel/signal.c                                    |   9 +
 kernel/time/timekeeping.c                          |   3 +-
 kernel/time/timer.c                                |  16 +-
 kernel/trace/ftrace.c                              |   8 +-
 kernel/trace/trace.c                               |   6 +-
 kernel/trace/trace_events_synth.c                  |  11 +-
 kernel/ucount.c                                    |  15 +-
 lib/Kconfig.debug                                  |   1 +
 mm/Kconfig                                         |   2 +-
 mm/backing-dev.c                                   |   7 +
 mm/damon/core.c                                    |  20 +-
 mm/damon/dbgfs.c                                   |  15 +-
 mm/damon/vaddr-test.h                              |  79 ++-
 mm/damon/vaddr.c                                   |   2 +-
 mm/filemap.c                                       |   2 -
 mm/hugetlb.c                                       |   2 +-
 mm/kfence/core.c                                   |   1 +
 mm/memcontrol.c                                    | 106 ++--
 mm/memory-failure.c                                |  14 +-
 mm/memory_hotplug.c                                |   1 +
 mm/mempolicy.c                                     |   3 +-
 mm/slub.c                                          |  15 +-
 mm/swap_slots.c                                    |   1 +
 mm/vmscan.c                                        |  65 ++-
 net/ax25/af_ax25.c                                 |   4 +-
 net/batman-adv/multicast.c                         |  15 +-
 net/batman-adv/multicast.h                         |  10 +-
 net/batman-adv/soft-interface.c                    |   7 +-
 net/bridge/br_ioctl.c                              |   2 +-
 net/bridge/br_multicast.c                          |  32 ++
 net/bridge/br_netlink.c                            |   4 +-
 net/bridge/br_private.h                            |  12 +-
 net/bridge/br_sysfs_br.c                           |   4 +-
 net/bridge/br_vlan_options.c                       |   4 +-
 net/core/dev.c                                     |   8 +-
 net/core/devlink.c                                 |  16 +-
 net/core/flow_dissector.c                          |   3 +-
 net/core/lwtunnel.c                                |   4 +
 net/core/neighbour.c                               |   3 +-
 net/core/skbuff.c                                  |   2 +-
 net/core/skmsg.c                                   |   5 +
 net/core/sock_map.c                                |  15 +-
 net/dsa/tag_ocelot.c                               |   6 +-
 net/ethtool/netlink.c                              |   3 +-
 net/ipv4/af_inet.c                                 |  12 +-
 net/ipv4/fib_semantics.c                           |  49 +-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/inet_diag.c                               |   4 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                |  11 +-
 net/ipv4/tcp_minisocks.c                           |   4 +-
 net/ipv4/udp.c                                     |  10 +-
 net/ipv6/icmp.c                                    |   6 +-
 net/ipv6/ip6_vti.c                                 |   2 +
 net/ipv6/raw.c                                     |   3 +
 net/ipv6/route.c                                   |  32 +-
 net/ipv6/seg6.c                                    |  59 ++
 net/ipv6/seg6_iptunnel.c                           |   8 +
 net/ipv6/seg6_local.c                              |  33 +-
 net/ipv6/sit.c                                     |   1 -
 net/ipv6/tcp_ipv6.c                                |  11 +-
 net/ipv6/udp.c                                     |   9 +-
 net/mac80211/agg-rx.c                              |   5 +-
 net/mac80211/agg-tx.c                              |  16 +-
 net/mac80211/cfg.c                                 |   3 +
 net/mac80211/driver-ops.h                          |   5 +-
 net/mac80211/ieee80211_i.h                         |  24 +-
 net/mac80211/mesh.h                                |  22 +-
 net/mac80211/mesh_pathtbl.c                        |  89 +--
 net/mac80211/mlme.c                                |  15 +-
 net/mac80211/rx.c                                  |   1 +
 net/mac80211/sta_info.c                            |  21 +-
 net/mac80211/sta_info.h                            |   2 +
 net/mac80211/tx.c                                  |  10 +-
 net/mac80211/util.c                                |  23 +-
 net/mctp/neigh.c                                   |   9 +-
 net/mptcp/pm_netlink.c                             |   3 +
 net/mptcp/protocol.c                               |   6 +-
 net/mptcp/sockopt.c                                |   1 -
 net/ncsi/ncsi-netlink.c                            |   6 +-
 net/netfilter/nf_conntrack_core.c                  |   6 +-
 net/netfilter/nf_conntrack_netlink.c               |   7 +-
 net/netfilter/nf_flow_table_core.c                 |   4 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_log.c                      |   3 +-
 net/netfilter/nfnetlink_queue.c                    |   5 +-
 net/netfilter/nft_exthdr.c                         |  11 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   2 +-
 net/netrom/af_netrom.c                             |   2 +-
 net/nfc/netlink.c                                  |  12 +-
 net/openvswitch/flow.c                             |   8 +-
 net/packet/af_packet.c                             |   5 +-
 net/phonet/pep.c                                   |   3 +
 net/rds/connection.c                               |   1 +
 net/sched/act_ct.c                                 |  15 +-
 net/sched/cls_api.c                                |   8 +-
 net/sched/cls_flower.c                             |   6 +-
 net/sched/sch_cake.c                               |   6 +-
 net/sched/sch_ets.c                                |   4 +-
 net/sched/sch_fq_pie.c                             |   1 +
 net/sched/sch_frag.c                               |   3 +-
 net/sched/sch_qfq.c                                |   6 +-
 net/sctp/diag.c                                    |  58 +-
 net/sctp/endpointola.c                             |  23 +-
 net/sctp/socket.c                                  |  45 +-
 net/smc/af_smc.c                                   |   4 +-
 net/smc/smc.h                                      |   5 +
 net/smc/smc_cdc.c                                  |  52 +-
 net/smc/smc_cdc.h                                  |   2 +-
 net/smc/smc_core.c                                 |  27 +-
 net/smc/smc_core.h                                 |   6 +
 net/smc/smc_ib.c                                   |   4 +-
 net/smc/smc_ib.h                                   |   1 +
 net/smc/smc_llc.c                                  |   2 +-
 net/smc/smc_wr.c                                   |  51 +-
 net/smc/smc_wr.h                                   |   5 +-
 net/tipc/crypto.c                                  |   8 +-
 net/tipc/socket.c                                  |   2 +
 net/vmw_vsock/virtio_transport_common.c            |   3 +-
 net/wireless/reg.c                                 |  30 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 samples/ftrace/Makefile                            |   1 +
 samples/ftrace/ftrace-direct-modify.c              |   3 +
 samples/ftrace/ftrace-direct-multi-modify.c        | 155 +++++
 samples/ftrace/ftrace-direct-too.c                 |   3 +
 samples/ftrace/ftrace-direct.c                     |   2 +
 scripts/recordmcount.pl                            |   2 +-
 security/selinux/hooks.c                           |  35 +-
 security/tomoyo/util.c                             |  31 +-
 sound/core/control_compat.c                        |   3 +
 sound/core/jack.c                                  |   4 +
 sound/core/oss/pcm_oss.c                           |  37 +-
 sound/core/rawmidi.c                               |   1 +
 sound/drivers/opl3/opl3_midi.c                     |   2 +-
 sound/hda/intel-sdw-acpi.c                         |  13 +-
 sound/pci/hda/patch_hdmi.c                         |  21 +-
 sound/pci/hda/patch_realtek.c                      | 109 +++-
 sound/soc/amd/yc/pci-acp6x.c                       |   3 +-
 sound/soc/codecs/rt5682.c                          |  14 +-
 sound/soc/codecs/rt5682s.c                         |  10 +-
 sound/soc/codecs/tas2770.c                         |   4 +-
 sound/soc/codecs/wcd934x.c                         | 126 ++--
 sound/soc/codecs/wsa881x.c                         |  16 +-
 sound/soc/meson/aiu-encoder-i2s.c                  |  33 --
 sound/soc/meson/aiu-fifo-i2s.c                     |  19 +
 sound/soc/meson/aiu-fifo.c                         |   6 +
 sound/soc/qcom/qdsp6/q6routing.c                   |   8 +-
 sound/soc/rockchip/rockchip_i2s_tdm.c              |  52 +-
 sound/soc/sof/intel/hda-codec.c                    |  14 +-
 sound/soc/sof/intel/pci-tgl.c                      |   4 +
 sound/soc/tegra/tegra210_adx.c                     |   4 +-
 sound/soc/tegra/tegra210_amx.c                     |   4 +-
 sound/soc/tegra/tegra210_mixer.c                   |   4 +-
 sound/soc/tegra/tegra210_mvc.c                     |   8 +-
 sound/soc/tegra/tegra210_sfc.c                     |   4 +-
 sound/soc/tegra/tegra_asoc_machine.c               |  11 +-
 sound/soc/tegra/tegra_asoc_machine.h               |   1 +
 sound/usb/mixer_quirks.c                           |  10 +-
 tools/bpf/resolve_btfids/main.c                    |   8 +-
 tools/build/Makefile.feature                       |   1 -
 tools/build/feature/Makefile                       |   4 -
 tools/build/feature/test-all.c                     |   5 -
 tools/build/feature/test-libpython-version.c       |  11 -
 tools/include/linux/debug_locks.h                  |  14 -
 tools/include/linux/hardirq.h                      |  12 -
 tools/include/linux/irqflags.h                     |  39 --
 tools/include/linux/lockdep.h                      |  72 ---
 tools/include/linux/proc_fs.h                      |   4 -
 tools/include/linux/spinlock.h                     |   2 -
 tools/include/linux/stacktrace.h                   |  33 --
 tools/include/uapi/linux/kvm.h                     |  19 +-
 tools/perf/Makefile.config                         |   2 -
 tools/perf/arch/powerpc/entry/syscalls/syscall.tbl |   1 +
 tools/perf/arch/s390/entry/syscalls/syscall.tbl    |   1 +
 tools/perf/bench/sched-messaging.c                 |   4 -
 tools/perf/builtin-inject.c                        |  15 +-
 tools/perf/builtin-script.c                        |   2 +-
 tools/perf/builtin-trace.c                         |   2 +-
 tools/perf/scripts/python/intel-pt-events.py       |  23 +-
 tools/perf/tests/expr.c                            |   4 +-
 tools/perf/tests/parse-metric.c                    |   1 +
 tools/perf/ui/tui/setup.c                          |   8 +-
 tools/perf/util/bpf_skel/bperf.h                   |  14 -
 tools/perf/util/bpf_skel/bperf_follower.bpf.c      |  19 +-
 tools/perf/util/bpf_skel/bperf_leader.bpf.c        |  19 +-
 tools/perf/util/bpf_skel/bpf_prog_profiler.bpf.c   |   2 +-
 tools/perf/util/debug.c                            |  19 -
 tools/perf/util/event.h                            |   5 +-
 tools/perf/util/expr.c                             |  12 +-
 tools/perf/util/header.c                           |  15 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  85 ++-
 tools/perf/util/intel-pt.c                         |   2 +
 tools/perf/util/perf_regs.c                        |   3 +
 tools/perf/util/pmu.c                              |  23 +-
 tools/perf/util/python.c                           |   2 +-
 tools/perf/util/smt.c                              |   2 +-
 tools/power/acpi/Makefile.config                   |   1 +
 tools/power/acpi/Makefile.rules                    |   1 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  20 +
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |  16 +-
 .../selftests/bpf/progs/test_module_attach.c       |  12 +
 tools/testing/selftests/bpf/test_verifier.c        |   2 +-
 .../selftests/bpf/verifier/atomic_cmpxchg.c        |  86 +++
 .../testing/selftests/bpf/verifier/atomic_fetch.c  |  94 +++
 .../selftests/bpf/verifier/search_pruning.c        |  71 +++
 tools/testing/selftests/bpf/verifier/spill_fill.c  |  32 ++
 .../selftests/bpf/verifier/value_ptr_arith.c       |  23 +
 .../bpf/verifier/xdp_direct_packet_access.c        | 632 +++++++++++++++++++--
 tools/testing/selftests/cgroup/cgroup_util.c       |   2 +-
 tools/testing/selftests/cgroup/test_core.c         | 165 ++++++
 tools/testing/selftests/damon/.gitignore           |   2 +
 tools/testing/selftests/damon/Makefile             |   7 +-
 tools/testing/selftests/damon/_debugfs_common.sh   |  52 ++
 tools/testing/selftests/damon/debugfs_attrs.sh     |  73 +--
 .../selftests/damon/debugfs_empty_targets.sh       |  13 +
 .../damon/debugfs_huge_count_read_write.sh         |  22 +
 tools/testing/selftests/damon/debugfs_schemes.sh   |  19 +
 .../testing/selftests/damon/debugfs_target_ids.sh  |  19 +
 .../selftests/damon/huge_count_read_write.c        |  39 ++
 .../drivers/net/mlxsw/rif_mac_profiles_occ.sh      |  30 +
 tools/testing/selftests/kvm/.gitignore             |   5 +-
 tools/testing/selftests/kvm/Makefile               |   6 +-
 .../selftests/kvm/include/x86_64/processor.h       |  25 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  10 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 134 +++--
 .../kvm/x86_64/{get_cpuid_test.c => cpuid_test.c}  |  30 +
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 434 ++++++++++++++
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c |   4 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c       |   4 +-
 .../vmx_exception_with_invalid_guest_state.c       | 139 +++++
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  34 +-
 tools/testing/selftests/net/amt.sh                 |   0
 tools/testing/selftests/net/fcnal-test.sh          |  53 +-
 tools/testing/selftests/net/fib_tests.sh           |  59 +-
 .../net/forwarding/forwarding.config.sample        |   2 +
 tools/testing/selftests/net/icmp_redirect.sh       |   2 +-
 tools/testing/selftests/net/mptcp/config           |   1 -
 tools/testing/selftests/net/tls.c                  |  36 ++
 tools/testing/selftests/net/toeplitz.c             |   2 +-
 tools/testing/selftests/net/udpgro_fwd.sh          |   7 +-
 tools/testing/selftests/net/udpgso.c               |  12 +-
 tools/testing/selftests/net/udpgso_bench_tx.c      |   8 +-
 tools/testing/selftests/netfilter/conntrack_vrf.sh |  30 +-
 .../selftests/netfilter/nft_concat_range.sh        |  24 +-
 .../testing/selftests/netfilter/nft_zones_many.sh  |  19 +-
 tools/testing/selftests/tc-testing/config          |   2 +
 tools/testing/selftests/tc-testing/tdc.py          |   8 +-
 tools/testing/selftests/tc-testing/tdc.sh          |   1 +
 tools/testing/selftests/vm/userfaultfd.c           |  16 +-
 virt/kvm/kvm_main.c                                |   5 +-
 914 files changed, 9782 insertions(+), 4415 deletions(-)
 rename Documentation/admin-guide/blockdev/drbd/{node-states-8.dot => peer-states-8.dot} (71%)
 create mode 100644 samples/ftrace/ftrace-direct-multi-modify.c
 delete mode 100644 tools/build/feature/test-libpython-version.c
 delete mode 100644 tools/include/linux/debug_locks.h
 delete mode 100644 tools/include/linux/hardirq.h
 delete mode 100644 tools/include/linux/irqflags.h
 delete mode 100644 tools/include/linux/lockdep.h
 delete mode 100644 tools/include/linux/proc_fs.h
 delete mode 100644 tools/include/linux/stacktrace.h
 delete mode 100644 tools/perf/util/bpf_skel/bperf.h
 create mode 100644 tools/testing/selftests/damon/.gitignore
 create mode 100644 tools/testing/selftests/damon/_debugfs_common.sh
 create mode 100644 tools/testing/selftests/damon/debugfs_empty_targets.sh
 create mode 100644 tools/testing/selftests/damon/debugfs_huge_count_read_write.sh
 create mode 100644 tools/testing/selftests/damon/debugfs_schemes.sh
 create mode 100644 tools/testing/selftests/damon/debugfs_target_ids.sh
 create mode 100644 tools/testing/selftests/damon/huge_count_read_write.c
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (83%)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
 mode change 100644 => 100755 tools/testing/selftests/net/amt.sh

