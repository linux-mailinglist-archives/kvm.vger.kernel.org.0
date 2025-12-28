Return-Path: <kvm+bounces-66737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD042CE591B
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:56:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E582B3009F96
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73177287276;
	Sun, 28 Dec 2025 23:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="LAc4znXf"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster4-host1-snip4-4.eps.apple.com [57.103.65.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7253A1E6F
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.65.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966199; cv=none; b=O8F7H5z3qs/7n1ADIw+33Wb53WuoJZROadwE+bKZBUaxLVZSi6zgXsX9re9pxbIBElkuqIAgTtzZA/KD/H+ZXx8jShE+rj+dYzkcyIWOphTeNhV+nQso3rgMjlO4JVwo3Il/+566YZ1h4E4GAeQw9O/kuz/xaQ+R48M4p7OtQHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966199; c=relaxed/simple;
	bh=+sheOkzDX655AAUS+duET1q3qmnyRfK6vaNq9kK3fz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5wuiZMloXgJO8WCmM1K/OVHCe+8bTuT2ftoWXZnlRX1WQwhmatFOCh3cmBh8e1BIdsEGTrF2H8Vyb96R5MDdZASYuFvzKmRF9f9JQII++iHxQK0N0aNBx789T2BltBznPgfwKC4dPY8pX4Ivob4kTPjyOgqi7IWcxjOEwG9Dec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=LAc4znXf; arc=none smtp.client-ip=57.103.65.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 076141800751;
	Sun, 28 Dec 2025 23:56:33 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=1CjKM6KDEmf5eo7QDBOx5N5scvQteXKGcwrcKL+2vCA=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=LAc4znXfQbXvtnHRxjnjmD3r1JY73JOEbc3WY3g/vlgg6rPRoFchnju8/XXVxJB8ns8T5TrRVtNs5MJpWE/yxLlELHoFMXDdqKe6on9tB4N63FDiH+u2GSx4Lx1/I3aSYvD7Y5FzgKIYMRw1uZGw9VPK1cNylkOBIi1Mo23das99T9UwnFRpWTCkdeqNsy9kiNNLiDJUKrEhoGpSo/OxqOlIvaVLsqIVyTSrulEV4OdBlx86tY6Tgq8wTjERbVhCCzVj9K8L5nQ+EMkaNNzFBPE8jqTJA4NSnA+egZkIzKeqqAPW7XZiKkdsdlQC/mEAl7ODpuvS1pJr0Wyiq/mQyQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id B3ED318000B9;
	Sun, 28 Dec 2025 23:56:28 +0000 (UTC)
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
	Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v12 08/28] hw: arm: virt-acpi-build: add temporary hack to match existing behavior
Date: Mon, 29 Dec 2025 00:54:02 +0100
Message-ID: <20251228235422.30383-9-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfXzrTr5EsRZPYj
 QXxB6Y6/+7lKl8AoIuseWMBO6m45XWgAWzNGySC3hy/QqstbtaGquaMET0A4uFoQ3x372RhOjxA
 Uv2jDhfi6uVObAj4jhtRmM08dJqKHyGyG8oq0aWCkoX4uy2hL7C9oZYz6o2RO4qViONQemMh7kI
 9ki/K0PMyA5jUPd3OMCT1QbSvVaDJGsBfrUaabNkWFi0dXkghsiT8WSM8qeCAJ9LH0TWA2XaxUf
 O6nUSUixZIEVb9EpQRrpfv4xv/h2kS8YkpkgdmgegFCv5dOac9GEYkKGU/9z7a9PNKHxmDYczVt
 tn6s7CSPw87WzNo3Js1
