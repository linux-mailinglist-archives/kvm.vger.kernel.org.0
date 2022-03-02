Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECED54CAEEB
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242009AbiCBTnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbiCBTnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:43:12 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10C064E7
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:42:26 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id a5-20020a92c545000000b002c2875a2a57so2063591ilj.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nuZe9ZhOuay90wUI9CO/j9ARq8u5vmZVCVvA+iWxxmE=;
        b=WhOfmlhODiH8EfJkCYzZDvh9S8MEzq3NEt5PIdnwe58jLGyDMLHtOkts1KC8XJ038o
         j/4t+g46z/BLc53Na19dx4lP27UIBdz5Heo3P32MaMQSCouLqYQfoqvXmoWdij7K9e2V
         bVA5mIAope1CdFCU74zsogpQvnu1nDAD+jhsGevtsQMG1/i7xGOcJV3d6SOpOJH2l8sT
         o72QODfkdzmX+EQ/iCxRrEonxc0bUAPfWVY55V6TkIVC9obMPa9BEqNB3PfM/7+MgVoD
         /ZOdp8I+q+7NEpGG5srirZMRiZGcgX+P6j+1Nu+hv1jOA8gioOML6979XqQktx9v1pXY
         HiWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nuZe9ZhOuay90wUI9CO/j9ARq8u5vmZVCVvA+iWxxmE=;
        b=Mh4ar5JEtTqp3P70q9zqeGRKM+TVWclaFICFHI/Y2LcMzfBxjG96KuAtNVinXZ3vyc
         s9HXTP7O7oeVn6QqaLeIDNQRcI393yIEiUx/QbvSxqdz48YSM2nLwrEMYJ/0Oc62g3UY
         3C3AQjcF9bBG2lAfvaPa+PiM3GCrvju0MAQi2MxcAsiM6+IZ8jF2+nHIwFRjgOdorkjT
         XlkwWEwdG4usq42qiMTK61O6JuYFGBNHfTwCDpik3SYccCmBk9f1BLxfmx/lBJxJDhNJ
         JsZPhjQF42vEaY+XYydSGUmrPe3S7jYZ6PmeAgN7TLZMip6gar16+iVkG4BTVMeRlQzU
         A8YQ==
X-Gm-Message-State: AOAM531WnJwJdWKwSIuFs9iJWbFSVWAsHomx2KnlnQpMXQQjMjUrFkbF
        PS/433Eo3QVXyZuOqkaWbaMQfiutPZE=
X-Google-Smtp-Source: ABdhPJyk1rwN1bkv1E5VJ6CQ34W9eUiJzPPN/6foQ8rJCLe/p51ymVvi545lXjtIZn4D0kgCWY1tf6aFd6Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:ce10:0:b0:2c2:8829:bd1f with SMTP id
 b16-20020a92ce10000000b002c28829bd1fmr27685914ilo.37.1646250146231; Wed, 02
 Mar 2022 11:42:26 -0800 (PST)
