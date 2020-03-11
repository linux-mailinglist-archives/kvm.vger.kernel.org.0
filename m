Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27587180F44
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 06:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgCKFHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 01:07:22 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:51814 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728245AbgCKFHV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 01:07:21 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id BCF9E10185974;
        Wed, 11 Mar 2020 05:07:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:69:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1535:1605:1606:1730:1747:1777:1792:2196:2199:2393:2525:2560:2563:2682:2685:2859:2902:2904:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3865:3866:3867:3868:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4117:4250:4321:4605:5007:6119:6261:7875:7903:9025:9036:10004:10848:11026:11473:11658:11914:12043:12048:12294:12296:12297:12438:12555:12679:12895:12986:13255:13894:14096:14394:14877:21080:21433:21451:21627:21811:21939:21990:30012:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: waves19_22ae4c1b18b41
X-Filterd-Recvd-Size: 6872
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:07:18 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next 018/491] KERNEL VIRTUAL MACHINE for s390 (KVM/s390): Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:32 -0700
Message-Id: <d63c86429f3e5aa806aa3e185c97d213904924a5.1583896348.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583896344.git.joe@perches.com>
References: <cover.1583896344.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/kvm/gaccess.c   | 23 +++++++++++++----------
 arch/s390/kvm/interrupt.c |  2 +-
 arch/s390/kvm/kvm-s390.c  |  4 ++--
 arch/s390/mm/gmap.c       |  6 +++---
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 07d30f..47a67a 100644
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
index 028167d6..819110 100644
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
index 6b1842a..d590f3 100644
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
index 27926a0..03c899 100644
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
2.24.0

