Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5CE373682
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhEEIoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232154AbhEEIoe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:34 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458WbYx130417;
        Wed, 5 May 2021 04:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=A8BW3T/fMZNLSQ9f8VJ0FghQ9g7P5FJmCdB4trDPmDU=;
 b=FdwZUF8aE7oxhlsxrn6B4DbY+M1T2I2wgxoUDugic7hMuvknMwq9IzR2umWZMfurujTK
 U2AYoLkWKO+2RN96ypwGJLGmGlMxzG5MW7SZLj+GinCiMkq6KzMk8Q4n4qtn2fCi9XeY
 8VeeqRq5ZyBzGtG9qe3Vuz8LQEurbo8/dkbqLNv7m+DD9z019bNiDQPMKLSW6nGsFEsg
 4zJr7ihTeKNp59MFMYhva9qz0rDkuE8dTRzU4n6mEJ5SRM70qqFrGXgZso4y+wprR7+a
 kI75YSho1Wc71to9RQvUXs1iz3mLyUrcNIYfRlk2PmoSKQwvoRx1ZAorpXJTvDPE84+N qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bpn92fej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:37 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458XQoG132588;
        Wed, 5 May 2021 04:43:37 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bpn92fdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458h3G5022508;
        Wed, 5 May 2021 08:43:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 38beeeg6d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458hWkf57737478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F81FA405C;
        Wed,  5 May 2021 08:43:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A062A405B;
        Wed,  5 May 2021 08:43:31 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 7/9] s390x: css: testing measurement block format 1
Date:   Wed,  5 May 2021 10:42:59 +0200
Message-Id: <20210505084301.17395-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
References: <20210505084301.17395-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YLh1lWPjFuLIa91HfKchEmvvg8mui-gd
X-Proofpoint-GUID: XBIJ534RcIkyHjmHlGkfDE-8uVCA5qII
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_03:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

Measurement block format 1 is made available by the extended
measurement block facility and is indicated in the SCHIB by
the bit in the PMCW.

The MBO is specified in the SCHIB of each channel and the MBO
defined by the SCHM instruction is ignored.

The test of the MB format 1 is just skipped if the feature is
not available.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/kvm/1615545714-13747-7-git-send-email-pmorel@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h     | 15 +++++++++
 lib/s390x/css_lib.c |  2 +-
 s390x/css.c         | 75 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 335bc705..7e3d2613 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -107,6 +107,7 @@ struct schib {
 	uint64_t mbo;
 	uint8_t  md[4];
 } __attribute__ ((aligned(4)));
+extern struct schib schib;
 
 struct irb {
 	struct scsw scsw;
@@ -386,4 +387,18 @@ struct measurement_block_format0 {
 	uint32_t initial_cmd_resp_time;
 };
 
+struct measurement_block_format1 {
+	uint32_t ssch_rsch_count;
+	uint32_t sample_count;
+	uint32_t device_connect_time;
+	uint32_t function_pending_time;
+	uint32_t device_disconnect_time;
+	uint32_t cu_queuing_time;
+	uint32_t device_active_only_time;
+	uint32_t device_busy_time;
+	uint32_t initial_cmd_resp_time;
+	uint32_t irq_delay_time;
+	uint32_t irq_prio_delay_time;
+};
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 8f093839..efc70576 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -19,7 +19,7 @@
 #include <malloc_io.h>
 #include <css.h>
 
-static struct schib schib;
+struct schib schib;
 struct chsc_scsc *chsc_scsc;
 
 static const char * const chsc_rsp_description[] = {
diff --git a/s390x/css.c b/s390x/css.c
index 658c5f87..c340c539 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -257,6 +257,80 @@ static void test_schm_fmt0(void)
 	free_io_mem(mb0, shared_mb_size);
 }
 
+static void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int cc;
+
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report(0, "stsch: sch %08x failed with cc=%d", schid, cc);
+		return;
+	}
+
+	/* Update the SCHIB to enable the measurement block */
+	pmcw->flags |= PMCW_MBUE;
+	pmcw->flags2 |= PMCW_MBF1;
+	schib.mbo = mb;
+
+	/* Tell the CSS we want to modify the subchannel */
+	expect_pgm_int();
+	cc = msch(schid, &schib);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+}
+
+/*
+ * test_schm_fmt1:
+ * With measurement block format 1 the measurement block is
+ * dedicated to a subchannel.
+ */
+static void test_schm_fmt1(void)
+{
+	struct measurement_block_format1 *mb1;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	if (!css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
+		report_skip("Extended measurement block not available");
+		return;
+	}
+
+	/* Allocate zeroed Measurement block */
+	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
+	if (!mb1) {
+		report_abort("measurement_block_format1 allocation failed");
+		return;
+	}
+
+	schm(NULL, 0); /* Stop any previous measurement */
+	schm(0, SCHM_MBU);
+
+	/* Expect error for non aligned MB */
+	report_prefix_push("Unaligned MB origin");
+	msch_with_wrong_fmt1_mbo(test_device_sid, (uint64_t)mb1 + 1);
+	report_prefix_pop();
+
+	/* Clear the measurement block for the next test */
+	memset(mb1, 0, sizeof(*mb1));
+
+	/* Expect success */
+	report_prefix_push("Valid MB origin");
+	if (start_measuring((u64)mb1, 0, true))
+		report(mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
+		       "SSCH measured %d", mb1->ssch_rsch_count);
+	report_prefix_pop();
+
+	/* Stop the measurement */
+	css_disable_mb(test_device_sid);
+	schm(NULL, 0);
+
+	free_io_mem(mb1, sizeof(struct measurement_block_format1));
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -268,6 +342,7 @@ static struct {
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
+	{ "measurement block format1", test_schm_fmt1 },
 	{ NULL, NULL }
 };
 
-- 
2.30.2

