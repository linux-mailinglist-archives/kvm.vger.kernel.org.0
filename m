Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD29C156F2E
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgBJGDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:03:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbgBJGDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=UoVoTfeqJAIn1DpUiVy/iSRc5XPT39jOF0FCEyMWDLs=; b=dV5tIkA3WQzanAgcull5UTsR+I
        ChuUYSBe1bz5gKlrB9q2wOVKYUaZTF1HxcGyRiRVKRDekvpEt8eQpY8UtzKuOjqU4c94dHKgilt+z
        gXFAp97JbXpH2mFniBLyue1PJJ3MEtBQUqbtgetSc6Cy9bDSKp+HvrdHge8S3BAA5SDjSHMl7EhqA
        egRaBMVWMF22I06uZtqazKadnXwLYkr6IhsTlo6CiEQfBXKezOsfGE+FSL8SRP//HmWWevGLyfD/+
        5D4Sl1QdQBUWGB+XitVS3CvpVPxAZ+KG1fgEckG2VUm6o+NinaCnn1WnCPaCHl/2+VTEydwBOXCBR
        930j1qaA==;
Received: from [80.156.29.194] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j12A3-0006Tj-MK; Mon, 10 Feb 2020 06:03:11 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1j12A2-00C2VH-1M; Mon, 10 Feb 2020 07:03:10 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 09/28] docs: kvm: convert devices/arm-vgit.txt to ReST
Date:   Mon, 10 Feb 2020 07:02:47 +0100
Message-Id: <1a49c2b2088952f56c317f2ec533f45e6801f2b1.1581314317.git.mchehab+huawei@kernel.org>
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
- change indent to match ReST syntax;
- use proper table markups;
- use literal block markups.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../devices/{arm-vgic.txt => arm-vgic.rst}    | 89 ++++++++++++-------
 Documentation/virt/kvm/devices/index.rst      |  1 +
 2 files changed, 60 insertions(+), 30 deletions(-)
 rename Documentation/virt/kvm/devices/{arm-vgic.txt => arm-vgic.rst} (66%)

diff --git a/Documentation/virt/kvm/devices/arm-vgic.txt b/Documentation/virt/kvm/devices/arm-vgic.rst
similarity index 66%
rename from Documentation/virt/kvm/devices/arm-vgic.txt
rename to Documentation/virt/kvm/devices/arm-vgic.rst
index 97b6518148f8..40bdeea1d86e 100644
--- a/Documentation/virt/kvm/devices/arm-vgic.txt
+++ b/Documentation/virt/kvm/devices/arm-vgic.rst
@@ -1,8 +1,12 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================================
 ARM Virtual Generic Interrupt Controller v2 (VGIC)
 ==================================================
 
 Device types supported:
-  KVM_DEV_TYPE_ARM_VGIC_V2     ARM Generic Interrupt Controller v2.0
+
+  - KVM_DEV_TYPE_ARM_VGIC_V2     ARM Generic Interrupt Controller v2.0
 
 Only one VGIC instance may be instantiated through either this API or the
 legacy KVM_CREATE_IRQCHIP API.  The created VGIC will act as the VM interrupt
@@ -17,7 +21,8 @@ create both a GICv3 and GICv2 device on the same VM.
 
 Groups:
   KVM_DEV_ARM_VGIC_GRP_ADDR
-  Attributes:
+   Attributes:
+
     KVM_VGIC_V2_ADDR_TYPE_DIST (rw, 64-bit)
       Base address in the guest physical address space of the GIC distributor
       register mappings. Only valid for KVM_DEV_TYPE_ARM_VGIC_V2.
@@ -27,19 +32,25 @@ Groups:
       Base address in the guest physical address space of the GIC virtual cpu
       interface register mappings. Only valid for KVM_DEV_TYPE_ARM_VGIC_V2.
       This address needs to be 4K aligned and the region covers 4 KByte.
+
   Errors:
