Return-Path: <kvm+bounces-45683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2466FAAD2B6
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFAA21C038D8
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305BD1C84CF;
	Wed,  7 May 2025 01:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VypvhEpx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2259718C004;
	Wed,  7 May 2025 01:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580890; cv=none; b=JOS3p34UwN8LytHlKoR4r81aRFjJ6Irz+1IKPnuUMFQIOoC2wW/xBFH4o2OWExzWvhXEDHFZyA8NMLpCdyehiZtxo54c02r9Dhw3UAZGGPuYRh27mo/gYfj0wtEa11FBb9jIiffEnR1vcu5SpOaLJoezekjQg2R+jZ3XfsAwmHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580890; c=relaxed/simple;
	bh=OfBgI9CkNGv1w958qRygQ8/xJI/SuERkts1Frocyh2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOZQttorVOhD7/3GoRnOaaIHKvORd8gXAOdNh42vHIdJM8pItnSgbR06uoXtmXbJ7UZFIrLungsE/CiYn3QD+IQXdMnYUclLXutYHkQOllft5xpkujF4UrI/KqJkfrfEp/DEdfosOeeN4tI6OHB+7IQeo5k/X3ix76IO50ZTQyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VypvhEpx; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746580888; x=1778116888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OfBgI9CkNGv1w958qRygQ8/xJI/SuERkts1Frocyh2M=;
  b=VypvhEpxGRnZb/RzYenk6/jSUhjbFTxd9exF1c78oIGQTDzoo2QbJp2g
   bo7GBh/r7s6kVEsHuln2iPBRUFo4vxYzUBPkfwFpEJawd0WNrcg1LhziB
   +t7+BO8mBzuMCb9pC4PAa1+7i33FwVuYg6TXVMDNm0gpkG0y5pwkxc+7q
   oVwyZVOvVGlzPIE3e/iN4d5OorqfamE0+CgrvUqRHTJEFU4KDIatHzNh7
   M0jooeouEL7HxsTnvw6z5NsMh2W/kTv0fNdyeMtekSfuwnnz8m8ULTLpe
   MKVCyRrWMh1LUuJlBAlGI/yrwpZjV8kAr9cgbkdDOFyHenim74C945+IT
   g==;
X-CSE-ConnectionGUID: WnivI6tiSbaHT2Gji5ag3w==
X-CSE-MsgGUID: ls7Qs+waTJWZ/c0rALoDlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47383988"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47383988"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:21:26 -0700
X-CSE-ConnectionGUID: TpQ4dlZlTNq5Fo1yomQlhA==
X-CSE-MsgGUID: MJoPH8AYQa6dsvF/X8d0Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136808754"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa009.fm.intel.com with ESMTP; 06 May 2025 18:21:25 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v5 6/9] x86/nmi: Prepare for the new NMI-source vector encoding
Date: Tue,  6 May 2025 18:21:42 -0700
Message-ID: <20250507012145.2998143-7-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250507012145.2998143-1-sohil.mehta@intel.com>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using the send_IPI_* APIC calls, callers typically use NMI vector
0x2 to trigger NMIs. The APIC APIs convert the NMI vector to the NMI
delivery mode, which is eventually used to program the APIC.

Before FRED, the hardware would ignore the vector used with NMI delivery
mode. However, with NMI-source reporting, the vector information is
relayed to the destination CPU, which sets the corresponding bit in the
NMI-source bitmap. Unfortunately, the kernel now needs to maintain a new
set of NMI vectors and differentiate them from the IDT vectors.

Instead of creating a parallel set of send_NMI_* APIs to handle
NMI-source vectors, enhance the existing send_IPI_* APIs with a new
encoding scheme to handle the NMI delivery mode along with the
NMI-source vector.

NMI-source vectors would be encoded as:
    APIC_DM_NMI (0x400) | NMI_SOURCE_VECTOR (0x1-0xF)

Also, introduce a helper to prepare the ICR value with the encoded
delivery mode and vector. Update the guest paravirtual APIC code to use
the new helper as well.

While at it, rename APIC_DM_FIXED_MASK to the more appropriate
APIC_DM_MASK.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v5: Use a simiplified encoding scheme for NMI-source vectors.
---
 arch/x86/include/asm/apic.h         | 30 +++++++++++++++++++++++++++++
 arch/x86/include/asm/apicdef.h      |  2 +-
 arch/x86/kernel/apic/ipi.c          |  4 ++--
 arch/x86/kernel/apic/local.h        | 24 ++++++++++++-----------
 arch/x86/kernel/kvm.c               |  9 +--------
 drivers/thermal/intel/therm_throt.c |  2 +-
 6 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c903d358405d..11a3f88518fa 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -470,6 +470,36 @@ static __always_inline bool apic_id_valid(u32 apic_id)
 	return apic_id <= apic->max_apic_id;
 }
 
