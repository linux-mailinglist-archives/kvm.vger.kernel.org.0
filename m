Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367C12D19E2
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 20:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgLGTm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 14:42:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51144 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGTm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 14:42:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7JdqVK004062;
        Mon, 7 Dec 2020 19:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=HP4ykR3R0iwJZXcpzLQ6riSiwYYg8qZvFJCz5Jl3mJY=;
 b=FyISXWK+FILRZAtOhLfPTqM4kxVfOgYLc3imyy6omMqB5P0trOAcQMbkXL8DzcS/EpOz
 EWwgoGWsvpN6yC8t+0/yU3M/ptJDzKkVNOeZqk1NXmGBFEzeOWYBfWtohwGJc9eZjQoj
 FcD9i8+llxoToC/O1iYLKUTqQHQmzzmZGubIiyegkZZwNglZDUWC/0yPHswAHFmu7M74
 U/dOt2nzd0qAvtaEifxey0gPeDnMxicFvNypdW4K5TB4wa4g0xlaC/ejDyPIdOCLlSW4
 nfa1NhtHS125/+9eRSu0DjAlx7oYvdnvwpiTwRpvk4PmvPRkfQVQQaxqnb7yi5jIQb50 vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mqq668-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 19:41:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7Jdfu3026188;
        Mon, 7 Dec 2020 19:41:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 358m4wqhgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 19:41:42 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7JffHo015272;
        Mon, 7 Dec 2020 19:41:41 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 11:41:41 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/2 v4] nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Mon,  7 Dec 2020 19:41:29 +0000
Message-Id: <20201207194129.7543-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201207194129.7543-1-krish.sadhukhan@oracle.com>
References: <20201207194129.7543-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to sections "Canonicalization and Consistency Checks" and "Event
Injection" in APM vol 2

    VMRUN exits with VMEXIT_INVALID error code if either:
      - Reserved values of TYPE have been specified, or
      - TYPE = 3 (exception) has been specified with a vector that does not
	correspond to an exception (this includes vector 2, which is an NMI,
	not an exception).

Existing tests already cover part of the second rule. This patch covers the
the first rule and the missing pieces of the second rule.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index f78c9e4..b9be522 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2132,6 +2132,43 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+static void test_event_inject(void)
+{
+	u32 i;
+	u32 event_inj_saved = vmcb->control.event_inj;
+
+	handle_exception(DE_VECTOR, my_isr);
+
+	report (svm_vmrun() == SVM_EXIT_VMMCALL && count_exc == 0, "Test "
+	    "No EVENTINJ");
+
+	/*
+	 * Reserved values for 'Type' in EVENTINJ causes VMEXIT_INVALID.
+	 */
+	for (i = 1; i < 8; i++) {
+		if (i != 1 && i < 5)
+			continue;
+		vmcb->control.event_inj = DE_VECTOR |
+		    i << SVM_EVTINJ_TYPE_SHIFT | SVM_EVTINJ_VALID;
+		report(svm_vmrun() == SVM_EXIT_ERR && count_exc == 0,
+		    "Test invalid TYPE (%x) in EVENTINJ", i);
+	}
+
+	/*
+	 * Invalid vector number for event type 'exception' in EVENTINJ
+	 * causes VMEXIT_INVALID.
+	 */
+	for (i = 32; i < 256; i += 4) {
+		vmcb->control.event_inj = i | SVM_EVTINJ_TYPE_EXEPT |
+		    SVM_EVTINJ_VALID;
+		report(svm_vmrun() == SVM_EXIT_ERR && count_exc == 0,
+		    "Test invalid vector (%u) in EVENTINJ for event type "
+		    "\'exception\'", i);
+	}
+
+	vmcb->control.event_inj = event_inj_saved;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2141,6 +2178,7 @@ static void svm_guest_state_test(void)
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_event_inject();
 }
 
 struct svm_test svm_tests[] = {
-- 
2.18.4

