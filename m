Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD384156F0A
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbgBJGDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:03:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbgBJGDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ncsM0xzARTSEa19oQa9XkTFMrAwUc3uVKUGgEy0y3l8=; b=YFUI6BTjJzMW979Q5ooq+9uCPE
        YFyUFJ4bRumzkkLisDJRtvDv9+gN82LW1aQ4Ik6ZEfvUEhSuGhpQBCmigBfSjzxFCrYfpz/eoM+26
        mmeOO/281qX8V0VtUYahWKrNs9fNsXb3WMP9PEcrv20SO41EbUAT6FIQRI/lWycPN1R3KUU3kFRYd
        YoKwiHBiIgEqn5w8ezTrdlDW3+CDEs/yc4Crlrkr44G/QwP80m12Jw5JsjjWkk+7ifzlWHuItzTEw
        KT4r36X5Mpys+8ROUJGcAD3mZJcVifCE3aq5z0WW8CA+C6iFoetoVSnZrzzxZW8we+uE931M+bU3q
        e5Zc5W3w==;
Received: from [80.156.29.194] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j12A3-0006Tq-VY; Mon, 10 Feb 2020 06:03:12 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1j12A2-00C2Vq-9C; Mon, 10 Feb 2020 07:03:10 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 16/28] docs: kvm: convert devices/xive.txt to ReST
Date:   Mon, 10 Feb 2020 07:02:54 +0100
Message-Id: <b35f1d6366524884a81bbfdf6733bb3f2531fc61.1581314317.git.mchehab+huawei@kernel.org>
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
- mark code blocks as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/index.rst      |   1 +
 .../virt/kvm/devices/{xive.txt => xive.rst}   | 148 +++++++++++-------
 2 files changed, 96 insertions(+), 53 deletions(-)
 rename Documentation/virt/kvm/devices/{xive.txt => xive.rst} (62%)

diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index 63b61369d09b..192cda7405c8 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -16,3 +16,4 @@ Devices
    vfio
    vm
    xics
+   xive
diff --git a/Documentation/virt/kvm/devices/xive.txt b/Documentation/virt/kvm/devices/xive.rst
similarity index 62%
rename from Documentation/virt/kvm/devices/xive.txt
rename to Documentation/virt/kvm/devices/xive.rst
index f5d1d6b5af61..8bdf3dc38f01 100644
--- a/Documentation/virt/kvm/devices/xive.txt
+++ b/Documentation/virt/kvm/devices/xive.rst
@@ -1,8 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================================================
 POWER9 eXternal Interrupt Virtualization Engine (XIVE Gen1)
-==========================================================
+===========================================================
 
 Device types supported:
-  KVM_DEV_TYPE_XIVE     POWER9 XIVE Interrupt Controller generation 1
+  - KVM_DEV_TYPE_XIVE     POWER9 XIVE Interrupt Controller generation 1
 
 This device acts as a VM interrupt controller. It provides the KVM
 interface to configure the interrupt sources of a VM in the underlying
@@ -64,72 +67,100 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
 
 * Groups:
 
-  1. KVM_DEV_XIVE_GRP_CTRL
-  Provides global controls on the device
+1. KVM_DEV_XIVE_GRP_CTRL
+     Provides global controls on the device
+
   Attributes:
     1.1 KVM_DEV_XIVE_RESET (write only)
     Resets the interrupt controller configuration for sources and event
     queues. To be used by kexec and kdump.
+
     Errors: none
 
     1.2 KVM_DEV_XIVE_EQ_SYNC (write only)
     Sync all the sources and queues and mark the EQ pages dirty. This
     to make sure that a consistent memory state is captured when
     migrating the VM.
+
     Errors: none
 
     1.3 KVM_DEV_XIVE_NR_SERVERS (write only)
     The kvm_device_attr.addr points to a __u32 value which is the number of
     interrupt server numbers (ie, highest possible vcpu id plus one).
+
     Errors:
-      -EINVAL: Value greater than KVM_MAX_VCPU_ID.
-      -EFAULT: Invalid user pointer for attr->addr.
-      -EBUSY:  A vCPU is already connected to the device.
 
-  2. KVM_DEV_XIVE_GRP_SOURCE (write only)
-  Initializes a new source in the XIVE device and mask it.
+      =======  ==========================================
+      -EINVAL  Value greater than KVM_MAX_VCPU_ID.
+      -EFAULT  Invalid user pointer for attr->addr.
+      -EBUSY   A vCPU is already connected to the device.
+      =======  ==========================================
+
+2. KVM_DEV_XIVE_GRP_SOURCE (write only)
+     Initializes a new source in the XIVE device and mask it.
+
   Attributes:
     Interrupt source number  (64-bit)
-  The kvm_device_attr.addr points to a __u64 value:
-  bits:     | 63   ....  2 |   1   |   0
-  values:   |    unused    | level | type
+
+  The kvm_device_attr.addr points to a __u64 value::
+
+    bits:     | 63   ....  2 |   1   |   0
+    values:   |    unused    | level | type
+
   - type:  0:MSI 1:LSI
   - level: assertion level in case of an LSI.
+
   Errors:
-    -E2BIG:  Interrupt source number is out of range
-    -ENOMEM: Could not create a new source block
-    -EFAULT: Invalid user pointer for attr->addr.
-    -ENXIO:  Could not allocate underlying HW interrupt
 
