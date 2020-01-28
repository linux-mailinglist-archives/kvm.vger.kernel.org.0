Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E102B14B5E4
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgA1OAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:00:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59430 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgA1OAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 09:00:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RPG23Q5VInCW2/dcxso2308vuKWS9qa+8lTMVckj8OQ=; b=Jm/mS4979PllP7wiC6ArM0x9ZV
        R/hEEfHUbGbhrxuRhyGKFrRsFMP+gybu6Pv+8uF+TlTAEKL62nKtR7gfbpr3m/ACN/Fpp4teRdEvM
        93YF8FHsWuq6xYxW6eHfbsnsUz4eVjCqnWqx85lU1eVVNaIykphUd1elb9X0CTlvyeFWt142uLd31
        G9q+5uiSACyQHnuIpaqweYOVCTmWAuLEnCYpruPLuAGnKkxZ/AlGXm48+tIq8nyrSjjl1+cK0rc0C
        NF6jy6R8gU/hIU8lTRR5dhiJW4yjkne0XFwptReZZgLVPEAyiP50+I9rKP7ikVBZLdaro+4eLKPXE
        LgdZgfGg==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRQ6-0007is-91; Tue, 28 Jan 2020 14:00:46 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRPp-001BO9-Iz; Tue, 28 Jan 2020 15:00:29 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 12/27] docs: kvm: convert devices/vcpu.txt to ReST
Date:   Tue, 28 Jan 2020 15:00:13 +0100
Message-Id: <10cb8731b167ee8f0bbec245a9f89af3842bc279.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
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
 Documentation/virt/kvm/devices/vcpu.rst  | 112 +++++++++++++++++++++++
 Documentation/virt/kvm/devices/vcpu.txt  |  76 ---------------
 3 files changed, 113 insertions(+), 76 deletions(-)
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
index 000000000000..1270fd7f2cff
--- /dev/null
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -0,0 +1,112 @@
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
+:Architectures: ARM,ARM64
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

