Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13711354E12
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244391AbhDFHl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244331AbhDFHlN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:13 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367ZHt4089677
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=z+xqMqKNP2p9v0rJES1t+Iyu6AiUcYSv1H1e2GO0GkI=;
 b=BqCPpIEsKQI7/QXw/C9H82gq0s2ZEHU7vEWNvkL1Law+1MJyD4NxxPTEnbiHvq3PzlCR
 eRbN0u+YQX2r/d8iCDz/p6KmwPdXdnS50/ywMp9tU0TgL3Wkp70SaOB/cpAdwOUzNxQS
 1HEIspZRQZCC9nuw5oCK76JJqgOMmy3V9d3l3MmKHIaqNkZc3EFFXP2/AjDgiEbL1gVy
 ahMBLHoWnOd4XqGl4H9wa+sAwzse6fs4WVbrmpSYAiMdylai02pqnYlQIzKe3q17ubNn
 WgxvG02AE/zvAalZlcgtcxQkFosUU85To6i/RISQnyxFnDEEIMLPGlqYNzjS+2ZZaxw+ mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5dv1qu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:06 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367aHVM093526
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:05 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5dv1qsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:05 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367XJcH026916;
        Tue, 6 Apr 2021 07:41:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37q2q5hwxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367eeV835782974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 795984C05E;
        Tue,  6 Apr 2021 07:41:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C9C54C040;
        Tue,  6 Apr 2021 07:41:00 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:41:00 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 16/16] s390x: css: testing clear subchannel
Date:   Tue,  6 Apr 2021 09:40:53 +0200
Message-Id: <1617694853-6881-17-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ntor66Bfk_hU-4nrnr2k5738V4j0e6FB
X-Proofpoint-ORIG-GUID: KxBllOLbq0CWc9elqMcYBrUB_Lv9LfCA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=880 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking return values for CSCH for various configurations.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 0f80a44..00c77c7 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -362,6 +362,69 @@ static void test_hsch(void)
 	free_io_mem(ccw, sizeof(*ccw));
 }
 
+static void test_csch(void)
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
+	/* CSCH is a privilege operation */
+	report_prefix_push("Privilege");
+	enter_pstate();
+	expect_pgm_int();
+	csch(test_device_sid);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	/* Basic check for CSCH */
+	report_prefix_push("CSCH on a quiet subchannel");
+	assert(css_enable(test_device_sid, 0) == 0);
+	report(csch(test_device_sid) == 0, "subchannel clear");
+	report_prefix_pop();
+
+	/* now we check the flags */
+	report_prefix_push("IRQ flags");
+	assert(tsch(test_device_sid, &irb) == 0);
+	report(check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED) == 0, "expected");
+	report_prefix_pop();
+
+	/* We want to check if the IRQ flags of SSCH are erased by clear */
+	report_prefix_push("CSCH on SSCH status pending subchannel");
+	assert(ssch(test_device_sid, &orb) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED |
+			    SCSW_SC_SECONDARY | SCSW_SC_PRIMARY);
+	report_prefix_pop();
+
+	/* Checking CSCH after HSCH */
+	report_prefix_push("CSCH on a halted subchannel");
+	assert(hsch(test_device_sid) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED);
+	report_prefix_pop();
+
+	/* Checking CSCH after CSCH */
+	report_prefix_push("CSCH on a cleared subchannel");
+	assert(csch(test_device_sid) == 0);
+	report(csch(test_device_sid) == 0, "subchannel cleared");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED);
+	report_prefix_pop();
+
+	free_io_mem(senseid, sizeof(*senseid));
+	free_io_mem(ccw, sizeof(*ccw));
+}
+
 /*
  * test_sense
  * Pre-requisites:
@@ -632,6 +695,7 @@ static struct tests tests[] = {
 	{ "enable (msch)", test_enable },
 	{ "start subchannel", test_ssch },
 	{ "halt subchannel", test_hsch },
+	{ "clear subchannel", test_csch },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
-- 
2.17.1

