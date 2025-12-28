Return-Path: <kvm+bounces-66741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 578C7CE593F
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A53930054B0
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0D02E092E;
	Sun, 28 Dec 2025 23:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="LcgRTI9I"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster4-host1-snip4-4.eps.apple.com [57.103.65.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFA413B585
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.65.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966229; cv=none; b=bmQ7eFQBmhcfhvRbHBoYh/h7EAvKACWTd5pd0nmjQ5OLtnWNwsLpUHjZgli7jrM7j/YtmXgsCQSk7XkbRf8i2Jah3U9YhiXaQ7bzdsyJ+YZzEKLGVWMLil6rlLr/R+femd47oTMFDMKnI/rd0sVoglhznX6eKYuf+2Jr1j1ur6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966229; c=relaxed/simple;
	bh=ND343gPd5MZcSuo0ZaIcwPAvbzTch6RWEF7oGjqJx5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7bpBi1L6S6RBowPF+/4AKB7nAV9wgBmVl8Hh3W22SaEfCSOHtzRk/984bC8/PKisPnpqMkNeundaArBYUO017To1ieZHW/Rm0qoUFvNj/phNmHBMYe6fWTIvUVfp4yMNIZaUGId6U6DbF7EMKFFXkwFt0K/mN9teGDmb6XrvDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=LcgRTI9I; arc=none smtp.client-ip=57.103.65.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id D7E041800753;
	Sun, 28 Dec 2025 23:56:57 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=pv9LTpPl13EUE97IZEQWuikh1ZpqnK830pITzzND0NY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=LcgRTI9InhRpSzDz0rnPsMrbxpRdtjvZcKB/tI3VG/e0A5WQ0SoynA8cN1bxx0f6ojIxVcc+luOO/+a1cCtjPtOuX08Iwyybi+WoEo27MJiFStKZo3tNk4A2kAUNJGK87rY1fsRDZni0yYqjeharv8djcM9qdiHpz2e8DFiGmYpsGf0vYpTaQ2hEZEUY+SFQItmpLQSTbw5krYI9Ksq6cm6akAJ5PBPdCf87kJpGKPu+Hr0wWxI5TyJcr2qsTOf7kfTbRxVvBbYTZCGsqWtY03SE94YO7MifJVe6q0YfZaRSduQtunOh0xWf4TvEqmhsTto9mJvcI1sRY8A/FqHLpw==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id DE5891800759;
	Sun, 28 Dec 2025 23:56:51 +0000 (UTC)
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
Subject: [PATCH v12 12/28] whpx: ifdef out winhvemulation on non-x86_64
Date: Mon, 29 Dec 2025 00:54:06 +0100
Message-ID: <20251228235422.30383-13-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX9kMyA6Ya9PRL
 ZGNeIGDN6sx1tKcmJx9upNZEZXVWYfWXweUMhcN8JIXbeNTEi5hDbWrnWScCwZV9DMpUbNnxs4F
 BY08DgHXgPGfusvSvvTUIilNp+I6bEkyXNsE7v0cKHv3rWPYo1OcqKj69irOa7dyxc451Fmhppb
 5MSbfyHcfRAmLSW0RVjRQSYhGzW5IwJ9g4l1nFwQK4MgXvgOMxrcfAkjL+c1Y8rl9FEDySwbCBi
 Zfp68/dtMf5NlKTOSyG8E35TFydjGp6Lir2ndyWvLJGy8J2iVl5remDlGgSDGtjyCSfxevaEAlB
 cYGBeIaONWEvO1KsESI
X-Authority-Info: v=2.4 cv=O600fR9W c=1 sm=1 tr=0 ts=6951c3ce cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8
 a=VExx-Oqz_yhFp4n2Ql0A:9 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: TscuJr8mrurIBbJm5fl-ob52L0nzqDaA
X-Proofpoint-ORIG-GUID: TscuJr8mrurIBbJm5fl-ob52L0nzqDaA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=894
 bulkscore=0 clxscore=1030 adultscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAAB/SHWJB4X6LBTaMgPZ/Op10PBxGIgbDZqgo2P2Pga+dWxvzq0xmhI1Bfk5wJWknKDHSiBZkRRMql0X/eUHZVtIhPIxawiG+Siq5dYrO+6QQ/xKAPFjBpB2ENTEsiBk/U2ZwcAlloauDwKt/1EkXzm+ueKW8eemH9GoRgDVCTMTl8T4e5wHCEFA1CbnRVMB/6VUD6osNuUrTRUT03oV7GVNsiD86zfKwcF+igxikA95M5FP/neKujA5Ehm9vF5IJA05ACC4b8Gx7XSKTcRoRW0tmr4Vp/J7zHx9NM+SvOk8D1wDVl5+dgBJex4p4HbAq/FYICuC3AUUjb/pT1+vdRa6qAq/5KvUYMbfTYOEP6CXtqwzFiNKCjx6WJxkiHg9+MD4r5ShyQsMGyBs+wzNK8IS770TNn2/gVgdzuZoHA5LYKanZsYwOrLS3WHfspIvR0ddfpGXOcrwxD551Ipn1Scic4gmSvZxALAn6K0JItcjKRm8LL/0Kb8p41X+nEWMkgRaGXQHtRZgz50akUe9+s80MoHnUuP32f6Vb7RmZU+RBe7+bw0IZpMsQXbLA9NAtMjIRuZpHljUuJu7oZDfhlmvLzcUEImuTxfjbqRpvC/wEJNUbRL2EwVD6aImFNtR09/yYBuptxAWt9nTki5X05gM8ZyOIUf168cIe0kBMpLKGVcEFgAGqntecqXMW+5nQJ7kHtSmqMyYsXiMPUd8dtgLecE6JyqmMSgv3/BBwrk1gH2FAjsgL3bZeZQCqTFBROOTXTG4phz2wDzrsQs0Zl4j6OEYMi0YLXlMLrSIjc+M/YDy1E2Bx1yg+YtaRPRKhoBuhnTdmBekH4yVsATHewOnYCA2T525gKp8ftxue8F5abfQ0Ug09TCi49lDzM3Evxr12BuuXV+PJw8LBmP8Mv1zUhZ2itcPU9gehuQKlfejVoRIT56ReW1aFiHjSsNCpmLToszFnz+6e1ezwdMLPxIjGo
 h/zBIUkKOIcJPmz0+VqqcokmMTIYX

winhvemulation is x86_64 only.

In the future, we might want to get rid of winhvemulation usage
entirely.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/whpx/whpx-common.c       | 14 ++++++++++++--
 include/system/whpx-common.h   |  2 ++
 include/system/whpx-internal.h |  7 ++++++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
index d106776ff4..5152f80804 100644
--- a/accel/whpx/whpx-common.c
+++ b/accel/whpx/whpx-common.c
@@ -41,7 +41,9 @@
 bool whpx_allowed;
 static bool whp_dispatch_initialized;
 static HMODULE hWinHvPlatform;
+#ifdef HOST_X86_64
 static HMODULE hWinHvEmulation;
+#endif
 
 struct whpx_state whpx_global;
 struct WHPDispatch whp_dispatch;
@@ -236,8 +238,10 @@ void whpx_destroy_vcpu(CPUState *cpu)
     struct whpx_state *whpx = &whpx_global;
 
     whp_dispatch.WHvDeleteVirtualProcessor(whpx->partition, cpu->cpu_index);
+#ifdef HOST_X86_64
     AccelCPUState *vcpu = cpu->accel;
     whp_dispatch.WHvEmulatorDestroyEmulator(vcpu->emulator);
+#endif
     g_free(cpu->accel);
 }
 
