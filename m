Return-Path: <kvm+bounces-66731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0AA2CE5906
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 830EE300442A
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376E92E173F;
	Sun, 28 Dec 2025 23:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="bdnMWOfa"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster3-host5-snip4-10.eps.apple.com [57.103.66.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5F11E32A2
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966143; cv=none; b=PXXA6qTp5IdOYRuNRw3msapPXhD6h0xri2qcSxA6ZRHcfnSIRdKpvFYGasNIQDbvxO0Jmr7Exs+SSGyZwKbfIdyqJ1y5107g8DqfwAnBBhb7Kkj2UpmsNmEE+Q00DOfG4OGNxCoSNn+CiJ4Skqv7yIXs3dZvxWOQnWtpybawQfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966143; c=relaxed/simple;
	bh=zYLQVDbjH6U/5wVrDJdcy4U1ETlPIZJW7JCyPKEFi7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZ4eksVo66DGkMbC2+aWc2Ldc6i7OmDguHjC2KWgo/nOlnKG1Row+dMHNWY5zniXODM5dPyoLBtFC1QlEybvnbAaSrWxwkrkNEGJlspM1AQqugbz/WU8IbtuW9uqU4O9qIdZqf1uk7BgLwh/IKvGbS4uPJxuUytnUMeDB7PAu38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=bdnMWOfa; arc=none smtp.client-ip=57.103.66.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 2EA8F1800748;
	Sun, 28 Dec 2025 23:55:38 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=aRq3YU5535mG5uSPAFBSlmsbBJkL1R5+IAqIsTf/zZw=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=bdnMWOfahgz6fnYRjVy9cKGOj3Y7JQrUtnQV/V1AH1KWi/smWESPc1GCYDO4op+vOO/FmuQJw1udQ8a2/7fGXrQhFARizktQi756xP3IKFKXVQukm9tlVGBW1wD18u5hBUIJy8R98/TDnYJu++Cg1NXAI9ZEHZqC8iFyaCV7HkShIWgFFdt92Y5nYSBf4P8AG1R6OItSRSO4mzr+WvQvikxTYANrFsvFHCghjC+PsSoM+EaxErFuYTWlivDE43/qcpLtChkE0LmEUstiQ0qKHJW1mIiwAT5JbAzlVsRmFJByUQvQwEOp6X6JJnp6HyX740TyEPCdHrm7r+D7fiAtKw==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 2B5F7180015E;
	Sun, 28 Dec 2025 23:55:33 +0000 (UTC)
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
Subject: [PATCH v12 02/28] accel/system: Introduce hwaccel_enabled() helper
Date: Mon, 29 Dec 2025 00:53:56 +0100
Message-ID: <20251228235422.30383-3-mohamed@unpredictable.fr>
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
X-Proofpoint-GUID: oGpg2w8p3aeBitWq5trlw_Fg7qxPMaNM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX9GX8lbpm4kCp
 PIFvOwMW9hJXdbT+uj0FZHxRAdjwdPN6XgUpzAQ43Q8SN5pwqn8rYdWXRfup6bz0Z0NpzwaslwT
 MGjDcGqbfNx74L6ezlTtZOYz/SQ118CSrmADCw+dYAl3YK0NVNgPdl8xepDucorTu56cA2BXkLn
 mfxK1l5Yz8Ot6cDGCSZJrFixVIeghbo2ObKE7UjJXwFlbNZjHa0hn4omtjmsN0fv5CFCK+6gCa4
 58raDOcBn+Bt/JGMoyp8L3qHOwc2VJ2qJfmoiJm1oUU/n6NSegOAxziUH6F1aErpTbInht9U1m3
 8dYs0I8qPXWZZz2Nl2S
X-Proofpoint-ORIG-GUID: oGpg2w8p3aeBitWq5trlw_Fg7qxPMaNM
X-Authority-Info: v=2.4 cv=drDWylg4 c=1 sm=1 tr=0 ts=6951c37b cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=e3h0T9cBdxntahtQdW8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 clxscore=1030 suspectscore=0 classifier=spam authscore=0
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512280223
X-JNJ: AAAAAAABoVcFCB49ye50TvD5t5xrezN5WMd1ltYhviWFt8ES+u1Mhf60pkgNJ1wnWeihX0LWzVUrVKg0Ha45cpHgIbtg5CzspMmYHYMYumPT84+V/c2+mq12Kqkng49lv3x6cP7bFEyNu2wbsQvqCBokK94aB+UXTYNhoiwGZSQ0BODJ3SPkvWvt0ov/l/S9CeZc73POUpESFuipph3wBdbcQ/7PE0ehutadZFAjoj25ko/yYdQZPi8jUvnkjmzPe6EIGogFcjP+OuZPu8ABSX0SnqUoU3TlbH40hEZ7dTwPV9iuHTa20zCPlPHhcBmzGsRfdWHl2aY3vTSKlYQhL/6L2qqeSG7I560RH/Xm6B88eBMFkNcVev0s+rUip2t3ZtA8qE2RCzsg9xZ9MSVo5F7QTYz8nKccmfbaQllz6aOLmRL1hjNSKm+SwNK4pmcfyKgokPYaz3gClsqoxBhuS3QyBX/NinA+Igqg0TEBDG4ZeWSFazKt/1ufFDBVWvqRLeR7ZKgHkVSJpTsi7yVqaPc/C+qtanbTwymyXpwM4b/NyS46Li6JFpkpW4Awyb+IEV3eCJ17uN8j04KLkFG/79YidXV3ni3m8aPf4wpkpiDSrV9Fua/zAuG1GiKWn6nO5otQpRqbiBNSYcCB7WbMsIvXeTXUFI+P6vCTEOAf4pM66WWvHgoCnM1jCVObW6WFi4AcHMBvnp1lkNDKPUsOx44BRTQsJ4DqxJEH4uMhp81sd5om6/6BYC+h8XIffsn57wsWRxJEcgI88eQQ8sauD35NM04P8J5CyndzcmIQvkUiqyM6kuZ7M4ruvzZW6gIZcBptDozFST/mIbBU4iZnLzQMTcnGmcZZrpfaBIgsWqWFRBK4W5/z79v123ox3mrmoYr5PXnIXq2mgwSGdFCPU+LUkdFEqAlNfZq/Tw8Hehvo0x/i1Jq1emOGgqNYr6iS14uUdthxRuBvwftxVUwjng==

From: Philippe Mathieu-Daudé <philmd@linaro.org>

hwaccel_enabled() return whether any hardware accelerator
is enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hw_accel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index 55497edc29..628a50e066 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -40,4 +40,17 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu);
 void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
 
+/**
+ * hwaccel_enabled:
+ *
+ * Returns: %true if a hardware accelerator is enabled, %false otherwise.
+ */
+static inline bool hwaccel_enabled(void)
+{
+    return hvf_enabled()
+        || kvm_enabled()
+        || nvmm_enabled()
+        || whpx_enabled();
+}
+
 #endif /* QEMU_HW_ACCEL_H */
-- 
2.50.1 (Apple Git-155)


