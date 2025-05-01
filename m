Return-Path: <kvm+bounces-45028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 634CDAA5A9B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 07:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 965ED1B68043
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BD626B2CE;
	Thu,  1 May 2025 05:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="IUJUV+Md"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C31537C8;
	Thu,  1 May 2025 05:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746078237; cv=none; b=R6e4FYUZwv6xMdbhSPFT9fxdXZvWqi6e+4EmCSmj2GhJ0dfo/XY2UTTeijfPjEpNRlIQ5EBXO59jmkNnN9mCidzTy8xwphDMin3dosSow+bAmK2vkTF4fRgTOzbRN4t1ptJ6vkO3MiPt2ifvtZNnxRqztWF/lXLFhDI8MDrfm3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746078237; c=relaxed/simple;
	bh=/JLhChbia0o2/r4lWhmDLY0qvyv1bWUrWd+adXfS/SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EjUnUIXhCo2fbuVNKUneBNl7OkBjumsmp+mMmwRIV9FbTTZ5IxqydYMigWOF51T0byiD/D7HvFYW9uMG935vwRLs1ZqRRIZho78ec4378nQiYKs/5CMvk4Z1O0Bt4Kj4ydl0vUgIE8/ibqgM7eWW7b8YWlfozl7mq4lQPA0r160=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=IUJUV+Md; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5415gf9Y1245658
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 30 Apr 2025 22:42:45 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5415gf9Y1245658
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1746078168;
	bh=ID53P6glTV3Qvu7uT3RgHnhRE2lpb6o+W8jMZwlWtkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUJUV+MdHEwURcEnpH/eI0iuI0Lc+eYenYN6HTufTcOgmCYV40c0bS/BaQfmv8I3Z
	 cnCCZbRUMK1HMYPuzJ8QBZxInRpB+LASWB0yIGR3JgoEJgKY2s1Oq/oSpEI2pUutJY
	 /RYrJiNUuYYzcyFiOyu9aNm+elgZjSqK6GYBgrpK5IDUh/2dS0IbKw+Hr//qegqnbw
	 kN2mi/oUibngc99YJMU7zb8jwDTBAdzIrnZap3kzvAyK9+vBW5OuweoUHA0Q3dJvdF
	 HifkwUpM4AHO8Z8u3cprxY4hRBEfs+1jps12fYrNFjJ79yngYTDJxOOUyUSTxvEAGE
	 QdXOqpu1JUFvw==
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
Subject: [PATCH v4A 01/15] x86/msr: Add missing includes of <asm/msr.h>
Date: Wed, 30 Apr 2025 22:42:41 -0700
Message-ID: <20250501054241.1245648-1-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <a1917b37-e41e-d303-749b-4007cda01605@linux.intel.com>
References: <a1917b37-e41e-d303-749b-4007cda01605@linux.intel.com>
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
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---

Change in v4A:
*) Use "git grep -l -e $PATTERN | grep -v -f <(git grep -l -e 'asm/msr\.h')"
   to ensure ALL required *direct* inclusion of <asm/msr.h> (Ilpo Järvinen).

Change in v4:
*) Add missing includes in a different patch (Ilpo Järvinen).
*) Add all necessary direct inclusions for msr.h (Ilpo Järvinen).

