Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64493517AF9
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiEBXod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiEBXmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:42:39 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1160C286C0
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:39:08 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 15-20020aa7920f000000b0050cf449957fso8716261pfo.9
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 16:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iAnIEZoxFvZcpUiI2JvanBeFHfSeSOkvmHvqJfm/zII=;
        b=letkbXX6ibxsOx6SG6cpYtGpVqlihTPUapx3VMOK3tKO5nMAIBqLmP1R+G/H79hn6z
         D3dMy9lOsmUparnWVrS/zBQGNU1jPkdufkUlSlviUeK8cCW8y1BUri6EcEsO3QUL1Kin
         VIfhpnmPpDR3HCldG9pOtTuNJYHbY8Yq2OeikN5FPLkimtJ4eAwI2sEFzielefJ+nTff
         wyLlslbL/YsXyh3mkmpb7mnhXDyQj+rv2EEduT2zFyTaWWvTG3Lm9nRibnhGRm0PBVkq
         gK6MBN3z7/19iXoFZoZkkCjCbAHHr4D49VJlbJ2A19at1ljCx7dIN3SdOswdbkJlmulr
         s3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iAnIEZoxFvZcpUiI2JvanBeFHfSeSOkvmHvqJfm/zII=;
        b=AOwDs17PaI97GGL99dT1HIDQp9zE6+2b80W6f26iSXQPBU74vyUj5fNqEKO4wei0sB
         dmQGZm5h84MZbRbJfvlFPtqcgRU0+N6HmKpB6x5u7ixFMb2HYfGtuJAtcRaFkKBKSCDA
         HOEb38JbFHxX+6NNAhH/y6ZhOkHSUzrzqCgntOsqz9PTTOvgzsZzZ5+q736qqmUi//et
         cDw2IGWf3uHZYdCTMsX/Lh7k5vNSXsJoXzbqsly6Ldos2wnJ5rMJ+S70JSYMAR8flBjM
         VyOZPgaDu4TvsKhmas48yrMXstSVzfYJhCGNwkKe2cdl0tcBHzHEySQ2Dyy9ees5kTPx
         jJRQ==
X-Gm-Message-State: AOAM5306swpR/43t1MaPRlsrOKOoSlKyBrXTisE8gQnbNMdegiO8Ocpy
        Pubpyh5C9z37D8McWoyqJ72sNABk44od
X-Google-Smtp-Source: ABdhPJyXQR7muVhKAlvZ3f9QrEFalM+VA9iIEkI1MvgTnwrFA4Swlm7HbQmeqI8TiVM1t3D3hWJMl7T+c3MZ
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:2e0d:b0:1c9:b839:af02 with SMTP id
 q13-20020a17090a2e0d00b001c9b839af02mr1691249pjd.122.1651534748316; Mon, 02
 May 2022 16:39:08 -0700 (PDT)
Date:   Mon,  2 May 2022 23:38:50 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-7-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 6/9] Docs: KVM: Add doc for the bitmap firmware registers
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Gavin Shan <gshan@redhat.com>
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

Add the documentation for the bitmap firmware registers in
hypercalls.rst and api.rst. This includes the details for
KVM_REG_ARM_STD_BMAP, KVM_REG_ARM_STD_HYP_BMAP, and
KVM_REG_ARM_VENDOR_HYP_BMAP registers.

Since the document is growing to carry other hypercall related
information, make necessary adjustments to present the document
in a generic sense, rather than being PSCI focused.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst            | 16 ++++
 Documentation/virt/kvm/arm/hypercalls.rst | 94 ++++++++++++++++++-----
 2 files changed, 92 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4a900cdbc62e..8ae638be79fd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2542,6 +2542,22 @@ arm64 firmware pseudo-registers have the following bit pattern::
 
   0x6030 0000 0014 <regno:16>
 
+arm64 bitmap feature firmware pseudo-registers have the following bit pattern::
+
+  0x6030 0000 0016 <regno:16>
+
+The bitmap feature firmware registers exposes the hypercall services that are
+available for userspace to configure. The set bits corresponds to the services
+that are available for the guests to access. By default, KVM sets all the
+supported bits during VM initialization. The userspace can discover the
+available services via KVM_GET_ONE_REG, and write back the bitmap corresponding
+to the features that it wishes guests to see via KVM_SET_ONE_REG.
+
+Note: These registers are immutable once any of the vCPUs of the VM has run at
+least once. A KVM_SET_ONE_REG in such a scenario will return a -EBUSY to userspace.
+
+(See Documentation/virt/kvm/arm/hypercalls.rst for more details.)
+
 arm64 SVE registers have the following bit patterns::
 
   0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index d52c2e83b5b8..383ca766cf36 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
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
-to a convenient value if required.
+to a convenient value as required.
 
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
@@ -74,4 +74,62 @@ The following register is defined:
     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
       The workaround is always active on this vCPU or it is not needed.
 
-.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
+
+Bitmap Feature Firmware Registers
+---------------------------------
+
+Contrary to the above registers, the following registers exposes the hypercall
+services in the form of a feature-bitmap to the userspace. This bitmap is
+translated to the services that are available to the guest. There is a register
+defined per service call owner and can be accessed via GET/SET_ONE_REG interface.
+
+By default, these registers are set with the upper limit of the features that
+are supported. This way userspace can discover all the electable hypercall services
+via GET_ONE_REG. The user-space can write-back the desired bitmap back via
+SET_ONE_REG. The features for the registers that are untouched, probably because
+userspace isn't aware of them, will be exposed as is to the guest.
+
+Note that KVM would't allow the userspace to configure the registers anymore once
+any of the vCPUs has run at least once. Instead, it will return a -EBUSY.
+
+The psuedo-firmware bitmap register are as follows:
+
+* KVM_REG_ARM_STD_BMAP:
+    Controls the bitmap of the ARM Standard Secure Service Calls.
+
+  The following bits are accepted:
+
+    Bit-0: KVM_REG_ARM_STD_BIT_TRNG_V1_0:
+      The bit represents the services offered under v1.0 of ARM True Random
+      Number Generator (TRNG) specification, ARM DEN0098.
+
+* KVM_REG_ARM_STD_HYP_BMAP:
+    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
+
+  The following bits are accepted:
+
+    Bit-0: KVM_REG_ARM_STD_HYP_BIT_PV_TIME:
+      The bit represents the Paravirtualized Time service as represented by
+      ARM DEN0057A.
+
+* KVM_REG_ARM_VENDOR_HYP_BMAP:
+    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
+
+  The following bits are accepted:
+
+    Bit-0: KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT
+      The bit represents the ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID
+      and ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID function-ids.
+
+    Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
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
2.36.0.464.gb9c8b46e94-goog

