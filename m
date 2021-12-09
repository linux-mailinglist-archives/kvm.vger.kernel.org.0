Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E8846E950
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 14:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbhLINtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 08:49:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238134AbhLINtg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 08:49:36 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9DRUrg006962;
        Thu, 9 Dec 2021 13:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YMB65Vo+lM9LIB+nUKkRAtPJN0OQZQ3iJCCyEE2BEgA=;
 b=MDnQuRaCT0Dm2OmuGv9RAcYN4UtInnRF0RBz5Xaws3upJ6s92RJ3Yn+Kcz504gXZs6fD
 hV4QIBPnRs+e7hxbF4y3aH6z2Z3pYFPSApWInuE25oAgBiRBBVSTLDdAUaT+9vsUwk7P
 bhH4sVmI45rWH+XpwT+iyaGY1dLGqthCMff2XeySx70N13D1ETZkX/axtUBVnANgPwn6
 5LOlseGFSCqZZb4PIvCdqkjwn4tOCGbCdHk5Zq+C5EZy87rkSb4dJYFrsH1vFxrFFwTY
 9nnAMENywYELDLBzNnRWexrXu7OsV4AtxscCf5xtN1vBfhOIlG+3qUp/EVbVMG+LOK56 yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cujpygc83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:57 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9DS2We008253;
        Thu, 9 Dec 2021 13:45:57 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cujpygc7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:57 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Dc2RD027933;
        Thu, 9 Dec 2021 13:45:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3cqykg847u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9DjpZR27132350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 13:45:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E504111C05B;
        Thu,  9 Dec 2021 13:45:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2033211C04A;
        Thu,  9 Dec 2021 13:45:50 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.63.16])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 13:45:50 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com
Subject: [PATCH v5 05/12] s390x: CPU topology: CPU topology migration
Date:   Thu,  9 Dec 2021 14:46:36 +0100
Message-Id: <20211209134643.143866-6-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211209134643.143866-1-pmorel@linux.ibm.com>
References: <20211209134643.143866-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ThhCOHH6BxRbALUGSRiJIUMmsQVjLhHL
X-Proofpoint-GUID: ZYEKxtZFZ_FSCGvH7kLll4n_XxyMmZEI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both source and target must have the same configuration
regarding the activation of Perform Topology Function
and Store Topology System Information.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 target/s390x/cpu.h                  |  2 ++
 target/s390x/cpu_features_def.h.inc |  1 +
 target/s390x/cpu_models.c           |  2 ++
 target/s390x/gen-features.c         |  3 ++
 target/s390x/kvm/kvm.c              |  6 ++++
 target/s390x/machine.c              | 48 +++++++++++++++++++++++++++++
 6 files changed, 62 insertions(+)

diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index b97efe85a5..674281ce56 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -150,6 +150,8 @@ struct CPUS390XState {
     /* currently processed sigp order */
     uint8_t sigp_order;
 
+    /* Using Perform CPU Topology Function*/
+    bool using_ptf;
 };
 
 static inline uint64_t *get_freg(CPUS390XState *cs, int nr)
diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
index e86662bb3b..27e8904978 100644
--- a/target/s390x/cpu_features_def.h.inc
+++ b/target/s390x/cpu_features_def.h.inc
@@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: Conditional-external-interception f
 DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
 DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
 DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