Change in v3:
* Add a problem statement to the changelog (Dave Hansen).
---
 arch/x86/coco/sev/core.c                                    | 1 +
 arch/x86/events/amd/core.c                                  | 1 +
 arch/x86/events/amd/ibs.c                                   | 1 +
 arch/x86/events/amd/iommu.c                                 | 2 ++
 arch/x86/events/amd/lbr.c                                   | 1 +
 arch/x86/events/amd/power.c                                 | 1 +
 arch/x86/events/core.c                                      | 1 +
 arch/x86/events/intel/bts.c                                 | 1 +
 arch/x86/events/intel/core.c                                | 1 +
 arch/x86/events/intel/cstate.c                              | 1 +
 arch/x86/events/intel/ds.c                                  | 1 +
 arch/x86/events/intel/knc.c                                 | 1 +
 arch/x86/events/intel/p4.c                                  | 1 +
 arch/x86/events/intel/p6.c                                  | 1 +
 arch/x86/events/intel/pt.c                                  | 1 +
 arch/x86/events/intel/uncore.c                              | 1 +
 arch/x86/events/intel/uncore_discovery.c                    | 1 +
 arch/x86/events/intel/uncore_nhmex.c                        | 1 +
 arch/x86/events/intel/uncore_snb.c                          | 1 +
 arch/x86/events/intel/uncore_snbep.c                        | 1 +
 arch/x86/events/msr.c                                       | 2 ++
 arch/x86/events/perf_event.h                                | 1 +
 arch/x86/events/probe.c                                     | 2 ++
 arch/x86/events/rapl.c                                      | 1 +
 arch/x86/events/utils.c                                     | 1 +
 arch/x86/events/zhaoxin/core.c                              | 1 +
 arch/x86/hyperv/hv_apic.c                                   | 1 +
 arch/x86/hyperv/hv_init.c                                   | 1 +
 arch/x86/hyperv/hv_spinlock.c                               | 1 +
 arch/x86/hyperv/hv_vtl.c                                    | 1 +
 arch/x86/hyperv/ivm.c                                       | 1 +
 arch/x86/include/asm/fred.h                                 | 1 +
 arch/x86/include/asm/kvm_host.h                             | 1 +
 arch/x86/include/asm/microcode.h                            | 2 ++
 arch/x86/include/asm/mshyperv.h                             | 1 +
 arch/x86/include/asm/msr.h                                  | 1 +
 arch/x86/include/asm/resctrl.h                              | 2 ++
 arch/x86/include/asm/suspend_32.h                           | 1 +
 arch/x86/include/asm/suspend_64.h                           | 1 +
 arch/x86/include/asm/switch_to.h                            | 2 ++
 arch/x86/kernel/acpi/sleep.c                                | 1 +
 arch/x86/kernel/amd_nb.c                                    | 1 +
 arch/x86/kernel/apic/apic.c                                 | 1 +
 arch/x86/kernel/apic/apic_numachip.c                        | 1 +
 arch/x86/kernel/cet.c                                       | 1 +
 arch/x86/kernel/cpu/amd.c                                   | 1 +
 arch/x86/kernel/cpu/aperfmperf.c                            | 1 +
 arch/x86/kernel/cpu/bus_lock.c                              | 1 +
 arch/x86/kernel/cpu/feat_ctl.c                              | 1 +
 arch/x86/kernel/cpu/hygon.c                                 | 1 +
 arch/x86/kernel/cpu/mce/inject.c                            | 1 +
 arch/x86/kernel/cpu/microcode/core.c                        | 1 +
 arch/x86/kernel/cpu/mshyperv.c                              | 1 +
 arch/x86/kernel/cpu/resctrl/core.c                          | 1 +
 arch/x86/kernel/cpu/resctrl/monitor.c                       | 1 +
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c                   | 1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                      | 1 +
 arch/x86/kernel/cpu/sgx/main.c                              | 1 +
 arch/x86/kernel/cpu/topology.c                              | 1 +
 arch/x86/kernel/cpu/topology_amd.c                          | 1 +
 arch/x86/kernel/cpu/tsx.c                                   | 1 +
 arch/x86/kernel/cpu/zhaoxin.c                               | 1 +
 arch/x86/kernel/fpu/core.c                                  | 1 +
 arch/x86/kernel/fpu/xstate.c                                | 1 +
 arch/x86/kernel/fpu/xstate.h                                | 1 +
 arch/x86/kernel/fred.c                                      | 1 +
 arch/x86/kernel/hpet.c                                      | 1 +
 arch/x86/kernel/kvm.c                                       | 1 +
 arch/x86/kernel/paravirt.c                                  | 1 +
 arch/x86/kernel/process.c                                   | 1 +
 arch/x86/kernel/process_64.c                                | 1 +
 arch/x86/kernel/trace_clock.c                               | 2 +-
 arch/x86/kernel/traps.c                                     | 1 +
 arch/x86/kernel/tsc.c                                       | 1 +
 arch/x86/kernel/tsc_sync.c                                  | 1 +
 arch/x86/kvm/svm/avic.c                                     | 1 +
 arch/x86/kvm/svm/sev.c                                      | 1 +
 arch/x86/kvm/svm/svm.c                                      | 1 +
 arch/x86/kvm/vmx/nested.c                                   | 1 +
 arch/x86/kvm/vmx/pmu_intel.c                                | 1 +
 arch/x86/kvm/vmx/sgx.c                                      | 1 +
 arch/x86/kvm/vmx/vmx.c                                      | 1 +
 arch/x86/lib/insn-eval.c                                    | 1 +
 arch/x86/lib/kaslr.c                                        | 2 +-
 arch/x86/mm/mem_encrypt_identity.c                          | 1 +
 arch/x86/mm/tlb.c                                           | 1 +
 arch/x86/pci/amd_bus.c                                      | 1 +
 arch/x86/pci/mmconfig-shared.c                              | 3 ++-
 arch/x86/power/cpu.c                                        | 1 +
 arch/x86/realmode/init.c                                    | 1 +
 arch/x86/virt/svm/sev.c                                     | 1 +
 arch/x86/xen/enlighten_pv.c                                 | 1 +
 arch/x86/xen/pmu.c                                          | 1 +
 arch/x86/xen/suspend.c                                      | 1 +
 drivers/accel/habanalabs/common/habanalabs_ioctl.c          | 2 --
 drivers/acpi/acpi_extlog.c                                  | 1 +
 drivers/acpi/processor_perflib.c                            | 1 +
 drivers/acpi/processor_throttling.c                         | 6 +++++-
 drivers/char/agp/nvidia-agp.c                               | 1 +
 drivers/cpufreq/amd-pstate-ut.c                             | 2 ++
 drivers/cpufreq/elanfreq.c                                  | 1 -
 drivers/cpufreq/sc520_freq.c                                | 1 -
 drivers/crypto/ccp/sev-dev.c                                | 1 +
 drivers/edac/amd64_edac.c                                   | 1 +
 drivers/edac/ie31200_edac.c                                 | 1 +
 drivers/edac/mce_amd.c                                      | 1 +
 drivers/hwmon/hwmon-vid.c                                   | 4 ++++
 drivers/idle/intel_idle.c                                   | 1 +
 drivers/misc/cs5535-mfgpt.c                                 | 1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                           | 4 ++++
 drivers/platform/x86/intel/ifs/core.c                       | 1 +
 drivers/platform/x86/intel/ifs/load.c                       | 1 +
 drivers/platform/x86/intel/ifs/runtest.c                    | 1 +
 drivers/platform/x86/intel/pmc/cnp.c                        | 1 +
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 1 +
 .../platform/x86/intel/speed_select_if/isst_if_mbox_msr.c   | 1 +
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c | 1 +
 drivers/platform/x86/intel/turbo_max_3.c                    | 1 +
 .../platform/x86/intel/uncore-frequency/uncore-frequency.c  | 1 +
 drivers/powercap/intel_rapl_common.c                        | 1 +
 drivers/powercap/intel_rapl_msr.c                           | 1 +
 .../intel/int340x_thermal/processor_thermal_device.c        | 1 +
 drivers/thermal/intel/intel_tcc_cooling.c                   | 1 +
 drivers/thermal/intel/x86_pkg_temp_thermal.c                | 1 +
 drivers/video/fbdev/geode/display_gx.c                      | 1 +
 drivers/video/fbdev/geode/gxfb_core.c                       | 1 +
 drivers/video/fbdev/geode/lxfb_ops.c                        | 1 +
 127 files changed, 142 insertions(+), 8 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index b18a33fe8dd3..85b16a0ee417 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -43,6 +43,7 @@
 #include <asm/apic.h>
 #include <asm/cpuid.h>
 #include <asm/cmdline.h>
