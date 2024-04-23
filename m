Return-Path: <kvm+bounces-15697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 818028AF59E
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4AF91C23F5C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B2613E8B5;
	Tue, 23 Apr 2024 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WvqMozAW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849E213DDDE;
	Tue, 23 Apr 2024 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893804; cv=none; b=jAV+YqSO+xzbPySUgKrXk2dTVtfxNCsTQHIvRRA5sIWMbaHCupcFzTDKVT2NJAwgXnTSG6LfTxQRWm4x5DflyeCKdfydWhWW94mQOWNp8erI8dyI0CVNxtY2h+EDZM5rMqYmodKZXOZ/JdxPPKqDyG8HKWYBEdT/wooFjfIzfGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893804; c=relaxed/simple;
	bh=I+J4qe71Mhah5FbNMvTzc8voWMvbCweR1e53QS6GvLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oz6Qnjwp+IZG++dzqK4MU8imCFGltZggyuioFelSx2EC0RAq3tW4BVxrqbVmbi0z6IZ+Pg1yzGvSkAoNTKwonznIfJyEk4aKQn/yZI7+TFg85+lhvWb/VDw9fY1CTPJ7HWPjbuLr8uq5Jcm/scLa5y3t9EffLoJA0qwR6hiPuvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WvqMozAW; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893803; x=1745429803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I+J4qe71Mhah5FbNMvTzc8voWMvbCweR1e53QS6GvLE=;
  b=WvqMozAW7TV9QyEME0KyJFFp6okHvT9EHSma5WsEknIijrjQ1qNQ3npN
   KpmGaaXTCe+Eq3CT8hoHb+nccz6wst6mlviBQ3crHiqTEy6GBx6/GIq2h
   6M8CNXZ2w//l3o22LgdK8OMV/ZDYAnubeovAqrjOTDsaiiRcWBHGClHN7
   uMfP1FP0wDaBMGSo8qnElbhMEbsUGvxd+m2OWIlC7cicwfVGDvhklLXiE
   tYDdjGuIvEy/Kt8DQcDdB91ca5lelmvjE9Lwkj1gA3wkYDshFnR1pxZQF
   iPhH3sJxl7COtiQ73L9AxTG5Ow055uA8VCn4CcMRRhy9Ui3hE3bBGa6OW
   Q==;
X-CSE-ConnectionGUID: yu6poW2yQHSnfz3khlB12w==
X-CSE-MsgGUID: zvAyEgsaRd25dsNOTDZMTw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712289"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712289"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:40 -0700
X-CSE-ConnectionGUID: Cg1VolOyR2ei29+5CuuRCQ==
X-CSE-MsgGUID: CaTNUXAdQLyr7DneB791Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097366"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:38 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	jim.harris@samsung.com,
	a.manzanares@samsung.com,
	"Bjorn Helgaas" <helgaas@kernel.org>,
	guang.zeng@intel.com,
	robert.hoo.linux@gmail.com,
	oliver.sang@intel.com,
	acme@kernel.org,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3  01/12] KVM: VMX: Move posted interrupt descriptor out of vmx code
Date: Tue, 23 Apr 2024 10:41:03 -0700
Message-Id: <20240423174114.526704-2-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare native usage of posted interrupt, move PID declaration out of
VMX code such that they can be shared.