Date:   Wed,  2 Mar 2022 19:42:20 +0000
In-Reply-To: <20220302194221.1774513-1-oupton@google.com>
Message-Id: <20220302194221.1774513-2-oupton@google.com>
Mime-Version: 1.0
References: <20220302194221.1774513-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 1/2] Documentation: KVM: Update documentation to indicate KVM
 is arm64-only
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM support for 32-bit ARM hosts (KVM/arm) has been removed from the
kernel since commit 541ad0150ca4 ("arm: Remove 32bit KVM host
support"). There still exists some remnants of the old architecture in
the KVM documentation.

Remove all traces of 32-bit host support from the documentation. Note
that AArch32 guests are still supported.

Fixes: 541ad0150ca4 ("arm: Remove 32bit KVM host support")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst          | 83 ++++++++++++-------------
 Documentation/virt/kvm/arm/hyp-abi.rst  | 54 ++++++++--------
 Documentation/virt/kvm/arm/ptp_kvm.rst  |  4 +-
 Documentation/virt/kvm/devices/vcpu.rst |  2 +-
 4 files changed, 70 insertions(+), 73 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f3172376ec3..25423ee890e2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -417,7 +417,7 @@ kvm_run' (see below).
 -----------------
 
 :Capability: basic
-:Architectures: all except ARM, arm64
+:Architectures: all except arm64
 :Type: vcpu ioctl
 :Parameters: struct kvm_regs (out)
 :Returns: 0 on success, -1 on error
@@ -450,7 +450,7 @@ Reads the general purpose registers from the vcpu.
 -----------------
 
 :Capability: basic
-:Architectures: all except ARM, arm64
+:Architectures: all except arm64
 :Type: vcpu ioctl
 :Parameters: struct kvm_regs (in)
 :Returns: 0 on success, -1 on error
@@ -824,7 +824,7 @@ Writes the floating point state to the vcpu.
 -----------------------
 
 :Capability: KVM_CAP_IRQCHIP, KVM_CAP_S390_IRQCHIP (s390)
-:Architectures: x86, ARM, arm64, s390
+:Architectures: x86, arm64, s390
 :Type: vm ioctl
 :Parameters: none
 :Returns: 0 on success, -1 on error
@@ -833,7 +833,7 @@ Creates an interrupt controller model in the kernel.
 On x86, creates a virtual ioapic, a virtual PIC (two PICs, nested), and sets up
 future vcpus to have a local APIC.  IRQ routing for GSIs 0-15 is set to both
 PIC and IOAPIC; GSI 16-23 only go to the IOAPIC.
-On ARM/arm64, a GICv2 is created. Any other GIC versions require the usage of
+On arm64, a GICv2 is created. Any other GIC versions require the usage of
 KVM_CREATE_DEVICE, which also supports creating a GICv2.  Using
 KVM_CREATE_DEVICE is preferred over KVM_CREATE_IRQCHIP for GICv2.
 On s390, a dummy irq routing table is created.
@@ -846,7 +846,7 @@ before KVM_CREATE_IRQCHIP can be used.
 -----------------
 
 :Capability: KVM_CAP_IRQCHIP
-:Architectures: x86, arm, arm64
+:Architectures: x86, arm64
 :Type: vm ioctl
 :Parameters: struct kvm_irq_level
 :Returns: 0 on success, -1 on error
@@ -870,7 +870,7 @@ capability is present (or unless it is not using the in-kernel irqchip,
 of course).
 
 
-ARM/arm64 can signal an interrupt either at the CPU level, or at the
+arm64 can signal an interrupt either at the CPU level, or at the
 in-kernel irqchip (GIC), and for in-kernel irqchip can tell the GIC to
 use PPIs designated for specific cpus.  The irq field is interpreted
 like this::
@@ -896,7 +896,7 @@ When KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 is supported, the target vcpu is
 identified as (256 * vcpu2_index + vcpu_index). Otherwise, vcpu2_index
 must be zero.
 
-Note that on arm/arm64, the KVM_CAP_IRQCHIP capability only conditions
+Note that on arm64, the KVM_CAP_IRQCHIP capability only conditions
 injection of interrupts for the in-kernel irqchip. KVM_IRQ_LINE can always
 be used for a userspace interrupt controller.
 
@@ -1087,7 +1087,7 @@ Other flags returned by ``KVM_GET_CLOCK`` are accepted but ignored.
 
 :Capability: KVM_CAP_VCPU_EVENTS
 :Extended by: KVM_CAP_INTR_SHADOW
-:Architectures: x86, arm, arm64
+:Architectures: x86, arm64
 :Type: vcpu ioctl
 :Parameters: struct kvm_vcpu_event (out)
 :Returns: 0 on success, -1 on error
@@ -1146,8 +1146,8 @@ The following bits are defined in the flags field:
   fields contain a valid state. This bit will be set whenever
   KVM_CAP_EXCEPTION_PAYLOAD is enabled.
 
-ARM/ARM64:
-^^^^^^^^^^
+ARM64:
+^^^^^^
 
 If the guest accesses a device that is being emulated by the host kernel in
 such a way that a real device would generate a physical SError, KVM may make
@@ -1206,7 +1206,7 @@ directly to the virtual CPU).
 
 :Capability: KVM_CAP_VCPU_EVENTS
 :Extended by: KVM_CAP_INTR_SHADOW
-:Architectures: x86, arm, arm64
+:Architectures: x86, arm64
 :Type: vcpu ioctl
 :Parameters: struct kvm_vcpu_event (in)
 :Returns: 0 on success, -1 on error
@@ -1241,8 +1241,8 @@ can be set in the flags field to signal that the
 exception_has_payload, exception_payload, and exception.pending fields
 contain a valid state and shall be written into the VCPU.
 
-ARM/ARM64:
-^^^^^^^^^^
+ARM64:
+^^^^^^
 
 User space may need to inject several types of events to the guest.
 
@@ -1449,7 +1449,7 @@ for vm-wide capabilities.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64, riscv
+:Architectures: x86, s390, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (out)
 :Returns: 0 on success; -1 on error
@@ -1467,7 +1467,7 @@ Possible values are:
 
    ==========================    ===============================================
    KVM_MP_STATE_RUNNABLE         the vcpu is currently running
