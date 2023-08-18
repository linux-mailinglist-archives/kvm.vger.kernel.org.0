Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A694978036F
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 03:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357099AbjHRBjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 21:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357096AbjHRBi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 21:38:57 -0400
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1415710C0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 18:38:55 -0700 (PDT)
Received: from 104.47.7.169_.trendmicro.com (unknown [172.21.10.202])
        by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 8DDA8108B1E6B;
        Fri, 18 Aug 2023 01:13:16 +0000 (UTC)
Received: from 104.47.7.169_.trendmicro.com (unknown [172.21.196.113])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id E64EE1000045E;
        Fri, 18 Aug 2023 01:13:14 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1692321194.277000
X-TM-MAIL-UUID: ca907b62-712e-42fa-9c69-cc7472ed3884
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.169])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 43BC310004D9B;
        Fri, 18 Aug 2023 01:13:14 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6gt32ezZm7ksxTeXELRUWWBedcDcYdd+RuRv3VxDbSW4xl5NyjgLIka+FRr59ScP/BOoPgzVa9KQQDb7vsK+WS9m+MqwiW9xCdToOAyf5ui09ttDcu+zWekhU2q7hSfy09cp+AXti2R2w8Yp7OziiEhmGLaqTKvb5059R2fG9EiA2dspefiG5pbCoBJg4JqDIWN0cxXph/r1y5ZIkW80GbX3Hu8c3TUhoXpt7yt7VKvFhJIWecAFm8VmBIDwXadmoAsaXhsr4h0/fPLr3MMKSYI+b4+l94b7ek2SeDR0wM3cdZJJcTx0i760HRe5PA89m8bNHHsPNlXxcD7ZfAzOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nuYTvW/XUgqVExRqpD9gMez2RPol1h+jOniVlfAKtI=;
 b=Zm8/Ear3YUImGx2GyOk3Wkjbr0iuzcKtYrNXaeikNHO3rcSEWRx5kJzL3dUeOeARxbuf5Gmm7H/XnyTPjlSMAg0GlUmQ/41WRbebxAJ6YtgMgdwB6lX0fwAit5A6uCwbgByTREuyLNaYC8yfNDPwClxEfGEHInmdXitom3pm6efLp+1ogc93sOdI3iDs0I1AlIHah3DnfS0ikBilC+DdcZv8JUkqpLULolJzxPTdli6DeYz46iZFPgCG/powJT/gwUct4b92nV6n1Riai8U1Wm1cGx58QojGjE9ETHooS+RWATj1rgF6Te+IHTxHNrlCGud4QC3jHUQqCI0cvtGrrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=alien8.de smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=opensynergy.com; dkim=none (message not signed); arc=none
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From:   Peter Hilber <peter.hilber@opensynergy.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Peter Hilber <peter.hilber@opensynergy.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <jstultz@google.com>,
        Stephen Boyd <sboyd@kernel.org>, netdev@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH 4/4] treewide: Use clocksource id for struct system_counterval_t
