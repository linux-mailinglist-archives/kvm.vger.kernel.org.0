Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BF22B4392
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgKPMUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:20:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729933AbgKPMUk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 07:20:40 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGC1UdC024953;
        Mon, 16 Nov 2020 07:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VNrSzwXlIs1GJ3IrKrrWJiVtMsGpmbn/qA5egjFTdW8=;
 b=iuuhzgMsFcaHjAqOhRxbMs5Cjci7/8DedpCHThx4tEqMi4JjyjcT25OjuI+wfh5mg0lQ
 usCv/aBTtaOOfhPVOze6nCbfJfdLzh5NaAmuFIyVGmEgzyFlIm5MYyjnl6x5iSB6W1Rs
 sCR7qUvW9uTm8V6nb3Cr/6bc7ip0ZU7kEk4c/NLxB9lp5jEEdH8Kp9d2dKUdf4yBgUnV
 QVYpss+bYKEbG7R7Qb/GadNwt6CJl4B0RBMCTqax3YYn4o4Zcm62aJrJgslBMH3q3gGo
 N41CjBIwwsUYcvkx7Xx5AKZtxbqmNmQWCd6mNP11X3H08YFZGaah2eq4e+3NBiKpoDPu wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uhy02ms5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 07:20:40 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AGC1f30026223;
        Mon, 16 Nov 2020 07:20:39 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uhy02mra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 07:20:39 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGCC8Y5009575;
        Mon, 16 Nov 2020 12:20:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 34t6v891pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 12:20:37 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGCKYPA6750948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 12:20:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4627B11C04C;
        Mon, 16 Nov 2020 12:20:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 326BA11C04A;
        Mon, 16 Nov 2020 12:20:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 16 Nov 2020 12:20:34 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E8011E0367; Mon, 16 Nov 2020 13:20:33 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: [GIT PULL 1/2] KVM: s390: pv: Mark mm as protected after the set secure parameters and improve cleanup
Date:   Mon, 16 Nov 2020 13:20:32 +0100
Message-Id: <20201116122033.382372-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201116122033.382372-1-borntraeger@de.ibm.com>
References: <20201116122033.382372-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_03:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015 adultscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011160069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We can only have protected guest pages after a successful set secure
parameters call as only then the UV allows imports and unpacks.

By moving the test we can now also check for it in s390_reset_acc()
and do an early return if it is 0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 29b40f105ec8 ("KVM: s390: protvirt: Add initial vm and cpu lifecycle handling")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 arch/s390/kvm/pv.c       | 3 ++-
 arch/s390/mm/gmap.c      | 2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..08ea6c4735cd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2312,7 +2312,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		struct kvm_s390_pv_unp unp = {};
 
 		r = -EINVAL;
-		if (!kvm_s390_pv_is_protected(kvm))
+		if (!kvm_s390_pv_is_protected(kvm) || !mm_is_protected(kvm->mm))
 			break;
 
 		r = -EFAULT;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index eb99e2f95ebe..f5847f9dec7c 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -208,7 +208,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
-	atomic_set(&kvm->mm->context.is_protected, 1);
 	return 0;
 }
 
@@ -228,6 +227,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		     *rc, *rrc);
+	if (!cc)
+		atomic_set(&kvm->mm->context.is_protected, 1);
 	return cc ? -EINVAL : 0;
 }
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index cfb0017f33a7..64795d034926 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2690,6 +2690,8 @@ static const struct mm_walk_ops reset_acc_walk_ops = {
 #include <linux/sched/mm.h>
 void s390_reset_acc(struct mm_struct *mm)
 {
+	if (!mm_is_protected(mm))
+		return;
 	/*
 	 * we might be called during
 	 * reset:                             we walk the pages and clear
-- 
2.28.0

