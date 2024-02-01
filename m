Return-Path: <kvm+bounces-7643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B08844EAB
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D8AB1F2CC17
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2AB45228;
	Thu,  1 Feb 2024 01:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="AkFHexsJ"
X-Original-To: kvm@vger.kernel.org
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9034F4403
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706750970; cv=fail; b=HDHrgvdVQqJ+qfSdCwW74yaGOlGMusgtb5kMENDHxdf1P+XCKJ2xYffV3vDwhwGc/tzWZLo0XeyrT4oXKxZH611kERpyQutuvsTOhuNSX7h5lT4v6toSSZBpPveRK8Pvks7M+CCgWgyI+Gp/u/axdPP9WFUAo54iLJl4COv4i64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706750970; c=relaxed/simple;
	bh=D57pOeABfamN98NGLpRroVr6iGToMt3H85oc0X/wUSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TNXP4c+AMwk74hhWrDEAC5TB/9Mm9WBrFDxG/807ZqMIB+RSvUCR2MbjAuKBSUyCqhE1pq5dnBfYaMR42pUeNfD2fP8Xr2hm/NBypjsGgHyRyOHAAfUZCTaADJLIoVNxDxRjKhGPrHrODrHIpw85mrTfb+TrLZoPgpdsMSAP65A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=AkFHexsJ; arc=fail smtp.client-ip=18.185.115.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.19.81])
	by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 4331210A7E627
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:06:37 +0000 (UTC)
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.176.220])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id AE869100004D3;
	Thu,  1 Feb 2024 01:06:29 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706749547.736000
X-TM-MAIL-UUID: 5c9397da-eb9e-42f7-9e74-f7ce1151010d
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id B3E8F10006A5E;
	Thu,  1 Feb 2024 01:05:47 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBQb9aXSmWIXZ5e3sAVvBwCaEuWpTiBSxy5zKGOn/TXCGahXbUijIOvoJ6FLkApl4W6WxN4PglFmo5hpdG6cKbAPa1Bs+NgDnP6Gg07GJ3t7o6PMEhLlwYMGVb3FMBQpZqE9zvnOqC1BDPB3F/kNGXCcyhEs4Uy/krRqZbtvMaQDuBiLEXYhL6ZlRk8RYXA3m+a/PSfxt9d2l1jEEhngf7nQc3DSF3hOF1O0ILvfP/lIGo8IOj8EX73a+WqFc8E9TiqclCt1e/9ZNejAaVULIQvme+upk7VxSu5csHljZaklgfpQj48rEX34b2ky6hEQNqt7U+zT35uHF0XVEok34w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhgN1hN5nDXN/Fou+ALZ0OcVA9vQ13ILRQYwQOvZUNw=;
 b=HB7O83FYqcEKRkcKv520CrrzYKjD5vPAZx4SyZe+RlWTafIhsfjhSkqidNHzfU6kd0bCYV5e3NigoNzfiQDXTMBglrJe9DaR5F1NKB1j0hQ7OH8yNK73hGxmYSBMMxy1W0fTLNEmM+uwW8O1m2Kq73QttWm5DzugYqdv4v82SfaiiW2sOgB09LAZRRpaXLm9p4BUrbzosZe4yfWT+7f2DFF5zIVV/eeBtc+rhdcctEaekJKzXjsUNA3oYTDomQqg0E4An3h/zXCvM6+6lXDun1vmj3V7W8cthW293jkO8h7NJg/WiNTsrzpBQch4XKJnh2CLQem2JTLIlU5ZMkVMZA==
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
Subject: [PATCH v3 5/8] ptp/kvm, arm_arch_timer: Set system_counterval_t.cs_id to constant
Date: Thu,  1 Feb 2024 02:04:50 +0100
Message-Id: <20240201010453.2212371-6-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: DB8EUR05FT029:EE_|FR2P281MB0107:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: dd7e9af6-3249-4a0e-c64b-08dc22c1ebd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	j//xz2/FI7LgQ7uhT1Y84nILqDRR6bYPSjAlv+0eWOzFVSi8tDilxUVImkG4ngHcgS/s+DJ7TJzTy8506LUOJWM1btQVxp6UTzSPEUL4U0UUVKiA8jhCBzNwlwqLa0cCJ+3S+yCwdKIRJ3NdOeI2A+Nd+K+loO0tup5dm5NpzRzEtXgf98N3hVPmDDvIZEJkyb4H6qwsdMWb/d5fcVtiBjK4RhIOjV2OW5XkDHZ5+GgdgrBP+lGxu+BQp0klpIDJV+T4xQJwyvwvA5M7bJ20omQY9zKZM7kwIuljfuKhcJOr/HjNjlEcbnV2Yq+kEQGUTrrT68dZexreikRhM7bc9dDl5sLphWvxGcmSRfKEdL7NodVOkzAscDmx53Glje0S4zCnwKnpaDZJTJIErsyj9cxiRSXsPXK08AhvpOvNf054HUQdNxM2ENKvOQqO+fL195s0noEexBmqA3GrLCDbCFX1mUti2RaxXvHA38h5edCDIex7VBbdLWubTNArj3BdTLSq9ODOm+0dAISChUxjmjeWZ30gBu2v/TngOH0LwWKKP1ZDKMSK3wqWWnVCCX8YJRMAaIHQoIu616GP1b48Zt/bgigVqKoHXvUY00WOMBWdbXjnx7p9RFQMIYcX13RJDE94eUJGHdfaKfZhXk7sWi+yy4w4sfhsipXNrOuneVhUOqUClyyyHZk1AreNIP+TptFlfMRWxKfXN9wRkk20M0+HJwyHliRs6mFdTUHPDBC5xd502r1Cg1/LHvRwL+0F
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(39840400004)(346002)(230922051799003)(1800799012)(64100799003)(82310400011)(186009)(451199024)(46966006)(36840700001)(40480700001)(83380400001)(41300700001)(86362001)(36756003)(81166007)(36860700001)(47076005)(336012)(2616005)(26005)(1076003)(2906002)(478600001)(6916009)(70586007)(70206006)(316002)(54906003)(42186006)(44832011)(5660300002)(7416002)(8676002)(8936002)(4326008)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 01:05:45.9427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7e9af6-3249-4a0e-c64b-08dc22c1ebd6
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT029.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB0107
X-TM-AS-ERS: 104.47.11.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28152.007
X-TMASE-Result: 10-1.458100-4.000000
X-TMASE-MatchedRID: bjwz5Y9VyUDCCiFlDvprp7r2u0KWqQKNSDS3MUO7D/TIRhEhdkLWEovP
	iBq/iW91MpPx8OFzfY0wNyuTxfRm8ShARHtTtMpxhi2C7dlNKWrn0oaU6WM++5zYnFsPfA8XUMf
	79vayL5ANuimYslhyE2tNUNGl1uzREfinJ3N6jMzFTQGAKRxj5No+48giqZwnEgg3cwDHl/0S3W
	M79W3o4ma3xca03R6M/utaD2GffWo0zI7+eiZZ8F5CD/hq6siqFEqAM28vQO1Q6z0JFJrmFnhEE
	wH9X4REQE1Xqh2tz4E=
