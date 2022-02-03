Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688F64A8155
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 10:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbiBCJTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 04:19:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237231AbiBCJTq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 04:19:46 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2137807H029011;
        Thu, 3 Feb 2022 09:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f1idZwrGhtomCKPDqR5MAoWzQwKDwoKGEoGt2Ape+9Y=;
 b=kCZioPF3zWcTAscIQ4LSF5Xj1bv4v572gB+CSceacBOSCo6Vt3Yi4uhdeYmVsP05KlLy
 nM9rhGpLgyKhgIJrGALeh7uJNbM3eg3cMjI2LdK9pjX4wbsR8+Ue8QkVTCKGqUrClzwz
 wY5P7MDNAQApA7dTupeiiQG35vmSoo10Xz2mG0ZG0i1CYuzm9JGYRxJ2POKFDbY0N7RP
 Ydtu/QXshZxferUy0Tj4bP5X4mI8hFlv9APus7MCjigpdEH6nWf5VF5Fu0MuY7RisUjm
 LVCNTexeuRSZjgaAfXdVwwa5V+LOrXdj/uA0wF4Dk3M5hkS3NCi2gRrCWAt4vA3Nb6Kb 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e00ufv4s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:45 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2138g3aA006474;
        Thu, 3 Feb 2022 09:19:45 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e00ufv4rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:45 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2139IvWY015775;
        Thu, 3 Feb 2022 09:19:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3dvw7a42rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2139Jdhm40632618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 09:19:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC545204F;
        Thu,  3 Feb 2022 09:19:39 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1A46152057;
        Thu,  3 Feb 2022 09:19:39 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/4] s390x: uv-guest: remove duplicated checks
Date:   Thu,  3 Feb 2022 09:19:34 +0000
Message-Id: <20220203091935.2716-4-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220203091935.2716-1-seiden@linux.ibm.com>
References: <20220203091935.2716-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GQiMIt4rKkflCFrtUFFwd4FYnMRfKKwz
X-Proofpoint-ORIG-GUID: QChd0jbnAjqGFSWFaBBGjWXBH5E9IQgM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_02,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Removing some tests which are done at other points in the code
implicitly.

In lib/s390x/uc.c#setup_uv(void) the rc of the qui result is verified
using asserts.
The whole test is fenced by lib/s390x/uc.c#os_is_guest(void) that
checks if SET and REMOVE SHARED is present.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-guest.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 44ad2154..97ae4687 100644
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
+	 * BIT_UVC_CMD_SET_SHARED_ACCESS are always present as they
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
2.30.2

