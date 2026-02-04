Return-Path: <kvm+bounces-70225-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJwcBPJhg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70225-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:12:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7083E81EE
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3F77430C6BD3
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392164218BB;
	Wed,  4 Feb 2026 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nc6XObIz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2277425CFD;
	Wed,  4 Feb 2026 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217396; cv=none; b=tHtR88i4l7DSBk0Vj/Z/BQPGTSVXjDrPS7M5XpOm0GQGjcG7fmUw4uTSL1iTT/NwMoesYILRlC1xBjNxCqIGwfE+zUChPJtamV+PxSGCZMj+FmXDOfZBVnNaTDKSdNHbgsqemcEeTfgVkvpbUPvvT8fplLBHHpRrdkgv5sx6M/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217396; c=relaxed/simple;
	bh=SAteRiMdwX1LFAOgy8DSS/MHr4xWkv4xCMolIJlUaA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epj8+aJInq4m+aqWLFAbejDYoE/oGR6FxNl5lPk61vQCgyOxcVW528sLUV3Bz/c6hNaqgB/svtA+dODUrDlXcFHCzsGhu6CuKDNx+4MlpiN0unYmcz5GmdSaNmiRW0SQb7GDq/X56RcYHJUF5HBzH6s7s+3Lk47sVqZqsmu3zp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nc6XObIz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 614AG4kI027849;
	Wed, 4 Feb 2026 15:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mypTH+XBNkKWj1LDS
	q3KYPnUvP/z9R0J703RZXHbfKE=; b=nc6XObIzCcYC3o6wLzpi8t8LUVs7rEAlS
	ZeesfcO1O2si7FnxRrvbi/sa9gRt+VKp6ixKy+jruo1+KrYiviMRaHv4/1Y1wxaY
	ZY9zle2RoegNukV8zrEUED1RvtwfRcPdlXKDLFiljqhYWDIBI6S+QCv/q1EGiYEl
	IA3qddsy4q1F7RvFdi+ekVN5quQ0a86eyyVEz1teCNCUkegYebE3boAI5fc1PKU8
	VF45VOKAS6ZALWZ5C8fYW264EEitmiaND3UbU9hRK+MR25vWJST/lX4AInmJhxGJ
	BTjIvyD3qbNN6POzZTXjop9BjkA57uKsMY3V5/IQkjMFIHn832DPA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cw7rnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614E5DsC027437;
	Wed, 4 Feb 2026 15:03:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs1dcrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F36ID47645066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42F782004B;
	Wed,  4 Feb 2026 15:03:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 019F720043;
	Wed,  4 Feb 2026 15:03:06 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:05 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 21/29] KVM: s390: Add some helper functions needed for vSIE
Date: Wed,  4 Feb 2026 16:02:50 +0100
Message-ID: <20260204150259.60425-22-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX486AhDgimvA5
 gvQHhJpkSRRiXF1liUl0vcBGio99LrxT2EWQF9EKtMPgeMsXzMEjiIjhfGstFUibS6hkskb2/gL
 x7+lPO8cozzg7XljlwWVF95R61SZh5O6zIB0mwHHIgQAo1LRo75pzkAT2EJWVHmfsLws0U/KV6T
 mwi3Hrv8WaZJXpRsrJsfqZgAEmRlQupq9wJAXNq1K2c3FA9OKcV8VVzuKj/1BxDJWLN34njZO5H
 7rlP53LacKRjhgpeNH6qRWIXqO8+zuEp0rtf5oLj2/hcmMRlHXbCOjWQZsMYKiuE45I2gSFIOCU
 KYHZFoXIJRT6J1HipnkZD0mwgO3bSFhyHWm2EgkTCg5ZTggYqAQl1OSEmsEKkxnwXrP8L/04dcR
 HNyoLEvz2shFpteRl/7vucbZFbt/EdLIkaFEyPJISnv3kWmeDWHg5rYLmS+40v1s61HZVR4dlWX
 Tsno6FW5AkLj9W8n9hw==
X-Authority-Analysis: v=2.4 cv=UuRu9uwB c=1 sm=1 tr=0 ts=69835fae cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=f7MFh5bWiv51XAAf4ckA:9
X-Proofpoint-ORIG-GUID: nt9YTETfuYx2mXNOu4evByG9pOY6WTZg
X-Proofpoint-GUID: nt9YTETfuYx2mXNOu4evByG9pOY6WTZg
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70225-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: A7083E81EE
X-Rspamd-Action: no action

Implement gmap_protect_asce_top_level(), which was a stub. This
function was a stub due to cross dependencies with other patches.

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
2.52.0


