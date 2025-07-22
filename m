Return-Path: <kvm+bounces-53085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B079B0D230
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 08:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 130783AF32E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 06:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0842BF3CF;
	Tue, 22 Jul 2025 06:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WIAKDlrl";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zIm9gCKV"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85CF2D322A;
	Tue, 22 Jul 2025 06:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753167321; cv=none; b=Ie1QS4ELQz6puXk9UQHcJ6tyF2SmTGnMJ7ewQxGRcTJsG0wWKVdlKVCK3Y1EEJE1KXT+3iVWB/26+MGLiICyfei0E6b9D6B2HpusXEpadAW1a0YYWzNBYrPuNG57pdRFFpMr3p3PJ7TNdm+34rtTIJtHDceDhNiJjFDknQGZiqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753167321; c=relaxed/simple;
	bh=7tu9JNR7Jrb5UoarjSOUM7NfWcuv1jFJzHqdoV5Xpjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF/VuR1vq1y9D87AFmr2N2Y22NFfdXza4TFhk0qDEnspFYi5MSpEbgV4tEHOznK2g8kJDSBHblJrbdms5sfB2vNzF07y/ZhHm6g7vuYUFGrDmckaWNGC9f/IclLLUZ58ybVx4v2OHoY6+9bDPKoPwzHahcpjXCsKImQsPi5mHnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=WIAKDlrl; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zIm9gCKV; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753167317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQRMiyYs1v7voyeresGGoDqMkeh3MiFIOHQqYaSfaK4=;
	b=WIAKDlrl4o6dLcOTH3nAKDD0qa3dYC/1w3Otl4ZW0tbgWn2iqHFXXmzfFKHrNlNx/ztRaD
	76ENRfnK9GGhNrSwYo89MLfuJcOxZ+IHMuU7cAmK1/2kd4hVwawvFCDCkUU3u5gZpDO3aJ
	DqCDeszHvgOWrna+X4OOxaTvZ8tjkdU2V3XpDvlaH1gJq9pqCxMVuHKjCYoXK/+HOEEiu8
	KvB2+tQd5kgqwJjpfVgfx4DXPuvma7/l4OKcGOfZ9OS3YTz1aZhdVXnXlRZt8LhzDzkZqC
	/4ivqCT8etzbakYNYUxiibMewhYB13WXcyd8Z8GBJjxOWDnQ5n+H0B3bfvWtLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753167317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQRMiyYs1v7voyeresGGoDqMkeh3MiFIOHQqYaSfaK4=;
	b=zIm9gCKVMVfZ/HGjylzGljCRUUnoLXAnf9w3sED6w4VFUHLOI2EpCoz3J1UKiQctlEj3TB
	o7271+xb9VWscCAw==
To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Ogness <john.ogness@linutronix.de>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	x86-cpuid@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>
Subject: [PATCH v3 5/6] treewide: Explicitly include the x86 CPUID headers
Date: Tue, 22 Jul 2025 08:54:30 +0200
Message-ID: <20250722065448.413503-6-darwi@linutronix.de>
In-Reply-To: <20250722065448.413503-1-darwi@linutronix.de>
References: <20250722065448.413503-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify all CPUID call sites which implicitly include any of the CPUID
headers to explicitly include them instead.

For arch/x86/kvm/reverse_cpuid.h, just include <asm/cpuid/types.h> since
it references the CPUID_EAX..EDX symbols without using any of the CPUID
APIs.