+DEF_FEAT(CPU_TOPOLOGY, "cpu_topology", MISC, 0, "CPU Topology available")
 
 /* Features exposed via the PLO instruction. */
 DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in general registers)")
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 11e06cc51f..1f9ea6479d 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -238,6 +238,7 @@ bool s390_has_feat(S390Feat feat)
 
     if (s390_is_pv()) {
         switch (feat) {
+        case S390_FEAT_CPU_TOPOLOGY:
         case S390_FEAT_DIAG_318:
         case S390_FEAT_HPMA2:
         case S390_FEAT_SIE_F2:
@@ -467,6 +468,7 @@ static void check_consistency(const S390CPUModel *model)
         { S390_FEAT_DIAG_318, S390_FEAT_EXTENDED_LENGTH_SCCB },
         { S390_FEAT_NNPA, S390_FEAT_VECTOR },
         { S390_FEAT_RDP, S390_FEAT_LOCAL_TLB_CLEARING },
+        { S390_FEAT_CPU_TOPOLOGY, S390_FEAT_CONFIGURATION_TOPOLOGY },
     };
     int i;
 
diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
index 7cb1a6ec10..377d8aad90 100644
--- a/target/s390x/gen-features.c
+++ b/target/s390x/gen-features.c
@@ -488,6 +488,7 @@ static uint16_t full_GEN9_GA3[] = {
 static uint16_t full_GEN10_GA1[] = {
     S390_FEAT_EDAT,
     S390_FEAT_CONFIGURATION_TOPOLOGY,
+    S390_FEAT_CPU_TOPOLOGY,
     S390_FEAT_GROUP_MSA_EXT_2,
     S390_FEAT_ESOP,
     S390_FEAT_SIE_PFMFI,
@@ -604,6 +605,8 @@ static uint16_t default_GEN9_GA1[] = {
 static uint16_t default_GEN10_GA1[] = {
     S390_FEAT_EDAT,
     S390_FEAT_GROUP_MSA_EXT_2,
+    S390_FEAT_CONFIGURATION_TOPOLOGY,
+    S390_FEAT_CPU_TOPOLOGY,
 };
 
 #define default_GEN10_GA2 EmptyFeat
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index c17e92fc9c..6ffc697b51 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -612,6 +612,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     } else {
         /* prefix is only supported via sync regs */
     }
+
     return 0;
 }
 
@@ -2427,6 +2428,10 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
         clear_bit(S390_FEAT_CMM_NT, model->features);
     }
 
+    if (kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
+        set_bit(S390_FEAT_CPU_TOPOLOGY, model->features);
+    }
+
     /* bpb needs kernel support for migration, VSIE and reset */
     if (!kvm_check_extension(kvm_state, KVM_CAP_S390_BPB)) {
         clear_bit(S390_FEAT_BPB, model->features);
@@ -2535,6 +2540,7 @@ void kvm_s390_apply_cpu_model(const S390CPUModel *model, Error **errp)
         error_setg(errp, "KVM: Error configuring CPU subfunctions: %d", rc);
         return;
     }
+
     /* enable CMM via CMMA */
     if (test_bit(S390_FEAT_CMM, model->features)) {
         kvm_s390_enable_cmma();
diff --git a/target/s390x/machine.c b/target/s390x/machine.c
index 37a076858c..6036e8e856 100644
--- a/target/s390x/machine.c
+++ b/target/s390x/machine.c
@@ -250,6 +250,53 @@ const VMStateDescription vmstate_diag318 = {
     }
 };
 
+static int cpu_topology_presave(void *opaque)
+{
+    S390CPU *cpu = opaque;
+
+    cpu->env.using_ptf = s390_has_feat(S390_FEAT_CPU_TOPOLOGY);
+    return 0;
+}
+
+static int cpu_topology_postload(void *opaque, int version_id)
+{
+    S390CPU *cpu = opaque;
+
+    if ((cpu->env.using_ptf == s390_has_feat(S390_FEAT_CPU_TOPOLOGY)) &&
+        (cpu->env.using_ptf == s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY))) {
+        return 0;
+    }
+    if (cpu->env.using_ptf) {
+        error_report("Target needs CPU Topology enabled");
+    } else {
+        if (s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+            error_report("Target is not allowed to enable configuration Topology");
+        }
+        if (s390_has_feat(S390_FEAT_CPU_TOPOLOGY)) {
+            error_report("Target is not allowed to enable CPU Topology");
+        }
+    }
+    return -EINVAL;
+}
+
+static bool cpu_topology_needed(void *opaque)
+{
+    return 1;
+}
+
+const VMStateDescription vmstate_cpu_topology = {
+    .name = "cpu/cpu_topology",
+    .version_id = 1,
+    .pre_save = cpu_topology_presave,
+    .post_load = cpu_topology_postload,
+    .minimum_version_id = 1,
+    .needed = cpu_topology_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_BOOL(env.using_ptf, S390CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 const VMStateDescription vmstate_s390_cpu = {
     .name = "cpu",
     .post_load = cpu_post_load,
@@ -287,6 +334,7 @@ const VMStateDescription vmstate_s390_cpu = {
         &vmstate_bpbc,
         &vmstate_etoken,
         &vmstate_diag318,
+        &vmstate_cpu_topology,
         NULL
     },
 };
-- 
2.27.0

