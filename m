Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802002D83A5
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 01:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391670AbgLLAxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 19:53:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407335AbgLLAxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 19:53:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BC0nUil036538;
        Sat, 12 Dec 2020 00:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=HP4ykR3R0iwJZXcpzLQ6riSiwYYg8qZvFJCz5Jl3mJY=;
 b=czEvxtVkI8pmqAzHpEZSduxgLcXcZSZFloYqmXeQe6/wpFjTIdG4GZP29pLqfYp1ticR
 fOufseeI8Zleqs2lG5iJExzS9wD8z/QK5Bq1ZCX+R4Rc3ZvW7qs68ldar39F3IBpNiCT
 enDYBekuBRZ0ko0yQXv8gS+TcRV3k4KxKUJL1rRc4ObaB8r3mpRJXNd7DoxnS1y1u58I
 7PiX46/MzblIRrpXOcECK1erhC5F70Q3yyQ7EmBdin1lU6CkB8bVL0flBSfJquH5BBPt
 LWRi1hzKloFPCkbULXqS8uh+lwInP/NRYrNmXmlnS+O75uNr60wqUB3Kw0Er5/T9z0Sa Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825mn8bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 12 Dec 2020 00:52:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BC0ns10099715;
        Sat, 12 Dec 2020 00:50:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35cjyqsb64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Dec 2020 00:50:27 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BC0oQPX012201;
        Sat, 12 Dec 2020 00:50:26 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Dec 2020 16:50:26 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Subject: [PATCH 2/2 v5] nSVM: Test reserved values for 'Type' and invalid vectors in EVENTINJ
Date:   Sat, 12 Dec 2020 00:50:19 +0000
Message-Id: <20201212005019.6807-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212005019.6807-1-krish.sadhukhan@oracle.com>
References: <20201212005019.6807-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012120004
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

