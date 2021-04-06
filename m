Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F6B354E13
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbhDFHld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244330AbhDFHlN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:13 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367WwPO147137
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=8MMexk60fhIRx1sOtOe/Tx1z3iCi8tOje3LG7LbYMzw=;
 b=jDMr4RuchdFAFhfApc8lhSsOWa2ge6a9XHGIRr6Tt8UDyMgdoJFQ3OtRDnD54V4NL+mO
 STxdiakl6H5phPw+7AnDsaEgl+FYW5wC6liT2QBFi4YZzCLsY1Hu0i3fB8aJJEZXuMaN
 weEZ+9qUMdRigl+VckHEKFe54BF0MhmdVnS7KLsedaWDrrJbplBwEruT9hwhFdfZubfL
 z9oTmPfpuQYohGveQObcedWdOYigSGNMoccqqlFAqg7hJ6GdVBaVEULz2mf30NMjlJ7y
 ASqhtfb7MBMYzq4vnLWdPv9ltvVuNMhKoBTzGPReQxa/aGIwYLv5YiZw54ckN8HJP1FD aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5easpwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:06 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367X4B8000802
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:05 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5easpvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:05 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367WWbF003701;
        Tue, 6 Apr 2021 07:41:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 37q2nm90r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367edHb33292604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14A5A4C04E;
        Tue,  6 Apr 2021 07:41:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D09C84C062;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 15/16] s390x: css: testing halt subchannel
Date:   Tue,  6 Apr 2021 09:40:52 +0200
Message-Id: <1617694853-6881-16-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bLHCOjedswXrOM6srkf5NEalkBqMzYQr
X-Proofpoint-ORIG-GUID: vriQTZ3EVXwl3XojbS-8v7CRd-sKaDEA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=855 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

checking return values for HSCH for various configurations.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  4 +++
 lib/s390x/css_lib.c |  4 +++
 s390x/css.c         | 63 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 3eb6957..90c8e4b 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -92,6 +92,10 @@ struct scsw {
 #define SCSW_KEY		0xf0000000
 #define SCSW_SSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_START | SCSW_SC_PENDING | SCSW_SC_SECONDARY | \
 				 SCSW_SC_PRIMARY)
+#define SCSW_HSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_HALT | \
+				 SCSW_SC_PENDING)
+#define SCSW_CSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_CLEAR | \
+				 SCSW_SC_PENDING)
 	uint32_t ctrl;
 	uint32_t ccw_addr;
 #define SCSW_DEVS_DEV_END	0x04
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 12ef874..4c4506a 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -528,6 +528,10 @@ int check_io_completion(int schid, uint32_t ctrl)
 		goto end;
 	}
 
+	/* We do not need more check for HSCH or CSCH */
+	if (irb.scsw.ctrl & (SCSW_FC_HALT | SCSW_FC_CLEAR))
+		goto end;
+
 	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
 		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
 		       irb.scsw.ctrl);
diff --git a/s390x/css.c b/s390x/css.c
index 52264f2..0f80a44 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -300,6 +300,68 @@ static void test_ssch(void)
 	css_enable(test_device_sid, 0);
 }
 
+static void test_hsch(void)
+{
+	struct orb orb = {
+		.intparm = test_device_sid,
+		.ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT,
+	};
+	struct ccw1 *ccw;
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+	orb.cpa = (uint64_t)ccw;
+
+	/* HSCH is a privilege operation */
+	report_prefix_push("Privilege");
+	enter_pstate();
+	expect_pgm_int();
+	hsch(test_device_sid);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	/* Basic HSCH */
+	report_prefix_push("HSCH on a quiet subchannel");
+	assert(css_enable(test_device_sid, 0) == 0);
+	report(hsch(test_device_sid) == 0, "subchannel halted");
+	report_prefix_pop();
+
+	/* now we check the flags */
+	report_prefix_push("Ctrl flags");
+	assert(tsch(test_device_sid, &irb) == 0);
+	report(check_io_completion(test_device_sid, SCSW_HSCH_COMPLETED) == 0, "expected");
+	report_prefix_pop();
+
+	/* Check HSCH after SSCH */
+	report_prefix_push("HSCH on status pending subchannel");
+	assert(ssch(test_device_sid, &orb) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_SSCH_COMPLETED);
+	report_prefix_pop();
+
+	/* Check HSCH after CSCH */
+	report_prefix_push("HSCH on busy on CSCH subchannel");
+	assert(csch(test_device_sid) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED);
+	report_prefix_pop();
+
+	/* Check HSCH after HSCH */
+	report_prefix_push("HSCH on busy on HSCH subchannel");
+	assert(hsch(test_device_sid) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_HSCH_COMPLETED);
+	report_prefix_pop();
+
+	free_io_mem(senseid, sizeof(*senseid));
+	free_io_mem(ccw, sizeof(*ccw));
+}
+
 /*
  * test_sense
  * Pre-requisites:
@@ -569,6 +631,7 @@ static struct tests tests[] = {
 	/* The css_init test is needed to initialize the CSS Characteristics */
 	{ "enable (msch)", test_enable },
 	{ "start subchannel", test_ssch },
+	{ "halt subchannel", test_hsch },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
-- 
2.17.1