-  3. KVM_DEV_XIVE_GRP_SOURCE_CONFIG (write only)
-  Configures source targeting
+    =======  ==========================================
+    -E2BIG   Interrupt source number is out of range
+    -ENOMEM  Could not create a new source block
+    -EFAULT  Invalid user pointer for attr->addr.
+    -ENXIO   Could not allocate underlying HW interrupt
+    =======  ==========================================
+
+3. KVM_DEV_XIVE_GRP_SOURCE_CONFIG (write only)
+     Configures source targeting
+
   Attributes:
     Interrupt source number  (64-bit)
-  The kvm_device_attr.addr points to a __u64 value:
-  bits:     | 63   ....  33 |  32  | 31 .. 3 |  2 .. 0
-  values:   |    eisn       | mask |  server | priority
+
+  The kvm_device_attr.addr points to a __u64 value::
+
+    bits:     | 63   ....  33 |  32  | 31 .. 3 |  2 .. 0
+    values:   |    eisn       | mask |  server | priority
+
   - priority: 0-7 interrupt priority level
   - server: CPU number chosen to handle the interrupt
   - mask: mask flag (unused)
   - eisn: Effective Interrupt Source Number
+
   Errors:
-    -ENOENT: Unknown source number
-    -EINVAL: Not initialized source number
-    -EINVAL: Invalid priority
-    -EINVAL: Invalid CPU number.
-    -EFAULT: Invalid user pointer for attr->addr.
-    -ENXIO:  CPU event queues not configured or configuration of the
-             underlying HW interrupt failed
-    -EBUSY:  No CPU available to serve interrupt
 
-  4. KVM_DEV_XIVE_GRP_EQ_CONFIG (read-write)
-  Configures an event queue of a CPU
+    =======  =======================================================
+    -ENOENT  Unknown source number
+    -EINVAL  Not initialized source number
+    -EINVAL  Invalid priority
+    -EINVAL  Invalid CPU number.
+    -EFAULT  Invalid user pointer for attr->addr.
+    -ENXIO   CPU event queues not configured or configuration of the
+	     underlying HW interrupt failed
+    -EBUSY   No CPU available to serve interrupt
+    =======  =======================================================
+
+4. KVM_DEV_XIVE_GRP_EQ_CONFIG (read-write)
+     Configures an event queue of a CPU
+
   Attributes:
     EQ descriptor identifier (64-bit)
-  The EQ descriptor identifier is a tuple (server, priority) :
-  bits:     | 63   ....  32 | 31 .. 3 |  2 .. 0
-  values:   |    unused     |  server | priority
-  The kvm_device_attr.addr points to :
+
+  The EQ descriptor identifier is a tuple (server, priority)::
+
+    bits:     | 63   ....  32 | 31 .. 3 |  2 .. 0
+    values:   |    unused     |  server | priority
+
+  The kvm_device_attr.addr points to::
+
     struct kvm_ppc_xive_eq {
 	__u32 flags;
 	__u32 qshift;
@@ -138,8 +169,9 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
 	__u32 qindex;
 	__u8  pad[40];
     };
+
   - flags: queue flags
-    KVM_XIVE_EQ_ALWAYS_NOTIFY (required)
+      KVM_XIVE_EQ_ALWAYS_NOTIFY (required)
 	forces notification without using the coalescing mechanism
 	provided by the XIVE END ESBs.
   - qshift: queue size (power of 2)
@@ -147,22 +179,31 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
   - qtoggle: current queue toggle bit
   - qindex: current queue index
   - pad: reserved for future use
+
   Errors:
-    -ENOENT: Invalid CPU number
-    -EINVAL: Invalid priority
-    -EINVAL: Invalid flags
-    -EINVAL: Invalid queue size
-    -EINVAL: Invalid queue address
-    -EFAULT: Invalid user pointer for attr->addr.
-    -EIO:    Configuration of the underlying HW failed
 
-  5. KVM_DEV_XIVE_GRP_SOURCE_SYNC (write only)
-  Synchronize the source to flush event notifications
+    =======  =========================================
+    -ENOENT  Invalid CPU number
+    -EINVAL  Invalid priority
+    -EINVAL  Invalid flags
+    -EINVAL  Invalid queue size
+    -EINVAL  Invalid queue address
+    -EFAULT  Invalid user pointer for attr->addr.
+    -EIO     Configuration of the underlying HW failed
+    =======  =========================================
+
+5. KVM_DEV_XIVE_GRP_SOURCE_SYNC (write only)
+     Synchronize the source to flush event notifications
+
   Attributes:
     Interrupt source number  (64-bit)
+
   Errors:
-    -ENOENT: Unknown source number
-    -EINVAL: Not initialized source number
+
+    =======  =============================
+    -ENOENT  Unknown source number
+    -EINVAL  Not initialized source number
+    =======  =============================
 
 * VCPU state
 
@@ -175,11 +216,12 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
   as it synthesizes the priorities of the pending interrupts. We
   capture a bit more to report debug information.
 
-  KVM_REG_PPC_VP_STATE (2 * 64bits)
-  bits:     |  63  ....  32  |  31  ....  0  |
-  values:   |   TIMA word0   |   TIMA word1  |
-  bits:     | 127       ..........       64  |
-  values:   |            unused              |
+  KVM_REG_PPC_VP_STATE (2 * 64bits)::
+
+    bits:     |  63  ....  32  |  31  ....  0  |
+    values:   |   TIMA word0   |   TIMA word1  |
+    bits:     | 127       ..........       64  |
+    values:   |            unused              |
 
 * Migration:
 
@@ -196,7 +238,7 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
   3. Capture the state of the source targeting, the EQs configuration
   and the state of thread interrupt context registers.
 
-  Restore is similar :
+  Restore is similar:
 
   1. Restore the EQ configuration. As targeting depends on it.
   2. Restore targeting
-- 
2.24.1