Date:   Fri, 18 Aug 2023 03:12:55 +0200
Message-Id: <20230818011256.211078-5-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230818011256.211078-1-peter.hilber@opensynergy.com>
References: <20230818011256.211078-1-peter.hilber@opensynergy.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6EUR05FT003:EE_|FR3P281MB1999:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: b0bdfd0e-4685-487d-114b-08db9f884b64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xpsBIsWe07RpaqKEQtn/mRa3Ad6Z6INZTCCTFcDbRoM1FjMRh/F8a5aLlIE/h6HrNSblnozf4/96qmeHoK/b6R6GG3OqgwMYXRpdgxa6fQa+9FIZbpT88rddU60N2nbe+LXvS8xWwy1skmYvNWEpoqLdx23nms8DkFOqVDeRmkgCt+bkv4XK6QcjrBvBM+c/iwYtpUI9Z8wFD1JeZiWbqOwxqGQKzq28w7DsFOaolzvLGrS1W7sw+qd8qmP0QyRYGTkvtl5RO5DduZS7I3daeeWc43oFH61D/eD6/EdO3XrgEA7k8cxcY7goqHn1Lbwv5323rKSKki7RPrNWli5hfe/gkb6r5To75eTD/kIMkhJ6fF2DAQtymkfddCp9qDn2V3qhORqvWNQ3L9ERjWEoXy0cCJsNrWN02q1ohec+Gjcy2CMR6kLWP1ZPuQ+eBhPcuDnEFn3fpGrZOi4Qd/hTvFNI1Ly86rrT2Kbln3X10Ga9fBZuIqoJpb2idI1AUbe9rGIRB0Pkce1ILTdQ94nRgXJ4XV6KWP+7H+nS7WSGhOk6Dm0L48b228525pUccBsCWu5vnl8sIdZH+Qer/2hdlXIBXvtobw6S/HXI03LbU8bCJGU5arBbh+0sxM+wSx2PcTOsPPFNIjaOjvVnUkXuRy4e1deTOj1aaW6vWbvL/0ukkSimqGjp9f2MnK7tM/7R5IvyFTbDVDw90cfR7FIasz7CQS41Uu4xMdYLchE4ctzxknoOEdMY2rvx2ZK1NiV8akqNigZ2AIvVA+JIum+XuOWeVsum7vef5qx8xlXCPV7LYYKkNh135cNzXkON1+bF
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(396003)(136003)(39840400004)(376002)(346002)(186009)(451199024)(82310400011)(1800799009)(36840700001)(46966006)(36756003)(86362001)(12101799020)(83380400001)(40480700001)(8676002)(4326008)(8936002)(5660300002)(44832011)(2906002)(41300700001)(1076003)(26005)(2616005)(336012)(36860700001)(47076005)(478600001)(7416002)(81166007)(54906003)(316002)(42186006)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2023 01:13:13.1493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0bdfd0e-4685-487d-114b-08db9f884b64
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT003.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB1999
X-TM-AS-ERS: 104.47.7.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1011-27820.003
X-TMASE-Result: 10--10.549300-4.000000
X-TMASE-MatchedRID: /ZPxQQwIKahn1p91e59ja75qo7cbei2zxgiPAz8l1fsopiVY+XbpKyi3
        ojDl4/MdYIIkUAi74WXQrFpqAqhSQJem/4ajnoSsx38MG44f3TdEu4hdWK+90/c8c/vfJy26maC
        R3tzSaSW7XX8F0k6vEcZ1ZNHqLwMNTnGLsaD0u2GGLYLt2U0pahJFEvBK54PaxoZncY54rxY0Ri
        Z6Ct8rIg5sFbr8OqgM5RN50ieMXjOJHPiCScEioHQK0rQOCABewRidCPjiF8OZBQ8i9msMNzt5y
        G5DhcrC26qGmmu04W7+T/V+MonHrcddJPEKsqAMES46qCSbf/WHvP6CYoqPSgN/ojyMXH62DEom
        GUxecKpxg7svMtapLh8kPiYhnCdMIj70CBf1okqTDJFFF4l8OLki3lzD1Nth7RpsEjdIn0c=
X-TMASE-XGENCLOUD: 8f1e8718-55b7-4968-8dc9-32a5e71c1900-0-0-200-0
X-TM-Deliver-Signature: 0FE74A8842DA82A1C35644C7F2C7D3EA
X-TM-Addin-Auth: 4IzaOOBrJ1+F86JpdLgH350CNsnOndP3x1CuVYEEcIJbuj2tiZvoS/UauXW
        gf6EX2PTDq7GJxcoBm/pbAQF4lJk+PIw2cKRzUWiOXgqxSdUxrISm6B1LXDuTPVqW+wu+CvuYLQ
        PMKpjffFlIQcamTUuctiGvN+hz0tqxHn+3Wx+ttduf2NUZWlx9LoDb3TzuwhDMn5QzJ5G+8YuwL
        IEHz2HQSoQvElyXArAhyGd1K20QU9FWmR2mTUUDTJcuoxQd18nEB1NNXK19RjR6eqPzT/CPoY9g
        aW2QvK0iLWPtPcs=.k8SahcA1loNwanXQcRQhYF7KEoybcTKHDPP/glFpkk2M7E6jXWtMNsBXTf
        lxPfQtafVI6NMx3vi2GzucOe+Yu/4KNKSDK+RuogVA8c/lbZEw5rMevkEE+PZXFIYLJFtcAJ+Oa
        h3T7pSx4imTn5X4U67YzjtnJrl+JimfcE9l6Z52WOYYZmYs0CcRAdDbqw2LzMbqj7m+rxyHNut4
        G+jpWDEmUunW60c9h6GpTes3DPo7exij9tAaOLh6RS/pENEy6FYd2ww5PfzQD+Wl/t91H5ukp/2
        3tYfFVctuiX6FcAZ7fGZnRP5UNtp1MftHl0ugJVXy8xV7LXmSkyZX3Ux95g==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1692321194;
        bh=5FpIlNayVCceR8LAT06Pzr1NN/V+2GS4+e2hsooOi3U=; l=4788;
        h=From:To:Date;
        b=g07xnghOW9Ag6/BtpFSOzZ4h4Y4Ja2RIGGB6yw2REtwGq9U6vIkDdUq1vuNhNajgH
         ugvABk15wDGdUy2Ai4jtBig1qKSlx3HnE0YUFTBwuIfHt8y70mR61jbden+B4yJtM/
         /XkL/XEexc279FH412kbD9sNApCWDKFf1pCMFxAri5MPEFFHIx6VGzaC8Q3jGnc3op
         K4t9LOMZWJtzujRjHBMAKZQIJsbHWTc8A6Q72Fs8jPWoHQ7oAWKwx9h1NBfJL33zjh
         iUjmfIKUn4YaQVRrjx8Rx6zE9+vAQ350BAFEDpifAp4T9tHgxm/kg8cqGq8TJGmVnE
         pLZptUTryRmzA==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use enum clocksource_ids, rather than struct clocksource *, in struct
