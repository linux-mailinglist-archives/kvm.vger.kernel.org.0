Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131167CAD43
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbjJPPT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbjJPPTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8794EE
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oXIYkBgWqGifderSC1Ie6itfGDjOSlFxOetg0dgIlJc=; b=ZqvA1DHpT6EVnq1euEg0gDCBf9
        zSVGzt6IKidO+fSnJxuFNxyeMPQL1z4FjZ52x3GefUUC6Uo8d/aytm/h1jw9qocdhjZOGcX8RiyNS
        NIpXSPw9iBK2BXZHrRwUM/8MG3xzuwa+lCIyyepUvCecX3XN3rySeoEx1lbB2MAt1Td1WAqF/KCUo
        csjWxFKfaZjk7AFxeU0WHuCkFAVqzh6Oie8noyrWhXdxXQ5/R6x6DNX9VMqv/tfkgjXT0l/i47BAF
        KVuWXsTz1qp/yBCO3SEPd2iyx53DEPo/MkMutsbbPAeUOCiYx+LHqT9hQca33aVMaGRqhtIDC75S4
        ODl5+8Sg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qsPNC-006lqZ-25; Mon, 16 Oct 2023 15:19:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0005nH-2M;
        Mon, 16 Oct 2023 16:19:13 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: [PATCH 03/12] include: update Xen public headers to Xen 4.17.2 release
Date:   Mon, 16 Oct 2023 16:19:00 +0100
Message-Id: <20231016151909.22133-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016151909.22133-1-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

... in order to advertise the XEN_HVM_CPUID_UPCALL_VECTOR feature,
which will come in a subsequent commit.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/i386/kvm/xen_xenstore.c                    |  2 +-
 include/hw/xen/interface/arch-arm.h           | 37 +++++++-------
 include/hw/xen/interface/arch-x86/cpuid.h     | 31 +++++-------
 .../hw/xen/interface/arch-x86/xen-x86_32.h    | 19 +------
 .../hw/xen/interface/arch-x86/xen-x86_64.h    | 19 +------
 include/hw/xen/interface/arch-x86/xen.h       | 26 ++--------
 include/hw/xen/interface/event_channel.h      | 19 +------
 include/hw/xen/interface/features.h           | 19 +------
 include/hw/xen/interface/grant_table.h        | 19 +------
 include/hw/xen/interface/hvm/hvm_op.h         | 19 +------
 include/hw/xen/interface/hvm/params.h         | 19 +------
 include/hw/xen/interface/io/blkif.h           | 27 ++++------
 include/hw/xen/interface/io/console.h         | 19 +------
 include/hw/xen/interface/io/fbif.h            | 19 +------
 include/hw/xen/interface/io/kbdif.h           | 19 +------
 include/hw/xen/interface/io/netif.h           | 25 +++-------
 include/hw/xen/interface/io/protocols.h       | 19 +------
 include/hw/xen/interface/io/ring.h            | 49 ++++++++++---------
 include/hw/xen/interface/io/usbif.h           | 19 +------
 include/hw/xen/interface/io/xenbus.h          | 19 +------
 include/hw/xen/interface/io/xs_wire.h         | 36 ++++++--------
 include/hw/xen/interface/memory.h             | 30 +++++-------
 include/hw/xen/interface/physdev.h            | 23 ++-------
 include/hw/xen/interface/sched.h              | 19 +------
 include/hw/xen/interface/trace.h              | 19 +------
 include/hw/xen/interface/vcpu.h               | 19 +------
 include/hw/xen/interface/version.h            | 19 +------
 include/hw/xen/interface/xen-compat.h         | 19 +------
 include/hw/xen/interface/xen.h                | 19 +------
 29 files changed, 124 insertions(+), 523 deletions(-)

