Return-Path: <kvm+bounces-66747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E60CE5954
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5273B3004EFD
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D577D2E541F;
	Sun, 28 Dec 2025 23:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="SSYXRLwF"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster1-host10-snip4-9.eps.apple.com [57.103.64.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637A92E2F0E
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.64.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966260; cv=none; b=XLUtnpw90sHdpHyT1d0xwyQ9mbcox94A2QpyCFGcs3cqWRb3PbX+OkObbJFWtm9+S1jQ9to7hj3eDfdY49BS4yxdhGoWRaMjpsnl/eaO/dxlUCaNhUZXH7N+vARQRf0r24A/TJ5Tx3MlfB2vXU1xqWAzlg+ewyMp5ny6/hEtB68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966260; c=relaxed/simple;
	bh=wwRIGOGG3f/NWMLUmPORCd6Sb8VhrrLbjcqr5XwgFwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h91P2tMroO/U5QVHS5gAC8J3o1/MjnpMRlXHIHyJWKhyJc9Jq9It73JqoKfc53W+fX1m5zNj6xikPzY+TsXv+Vo9RFMMqELgUsTsCcFeYFe4AvL/oid3rjqh7qEsyjjmE7WZcE2lVdzNGFYSH0uhv2u7wU1rmaxZWQyH7KXX9Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=SSYXRLwF; arc=none smtp.client-ip=57.103.64.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 09B5C1800758;
	Sun, 28 Dec 2025 23:57:32 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=l9p5jVYclwL2K7rHpkywk2BNDTimX+u9/pjnya/K+yM=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=SSYXRLwF4XP5DxIuNHbG6I5tdeE1dafeRf/G9JPbtz8BdOS/Iq0xnW5zBNouK40s9Go45+lDtt5PQiHfSeOKvuYTqZeHYgHcA82RWa1kLAqOf0+9sE+czZtmOkXqiTvPngcNrxUeayKSfp4hmcY5HjiUmw7j0SL8hTsbJsWxPXilf0Xwf3+GjGLDXo8zGQz1Qi1YZ/MyJzpjRF+qGNt/UxVAwTwAah8PmDr/abLFLfqJSpEktpH+c1UjYoyEqe/2EFWswJNIzmtVXTw00vPn0cuOPH+tLzGaR7z3+nCImoLLvhVPYNaJoedjja+ubQilcXOPwfaxA0Oh+1++2xmt2Q==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 43CEB1800760;
	Sun, 28 Dec 2025 23:57:27 +0000 (UTC)
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
Subject: [PATCH v12 18/28] target/arm: cpu: mark WHPX as supporting PSCI 1.3
Date: Mon, 29 Dec 2025 00:54:12 +0100
Message-ID: <20251228235422.30383-19-mohamed@unpredictable.fr>
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
X-Proofpoint-GUID: BwVHizWFnWm1VBM6R3KOhjgWWI0doPd6
X-Proofpoint-ORIG-GUID: BwVHizWFnWm1VBM6R3KOhjgWWI0doPd6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX0QvK3/9Hlz7w
 VcahPj0JP/ojrRJv30SdUwCiMmEjggezIRk3HU1MIMy4+EQ+KaaUFn1eqq18SIV3/GBbdttsL9Y
 GEqzzRxA7KLyjWNZCdvRaac6/GN34wG+nccWfiFaiQ3ZpwLqAnD4N1H7ucIIkmP+jZVR2vdJF4j
 PNoiz/9tIUEjbomeyKGhpZaZHMU303NyYSyAbYdGl8nEAU70/yfgEFjmNHGBxN6Lv441iUl1sVu
 65Ex5gZj5AA6A8LJgL67OUqMPE4Piy+HQ72W59J2yVgwdACeAjbV44xJJ5uQWC4dzq+1TI1YQbs
 mxNQt7pywSJAU/AcVV/
X-Authority-Info: v=2.4 cv=JNo2csKb c=1 sm=1 tr=0 ts=6951c3ef cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8
 a=GfoCO2L6IEBdUbzNuv4A:9 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1030
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=836 adultscore=0 classifier=spam authscore=0 adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAABxRQk+tUnd2d70/KUJLWB6ghqRJjyYrYIG/5aI6Wn6o5UHJeuXqWp24GiIgDPWMweAYmKzHTBBG+dPtnarlFFBjF22S0oyjYlZajywsFywUPLxO3yxUxjj/RoGrfNQgoKUlf5I0UC56+nDQSZ1u+E1nu4q6EaV1p7+qpWxoimNqmjEipBuf0svZ8KRBpSPTsSmII+d/YjArsHzsXSeww+rQApXChBpTNjHvI2BRo2hi86sCcmahvC78CkF1/31j+j8Z6JU07E4BkgGAFHz+fYAXCWG8JANGuE2/2atsY1YMNQaAvmSEPyw/7tp6pAUPZLpO5JY1puDDydctMs79xzXMzlGYW/Rqa+B6uwihjOlSnzH4hi8OmM8TSxqQnlqozIbKv4jxt/eB/DmsOpvGN58fnoSfsRdBR9jxcAKxLJ7Slv2DplCT+zR1j5bBxfq3NpPy5YFvqbvtrdwm9auTsU580JbPmLB/Er+qmAZpKG7H9BrPvy7N5Zwdr9ut8QPkw7EAJw4z0200Ru0g9A7z5PHCIzk8kooL/tffdQSzcb9H9lFPUfXiAqP8saeN5bXuSJzLu8Ho+7+wjbCE4+yWeDrzp9qwed9+jdC2fkKZjW48AQRXPY6um+xTcB18YRmBQWcxell9n0M0vDKmStczDANkHW6wEZKxnfD7q3d0E0FKQTth7PZw5w/J9vFmSArtpGOkDpSVBHF3GcPmQ+r7BoTaj1kivdf9fzepcMB6n4ChKmWEq3m49w7QfGArYheLVuaO5SfVZSf378Ty/y7AshqW431UUjAP07Sasbvxe2N5O5RSN5npvXWE5gpjuyrH62l1WaJJ22ENtg4V5nJO2NaH+QyblSVbS+ejxkjOCnlt3je6CCI1l9rzAMe/8b0BXDG/Ac4VS4XiqF5pVPpfQea31def9csNA6yFj+u7M8919vpqDKMm71uW2BXtWANjRjRS8ZRtUl91yUtXM6IW/wLth
 yWz2EZqul/V2U5YVD8fG6

Hyper-V supports PSCI 1.3, and that implementation is exposed through
WHPX.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index caf7980b1f..70f0bebd19 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -23,6 +23,7 @@
 #include "qemu/timer.h"
 #include "qemu/log.h"
 #include "exec/page-vary.h"
+#include "system/whpx.h"
 #include "target/arm/idau.h"
 #include "qemu/module.h"
 #include "qapi/error.h"
@@ -1143,6 +1144,8 @@ static void arm_cpu_initfn(Object *obj)
     if (tcg_enabled() || hvf_enabled()) {
         /* TCG and HVF implement PSCI 1.1 */
         cpu->psci_version = QEMU_PSCI_VERSION_1_1;
+    } else if (whpx_enabled()) {
+        cpu->psci_version = QEMU_PSCI_VERSION_1_3;
     }
 }
 
-- 
2.50.1 (Apple Git-155)


