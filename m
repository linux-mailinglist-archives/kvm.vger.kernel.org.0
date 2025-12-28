Return-Path: <kvm+bounces-66733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF55FCE590C
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:55:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E06A03003BED
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD452E0939;
	Sun, 28 Dec 2025 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="WtXQ15Vr"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster2-host3-snip4-7.eps.apple.com [57.103.64.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1BB3A1E6F
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.64.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966155; cv=none; b=UtyKnPbrstBoRX55zDyc0kEKMWJ33mi7+1aLLuZ8rI8GTy9VNhrz6tlUQECVGefr9xSSgCoe6g/XG4mYiNPCZ7PVfMkAXGHmhWkemZs/t/x6+BNenTB3+IA+x7Dedex5RerlvkTTrPk37VSPsv10W+jIhmqeEZM9LcTBv5R/jgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966155; c=relaxed/simple;
	bh=huw3FTGkOKbZ98JG4GP2ocqkmR6/8jkfx/mvSUXkJiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/z1q+NnnQWDY3P76AK37AJiL67dsdyqapCHsqcpy2G51Kbr6yekjqzgtqbUe32veurQkdTJ6EHMMcMr8wadaEkggfNUHg9AXQ58WXa5yBeZw6GH8rD50Vhm5XcXtVxLEnUCatUHpUSWOnme3QulakUmmqfX/q+ktfV/jF0TxFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=WtXQ15Vr; arc=none smtp.client-ip=57.103.64.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id BA7841800746;
	Sun, 28 Dec 2025 23:55:51 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=rFhI/t8cH+kmkaHds1mEcRYKggaDjPc//d5pkD2w7mQ=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=WtXQ15Vrq9Ahmzp8aBVd3DPafEQ3tflkluIf8rLRIhlUUmVqo/CjxfUeiuftO3ZtGISjohlIfU+1w/wdvKyWS29CTeR6b1uLAamncbaW3v0gFsLpjOw2bnRcQtukTFRyx+YyBR26pLAH0/zheTPLR3uoGw0nja8rTZ8ARyl6B2nGe8TLeI3M9r5OPdMUYZVPJOl6VI/MbXP7NkweNvBSNb81zjGaO8hqTET2JdUnb2WIsZx5iUvw8B0/8FJgZ7WkAsHL+hlNBtSLmsJxvvy14VOX4WTpRDesIbDgIsGY2ZouCrOgP06jYd8ycDLRZpnbeeEFntziwYkUnf2YixWVtg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 44C2B1800177;
	Sun, 28 Dec 2025 23:55:43 +0000 (UTC)
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
Subject: [PATCH v12 04/28] hw/arm: virt: add GICv2m for the case when ITS is not available
Date: Mon, 29 Dec 2025 00:53:58 +0100
Message-ID: <20251228235422.30383-5-mohamed@unpredictable.fr>
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
X-Proofpoint-GUID: qxZtYuE4fzNu3NPzekNRZ2WNRIM4VJXq
X-Authority-Info: v=2.4 cv=euzSD4pX c=1 sm=1 tr=0 ts=6951c388 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=8tVNtdTugjW4QW2w:21 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=2MEwu6HtH8Fm8Y6mf3QA:9 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX5cxJZ3Ickkcb
 2moo5O9WSooRCERms4wAlRQAFAQyr/ZQvupVJxTN4sq/fKAhkVHu0HQGdb67YZ681sOTPJx2JK4
 GTvx6iIJK2MnnJmGuo59URA6EXUpEZ5e2PkZScr1F0YbfI5oB5pEjE6+smRh6D48PKoD36pp0Jp
 IGtWpE19/9yw49LgWqOoqi3XQ5glY864tBjuLHdyv+AbsvzJczBX/QucUXfd/SkK3Sex1F6D3wq
 I2PNkrS3cd25fdHeJDRXFNmx8CX50/6rSz6bTr++w7C5Ov9jD+VGcGU3TQeR0hRLEtusaKduG02
 72NjltLeX18nIrXLdkm
X-Proofpoint-ORIG-GUID: qxZtYuE4fzNu3NPzekNRZ2WNRIM4VJXq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 clxscore=1030
 mlxscore=0 mlxlogscore=999 bulkscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAABahXJBowf/LvZm1PryqzY6MjtHiVYQGuNoCNMivoQISOT+qBnMyWEau1uZCUNPM4UBJwNG6aXt0g3PabgKxNZNWXen3IlkKkDBW+TZbyJ6XSJpjswGEiyayayMzWwXEdFJzAHrr0JuK33O1RMoqaSQD+Y+D6SvrxTQhOqRqPqVzIgvMMgIut7+jALHVsKIGrMmpSFBr7XxOmbmy2i4c7Sr8up+0vg3uGfQi6Ln7tb7NziRBcLE+pTYWR5VseIOJo0X8Lx4KzsPK/Tb6FtSeBAKYXEpX9wnYFsHMCetkm5zAn3pwhlWGqZV/6NzpbYrGkWR/i9Jo759hleya7pf9Au23k6i7tmrDWCWeBJgSVo44epAFFVB4AAklFiBmskx6VH9v3vooNJLaV0Rl1GIY9EdZKSBgOSFl9yuDn2UYqRuJpqt0QYvGaILs2vsPZUFmgMmWQyx09fZmXvKQJNXqOWz+5P3a7fDHkvQIWt4fJ4Eq0WhyZKa0XnotHsnIM61Igx1Hb2vWixezZFcYLEcuYQkONycA6puXZFZtcLIhpIyRJ2EWpHZOEzmlCTQrMVdOrU9cLOWMn/bnCQTYMCvcGPqps2IKZdT++YDoba5sVetvRWQ6F9i8tLQ8tHzuT7gv6STf5VZ+yoopTaxfq4DDep+77Tb0rDJ1py8QUwAG6AQJPihYBXo7SixXGvJtZf/fowSU2W038rRlKmRLJGYASZkK6UugLUjzl0RTOr48wjd7tK+fHG1uyUV3tN72opU0JTFS7rMJFm9dcUHqVmBT0+1aw0xN+NDsiDg2jslkWmXeO/T1Hf1vymnFqKLZe+KGh/5HmINyk7S5cUXqOkKAUTVyu/wXSVgiaU8meCJJDkOH0nIqj3MmiQO89pgyAhytS8PLp402HRn0C0K4Yoo7DvHIdTrG7xS93UyQdWUXXU/WtXy1cVrEeUhaWk6wO1SXZTe+5SjfuTJMT7IwO/8AlnRA=
 =

On Hypervisor.framework for macOS and WHPX for Windows, the provided environment is a GICv3 without ITS.

As such, support a GICv3 w/ GICv2m for that scenario.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/virt-acpi-build.c |  4 +++-
 hw/arm/virt.c            | 16 +++++++++++++++-
 include/hw/arm/virt.h    |  2 ++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 03b4342574..b6f722657a 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -960,7 +960,9 @@ build_madt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
             build_append_int_noprefix(table_data, memmap[VIRT_GIC_ITS].base, 8);
             build_append_int_noprefix(table_data, 0, 4);    /* Reserved */
         }
