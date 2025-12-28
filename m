Return-Path: <kvm+bounces-66748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DBCA9CE596C
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8C17F30087AC
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1906C2E5B09;
	Sun, 28 Dec 2025 23:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Sj69bmSr"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster1-host6-snip4-8.eps.apple.com [57.103.64.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4C02E542A
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.64.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966264; cv=none; b=kwP9pmWurYPbV1ymLpPSoFCsOywIT20Hy3Fyf/jZMdFOozUy0Umx5HQ2htdXZ1085GtPssOuQKtO5Zy6Hq7ahJCMyiyO3BabIKG6NmQuFwr2ObwZ74uv83Jknbi6EZvDkUGV3iGbxpyvuo9r6/fF4qWP9yu2pdcn2DSkw55hMK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966264; c=relaxed/simple;
	bh=NG0rxUD1VGkf2NkCUGcHubk6BjdwaRXst5Fgo5vGXy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+/3/6GMYa+wfLFxS/1klKaE7WGBqcR+RrAK/26Ajb2AL6lwNO4uyoxTaVyTE7z4/vTorgtfydH2C0cELyFuXLRw0vxzL+yQv4wNPgP6rXYxo1lWxY9iXdaeH8K7EQ5VrOiYNdfXzOxCgseWNC1TyTWRQ+T0lLeEbCuwjWUFOBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Sj69bmSr; arc=none smtp.client-ip=57.103.64.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 96ECB180075D;
	Sun, 28 Dec 2025 23:57:39 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=Xai/iIFmYKBh9hXKXoLHcpMWSKlCLXcV6orHyLZTCZs=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Sj69bmSrTZF/YFa/O6RzatDPKNLgTczCtf/cCMdahMn422FzeT5WM5YbdH9AdTFQgm3J05TP5mfbl+lRGcY6r91FSuarwA8aJTyQf34G9/NGLJlo/jOaURjwJIPd5KaFpqsvOnbnI+2Q8fIObHNcRhA3GOwlU/iuiMveYPmnWYKoIp/g4mJfCS7cPQu/I9njB+fEJXWaFOsi2v/ipbkN/+oYevCWJ1uFBT4D2m7LKwp+7ijpuoJdgRhflv3WjxaaXVRPzUwrxEN7iLhG3ay1jXs+8asawMU0eZOmbIwrJp7JlM06weHpHJn22zszSrJS8jO7Hz4IMkhbPuKdVuwEyg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 412C1180074E;
	Sun, 28 Dec 2025 23:57:32 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org,
	mohamed@unpredictable.fr
Cc: Alexander Graf <agraf@csgraf.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	qemu-arm@nongnu.org,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Cameron Esfahani <dirty@apple.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v12 19/28] whpx: arm64: clamp down IPA size
Date: Mon, 29 Dec 2025 00:54:13 +0100
Message-ID: <20251228235422.30383-20-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251228235422.30383-1-mohamed@unpredictable.fr>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfXx6GCwqRWM582
 P7rNkkh1hi0QRBgGxB11+wRbfXvdE0zkoBPL2Mbw76faYVVU8RqbyCWd0LQrsom63b8O/VXjxbd
 1ltDiq1tLHoPctmhW2xq36N3SPSmQYyfeuEYvGwgLxQQ71NafOYDrffAu7sAGcMd8c7tpesva0y
 /4fJLamW39FIopA9/LTaTftvXT1KEqVJzPmEfrqA8TYDpBSSwGlaqxfUxW226DrXdbLgPW515/c
 G6pr0OYsLglYcegiSsvsNSElcB3CwhzmfQTn8UkuFGqKg4+xtrZV2TUVghwPSLUi16SWMgTjWcZ
 MCjAmC3R9YcZ2KTSLYd
X-Authority-Info: v=2.4 cv=csSWUl4i c=1 sm=1 tr=0 ts=6951c3f5 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8
 a=wAo57kR77d7e8uaIccUA:9 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: qVC9zRCCJ3wB6rhM_Rrtg5d1rFPSRVOO
