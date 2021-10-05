Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF724221C6
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhJEJL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:11:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232992AbhJEJL1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 05:11:27 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1958Vn4W018560
        for <kvm@vger.kernel.org>; Tue, 5 Oct 2021 05:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w4z3crXM3mfMM+NDcXz/g8Zj9BIJOSBioswdiuj3B2s=;
 b=R8yryRKFocq35+ySuyFyqc7kT1hGKwX7kAwmyV6wbPsZAbwfDYqExuWXp7wEu4PDMqTO
 WdfEag8lB6/yr/PsgIFp0+RF1ggRzw6RoPAHPbOpM/7uFim7bsxD0kpsRsgT4jDnERBh
 uF0fBkfWyKPjGHvrX7mMkbiOrSLvDGD8rm01STXkV58xwNcL0m8uGSrgWLJviAljWLTw
 ZifvE//zfzEKvp625GkC5ZmB8P7VGlTl2U0Xaq7drn5e5rDhSYOHg93gYiGxn10ob9Rr
 BR6B6RFQen1ZXlUY5p+wwMi8i6kAlp+IvYVF8FLeFDmvq3gmxWb5TGumfCfGX7BvENeR zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgk9cgx7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 05:09:36 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19592T7T008353
        for <kvm@vger.kernel.org>; Tue, 5 Oct 2021 05:09:36 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgk9cgx6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:09:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19596abP015818;
        Tue, 5 Oct 2021 09:09:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3bef2ar83x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:09:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19599UhD53543392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 09:09:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B839B11C05C;
        Tue,  5 Oct 2021 09:09:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 875FB11C04C;
        Tue,  5 Oct 2021 09:09:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 09:09:30 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/5] lib: Introduce report_pass and report_fail
Date:   Tue,  5 Oct 2021 11:09:19 +0200
Message-Id: <20211005090921.1816373-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005090921.1816373-1-scgl@linux.ibm.com>
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jML5YsD-GLSKTSO_ZiR-adTgQ57x6KMY
X-Proofpoint-GUID: wgUY239IopVFQGVRbJ68yVn3Uv06CM-4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_05,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These functions can be used instead of report(1/true/0/false, ...)
and read a bit nicer.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
There is probably a better name than report_passed() for the function
without a message...

 lib/libcflat.h |  6 +++++-
 lib/report.c   | 20 +++++++++++++++++++-
 x86/vmx.h      |  6 +++---
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 39f4552..9bb7e08 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -106,7 +106,11 @@ extern void report_skip(const char *msg_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern void report_info(const char *msg_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
-extern void report_pass(void);
+extern void report_pass(const char *msg_fmt, ...)
+					__attribute__((format(printf, 1, 2)));
+extern void report_fail(const char *msg_fmt, ...)
+					__attribute__((format(printf, 1, 2)));
+extern void report_passed(void);
 extern int report_summary(void);
 
 bool simple_glob(const char *text, const char *pattern);
diff --git a/lib/report.c b/lib/report.c
index 2255dc3..8e9bff5 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -19,7 +19,7 @@ static struct spinlock lock;
 
 #define PREFIX_DELIMITER ": "
 
-void report_pass(void)
+void report_passed(void)
 {
 	spin_lock(&lock);
 	tests++;
@@ -112,6 +112,24 @@ void report(bool pass, const char *msg_fmt, ...)
 	va_end(va);
 }
 
+void report_pass(const char *msg_fmt, ...)
+{
+	va_list va;
+
+	va_start(va, msg_fmt);
+	va_report(msg_fmt, true, false, false, va);
+	va_end(va);
+}
+
+void report_fail(const char *msg_fmt, ...)
+{
+	va_list va;
+
+	va_start(va, msg_fmt);
+	va_report(msg_fmt, false, false, false, va);
+	va_end(va);
+}
+
 void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
 {
 	va_list va;
diff --git a/x86/vmx.h b/x86/vmx.h
index ebd014c..fd0174a 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -928,7 +928,7 @@ do { \
 		dump_stack(); \
 		__abort_test(); \
 	} \
-	report_pass(); \
+	report_passed(); \
 } while (0)
 
 #define TEST_ASSERT_MSG(cond, fmt, args...) \
@@ -939,7 +939,7 @@ do { \
 		dump_stack(); \
 		__abort_test(); \
 	} \
-	report_pass(); \
+	report_passed(); \
 } while (0)
 
 #define __TEST_EQ(a, b, a_str, b_str, assertion, fmt, args...) \
@@ -964,7 +964,7 @@ do { \
 		if (assertion) \
 			__abort_test(); \
 	} \
-	report_pass(); \
+	report_passed(); \
 } while (0)
 
 #define TEST_ASSERT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 1, "")
-- 
2.31.1

