Return-Path: <kvm+bounces-44508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3D6A9E1DC
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 11:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8E071682EB
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F398C257AD3;
	Sun, 27 Apr 2025 09:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="N3K85yLK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EE3252287;
	Sun, 27 Apr 2025 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745745697; cv=none; b=J0vwkiYbY7hLUuRj0kXqJTu2IkUzyoENdCvzMmy5Tm7b44p2dFfP6R6YSQa9IOPfgor2ropEPibmbNFhBNqKtls1W5kgB4DpAydKSN+U+v6R5qcgYxuNpni780+xMqSLRPdywHmjWEVFz4GusXc1K6Et6vCIrw9GFIPLWvDhWXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745745697; c=relaxed/simple;
	bh=Lm+SNVGc6rhMVEsF8IFoVKc30bO5oN4xscpr67pZVGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oyQt/U5RbWz5YPRz5kD1B0StCkRKnhGmdiimafIEO1v+4K+So6m9vQQo5QZjRvgejt1y7cHgVJ0Kaom+9l802qowu2vsgQBT7Dtp0kCMxS0JVFYWHPQniX2tIhUuRJh0qyPxxoSU1VuEuFBRNibXaPqkPrNfmwsXm56u4IERXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=N3K85yLK; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53R9KRRw1598826
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 27 Apr 2025 02:20:33 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53R9KRRw1598826
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745745635;
	bh=BFab8Rp62MTx7q8P2trDG04ZRF3VDtEGraetT1LpgfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3K85yLKwlIzP3hBWOoogel+7Tmd2/Z8ipeM72kJLPdHXTB85i5jLIEgMEvigriCb
	 m43z3jgS0uGjdMrSJ7X95khmPgkSrwwel64BgjCimN2UPz0kvs8o6A5wTTxe9yDECP
	 ilgfy5cFCJL93YwGivSZjlIOk9Wb6iJkqUMR3xmuXhEN/Q1gG0DJZ6TJByKdRaYya6
	 xWHIPVw4+qkpquK2NndJ+WilmRTOY4kpGo3fFShc2onXL0GamRGvxelevAajavhIdS
	 dOF0cvRHolDm9JM2NaltGpgKtSk3xpinL0VuMr2w0XwFuCVroIioMBYV6/wX2CZoAf
	 5ottV1NZ5hScA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: [PATCH v4 01/15] x86/msr: Add missing includes of <asm/msr.h>
Date: Sun, 27 Apr 2025 02:20:13 -0700
Message-ID: <20250427092027.1598740-2-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250427092027.1598740-1-xin@zytor.com>
References: <20250427092027.1598740-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For some reason, there are some TSC-related functions in the MSR
header even though there is a tsc.h header.

To facilitate the relocation of rdtsc{,_ordered}() from <asm/msr.h>
to <asm/tsc.h> and to eventually eliminate the inclusion of
<asm/msr.h> in <asm/tsc.h>, add <asm/msr.h> to the source files that
reference definitions from <asm/msr.h>.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---

Change in v4:
*) Add missing includes in a different patch (Ilpo Järvinen).
*) Add all necessary direct inclusions for msr.h (Ilpo Järvinen).

