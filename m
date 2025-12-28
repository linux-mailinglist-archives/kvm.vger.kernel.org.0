Return-Path: <kvm+bounces-66755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D43DCE59B1
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 01:06:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F45E3022F38
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA62E2E7186;
	Sun, 28 Dec 2025 23:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="eKqhoxot"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster3-host8-snip4-10.eps.apple.com [57.103.66.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2312E7161
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966300; cv=none; b=hpZc1/SwvhIE4iMGZmkoPpZ0TgE7u/tRjbFacwDDejVyQhQhLW7H20neb4OD2eKpxwSy7J8ZMbIX92jLVRdn6WYLblf6HwwWiesuEtV8Osjmplsm6KOFcA864yoy+ItZ1BcPzvzAaUNhDxpX8I+rko+Xd183z+xXXlqX9NbdMx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966300; c=relaxed/simple;
	bh=xilhZDuSkA7eGtOZC7tjHtfk4fpXjCmpCFDIaTzGv1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DopCzhPC8POoC70/jBNRDQwphGKms5IiFG7sKnYdSZRfU8ZiZ3y/cjvc3VK0jiJ8moatvSHForUO+aXcO9JS9nZ1KjNS6pCdisM+zUYTsV/1efRPny2yYOoNdpX239biGq7T3O4AhWObEYrjjk43cU5vs2nTT77pk9vFgfB7V4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=eKqhoxot; arc=none smtp.client-ip=57.103.66.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 003BC1800755;
	Sun, 28 Dec 2025 23:58:17 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=SIxSFA0VmEGoMlWfyikaE4kpHd7S/1I8D1yFZzd3Z5s=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=eKqhoxotfXAO3nZzopBIkf9KhYF46ZtdlAdLucLly6TEBahnqAZUBxpyXxvUtYi5lOayv9gS9KKReP7FjUDeqlKUfrpORrQ65shfQkP2UfvSMxdEFvD/CGkMXXQQx2JvEk3JU11J/f1fwwWT/LQrAZ/rsC2Novjw9tQmiD+zpLy5Iwj2sn6jsORXrmiq269UJ+a7oqOZo0LJ/dawAr+MpD4T0gignjPf0EmNnpr5KOynAVKyc9QYm9BpBrjJIGfPhZFz+oXskzmGFqHq9Y09gIFWYYbEZBkiX9CyyG5tPBE0kwxuma59offKlaM0Hv6uBU1QvCF1X93oQ4SGrzy7ZQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 08541180075D;
	Sun, 28 Dec 2025 23:58:12 +0000 (UTC)
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
Subject: [PATCH v12 26/28] whpx: arm64: check for physical address width after WHPX availability
Date: Mon, 29 Dec 2025 00:54:20 +0100
Message-ID: <20251228235422.30383-27-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: R22yr3iHXzbLNSOLcCo-r4Muc--TW-k5
X-Proofpoint-GUID: R22yr3iHXzbLNSOLcCo-r4Muc--TW-k5
X-Authority-Info: v=2.4 cv=FrsIPmrq c=1 sm=1 tr=0 ts=6951c41a cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=GePjjIfFpqe_pMnJkREA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfXyia9Ph/XIE5b
 gX7U8FhaMOWQgb7T0GrUdK6u91rA1ige7YFnNw8p++CVtnlKyteqjJAXoENWyMWKkFviPqQjImU
 /gQeBvLoirvEx66BRoFeM2HHM8jCu8vOoFamQetyJEzkN48O7WFkjFFUaxnnHO+962Irw4AI4dz
 L2rscAevsw69KOpDJ9EeVNJCwnZiT/VktU0uM/7heetB+BWScjBe2r5edwk+yjTpCGTD0IZu0eY
 QjfEOm+149qPyaRT3jPM/q/MSTp/juIMPVedjnySBw9ywW+oaLNiGd/TNnk4W7KzpdaEzI70FWF
 rCHoW7YuhDKgO8EoNcz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 phishscore=0 clxscore=1030 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAABbaj3v0A0TchpYF6qqu17QHycPjpvNl4Vv4ZKOOb1vxROCTqOgETSoB0V79Nq2CbW+AhFlKX4uK9ksr+JSmmFuRkM4uXB4cf2AJXvtNYXCXChW4AX1+jPOyWPxnpcpzUYq3jfHeGjiz1xfI++RjkjNoLqMd2qt/J+4+HicVKEQkzg3iiAY6kFwYmjetphmRprl7DYd1G5cOaGwlP8zZpYfEE75KEn60s8bSi62fFMrNDPUbYB6zvrVXPWMrRdDHGIV3b/+08LExWIM4UcaXDTdIVCI53GVh0FPOcHvy/zOtpFuEhXAEunYnCkKjofQdHXwSrQ6+ZJ9wQQc/cC1QdvjUQilFdgNBtn1a15EsabALlV1gL/eneBQwPq1ANiUMy4HwlDa0L+3dciRCqLIz1CZlM2OQV7pPrjtbGUUeD2IqL7UiEryUNbu8bTYtVsyZSnkJ6Ac7hfhBg9qD7kYqUQMvKnoITDKlCZyCIOQAp+TcPmtyhBnQaFgLIye4nMFNU9F7KPaEoegX8os8qGr4qRWALY3O/EPKGGCH6hHRbkQjcsJxN1rYppBaciH2Os1+k3daUPccpAp3q/E2UEQ20+xOUtzsj/ZtR9V6iekg5ryULGOVarCjkXWVTDKQO6mFyHOOUbJSbLc/YX4Wg/whOhqqvG2LCKpjSyS7xwQLUZ0BbZ4/K9uzY7VYH7WuaX5Y2pRfAlCKyqHLw7cnVt/zhPM4tr5RW2jLCWHlfDjRBVk0TmCACV11dqfg3LNVqbgJ12l8NMLgfr6g2ouehvWkcfMO9605UdcgJI74dLLDtjLrpYFrRhxPQ9DAKMdAY+t4CZDE7bT7ZKHEw4R3UqkiRz3ivhDD4+tnz49s5NxEcgKVIxAQx42RFB4Hg7lilpSBG3kZmDQ2xNnwslgq73k/iQ5eQWsQmk+i1at61U3HleaNOxSqU2lOl7mN77iS86r2p+og0YUSjkg1++skTDLnLVyJZ
 6

In the case where WHPX isn't supported on the platform, makes the
intended error appear instead of failing at getting the IPA width.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 target/arm/whpx/whpx-all.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
index eea20f5e5e..2e5ece45ea 100644
--- a/target/arm/whpx/whpx-all.c
+++ b/target/arm/whpx/whpx-all.c
@@ -678,7 +678,7 @@ uint32_t whpx_arm_get_ipa_bit_size(void)
         WHvCapabilityCodePhysicalAddressWidth, &whpx_cap,
         sizeof(whpx_cap), &whpx_cap_size);
     if (FAILED(hr)) {
-        error_report("WHPX: failed to get supported"
+        error_report("WHPX: failed to get supported "
              "physical address width, hr=%08lx", hr);
     }
 
@@ -909,14 +909,6 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
         goto error;
     }
 
-    if (mc->get_physical_address_range) {
-        pa_range = mc->get_physical_address_range(ms,
-            whpx_arm_get_ipa_bit_size(), whpx_arm_get_ipa_bit_size());
-        if (pa_range < 0) {
-            return -EINVAL;
-        }
-    }
-
     whpx->mem_quota = ms->ram_size;
 
     hr = whp_dispatch.WHvGetCapability(
@@ -943,6 +935,14 @@ int whpx_accel_init(AccelState *as, MachineState *ms)
         goto error;
     }
 
+    if (mc->get_physical_address_range) {
+        pa_range = mc->get_physical_address_range(ms,
+            whpx_arm_get_ipa_bit_size(), whpx_arm_get_ipa_bit_size());
+        if (pa_range < 0) {
+            return -EINVAL;
+        }
+    }
+
     hr = whp_dispatch.WHvCreatePartition(&whpx->partition);
     if (FAILED(hr)) {
         error_report("WHPX: Failed to create partition, hr=%08lx", hr);
-- 
2.50.1 (Apple Git-155)


