Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FF152492C
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352182AbiELJhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352105AbiELJfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA9965A6
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:45 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9Q1Sq003575
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pP+eXHGM9BFfaHppJw1IhEgoz2TFEK1SsArXXExDYvE=;
 b=mhn1mFal2j1Qm+E1OtlJiK7C+IigN2SO21Zecn1QBvOK5UmTreldCBisjygU3ypGLG9b
 6hRbKcCWDt7Pw82DEcMwDZSLEIZYjTICH4x85VQ1Xw4gjmEEMU1rJRtD9uVErJxNSMYP
 5GIhS/IIi93eM3WouJGxQQVDy6lCC++xi/UQS1moq95SfYAykBMGmBIF4/jL7QbTfXLZ
 MKyzfJrdW7/90gyKHZ5HnIHO83/feZM+M1fyf/8vGNrSTZbDqr5WP2No9LS+OWVvVcLk
 71/PlQVkUkFq6h1s347hRcLfWo6PdEMyARB/R2EFNDtMfY9MvuwKEUEQOorjXV0laBCk rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yksg4wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:44 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9RuvL011345
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:43 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yksg4w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9WqRv020421;
        Thu, 12 May 2022 09:35:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8xs9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZcTO57409964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5731311C04A;
        Thu, 12 May 2022 09:35:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F75F11C04C;
        Thu, 12 May 2022 09:35:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:37 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 25/28] s390x: uv-guest: remove duplicated checks
Date:   Thu, 12 May 2022 11:35:20 +0200
Message-Id: <20220512093523.36132-26-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yBX_vx9DS5m1xh_q-gBr4lirHhqhke9f
X-Proofpoint-GUID: Y-7od5ThuQcguZSYF3_lsOXSsVbLjVe8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

Removing some tests which are done at other points in the code
implicitly.

In lib/s390x/uc.c#setup_uv(void) the rc of the qui result is verified
using asserts.
The whole test is fenced by lib/s390x/uc.c#uv_os_is_guest(void) that
checks if SET and REMOVE SHARED is present.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-guest.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 99120cae..728c60aa 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -69,23 +69,15 @@ static void test_query(void)
 	cc = uv_call(0, (u64)&uvcb);
 	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
 
-	uvcb.header.len = sizeof(uvcb);
-	cc = uv_call(0, (u64)&uvcb);
-	report((!cc && uvcb.header.rc == UVC_RC_EXECUTED) ||
-	       (cc == 1 && uvcb.header.rc == 0x100),
-		"successful query");
-
 	/*
-	 * These bits have been introduced with the very first
-	 * Ultravisor version and are expected to always be available
-	 * because they are basic building blocks.
+	 * BIT_UVC_CMD_QUI, BIT_UVC_CMD_SET_SHARED_ACCESS and
+	 * BIT_UVC_CMD_REMOVE_SHARED_ACCESS are always present as they
+	 * have been introduced with the first Ultravisor version.
+	 * However, we only need to check for QUI as
+	 * SET/REMOVE SHARED are used to fence this test to be only
+	 * executed by protected guests.
 	 */
-	report(test_bit_inv(BIT_UVC_CMD_QUI, &uvcb.inst_calls_list[0]),
-	       "query indicated");
-	report(test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
-	       "share indicated");
-	report(test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
-	       "unshare indicated");
+	report(uv_query_test_call(BIT_UVC_CMD_QUI), "query indicated");
 	report_prefix_pop();
 }
 
-- 
2.36.1

