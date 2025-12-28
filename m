Return-Path: <kvm+bounces-66739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D43CE5924
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:57:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ACE53300C5F7
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630AB29A326;
	Sun, 28 Dec 2025 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="eM0STR9f"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster4-host4-snip4-2.eps.apple.com [57.103.65.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3972E2E173D
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.65.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966213; cv=none; b=SztXRbArp60znqU1T+2Nst3VV6xQ2bzhTHdXk7vQYcBDX60DtITLxDuZGnd610j73ahxEPQcc/hRaLKjg6nrlIWkvGzUWru7VG1A+aoJdU9S7QB3wynKdxy0xysm08r68jqDtaY2vpgUY8siAMfOeaeLK6LIbQHYVFZ5M30Rw/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966213; c=relaxed/simple;
	bh=7Lt8JgPITRWToyiSNdUq8obrKbGY/thXSIo5cJ+hCAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NESPtg7O8s/Ak75YCYQwStzEft8y2LxtKk5ft076VQ1VbXYrh2FdkZzBAu9qxrAlnP796vixfjMvdow1IVO0JYuwex5MCroEPu3xpGNsByaCL6JFTGqra1PWM4ccmW6xbQfbeJAxigZHoY2K3jhOq3yJlKz19v6LB8u4+Xm/Lmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=eM0STR9f; arc=none smtp.client-ip=57.103.65.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id D88B8180015E;
	Sun, 28 Dec 2025 23:56:45 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=1zFYtxGhq0VuOqIx4HS+RS5UNcitCPNW8rhTvyPPr5c=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=eM0STR9fkx4mJtw++ztnRAiLrwwRrJSymkrmEyPWeXFmTi1k3iDPg44t8FeFrMRIYHNMw819Ex3cZSVBmyzsjArvYO9mc9s+5XvsMF+b2LVKENsaiK3KvUK19liH13BrcQmbP3Nomj/Yq88ZLu9TMlLl6xFhsECLQPYRwHeRCrWCRIffxfZmaBGpkdUQ57eO+Mm7jEv7GiZ3g+NtIEANVjmUXqDmbHm1QHcVMEgqA4UMs9xVucsCCpb0n1wUI9cPDk4n5jNTjw/9aEOjcEJubcbCWt1uT7Iqjr0S5K8vOJ9wXq6feXQDaa0KPNTtL2/cEX1gM8Camo0amRyqYYSDuQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 66043180016B;
	Sun, 28 Dec 2025 23:56:40 +0000 (UTC)
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
Subject: [PATCH v12 10/28] whpx: Move around files before introducing AArch64 support
Date: Mon, 29 Dec 2025 00:54:04 +0100
Message-ID: <20251228235422.30383-11-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251228235422.30383-1-mohamed@unpredictable.fr>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Info: v=2.4 cv=YYKwJgRf c=1 sm=1 tr=0 ts=6951c3c0 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=yMhMjlubAAAA:8 a=5-iGLm-LtT_B5TT3xKgA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: sSsH6l_xmpCVAyIWDNFKgGm58Gcq_1q7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX/ITAZY9gsxZ6
 LszECaSeq0Do9+lfhpbJRA0fYdMHDGj4hojxoirQDwh4SFJnm3ExDSG3OsenN7s1yvHoLh+WB8m
 gAXb8yXAmgWFjw57LpsaQFZfcfj259GpczPEIlbk9q1ygicRDsrVYNw0DewMR3eFuHsYYFtQIk/
 vLURHfSHc/ha5RdHVf6TAGFaan71OMqB7hX5DpG16A+uz5F3ptRY01uRuG+FVmiaKDj1nZUCcRN
 6B1ntiPGgKzQo31enYLMKtXEI+h3DigTQJWYZRR9UP0iZadTthxfCIJbRt7mxSfdm4fXtfyNy2f
 myB9uVNEI+wYK1VOcpd
X-Proofpoint-ORIG-GUID: sSsH6l_xmpCVAyIWDNFKgGm58Gcq_1q7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 clxscore=1030
 adultscore=0 spamscore=0 mlxscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAABTx0MXluRbCeojGgdxaMQcl5+q8WrWyf5POxIQsCOo2o8tuBILNO/uBHswXprJDHnBX1HJ1IwMKAU5LrcqOQUhwzCHyb3wkA0q6uF+KxX02GyyMLWpL+8w7nTQQlY9wl6SnLRa2H9P1tkGU/0p3amSVsc2cOsf0VKB2CW5u4qe/q/K94VfeG93AOYntQi7fJ+XNb9nXGwPxjR+HoOQ5BjWVSCCjcGWPNdZIx2dWodJmayMErm6m7O66hHPkiXX0GTzV+HrlRIlVrVo2wvTx2KeNty6PNHsAvXcidPpemz3OvgmEKGHy9sn5LnK8wP5dhg4FJ1a9cuDoFcscMgcMTEmnnULoUrwywo9tOzQxz+SqAOcgC+pAjrvNdIu3iBnU5SS5rnnBbNxbAAUcKPHtj2ZPcNvvO/AWlVd1eDsuZqJ6LfzxCai7gL4l6K8Xw/LQxubh7SxHGqoXO8VPYEXE9xF+2kA0xWHodSN+YK1s3miCCPFpuRmaqZqsVwKK+137DVNNnmS2puan3reNKOVrmAXMK2mC1+c6qDbSZEmOwYRr8g3I1zdkm2VCrl3HFdj1D6rQCSFj3430zRyvN7uyzDw3sNoORGLMtkF8cGnnboy84d1k7GyRUGtTDVk59p4EMtQFW0E7xI6Ygw9oHjMxMOduJfLCePSenF7aqi/sWM2QdEZAqF84SwhdLBQyT6+RyweaFOP6NuoOdIyFaSyqXk3oZVJ3uTjLcKORRkCLzOQfGBLIS1jPWgwsPMoqMaWzmplJK887TVMZLTTjctRTu0zsNO9ZAQWoz/4jXyOcrTS4iDOrGkUYOyX3BNIFbLjpM+W/KdSw8cVUS5Yuk52Kb+HxcEOVSWt9dxL0VN0Ove5l9Nq0FTz9mINr9NmYPu2S6hxN/BnK25xQGxHlbBDkIaVfm+ghabiLjT7ZsrE6TC0x7NeKXCkbZpbIYvcJCDJdtkNifeHQS4levLvcUb6W0YIuN
 IjScXhJwFDZU=

Switch to a design where we can share whpx code between x86 and AArch64 when it makes sense to do so.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 MAINTAINERS                                           | 2 ++
 accel/meson.build                                     | 1 +
 accel/whpx/meson.build                                | 6 ++++++
 {target/i386 => accel}/whpx/whpx-accel-ops.c          | 4 ++--
 {target/i386/whpx => include/system}/whpx-accel-ops.h | 4 ++--
 {target/i386/whpx => include/system}/whpx-internal.h  | 6 ++++--
 target/i386/whpx/meson.build                          | 1 -
 target/i386/whpx/whpx-all.c                           | 4 ++--
 target/i386/whpx/whpx-apic.c                          | 2 +-
 9 files changed, 20 insertions(+), 10 deletions(-)
 create mode 100644 accel/whpx/meson.build
 rename {target/i386 => accel}/whpx/whpx-accel-ops.c (97%)
 rename {target/i386/whpx => include/system}/whpx-accel-ops.h (92%)
 rename {target/i386/whpx => include/system}/whpx-internal.h (97%)

diff --git a/MAINTAINERS b/MAINTAINERS
index cbae7c26f8..6b045fb3f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -550,9 +550,11 @@ WHPX CPUs
 M: Pedro Barbuda <pbarbuda@microsoft.com>
 M: Mohamed Mediouni <mohamed@unpredictable.fr>
 S: Supported
+F: accel/whpx/
 F: target/i386/whpx/
 F: accel/stubs/whpx-stub.c
 F: include/system/whpx.h
+F: include/system/whpx-accel-ops.h
 
 MSHV
 M: Magnus Kulke <magnus.kulke@linux.microsoft.com>
diff --git a/accel/meson.build b/accel/meson.build
index 983dfd0bd5..289b7420ff 100644
--- a/accel/meson.build
+++ b/accel/meson.build
@@ -6,6 +6,7 @@ user_ss.add(files('accel-user.c'))
 subdir('tcg')
 if have_system
   subdir('hvf')
+  subdir('whpx')
   subdir('qtest')
   subdir('kvm')
   subdir('xen')
diff --git a/accel/whpx/meson.build b/accel/whpx/meson.build
new file mode 100644
index 0000000000..7b3d6f1c1c
--- /dev/null
+++ b/accel/whpx/meson.build
@@ -0,0 +1,6 @@
+whpx_ss = ss.source_set()
+whpx_ss.add(files(
+  'whpx-accel-ops.c',
+))
+
+specific_ss.add_all(when: 'CONFIG_WHPX', if_true: whpx_ss)
diff --git a/target/i386/whpx/whpx-accel-ops.c b/accel/whpx/whpx-accel-ops.c
similarity index 97%
rename from target/i386/whpx/whpx-accel-ops.c
rename to accel/whpx/whpx-accel-ops.c
index f75886128d..c84a25c273 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/accel/whpx/whpx-accel-ops.c
@@ -16,8 +16,8 @@
 #include "qemu/guest-random.h"
 
 #include "system/whpx.h"
-#include "whpx-internal.h"
-#include "whpx-accel-ops.h"
+#include "system/whpx-internal.h"
+#include "system/whpx-accel-ops.h"
 
 static void *whpx_cpu_thread_fn(void *arg)
 {
diff --git a/target/i386/whpx/whpx-accel-ops.h b/include/system/whpx-accel-ops.h
similarity index 92%
rename from target/i386/whpx/whpx-accel-ops.h
rename to include/system/whpx-accel-ops.h
index 54cfc25a14..ed9d4c49f4 100644
--- a/target/i386/whpx/whpx-accel-ops.h
+++ b/include/system/whpx-accel-ops.h
@@ -7,8 +7,8 @@
  * See the COPYING file in the top-level directory.
  */
 
-#ifndef TARGET_I386_WHPX_ACCEL_OPS_H
-#define TARGET_I386_WHPX_ACCEL_OPS_H
+#ifndef SYSTEM_WHPX_ACCEL_OPS_H
+#define SYSTEM_WHPX_ACCEL_OPS_H
 
 #include "system/cpus.h"
 
diff --git a/target/i386/whpx/whpx-internal.h b/include/system/whpx-internal.h
similarity index 97%
rename from target/i386/whpx/whpx-internal.h
rename to include/system/whpx-internal.h
index 2dcad1f565..041fa958b4 100644
--- a/target/i386/whpx/whpx-internal.h
+++ b/include/system/whpx-internal.h
@@ -1,11 +1,13 @@
-#ifndef TARGET_I386_WHPX_INTERNAL_H
-#define TARGET_I386_WHPX_INTERNAL_H
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef SYSTEM_WHPX_INTERNAL_H
+#define SYSTEM_WHPX_INTERNAL_H
 
 #include <windows.h>
 #include <winhvplatform.h>
 #include <winhvemulation.h>
 
 #include "hw/i386/apic.h"
+#include "exec/vaddr.h"
 
 typedef enum WhpxBreakpointState {
     WHPX_BP_CLEARED = 0,
diff --git a/target/i386/whpx/meson.build b/target/i386/whpx/meson.build
index 9c54aaad39..c3aaaff9fd 100644
--- a/target/i386/whpx/meson.build
+++ b/target/i386/whpx/meson.build
@@ -1,5 +1,4 @@
 i386_system_ss.add(when: 'CONFIG_WHPX', if_true: files(
   'whpx-all.c',
   'whpx-apic.c',
-  'whpx-accel-ops.c',
 ))
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index db184e1b0d..cef31fc1a8 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -31,8 +31,8 @@
 #include "accel/accel-cpu-target.h"
 #include <winerror.h>
 
-#include "whpx-internal.h"
-#include "whpx-accel-ops.h"
+#include "system/whpx-internal.h"
+#include "system/whpx-accel-ops.h"
 
 #include <winhvplatform.h>
 #include <winhvemulation.h>
diff --git a/target/i386/whpx/whpx-apic.c b/target/i386/whpx/whpx-apic.c
index afcb25843b..b934fdcbe1 100644
--- a/target/i386/whpx/whpx-apic.c
+++ b/target/i386/whpx/whpx-apic.c
@@ -18,7 +18,7 @@
 #include "hw/pci/msi.h"
 #include "system/hw_accel.h"
 #include "system/whpx.h"
-#include "whpx-internal.h"
+#include "system/whpx-internal.h"
 
 struct whpx_lapic_state {
     struct {
-- 
2.50.1 (Apple Git-155)


