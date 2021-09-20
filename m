Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA1E41159B
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbhITN1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:27:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239457AbhITN0o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:44 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD6j1004069;
        Mon, 20 Sep 2021 09:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MKriC/PBltPAZFD/lZSgxC9o/TZajfZQswLOFV2NfWw=;
 b=ZEqzTPbzyjO5mIZmkxodoyF+WiB2x+6/kSIPz1S7Aoqs+S/krTEG6LJ6t9hUV0L4kb2u
 aBqD7yUHIvLchjMJC6UaDaQuAhHveWtUMnpr0RZRRYSbScfzuDN98DGCUg2zNN3JXwHA
 LHcEK7SoC6kT3bm/fZlEx1s3FRLE8K/kGcopR7Rm3b6msQJBo7YU/drQFWOo9UENlLLv
 ufcyeoacTDhyluWe+CiwmwUkH0CJ0/skdySzzaaQA6gObsBFwB4+D1u87iFGuMetJZZc
 ZwT9wBHLYs1YzBLFOXrX+hzj5jbwnnvWyaP8xt/x+/2REp+q/laVYFVM6gHBo600SMQJ pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5w06t5u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:16 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDEsP5013817;
        Mon, 20 Sep 2021 09:25:16 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5w06t5sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:16 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD6h8031002;
        Mon, 20 Sep 2021 13:25:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b57cj86t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:25:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDKN8o58524084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:20:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5336A4051;
        Mon, 20 Sep 2021 13:25:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 796ACA4055;
        Mon, 20 Sep 2021 13:25:08 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.9.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:25:08 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v5 10/14] KVM: s390: pv: usage counter instead of flag
Date:   Mon, 20 Sep 2021 15:24:58 +0200
Message-Id: <20210920132502.36111-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920132502.36111-1-imbrenda@linux.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1NuuoL8kp1vzUmuwvw7uU4a201NEJI9J
X-Proofpoint-GUID: Gi-zqc3h8ihWo6DEb6rstKtb6e3RXudb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the is_protected field as a counter instead of a flag. This will
be used in upcoming patches.

Increment the counter when a secure configuration is created, and
decrement it when it is destroyed. Previously the flag was set when the
set secure parameters UVC was performed.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/mmu.h         |  2 +-
 arch/s390/include/asm/mmu_context.h |  2 +-
 arch/s390/include/asm/pgtable.h     |  2 +-
 arch/s390/kvm/pv.c                  | 12 +++++++-----
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index e12ff0f29d1a..2c4cbc254604 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -17,7 +17,7 @@ typedef struct {
 	unsigned long asce_limit;
 	unsigned long vdso_base;
 	/* The mmu context belongs to a secure guest. */
-	atomic_t is_protected;
+	atomic_t protected_count;
 	/*
 	 * The following bitfields need a down_write on the mm
 	 * semaphore when they are written to. As they are only
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index c7937f369e62..2a38af5a00c2 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -26,7 +26,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	INIT_LIST_HEAD(&mm->context.gmap_list);
 	cpumask_clear(&mm->context.cpu_attach_mask);
 	atomic_set(&mm->context.flush_count, 0);
-	atomic_set(&mm->context.is_protected, 0);
+	atomic_set(&mm->context.protected_count, 0);
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
 #ifdef CONFIG_PGSTE
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 0f1af2232ebe..5d06b6befb1f 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -523,7 +523,7 @@ static inline int mm_has_pgste(struct mm_struct *mm)
 static inline int mm_is_protected(struct mm_struct *mm)
 {
 #ifdef CONFIG_PGSTE
-	if (unlikely(atomic_read(&mm->context.is_protected)))
+	if (unlikely(atomic_read(&mm->context.protected_count)))
 		return 1;
 #endif
 	return 0;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 47db80003ea0..eb13382c3d36 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -173,7 +173,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
-	atomic_set(&kvm->mm->context.is_protected, 0);
+	if (!cc)
+		atomic_dec(&kvm->mm->context.protected_count);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
 	/* Intended memory leak on "impossible" error */
@@ -214,11 +215,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
+	atomic_inc(&kvm->mm->context.protected_count);
 	if (cc) {
-		if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
+		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
 			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
-		else
+		} else {
+			atomic_dec(&kvm->mm->context.protected_count);
 			kvm_s390_pv_dealloc_vm(kvm);
+		}
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
@@ -241,8 +245,6 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		     *rc, *rrc);
-	if (!cc)
-		atomic_set(&kvm->mm->context.is_protected, 1);
 	return cc ? -EINVAL : 0;
 }
 
-- 
2.31.1

