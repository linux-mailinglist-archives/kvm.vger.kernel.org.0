Return-Path: <kvm+bounces-70216-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2OaiKhFhg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70216-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:09:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5038BE8007
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:09:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BE4443051566
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A652C028C;
	Wed,  4 Feb 2026 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="afTRYFRy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206C64218BB;
	Wed,  4 Feb 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217391; cv=none; b=Bay8wTQOfssmupoyeBPJWfSLHkmEUpEeXdIg35cL43JvqHX5IZvttxIsRcvSdFKiBEZ9NBVLxvFUZXulFsgh1JCn99OoYpp2v0uVb2Pkm2lk2dNeOsCZ5RCOmcrBXbP483dvajeeoYwwDTW8F9xiL7HXNAGhh5sM/rw5X5K0Zo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217391; c=relaxed/simple;
	bh=8UkpGTWwtwpBCmzbEuC+cxDdvga6PTHi3Kdv9DBkpd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFFwzoFjU+bqnTT7sZCb12FxnNRc1hbK4PcRolTPR4Dexm4aGGdf2ExD4cm35054A232s2dGCsVEk2RPcpZRj8g2IYCi3VcsrFuzgSuUHUo/4gPLntD9TWCFv4RSo138zy/h21PTikZ4+O7IM1A57MWQ3nLV0D0bxhv2XA4xH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=afTRYFRy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 61407IjU005992;
	Wed, 4 Feb 2026 15:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lwTngDyaNYF1vtCdZ
	/G6YT4Oibj8h9KDMYrxj6jl/Wg=; b=afTRYFRygHGdhppPyxlL7BWj96hgupLR6
	P5VPrdZ8sldHEO4r+nUhrW5xC5UqMluPEiiu+1igVvEsMas9RJb4duGJjNsWhkHe
	Fh9yFzgVuhhu6cdFcaqp5vTw6sp4EW7JcxJXFPEF+spR7P5+bSHea11wglBt4ksD
	Bn9IQyX81jsRW/X8jmCPiieCClnULvJiwM9A6QyPEoxwyzTyVHe0Q8A/sSrOr9E1
	7bqs3O1FUIIJj3U+LaibAxTOwUfL2Jp5SGssOf4hk3Zp1oZW3wx+Yo5qilSBTABy
	WMWtQkrgt3qR/LYUz4n8221mOW1+iQbO3+9YeF+dxXoYcYLz97iqQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cw7rng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614DdM65005959;
	Wed, 4 Feb 2026 15:03:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1x9jde59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F32tC36897240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F2A82004B;
	Wed,  4 Feb 2026 15:03:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E84A20040;
	Wed,  4 Feb 2026 15:03:02 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:02 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 10/29] KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
Date: Wed,  4 Feb 2026 16:02:39 +0100
Message-ID: <20260204150259.60425-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204150259.60425-1-imbrenda@linux.ibm.com>
References: <20260204150259.60425-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX1bR9wHgpCccQ
 ijr78ARjMXdVw1BuAruwTJb/bTqNKvWtPhaRzMFP/Vyebe4od2brHQ/P2ELrBKZWnKxdCP+zOjN
 jWhlnl5R8EoHJz1a8z9jP1dE4YUWNZSeWqhN0i2Od51HlUaf0VTQcCkW0HgFaG7qrMtWBhe0dXS
 32r5qJePwBH++gCgJuhZBay4UmbRpNXh07LjVuD+21a+93fIZsMIq/PkLmuziT+bJ0sMZ0HT2N4
 Ef4UYidptSRSg2cMk4dZp+wfrEvzIafpXd0ypsMF0xbDMK+kYxSqXne+MWz7sn7Km2o7XHv9afk
 0A60KgJH/xMnxAPwsTPI2+v0k8tRPMJKliGVNWbNj1SSvbb7iYnxRgv8a1QVwBGp8KDTIe6O8ht
 loc+9rtLNw3odAzDm4OZ2r8KCj2PhND/Mg6sWYiiIu6ohWY1qRMvzTHuxWJScj9qcT8H5qi9Xms
 ewoGEWi6bzvrhG6Cj9g==
X-Authority-Analysis: v=2.4 cv=UuRu9uwB c=1 sm=1 tr=0 ts=69835fab cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=sWpJ-_il0aw9mM0vlR0A:9
X-Proofpoint-ORIG-GUID: JBhZwtGI8A2FbpnkPh3cIxmHSgMeWUr7
X-Proofpoint-GUID: JBhZwtGI8A2FbpnkPh3cIxmHSgMeWUr7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602040113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70216-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 5038BE8007
X-Rspamd-Action: no action

Enable KVM_GENERIC_MMU_NOTIFIER, for now with empty placeholder callbacks.

Also enable KVM_MMU_LOCKLESS_AGING and define KVM_HAVE_MMU_RWLOCK.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/Kconfig            |  2 ++
 arch/s390/kvm/kvm-s390.c         | 45 +++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3dbddb7c60a9..6ba99870fc32 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/isc.h>
 #include <asm/guarded_storage.h>
 
+#define KVM_HAVE_MMU_RWLOCK
 #define KVM_MAX_VCPUS 255
 
 #define KVM_INTERNAL_MEM_SLOTS 1
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index f4ec8c1ce214..917ac740513e 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -30,6 +30,8 @@ config KVM
 	select KVM_VFIO
 	select MMU_NOTIFIER
 	select VIRT_XFER_TO_GUEST_WORK
+	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_MMU_LOCKLESS_AGING
 	help
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cd39b2f099ca..ec92e6361eab 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4805,7 +4805,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
 	if (!rc)
 		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
-	scoped_guard(spinlock, &vcpu->kvm->mmu_lock) {
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
 		kvm_release_faultin_page(vcpu->kvm, page, false, writable);
 	}
 	mmap_read_unlock(vcpu->arch.gmap->mm);
@@ -6021,6 +6021,49 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	return;
 }
 
+/**
+ * kvm_test_age_gfn() - test young
+ * @kvm: the kvm instance
+ * @range: the range of guest addresses whose young status needs to be cleared
+ *
+ * Context: called by KVM common code without holding the kvm mmu lock
+ * Return: true if any page in the given range is young, otherwise 0.
+ */
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+/**
+ * kvm_age_gfn() - clear young
+ * @kvm: the kvm instance
+ * @range: the range of guest addresses whose young status needs to be cleared
+ *
+ * Context: called by KVM common code without holding the kvm mmu lock
+ * Return: true if any page in the given range was young, otherwise 0.
+ */
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+/**
+ * kvm_unmap_gfn_range() - Unmap a range of guest addresses
+ * @kvm: the kvm instance
+ * @range: the range of guest page frames to invalidate
+ *
+ * This function always returns false because every DAT table modification
+ * has to use the appropriate DAT table manipulation instructions, which will
+ * keep the TLB coherent, hence no additional TLB flush is ever required.
+ *
+ * Context: called by KVM common code with the kvm mmu write lock held
+ * Return: false
+ */
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
 static inline unsigned long nonhyp_mask(int i)
 {
 	unsigned int nonhyp_fai = (sclp.hmfai << i * 2) >> 30;
-- 
2.52.0


