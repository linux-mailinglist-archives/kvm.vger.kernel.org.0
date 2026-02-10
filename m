Return-Path: <kvm+bounces-70756-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YO7NOCxRi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70756-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D51511C9E6
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 39ED530ACCAC
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514A538B7A1;
	Tue, 10 Feb 2026 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lEnLD6xH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F7038552E;
	Tue, 10 Feb 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737689; cv=none; b=K9up3oP3Z/BlmbRmcRQTEbU9LpAKGEoyZJ+c+pzQSX9+gAqAQ9g/plNWDGWea2I42lr/G3VfLT6eJWawmZg28U9fW7LbBLsQlghHsq0Ii/EkQvfr+OA5wqDlNghmOTGBBRXyKU+q2BKlCirThu1MZ/mrGTKigUWE4f1eVgwVNZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737689; c=relaxed/simple;
	bh=F43NrvMo2jtfKQSeST+PpKN2TQyHYs2MiOv3EBqaDb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9hVBLSNVCtxM3dU3dPieOjCCFtGw7AwiNITMb+jvfxElbZb9Ggr2No1nPp7FOKTGpVPlo7hOdcOyKEP029PBoih/HxVAW+GS/OE1MsDGwDiSPN9g6JoqRt5Bz1DEStel1HlcCCBLItnvDcYWcpYj18np2qquf7/Y/qIJhwFMTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lEnLD6xH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ACM8Pn868900;
	Tue, 10 Feb 2026 15:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xvOrwa3owCKOVex8Y
	Hs2XtOiWQi32yPWQZuTYXXfILA=; b=lEnLD6xHis+XDuxfgTPL+82EMZZJKMY8n
	NQxXBTOd5OaOdnQ5HaMmQJHO1OsIMmhQLZZO/3lqgPUWBOkNER/kXuxLycE8PAZu
	3EATx9MF2TDtojLwuyh2FZa87TBYSByZZH4ob4Qi+/DvNffeNbK4yxmmuI/Mur/N
	MPcYa0tOhYt/EEgtS0GiVD+E/PBdfag+RxioxYW3lbB1s5f7FOIQRonwzijhFGzu
	SulgVn+vmMM/MPJN1iH7z+YeE/MnbVE/Xxbr26a+JClBuRK7NBfQc3ica9eoHyCq
	LUBK5GIQiu9XE+QvWCjYDlKAHJOGFdMBNyhTiO+S2OgE7pzbcG5XQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v2qm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AFLZav019225;
	Tue, 10 Feb 2026 15:34:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk1nwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYYa259375926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCDB920040;
	Tue, 10 Feb 2026 15:34:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BEBA20043;
	Tue, 10 Feb 2026 15:34:34 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:34 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 29/36] KVM: s390: Storage key manipulation IOCTL
Date: Tue, 10 Feb 2026 16:34:10 +0100
Message-ID: <20260210153417.77403-30-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qyx8BxZqBuelVDrWzCHWHfN6yTTUYksf
X-Proofpoint-ORIG-GUID: qyx8BxZqBuelVDrWzCHWHfN6yTTUYksf
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698b500f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=jVMGocEsZ36WJnCjVsIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXwNCtivzhiX8/
 tHgE2sW8lbr01w8RqUcCrG/cYKYcEsr7WN6E7y7hpXit0lXvUIL3i1NC572PyQuHWxG+RGFwJ7v
 l882YrXOrUpnd8tYwhPPCDFNkcdGQDm9Y9a8VSM92tL7IYM68YWLCiLJ9OehyUbUOM67XrbT7V4
 4CakXDRKgrXmLtjpr0NmnkfMbKibp3mo4u9vtl+dv1fjJ00lArCoPsiW0INqwlmjGthuvuaNCKp
 TN2bnFRsbatGMiKIFDinJepsRizQw0UOsZtAv4SIH+GR/lH/MwPrOY7+x/FbuD++IluuJCJfbcF
 Kr/UgG1Q1UWWRWviub5zdpLVYeFioHu7neyRAqhhdgViKTuXTJMAvprZv8AIYO2u3lWBmmo2K7C
 ElmIxRFLPyaUrJy2Y82z+vWaHJvJaU4Hye7fSbEOYN9W/lXVEfgVuSNn5jMeik2UGWnGFIjCdIl
 UTasKhXkPGW/IW7E+5w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70756-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 7D51511C9E6
X-Rspamd-Action: no action

Add a new IOCTL to allow userspace to manipulate storage keys directly.

This will make it easier to write selftests related to storage keys.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
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
2.53.0