X-Proofpoint-ORIG-GUID: qVC9zRCCJ3wB6rhM_Rrtg5d1rFPSRVOO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 clxscore=1030 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 classifier=spam authscore=0
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512280223
X-JNJ: AAAAAAABIK6e4Q6bfEs/s6vOTAVqS/YzKYs5/Twa3MAHyPAc7qLn+B05RYm2qHIJtUTEh7wbx9QqFVGpyNH0lfKiIkg24QZ+iDfM5uzDEqOm59HnwAsC7syB6haVZdbjV1+shrLsHQZ9tClhsSif2fsH5+s11PkcDJMYmip+aSZ6biEio3TqSTf2QGyYpdEYENAMcuaqT3Xu4RCIRNBtM389bDp6ANvajZV3kZzaHeVgqK8aZVz3S2cJlgdV/2zeGEEkor6dKkk0maSN6DT2MRXpNwXQgtv93qzxvnFc99dIdpbhOjX6zmhM0WkcYcVctTdlcuZq95sRgHWw6K0Xuoym5adt+svL2eLBXiWLRFeMNGwP4KmC+wloIjt8YFRGarlcfK7XYJ6bXxI7Kl2LHXjXTp1J/ftMShmfDFI1RPXXpH7ImBnjLZl6a9ppZl4Qi87j76ZRce1unUk0nlXUMCwt/kINtzGFn01VTpaPoTactM/piC/i8YoNC+O5KjvsgI+qZVZ2RLshheZpJMjaUl51xcLQr03kXpzBmrgng4bkUoc8iM+o6nnNITC454g6uMUm4TEpMH/lfpjhLh7qFcR41O1WqZU0y0NKbxHpo4bI5ZjFAJYx+y0ibdexyB3UY2MwCthsoqShP6Wm0lF40QA2OiaC+miCR/LOeNkf4YrubWktZwtW7fdJ6BC8IRhtkZ9meV9yTNetUHOpFhcRSP4XVtJPQ32OIBR05YJvjlKjKp6qQ8vqee1boxlrkj1MBOY0YER2UP+KGKtpZhJ3I8j/bbHpdyKDvHVLgCgnWuDRKLbaXsDAh/NNAM+OcI1xgmcs5ku5QwMvZ7C2Gs07fITVVpx8hmbdB37J1/PNoHT2q4f1/zFJidJfwyKDmA647gh/e1mjZP6/YgV2s5MLE3nUIUzxH9XNOq1nYFmIAGtAt/keIccRtR+MeEu+0FTA5Ho=

Code taken from HVF and adapted for WHPX use. Note that WHPX doesn't
have a default vs maximum IPA distinction.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/virt.c               | 32 ++++++++++++++++++++++++++
 include/hw/core/boards.h    |  1 +
 target/arm/whpx/meson.build |  2 ++
 target/arm/whpx/whpx-all.c  | 45 +++++++++++++++++++++++++++++++++++++
 target/arm/whpx/whpx-stub.c | 15 +++++++++++++
 target/arm/whpx_arm.h       | 16 +++++++++++++
 6 files changed, 111 insertions(+)
 create mode 100644 target/arm/whpx/whpx-stub.c
 create mode 100644 target/arm/whpx_arm.h

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index e0f1727502..5b0be2f8c3 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -72,6 +72,7 @@
 #include "hw/core/irq.h"
 #include "kvm_arm.h"
 #include "hvf_arm.h"
+#include "whpx_arm.h"
 #include "hw/firmware/smbios.h"
 #include "qapi/visitor.h"
 #include "qapi/qapi-visit-common.h"
@@ -3315,6 +3316,36 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
     return fixed_ipa ? 0 : requested_pa_size;
 }
 