-    } else {
+    }
+
+    if (!(vms->gic_version != VIRT_GIC_VERSION_2 && vms->its) && !vms->no_gicv3_with_gicv2m) {
         const uint16_t spi_base = vms->irqmap[VIRT_GIC_V2M] + ARM_SPI_BASE;
 
         /* 5.2.12.16 GIC MSI Frame Structure */
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index fd0e28f030..0fb8dcb07d 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -959,6 +959,8 @@ static void create_gic(VirtMachineState *vms, MemoryRegion *mem)
 
     if (vms->gic_version != VIRT_GIC_VERSION_2 && vms->its) {
         create_its(vms);
+    } else if (vms->gic_version != VIRT_GIC_VERSION_2 && !vms->no_gicv3_with_gicv2m) {
+        create_v2m(vms);
     } else if (vms->gic_version == VIRT_GIC_VERSION_2) {
         create_v2m(vms);
     }
@@ -2444,6 +2446,8 @@ static void machvirt_init(MachineState *machine)
     vms->ns_el2_virt_timer_irq = ns_el2_virt_timer_present() &&
         !vmc->no_ns_el2_virt_timer_irq;
 
+    vms->no_gicv3_with_gicv2m = vmc->no_gicv3_with_gicv2m;
+
     fdt_add_timer_nodes(vms);
     fdt_add_cpu_nodes(vms);
 
@@ -3488,6 +3492,7 @@ static void virt_instance_init(Object *obj)
     vms->its = true;
     /* Allow ITS emulation if the machine version supports it */
     vms->tcg_its = !vmc->no_tcg_its;
+    vms->no_gicv3_with_gicv2m = false;
 
     /* Default disallows iommu instantiation */
     vms->iommu = VIRT_IOMMU_NONE;
@@ -3533,10 +3538,19 @@ static void machvirt_machine_init(void)
 }
 type_init(machvirt_machine_init);
 
+static void virt_machine_11_0_options(MachineClass *mc)
+{
+}
+DEFINE_VIRT_MACHINE_AS_LATEST(11, 0)
+
 static void virt_machine_10_2_options(MachineClass *mc)
 {
+    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
+
+    vmc->no_gicv3_with_gicv2m = true;
+    virt_machine_11_0_options(mc);
 }
-DEFINE_VIRT_MACHINE_AS_LATEST(10, 2)
+DEFINE_VIRT_MACHINE(10, 2)
 
 static void virt_machine_10_1_options(MachineClass *mc)
 {
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index 8694aaa4e2..c5bc47ee88 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -130,6 +130,7 @@ struct VirtMachineClass {
     bool no_cpu_topology;
     bool no_tcg_lpa2;
     bool no_ns_el2_virt_timer_irq;
+    bool no_gicv3_with_gicv2m;
     bool no_nested_smmu;
 };
 
@@ -178,6 +179,7 @@ struct VirtMachineState {
     char *oem_id;
     char *oem_table_id;
     bool ns_el2_virt_timer_irq;
+    bool no_gicv3_with_gicv2m;
     CXLState cxl_devices_state;
     bool legacy_smmuv3_present;
 };
-- 
2.50.1 (Apple Git-155)


