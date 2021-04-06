Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAAE354E0D
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244352AbhDFHlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236561AbhDFHlL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:11 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367YBFc028858
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=WjrrTIv/QfOA+yz4xZEeaOP+msvP1mk2ykPbr1OgJ+Q=;
 b=Yraa1HeiPGFWIDB6ssGIySUIHtpNaInd9H7valctraEs71pEuME2fTuBjmvdlRVe3hGF
 AQ5yqobu39nx3CnynCdedra/Vlpfny2l+BaTZxG4iCHYJxbW/943u8JoKzhouj1LxUXH
 WffwUpABd6hD+55TcChb71IoCTpSqtYd7QgB0Vzn0jVsAZk2LGZw+YjZnKg17MUOg/S8
 dCrAEFDeINgvUOV03Txf9ktqjysMRyooCEGwYfODi6VnSilX98cAGKY0xTbwNiWWyxSg
 gHkY1PB5pR9vxpCc2+u9uA80U/qepHIl6SktL5U29BNeeUrG3Y3EQ37ceFt1tUqsYDB2 WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5tyk6kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:03 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367ZgRM032986
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:03 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5tyk6jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:03 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367YOm6025878;
        Tue, 6 Apr 2021 07:41:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 37q3a8h0g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367evsu12779860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE1254C052;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C1064C05C;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 08/16] s390x: css: ssch check for cpa zero
Date:   Tue,  6 Apr 2021 09:40:45 +0200
Message-Id: <1617694853-6881-9-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tP_v1estgEqnjz2eRilQZQOy1Ee6Jy0d
X-Proofpoint-GUID: bF76xEMnnQWVNHCv5Uu4NzItK4QtFCkM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We expect a CSS program check if the CPA of the ORB is null
and access to the IRB to check it.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  1 +
 lib/s390x/css_lib.c |  4 ++--
 s390x/css.c         | 13 +++++++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index a5a8427..d824e34 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -139,6 +139,7 @@ struct irb {
 	uint32_t ecw[8];
 	uint32_t emw[8];
 } __attribute__ ((aligned(4)));
+extern struct irb irb;
 
 #define CCW_CMD_SENSE_ID	0xe4
 #define CSS_SENSEID_COMMON_LEN	8
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 65159aa..12ef874 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -21,6 +21,8 @@
 
 struct schib schib;
 struct chsc_scsc *chsc_scsc;
+struct irb irb;
+
 
 static const char * const chsc_rsp_description[] = {
 	"CHSC unknown error",
@@ -411,8 +413,6 @@ bool css_disable_mb(int schid)
 	return retry_count > 0;
 }
 
-static struct irb irb;
-
 void css_irq_io(void)
 {
 	int ret = 0;
diff --git a/s390x/css.c b/s390x/css.c
index da21ccc..d248cac 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -91,8 +91,21 @@ static void ssch_privilege(void)
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 }
 
+static void ssch_orb_cpa_zero(void)
+{
+	uint32_t cpa = orb->cpa;
+
+	orb->cpa = 0;
+	ssch(test_device_sid, orb);
+	tsch(test_device_sid, &irb);
+	report(check_io_errors(test_device_sid, 0, SCSW_SCHS_PRG_CHK), "expecting Program check");
+
+	orb->cpa = cpa;
+}
+
 static struct tests ssh_tests[] = {
 	{ "privilege", ssch_privilege },
+	{ "orb cpa zero", ssch_orb_cpa_zero },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

