Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F109115468A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgBFOul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:50:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55586 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727599AbgBFOuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BBkxbTIBsbP281l/EajrQ33Ah82OprSYBCybWSzNyDw=; b=Y4FLe/XHPEPK7NrVGVgKxy2KT5
        SePDaNyK7vUUorE/rwONhNANltY//QyMa95hhAJfdXMqYiPrYqMfcwAeOOB007vYBRd2tp7QLPBkI
        RmtwDvuGHBoSKgx2/FJXnEjXxtyzyl7ZR0aPMU6rE0VTaLNq9WLsrXnfUGmrUxVeFfJdu1P0qORw/
        vmEkhjvwXy97ssiZBkeKQxoUS4TzmRlriJRamXg5t92PAzDJemC0PRhYq6HQK/sVhsjjgfRgfbGGj
        GKYvFmMI8JSKwVWCyHjx85PVLyZwn8B53pTJKkU5ue+25LE8/QhvhRwte3j8rUB9KHfcIhlFmXvMR
        lXi5Qsyg==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUI-0004Ip-U8; Thu, 06 Feb 2020 14:50:38 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU6-002nKz-IX; Thu, 06 Feb 2020 15:50:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 11/27] docs: kvm: convert devices/s390_flic.txt to ReST
Date:   Thu,  6 Feb 2020 15:50:08 +0100
Message-Id: <a09bd17c6228c2a6ee30b487b583d811ad7bc1f3.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use standard markup for document title;
- Adjust indentation and add blank lines as needed;
- use the notes markup;
- mark code blocks as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 Documentation/virt/kvm/devices/index.rst      |  1 +
 .../devices/{s390_flic.txt => s390_flic.rst}  | 70 +++++++++++--------
 2 files changed, 41 insertions(+), 30 deletions(-)
 rename Documentation/virt/kvm/devices/{s390_flic.txt => s390_flic.rst} (87%)

diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index 9e5586e371de..e6caccc36623 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -11,3 +11,4 @@ Devices
    arm-vgic
    arm-vgic-v3
    mpic
+   s390_flic
diff --git a/Documentation/virt/kvm/devices/s390_flic.txt b/Documentation/virt/kvm/devices/s390_flic.rst
similarity index 87%
rename from Documentation/virt/kvm/devices/s390_flic.txt
rename to Documentation/virt/kvm/devices/s390_flic.rst
index a4e20a090174..954190da7d04 100644
--- a/Documentation/virt/kvm/devices/s390_flic.txt
+++ b/Documentation/virt/kvm/devices/s390_flic.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================================
 FLIC (floating interrupt controller)
 ====================================
 
@@ -31,8 +34,10 @@ Groups:
     Copies all floating interrupts into a buffer provided by userspace.
     When the buffer is too small it returns -ENOMEM, which is the indication
     for userspace to try again with a bigger buffer.
+
     -ENOBUFS is returned when the allocation of a kernelspace buffer has
     failed.
+
     -EFAULT is returned when copying data to userspace failed.
     All interrupts remain pending, i.e. are not deleted from the list of
     currently pending interrupts.
@@ -60,38 +65,41 @@ Groups:
 
   KVM_DEV_FLIC_ADAPTER_REGISTER
     Register an I/O adapter interrupt source. Takes a kvm_s390_io_adapter
-    describing the adapter to register:
+    describing the adapter to register::
 
-struct kvm_s390_io_adapter {
-	__u32 id;
-	__u8 isc;
-	__u8 maskable;
-	__u8 swap;
-	__u8 flags;
-};
+	struct kvm_s390_io_adapter {
+		__u32 id;
+		__u8 isc;
+		__u8 maskable;
+		__u8 swap;
+		__u8 flags;
+	};
 
    id contains the unique id for the adapter, isc the I/O interruption subclass
    to use, maskable whether this adapter may be masked (interrupts turned off),
    swap whether the indicators need to be byte swapped, and flags contains
    further characteristics of the adapter.
