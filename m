Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBAAB14EA63
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 11:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgAaKCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 05:02:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728351AbgAaKCX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 05:02:23 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00V9vg3w047182
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 05:02:22 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvfy8vnkj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 05:02:21 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 31 Jan 2020 10:02:18 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 10:02:15 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VA2Fkl48627912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 10:02:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E84C311C04C;
        Fri, 31 Jan 2020 10:02:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 879C011C050;
        Fri, 31 Jan 2020 10:02:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.11.63])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jan 2020 10:02:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
Subject: [PATCH v10 2/6] KVM: s390: Cleanup initial cpu reset
Date:   Fri, 31 Jan 2020 05:02:01 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131100205.74720-1-frankja@linux.ibm.com>
References: <20200131100205.74720-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013110-4275-0000-0000-0000039CBB93
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013110-4276-0000-0000-000038B0DBF0
Message-Id: <20200131100205.74720-3-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_02:2020-01-30,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=1 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code seems to be quite old and uses lots of unneeded spaces for
alignment, which doesn't really help with readability.

Let's:
* Get rid of the extra spaces
* Remove the ULs as they are not needed on 0s
* Define constants for the CR 0 and 14 initial values
* Use the sizeof of the gcr array to memset it to 0

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 arch/s390/include/asm/kvm_host.h |  5 +++++
 arch/s390/kvm/kvm-s390.c         | 18 +++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 02f4c21c57f6..73044545ecac 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -122,6 +122,11 @@ struct mcck_volatile_info {
 	__u32 reserved;
 };
 
+#define CR0_INITIAL_MASK (CR0_UNUSED_56 | CR0_INTERRUPT_KEY_SUBMASK | \
+			  CR0_MEASUREMENT_ALERT_SUBMASK)
+#define CR14_INITIAL_MASK (CR14_UNUSED_32 | CR14_UNUSED_33 | \
+			   CR14_EXTERNAL_DAMAGE_SUBMASK)
+
 #define CPUSTAT_STOPPED    0x80000000
 #define CPUSTAT_WAIT       0x10000000
 #define CPUSTAT_ECALL_PEND 0x08000000
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 876802894b35..bb072866bd69 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2847,19 +2847,15 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
 {
 	/* this equals initial cpu reset in pop, but we don't switch to ESA */
-	vcpu->arch.sie_block->gpsw.mask = 0UL;
-	vcpu->arch.sie_block->gpsw.addr = 0UL;
+	vcpu->arch.sie_block->gpsw.mask = 0;
+	vcpu->arch.sie_block->gpsw.addr = 0;
 	kvm_s390_set_prefix(vcpu, 0);
 	kvm_s390_set_cpu_timer(vcpu, 0);
-	vcpu->arch.sie_block->ckc       = 0UL;
-	vcpu->arch.sie_block->todpr     = 0;
-	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
-	vcpu->arch.sie_block->gcr[0]  = CR0_UNUSED_56 |
-					CR0_INTERRUPT_KEY_SUBMASK |
-					CR0_MEASUREMENT_ALERT_SUBMASK;
-	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
-					CR14_UNUSED_33 |
-					CR14_EXTERNAL_DAMAGE_SUBMASK;
+	vcpu->arch.sie_block->ckc = 0;
+	vcpu->arch.sie_block->todpr = 0;
+	memset(vcpu->arch.sie_block->gcr, 0, sizeof(vcpu->arch.sie_block->gcr));
+	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
+	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
 	vcpu->run->s.regs.fpc = 0;
 	vcpu->arch.sie_block->gbea = 1;
 	vcpu->arch.sie_block->pp = 0;
-- 
2.20.1