+#include <asm/msr.h>
 
 #define DR7_RESET_VALUE        0x400
 
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index cb62b6d12691..79e8453dd051 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -9,6 +9,7 @@
 #include <linux/jiffies.h>
 #include <asm/apicdef.h>
 #include <asm/apic.h>
+#include <asm/msr.h>
 #include <asm/nmi.h>
 
 #include "../perf_event.h"
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 82fa755d1b12..20877927b021 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -15,6 +15,7 @@
 #include <linux/sched/clock.h>
 
 #include <asm/apic.h>
+#include <asm/msr.h>
 
 #include "../perf_event.h"
 
diff --git a/arch/x86/events/amd/iommu.c b/arch/x86/events/amd/iommu.c
index f8228d8243f7..a721da9987dd 100644
--- a/arch/x86/events/amd/iommu.c
+++ b/arch/x86/events/amd/iommu.c
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include <linux/amd-iommu.h>
 
+#include <asm/msr.h>
+
 #include "../perf_event.h"
 #include "iommu.h"
 
diff --git a/arch/x86/events/amd/lbr.c b/arch/x86/events/amd/lbr.c
index 198851985bb7..d24da377df77 100644
--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/perf_event.h>
+#include <asm/msr.h>
 #include <asm/perf_event.h>
 
 #include "../perf_event.h"
