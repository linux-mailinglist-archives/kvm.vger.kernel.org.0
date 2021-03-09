Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7279B3325D3
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 13:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhCIMvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 07:51:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231152AbhCIMv1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 07:51:27 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129CYLHY053639
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=J+hDfOZ5r6Ke/FWBmtDKwunEwXSZRn7kBz6Gx02ospg=;
 b=QvsWwColblA35fobEf78UPmIQBBSGN0NPttIdUHzdj6e0bIMzWhILfFXt+dN8zcVIPqy
 GlXg4YuA1PgcKFoA6sOycMQwMfiZd+osjL8gdhdpD3odEk4tkWdpO8xWpMgYoWchU4zU
 Fh01foiL2yoKkskmDi3zjBaioKx/6SbFtTvrVvdxS0MqVDMZ9t2Bt/Or3aodTWMAVc7r
 fVQ+7NNR6R5ypxohFYP2NkORAAtjBHLOqR5KOQERBV4fei+4Ft4U7H8IJHQ0xXaQVcbv
 KNatLIXr+zjkW3lzLgG4roEWRzc76oHEghkCNB1XWxbu8rsN2RzFBiaeWWqqmOrJsuj3 eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37607sphju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 07:51:26 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 129CpQmt147724
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:26 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37607sphgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 07:51:26 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129CRq8c011456;
        Tue, 9 Mar 2021 12:51:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3768n1g1u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 12:51:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129CpKAS24773018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 12:51:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB51652051;
        Tue,  9 Mar 2021 12:51:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.215])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8715E5205F;
        Tue,  9 Mar 2021 12:51:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 6/6] s390x: css: testing measurement block format 1
Date:   Tue,  9 Mar 2021 13:51:17 +0100
Message-Id: <1615294277-7332-7-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_11:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103090062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Measurement block format 1 is made available by the extended
measurement block facility and is indicated in the SCHIB by
the bit in the PMCW.

The MBO is specified in the SCHIB of each channel and the MBO
defined by the SCHM instruction is ignored.

The test of the MB format 1 is just skipped if the feature is
not available.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     | 15 +++++++++
 lib/s390x/css_lib.c |  2 +-
 s390x/css.c         | 75 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 335bc70..7e3d261 100644
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
index 8f09383..efc7057 100644
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
index b63826e..a5c647e 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -259,6 +259,80 @@ static void test_schm_fmt0(void)
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
@@ -270,6 +344,7 @@ static struct {
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
+	{ "measurement block format1", test_schm_fmt1 },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

