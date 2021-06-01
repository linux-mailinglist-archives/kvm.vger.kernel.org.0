Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DA63977CD
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhFAQR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 12:17:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhFAQR0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 12:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622564145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q4leLm952lrrTCgalhESBYHzQycOxByzl6dLVNBRG84=;
        b=QKX9Tt7UIi5y7juND1IifDuBTmw3ogEviAUKIFiHykjseAIE1DGUt3LWvUef7IIU+VT6Uv
        pokERHAcyi96SBNT31sZ0lMwDMXLh8QFkghrbRH7FAwxe6ZwKn2y6ZNbSQcl6SCebTs+lo
        ZFxS8lxoFmfX0EqH6nOLITRX0SWmPKg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-d4YwJTFnNqqCG7TfcJcnDQ-1; Tue, 01 Jun 2021 12:15:41 -0400
X-MC-Unique: d4YwJTFnNqqCG7TfcJcnDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9144F802690;
        Tue,  1 Jun 2021 16:15:40 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-153.ams2.redhat.com [10.36.113.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8C38369A;
        Tue,  1 Jun 2021 16:15:35 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH] s390x: unify header guards
Date:   Tue,  1 Jun 2021 18:15:25 +0200
Message-Id: <20210601161525.462315-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's unify the header guards to _ASM_S390X_FILE_H_ respectively
_S390X_FILE_H_. This makes it more obvious what the file is
about, and avoids possible name space collisions.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---

Only did s390x for now; the other archs seem to be inconsistent in
places as well, and I can also try to tackle them if it makes sense.

---
 lib/s390x/asm/bitops.h       | 4 ++--
 lib/s390x/asm/cpacf.h        | 6 +++---
 lib/s390x/asm/interrupt.h    | 4 ++--
 lib/s390x/asm/io.h           | 4 ++--
 lib/s390x/asm/mem.h          | 4 ++--
 lib/s390x/asm/memory_areas.h | 4 ++--
 lib/s390x/asm/page.h         | 4 ++--
 lib/s390x/asm/pgtable.h      | 6 +++---
 lib/s390x/asm/sigp.h         | 6 +++---
 lib/s390x/asm/spinlock.h     | 4 ++--
 lib/s390x/asm/stack.h        | 4 ++--
 lib/s390x/asm/time.h         | 4 ++--
 lib/s390x/asm/uv.h           | 4 ++--
 lib/s390x/css.h              | 4 ++--
 lib/s390x/interrupt.h        | 6 +++---
 lib/s390x/mmu.h              | 6 +++---
 lib/s390x/sclp.h             | 6 +++---
 lib/s390x/sie.h              | 6 +++---
 lib/s390x/smp.h              | 4 ++--
 lib/s390x/uv.h               | 6 +++---
 lib/s390x/vm.h               | 6 +++---
 s390x/sthyi.h                | 4 ++--
 22 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
index 792881ec3249..61cd38fd36b7 100644
--- a/lib/s390x/asm/bitops.h
+++ b/lib/s390x/asm/bitops.h
@@ -8,8 +8,8 @@
  *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
  *
  */
-#ifndef _ASMS390X_BITOPS_H_
-#define _ASMS390X_BITOPS_H_
+#ifndef _ASM_S390X_BITOPS_H_
+#define _ASM_S390X_BITOPS_H_
 
 #ifndef _BITOPS_H_
 #error only <bitops.h> can be included directly
diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
index 805fcf1a2d71..8e9b8d754c92 100644
--- a/lib/s390x/asm/cpacf.h
+++ b/lib/s390x/asm/cpacf.h
@@ -8,8 +8,8 @@
  *	      Harald Freudenberger (freude@de.ibm.com)
  *	      Martin Schwidefsky <schwidefsky@de.ibm.com>
  */
-#ifndef _ASM_S390_CPACF_H
-#define _ASM_S390_CPACF_H
+#ifndef _ASM_S390X_CPACF_H_
+#define _ASM_S390X_CPACF_H_
 
 #include <asm/facility.h>
 #include <linux/compiler.h>
@@ -471,4 +471,4 @@ static inline void cpacf_pckmo(long func, void *param)
 		: "cc", "memory");
 }
 
-#endif	/* _ASM_S390_CPACF_H */
+#endif	/* _ASM_S390X_CPACF_H_ */
diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 31e4766d23d5..c095a76f1e7d 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -5,8 +5,8 @@
  * Authors:
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASMS390X_IRQ_H_
-#define _ASMS390X_IRQ_H_
+#ifndef _ASM_S390X_IRQ_H_
+#define _ASM_S390X_IRQ_H_
 #include <asm/arch_def.h>
 
 #define EXT_IRQ_EMERGENCY_SIG	0x1201
diff --git a/lib/s390x/asm/io.h b/lib/s390x/asm/io.h
index 1dc6283b641f..8b602ca70075 100644
--- a/lib/s390x/asm/io.h
+++ b/lib/s390x/asm/io.h
@@ -6,8 +6,8 @@
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASMS390X_IO_H_
-#define _ASMS390X_IO_H_
+#ifndef _ASM_S390X_IO_H_
+#define _ASM_S390X_IO_H_
 
 #define __iomem
 
diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 281390ebd816..082655759d54 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -5,8 +5,8 @@
  * Copyright IBM Corp. 2018
  * Author(s): Janosch Frank <frankja@de.ibm.com>
  */
-#ifndef _ASM_S390_MEM_H
-#define _ASM_S390_MEM_H
+#ifndef _ASM_S390X_MEM_H_
+#define _ASM_S390X_MEM_H_
 
 #define SKEY_ACC	0xf0
 #define SKEY_FP		0x08
diff --git a/lib/s390x/asm/memory_areas.h b/lib/s390x/asm/memory_areas.h
index 827bfb356007..c368bbb5dc5e 100644
--- a/lib/s390x/asm/memory_areas.h
+++ b/lib/s390x/asm/memory_areas.h
@@ -1,5 +1,5 @@
-#ifndef _ASMS390X_MEMORY_AREAS_H_
-#define _ASMS390X_MEMORY_AREAS_H_
+#ifndef _ASM_S390X_MEMORY_AREAS_H_
+#define _ASM_S390X_MEMORY_AREAS_H_
 
 #define AREA_NORMAL_PFN (1 << 19)
 #define AREA_NORMAL_NUMBER 0
diff --git a/lib/s390x/asm/page.h b/lib/s390x/asm/page.h
index f130f936c5da..c22c089c13e4 100644
--- a/lib/s390x/asm/page.h
+++ b/lib/s390x/asm/page.h
@@ -6,8 +6,8 @@
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASMS390X_PAGE_H_
-#define _ASMS390X_PAGE_H_
+#ifndef _ASM_S390X_PAGE_H_
+#define _ASM_S390X_PAGE_H_
 
 #include <asm-generic/page.h>
 
diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index 277f34801460..210d6ab398e2 100644
--- a/lib/s390x/asm/pgtable.h
+++ b/lib/s390x/asm/pgtable.h
@@ -7,8 +7,8 @@
  * Authors:
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASMS390X_PGTABLE_H_
-#define _ASMS390X_PGTABLE_H_
+#ifndef _ASM_S390X_PGTABLE_H_
+#define _ASM_S390X_PGTABLE_H_
 
 #include <asm/page.h>
 #include <alloc_page.h>
@@ -219,4 +219,4 @@ static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
 
 void configure_dat(int enable);
 
-#endif /* _ASMS390X_PGTABLE_H_ */
+#endif /* _ASM_S390X_PGTABLE_H_ */
diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index 00844d26d15a..b3bf7e9cb50c 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -5,8 +5,8 @@
  * Copied from the Linux kernel file arch/s390/include/asm/sigp.h
  */
 
-#ifndef ASM_S390X_SIGP_H
-#define ASM_S390X_SIGP_H
+#ifndef _ASM_S390X_SIGP_H_
+#define _ASM_S390X_SIGP_H_
 
 /* SIGP order codes */
 #define SIGP_SENSE			1
@@ -73,4 +73,4 @@ static inline int sigp_retry(uint16_t addr, uint8_t order, unsigned long parm,
 }
 
 #endif /* __ASSEMBLER__ */
-#endif /* ASM_S390X_SIGP_H */
+#endif /* _ASM_S390X_SIGP_H_ */
diff --git a/lib/s390x/asm/spinlock.h b/lib/s390x/asm/spinlock.h
index 677d2cd6e287..ca9bf8616749 100644
--- a/lib/s390x/asm/spinlock.h
+++ b/lib/s390x/asm/spinlock.h
@@ -6,8 +6,8 @@
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef __ASMS390X_SPINLOCK_H
-#define __ASMS390X_SPINLOCK_H
+#ifndef _ASM_S390X_SPINLOCK_H_
+#define _ASM_S390X_SPINLOCK_H_
 
 #include <asm-generic/spinlock.h>
 
diff --git a/lib/s390x/asm/stack.h b/lib/s390x/asm/stack.h
index 909da36dce47..b49978051d88 100644
--- a/lib/s390x/asm/stack.h
+++ b/lib/s390x/asm/stack.h
@@ -6,8 +6,8 @@
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASMS390X_STACK_H_
-#define _ASMS390X_STACK_H_
+#ifndef _ASM_S390X_STACK_H_
+#define _ASM_S390X_STACK_H_
 
 #ifndef _STACK_H_
 #error Do not directly include <asm/stack.h>. Just use <stack.h>.
diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 0d67f7231992..72a43228d73d 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -8,8 +8,8 @@
  * Copied from the s390/intercept test by:
  *  Pierre Morel <pmorel@linux.ibm.com>
  */
-#ifndef ASM_S390X_TIME_H
-#define ASM_S390X_TIME_H
+#ifndef _ASM_S390X_TIME_H_
+#define _ASM_S390X_TIME_H_
 
 #define STCK_SHIFT_US	(63 - 51)
 #define STCK_MAX	((1UL << 52) - 1)
diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index b22cbaa87109..12c4fdcce669 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -9,8 +9,8 @@
  * This code is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2.
  */
-#ifndef ASM_S390X_UV_H
-#define ASM_S390X_UV_H
+#ifndef _ASM_S390X_UV_H_
+#define _ASM_S390X_UV_H_
 
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 7e3d2613402e..d644971fb2b7 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -6,8 +6,8 @@
  * Author: Pierre Morel <pmorel@linux.ibm.com>
  */
 
-#ifndef CSS_H
-#define CSS_H
+#ifndef _S390X_CSS_H_
+#define _S390X_CSS_H_
 
 #define lowcore_ptr ((struct lowcore *)0x0)
 
diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
index 1973d267c2f1..48d90cec1f23 100644
--- a/lib/s390x/interrupt.h
+++ b/lib/s390x/interrupt.h
@@ -1,8 +1,8 @@
-#ifndef INTERRUPT_H
-#define INTERRUPT_H
+#ifndef _S390X_INTERRUPT_H_
+#define _S390X_INTERRUPT_H_
 #include <asm/interrupt.h>
 
 int register_io_int_func(void (*f)(void));
 int unregister_io_int_func(void (*f)(void));
 
-#endif /* INTERRUPT_H */
+#endif /* _S390X_INTERRUPT_H_ */
diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index 603f289e8e00..328a25513aae 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -7,12 +7,12 @@
  * Authors:
  *	Janosch Frank <frankja@de.ibm.com>
  */
-#ifndef _ASMS390X_MMU_H_
-#define _ASMS390X_MMU_H_
+#ifndef _S390X_MMU_H_
+#define _S390X_MMU_H_
 
 void protect_page(void *vaddr, unsigned long prot);
 void protect_range(void *start, unsigned long len, unsigned long prot);
 void unprotect_page(void *vaddr, unsigned long prot);
 void unprotect_range(void *start, unsigned long len, unsigned long prot);
 
-#endif /* _ASMS390X_MMU_H_ */
+#endif /* _S390X_MMU_H_ */
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 7abf1038f5ee..28e526e2c915 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -10,8 +10,8 @@
  * Author: Christian Borntraeger <borntraeger@de.ibm.com>
  */
 
-#ifndef SCLP_H
-#define SCLP_H
+#ifndef _S390X_SCLP_H_
+#define _S390X_SCLP_H_
 
 #define SCLP_CMD_CODE_MASK                      0xffff00ff
 
@@ -329,4 +329,4 @@ void sclp_memory_setup(void);
 uint64_t get_ram_size(void);
 uint64_t get_max_ram_size(void);
 
-#endif /* SCLP_H */
+#endif /* _S390X_SCLP_H_ */
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 518613baf1fa..db30d6164ab6 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifndef SIE_H
-#define SIE_H
+#ifndef _S390X_SIE_H_
+#define _S390X_SIE_H_
 
 #define CPUSTAT_STOPPED    0x80000000
 #define CPUSTAT_WAIT       0x10000000
@@ -195,4 +195,4 @@ extern void sie_entry(void);
 extern void sie_exit(void);
 extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
 
-#endif /* SIE_H */
+#endif /* _S390X_SIE_H_ */
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index 67ff16ca3c52..d99f9fc6cced 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -7,8 +7,8 @@
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
  */
-#ifndef SMP_H
-#define SMP_H
+#ifndef _S390_SMP_H_
+#define _S390_SMP_H_
 
 #include <asm/arch_def.h>
 
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 42608a967a03..96257851b1d4 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifndef UV_H
-#define UV_H
+#ifndef _S390X_UV_H_
+#define _S390X_UV_H_
 
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
 bool uv_query_test_call(unsigned int nr);
 int uv_setup(void);
 
-#endif /* UV_H */
+#endif /* _S390X_UV_H_ */
diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
index 16722760cb46..7abba0ccae3d 100644
--- a/lib/s390x/vm.h
+++ b/lib/s390x/vm.h
@@ -5,9 +5,9 @@
  * Copyright (c) 2020 Red Hat Inc
  */
 
-#ifndef S390X_VM_H
-#define S390X_VM_H
+#ifndef _S390X_VM_H_
+#define _S390X_VM_H_
 
 bool vm_is_tcg(void);
 
-#endif  /* S390X_VM_H */
+#endif  /* _S390X_VM_H_ */
diff --git a/s390x/sthyi.h b/s390x/sthyi.h
index bbd74c6197c3..eb92fdd2f2b2 100644
--- a/s390x/sthyi.h
+++ b/s390x/sthyi.h
@@ -7,8 +7,8 @@
  * Authors:
  *    Janosch Frank <frankja@linux.vnet.ibm.com>
  */
-#ifndef _STHYI_H_
-#define _STHYI_H_
+#ifndef _S390X_STHYI_H_
+#define _S390X_STHYI_H_
 
 #include <stdint.h>
 
-- 
2.31.1

