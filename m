Return-Path: <kvm+bounces-4602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3B3815351
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6BA31F248CE
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA6765EC8;
	Fri, 15 Dec 2023 22:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="EAEuIw9o"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE2563A3
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.10.213])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 64B3C10874D76;
	Fri, 15 Dec 2023 22:06:46 +0000 (UTC)
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.199.136])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 5AC5510001FCD;
	Fri, 15 Dec 2023 22:06:39 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1702677998.434000
X-TM-MAIL-UUID: 380a2162-0f97-44b7-bd2a-c04e49365528
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 6A2FD1000333E;
	Fri, 15 Dec 2023 22:06:38 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAUNQT1zw7RsVAN+nof2ecsdmsI8RXb2jE1Gx234PtrcSPMr8SIsvG9DFbCdvaqibaVwzO0rMBnTvyWnWdEEIDTcw6pyHEnbJHp/4CGLPuNdX3VoQsd175qS7sQSZpeAoFHKr2PyJEWZfCZcrX6x9v8CltM1I+UJo5KBEEi9/3mstvmdQcitqsDMFx2qPZkiIRAGXxYgoxvdWpNcQEToOGd2fSA2iLKM2gWqmG0OoqixQ3xqnen3eBCaU6XRh5AqVTS5OWmslnIZcRpUYY+Lpl+DqZeBUCGGB2MASzFa6zt+qSHbM3U4J2tFwFn91TQUdGVA8aKduSGw2e5JjN6rOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxIjbTGYUvyiFb0/gfdolPN9p2YMcYlaQ7cCg+6BRCM=;
 b=Vm1/4PrZXlRyj/hL/DUlxW/yYsRCZ8JyRplBzopBZMfYGnkQ6LH3wDQYG73m/knI+ydc8LXcxdpG11nLxPDHQ423NDGeg9mACQdR4LWSRYQ+1nIw/0RIOjOJZCuGzAKtoxTPJtEXVuLsu4QJD7y7YAauX3d7VUYljGz5sp2Jue8WCYVQ17r9hmxcgoyQSmj8jwkK/BCkD8A8aYFGOtT9kZI60qpIPzRFNm5puR1qI6O+b+K82Ui2jDhotLk5IWmn2KQfPP0WNGCjd6cb4u4PD5VJci7RywfguxJDV3u7lDNKAZG8vmwRr8MkmpEpnDMcu9zhpDdEhVkFJBT1gfKSyQ==
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
	netdev@vger.kernel.org,
	Stephen Boyd <sboyd@kernel.org>