diff --git a/hw/i386/kvm/xen_xenstore.c b/hw/i386/kvm/xen_xenstore.c
index 660d0b72f9..d2b311109b 100644
--- a/hw/i386/kvm/xen_xenstore.c
+++ b/hw/i386/kvm/xen_xenstore.c
@@ -331,7 +331,7 @@ static void xs_error(XenXenstoreState *s, unsigned int id,
     const char *errstr = NULL;
 
     for (unsigned int i = 0; i < ARRAY_SIZE(xsd_errors); i++) {
-        struct xsd_errors *xsd_error = &xsd_errors[i];
+        const struct xsd_errors *xsd_error = &xsd_errors[i];
 
         if (xsd_error->errnum == errnum) {
             errstr = xsd_error->errstring;
diff --git a/include/hw/xen/interface/arch-arm.h b/include/hw/xen/interface/arch-arm.h
index 94b31511dd..1528ced509 100644
--- a/include/hw/xen/interface/arch-arm.h
+++ b/include/hw/xen/interface/arch-arm.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * arch-arm.h
  *
  * Guest OS interface to ARM Xen.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright 2011 (C) Citrix Systems
  */
 
@@ -361,6 +344,7 @@ typedef uint64_t xen_callback_t;
 #define PSR_DBG_MASK    (1<<9)        /* arm64: Debug Exception mask */
 #define PSR_IT_MASK     (0x0600fc00)  /* Thumb If-Then Mask */
 #define PSR_JAZELLE     (1<<24)       /* Jazelle Mode */
+#define PSR_Z           (1<<30)       /* Zero condition flag */
 
 /* 32 bit modes */
 #define PSR_MODE_USR 0x10
@@ -383,7 +367,15 @@ typedef uint64_t xen_callback_t;
 #define PSR_MODE_EL1t 0x04
 #define PSR_MODE_EL0t 0x00
 
-#define PSR_GUEST32_INIT  (PSR_ABT_MASK|PSR_FIQ_MASK|PSR_IRQ_MASK|PSR_MODE_SVC)
+/*
+ * We set PSR_Z to be able to boot Linux kernel versions with an invalid
+ * encoding of the first 8 NOP instructions. See commit a92882a4d270 in
+ * Linux.
+ *
+ * Note that PSR_Z is also set by U-Boot and QEMU -kernel when loading
+ * zImage kernels on aarch32.
+ */
+#define PSR_GUEST32_INIT (PSR_Z|PSR_ABT_MASK|PSR_FIQ_MASK|PSR_IRQ_MASK|PSR_MODE_SVC)
 #define PSR_GUEST64_INIT (PSR_ABT_MASK|PSR_FIQ_MASK|PSR_IRQ_MASK|PSR_MODE_EL1h)
 
 #define SCTLR_GUEST_INIT    xen_mk_ullong(0x00c50078)
@@ -398,6 +390,10 @@ typedef uint64_t xen_callback_t;
 
 /* Physical Address Space */
 
+/* Virtio MMIO mappings */
+#define GUEST_VIRTIO_MMIO_BASE   xen_mk_ullong(0x02000000)
+#define GUEST_VIRTIO_MMIO_SIZE   xen_mk_ullong(0x00100000)
+
 /*
  * vGIC mappings: Only one set of mapping is used by the guest.
  * Therefore they can overlap.
@@ -484,6 +480,9 @@ typedef uint64_t xen_callback_t;
 
 #define GUEST_VPL011_SPI        32
 
+#define GUEST_VIRTIO_MMIO_SPI_FIRST   33
+#define GUEST_VIRTIO_MMIO_SPI_LAST    43
+
 /* PSCI functions */
 #define PSCI_cpu_suspend 0
 #define PSCI_cpu_off     1
diff --git a/include/hw/xen/interface/arch-x86/cpuid.h b/include/hw/xen/interface/arch-x86/cpuid.h
index ce46305bee..7ecd16ae05 100644
--- a/include/hw/xen/interface/arch-x86/cpuid.h
+++ b/include/hw/xen/interface/arch-x86/cpuid.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * arch-x86/cpuid.h
  *
  * CPUID interface to Xen.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2007 Citrix Systems, Inc.
  *
  * Authors:
@@ -102,6 +85,18 @@
 #define XEN_HVM_CPUID_IOMMU_MAPPINGS   (1u << 2)
 #define XEN_HVM_CPUID_VCPU_ID_PRESENT  (1u << 3) /* vcpu id is present in EBX */
 #define XEN_HVM_CPUID_DOMID_PRESENT    (1u << 4) /* domid is present in ECX */
+/*
+ * With interrupt format set to 0 (non-remappable) bits 55:49 from the
+ * IO-APIC RTE and bits 11:5 from the MSI address can be used to store
+ * high bits for the Destination ID. This expands the Destination ID
+ * field from 8 to 15 bits, allowing to target APIC IDs up 32768.
+ */
+#define XEN_HVM_CPUID_EXT_DEST_ID      (1u << 5)
+/*
+ * Per-vCPU event channel upcalls work correctly with physical IRQs
+ * bound to event channels.
+ */
+#define XEN_HVM_CPUID_UPCALL_VECTOR    (1u << 6)
 
 /*
  * Leaf 6 (0x40000x05)
diff --git a/include/hw/xen/interface/arch-x86/xen-x86_32.h b/include/hw/xen/interface/arch-x86/xen-x86_32.h
index 19d7388633..139438e835 100644
--- a/include/hw/xen/interface/arch-x86/xen-x86_32.h
+++ b/include/hw/xen/interface/arch-x86/xen-x86_32.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * xen-x86_32.h
  *
  * Guest OS interface to x86 32-bit Xen.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2004-2007, K A Fraser
  */
 
diff --git a/include/hw/xen/interface/arch-x86/xen-x86_64.h b/include/hw/xen/interface/arch-x86/xen-x86_64.h
index 40aed14366..5d9035ed22 100644
--- a/include/hw/xen/interface/arch-x86/xen-x86_64.h
+++ b/include/hw/xen/interface/arch-x86/xen-x86_64.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * xen-x86_64.h
  *
  * Guest OS interface to x86 64-bit Xen.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2004-2006, K A Fraser
  */
 
diff --git a/include/hw/xen/interface/arch-x86/xen.h b/include/hw/xen/interface/arch-x86/xen.h
index 7acd94c8eb..c0f4551247 100644
--- a/include/hw/xen/interface/arch-x86/xen.h
+++ b/include/hw/xen/interface/arch-x86/xen.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * arch-x86/xen.h
  *
  * Guest OS interface to x86 Xen.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2004-2006, K A Fraser
  */
 
@@ -320,12 +303,9 @@ struct xen_arch_domainconfig {
     uint32_t misc_flags;
 };
 
-/* Location of online VCPU bitmap. */
-#define XEN_ACPI_CPU_MAP             0xaf00
-#define XEN_ACPI_CPU_MAP_LEN         ((HVM_MAX_VCPUS + 7) / 8)
+/* Max  XEN_X86_* constant. Used for ABI checking. */
+#define XEN_X86_MISC_FLAGS_MAX XEN_X86_MSR_RELAXED
 
-/* GPE0 bit set during CPU hotplug */
-#define XEN_ACPI_GPE0_CPUHP_BIT      2
 #endif
 
 /*
diff --git a/include/hw/xen/interface/event_channel.h b/include/hw/xen/interface/event_channel.h
index 73c9f38ce1..0d91a1c4af 100644
--- a/include/hw/xen/interface/event_channel.h
+++ b/include/hw/xen/interface/event_channel.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * event_channel.h
  *
  * Event channels between domains.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2003-2004, K A Fraser.
  */
 
diff --git a/include/hw/xen/interface/features.h b/include/hw/xen/interface/features.h
index 9ee2f760ef..d2a9175aae 100644
--- a/include/hw/xen/interface/features.h
+++ b/include/hw/xen/interface/features.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * features.h
  *
  * Feature flags, reported by XENVER_get_features.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2006, Keir Fraser <keir@xensource.com>
  */
 
diff --git a/include/hw/xen/interface/grant_table.h b/include/hw/xen/interface/grant_table.h
index 7934d7b718..1dfa17a6d0 100644
--- a/include/hw/xen/interface/grant_table.h
+++ b/include/hw/xen/interface/grant_table.h
@@ -1,27 +1,10 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * grant_table.h
  *
  * Interface for granting foreign access to page frames, and receiving
  * page-ownership transfers.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2004, K A Fraser
  */
 
diff --git a/include/hw/xen/interface/hvm/hvm_op.h b/include/hw/xen/interface/hvm/hvm_op.h
index 870ec52060..e22adf0319 100644
--- a/include/hw/xen/interface/hvm/hvm_op.h
+++ b/include/hw/xen/interface/hvm/hvm_op.h
@@ -1,22 +1,5 @@
+/* SPDX-License-Identifier: MIT */
 /*
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2007, Keir Fraser
  */
 
diff --git a/include/hw/xen/interface/hvm/params.h b/include/hw/xen/interface/hvm/params.h
index c9d6e70d7b..a22b4ed45d 100644
--- a/include/hw/xen/interface/hvm/params.h
+++ b/include/hw/xen/interface/hvm/params.h
@@ -1,22 +1,5 @@
+/* SPDX-License-Identifier: MIT */
 /*
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2007, Keir Fraser
  */
 
diff --git a/include/hw/xen/interface/io/blkif.h b/include/hw/xen/interface/io/blkif.h
index 4cdba79aba..22f1eef0c0 100644
--- a/include/hw/xen/interface/io/blkif.h
+++ b/include/hw/xen/interface/io/blkif.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * blkif.h
  *
  * Unified block-device I/O interface for Xen guest OSes.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2003-2004, Keir Fraser
  * Copyright (c) 2012, Spectra Logic Corporation
  */
@@ -363,6 +346,14 @@
  *      that the frontend requires that the logical block size is 512 as it
  *      is hardcoded (which is the case in some frontend implementations).
  *
+ * trusted
+ *      Values:         0/1 (boolean)
+ *      Default value:  1
+ *
+ *      A value of "0" indicates that the frontend should not trust the
+ *      backend, and should deploy whatever measures available to protect from
+ *      a malicious backend on the other end.
+ *
  *------------------------- Virtual Device Properties -------------------------
  *
  * device-type
diff --git a/include/hw/xen/interface/io/console.h b/include/hw/xen/interface/io/console.h
index 4811f47220..4509b4b689 100644
--- a/include/hw/xen/interface/io/console.h
+++ b/include/hw/xen/interface/io/console.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * console.h
  *
  * Console I/O interface for Xen guest OSes.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2005, Keir Fraser
  */
 
diff --git a/include/hw/xen/interface/io/fbif.h b/include/hw/xen/interface/io/fbif.h
index cc25aab32e..93c73195d8 100644
--- a/include/hw/xen/interface/io/fbif.h
+++ b/include/hw/xen/interface/io/fbif.h
@@ -1,24 +1,7 @@
+/* SPDX-License-Identifier: MIT */
 /*
  * fbif.h -- Xen virtual frame buffer device
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (C) 2005 Anthony Liguori <aliguori@us.ibm.com>
  * Copyright (C) 2006 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
  */
diff --git a/include/hw/xen/interface/io/kbdif.h b/include/hw/xen/interface/io/kbdif.h
index a6b01c52c7..4bde6b3821 100644
--- a/include/hw/xen/interface/io/kbdif.h
+++ b/include/hw/xen/interface/io/kbdif.h
@@ -1,24 +1,7 @@
+/* SPDX-License-Identifier: MIT */
 /*
  * kbdif.h -- Xen virtual keyboard/mouse
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (C) 2005 Anthony Liguori <aliguori@us.ibm.com>
  * Copyright (C) 2006 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
  */
diff --git a/include/hw/xen/interface/io/netif.h b/include/hw/xen/interface/io/netif.h
index 00dd258712..c13b85061d 100644
--- a/include/hw/xen/interface/io/netif.h
+++ b/include/hw/xen/interface/io/netif.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * netif.h
  *
  * Unified network-device I/O interface for Xen guest OSes.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2003-2004, Keir Fraser
  */
 
@@ -160,6 +143,12 @@
  * be applied if it is set.
  */
 
+/*
+ * The setting of "trusted" node to "0" in the frontend path signals that the
+ * frontend should not trust the backend, and should deploy whatever measures
+ * available to protect from a malicious backend on the other end.
+ */
+
 /*
  * Control ring
  * ============
diff --git a/include/hw/xen/interface/io/protocols.h b/include/hw/xen/interface/io/protocols.h
index 52b4de0f81..7815e1ff0f 100644
--- a/include/hw/xen/interface/io/protocols.h
+++ b/include/hw/xen/interface/io/protocols.h
@@ -1,24 +1,7 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * protocols.h
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2008, Keir Fraser
  */
 
diff --git a/include/hw/xen/interface/io/ring.h b/include/hw/xen/interface/io/ring.h
index c486c457e0..025939278b 100644
--- a/include/hw/xen/interface/io/ring.h
+++ b/include/hw/xen/interface/io/ring.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * ring.h
  *
  * Shared producer-consumer ring macros.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Tim Deegan and Andrew Warfield November 2004.
  */
 
@@ -95,9 +78,8 @@ typedef unsigned int RING_IDX;
  * of the shared memory area (PAGE_SIZE, for instance). To initialise
  * the front half:
  *
- *     mytag_front_ring_t front_ring;
- *     SHARED_RING_INIT((mytag_sring_t *)shared_page);
- *     FRONT_RING_INIT(&front_ring, (mytag_sring_t *)shared_page, PAGE_SIZE);
+ *     mytag_front_ring_t ring;
+ *     XEN_FRONT_RING_INIT(&ring, (mytag_sring_t *)shared_page, PAGE_SIZE);
  *
  * Initializing the back follows similarly (note that only the front
  * initializes the shared ring):
@@ -184,6 +166,11 @@ typedef struct __name##_back_ring __name##_back_ring_t
 
 #define FRONT_RING_INIT(_r, _s, __size) FRONT_RING_ATTACH(_r, _s, 0, __size)
 
+#define XEN_FRONT_RING_INIT(r, s, size) do {                            \
+    SHARED_RING_INIT(s);                                                \
+    FRONT_RING_INIT(r, s, size);                                        \
+} while (0)
+
 #define BACK_RING_ATTACH(_r, _s, _i, __size) do {                       \
     (_r)->rsp_prod_pvt = (_i);                                          \
     (_r)->req_cons = (_i);                                              \
@@ -208,11 +195,11 @@ typedef struct __name##_back_ring __name##_back_ring_t
     (RING_FREE_REQUESTS(_r) == 0)
 
 /* Test if there are outstanding messages to be processed on a ring. */
-#define RING_HAS_UNCONSUMED_RESPONSES(_r)                               \
+#define XEN_RING_NR_UNCONSUMED_RESPONSES(_r)                            \
     ((_r)->sring->rsp_prod - (_r)->rsp_cons)
 
 #ifdef __GNUC__
-#define RING_HAS_UNCONSUMED_REQUESTS(_r) ({                             \
+#define XEN_RING_NR_UNCONSUMED_REQUESTS(_r) ({                          \
     unsigned int req = (_r)->sring->req_prod - (_r)->req_cons;          \
     unsigned int rsp = RING_SIZE(_r) -                                  \
         ((_r)->req_cons - (_r)->rsp_prod_pvt);                          \
@@ -220,13 +207,27 @@ typedef struct __name##_back_ring __name##_back_ring_t
 })
 #else
 /* Same as above, but without the nice GCC ({ ... }) syntax. */