X-TMASE-XGENCLOUD: 94638120-ac67-4978-93c3-0cd2902ecd73-0-0-200-0
X-TM-Deliver-Signature: B373ADE2DED4ADB7679BF271BCAA9316
X-TM-Addin-Auth: 8XTTJSTfCuDKwe9AtHmgxezWSnJkKdKsUymwIVnx6WSdfhq4RiAhPIVgF7B
	HjuXLGJUfaidfVcwF0dz9meo/dg7OzUGLqfndiWAP6lunKNHVjmPkSVhkyvj8iE44qJOVGHMuZG
	ruTUQm5PM/dJLRv06dV3tnoEODN+V98FUDIC447mOOkIL3ofFGuh9qCO2i6BYK7Yhfu6oBRRVIM
	Sm2f3jt5i+nZQnH8OrQZiaj+sv5h8WaiLuV1iWvsNZ1yQBuD0sq/dASCpdLZ96dJoHUbovZjGOY
	DDHzqHVo+/pemfGlvsM46A5Id6L4t/WIozEu.pxOrUYIredW6WK5u3i8RWDdo9ZxGzitekXngfs
	5S4rjzOn6m5a/K3VJXYh/5f7gK8kD6Aq5WBbexVChp6M4SjVKyXdH/WpB7upkSSFgY1MydhpzZf
	GhNqrptC1Z6/5FarD4U1AP6QqP0Ou0vg1loJPZihrFsJYgd5XfkE8rv4bc0ayXWly5vix5c/83h
	t4spgTpvm8QC/g8jWpS1g51T7x70ROQOLg9qXyG/tWcaInkZb0z8+j+ABbAdbui0lh/QT2h3DFr
	0Bk9NplUry5QbI3/nunLmy0R+knYJwwh3s4/l1RPe0uFX04zaubvyfWmKX/b3w1fhYPD6QcHMyP
	xQ6w==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706749589;
	bh=D57pOeABfamN98NGLpRroVr6iGToMt3H85oc0X/wUSE=; l=4724;
	h=From:To:Date;
	b=AkFHexsJyiiioD/6hJQl8fT+d4yVX/CIpU2UIXVNhWItDjjxfsIG/HITheyeh8U+8
	 psOofcEjsvIC9UnnhLYWuY1ARPzvlhT3wShy3GWUYLbTTUjWaBUOiZtObIPosDv1Xc
	 EJda/tp4lkxTTLdjSD1OEF353i9ZQ71V+RjnIKiqtiz4logvUH1p5WbFBINeTRXl/h
	 ucoFLm6nYrDgQbOcZX9KY/TnW3BOPTepIIFhEmMhfeVPTKVK680zBnVvlwc8cGqZZN
	 Fgjral0NWJHmp29GjNconaUokkSB5f9m38sheEpzvB6mWhKm8B6k4wtC+xazH/yKrL
	 Rxf+80P5uBEpw==

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


