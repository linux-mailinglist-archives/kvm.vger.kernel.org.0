Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6C53A1789
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhFIOjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238031AbhFIOjh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c7bbEH34P78p2zCbMRra3JRzBpKWeWp/UGk63O1IjrQ=;
        b=EPAvLheCKrqMBvDtIJcZUh3iN++qLuqH5BzAhRdPSwwJh7pFXNLxNK+IOL8WcOH0BaFPEd
        wmqSvM1w60xCMG1UVwc7cbot0dFLV5dFesqezRKbWcE/C0us80x5W5r+yMkvsYHYlgMk3Y
        RSEtAi01BelMWJGNsUSAaSD6kuNFhuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-QzD-039KMeqUM-y2LzK5BQ-1; Wed, 09 Jun 2021 10:37:41 -0400
X-MC-Unique: QzD-039KMeqUM-y2LzK5BQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77B42107ACF6;
        Wed,  9 Jun 2021 14:37:40 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA2D019C46;
        Wed,  9 Jun 2021 14:37:34 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH v2 6/7] s390x: unify header guards
Date:   Wed,  9 Jun 2021 16:37:11 +0200
Message-Id: <20210609143712.60933-7-cohuck@redhat.com>
In-Reply-To: <20210609143712.60933-1-cohuck@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Standardize header guards to _ASMS390X_HEADER_H_, _S390X_HEADER_H_,
and S390X_HEADER_H, respectively.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/asm/arch_def.h | 4 ++--
 lib/s390x/asm/barrier.h  | 4 ++--
 lib/s390x/asm/cpacf.h    | 6 +++---
 lib/s390x/asm/facility.h | 4 ++--
 lib/s390x/asm/float.h    | 4 ++--
 lib/s390x/asm/mem.h      | 4 ++--
 lib/s390x/asm/sigp.h     | 6 +++---
 lib/s390x/asm/spinlock.h | 4 ++--
 lib/s390x/asm/time.h     | 4 ++--
 lib/s390x/asm/uv.h       | 4 ++--
 lib/s390x/css.h          | 4 ++--
 lib/s390x/interrupt.h    | 4 ++--
 lib/s390x/mmu.h          | 4 ++--
 lib/s390x/sclp.h         | 6 +++---
 lib/s390x/sie.h          | 6 +++---
 lib/s390x/smp.h          | 4 ++--
 lib/s390x/uv.h           | 4 ++--
 lib/s390x/vm.h           | 6 +++---
 s390x/sthyi.h            | 4 ++--
 19 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 7e2c5e623ab2..76f9e3862965 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -5,8 +5,8 @@
  * Authors:
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASM_S390X_ARCH_DEF_H_
-#define _ASM_S390X_ARCH_DEF_H_
+#ifndef _ASMS390X_ARCH_DEF_H_
+#define _ASMS390X_ARCH_DEF_H_
 
 struct stack_frame {
 	struct stack_frame *back_chain;
diff --git a/lib/s390x/asm/barrier.h b/lib/s390x/asm/barrier.h
index 8e2fd6d90034..9534f9e8fa96 100644
--- a/lib/s390x/asm/barrier.h
+++ b/lib/s390x/asm/barrier.h
@@ -6,8 +6,8 @@
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASM_S390X_BARRIER_H_
-#define _ASM_S390X_BARRIER_H_
+#ifndef _ASMS390X_BARRIER_H_
+#define _ASMS390X_BARRIER_H_
 
 #include <asm-generic/barrier.h>
 
diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
index 805fcf1a2d71..685262b0ff62 100644
--- a/lib/s390x/asm/cpacf.h
+++ b/lib/s390x/asm/cpacf.h
@@ -8,8 +8,8 @@
  *	      Harald Freudenberger (freude@de.ibm.com)
  *	      Martin Schwidefsky <schwidefsky@de.ibm.com>
  */
-#ifndef _ASM_S390_CPACF_H
-#define _ASM_S390_CPACF_H
+#ifndef _ASMS390X_CPACF_H_
+#define _ASMS390X_CPACF_H_
 
 #include <asm/facility.h>
 #include <linux/compiler.h>
@@ -471,4 +471,4 @@ static inline void cpacf_pckmo(long func, void *param)
 		: "cc", "memory");
 }
 
-#endif	/* _ASM_S390_CPACF_H */
+#endif	/* _ASMS390X_CPACF_H_ */
diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index 95d4a15fe34f..ef0fd037ed35 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -5,8 +5,8 @@
  * Authors:
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASM_S390X_FACILITY_H_
-#define _ASM_S390X_FACILITY_H_
+#ifndef _ASMS390X_FACILITY_H_
+#define _ASMS390X_FACILITY_H_
 
 #include <libcflat.h>
 #include <asm/facility.h>
