Return-Path: <kvm+bounces-4597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAA9815345
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D69E1F24846
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B275639E;
	Fri, 15 Dec 2023 22:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="P9TsXwVm"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E159F4B5B3
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.168_.trendmicro.com (unknown [172.21.19.58])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 5789110005854
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:06:42 +0000 (UTC)
Received: from 104.47.11.168_.trendmicro.com (unknown [172.21.165.80])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id D08B810000624;
	Fri, 15 Dec 2023 22:06:34 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1702677994.297000
X-TM-MAIL-UUID: 88af4850-7668-41a2-a00c-fc0043bae284
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 48A65100012B2;
	Fri, 15 Dec 2023 22:06:34 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrvoYLGxDx8rz70NuCQanFGKRLwQfT3gPjd4Vzvi0jcG0WYOSXpO1r1nHZbAGkZMwYm5qP1yN0CvTh+9Wpca6dzC7PqOgTtzJIWdji2c6NGaludtaWSpxPFt1fIh2HS2hR8Kkrm7+z/G9wd9MMCiGTXfUmu2B0pOvFAtdy3+gD7fCQdvC4SquWIH82VbGg4uQf+JiVRYwI52T6JC1Xqk9S+g3trDTbwfU+9xpOSBhv5RRcFY0a/rmxvX4EJy7DEkylKeiezpwYpLrut88VSE5xQQ7gFysALC0FqQrXjKCJ3qjs1N0/6cyNi0V+JqmWjCWfNpDMW7uhK/UPMzGGKGDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRtFNCAr1Ds5fKMUJ17PxiUdSGKCZ1/180VbstTHU9s=;
 b=idnXn3uq1p7EaIx7MEDjGvYX5wFZyFFe0IF1nd0TQuVhZU3nRB4Y9vZhlnPyRWHUDKbqO4w6HigrruKsl2RLx5PVb9yqwYj/v+yu1TbGfcByHxetpYi9KCwOd/pwbbzb+n4YsJpUGpsSkONVT8gG48347Z1DmZQfUmGT3A+GClZlSQNWNexirmR7Zg2gW2r5qY7e3EwggWgBIUo+nwNyHFfakMq64AzyomKh3qU/FX6WxZ/JnBQEb3eNNOMjrrvgkTKyfP4Y28ZGQ4OTgNJ6VAaNtkOt5ye4eGk1yzSXC+nBxI7ZQfoq3HUsZdrZCVEmCmaJcF7ZfMLSLg65+x4C9Q==
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
	Marc Zyngier <maz@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Richard Cochran <richardcochran@gmail.com>,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [RFC PATCH v2 2/7] x86/tsc: Add clocksource ID, set system_counterval_t.cs_id