-    -E2BIG:  Address outside of addressable IPA range
-    -EINVAL: Incorrectly aligned address
-    -EEXIST: Address already configured
-    -ENXIO:  The group or attribute is unknown/unsupported for this device
+
+    =======  =============================================================
+    -E2BIG   Address outside of addressable IPA range
+    -EINVAL  Incorrectly aligned address
+    -EEXIST  Address already configured
+    -ENXIO   The group or attribute is unknown/unsupported for this device
              or hardware support is missing.
-    -EFAULT: Invalid user pointer for attr->addr.
+    -EFAULT  Invalid user pointer for attr->addr.
+    =======  =============================================================
 
   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
-  Attributes:
-    The attr field of kvm_device_attr encodes two values:
-    bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
-    values:   |    reserved   | vcpu_index |      offset     |
+   Attributes:
+
+    The attr field of kvm_device_attr encodes two values::
+
+      bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
+      values:   |    reserved   | vcpu_index |      offset     |
 
     All distributor regs are (rw, 32-bit)
 
@@ -58,16 +69,22 @@ Groups:
     KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_CPU_REGS) to ensure
     the expected behavior. Unless GICD_IIDR has been set from userspace, writes
     to the interrupt group registers (GICD_IGROUPR) are ignored.
+
   Errors:
-    -ENXIO: Getting or setting this register is not yet supported
-    -EBUSY: One or more VCPUs are running
-    -EINVAL: Invalid vcpu_index supplied
+
+    =======  =====================================================
+    -ENXIO   Getting or setting this register is not yet supported
+    -EBUSY   One or more VCPUs are running
+    -EINVAL  Invalid vcpu_index supplied
+    =======  =====================================================
 
   KVM_DEV_ARM_VGIC_GRP_CPU_REGS
-  Attributes:
-    The attr field of kvm_device_attr encodes two values:
-    bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
-    values:   |    reserved   | vcpu_index |      offset     |
+   Attributes:
+
+    The attr field of kvm_device_attr encodes two values::
+
+      bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
+      values:   |    reserved   | vcpu_index |      offset     |
 
     All CPU interface regs are (rw, 32-bit)
 
@@ -101,27 +118,39 @@ Groups:
     value left by 3 places to obtain the actual priority mask level.
 
   Errors:
-    -ENXIO: Getting or setting this register is not yet supported
-    -EBUSY: One or more VCPUs are running
-    -EINVAL: Invalid vcpu_index supplied
+
+    =======  =====================================================
+    -ENXIO   Getting or setting this register is not yet supported
+    -EBUSY   One or more VCPUs are running
+    -EINVAL  Invalid vcpu_index supplied
+    =======  =====================================================
 
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
-  Attributes:
+   Attributes:
+
     A value describing the number of interrupts (SGI, PPI and SPI) for
     this GIC instance, ranging from 64 to 1024, in increments of 32.
 
   Errors:
-    -EINVAL: Value set is out of the expected range
-    -EBUSY: Value has already be set, or GIC has already been initialized
-            with default values.
+
+    =======  =============================================================
+    -EINVAL  Value set is out of the expected range
+    -EBUSY   Value has already be set, or GIC has already been initialized
+             with default values.
+    =======  =============================================================
 
   KVM_DEV_ARM_VGIC_GRP_CTRL
-  Attributes:
+   Attributes:
+
     KVM_DEV_ARM_VGIC_CTRL_INIT
       request the initialization of the VGIC or ITS, no additional parameter
       in kvm_device_attr.addr.
+
   Errors:
-    -ENXIO: VGIC not properly configured as required prior to calling
-     this attribute
-    -ENODEV: no online VCPU
-    -ENOMEM: memory shortage when allocating vgic internal data
+
+    =======  =========================================================
+    -ENXIO   VGIC not properly configured as required prior to calling
+             this attribute
+    -ENODEV  no online VCPU
+    -ENOMEM  memory shortage when allocating vgic internal data
+    =======  =========================================================
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index 80c1e0e225f4..7eabce80c61e 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -8,4 +8,5 @@ Devices
    :maxdepth: 2
 
    arm-vgic-its
+   arm-vgic
    arm-vgic-v3
-- 
2.24.1

