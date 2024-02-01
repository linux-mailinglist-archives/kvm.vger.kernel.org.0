Return-Path: <kvm+bounces-7635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E66844E52
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:08:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4568028E656
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2955397;
	Thu,  1 Feb 2024 01:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="W1lqbVer"
X-Original-To: kvm@vger.kernel.org
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0525442F
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706749661; cv=fail; b=SQbPIDemu7NayNsx1jkiPwoy3BR7erqznLq/jqqkWCHkaFu+NdmICmiRAgquDqwU734XIQ5reIm6zi38XH9jcww2dJLuATWlMrO59CKRtPkErTQUcWU83Q/2PoAX/9Vy9ykP54B5ClXFzmpRx5UiMvu+Ev6MCyZQNEV267Nymtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706749661; c=relaxed/simple;
	bh=kph/GZbUL8v7Z7FSL2xEtj/zUnB/iHPuTCylgtGC1wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qy2iroUkp3L3xhY1xffcgB/Ql/MUSUA+wfcnXY19jVpzkTZ5JKo3ODfLN+YdrEB6ui1/W6W3s1peesqBeizONTsPw91av8Eo56GnHMyQilE3aoMtXUGqCqrbw7EUoxdYxHad5J/5Dt6Vm4KI4sammcI8nLj7m83zuqIC1P/79bA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=W1lqbVer; arc=fail smtp.client-ip=18.185.115.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.168_.trendmicro.com (unknown [172.21.10.52])
	by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 743B310A7E637;
	Thu,  1 Feb 2024 01:07:37 +0000 (UTC)
Received: from 104.47.11.168_.trendmicro.com (unknown [172.21.199.136])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id B23011000045E;
	Thu,  1 Feb 2024 01:07:29 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706749545.895000