diff --git a/arch/x86/events/amd/power.c b/arch/x86/events/amd/power.c
index 598a727d823a..dad42790cf7d 100644
--- a/arch/x86/events/amd/power.c
+++ b/arch/x86/events/amd/power.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/perf_event.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 #include "../perf_event.h"
 
 /* Event code: LSB 8 bits, passed in attr->config any other bit is reserved. */
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 85b55c1dc162..32ff97a6a4ac 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -32,6 +32,7 @@
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
+#include <asm/msr.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/alternative.h>
diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index a95e6c91c4d7..ca9f57437d8b 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -17,6 +17,7 @@
 
 #include <linux/sizes.h>
 #include <asm/perf_event.h>
+#include <asm/msr.h>
 
 #include "../perf_event.h"
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 394fa83b537b..52d7fb5b0329 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -23,6 +23,7 @@
 #include <asm/intel_pt.h>
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 
 #include "../perf_event.h"
 
diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index 56b1c391ccc7..ec753e39b007 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -111,6 +111,7 @@
 #include <linux/nospec.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 #include "../perf_event.h"
 #include "../probe.h"
 
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 410a8975d1b9..7ba945d3eacc 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -10,6 +10,7 @@
 #include <asm/tlbflush.h>
 #include <asm/insn.h>
 #include <asm/io.h>
+#include <asm/msr.h>
 #include <asm/timer.h>
 
 #include "../perf_event.h"
diff --git a/arch/x86/events/intel/knc.c b/arch/x86/events/intel/knc.c
index 425f6e6eed89..38904a558128 100644
--- a/arch/x86/events/intel/knc.c
+++ b/arch/x86/events/intel/knc.c
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 
 #include <asm/hardirq.h>
+#include <asm/msr.h>
 
 #include "../perf_event.h"
 
diff --git a/arch/x86/events/intel/p4.c b/arch/x86/events/intel/p4.c
index 24d811a9608a..aa5202126752 100644
--- a/arch/x86/events/intel/p4.c
+++ b/arch/x86/events/intel/p4.c
@@ -13,6 +13,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/hardirq.h>
 #include <asm/apic.h>
+#include <asm/msr.h>
 
 #include "../perf_event.h"
 
diff --git a/arch/x86/events/intel/p6.c b/arch/x86/events/intel/p6.c
index 35917a776bec..6e41de355bd8 100644
--- a/arch/x86/events/intel/p6.c
+++ b/arch/x86/events/intel/p6.c
@@ -3,6 +3,7 @@
 #include <linux/types.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 
 #include "../perf_event.h"
 
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index d579f1092357..f37cce231266 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -24,6 +24,7 @@
 #include <asm/io.h>
 #include <asm/intel_pt.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 
 #include "../perf_event.h"
 #include "pt.h"
diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index d6070529c58e..c24d21932c91 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -3,6 +3,7 @@
 
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 #include "uncore.h"
 #include "uncore_discovery.h"
 
diff --git a/arch/x86/events/intel/uncore_discovery.c b/arch/x86/events/intel/uncore_discovery.c
index 4fc3eec325f6..18a3022f26a0 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -5,6 +5,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <asm/msr.h>
 #include "uncore.h"
 #include "uncore_discovery.h"
 
diff --git a/arch/x86/events/intel/uncore_nhmex.c b/arch/x86/events/intel/uncore_nhmex.c
index bef9c782c781..8962e7cb21e3 100644
--- a/arch/x86/events/intel/uncore_nhmex.c
+++ b/arch/x86/events/intel/uncore_nhmex.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Nehalem-EX/Westmere-EX uncore support */
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 #include "uncore.h"
 
 /* NHM-EX event control */
diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index afc8ef02a7a9..a1a96833e30e 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Nehalem/SandBridge/Haswell/Broadwell/Skylake uncore support */
+#include <asm/msr.h>
 #include "uncore.h"
 #include "uncore_discovery.h"
 
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index dd53dd87cdec..500913ead670 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* SandyBridge-EP/IvyTown uncore support */
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 #include "uncore.h"
 #include "uncore_discovery.h"
 
diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 8970ecef87c5..7f5007a4752a 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -3,6 +3,8 @@
 #include <linux/sysfs.h>
 #include <linux/nospec.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
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
diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 7ff52c23d7a1..defd86137f12 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -65,6 +65,7 @@
 #include <linux/nospec.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 #include "perf_event.h"
 #include "probe.h"
 
diff --git a/arch/x86/events/utils.c b/arch/x86/events/utils.c
index dab4ed199227..77fd00b3305e 100644
--- a/arch/x86/events/utils.c
+++ b/arch/x86/events/utils.c
@@ -2,6 +2,7 @@
 #include <asm/insn.h>
 #include <linux/mm.h>
 
+#include <asm/msr.h>
 #include "perf_event.h"
 
 static int decode_branch_type(struct insn *insn)
diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index e299364eb889..91443aba4c7d 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -15,6 +15,7 @@
 #include <asm/cpufeature.h>
 #include <asm/hardirq.h>
 #include <asm/apic.h>
+#include <asm/msr.h>
 
 #include "../perf_event.h"
 
diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index c450e67cb0a4..a079a1427091 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -28,6 +28,7 @@
 #include <asm/hypervisor.h>
 #include <asm/mshyperv.h>
 #include <asm/apic.h>
+#include <asm/msr.h>
 
 #include <asm/trace/hyperv.h>
 
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index ed89867b6fd0..5d27194a2efa 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -21,6 +21,7 @@
 #include <asm/hypervisor.h>
 #include <hyperv/hvhdk.h>
 #include <asm/mshyperv.h>
+#include <asm/msr.h>
 #include <asm/idtentry.h>
 #include <asm/set_memory.h>
 #include <linux/kexec.h>
diff --git a/arch/x86/hyperv/hv_spinlock.c b/arch/x86/hyperv/hv_spinlock.c
index 626f6d4d6253..81b006601370 100644
--- a/arch/x86/hyperv/hv_spinlock.c
+++ b/arch/x86/hyperv/hv_spinlock.c
@@ -15,6 +15,7 @@
 #include <asm/mshyperv.h>
 #include <asm/paravirt.h>
 #include <asm/apic.h>
+#include <asm/msr.h>
 
 static bool hv_pvspin __initdata = true;
 
diff --git a/arch/x86/hyperv/hv_vtl.c b/arch/x86/hyperv/hv_vtl.c
index 13242ed8ff16..079b276e5f30 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -11,6 +11,7 @@
 #include <asm/desc.h>
 #include <asm/i8259.h>
 #include <asm/mshyperv.h>
+#include <asm/msr.h>
 #include <asm/realmode.h>
 #include <asm/reboot.h>
 #include <../kernel/smpboot.h>
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
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9af20b3c0f1d..f1b5f7eceda0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -34,6 +34,7 @@
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/msr-index.h>
+#include <asm/msr.h>
 #include <asm/asm.h>
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
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
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 011bf67a1866..bd6afe805cf6 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -9,6 +9,8 @@
 #include <linux/resctrl_types.h>
 #include <linux/sched.h>
 
