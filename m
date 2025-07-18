Return-Path: <kvm+bounces-52821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 427A3B09949
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E1CC172697
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B121A23A5;
	Fri, 18 Jul 2025 01:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gTYc+9vb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA71194A60;
	Fri, 18 Jul 2025 01:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802800; cv=none; b=B1DmcvJyDY514bs7V9QrPmiPZGsvXrh0RZU4S19uwSrqLjzfmZyhSmXb1A2o2MY7UP9y/XooDjE3lbNOlXGZpJQwrLaLyZJPNMNOhdcGrn419Tlq4+J1WG+jOFMtbO/DYV3Qp8lCvPIW1RYUQDycYjjSZR5KH3RLZ612x9z8nMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802800; c=relaxed/simple;
	bh=fT3sDIHjSujlwY4VLBHqNBqr18zjKD3cM+JhfiCXGY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KoRCZEpUv1oef68UDbTXOxfMjf6Dt/jI//83iNxcESDSvbq6+nfIalt4GV6iexXqmpRRE6KZgI5xyLPdyNFla5DSEqCGKDPf4FbXOr+X4g7cdLQM/iv4TGvKYVqjyIrXJqmrmv7hHcZidxKsEETMMt+nXVlStCaOb0Lh03wKVGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gTYc+9vb; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802800; x=1784338800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fT3sDIHjSujlwY4VLBHqNBqr18zjKD3cM+JhfiCXGY0=;
  b=gTYc+9vb7hQveYmNE7Wqq9C3ckLBfyKL9e9BKjFG9X9XKb7H9yJX5YbF
   B4UIp0COFd0qAQhPGNLoIoZQ8UYPQ2HWNf4oZckBk3nwh1ATIVa2nlDN9
   c9xC7RwBODFBDC3Jnv5TB61AclWfxY11WgrRl25Aj+zeN8/p8cWxKtEiR
   MG2lDn+6ZmPIlkCEsgBJPUeIqEg2AGEarWqhnFKDUqC7tF9NC+6WmdLzz
   Xr4naZFp00LMdHzBIWXZ9nC7jcBZiqiDhnUp5sOOc14JzHTDDqUgllZ6H
   UuKFuqNs+UNIlkivHbxVhcwJWl7+l5uEvAeUsVqppdMF5lpdYpYBD3C3o
   g==;
X-CSE-ConnectionGUID: S9q+kh6wTee/2EJdla/9Bg==
X-CSE-MsgGUID: 0t/+ilgTSYq2/YBAcjkIfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54951443"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54951443"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:40:00 -0700
X-CSE-ConnectionGUID: P1XL2ch1T4aOu5bH6ZSr5g==
X-CSE-MsgGUID: 2zEQiVstS5ev8vRQIuJKUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188918351"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa001.fm.intel.com with ESMTP; 17 Jul 2025 18:39:56 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Yi Lai <yi1.lai@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v2 1/7] x86/pmu: Add helper to detect Intel overcount issues
Date: Fri, 18 Jul 2025 09:39:09 +0800
Message-Id: <20250718013915.227452-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
References: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

For Intel Atom CPUs, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows.

The detailed information can be found in the errata (section SRF7):
https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/

For the Atom platforms before Sierra Forest (including Sierra Forest),
Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
be overcounted on these certain instructions, but for Clearwater Forest
only "Instruction Retired" event is overcounted on these instructions.

So add a helper detect_inst_overcount_flags() to detect whether the
platform has the overcount issue and the later patches would relax the
precise count check by leveraging the gotten overcount flags from this
helper.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
[Rewrite comments and commit message - Dapeng]
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 lib/x86/processor.h | 27 ++++++++++++++++++++++++++
 x86/pmu.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 62f3d578..937f75e4 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -1188,4 +1188,31 @@ static inline bool is_lam_u57_enabled(void)
 	return !!(read_cr3() & X86_CR3_LAM_U57);
 }
 
+/* Copy from kernel arch/x86/lib/cpu.c */
+static inline u32 x86_family(u32 sig)
+{
+	u32 x86;
+
+	x86 = (sig >> 8) & 0xf;
+
+	if (x86 == 0xf)
+		x86 += (sig >> 20) & 0xff;
+
+	return x86;
+}
+
+static inline u32 x86_model(u32 sig)
+{
+	u32 fam, model;
+
+	fam = x86_family(sig);
+
+	model = (sig >> 4) & 0xf;
+
+	if (fam >= 0x6)
+		model += ((sig >> 16) & 0xf) << 4;
+
+	return model;
+}
+
 #endif
diff --git a/x86/pmu.c b/x86/pmu.c
index a6b0cfcc..87365aff 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -159,6 +159,14 @@ static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 static unsigned int fixed_counters_num;
 
+/*
+ * Flags for Intel "Instruction Retired" and "Branch Instruction Retired"
+ * overcount flaws.
+ */
+#define INST_RETIRED_OVERCOUNT BIT(0)
+#define BR_RETIRED_OVERCOUNT   BIT(1)
+static u32 intel_inst_overcount_flags;
+
 static int has_ibpb(void)
 {
 	return this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
@@ -959,6 +967,43 @@ static void check_invalid_rdpmc_gp(void)
 	       "Expected #GP on RDPMC(64)");
 }
 
+/*
+ * For Intel Atom CPUs, the PMU events "Instruction Retired" or
+ * "Branch Instruction Retired" may be overcounted for some certain
+ * instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
+ * and complex SGX/SMX/CSTATE instructions/flows.
+ *
+ * The detailed information can be found in the errata (section SRF7):
+ * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
+ *
+ * For the Atom platforms before Sierra Forest (including Sierra Forest),
+ * Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
+ * be overcounted on these certain instructions, but for Clearwater Forest
+ * only "Instruction Retired" event is overcounted on these instructions.
+ */
+static u32 detect_inst_overcount_flags(void)
+{
+	u32 flags = 0;
+	struct cpuid c = cpuid(1);
+
+	if (x86_family(c.a) == 0x6) {
+		switch (x86_model(c.a)) {
+		case 0xDD: /* Clearwater Forest */
+			flags = INST_RETIRED_OVERCOUNT;
+			break;
+
+		case 0xAF: /* Sierra Forest */
+		case 0x4D: /* Avaton, Rangely */
+		case 0x5F: /* Denverton */
+		case 0x86: /* Jacobsville */
+			flags = INST_RETIRED_OVERCOUNT | BR_RETIRED_OVERCOUNT;
+			break;
+		}
+	}
+
+	return flags;
+}
+
 int main(int ac, char **av)
 {
 	int instruction_idx;
@@ -985,6 +1030,8 @@ int main(int ac, char **av)
 		branch_idx = INTEL_BRANCHES_IDX;
 		branch_miss_idx = INTEL_BRANCH_MISS_IDX;
 
+		intel_inst_overcount_flags = detect_inst_overcount_flags();
+
 		/*
 		 * For legacy Intel CPUS without clflush/clflushopt support,
 		 * there is no way to force to trigger a LLC miss, thus set
-- 
2.34.1