Change in v3:
* Add a problem statement to the changelog (Dave Hansen).
---
 arch/x86/events/msr.c                                         | 3 +++
 arch/x86/events/perf_event.h                                  | 1 +
 arch/x86/events/probe.c                                       | 2 ++
 arch/x86/hyperv/ivm.c                                         | 1 +
 arch/x86/include/asm/fred.h                                   | 1 +
 arch/x86/include/asm/microcode.h                              | 2 ++
 arch/x86/include/asm/mshyperv.h                               | 1 +
 arch/x86/include/asm/msr.h                                    | 1 +
 arch/x86/include/asm/suspend_32.h                             | 1 +
 arch/x86/include/asm/suspend_64.h                             | 1 +
 arch/x86/include/asm/switch_to.h                              | 2 ++
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c                     | 1 +
 arch/x86/kernel/fpu/xstate.h                                  | 1 +
 arch/x86/kernel/hpet.c                                        | 1 +
 arch/x86/kernel/process_64.c                                  | 1 +
 arch/x86/kernel/trace_clock.c                                 | 2 +-
 arch/x86/kernel/tsc_sync.c                                    | 1 +
 arch/x86/lib/kaslr.c                                          | 2 +-
 arch/x86/mm/mem_encrypt_identity.c                            | 1 +
 arch/x86/realmode/init.c                                      | 1 +
 drivers/acpi/acpi_extlog.c                                    | 1 +
 drivers/acpi/processor_perflib.c                              | 1 +
 drivers/acpi/processor_throttling.c                           | 3 ++-
 drivers/char/agp/nvidia-agp.c                                 | 1 +
 drivers/cpufreq/amd-pstate-ut.c                               | 2 ++
 drivers/crypto/ccp/sev-dev.c                                  | 1 +
 drivers/edac/amd64_edac.c                                     | 1 +
 drivers/edac/ie31200_edac.c                                   | 1 +
 drivers/edac/mce_amd.c                                        | 1 +
 drivers/hwmon/hwmon-vid.c                                     | 4 ++++
 drivers/idle/intel_idle.c                                     | 1 +
 drivers/misc/cs5535-mfgpt.c                                   | 1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                             | 4 ++++
 drivers/platform/x86/intel/ifs/core.c                         | 1 +
 drivers/platform/x86/intel/ifs/load.c                         | 1 +
 drivers/platform/x86/intel/ifs/runtest.c                      | 1 +
 drivers/platform/x86/intel/pmc/cnp.c                          | 1 +
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c   | 1 +
 drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c | 1 +
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c   | 1 +
 drivers/platform/x86/intel/turbo_max_3.c                      | 1 +
 .../platform/x86/intel/uncore-frequency/uncore-frequency.c    | 1 +
 drivers/powercap/intel_rapl_common.c                          | 1 +
 drivers/powercap/intel_rapl_msr.c                             | 1 +
 .../thermal/intel/int340x_thermal/processor_thermal_device.c  | 1 +
 drivers/thermal/intel/intel_tcc_cooling.c                     | 1 +
 drivers/thermal/intel/x86_pkg_temp_thermal.c                  | 1 +
 drivers/video/fbdev/geode/display_gx.c                        | 1 +
 drivers/video/fbdev/geode/gxfb_core.c                         | 1 +
 drivers/video/fbdev/geode/lxfb_ops.c                          | 1 +
 50 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 8970ecef87c5..c39e49cecace 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -3,6 +3,9 @@
 #include <linux/sysfs.h>
 #include <linux/nospec.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
