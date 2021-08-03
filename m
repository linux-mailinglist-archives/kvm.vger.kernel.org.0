Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FD93DE862
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhHCI1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:27:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234549AbhHCI1G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:27:06 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173846e4089688;
        Tue, 3 Aug 2021 04:26:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7t+0kN2OAJDdPMsyKpyRdjIoxP3tWrlLLWw0H093qz0=;
 b=lZ9hOVMHTzbAvbIr/f6+6uqc88LTIKk5bgxftguONiM9H/cHi9C4SdiuR54qN0z1J+OK
 AipOI4R+uslsaO68/sH1I2IFyYcWy1SMgBNu4o5T+zHNHMvodRh/XKuw1jIXxNBWo3j2
 iWQu1Sc6HiUm1BfVDQshg9IyrKJEyooJnaPYbiyxQ8HlyC1XKiSHeKvr1n9dFvv5gXT9
 o5i5b033gRFbo/nDA5Z+la5BA+4/ZzhhAbiiaBzKPyRbfDsssOch+W3bEKeduJUI8Prd
 566h0qqH9EOhn0vPS9p1c1Sk3UzXP5KIoGu7w4hFdRYsXstlz2yhz0ON2R3oDOEh3iz9 fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a6f14rg2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:26:55 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17385NeB095043;
        Tue, 3 Aug 2021 04:26:55 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a6f14rg19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:26:55 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1738IASv007713;
        Tue, 3 Aug 2021 08:26:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3a4wshx0ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 08:26:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1738NrNo58786080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 08:23:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3442AA4053;
        Tue,  3 Aug 2021 08:26:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3F6EA405D;
        Tue,  3 Aug 2021 08:26:48 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.75.95])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Aug 2021 08:26:48 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v3 2/3] s390x: KVM: Implementation of Multiprocessor Topology-Change-Report
Date:   Tue,  3 Aug 2021 10:26:45 +0200
Message-Id: <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jEumUyR3XCzpaUewnpqqAIAbBuKlP9ss
X-Proofpoint-GUID: lo_xMhwT4LYgHQ9Yy8TO6z44fPfX1ID8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We let the userland hypervisor know if the machine support the CPU
topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.

The PTF instruction will report a topology change if there is any change
with a previous STSI_15_2 SYSIB.
Changes inside a STSI_15_2 SYSIB occur if CPU bits are set or clear
inside the CPU Topology List Entry CPU mask field, which happens with
changes in CPU polarization, dedication, CPU types and adding or
removing CPUs in a socket.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry of the guest's
SCA which will be cleared during the interpretation of PTF.

To check if the topology has been modified we use a new field of the
arch vCPU to save the previous real CPU ID at the end of a schedule
and verify on next schedule that the CPU used is in the same socket.

We deliberatly ignore:
- polarization: only horizontal polarization is currently used in linux.
- CPU Type: only IFL Type are supported in Linux
- Dedication: we consider that only a complete dedicated CPU stack can
  take benefit of the CPU Topology.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 14 +++++++---
 arch/s390/kvm/kvm-s390.c         | 48 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/vsie.c             |  3 ++
 include/uapi/linux/kvm.h         |  1 +
 4 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 9b4473f76e56..b7effdc96a7a 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -95,15 +95,19 @@ struct bsca_block {
 	union ipte_control ipte_control;
 	__u64	reserved[5];
 	__u64	mcn;
-	__u64	reserved2;
+#define ESCA_UTILITY_MTCR	0x8000
+	__u16	utility;
+	__u8	reserved2[6];
 	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
 };
 
 struct esca_block {
 	union ipte_control ipte_control;
-	__u64   reserved1[7];
+	__u64   reserved1[6];
+	__u16	utility;
+	__u8	reserved2[6];
 	__u64   mcn[4];
-	__u64   reserved2[20];
+	__u64   reserved3[20];
 	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
 };
 
