Return-Path: <kvm+bounces-70230-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIvZHIljg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70230-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:19:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19149E849D
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 55E0A303BA54
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B13428471;
	Wed,  4 Feb 2026 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ErEOwL2X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75112426EB7;
	Wed,  4 Feb 2026 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217397; cv=none; b=ohhWb+2JZdaXCeazV9dSxqNUrAe3dy9CcuN85LBVk5XwwqAfVC9sbPMaZCPaz+5DraRojNDuxykRBn0FqPY3ovOALGK1dRpFNCGUAvHy6hFhCe5zrLuIVgYaZIIw+i6j3nPPbiXGboW0wj62FpYbFYzqd3//Y+iRHLxPMvNhAa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217397; c=relaxed/simple;
	bh=Vjj9x0om/TE5l/TnOuT6oFg8gd3mI14YxbuDYWY/aD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcXDjsiOhZgLyEDnT0alhYfwlAW5/KmQtTbNYi+o5SBkTzwe0WKe6CWyHbJ9gJz5dU0tlrAzTmOz+cmoIlgJEQ5ka3qt7zI4NL30Ay40jcm/JOiFUZse78VlO6GxOWvTwq9AKVsjVTR1l7MoHDzkVhWI07nFTwDvvymS1lOR8yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ErEOwL2X; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613MZQha024345;
	Wed, 4 Feb 2026 15:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xoow5PPmZXyqk0bxm
	kYGArhZeaNXf1UPw8ifuUMYBFw=; b=ErEOwL2X6PQADCiIVl30mwfUJPWTmOnSc
	1jaCymmZcmUg7/v29uIDuYWfFfFznrF5Ss2797RYg06b0tkDfLKMxkjG2bdpK2Ca
	wJ/rackoVD+Z+hqf1EVqBK62DLB36jqcbkzxpRwCwAZzEJYnMGPLzVYP8sM/1kmN
	S3nVuPSruh12IGaii8l4t2nnui4EQLSNjG9nYA6lvkvxlm0WoEBQnln6ZUtcrmQT
	UsckI58CDIlqOl2jXHJW2jIR5dgtSnMgvrqaNiFWYeZKv7ih3rTDQUDNtQnmERYS
	3SVKWNLkyi3ySDEhcd27DM0I3k8MnNQq5DC5sF8ex0lDqLnytHvwQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175n00fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614BYpMH029047;
	Wed, 4 Feb 2026 15:03:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1v2sdsq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F387U30474824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96B6120043;
	Wed,  4 Feb 2026 15:03:08 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55A2520040;
	Wed,  4 Feb 2026 15:03:08 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:08 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 28/29] KVM: s390: Storage key manipulation IOCTL
Date: Wed,  4 Feb 2026 16:02:57 +0100
Message-ID: <20260204150259.60425-29-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204150259.60425-1-imbrenda@linux.ibm.com>
References: <20260204150259.60425-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d0Q2CYolNDsfLQuLVl0ZONy5LoH9KwR2
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=69835fb1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=jVMGocEsZ36WJnCjVsIA:9
X-Proofpoint-GUID: d0Q2CYolNDsfLQuLVl0ZONy5LoH9KwR2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX0yBCghTj79AK
 Gc/0eudK07H+oByZhT/EWlm1lnEfgP3m66qM5oLn3GSDjiHVnBUSEGJbFBuja5fyaYImRSGLQnk
 olPstaThebGdwfg6xVhZrqCaL+CINB3qzbbmPEpu6cWMZYgVmC/Z5pACOe8I/5znAz21f9t4Tez
 NoPr8mXSyfgjFiiFb1rW1HzQJMpooWbU6WDi4md4Ri6tBgh3iN7DaN3CVrZeOiy7RwOmVOcfl1H
 7bEas1CAkdhxeCdIxsSOOhLtLJueHoDqClETYYdOui3vEriDM812Yv0d5IEEnehFL3Z04ok7Hg1
 PLyVOPS5qey5CwJepwfhU3QOw5DfmyKh6m07rP2mVEYSEfPCCQUDyQr+Se2BxWt7VBX+jL4HYA2
 MrJn7hXT/EAMmEo4B7cEp2jjI+SdKsNO7rPsSI8nqSlmCcr4ztyEGDawwW2edgr3gHyyb73yZ/Q
 UcyiyO39gXTx+Zoc4Zg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602040113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70230-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 19149E849D
X-Rspamd-Action: no action

Add a new IOCTL to allow userspace to manipulate storage keys directly.

This will make it easier to write selftests related to storage keys.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 42 ++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.c       | 58 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 11 +++++++
 3 files changed, 111 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..72e04dedb068 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6517,6 +6517,40 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_S390_KEYOP