Note, adding explicit CPUID includes for all call sites allows removing
the <asm/cpuid/api.h> include from <asm/processor.h> next.  This way, the
CPUID API header can include <asm/procesor.h> at a later step without
introducing a circular dependency.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
---
 arch/x86/boot/compressed/pgtable_64.c             | 1 +
 arch/x86/boot/startup/sme.c                       | 1 +
 arch/x86/coco/tdx/tdx.c                           | 1 +
 arch/x86/events/amd/core.c                        | 2 ++
 arch/x86/events/amd/ibs.c                         | 1 +
 arch/x86/events/amd/lbr.c                         | 2 ++
 arch/x86/events/amd/power.c                       | 3 +++
 arch/x86/events/amd/uncore.c                      | 1 +
 arch/x86/events/intel/core.c                      | 1 +
 arch/x86/events/intel/lbr.c                       | 1 +
 arch/x86/events/zhaoxin/core.c                    | 1 +
 arch/x86/include/asm/acrn.h                       | 2 ++
 arch/x86/include/asm/microcode.h                  | 1 +
 arch/x86/include/asm/xen/hypervisor.h             | 1 +
 arch/x86/kernel/apic/apic.c                       | 1 +
 arch/x86/kernel/cpu/amd.c                         | 1 +
 arch/x86/kernel/cpu/centaur.c                     | 1 +
 arch/x86/kernel/cpu/hygon.c                       | 1 +
 arch/x86/kernel/cpu/mce/core.c                    | 1 +
 arch/x86/kernel/cpu/mce/inject.c                  | 1 +
 arch/x86/kernel/cpu/microcode/amd.c               | 1 +
 arch/x86/kernel/cpu/microcode/core.c              | 1 +
 arch/x86/kernel/cpu/microcode/intel.c             | 1 +
 arch/x86/kernel/cpu/mshyperv.c                    | 1 +
 arch/x86/kernel/cpu/resctrl/core.c                | 1 +
 arch/x86/kernel/cpu/resctrl/monitor.c             | 1 +
 arch/x86/kernel/cpu/scattered.c                   | 1 +
 arch/x86/kernel/cpu/sgx/driver.c                  | 3 +++
 arch/x86/kernel/cpu/sgx/main.c                    | 3 +++
 arch/x86/kernel/cpu/topology_amd.c                | 1 +
 arch/x86/kernel/cpu/topology_common.c             | 1 +
 arch/x86/kernel/cpu/topology_ext.c                | 1 +
 arch/x86/kernel/cpu/transmeta.c                   | 3 +++
 arch/x86/kernel/cpu/vmware.c                      | 1 +
 arch/x86/kernel/cpu/zhaoxin.c                     | 1 +
 arch/x86/kernel/cpuid.c                           | 1 +
 arch/x86/kernel/jailhouse.c                       | 1 +
 arch/x86/kernel/kvm.c                             | 1 +
 arch/x86/kernel/paravirt.c                        | 1 +
 arch/x86/kvm/mmu/mmu.c                            | 1 +
 arch/x86/kvm/mmu/spte.c                           | 1 +
 arch/x86/kvm/reverse_cpuid.h                      | 2 ++
 arch/x86/kvm/svm/sev.c                            | 1 +
 arch/x86/kvm/svm/svm.c                            | 1 +
 arch/x86/kvm/vmx/pmu_intel.c                      | 1 +
 arch/x86/kvm/vmx/sgx.c                            | 1 +
 arch/x86/kvm/vmx/vmx.c                            | 1 +
 arch/x86/mm/pti.c                                 | 1 +
 arch/x86/pci/xen.c                                | 1 +
 arch/x86/xen/enlighten_hvm.c                      | 1 +
 arch/x86/xen/pmu.c                                | 1 +
 arch/x86/xen/time.c                               | 1 +
 drivers/char/agp/efficeon-agp.c                   | 2 ++
 drivers/cpufreq/longrun.c                         | 1 +
 drivers/cpufreq/powernow-k7.c                     | 1 +
 drivers/cpufreq/powernow-k8.c                     | 1 +
 drivers/cpufreq/speedstep-lib.c                   | 1 +
 drivers/firmware/efi/libstub/x86-5lvl.c           | 1 +
 drivers/gpu/drm/gma500/mmu.c                      | 2 ++
 drivers/hwmon/fam15h_power.c                      | 1 +
 drivers/hwmon/k10temp.c                           | 2 ++
 drivers/hwmon/k8temp.c                            | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 2 ++
 drivers/ras/amd/fmpm.c                            | 1 +
 drivers/thermal/intel/intel_hfi.c                 | 1 +
 drivers/thermal/intel/x86_pkg_temp_thermal.c      | 1 +
 drivers/virt/acrn/hsm.c                           | 1 +
 drivers/xen/events/events_base.c                  | 1 +
 drivers/xen/grant-table.c                         | 1 +
 drivers/xen/xenbus/xenbus_xs.c                    | 3 +++
 70 files changed, 88 insertions(+)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index bdd26050dff7..d94d98595780 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -2,6 +2,7 @@
 #include "misc.h"
 #include <asm/bootparam.h>
 #include <asm/bootparam_utils.h>