X-TM-MAIL-UUID: 3c71908f-6059-4723-b1c6-9309dd182ff3
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id DAA3010006A5E;
	Thu,  1 Feb 2024 01:05:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eda9osc6SezHsGjdXbSKIH1/GE6+71QDoSKcu3jBUTIdL+urdgCLPH9XM3hSg+8/oyfZMFo0EccgfrmwsO5lZ5b2eZSYrXjgyDa5z/wF6+46Xl6F52JeykdV5Wc+JlGCHmcxRAkbB3Qnb2wLk6Q8uAk2LYJcZWYSILfacj7pYYTZq7QqWhsIMFJycGXZkXQfmQsPTIvptf+RzGWIrSXZSr2U6mygCuu107gmP6AEeLj+hMw+GalKMiFMZxICK8EgEQRimAkNgDQgkzFzWdl3qz/BKarXU2TB+KvxyEhJBsnLCgYUxC60zosbp725e7+I5vxpOUQ62oMAEm2J0tICzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qi5SeCGD4c/KlJEua7rmHMG+XxuwLmKXWOyIksFBo8=;
 b=iJJRu87tJ0gH0pHtZddl5c2dSvMNxSK9Ig1iJyisfEHaemdWj2HsCtOjss6VC3WxvOpV4dWoh+uiStFAek/XI3YQOfnBTqs7FJSZCZwAgD4zODUsWrfWfeBfhsQvw5wr7QJj6VnXfaye+83advL+exjRs8WQHrkM29gxLblgKjsH+RNPVhmsg/cmZHJidpEylvf1sC1a+/Czy+28+LBxLyGFhCmzrLf7ZtSCYmG4U51uCNBEMO1ZVDdkukwBtTvBhjxzG8TkcU3PMp5HFF+pDXpXyl1LdAlDV8AW/QfsznvcG744xWNwz1eGkK5E+1Wbg0TKUXXsVkB8bkIKV4g9wg==
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
Subject: [PATCH v3 3/8] x86/tsc: Add clocksource ID, set system_counterval_t.cs_id
Date: Thu,  1 Feb 2024 02:04:48 +0100
Message-Id: <20240201010453.2212371-4-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: DB8EUR05FT010:EE_|FRYP281MB0093:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: cf5fb289-d164-4722-b051-08dc22c1eae7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Q6wV8Ma0AfooY2vBodUQE+9VGdTUFvLwXC/WTekIONIEqZJ6EbLV6J1RC5YMBLRbtkRnmL3rf9YOetjV4nPDg4G2glkyxA3Uqljef16/DGPEATVw6xWo8kN9+KX+1TXXl0VD+gzSrJmqS+6jMFwHLTeytLIzR7V1pz4GPfrTjSHFf/Ax6/PVkd5NCpd7ahspxRCBg2G5X6gRL4gLmLreEA2cTFyxVwhKYtxUEYBYVmesTwCqusDAn+aI2xGj9AOuQ4/Hpf8ewasRuwYOnNYxddqGCWiALWN7O82HOn6zXC3PJp4FTwED+aTDgxU7AWsjC1gEJ+JmF063pVwZN+EtQWQ9aMuL7iu6jJUkKmu2xis/b8bcLhR2IpRlhzqVNUDknsRunloTUXU+TBrvlTwqtkvrLMKKgfgb3CHt07IkvLGu8qRplZT015kqB15k23pBUeCsdGDhz/T6NtEZIwxXbheWQU+DCpvqQ9gEImp6BpzZFY0zLQYbo7e3QZkTIlhUlulikJLUOm3wb19DaETFH6BcNvjeFfjHcMUo49J1AyjZ9lhv3Zs/1buaOXiIwjISZwOosZs0TAAmNV0v6cOkmGRaGcCxP5TdH0krI4VF6B5lP2aYcV1VCYgFHOiM3Bj1SZHJ7sKGJ/tsviVTRpHTePIn3X85b1z9In6WPVppW1Tw13YEfCBq3POyA9ZIWrBmX4fxvqVZe262L+GaLIAooHEoUqI0UMKmx6m+OXOBU8RCSEZCPYNv9qYb6Dx+xNn2+tMNcTwtM9p0suQUCKcm+bPvnGOJJYks9Grk5vZq0a0=
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(346002)(376002)(39840400004)(396003)(136003)(230173577357003)(230273577357003)(230922051799003)(451199024)(82310400011)(1800799012)(64100799003)(186009)(46966006)(36840700001)(8676002)(4326008)(8936002)(83380400001)(2616005)(1076003)(70206006)(26005)(70586007)(336012)(41300700001)(86362001)(42186006)(478600001)(6916009)(54906003)(316002)(47076005)(7416002)(5660300002)(44832011)(36756003)(36860700001)(81166007)(2906002)(40480700001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 01:05:44.3759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5fb289-d164-4722-b051-08dc22c1eae7
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT010.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRYP281MB0093
X-TM-AS-ERS: 104.47.11.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28152.007
X-TMASE-Result: 10--14.335400-4.000000
X-TMASE-MatchedRID: DIEPoA0d9jzJ+P2VFrJmrKwODSO9Fuc1zmG9pmg8ncKJFoX8AKzcA1om
	CW9DDtQZ4hVD9eCRkSzqUb9emYLkvriZvMg1M8zIiu6u4shZ+fGRRM7IbBAoRyhxkKIUBctf+JL
	cWYHtZNEObBW6/DqoDOUTedInjF4ziRz4gknBIqB0CtK0DggAXqeeBvX7bSdNqWgfIMWloSygxg
	zwH3l2wulvQEurXogbqQMn/UStEoOovD0wMSGqkmwEEr52PwDFaRrjP4hMuEYY5lMhYxPBYrdG6
	qoYZcgziQXeVzaEgj/rEDQC9rvecA+bXnHKG3yVfHZ4iVAbWwx8LgjA4u/K5wLgOGUBLTt6Wjsa
	YI4lh3XIx3Icp6zuW7dCjoZl+x6LClEFFkJvh3LF0CStGX+q3SX3GjGd8V5p
X-TMASE-XGENCLOUD: 8c0870c6-cf32-4942-8371-e6ebefe45c43-0-0-200-0
X-TM-Deliver-Signature: 457A051C3E60FB81FFFA52480F7077B2
X-TM-Addin-Auth: g0H8j/tgeWZt7f3c1doJXElz7fTzMIbUDtS7WFcH9pbnHdsVxqGfKdGaXZy
	L4lmAWdUeo9oDkEkf0XVKMDlEAR4pstyw4BIvoZiGqOoiDIoV/su5AjUIZzOBA3FKTFrwURhkFS
	9Q8yVZ0/Jg9TgwAip0dtGcH0P9PeHGMFfklc/cdvUdMDivvlZfUMbeYL+Gwdr00S5L0Myc4LL+V
	GwwOs2AXqMlWSuzjVVZVmi2hoHdlySvf05knPxQYOFtYdMNkmb9a41tzJARk/QqLb20kMCr0GzG
	Pg+D+JJOPXIaWBaRTHEBH5gTTqWg+fbnERLP.oUND6oWJmlwibje0Xwjsx7X5kSfjjAZUXsS293
	zutkbiLrdLW2T2/1d7z8gWCY+R+MxSGJe6ujcEWY2t5l9Ex3CLiWpFw4zVz14NVyNe5rHCgEc1D
	Q0bm0Evd6JYz07IcRL3+irrf2hDggFUgvbE2mfnJqbLSmWYgL7NtpVPss9TZUVo3wu31B4pRlk7
	jwDzyIWXufL9T4EU/RiVN7S9QGCfIIr6bgFEtp+i1EgD5Pq7TMrg3DzkpuZ7bQ/555vn4GnIWL+
	xL0XD4ImaYDad52moUzFZyqsdvB2Y3xiTAhwcfvT9q5YdAre7a/6LG9bZyg7NqKq6R1HNks+gRP
	DxYQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706749649;
	bh=kph/GZbUL8v7Z7FSL2xEtj/zUnB/iHPuTCylgtGC1wc=; l=4864;
	h=From:To:Date;
	b=W1lqbVerDfdnojQVcYq+RUuqiyM8t+YiciIAngWFY9ARIl+XxAKxP9LLu85CchGw/
	 Gk/3Xg3h45xNYsmACzKrRxjLc+C62wtNTAhwkhWRRCuhdpfi93bVy7lwz94xQsrzYc
	 7R681xx1Oyh6QEjfsIPm8UH5pHR3b07Sda9b5hZtNZP6OAGyU8HZllX5y972pYM02P
	 nNWt+GYmmjS2+O4oJjVUyQIoqL7qnRC0509wmrORww4WYSN23/jXwlsAVUwQOkfYG5
	 GdGygZTo5wOVOxCpuwwerejb5iOSSUZm9T0ERrVN1CJjq0JNL+b/3WvhazL4ITkwDv
	 YZZC67DuBfkxw==

Add a clocksource ID for TSC and a distinct one for the early TSC.

Use distinct IDs for TSC and early TSC, since those also have distinct
clocksource structs. This should help to keep existing semantics when
comparing clocksources.

Also, set the recently added struct system_counterval_t member cs_id to the
TSC ID in the cases where the clocksource member is being set to the TSC
clocksource. In the future, get_device_system_crosststamp() will compare
the clocksource ID in struct system_counterval_t, rather than the
clocksource.

For the x86 ART related code, system_counterval_t.cs == NULL corresponds to
system_counterval_t.cs_id == CSID_GENERIC (0).

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v3:
    
    - Omit redundant clocksource_ids.h include (Andy Shevchenko).
    
    - Omit struct system_counterval_t member documentation, to resolve
      kernel-doc warning pointed out by Simon Horman.
    
    v2:
    
    - Name clock id according to Thomas Gleixner's mockup.
    
    - Refer to clocksource IDs as such in comments (Thomas Gleixner).
    
    - Update comments which were still referring to clocksource pointers.

 arch/x86/kernel/tsc.c           | 27 ++++++++++++++++++++-------
 include/linux/clocksource_ids.h |  2 ++
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 42328f9653c1..9f164aad5e94 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -54,6 +54,7 @@ static u32 art_to_tsc_numerator;
 static u32 art_to_tsc_denominator;
 static u64 art_to_tsc_offset;
 static struct clocksource *art_related_clocksource;
+static bool have_art;
 
 struct cyc2ns {
 	struct cyc2ns_data data[2];	/*  0 + 2*16 = 32 */
@@ -1168,6 +1169,7 @@ static struct clocksource clocksource_tsc_early = {
 	.mask			= CLOCKSOURCE_MASK(64),
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
+	.id			= CSID_X86_TSC_EARLY,
 	.vdso_clock_mode	= VDSO_CLOCKMODE_TSC,
 	.enable			= tsc_cs_enable,
 	.resume			= tsc_resume,
@@ -1190,6 +1192,7 @@ static struct clocksource clocksource_tsc = {
 				  CLOCK_SOURCE_VALID_FOR_HRES |
 				  CLOCK_SOURCE_MUST_VERIFY |
 				  CLOCK_SOURCE_VERIFY_PERCPU,
+	.id			= CSID_X86_TSC,
 	.vdso_clock_mode	= VDSO_CLOCKMODE_TSC,
 	.enable			= tsc_cs_enable,
 	.resume			= tsc_resume,
@@ -1309,8 +1312,11 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
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
 
@@ -1327,7 +1333,7 @@ EXPORT_SYMBOL(convert_art_to_tsc);
  * that this flag is set before conversion to TSC is attempted.
  *
  * Return:
- * struct system_counterval_t - system counter value with the pointer to the
+ * struct system_counterval_t - system counter value with the ID of the
  *	corresponding clocksource
  */
 
@@ -1343,8 +1349,11 @@ struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns)
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
 
@@ -1450,8 +1459,10 @@ static void tsc_refine_calibration_work(struct work_struct *work)
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
@@ -1476,8 +1487,10 @@ static int __init init_tsc_clocksource(void)
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


