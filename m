Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C514BBD8
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgA1Otk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:49:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbgA1OAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 09:00:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jCGNvxr49Lix6H95n0igp3NkedHJdEszNuxewfmtp4U=; b=fc1iY6Qx1yxSY+62KFqb/Clia9
        OYMkvWWkR2paMXKhmnjOBuzaKgV4Fnj3tCcWxxWsPGGpwPlfd4FwU4ZNJrCD2axU49+P7xMsEZmC9
        uWL/3zfYB+LS52QsgFLaFweeGd1SCMsQnXoOHQvKsTbA7ZQpmjOm69YifcTOfo2ft9cnDOCYAlmYh
        xt8sfvCT30mLzamI4qwPr9JyJ2GEMoXLSibP0E7uclu84q/KXaABqGTaPkr+6YUeI/LX839RXw4BU
        H2XceMpCByAw264O0SuA9EnqzIbOESmFWqwCzbZAt6WU0yu/K3HzPRIj9n36xc5UOrvD35bsWn9/Q
        pinGjYiw==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRQ5-0007ip-UM; Tue, 28 Jan 2020 14:00:45 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRPp-001BOO-Mg; Tue, 28 Jan 2020 15:00:29 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 15/27] docs: kvm: convert devices/xics.txt to ReST
Date:   Tue, 28 Jan 2020 15:00:16 +0100
Message-Id: <ad7db80d43d8afef0fffb5424fa1fc12fdf4ef50.1580219586.git.mchehab+huawei@kernel.org>
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
- use :field: markups.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/index.rst      |  1 +
 .../virt/kvm/devices/{xics.txt => xics.rst}   | 26 ++++++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)
 rename Documentation/virt/kvm/devices/{xics.txt => xics.rst} (85%)

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
similarity index 85%
rename from Documentation/virt/kvm/devices/xics.txt
rename to Documentation/virt/kvm/devices/xics.rst
index 423332dda7bc..74e36dbea0fd 100644
--- a/Documentation/virt/kvm/devices/xics.txt
+++ b/Documentation/virt/kvm/devices/xics.rst
@@ -1,20 +1,29 @@
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
@@ -53,24 +62,29 @@ the interrupt source number.  The 64 bit state word has the following
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

