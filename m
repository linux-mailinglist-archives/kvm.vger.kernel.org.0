Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D1F44F087
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhKMBZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbhKMBZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:25:53 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF054C0613F5
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:23:01 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j18-20020a63fc12000000b002dd2237eb1cso5672472pgi.5
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=g3+aox7fzytzBAtVqJz8rKFvz5lbt92AaNYPgpLVkEY=;
        b=NiFli5Y+14kem70XbljlK2MHcjurgn6MPuwKPmXSd7rGWvYOQRIvwfcEd+tRcZvodI
         WZoTfZ6Hr6DXe8PBAGKo9bD6SDnf/NSBbbgnM63/yllW2rduAKr2314Pb1Q7Z5PnknJ/
         Qx1O+HpfnX2lRKhqPnMWf6RLvEA/HpSqE2lmaXhKUEuX5qErIKC55+VxNLIbnmHl7QZA
         TvVZv/V1hhdxdQ20nNW12eEPgRMmAOago5mzHjDem5lVhK7DHRB34qnbSZNghdjojCB4
         rpTs330JDOwgMyQYEbVXeTjodxncPNmB/SYMPPLrBurYsuHWjTUdrFCUQHyluAgiBfvF
         g0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g3+aox7fzytzBAtVqJz8rKFvz5lbt92AaNYPgpLVkEY=;
        b=UkTh6CvXdyi8IbcWvcgpTl2YsnN7XrMmYliO04ACFxh97eSYb1f9+bNkn047FFpMbU
         oYLggkgfV8RU9gjLvMw+3E6+uJ4eEYEG6n7urY2nx4Rk5IhfWkDshJG0I5Ry2MBxSAF/
         zYcnJgPplJRdhVeAf0WQ+pd8cXkEuoFixEaQ7mXcHHh5Smx1/4aLKacEUqdPqRt+Rcnj
         Lyn8kzCVBxriFJo+emt1hZTAPf5u7j9S4wNp5wynue8gK2HzYwLZJVoZjyvnAtCYQRTq
         7Y20Ej6qR2gwvZg1JWWJUxnqDwZGBB8f823olXoVKu1EUO2RE0HHX+7ROMmGR8B56/bL
         wACQ==
X-Gm-Message-State: AOAM5312OHG/0EVTPZ69DC9UsquTbqpplOUx69jeMoDUmrRhSf4G9KNj
        7F2gRjOoUqxQ97A9fp+nTjB9DwrPoTIA
X-Google-Smtp-Source: ABdhPJw6EZS2Qj/BRyr/pJRFu4I87U2GEaFJToIWpSRiGeVJhc0MJgA1bcNg7gzyDPzhMD5DBksKCxhbzwlF
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:3905:: with SMTP id
 y5mr141745pjb.0.1636766580759; Fri, 12 Nov 2021 17:23:00 -0800 (PST)
Date:   Sat, 13 Nov 2021 01:22:30 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-8-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 07/11] Docs: KVM: Add doc for the bitmap firmware registers
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Add documentation for the capability, KVM_CAP_ARM_HVC_FW_REG_BMAP,
  in KVM's api.rst.

- Add the documentation for the bitmap firmware registers in
  psci.rst. This includes the details for KVM_REG_ARM_STD_BMAP,
  KVM_REG_ARM_STD_HYP_BMAP, and KVM_REG_ARM_VENDOR_HYP_BMAP
  registers.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/api.rst      | 23 ++++++++
 Documentation/virt/kvm/arm/psci.rst | 89 +++++++++++++++++++++++------
 2 files changed, 95 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3b093d6dbe22..7d88567feaa7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6911,6 +6911,29 @@ MAP_SHARED mmap will result in an -EINVAL return.
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
 
+7.29 KVM_CAP_ARM_HVC_FW_REG_BMAP
+--------------------------------
+
+:Architecture: arm64
+:Parameters: none
+
+This capability indicates that KVM for arm64 supports the psuedo-firmware
+register bitmap extension. It must be explicitly enabled. Once enabled,
+KVM allows access to the firmware registers that hold the bitmap of the
+hypercall services that should be exposed to the guest.
+
+By default, the registers are set with the upper-limit of the features
+exposed to the guest. User-space can discover them via the GET_ONE_REG
+interface. If unsatisfied with the configuration, it can write-back the
+bitmap that it sees fit for the guest via SET_ONE_REG interface. The
+registers that are never accessed by the user-space (read/write) are
+by default cleared just before the vCPU runs. This is to make sure that
+the features are not accidentally exposed to the guest without the
+consent of user-space.
+
+Note that the capability has to be enabled before running any vCPU. Also,
+the capability cannot be disabled. The VM has to be restarted for that.
+
 8. Other capabilities.
 ======================
 
diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/psci.rst
index d52c2e83b5b8..f6306b91168d 100644
--- a/Documentation/virt/kvm/arm/psci.rst
+++ b/Documentation/virt/kvm/arm/psci.rst
@@ -1,32 +1,32 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=========================================
-Power State Coordination Interface (PSCI)
-=========================================
+=======================
+ARM Hypercall Interface
+=======================
 
-KVM implements the PSCI (Power State Coordination Interface)
-specification in order to provide services such as CPU on/off, reset
-and power-off to the guest.
+KVM handles the hypercall services as requested by the guests. New hypercall
+services are regularly made available by the ARM specification or by KVM (as
+vendor services) if they make sense from a virtualization point of view.
 
-The PSCI specification is regularly updated to provide new features,
-and KVM implements these updates if they make sense from a virtualization
-point of view.
-
-This means that a guest booted on two different versions of KVM can
-observe two different "firmware" revisions. This could cause issues if
-a given guest is tied to a particular PSCI revision (unlikely), or if
-a migration causes a different PSCI version to be exposed out of the
-blue to an unsuspecting guest.
+This means that a guest booted on two different versions of KVM can observe
+two different "firmware" revisions. This could cause issues if a given guest
+is tied to a particular version of a hypercall service, or if a migration
+causes a different version to be exposed out of the blue to an unsuspecting
+guest.
 
 In order to remedy this situation, KVM exposes a set of "firmware
 pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
-interface. These registers can be saved/restored by userspace, and set
+interface. These registers can be saved/restored by user-space, and set
 to a convenient value if required.
 
-The following register is defined:
+The following registers are defined:
 
 * KVM_REG_ARM_PSCI_VERSION:
 
+  KVM implements the PSCI (Power State Coordination Interface)
+  specification in order to provide services such as CPU on/off, reset
+  and power-off to the guest.
+
   - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
     (and thus has already been initialized)
   - Returns the current PSCI version on GET_ONE_REG (defaulting to the
@@ -74,4 +74,59 @@ The following register is defined:
     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
       The workaround is always active on this vCPU or it is not needed.
 
+Contrary to the above registers, the following registers exposes the hypercall
+services in the form of a feature-bitmap. This bitmap is translated to the
+services that are exposed to the guest. There is a register defined per service
+call owner and can be accessed via GET/SET_ONE_REG interface.
+
+A new KVM capability, KVM_CAP_ARM_HVC_FW_REG_BMAP, is introduced to let
+user-space know of this extension. It has to explicitly enable the capability
+to get access to these registers. If the capability is enabled, a 'read' of
+these registers will simply expose the upper-limit of all features supported
+by the corresponding service call owner in the form of a bitmap. If the
+user-space is unhappy with the arrangement, it can 'write-back' the bitmap
+that it wishes to expose.
+
+If a register is not accessed (either read/write), KVM will assume that the
+user-space is unaware of its existence. In such a case, KVM would simply
+clear all the bits of that register just before starting the VM. This way
+no new features are accidentally exposed to the guest.
+
+The psuedo-firmware bitmap register are as follows:
+
+* KVM_REG_ARM_STD_BMAP:
+    Controls the bitmap of the ARM Standard Secure Service Calls.
+
+  The following bits are accepted:
+
+  KVM_REG_ARM_STD_BIT_TRNG_V1_0:
+    The bit represents the services offered under v1.0 of ARM True Random
+    Number Generator (TRNG) specification, ARM DEN0098.
+
+* KVM_REG_ARM_STD_HYP_BMAP:
+    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
+
+  The following bits are accepted:
+
+  KVM_REG_ARM_STD_HYP_BIT_PV_TIME:
+    The bit represents the Paravirtualized Time service as represented by
+    ARM DEN0057A.
+
+* KVM_REG_ARM_VENDOR_HYP_BMAP:
+    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
+
+  The following bits are accepted:
+
+  KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
+    The bit represents the Precision Time Protocol KVM service.
+
+Errors:
+
+    =======  =============================================================
+    -ENOENT   Register accessed (read/write) without enabling
+              KVM_CAP_ARM_HVC_FW_REG_BMAP.
+    -EBUSY    Attempt a 'write' to the register after the VM has started.
+    -EINVAL   Invalid bitmap written to the register.
+    =======  =============================================================
+
 .. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
-- 
2.34.0.rc1.387.gb447b232ab-goog