-                                 [x86,arm/arm64,riscv]
+                                 [x86,arm64,riscv]
    KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
@@ -1476,7 +1476,7 @@ Possible values are:
                                  is waiting for an interrupt [x86]
    KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
-   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64,riscv]
+   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm64,riscv]
    KVM_MP_STATE_CHECK_STOP       the vcpu is in a special error state [s390]
    KVM_MP_STATE_OPERATING        the vcpu is operating (running or halted)
                                  [s390]
@@ -1488,7 +1488,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64/riscv:
+For arm64/riscv:
 ^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
@@ -1498,7 +1498,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64, riscv
+:Architectures: x86, s390, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (in)
 :Returns: 0 on success; -1 on error
@@ -1510,7 +1510,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64/riscv:
+For arm64/riscv:
 ^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
@@ -1780,14 +1780,14 @@ The flags bitmap is defined as::
 ------------------------
 
 :Capability: KVM_CAP_IRQ_ROUTING
-:Architectures: x86 s390 arm arm64
+:Architectures: x86 s390 arm64
 :Type: vm ioctl
 :Parameters: struct kvm_irq_routing (in)
 :Returns: 0 on success, -1 on error
 
 Sets the GSI routing table entries, overwriting any previously set entries.
 
-On arm/arm64, GSI routing has the following limitation:
+On arm64, GSI routing has the following limitation:
 
 - GSI routing does not apply to KVM_IRQ_LINE but only to KVM_IRQFD.
 
@@ -2855,7 +2855,7 @@ after pausing the vcpu, but before it is resumed.
 -------------------
 
 :Capability: KVM_CAP_SIGNAL_MSI
-:Architectures: x86 arm arm64
+:Architectures: x86 arm64
 :Type: vm ioctl
 :Parameters: struct kvm_msi (in)
 :Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
@@ -3043,7 +3043,7 @@ into the hash PTE second double word).
 --------------
 
 :Capability: KVM_CAP_IRQFD
-:Architectures: x86 s390 arm arm64
+:Architectures: x86 s390 arm64
 :Type: vm ioctl
 :Parameters: struct kvm_irqfd (in)
 :Returns: 0 on success, -1 on error
@@ -3069,7 +3069,7 @@ Note that closing the resamplefd is not sufficient to disable the
 irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
 and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
 
-On arm/arm64, gsi routing being supported, the following can happen:
+On arm64, gsi routing being supported, the following can happen:
 
 - in case no routing entry is associated to this gsi, injection fails
 - in case the gsi is associated to an irqchip routing entry,
@@ -3325,7 +3325,7 @@ current state.  "addr" is ignored.
 ----------------------
 
 :Capability: basic
-:Architectures: arm, arm64
+:Architectures: arm64
 :Type: vcpu ioctl
 :Parameters: struct kvm_vcpu_init (in)
 :Returns: 0 on success; -1 on error
@@ -3423,7 +3423,7 @@ Possible features:
 -----------------------------
 
 :Capability: basic
-:Architectures: arm, arm64
+:Architectures: arm64
 :Type: vm ioctl
 :Parameters: struct kvm_vcpu_init (out)
 :Returns: 0 on success; -1 on error
@@ -3452,7 +3452,7 @@ VCPU matching underlying host.
 ---------------------
 
 :Capability: basic
-:Architectures: arm, arm64, mips
+:Architectures: arm64, mips
 :Type: vcpu ioctl
 :Parameters: struct kvm_reg_list (in/out)
 :Returns: 0 on success; -1 on error
@@ -3479,7 +3479,7 @@ KVM_GET_ONE_REG/KVM_SET_ONE_REG calls.
 -----------------------------------------
 
 :Capability: KVM_CAP_ARM_SET_DEVICE_ADDR
-:Architectures: arm, arm64
+:Architectures: arm64
 :Type: vm ioctl
 :Parameters: struct kvm_arm_device_address (in)
 :Returns: 0 on success, -1 on error
@@ -3506,13 +3506,13 @@ can access emulated or directly exposed devices, which the host kernel needs
 to know about. The id field is an architecture specific identifier for a
 specific device.
 
-ARM/arm64 divides the id field into two parts, a device id and an
+arm64 divides the id field into two parts, a device id and an
 address type id specific to the individual device::
 
   bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
   field: |        0x00000000      |     device id   |  addr type id  |
 
-ARM/arm64 currently only require this when using the in-kernel GIC
+arm64 currently only require this when using the in-kernel GIC
 support for the hardware VGIC features, using KVM_ARM_DEVICE_VGIC_V2
 as the device id.  When setting the base address for the guest's
 mapping of the VGIC virtual CPU and distributor interface, the ioctl
