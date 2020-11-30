Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184892C91AB
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 23:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388767AbgK3WyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 17:54:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56762 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbgK3WyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 17:54:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMdFnv033963;
        Mon, 30 Nov 2020 22:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=HP4ykR3R0iwJZXcpzLQ6riSiwYYg8qZvFJCz5Jl3mJY=;
 b=xkaHQQvD6LKrkltQFKGFDfRltUPbn1KmDpv7BHXMo9ngA4+sHqGbJuOnMF4qYVoRDxWE
 Z3nfj4AX182v6+aNOQQFC/ePbNYY6zVUdApW4SJ+lM4a2Kx2FaOYUphQ8qsW7OBmc1e9
 oRJrNk8wWc3khsx3LqbZlRIL1h7BcoRonGDv8I1Tr9vi/FM9hqP0VVJDMEF3QB6QGDVQ
 sJoDjf7Q4idr0JWUZhFWzu8ffWvhlCkMxULCRXgl5JsRfi00rGIZhJou6JfvbioxSV52
 o/Boyn4UMECnd5bN4koZ6FBlBAS79rwh804CSu/MW3WUBSIE2Q1t0e5dOwX8vTz2ar2F WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqfs4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 22:53:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMeECw107097;
        Mon, 30 Nov 2020 22:53:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540ar8taf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 22:53:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUMrFeg026958;
        Mon, 30 Nov 2020 22:53:15 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 14:53:15 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/2 v3] nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Mon, 30 Nov 2020 22:53:06 +0000
Message-Id: <20201130225306.15075-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201130225306.15075-1-krish.sadhukhan@oracle.com>
References: <20201130225306.15075-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300141
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