+#include <asm/tsc.h>
+
 #include "probe.h"
 
 enum perf_msr_id {
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index a5166fa9339b..a8d4e82e3589 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -17,6 +17,7 @@
 #include <asm/fpu/xstate.h>
 #include <asm/intel_ds.h>
 #include <asm/cpu.h>
+#include <asm/msr.h>
 
 /* To enable MSR tracing please use the generic trace points. */
 
diff --git a/arch/x86/events/probe.c b/arch/x86/events/probe.c
index fda35cf25528..bb719d0d3f0b 100644
--- a/arch/x86/events/probe.c
+++ b/arch/x86/events/probe.c
@@ -2,6 +2,8 @@
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/bits.h>
+
+#include <asm/msr.h>
 #include "probe.h"
 
 static umode_t
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 1b8a2415183b..8209de792388 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -22,6 +22,7 @@
 #include <asm/realmode.h>
 #include <asm/e820/api.h>
 #include <asm/desc.h>
+#include <asm/msr.h>
 #include <uapi/asm/vmx.h>
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 2a29e5216881..12b34d5b2953 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -9,6 +9,7 @@
 #include <linux/const.h>
 
 #include <asm/asm.h>
+#include <asm/msr.h>
 #include <asm/trapnr.h>
 
 /*
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 263ea3dd0001..107a1aaa211b 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_MICROCODE_H
 #define _ASM_X86_MICROCODE_H
 
+#include <asm/msr.h>
+
 struct cpu_signature {
 	unsigned int sig;
 	unsigned int pf;
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index bab5ccfc60a7..15d00dace70f 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -8,6 +8,7 @@
 #include <linux/io.h>
 #include <asm/nospec-branch.h>
 #include <asm/paravirt.h>
+#include <asm/msr.h>
 #include <hyperv/hvhdk.h>
 
 /*
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2ccc78ebc3d7..72a9ebc99078 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -12,6 +12,7 @@
 #include <uapi/asm/msr.h>
 #include <asm/shared/msr.h>
 
+#include <linux/types.h>
 #include <linux/percpu.h>
 
 struct msr_info {
diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index d8416b3bf832..e8e5aab06255 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -9,6 +9,7 @@
 
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
+#include <asm/msr.h>
 
 /* image of the saved processor state */
 struct saved_context {
diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index 54df06687d83..b512f9665f78 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -9,6 +9,7 @@
 
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
+#include <asm/msr.h>
 
 /*
  * Image of the saved processor state, used by the low level ACPI suspend to
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 75248546403d..4f21df7af715 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -52,6 +52,8 @@ do {									\
 } while (0)
 
 #ifdef CONFIG_X86_32
+#include <asm/msr.h>
+
 static inline void refresh_sysenter_cs(struct thread_struct *thread)
 {
 	/* Only happens when SEP is enabled, no need to test "SEP"arately: */
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 2a82eb6a0376..26c354bdea07 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -25,6 +25,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/resctrl.h>
 #include <asm/perf_event.h>
+#include <asm/msr.h>
 
 #include "../../events/perf_event.h" /* For X86_CONFIG() */
 #include "internal.h"
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 5e5d35027f13..f705bd355ea2 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -5,6 +5,7 @@
 #include <asm/cpufeature.h>
 #include <asm/fpu/xstate.h>
 #include <asm/fpu/xcr.h>
+#include <asm/msr.h>
 
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(u64, xfd_state);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index cc5d12232216..c9982a7c9536 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -12,6 +12,7 @@
 #include <asm/hpet.h>
 #include <asm/time.h>
 #include <asm/mwait.h>
+#include <asm/msr.h>
 
 #undef  pr_fmt
 #define pr_fmt(fmt) "hpet: " fmt
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 24e1ccf22912..cfa9c031de91 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -57,6 +57,7 @@
 #include <asm/unistd.h>
 #include <asm/fsgsbase.h>
 #include <asm/fred.h>
+#include <asm/msr.h>
 #ifdef CONFIG_IA32_EMULATION
 /* Not included via unistd.h */
 #include <asm/unistd_32_ia32.h>
diff --git a/arch/x86/kernel/trace_clock.c b/arch/x86/kernel/trace_clock.c
index b8e7abe00b06..708d61743d15 100644
--- a/arch/x86/kernel/trace_clock.c
+++ b/arch/x86/kernel/trace_clock.c
@@ -4,7 +4,7 @@
  */
 #include <asm/trace_clock.h>
 #include <asm/barrier.h>
-#include <asm/msr.h>
+#include <asm/tsc.h>
 
 /*
  * trace_clock_x86_tsc(): A clock that is just the cycle counter.
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index f1c7a86dbf49..ec3aa340d351 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
+#include <asm/msr.h>
 #include <asm/tsc.h>
 
 struct tsc_adjust {
diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
index a58f451a7dd3..b5893928d55c 100644
--- a/arch/x86/lib/kaslr.c
+++ b/arch/x86/lib/kaslr.c
@@ -8,7 +8,7 @@
  */
 #include <asm/asm.h>
 #include <asm/kaslr.h>
-#include <asm/msr.h>
+#include <asm/tsc.h>
 #include <asm/archrandom.h>
 #include <asm/e820/api.h>
 #include <asm/shared/io.h>
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 5eecdd92da10..afda349db35b 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -44,6 +44,7 @@
 #include <asm/sections.h>
 #include <asm/coco.h>
 #include <asm/sev.h>
+#include <asm/msr.h>
 
 #include "mm_internal.h"
 
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 263787b4800c..ed5c63c0b4e5 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -9,6 +9,7 @@
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
+#include <asm/msr.h>
 #include <asm/sev.h>
 
 struct real_mode_header *real_mode_header;
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 8465822b6672..f6b9562779de 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -15,6 +15,7 @@
 #include <acpi/ghes.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
+#include <asm/msr.h>
 
 #include "apei/apei-internal.h"
 #include <ras/ras_event.h>
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 53996f1a2d80..64b8d1e19594 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -20,6 +20,7 @@
 #include <acpi/processor.h>
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
+#include <asm/msr.h>
 #endif
 
 #define ACPI_PROCESSOR_FILE_PERFORMANCE	"performance"
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 00d045e5f524..8482e9a8a7aa 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -18,9 +18,10 @@
 #include <linux/sched.h>
 #include <linux/cpufreq.h>
 #include <linux/acpi.h>
+#include <linux/uaccess.h>
 #include <acpi/processor.h>
 #include <asm/io.h>
-#include <linux/uaccess.h>
+#include <asm/asm.h>
 
 /* ignore_tpc:
  *  0 -> acpi processor driver doesn't ignore _TPC values
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index e424360fb4a1..4787391bb6b4 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -11,6 +11,7 @@
 #include <linux/page-flags.h>
 #include <linux/mm.h>
 #include <linux/jiffies.h>
+#include <asm/msr.h>
 #include "agp.h"
 
 /* NVIDIA registers */
diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index 707fa81c749f..c8d031b297d2 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -31,6 +31,8 @@
 
 #include <acpi/cppc_acpi.h>
 
+#include <asm/msr.h>
+
 #include "amd-pstate.h"
 
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index bb8a25ef5b43..ec8b37a7f40c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -33,6 +33,7 @@
 #include <asm/cacheflush.h>
 #include <asm/e820/types.h>
 #include <asm/sev.h>
+#include <asm/msr.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index db758aa900b0..622385218735 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -4,6 +4,7 @@
 #include "amd64_edac.h"
 #include <asm/amd_nb.h>
 #include <asm/amd_node.h>
+#include <asm/msr.h>
 
 static struct edac_pci_ctl_info *pci_ctl;
 
diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
index 204834149579..5ddd83dc94ba 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -52,6 +52,7 @@
 
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <asm/mce.h>
+#include <asm/msr.h>
 #include "edac_module.h"
 
 #define EDAC_MOD_STR "ie31200_edac"
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 50d74d3bf0f5..af3c12284a1e 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -3,6 +3,7 @@
 #include <linux/slab.h>
 
 #include <asm/cpu.h>
+#include <asm/msr.h>
 
 #include "mce_amd.h"
 
diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
index 6d1175a51832..2df4956296ed 100644
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -15,6 +15,10 @@
 #include <linux/kernel.h>
 #include <linux/hwmon-vid.h>
 
+#ifdef CONFIG_X86
+#include <asm/msr.h>
+#endif
+
 /*
  * Common code for decoding VID pins.
  *
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 517b28a85560..6a1712b50c7f 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -56,6 +56,7 @@
 #include <asm/intel-family.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
+#include <asm/msr.h>
 #include <asm/tsc.h>
 #include <asm/fpu/api.h>
 #include <asm/smp.h>
diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index 18fc1aaa5cdd..2b6778d8d166 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/cs5535.h>
 #include <linux/slab.h>
+#include <asm/msr.h>
 
 #define DRV_NAME "cs5535-mfgpt"
 
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3df6aabc7e33..7edd0b5e0e77 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -27,6 +27,10 @@
 #include <linux/module.h>
 #include <net/ip6_checksum.h>
 
+#ifdef CONFIG_X86
+#include <asm/msr.h>
+#endif
+
 #include "vmxnet3_int.h"
 #include "vmxnet3_xdp.h"
 
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index c4328a7ae083..b73e582128c9 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 
 #include "ifs.h"
 
diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 0289391eccde..50f1fdf7dfed 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -5,6 +5,7 @@
 #include <linux/sizes.h>
 #include <asm/cpu.h>
 #include <asm/microcode.h>
+#include <asm/msr.h>
 
 #include "ifs.h"
 
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 6b6ed7be461a..dfc119d7354d 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -7,6 +7,7 @@
 #include <linux/nmi.h>
 #include <linux/slab.h>
 #include <linux/stop_machine.h>
+#include <asm/msr.h>
 
 #include "ifs.h"
 
diff --git a/drivers/platform/x86/intel/pmc/cnp.c b/drivers/platform/x86/intel/pmc/cnp.c
index 547bdf1ab02d..efea4e1ba52b 100644
--- a/drivers/platform/x86/intel/pmc/cnp.c
+++ b/drivers/platform/x86/intel/pmc/cnp.c
@@ -10,6 +10,7 @@
 
 #include <linux/smp.h>
 #include <linux/suspend.h>
+#include <asm/msr.h>
 #include "core.h"
 
 /* Cannon Lake: PGD PFET Enable Ack Status Register(s) bitmap */
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 44dcd165b4c0..8a5713593811 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -21,6 +21,7 @@
 
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 
 #include "isst_if_common.h"
 
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
index 78989f649aea..22745b217c6f 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
@@ -18,6 +18,7 @@
 #include <uapi/linux/isst_if.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 
 #include "isst_if_common.h"
 
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 0b8ef0cfaf80..4d30d5360c8f 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <asm/msr.h>
 #include <uapi/linux/isst_if.h>
 
 #include "isst_tpmi_core.h"
diff --git a/drivers/platform/x86/intel/turbo_max_3.c b/drivers/platform/x86/intel/turbo_max_3.c
index 7e538bbd5b50..b5af3e91ba04 100644
--- a/drivers/platform/x86/intel/turbo_max_3.c
+++ b/drivers/platform/x86/intel/turbo_max_3.c
@@ -17,6 +17,7 @@
 
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 
 #define MSR_OC_MAILBOX			0x150
 #define MSR_OC_MAILBOX_CMD_OFFSET	32
diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index 6f873765d2d1..96f854c21bb5 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -21,6 +21,7 @@
 #include <linux/suspend.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 
 #include "uncore-frequency-common.h"
 
diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 5ab3feb29686..e3be40adc0d7 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -28,6 +28,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/iosf_mbi.h>
+#include <asm/msr.h>
 
 /* bitmasks for RAPL MSRs, used by primitive access functions */
 #define ENERGY_STATUS_MASK      0xffffffff
diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index 6d5853db17ad..8ad2115d65f6 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -24,6 +24,7 @@
 
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 
 /* Local defines */
 #define MSR_PLATFORM_POWER_LIMIT	0x0000065C
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index b0249468b844..57cf46f69669 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/thermal.h>
+#include <asm/msr.h>
 #include "int340x_thermal_zone.h"
 #include "processor_thermal_device.h"
 #include "../intel_soc_dts_iosf.h"
diff --git a/drivers/thermal/intel/intel_tcc_cooling.c b/drivers/thermal/intel/intel_tcc_cooling.c
index 0394897e83cf..f352ecafbedf 100644
--- a/drivers/thermal/intel/intel_tcc_cooling.c
+++ b/drivers/thermal/intel/intel_tcc_cooling.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/thermal.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 
 #define TCC_PROGRAMMABLE	BIT(30)
 #define TCC_LOCKED		BIT(31)
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 496abf8e55e0..4894a26b1e4e 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -20,6 +20,7 @@
 #include <linux/debugfs.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 
 #include "thermal_interrupt.h"
 
diff --git a/drivers/video/fbdev/geode/display_gx.c b/drivers/video/fbdev/geode/display_gx.c
index b5f25dffd274..099322cefce0 100644
--- a/drivers/video/fbdev/geode/display_gx.c
+++ b/drivers/video/fbdev/geode/display_gx.c
@@ -13,6 +13,7 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 #include <asm/delay.h>
+#include <asm/msr.h>
 #include <linux/cs5535.h>
 
 #include "gxfb.h"
diff --git a/drivers/video/fbdev/geode/gxfb_core.c b/drivers/video/fbdev/geode/gxfb_core.c
index 2b27d6540805..0105ecf92773 100644
--- a/drivers/video/fbdev/geode/gxfb_core.c
+++ b/drivers/video/fbdev/geode/gxfb_core.c
@@ -30,6 +30,7 @@
 #include <linux/cs5535.h>
 
 #include <asm/olpc.h>
+#include <asm/msr.h>
 
 #include "gxfb.h"
 
diff --git a/drivers/video/fbdev/geode/lxfb_ops.c b/drivers/video/fbdev/geode/lxfb_ops.c
index a27531b5de11..2e33da9849b0 100644
--- a/drivers/video/fbdev/geode/lxfb_ops.c
+++ b/drivers/video/fbdev/geode/lxfb_ops.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/cs5535.h>
 
+#include <asm/msr.h>
 #include "lxfb.h"
 
 /* TODO
-- 
2.49.0