+#include <asm/msr.h>
+
 /*
  * This value can never be a valid CLOSID, and is used when mapping a
  * (closid, rmid) pair to an index and back. On x86 only the RMID is
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
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 6dfecb27b846..91fa262f0e30 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -16,6 +16,7 @@
 #include <asm/cacheflush.h>
 #include <asm/realmode.h>
 #include <asm/hypervisor.h>
+#include <asm/msr.h>
 #include <asm/smp.h>
 
 #include <linux/ftrace.h>
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index dc389ca052b7..4973a10d74f5 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/pci_ids.h>
 #include <asm/amd_nb.h>
+#include <asm/msr.h>
 
 static u32 *flush_words;
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a05871c85183..d73ba5a7b623 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -59,6 +59,7 @@
 #include <asm/time.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
+#include <asm/msr.h>
 #include <asm/tsc.h>
 #include <asm/hypervisor.h>
 #include <asm/cpu_device_id.h>
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index fcfef701c17a..e272bc7fdc8e 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/pgtable.h>
 
+#include <asm/msr.h>
 #include <asm/numachip/numachip.h>
 #include <asm/numachip/numachip_csr.h>
 
diff --git a/arch/x86/kernel/cet.c b/arch/x86/kernel/cet.c
index d897aadd1d44..99444409c026 100644
--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -2,6 +2,7 @@
 
 #include <linux/ptrace.h>
 #include <asm/bugs.h>
+#include <asm/msr.h>
 #include <asm/traps.h>
 
 enum cp_error_code {
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0bbe79862aa6..3bca79feb23f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -21,6 +21,7 @@
 #include <asm/delay.h>
 #include <asm/debugreg.h>
 #include <asm/resctrl.h>
+#include <asm/msr.h>
 #include <asm/sev.h>
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index e99892aad628..a315b0627dfb 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -20,6 +20,7 @@
 #include <asm/cpu.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 
 #include "cpu.h"
 
diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
index a18d0f2ea832..981f8b1f0792 100644
--- a/arch/x86/kernel/cpu/bus_lock.c
+++ b/arch/x86/kernel/cpu/bus_lock.c
@@ -10,6 +10,7 @@
 #include <asm/cmdline.h>
 #include <asm/traps.h>
 #include <asm/cpu.h>
+#include <asm/msr.h>
 
 enum split_lock_detect_state {
 	sld_off = 0,
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 441174844e01..d69757246bde 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -4,6 +4,7 @@
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
+#include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/vmx.h>
 
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 21541e310c2c..2154f12766fb 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -15,6 +15,7 @@
 #include <asm/cacheinfo.h>
 #include <asm/spec-ctrl.h>
 #include <asm/delay.h>
+#include <asm/msr.h>
 
 #include "cpu.h"
 
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 338aeee95bd2..e13f533e31e6 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -28,6 +28,7 @@
 #include <asm/apic.h>
 #include <asm/irq_vectors.h>
 #include <asm/mce.h>
+#include <asm/msr.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
 
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index b3658d11e7b6..793e2927d0fa 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -37,6 +37,7 @@
 #include <asm/perf_event.h>
 #include <asm/processor.h>
 #include <asm/cmdline.h>
+#include <asm/msr.h>
 #include <asm/setup.h>
 
 #include "internal.h"
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index b924befe8d6e..c78f860419d6 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -30,6 +30,7 @@
 #include <asm/reboot.h>
 #include <asm/nmi.h>
 #include <clocksource/hyperv_timer.h>
+#include <asm/msr.h>
 #include <asm/numa.h>
 #include <asm/svm.h>
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 280d6900726b..d987b11c168c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -22,6 +22,7 @@
 #include <linux/cpuhotplug.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 #include <asm/resctrl.h>
 #include "internal.h"
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index f73a74945ffa..591b0b44d260 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
 #include <asm/resctrl.h>
 
 #include "internal.h"
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
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 26f4d820ee6e..9acd7f320ce3 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -28,6 +28,7 @@
 
 #include <uapi/linux/magic.h>
 
+#include <asm/msr.h>
 #include <asm/resctrl.h>
 #include "internal.h"
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 40967d8f995a..6722b2fc82cf 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/vmalloc.h>
+#include <asm/msr.h>
 #include <asm/sgx.h>
 #include "driver.h"
 #include "encl.h"
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 6e1885dece0f..e35ccdc84910 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -30,6 +30,7 @@
 #include <asm/hypervisor.h>
 #include <asm/io_apic.h>
 #include <asm/mpspec.h>
+#include <asm/msr.h>
 #include <asm/smp.h>
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 535dcf511096..f78d38510027 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -3,6 +3,7 @@
 
 #include <asm/apic.h>
 #include <asm/memtype.h>
+#include <asm/msr.h>
 #include <asm/processor.h>
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index b0a9c9e9d029..49782724a943 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -12,6 +12,7 @@
 
 #include <asm/cmdline.h>
 #include <asm/cpu.h>
+#include <asm/msr.h>
 
 #include "cpu.h"
 
diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
index 90eba7eb5335..89b1c8a70fe8 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -4,6 +4,7 @@
 
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
+#include <asm/msr.h>
 
 #include "cpu.h"
 
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 985dfffe28c1..e92d27324d9a 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -11,6 +11,7 @@
 #include <asm/fpu/sched.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/types.h>
+#include <asm/msr.h>
 #include <asm/traps.h>
 #include <asm/irq_regs.h>
 
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 2bd87b788630..86d690afb63c 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -21,6 +21,7 @@
 #include <asm/fpu/xcr.h>
 
 #include <asm/cpuid.h>
+#include <asm/msr.h>
 #include <asm/tlbflush.h>
 #include <asm/prctl.h>
 #include <asm/elf.h>
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
diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
index 10b0169f3fc1..816187da3a47 100644
--- a/arch/x86/kernel/fred.c
+++ b/arch/x86/kernel/fred.c
@@ -3,6 +3,7 @@
 
 #include <asm/desc.h>
 #include <asm/fred.h>
+#include <asm/msr.h>
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
 
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
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 44a45df7200a..27f7192e1c61 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -40,6 +40,7 @@
 #include <asm/mtrr.h>
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
+#include <asm/msr.h>
 #include <asm/ptrace.h>
 #include <asm/reboot.h>
 #include <asm/svm.h>
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1ccd05d8999f..015bf298434f 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -33,6 +33,7 @@
 #include <asm/tlb.h>
 #include <asm/io_bitmap.h>
 #include <asm/gsseg.h>
+#include <asm/msr.h>
 
 /* stub always returning 0. */
 DEFINE_ASM_FUNC(paravirt_ret0, "xor %eax,%eax", .entry.text);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c168f99b5f0b..bd50249cff50 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -52,6 +52,7 @@
 #include <asm/unwind.h>
 #include <asm/tdx.h>
 #include <asm/mmu_context.h>
