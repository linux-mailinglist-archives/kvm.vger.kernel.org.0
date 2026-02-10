Return-Path: <kvm+bounces-70757-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4PJ6Ap1Qi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70757-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:37:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B961611C91B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D0B8F3016737
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3E638B7C7;
	Tue, 10 Feb 2026 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xv0Sfz1g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86F5385536;
	Tue, 10 Feb 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737690; cv=none; b=sbRUPF2t5JzcE0MTnsgu3oJqtpgPuRsZJq47RDit/4HtR+LNc3LkYW5XecYFzStr8oShpiz5gOlzfNfuWwTKCUzKXn+sBGmi8V6Vly2eEyQjwALvf7ElS758SNc0sBKa0+zKpH4ZlKEr4LTWq86jiqbDgXSbtKr0JzSdilCehrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737690; c=relaxed/simple;
	bh=1h43zA/Ba9eE1Ti10FyDQo8qhDtlo4bO3nHYChWJZbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb2XN+yWIfbOjBGQtzYATyorDGCLAy1IM57ByU9ZuLAXHGFu76xgjQBrNkzJH+S2zJR+W+0jqNUuUxxYiOgvaTXg2zWer6Kfyhn9YeDINJjj/UwyXIruyXV771QDq0eDXB4rnDos+qh47kpc0cEdTdZmhlta5kDNWDmFojlpNYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xv0Sfz1g; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AANZwg1198145;
	Tue, 10 Feb 2026 15:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GEuX7oEcjv1OwGea0
	lnGzQl9VKIl7OyMXcm47AI6IWg=; b=Xv0Sfz1g0+woxa7jU5vxEOv9zCqCdNfsI
	SzHuCWaS6p9s4rEdSnVibeZt20In6svKTJl+EEFRJne2SDu4wveGUQlRIH33bInB
	+uWcBQMoG+DP0U9m215wGwN0H4sUjIuWY7gWjboX0pUyUCeBU6SeG/DzfEcREbSz
	5kXQvYEq8oSGsoXSlDfwaxWfzrNxtZh5nHSDIv0m+F1Kl8iktBKUQLcrvJGMrXjR
	V0vXJ7z3onAPGNw+wmNzpqR9kl4KgnxQfoSv44q9sDUL3TF/n0qxdHlARzURgN0G
	VaiIHNvujOpp1K6e1oZNgrDDNgZxkL1OYmfNG7/2wzRs9Js7JS7Tw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uts2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AE0ULl008383;
	Tue, 10 Feb 2026 15:34:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3y9y4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYbBN47645162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB4A920040;
	Tue, 10 Feb 2026 15:34:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A10E20043;
	Tue, 10 Feb 2026 15:34:37 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:37 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 34/36] KVM: s390: vsie: Fix race in acquire_gmap_shadow()
Date: Tue, 10 Feb 2026 16:34:15 +0100
Message-ID: <20260210153417.77403-35-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXzoF5GC2YT5KT
 uEZubZHR3TecGq9z0gQrKEKYA+X22L/pXv8TR2k1QJxaOQrB1NOpIQ53GURBbf2WFpUiipiYUas
 d5WLJhB2XGrO9RA1IGnqu/IWzgnoIvV12Qo4vESeMGTcCvEFeID6ojHUDbvTVdnUP19oi+Lpzbt
 +74FSnl4BfrcDcBo1iIQeUaLmIKaKkosB5YAVtleEAsZqjKJL7gZlt8FkvSElHf4O3b9giOUIyi
 BNIaTyREiy5LjwEs/l1LelanNM1lPNjhRW7RMDBDEUVZOsZYzS4icMu3f8RpKylEzMje/9tw+ZP
 99c10d2Psxlj0bEgeGcaBwNqJrAO80rhor+UvjfrDqfloRHiLf+L+tfSIwr2FZmV/XsVGNcF230
 ZPWAeYOSt4xCjpwB16gPhon7aaqIUB1uMxBs/1UpLqCRR/iqLwlmEHTHmAqpfpmaZZbnoJ2x1ud
 x8YKic9fUxhaHwjRQNw==
