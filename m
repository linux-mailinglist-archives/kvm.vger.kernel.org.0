Return-Path: <kvm+bounces-59535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74087BBEE86
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 20:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 479A5189B53F
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 18:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245E02DCF46;
	Mon,  6 Oct 2025 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5LGxLsV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C962376EB;
	Mon,  6 Oct 2025 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774750; cv=none; b=RQfbPDtjbn/UDIRLUGsEzwYJ1g9Wms8Bds78b9HNZWD/RQSRQ0tUs92siFxWjIMw9u2qckfrFYV4eDOfCpPhVSXX1Xeb6CNPDvuIHd/gS9h/ssNRD758TUX3vV/nAiQQEr3JNzYae+kXAjIIyY36KHCTzllVBoEsV1hRMQ8XKpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774750; c=relaxed/simple;
	bh=o0BM9Rulk2fLONymVwALWm16NrAkLNqYnt/EXRkq9nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JdAFu8TJAwO57apLfrMtfJ5j24lXyrKewY2CcfQsyPHq8v1RVC80gBSaYR8LbQAWN2J9fXwtd97/+IEZ8/GpCMW6phhH+Q6eLjOdwCCWpDFwD2BtmC+MPuzvyLhzXuOuRidCJ2m5fUSlVFv9lSsDQJkaltv7SUFhWh4vV9OZvNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5LGxLsV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA33C4CEFE;
	Mon,  6 Oct 2025 18:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774749;
	bh=o0BM9Rulk2fLONymVwALWm16NrAkLNqYnt/EXRkq9nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5LGxLsVscglG0g+KjaUbodNN4mFIj+Zx0Du1U+vT28nno1qK1KCcwIeHDHC6/OnR
	 YFJlwm4wts27HsTQqFPIA0iqIUoOyLZesaQ/Z9X3QR1Pzo/SGjfw2Y6GpLvmWP5Mzg
	 9h2uK6F6Wj4mwU3jZA+QWnEkZ1lUu2+6h8at9YbOjUksv1E9nBJ7zU6IugaU6Q2VEg
	 ghv73kG6b4ljZbCPSeDzcYByyuq67mNlO2UbW1m8s+ieUI6eWUe95jRfZ3cTJNFS/+
	 2c8tPtQqpTj28TuweG9CLVnvxWZAwk+cRDsNtG0NMGTWfoR1UxPdTyaoMXoB9pkxeK
	 sjHJyn6lAbUhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] perf/x86/intel: Add ICL_FIXED_0_ADAPTIVE bit into INTEL_FIXED_BITS_MASK
Date: Mon,  6 Oct 2025 14:17:40 -0400
Message-ID: <20251006181835.1919496-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 2676dbf9f4fb7f6739d1207c0f1deaf63124642a ]

ICL_FIXED_0_ADAPTIVE is missed to be added into INTEL_FIXED_BITS_MASK,
add it.

With help of this new INTEL_FIXED_BITS_MASK, intel_pmu_enable_fixed() can
be optimized. The old fixed counter control bits can be unconditionally
cleared with INTEL_FIXED_BITS_MASK and then set new control bits base on
new configuration.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Link: https://lore.kernel.org/r/20250820023032.17128-7-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should definitely be backported to stable kernel trees.

## Extensive Analysis

### Nature of the Bug

This commit fixes a **real and significant bug** in the Intel PMU
(Performance Monitoring Unit) fixed counter handling. The bug has
existed since kernel v6.5 when `INTEL_FIXED_BITS_MASK` was introduced in
commit 10d95a317ec12 (May 2023).

### Technical Details of the Bug

**In arch/x86/include/asm/perf_event.h:18-35:**

The original `INTEL_FIXED_BITS_MASK` was defined as `0xFULL` (binary
1111), covering only bits 0-3:
```c
-#define INTEL_FIXED_BITS_MASK                          0xFULL
```

However, the mask was missing `ICL_FIXED_0_ADAPTIVE` (bit 32), which has
existed since 2019 for Ice Lake adaptive PEBS v4 support (commit
c22497f5838c2). The fix correctly includes all relevant bits:
```c
+#define INTEL_FIXED_BITS_MASK                                  \
+       (INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER |            \
+        INTEL_FIXED_0_ANYTHREAD | INTEL_FIXED_0_ENABLE_PMI |   \
+        ICL_FIXED_0_ADAPTIVE)
```

**In arch/x86/events/intel/core.c:2844-2896:**

The bug manifests in `intel_pmu_enable_fixed()` at lines 2888-2895. When
reconfiguring a fixed counter:

**Before the fix:**
- Line 2888 creates `mask` with only bits 0-3
- Lines 2890-2893 conditionally add `ICL_FIXED_0_ADAPTIVE` to both
  `bits` and `mask` only if PEBS is enabled
- Line 2895 clears bits using the incomplete mask
- **Problem:** If a counter previously had `ICL_FIXED_0_ADAPTIVE` set
  but the new configuration doesn't need it, the bit won't be cleared
  because it's not in the mask

**After the fix:**
- The mask always includes `ICL_FIXED_0_ADAPTIVE`
- Line 2890 unconditionally clears all relevant bits (including
  `ICL_FIXED_0_ADAPTIVE`)
- Lines 2890-2891 set `ICL_FIXED_0_ADAPTIVE` only when needed
- The code is cleaner and bug-free

