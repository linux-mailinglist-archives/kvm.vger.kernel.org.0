Return-Path: <kvm+bounces-66749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1392CE5978
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 55D0830049FB
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC862E62A4;
	Sun, 28 Dec 2025 23:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="RhDkyWYv"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster5-host2-snip4-10.eps.apple.com [57.103.66.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829CC2E3B15
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966272; cv=none; b=PddxVkdRfVDvaZnDMn1qNR4guHNUYszQGbLWUOK6vzGPjdynh9dBcklScEKtBoj5LroreZ913xw1RDGf/fjMpailwpRur00UojZbWj5+ASBezpgaF2hYfImkPY5qLCZNu7oInFTsDt6mVXknVHq69XeZA+gM5J0sncCqRgmls90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966272; c=relaxed/simple;
	bh=jCagiVcXQri/fpFa/QgKuQx1d5KRd+3TyCYOT7DIfPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ec491NyF7StQrHGxWbz4YJTT1tjrZf7uPh0U22JzKxhK2/vUdPUFDz+M7iUkLdhJ/ptmmnGs6Oy3xVrb9n2VJzAB9ye0IJKCTdnzJoC/Xn2C3Pkk4P4kwSbtkw8KAnWkfLt2sAcHMYfD0bjfBbUJbufmOik4gpa1o6aDzvCiplo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=RhDkyWYv; arc=none smtp.client-ip=57.103.66.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 6BD471800761;
	Sun, 28 Dec 2025 23:57:45 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=ar6KdLnhF85DQ3W9aVt7iHNkUUlK4hdsg8ONf+fKyGM=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=RhDkyWYvJIo6v+1Lq7DhMqVsreaIKscQqcaz2F1kVJ1E3WBiQmC4a2nW9PSQ2Y+Y2fjYq/5wTfRahUhpj3GFUcrCKEOhoyNkUGCQh6M9L+Qkz1DDBxWEgQbaN4pbv0UTbdY6/6i3utGDv8pQuY2GDmF88P9kY5ZIIGYSRGzSbfAtiq5lOarjmzLV+tx1S4A2l3uHQXWKhfl6IdR9AOWnyBi6Mu9NhXBNJG2qJfBMkmrwfpe7eVww8ikn7d11aSk+WoND8lZ8XPrQuoeOhYPcj7WEHR83thLaiOOf4oot92LD99cZeK1y1c3sw//fYPuFWWidltD96rCD5tFHzUIapw==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 8F0141800754;
	Sun, 28 Dec 2025 23:57:39 +0000 (UTC)
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
Subject: [PATCH v12 20/28] hw/arm, accel/hvf, whpx: unify get_physical_address_range between WHPX and HVF
Date: Mon, 29 Dec 2025 00:54:14 +0100
Message-ID: <20251228235422.30383-21-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX3XJzdr0bG9bq
 Sg9SJvknKsa+Yg56eK0ygrONOTavho80VEJc7CzPpK5t58ovE8filF4T/Gw+rEXThbvymNrwNBH
 dDmdqdiHJhpSHmss06cfFSoIFGdQgQT2v27+2fcMAepFwDZZxdiCQNAqSnmgd7xUP0AixDeI62Y
 fa8rwB02eIG2HKibTxkqU04UJ2BqcwbcBRf2NjZCi9OTBjR2DbkNV0eKXtIpVXSVNSv/Cuz1fT8
 kM9xzAPBQLfEUN1uk9D280xbl3UKBeeel3ImHt1kzNgVHyU7sbaudS9xT1iK32FNWxK/sySdK2w
 yB5fiRaRTwOt0SLa8sy
X-Proofpoint-GUID: -aZWOS2rWHXmIFCyZ7NxtqBbh7qiLB3k
X-Authority-Info: v=2.4 cv=d+b4CBjE c=1 sm=1 tr=0 ts=6951c3fc cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8
 a=8f9Dc39nvweVu8kgsNkA:9 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: -aZWOS2rWHXmIFCyZ7NxtqBbh7qiLB3k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1030
 adultscore=0 phishscore=0 mlxlogscore=999 classifier=spam authscore=0
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512280223
X-JNJ: AAAAAAABogYH7e2cLC9URDV4aKLFO1j+iD2mJNLUl+6E8ebFHZ905kow03NdpizfyKHfPnCZ7ppkIWifhKJ/RojOBQT5cuNmqUPlupCukhQChJ56z5M2iewlaOYk4RqjY11iDS06JjDperu3vPUnQHxDSON/w2R0KGGOBA+McnfQnLOl1nN38v+WjNxxdlbpeAqYICEKY+h8JVy+9vbI0pmF7EmiqKLlc2If/6mlmaL1Mg2xzoQYGYTWhmZ0sf+3ixd7F0cyhkjg7iuQFESOIPf6T5Y8PcDJjIFWy+iZ5s/dDipO/M6b/KQePXE3wEkK9OrbpX8kvIkP1hcl7k4L6fpEvJc+LI3PYsYreEFdxFvXIV3ynxU9DIR7gg4yGqmOcuIIa+VRNLnz1wM9XbO53YNwaZlqkFIalG6uCfZTqptNPqvgt+GuPafJJF4MEF+AYCZ0+woWEseO6HD9Og9GPlEYpU9aeIXA/+WUKVB1IO2Y/+R5ZusAQD5LttOhFqS67DsMPuNDMwlfQdhx4vRFTlFMgikHcsyMx45QgbTdsl1KwIqdML+Tt1Cb1f28QuaPBMnNNPWXHminTb0OIJpYoIyCmj+0gWQ1Vn2V48x04Si/YWr4hLJW+Hi10i3uXDcSMbwaID7oB1tBoIK9XBp9aLCAJs77rXnyAUAWqTud19P/hUJXyLqTf3P60G7omJEHCHPIhfnIiyjHv5DggGhfR9LG5emwePYE7oysDKrUYLntIBNpBPwlv5iwf9nypGv3tlUyloqHfu1gEEBnAlUxNuKLCXfRFbZaki9uL5z7m72pz8RBPcGFsFJIZ/RglCu01nxgXyR9u7FsbkVWSgcY0xy7olZNOlXOoUl2Po01WUNsFA0xzOYuu2kGGJrFXWcXQYtpLNtyEqc9KOIJxH5Bh2lsaYObLvu5UOvPeng0e+6UUtgvLxK9E0orqlFZBjG+/7MQl4u3HpLWZjzRZ5LwHBbn2VrHe31
 72Tg3wZY1cjHZfoA=

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/hvf/hvf-all.c        |  7 +++++--
 hw/arm/virt.c              | 41 ++++----------------------------------
 include/hw/core/boards.h   |  4 ++--
 include/system/hvf_int.h   |  5 +++++
 target/arm/hvf-stub.c      | 20 -------------------
 target/arm/hvf/hvf.c       |  6 +++---
 target/arm/hvf_arm.h       |  3 ---
 target/arm/meson.build     |  1 -
 target/arm/whpx/whpx-all.c |  5 +++--
 target/i386/hvf/hvf.c      | 11 ++++++++++
 10 files changed, 33 insertions(+), 70 deletions(-)
 delete mode 100644 target/arm/hvf-stub.c

diff --git a/accel/hvf/hvf-all.c b/accel/hvf/hvf-all.c
index 77f4e4e4f3..ce18bc0dac 100644
--- a/accel/hvf/hvf-all.c
+++ b/accel/hvf/hvf-all.c
@@ -17,6 +17,7 @@
 #include "system/hvf_int.h"
 #include "hw/core/cpu.h"
 #include "hw/core/boards.h"
+#include "target/arm/hvf_arm.h"
 #include "trace.h"
 
 bool hvf_allowed;
@@ -256,8 +257,10 @@ static int hvf_accel_init(AccelState *as, MachineState *ms)
     int pa_range = 36;
     MachineClass *mc = MACHINE_GET_CLASS(ms);
 
-    if (mc->hvf_get_physical_address_range) {
-        pa_range = mc->hvf_get_physical_address_range(ms);
+
+    if (mc->get_physical_address_range) {
+        pa_range = mc->get_physical_address_range(ms,
+            hvf_arch_get_default_ipa_bit_size(), hvf_arch_get_max_ipa_bit_size());
         if (pa_range < 0) {
             return -EINVAL;
         }
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 5b0be2f8c3..018366482b 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -3316,43 +3316,11 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
     return fixed_ipa ? 0 : requested_pa_size;
 }
 
-static int virt_whpx_get_physical_address_range(MachineState *ms)
+static int virt_get_physical_address_range(MachineState *ms,
+    int default_ipa_size, int max_ipa_size)
 {
     VirtMachineState *vms = VIRT_MACHINE(ms);
 
-    int max_ipa_size = whpx_arm_get_ipa_bit_size();
-
-    /* We freeze the memory map to compute the highest gpa */
-    virt_set_memmap(vms, max_ipa_size);
-
-    int requested_ipa_size = 64 - clz64(vms->highest_gpa);
-
-    /*
-     * If we're <= the default IPA size just use the default.
-     * If we're above the default but below the maximum, round up to
-     * the maximum. hvf_arm_get_max_ipa_bit_size() conveniently only
-     * returns values that are valid ARM PARange values.
-     */
-    if (requested_ipa_size <= max_ipa_size) {
-        requested_ipa_size = max_ipa_size;
-    } else {
-        error_report("-m and ,maxmem option values "
-                     "require an IPA range (%d bits) larger than "
-                     "the one supported by the host (%d bits)",
-                     requested_ipa_size, max_ipa_size);
-        return -1;
-    }
-
-    return requested_ipa_size;
-}
-
-static int virt_hvf_get_physical_address_range(MachineState *ms)
-{
-    VirtMachineState *vms = VIRT_MACHINE(ms);
-
-    int default_ipa_size = hvf_arm_get_default_ipa_bit_size();
-    int max_ipa_size = hvf_arm_get_max_ipa_bit_size();
-
     /* We freeze the memory map to compute the highest gpa */
     virt_set_memmap(vms, max_ipa_size);
 
@@ -3361,7 +3329,7 @@ static int virt_hvf_get_physical_address_range(MachineState *ms)
     /*
      * If we're <= the default IPA size just use the default.
      * If we're above the default but below the maximum, round up to
-     * the maximum. hvf_arm_get_max_ipa_bit_size() conveniently only
+     * the maximum. hvf_arch_get_max_ipa_bit_size() conveniently only
      * returns values that are valid ARM PARange values.
      */
     if (requested_ipa_size <= default_ipa_size) {
@@ -3444,8 +3412,7 @@ static void virt_machine_class_init(ObjectClass *oc, const void *data)
     mc->get_valid_cpu_types = virt_get_valid_cpu_types;
     mc->get_default_cpu_node_id = virt_get_default_cpu_node_id;
     mc->kvm_type = virt_kvm_type;
-    mc->hvf_get_physical_address_range = virt_hvf_get_physical_address_range;
-    mc->whpx_get_physical_address_range = virt_whpx_get_physical_address_range;
+    mc->get_physical_address_range = virt_get_physical_address_range;
     assert(!mc->get_hotplug_handler);
     mc->get_hotplug_handler = virt_machine_get_hotplug_handler;
     hc->pre_plug = virt_machine_device_pre_plug_cb;
diff --git a/include/hw/core/boards.h b/include/hw/core/boards.h
index 0dd9ef2613..f4e574749a 100644
--- a/include/hw/core/boards.h
+++ b/include/hw/core/boards.h
@@ -277,8 +277,8 @@ struct MachineClass {
     void (*reset)(MachineState *state, ResetType type);
     void (*wakeup)(MachineState *state);
     int (*kvm_type)(MachineState *machine, const char *arg);
-    int (*hvf_get_physical_address_range)(MachineState *machine);
-    int (*whpx_get_physical_address_range)(MachineState *machine);
+    int (*get_physical_address_range)(MachineState *machine,
+        int default_ipa_size, int max_ipa_size);
 
     BlockInterfaceType block_default_type;
     int units_per_default_bus;
diff --git a/include/system/hvf_int.h b/include/system/hvf_int.h
index 3d2be4092e..cecd4617d2 100644
--- a/include/system/hvf_int.h
+++ b/include/system/hvf_int.h
@@ -73,6 +73,8 @@ void assert_hvf_ok_impl(hv_return_t ret, const char *file, unsigned int line,
 const char *hvf_return_string(hv_return_t ret);
 int hvf_arch_init(void);
 hv_return_t hvf_arch_vm_create(MachineState *ms, uint32_t pa_range);
+uint32_t hvf_arch_get_default_ipa_bit_size(void);
+uint32_t hvf_arch_get_max_ipa_bit_size(void);
 hvf_slot *hvf_find_overlap_slot(uint64_t, uint64_t);
 void hvf_kick_vcpu_thread(CPUState *cpu);
 
@@ -120,4 +122,7 @@ int hvf_update_guest_debug(CPUState *cpu);
  */
 bool hvf_arch_supports_guest_debug(void);
 
+uint32_t hvf_arch_get_default_ipa_bit_size(void);
+uint32_t hvf_arch_get_max_ipa_bit_size(void);
+
 #endif
diff --git a/target/arm/hvf-stub.c b/target/arm/hvf-stub.c
deleted file mode 100644
index ff137267a0..0000000000
--- a/target/arm/hvf-stub.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * QEMU Hypervisor.framework (HVF) stubs for ARM
- *
- *  Copyright (c) Linaro
- *
- * SPDX-License-Identifier: GPL-2.0-or-later
- */
-
-#include "qemu/osdep.h"
-#include "hvf_arm.h"
-
-uint32_t hvf_arm_get_default_ipa_bit_size(void)
-{
-    g_assert_not_reached();
-}
-
-uint32_t hvf_arm_get_max_ipa_bit_size(void)
-{
-    g_assert_not_reached();
-}
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index fa26f63a61..5e93c42047 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -731,7 +731,7 @@ static uint64_t hvf_get_reg(CPUState *cpu, int rt)
 static void clamp_id_aa64mmfr0_parange_to_ipa_size(ARMISARegisters *isar)
 {
     uint32_t ipa_size = chosen_ipa_bit_size ?
-            chosen_ipa_bit_size : hvf_arm_get_max_ipa_bit_size();
+            chosen_ipa_bit_size : hvf_arch_get_max_ipa_bit_size();
     uint64_t id_aa64mmfr0;
 
     /* Clamp down the PARange to the IPA size the kernel supports. */
@@ -827,7 +827,7 @@ static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     return r == HV_SUCCESS;
 }
 
-uint32_t hvf_arm_get_default_ipa_bit_size(void)
+uint32_t hvf_arch_get_default_ipa_bit_size(void)
 {
     uint32_t default_ipa_size;
     hv_return_t ret = hv_vm_config_get_default_ipa_size(&default_ipa_size);
@@ -836,7 +836,7 @@ uint32_t hvf_arm_get_default_ipa_bit_size(void)
     return default_ipa_size;
 }
 
-uint32_t hvf_arm_get_max_ipa_bit_size(void)
+uint32_t hvf_arch_get_max_ipa_bit_size(void)
 {
     uint32_t max_ipa_size;
     hv_return_t ret = hv_vm_config_get_max_ipa_size(&max_ipa_size);
diff --git a/target/arm/hvf_arm.h b/target/arm/hvf_arm.h
index ea82f2691d..5d19d82e5d 100644
--- a/target/arm/hvf_arm.h
+++ b/target/arm/hvf_arm.h
@@ -22,7 +22,4 @@ void hvf_arm_init_debug(void);
 
 void hvf_arm_set_cpu_features_from_host(ARMCPU *cpu);
 
-uint32_t hvf_arm_get_default_ipa_bit_size(void);
-uint32_t hvf_arm_get_max_ipa_bit_size(void);
-
 #endif
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 61277a627c..9f2eb91635 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -41,7 +41,6 @@ arm_common_system_ss.add(files('cpu.c'))
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
-arm_common_system_ss.add(when: 'CONFIG_HVF', if_false: files('hvf-stub.c'))
 arm_common_system_ss.add(when: 'CONFIG_ARM_COMPATIBLE_SEMIHOSTING',
 		                 if_true: files('common-semi-target.c'))
 arm_common_system_ss.add(files(
diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
index fe58217e46..4254a8aadb 100644
--- a/target/arm/whpx/whpx-all.c
+++ b/target/arm/whpx/whpx-all.c
@@ -805,8 +805,9 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
         goto error;
     }
 
-    if (mc->whpx_get_physical_address_range) {
-        pa_range = mc->whpx_get_physical_address_range(ms);
+    if (mc->get_physical_address_range) {
+        pa_range = mc->get_physical_address_range(ms,
+            whpx_arm_get_ipa_bit_size(), whpx_arm_get_ipa_bit_size());
         if (pa_range < 0) {
             return -EINVAL;
         }
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 2023a7bfbb..9d41e51b83 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -225,6 +225,17 @@ int hvf_arch_init(void)
     return 0;
 }
 
+/* 48-bit on all Intel Macs. Function currently unused. */
+uint32_t hvf_arch_get_default_ipa_bit_size(void)
+{
+    g_assert_not_reached();
+}
+
+uint32_t hvf_arch_get_max_ipa_bit_size(void)
+{
+    g_assert_not_reached();
+}
+
 hv_return_t hvf_arch_vm_create(MachineState *ms, uint32_t pa_range)
 {
     return hv_vm_create(HV_VM_DEFAULT);
-- 
2.50.1 (Apple Git-155)