-#define RING_HAS_UNCONSUMED_REQUESTS(_r)                                \
+#define XEN_RING_NR_UNCONSUMED_REQUESTS(_r)                             \
     ((((_r)->sring->req_prod - (_r)->req_cons) <                        \
       (RING_SIZE(_r) - ((_r)->req_cons - (_r)->rsp_prod_pvt))) ?        \
      ((_r)->sring->req_prod - (_r)->req_cons) :                         \
      (RING_SIZE(_r) - ((_r)->req_cons - (_r)->rsp_prod_pvt)))
 #endif
 
+#ifdef XEN_RING_HAS_UNCONSUMED_IS_BOOL
+/*
+ * These variants should only be used in case no caller is abusing them for
+ * obtaining the number of unconsumed responses/requests.
+ */
+#define RING_HAS_UNCONSUMED_RESPONSES(_r) \
+    (!!XEN_RING_NR_UNCONSUMED_RESPONSES(_r))
+#define RING_HAS_UNCONSUMED_REQUESTS(_r)  \
+    (!!XEN_RING_NR_UNCONSUMED_REQUESTS(_r))
+#else
+#define RING_HAS_UNCONSUMED_RESPONSES(_r) XEN_RING_NR_UNCONSUMED_RESPONSES(_r)
+#define RING_HAS_UNCONSUMED_REQUESTS(_r)  XEN_RING_NR_UNCONSUMED_REQUESTS(_r)
+#endif
+
 /* Direct access to individual ring elements, by index. */
 #define RING_GET_REQUEST(_r, _idx)                                      \
     (&((_r)->sring->ring[((_idx) & (RING_SIZE(_r) - 1))].req))
