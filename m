Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81A13325D1
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 13:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhCIMvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 07:51:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5530 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231295AbhCIMv0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 07:51:26 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129ClQ9U054700
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=9dpCZ2DOfqcgwAsXZCugzhBVS4lIfqVZ4K9b+V4g4l4=;
 b=Ph9AHJrjrEyEsmW9qXtQTg8Povvh9vj+KGbPj709d2lFallNrqog5FaV1nSYDvhxdKmT
 ulgI8AatXMQC8vGjQEKtVc4BefZ7II5ifY+yHAepl3EY2KpS3pF/6FGXKGubeFb8yBQJ
 H9fbzv0QxMkN4JRQk0ocPX54NsFj3/a2MqNjADT1AJqwBVillkD+4U7471aTX4CfxuoP
 MU4xmUc+od92vu4apPuUtwm/V5GiyDbLgacPJZukaaAj0SJ3O2ZHLBdeApjKVvx4riL7
 qznlBtp4QUTp2OBxhFn82SlvtXVopDLndWs8vyLlQULbIXjhv1C9YG0jXYnHasmCRx8U 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3769b6g1th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 07:51:25 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 129CmGMK062075
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:25 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3769b6g1sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 07:51:24 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129CTZAJ008604;
        Tue, 9 Mar 2021 12:51:22 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3768urr0yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 12:51:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129CpKui35914162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 12:51:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2B0552065;
        Tue,  9 Mar 2021 12:51:19 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.215])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8E66D5205F;
        Tue,  9 Mar 2021 12:51:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 3/6] s390x: css: extending the subchannel modifying functions
Date:   Tue,  9 Mar 2021 13:51:14 +0100
Message-Id: <1615294277-7332-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_11:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015 phishscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103090062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To enable or disable measurement we will need specific
modifications on the subchannel.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/css.h     |   9 +++-
 lib/s390x/css_lib.c | 100 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 71d91f0..3c50fa8 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -82,6 +82,8 @@ struct pmcw {
 	uint32_t intparm;
 #define PMCW_DNV	0x0001
 #define PMCW_ENABLE	0x0080
+#define PMCW_MBUE	0x0010
+#define PMCW_DCTME	0x0008
 #define PMCW_ISC_MASK	0x3800
 #define PMCW_ISC_SHIFT	11
 	uint16_t flags;
@@ -94,6 +96,7 @@ struct pmcw {
 	uint8_t  pom;
 	uint8_t  pam;
 	uint8_t  chpid[8];
+#define PMCW_MBF1	0x0004
 	uint32_t flags2;
 };
 #define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
@@ -101,7 +104,8 @@ struct pmcw {
 struct schib {
 	struct pmcw pmcw;
 	struct scsw scsw;
-	uint8_t  md[12];
+	uint64_t mbo;
+	uint8_t  md[4];
 } __attribute__ ((aligned(4)));
 
 struct irb {
@@ -355,4 +359,7 @@ bool chsc(void *p, uint16_t code, uint16_t len);
 #define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
 #define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
 
+bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
+bool css_disable_mb(int schid);
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 41134dc..77b39c7 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -248,6 +248,106 @@ retry:
 	return -1;
 }
 
+/*
+ * schib_update_mb: update the subchannel Measurement Block
+ * @schid: Subchannel Identifier
+ * @mb   : 64bit address of the measurement block
+ * @mbi : the measurement block offset
+ * @flags : PMCW_MBUE to enable measurement block update
+ *	    PMCW_DCTME to enable device connect time
+ *	    0 to disable measurement
+ * @format1: set if format 1 is to be used
+ */
+static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
+			    uint16_t flags, bool format1)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int cc;
+
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
+		return false;
+	}
+
+	/* Update the SCHIB to enable the measurement block */
+	if (flags) {
+		pmcw->flags |= flags;
+
+		if (format1)
+			pmcw->flags2 |= PMCW_MBF1;
+		else
+			pmcw->flags2 &= ~PMCW_MBF1;
+
+		pmcw->mbi = mbi;
+		schib.mbo = mb & ~0x3f;
+	} else {
+		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
+	}
+
+	/* Tell the CSS we want to modify the subchannel */
+	cc = msch(schid, &schib);
+	if (cc) {
+		/*
+		 * If the subchannel is status pending or
+		 * if a function is in progress,
+		 * we consider both cases as errors.
+		 */
+		report_info("msch: sch %08x failed with cc=%d", schid, cc);
+		return false;
+	}
+
+	/*
+	 * Read the SCHIB again
+	 */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: updating sch %08x failed with cc=%d",
+			    schid, cc);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * css_enable_mb: enable the subchannel Measurement Block
+ * @schid: Subchannel Identifier
+ * @mb   : 64bit address of the measurement block
+ * @format1: set if format 1 is to be used
+ * @mbi : the measurement block offset
+ * @flags : PMCW_MBUE to enable measurement block update
+ *	    PMCW_DCTME to enable device connect time
+ */
+bool css_enable_mb(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
+		   bool format1)
+{
+	int retry_count = MAX_ENABLE_RETRIES;
+	struct pmcw *pmcw = &schib.pmcw;
+
+	while (retry_count-- &&
+	       !schib_update_mb(schid, mb, mbi, flags, format1))
+		mdelay(10); /* the hardware was not ready, give it some time */
+
+	return schib.mbo == mb && pmcw->mbi == mbi;
+}
+
+/*
+ * css_disable_mb: disable the subchannel Measurement Block
+ * @schid: Subchannel Identifier
+ */
+bool css_disable_mb(int schid)
+{
+	int retry_count = MAX_ENABLE_RETRIES;
+
+	while (retry_count-- &&
+	       !schib_update_mb(schid, 0, 0, 0, 0))
+		mdelay(10); /* the hardware was not ready, give it some time */
+
+	return retry_count > 0;
+}
+
 static struct irb irb;
 
 void css_irq_io(void)
-- 
2.17.1