system_counterval_t. This allows drivers to use
get_device_system_crosststamp() without referring to clocksource structs,
which are clocksource driver implementation details.

As a "treewide" change, this modifies code in timekeeping, ptp/kvm, and
x86/tsc.

So far, get_device_system_crosststamp() requires the caller to provide a
clocksource * as part of the cross-timestamp (through the
system_counterval_t * parameter in the get_time_fn() callback). But
clocksource * are not easily accessible to most code. As a workaround,
custom functions returning the clocksource * may be put into the
clocksource driver code (cf. kvm_arch_ptp_get_crosststamp() in
arm_arch_timer.c).

To avoid more interference with clocksource driver implementation details
from future code, change system_counterval_t to use enum clocksource_ids,
which serves as a unique identifier for relevant clocksources.

This change will allow the virtio_rtc driver, available as an RFC patch
series, to work without modifying the arm_arch_timer implementation.

This change should not alter any behavior. For the x86 ART related code,
.cs == NULL corresponds to system_counterval_t.cs_id == CSID_GENERIC (0).

The one drawback of this change is that clocksources now need a custom id
to work with get_device_system_crosststamp(), since they cannot be
distinguished otherwise.

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---
 arch/x86/kernel/tsc.c        | 6 +++---
 drivers/ptp/ptp_kvm_common.c | 3 ++-
 include/linux/timekeeping.h  | 4 ++--
 kernel/time/timekeeping.c    | 3 ++-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index e56cc4e97d0d..eadfb819a0b5 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1313,7 +1313,7 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
 	res += tmp + art_to_tsc_offset;
 
 	return (struct system_counterval_t) {
-		.cs = have_art ? &clocksource_tsc : NULL,
+		.cs_id = have_art ? CSID_TSC : CSID_GENERIC,
 		.cycles = res
 	};
 }
@@ -1335,7 +1335,7 @@ EXPORT_SYMBOL(convert_art_to_tsc);
  * struct system_counterval_t - system counter value with the pointer to the
  *	corresponding clocksource
  *	@cycles:	System counter value
- *	@cs:		Clocksource corresponding to system counter value. Used
+ *	@cs_id:		Clocksource corresponding to system counter value. Used
  *			by timekeeping code to verify comparability of two cycle
  *			values.
  */
@@ -1353,7 +1353,7 @@ struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns)
 	res += tmp;
 
 	return (struct system_counterval_t) {
-		.cs = have_art ? &clocksource_tsc : NULL,
+		.cs_id = have_art ? CSID_TSC : CSID_GENERIC,
 		.cycles = res
 	};
 }
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index 2418977989be..d72e6ed71b7a 100644
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
@@ -46,7 +47,7 @@ static int ptp_kvm_get_time_fn(ktime_t *device_time,
 	preempt_enable_notrace();
 
 	system_counter->cycles = cycle;
-	system_counter->cs = cs;
+	system_counter->cs_id = cs->id;
 
 	*device_time = timespec64_to_ktime(tspec);
 
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index fe1e467ba046..2e7ae0f7f19e 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -270,12 +270,12 @@ struct system_device_crosststamp {
  * struct system_counterval_t - system counter value with the pointer to the
  *				corresponding clocksource
  * @cycles:	System counter value
- * @cs:		Clocksource corresponding to system counter value. Used by
+ * @cs_id:	Clocksource corresponding to system counter value. Used by
  *		timekeeping code to verify comparibility of two cycle values
  */
 struct system_counterval_t {
 	u64			cycles;
-	struct clocksource	*cs;
+	enum clocksource_ids	cs_id;
 };
 
 /*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 266d02809dbb..56428eadf4c1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1236,7 +1236,8 @@ int get_device_system_crosststamp(int (*get_time_fn)
 		 * system counter value is the same as the currently installed
 		 * timekeeper clocksource
 		 */
-		if (tk->tkr_mono.clock != system_counterval.cs)
+		if (system_counterval.cs_id == CSID_GENERIC ||
+		    tk->tkr_mono.clock->id != system_counterval.cs_id)
 			return -ENODEV;
 		cycles = system_counterval.cycles;
 
-- 
2.39.2