diff --git a/include/hw/xen/interface/io/usbif.h b/include/hw/xen/interface/io/usbif.h
index c0a552e195..875af0dc7c 100644
--- a/include/hw/xen/interface/io/usbif.h
+++ b/include/hw/xen/interface/io/usbif.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: MIT */
 /*
  * usbif.h
  *
@@ -5,24 +6,6 @@
  *
  * Copyright (C) 2009, FUJITSU LABORATORIES LTD.
  * Author: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
- *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
  */
 
 #ifndef __XEN_PUBLIC_IO_USBIF_H__
diff --git a/include/hw/xen/interface/io/xenbus.h b/include/hw/xen/interface/io/xenbus.h
index 927f9db552..9cd0cd7c67 100644
--- a/include/hw/xen/interface/io/xenbus.h
+++ b/include/hw/xen/interface/io/xenbus.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /*****************************************************************************
  * xenbus.h
  *
  * Xenbus protocol details.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (C) 2005 XenSource Ltd.
  */
 
diff --git a/include/hw/xen/interface/io/xs_wire.h b/include/hw/xen/interface/io/xs_wire.h
index 4dd6632669..04e6849feb 100644
--- a/include/hw/xen/interface/io/xs_wire.h
+++ b/include/hw/xen/interface/io/xs_wire.h
@@ -1,25 +1,8 @@
+/* SPDX-License-Identifier: MIT */
 /*
  * Details of the "wire" protocol between Xen Store Daemon and client
  * library or guest kernel.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (C) 2005 Rusty Russell IBM Corporation
  */
 