+/*
+ * Prepare the delivery mode and vector for the ICR.
+ *
+ * NMI-source vectors have the NMI delivery mode encoded within them to
+ * differentiate them from the IDT vectors. IDT vector 0x2 (NMI_VECTOR)
+ * is treated as an NMI request but without any NMI-source information.
+ */
+static inline u16 __prepare_ICR_DM_vector(u16 dm_vector)
+{
+	u16 vector = dm_vector & APIC_VECTOR_MASK;
+	u16 dm = dm_vector & APIC_DM_MASK;
+
+	if (dm == APIC_DM_NMI) {
+		/*
+		 * Pre-FRED, the actual vector is ignored for NMIs, but
+		 * zero it if NMI-source reporting is not supported to
+		 * avoid breakage on misbehaving hardware or hypervisors.
+		 */
+		if (!cpu_feature_enabled(X86_FEATURE_NMI_SOURCE))
+			vector = 0;
+
+		return dm | vector;
+	}
+
+	if (vector == NMI_VECTOR)
+		return APIC_DM_NMI;
+	else
+		return APIC_DM_FIXED | vector;
+}
+
 #else /* CONFIG_X86_LOCAL_APIC */
 
 static inline u32 apic_read(u32 reg) { return 0; }
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 094106b6a538..3fb8fa73f6aa 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -87,8 +87,8 @@
 #define		APIC_ICR_BUSY		0x01000
 #define		APIC_DEST_LOGICAL	0x00800
 #define		APIC_DEST_PHYSICAL	0x00000
+#define		APIC_DM_MASK		0x00700
 #define		APIC_DM_FIXED		0x00000
-#define		APIC_DM_FIXED_MASK	0x00700
 #define		APIC_DM_LOWEST		0x00100
 #define		APIC_DM_SMI		0x00200
 #define		APIC_DM_REMRD		0x00300
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 98a57cb4aa86..4e8bc42f3bd5 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -158,7 +158,7 @@ static void __default_send_IPI_shortcut(unsigned int shortcut, int vector)
 	 * issues where otherwise the system hangs when the panic CPU tries
 	 * to stop the others before launching the kdump kernel.
 	 */
-	if (unlikely(vector == NMI_VECTOR))
+	if (unlikely(is_nmi_vector(vector)))
 		apic_mem_wait_icr_idle_timeout();
 	else
 		apic_mem_wait_icr_idle();
@@ -175,7 +175,7 @@ void __default_send_IPI_dest_field(unsigned int dest_mask, int vector,
 				   unsigned int dest_mode)
 {
 	/* See comment in __default_send_IPI_shortcut() */
-	if (unlikely(vector == NMI_VECTOR))
+	if (unlikely(is_nmi_vector(vector)))
 		apic_mem_wait_icr_idle_timeout();
 	else
 		apic_mem_wait_icr_idle();
diff --git a/arch/x86/kernel/apic/local.h b/arch/x86/kernel/apic/local.h
index bdcf609eb283..9a54c589a4bf 100644
--- a/arch/x86/kernel/apic/local.h
+++ b/arch/x86/kernel/apic/local.h
@@ -24,22 +24,24 @@ extern u32 x2apic_max_apicid;
 
 /* IPI */
 
+u16 __prepare_ICR_DM_vector(u16 vector);
+
 DECLARE_STATIC_KEY_FALSE(apic_use_ipi_shorthand);
 
+/* NMI-source vectors have the delivery mode encoded within them */
+static inline bool is_nmi_vector(u16 vector)
+{
+	if ((vector & APIC_DM_MASK) == APIC_DM_NMI)
+		return true;
+	if ((vector & APIC_VECTOR_MASK) == NMI_VECTOR)
+		return true;
+	return false;
+}
+
 static inline unsigned int __prepare_ICR(unsigned int shortcut, int vector,
 					 unsigned int dest)
 {
-	unsigned int icr = shortcut | dest;
-
-	switch (vector) {
-	default:
-		icr |= APIC_DM_FIXED | vector;
-		break;
-	case NMI_VECTOR:
-		icr |= APIC_DM_NMI;
-		break;
-	}
-	return icr;
+	return shortcut | dest | __prepare_ICR_DM_vector(vector);
 }
 
 void default_init_apic_ldr(void);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3be9b3342c67..aa45fe4fecd0 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -517,14 +517,7 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
 
 	local_irq_save(flags);
 
-	switch (vector) {
-	default:
-		icr = APIC_DM_FIXED | vector;
-		break;
-	case NMI_VECTOR:
-		icr = APIC_DM_NMI;
-		break;
-	}
+	icr = __prepare_ICR_DM_vector(vector);
 
 	for_each_cpu(cpu, mask) {
 		apic_id = per_cpu(x86_cpu_to_apicid, cpu);
diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index e69868e868eb..83dd53cb4fc7 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -740,7 +740,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	 * BIOS has programmed on AP based on BSP's info we saved since BIOS
 	 * is always setting the same value for all threads/cores.
 	 */
-	if ((h & APIC_DM_FIXED_MASK) != APIC_DM_FIXED)
+	if ((h & APIC_DM_MASK) != APIC_DM_FIXED)
 		apic_write(APIC_LVTTHMR, lvtthmr_init);
 
 
-- 
2.43.0


