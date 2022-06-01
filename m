Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B1053AA32
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353403AbiFAPhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355680AbiFAPhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:37:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573ECBF55;
        Wed,  1 Jun 2022 08:36:58 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251FRIeG026301;
        Wed, 1 Jun 2022 15:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=5qcsyukOkCFEszks/gs1uP8y4vn3Qv+P/0BK12XOiz0=;
 b=I13pwy0J3BR9JaWtxXRYXvTvecLUzV73xzD2aN6prexuxDtDQizpt6GeNXY7BX8UG+NX
 PX22xxDl2zpHCRKxp8dK4Pe3wVHPHBHGpzJQ+nNz7ZOAf6b3IR9xSFVTtd3hkPh1OgvF
 rdbbQoIoVDA9ShxTf86ApubN9tqI+JGBTLW1Qe/308Vjw1DwWRcqlDp+w0sVNFlY+1Fo
 hl2d1t9LY6yFDovJC9XVWBz79p/YGd4MNE6Z8kEoRtA44lyWFIhxgSWqXBQiXnehtEF5
 hf8Oin+lQGu1D+TUouEuwPHkoSjr6Bg0OB2cjiiPixU7AziUqRbOoBbipFeCY3Y39pg+ FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geas5876y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:57 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251FTY6N000677;
        Wed, 1 Jun 2022 15:36:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geas5875u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FKruU023643;
        Wed, 1 Jun 2022 15:36:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h5uek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251Faqq124773108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5094AE055;
        Wed,  1 Jun 2022 15:36:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92C77AE051;
        Wed,  1 Jun 2022 15:36:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Jun 2022 15:36:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 55307E028C; Wed,  1 Jun 2022 17:36:51 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 12/15] KVM: s390: selftests: Use TAP interface in the memop test
Date:   Wed,  1 Jun 2022 17:36:43 +0200
Message-Id: <20220601153646.6791-13-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sXKum7pdkT3DNM9Vn1tmzI_tKNYm_5G-
X-Proofpoint-GUID: iT-NsX7isr_sOzkGO4-4W0BPluzkJmEk
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

The memop test currently does not have any output (unless one of the
TEST_ASSERT statement fails), so it's hard to say for a user whether
a certain new sub-test has been included in the binary or not. Let's
make this a little bit more user-friendly and include some TAP output
via the kselftests.h interface.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220531101554.36844-2-thuth@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 97 ++++++++++++++++++-----
 1 file changed, 78 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 49f26f544127..e704c6fa5758 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -14,6 +14,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "kselftest.h"
 
 enum mop_target {
 	LOGICAL,
@@ -691,34 +692,92 @@ static void test_errors(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
+struct testdef {
+	const char *name;
+	void (*test)(void);
+	int extension;
+} testlist[] = {
+	{
+		.name = "simple copy",
+		.test = test_copy,
+	},
+	{
+		.name = "generic error checks",
+		.test = test_errors,
+	},
+	{
+		.name = "copy with storage keys",
+		.test = test_copy_key,
+		.extension = 1,
+	},
+	{
+		.name = "copy with key storage protection override",
+		.test = test_copy_key_storage_prot_override,
+		.extension = 1,
+	},
+	{
+		.name = "copy with key fetch protection",
+		.test = test_copy_key_fetch_prot,
+		.extension = 1,
+	},
+	{
+		.name = "copy with key fetch protection override",
+		.test = test_copy_key_fetch_prot_override,
+		.extension = 1,
+	},
+	{
+		.name = "error checks with key",
+		.test = test_errors_key,
+		.extension = 1,
+	},
+	{
+		.name = "termination",
+		.test = test_termination,
+		.extension = 1,
+	},
+	{
+		.name = "error checks with key storage protection override",
+		.test = test_errors_key_storage_prot_override,
+		.extension = 1,
+	},
+	{
+		.name = "error checks without key fetch prot override",
+		.test = test_errors_key_fetch_prot_override_not_enabled,
+		.extension = 1,
+	},
+	{
+		.name = "error checks with key fetch prot override",
+		.test = test_errors_key_fetch_prot_override_enabled,
+		.extension = 1,
+	},
+};
+
 int main(int argc, char *argv[])
 {
-	int memop_cap, extension_cap;
+	int memop_cap, extension_cap, idx;
 
 	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
 
+	ksft_print_header();
+
 	memop_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP);
 	extension_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP_EXTENSION);
 	if (!memop_cap) {
-		print_skip("CAP_S390_MEM_OP not supported");
-		exit(KSFT_SKIP);
+		ksft_exit_skip("CAP_S390_MEM_OP not supported.\n");
 	}
 
-	test_copy();
-	if (extension_cap > 0) {
-		test_copy_key();
-		test_copy_key_storage_prot_override();
-		test_copy_key_fetch_prot();
-		test_copy_key_fetch_prot_override();
-		test_errors_key();
-		test_termination();
-		test_errors_key_storage_prot_override();
-		test_errors_key_fetch_prot_override_not_enabled();
-		test_errors_key_fetch_prot_override_enabled();
-	} else {
-		print_skip("storage key memop extension not supported");
-	}
-	test_errors();
+	ksft_set_plan(ARRAY_SIZE(testlist));
 
-	return 0;
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		if (testlist[idx].extension >= extension_cap) {
+			testlist[idx].test();
+			ksft_test_result_pass("%s\n", testlist[idx].name);
+		} else {
+			ksft_test_result_skip("%s - extension level %d not supported\n",
+					      testlist[idx].name,
+					      testlist[idx].extension);
+		}
+	}
+
+	ksft_finished();	/* Print results and exit() accordingly */
 }
-- 
2.35.1