Date: Fri, 15 Dec 2023 23:06:07 +0100
Message-Id: <20231215220612.173603-3-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: AM6EUR05FT033:EE_|FR2P281MB1818:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 61ae0900-d40d-4128-bc8d-08dbfdba18e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EtmwNUPBPq2KEPELYx7NUUL5GqMpS8TgXfuiOcqIthhH8YPMdCDaIBhOiPMu+yUtB5Bk3UakBYMclo+rF9MTH3F8sb2NrKVFrACtXBrtYyikbX9mv36KfxHSFW6RxmMXqbGcUZj2OXjATTFaySFVGLK28f/uGJ45/tRcni8Cm1wnCDjFFsxv2J2mRWy3PydaqKZzx5lN/DuAq2qOrgayyliE/XXDHL6wgO4DAtwiqQzgZ17isvE/y4EPL4w2ZX8zdOLVMCV+Uc0vQAy/q/gzWlQkOFjTBxhCXwfGmx98sBlOCr75hrp41rxZriSH25blRZB561rZwagK1pBMcluu6nMTJKDtd+WFfuPALsfSqiOW9maZaD6ykbBPXcwpPmmMpq9p9qmS/xnAslDxescihVKyJsqxXKs9ByG+crHA6p8lo/+CgmTn9ku4apIAvwuji1r+1tXtf3Db+gAqXyUIaJqC10UQe8o38p+oOdVT0xGUbZhGD34Anxgr/EIyqc3VkQ+fgGQ37NU6HuAukBQW2DS4mkvN9ra0h9KAqdFGU6PSrr4lH3zR1hsx/sG28gNKCEO7jk1p8oxqRmd0O2XW9PerUEqKzvQFNl8NXaOw2NBeuRHoynMAfd+YrnjKD0UM/b1qkF3JxEnwkiglpKra3Iy7uHGjE6G/W3VgKQdTOaybS9jCWKTmnpU1I4m4XUvauN0WAwzL3gHZBuKQz0QCj5bbPe6Iv1444slZpqnMf671N5pXmru0h7oxO9ZcTxdvpOi+f9Hz/nzEwe+q+bN9zU2hJrcDwodsINxDv5Jy/50=
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(39830400003)(396003)(376002)(346002)(136003)(230922051799003)(1800799012)(186009)(64100799003)(82310400011)(451199024)(46966006)(36840700001)(40480700001)(36860700001)(47076005)(81166007)(2906002)(7416002)(36756003)(5660300002)(83380400001)(336012)(1076003)(26005)(2616005)(478600001)(6916009)(54906003)(70206006)(70586007)(41300700001)(86362001)(4326008)(8676002)(8936002)(42186006)(316002)(44832011)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 22:06:32.5860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ae0900-d40d-4128-bc8d-08dbfdba18e7
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM6EUR05FT033.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1818
X-TM-AS-ERS: 104.47.11.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28060.002
X-TMASE-Result: 10--15.306600-4.000000
X-TMASE-MatchedRID: DIEPoA0d9jzJ+P2VFrJmrKwODSO9Fuc1zmG9pmg8ncKJFoX8AKzcA1om
	CW9DDtQZ4hVD9eCRkSzqUb9emYLkvhfJ8eNjkTqdDH4m2ujwCttelLFkoMPMWMhGESF2QtYSi8+
	IGr+Jb3Uyk/Hw4XN9jfnGisRnvgFZd5ZQIOSj8/NgFLgE7TxyQ5Fx8VBGp0H2/2e2Gew+JKSNm3
	Cs2pKS6xeVNYbNufufJ+HonzWLENa7Ky1CjgAnYWwEEr52PwDFaRrjP4hMuEYY5lMhYxPBYrdG6
	qoYZcgziQXeVzaEgj/rEDQC9rvecA+bXnHKG3yVfHZ4iVAbWwx8LgjA4u/K5wLgOGUBLTt6Wjsa
	YI4lh3W+IjsEEOIzYopRhpdokeNoQh7AYbodFKriEn0i32rZrz9rrDnRhlmw
