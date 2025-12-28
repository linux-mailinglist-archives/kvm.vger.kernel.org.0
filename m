Return-Path: <kvm+bounces-66753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E320CE59AB
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 01:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8967E30072B0
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A186E2E6CC4;
	Sun, 28 Dec 2025 23:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Cc80Y0vB"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster5-host9-snip4-10.eps.apple.com [57.103.66.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9272E613A
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966296; cv=none; b=CyM+n9RAMGayLmk+y7ku1jiqKSQCA13ZdoOhC1ZnR+lypIMZYALYunNIsrJ+3CmSITMFBIB7rRV99+X2CLfwBqAqp645QRI/awR+O9ojR/e2iGRm/YoTV9g6AqeQ6SDNsjct8b/HDAkGdxthw+KqiPAioojPQktvYgJDuj7NVgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966296; c=relaxed/simple;
	bh=3MBWmOuS36ltBs6IVmw/mc/3ftEDOleFMNQm8tXwy8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFCFREJQ9Hsy15RiHli5G+FfdeH5SGF8UIoB3AnxlRtWHUaq6sH1fMhdFcSTSu/S8yKvaPai+C7uxrKlm1a+gfSmBcgBwFGxRkgPRaOQ8PgmvqdlwOIgfEFzsHvU650EollgseCvCMjqkq0tj7xWe3wOhLYUm118wydJ8WiziIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Cc80Y0vB; arc=none smtp.client-ip=57.103.66.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 09367180075F;
	Sun, 28 Dec 2025 23:58:07 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=KNda2FnGVdB+1PuvMJJo6JwnL0/5/2Oo7u+nyBw0Jtc=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Cc80Y0vB5ZSeGN8OuhTNFNsqRAyw1TtlVWmhCPuAoE5YBOgb4dEUJKBWFRbd9aQuR5Ss9mvu6jocfbTyjcbpZsVcRjFQh3sUhZFtYZXgIj6ri9PM1n1KlCOXXyOjaHluMraUN6dcGk4uPibgB8Ll/iRQGRwSUEE/ugoAcgrnFF1f02nspHi1OtJvnrXBMvRUDtGc756LpcPkomH3qqSyX3rNfHlU5ZCE5GYp/HN2rctl4UBJOUcTOJ73l00dkBjBMGvqu+62teqMAGvd/OM7hJ+1BSLJcZubCcbGt7GUsASzzYgOL49wG3Xe6i09GWuBA6bOcVvfo9tR7u/2RrH0Gg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 37F5B1800755;
	Sun, 28 Dec 2025 23:58:02 +0000 (UTC)
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
Subject: [PATCH v12 24/28] whpx: enable arm64 builds
Date: Mon, 29 Dec 2025 00:54:18 +0100
Message-ID: <20251228235422.30383-25-mohamed@unpredictable.fr>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX96raMmH+vzwi
 vMDNQYRvozKfq0YvcbS2rScyJjDnp+3SfE4fTlk8ZgCwdgHjFBT0bR3NFxr2Mf3e6665/wP5zFj
 xu22+CZc7Vgib0IC1x0YBDy/cmJGFIw3XOpgRO9JALlDU2mRuuTrAaQTNQU1EwI/j2g1Lprq+Gu
 xdk/CDOu1LakFGjqPF3iqlNmM7R0rpIgG3nBICFl6okhzKGC7OipSRf3rXCy/sU+7CeuOhuL86g
 EDjSueR4tmXCp8NOf59XJps6qXQwBLbbTYoXsCW/kJ37vLfdbryzEWQ1yhAPnGMp30C1Mj1Pz0Y
 m80V4TO5uizQKtl1DsL
X-Authority-Info: v=2.4 cv=csSWUl4i c=1 sm=1 tr=0 ts=6951c413 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8
 a=Ck9h3XeVBPDugYI9Na4A:9 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 3SD7tV2nlMz17eNSRBslENJ6_NVMFYEe
