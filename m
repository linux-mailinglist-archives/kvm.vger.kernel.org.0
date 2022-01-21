Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB024961C0
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381498AbiAUPJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:09:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381497AbiAUPJk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 10:09:40 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LEo51K027072;
        Fri, 21 Jan 2022 15:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zFPUar6zWqSPo+c0cf7vQiGLXEqFZFfpFz7/ABy77UM=;
 b=qaZtLYWIZplZZSnZAwHaVNbCTl9wEXq5Ocm1MC7v4GG9ZwvSkhMXMItUHdOC+r1FSHRX
 DEtr+pqP2WWbJFpjP/gqeiayCL/RvP+u7A5hnF80a4Oqqn7ABAmB7flHWVmxqu9DiLEB
 tYf0W6hJ2WPyaVKPYMIZrDMxJnoEmS7hWPHOYXOVePbkwDbYBv+VQ47d5zAcWEm4lqX2
 4OZqb4+71tcNHh0mIrfoGh4bfzBRfKALg3bVcN1DliqWZLDSh/bRbq8gygpxt1T/fFc4
 ybjKr01x/HV08O/94/ihfllTQcW5pM1fzvbyvsJ0shACoe12ls0ZfWSAIZ/fsoOHZ+dU lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqs6aqyd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:39 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LEpxZb012077;
        Fri, 21 Jan 2022 15:09:39 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqs6aqyc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:39 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LF40Xa023928;
        Fri, 21 Jan 2022 15:09:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3dqjm7dsew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LF9Xgo48038162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:09:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A66AE42049;
        Fri, 21 Jan 2022 15:09:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69D0D4204D;
        Fri, 21 Jan 2022 15:09:33 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 15:09:33 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [PATCH kvm-unit-tests v1 5/8] s390x: Add more tests for SSCH
Date:   Fri, 21 Jan 2022 16:09:28 +0100
Message-Id: <20220121150931.371720-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121150931.371720-1-nrb@linux.ibm.com>
References: <20220121150931.371720-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DYP9KsIwlKtzzFtd73m3P7AguK71YjgB
X-Proofpoint-ORIG-GUID: hhPubhS0L0MOUUNPDe-nO6ajBKocpeW-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have some coverage of SSCH due to its use in
start_ccw1_chain() in css_lib, but two more cases deserve our
attention:

- unaligned operand address. We check for misalignment by 1 and 2 bytes.
- an invalid ORB structure.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 3f9dbac173e3..aa3c22eb91bd 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -462,6 +462,38 @@ static void test_stcrw(void)
 	report_prefix_pop();
 }
 
+static void test_ssch(void)
+{
+	const int align_to = 4;
+	struct orb orb;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	report_prefix_push("Unaligned");
+	for (int i = 1; i < align_to; i *= 2) {
+		report_prefix_pushf("%d", i);
+
+		expect_pgm_int();
+		ssch(test_device_sid, (struct orb *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid ORB");
+
+	memset(&orb, 0xff, sizeof(orb));
+	expect_pgm_int();
+	ssch(test_device_sid, &orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -476,6 +508,7 @@ static struct {
 	{ "measurement block format1", test_schm_fmt1 },
 	{ "msch", test_msch },
 	{ "stcrw", test_stcrw },
+	{ "ssch", test_ssch },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

