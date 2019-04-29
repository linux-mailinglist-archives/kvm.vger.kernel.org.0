Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D36DEB6
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfD2JKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:10:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727581AbfD2JKN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 05:10:13 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T99uuG078875
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:12 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s5vqjv2jr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:11 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 29 Apr 2019 10:10:10 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 10:10:06 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3T9A58g59113572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 09:10:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23BD64C050;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08F124C05C;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Apr 2019 09:10:04 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B57BC20F5D4; Mon, 29 Apr 2019 11:10:04 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 06/12] KVM: s390: add enhanced sort facilty to cpu model
Date:   Mon, 29 Apr 2019 11:09:56 +0200
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190429091002.71164-1-borntraeger@de.ibm.com>
References: <20190429091002.71164-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042909-0028-0000-0000-00000368691F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042909-0029-0000-0000-00002427C95B
Message-Id: <20190429091002.71164-7-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This enables stfle.150 and adds the subfunctions for SORTL. Bit 150 is
added to the list of facilities that will be enabled when there is no
cpu model involved as sortl requires no additional handling from
userspace, e.g. for migration.

Please note that a cpu model enabled user space can and will have the
final decision on the facility bits for a guests.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Collin Walling <walling@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/uapi/asm/kvm.h |  3 ++-
 arch/s390/kvm/kvm-s390.c         | 20 ++++++++++++++++++++
 arch/s390/tools/gen_facilities.c |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 09652eabe769..eba5bac08348 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -153,7 +153,8 @@ struct kvm_s390_vm_cpu_subfunc {
 	__u8 ppno[16];		/* with MSA5 */
 	__u8 kma[16];		/* with MSA8 */
 	__u8 kdsa[16];		/* with MSA9 */
-	__u8 reserved[1792];
+	__u8 sortl[32];		/* with STFLE.150 */
+	__u8 reserved[1760];
 };
 
 /* kvm attributes for crypto */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 336e591d94eb..757f76bba9ea 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -334,6 +334,8 @@ static inline void __insn32_query(unsigned int opcode, u8 query[32])
 		: "cc");
 }
 
+#define INSN_SORTL 0xb938
+
 static void kvm_s390_cpu_feat_init(void)
 {
 	int i;
@@ -385,6 +387,9 @@ static void kvm_s390_cpu_feat_init(void)
 		__cpacf_query(CPACF_KDSA, (cpacf_mask_t *)
 			      kvm_s390_available_subfunc.kdsa);
 
+	if (test_facility(150)) /* SORTL */
+		__insn32_query(INSN_SORTL, kvm_s390_available_subfunc.sortl);
+
 	if (MACHINE_HAS_ESOP)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ESOP);
 	/*
@@ -1351,6 +1356,11 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
 	VM_EVENT(kvm, 3, "SET: guest KDSA   subfunc 0x%16.16lx.%16.16lx",
 		 ((unsigned long *) &kvm->arch.model.subfuncs.kdsa)[0],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.kdsa)[1]);
+	VM_EVENT(kvm, 3, "SET: guest SORTL  subfunc 0x%16.16lx.%16.16lx.%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[0],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[1],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[2],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[3]);
 
 	return 0;
 }
@@ -1522,6 +1532,11 @@ static int kvm_s390_get_processor_subfunc(struct kvm *kvm,
 	VM_EVENT(kvm, 3, "GET: guest KDSA   subfunc 0x%16.16lx.%16.16lx",
 		 ((unsigned long *) &kvm->arch.model.subfuncs.kdsa)[0],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.kdsa)[1]);
+	VM_EVENT(kvm, 3, "GET: guest SORTL  subfunc 0x%16.16lx.%16.16lx.%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[0],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[1],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[2],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[3]);
 
 	return 0;
 }
@@ -1580,6 +1595,11 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
 	VM_EVENT(kvm, 3, "GET: host  KDSA   subfunc 0x%16.16lx.%16.16lx",
 		 ((unsigned long *) &kvm_s390_available_subfunc.kdsa)[0],
 		 ((unsigned long *) &kvm_s390_available_subfunc.kdsa)[1]);
+	VM_EVENT(kvm, 3, "GET: host  SORTL  subfunc 0x%16.16lx.%16.16lx.%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm_s390_available_subfunc.sortl)[0],
+		 ((unsigned long *) &kvm_s390_available_subfunc.sortl)[1],
+		 ((unsigned long *) &kvm_s390_available_subfunc.sortl)[2],
+		 ((unsigned long *) &kvm_s390_available_subfunc.sortl)[3]);
 
 	return 0;
 }
diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index e952cb3b75b2..1ec6bed785e8 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -93,6 +93,7 @@ static struct facility_def facility_defs[] = {
 			131, /* enhanced-SOP 2 and side-effect */
 			139, /* multiple epoch facility */
 			146, /* msa extension 8 */
+			150, /* enhanced sort */
 			155, /* msa extension 9 */
 			-1  /* END */
 		}
-- 
2.19.1