+#include <asm/msr.h>
 #include <asm/shstk.h>
 
 #include "process.h"
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
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 823410aaf429..ca43eb5a02a3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -68,6 +68,7 @@
 #include <asm/vdso.h>
 #include <asm/tdx.h>
 #include <asm/cfi.h>
+#include <asm/msr.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 160fef71b9a3..5d3a764ba77c 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -29,6 +29,7 @@
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
 #include <asm/i8259.h>
+#include <asm/msr.h>
 #include <asm/topology.h>
 #include <asm/uv/uv.h>
 #include <asm/sev.h>
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
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 51842100f6d2..5f99762fb2f7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -20,6 +20,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/irq_remapping.h>
+#include <asm/msr.h>
 
 #include "trace.h"
 #include "lapic.h"
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a4aabd666665..4b607cc377c9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -26,6 +26,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
+#include <asm/msr.h>
 #include <asm/sev.h>
 
 #include "mmu.h"
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 67657b3a36ce..c23f620989ed 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -31,6 +31,7 @@
 #include <linux/string_choices.h>
 
 #include <asm/apic.h>
+#include <asm/msr.h>
 #include <asm/perf_event.h>
 #include <asm/tlbflush.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a7fea622e204..d268224227f0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6,6 +6,7 @@
 
 #include <asm/debugreg.h>
 #include <asm/mmu_context.h>
+#include <asm/msr.h>
 
 #include "x86.h"
 #include "cpuid.h"
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5e0bb821c7bc..231a9633359c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <asm/msr.h>
 #include <asm/perf_event.h>
 #include "x86.h"
 #include "cpuid.h"
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 949864259ee6..df1d0cf76947 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -2,6 +2,7 @@
 /*  Copyright(c) 2021 Intel Corporation. */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <asm/msr.h>
 #include <asm/sgx.h>
 
 #include "x86.h"
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cd0d6c1fcf9c..d8412cfdb18e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -46,6 +46,7 @@
 #include <asm/perf_event.h>
 #include <asm/mmu_context.h>
 #include <asm/mshyperv.h>
