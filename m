Return-Path: <kvm+bounces-49330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68462AD7DE4
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:53:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4098A18960F6
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A4492E7628;
	Thu, 12 Jun 2025 21:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gxKuidHU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12992E3385;
	Thu, 12 Jun 2025 21:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765036; cv=none; b=ad6j2AiqlbvTiuhZEKDrMAvqamy4H9PsdXUeysf/v3aES2XMHYPYOWdYehVStF2Rb2DTKxsVuBZDd8YAkhc7LJ36zJ/bmMWjMfW7WHq1WCjb0nVe1nk1PG61ey8VTJTHi/00nFQpavvIVeR4F8BkC8jlW6qVm6UnlVAKIl6e+4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765036; c=relaxed/simple;
	bh=A1gwyln+xuisMeyo3d8GVwsGZcGvqUSnNcXq3phIvbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GERbsfmccEApbbjLRWjnGpNVhjPnOqQyyOO0ifpDng0VZF12xU3uaC0eK35wvLAgqX6o0XWgSRmT3kVlhj/POGNT/6rOs1xSkQ/1tOapCHG51XAFvOx5jE9guQTu9e5mVoLXnkZdRO5ZiskcRIYN5JliYmcTdprhZWJ8PKRDDRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gxKuidHU; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765035; x=1781301035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A1gwyln+xuisMeyo3d8GVwsGZcGvqUSnNcXq3phIvbc=;
  b=gxKuidHUdOTSfMz2S65w/oXMYlLb5HdRqt9m9zmZ9SC23VcA5AVNU00R
   I2DSiZHKP9fBtLd6teerkVpFXhTbDTXWfLggApXI+Gt1upH0wnp5WWcq1
   eSAAM3eW8v1c7j1qYFN9NJfqZ+TPvBAdaXPdwDytbWgL9YLjdqYL8hQly
   AzAUOPBiKAkzR4qdpNlMuhOjjJQjfHbe+VmPmL6BvqxsuKbIfBWCo6laY
   qr5+DlrxHE0lHsIxebyikq51q/RXwSifTxAbVH1RiwCByKYMcCns015Ko
   8PUd6kPty60sNivzxtVYmWH0zIWRXPmx+dQfnKp5xM+J7rKnz3L46DRjs
   g==;
X-CSE-ConnectionGUID: 2z/2VB+uQ4yCeNFaSD2PAQ==
X-CSE-MsgGUID: VK81YY4hQg+zDb/vS0K3sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065383"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065383"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:33 -0700
X-CSE-ConnectionGUID: Zr0PGwJFTbWaJrG7wtXcPQ==
X-CSE-MsgGUID: +oYlPMCrQuynSuqf0d5mLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881984"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:32 -0700
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
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v7 07/10] x86/nmi: Prepare for the new NMI-source vector encoding
Date: Thu, 12 Jun 2025 14:48:46 -0700
Message-ID: <20250612214849.3950094-8-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
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
v7: No change.

v6: Remove a redundant else statement. (PeterZ)

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
index 23d86c9750b9..32cdd81e5e45 100644
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
+
+	return APIC_DM_FIXED | vector;
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
index 921c1c783bc1..317d585ff3d0 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -518,14 +518,7 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
 
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
index debc94e2dc16..5c0d2de2986e 100644
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


