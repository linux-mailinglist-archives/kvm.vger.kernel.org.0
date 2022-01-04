Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEE84848E5
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiADTty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiADTtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:49:46 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD9AC061784
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:49:45 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k21-20020a63f015000000b0033db7baf101so20240195pgh.19
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qxftiJcdUZf4HiiTODBdErN1n11tZbdt+QJMuZxMAlI=;
        b=YkMmDRAAFDDPYGNhhIRDFxfkKYpuGqlN9D9sXGCZAE11WaqNM+IHCUuRiJ1hcF0tbu
         kVdUhM5Pu78t+NphyqjAEVKSsUJrryu1NiffqPFbdsvlVlK/ZAsjpM/LPSHlep6jnwNk
         HBrkosSfU8q5DxVJ0BWrjd+CVT57/vrcZwcUawB2hLgRbhpI3khcYZS5a6qrbPqjHCUK
         6zGs/PKX6JAaVyzxfcyCjJq1DE74ndzj4mqyR2IlZKmmZBTUfN56qCGgCrhAqv5ndfRi
         /U17VXZV1C0FXOiLtd8atkyhIQ/b4gG2Iy7z3tsyMeciRdJcKctKOHcBLD/to2jml0B4
         R4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qxftiJcdUZf4HiiTODBdErN1n11tZbdt+QJMuZxMAlI=;
        b=6TQtVJjHqxvy7sQKJCg4d9PRAMYZRyvagAOij18pWiPai2eRoLAyaoCBcHOha2UR4y
         /uiDopNFkrKn1rBMBrtwv3BHlWhcFImzuXUWZ3yhMGH73kh+cEaNt35FrhGfaCmBa0v1
         kdg4IqQuas+O5UMhn3L/+ylSoHWM8AVVMZqfO7W4kIaKHslfZF+EI689glc7RtwCuA6M
         V2dP/jm5py4ETnKhSmuyloPnRRxsR8r869oZC7MNVyNbcnc6dqBYhbqzWA5k1uubVyUZ
         laxZFUzDnSYgBzfd55vKYzYWaCB0st7ztDdLKMA1Z0c3JqfjgsCh7eR+EuCYTK6ihN0w
         wCwA==
X-Gm-Message-State: AOAM532Iv2AMp6XL1EXc95jSrHXBw/4yrIGAClSdJJYvu9Bstgq6XSPN
        Ns2Pxl305MscJ3Ut+/ottrnYM7A9cROG
X-Google-Smtp-Source: ABdhPJwtINulE60i0V/8q8hHi+gLB5QjLyb+pcgORysvbdogsBEYosGxGWehe//E5ULxvhq2CdSQ/dNbyMu6
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1485:b0:4bb:317a:a909 with SMTP
 id v5-20020a056a00148500b004bb317aa909mr52783212pfu.29.1641325785228; Tue, 04
 Jan 2022 11:49:45 -0800 (PST)
Date:   Tue,  4 Jan 2022 19:49:14 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-8-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 07/11] Docs: KVM: Add doc for the bitmap firmware registers
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

Add the documentation for the bitmap firmware registers in
psci.rst. This includes the details for KVM_REG_ARM_STD_BMAP,
KVM_REG_ARM_STD_HYP_BMAP, and KVM_REG_ARM_VENDOR_HYP_BMAP
registers.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/arm/psci.rst | 85 +++++++++++++++++++++++------
 1 file changed, 68 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/psci.rst
index d52c2e83b5b8..edc3caf927ae 100644
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
 interface. These registers can be saved/restored by userspace, and set
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
@@ -74,4 +74,55 @@ The following register is defined:
     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
       The workaround is always active on this vCPU or it is not needed.
 
-.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
+Contrary to the above registers, the following registers exposes the hypercall
+services in the form of a feature-bitmap. This bitmap is translated to the
+services that are exposed to the guest. There is a register defined per service
+call owner and can be accessed via GET/SET_ONE_REG interface.
+
+A new KVM capability, KVM_CAP_ARM_HVC_FW_REG_BMAP, is introduced to let
+user-space know of this extension. A simple 'read' of the capability would
+return the number of bitmapped registers. The user-space is expected to
+make a not of this value and configure each of the register.
+
+By default, these registers are set with the upper limit of the features that
+are supported. User-space can discover this configuration via GET_ONE_REG. If
+unsatisfied, the user-space can write back the desired bitmap back via
+SET_ONE_REG.
+
+The psuedo-firmware bitmap register are as follows:
+
+* KVM_REG_ARM_STD_BMAP:
+    Controls the bitmap of the ARM Standard Secure Service Calls.
+
+  The following bits are accepted:
+
+    KVM_REG_ARM_STD_BIT_TRNG_V1_0:
+      The bit represents the services offered under v1.0 of ARM True Random
+      Number Generator (TRNG) specification, ARM DEN0098.
+
+* KVM_REG_ARM_STD_HYP_BMAP:
+    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
+
+  The following bits are accepted:
+
+    KVM_REG_ARM_STD_HYP_BIT_PV_TIME:
+      The bit represents the Paravirtualized Time service as represented by
+      ARM DEN0057A.
+
+* KVM_REG_ARM_VENDOR_HYP_BMAP:
+    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
+
+  The following bits are accepted:
+
+    KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
+      The bit represents the Precision Time Protocol KVM service.
+
+Errors:
+
+    =======  =============================================================
+    -ENOENT   Unknown register accessed.
+    -EBUSY    Attempt a 'write' to the register after the VM has started.
+    -EINVAL   Invalid bitmap written to the register.
+    =======  =============================================================
+
+.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
\ No newline at end of file
-- 
2.34.1.448.ga2b2bfdf31-goog

