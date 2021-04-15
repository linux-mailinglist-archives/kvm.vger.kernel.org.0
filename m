Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648993603CE
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 10:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhDOIB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 04:01:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230190AbhDOIB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 04:01:56 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13F7XvQ5152102;
        Thu, 15 Apr 2021 04:01:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Iy+4HEBSF+6Bj1MzBbaPvov+Xtf3UDKQhBpPJ8i7LDw=;
 b=re0aowbxXwZsu8Y6GwmjiH+iLQxFENxjcoYfAuplBPNLiaWDQDxy2EzikGqbeYtOqMsw
 zdshtgZPPiyXjHygi+VG2tRBAQEHWvxDcKcV8ZDs7hufE0EmciNA5TnUBmk17YmN7i45
 yb7hLkwOAcCgIvVafsRwfURLXEDBsZFbNyw1a4Jm6hZy+A31XEFWK8v9RJ2ct+WycGrx
 AlOqZRMkBWUkw8PMH1ar6d9eBtcxaTNKsoXxLsOqrQ4Pv82GlCCYSWpsEuL7M0v8aUl4
 qdH7b8440+wqy1x/Q7R2chaO7brmYyKmwAstLDjx3XI5sfVYa11762mFBxF7RcdkS8v5 EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x13v8w1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 04:01:33 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13F7YPS0153929;
        Thu, 15 Apr 2021 04:01:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x13v8w0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 04:01:33 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13F7qMaL030873;
        Thu, 15 Apr 2021 08:01:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37u3n8uqum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 08:01:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13F815wT22479228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 08:01:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60FD111C06E;
        Thu, 15 Apr 2021 08:01:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C91011C064;
        Thu, 15 Apr 2021 08:01:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Apr 2021 08:01:27 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: fix guarded storage control register handling
Date:   Thu, 15 Apr 2021 10:01:27 +0200
Message-Id: <20210415080127.1061275-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oW4X9HK-9CKK23m1Mb8WhFHrZfpUPmTT
X-Proofpoint-ORIG-GUID: hLD123nSDLfmqXYS4Ky0LkkimoaxWHCY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_03:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=624
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104150049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

store_regs_fmt2() has an ordering problem: first the guarded storage
facility is enabled on the local cpu, then preemption disabled, and
then the STGSC (store guarded storage controls) instruction is
executed.

If the process gets scheduled away between enabling the guarded
storage facility and before preemption is disabled, this might lead to
a special operation exception and therefore kernel crash as soon as
the process is scheduled back and the STGSC instruction is executed.

Fixes: 4e0b1ab72b8a ("KVM: s390: gs support for kvm guests")
Cc: <stable@vger.kernel.org> # 4.12
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2f09e9d7dc95..24ad447e648c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4307,16 +4307,16 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu)
 	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
 	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
 	if (MACHINE_HAS_GS) {
+		preempt_disable();
 		__ctl_set_bit(2, 4);
 		if (vcpu->arch.gs_enabled)
 			save_gs_cb(current->thread.gs_cb);
-		preempt_disable();
 		current->thread.gs_cb = vcpu->arch.host_gscb;
 		restore_gs_cb(vcpu->arch.host_gscb);
-		preempt_enable();
 		if (!vcpu->arch.host_gscb)
 			__ctl_clear_bit(2, 4);
 		vcpu->arch.host_gscb = NULL;
+		preempt_enable();
 	}
 	/* SIE will save etoken directly into SDNX and therefore kvm_run */
 }
-- 
2.25.1

