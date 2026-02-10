Return-Path: <kvm+bounces-70746-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8NZeDFtQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70746-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CA86A11C891
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DC90E3006151
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A8438A701;
	Tue, 10 Feb 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fBmjUvOn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359453816FC;
	Tue, 10 Feb 2026 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737680; cv=none; b=HPt4JF90ANvibLx4RfPoQSk5bIF7FyjYNd/yM+NrmzhhWA80qYL5KtVUNmvRpxaiub2EKlbtiHFrCM2ulIuc6jIagy2qW89MR0R/y9GhA2OmzcfqRIB1tppamMYwepv9EliTgEXs9DTSxwV2AznQXrvhKNqs7zi+Sy5zUfdTo4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737680; c=relaxed/simple;
	bh=L7lrFJFdRXgpa5Ea8fzLN71AvKYf447TKUF3obRWpSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCem/8NeQML/1i0Ax9hKMSEeD4cxsKXSr6UCo8Gc9LXdO9ZqTIvJrx0+LP0HS47gGjCAYA1shg7tWhoPheDamRrxSKIFx0KuJaeJbSGUfqdy6Jua6In72a2dO7s/A1uy/T4aa8Z2P7492SPxjLj7U04y/hbV8D3exko7ntAjjOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fBmjUvOn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AACK05198637;
	Tue, 10 Feb 2026 15:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+s7iqYDYggkYKDSKg
	i1zxaE/0Mu0GNtQzxGB15MWpQI=; b=fBmjUvOnGO2YETfcvDYaf1PV8dJv8iR1u
	6XJK2/Ep+9uDWndYT4vqr8fH68RWZIwPmMJQnx2TPFV3WcS9m7qdxNHhrZsxVIaj
	PVBQnq4fQ3IBVlDdN83TT6EeN9XVF/3yVECVM8pNQ3/+2va8mSGn2LWU1hE+JNTQ
	mUuJ4giqqTebJb7D5Yj/iqU0wWVhY3P+L1PMoQgxxVpSb/Xx6vwaZV0h2Fq+bNxX
	ECPALHlVrb5j+zfxFSwbsL8LJ5wmIefV+fuH9eDBhC3SRM/noX2kcADmehA5wTK7
	k+ReMENElswNUCuFxxp1jdGEalIB1HFc+lxUBw6ijYH27kWT4C+Eg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucyby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AE2WtJ008404;
	Tue, 10 Feb 2026 15:34:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3y9y3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYUpa47645144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B02E720040;
	Tue, 10 Feb 2026 15:34:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E43420043;
	Tue, 10 Feb 2026 15:34:30 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:30 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 22/36] KVM: s390: Add some helper functions needed for vSIE
Date: Tue, 10 Feb 2026 16:34:03 +0100
Message-ID: <20260210153417.77403-23-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698b500b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=f7MFh5bWiv51XAAf4ckA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX4wbPGOA5uGG5
 YRTuWDpY50SO7OBQlAIU7TCe0JZWs2ADsSU2WtX50L3JFisuR8v2uhM3ZoFyUmUIgILppA0p0Bv
 MWVOAWDfuLsTKzQHezE1Ys2j25YasItYQmLMymJcmFWStstyq1BjCOPXbIFi+RrtluCFEB11kcj
 r6xPUkVl9dzlNGfQXrMlAVeSTBOp8Jg6zTTOrK9i6JHo3ijJtzFAZmq+lfsSKOUUFomPn/p1b+O
 bgjMmofWybHlSiLFAem/QOg64lkDCssc2GjR9imonQt/bgOdprLQFmbUCP9abzOdkHrb4Y/ARGN
 DDkfVdbLi9DqMP9w0Y7mSwUh6eBa5vrReYLQWYeE9O6Peovm73Qpf7Mfzjb9fx2yvys0GdnBOcW
 bhMmSKV6t8QYn2FZoH3I5HoOWNMSLC+0jU8qipSdtfc83DbuvIBm1oZ+ZGo4hhASMSqm9fTQZrX
 7FluRgUZVOSJxWcgVNg==
