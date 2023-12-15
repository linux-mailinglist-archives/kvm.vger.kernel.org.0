Return-Path: <kvm+bounces-4596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C159A815344
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26D27285939
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CF613B149;
	Fri, 15 Dec 2023 22:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="mviW8a/I"
X-Original-To: kvm@vger.kernel.org
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4149713B127
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.19.58])
	by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 6780910A4F4A2;
	Fri, 15 Dec 2023 22:06:44 +0000 (UTC)
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.190.17])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 0447D100017B7;
	Fri, 15 Dec 2023 22:06:37 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1702677996.575000
X-TM-MAIL-UUID: 3cf0ae40-e021-4181-887a-bfd49b216fe5
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 8CA2E100012B8;
	Fri, 15 Dec 2023 22:06:36 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4Jn66wI/Lm3/qbC3LNinLdH+HuVJQl8PYcQyX0fEuUZW5Mxwou1utglcNvJ6iNI5yuz+gMqy5SWxkfgyFfU4TVixWXAa4VmOeJYoz+0no/JfoqyxFdJFqDKNy7y0+SEOhYyRJqKES3Uzbef4flhPI+kagwiHMtjEfB9MzLOy1+F7WZaYQF1vnBmjTAYsnCR8OeUMSLD4yivL8jd7Q8MOBVpBjCaiHG2gg9Xh3VcngX1leaI/sSCbWF+4D9zpS3jRBG7zSBQcgEJxYSs2XROtGmtz41g6Hx2itKLjFtXcuI7kJt4tV2PkBjaDlOyj8FWDosb2M4F07Qe1M6/EW/4xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhgN1hN5nDXN/Fou+ALZ0OcVA9vQ13ILRQYwQOvZUNw=;
 b=BqZ42nXmzQnDA2NctbcIaoKFj1BcCCfbSo6WxL/sVOojt+z2PGvR9EAeeDf4chduqoRXg2vzxrcxBDKYlMcNA0iL00YQkS0FPoCcUl6rVsuKg32cvi/RB17u3ShJBNIsv2AzwT1wxEJR2CQHX5w0igbvXaF26FkkWp11pQO1VZ/oKEbI/em0w65t+qeotsFteBrqhroqcIHnoDDyG+HdmYHPYZO8EV8kWRax8FjlORrfo/t5ntK6GVPu1yzRJjWdwrJuyZbLX47tA0gXX4wju/n9fOYl0JOzGM/6CSm9jj9CYj2sGViCCaGHbMR8LA5zximRyqttCa9r0hnkhRHECw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=alien8.de smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=opensynergy.com; dkim=none (message not signed); arc=none (0)
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From: Peter Hilber <peter.hilber@opensynergy.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hilber <peter.hilber@opensynergy.com>,
	"D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	jstultz@google.com,
	giometti@enneenne.com,
	corbet@lwn.net,
	andriy.shevchenko@linux.intel.com,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Richard Cochran <richardcochran@gmail.com>,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [RFC PATCH v2 4/7] ptp/kvm, arm_arch_timer: Set system_counterval_t.cs_id to constant