+
    Currently defined values for 'flags' are:
+
    - KVM_S390_ADAPTER_SUPPRESSIBLE: adapter is subject to AIS
      (adapter-interrupt-suppression) facility. This flag only has an effect if
      the AIS capability is enabled.
+
    Unknown flag values are ignored.
 
 
   KVM_DEV_FLIC_ADAPTER_MODIFY
     Modifies attributes of an existing I/O adapter interrupt source. Takes
-    a kvm_s390_io_adapter_req specifying the adapter and the operation:
+    a kvm_s390_io_adapter_req specifying the adapter and the operation::
 
-struct kvm_s390_io_adapter_req {
-	__u32 id;
-	__u8 type;
-	__u8 mask;
-	__u16 pad0;
-	__u64 addr;
-};
+	struct kvm_s390_io_adapter_req {
+		__u32 id;
+		__u8 type;
+		__u8 mask;
+		__u16 pad0;
+		__u64 addr;
+	};
 
     id specifies the adapter and type the operation. The supported operations
     are:
@@ -103,8 +111,9 @@ struct kvm_s390_io_adapter_req {
       perform a gmap translation for the guest address provided in addr,
       pin a userspace page for the translated address and add it to the
       list of mappings
-      Note: A new mapping will be created unconditionally; therefore,
-            the calling code should avoid making duplicate mappings.
+
+      .. note:: A new mapping will be created unconditionally; therefore,
+	        the calling code should avoid making duplicate mappings.
 
     KVM_S390_IO_ADAPTER_UNMAP
       release a userspace page for the translated address specified in addr
@@ -112,16 +121,17 @@ struct kvm_s390_io_adapter_req {
 
   KVM_DEV_FLIC_AISM
     modify the adapter-interruption-suppression mode for a given isc if the
-    AIS capability is enabled. Takes a kvm_s390_ais_req describing:
+    AIS capability is enabled. Takes a kvm_s390_ais_req describing::
 
-struct kvm_s390_ais_req {
-	__u8 isc;
-	__u16 mode;
-};
+	struct kvm_s390_ais_req {
+		__u8 isc;
+		__u16 mode;
+	};
 
     isc contains the target I/O interruption subclass, mode the target
     adapter-interruption-suppression mode. The following modes are
     currently supported:
+
     - KVM_S390_AIS_MODE_ALL: ALL-Interruptions Mode, i.e. airq injection
       is always allowed;
     - KVM_S390_AIS_MODE_SINGLE: SINGLE-Interruption Mode, i.e. airq
@@ -139,12 +149,12 @@ struct kvm_s390_ais_req {
 
   KVM_DEV_FLIC_AISM_ALL
     Gets or sets the adapter-interruption-suppression mode for all ISCs. Takes
-    a kvm_s390_ais_all describing:
+    a kvm_s390_ais_all describing::
 
-struct kvm_s390_ais_all {
-       __u8 simm; /* Single-Interruption-Mode mask */
-       __u8 nimm; /* No-Interruption-Mode mask *
-};
+	struct kvm_s390_ais_all {
+	       __u8 simm; /* Single-Interruption-Mode mask */
+	       __u8 nimm; /* No-Interruption-Mode mask *
+	};
 
     simm contains Single-Interruption-Mode mask for all ISCs, nimm contains
     No-Interruption-Mode mask for all ISCs. Each bit in simm and nimm corresponds
@@ -159,5 +169,5 @@ ENXIO, as specified in the API documentation). It is not possible to conclude
 that a FLIC operation is unavailable based on the error code resulting from a
 usage attempt.
 
-Note: The KVM_DEV_FLIC_CLEAR_IO_IRQ ioctl will return EINVAL in case a zero
-schid is specified.
+.. note:: The KVM_DEV_FLIC_CLEAR_IO_IRQ ioctl will return EINVAL in case a
+	  zero schid is specified.
-- 
2.24.1

