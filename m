Return-Path: <kvm+bounces-66746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05591CE595A
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9EE7A3007C4A
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98B22E36F8;
	Sun, 28 Dec 2025 23:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="go8kJFXl"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster1-host4-snip4-10.eps.apple.com [57.103.64.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B65013B585
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.64.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966256; cv=none; b=nouW5g86sW1lOQJeyxKaPEiNmXfs6lQK81ufKeOMI/F/HE/3qNV7OxZqyGlL5Rm5GTL3Seo1jkbHCthve1zL85WQIv/ascfQCWU0emsYcAMiILl/lMxbt0+X7LmLg3Tvz8m7XWjvC8Ryu1E1yQ/2Fqgd6WS2r7A0momFt6w4YWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966256; c=relaxed/simple;
	bh=VD2mAr49VKRNKnCEbdy0MHHk+PNko3PDYEcQCRRyLE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3sEmhL4fuUlqMaw4K3Eo2vG7TzYPobZ5IfbzpbO+98z0EkUbnVBSgK/f8gh2Vn1vZ8dOZHdlZ8wQOk5Y2suCJ24iJFKmb0mROQwu706f4TLIU7EiK+gPCOmzrq7Kh+8Zkh8UtmmPQuzi8djycvw/FmlFxCnzVp4AmN6WyTAJiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=go8kJFXl; arc=none smtp.client-ip=57.103.64.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id B574E18000BB;
	Sun, 28 Dec 2025 23:57:27 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=QDXE4BTKz17kv5VTY/i5MP6X8/apcEf7UgecJbK6GMA=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=go8kJFXlbd3oCXMCA5QEVPJIkISwqMECbV+dns1mbRf4afmykhZT9Vc1cDd7PTfuDsRcrBzUnKJaLSwr+2X5DW0MmXMctRZIAMYD6G0DvXlS6S6ZgAKL0kn/2MDGpA4M7thnWEosiERipmac7teZylZe5GF7ZkOHUuUCfGMp1QX1W2/mt3rdDJWyL24x7IthDWj5Wxtxm+V7ts89kTThUqeQZjwAvT13USVQzkQ7eLGZWSb1Dof4F5RpbsTdTwlv7IyUq6qz3JGY9wTGeK/Foq/pxI68sM8k/KhhRDW5T0yIj3YUq/9E6qKY777ZJWvTq2wljmUUDYjwdBm1khowIQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id EEEED1800758;
	Sun, 28 Dec 2025 23:57:20 +0000 (UTC)
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
Subject: [PATCH v12 17/28] whpx: change memory management logic
Date: Mon, 29 Dec 2025 00:54:11 +0100
Message-ID: <20251228235422.30383-18-mohamed@unpredictable.fr>
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
X-Proofpoint-GUID: NjGh43IiO3Q0R9WKNb4nGe2PdcSijygC
X-Proofpoint-ORIG-GUID: NjGh43IiO3Q0R9WKNb4nGe2PdcSijygC
X-Authority-Info: v=2.4 cv=V5JwEOni c=1 sm=1 tr=0 ts=6951c3eb cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=-lUDFlMDQ8UY_jOkuTYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX1KyhiV+ZmKbN
 2ANAfsTxBASIw346Ax+DBKaWVzlgt9EjOpSbCdhtL3JqF7oJDeayYB+dayDvZtkOeys0Z/9PFZ5
 RehtGUyEcfqSrooorxSD3zAxPlDRsj+ul8xh/+tuBYJcwH33dWFI/vEoCXyGdzWZDKEoIKvHYXQ
 2tnacZLgjJRzde3wfcrIkJFWtlVHT9qdEbPQgRpH6P23mHkgmsbwjJu6NirHPgKB8FUxiCooJG9
 nvMNfqdyS/Im5xFQkh6RK1COga21v+XJ2xuAakhrcnExt0Itjxi3R5KekUjHRLGR0L0C837JLWo
 eCPXuNCojytct9HemB6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1030 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 classifier=spam authscore=0
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512280223
X-JNJ: AAAAAAABn9jVyaDDyISAKSriCfnSBElNzoGH/CEj3Y3Y7xOhokuerFwM94+2tCTy1HKL9edtF2Sq/s0mQsLgV7Xgkr1QVm5LEPVPcU5RfTNNBmQdA3k1+0q8RwwpRwKD8NJgjWjhfUMo+8nsJS+iwX9lM3aCQkqmip8oLnBnoRXU78dMLQyTc8+66iEb1fz2/RgozdRpc1HGFgwGUWA8+0tDrYAJnhKlBXL3DbXUEDR+MMyrpKhnUuthnMEk/yytOsDYmUK2fYJZfo5JYZUbatJWAyp0cvz8kWw/IUxVDYnwty6pxiRHEcmdsA0GK3lgfSeDWzNlhUSSmJj3O1rhi67taVPX053R1dnsjcW4teOuiFCugPVWA+9znakqQJPKJ1FRhNExbijtbENEG9qoIF8lNRnhQ8ZLe2S4FKq70N++m0aQg4DIUG8pECV6n/D55ft2SIN08f3Hz/Z8K8pXO8my/uw01HfSDysFHQUpFZ5vaLn6dc2uy3+DlNA51LaMShYRLXFTsYP6n/28LFm1+YWFICebOL6g2KIKutZINHx8lUIv2Qm6UQ1wCQK1uCo8IwVm3Wi/iQ1x/XOvVxiItuWBVCR+o0iwp3AdgP5/jeiVU/ktJfQPC89Pp+Jv2Nien+JmDTO4vMEzbI/9UevPUTbDr7JjSBkciFJFw+dMHBg4BAgj1eJgrbBzBnj85NT8s27GnUnhx8Za3IYVf7MLKQLPGlMukGcT9ZQydfdeTPQG9oNU6Ic75DDcvi5qiJwyER1qhP6zXfeLhwRWIZyCtC38g7Os3kPYrJ08dyzIl7YDCZ6FAOc3mCQnhs6p94tLxLADGx5tDf2GR5u0WkibnOeE3FN44ra66Ey5fYDQx8Zs1jrD4B/riFoxWKLX0BHzuJDPlnMzNlqqvD0ncryMPIH4IjUCnl0ydlJSgxh9pPt+TQIjh15ahKtjSeSno+bC5aUG8+GyJXTmXQJv

This allows edk2 to work on Arm, although u-boot is still not functional.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 accel/whpx/whpx-common.c | 97 +++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 61 deletions(-)

diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
index 0d20b1d24c..e0db8ace4a 100644
--- a/accel/whpx/whpx-common.c
+++ b/accel/whpx/whpx-common.c
@@ -259,89 +259,64 @@ void whpx_vcpu_kick(CPUState *cpu)
  * Memory support.
  */
 
-static void whpx_update_mapping(hwaddr start_pa, ram_addr_t size,
-                                void *host_va, int add, int rom,
-                                const char *name)
+static void whpx_set_phys_mem(MemoryRegionSection *section, bool add)
 {
     struct whpx_state *whpx = &whpx_global;
+    MemoryRegion *area = section->mr;
+    bool writable = !area->readonly && !area->rom_device;
+    WHV_MAP_GPA_RANGE_FLAGS flags;
+    uint64_t page_size = qemu_real_host_page_size();
+    uint64_t gva = section->offset_within_address_space;
+    uint64_t size = int128_get64(section->size);
     HRESULT hr;
+    void *mem;
 
-    /*
-    if (add) {
-        printf("WHPX: ADD PA:%p Size:%p, Host:%p, %s, '%s'\n",
-               (void*)start_pa, (void*)size, host_va,
-               (rom ? "ROM" : "RAM"), name);
-    } else {
-        printf("WHPX: DEL PA:%p Size:%p, Host:%p,      '%s'\n",
-               (void*)start_pa, (void*)size, host_va, name);
-    }
-    */
-
-    if (add) {
-        hr = whp_dispatch.WHvMapGpaRange(whpx->partition,
-                                         host_va,
-                                         start_pa,
-                                         size,
-                                         (WHvMapGpaRangeFlagRead |
-                                          WHvMapGpaRangeFlagExecute |
-                                          (rom ? 0 : WHvMapGpaRangeFlagWrite)));
-    } else {
-        hr = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
-                                           start_pa,
-                                           size);
-    }
-
-    if (FAILED(hr)) {
-        error_report("WHPX: Failed to %s GPA range '%s' PA:%p, Size:%p bytes,"
-                     " Host:%p, hr=%08lx",
-                     (add ? "MAP" : "UNMAP"), name,
-                     (void *)(uintptr_t)start_pa, (void *)size, host_va, hr);
+    if (!memory_region_is_ram(area)) {
+        if (writable) {
+            return;
+        } else if (!memory_region_is_romd(area)) {
+             add = false;
+        }
     }
-}
-
-static void whpx_process_section(MemoryRegionSection *section, int add)
-{
-    MemoryRegion *mr = section->mr;
-    hwaddr start_pa = section->offset_within_address_space;
-    ram_addr_t size = int128_get64(section->size);
-    unsigned int delta;
-    uint64_t host_va;
 
-    if (!memory_region_is_ram(mr)) {
-        return;
+    if (!QEMU_IS_ALIGNED(size, page_size) ||
+        !QEMU_IS_ALIGNED(gva, page_size)) {
+        /* Not page aligned, so we can not map as RAM */
+        add = false;
     }
 
-    delta = qemu_real_host_page_size() - (start_pa & ~qemu_real_host_page_mask());
-    delta &= ~qemu_real_host_page_mask();
-    if (delta > size) {
-        return;
-    }
-    start_pa += delta;
-    size -= delta;
-    size &= qemu_real_host_page_mask();
-    if (!size || (start_pa & ~qemu_real_host_page_mask())) {
+    if (!add) {
+        hr = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
+                gva, size);
+        if (FAILED(hr)) {
+            error_report("WHPX: failed to unmap GPA range");
+            abort();
+        }
         return;
     }
 
-    host_va = (uintptr_t)memory_region_get_ram_ptr(mr)
-            + section->offset_within_region + delta;
+    flags = WHvMapGpaRangeFlagRead | WHvMapGpaRangeFlagExecute
+     | (writable ? WHvMapGpaRangeFlagWrite : 0);
+    mem = memory_region_get_ram_ptr(area) + section->offset_within_region;
 
-    whpx_update_mapping(start_pa, size, (void *)(uintptr_t)host_va, add,
-                        memory_region_is_rom(mr), mr->name);
+    hr = whp_dispatch.WHvMapGpaRange(whpx->partition,
+         mem, gva, size, flags);
+    if (FAILED(hr)) {
+        error_report("WHPX: failed to map GPA range");
+        abort();
+    }
 }
 
 static void whpx_region_add(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
-    memory_region_ref(section->mr);
-    whpx_process_section(section, 1);
+    whpx_set_phys_mem(section, true);
 }
 
 static void whpx_region_del(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
-    whpx_process_section(section, 0);
-    memory_region_unref(section->mr);
+    whpx_set_phys_mem(section, false);
 }
 
 static void whpx_transaction_begin(MemoryListener *listener)
-- 
2.50.1 (Apple Git-155)


