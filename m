Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C31A9D3C
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 10:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbfIEIkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 04:40:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732736AbfIEIkl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Sep 2019 04:40:41 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x858bjl6132891
        for <kvm@vger.kernel.org>; Thu, 5 Sep 2019 04:40:40 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2utwe24kxb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 04:40:40 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 5 Sep 2019 09:40:38 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Sep 2019 09:40:36 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x858eZMl53477436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Sep 2019 08:40:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33E61A4053;
        Thu,  5 Sep 2019 08:40:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF6C2A405E;
        Thu,  5 Sep 2019 08:40:34 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Sep 2019 08:40:34 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, frankja@linux.vnet.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [GIT PULL 8/8] KVM: selftests: Test invalid bits in kvm_valid_regs and kvm_dirty_regs on s390x
Date:   Thu,  5 Sep 2019 10:40:09 +0200
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190905084009.26106-1-frankja@linux.ibm.com>
References: <20190905084009.26106-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19090508-0016-0000-0000-000002A6FD92
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090508-0017-0000-0000-000033076F02
Message-Id: <20190905084009.26106-9-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-05_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=617 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909050089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

Now that we disallow invalid bits in kvm_valid_regs and kvm_dirty_regs
on s390x, too, we should also check this condition in the selftests.
The code has been taken from the x86-version of the sync_regs_test.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/lkml/20190904085200.29021-3-thuth@redhat.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 .../selftests/kvm/s390x/sync_regs_test.c      | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index bbc93094519b..d5290b4ad636 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -85,6 +85,36 @@ int main(int argc, char *argv[])
 
 	run = vcpu_state(vm, VCPU_ID);
 
+	/* Request reading invalid register set from VCPU. */
+	run->kvm_valid_regs = INVALID_SYNC_FIELD;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv < 0 && errno == EINVAL,
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    rv);
+	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
+
+	run->kvm_valid_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv < 0 && errno == EINVAL,
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    rv);
+	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
+
+	/* Request setting invalid register set into VCPU. */
+	run->kvm_dirty_regs = INVALID_SYNC_FIELD;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv < 0 && errno == EINVAL,
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    rv);
+	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
+
+	run->kvm_dirty_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv < 0 && errno == EINVAL,
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    rv);
+	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
+
 	/* Request and verify all valid register sets. */
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vm, VCPU_ID);
-- 
2.20.1

