Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0513D57DB20
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 09:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiGVHUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 03:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiGVHUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 03:20:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB0F2AC1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 00:20:11 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M6jxW8028253
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=b+M7J7UE23UZy9Z6hlOkLchhu8gMQMBfnYeKPCg3DWQ=;
 b=SWXwMket+r8VYfAA8Zzc8e016rZey8GvsmexQtrAvIjC2o/R1i50ec8a7fedYwFUBIE+
 4+3FkjZ23AtlEmsnBqKBxpA5B462NQOKPR9UM42uMJzRVZvhz5yQvmTygguuMJOcCDCt
 l1r7DwOieBhG5pok3AEI2wXFER/rUq/SufH+V0PGcDvPx4yyfXvJy2wE5tsOuqq63YvI
 J02wTyOswUeEpCVzNA6o5LA+zfSd9kbDBQC/PJNkNH7Uov5SA7hIt/L7AGLsg96XNCRY
 3rzhvguoveNWgBSW49SXh4g7x7QoCdIF53NWFj8qt8MjXkED24aqvpsFND9h+GdJbGo+ qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfpws0t3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:11 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M6rdYn017515
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfpws0t37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 07:20:10 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M75IMs023908;
        Fri, 22 Jul 2022 07:20:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3hbmy9018v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 07:20:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M7K5T218022704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 07:20:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81DF74C050;
        Fri, 22 Jul 2022 07:20:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D16A4C04E;
        Fri, 22 Jul 2022 07:20:05 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 07:20:05 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/3] s390x: smp: move sigp calls with invalid cpu address to array
Date:   Fri, 22 Jul 2022 09:20:02 +0200
Message-Id: <20220722072004.800792-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722072004.800792-1-nrb@linux.ibm.com>
References: <20220722072004.800792-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2ifcpMXOjZ4xC3UwPOpa-b69oovcjWjs
X-Proofpoint-ORIG-GUID: EyZbSXQSRPrnDQL_XdGFYmsHsqg7AyZs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have the nice array to test SIGP calls with invalid CPU addresses.
Move the SIGP cases there to eliminate some of the duplicated code in
test_emcall and test_cond_emcall.

Since adding coverage for invalid CPU addresses in the ecall case is now
trivial, do that as well.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 0df4751f9cee..34ae91c3fe12 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -30,6 +30,9 @@ static const struct sigp_invalid_cases cases_invalid_cpu_addr[] = {
 	{ SIGP_STOP,                  "stop with invalid CPU address" },
 	{ SIGP_START,                 "start with invalid CPU address" },
 	{ SIGP_CPU_RESET,             "reset with invalid CPU address" },
+	{ SIGP_COND_EMERGENCY_SIGNAL, "conditional emcall with invalid CPU address" },
+	{ SIGP_EMERGENCY_SIGNAL,      "emcall with invalid CPU address" },
+	{ SIGP_EXTERNAL_CALL,         "ecall with invalid CPU address" },
 	{ INVALID_ORDER_CODE,         "invalid order code and CPU address" },
 	{ SIGP_SENSE,                 "sense with invalid CPU address" },
 	{ SIGP_STOP_AND_STORE_STATUS, "stop and store status with invalid CPU address" },
@@ -329,7 +332,6 @@ static void emcall(void)
 static void test_emcall(void)
 {
 	struct psw psw;
-	int cc;
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)emcall;
 
@@ -343,13 +345,6 @@ static void test_emcall(void)
 	wait_for_flag();
 	smp_cpu_stop(1);
 
-	report_prefix_push("invalid CPU address");
-
-	cc = sigp(INVALID_CPU_ADDRESS, SIGP_EMERGENCY_SIGNAL, 0, NULL);
-	report(cc == 3, "CC = 3");
-
-	report_prefix_pop();
-
 	report_prefix_pop();
 }
 
@@ -368,13 +363,6 @@ static void test_cond_emcall(void)
 		goto out;
 	}
 
-	report_prefix_push("invalid CPU address");
-
-	cc = sigp(INVALID_CPU_ADDRESS, SIGP_COND_EMERGENCY_SIGNAL, 0, NULL);
-	report(cc == 3, "CC = 3");
-
-	report_prefix_pop();
-
 	report_prefix_push("success");
 	set_flag(0);
 
-- 
2.36.1