X-Proofpoint-GUID: Fadwj1TMWmJSLQzJeE44ZuSqq06F9ZMJ
X-Proofpoint-ORIG-GUID: Fadwj1TMWmJSLQzJeE44ZuSqq06F9ZMJ
X-Authority-Info: v=2.4 cv=CcYFJbrl c=1 sm=1 tr=0 ts=6951c3b3 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=HMNHyw_DGvBsvbusI_IA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 suspectscore=0 clxscore=1030 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAABTeNfovWtPCnelYkI7Whkwav5cIsnvyD1YFj4+gLpYVM6erlHd1gMDCCuCfmkEetazzj4nuv3JEo4cZwiqirqzD8NR1vbLAYl92rNJe9TQ2aZNA47LxKZSuv6zHU4miCEfLVvq0Q0Lhqbb9qQ38ezOqCquPR8vxK0Ow7I2o2XKTPcq1NI1HunJ8+7vPG31VBtaXRXCz6vGPxOkbxo/bcQO3/y0aBryR1AqeB5kN3JxamlC6fvoqrlbwRgv1MCiXSBGFb0m3KqKQyGTlXlYC4HqUhb4rue//i8iJ7yjR+Le3q/p7z+kkHEjShMEISTcYr7RwytweZ6m02oIFryUuBZjI6/QfjiDR7FE9mFO5rGIAa257ujXrzoOvycdl+tbes/5GzbzZc4TTq95DhR+MrPZFh5SEcx/nhLePGaXO8B5XluPxeMPzWAJbp1TqsLA2oLoOygGrcurZh7PLZXEsyJgVzxdHo/GkmM59Cys+i8Rm7qN5Ob5Oy/TUSHXOjKIvBvCYTOybyP/agg5IMvxUZ4Sjdiugjh9XPt1IU3wDxDtPcGzP+E2Hz9Y7FQuoXTr/d1hVS1oqEXmBwUu0xieqLdmQGGMGKqDiyQvrjHCLkejfFdXWh6SeWZihEyQFdnAj4B1SPMxqdyIhz/yPLKOR/lYOyU9Z+jiu1RY/2yn2ty/kRw8ICmmcRJakzJPIzjGP9Qw+4xboX4RwIiZGEsGcVhgcNFx5SeankJwbp2AUrQubkCX1zj6AZsd5aUxgby+ZRBNa1GX2U6imeA8htmep0wx48/qcZgSwMdYYzZBBCvT2LGysAIyr4fWsEjhftDKb/Geg+28xROcnS5KdQCAUHcZHGmzKTD6BXqMcARJ7viTgQuGyRIgDFKKQhXPgylUZTOeMfRG37JnACAhiCH5iY8oGekaizpEaAy6dVqlI9PhRaU90r24MajTfrqYoA=

In the prior Qemu ACPI table handling, GICv2 configurations
had vms->its=1... That's broken.

Match that assumption to match the existing ACPI tables that
have been shipping for quite a while.

And see what to do for older releases. Likely don't
want this to be carried around indefinitely.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 hw/arm/virt-acpi-build.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index f3adb95cfe..2b217e8681 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -473,7 +473,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
         nb_nodes = num_smmus + 1; /* RC and SMMUv3 */
         rc_mapping_count = rc_smmu_idmaps_len;
 
-        if (virt_is_its_enabled(vms)) {
+        if (virt_is_its_enabled(vms) || vms->gic_version == 2) {
             /*
              * Knowing the ID ranges from the RC to the SMMU, it's possible to
              * determine the ID ranges from RC that go directly to ITS.
@@ -484,7 +484,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
             rc_mapping_count += rc_its_idmaps->len;
         }
     } else {
-        if (virt_is_its_enabled(vms)) {
+        if (virt_is_its_enabled(vms) || vms->gic_version == 2) {
             nb_nodes = 2; /* RC and ITS */
             rc_mapping_count = 1; /* Direct map to ITS */
         } else {
@@ -499,7 +499,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
     build_append_int_noprefix(table_data, IORT_NODE_OFFSET, 4);
     build_append_int_noprefix(table_data, 0, 4); /* Reserved */
 
-    if (virt_is_its_enabled(vms)) {
+    if (virt_is_its_enabled(vms) || vms->gic_version == 2) {
         /* Table 12 ITS Group Format */
         build_append_int_noprefix(table_data, 0 /* ITS Group */, 1); /* Type */
         node_size =  20 /* fixed header size */ + 4 /* 1 GIC ITS Identifier */;
@@ -518,7 +518,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
         int smmu_mapping_count, offset_to_id_array;
         int irq = sdev->irq;
 
-        if (virt_is_its_enabled(vms)) {
+        if (virt_is_its_enabled(vms) || vms->gic_version == 2) {
             smmu_mapping_count = 1; /* ITS Group node */
             offset_to_id_array = SMMU_V3_ENTRY_SIZE; /* Just after the header */
         } else {
@@ -611,7 +611,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
             }
         }
 
-        if (virt_is_its_enabled(vms)) {
+        if (virt_is_its_enabled(vms) || vms->gic_version == 2) {
             /*
              * Map bypassed (don't go through the SMMU) RIDs (input) to
              * ITS Group node directly: RC -> ITS.
-- 
2.50.1 (Apple Git-155)


