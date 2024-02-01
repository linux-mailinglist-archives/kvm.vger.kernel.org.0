Return-Path: <kvm+bounces-7633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A152B844E47
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF2151C222BF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72275238;
	Thu,  1 Feb 2024 01:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="XWj5mJP3"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC14400
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706749596; cv=fail; b=njd+pqBhTA6r3rpLoigDl7FtfSVRqtqMuIo5t9ZI/MVHi6JNkaG5Ds3zWYPEDr7ZAtMoiu6jzK8jwIooSRuRBIxG5dEqfyEX8QH6F9s7Bl+w3AszB/dnAUD75H3NEgq59OSZHSYMPhFIC9mOv2FOWpbPUFq6KQra2EDm9RMTmFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706749596; c=relaxed/simple;
	bh=j3ZK0LDs+hrr9tdazQ5dmRy2Y1/jm40trOZjBU8ltrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GfGWyf7vqzPdc8DZKtNCp8tJ6s8z/eYdJnOhgAlrfDj7GDG1QSPeYIa4RIo7vgLN8qN7YJCfXjhf7eB5T2bd+JlR5xF8vpxVnGbO+i2tOn0r8zz3y/zzh/dhd15ZWoSwE1mrEMmus+a5ja50b1QDsu17WTuGbf4KatJxPVuEc9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=XWj5mJP3; arc=fail smtp.client-ip=18.185.115.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.19.202])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id A572710D3A205;
	Thu,  1 Feb 2024 01:06:32 +0000 (UTC)
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.176.220])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 8AFDB100004D0;
	Thu,  1 Feb 2024 01:06:25 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706749549.349000
X-TM-MAIL-UUID: 57a7349a-401c-46dd-a091-502461c475aa
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 5580710006A5E;
	Thu,  1 Feb 2024 01:05:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKhyu1JIeZwB9nOdO9yB4NN5zgsl1eKp2kxic9vkp1DOl3zR2PLwPFLOeLTDfdN24qjaorlw0uvUj+lJhmGrm8C9Wpj1jp9qgOIBH0X+QiOIvImLOgvZgry00ly7RS389iUSXp4o5//uY1LW8xRogIyUgQCGR5vaXsS6q6lBz3SPgQhjfwf/ojUa+VWVGK7VS/i0OrcJ4sFFh2qd90DN7K5gl/77hRVkmv4BA/CEVAIAQng2r+2WAqPFj3VJIn8ak7MxLb1ASixnIeA4aNY9zJCcctZ8BvOCsMR6lt+/VdyuBoR6YzWQTWKfNn36PQfFGGECY6qtZLVO3n1SXIZPfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsyIsJZULVmOyBWJOur/9/jVP+yb1X6rnbgwdmk3TFE=;
 b=KRGUgomn33oerqrVwRfUHTGUzle56lVaaDZfDYUTwY2sgPMzqXO6/KA/Njz7GFyrgOSA1yvC5B/rGA2Fhaa6n7kxpvZCC0FFVqvvotQFE0rLLmAYIw7Uo9ZtTSSLM6G8gLR+l3NcXcRWfXVircIF/tERHyjdzAjqPTh51nnqxmZnEqqCycGEqK66+iiXRRVOQ7Hxr5/wBRny8glvjlyZUE/sOateCWr5HsTBXn2xkucUom7Wi4iqTu+NaygyGz2+4MdvZxJOHYZQdgoPv3SCrgqEw3XZFxb5pT5WK8VWwWxcJQvOphJEXe8nLDqqBCl8NuNxCKVcH6I+/4L/MmCZzw==
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
	netdev@vger.kernel.org,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH v3 7/8] treewide: Remove system_counterval_t.cs, which is never read
