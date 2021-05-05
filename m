Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BFC37367E
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhEEIog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232119AbhEEIoc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458XbLA086018;
        Wed, 5 May 2021 04:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=+zU5VrJHjAEDmtRdBmvi1J5X8mLrDdIsview2IX2X8w=;
 b=J486bXi6Pf4rAK3JKVlflA8S0fdA87nf7OJ1AZNOSRImm6TdnM23wSnBEsZtHXlwlRUk
 wo6Ip39nebmf8j2h7Y7Q3a5EfKflUUNjvpOpCEV8xUc+It0qk7e2G5VwMKcF8vsyrXDU
 RAuR3JKYgFMuYyybQRaTjSvq1X6V/Y0A+c4Z0U2pPW6UVWqGYeB1H9HFheuBoUPzmYQL
 Wu7cw9oF7NYfe2Euo6Vm56Yx/n2RLJfXHRIdnU0oxx3c/TDV4Vp5Sosucq7olT+uwZh/
 sFrR4/H48PCZdnF/+mEYgxh9iTYPVhREdEIzhWcKku4niNPlcxUCWnZMW6ifRtCuaA0v Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bn4dmm1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:35 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458baeQ105325;
        Wed, 5 May 2021 04:43:35 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bn4dmm0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:35 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458hXiK004474;
        Wed, 5 May 2021 08:43:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 38beea83k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:33 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458hUxI21889402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 236D0A4060;
        Wed,  5 May 2021 08:43:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B0EDA405C;
        Wed,  5 May 2021 08:43:29 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 4/9] s390x: css: extending the subchannel modifying functions
Date:   Wed,  5 May 2021 10:42:56 +0200
Message-Id: <20210505084301.17395-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
References: <20210505084301.17395-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4xTwpxvgpr3zE94rxb1dgL8KCMUwkVtP
X-Proofpoint-ORIG-GUID: G12lA9mFu9ueuzwi4Vflsmd95NcuKuVC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_03:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

To enable or disable measurement we will need specific
modifications on the subchannel.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/kvm/1615545714-13747-4-git-send-email-pmorel@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h     |   9 +++-
 lib/s390x/css_lib.c | 100 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index b9e4c08f..7dddb422 100644
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
 #define css_test_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
 #define css_test_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
 
+bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
+bool css_disable_mb(int schid);
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index a97d61e7..8f093839 100644
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
2.30.2

