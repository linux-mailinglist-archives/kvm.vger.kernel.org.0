Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821704E2427
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346266AbiCUKUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiCUKUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C882A240;
        Mon, 21 Mar 2022 03:19:11 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L9MuKD010588;
        Mon, 21 Mar 2022 10:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3qw3e7BuEn1pPymt4arsvOWmgm2yE8s6QV6FNjb7NoU=;
 b=Kb+tL3NKe1TuOeCUUy+gynhG5YAIQOtuEOW2v6p8qmB+RMEALmQYqDwVnn/VREEQNoa0
 D79fnz1sLcbYpv0JsGxJ84VhroE0AIZEOKdSbHMUNoGtSIKFTO4g8Ult5sQM/CvfPPTW
 Il5Z39eH3n2f8pX5i6q6SezbhSsKCorle5IHfwFq2u8HPbDKWYDPqMYNuIMBS67GyUoC
 cbxtK8d7+rIEo2l9T4bjgG2B3ff9l9lxQ8zu89/+NbrndsfPP7R9KPv85ZJDbyTOJF3W
 t0J1J5KD9KglVemhgOehH3ksePhtOvP2769KYoe8prX0FytDxfd6P4nZE75zYdRwdhP5 dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3exppbh10d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:11 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LAGIfx016049;
        Mon, 21 Mar 2022 10:19:10 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3exppbh104-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LAEb0N029756;
        Mon, 21 Mar 2022 10:19:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t8uju2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LA7RL75964174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:07:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3D9A11C04C;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74C9811C052;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 2/9] s390x: smp: stop already stopped CPU
Date:   Mon, 21 Mar 2022 11:18:57 +0100
Message-Id: <20220321101904.387640-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ibFRI82f-WaC8xZVUlqgQau0AzA0NeFC
X-Proofpoint-GUID: GDyDvV5o9ONzXqAG9gyHjlx-WpGnks0y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As per the PoP, the SIGP STOP order is only effective when the CPU is in
the operating state. Hence, we should have a test which tries to stop an
already stopped CPU.

Even though the SIGP order might be processed asynchronously, we assert
the CPU stays stopped.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 911a26c51b10..e5a16eb5a46a 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -129,6 +129,11 @@ static void test_stop(void)
 	 */
 	while (!smp_cpu_stopped(1)) {}
 	report_pass("stop");
+
+	report_prefix_push("stop stopped CPU");
+	report(!smp_cpu_stop(1), "STOP succeeds");
+	report(smp_cpu_stopped(1), "CPU is stopped");
+	report_prefix_pop();
 }
 
 static void test_stop_store_status(void)
-- 
2.31.1

