Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724EA4D4D51
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 16:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344744AbiCJPKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 10:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344487AbiCJPKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 10:10:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12370BBE29
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 07:03:29 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22AEqOri011153
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 15:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=r8r6M3LcdUdNUv80t8+3mE3uJRqYhtgzPDPzLa2V1xU=;
 b=XHIT/wHq5+9c/Cuh/37yM4VktktNUHk2KwZAjBYY69UKLUoe5R0cH9CVaf2lglg1hbpv
 nqfVSHCUhwhz7sccFLO5FnYCirV6F+B9kD8ibmxnsPA67S0peeAltKJ1JHDBnoRDEtzy
 HXnsJIUsAYN0RHkSwANXDMoasDBWQ086PWJKWPhEXsriiHWzPPPyBXSyvf50bjfEs+tm
 xPGNsBp0GfeyudUzE95ePsEnPZ0xWuVuL4loOupfTLM7E8KUM4QA2ZBxR3P5AayU1HDx
 S2RuVuLM+7Ji1E8yLQHRViVGfw2AkTiJu6aQ00dbZcQG7VUxNRHbjjUDHAYd0EjPUqRV cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ep0sduj2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 15:03:28 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22AEt4Ga017305
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 15:03:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ep0sduj27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 15:03:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22AEquje029128;
        Thu, 10 Mar 2022 15:03:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ekyg94wn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 15:03:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22AF3M9P50200890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 15:03:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1B2EA405B;
        Thu, 10 Mar 2022 15:03:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67CD7A4054;
        Thu, 10 Mar 2022 15:03:22 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Mar 2022 15:03:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     mhartmay@linux.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH] runtime: indicate failure on crash/timeout/abort in TAP
Date:   Thu, 10 Mar 2022 16:03:22 +0100
Message-Id: <20220310150322.2111128-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SbA3MJQrhhyUapW4iFlG-Ngh7R6SJd3f
X-Proofpoint-GUID: KigsqVT80jxEONPFAWWy1CemLUvxG8fY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=928 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100079
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
---
 scripts/runtime.bash | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 6d5fced94246..b41b3d444e27 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -163,9 +163,19 @@ function run()
         print_result "SKIP" $testname "$summary"
     elif [ $ret -eq 124 ]; then
         print_result "FAIL" $testname "" "timeout; duration=$timeout"
+        if [[ $tap_output != "no" ]]; then
+            echo "not ok TEST_NUMBER - ${testname}: timeout; duration=$timeout" >&3
+        fi
     elif [ $ret -gt 127 ]; then
-        print_result "FAIL" $testname "" "terminated on SIG$(kill -l $(($ret - 128)))"
+        signame="SIG"$(kill -l $(($ret - 128)))
+        print_result "FAIL" $testname "" "terminated on $signame"
+        if [[ $tap_output != "no" ]]; then
+            echo "not ok TEST_NUMBER - ${testname}: terminated on $signame" >&3
+        fi
     else
+        if [ $ret -eq 127 ] && [[ $tap_output != "no" ]]; then
+            echo "not ok TEST_NUMBER - ${testname}: aborted" >&3
+        fi
         print_result "FAIL" $testname "$summary"
     fi
 
-- 
2.31.1

