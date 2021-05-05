Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F9337367C
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhEEIof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44518 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232098AbhEEIob (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:31 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458X99x013577;
        Wed, 5 May 2021 04:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=3rqZA6nLtA5Bvc9E3ATsoIzOl9MJtriwsypShRZXov0=;
 b=W84EpfsSdAxF1+hUtInM4g04DXCkX3qdf+aMyS/hdZZLorN3MXGfBEdawKMXEoIFX6Yy
 HuMHa3RwmBnq+LTSpzT68RbLyyVuI2j9zCfVv+YD0Xswn1WaTUtDAgPF1JW0QINYfL7y
 3dbt1s/LbJ+HmDkHHZllAqewBsavC25cKdC1GLapK1XTD9kLajg+v0eH+Tz4slZ7r0Ur
 47UG0uArn5CARdXZrU6LB+xKBw677jqR9G46PpAOmqvQ311chMwtVyHpljHTmfRY0Dja
 sRttZmAOYyVWsVOaScCN+SD1374fmWXYrtxBzHvC+wozvdvKYYQ85Ub3VG+q5WZF33SY Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bqnp8q8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:35 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458XNJR014790;
        Wed, 5 May 2021 04:43:34 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bqnp8q85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:34 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458hWb9004470;
        Wed, 5 May 2021 08:43:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 38beea83k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458h3G935782974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72F39A405F;
        Wed,  5 May 2021 08:43:29 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC7DBA405C;
        Wed,  5 May 2021 08:43:28 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 3/9] s390x: css: simplifications of the tests
Date:   Wed,  5 May 2021 10:42:55 +0200
Message-Id: <20210505084301.17395-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
References: <20210505084301.17395-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hXUKUmVwBwsUKDIbDclvEB08V4krAOPC
X-Proofpoint-GUID: PWN94W-ANbHM_eyvDqDsmBpxcEfh7B1V
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_03:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

In order to ease the writing of tests based on:
- interrupt
- enabling a subchannel
- using multiple I/O on a channel without disabling it

We do the following simplifications:
- the I/O interrupt handler is registered on CSS initialization
- We do not enable again a subchannel in senseid if it is already
  enabled
- we add a css_enabled() function to test if a subchannel is enabled

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/kvm/1615545714-13747-3-git-send-email-pmorel@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h     |  1 +
 lib/s390x/css_lib.c | 41 ++++++++++++++++++++++++++---------------
 s390x/css.c         | 15 +++++----------
 3 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 3dc2f313..b9e4c08f 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -278,6 +278,7 @@ int css_enumerate(void);
 
 #define IO_SCH_ISC      3
 int css_enable(int schid, int isc);
+bool css_enabled(int schid);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 3c1acbfb..a97d61e7 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -161,6 +161,31 @@ out:
 	return schid;
 }
 
+/*
+ * css_enabled: report if the subchannel is enabled
+ * @schid: Subchannel Identifier
+ * Return value:
+ *   true if the subchannel is enabled
+ *   false otherwise
+ */
+bool css_enabled(int schid)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int cc;
+
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: updating sch %08x failed with cc=%d",
+			    schid, cc);
+		return false;
+	}
+
+	if (!(pmcw->flags & PMCW_ENABLE)) {
+		report_info("stsch: sch %08x not enabled", schid);
+		return false;
+	}
+	return true;
+}
 /*
  * css_enable: enable the subchannel with the specified ISC
  * @schid: Subchannel Identifier
@@ -210,18 +235,8 @@ retry:
 	/*
 	 * Read the SCHIB again to verify the enablement
 	 */
-	cc = stsch(schid, &schib);
-	if (cc) {
-		report_info("stsch: updating sch %08x failed with cc=%d",
-			    schid, cc);
-		return cc;
-	}
-
-	if ((pmcw->flags & flags) == flags) {
-		report_info("stsch: sch %08x successfully modified after %d retries",
-			    schid, retry_count);
+	if (css_enabled(schid))
 		return 0;
-	}
 
 	if (retry_count++ < MAX_ENABLE_RETRIES) {
 		mdelay(10); /* the hardware was not ready, give it some time */
@@ -250,10 +265,6 @@ void css_irq_io(void)
 		       lowcore_ptr->io_int_param, sid);
 		goto pop;
 	}
-	report_info("subsys_id_word: %08x io_int_param %08x io_int_word %08x",
-			lowcore_ptr->subsys_id_word,
-			lowcore_ptr->io_int_param,
-			lowcore_ptr->io_int_word);
 	report_prefix_pop();
 
 	report_prefix_push("tsch");
diff --git a/s390x/css.c b/s390x/css.c
index 12036b3b..a4778338 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -25,6 +25,7 @@ static unsigned long cu_type = DEFAULT_CU_TYPE;
 
 static int test_device_sid;
 static struct senseid *senseid;
+struct ccw1 *ccw;
 
 static void test_enumerate(void)
 {
@@ -58,7 +59,6 @@ static void test_enable(void)
  */
 static void test_sense(void)
 {
-	struct ccw1 *ccw;
 	int ret;
 	int len;
 
@@ -74,18 +74,12 @@ static void test_sense(void)
 		return;
 	}
 
-	ret = register_io_int_func(css_irq_io);
-	if (ret) {
-		report(0, "Could not register IRQ handler");
-		return;
-	}
-
 	lowcore_ptr->io_int_param = 0;
 
 	senseid = alloc_io_mem(sizeof(*senseid), 0);
 	if (!senseid) {
 		report(0, "Allocation of senseid");
-		goto error_senseid;
+		return;
 	}
 
 	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
@@ -137,12 +131,13 @@ error:
 	free_io_mem(ccw, sizeof(*ccw));
 error_ccw:
 	free_io_mem(senseid, sizeof(*senseid));
-error_senseid:
-	unregister_io_int_func(css_irq_io);
 }
 
 static void css_init(void)
 {
+	assert(register_io_int_func(css_irq_io) == 0);
+	lowcore_ptr->io_int_param = 0;
+
 	report(get_chsc_scsc(), "Store Channel Characteristics");
 }
 
-- 
2.30.2