+#include <asm/cpuid/api.h>
 #include <asm/e820/types.h>
 #include <asm/processor.h>
 #include "../string.h"
diff --git a/arch/x86/boot/startup/sme.c b/arch/x86/boot/startup/sme.c
index 922b236be02f..6a58ab568390 100644
--- a/arch/x86/boot/startup/sme.c
+++ b/arch/x86/boot/startup/sme.c
@@ -40,6 +40,7 @@
 #include <linux/mm.h>
 
 #include <asm/coco.h>
+#include <asm/cpuid/api.h>
 #include <asm/init.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 7bc11836c46a..4ed8ec642646 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -10,6 +10,7 @@
 #include <linux/kexec.h>
 
 #include <asm/coco.h>
+#include <asm/cpuid/api.h>
 #include <asm/ia32.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index b20661b8621d..d28d45ceb707 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -7,8 +7,10 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+
 #include <asm/apicdef.h>
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/nmi.h>
 
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 112f43b23ebf..0c7848e6149e 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -15,6 +15,7 @@
 #include <linux/sched/clock.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "../perf_event.h"
diff --git a/arch/x86/events/amd/lbr.c b/arch/x86/events/amd/lbr.c
index d24da377df77..5b437dc8e4ce 100644
--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/perf_event.h>
+
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/perf_event.h>
 
diff --git a/arch/x86/events/amd/power.c b/arch/x86/events/amd/power.c
index dad42790cf7d..744dffa42dee 100644
--- a/arch/x86/events/amd/power.c
+++ b/arch/x86/events/amd/power.c
@@ -10,8 +10,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/perf_event.h>
+
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
+
 #include "../perf_event.h"
 
 /* Event code: LSB 8 bits, passed in attr->config any other bit is reserved. */
diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index c1483ef16c0b..5261f12007df 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -15,6 +15,7 @@
 #include <linux/smp.h>
 #include <linux/types.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/perf_event.h>
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c2fb729c270e..ebbcdf82b494 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -17,6 +17,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/debugreg.h>
 #include <asm/hardirq.h>
 #include <asm/intel-family.h>
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 7aa59966e7c3..0d1ec3651735 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -3,6 +3,7 @@
 #include <linux/types.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/perf_event.h>
 #include <asm/msr.h>
 
diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index d59992364880..15bb9c9c9358 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -14,6 +14,7 @@
 
 #include <asm/apic.h>
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/hardirq.h>
 #include <asm/msr.h>
 
diff --git a/arch/x86/include/asm/acrn.h b/arch/x86/include/asm/acrn.h
index fab11192c60a..db42b477c41d 100644
--- a/arch/x86/include/asm/acrn.h
+++ b/arch/x86/include/asm/acrn.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_ACRN_H
 #define _ASM_X86_ACRN_H
 