@@ -4726,7 +4726,7 @@ to I/O ports.
 ------------------------------------
 
 :Capability: KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
-:Architectures: x86, arm, arm64, mips
+:Architectures: x86, arm64, mips
 :Type: vm ioctl
 :Parameters: struct kvm_clear_dirty_log (in)
 :Returns: 0 on success, -1 on error
@@ -4838,7 +4838,7 @@ version has the following quirks:
 4.119 KVM_ARM_VCPU_FINALIZE
 ---------------------------
 
-:Architectures: arm, arm64
+:Architectures: arm64
 :Type: vcpu ioctl
 :Parameters: int feature (in)
 :Returns: 0 on success, -1 on error
@@ -5920,7 +5920,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
 
 If exit_reason is KVM_EXIT_SYSTEM_EVENT then the vcpu has triggered
 a system-level event using some architecture specific mechanism (hypercall
-or some special instruction). In case of ARM/ARM64, this is triggered using
+or some special instruction). In case of ARM64, this is triggered using
 HVC instruction based PSCI call from the vcpu. The 'type' field describes
 the system-level event type. The 'flags' field describes architecture
 specific flags for the system-level event.
@@ -6013,7 +6013,7 @@ in send_page or recv a buffer to recv_page).
 			__u64 fault_ipa;
 		} arm_nisv;
 
-Used on arm and arm64 systems. If a guest accesses memory not in a memslot,
+Used on arm64 systems. If a guest accesses memory not in a memslot,
 KVM will typically return to userspace and ask it to do MMIO emulation on its
 behalf. However, for certain classes of instructions, no instruction decode
 (direction, length of memory access) is provided, and fetching and decoding
@@ -6030,11 +6030,10 @@ did not fall within an I/O window.
 Userspace implementations can query for KVM_CAP_ARM_NISV_TO_USER, and enable
 this capability at VM creation. Once this is done, these types of errors will
 instead return to userspace with KVM_EXIT_ARM_NISV, with the valid bits from
