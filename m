Return-Path: <kvm+bounces-4599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05DCE815349
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:11:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7624AB24162
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C634641844;
	Fri, 15 Dec 2023 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="VQhIjNaq"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2B266AAF
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.10.81])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 5BAEC10784101;
	Fri, 15 Dec 2023 22:06:45 +0000 (UTC)
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.190.17])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id DD6FA1000006D;
	Fri, 15 Dec 2023 22:06:37 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1702677996.868000
X-TM-MAIL-UUID: b9911cce-9f2e-442c-be80-281553fba8e2
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id D4032100010AC;
	Fri, 15 Dec 2023 22:06:36 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8qwOH0LP0a+2dT6T3bmhN3gwhVzgk7+ijr/YNhHPNVJdrOyaiy9RXTzkf4SIOyafkfrZNBgkGckoWWBbqnK292j+TZj8c2tsRVn7JtaOMm1UmJ1Y1/+Yp37myNVr/H/NjfF58st7C9ZOOH8yjwpPH27b8SRTUZvvDzvz83mhrJkw9lMSBze4ueAU4+YiPvRV+558KX7KPOJtoIezgrnLx+uzTPDckCpryLEKxBcF7Z84IkvGxSzmJ8IsSvoECV2xE8NBhCYX7lix+h0AJGEFI9pC7GnrztssE0N6B9NPUMRC/2FXQ4mpwb3uOaMhEOf7jsEvNTDuHcM5m3E03LMAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xfDBu0dFrCJ0xgcFfSZVaKqG7Zde6VKWwu8n6eP+A0=;
 b=VhuAcRgFJ75vNoJvAKShPJcMGf4OUw5MhzHILcJNxST5RlaHilsg5tX25tI3kz7OdgdA/ey27WbTTajM39Q60gDzM+XKe4ysJEoSzMrzeacGPV5MapGhl2CqOqQcsN1tk9TWo866L9Fh11O1mvlra2Q4bG+lFqzxM3Ye2tWzQthLLnoakD51bzYVhM2HgC9h2uILF4n+KUkBxLtUtCSopTKZv66Rk+/cVWTeS6XdkWx08GYF/cNK24ddG3juH+NulDwACf81gQfaO/rDDvyeZEhz5xUnbHb8DwWJasUShRmG8zYYAHdc5TlcG8+KaezmEVWOFqOceRMDONTeFfrLbw==
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
Subject: [RFC PATCH v2 5/7] timekeeping: Evaluate system_counterval_t.cs_id instead of .cs
Date: Fri, 15 Dec 2023 23:06:10 +0100
Message-Id: <20231215220612.173603-6-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: DB8EUR05FT060:EE_|FRYP281MB2304:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: a451a6e6-48ba-49e3-4948-08dbfdba1a79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2yeCm6q8s6Z7qAa8lz2S9IEc2ybGg3JzMs0IP/j8nkV8GkVhLIFhlp5+3WG5vkrEJkIQzKWh8VZD1sf/GomE6s6W92D+QIRPAiDXuLKziaLBEeZo7c0We+s8MkWqgb75gqBqhSomdvEbyweEKZq3mBzRD3CefmB8IGDz97eQ7xVXkqXXamnpXt2czIdpZbKXOIsL7VJeKPznVlNeOKVw0gvlHEz1XQqOwrqSsxa1dK0XrXEjJLyHzIozMFFUzhcGj8Wr8mhPZ0RWi0x0wH0IgbZcdGZsM7ihyNoazO2p6pLp3WloCCF7RLY9wgIDuki2WcIpfk6UZRjs3f0tCpGi4xi6qcZgl2pCa3dpWgleelPeHQdd0IROEZ5XkqeOzscxgajStmPtqy92qKwEiCeMjKVKhAXM4QCmKzGBszhymDVV1P5k8aZF+kAZk7upZRoONxawO/H6ISSPeWqpTS+KT1s6yUD5tq4jk/GgtOFEpijNkujz4NjAY6vUDIa4AclHfGbeXuvEXMGTB4JYDVDl6SRpRG7yvk+pA929bq0Ca6sFV00bRLpK+udFelW3gpg14YJiyF3IcqULioU4GohLBI8UCgMo+0Az5+VlJecNdP3y+qcl5eZvrgiHeFB9VdTvUyKmrFN04YZc85Otp1afjjF5qKbn6bl17dR6TWmNsFVtVGF90iIZjfhRfPlsHlJnL8e/lJvoeJMxLUIMPXL4XHkPHqy3DOzXNZ/VigK0gjN8+4nSPjGT5o0uc1NusY//JoxfO4AVkQin81zmmnIjuVhA4OY7z02h6GUAJrm98G4=
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39840400004)(376002)(230922051799003)(451199024)(82310400011)(64100799003)(186009)(1800799012)(46966006)(36840700001)(47076005)(83380400001)(1076003)(2616005)(336012)(26005)(36860700001)(4326008)(8676002)(8936002)(5660300002)(44832011)(41300700001)(7416002)(2906002)(478600001)(966005)(42186006)(54906003)(70206006)(6916009)(316002)(70586007)(36756003)(81166007)(86362001)(40480700001)(142923001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 22:06:35.1864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a451a6e6-48ba-49e3-4948-08dbfdba1a79
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT060.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRYP281MB2304
X-TM-AS-ERS: 104.47.7.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28060.002
X-TMASE-Result: 10--4.043200-4.000000
X-TMASE-MatchedRID: xPvPRJicGCRt/9ulvM0QMd/Z7q+hZQVe6wJlKkXfZVkJ5yiKyAQmigHW
	HoYGrPh+C2QDPheido9iBl6ePEpdZVlsdSBrk49aju2XlcEx9HRelLFkoMPMWOI/qZVAgf06Vif
	9o7rSV9vm9Tc/GgfFJwFtWueZlMH0t5KZ74QYwoxVSWOKG8Va/NVTzaAe7ACyygHdGJDPWm8TJ/
	T+Ssc4ZVqoLahcwH4L6xA0Ava73nAPm15xyht8lXx2eIlQG1sMfC4IwOLvyucC4DhlAS07elo7G
	mCOJYd1ifGCYEa4FxdKYLa8+Kx/sN9Plhio5fnckALaj3suKW4400aIRT5JuQ==
X-TMASE-XGENCLOUD: 433c05aa-ddf0-45d7-a0fb-c0f2b7ea777d-0-0-200-0
X-TM-Deliver-Signature: 9B5D122645748B5C3E68F7F255BE5457
X-TM-Addin-Auth: 2Smz6PIzA9aWRECSpKU3IMaFQ3QOtnjDu2p5JyMRuNABGs+ROowudK4OXIe
	mMg35X9gkMVwq7D+cdMcXWf17+Dc+qsWdb218EtH9aFnGw5XL4Q+NmLZUUpHvrYTyd52WOL3ct2
	W/Iuz6pgKNwO+Zqbco/oI3/L0Ag+X9dkjG/x+TPr1ip+DNSygfhciGQh/LRQlsIoUYPzbmrtKBh
	bgmsSRT/cpzBnNS5IMNw1Lx2TTRaNvwVt5G+24zw+Gc0124B3ziP5gEPgbM5wsBU/9qoenl26zF
	A4iBRczYOJnppZ0=.c8JYJCjKerTdVa17JXNbgHeu7f94N8OFSitIG/uqQ0A4v1ichTrzYxvAx8
	+XDyXVUYIvRF+HvTjmYpyQoePsMA4B+1S97F9ymPmlHHLygQtF47iYFNLHlc90CD9KRFHwFD4pR
	OIDca6uvXDf3mY19dajip1e4Jyn/8EZFAypG798RWxDcL7tWzE96KzFSOYyhy6ZAunUR9MDsvDp
	rrN/H8ywFWSzN1gzeaK/EV02GIpujAgIWiCb/VEsak9ipSoGJ3Gygul3nsWQYZJKlksc2pgxFNE
	WN8yDRQyBZsf/+gE7beefSLAeHzXfPsaNtytcPHH0zTBJzmJ2h3eqJwYtig==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1702677997;
	bh=NojOs1qfg8jfCnvQpu510s9G5wxEpdRCYhUuXgZyMgM=; l=3420;
	h=From:To:Date;
	b=VQhIjNaqWzDConf6m33bHny6T8JEUmz/xXKoo28/UItFI3emjHtLfee5RxKqbhpbR
	 9JNrSoxG6DUxm/pLxYfHUHgWCG7ib6HyY/yvK6slMXN+EdfTcVpPX8oMjv1j+DSMEV
	 JLzD2OewqgJWBP+KswLFp4OQtI8a16PVZd/+d2L8tODvF826LEg6kgu7+VOyggTQ3I
	 DS8zEvP11DlvzYYyM+C+5L7+9B+fqBF3J5o2Tv3a5zi1Lz45daA6bLavB8h6Zsfl/x
	 5AnO+q0H5V7D8yljYj1kQv7cDKfDU0tAum/EE1PN/rLOZQD92Cev/R2dbPIXdfoO9s
	 ROQDNI6ceCzSg==

Clocksource pointers can be problematic to obtain for drivers which are not
clocksource drivers themselves. In particular, the RFC virtio_rtc driver
[1] would require a new helper function to obtain a pointer to the Arm
Generic Timer clocksource. The ptp_kvm driver also required a similar
workaround.

Address this by evaluating the clocksource ID, rather than the clocksource
pointer, of struct system_counterval_t. By this, setting the clocksource
pointer becomes unneeded, and it will be dropped from struct
system_counterval_t in the future. By this, get_device_system_crosststamp()
callers (such as virtio_rtc and ptp_kvm) will no longer need to supply
clocksource pointers.

This change should not alter any behavior, as the struct
system_counterval_t clocksource ID is already being set wherever the
clocksource pointer is set. get_device_system_crosststamp() will now fail
if the clocksource has id CSID_GENERIC, but all currently relevant
clocksources have a custom clocksource id.

[1] https://lore.kernel.org/lkml/20230818012014.212155-1-peter.hilber@opensynergy.com/

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v2:
    
    - Refer to clocksource IDs as such in comments (Thomas Gleixner).
    
    - Update comments which were still referring to clocksource pointers.

 include/linux/timekeeping.h | 10 +++++-----
 kernel/time/timekeeping.c   |  9 +++++----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 74dc7c8b036f..75e957171bd5 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -267,13 +267,13 @@ struct system_device_crosststamp {
 };
 
 /**
- * struct system_counterval_t - system counter value with the pointer to the
+ * struct system_counterval_t - system counter value with the ID of the
  *				corresponding clocksource
  * @cycles:	System counter value
- * @cs:		Clocksource corresponding to system counter value. Used by
- *		timekeeping code to verify comparibility of two cycle values
- * @cs_id:	Clocksource ID corresponding to system counter value. To be
- *		used instead of cs in the future.
+ * @cs:		Clocksource corresponding to system counter value. Timekeeping
+ *		code now evaluates cs_id instead.
+ * @cs_id:	Clocksource ID corresponding to system counter value. Used by
+ *		timekeeping code to verify comparability of two cycle values.
  *		The default ID, CSID_GENERIC, does not identify a specific
  *		clocksource.
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 266d02809dbb..0ff065c5d25b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1232,11 +1232,12 @@ int get_device_system_crosststamp(int (*get_time_fn)
 			return ret;
 
 		/*
-		 * Verify that the clocksource associated with the captured
-		 * system counter value is the same as the currently installed
-		 * timekeeper clocksource
+		 * Verify that the clocksource ID associated with the captured
+		 * system counter value is the same as for the currently
+		 * installed timekeeper clocksource
 		 */
-		if (tk->tkr_mono.clock != system_counterval.cs)
+		if (system_counterval.cs_id == CSID_GENERIC ||
+		    tk->tkr_mono.clock->id != system_counterval.cs_id)
 			return -ENODEV;
 		cycles = system_counterval.cycles;
 
-- 
2.40.1


