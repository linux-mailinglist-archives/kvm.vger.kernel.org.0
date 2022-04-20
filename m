Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A0F50870D
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378127AbiDTLeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378124AbiDTLeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:34:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9885A20BD7;
        Wed, 20 Apr 2022 04:31:21 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KADYdP021218;
        Wed, 20 Apr 2022 11:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZtKAM9AOOI2DcM0EajgkYHgUsNEuN1o+fNMaKSspwzA=;
 b=QyGlMtIB4q7MZyii1SRCqpvUUlf/7St9DIubXw9BU4exky8SpVeffD5zS2HJ9b9t9Y1I
 /DjZwOOB6PFVzSh94HXqnF8Xujl3BLS2jLZ50yHHZF/RqEefGjj3Yun80jG+UiNP3LuJ
 GPlOCajL6LS/SuAfyPF/Tvvi5fxi76RpMtj2wn7rXvdxYu7HsdrQ7L9hbaDQmea8+Yiv
 3dVg4IsUdgaazIv69f2OrU8FvxvModbjl3wrVH4uvzj+inoXlpyI7LsfJvxUpis6GA1+
 2kLKznVYD4z2SpYeLPwM849hvCp9OHYeNiIc4dMwb77pT/k4+ZvOc2gS7qLbCL8CyYEo lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhyqdwvq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:31:21 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBFNKv028514;
        Wed, 20 Apr 2022 11:31:20 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fhyqdwvp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:31:20 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBS00i018268;
        Wed, 20 Apr 2022 11:31:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3ffn2hvw1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:31:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBVFdF33816832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:31:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E126F5204F;
        Wed, 20 Apr 2022 11:31:14 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 356315205A;
        Wed, 20 Apr 2022 11:31:14 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 1/2] s390x: KVM: guest support for topology function
Date:   Wed, 20 Apr 2022 13:34:29 +0200
Message-Id: <20220420113430.11876-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420113430.11876-1-pmorel@linux.ibm.com>
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U3j92ejWWyrnikEu01trUdLDdHESxDDk
X-Proofpoint-ORIG-GUID: A5OHq7Osn9VucgxWEad-mEOItOXqVmRq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We let the userland hypervisor know if the machine support the CPU
topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.

The PTF instruction will report a topology change if there is any change
with a previous STSI_15_1_2 SYSIB.
Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
inside the CPU Topology List Entry CPU mask field, which happens with
changes in CPU polarization, dedication, CPU types and adding or
removing CPUs in a socket.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry of the guest's
SCA which will be cleared during the interpretation of PTF.

To check if the topology has been modified we use a new field of the
arch vCPU to save the previous real CPU ID at the end of a schedule
and verify on next schedule that the CPU used is in the same socket.
We do not report polarization, CPU Type or dedication change.

STSI(15.1.x) gives information on the CPU configuration topology.
Let's accept the interception of STSI with the function code 15 and
let the userland part of the hypervisor handle it when userland
support the CPU Topology facility.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst   | 16 +++++++
 arch/s390/include/asm/kvm_host.h | 12 ++++--
 arch/s390/kvm/kvm-s390.c         | 74 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         | 25 +++++++++++
 arch/s390/kvm/priv.c             | 14 ++++--
 arch/s390/kvm/vsie.c             |  3 ++
 include/uapi/linux/kvm.h         |  1 +
 7 files changed, 137 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85c7abc51af5..3499bc8d205e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7769,3 +7769,19 @@ Ordering of KVM_GET_*/KVM_SET_* ioctls
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 TBD
+
+8.17 KVM_CAP_S390_CPU_TOPOLOGY
+------------------------------
+
+:Capability: KVM_CAP_S390_CPU_TOPOLOGY
+:Architectures: s390
+:Type: vm
+
+This capability indicates that kvm will provide the S390 CPU Topology facility
+which consist of the interpretation of the PTF instruction for the Function
+Code 2 along with interception and forwarding of both the PTF instruction
+with Function Codes 0 or 1 and the STSI(15,1,x) instruction to the userland
+hypervisor.
+
+The stfle facility 11, CPU Topology facility, should not be provided to the
+guest without this capability.
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 766028d54a3e..04653b43ccee 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -97,15 +97,19 @@ struct bsca_block {
 	union ipte_control ipte_control;
 	__u64	reserved[5];
 	__u64	mcn;
-	__u64	reserved2;
+#define SCA_UTILITY_MTCR	0x8000
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
 
@@ -249,6 +253,7 @@ struct kvm_s390_sie_block {
 #define ECB_SPECI	0x08
 #define ECB_SRSI	0x04
 #define ECB_HOSTPROTINT	0x02
+#define ECB_PTF		0x01
 	__u8	ecb;			/* 0x0061 */
 #define ECB2_CMMA	0x80
 #define ECB2_IEP	0x20
@@ -750,6 +755,7 @@ struct kvm_vcpu_arch {
 	bool skey_enabled;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
+	int prev_cpu;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 156d1c25a3c1..925ccc59f283 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -606,6 +606,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		r = test_facility(11);
+		break;
 	default:
 		r = 0;
 	}
@@ -817,6 +820,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		icpt_operexc_on_all_vcpus(kvm);
 		r = 0;
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		r = -EINVAL;
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus) {
+			r = -EBUSY;
+		} else if (test_facility(11)) {
+			set_kvm_facility(kvm->arch.model.fac_mask, 11);
+			set_kvm_facility(kvm->arch.model.fac_list, 11);
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
+			 r ? "(not available)" : "(success)");
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -1695,6 +1712,50 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 	return ret;
 }
 