@@ -228,7 +232,7 @@ struct kvm_s390_sie_block {
 	__u8	icptcode;		/* 0x0050 */
 	__u8	icptstatus;		/* 0x0051 */
 	__u16	ihcpu;			/* 0x0052 */
-	__u8	reserved54;		/* 0x0054 */
+	__u8	mtcr;			/* 0x0054 */
 #define IICTL_CODE_NONE		 0x00
 #define IICTL_CODE_MCHK		 0x01
 #define IICTL_CODE_EXT		 0x02
@@ -246,6 +250,7 @@ struct kvm_s390_sie_block {
 #define ECB_TE		0x10
 #define ECB_SRSI	0x04
 #define ECB_HOSTPROTINT	0x02
+#define ECB_PTF		0x01
 	__u8	ecb;			/* 0x0061 */
 #define ECB2_CMMA	0x80
 #define ECB2_IEP	0x20
@@ -747,6 +752,7 @@ struct kvm_vcpu_arch {
 	bool skey_enabled;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
+	int prev_cpu;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b655a7d82bf0..ff6d8a2b511c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -568,6 +568,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_VCPU_RESETS:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
+	case KVM_CAP_S390_CPU_TOPOLOGY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -819,6 +820,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		icpt_operexc_on_all_vcpus(kvm);
 		r = 0;
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus) {
+			r = -EBUSY;
+		} else {
+			set_kvm_facility(kvm->arch.model.fac_mask, 11);
+			set_kvm_facility(kvm->arch.model.fac_list, 11);
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
+			 r ? "(not available)" : "(success)");
+		break;
+
+		r = -EINVAL;
+		break;
+
 	default:
 		r = -EINVAL;
 		break;
@@ -3067,18 +3085,41 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
 	return value;
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void kvm_s390_set_mtcr(struct kvm_vcpu *vcpu)
 {
+	struct esca_block *esca = vcpu->kvm->arch.sca;
+
+	if (vcpu->arch.sie_block->ecb & ECB_PTF) {
+		ipte_lock(vcpu);
+		WRITE_ONCE(esca->utility, ESCA_UTILITY_MTCR);
+		ipte_unlock(vcpu);
+	}
+}
 
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
 	gmap_enable(vcpu->arch.enabled_gmap);
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
 		__start_cpu_timer_accounting(vcpu);
 	vcpu->cpu = cpu;
+
+	/*
+	 * With PTF interpretation the guest will be aware of topology
+	 * change by the Multiprocessor Topology-Change-Report is pending.
+	 * Check for reasons to make the MTCR pending and make it pending.
+	 */
+	if ((vcpu->arch.sie_block->ecb & ECB_PTF) &&
+	    cpu != vcpu->arch.prev_cpu) {
+		if (cpu_topology[cpu].socket_id !=
+		    cpu_topology[vcpu->arch.prev_cpu].socket_id)
+			kvm_s390_set_mtcr(vcpu);
+	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.prev_cpu = vcpu->cpu;
 	vcpu->cpu = -1;
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
 		__stop_cpu_timer_accounting(vcpu);
@@ -3198,6 +3239,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
 	if (test_kvm_facility(vcpu->kvm, 9))
 		vcpu->arch.sie_block->ecb |= ECB_SRSI;
+
+	/* PTF needs both host and guest facilities to enable interpretation */
+	if (test_kvm_facility(vcpu->kvm, 11) && test_facility(11))
+		vcpu->arch.sie_block->ecb |= ECB_PTF;
+
 	if (test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= ECB_TE;
 
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 4002a24bc43a..50d67190bf65 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -503,6 +503,9 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* Host-protection-interruption introduced with ESOP */
 	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
 		scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
+	/* CPU Topology */
+	if (test_kvm_facility(vcpu->kvm, 11))
+		scb_s->ecb |= scb_o->ecb & ECB_PTF;
 	/* transactional execution */
 	if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
 		/* remap the prefix is tx is toggled on */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..081ce0cd44b9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_S390_CPU_TOPOLOGY 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.1

