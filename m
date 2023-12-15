Return-Path: <kvm+bounces-4595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE06815341
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2824FB25AB2
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605D26A01E;
	Fri, 15 Dec 2023 22:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="csE/8rhP"
X-Original-To: kvm@vger.kernel.org
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7796979D;
	Fri, 15 Dec 2023 22:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.199.136])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id BEAB210000081;
	Fri, 15 Dec 2023 22:06:35 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1702677995.018000
X-TM-MAIL-UUID: e195d0a4-074e-42bc-8b38-5418a9ed923e
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 048BC100012B2;
	Fri, 15 Dec 2023 22:06:35 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsAIxYSW4RuBGDTyAvojo97WrVQNAdh8eReV1VjCgS3+/JmkK7mYBMCXxjuAocVdnKf56lLuImQgsnsmvY5U43qZs4Y3IbqhPE+HvdFyv9fv0vJXSNN7OP872EkSSKtxdDGaMA/7SWOdxge5+vrUSD0wElM4ZpySK4w+j7tQTmCCtZzXL3iakwDnTyTNwS42/FI92QaYlzv4I0bLw945ilEuRDfAbOXYyT0GTZ09WwnAtCHP5y/3MBOFquYPwq8U7EVAUMlG9RIRxZatz4MhCsYPhlBPeDQRlyH+Ru6VzXFOlTYKwbMaJKC/KK/vjbTl1VLXAxE6UPEoWj8hTw4IxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Sd5IEkoUPoeW7OZTn5GtmVq/OgfU7MvXexTI6z7ujI=;
 b=I1lY1+OVaSD9h9t188HZpYu8nvgNo1WzOaG/jOLrXv+rQ0iIb5Q+fFhP0XvzR1BSfmVwwSopBGHxXRI7TFeOBitY1skhLUwPBlBXqCAo/XMlAq5aQWpiTDkv9NvPviMreiJGZBkcSQZcRa2JGJbailKuzyP0pK+iNXjm/7o1b0b0ZPDt10bKv2s5HcujNOYut5sftbqO5DUFakzHyoZcG+Mkwtv+vVOX7YjZMmYSY4MMbj8tO64mGXGflg17n1/vSwfDfsMMBBgmqO1S+7EroQZm5c3SEaHKi1uazp4hbEdERpMoOcZgEwt9amsqxPTPwf3KldK+WYiRday5Bzn6vA==
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
Subject: [RFC PATCH v2 3/7] x86/kvm, ptp/kvm: Add clocksource ID, set system_counterval_t.cs_id
Date: Fri, 15 Dec 2023 23:06:08 +0100
Message-Id: <20231215220612.173603-4-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: AM6EUR05FT045:EE_|FR3P281MB3357:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 1be1649b-47ca-46d6-5f1e-08dbfdba1963
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dxBJ1YWW7MJZ+OYqQD1XhEXh22Ax1ZjwGMdmFpjYolHusm9t+mgKs2Kvf5mcvofB2PaC2KB97Jl84ylnJKv/K8Gd5y7tFP0ugKFlRID9FTe5AUdQzPebFJ3ki8Dz04xxZlRvpddolQLxGHJpRscSiFVFfewVv6B0mZt6iykh2Tn3PlnubtAHDYi1j3wsD7Rjmdit6Z0asmoLrdDCiqvHoYlMdx67nFBayamMfE0mlVX9RGfvFIqRXFohra+NojTMltICxGCrt2xgwHvVO+aYod5ACHdgaJSgkAxX02yIq0+dinP0pAQaiMxvl0xnIWiCf+dfk5X1hGImpNbt5lFxvqZ6EO1kubdMuHnRQHijbgvW9+Mm2tPWHuqxnaV02WGuBZ8LTa3hpvqEiZLunZXG9bpQuJ//adBb+4zblMAPI2CGM3+MSn9oElk8Dwm4zlQTR8NpzDkDsigSQaOviShJ0wzhxxt5kZ8hBfFtR6l/JSYgD4AnLYDXrE5De67T3Ga3ivyW04azx8C+HKt+xO5CD2GsgInuA63wTOjZzX68QekCO7GqcEE+2MgYJQiyXn/lMjvax2L1d6tgXWZlqFRpJDaWDu4hcNt5mt2pOH//ot73FB1qKeDO6a1vSwTBgxjex07Aktp2ELSFGXHxijhGZvKSapv18ZINwbERPxxq0q2Ha5yamc7zdo2bzgA0hBhrH3NOGumvL2n0RNa7Ptay39NbU91gTdZojKg1utdd1lPGAbfjUr/T4HoHKO3hpepKiPWsszoK6lftuLQBR1upFSHi5ecCjqRowGPexvfJFOA=
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(136003)(39840400004)(230922051799003)(64100799003)(82310400011)(451199024)(1800799012)(186009)(36840700001)(46966006)(26005)(336012)(2616005)(1076003)(83380400001)(478600001)(44832011)(40480700001)(5660300002)(41300700001)(8936002)(8676002)(4326008)(86362001)(47076005)(36860700001)(36756003)(2906002)(7416002)(81166007)(6916009)(70586007)(70206006)(54906003)(316002)(42186006)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 22:06:33.3963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be1649b-47ca-46d6-5f1e-08dbfdba1963
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM6EUR05FT045.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB3357
X-TM-AS-ERS: 104.47.7.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28060.002
X-TMASE-Result: 10--1.344000-4.000000
X-TMASE-MatchedRID: a3KJLn6RIiLJ+P2VFrJmrN/Z7q+hZQVeET56SaIP1M8cZzGOQm4bA4m5
	ne5dZEv4w9jS+jgSrFWUIXVq5Qbu8VVPepzs4BLj+wgn0U2OrUhelLFkoMPMWMhGESF2QtYSi8+
	IGr+Jb3Uyk/Hw4XN9jV1yiVrPdbQVm3S8hE6lHm2TlNTCzR+UCIUS0zu7U8m3qa5aeVMSQixPQF
	Fk0j5jBsA2iDfbpfy+AVpeDm8nJoLwnQHFZbUP3moEkqixPwVYOfEmq6feyfNuRXh7bFKB7pL2m
	I2fvuQKGSRm1o84EoGgf2pYMhSRCAw9lCLgQXXbvuvB6gAgryg=
