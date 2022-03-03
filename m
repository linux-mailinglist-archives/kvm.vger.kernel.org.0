Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E3C4CC791
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiCCVFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbiCCVFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:05:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F2598586;
        Thu,  3 Mar 2022 13:04:33 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KVYON006232;
        Thu, 3 Mar 2022 21:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ovVSVHDwa/Fx6R4JucXdR1ubag0ugwqSwa8Bpuphbsw=;
 b=i3cIPnDzzDJg4RupcCsvyt9vucPdf6iau+eDlXGiFQikRBs5Ja3+/a21BmTnN8InM0wH
 zYKaqqM9rx8TZhkSetlsFMPLZ8nj+dbLrcjIFQ5tPS4amfVhRIGZ6Ec0Th5Hvqc71U7M
 st8nJ4k7l+1ff4zINCMSQ4Fz0IQpELJt2Tzb78+rLkMO2V8MHlOgKzpo6CfNTKHgGuOq
 AR6Pialsacx7uAzWrvAABEZrAAkISBE2UjlFOEKYT+rap54h1SLDjMc1ZQn43/IpX6LG
 EWnYYbkutaD3ue+gG2fvtg+kEZQArE5IwnefimqbXkk1NZbrILN2hbaeLgGhzENPUgxN HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek4srrjgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:33 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223L4WR2018162;
        Thu, 3 Mar 2022 21:04:32 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek4srrjg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223L3EY5018438;
        Thu, 3 Mar 2022 21:04:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ek4k8023s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223L4QRK45875606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 21:04:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4BCB4C04A;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C20304C040;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 802FDE03D1; Thu,  3 Mar 2022 22:04:26 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v1 2/6] s390x: smp: Test SIGP RESTART against stopped CPU
Date:   Thu,  3 Mar 2022 22:04:21 +0100
Message-Id: <20220303210425.1693486-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303210425.1693486-1-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uqBZg2-Nlzxzk9i33nlE2-MzyhxYuF7D
X-Proofpoint-GUID: hUT0V94r16enns1K-boOYG95-jR0BNG6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1015 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203030095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

test_restart() makes two smp_cpu_restart() calls against CPU 1.
It claims to perform both of them against running (operating) CPUs,
but the first invocation tries to achieve this by calling
smp_cpu_stop() to CPU 0. This will be rejected by the library.

Let's fix this by making the first restart operate on a stopped CPU,
to ensure it gets test coverage instead of relying on other callers.

Fixes: 166da884d ("s390x: smp: Add restart when running test")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 s390x/smp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 068ac74d..2f4af820 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -50,10 +50,6 @@ static void test_start(void)
 	report_pass("start");
 }
 
-/*
- * Does only test restart when the target is running.
- * The other tests do restarts when stopped multiple times already.
- */
 static void test_restart(void)
 {
 	struct cpu *cpu = smp_cpu_from_idx(1);
@@ -62,8 +58,8 @@ static void test_restart(void)
 	lc->restart_new_psw.mask = extract_psw_mask();
 	lc->restart_new_psw.addr = (unsigned long)test_func;
 
-	/* Make sure cpu is running */
-	smp_cpu_stop(0);
+	/* Make sure cpu is stopped */
+	smp_cpu_stop(1);
 	set_flag(0);
 	smp_cpu_restart(1);
 	wait_for_flag();
-- 
2.32.0