diff --git a/lib/s390x/asm/float.h b/lib/s390x/asm/float.h
index 136794475849..eb752050b162 100644
--- a/lib/s390x/asm/float.h
+++ b/lib/s390x/asm/float.h
@@ -5,8 +5,8 @@
  * Authors:
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef _ASM_S390X_FLOAT_H_
-#define _ASM_S390X_FLOAT_H_
+#ifndef _ASMS390X_FLOAT_H_
+#define _ASMS390X_FLOAT_H_
 
 static inline void set_fpc(uint32_t fpc)
 {
diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 281390ebd816..1963cef7ec03 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -5,8 +5,8 @@
  * Copyright IBM Corp. 2018
  * Author(s): Janosch Frank <frankja@de.ibm.com>
  */
-#ifndef _ASM_S390_MEM_H
-#define _ASM_S390_MEM_H
+#ifndef _ASMS390X_MEM_H_
+#define _ASMS390X_MEM_H_
 
 #define SKEY_ACC	0xf0
 #define SKEY_FP		0x08
diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index 00844d26d15a..61d2c6256fed 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -5,8 +5,8 @@
  * Copied from the Linux kernel file arch/s390/include/asm/sigp.h
  */
 
-#ifndef ASM_S390X_SIGP_H
-#define ASM_S390X_SIGP_H
+#ifndef _ASMS390X_SIGP_H_
+#define _ASMS390X_SIGP_H_
 
 /* SIGP order codes */
 #define SIGP_SENSE			1
@@ -73,4 +73,4 @@ static inline int sigp_retry(uint16_t addr, uint8_t order, unsigned long parm,
 }
 
 #endif /* __ASSEMBLER__ */
-#endif /* ASM_S390X_SIGP_H */
+#endif /* _ASMS390X_SIGP_H_ */
diff --git a/lib/s390x/asm/spinlock.h b/lib/s390x/asm/spinlock.h
index 677d2cd6e287..22d4d3899569 100644
--- a/lib/s390x/asm/spinlock.h
+++ b/lib/s390x/asm/spinlock.h
@@ -6,8 +6,8 @@
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
  */
-#ifndef __ASMS390X_SPINLOCK_H
-#define __ASMS390X_SPINLOCK_H
+#ifndef _ASMS390X_SPINLOCK_H_
+#define _ASMS390X_SPINLOCK_H_
 
 #include <asm-generic/spinlock.h>
 
diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 0d67f7231992..7652a151e87a 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -8,8 +8,8 @@
  * Copied from the s390/intercept test by:
  *  Pierre Morel <pmorel@linux.ibm.com>
  */
-#ifndef ASM_S390X_TIME_H
-#define ASM_S390X_TIME_H
+#ifndef _ASMS390X_TIME_H_
+#define _ASMS390X_TIME_H_
 
 #define STCK_SHIFT_US	(63 - 51)
 #define STCK_MAX	((1UL << 52) - 1)
diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index b22cbaa87109..dc3e02dea1b4 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -9,8 +9,8 @@
  * This code is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2.
  */
-#ifndef ASM_S390X_UV_H
-#define ASM_S390X_UV_H
+#ifndef _ASMS390X_UV_H_
+#define _ASMS390X_UV_H_
 
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
index 1973d267c2f1..99fa0beee9ad 100644
--- a/lib/s390x/interrupt.h
+++ b/lib/s390x/interrupt.h
@@ -1,5 +1,5 @@
-#ifndef INTERRUPT_H
-#define INTERRUPT_H
+#ifndef _S390X_INTERRUPT_H_
+#define _S390X_INTERRUPT_H_
 #include <asm/interrupt.h>
 
 int register_io_int_func(void (*f)(void));
diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index 603f289e8e00..b995f85b839f 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -7,8 +7,8 @@
  * Authors:
  *	Janosch Frank <frankja@de.ibm.com>
  */
-#ifndef _ASMS390X_MMU_H_
-#define _ASMS390X_MMU_H_
+#ifndef _S390X_MMU_H_
+#define _S390X_MMU_H_
 
 void protect_page(void *vaddr, unsigned long prot);
 void protect_range(void *start, unsigned long len, unsigned long prot);
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
index 67ff16ca3c52..a2609f11e40b 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -7,8 +7,8 @@
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
  */
-#ifndef SMP_H
-#define SMP_H
+#ifndef _S390X_SMP_H_
+#define _S390X_SMP_H_
 
 #include <asm/arch_def.h>
 
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 42608a967a03..2b23407a2fcf 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifndef UV_H
-#define UV_H
+#ifndef _S390X_UV_H_
+#define _S390X_UV_H_
 
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
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
index bbd74c6197c3..0a47c2385dc7 100644
--- a/s390x/sthyi.h
+++ b/s390x/sthyi.h
@@ -7,8 +7,8 @@
  * Authors:
  *    Janosch Frank <frankja@linux.vnet.ibm.com>
  */
-#ifndef _STHYI_H_
-#define _STHYI_H_
+#ifndef S390X_STHYI_H
+#define S390X_STHYI_H
 
 #include <stdint.h>
 
-- 
2.31.1

