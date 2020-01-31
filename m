Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D9314EF0B
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgAaPD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:03:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729111AbgAaPD7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:03:59 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF152R056840
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:03:58 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvfy985t1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:03:57 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:03:55 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:03:52 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF3pMP27656204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:03:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC85F42041;
        Fri, 31 Jan 2020 15:03:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9488542045;
        Fri, 31 Jan 2020 15:03:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:03:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 538D6E03BC; Fri, 31 Jan 2020 16:03:51 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 7/7] selftests: KVM: testing the local IRQs resets
Date:   Fri, 31 Jan 2020 16:03:48 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150348.73360-1-borntraeger@de.ibm.com>
References: <20200131150348.73360-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20013115-0016-0000-0000-000002E28F3D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0017-0000-0000-000033455F3A
Message-Id: <20200131150348.73360-8-borntraeger@de.ibm.com>
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

Local IRQs are reset by a normal cpu reset.  The initial cpu reset and
the clear cpu reset, as superset of the normal reset, both clear the
IRQs too.

Let's inject an interrupt to a vCPU before calling a reset and see if
it is gone after the reset.

We choose to inject only an emergency interrupt at this point and can
extend the test to other types of IRQs later.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[minor fixups]
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20200131100205.74720-7-frankja@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/s390x/resets.c | 42 ++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index fb8e976943a9..1485bc6c8999 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -14,6 +14,9 @@
 #include "kvm_util.h"
 
 #define VCPU_ID 3
+#define LOCAL_IRQS 32
+
+struct kvm_s390_irq buf[VCPU_ID + LOCAL_IRQS];
 
 struct kvm_vm *vm;
 struct kvm_run *run;
@@ -53,6 +56,23 @@ static void test_one_reg(uint64_t id, uint64_t value)
 	TEST_ASSERT(eval_reg == value, "value == %s", value);
 }
 
+static void assert_noirq(void)
+{
+	struct kvm_s390_irq_state irq_state;
+	int irqs;
+
+	irq_state.len = sizeof(buf);
+	irq_state.buf = (unsigned long)buf;
+	irqs = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_GET_IRQ_STATE, &irq_state);
+	/*
+	 * irqs contains the number of retrieved interrupts. Any interrupt
+	 * (notably, the emergency call interrupt we have injected) should
+	 * be cleared by the resets, so this should be 0.
+	 */
+	TEST_ASSERT(irqs >= 0, "Could not fetch IRQs: errno %d\n", errno);
+	TEST_ASSERT(!irqs, "IRQ pending");
+}
+
 static void assert_clear(void)
 {
 	struct kvm_sregs sregs;
@@ -94,6 +114,22 @@ static void assert_initial(void)
 static void assert_normal(void)
 {
 	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
+	assert_noirq();
+}
+
+static void inject_irq(int cpu_id)
+{
+	struct kvm_s390_irq_state irq_state;
+	struct kvm_s390_irq *irq = &buf[0];
+	int irqs;
+
+	/* Inject IRQ */
+	irq_state.len = sizeof(struct kvm_s390_irq);
+	irq_state.buf = (unsigned long)buf;
+	irq->type = KVM_S390_INT_EMERGENCY;
+	irq->u.emerg.code = cpu_id;
+	irqs = _vcpu_ioctl(vm, cpu_id, KVM_S390_SET_IRQ_STATE, &irq_state);
+	TEST_ASSERT(irqs >= 0, "Error injecting EMERGENCY IRQ errno %d\n", errno);
 }
 
 static void test_normal(void)
@@ -106,6 +142,8 @@ static void test_normal(void)
 
 	vcpu_run(vm, VCPU_ID);
 
+	inject_irq(VCPU_ID);
+
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_NORMAL_RESET, 0);
 	assert_normal();
 	kvm_vm_free(vm);
@@ -120,6 +158,8 @@ static void test_initial(void)
 
 	vcpu_run(vm, VCPU_ID);
 
+	inject_irq(VCPU_ID);
+
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_INITIAL_RESET, 0);
 	assert_normal();
 	assert_initial();
@@ -135,6 +175,8 @@ static void test_clear(void)
 
 	vcpu_run(vm, VCPU_ID);
 
+	inject_irq(VCPU_ID);
+
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_CLEAR_RESET, 0);
 	assert_normal();
 	assert_initial();
-- 
2.21.0