Date: Fri, 15 Dec 2023 23:06:09 +0100
Message-Id: <20231215220612.173603-5-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231215220612.173603-1-peter.hilber@opensynergy.com>
References: <20231215220612.173603-1-peter.hilber@opensynergy.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR05FT012:EE_|BE1P281MB2932:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 282d9463-953e-4fa8-2bba-08dbfdba19f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8yYfvD9Hm4D60NL5mPXiHSSAAb5rEjKzsa9XmiaCfSkMKKJuQxpGofiNBVS6ZYdu2nE4XO14juGnkprupnHbDc/Fmele74gNyBPPuaeSzbBmf3qLU9bRHTK8bUcIC3+iEgcmd1N1PyMq4VazlYphbYcD+n1sq0r8u8mrR8Fr8Y/nXBA6aGb1roOKCMl1Up4Q9ijDDB5BJ2cAHbYqdy4FCKg3Ak53W0gf8aX7l5L+03snHQTApw2gfEBLGflmgyhEeyFhuFAl5T7vwZHCCrtFYWxHpOugMRIAsLSGu+waSXCbaZufOV8DPaXTXbTHaJGvsAmkDJJUtlqh6GUi+bSk6+GCungCI6cm2tFc04u1AxGFFRONJ8TeHPumn79AmMhwPGcMyziU0XpjMIRrEbNglHDOaFviD+kX46zXXJkBiFMgIIo2Wy5UxXtioadnzXTrXO4OXEII2VwvvTM7MHD4vmsX+XucBmErFQ8IWMAUoogfOjcPJoiEOY3SiL/doUwl6xwJLAqXji+5skVPFxWyA9Xxkj+rML3vxvIBXE8fPShhL393KjUGzWTf7Zl3JhvFzs33RkUMpKhUiaqvLxJ/yYXqlQTSaS9HgW7EKQ+94byxDDyp42gNefDeYto7CxEHHG1T0YbuuVJ+KlLe32m3RDwc8bOI5t+WOkuKvJ3bLJVT2eoNr4T1zZExNw5cLaBMiTXr22/uADODxgM9s156IP7DeJZDFzR42xigK8snhTTrnKqNvX1UIajmEyR5WMOx9+va1HDyWQy2O4Q1oWwjJdB5MZHku6STqrAYPkXQpyA=
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(39840400004)(396003)(376002)(136003)(346002)(230922051799003)(1800799012)(451199024)(186009)(82310400011)(64100799003)(46966006)(36840700001)(47076005)(83380400001)(1076003)(2616005)(336012)(26005)(36860700001)(4326008)(8676002)(8936002)(5660300002)(44832011)(41300700001)(7416002)(2906002)(478600001)(42186006)(54906003)(70206006)(6916009)(316002)(70586007)(36756003)(81166007)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 22:06:34.3467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 282d9463-953e-4fa8-2bba-08dbfdba19f9
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT012.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB2932
X-TM-AS-ERS: 104.47.7.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28060.002
X-TMASE-Result: 10-1.458100-4.000000
X-TMASE-MatchedRID: bjwz5Y9VyUDCCiFlDvprp7r2u0KWqQKNSDS3MUO7D/TIRhEhdkLWEovP
	iBq/iW91MpPx8OFzfY0wNyuTxfRm8ShARHtTtMpxhi2C7dlNKWrn0oaU6WM++5zYnFsPfA8XUMf
	79vayL5ANuimYslhyE2tNUNGl1uzREfinJ3N6jMzFTQGAKRxj5No+48giqZwnEgg3cwDHl/0S3W
	M79W3o4ma3xca03R6M/utaD2GffWo0zI7+eiZZ8F5CD/hq6siqFEqAM28vQO1Q6z0JFJrmFnhEE
	wH9X4REQE1Xqh2tz4E=
X-TMASE-XGENCLOUD: adbce404-56d9-4abd-afa9-55a092636643-0-0-200-0
X-TM-Deliver-Signature: B819EC21C70D82E2308EA9DCB3485B89
X-TM-Addin-Auth: 7n2liQSfv/l2jQ8mhkvQOzxTvEU6xMkC2HSJXzl75MYIDgpCyS9+QL7naJ5
	NEhnfryRmv8FATbKtHV4FRuhVJDXiCyNxiYywWP2h3r9YRYoeYuLVsxlbr63rVCCxr2+6pfhGjC
	27BMqowTqxEL5T8TsqG6Ck5ljt2D4KPIdCznnDAVMo1gTsYpbhKFTf9kpipIsri4lRnBhxsQ0+v
	uCiGnN7i2FBv+QY3yd3tCJbQjaIK6J8NpkIUIAHpERPJOXvQzYCnLF00ks6Mh463yV25r7FjCo1
	xWwkvxwPFZUqcYM=.Zr9HoGg1JNgvSbfKNJb4YLbipw0BMkejA1/LH1SN49l8x72K+pKj7jK0r8
	wL/r5nz2dlOqDi5P8cIRX7oOgdTuhRb1DYt8aCtqJ2eL7s/mhLIdyXq5LgZT/1LPFqN1x6KWdqJ
	G+qBX7xjxY1uLwRky54K31QkW6FPxs7Etig2V91G7PuS3Nrn38oioOUcH/lXq5OpJVl+6AGq8Ml
	mTRymcCsR60/lEr54f82zHXYjIh88khj/LICY9sck1GRTiCokHtYymJfJwzkpRrmYA+s2EkhzZX
	iJ5J85zlr/KQ9d2bm8WqyPMQfB3A9qi8D4YjE86bGze3aDTjD+rDd9GsUXA==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1702677996;
	bh=D57pOeABfamN98NGLpRroVr6iGToMt3H85oc0X/wUSE=; l=4724;
	h=From:To:Date;
	b=mviW8a/ILMUFUiUX4SXEVY7pQb2hpF9WfzofXo7M6w37PkAnjsyT7HaBMuXoILGdY
	 ziLAtJlqdnpgmPhByLqAifsQUUPJoeaWut+ZwdVibtyNsW7W+QGKtic3qVrcvu/NWw
	 fNJNyPeBKnkOkMIX9cUjZjgj0yJWIouJseUjPtvQ9mf6ydt0RWI8MFEZko6++j3YmH
	 BqtSSmpVqM+nUY2P/ogvXsC6AfoEBY4UXuvNhOPAyo2fJtg6KSck8ETG8ykIuZ8r8z
	 BZ34Ew49LojuW7RqxBXzmMuIaHDanS3CRoQ6nMP7+fs6zCKTjpYE+nw3cMQbrDJ450
	 c+f4IkhQ1tylA==