+/**
+ * kvm_s390_get_first_vcpu
+ * @kvm: guest KVM description
+ *
+ * returns the first online vcpu
+ */
+static struct kvm_vcpu *kvm_s390_get_first_vcpu(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		return vcpu;
+	return NULL;
+}
+
+/**
+ * kvm_s390_sca_set_mtcr
+ * @kvm: guest KVM description
+ *
+ * Is only relevant if the topology facility is present,
+ * the caller should check KVM facility 11
+ *
+ * Updates the Multiprocessor Topology-Change-Report to signal
+ * the guest with a topology change.
+ * Note that both bsca and esca have the utility half word at
+ * the same offset.
+ */
+static int kvm_s390_sca_set_mtcr(struct kvm *kvm)
+{
+	struct bsca_block *sca = kvm->arch.sca;
+	struct kvm_vcpu *vcpu;
+
+	vcpu = kvm_s390_get_first_vcpu(kvm);
+	if (!vcpu)
+		return -ENODEV;
+
+	ipte_lock(vcpu);
+	WRITE_ONCE(sca->utility, sca->utility | SCA_UTILITY_MTCR);
+	ipte_unlock(vcpu);
+
+	return 0;
+}
+
 static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
@@ -3138,16 +3199,20 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-
 	gmap_enable(vcpu->arch.enabled_gmap);
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
 		__start_cpu_timer_accounting(vcpu);
 	vcpu->cpu = cpu;
+
+	if (kvm_s390_topology_changed(vcpu))
+		kvm_s390_sca_set_mtcr(vcpu->kvm);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	/* Remember which CPU was backing the vCPU */
+	vcpu->arch.prev_cpu = vcpu->cpu;
 	vcpu->cpu = -1;
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
 		__stop_cpu_timer_accounting(vcpu);
@@ -3267,6 +3332,13 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
 	if (test_kvm_facility(vcpu->kvm, 9))
 		vcpu->arch.sie_block->ecb |= ECB_SRSI;
+
+	/* PTF needs guest facilities to enable interpretation */
+	if (test_kvm_facility(vcpu->kvm, 11))
+		vcpu->arch.sie_block->ecb |= ECB_PTF;
+	/* Indicate this is a new vcpu */
+	vcpu->arch.prev_cpu = S390_KVM_TOPOLOGY_NEW_CPU;
+
 	if (test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= ECB_TE;
 	if (!kvm_is_ucontrol(vcpu->kvm))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 497d52a83c78..897767652b5c 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -514,4 +514,29 @@ void kvm_s390_vcpu_crypto_reset_all(struct kvm *kvm);
  */
 extern unsigned int diag9c_forwarding_hz;
 
+#define S390_KVM_TOPOLOGY_NEW_CPU -1
+/**
+ * kvm_s390_topology_changed
+ * @vcpu: the virtual CPU
+ *
+ * If the topology facility is present, checks if the CPU toplogy
+ * viewed by the guest changed due to load balancing or CPU hotplug.
+ */
+static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
+{
+	if (!test_kvm_facility(vcpu->kvm, 11))
+		return false;
+
+	/* A new vCPU has been hotplugged */
+	if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
+		return true;
+
+	/* The real CPU backing up the vCPU moved to another socket */
+	if (cpumask_test_cpu(vcpu->cpu,
+			     topology_core_cpumask(vcpu->arch.prev_cpu)))
+		return true;
+
+	return false;
+}
+
 #endif
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 5beb7a4a11b3..5ab7173c3909 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -874,10 +874,12 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	if (fc > 3) {
-		kvm_s390_set_psw_cc(vcpu, 3);
-		return 0;
-	}
+	if (fc > 3 && fc != 15)
+		goto out_no_data;
+
+	/* fc 15 is provided with PTF/CPU topology support */
+	if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
+		goto out_no_data;
 
 	if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
 	    || vcpu->run->s.regs.gprs[1] & 0xffff0000)
@@ -911,6 +913,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
 		break;
+	case 15:
+		trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
+		insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
+		return -EREMOTE;
 	}
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index acda4b6fc851..da0397cf2cc7 100644
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
index 91a6fe4e02c0..9640cfa9a92a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_S390_CPU_TOPOLOGY 214
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.27.0