+--------------------
+
+:Capability: KVM_CAP_S390_KEYOP
+:Architectures: s390
+:Type: vm ioctl
+:Parameters: struct kvm_s390_keyop (in/out)
+:Returns: 0 in case of success, < 0 on error
+
+The specified key operation is performed on the given guest address. The
+previous storage key (or the relevant part thereof) will be returned in
+`key`.
+
+::
+
+  struct kvm_s390_keyop {
+	__u64 guest_addr;
+	__u8  key;
+	__u8  operation;
+  };
+
+Currently supported values for ``operation``:
+
+KVM_S390_KEYOP_ISKE
+  Returns the storage key for the guest address ``guest_addr`` in ``key``.
+
+KVM_S390_KEYOP_RRBE
+  Resets the reference bit for the guest address ``guest_addr``, returning the
+  R and C bits of the old storage key in ``key``; the remaining fields of
+  the storage key will be set to 0.
+
+KVM_S390_KEYOP_SSKE
+  Sets the storage key for the guest address ``guest_addr`` to the key
+  specified in ``key``, returning the previous value in ``key``.
 
 .. _kvm_run:
 
@@ -9287,6 +9321,14 @@ The presence of this capability indicates that KVM_RUN will update the
 KVM_RUN_X86_GUEST_MODE bit in kvm_run.flags to indicate whether the
 vCPU was executing nested guest code when it exited.
 
+8.46 KVM_CAP_S390_KEYOP
+-----------------------
+
+:Architectures: s390
+
+The presence of this capability indicates that the KVM_S390_KEYOP ioctl is
+available.
+
 KVM exits with the register state of either the L1 or L2 guest
 depending on which executed at the time of an exit. Userspace must
 take care to differentiate between these cases.
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ac7b5f56f0b5..9f24252775dd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -554,6 +554,37 @@ static void __kvm_s390_exit(void)
 	debug_unregister(kvm_s390_dbf_uv);
 }
 
+static int kvm_s390_keyop(struct kvm_s390_mmu_cache *mc, struct kvm *kvm, int op,
+			  unsigned long addr, union skey skey)
+{
+	union asce asce = kvm->arch.gmap->asce;
+	gfn_t gfn = gpa_to_gfn(addr);
+	int r;
+
+	guard(read_lock)(&kvm->mmu_lock);
+
+	switch (op) {
+	case KVM_S390_KEYOP_SSKE:
+		r = dat_cond_set_storage_key(mc, asce, gfn, skey, &skey, 0, 0, 0);
+		if (r >= 0)
+			return skey.skey;
+		break;
+	case KVM_S390_KEYOP_ISKE:
+		r = dat_get_storage_key(asce, gfn, &skey);
+		if (!r)
+			return skey.skey;
+		break;
+	case KVM_S390_KEYOP_RRBE:
+		r = dat_reset_reference_bit(asce, gfn);
+		if (r > 0)
+			return r << 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return r;
+}
+
 /* Section: device related */
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
@@ -598,6 +629,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_DIAG318:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_S390_USER_OPEREXEC:
+	case KVM_CAP_S390_KEYOP:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -2931,6 +2963,32 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			r = -EFAULT;
 		break;
 	}
+	case KVM_S390_KEYOP: {
+		struct kvm_s390_mmu_cache *mc;
+		struct kvm_s390_keyop kop;
+		union skey skey;
+
+		if (copy_from_user(&kop, argp, sizeof(kop))) {
+			r = -EFAULT;
+			break;
+		}
+		skey.skey = kop.key;
+
+		mc = kvm_s390_new_mmu_cache();
+		if (!mc)
+			return -ENOMEM;
+
+		r = kvm_s390_keyop(mc, kvm, kop.operation, kop.guest_addr, skey);
+		kvm_s390_free_mmu_cache(mc);
+		if (r < 0)
+			break;
+
+		kop.key = r;
+		r = 0;
+		if (copy_to_user(argp, &kop, sizeof(kop)))
+			r = -EFAULT;
+		break;
+	}
 	case KVM_S390_ZPCI_OP: {
 		struct kvm_s390_zpci_op args;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..ab3d3d96e75f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -974,6 +974,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
+#define KVM_CAP_S390_KEYOP 247
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1219,6 +1220,15 @@ struct kvm_vfio_spapr_tce {
 	__s32	tablefd;
 };
 
+#define KVM_S390_KEYOP_ISKE 0x01
+#define KVM_S390_KEYOP_RRBE 0x02
+#define KVM_S390_KEYOP_SSKE 0x03
+struct kvm_s390_keyop {
+	__u64 guest_addr;
+	__u8  key;
+	__u8  operation;
+};
+
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
@@ -1238,6 +1248,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
+#define KVM_S390_KEYOP           _IOWR(KVMIO, 0x53, struct kvm_s390_keyop)
 
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
-- 
2.52.0