+static int virt_whpx_get_physical_address_range(MachineState *ms)
+{
+    VirtMachineState *vms = VIRT_MACHINE(ms);
+
+    int max_ipa_size = whpx_arm_get_ipa_bit_size();
+
+    /* We freeze the memory map to compute the highest gpa */
+    virt_set_memmap(vms, max_ipa_size);
+
+    int requested_ipa_size = 64 - clz64(vms->highest_gpa);
+
+    /*
+     * If we're <= the default IPA size just use the default.
+     * If we're above the default but below the maximum, round up to
+     * the maximum. hvf_arm_get_max_ipa_bit_size() conveniently only
+     * returns values that are valid ARM PARange values.
+     */
+    if (requested_ipa_size <= max_ipa_size) {
+        requested_ipa_size = max_ipa_size;
+    } else {
+        error_report("-m and ,maxmem option values "
+                     "require an IPA range (%d bits) larger than "
+                     "the one supported by the host (%d bits)",
+                     requested_ipa_size, max_ipa_size);
+        return -1;
+    }
+
+    return requested_ipa_size;
+}
+
 static int virt_hvf_get_physical_address_range(MachineState *ms)
 {
     VirtMachineState *vms = VIRT_MACHINE(ms);
@@ -3414,6 +3445,7 @@ static void virt_machine_class_init(ObjectClass *oc, const void *data)
     mc->get_default_cpu_node_id = virt_get_default_cpu_node_id;
     mc->kvm_type = virt_kvm_type;
     mc->hvf_get_physical_address_range = virt_hvf_get_physical_address_range;
+    mc->whpx_get_physical_address_range = virt_whpx_get_physical_address_range;
     assert(!mc->get_hotplug_handler);
     mc->get_hotplug_handler = virt_machine_get_hotplug_handler;
     hc->pre_plug = virt_machine_device_pre_plug_cb;
diff --git a/include/hw/core/boards.h b/include/hw/core/boards.h
index 815845207b..0dd9ef2613 100644
--- a/include/hw/core/boards.h
+++ b/include/hw/core/boards.h
@@ -278,6 +278,7 @@ struct MachineClass {
     void (*wakeup)(MachineState *state);
     int (*kvm_type)(MachineState *machine, const char *arg);
     int (*hvf_get_physical_address_range)(MachineState *machine);
+    int (*whpx_get_physical_address_range)(MachineState *machine);
 
     BlockInterfaceType block_default_type;
     int units_per_default_bus;
diff --git a/target/arm/whpx/meson.build b/target/arm/whpx/meson.build
index 1de2ef0283..3df632c9d3 100644
--- a/target/arm/whpx/meson.build
+++ b/target/arm/whpx/meson.build
@@ -1,3 +1,5 @@
 arm_system_ss.add(when: 'CONFIG_WHPX', if_true: files(
   'whpx-all.c',
 ))
+
+arm_common_system_ss.add(when: 'CONFIG_WHPX', if_false: files('whpx-stub.c'))
diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
index 75b82be4e7..fe58217e46 100644
--- a/target/arm/whpx/whpx-all.c
+++ b/target/arm/whpx/whpx-all.c
@@ -35,6 +35,7 @@
 #include "system/whpx-accel-ops.h"
 #include "system/whpx-all.h"
 #include "system/whpx-common.h"
+#include "whpx_arm.h"
 #include "hw/arm/bsa.h"
 #include "arm-powerctl.h"
 
@@ -657,6 +658,40 @@ static void whpx_cpu_update_state(void *opaque, bool running, RunState state)
 {
 }
 
+uint32_t whpx_arm_get_ipa_bit_size(void)
+{
+    WHV_CAPABILITY whpx_cap;
+    UINT32 whpx_cap_size;
+    HRESULT hr;
+    hr = whp_dispatch.WHvGetCapability(
+        WHvCapabilityCodePhysicalAddressWidth, &whpx_cap,
+        sizeof(whpx_cap), &whpx_cap_size);
+    if (FAILED(hr)) {
+        error_report("WHPX: failed to get supported"
+             "physical address width, hr=%08lx", hr);
+    }
+
+    /*
+     * We clamp any IPA size we want to back the VM with to a valid PARange
+     * value so the guest doesn't try and map memory outside of the valid range.
+     * This logic just clamps the passed in IPA bit size to the first valid
+     * PARange value <= to it.
+     */
+    return round_down_to_parange_bit_size(whpx_cap.PhysicalAddressWidth);
+}
+
+static void clamp_id_aa64mmfr0_parange_to_ipa_size(ARMISARegisters *isar)
+{
+    uint32_t ipa_size = whpx_arm_get_ipa_bit_size();
+    uint64_t id_aa64mmfr0;
+
+    /* Clamp down the PARange to the IPA size the kernel supports. */
+    uint8_t index = round_down_to_parange_index(ipa_size);
+    id_aa64mmfr0 = GET_IDREG(isar, ID_AA64MMFR0);
+    id_aa64mmfr0 = (id_aa64mmfr0 & ~R_ID_AA64MMFR0_PARANGE_MASK) | index;
+    SET_IDREG(isar, ID_AA64MMFR0, id_aa64mmfr0);
+}
+
 int whpx_init_vcpu(CPUState *cpu)
 {
     HRESULT hr;
@@ -735,6 +770,7 @@ int whpx_init_vcpu(CPUState *cpu)
     val.Reg64 = deposit64(arm_cpu->mp_affinity, 31, 1, 1 /* RES1 */);
     whpx_set_reg(cpu, WHvArm64RegisterMpidrEl1, val);
 
+    clamp_id_aa64mmfr0_parange_to_ipa_size(&arm_cpu->isar);
     return 0;
 
 error:
@@ -757,6 +793,8 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
     UINT32 whpx_cap_size;
     WHV_PARTITION_PROPERTY prop;
     WHV_CAPABILITY_FEATURES features = {0};
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+    int pa_range = 0;
 
     whpx = &whpx_global;
     /* on arm64 Windows Hypervisor Platform, vGICv3 always used */
@@ -767,6 +805,13 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
         goto error;
     }
 
+    if (mc->whpx_get_physical_address_range) {
+        pa_range = mc->whpx_get_physical_address_range(ms);
+        if (pa_range < 0) {
+            return -EINVAL;
+        }
+    }
+
     whpx->mem_quota = ms->ram_size;
 
     hr = whp_dispatch.WHvGetCapability(
diff --git a/target/arm/whpx/whpx-stub.c b/target/arm/whpx/whpx-stub.c
new file mode 100644
index 0000000000..32e434a5f6
--- /dev/null
+++ b/target/arm/whpx/whpx-stub.c
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * WHPX stubs for ARM
+ *
+ *  Copyright (c) 2025 Mohamed Mediouni
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "whpx_arm.h"
+
+uint32_t whpx_arm_get_ipa_bit_size(void)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/whpx_arm.h b/target/arm/whpx_arm.h
new file mode 100644
index 0000000000..de7406b66f
--- /dev/null
+++ b/target/arm/whpx_arm.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * WHPX support -- ARM specifics
+ *
+ * Copyright (c) 2025 Mohamed Mediouni
+ *
+ */
+
+#ifndef QEMU_WHPX_ARM_H
+#define QEMU_WHPX_ARM_H
+
+#include "target/arm/cpu-qom.h"
+
+uint32_t whpx_arm_get_ipa_bit_size(void);
+
+#endif
-- 
2.50.1 (Apple Git-155)


