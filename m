Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8F7440E26
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhJaMN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231931AbhJaMNr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:47 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VC7lW0030963;
        Sun, 31 Oct 2021 12:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=hvMyYgSWH95gJtWWAAXwKbaVE9ClUbW8L+NxnBAJQnc=;
 b=i+eHRVoy/q9oYtNb5nd8CE17gsHs0MCmPoPeEwPq1RiRXj/pSGAwQFceJ73R+gWmTKqU
 85VxIeHAUGSCRH6gQ6vOP31RDMcCf43VDoqzVg25VxKM/oBZgsyM2LzmAQX78AHhbOS3
 sfhYp/gpgvZ0U92UT8etXs2UOJaI/YQtYf6oJ8BSFJ/we3tvd+3wCZMXzkgXy8C1RoaR
 APRXx0r0QnhJb9cN9xTrtOrZmB3bZTtd35SsrnCLZ+27PDyAjeJZBvOeKnZ5ywfl8qWx
 nPZDKwkXO+6JOtqpH44KFOCHHAhVh7qZVHmLeJeJMuN8xdWhIcKVCA8o8fZYqVZUwTtQ AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1tk2g5us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:15 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VCBFtB014416;
        Sun, 31 Oct 2021 12:11:15 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1tk2g5ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC8udD023607;
        Sun, 31 Oct 2021 12:11:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3c0wahw9hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VC4oHV64225730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:04:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6ABF4C04E;
        Sun, 31 Oct 2021 12:11:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3D284C04A;
        Sun, 31 Oct 2021 12:11:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 6840BE056B; Sun, 31 Oct 2021 13:11:09 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 14/17] KVM: s390: Add a routine for setting userspace CPU state
Date:   Sun, 31 Oct 2021 13:11:01 +0100
Message-Id: <20211031121104.14764-15-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0HTbQKD3vk09LqMbU7h79ZzWTO68PIdH
X-Proofpoint-ORIG-GUID: yQzjwgvJi0c_s2u4OxKmoCISSHDoRfnK
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=982
 priorityscore=1501 spamscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

This capability exists, but we don't record anything when userspace
enables it. Let's refactor that code so that a note can be made in
the debug logs that it was enabled.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20211008203112.1979843-7-farman@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 6 +++---
 arch/s390/kvm/kvm-s390.h | 9 +++++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1c97493d21e1..6482ea9139bb 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2487,8 +2487,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_S390_PV_COMMAND: {
 		struct kvm_pv_cmd args;
 
-		/* protvirt means user sigp */
-		kvm->arch.user_cpu_state_ctrl = 1;
+		/* protvirt means user cpu state */
+		kvm_s390_set_user_cpu_state_ctrl(kvm);
 		r = 0;
 		if (!is_prot_virt_host()) {
 			r = -EINVAL;
@@ -3802,7 +3802,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	vcpu_load(vcpu);
 
 	/* user space knows about this interface - let it control the state */
-	vcpu->kvm->arch.user_cpu_state_ctrl = 1;
+	kvm_s390_set_user_cpu_state_ctrl(vcpu->kvm);
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_STOPPED:
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 52bc8fbaa60a..c07a050d757d 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -208,6 +208,15 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+static inline void kvm_s390_set_user_cpu_state_ctrl(struct kvm *kvm)
+{
+	if (kvm->arch.user_cpu_state_ctrl)
+		return;
+
+	VM_EVENT(kvm, 3, "%s", "ENABLE: Userspace CPU state control");
+	kvm->arch.user_cpu_state_ctrl = 1;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
-- 
2.31.1

