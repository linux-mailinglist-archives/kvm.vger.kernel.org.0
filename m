Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41D2156F0F
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgBJGDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:03:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36318 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbgBJGDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TMlBkOqOYR3ysxOJY5Cjd1qwRLlnNrloXMHDgT46IzQ=; b=J0fcXwq5l1R5uWl8/SEMWZJJ8v
        nNl0eTaDibgD04bLAeJtc/Mc81ulP0DrINjWEbzorIZIXYNMnGhhqO7CHidTYHWMOI2gAdUzVJ4qD
        Qd/qB+zvAuPc2oXEmoIHZKopbhTSA0h2NAH2RbRqNVAe/zIfEddY0jjR6xcHNe0JooOka0VVwsYo/
        l2y+eUA57tE5mdycIaQ2OaE7OwWMrEz5YHF/5KA7Mdg9UY9qV7G1aRkPqLgj/oww2mRYGTKKSa6Jy
        chXWhMLFb/dVdhOx5rzgZWR3z7aM+A5590MWPvT/uosYoa0IUj+jCHIVhyI5SrZI2O0YFth+NSLUw
        MQ89wmqQ==;
Received: from [80.156.29.194] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j12A3-0006Tm-QF; Mon, 10 Feb 2020 06:03:12 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1j12A2-00C2VW-4K; Mon, 10 Feb 2020 07:03:10 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 12/28] docs: kvm: convert devices/vcpu.txt to ReST
Date:   Mon, 10 Feb 2020 07:02:50 +0100
Message-Id: <2096c62896f7cb2a8e636e1b68135f00c23a0672.1581314317.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581314316.git.mchehab+huawei@kernel.org>
References: <cover.1581314316.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use title markups;
- adjust indentation and add blank lines as needed;
- adjust tables to match ReST accepted formats;
- use :field: markups;
- mark code blocks as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/index.rst |   1 +
 Documentation/virt/kvm/devices/vcpu.rst  | 114 +++++++++++++++++++++++
 Documentation/virt/kvm/devices/vcpu.txt  |  76 ---------------
 3 files changed, 115 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/virt/kvm/devices/vcpu.rst
 delete mode 100644 Documentation/virt/kvm/devices/vcpu.txt

diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index e6caccc36623..5a61838f0e61 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -12,3 +12,4 @@ Devices
    arm-vgic-v3
    mpic
    s390_flic
