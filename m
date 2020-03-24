Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F64190E13
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCXMuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:50:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727383AbgCXMuj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:50:39 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OCmiob073388
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 08:50:38 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywewu0nu8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 08:50:38 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 24 Mar 2020 12:50:34 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 12:50:30 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OCoVsE58065068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 12:50:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 872C042045;
        Tue, 24 Mar 2020 12:50:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DC0E42041;
        Tue, 24 Mar 2020 12:50:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 24 Mar 2020 12:50:31 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 285A9E149E; Tue, 24 Mar 2020 13:50:31 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: [GIT PULL 1/2] KVM: s390: Use fallthrough;
Date:   Tue, 24 Mar 2020 13:50:29 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324125030.323689-1-borntraeger@de.ibm.com>
References: <20200324125030.323689-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032412-0016-0000-0000-000002F6DAA8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032412-0017-0000-0000-0000335A7870
Message-Id: <20200324125030.323689-2-borntraeger@de.ibm.com>
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240065
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Perches <joe@perches.com>

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe@perches.com

Signed-off-by: Joe Perches <joe@perches.com>
Link: https://lore.kernel.org/r/d63c86429f3e5aa806aa3e185c97d213904924a5.1583896348.git.joe@perches.com
[borntrager@de.ibm.com: Fix link to tool and subject]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/gaccess.c   | 23 +++++++++++++----------
 arch/s390/kvm/interrupt.c |  2 +-
 arch/s390/kvm/kvm-s390.c  |  4 ++--
 arch/s390/mm/gmap.c       |  6 +++---
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 07d30ffcfa41..47a67a958107 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -505,7 +505,7 @@ static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 		switch (prot) {
 		case PROT_TYPE_IEP:
 			tec->b61 = 1;
-			/* FALL THROUGH */
+			fallthrough;
 		case PROT_TYPE_LA:
 			tec->b56 = 1;
 			break;
@@ -514,12 +514,12 @@ static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 			break;
 		case PROT_TYPE_ALC:
 			tec->b60 = 1;
-			/* FALL THROUGH */
+			fallthrough;
 		case PROT_TYPE_DAT:
 			tec->b61 = 1;
 			break;
 		}
-		/* FALL THROUGH */
+		fallthrough;
 	case PGM_ASCE_TYPE:
 	case PGM_PAGE_TRANSLATION:
 	case PGM_REGION_FIRST_TRANS:
@@ -534,7 +534,7 @@ static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 		tec->addr = gva >> PAGE_SHIFT;
 		tec->fsi = mode == GACC_STORE ? FSI_STORE : FSI_FETCH;
 		tec->as = psw_bits(vcpu->arch.sie_block->gpsw).as;
-		/* FALL THROUGH */
+		fallthrough;
 	case PGM_ALEN_TRANSLATION:
 	case PGM_ALE_SEQUENCE:
 	case PGM_ASTE_VALIDITY:
@@ -677,7 +677,7 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			dat_protection |= rfte.p;
 		ptr = rfte.rto * PAGE_SIZE + vaddr.rsx * 8;
 	}
-		/* fallthrough */
+		fallthrough;
 	case ASCE_TYPE_REGION2: {
 		union region2_table_entry rste;
 
@@ -695,7 +695,7 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			dat_protection |= rste.p;
 		ptr = rste.rto * PAGE_SIZE + vaddr.rtx * 8;
 	}
-		/* fallthrough */
+		fallthrough;
 	case ASCE_TYPE_REGION3: {
 		union region3_table_entry rtte;
 
@@ -723,7 +723,7 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			dat_protection |= rtte.fc0.p;
 		ptr = rtte.fc0.sto * PAGE_SIZE + vaddr.sx * 8;
 	}
-		/* fallthrough */
+		fallthrough;
 	case ASCE_TYPE_SEGMENT: {
 		union segment_table_entry ste;
 
@@ -1050,7 +1050,8 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
 		if (rc)
 			return rc;
-	} /* fallthrough */
+	}
+		fallthrough;
 	case ASCE_TYPE_REGION2: {
 		union region2_table_entry rste;
 
@@ -1076,7 +1077,8 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
 		if (rc)
 			return rc;
-	} /* fallthrough */
+	}
+		fallthrough;
 	case ASCE_TYPE_REGION3: {
 		union region3_table_entry rtte;
 
@@ -1111,7 +1113,8 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
 		if (rc)
 			return rc;
-	} /* fallthrough */
+	}
+		fallthrough;
 	case ASCE_TYPE_SEGMENT: {
 		union segment_table_entry ste;
 
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 028167d6eacd..8191106bf7b9 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -886,7 +886,7 @@ static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
 	case PGM_PRIMARY_AUTHORITY:
 	case PGM_SECONDARY_AUTHORITY:
 		nullifying = true;
-		/* fall through */
+		fallthrough;
 	case PGM_SPACE_SWITCH:
 		rc = put_guest_lc(vcpu, pgm_info.trans_exc_code,
 				  (u64 *)__LC_TRANS_EXC_CODE);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b1842a9feed..d590f32f13d3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3752,7 +3752,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		rc = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR_LOAD);
 		break;
 	case KVM_MP_STATE_CHECK_STOP:
-		/* fall through - CHECK_STOP and LOAD are not supported yet */
+		fallthrough;	/* CHECK_STOP and LOAD are not supported yet */
 	default:
 		rc = -ENXIO;
 	}
@@ -4985,7 +4985,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 					old->npages * PAGE_SIZE);
 		if (rc)
 			break;
-		/* FALLTHROUGH */
+		fallthrough;
 	case KVM_MR_CREATE:
 		rc = gmap_map_segment(kvm->arch.gmap, mem->userspace_addr,
 				      mem->guest_phys_addr, mem->memory_size);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 27926a06df32..03c899849c38 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -804,7 +804,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 		if (*table & _REGION_ENTRY_INVALID)
 			return NULL;
 		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
-		/* Fallthrough */
+		fallthrough;
 	case _ASCE_TYPE_REGION2:
 		table += (gaddr & _REGION2_INDEX) >> _REGION2_SHIFT;
 		if (level == 3)
@@ -812,7 +812,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 		if (*table & _REGION_ENTRY_INVALID)
 			return NULL;
 		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
-		/* Fallthrough */
+		fallthrough;
 	case _ASCE_TYPE_REGION3:
 		table += (gaddr & _REGION3_INDEX) >> _REGION3_SHIFT;
 		if (level == 2)
@@ -820,7 +820,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 		if (*table & _REGION_ENTRY_INVALID)
 			return NULL;
 		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
-		/* Fallthrough */
+		fallthrough;
 	case _ASCE_TYPE_SEGMENT:
 		table += (gaddr & _SEGMENT_INDEX) >> _SEGMENT_SHIFT;
 		if (level == 1)
-- 
2.24.1