X-Proofpoint-ORIG-GUID: rteEhZo11dc12OP6u4JhnH5TVzefc7Ap
X-Proofpoint-GUID: rteEhZo11dc12OP6u4JhnH5TVzefc7Ap
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698b5012 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=2Zy88G6H4nKnHoKmEisA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70757-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: B961611C91B
X-Rspamd-Action: no action

The shadow gmap returned by gmap_create_shadow() could get dropped
before taking the gmap->children_lock. This meant that the shadow gmap
was sometimes being used while its reference count was 0.

Fix this by taking the additional reference inside gmap_create_shadow()
while still holding gmap->children_lock, instead of afterwards.

Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c | 15 ++++++++++++---
 arch/s390/kvm/vsie.c |  6 +++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index da222962ef6d..26cd2b208b6f 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -1179,6 +1179,8 @@ static int gmap_protect_asce_top_level(struct kvm_s390_mmu_cache *mc, struct gma
  * The shadow table will be removed automatically on any change to the
  * PTE mapping for the source table.
  *
+ * The returned shadow gmap will be returned with one extra reference.
+ *
  * Return: A guest address space structure, ERR_PTR(-ENOMEM) if out of memory,
  * ERR_PTR(-EAGAIN) if the caller has to retry and ERR_PTR(-EFAULT) if the
  * parent gmap table could not be protected.
@@ -1189,10 +1191,13 @@ struct gmap *gmap_create_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *pare
 	struct gmap *sg, *new;
 	int rc;
 
-	scoped_guard(spinlock, &parent->children_lock)
+	scoped_guard(spinlock, &parent->children_lock) {
 		sg = gmap_find_shadow(parent, asce, edat_level);
-	if (sg)
-		return sg;
+		if (sg) {
+			gmap_get(sg);
+			return sg;
+		}
+	}
 	/* Create a new shadow gmap. */
 	new = gmap_new(parent->kvm, asce.r ? 1UL << (64 - PAGE_SHIFT) : asce_end(asce));
 	if (!new)
@@ -1206,6 +1211,7 @@ struct gmap *gmap_create_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *pare
 		sg = gmap_find_shadow(parent, asce, edat_level);
 		if (sg) {
 			gmap_put(new);
+			gmap_get(sg);
 			return sg;
 		}
 		if (asce.r) {
@@ -1219,16 +1225,19 @@ struct gmap *gmap_create_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *pare
 			}
 			gmap_add_child(parent, new);
 			/* Nothing to protect, return right away. */
+			gmap_get(new);
 			return new;
 		}
 	}
 
+	gmap_get(new);
 	new->parent = parent;
 	/* Protect while inserting, protects against invalidation races. */
 	rc = gmap_protect_asce_top_level(mc, new);
 	if (rc) {
 		new->parent = NULL;
 		gmap_put(new);
+		gmap_put(new);
 		return ERR_PTR(rc);
 	}
 	return new;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index f950ebb32812..d249b10044eb 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1256,6 +1256,7 @@ static struct gmap *acquire_gmap_shadow(struct kvm_vcpu *vcpu, struct vsie_page
 			release_gmap_shadow(vsie_page);
 		}
 	}
+again:
 	gmap = gmap_create_shadow(vcpu->arch.mc, vcpu->kvm->arch.gmap, asce, edat);
 	if (IS_ERR(gmap))
 		return gmap;
@@ -1263,11 +1264,14 @@ static struct gmap *acquire_gmap_shadow(struct kvm_vcpu *vcpu, struct vsie_page
 		/* unlikely race condition, remove the previous shadow */
 		if (vsie_page->gmap_cache.gmap)
 			release_gmap_shadow(vsie_page);
+		if (!gmap->parent) {
+			gmap_put(gmap);
+			goto again;
+		}
 		vcpu->kvm->stat.gmap_shadow_create++;
 		list_add(&vsie_page->gmap_cache.list, &gmap->scb_users);
 		vsie_page->gmap_cache.gmap = gmap;
 		prefix_unmapped(vsie_page);
-		gmap_get(gmap);
 	}
 	return gmap;
 }
-- 
2.53.0


