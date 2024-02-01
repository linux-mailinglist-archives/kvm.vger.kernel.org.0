Return-Path: <kvm+bounces-7639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28A2E844E89
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 928381F2C973
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71192FBE7;
	Thu,  1 Feb 2024 01:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="V9n3kxsb"
X-Original-To: kvm@vger.kernel.org
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7C25CB5
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706750020; cv=fail; b=FLLk0uuU4/OYM4PXyRPdxPPTPcv8XvtkhZwN+1ufqA4v3+ZoKkwzWA60UMStvAGyfZ7RaaMf/Ncp/8IhpijglfCv2kLw5o0G1qeuhTBygnneiVArcUzsvr1U+NcksrcuNuya/4MlzNjRIqFclXF2RSwGXjRebT7cT0seFRuzUr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706750020; c=relaxed/simple;
	bh=5YtK4a4nifkYy7D9GImx5YWZNY7r7bQKqO6G1y6uwu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phAXHYst8TbDjNiP10lsEpRkU7gM514UXZc8jDBYJ5QSwljOuFUcDMrNEfhhBr3JP+K9Sv5g+nhwhaxIvGCJKW3wLajKmS7C0tMVyVBi49N+M+EeRycxzqR9MbCK1re1ECUrpjlGQPfrM+QdCQETGrj6NKTkHSXhiqo9Wlp7LQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=V9n3kxsb; arc=fail smtp.client-ip=18.185.115.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.19.81])
	by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 5BB2A10A7E2DD;
	Thu,  1 Feb 2024 01:06:31 +0000 (UTC)
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.176.220])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id CD5F2100004E7;
	Thu,  1 Feb 2024 01:06:23 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706749547.193000
X-TM-MAIL-UUID: b05bbf6d-8b4b-42d1-8a10-3a4eb6c9942b
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 2F5651000030C;
	Thu,  1 Feb 2024 01:05:47 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxAE+zjcXonRvxWcg2KKBiAorb5Ekhpw7TzXJC0ymiBcNT6oQXKU0rKS666Y2qE/h0X6ZKNKQYsNvxkvyvQSkzlXIhaampPoDUgGflZfc2WUacX8g9HhWq7qzE4KFsyX+ApRT2ChQmWntBRdtOSDe4wTturGKlVy2uAlNeeCYmKZ3ECzGB8w/mDViikiY+C5TLxabhG6Fy7Om1crN4KYtq4F+ZgqfxvGVmKqWUnqUHe7/oHWR9tk0m2paXVmXlEnb4UWNlMjWBuM2AggHyY7aa2Ter7Ih0wXYGA1AZxv/6d8Jkcsl0iUp0nLROn1t2O69cJxaG3A+efFcYECdpYhIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KYjWDpJ4m6ElafzQDPfs1wFjYeCwnJ/3eTVK+O6LPg=;
 b=FitptyKP4tdsDRVInPq3X4mqJSjchbb8jbZ1d8Sz5ovqFlM1EZElcrruVMHReiFu7l4SFxW1D+aYMR4rgjjbjc8/qISV9Qzy2Wgkl1GbGSqI4LLXZyA/e5XWP4M+2U2UsOd5MXm/I+B+hyWeS72MgJkVznDtj0Nsn0RMdWY6LeRbGKGxF21A7XTaNuVCJJO5SAjutMz8y38VGyzMbRbLCprT0pYUiaBIt+st9tiIz5DFZynaaJgedf1zIUBQ77JF59QTmlHfsouBAKXLj461aJ9db15BGKvejpUN5oxsdF12tyKaDduxbcQbENKvaXVPkSt0uechKCpwdlOwCk8TSQ==
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
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
	Simon Horman <horms@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Subject: [PATCH v3 4/8] x86/kvm, ptp/kvm: Add clocksource ID, set system_counterval_t.cs_id