@@ -71,11 +54,12 @@ struct xsd_errors
 #ifdef EINVAL
 #define XSD_ERROR(x) { x, #x }
 /* LINTED: static unused */
-static struct xsd_errors xsd_errors[]
+static const struct xsd_errors xsd_errors[]
 #if defined(__GNUC__)
 __attribute__((unused))
 #endif
     = {
+    /* /!\ New errors should be added at the end of the array. */
     XSD_ERROR(EINVAL),
     XSD_ERROR(EACCES),
     XSD_ERROR(EEXIST),
@@ -90,7 +74,8 @@ __attribute__((unused))
     XSD_ERROR(EBUSY),
     XSD_ERROR(EAGAIN),
     XSD_ERROR(EISCONN),
-    XSD_ERROR(E2BIG)
+    XSD_ERROR(E2BIG),
+    XSD_ERROR(EPERM),
 };
 #endif
 
@@ -124,6 +109,7 @@ struct xenstore_domain_interface {
     XENSTORE_RING_IDX rsp_cons, rsp_prod;
     uint32_t server_features; /* Bitmap of features supported by the server */
     uint32_t connection;
+    uint32_t error;
 };
 
 /* Violating this is very bad.  See docs/misc/xenstore.txt. */
@@ -135,10 +121,18 @@ struct xenstore_domain_interface {
 
 /* The ability to reconnect a ring */
 #define XENSTORE_SERVER_FEATURE_RECONNECTION 1
+/* The presence of the "error" field in the ring page */
+#define XENSTORE_SERVER_FEATURE_ERROR        2
 
 /* Valid values for the connection field */
 #define XENSTORE_CONNECTED 0 /* the steady-state */
-#define XENSTORE_RECONNECT 1 /* guest has initiated a reconnect */
+#define XENSTORE_RECONNECT 1 /* reconnect in progress */
+
+/* Valid values for the error field */
+#define XENSTORE_ERROR_NONE    0 /* No error */
+#define XENSTORE_ERROR_COMM    1 /* Communication problem */
+#define XENSTORE_ERROR_RINGIDX 2 /* Invalid ring index */
+#define XENSTORE_ERROR_PROTO   3 /* Protocol violation (payload too long) */
 
 #endif /* _XS_WIRE_H */
 
diff --git a/include/hw/xen/interface/memory.h b/include/hw/xen/interface/memory.h
index 383a9468c3..29cf5c8239 100644
--- a/include/hw/xen/interface/memory.h
+++ b/include/hw/xen/interface/memory.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * memory.h
  *
  * Memory reservation and information.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
  */
 
@@ -541,12 +524,14 @@ struct xen_mem_sharing_op {
                 uint32_t gref;     /* IN: gref to debug         */
             } u;
         } debug;