@@ -412,8 +416,12 @@ static bool load_whp_dispatch_fns(HMODULE *handle,
         LIST_WINHVPLATFORM_FUNCTIONS(WHP_LOAD_FIELD)
         break;
     case WINHV_EMULATION_FNS_DEFAULT:
+#ifdef HOST_X86_64
         WHP_LOAD_LIB(WINHV_EMULATION_DLL, hLib)
         LIST_WINHVEMULATION_FUNCTIONS(WHP_LOAD_FIELD)
+#else
+        g_assert_not_reached();
+#endif
         break;
     case WINHV_PLATFORM_FNS_SUPPLEMENTAL:
         WHP_LOAD_LIB(WINHV_PLATFORM_DLL, hLib)
@@ -539,11 +547,11 @@ bool init_whp_dispatch(void)
     if (!load_whp_dispatch_fns(&hWinHvPlatform, WINHV_PLATFORM_FNS_DEFAULT)) {
         goto error;
     }
-
+#ifdef HOST_X86_64
     if (!load_whp_dispatch_fns(&hWinHvEmulation, WINHV_EMULATION_FNS_DEFAULT)) {
         goto error;
     }
-
+#endif
     assert(load_whp_dispatch_fns(&hWinHvPlatform,
         WINHV_PLATFORM_FNS_SUPPLEMENTAL));
     whp_dispatch_initialized = true;
@@ -553,9 +561,11 @@ error:
     if (hWinHvPlatform) {
         FreeLibrary(hWinHvPlatform);
     }
+#ifdef HOST_X86_64
     if (hWinHvEmulation) {
         FreeLibrary(hWinHvEmulation);
     }
+#endif
     return false;
 }
 
diff --git a/include/system/whpx-common.h b/include/system/whpx-common.h
index e549c7539c..8f171d1397 100644
--- a/include/system/whpx-common.h
+++ b/include/system/whpx-common.h
@@ -3,7 +3,9 @@
 #define SYSTEM_WHPX_COMMON_H
 
 struct AccelCPUState {
+#ifdef HOST_X86_64
     WHV_EMULATOR_HANDLE emulator;
+#endif
     bool window_registered;
     bool interruptable;
     bool ready_for_pic_interrupt;
diff --git a/include/system/whpx-internal.h b/include/system/whpx-internal.h
index 041fa958b4..609d0e1c08 100644
--- a/include/system/whpx-internal.h
+++ b/include/system/whpx-internal.h
@@ -4,8 +4,9 @@
 
 #include <windows.h>
 #include <winhvplatform.h>
+#ifdef HOST_X86_64
 #include <winhvemulation.h>
-
+#endif
 #include "hw/i386/apic.h"
 #include "exec/vaddr.h"
 
@@ -101,12 +102,16 @@ void whpx_apic_get(APICCommonState *s);
 
 /* Define function typedef */
 LIST_WINHVPLATFORM_FUNCTIONS(WHP_DEFINE_TYPE)
+#ifdef HOST_X86_64
 LIST_WINHVEMULATION_FUNCTIONS(WHP_DEFINE_TYPE)
+#endif
 LIST_WINHVPLATFORM_FUNCTIONS_SUPPLEMENTAL(WHP_DEFINE_TYPE)
 
 struct WHPDispatch {
     LIST_WINHVPLATFORM_FUNCTIONS(WHP_DECLARE_MEMBER)
+#ifdef HOST_X86_64
     LIST_WINHVEMULATION_FUNCTIONS(WHP_DECLARE_MEMBER)
+#endif
     LIST_WINHVPLATFORM_FUNCTIONS_SUPPLEMENTAL(WHP_DECLARE_MEMBER)
 };
 
-- 
2.50.1 (Apple Git-155)