Subject: [RFC PATCH v2 6/7] treewide: Remove system_counterval_t.cs, which is never read
Date: Fri, 15 Dec 2023 23:06:11 +0100
Message-Id: <20231215220612.173603-7-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: DB8EUR05FT029:EE_|BEZP281MB2565:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 0f050ba9-8f21-4237-9841-08dbfdba1b07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KZg1rM4Xi3aH+KMY3YAypfhSkB0OqvflvVb+V2gL79jodI2XWMukEK4fipK/Xy9TuFbyp4VDHNP+2TNSTHCax3DS+BOZhsKibFlUuoaflChFWchs44ceTAFVFuqvRQSyLNp0fuldFwQORa6hl1liLH320aI7TwKS+t7uicRx8SBlUbM87gv8fVfTO1k+8z8c4c7/7zIW1UIxKs0DZiLS8hh+PaHzz5qYmcZoJCxxDjuQTGsSg1utsmGtrXNCCFWI1eFUYxfKyRBAQb2H2UE0yMoU4HoePSsBWB38+T2vXkYPdA7cbj+VTfpkegaONQ7BetNTNh/9GkLhyE7OEY41FNiDnjk8l4TaH6tNVbbFoV2pi3XDDA9wwM31F3sb4P9vnGNfhf8bEbUZ+zHt2GxjKi87xmO2EdQkaPaN6NAU5rYSnHNqtiheVfqknOapu0DfBPWR/N985PeCjVsYgvCqdlIRhxBRR/WKn2fuPwCAENZR1RrC/dhe7NkXj6OoOGV/l2dBrxC22biCJ51oVft938mvTjH7ta6IGE8IPG4G6dXfxYJ0Lvq16G+3K0SQmrbb5aG3islSUg/ZS5BqtJSAHZogKXqy3W0SfmxpAWhXDrepn7q8kiOb9+Ypo11MmHqNAPaHJeSO9GBuH5Q9CoOYHy/VR4kb2UoELjIm6DPkbcAYzHklDtPPYOUPE9ptL1A/Ps88Cm9NPLmjQ6wuaVThPKKij8TPIQRClFu/IzTnoRAZafVPlwNTwIsPN864wWk5tkJ8T6uLxA4TIvd/IM4WNS0uNC8RXHG5JRnLSmqP0UY=
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(136003)(39840400004)(230922051799003)(64100799003)(82310400011)(451199024)(1800799012)(186009)(36840700001)(46966006)(26005)(336012)(2616005)(1076003)(83380400001)(478600001)(44832011)(40480700001)(5660300002)(41300700001)(8936002)(8676002)(4326008)(86362001)(47076005)(36860700001)(36756003)(2906002)(7416002)(81166007)(6916009)(70586007)(70206006)(54906003)(316002)(42186006)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 22:06:36.1346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f050ba9-8f21-4237-9841-08dbfdba1b07
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT029.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB2565
X-TM-AS-ERS: 104.47.11.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28060.002
X-TMASE-Result: 10-0.836900-4.000000
X-TMASE-MatchedRID: 2GwetqJOyZxrxBLbo6y0d4ruruLIWfnxgz5VmKZ8x85rIVA3IGfCC6DE
	DQa+uiKUfxo+wwDBGZpKfWS2EzGP5o/GIRjw2D78dArStA4IAF7scFLCzRtoVlQxWbscxchmnR4
	nzBni1yUsCE8eCr9Fv/h6QguGwzP2odZPcBheFfPFPyeOO7dH/hqqRtM3sdE1t1CSfPp/+EVQx/
	v29rIvkA26KZiyWHITa01Q0aXW7NFyiIBweSEVUnzV+KRRiDItcnxszfxH2Ckmx8kl1Wnd+q+eC
	SMeOiOkfZ9uentPYeaJcb4M4L3rfi1QF7giu85XOwBXM346/+yvkC0mxvBJfxrHZI5RLnIFAYOW
	D5xf/BeZ8t8OMKF/JZdgeE57XjFe
X-TMASE-XGENCLOUD: 83b42042-85a5-9e61-a95c-102c20ead691-0-0-200-0
X-TM-Deliver-Signature: C38C6D983C320C4080E8007E1137FCAA
X-TM-Addin-Auth: EEWhv+5llAm4/fbOKmJ61TMy2JOkDZQeoJhddwCqTDcZ0lL/XKMgAWTFJYw
	ieGO2TOmwFDveJjktUd+YFzcexEOysLp6b6uYh3vNXlPQOep4i4D/MIdzgQpu9IwuHynUAyQshq
	5xU2QoxNWwXBBRys0cLiLTOPveC9HBJkL9Bbzl9wRlVqBbahHVtF74WNzwAJzmHpNfriVrPiXeg
	j5Vly4GyRrxw+b7OpyTCi/wdOL+6iTGpAz0bGw7TYeHDuLJG+ZJCygPlzo87OOv5bpWp0t4CptS
	ix9MXewHEtidU0w=.EpTjqq6jbicBovuIo5mU+mx/DOpcnWbkLDKy9lMFvEQ7lGGx0ygISGnBK8
	qTSXgLfTicHPxmu4C17/JugbusZH2aV23OKlc7S8T0Xvn5U6USAP3jXYEo/SaXh8Riw5me7cTNz
	vwM0GtDuY9Z7BmgyXo3O/rbDwR0lCrH34NKFz2Jj6CFxpuDxEDeA22bcrLrRUOtG5Rtx+pc+/IN
	vt2LhvwACYRPPDoVXLf9nJf1RmBrfHcqsihAteH4UihFXIj6uNR4sLvD3350CXslfTPOAo7CLd2
	zsWXZYAj2hDdNrr/v/yFT3g1XHSdq4WvCVvfgvF9yOF40HF6E+CAEsumbQQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1702677999;
	bh=BQ1ird3OIQSstOkL5D7Q4WuNIDqcJanL9DnLpx2+/qU=; l=7223;
	h=From:To:Date;
	b=EAEuIw9oOAURhR6HeGmUoB+cn7XiUKke8eOP0/T0Hfs1nyuDStqPxPyYz08F4pGb0
	 uHuK4KGEwaaQYvooRWN2UaEfKSWs4sbnddRD/FQO7TZIJ31HrfSkxdQJbk7f65e8d6
	 5vZjRTzWAZYrWBvfnVj55EH7wNwbB0ttJmP8zuJ/kQMQWajhEe1ww+ItX3VlP48qLe
	 mA0lV55y1HfA5W+/wmLBbKIQY+xUcNaRovOkrAGJkoGUOeuaga+Zu+xMz6KxwjPhi0
	 JUJN1H8xkzni6Hl3BQyecff9NoW6V6fPZ+lmGim8R2whRP7PlceNTI5vZwj0XzkvND
	 rcosdNEMMeseQ==

