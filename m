Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E77551F30
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343603AbiFTOks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245155AbiFTOj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:39:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A268E389A
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:59:50 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KCaKgZ001209;
        Mon, 20 Jun 2022 13:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pmxlHQTPLuQWjWWffZUOf857m+unAVhna8a8UF/oL98=;
 b=aflzalbZDRoDJ6DAiunV1LeOKqkbzIlhWptiTnTtagfC5RY82/XkUQ0mF8KacexsypRw
 J3xfOWIsldjT70E0hBl+8ZsFtYEyk+CV5twI47441z9yXtm14QiK1Y7hZSIRptFHeDdx
 Twhm15VerEhQzMrLWRehQWwalK+B1TnzEjAA4CVBtpBv34cwKmOy+u3v86vx+kgGHBSL
 Ejm/QEzvsBr8FIhtShlgeibbeNDMKnqhrakzMn24RlHYA4aEx414bFKF5PeOsT2yB/88
 BveN9HPGVrGNWX8XdvmQEBPfzQIayDz5gogeuuBlVZMJJfweky87qxA0zYztGhuzmBWn aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrgvkd82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:45 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KDNCg5013097;
        Mon, 20 Jun 2022 13:59:44 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrgvkd78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:44 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KDpBiE009321;
        Mon, 20 Jun 2022 13:59:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3gs5yhjm0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KDxcMM11993578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 13:59:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D755A11C04A;
        Mon, 20 Jun 2022 13:59:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1800211C04C;
        Mon, 20 Jun 2022 13:59:38 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 13:59:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v8 09/12] target/s390x: interception of PTF instruction
Date:   Mon, 20 Jun 2022 16:03:49 +0200
Message-Id: <20220620140352.39398-10-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620140352.39398-1-pmorel@linux.ibm.com>
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EKgmt6jDwYy8I5R3ZQ-BrORG_4CiXy8V
X-Proofpoint-ORIG-GUID: 9HCbIqDw9avsgFcJkWuGzxy3rhgZtGoc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the host supports the CPU topology facility, the PTF
instruction with function code 2 is interpreted by the SIE,
provided that the userland hypervizor activates the interpretation
by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.

The PTF instructions with function code 0 and 1 are intercepted
and must be emulated by the userland hypervizor.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c            | 50 ++++++++++++++++++++++++++++++
 include/hw/s390x/s390-virtio-ccw.h |  6 ++++
 target/s390x/kvm/kvm.c             | 13 ++++++++
 3 files changed, 69 insertions(+)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 107cdbecad..2dbb42ee2b 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -20,6 +20,56 @@
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 
+/*
+ * s390_handle_ptf:
+ *
+ * @register 1: contains the function code
+ *
+ * Function codes 0 and 1 handle the CPU polarization.
+ * We assume an horizontal topology, the only one supported currently
+ * by Linux, consequently we answer to function code 0, requesting
+ * horizontal polarization that it is already the current polarization
+ * and reject vertical polarization request without further explanation.
+ *
+ * Function code 2 is handling topology changes and is interpreted
+ * by the SIE.
+ */
+void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
+{
+    CPUS390XState *env = &cpu->env;
+    uint64_t reg = env->regs[r1];
+    uint8_t fc = reg & S390_TOPO_FC_MASK;
+
+    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+        s390_program_interrupt(env, PGM_OPERATION, ra);
+        return;
+    }
+
+    if (env->psw.mask & PSW_MASK_PSTATE) {
+        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
+        return;
+    }
+
+    if (reg & ~S390_TOPO_FC_MASK) {
+        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
+        return;
+    }
+
+    switch (fc) {
+    case 0:    /* Horizontal polarization is already set */
+        env->regs[r1] |= S390_PTF_REASON_DONE;
+        setcc(cpu, 2);
+        break;
+    case 1:    /* Vertical polarization is not supported */
+        env->regs[r1] |= S390_PTF_REASON_NONE;
+        setcc(cpu, 2);
+        break;
+    default:
+        /* Note that fc == 2 is interpreted by the SIE */
+        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
+    }
+}
+
 /*
  * s390_create_cores:
  * @ms: Machine state
diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
index 3331990e02..f2c64dbc1a 100644
--- a/include/hw/s390x/s390-virtio-ccw.h
+++ b/include/hw/s390x/s390-virtio-ccw.h
@@ -30,6 +30,12 @@ struct S390CcwMachineState {
     uint8_t loadparm[8];
 };
 
+#define S390_PTF_REASON_NONE (0x00 << 8)
+#define S390_PTF_REASON_DONE (0x01 << 8)
+#define S390_PTF_REASON_BUSY (0x02 << 8)
+#define S390_TOPO_FC_MASK 0xffUL
+void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
+
 struct S390CcwMachineClass {
     /*< private >*/
     MachineClass parent_class;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 563bf5ac60..c664c45e8a 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -97,6 +97,7 @@
 
 #define PRIV_B9_EQBS                    0x9c
 #define PRIV_B9_CLP                     0xa0
+#define PRIV_B9_PTF                     0xa2
 #define PRIV_B9_PCISTG                  0xd0
 #define PRIV_B9_PCILG                   0xd2
 #define PRIV_B9_RPCIT                   0xd3
@@ -1461,6 +1462,15 @@ static int kvm_mpcifc_service_call(S390CPU *cpu, struct kvm_run *run)
     }
 }
 
+static int kvm_handle_ptf(S390CPU *cpu, struct kvm_run *run)
+{
+    uint8_t r1 = (run->s390_sieic.ipb >> 20) & 0x0f;
+
+    s390_handle_ptf(cpu, r1, RA_IGNORED);
+
+    return 0;
+}
+
 static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
 {
     int r = 0;
@@ -1478,6 +1488,9 @@ static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
     case PRIV_B9_RPCIT:
         r = kvm_rpcit_service_call(cpu, run);
         break;
+    case PRIV_B9_PTF:
+        r = kvm_handle_ptf(cpu, run);
+        break;
     case PRIV_B9_EQBS:
         /* just inject exception */
         r = -1;
-- 
2.31.1