+#include <asm/cpuid/api.h>
+
 /*
  * This CPUID returns feature bitmaps in EAX.
  * Guest VM uses this to detect the appropriate feature bit.
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 8b41f26f003b..645e65ac1586 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_MICROCODE_H
 
 #include <asm/msr.h>
+#include <asm/cpuid/api.h>
 
 struct cpu_signature {
 	unsigned int sig;
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index c2fc7869b996..7c596cebfb78 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -37,6 +37,7 @@ extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
 #include <asm/bug.h>
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 
 #define XEN_SIGNATURE "XenVMMXenVMM"
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f0e63842e2ef..b6bd2bd248d6 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -45,6 +45,7 @@
 #include <asm/barrier.h>
 #include <asm/cpu.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/hypervisor.h>
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c98b0d952537..8e29b39bc70c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -15,6 +15,7 @@
 #include <asm/cacheinfo.h>
 #include <asm/cpu.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/debugreg.h>
 #include <asm/delay.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index a3b55db35c96..cc5a390dcd07 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -5,6 +5,7 @@
 
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/e820/api.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 2154f12766fb..75ad7eb1301a 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -10,6 +10,7 @@
 
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/cpuid/api.h>
 #include <asm/smp.h>
 #include <asm/numa.h>
 #include <asm/cacheinfo.h>
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 5a11c522ea97..31ff1c578b40 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -47,6 +47,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/fred.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index d02c4f556cd0..42c82c14c48a 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -26,6 +26,7 @@
 
 #include <asm/amd/nb.h>
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/irq_vectors.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index fc62ebf96f01..f19ac3247c19 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -34,6 +34,7 @@
 
 #include <asm/cmdline.h>
 #include <asm/cpu.h>
+#include <asm/cpuid/api.h>
 #include <asm/microcode.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 9243ed3ded85..eae9eaa455ba 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -35,6 +35,7 @@
 #include <asm/apic.h>
 #include <asm/cmdline.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/perf_event.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 99fda8f7dba7..30d20f78f07d 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -23,6 +23,7 @@
 #include <linux/uio.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index d0491bba9e30..771a65e6fefb 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -22,6 +22,7 @@
 #include <hyperv/hvhdk.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/desc.h>
 #include <asm/hypervisor.h>
 #include <asm/i8259.h>
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 35285567beec..52d3753ab020 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/resctrl.h>
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index c261558276cd..5dffb9453d77 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -21,6 +21,7 @@
 #include <linux/resctrl.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "internal.h"
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b52d00e8ad54..99c052f1962a 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -5,6 +5,7 @@
 #include <linux/cpu.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/memtype.h>
 #include <asm/processor.h>
 
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7f8d1e11dbee..f0c0a001bce6 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -6,7 +6,10 @@
 #include <linux/mman.h>
 #include <linux/security.h>
 #include <linux/suspend.h>
+
+#include <asm/cpuid/api.h>
 #include <asm/traps.h>
+
 #include "driver.h"
 #include "encl.h"
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2de01b379aa3..00bf42f4c536 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -14,8 +14,11 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/vmalloc.h>
+
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/sgx.h>
+
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 843b1655ab45..abc6f5a7a486 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/memtype.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/cpu/topology_common.c b/arch/x86/kernel/cpu/topology_common.c
index 48c47d02d8a9..38189e4fea0e 100644
--- a/arch/x86/kernel/cpu/topology_common.c
+++ b/arch/x86/kernel/cpu/topology_common.c
@@ -4,6 +4,7 @@
 #include <xen/xen.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
diff --git a/arch/x86/kernel/cpu/topology_ext.c b/arch/x86/kernel/cpu/topology_ext.c
index 467b0326bf1a..eb915c73895f 100644
--- a/arch/x86/kernel/cpu/topology_ext.c
+++ b/arch/x86/kernel/cpu/topology_ext.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/memtype.h>
 #include <asm/processor.h>
 
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 42c939827621..1fdcd69c625c 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -3,8 +3,11 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 #include <linux/mm.h>
+
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
+
 #include "cpu.h"
 
 static void early_init_transmeta(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index f5e82d15d0b1..e6f80f5e59a3 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -31,6 +31,7 @@
 #include <linux/static_call.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/div64.h>
 #include <asm/hypervisor.h>
 #include <asm/svm.h>
diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
index 89b1c8a70fe8..cfcfb6221e3f 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -4,6 +4,7 @@
 
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index dae436253de4..cbd04b677fd1 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -37,6 +37,7 @@
 #include <linux/gfp.h>
 #include <linux/completion.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 
diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
index f38d4516f7e7..787128e63f32 100644
--- a/arch/x86/kernel/jailhouse.c
+++ b/arch/x86/kernel/jailhouse.c
@@ -17,6 +17,7 @@
 #include <asm/acpi.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/cpuid/api.h>
 #include <asm/hypervisor.h>
 #include <asm/i8259.h>
 #include <asm/io_apic.h>
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index cd3520a6248b..ddeea40273ed 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -33,6 +33,7 @@
 #include <asm/apic.h>
 #include <asm/apicdef.h>
 #include <asm/cpu.h>
+#include <asm/cpuid/api.h>
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/desc.h>
 #include <asm/e820/api.h>
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 3d745cd25a43..b7fc3b78086c 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -18,6 +18,7 @@
 
 #include <asm/apic.h>
 #include <asm/bug.h>
+#include <asm/cpuid/api.h>
 #include <asm/debugreg.h>
 #include <asm/delay.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 08bd094f2945..41958178c7d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -37,6 +37,7 @@
 #include <linux/wordpart.h>
 
 #include <asm/cmpxchg.h>
+#include <asm/cpuid/api.h>
 #include <asm/io.h>
 #include <asm/memtype.h>
 #include <asm/page.h>
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cfce03d8f123..e7b69275ae50 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -15,6 +15,7 @@
 #include "x86.h"
 #include "spte.h"
 
+#include <asm/cpuid/api.h>
 #include <asm/e820/api.h>
 #include <asm/memtype.h>
 #include <asm/vmx.h>
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index c53b92379e6e..77bdc3fe3fc5 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -3,8 +3,10 @@
 #define ARCH_X86_KVM_REVERSE_CPUID_H
 
 #include <uapi/asm/kvm.h>
+
 #include <asm/cpufeature.h>
 #include <asm/cpufeatures.h>
+#include <asm/cpuid/types.h>
 
 /*
  * Define a KVM-only feature flag.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d64392bc0228..eb2aca272268 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 
 #include <uapi/linux/sev-guest.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/debugreg.h>
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d8504af36836..42b21d01fe02 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -33,6 +33,7 @@
 
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 64208fe5aa96..66d9701acf39 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -14,6 +14,7 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/perf_event.h>
 
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index f70128063bd5..1d2c38e0c66f 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -2,6 +2,7 @@
 /*  Copyright(c) 2021 Intel Corporation. */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/sgx.h>
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2bf9d4326a19..37e49693165e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -34,6 +34,7 @@
 #include <asm/asm.h>
 #include <asm/cpu.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index 9d5d57a84a3c..277cfb9ead67 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -32,6 +32,7 @@
 
 #include <asm/cmdline.h>
 #include <asm/cpufeature.h>