+#include <asm/msr.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
 #include <asm/vmx.h>
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index da5af3cc25b1..dbe0fbf0037f 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -13,6 +13,7 @@
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
 #include <asm/ldt.h>
+#include <asm/msr.h>
 #include <asm/vm86.h>
 
 #undef pr_fmt
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
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index b1d521201e0b..6a9befef9fb8 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -19,6 +19,7 @@
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/apic.h>
+#include <asm/msr.h>
 #include <asm/perf_event.h>
 #include <asm/tlb.h>
 
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 6158f652a7cd..5154915bf50f 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -6,6 +6,7 @@
 #include <linux/range.h>
 
 #include <asm/amd_nb.h>
+#include <asm/msr.h>
 #include <asm/pci_x86.h>
 
 #include <asm/pci-direct.h>
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 39255f0eb14d..1f4522325920 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -22,9 +22,10 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/rculist.h>
+#include <asm/acpi.h>
 #include <asm/e820/api.h>
+#include <asm/msr.h>
 #include <asm/pci_x86.h>
-#include <asm/acpi.h>
 
 /* Indicate if the ECAM resources have been placed into the resource table */
 static bool pci_mmcfg_running_state;
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index d5a7b3bc2453..916441f5e85c 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -27,6 +27,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cpu_device_id.h>
 #include <asm/microcode.h>
+#include <asm/msr.h>
 #include <asm/fred.h>
 
 #ifdef CONFIG_X86_32
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
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 334177c89df0..76926f75e9bf 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -30,6 +30,7 @@
 #include <asm/cpuid.h>
 #include <asm/cmdline.h>
 #include <asm/iommu.h>
+#include <asm/msr.h>
 
 /*
  * The RMP entry information as returned by the RMPREAD instruction.
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 846b5737d320..8ddd9e535f99 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -61,6 +61,7 @@
 #include <asm/processor.h>
 #include <asm/proto.h>
 #include <asm/msr-index.h>
+#include <asm/msr.h>
 #include <asm/traps.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index f06987b0efc3..3cb566d4aaad 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -2,6 +2,7 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 
+#include <asm/msr.h>
 #include <asm/xen/hypercall.h>
 #include <xen/xen.h>
 #include <xen/page.h>
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 7bb3ac2d5ac8..ba2f17e64321 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -13,6 +13,7 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/page.h>
 #include <asm/fixmap.h>
+#include <asm/msr.h>
 
 #include "xen-ops.h"
 
diff --git a/drivers/accel/habanalabs/common/habanalabs_ioctl.c b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
index 8729a0c57d78..dc80ca921d90 100644
--- a/drivers/accel/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
@@ -17,8 +17,6 @@
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 
-#include <asm/msr.h>
-
 /* make sure there is space for all the signed info */
 static_assert(sizeof(struct cpucp_info) <= SEC_DEV_INFO_BUF_SZ);
 
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
index 00d045e5f524..ecd7fe256153 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -18,9 +18,13 @@
 #include <linux/sched.h>
 #include <linux/cpufreq.h>
 #include <linux/acpi.h>
+#include <linux/uaccess.h>
 #include <acpi/processor.h>
 #include <asm/io.h>
-#include <linux/uaccess.h>
+#include <asm/asm.h>
+#ifdef CONFIG_X86
+#include <asm/msr.h>
+#endif
 
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
 
 
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 36494b855e41..fc5a58088b35 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -21,7 +21,6 @@
 #include <linux/cpufreq.h>
 
 #include <asm/cpu_device_id.h>
-#include <asm/msr.h>
 #include <linux/timex.h>
 #include <linux/io.h>
 
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 103d2519dff7..b360f03a116f 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -21,7 +21,6 @@
 #include <linux/io.h>
 
 #include <asm/cpu_device_id.h>
-#include <asm/msr.h>
 
 #define MMCR_BASE	0xfffef000	/* The default base address */
 #define OFFS_CPUCTL	0x2   /* CPU Control Register */
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
index 2b27d6540805..8d69be7c9d31 100644
--- a/drivers/video/fbdev/geode/gxfb_core.c
+++ b/drivers/video/fbdev/geode/gxfb_core.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/cs5535.h>
 
+#include <asm/msr.h>
 #include <asm/olpc.h>
 
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


