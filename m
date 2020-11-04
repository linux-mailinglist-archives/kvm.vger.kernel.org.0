Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26312A6C84
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 19:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732306AbgKDSLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 13:11:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730052AbgKDSLU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 13:11:20 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4IBIbm126539
        for <kvm@vger.kernel.org>; Wed, 4 Nov 2020 13:11:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=G8xuG92S8oL8aT+HGs+EKJ6b+qEWT49kDAyWabJeKmA=;
 b=AMAcMxAbWWwSZqpvYBEXSMUIMFyQBL32pFDksa1uhBr6UmCVAJ3vPKhJ/OjPxzdrQ4Zd
 lbBd9N5JJ+InZLz1WFxUuMzTWoMqbtyl8pUy38sa0p4DIYCHO/bbTAQzfL36WJZE0qUK
 4smaat17OjNL9mx18DIV+kezSYNcHR2QMVcEIuKnElZCci04f/X4Rt52RT/eV4bD7zXI
 5XfI2M2iShSlv2VRECtlk6/FDtLaIaNTrHefcOJZaf8C6hfkDmYTm5/RmhvmBNk2rk/q
 XO/i1SWEQdSuSrA8ZiSrlERKeRPIFOBfRE/gg5549FYb68yxjzGp0ysvGGMPc/Fe9rSW 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ksrurfgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 13:11:19 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A4IBIik126536
        for <kvm@vger.kernel.org>; Wed, 4 Nov 2020 13:11:18 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ksrurfcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 13:11:18 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A4I7rPp021911;
        Wed, 4 Nov 2020 18:11:04 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 34h0ej0bag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 18:11:04 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A4IB0KU66584996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Nov 2020 18:11:01 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E161EC6055;
        Wed,  4 Nov 2020 18:11:00 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E515C6057;
        Wed,  4 Nov 2020 18:11:00 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.157.224])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  4 Nov 2020 18:11:00 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, frankja@linux.ibm.com,
        borntraeger@de.ibm.com
Subject: [PATCH] s390/kvm: remove diag318 reset code
Date:   Wed,  4 Nov 2020 13:10:32 -0500
Message-Id: <20201104181032.109800-1-walling@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_12:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=948 mlxscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=13 adultscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The diag318 data must be set to 0 by VM-wide reset events
triggered by diag308. As such, KVM should not handle
resetting this data via the VCPU ioctls.

Fixes: 23a60f834406 (s390/kvm: diagnose 0x318 sync and reset)
Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..f9e118a0e113 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3564,7 +3564,6 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->pp = 0;
 		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
 		vcpu->arch.sie_block->todpr = 0;
-		vcpu->arch.sie_block->cpnc = 0;
 	}
 }
 
@@ -3582,7 +3581,6 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
 
 	regs->etoken = 0;
 	regs->etoken_extension = 0;
-	regs->diag318 = 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
-- 
2.26.2

