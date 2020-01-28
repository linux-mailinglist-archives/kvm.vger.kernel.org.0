Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2342914BC50
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbgA1Ovx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:51:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgA1N6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=x2sp6iOc0E903sdVig18K8EVOnXyeDCsbEfAqgSYd/k=; b=Wqdn7PSG8YYCTbIM4duvfgQYBO
        7mA4hBsW+z65VIM9Iw6tpQCJbdNirWjuxnbABev+Bjrs4Kcmf6uOvdWmkpq9wsIe/E2irNFKlZ0FS
        mOYTL0it8Ylw/cqxk25KpxlqCKqyK12GOm5VYOqHRZ+UG1PjDj+lbzhintJuv+9FLVS2I+0YZSxJa
        mLq1a1Na0dMpMNKvfP9SdCS2R3KAoo6y1DNdZ4tvQHOY69ERTMrOu7Qw8YO8CciAXw6CMlNjZh9NJ
        8KIHy5EQuu9TnhreWVRrd7a5V4eLTVN33RiQyt77oxIY5SgifJlKHm1AidxlJ3zjKeWT6EqAI7aOz
        nYjZcr8A==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRO7-0006KI-V0; Tue, 28 Jan 2020 13:58:44 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRNq-001BKD-Kq; Tue, 28 Jan 2020 14:58:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 16/27] docs: kvm: convert devices/xive.txt to ReST
Date:   Tue, 28 Jan 2020 14:58:12 +0100
Message-Id: <126a26241472a0df74b8c19f489162ddc1edfc4b.1580219586.git.mchehab+huawei@kernel.org>
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
- mark code blocks as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/index.rst      |   1 +
 .../virt/kvm/devices/{xive.txt => xive.rst}   | 146 +++++++++++-------
 2 files changed, 94 insertions(+), 53 deletions(-)
 rename Documentation/virt/kvm/devices/{xive.txt => xive.rst} (63%)

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
similarity index 63%
rename from Documentation/virt/kvm/devices/xive.txt
rename to Documentation/virt/kvm/devices/xive.rst
index f5d1d6b5af61..e3947089b19c 100644
--- a/Documentation/virt/kvm/devices/xive.txt
+++ b/Documentation/virt/kvm/devices/xive.rst
@@ -1,8 +1,9 @@
+===========================================================
 POWER9 eXternal Interrupt Virtualization Engine (XIVE Gen1)
-==========================================================
+===========================================================
 
 Device types supported:
-  KVM_DEV_TYPE_XIVE     POWER9 XIVE Interrupt Controller generation 1
+  - KVM_DEV_TYPE_XIVE     POWER9 XIVE Interrupt Controller generation 1
 
 This device acts as a VM interrupt controller. It provides the KVM
 interface to configure the interrupt sources of a VM in the underlying
@@ -64,72 +65,100 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
 
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
@@ -138,8 +167,9 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
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
@@ -147,22 +177,31 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
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
 
@@ -175,11 +214,12 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
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
 
@@ -196,7 +236,7 @@ the legacy interrupt mode, referred as XICS (POWER7/8).
   3. Capture the state of the source targeting, the EQs configuration
   and the state of thread interrupt context registers.
 
-  Restore is similar :
+  Restore is similar:
 
   1. Restore the EQ configuration. As targeting depends on it.
   2. Restore targeting
-- 
2.24.1