+   vcpu
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
new file mode 100644
index 000000000000..9963e680770a
--- /dev/null
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -0,0 +1,114 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+Generic vcpu interface
+======================
+
+The virtual cpu "device" also accepts the ioctls KVM_SET_DEVICE_ATTR,
+KVM_GET_DEVICE_ATTR, and KVM_HAS_DEVICE_ATTR. The interface uses the same struct
+kvm_device_attr as other devices, but targets VCPU-wide settings and controls.
+
+The groups and attributes per virtual cpu, if any, are architecture specific.
+
+1. GROUP: KVM_ARM_VCPU_PMU_V3_CTRL
+==================================
+
+:Architectures: ARM64
+
+1.1. ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_IRQ
+---------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address for PMU overflow interrupt is a
+	     pointer to an int
+
+Returns:
+
+	 =======  ========================================================
+	 -EBUSY   The PMU overflow interrupt is already set
+	 -ENXIO   The overflow interrupt not set when attempting to get it
+	 -ENODEV  PMUv3 not supported
+	 -EINVAL  Invalid PMU overflow interrupt number supplied or
+		  trying to set the IRQ number without using an in-kernel
+		  irqchip.
+	 =======  ========================================================
+
+A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
+number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
+type must be same for each vcpu. As a PPI, the interrupt number is the same for
+all vcpus, while as an SPI it must be a separate number per vcpu.
+
+1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
+---------------------------------------
+
+:Parameters: no additional parameter in kvm_device_attr.addr
+
+Returns:
+
+	 =======  ======================================================
+	 -ENODEV  PMUv3 not supported or GIC not initialized
+	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
+		  configured as required prior to calling this attribute
+	 -EBUSY   PMUv3 already initialized
+	 =======  ======================================================
+
+Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
+virtual GIC implementation, this must be done after initializing the in-kernel
+irqchip.
+
+
+2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
+=================================
+
+:Architectures: ARM, ARM64
+
+2.1. ATTRIBUTES: KVM_ARM_VCPU_TIMER_IRQ_VTIMER, KVM_ARM_VCPU_TIMER_IRQ_PTIMER
+-----------------------------------------------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address for the timer interrupt is a
+	     pointer to an int
+
+Returns:
+
+	 =======  =================================
+	 -EINVAL  Invalid timer interrupt number
+	 -EBUSY   One or more VCPUs has already run
+	 =======  =================================
+
+A value describing the architected timer interrupt number when connected to an
+in-kernel virtual GIC.  These must be a PPI (16 <= intid < 32).  Setting the
+attribute overrides the default values (see below).
+
+=============================  ==========================================
+KVM_ARM_VCPU_TIMER_IRQ_VTIMER  The EL1 virtual timer intid (default: 27)
+KVM_ARM_VCPU_TIMER_IRQ_PTIMER  The EL1 physical timer intid (default: 30)
+=============================  ==========================================
+
+Setting the same PPI for different timers will prevent the VCPUs from running.
+Setting the interrupt number on a VCPU configures all VCPUs created at that
+time to use the number provided for a given timer, overwriting any previously
+configured values on other VCPUs.  Userspace should configure the interrupt
+numbers on at least one VCPU after creating all VCPUs and before running any
+VCPUs.
+
+3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
+==================================
+
+:Architectures: ARM64
+
+3.1 ATTRIBUTE: KVM_ARM_VCPU_PVTIME_IPA
+--------------------------------------
+
+:Parameters: 64-bit base address
+
+Returns:
+
+	 =======  ======================================
+	 -ENXIO   Stolen time not implemented
+	 -EEXIST  Base address already set for this VCPU
+	 -EINVAL  Base address not 64 byte aligned
+	 =======  ======================================
+
+Specifies the base address of the stolen time structure for this VCPU. The
+base address must be 64 byte aligned and exist within a valid guest memory
+region. See Documentation/virt/kvm/arm/pvtime.txt for more information
+including the layout of the stolen time structure.
diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
deleted file mode 100644
index 6f3bd64a05b0..000000000000
--- a/Documentation/virt/kvm/devices/vcpu.txt
+++ /dev/null
@@ -1,76 +0,0 @@
-Generic vcpu interface
-====================================
-
-The virtual cpu "device" also accepts the ioctls KVM_SET_DEVICE_ATTR,
-KVM_GET_DEVICE_ATTR, and KVM_HAS_DEVICE_ATTR. The interface uses the same struct
-kvm_device_attr as other devices, but targets VCPU-wide settings and controls.
-
-The groups and attributes per virtual cpu, if any, are architecture specific.
-
-1. GROUP: KVM_ARM_VCPU_PMU_V3_CTRL
-Architectures: ARM64
-
-1.1. ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_IRQ
-Parameters: in kvm_device_attr.addr the address for PMU overflow interrupt is a
-            pointer to an int
-Returns: -EBUSY: The PMU overflow interrupt is already set
-         -ENXIO: The overflow interrupt not set when attempting to get it
-         -ENODEV: PMUv3 not supported
-         -EINVAL: Invalid PMU overflow interrupt number supplied or
-                  trying to set the IRQ number without using an in-kernel
-                  irqchip.
-
-A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
-number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
-type must be same for each vcpu. As a PPI, the interrupt number is the same for
-all vcpus, while as an SPI it must be a separate number per vcpu.
-
-1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
-Parameters: no additional parameter in kvm_device_attr.addr
-Returns: -ENODEV: PMUv3 not supported or GIC not initialized
-         -ENXIO: PMUv3 not properly configured or in-kernel irqchip not
-                 configured as required prior to calling this attribute
-         -EBUSY: PMUv3 already initialized
-
-Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
-virtual GIC implementation, this must be done after initializing the in-kernel
-irqchip.
-
-
-2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
-Architectures: ARM,ARM64
-
-2.1. ATTRIBUTE: KVM_ARM_VCPU_TIMER_IRQ_VTIMER
-2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_IRQ_PTIMER
-Parameters: in kvm_device_attr.addr the address for the timer interrupt is a
-            pointer to an int
-Returns: -EINVAL: Invalid timer interrupt number
-         -EBUSY:  One or more VCPUs has already run
-
-A value describing the architected timer interrupt number when connected to an
-in-kernel virtual GIC.  These must be a PPI (16 <= intid < 32).  Setting the
-attribute overrides the default values (see below).
-
-KVM_ARM_VCPU_TIMER_IRQ_VTIMER: The EL1 virtual timer intid (default: 27)
-KVM_ARM_VCPU_TIMER_IRQ_PTIMER: The EL1 physical timer intid (default: 30)
-
-Setting the same PPI for different timers will prevent the VCPUs from running.
-Setting the interrupt number on a VCPU configures all VCPUs created at that
-time to use the number provided for a given timer, overwriting any previously
-configured values on other VCPUs.  Userspace should configure the interrupt
-numbers on at least one VCPU after creating all VCPUs and before running any
-VCPUs.
-
-3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
-Architectures: ARM64
-
-3.1 ATTRIBUTE: KVM_ARM_VCPU_PVTIME_IPA
-Parameters: 64-bit base address
-Returns: -ENXIO:  Stolen time not implemented
-         -EEXIST: Base address already set for this VCPU
-         -EINVAL: Base address not 64 byte aligned
-
-Specifies the base address of the stolen time structure for this VCPU. The
-base address must be 64 byte aligned and exist within a valid guest memory
-region. See Documentation/virt/kvm/arm/pvtime.txt for more information
-including the layout of the stolen time structure.
-- 
2.24.1

