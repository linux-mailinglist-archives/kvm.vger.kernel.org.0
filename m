Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46131546C8
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgBFOvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:51:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgBFOuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=W2TEM9K5krwWHu3V6Pmpbxn8qb5V0LOnOybj7d04Q5s=; b=ewnsLdph6Kx8fgV3UQNqbixry8
        9bLXKmbwu5wU8rp1lf0075WjycFTGKUnRq698+bvhG8sRuwaDoUwuVRL6IclOTeRFwabqdSLovLg4
        djEqE9xMHTGoebfyq9TMMbyl0eZoG1SLOJqyvS65UV2K0Zfar8W0fpcHJF7vLzJtF1qYTVoxDpxGa
        TM1SHP4RAVCem9htn8N7OkUVvRCfpmSmFLQ/iKLr3n5R4S3y+YOPnzw2Pq3yKc8rr/ym/avBNZqEW
        j96+GjUvWQkO8CqqmAq7l/4JiL/caEmayzu0l2eEro3mQRjQ8vgcWrpytQ8X3x98hXzZybDH5nf/r
        gOJn2oYQ==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUE-0004Ih-AE; Thu, 06 Feb 2020 14:50:34 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU6-002nLF-Nw; Thu, 06 Feb 2020 15:50:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 15/27] docs: kvm: convert devices/xics.txt to ReST
Date:   Thu,  6 Feb 2020 15:50:12 +0100
Message-Id: <09762491d91f061cf1252e8d535f06bcba8209f7.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use title markups;
- adjust indentation and add blank lines as needed;
- adjust tables to match ReST accepted formats;
- use :field: markups.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/index.rst      |  1 +
 .../virt/kvm/devices/{xics.txt => xics.rst}   | 28 +++++++++++++++----
 2 files changed, 23 insertions(+), 6 deletions(-)
 rename Documentation/virt/kvm/devices/{xics.txt => xics.rst} (84%)

diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index 29f8ecdf7fa0..63b61369d09b 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -15,3 +15,4 @@ Devices
    vcpu
    vfio
    vm
+   xics
diff --git a/Documentation/virt/kvm/devices/xics.txt b/Documentation/virt/kvm/devices/xics.rst
similarity index 84%
rename from Documentation/virt/kvm/devices/xics.txt
rename to Documentation/virt/kvm/devices/xics.rst
index 423332dda7bc..2d6927e0b776 100644
--- a/Documentation/virt/kvm/devices/xics.txt
+++ b/Documentation/virt/kvm/devices/xics.rst
@@ -1,20 +1,31 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
 XICS interrupt controller
+=========================
 
 Device type supported: KVM_DEV_TYPE_XICS
 
 Groups:
   1. KVM_DEV_XICS_GRP_SOURCES
-  Attributes: One per interrupt source, indexed by the source number.
+       Attributes:
 
+         One per interrupt source, indexed by the source number.
   2. KVM_DEV_XICS_GRP_CTRL
-  Attributes:
-    2.1 KVM_DEV_XICS_NR_SERVERS (write only)
+       Attributes:
+
+         2.1 KVM_DEV_XICS_NR_SERVERS (write only)
+
   The kvm_device_attr.addr points to a __u32 value which is the number of
   interrupt server numbers (ie, highest possible vcpu id plus one).
+
   Errors:
-    -EINVAL: Value greater than KVM_MAX_VCPU_ID.
-    -EFAULT: Invalid user pointer for attr->addr.
-    -EBUSY:  A vcpu is already connected to the device.
+
+    =======  ==========================================
+    -EINVAL  Value greater than KVM_MAX_VCPU_ID.
+    -EFAULT  Invalid user pointer for attr->addr.
+    -EBUSY   A vcpu is already connected to the device.
+    =======  ==========================================
 
 This device emulates the XICS (eXternal Interrupt Controller
 Specification) defined in PAPR.  The XICS has a set of interrupt
@@ -53,24 +64,29 @@ the interrupt source number.  The 64 bit state word has the following
 bitfields, starting from the least-significant end of the word:
 
 * Destination (server number), 32 bits
+
   This specifies where the interrupt should be sent, and is the
   interrupt server number specified for the destination vcpu.
 
 * Priority, 8 bits
+
   This is the priority specified for this interrupt source, where 0 is
   the highest priority and 255 is the lowest.  An interrupt with a
   priority of 255 will never be delivered.
 
 * Level sensitive flag, 1 bit
+
   This bit is 1 for a level-sensitive interrupt source, or 0 for
   edge-sensitive (or MSI).
 
 * Masked flag, 1 bit
+
   This bit is set to 1 if the interrupt is masked (cannot be delivered
   regardless of its priority), for example by the ibm,int-off RTAS
   call, or 0 if it is not masked.
 
 * Pending flag, 1 bit
+
   This bit is 1 if the source has a pending interrupt, otherwise 0.
 
 Only one XICS instance may be created per VM.
-- 
2.24.1