### Impact Analysis

1. **Affected Hardware:** Intel Ice Lake (ICL) and newer processors with
   adaptive PEBS support

2. **Symptom:** The `ICL_FIXED_0_ADAPTIVE` bit can remain incorrectly
   set after reconfiguring performance counters, causing:
   - Incorrect PMU behavior
   - Adaptive PEBS being enabled when it should be disabled
   - Performance monitoring data corruption

3. **Severity:** This bug was explicitly identified as **"Bug #3"** in
   KVM commit 9e985cbf2942a (March 2024), which stated:
  > "Bug #3 is in perf. intel_pmu_disable_fixed() doesn't clear the
  upper bits either, i.e. leaves ICL_FIXED_0_ADAPTIVE set, and
  intel_pmu_enable_fixed() effectively doesn't clear
  ICL_FIXED_0_ADAPTIVE either. I.e. perf _always_ enables ADAPTIVE
  counters, regardless of what KVM requests."

4. **Security Context:** KVM had to **completely disable adaptive PEBS
   support** (with a Cc: stable tag) as a workaround for multiple bugs,
   including this one. The KVM commit mentioned potential security
   implications including LBR leaks.

### Why This Should Be Backported

1. ✅ **Fixes an important bug** affecting Intel processors since 2019
   (Ice Lake)
2. ✅ **Small, contained change** - only modifies a constant definition
   and simplifies existing code
3. ✅ **Low regression risk** - the change makes the mask complete and
   correct
4. ✅ **Well-reviewed and tested** - Reviewed-by: Kan Liang, Tested-by:
   Yi Lai (both from Intel)
5. ✅ **Addresses known issue** - this was explicitly identified in a
   previous security-related commit
6. ✅ **Affects both enable and disable paths** - also fixes
   `intel_pmu_disable_fixed()` at line 2562 which uses the same mask
7. ✅ **No architectural changes** - pure bug fix
8. ✅ **Stable since v6.5** - applies cleanly to all kernels since the
   mask was introduced

### Dependencies

This fix requires that `INTEL_FIXED_BITS_MASK` exists, which was
introduced in kernel v6.5. The fix should be backported to all stable
trees from **v6.5 onwards**.

### Conclusion

This is a textbook example of a commit suitable for stable backporting:
it fixes a real bug with clear symptoms, is small and low-risk, and has
been properly reviewed and tested. The fact that it addresses an issue
severe enough to warrant disabling an entire feature in KVM further
underscores its importance.

 arch/x86/events/intel/core.c      | 10 +++-------
 arch/x86/include/asm/perf_event.h |  6 +++++-
 arch/x86/kvm/pmu.h                |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c2fb729c270ec..af47d266f8064 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2845,8 +2845,8 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	u64 mask, bits = 0;
 	int idx = hwc->idx;
+	u64 bits = 0;
 
 	if (is_topdown_idx(idx)) {
 		struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
@@ -2885,14 +2885,10 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 
 	idx -= INTEL_PMC_IDX_FIXED;
 	bits = intel_fixed_bits_by_idx(idx, bits);
-	mask = intel_fixed_bits_by_idx(idx, INTEL_FIXED_BITS_MASK);
-
-	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip) {
+	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip)
 		bits |= intel_fixed_bits_by_idx(idx, ICL_FIXED_0_ADAPTIVE);
-		mask |= intel_fixed_bits_by_idx(idx, ICL_FIXED_0_ADAPTIVE);
-	}
 
-	cpuc->fixed_ctrl_val &= ~mask;
+	cpuc->fixed_ctrl_val &= ~intel_fixed_bits_by_idx(idx, INTEL_FIXED_BITS_MASK);
 	cpuc->fixed_ctrl_val |= bits;
 }
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 70d1d94aca7e6..ee943bd1595af 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -35,7 +35,6 @@
 #define ARCH_PERFMON_EVENTSEL_EQ			(1ULL << 36)
 #define ARCH_PERFMON_EVENTSEL_UMASK2			(0xFFULL << 40)
 
-#define INTEL_FIXED_BITS_MASK				0xFULL
 #define INTEL_FIXED_BITS_STRIDE			4
 #define INTEL_FIXED_0_KERNEL				(1ULL << 0)
 #define INTEL_FIXED_0_USER				(1ULL << 1)
@@ -48,6 +47,11 @@
 #define ICL_EVENTSEL_ADAPTIVE				(1ULL << 34)
 #define ICL_FIXED_0_ADAPTIVE				(1ULL << 32)
 
+#define INTEL_FIXED_BITS_MASK					\
+	(INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER |		\
+	 INTEL_FIXED_0_ANYTHREAD | INTEL_FIXED_0_ENABLE_PMI |	\
+	 ICL_FIXED_0_ADAPTIVE)
+
 #define intel_fixed_bits_by_idx(_idx, _bits)			\
 	((_bits) << ((_idx) * INTEL_FIXED_BITS_STRIDE))
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ad89d0bd60058..103604c4b33b5 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -13,7 +13,7 @@
 #define MSR_IA32_MISC_ENABLE_PMU_RO_MASK (MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |	\
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 
-/* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
+/* retrieve a fixed counter bits out of IA32_FIXED_CTR_CTRL */
 #define fixed_ctrl_field(ctrl_reg, idx) \
 	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
 
-- 
2.51.0