X-TMASE-XGENCLOUD: 39f7415f-b65b-4af8-98a4-8e0e810d2320-0-0-200-0
X-TM-Deliver-Signature: 9981ACC6710F36E7AE444A7FBB5B2F75
X-TM-Addin-Auth: e5O++ZGxWzX11OOFF/fMTxIjpFbFRb6LU0G74PTperWeB71cyvJjw1LumU3
	vEFisFzhe7t8iSg1fIWdG0yJrgpj2AzNzKRPDnXBxYb7PXETFqS2+0DOtPXadwQ7fZHePPFREC5
	L1w4HyXEcJaPmk51IjR/cSEWkjvOkHkRGb897sXQVwu5bwYQvE0gtgM0dZg1G26d7HqqS1OfJX0
	bLekgQzekcl54v0CwdJhfbroUCVVWQ63+sPOhW87FRPOOBvKA6VpJBDPtoN43zGCS3CtuPiaNBV
	+ADe1XZP8k0UV6Q=.Zd/Vxvy+bWecvQV6pAZDouJtopdxZcPhom+RHNpRQGV7YAjHFTj8hKJj+p
	TonVdPm3dtaSfgmWxtiuPl2HP28taMN1VDhuGlnm0JbSVW9js+fv/ZZJgqTOUaBYSoR7qyXrs2I
	zbxLxBEODMqv1Nj2n5eMPExFb08MML9BKmqxUO9MCA+t/vYUIlIB42ioUwR+2djK9C5Bhk95OOW
	xER25/p90K2gPuWmcqOrcZAHMWfqt5YA67i2sEaleXoMHqLJvnZ7nZNU/URUPx3BqcNJEk1mxwq
	5MCrzRXDrDcYsBYFdWZ3QT4Tsuu4f7fNMKsdBgkvRQzZSPB65KwVyrOZCQA==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1702677995;
	bh=gkS2CFdT/6ybIKM4BHtmApR0TjJcIGt+eMfoV/Wrp7s=; l=2392;
	h=From:To:Date;
	b=csE/8rhPF/WBV6ofOsmdvZzR8aDbAAgYUoar3EGxQM8oeGi4rQsZ/VqufiuXZswAi
	 VrquGJR/ZFZEcaaSdWVIJ6KPiqlNDXd0lquvBXNlzIstNRMLCVd3njIeT9Wc5mCMEi
	 FczcCIpAt5ByCGGYZa6iwfh1lFQ+0ij0jdKXTC5QaJlvZC9gmNIvzAkfUB64gAjudi
	 ixuB0cieQkG8bPmvPcWqEqLt8zbATHMyOGOlQEv3IGzPAGKR7WCU0n81MQXeOtUefF
	 OEffS557QTgtQJU8Rz67/iG64+PhsS8zB+YDL82I6ZLN5OCxOBfJ94GYiIQOdbnYJ2
	 4h5j+K51VDj6A==

Add a clocksource ID for the x86 kvmclock.

Also, for ptp_kvm, set the recently added struct system_counterval_t member
cs_id to the clocksource ID (x86 kvmclock or Arm Generic Timer). In the
future, this will keep get_device_system_crosststamp() working, when it
will compare the clocksource id in struct system_counterval_t, rather than
the clocksource.

For now, to avoid touching too many subsystems at once, extract the
clocksource ID from the clocksource. The clocksource dereference will be
removed in the following.

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v2:
    
    - Name clock id according to Thomas Gleixner's mockup.

 arch/x86/kernel/kvmclock.c      | 2 ++
 drivers/ptp/ptp_kvm_common.c    | 2 ++
 include/linux/clocksource_ids.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fb8f52149be9..25d6bf743b03 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -4,6 +4,7 @@
 */
 
 #include <linux/clocksource.h>
+#include <linux/clocksource_ids.h>
 #include <linux/kvm_para.h>
 #include <asm/pvclock.h>
 #include <asm/msr.h>
@@ -160,6 +161,7 @@ struct clocksource kvm_clock = {
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


