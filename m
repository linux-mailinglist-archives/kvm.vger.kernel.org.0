Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F66C4D1F24
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349190AbiCHRbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiCHRbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:31:44 -0500
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED3A55771
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:30:46 -0800 (PST)
Received: by mail-oo1-xc4a.google.com with SMTP id j18-20020a4ae852000000b003181c031d81so14502214ooj.22
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=d1sHtgMJucCQ/uQdDZlgV+Y7M7TAXZ781zq61M6dHnE=;
        b=aVW97vHcQj4iOaAml3pEApqPds8dC0VfUIBLjcooHqZ1RVHqHFLgbtTThuNS1Hr673
         zKUF2nz7mwcKf8scex+xeA52F3exMIIACqV7xha3NHYLiblLy3iTQUaROgHkn1CzxxWh
         U+KwCZH7zmuyQch7lmh/8A6fryWr9uySyEPVmcxDqWi21C+YU6XN9kFG8pUwfneKxQNB
         OFxApsNsF/txr3ozP+HJ7lNPRNXv/QaAWZYoWXYL3SflUKLcfuWG37jYIztyE6WGVsAp
         E+0I/zl+YE4CVa0lrU474RHuqnxJF7/Dbed/f5w3pFXvXiVL1IJyLuy4pnpfBDTJhU5t
         xKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=d1sHtgMJucCQ/uQdDZlgV+Y7M7TAXZ781zq61M6dHnE=;
        b=cdNugzjI3ib3Mke/G2gZu5ZGn/V6ELm/EWQ5mh15eEAsb9dchuJGIQ+vkB9fjl8ACR
         cTYRK29XDCwTooJ/njXpI3yCFy4uDV4yeoXj9uR25wftfTT/Pg/J7GxuRLTYwMwg5Fvd
         RaIRWZY34YPt5mfQYp3cWPov/p7+HkdUTTmM8jZ66qhChXT3OFBgsdkUlZdt9Zb5carF
         9Omql45ICeh4NgimyuYngKWBhHOgtYTuYjKAi3KKeQhRunWRz15Qr4rzjnkLxTJPiZYj
         X8eIWferi9xvZ8ccxh3Vo9w6q9szXZyOv7Qim5GFzwZyECnwxE7M3zws6qW7dIZpkBiB
         kmoQ==
X-Gm-Message-State: AOAM530gqCxqWRfikCvWBnnqui3g3mDL/VOU8zYtFizWtVAz8e3JMahL
        rLkNTXvdzZPwh3U1wXIz3gVXPXzfZzA=
X-Google-Smtp-Source: ABdhPJzUTB3i3WFC5uoCO4KgNNI8fSx+v4wht6spoC8+R5/rgZ6+5+nErHKU5UYUSZ7kB3FKCtkvhUC71lA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:4596:b0:da:b3f:2b1d with SMTP id
 y22-20020a056870459600b000da0b3f2b1dmr3110954oao.188.1646760645912; Tue, 08
 Mar 2022 09:30:45 -0800 (PST)
Date:   Tue,  8 Mar 2022 17:28:57 +0000
Message-Id: <20220308172856.2997250-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v2] Documentation: KVM: Update documentation to indicate KVM
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---

Applies to v5.17-rc6.

v1: http://lore.kernel.org/r/20220302194221.1774513-1-oupton@google.com

v1 -> v2:
 - Realign markup to shortened lines
 - Drop changes to hyp-abi.rst (Marc)
 - Drop changes to ptp_kvm.rst (Marc)
 - Drop 'Fixes: ' tag (Marc)
 - Drop file/directory rename patch (Marc)

 Documentation/virt/kvm/api.rst          | 87 ++++++++++++-------------
 Documentation/virt/kvm/devices/vcpu.rst |  2 +-
 2 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f3172376ec3..c55410dba483 100644
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
@@ -1488,8 +1488,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64/riscv:
-^^^^^^^^^^^^^^^^^^^^
+For arm64/riscv:
+^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -1498,7 +1498,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64, riscv
+:Architectures: x86, s390, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (in)
 :Returns: 0 on success; -1 on error
@@ -1510,8 +1510,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64/riscv:
-^^^^^^^^^^^^^^^^^^^^
+For arm64/riscv:
+^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
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
2.35.1.616.g0bdcbb4464-goog

