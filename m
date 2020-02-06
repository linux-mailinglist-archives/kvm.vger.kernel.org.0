Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742D615469B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgBFOux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:50:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbgBFOuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Q0ByLN+MT5oQ7WLNRqLDh/71ln8CBqGELV7pKOMFo6g=; b=GC9WjhS8SAh4Z+Tybj40NJqhXA
        8Qhgn8UhEa3Vu6TNzMAV7CdCbfXYyu8dwc2tVTy9pouYTlQ138iuC/6yyiPjTRHbMmXVjt2vQSiNA
        xdwzof4OBpxoAOL6a+8rF1ZAyjItE4H/xaic6sAdGW0sWNQiaARmh9qunuS6kzKg7zQvuJhOuDy8w
        XkXIkS7vMk4ulog5Q17g63bWZ6qrqTnHlOM5H4sP566mz9Cq0KMYjmdtgE3zfjSOegQod8pCdXfR6
        Hf61uc7sHBvarA+aPN2UFCqJylSRBoLePZCc/znnxT9uSGkIitJ7pEKWJoMAF5w3oXcLNvJjmm9VD
        IY9vLO+A==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUI-0004Ii-Ui; Thu, 06 Feb 2020 14:50:39 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU6-002nKj-E6; Thu, 06 Feb 2020 15:50:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 07/27] docs: kvm: devices/arm-vgic-its.txt to ReST format
Date:   Thu,  6 Feb 2020 15:50:04 +0100
Message-Id: <ff61f78f76020b256f6695d084306435bf14721c.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Fix document title to match ReST format
- Convert the table to be properly recognized
- use proper markups for literal blocks
- Some indentation fixes to match ReST

While here, add an index for kvm devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../{arm-vgic-its.txt => arm-vgic-its.rst}    | 106 +++++++++++-------
 Documentation/virt/kvm/devices/index.rst      |  10 ++
 Documentation/virt/kvm/index.rst              |   1 +
 3 files changed, 78 insertions(+), 39 deletions(-)
 rename Documentation/virt/kvm/devices/{arm-vgic-its.txt => arm-vgic-its.rst} (71%)
 create mode 100644 Documentation/virt/kvm/devices/index.rst

diff --git a/Documentation/virt/kvm/devices/arm-vgic-its.txt b/Documentation/virt/kvm/devices/arm-vgic-its.rst
similarity index 71%
rename from Documentation/virt/kvm/devices/arm-vgic-its.txt
rename to Documentation/virt/kvm/devices/arm-vgic-its.rst
index eeaa95b893a8..6c304fd2b1b4 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-its.txt
+++ b/Documentation/virt/kvm/devices/arm-vgic-its.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================================
 ARM Virtual Interrupt Translation Service (ITS)
 ===============================================
 
@@ -12,22 +15,32 @@ There can be multiple ITS controllers per guest, each of them has to have
 a separate, non-overlapping MMIO region.
 
 
-Groups:
-  KVM_DEV_ARM_VGIC_GRP_ADDR
+Groups
+======
+
+KVM_DEV_ARM_VGIC_GRP_ADDR
+-------------------------
+
   Attributes:
     KVM_VGIC_ITS_ADDR_TYPE (rw, 64-bit)
       Base address in the guest physical address space of the GICv3 ITS
       control register frame.
       This address needs to be 64K aligned and the region covers 128K.
+
   Errors:
-    -E2BIG:  Address outside of addressable IPA range
-    -EINVAL: Incorrectly aligned address
-    -EEXIST: Address already configured
-    -EFAULT: Invalid user pointer for attr->addr.
-    -ENODEV: Incorrect attribute or the ITS is not supported.
 
+    =======  =================================================
+    -E2BIG   Address outside of addressable IPA range
+    -EINVAL  Incorrectly aligned address
+    -EEXIST  Address already configured
+    -EFAULT  Invalid user pointer for attr->addr.
+    -ENODEV  Incorrect attribute or the ITS is not supported.
+    =======  =================================================
+
+
+KVM_DEV_ARM_VGIC_GRP_CTRL
+-------------------------
 
-  KVM_DEV_ARM_VGIC_GRP_CTRL
   Attributes:
     KVM_DEV_ARM_VGIC_CTRL_INIT
       request the initialization of the ITS, no additional parameter in
@@ -58,16 +71,21 @@ Groups:
       "ITS Restore Sequence".
 
   Errors:
-    -ENXIO:  ITS not properly configured as required prior to setting
+
+    =======  ==========================================================
+     -ENXIO  ITS not properly configured as required prior to setting
              this attribute
-    -ENOMEM: Memory shortage when allocating ITS internal data
-    -EINVAL: Inconsistent restored data
-    -EFAULT: Invalid guest ram access
-    -EBUSY:  One or more VCPUS are running
-    -EACCES: The virtual ITS is backed by a physical GICv4 ITS, and the
+    -ENOMEM  Memory shortage when allocating ITS internal data
+    -EINVAL  Inconsistent restored data
+    -EFAULT  Invalid guest ram access
+    -EBUSY   One or more VCPUS are running
+    -EACCES  The virtual ITS is backed by a physical GICv4 ITS, and the
 	     state is not available
+    =======  ==========================================================
+
+KVM_DEV_ARM_VGIC_GRP_ITS_REGS
+-----------------------------
 