X-Proofpoint-ORIG-GUID: PypFiXCCOAZOsakzK8MWY6EUwG3fj_Tv
X-Proofpoint-GUID: PypFiXCCOAZOsakzK8MWY6EUwG3fj_Tv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70746-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: CA86A11C891
X-Rspamd-Action: no action

Implement gmap_protect_asce_top_level(), which was a stub. This
function was a stub due to cross dependencies with other patches.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c | 74 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 5736145ef53a..fea1c66fcabe 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -22,6 +22,7 @@
 #include "dat.h"
 #include "gmap.h"
 #include "kvm-s390.h"
+#include "faultin.h"
 
 static inline bool kvm_s390_is_in_sie(struct kvm_vcpu *vcpu)
 {
@@ -1091,10 +1092,79 @@ static struct gmap *gmap_find_shadow(struct gmap *parent, union asce asce, int e
 	return NULL;
 }
 
+#define CRST_TABLE_PAGES (_CRST_TABLE_SIZE / PAGE_SIZE)
+struct gmap_protect_asce_top_level {
+	unsigned long seq;
+	struct guest_fault f[CRST_TABLE_PAGES];
+};
+
+static inline int __gmap_protect_asce_top_level(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
+						struct gmap_protect_asce_top_level *context)
+{
+	int rc, i;
+
+	guard(write_lock)(&sg->kvm->mmu_lock);
+
+	if (kvm_s390_array_needs_retry_safe(sg->kvm, context->seq, context->f))
+		return -EAGAIN;
+
+	scoped_guard(spinlock, &sg->parent->children_lock) {
+		for (i = 0; i < CRST_TABLE_PAGES; i++) {
+			if (!context->f[i].valid)
+				continue;
+			rc = gmap_protect_rmap(mc, sg, context->f[i].gfn, 0, context->f[i].pfn,
+					       TABLE_TYPE_REGION1 + 1, context->f[i].writable);
+			if (rc)
+				return rc;
+		}
+		gmap_add_child(sg->parent, sg);
+	}
+
+	kvm_s390_release_faultin_array(sg->kvm, context->f, false);
+	return 0;
+}
+
+static inline int _gmap_protect_asce_top_level(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
+					       struct gmap_protect_asce_top_level *context)
+{
+	int rc;
+
+	if (kvm_s390_array_needs_retry_unsafe(sg->kvm, context->seq, context->f))
+		return -EAGAIN;
+	do {
+		rc = kvm_s390_mmu_cache_topup(mc);
+		if (rc)
+			return rc;
+		rc = radix_tree_preload(GFP_KERNEL);
+		if (rc)
+			return rc;
+		rc = __gmap_protect_asce_top_level(mc, sg, context);
+		radix_tree_preload_end();
+	} while (rc == -ENOMEM);
+
+	return rc;
+}
+
 static int gmap_protect_asce_top_level(struct kvm_s390_mmu_cache *mc, struct gmap *sg)
 {
-	KVM_BUG_ON(1, sg->kvm);
-	return -EINVAL;
+	struct gmap_protect_asce_top_level context = {};
+	union asce asce = sg->guest_asce;
+	int rc;
+
+	KVM_BUG_ON(!is_shadow(sg), sg->kvm);
+
+	context.seq = sg->kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	rc = kvm_s390_get_guest_pages(sg->kvm, context.f, asce.rsto, asce.dt + 1, false);
+	if (rc > 0)
+		rc = -EFAULT;
+	if (!rc)
+		rc = _gmap_protect_asce_top_level(mc, sg, &context);
+	if (rc)
+		kvm_s390_release_faultin_array(sg->kvm, context.f, true);
+	return rc;
 }
 
 /**
-- 
2.53.0