+#include <asm/cpuid/api.h>
 #include <asm/desc.h>
 #include <asm/hypervisor.h>
 #include <asm/pti.h>
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index e23c7f730f07..dd0e259a2882 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -23,6 +23,7 @@
 
 #include <asm/acpi.h>
 #include <asm/apic.h>
+#include <asm/cpuid/api.h>
 #include <asm/i8259.h>
 #include <asm/io_apic.h>
 #include <asm/pci_x86.h>
diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index 6b736b18826b..25060b139bad 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -14,6 +14,7 @@
 
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/cpuid/api.h>
 #include <asm/e820/api.h>
 #include <asm/early_ioremap.h>
 #include <asm/hypervisor.h>
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index fae48c14ec45..681a8db58868 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -9,6 +9,7 @@
 #include <xen/page.h>
 #include <xen/xen.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/xen/hypercall.h>
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 229f8161eeab..65826ff26d7d 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -23,6 +23,7 @@
 #include <xen/interface/vcpu.h>
 #include <xen/interface/xen.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/pvclock.h>
 
 #include <asm/xen/cpuid.h>
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 79f956d7b17d..4ae44878119b 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -28,6 +28,8 @@
 #include <linux/page-flags.h>
 #include <linux/pci.h>
 
+#include <asm/cpuid/api.h>
+
 #include "agp.h"
 #include "intel-agp.h"
 
diff --git a/drivers/cpufreq/longrun.c b/drivers/cpufreq/longrun.c
index 263c48b8f628..3429857feb96 100644
--- a/drivers/cpufreq/longrun.c
+++ b/drivers/cpufreq/longrun.c
@@ -12,6 +12,7 @@
 #include <linux/timex.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 0608040fcd1e..7a324a829a43 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -27,6 +27,7 @@
 #include <linux/timex.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/timer.h>		/* Needed for recalibrate_cpu_khz() */
 
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 2b5cdd8f1c0a..e909eee30edd 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -41,6 +41,7 @@
 
 #include <asm/msr.h>
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 
 #include <acpi/processor.h>
 
diff --git a/drivers/cpufreq/speedstep-lib.c b/drivers/cpufreq/speedstep-lib.c
index f08817331aec..3c323cd8eede 100644
--- a/drivers/cpufreq/speedstep-lib.c
+++ b/drivers/cpufreq/speedstep-lib.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/tsc.h>
 
