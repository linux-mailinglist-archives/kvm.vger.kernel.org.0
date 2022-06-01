Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5EF53AA43
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355726AbiFAPhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355660AbiFAPhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:37:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF14BF5D;
        Wed,  1 Jun 2022 08:36:58 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251FE1We004380;
        Wed, 1 Jun 2022 15:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=0veDqImjM7n/9IW6nZeMnnGWd6Ot86bv17V5qf5u82g=;
 b=G9XY6j/Hrkx6ao5vrvmv19Z86eqdmKUcnApaohhdWKfpgOBEPKgD6hUzfTpCWDYs5R/0
 qvkUaUulYWB6Kn0o+45mwG9/Ze4d0VdQVGvA5pjfrKOnhI+qitMuX8yeoAwGLx7J1npe
 dngTg4zK1SNGsnYq8MtHI2/V7wIiWhbpRUHejizAOfUEkhTgOCjktbupA3XF69w+LBOz
 CthCmsw8a7H6BuLwJCtE3F7X7Of4kpLLxLQeebZvPAujziiehqJWYpcw/oPcYhWHgayL
 Ar3Hr1eYPv46vMrF1p2k+0XImFeiyuNx/p1UMrJ0lNQM4opvImjmSA9Mqq+Feq/45+QY AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geajsrgaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:57 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251FFIUU007363;
        Wed, 1 Jun 2022 15:36:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geajsrg9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FLbnG013460;
        Wed, 1 Jun 2022 15:36:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3gbcakmdgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251FaqIi21692850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E3FAA405C;
        Wed,  1 Jun 2022 15:36:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9E88A405B;
        Wed,  1 Jun 2022 15:36:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Jun 2022 15:36:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B1A44E028C; Wed,  1 Jun 2022 17:36:51 +0200 (CEST)
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
Subject: [GIT PULL 13/15] KVM: s390: selftests: Use TAP interface in the sync_regs test
Date:   Wed,  1 Jun 2022 17:36:44 +0200
Message-Id: <20220601153646.6791-14-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YlZq_yqmudr0ABm6RP6TRHrxxLzmMQj-
X-Proofpoint-ORIG-GUID: XS_VWpaR3V3Q-ptOJxortKAhQKv8TUrX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

The sync_regs test currently does not have any output (unless one
of the TEST_ASSERT statement fails), so it's hard to say for a user
whether a certain new sub-test has been included in the binary or
not. Let's make this a little bit more user-friendly and include
some TAP output via the kselftests.h interface.
To be able to distinguish the different sub-tests more easily, we
also break up the huge main() function here in more fine grained
parts.

Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220531101554.36844-3-thuth@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 .../selftests/kvm/s390x/sync_regs_test.c      | 87 ++++++++++++++-----
 1 file changed, 66 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index caf7b8859a94..9510739e226d 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -21,6 +21,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "diag318_test_handler.h"
+#include "kselftest.h"
 
 #define VCPU_ID 5
 
@@ -74,27 +75,9 @@ static void compare_sregs(struct kvm_sregs *left, struct kvm_sync_regs *right)
 #define TEST_SYNC_FIELDS   (KVM_SYNC_GPRS|KVM_SYNC_ACRS|KVM_SYNC_CRS|KVM_SYNC_DIAG318)
 #define INVALID_SYNC_FIELD 0x80000000
 
-int main(int argc, char *argv[])
+void test_read_invalid(struct kvm_vm *vm, struct kvm_run *run)
 {
-	struct kvm_vm *vm;
-	struct kvm_run *run;
-	struct kvm_regs regs;
-	struct kvm_sregs sregs;
-	int rv, cap;
-
-	/* Tell stdout not to buffer its content */
-	setbuf(stdout, NULL);
-
-	cap = kvm_check_cap(KVM_CAP_SYNC_REGS);
-	if (!cap) {
-		print_skip("CAP_SYNC_REGS not supported");
-		exit(KSFT_SKIP);
-	}
-
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-
-	run = vcpu_state(vm, VCPU_ID);
+	int rv;
 
 	/* Request reading invalid register set from VCPU. */
 	run->kvm_valid_regs = INVALID_SYNC_FIELD;
@@ -110,6 +93,11 @@ int main(int argc, char *argv[])
 		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
 		    rv);
 	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
+}
+
+void test_set_invalid(struct kvm_vm *vm, struct kvm_run *run)
+{
+	int rv;
 
 	/* Request setting invalid register set into VCPU. */
 	run->kvm_dirty_regs = INVALID_SYNC_FIELD;
@@ -125,6 +113,13 @@ int main(int argc, char *argv[])
 		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
 		    rv);
 	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
+}
+
+void test_req_and_verify_all_valid_regs(struct kvm_vm *vm, struct kvm_run *run)
+{
+	struct kvm_sregs sregs;
+	struct kvm_regs regs;
+	int rv;
 
 	/* Request and verify all valid register sets. */
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
@@ -146,6 +141,13 @@ int main(int argc, char *argv[])
 
 	vcpu_sregs_get(vm, VCPU_ID, &sregs);
 	compare_sregs(&sregs, &run->s.regs);
+}
+
+void test_set_and_verify_various_reg_values(struct kvm_vm *vm, struct kvm_run *run)
+{
+	struct kvm_sregs sregs;
+	struct kvm_regs regs;
+	int rv;
 
 	/* Set and verify various register values */
 	run->s.regs.gprs[11] = 0xBAD1DEA;
@@ -180,6 +182,11 @@ int main(int argc, char *argv[])
 
 	vcpu_sregs_get(vm, VCPU_ID, &sregs);
 	compare_sregs(&sregs, &run->s.regs);
+}
+
+void test_clear_kvm_dirty_regs_bits(struct kvm_vm *vm, struct kvm_run *run)
+{
+	int rv;
 
 	/* Clear kvm_dirty_regs bits, verify new s.regs values are
 	 * overwritten with existing guest values.
@@ -200,8 +207,46 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(run->s.regs.diag318 != 0x4B1D,
 		    "diag318 sync regs value incorrect 0x%llx.",
 		    run->s.regs.diag318);
+}
+
+struct testdef {
+	const char *name;
+	void (*test)(struct kvm_vm *vm, struct kvm_run *run);
+} testlist[] = {
+	{ "read invalid", test_read_invalid },
+	{ "set invalid", test_set_invalid },
+	{ "request+verify all valid regs", test_req_and_verify_all_valid_regs },
+	{ "set+verify various regs", test_set_and_verify_various_reg_values },
+	{ "clear kvm_dirty_regs bits", test_clear_kvm_dirty_regs_bits },
+};
+
+int main(int argc, char *argv[])
+{
+	static struct kvm_run *run;
+	static struct kvm_vm *vm;
+	int idx;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	ksft_print_header();
+
+	if (!kvm_check_cap(KVM_CAP_SYNC_REGS))
+		ksft_exit_skip("CAP_SYNC_REGS not supported");
+
+	ksft_set_plan(ARRAY_SIZE(testlist));
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		testlist[idx].test(vm, run);
+		ksft_test_result_pass("%s\n", testlist[idx].name);
+	}
 
 	kvm_vm_free(vm);
 
-	return 0;
+	ksft_finished();	/* Print results and exit() accordingly */
 }
-- 
2.35.1