Date: Thu,  1 Feb 2024 02:04:52 +0100
Message-Id: <20240201010453.2212371-8-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: VI1EUR05FT008:EE_|FRYP281MB0272:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 81d7bb6c-a1ec-4d74-9208-08dc22c1ecfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	s5p/bEfW1RcHnaUVG/vPSD45EAcSRtlIOej782H1Qr4bexPXN78iDHu2/3sLAOKBHi119bqIVep+/rMO5VyE8j2xgSiuVZBPhiHrLO+ahZ6FV47rCbjbi0hMdnXX4e80HKVeeMspKZ5zgByY9ll03N2BshqGdXtoDXfc7N/hAprTJAMacD3NluZJfLFl/FuujB6B/HXNcpsWMSajjDsQ1+tcC4V2yFTqandyCqeVJ2cyKlUvmRSPKdk9EhUswVRVtpJR+stEiAaRbrFnjrf2mVT5tFIEk+hH4Az6zG1T7SNK/2zBIldYuZTvfqoniTt4uKmhS+1Xi7f0uLgzKK2znsUgbpgE+wZ+yMFhjuvnXUPwucyF8L1UInGpTYeAyeBYlUD6fMD2z+wJd23N6auQyJ2zyjM44R9VJVa0Bt6n8mEpjEztB545+vZVqJ+Y2iLJr5a85PGyxmWmOd5InNlMJ/h/Ayfp6dPHaLwb5ICeWepqgo3kAESx08OQKPB5CeUlSvGpNCK1YeAWgNOLbVn9Fp111sFCrR4UpwuYTfWvcU36exn9QG2j96UhZjP9w8UV3VLb+dalqliYE0dif9uv/RZ0MA2XX20IyhqTfs0FieJUuUc0RnnwKqJ7+8Oq2pEMZKxkYybBxTrL1los1W/z3MoWLeTyeXlR9D/a9hccfZvsP/lJYYhwPwdJeCwW6xV97upuTGDxwYxyNKWRP7c7KVyUYrnxXQ+WbmhXX8CE7jhTLzYLIqzZTsJyALjjUtr2
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(39840400004)(346002)(376002)(136003)(396003)(230922051799003)(1800799012)(82310400011)(186009)(451199024)(64100799003)(36840700001)(46966006)(316002)(47076005)(70206006)(70586007)(42186006)(6916009)(54906003)(36756003)(7416002)(36860700001)(8936002)(4326008)(44832011)(8676002)(86362001)(5660300002)(41300700001)(81166007)(2616005)(40480700001)(336012)(1076003)(478600001)(26005)(2906002)(83380400001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 01:05:47.8969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d7bb6c-a1ec-4d74-9208-08dc22c1ecfe
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR05FT008.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRYP281MB0272
X-TM-AS-ERS: 104.47.7.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28152.007
X-TMASE-Result: 10-0.836900-4.000000
X-TMASE-MatchedRID: 2GwetqJOyZxrxBLbo6y0d4ruruLIWfnxgz5VmKZ8x85rIVA3IGfCC6DE
	DQa+uiKUfxo+wwDBGZpKfWS2EzGP5o/GIRjw2D78dArStA4IAF4SRRLwSueD2tEOKD7Vsunkj6Q
	WX061FFJ3hNro2zkthd9gyvNyzxXy0bKbAkjZTQt4lyF1lyvUrTUfXwpl5znYB/H9q/pEjfECt0
	I5Tjuo2dlhzrOwI51bKRbMLPl3awjb3dppi+rLrXzV+KRRiDItcnxszfxH2Ckmx8kl1Wnd+q+eC
	SMeOiOkfZ9uentPYeaJcb4M4L3rfi1QF7giu85XOwBXM346/+wUiV4IE4MuxRTbXVdulhu/g7hE
	xeK2mZMPR11w2j/xz8m6mrJkmFv1
X-TMASE-XGENCLOUD: 5c2e2e76-2709-4d52-874d-66c1ac854c9f-0-0-200-0
X-TM-Deliver-Signature: AA2270AE4D693477B76D0B655674B1B2
X-TM-Addin-Auth: 0Q/emdNT/sNhsg4VmkEqA2bu2nwRc6yHrwfyDG7IMJ+dbBHMyMPaixZ8R0s
	1wC8mhCCB/0wymKGMmNx4IT3OCTtdT7hnm6lTJv7lcK9G9hJ5spUPD3r10QrlYYdgFEYN6EvIjx
	Lr+Tsxz4GRDIGFCvs9woZNEVmzBWfZc5RBSd8ThjUYM/W8iFS6enWL0K62k+3l5GYHkccduG6/d
	//yHM5obD7hm34tudjbXV8RTxcodJRXRE2Bb13sHMl4Z7nWvgH01QT3Kt9/IOGJQyB8pxeCgepL
	ljKkzZfq83uwBuCFyA5Imyvj1VmqfVYh3n02.JPyoV/T2r1tAEv1U2pH2m/h5Kz2zbcSCHDbYHT
	XxvHJK7bu8RSaskkqGRoRWblNYdOGwapk478mbCBWwHFs+qRIkG9JO5xEPCTG+lqkIlB9BuOMd9
	X1mVvf/iDTJASysGBQbHn9jd+SwCdNSgg+nuGvDBrTAlH9n7vrpbDalc/HMxm3sJUcfFVXnCShI
	0MITdgDSFqtUdrGpefVMRv+b97DTpRxpITAw6fFbR+knLuvFp1s12x5aSjlhs9ORt80AyrJck+b
	G4gs2L4Yt7Tqc3szU3dC4/sLGqJCZvwJGLvihk52vxB2MnyhBxZ109ISF5BLO4N0UyQOzHa6Ln8
	BS6w==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706749585;
	bh=j3ZK0LDs+hrr9tdazQ5dmRy2Y1/jm40trOZjBU8ltrU=; l=6724;
	h=From:To:Date;
	b=XWj5mJP31O4E221jcObYKFA0r/yq0fZlOLcoTqw2C0JCSLwZJy7RN+GMHteSyjY86
	 skqvyIe0/+D1muE+/Z0lOqRrxzWOM3xPs2/PZEmLoYqE06uO+lyP0VIayPFJq28/2M
	 zxpXlUOjkjJYCa0V/d3NBBfgTIOGbdURsQTaBMCfRlX2bx9J/7FNrsQOTM2TD4TvLM
	 OOKPZk6Ofi5cm6Ny3tTVofh3bB//FGmLuYKQ+ZRFL8Qafbw1xEBh2L9MvCjpfabOuo
	 EBrovfjDD9vNPsg3xG8/VCGGji6LIuM0JnuzE99bRNJHfUfbfTdG0WJRBhahR8ADxp
	 CHnoSMuKwURTw==

The clocksource pointer in struct system_counterval_t is not evaluated any
more. Remove the code setting the member, and the member itself.

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---
 arch/x86/kernel/tsc.c                | 11 ++---------
 drivers/clocksource/arm_arch_timer.c |  3 ---
 drivers/ptp/ptp_kvm_arm.c            |  2 +-
 drivers/ptp/ptp_kvm_common.c         |  4 +---
 drivers/ptp/ptp_kvm_x86.c            |  2 --
 include/linux/ptp_kvm.h              |  4 +---
 include/linux/timekeeping.h          |  3 ---
 7 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9f164aad5e94..693148adca22 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -53,7 +53,6 @@ static int __read_mostly tsc_force_recalibrate;
 static u32 art_to_tsc_numerator;
 static u32 art_to_tsc_denominator;
 static u64 art_to_tsc_offset;
-static struct clocksource *art_related_clocksource;
 static bool have_art;
 
 struct cyc2ns {
@@ -1313,7 +1312,6 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
 	res += tmp + art_to_tsc_offset;
 
 	return (struct system_counterval_t) {
-		.cs = art_related_clocksource,
 		.cs_id = have_art ? CSID_X86_TSC : CSID_GENERIC,
 		.cycles = res
 	};
@@ -1350,7 +1348,6 @@ struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns)
 	res += tmp;
 
 	return (struct system_counterval_t) {
-		.cs = art_related_clocksource,
 		.cs_id = have_art ? CSID_X86_TSC : CSID_GENERIC,
 		.cycles = res
 	};
@@ -1459,10 +1456,8 @@ static void tsc_refine_calibration_work(struct work_struct *work)
 	if (tsc_unstable)
 		goto unreg;
 
-	if (boot_cpu_has(X86_FEATURE_ART)) {
-		art_related_clocksource = &clocksource_tsc;
+	if (boot_cpu_has(X86_FEATURE_ART))
 		have_art = true;
-	}
 	clocksource_register_khz(&clocksource_tsc, tsc_khz);
 unreg:
 	clocksource_unregister(&clocksource_tsc_early);
@@ -1487,10 +1482,8 @@ static int __init init_tsc_clocksource(void)
 	 * the refined calibration and directly register it as a clocksource.
 	 */
 	if (boot_cpu_has(X86_FEATURE_TSC_KNOWN_FREQ)) {
-		if (boot_cpu_has(X86_FEATURE_ART)) {
-			art_related_clocksource = &clocksource_tsc;
+		if (boot_cpu_has(X86_FEATURE_ART))
 			have_art = true;
-		}
 		clocksource_register_khz(&clocksource_tsc, tsc_khz);
 		clocksource_unregister(&clocksource_tsc_early);
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 45a02872669e..8d4a52056684 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1807,7 +1807,6 @@ TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
 #endif
 
 int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
-				 struct clocksource **cs,
 				 enum clocksource_ids *cs_id)
 {
 	struct arm_smccc_res hvc_res;
@@ -1832,8 +1831,6 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
 	*ts = ktime_to_timespec64(ktime);
 	if (cycle)
 		*cycle = (u64)hvc_res.a2 << 32 | hvc_res.a3;
-	if (cs)
-		*cs = &clocksource_counter;
 	if (cs_id)
 		*cs_id = CSID_ARM_ARCH_COUNTER;
 
diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
index 017bb5f03b14..e68e6943167b 100644
--- a/drivers/ptp/ptp_kvm_arm.c
+++ b/drivers/ptp/ptp_kvm_arm.c
@@ -28,5 +28,5 @@ void kvm_arch_ptp_exit(void)
 
 int kvm_arch_ptp_get_clock(struct timespec64 *ts)
 {
-	return kvm_arch_ptp_get_crosststamp(NULL, ts, NULL, NULL);
+	return kvm_arch_ptp_get_crosststamp(NULL, ts, NULL);
 }
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index f6683ba0ab3c..15ccb7dd2ed0 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -30,14 +30,13 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 {
 	enum clocksource_ids cs_id;
 	struct timespec64 tspec;
-	struct clocksource *cs;
 	u64 cycle;
 	int ret;
 
 	spin_lock(&kvm_ptp_lock);
 
 	preempt_disable_notrace();
-	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs, &cs_id);
+	ret = kvm_arch_ptp_get_crosststamp(&cycle, &tspec, &cs_id);
 	if (ret) {
 		spin_unlock(&kvm_ptp_lock);
 		preempt_enable_notrace();
@@ -47,7 +46,6 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 	preempt_enable_notrace();
 
 	system_counter->cycles = cycle;
-	system_counter->cs = cs;
 	system_counter->cs_id = cs_id;
 
 	*device_time = timespec64_to_ktime(tspec);
diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 2782442922cb..617c8d6706d3 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -93,7 +93,6 @@ int kvm_arch_ptp_get_clock(struct timespec64 *ts)
 }
 
 int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
-			      struct clocksource **cs,
 			      enum clocksource_ids *cs_id)
 {
 	struct pvclock_vcpu_time_info *src;
@@ -124,7 +123,6 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
 		*cycle = __pvclock_read_cycles(src, clock_pair->tsc);
 	} while (pvclock_read_retry(src, version));
 
-	*cs = &kvm_clock;
 	*cs_id = CSID_X86_KVM_CLK;
 
 	return 0;
diff --git a/include/linux/ptp_kvm.h b/include/linux/ptp_kvm.h
index 95b3d4d0d7dd..e8c74fa3f455 100644
--- a/include/linux/ptp_kvm.h
+++ b/include/linux/ptp_kvm.h
@@ -12,13 +12,11 @@
 #include <linux/types.h>
 
 struct timespec64;
-struct clocksource;
 
 int kvm_arch_ptp_init(void);
 void kvm_arch_ptp_exit(void);
 int kvm_arch_ptp_get_clock(struct timespec64 *ts);
 int kvm_arch_ptp_get_crosststamp(u64 *cycle,
-		struct timespec64 *tspec, struct clocksource **cs,
-		enum clocksource_ids *cs_id);
+		struct timespec64 *tspec, enum clocksource_ids *cs_id);
 
 #endif /* _PTP_KVM_H_ */
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 3538c5bdf9ee..7e50cbd97f86 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -271,8 +271,6 @@ struct system_device_crosststamp {
  * struct system_counterval_t - system counter value with the ID of the
  *				corresponding clocksource
  * @cycles:	System counter value
- * @cs:		Clocksource corresponding to system counter value. Timekeeping
- *		code now evaluates cs_id instead.
  * @cs_id:	Clocksource ID corresponding to system counter value. Used by
  *		timekeeping code to verify comparability of two cycle values.
  *		The default ID, CSID_GENERIC, does not identify a specific
@@ -280,7 +278,6 @@ struct system_device_crosststamp {
  */
 struct system_counterval_t {
 	u64			cycles;
-	struct clocksource	*cs;
 	enum clocksource_ids	cs_id;
 };
 
-- 
2.40.1