X-TMASE-XGENCLOUD: c483d876-081e-4ae2-8aa7-2fd9f78d3f0f-0-0-200-0
X-TM-Deliver-Signature: 06DA4D6566C336DA0B9D250AF27F248C
X-TM-Addin-Auth: rDHOMPXkU5q4l4Kj2AGctaQDGNncex0Rh+Ce67ArPJyZ+/WzH0J0oOpH6/E
	NanLrYKL8reYaAFrlrVn/FF6vh1EQsdtuZkGvp131ehc3g6fkOgHQHABNiX1G1ojMZwQsX8X3zK
	NAd3XMdbOX2j9x3CcXiHj0+v1P6E/Fu3A4+tGHamsaduqbBnStO3v/bPQT65t3Cc6J5Y2yiWbCM
	SAZcPAItHcEPbnllKnddWJaaNcNpDSyUSjX8rBrixDGYBkIvdmBbwBUhKXCJNk5rlTWnd8suDvs
	NgsPasGYRSTIFPg=.Zxa1Sjv5U70bbTSZLQa39wPe4UMZqzpZ85L62/vjY4hAxoI9ZsGh03O/it
	8ptsPyUQMucW1MQrf4umLPgNZp1sw5XVZsaexhe3icj9cgDhplbgnFM9wUAd0OEm/7H4rhzCd05
	7LJyvoyf+tiYCIK0SW8qnn0aGzPEVq1srLiCcA+5+yx64e3G85VYWZq0MauzvEziwyKmcp9hyDQ
	/ZWekuJn9Yo/RpCiVI6P1/IkasFjnnCM7yUmyr4Fcy1TA6RovwAZlr+FV0VzGOkNCc6dG/30+y9
	Rodt1lLubqgh0MtFpb2W66K95PEfgcHv0FoFerqpyVHGY1ftUwMDTwuo5zQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1702677994;
	bh=xEWCo0i3CVcG9U7bBjQMZXzIReSqMOlFd1TAhHuIl7k=; l=5309;
	h=From:To:Date;
	b=P9TsXwVmJ0G8nDTtUxP0YLVC5LwZdOmscfvxFVdPTfD09pHAZFbwfiAA3zo0AcjJx
	 6h+H5opIW1Xh1vHhj5Q+7uJcozk9pMqpV/ZsTEeGKO6bMX2vLuaTMTrUYQIt4D7g2O
	 RyPX2tPCRgaa7Cg3g1iI3CIiLQCAgpwFToNS0TDmmhMdhS1HfSg5d7ELothvU5+kO+
	 wy6DPjrHBfOFLkfhHd8MrOYuWxI514Bo9/FXOrswJBp4NLGYlRBk9snnH61QzKPQWk
	 8HoY59VEAqZ61verzdCqIl+Chp9L+RjL+uSig30F5TlV6Pomzfwa2w9YyCASBOYtD4
	 aynqd/T9MRvCg==

Add a clocksource ID for TSC and a distinct one for the early TSC.

Use distinct IDs for TSC and early TSC, since those also have distinct
clocksource structs. This should help to keep existing semantics when
comparing clocksources.

Also, set the recently added struct system_counterval_t member cs_id to the
TSC ID in the cases where the clocksource member is being set to the TSC
clocksource. In the future, this will keep get_device_system_crosststamp()
working, when it will compare the clocksource id in struct
system_counterval_t, rather than the clocksource.

For the x86 ART related code, system_counterval_t.cs == NULL corresponds to
system_counterval_t.cs_id == CSID_GENERIC (0).

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v2:
    
    - Name clock id according to Thomas Gleixner's mockup.
    
    - Refer to clocksource IDs as such in comments (Thomas Gleixner).
    
    - Update comments which were still referring to clocksource pointers.

 arch/x86/kernel/tsc.c           | 31 ++++++++++++++++++++++++-------
 include/linux/clocksource_ids.h |  2 ++
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 15f97c0abc9d..9367174f7920 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -11,6 +11,7 @@
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
 #include <linux/clocksource.h>
+#include <linux/clocksource_ids.h>
 #include <linux/percpu.h>
 #include <linux/timex.h>
 #include <linux/static_key.h>
@@ -54,6 +55,7 @@ static u32 art_to_tsc_numerator;
 static u32 art_to_tsc_denominator;
 static u64 art_to_tsc_offset;
 static struct clocksource *art_related_clocksource;
