Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088184788FC
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 11:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhLQKc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 05:32:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18180 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235039AbhLQKc0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 05:32:26 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHADfwB011439;
        Fri, 17 Dec 2021 10:32:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9VYbqb1ty64wbCHDVKV/6zeCWIle/Pyriv9HWo1Fslg=;
 b=p9pcETTQg0cXErS26tGnscp7tETfz2QQBg9XblSZ18MDfgvSvWsfPM1kVgkluuSAfLYF
 FOSWFZvBZVC+T0mTBzXrp2Z9yyjFrIA4QoLRBMymMDjAPHQtWK5pS0R3BgbUYs9QmRhz
 Vb7JMHTv4M6kl2jafKbFVHyoAZFbJmYHL3NpQLg3Oyzp3Cf4k1dYtzAhKXMUqkKxwrNB
 vn2uI6sTn/qz0W61bZQEjVUenGOy/jZaQ2LHAN9np3MTmv84La933FTqST4wxghr6rwc
 0x+dsLnSl5p7JfQd0jgVf+YLDgQiRab2hzRZBbvGzCEqTcYX0pHIja0TS0VrLU/yGRlZ Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cypc7jpq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:32:25 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHAG01K025795;
        Fri, 17 Dec 2021 10:32:25 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cypc7jpg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:32:25 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHADV1O023944;
        Fri, 17 Dec 2021 10:31:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3cy7jrg7n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:31:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHAVtRk43647346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 10:31:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3966AA4079;
        Fri, 17 Dec 2021 10:31:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E54EEA4071;
        Fri, 17 Dec 2021 10:31:54 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 10:31:54 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [PATCH kvm-unit-tests 1/2] s390x: diag288: Add missing clobber
Date:   Fri, 17 Dec 2021 11:31:36 +0100
Message-Id: <20211217103137.1293092-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217103137.1293092-1-nrb@linux.ibm.com>
References: <20211217103137.1293092-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ifjbQTaDOfe5a0rPL7ojY1044dolNDi9
X-Proofpoint-GUID: F6MHugg61HKxpqevgZHl_hOz6GaucFDI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_04,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We clobber r0 and thus should let the compiler know we're doing so.

Because we change from basic to extended ASM, we need to change the
register names, as %r0 will be interpreted as a token in the assembler
template.

For consistency, we align with the common style in kvm-unit-tests which
is just 0.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/diag288.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/s390x/diag288.c b/s390x/diag288.c
index 072c04a5cbd6..da7b06c365bf 100644
--- a/s390x/diag288.c
+++ b/s390x/diag288.c
@@ -94,11 +94,12 @@ static void test_bite(void)
 	/* Arm watchdog */
 	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
 	diag288(CODE_INIT, 15, ACTION_RESTART);
-	asm volatile("		larl	%r0, 1f\n"
-		     "		stg	%r0, 424\n"
+	asm volatile("		larl	0, 1f\n"
+		     "		stg	0, 424\n"
 		     "0:	nop\n"
 		     "		j	0b\n"
-		     "1:");
+		     "1:"
+		     : : : "0");
 	report_pass("restart");
 }
 
-- 
2.31.1