-the HSR (arm) and ESR_EL2 (arm64) in the esr_iss field, and the faulting IPA
-in the fault_ipa field. Userspace can either fix up the access if it's
-actually an I/O access by decoding the instruction from guest memory (if it's
-very brave) and continue executing the guest, or it can decide to suspend,
-dump, or restart the guest.
+the ESR_EL2 in the esr_iss field, and the faulting IPA in the fault_ipa field.
+Userspace can either fix up the access if it's actually an I/O access by
+decoding the instruction from guest memory (if it's very brave) and continue
+executing the guest, or it can decide to suspend, dump, or restart the guest.
 
 Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
@@ -6741,7 +6740,7 @@ and injected exceptions.
 
 7.18 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
 
-:Architectures: x86, arm, arm64, mips
+:Architectures: x86, arm64, mips
 :Parameters: args[0] whether feature should be enabled or not
 
 Valid flags are::
@@ -7138,7 +7137,7 @@ reserved.
 8.9 KVM_CAP_ARM_USER_IRQ
 ------------------------
 
-:Architectures: arm, arm64
+:Architectures: arm64
 
 This capability, if KVM_CHECK_EXTENSION indicates that it is available, means
 that if userspace creates a VM without an in-kernel interrupt controller, it
@@ -7265,7 +7264,7 @@ HvFlushVirtualAddressList, HvFlushVirtualAddressListEx.
 8.19 KVM_CAP_ARM_INJECT_SERROR_ESR
 ----------------------------------
 
-:Architectures: arm, arm64
+:Architectures: arm64
 
 This capability indicates that userspace can specify (via the
 KVM_SET_VCPU_EVENTS ioctl) the syndrome value reported to the guest when it
diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm/hyp-abi.rst
index 4d43fbc25195..516ea630d160 100644
--- a/Documentation/virt/kvm/arm/hyp-abi.rst
+++ b/Documentation/virt/kvm/arm/hyp-abi.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 =======================================
-Internal ABI between the kernel and HYP
+Internal ABI between the kernel and EL2
 =======================================
 
 This file documents the interaction between the Linux kernel and the
@@ -13,65 +13,63 @@ used as a host.
 
 Note: KVM/arm has been removed from the kernel. The API described
 here is still valid though, as it allows the kernel to kexec when
-booted at HYP. It can also be used by a hypervisor other than KVM
+booted at EL2. It can also be used by a hypervisor other than KVM
 if necessary.
 
-On arm and arm64 (without VHE), the kernel doesn't run in hypervisor
+On arm64 without VHE, the kernel doesn't run in hypervisor
 mode, but still needs to interact with it, allowing a built-in
 hypervisor to be either installed or torn down.
 
-In order to achieve this, the kernel must be booted at HYP (arm) or
-EL2 (arm64), allowing it to install a set of stubs before dropping to
-SVC/EL1. These stubs are accessible by using a 'hvc #0' instruction,
-and only act on individual CPUs.
+In order to achieve this, the kernel must be booted at EL2 (arm64),
+allowing it to install a set of stubs before dropping to EL1.
+These stubs are accessible by using a 'hvc #0' instruction, and only
+act on individual CPUs.
 
 Unless specified otherwise, any built-in hypervisor must implement
-these functions (see arch/arm{,64}/include/asm/virt.h):
+these functions (see arch/arm64/include/asm/virt.h):
 
 * ::
 
-    r0/x0 = HVC_SET_VECTORS
-    r1/x1 = vectors
+    x0 = HVC_SET_VECTORS
+    x1 = vectors
 
-  Set HVBAR/VBAR_EL2 to 'vectors' to enable a hypervisor. 'vectors'
+  Set VBAR_EL2 to 'vectors' to enable a hypervisor. 'vectors'
   must be a physical address, and respect the alignment requirements
   of the architecture. Only implemented by the initial stubs, not by
   Linux hypervisors.
 
 * ::
 
-    r0/x0 = HVC_RESET_VECTORS
+    x0 = HVC_RESET_VECTORS
 
-  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the initials
-  stubs' exception vector value. This effectively disables an existing
-  hypervisor.
+  Turn EL2 MMU off, and reset VBAR_EL2 to the initials stubs' exception
+  vector value. This effectively disables an existing hypervisor.
 
 * ::
 
-    r0/x0 = HVC_SOFT_RESTART
-    r1/x1 = restart address
-    x2 = x0's value when entering the next payload (arm64)
-    x3 = x1's value when entering the next payload (arm64)
-    x4 = x2's value when entering the next payload (arm64)
+    x0 = HVC_SOFT_RESTART
+    x1 = restart address
+    x2 = x0's value when entering the next payload
+    x3 = x1's value when entering the next payload
+    x4 = x2's value when entering the next payload
 
   Mask all exceptions, disable the MMU, clear I+D bits, move the arguments
-  into place (arm64 only), and jump to the restart address while at HYP/EL2.
-  This hypercall is not expected to return to its caller.
+  into place, and jump to the restart address while at EL2. This hypercall
+  is not expected to return to its caller.
 
 * ::
 
-    x0 = HVC_VHE_RESTART (arm64 only)
+    x0 = HVC_VHE_RESTART
 
   Attempt to upgrade the kernel's exception level from EL1 to EL2 by enabling
   the VHE mode. This is conditioned by the CPU supporting VHE, the EL2 MMU
   being off, and VHE not being disabled by any other means (command line
   option, for example).
 
-Any other value of r0/x0 triggers a hypervisor-specific handling,
+Any other value of x0 triggers a hypervisor-specific handling,
 which is not documented here.
 
-The return value of a stub hypercall is held by r0/x0, and is 0 on
+The return value of a stub hypercall is held by x0, and is 0 on
 success, and HVC_STUB_ERR on error. A stub hypercall is allowed to
-clobber any of the caller-saved registers (x0-x18 on arm64, r0-r3 and
-ip on arm). It is thus recommended to use a function call to perform
-the hypercall.
+clobber any of the caller-saved registers (x0-x18 on arm64). It is
+thus recommended to use a function call to perform the hypercall.
diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm/ptp_kvm.rst
index aecdc80ddcd8..5d47f7ecbf5a 100644
--- a/Documentation/virt/kvm/arm/ptp_kvm.rst
+++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-PTP_KVM support for arm/arm64
-=============================
+PTP_KVM support for arm64
+=========================
 
 PTP_KVM is used for high precision time sync between host and guests.
 It relies on transferring the wall clock and counter value from the
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 60a29972d3f1..92942440a9e7 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -108,7 +108,7 @@ using event 0x11 (CPU_CYCLES).
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
 
-:Architectures: ARM, ARM64
+:Architectures: ARM64
 
 2.1. ATTRIBUTES: KVM_ARM_VCPU_TIMER_IRQ_VTIMER, KVM_ARM_VCPU_TIMER_IRQ_PTIMER
 -----------------------------------------------------------------------------
-- 
2.35.1.574.g5d30c73bfb-goog