+static bool have_art;
 
 struct cyc2ns {
 	struct cyc2ns_data data[2];	/*  0 + 2*16 = 32 */
@@ -1168,6 +1170,7 @@ static struct clocksource clocksource_tsc_early = {
 	.mask			= CLOCKSOURCE_MASK(64),
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
+	.id			= CSID_X86_TSC_EARLY,
 	.vdso_clock_mode	= VDSO_CLOCKMODE_TSC,
 	.enable			= tsc_cs_enable,
 	.resume			= tsc_resume,
@@ -1190,6 +1193,7 @@ static struct clocksource clocksource_tsc = {
 				  CLOCK_SOURCE_VALID_FOR_HRES |
 				  CLOCK_SOURCE_MUST_VERIFY |
 				  CLOCK_SOURCE_VERIFY_PERCPU,
+	.id			= CSID_X86_TSC,
 	.vdso_clock_mode	= VDSO_CLOCKMODE_TSC,
 	.enable			= tsc_cs_enable,
 	.resume			= tsc_resume,
@@ -1309,8 +1313,11 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
 	do_div(tmp, art_to_tsc_denominator);
 	res += tmp + art_to_tsc_offset;
 
-	return (struct system_counterval_t) {.cs = art_related_clocksource,
-			.cycles = res};
+	return (struct system_counterval_t) {
+		.cs = art_related_clocksource,
+		.cs_id = have_art ? CSID_X86_TSC : CSID_GENERIC,
+		.cycles = res
+	};
 }
 EXPORT_SYMBOL(convert_art_to_tsc);
 
@@ -1327,12 +1334,15 @@ EXPORT_SYMBOL(convert_art_to_tsc);
  * that this flag is set before conversion to TSC is attempted.
  *
  * Return:
- * struct system_counterval_t - system counter value with the pointer to the
+ * struct system_counterval_t - system counter value with the ID of the
  *	corresponding clocksource
  *	@cycles:	System counter value
  *	@cs:		Clocksource corresponding to system counter value. Used
  *			by timekeeping code to verify comparability of two cycle
  *			values.
+ *	@cs_id:		Clocksource ID corresponding to system counter value.
+ *			Used by timekeeping code to verify comparability of two
+ *			cycle values.
  */
 
 struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns)
@@ -1347,8 +1357,11 @@ struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns)
 	do_div(tmp, USEC_PER_SEC);
 	res += tmp;
 
-	return (struct system_counterval_t) { .cs = art_related_clocksource,
-					      .cycles = res};
+	return (struct system_counterval_t) {
+		.cs = art_related_clocksource,
+		.cs_id = have_art ? CSID_X86_TSC : CSID_GENERIC,
+		.cycles = res
+	};
 }
 EXPORT_SYMBOL(convert_art_ns_to_tsc);
 
@@ -1454,8 +1467,10 @@ static void tsc_refine_calibration_work(struct work_struct *work)
 	if (tsc_unstable)
 		goto unreg;
 
-	if (boot_cpu_has(X86_FEATURE_ART))
+	if (boot_cpu_has(X86_FEATURE_ART)) {
 		art_related_clocksource = &clocksource_tsc;
+		have_art = true;
+	}
 	clocksource_register_khz(&clocksource_tsc, tsc_khz);
 unreg:
 	clocksource_unregister(&clocksource_tsc_early);
@@ -1480,8 +1495,10 @@ static int __init init_tsc_clocksource(void)
 	 * the refined calibration and directly register it as a clocksource.
 	 */
 	if (boot_cpu_has(X86_FEATURE_TSC_KNOWN_FREQ)) {
-		if (boot_cpu_has(X86_FEATURE_ART))
+		if (boot_cpu_has(X86_FEATURE_ART)) {
 			art_related_clocksource = &clocksource_tsc;
+			have_art = true;
+		}
 		clocksource_register_khz(&clocksource_tsc, tsc_khz);
 		clocksource_unregister(&clocksource_tsc_early);
 
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
index 16775d7d8f8d..f8467946e9ee 100644
--- a/include/linux/clocksource_ids.h
+++ b/include/linux/clocksource_ids.h
@@ -6,6 +6,8 @@
 enum clocksource_ids {
 	CSID_GENERIC		= 0,
 	CSID_ARM_ARCH_COUNTER,
+	CSID_X86_TSC_EARLY,
+	CSID_X86_TSC,
 	CSID_MAX,
 };
 
-- 
2.40.1