-  KVM_DEV_ARM_VGIC_GRP_ITS_REGS
   Attributes:
       The attr field of kvm_device_attr encodes the offset of the
       ITS register, relative to the ITS control frame base address
@@ -78,6 +96,7 @@ Groups:
       be accessed with full length.
 
       Writes to read-only registers are ignored by the kernel except for:
+
       - GITS_CREADR. It must be restored otherwise commands in the queue
         will be re-executed after restoring CWRITER. GITS_CREADR must be
         restored before restoring the GITS_CTLR which is likely to enable the
@@ -91,30 +110,36 @@ Groups:
 
       For other registers, getting or setting a register has the same
       effect as reading/writing the register on real hardware.
+
   Errors:
-    -ENXIO: Offset does not correspond to any supported register
-    -EFAULT: Invalid user pointer for attr->addr
-    -EINVAL: Offset is not 64-bit aligned
-    -EBUSY: one or more VCPUS are running
 
- ITS Restore Sequence:
- -------------------------
+    =======  ====================================================
+    -ENXIO   Offset does not correspond to any supported register
+    -EFAULT  Invalid user pointer for attr->addr
+    -EINVAL  Offset is not 64-bit aligned
+    -EBUSY   one or more VCPUS are running
+    =======  ====================================================
+
+ITS Restore Sequence:
+---------------------
 
 The following ordering must be followed when restoring the GIC and the ITS:
+
 a) restore all guest memory and create vcpus
 b) restore all redistributors
 c) provide the ITS base address
    (KVM_DEV_ARM_VGIC_GRP_ADDR)
 d) restore the ITS in the following order:
-   1. Restore GITS_CBASER
-   2. Restore all other GITS_ registers, except GITS_CTLR!
-   3. Load the ITS table data (KVM_DEV_ARM_ITS_RESTORE_TABLES)
-   4. Restore GITS_CTLR
+
+     1. Restore GITS_CBASER
+     2. Restore all other ``GITS_`` registers, except GITS_CTLR!
+     3. Load the ITS table data (KVM_DEV_ARM_ITS_RESTORE_TABLES)
+     4. Restore GITS_CTLR
 
 Then vcpus can be started.
 
- ITS Table ABI REV0:
- -------------------
+ITS Table ABI REV0:
+-------------------
 
  Revision 0 of the ABI only supports the features of a virtual GICv3, and does
  not support a virtual GICv4 with support for direct injection of virtual
@@ -125,12 +150,13 @@ Then vcpus can be started.
  entries in the collection are listed in no particular order.
  All entries are 8 bytes.
 
- Device Table Entry (DTE):
+ Device Table Entry (DTE)::
 
- bits:     | 63| 62 ... 49 | 48 ... 5 | 4 ... 0 |
- values:   | V |   next    | ITT_addr |  Size   |
+   bits:     | 63| 62 ... 49 | 48 ... 5 | 4 ... 0 |
+   values:   | V |   next    | ITT_addr |  Size   |
+
+ where:
 
- where;
  - V indicates whether the entry is valid. If not, other fields
    are not meaningful.
  - next: equals to 0 if this entry is the last one; otherwise it
@@ -140,32 +166,34 @@ Then vcpus can be started.
  - Size specifies the supported number of bits for the EventID,
    minus one
 
- Collection Table Entry (CTE):
+ Collection Table Entry (CTE)::
 
- bits:     | 63| 62 ..  52  | 51 ... 16 | 15  ...   0 |
- values:   | V |    RES0    |  RDBase   |    ICID     |
+   bits:     | 63| 62 ..  52  | 51 ... 16 | 15  ...   0 |
+   values:   | V |    RES0    |  RDBase   |    ICID     |
 
  where:
+
  - V indicates whether the entry is valid. If not, other fields are
    not meaningful.
  - RES0: reserved field with Should-Be-Zero-or-Preserved behavior.
  - RDBase is the PE number (GICR_TYPER.Processor_Number semantic),
  - ICID is the collection ID
 
- Interrupt Translation Entry (ITE):
+ Interrupt Translation Entry (ITE)::
 
- bits:     | 63 ... 48 | 47 ... 16 | 15 ... 0 |
- values:   |    next   |   pINTID  |  ICID    |
+   bits:     | 63 ... 48 | 47 ... 16 | 15 ... 0 |
+   values:   |    next   |   pINTID  |  ICID    |
 
  where:
+
  - next: equals to 0 if this entry is the last one; otherwise it corresponds
    to the EventID offset to the next ITE capped by 2^16 -1.
  - pINTID is the physical LPI ID; if zero, it means the entry is not valid
    and other fields are not meaningful.
  - ICID is the collection ID
 
- ITS Reset State:
- ----------------
+ITS Reset State:
+----------------
 
 RESET returns the ITS to the same state that it was when first created and
 initialized. When the RESET command returns, the following things are
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
new file mode 100644
index 000000000000..2aad8d426097
--- /dev/null
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -0,0 +1,10 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======
+Devices
+=======
+
+.. toctree::
+   :maxdepth: 2
+
+   arm-vgic-its
diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index cc6dde47b267..24d1076ec680 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -14,3 +14,4 @@ KVM
    vcpu-requests
 
    arm/index
+   devices/index
-- 
2.24.1

