Return-Path: <kvm+bounces-66756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB30BCE597B
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6125301B82D
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4422E7BAD;
	Sun, 28 Dec 2025 23:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="GTQ8V6nd"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster3-host2-snip4-2.eps.apple.com [57.103.66.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502E52E7637
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966307; cv=none; b=fzdi3gkAwcSuC/v/aK0FWmfQTAl/Bfhfo/l5JOhhOgCivIQyu3YsoMIfMfdkGn1iYD+ffDWbIW6ulKhVrogigUoxzPUwmIrX93zXQIpuds60rmDN30xol6d+f4uoccot1ZtVfwEH9BE3ZXSu99/I0sm1vzpEPHmUqAdvFhMW6bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966307; c=relaxed/simple;
	bh=uZ1CNkFl1tSlZ/Cx+oDuKsI/2KL8rkZbNFzwv/p6LX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfpbd+6jaw8Hl+zlF4DnR8JPGFNIz3zU8hUHsnS04lDl3ASfwxFtAQxS79tP5wnj8Z1by6Eu0NjSl865goQvIKx2hQqyfBKcK/cRvzG2YvHHkTr0fMaw7i9AW4qIeKnoBQVdXJR6k4bh1DK5xReoZdrWKsXC0UKkaaNR04tFYmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=GTQ8V6nd; arc=none smtp.client-ip=57.103.66.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 22ED91800754;
	Sun, 28 Dec 2025 23:58:23 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=L7mT2nD+Ba0e7wIL0PqN3n0dkcKAmO0tlq8DUQcg4f8=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=GTQ8V6ndVUzUrSiGyLws8UAnMMl58UJC+Ze8/aSifDruSX84u49YTwlCWQ8r9MsUr+kmDHE3RXGhvBaW5PNtr1If/W2KMm5WdpCoJAa9HTx4CkAHubNxgRlofP80724yBKeeWxuyAxypwXgFGot5OoecuEsVLbUOnDIdcbekOr0GqCkUqnWbDYAPrXxRHkI2CExiOeQq1GK/430V6JaaBEH8SiQtxj2Uv/JuO1U84txsrnHqdAnzcJLHCgC9Y9tZfKOI0SYW7212O6A//4HK8iieGWakg+n6r93dmJ8i/bLDIIyIfV3iSiMse40K9Waq4VUdkTtDbp1SvYwOoVSwyg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 2A9A11800756;
	Sun, 28 Dec 2025 23:58:18 +0000 (UTC)
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
Subject: [PATCH v12 27/28] whpx: arm64: add partition-wide reset on the reboot path
Date: Mon, 29 Dec 2025 00:54:21 +0100
Message-ID: <20251228235422.30383-28-mohamed@unpredictable.fr>
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
X-Proofpoint-ORIG-GUID: KPGogu3uV69M0IsFu5oeu1r1YuBd0nfe
X-Authority-Info: v=2.4 cv=CtOys34D c=1 sm=1 tr=0 ts=6951c420 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=h5GvOLqLgfJ3vAEETv4A:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-GUID: KPGogu3uV69M0IsFu5oeu1r1YuBd0nfe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX9m0KKcefk9NP
 E+ec3UdtAYe8dx20IV2y+aQmpLPrfgqKeR0pm5jvIBTKUYk3qexQ8jh6ICBa9YXr5tRh++xtmb0
 y37Ppv8YCHmW1Xm+VfQM9rf/bfRSmTAHRD+KUeW91sEwGK3FSUUIWIPVzSaZykiXF0s8t2Cfywy
 ItUnrwlFVBoZO6CQt3EXrlmeBDxRMYbnFcK3FvyO2Tl2DR2xugA+1VDg9J4AAOE7rS+HTWpOonE
 ZRppL95gVLhGuR14ENIIuVNbRc3C0BS/rvzoVFSVTgbmV9bhXmVGCQLda7e13i6M2ZB6ZJC8AiO
 sjarmlwJ4qjG30Xq+Cv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 mlxlogscore=883 clxscore=1030 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAABYC9Pt62b4I1ZKDRcZql1avM8R/AM7rMiTQRLB2KPV3Db7n/ZDmAlB78DDj8xUTUANSMBNi/RvyqwZmokoM3Z8vqjN5mFOwZPo64tFN6EzAZDImPS/VAE9VnqsMtwUPil+K3lwK4Uxz6uCBaUNhH7Yym4DyigERoPcZx16gmbn6QlyVS7AnNKfVt6AP7sbWW7xfXb/VmfA2PaxtA3LGErjBMZYchZO3iEhblJ9CPi+o+DJCFZFzs4M3i2e5ANbVTSBskXZX/rDzyuey30JiV8hH1dAMgKSnhDtLZ9lkwClQJNIhSwlF0/Un9BJxIQ+Rc5KDP0Nt6+FPzUe47rsiSV2mE8GqOr/7eOg11t1SB3x1WCzw9YdK3uOS1yBV0aWm0mRRwC7jlQ6q3vpuJU8cpIYENopGEinl7kW5CJz6wh/VaatnZwoj9jl6RHOv2xvSJItnhpF4iERFlO01jqtQ08bowLxefco7nxi0CVV8Ci9BjXSXVGHHhe9elUuMQSDdUgLuQWkSfXlc/jcEiWNlnxR17QW0UYaxxvAG3qAxYEtNcXvFjXcohRQ/YPsMoQQ+f7x8xIL9YZJsLO6vdBUDZDQ5di+nzqo4CBcfSFzVbfw9KkeYWi5y1cYv6jIgOZ96FH5TB7lPN/h94u7ik9G5z1RXZMSoBNW5eJOphqBLvt2AEnbULdWsTlvqI3jYWov6bkId8G3HaFMJ++JKGf4VQeHgroP47CNkchPk4Xd/qjkEO+0C/Uv9DcBODhyrtLyxVhtumASgWRIHlU5BRXl6YER+6OsuKK8jhPX5Eq7067X+1SK0b24yMuhs7K2RFbccY7UDSHLeUcdMDzZ4Y0/HI2Io+A11L7IPV6NxpY2TC5kI4FQhItkunJTW6TkjEMPMhsKYjoX1PEXlgmuBv2lIU2gkEWZuw9T9EIlfQjtmPD58mklT09EzRiEdt34cw/COJ1

This resets non-architectural state to allow for reboots to succeed.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 include/system/whpx-internal.h | 2 ++
 target/arm/whpx/whpx-all.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/system/whpx-internal.h b/include/system/whpx-internal.h
index 9e872e5f56..802fa87765 100644
--- a/include/system/whpx-internal.h
+++ b/include/system/whpx-internal.h
@@ -94,6 +94,8 @@ void whpx_apic_get(APICCommonState *s);
         (WHV_PARTITION_HANDLE Partition, UINT32 VpIndex, \
         WHV_VIRTUAL_PROCESSOR_STATE_TYPE StateType, PVOID Buffer, \
         UINT32 BufferSizeInBytes)) \
+  X(HRESULT, WHvResetPartition, \
+        (WHV_PARTITION_HANDLE Partition)) \
 
 
 #define LIST_WINHVEMULATION_FUNCTIONS(X) \
diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
index 2e5ece45ea..0e80ef771c 100644
--- a/target/arm/whpx/whpx-all.c
+++ b/target/arm/whpx/whpx-all.c
@@ -497,6 +497,8 @@ int whpx_vcpu_run(CPUState *cpu)
             if (arm_cpu->power_state != PSCI_OFF) {
                 whpx_psci_cpu_off(arm_cpu);
             }
+            /* Partition-wide reset, to reset state for reboots to succeed. */
+            whp_dispatch.WHvResetPartition(whpx->partition);
             bql_unlock();
             break;
         case WHvRunVpExitReasonNone:
-- 
2.50.1 (Apple Git-155)