Identify the clocksources used by ptp_kvm by setting clocksource ID enum
constants. This avoids dereferencing struct clocksource. Once the
system_counterval_t.cs member will be removed, this will also avoid the
need to obtain clocksource pointers from kvm_arch_ptp_get_crosststamp().

The clocksource IDs are associated to timestamps requested from the KVM
hypervisor, so the proper clocksource ID is known at the ptp_kvm request
site.

While at it, also rectify the ptp_kvm_get_time_fn() ret type.

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v2:
    
    Added in v2.

 drivers/clocksource/arm_arch_timer.c |  5 ++++-
 drivers/ptp/ptp_kvm_arm.c            |  2 +-
 drivers/ptp/ptp_kvm_common.c         | 10 +++++-----
 drivers/ptp/ptp_kvm_x86.c            |  4 +++-
 include/linux/ptp_kvm.h              |  4 +++-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index e054de92de91..45a02872669e 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1807,7 +1807,8 @@ TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
 #endif
 
 int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
-				 struct clocksource **cs)
+				 struct clocksource **cs,
+				 enum clocksource_ids *cs_id)
 {
 	struct arm_smccc_res hvc_res;
 	u32 ptp_counter;
@@ -1833,6 +1834,8 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
 		*cycle = (u64)hvc_res.a2 << 32 | hvc_res.a3;
 	if (cs)
 		*cs = &clocksource_counter;
+	if (cs_id)
+		*cs_id = CSID_ARM_ARCH_COUNTER;
 
 	return 0;
 }
diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
index e68e6943167b..017bb5f03b14 100644
--- a/drivers/ptp/ptp_kvm_arm.c
+++ b/drivers/ptp/ptp_kvm_arm.c
@@ -28,5 +28,5 @@ void kvm_arch_ptp_exit(void)
 
 int kvm_arch_ptp_get_clock(struct timespec64 *ts)
 {
-	return kvm_arch_ptp_get_crosststamp(NULL, ts, NULL);
+	return kvm_arch_ptp_get_crosststamp(NULL, ts, NULL, NULL);
 }
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index b0b36f135347..f6683ba0ab3c 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -4,7 +4,6 @@
  *
  * Copyright (C) 2017 Red Hat Inc.
  */
-#include <linux/clocksource.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -29,15 +28,16 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 			       struct system_counterval_t *system_counter,
 			       void *ctx)
 {
-	long ret;
-	u64 cycle;
+	enum clocksource_ids cs_id;
 	struct timespec64 tspec;
 	struct clocksource *cs;
+	u64 cycle;
+	int ret;
 
 	spin_lock(&kvm_ptp_lock);
 
 	preempt_disable_notrace();
-	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs);
+	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs, &cs_id);
 	if (ret) {
 		spin_unlock(&kvm_ptp_lock);
 		preempt_enable_notrace();
@@ -48,7 +48,7 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 
 	system_counter->cycles = cycle;
 	system_counter->cs = cs;
-	system_counter->cs_id = cs->id;
+	system_counter->cs_id = cs_id;
 
 	*device_time = timespec64_to_ktime(tspec);
 
diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 902844cc1a17..2782442922cb 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -93,7 +93,8 @@ int kvm_arch_ptp_get_clock(struct timespec64 *ts)
 }
 
 int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
-			      struct clocksource **cs)
+			      struct clocksource **cs,
+			      enum clocksource_ids *cs_id)
 {
 	struct pvclock_vcpu_time_info *src;
 	unsigned int version;
@@ -124,6 +125,7 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
 	} while (pvclock_read_retry(src, version));
 
 	*cs = &kvm_clock;
+	*cs_id = CSID_X86_KVM_CLK;
 
 	return 0;
 }
diff --git a/include/linux/ptp_kvm.h b/include/linux/ptp_kvm.h
index 746fd67c3480..95b3d4d0d7dd 100644
--- a/include/linux/ptp_kvm.h
+++ b/include/linux/ptp_kvm.h
@@ -8,6 +8,7 @@
 #ifndef _PTP_KVM_H_
 #define _PTP_KVM_H_
 
+#include <linux/clocksource_ids.h>
 #include <linux/types.h>
 
 struct timespec64;
@@ -17,6 +18,7 @@ int kvm_arch_ptp_init(void);
 void kvm_arch_ptp_exit(void);
 int kvm_arch_ptp_get_clock(struct timespec64 *ts);
 int kvm_arch_ptp_get_crosststamp(u64 *cycle,
-		struct timespec64 *tspec, struct clocksource **cs);
+		struct timespec64 *tspec, struct clocksource **cs,
+		enum clocksource_ids *cs_id);
 
 #endif /* _PTP_KVM_H_ */
-- 
2.40.1