-        struct mem_sharing_op_fork {      /* OP_FORK */
+        struct mem_sharing_op_fork {      /* OP_FORK{,_RESET} */
             domid_t parent_domain;        /* IN: parent's domain id */
 /* Only makes sense for short-lived forks */
 #define XENMEM_FORK_WITH_IOMMU_ALLOWED (1u << 0)
 /* Only makes sense for short-lived forks */
 #define XENMEM_FORK_BLOCK_INTERRUPTS   (1u << 1)
+#define XENMEM_FORK_RESET_STATE        (1u << 2)
+#define XENMEM_FORK_RESET_MEMORY       (1u << 3)
             uint16_t flags;               /* IN: optional settings */
             uint32_t pad;                 /* Must be set to 0 */
         } fork;
@@ -662,6 +647,13 @@ struct xen_mem_acquire_resource {
      * two calls.
      */
     uint32_t nr_frames;
+    /*
+     * Padding field, must be zero on input.
+     * In a previous version this was an output field with the lowest bit
+     * named XENMEM_rsrc_acq_caller_owned. Future versions of this interface
+     * will not reuse this bit as an output with the field being zero on
+     * input.
+     */
     uint32_t pad;
     /*
      * IN - the index of the initial frame to be mapped. This parameter
diff --git a/include/hw/xen/interface/physdev.h b/include/hw/xen/interface/physdev.h
index d271766ad0..f0c0d4727c 100644
--- a/include/hw/xen/interface/physdev.h
+++ b/include/hw/xen/interface/physdev.h
@@ -1,22 +1,5 @@
+/* SPDX-License-Identifier: MIT */
 /*
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2006, Keir Fraser
  */
 
@@ -211,8 +194,8 @@ struct physdev_manage_pci_ext {
     /* IN */
     uint8_t bus;
     uint8_t devfn;
-    unsigned is_extfn;
-    unsigned is_virtfn;
+    uint32_t is_extfn;
+    uint32_t is_virtfn;
     struct {
         uint8_t bus;
         uint8_t devfn;
diff --git a/include/hw/xen/interface/sched.h b/include/hw/xen/interface/sched.h
index 811bd87c82..b4362c6a1d 100644
--- a/include/hw/xen/interface/sched.h
+++ b/include/hw/xen/interface/sched.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * sched.h
  *
  * Scheduler state interactions
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
  */
 
diff --git a/include/hw/xen/interface/trace.h b/include/hw/xen/interface/trace.h
index d5fa4aea8d..62a179971d 100644
--- a/include/hw/xen/interface/trace.h
+++ b/include/hw/xen/interface/trace.h
@@ -1,24 +1,7 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * include/public/trace.h
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Mark Williamson, (C) 2004 Intel Research Cambridge
  * Copyright (C) 2005 Bin Ren
  */
diff --git a/include/hw/xen/interface/vcpu.h b/include/hw/xen/interface/vcpu.h
index 3623af932f..81a3b3a743 100644
--- a/include/hw/xen/interface/vcpu.h
+++ b/include/hw/xen/interface/vcpu.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * vcpu.h
  *
  * VCPU initialisation, query, and hotplug.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
  */
 
diff --git a/include/hw/xen/interface/version.h b/include/hw/xen/interface/version.h
index 17a81e23cd..9c78b4f3b6 100644
--- a/include/hw/xen/interface/version.h
+++ b/include/hw/xen/interface/version.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * version.h
  *
  * Xen version, type, and compile information.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2005, Nguyen Anh Quynh <aquynh@gmail.com>
  * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
  */
diff --git a/include/hw/xen/interface/xen-compat.h b/include/hw/xen/interface/xen-compat.h
index e1c027a95c..97fe698498 100644
--- a/include/hw/xen/interface/xen-compat.h
+++ b/include/hw/xen/interface/xen-compat.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * xen-compat.h
  *
  * Guest OS interface to Xen.  Compatibility layer.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2006, Christian Limpach
  */
 
diff --git a/include/hw/xen/interface/xen.h b/include/hw/xen/interface/xen.h
index e373592c33..920567e006 100644
--- a/include/hw/xen/interface/xen.h
+++ b/include/hw/xen/interface/xen.h
@@ -1,26 +1,9 @@
+/* SPDX-License-Identifier: MIT */
 /******************************************************************************
  * xen.h
  *
  * Guest OS interface to Xen.
  *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this software and associated documentation files (the "Software"), to
- * deal in the Software without restriction, including without limitation the
- * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
- * sell copies of the Software, and to permit persons to whom the Software is
- * furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
  * Copyright (c) 2004, K A Fraser
  */
 
-- 
2.40.1