Acked-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/posted_intr.h | 88 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/posted_intr.h     | 93 +-----------------------------
 arch/x86/kvm/vmx/vmx.c             |  1 +
 arch/x86/kvm/vmx/vmx.h             |  2 +-
 4 files changed, 91 insertions(+), 93 deletions(-)
 create mode 100644 arch/x86/include/asm/posted_intr.h

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
new file mode 100644
index 000000000000..f0324c56f7af
--- /dev/null
+++ b/arch/x86/include/asm/posted_intr.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_POSTED_INTR_H
+#define _X86_POSTED_INTR_H
+
+#define POSTED_INTR_ON  0
+#define POSTED_INTR_SN  1
+
+#define PID_TABLE_ENTRY_VALID 1
+
+/* Posted-Interrupt Descriptor */
+struct pi_desc {
+	u32 pir[8];     /* Posted interrupt requested */
+	union {
+		struct {
+				/* bit 256 - Outstanding Notification */
+			u16	on	: 1,
+				/* bit 257 - Suppress Notification */
+				sn	: 1,
+				/* bit 271:258 - Reserved */
+				rsvd_1	: 14;
+				/* bit 279:272 - Notification Vector */
+			u8	nv;
+				/* bit 287:280 - Reserved */
+			u8	rsvd_2;
+				/* bit 319:288 - Notification Destination */
+			u32	ndst;
+		};
+		u64 control;
+	};
+	u32 rsvd[6];
+} __aligned(64);
+
+static inline bool pi_test_and_set_on(struct pi_desc *pi_desc)
+{
+	return test_and_set_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_and_clear_on(struct pi_desc *pi_desc)
+{
+	return test_and_clear_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_and_clear_sn(struct pi_desc *pi_desc)
+{
+	return test_and_clear_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
+{
+	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
+}
+
+static inline bool pi_is_pir_empty(struct pi_desc *pi_desc)
+{
+	return bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
+}
+
+static inline void pi_set_sn(struct pi_desc *pi_desc)
+{
+	set_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
+}
+
+static inline void pi_set_on(struct pi_desc *pi_desc)
+{
+	set_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline void pi_clear_on(struct pi_desc *pi_desc)
+{
+	clear_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline void pi_clear_sn(struct pi_desc *pi_desc)
+{
+	clear_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_on(struct pi_desc *pi_desc)
+{
+	return test_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_sn(struct pi_desc *pi_desc)
+{
+	return test_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
+}
+
+#endif /* _X86_POSTED_INTR_H */
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 26992076552e..6b2a0226257e 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -1,98 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __KVM_X86_VMX_POSTED_INTR_H
 #define __KVM_X86_VMX_POSTED_INTR_H
-
-#define POSTED_INTR_ON  0
-#define POSTED_INTR_SN  1
-
-#define PID_TABLE_ENTRY_VALID 1
-
-/* Posted-Interrupt Descriptor */
-struct pi_desc {
-	u32 pir[8];     /* Posted interrupt requested */
-	union {
-		struct {
-				/* bit 256 - Outstanding Notification */
-			u16	on	: 1,
-				/* bit 257 - Suppress Notification */
-				sn	: 1,
-				/* bit 271:258 - Reserved */
-				rsvd_1	: 14;
-				/* bit 279:272 - Notification Vector */
-			u8	nv;
-				/* bit 287:280 - Reserved */
-			u8	rsvd_2;
-				/* bit 319:288 - Notification Destination */
-			u32	ndst;
-		};
-		u64 control;
-	};
-	u32 rsvd[6];
-} __aligned(64);
-
-static inline bool pi_test_and_set_on(struct pi_desc *pi_desc)
-{
-	return test_and_set_bit(POSTED_INTR_ON,
-			(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_and_clear_on(struct pi_desc *pi_desc)
-{
-	return test_and_clear_bit(POSTED_INTR_ON,
-			(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_and_clear_sn(struct pi_desc *pi_desc)
-{
-	return test_and_clear_bit(POSTED_INTR_SN,
-			(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
-{
-	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
-}
-
-static inline bool pi_is_pir_empty(struct pi_desc *pi_desc)
-{
-	return bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
-}
-
-static inline void pi_set_sn(struct pi_desc *pi_desc)
-{
-	set_bit(POSTED_INTR_SN,
-		(unsigned long *)&pi_desc->control);
-}
-
-static inline void pi_set_on(struct pi_desc *pi_desc)
-{
-	set_bit(POSTED_INTR_ON,
-		(unsigned long *)&pi_desc->control);
-}
-
-static inline void pi_clear_on(struct pi_desc *pi_desc)
-{
-	clear_bit(POSTED_INTR_ON,
-		(unsigned long *)&pi_desc->control);
-}
-
-static inline void pi_clear_sn(struct pi_desc *pi_desc)
-{
-	clear_bit(POSTED_INTR_SN,
-		(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_on(struct pi_desc *pi_desc)
-{
-	return test_bit(POSTED_INTR_ON,
-			(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_sn(struct pi_desc *pi_desc)
-{
-	return test_bit(POSTED_INTR_SN,
-			(unsigned long *)&pi_desc->control);
-}
+#include <asm/posted_intr.h>
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37a89eda90f..d94bb069bac9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -70,6 +70,7 @@
 #include "x86.h"
 #include "smm.h"
 #include "vmx_onhyperv.h"
+#include "posted_intr.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 65786dbe7d60..e133e8077e6d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -7,10 +7,10 @@
 #include <asm/kvm.h>
 #include <asm/intel_pt.h>
 #include <asm/perf_event.h>
+#include <asm/posted_intr.h>
 
 #include "capabilities.h"
 #include "../kvm_cache_regs.h"
-#include "posted_intr.h"
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "../cpuid.h"
-- 
2.25.1