X-Proofpoint-ORIG-GUID: 3SD7tV2nlMz17eNSRBslENJ6_NVMFYEe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 clxscore=1030 spamscore=0 mlxlogscore=742 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 classifier=spam authscore=0
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512280223
X-JNJ: AAAAAAAB1MFkOMbyechtoT4PwmZrc8w0/Vg8fgnzC4Q0PTdLdt9m1VZPYcQO71wwrJcns4HsQrOydKJW0jrScbNCIP6AFMa545b1keyhQgagz8Th1Ic+djLkegagsECOq7/z33VPofv+tQcjUxxIXPA97/zPi4qY456A0zRyULiD+18W1f6UdAyyFLJeHZGPHkDW9KP5GT628BnpRI+3/EsfX5kV+eKuETvzy/4ificohvyIBBqEf4KxXvDgR9fbCcSrgdxeZ9qJ+Xy50iBA6jiKKgFY333iCpYDyy7vm32wKjsqTK5G98zLLGVyHKBr8aPicwscX6sb+j+N5q5GQtb4cwAcj0QrmhhukyjCmYXYxuLH5g6PxlNaLYO7XnNG8OIIb8UVdL2BxHmd5pmdlKIeMAbyOgDDywKi5PWDUIC6Zy6QJ2wxo5qUCXUK6TUFJm5RfBCgepWF9HPRaU7GQr5V7gaOi5lUJGNhy1QZsIfDu2XCHC08IkMeDihEHzYL7uelW2bRBZhExSJcZ0jeWOevxCIi4lxboqpRjdhHBL+wiO6nMDeR+CIg66xt2TmfmLWMncGGMUWnhVsM7z9WvHdVfm+NH7aKodeYXSFg0en8o7v/WRtg82vQbElJyx5lLhhS++VFmxwwobGMSkTQfx9Os7gbUUnXey2ziEntvxGglkvc1ATXyq9S2SpHyVLEMUAsaOOJksDeW2SsXS+I8Mkvayu/PKLGbh9E9sicXZf+ZMA8KM6Nhk3UDvXg/egmk18Qu+K1DqWBn50ueHD0EnyBuP/1qz5Daw6xsT33ACz0e7gKm5idWC55rCyXdsjZBRTs11FBzbfakXHmz1e5poa5jNyHZKi992U9y52l+cbmhCM03FgQeC02RQJ3fB4lqh5oB5+uAepIhYviw1l8l2Xo/5T6PHPyMkOSuXiJ+eWjO7UfMZdnAciGvDbjc3JxXBYW1QC88vQ16xU4n+Ne0ZOh7c09E57
 D6WoO

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 meson.build | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/meson.build b/meson.build
index 14b1160c15..7421ead19e 100644
--- a/meson.build
+++ b/meson.build
@@ -317,7 +317,8 @@ accelerator_targets += { 'CONFIG_XEN': xen_targets }
 
 if cpu == 'aarch64'
   accelerator_targets += {
-    'CONFIG_HVF': ['aarch64-softmmu']
+    'CONFIG_HVF': ['aarch64-softmmu'],
+    'CONFIG_WHPX': ['aarch64-softmmu']
   }
 elif cpu == 'x86_64'
   accelerator_targets += {
@@ -883,13 +884,18 @@ if get_option('mshv').allowed() and host_os == 'linux'
 endif
 
 if get_option('whpx').allowed() and host_os == 'windows'
-  if get_option('whpx').enabled() and host_machine.cpu() != 'x86_64'
-    error('WHPX requires 64-bit host')
-  elif cc.has_header('winhvplatform.h', required: get_option('whpx')) and \
-       cc.has_header('winhvemulation.h', required: get_option('whpx'))
-    accelerators += 'CONFIG_WHPX'
+  if cpu == 'i386'
+    if get_option('whpx').enabled()
+     error('WHPX requires 64-bit host')
+    endif
+   # Leave CONFIG_WHPX disabled
+  else
+    if cc.has_header('winhvplatform.h', required: get_option('whpx')) and \
+      cc.has_header('winhvemulation.h', required: get_option('whpx'))
+      accelerators += 'CONFIG_WHPX'
+    endif
   endif
-endif
+ endif
 
 hvf = not_found
 if get_option('hvf').allowed()
-- 
2.50.1 (Apple Git-155)