diff --git a/drivers/firmware/efi/libstub/x86-5lvl.c b/drivers/firmware/efi/libstub/x86-5lvl.c
index f1c5fb45d5f7..029ad80cf0b4 100644
--- a/drivers/firmware/efi/libstub/x86-5lvl.c
+++ b/drivers/firmware/efi/libstub/x86-5lvl.c
@@ -2,6 +2,7 @@
 #include <linux/efi.h>
 
 #include <asm/boot.h>
+#include <asm/cpuid/api.h>
 #include <asm/desc.h>
 #include <asm/efi.h>
 
diff --git a/drivers/gpu/drm/gma500/mmu.c b/drivers/gpu/drm/gma500/mmu.c
index e6753282e70e..4d2aba31a78c 100644
--- a/drivers/gpu/drm/gma500/mmu.c
+++ b/drivers/gpu/drm/gma500/mmu.c
@@ -7,6 +7,8 @@
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
 
+#include <asm/cpuid/api.h>
+
 #include "mmu.h"
 #include "psb_drv.h"
 #include "psb_reg.h"
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 5a5674e85f63..1ecaef25f04e 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/topology.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
 
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index babf2413d666..12115654689a 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -20,7 +20,9 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+
 #include <asm/amd/node.h>
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 
 MODULE_DESCRIPTION("AMD Family 10h+ CPU core temperature monitor");
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 8c1efce9a04b..eb167be245b9 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -15,6 +15,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/processor.h>
 
 #define TEMP_FROM_REG(val)	(((((val) >> 16) & 0xff) - 49) * 1000)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 444ee53566c4..f63d66a27ffe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -7,6 +7,8 @@
 #include <linux/pci.h>
 #include <linux/platform_data/x86/intel_pmc_ipc.h>
 
+#include <asm/cpuid/api.h>
+
 #include "dwmac-intel.h"
 #include "dwmac4.h"
 #include "stmmac.h"
diff --git a/drivers/ras/amd/fmpm.c b/drivers/ras/amd/fmpm.c
index 775c5231be57..f9723051477c 100644
--- a/drivers/ras/amd/fmpm.c
+++ b/drivers/ras/amd/fmpm.c
@@ -52,6 +52,7 @@
 #include <acpi/apei.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/mce.h>
 
 #include "../debugfs.h"
diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index bd2fca7dc017..c910cc563d9d 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -41,6 +41,7 @@
 #include <linux/topology.h>
 #include <linux/workqueue.h>
 
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "intel_hfi.h"
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index c843cb5fc5c3..1b9e0b49856c 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -20,6 +20,7 @@
 #include <linux/thermal.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/cpuid/api.h>
 #include <asm/msr.h>
 
 #include "thermal_interrupt.h"
diff --git a/drivers/virt/acrn/hsm.c b/drivers/virt/acrn/hsm.c
index e4e196abdaac..67119f9da449 100644
--- a/drivers/virt/acrn/hsm.c
+++ b/drivers/virt/acrn/hsm.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 
 #include <asm/acrn.h>
+#include <asm/cpuid/api.h>
 #include <asm/hypervisor.h>
 
 #include "acrn_drv.h"
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 727a78bfdf02..e07c36c337fa 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -40,6 +40,7 @@
 #include <linux/string.h>
 
 #ifdef CONFIG_X86
+#include <asm/cpuid/api.h>
 #include <asm/desc.h>
 #include <asm/i8259.h>
 #include <asm/idtentry.h>
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index a9ff69f08eb8..68ff1d6ff7bd 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -59,6 +59,7 @@
 #include <xen/swiotlb-xen.h>
 #include <xen/balloon.h>
 #ifdef CONFIG_X86
+#include <asm/cpuid/api.h>
 #include <asm/xen/cpuid.h>
 #endif
 #include <xen/mem-reservation.h>
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 589585b05f8a..74d1d76426c3 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -48,6 +48,9 @@
 #include <linux/unistd.h>
 
 #include <asm/xen/hypervisor.h>
+#ifdef CONFIG_X86
+#include <asm/cpuid/api.h>
+#endif
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
-- 
2.50.1


