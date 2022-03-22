Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D1D4E3ED7
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 13:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiCVMz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 08:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiCVMzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 08:55:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3974C2B1B9
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 05:53:51 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MB6fEP027658
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 12:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=q/CZNXg2zd2Y6hNGIjYhCGiWsemBGiWFesXpqBGxj8o=;
 b=efSRnuzEq0MXkklzIbhgbsbCs+3PmnKkUsGTVIKN/EQrFq7CFrFOof25Q2CaL9HBqpXi
 fwKAOr/OQPETUOiiTGgfQjkYlj0UzNTtvNdm4QIrtLpfoLYCan/NKPgAdQDfY2FQJK7g
 SxVT/onQNpbxYY1OI25BiaLG8b0W9F+fsHKaoAAgfd2BHdeD0N/30wRdRueKGNlgpeaM
 7qJ/bRbpuw3DLkXDILvh0nIZ/4P9CjMWxhKcCFC/boZKGNfXU09rC3UQ9As6hVs/WD12
 T9KSjxWjhnVA3gYfdx8sBGGXc9E1VwlZPL0eDcD9UUNcp0KuPGM3GWinXXgI91sAnjZ9 +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey8ymyx38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 12:53:50 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MCFACk022539
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 12:53:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey8ymyx2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 12:53:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MCrcNE023931;
        Tue, 22 Mar 2022 12:53:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t8x6wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 12:53:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MCrlm332964882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 12:53:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28EB24C040;
        Tue, 22 Mar 2022 12:53:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E89B74C046;
        Tue, 22 Mar 2022 12:53:43 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 12:53:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     mhartmay@linux.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v2] runtime: indicate failure on crash/timeout/abort in TAP
Date:   Tue, 22 Mar 2022 13:53:43 +0100
Message-Id: <20220322125343.572124-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7yvJGJSq4IS9fp5AwZVq64vUFp-wVDc0
X-Proofpoint-ORIG-GUID: uBeoBmiQyv4FoCO682XIZaEaHaDXPlvA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=952 clxscore=1015 impostorscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we have crashes, timeouts or aborts, there is currently no indication for
this in the TAP output. When all reports() up to this point succeeded, this
might result in a TAP file looking completely fine even though things went
terribly wrong.

For example, when I set the timeout for the diag288 test on s390x to 1 second,
it fails because it takes quite long, which is properly indicated in the
normal output:

$ ./run_tests.sh diag288
FAIL diag288 (timeout; duration=1s)

But, when I enable TAP output, I get this:

$ ./run_tests.sh -t diag288
TAP version 13
ok 1 - diag288: diag288: privileged: Program interrupt: expected(2) == received(2)
ok 2 - diag288: diag288: specification: uneven: Program interrupt: expected(6) == received(6)
ok 3 - diag288: diag288: specification: unsupported action: Program interrupt: expected(6) == received(6)
ok 4 - diag288: diag288: specification: unsupported function: Program interrupt: expected(6) == received(6)
ok 5 - diag288: diag288: specification: no init: Program interrupt: expected(6) == received(6)
ok 6 - diag288: diag288: specification: min timer: Program interrupt: expected(6) == received(6)
1..6

Which looks like a completely fine TAP file, but actually we ran into a timeout
and didn't even run all tests.

With this patch, we get an additional line at the end which properly shows
something went wrong:

not ok 7 - diag288: timeout; duration=1s

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 scripts/runtime.bash | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 6d5fced94246..8795ceacf83b 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -163,9 +163,19 @@ function run()
         print_result "SKIP" $testname "$summary"
     elif [ $ret -eq 124 ]; then
         print_result "FAIL" $testname "" "timeout; duration=$timeout"
+        if [ $tap_output = "yes" ]; then
+            echo "not ok TEST_NUMBER - ${testname}: timeout; duration=$timeout" >&3
+        fi
     elif [ $ret -gt 127 ]; then
-        print_result "FAIL" $testname "" "terminated on SIG$(kill -l $(($ret - 128)))"
+        signame="SIG"$(kill -l $(($ret - 128)))
+        print_result "FAIL" $testname "" "terminated on $signame"
+        if [ $tap_output = "yes" ]; then
+            echo "not ok TEST_NUMBER - ${testname}: terminated on $signame" >&3
+        fi
     else
+        if [ $ret -eq 127 ] && [ $tap_output = "yes" ]; then
+            echo "not ok TEST_NUMBER - ${testname}: aborted" >&3
+        fi
         print_result "FAIL" $testname "$summary"
     fi
 
-- 
2.31.1