Date: Thu,  1 Feb 2024 02:04:49 +0100
Message-Id: <20240201010453.2212371-5-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
References: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR05FT057:EE_|FR6P281MB3654:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 06b4cafd-189f-4843-05c1-08dc22c1eb45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CGH93QONNpnotSd5ir1KXFLAKLHO0g6xDMneH3QMhTOtvmUM9U8+75fe0QclloegLnh36K2b0+9GkMh218dHEPwTOlqej7nK1FHgLgkgMydmNpwGzhrvNxLdQLZ1Nn6Z5vwSc5WVowHQ0KT5fQj6QpRmqypHPVrZjyJiwpGh29tSmpwM6KIVX7gwALP8L8iOtfO75362Xa2csMgNu/2/cui8toeX7TFQMrPOuqpgiYYXUBgPIUqxxL+oeXzwXgt6aArK+AG9fCGHG/qXLJ6BH3L/F+cnXcjcvhw0lYyD31/hiH0daSN5nyuMie5eQ1aPKOQYHZc82Owf/+FzddyOW90O3lQ6KfgsY8sjYyBpAvtD8WxZogHSUWHUWzKkaldW1w/Tyj43nHS22QGEmSOAfssVZVUpS0ZcY7lq7dn3JNQ8ONkqwRgnrMNV7ja5U5h2zcx4hPoH+PhWNPNRFTrJkcuB4an+n5ZQ0wk+/irFNrC/pA3RJYOIOj3cZy5CqBJMVADTx6O7upVM1wE5JBoJiBkshVjGqu78Ldmb9dloJBIOCWfy3p8UdvErYIDOPghTHMxU0MELt/N8LOD9ZZ0N5j0aFFrekL1wYeVXkMAAjGf5/RaPByeAklp1dHC/zRBFxTFneYrimBqIwJ5I4HvgBL1ICrkAl/HzQjbXEChmI+cCmr4rpyCiJISprnrYy/jGRyhbOkK3tNIRni2jzsb4QKPHnjiKs26B7aBlmdn+J04cMLIExMRVJ7hiW9XACKL1
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39840400004)(376002)(230922051799003)(1800799012)(64100799003)(451199024)(82310400011)(186009)(36840700001)(46966006)(336012)(5660300002)(86362001)(41300700001)(36756003)(36860700001)(47076005)(81166007)(316002)(42186006)(8676002)(54906003)(4326008)(70206006)(83380400001)(44832011)(26005)(1076003)(70586007)(8936002)(2616005)(6916009)(478600001)(2906002)(7416002)(40480700001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 01:05:45.0032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b4cafd-189f-4843-05c1-08dc22c1eb45
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR05FT057.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR6P281MB3654
X-TM-AS-ERS: 104.47.11.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28152.007
X-TMASE-Result: 10--1.472000-4.000000
X-TMASE-MatchedRID: SzbEz7SZt2vJ+P2VFrJmrN/Z7q+hZQVeET56SaIP1M+3UJJ8+n/4RSVv
	z26lmBXMFRlFiUGUwEmxjL2S8+j0lhfJ8eNjkTqdiu6u4shZ+fGDPlWYpnzHzmshUDcgZ8ILoMQ
	NBr66IpR/Gj7DAMEZmgMX/QeBIae0ez0KPZoFPyh4ZqfDdG89LitlpTPi5tO8MHiMmW0ZUNss3n
	AY9fdM9dh5c4TN8zbZ7PVkFWMnCn8N5Rk4kJccyL/a0nd+hIFCI/NGWt0UYPCKAhAjcFxLY7vRD
	AstQV9xnkz5OiQq1jJyAc4P1/IUE6iCvOFGVAUC
X-TMASE-XGENCLOUD: 3bef6c72-1ea3-4c1e-8ab3-531d12416ba7-0-0-200-0
X-TM-Deliver-Signature: 5ABE237ED0DAA6C42DFD5D7901FB2AE6
X-TM-Addin-Auth: huWxA5dvdJK+KqvepDjR7IiEWLwW4lQK9IP9AgwcLnrCsaiYx4kbtEyM7wy
	i8lvS2sosGbZTMJc8ieC8Uy8FPJq16GO82Rq3GAqNqxQZ0I68KFqRe2OQBp1V6xVWBwukPEM3AV
	Ef3S5GqZ8EZI17/Wu4yNE2dmvCVLAfLL2OygIrHMcf+rWTKav4AJd12GtX7xM0AM2LQNQ13LVSA
	ldeqaFiVOhP8fvcRwKtYZDYqP8nji9/RyCu8CfaN2zgZXMPEvNflR+KvybAXGfCzybHLUl5joEr
	VsOv8qJG/cAFm9CgJLJQF6HzgK14h9fLzh5D.nUEaiXUYV3LXvv8D13L4zaL2ak37HWTRFbaP5H
	Xon0z/ZVS+oIlGFsTpOAlLXImfzg+mJ10khzOHr8wmR0ro5+1qEtgx5BNTZQ1zLlqRQjX5wu103
	bajCMyp2q1oIonqd0T3pvLMDnGmaxHIqyck6MrCePjlTZeOntY4xpSDsu9djzuiA2mOUi5yP45J
	LawTUxWfPvODDOhlhYxZPwoDwyyDWp3qs+vgsg9kvV988PUkMZLIa7ZXqi42KtIkc1zY2F+yhtt
	pwu6ItBTzByfSeascdwKcSMrFDexJY2YLiY2ulPlRyzc+3Qp+8CM38xX58P/Pvh7po+zyLSnghF
	LHXA==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706749583;
	bh=5YtK4a4nifkYy7D9GImx5YWZNY7r7bQKqO6G1y6uwu4=; l=2271;
	h=From:To:Date;
	b=V9n3kxsbJbVA2nqHpwcOsdkmRaoBWe18noGWcY36Li4sjYA1hWj2vt4imy7oy2Z3m
	 Zxbufu3tJC5nFbhRtCyVJEkuOb+lFQf1cDY/R1iQXD8PLfcF2FivwJMdtWx5Sx+Snm
	 7MNLDGhImuhCH24fXpyyFeyBoXtKXG9toTDQgiiMTzQGOxxskgyt2p/j+pZY1t9YHA
	 l/xFvynl8ylj2XIMWMp1SZGlP/Gf64IHJVnOi9x4XL2LT3pgKJ1t+YzmeSqjWEPJJ9
	 CHAUuY+zv6PpgDpTPC1lTg8LobLpXanwxYC0ADwVTWgU7RT2U1KX70R161d2qiRMTV
	 GRaMfusW7cvcg==

Add a clocksource ID for the x86 kvmclock.

Also, for ptp_kvm, set the recently added struct system_counterval_t member
cs_id to the clocksource ID (x86 kvmclock or Arm Generic Timer). In the
future, get_device_system_crosststamp() will compare the clocksource ID in
struct system_counterval_t, rather than the clocksource.

For now, to avoid touching too many subsystems at once, extract the
clocksource ID from the clocksource. The clocksource dereference will be
removed in the following.

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v3:
    
    - Omit redundant clocksource_ids.h include (Andy Shevchenko).
    
    v2:
    
    - Name clock id according to Thomas Gleixner's mockup.

 arch/x86/kernel/kvmclock.c      | 1 +
 drivers/ptp/ptp_kvm_common.c    | 2 ++
 include/linux/clocksource_ids.h | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5bb395551c44..2f1bbf730f45 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -160,6 +160,7 @@ struct clocksource kvm_clock = {
 	.rating	= 400,
 	.mask	= CLOCKSOURCE_MASK(64),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+	.id     = CSID_X86_KVM_CLK,
 	.enable	= kvm_cs_enable,
 };
 EXPORT_SYMBOL_GPL(kvm_clock);
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index 2418977989be..b0b36f135347 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2017 Red Hat Inc.
  */
+#include <linux/clocksource.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -47,6 +48,7 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 
 	system_counter->cycles = cycle;
 	system_counter->cs = cs;
+	system_counter->cs_id = cs->id;
 
 	*device_time = timespec64_to_ktime(tspec);
 
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
index f8467946e9ee..a4fa3436940c 100644
--- a/include/linux/clocksource_ids.h
+++ b/include/linux/clocksource_ids.h
@@ -8,6 +8,7 @@ enum clocksource_ids {
 	CSID_ARM_ARCH_COUNTER,
 	CSID_X86_TSC_EARLY,
 	CSID_X86_TSC,
+	CSID_X86_KVM_CLK,
 	CSID_MAX,
 };
 
-- 
2.40.1


