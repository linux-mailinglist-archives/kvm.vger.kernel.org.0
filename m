Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349E63F9801
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244918AbhH0KSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:18:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244893AbhH0KSR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:18:17 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RA6djf032459
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=QjT0sLJxQnBtiDNqea96LIa2fDtzrhQITGc+Zcfev7o=;
 b=UVB6ldm3VQ+feEHSCN/c0FN9CRuOJr/WysHo3K+UZ9OmwjZGEZeko0pxAyphHfmKkuDV
 J8mYoRfU35F3yz+zwzrDrEf+POJ7tPeN6X1Bcz7KIQabef9DHLqGerL/Jkxo387TpHrm
 NNxq/wrYlzTPUr8lO9DwPszblHXx2bXdFTIV9gh+krFrwyB1dF6J8586i/l2B01aaEeF
 0XTVCW63mdYfu4V2+ZobDZfSjXWtFvCSSH5Ym8eTQ6JccQ/oTiNMNLZvynrxV8dIrU17
 1jTgHcTm8pbHfvLDRWG6IULTy3sm99SLeaKhKwOP+70mnhA22HVl2t2fAOQtJnDILEhA 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3apv53jv92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RA6x8P034161
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3apv53jv8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:17:27 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAD7sL017066;
        Fri, 27 Aug 2021 10:17:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3ajs48seyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:17:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAHMhM50069788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:17:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05A754C058;
        Fri, 27 Aug 2021 10:17:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFA014C040;
        Fri, 27 Aug 2021 10:17:21 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:17:21 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH 2/7] s390x: css: add callback for emnumeration
Date:   Fri, 27 Aug 2021 12:17:15 +0200
Message-Id: <1630059440-15586-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q2A2oZQ1kGEHKJ63DQidOrT1EGBsalgG
X-Proofpoint-ORIG-GUID: ld7r78Cu5WojcclrqgZf_WWDg_RIzDIw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will need to look for a device inside the channel subsystem
based upon device specificities.

Let's provide a callback for an upper layer to be called during
the enumeration of the channel subsystem.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     | 3 ++-
 lib/s390x/css_lib.c | 4 +++-
 s390x/css.c         | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index d644971f..2005f4d7 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -278,7 +278,8 @@ void dump_irb(struct irb *irbp);
 void dump_pmcw(struct pmcw *p);
 void dump_orb(struct orb *op);
 
-int css_enumerate(void);
+typedef int (enumerate_cb_t)(int);
+int css_enumerate(enumerate_cb_t *f);
 #define MAX_ENABLE_RETRIES      5
 
 #define IO_SCH_ISC      3
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index efc70576..484f9c41 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -117,7 +117,7 @@ bool get_chsc_scsc(void)
  * On success return the first subchannel ID found.
  * On error return an invalid subchannel ID containing cc
  */
-int css_enumerate(void)
+int css_enumerate(enumerate_cb_t *f)
 {
 	struct pmcw *pmcw = &schib.pmcw;
 	int scn_found = 0;
@@ -153,6 +153,8 @@ int css_enumerate(void)
 			schid = scn | SCHID_ONE;
 		report_info("Found subchannel %08x", scn | SCHID_ONE);
 		dev_found++;
+		if (f)
+			f(scn | SCHID_ONE);
 	}
 
 out:
diff --git a/s390x/css.c b/s390x/css.c
index c340c539..b50fbc67 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -29,7 +29,7 @@ struct ccw1 *ccw;
 
 static void test_enumerate(void)
 {
-	test_device_sid = css_enumerate();
+	test_device_sid = css_enumerate(NULL);
 	if (test_device_sid & SCHID_ONE) {
 		report(1, "Schid of first I/O device: 0x%08x", test_device_sid);
 		return;
-- 
2.25.1