The clocksource pointer in struct system_counterval_t is not evaluated any
more. Remove the code setting the member, and the member itself.

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---
 arch/x86/kernel/tsc.c                | 14 ++------------
 drivers/clocksource/arm_arch_timer.c |  3 ---
 drivers/ptp/ptp_kvm_arm.c            |  2 +-
 drivers/ptp/ptp_kvm_common.c         |  4 +---
 drivers/ptp/ptp_kvm_x86.c            |  2 --
 include/linux/ptp_kvm.h              |  4 +---
 include/linux/timekeeping.h          |  3 ---
 7 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9367174f7920..868f09966b0f 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -54,7 +54,6 @@ static int __read_mostly tsc_force_recalibrate;
 static u32 art_to_tsc_numerator;
 static u32 art_to_tsc_denominator;
 static u64 art_to_tsc_offset;
-static struct clocksource *art_related_clocksource;
 static bool have_art;
 
 struct cyc2ns {
@@ -1314,7 +1313,6 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
 	res += tmp + art_to_tsc_offset;
 
 	return (struct system_counterval_t) {
-		.cs = art_related_clocksource,
 		.cs_id = have_art ? CSID_X86_TSC : CSID_GENERIC,
 		.cycles = res
 	};
@@ -1337,9 +1335,6 @@ EXPORT_SYMBOL(convert_art_to_tsc);
  * struct system_counterval_t - system counter value with the ID of the
  *	corresponding clocksource
  *	@cycles:	System counter value
- *	@cs:		Clocksource corresponding to system counter value. Used
- *			by timekeeping code to verify comparability of two cycle
- *			values.
  *	@cs_id:		Clocksource ID corresponding to system counter value.
  *			Used by timekeeping code to verify comparability of two
  *			cycle values.
@@ -1358,7 +1353,6 @@ struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns)
 	res += tmp;
 
 	return (struct system_counterval_t) {
-		.cs = art_related_clocksource,
 		.cs_id = have_art ? CSID_X86_TSC : CSID_GENERIC,
 		.cycles = res
 	};
@@ -1467,10 +1461,8 @@ static void tsc_refine_calibration_work(struct work_struct *work)
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
@@ -1495,10 +1487,8 @@ static int __init init_tsc_clocksource(void)
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
index 75e957171bd5..0f00f382bb5d 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -270,8 +270,6 @@ struct system_device_crosststamp {
  * struct system_counterval_t - system counter value with the ID of the
  *				corresponding clocksource
  * @cycles:	System counter value
- * @cs:		Clocksource corresponding to system counter value. Timekeeping
- *		code now evaluates cs_id instead.
  * @cs_id:	Clocksource ID corresponding to system counter value. Used by
  *		timekeeping code to verify comparability of two cycle values.
  *		The default ID, CSID_GENERIC, does not identify a specific
@@ -279,7 +277,6 @@ struct system_device_crosststamp {
  */
 struct system_counterval_t {
 	u64			cycles;
-	struct clocksource	*cs;
 	enum clocksource_ids	cs_id;
 };
 
-- 
2.40.1


