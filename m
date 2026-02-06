Return-Path: <kvm+bounces-70443-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMKTB3P8hWnUIwQAu9opvQ
	(envelope-from <kvm+bounces-70443-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:36:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD828FF0D7
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1FDDF3012CFE
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0162133B6EC;
	Fri,  6 Feb 2026 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FRTYQzlm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDB441B37A;
	Fri,  6 Feb 2026 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770388571; cv=none; b=j8PzdRFiBOECqjD2wmzpCjhMRb9JSfLajH1UPt+SFBW88pu56p7DIxxfUWnsCFRwb0g6aHa73dE/fUAPhn0FHWb0wfDE8GBUtuS+DJj+VNF7uD4EfDmGM3HPHDGd/ORlRKzmKAWZabhk4sZzK6P7mNOuS062zCnhpsjxtIPw618=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770388571; c=relaxed/simple;
	bh=s9XbWYFcP+A82AuBUlEgr9qX8/WvhGPY8I8vsO0/o0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjAleUjeVUAfwFg8mBwPR8rcQJ6aJIgwQw8JcGQtvOb1Gcz02qd1Mq3Sccappt1+/ZkVe6RHRK5g1Nu7VifVjdiWUGDzPiDeWA1tX36UVXuoppUASOUszmgQEqmnp9EkVIGc8d8Ihpd4DKMiMp1zrqvhah4FCpk5Lu3N40k4r4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FRTYQzlm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616BaBck009119;
	Fri, 6 Feb 2026 14:36:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=kTtSp4OjQif9vQ7xB
	780ZKfwHlP+SAXvGWNcax3SbPA=; b=FRTYQzlmuh6xt6g1oECUSusay5cVtm/wF
	3PQTTL+/+v1asC9FiowrYnrJeUTXjkW/GzscjcuyxigmcWv8qhJGT8Z7D4rRabft
	JTiw5pIZE1JXITqj6RgH0B8sqba2PQMe9x/m123q3DnLH7Hj5NAgCIR6A2VbHs5f
	E3IljsVjdijp3cvKWHXTYk9/SUlS8BNEI9AadLZtKDbiRr0K5IUB99hW4BzfEniU
	F7n7fEN30gJPtSQKR/XJKMssEKCf2K1+14KXPFAZituMlFvxRV9lPoZnFrDOTCLP
	2Ntah2FkgUTETCdtLMb/VqcJmEnOL9VRq4+kNz4zch3Bi6YNNhwTA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f6v3uu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:36:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616BdRFF009147;
	Fri, 6 Feb 2026 14:36:02 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1veyekeg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:36:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616EZwrT29950368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 14:35:58 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11FC120043;
	Fri,  6 Feb 2026 14:35:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35C7020040;
	Fri,  6 Feb 2026 14:35:57 +0000 (GMT)
Received: from p-imbrenda.t-mobile.de (unknown [9.111.61.157])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 14:35:57 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v1 3/3] KVM: s390: vsie: Fix race in acquire_gmap_shadow()
Date: Fri,  6 Feb 2026 15:35:53 +0100
Message-ID: <20260206143553.14730-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206143553.14730-1-imbrenda@linux.ibm.com>
References: <20260206143553.14730-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HazLgJd6JTEEtmBifDMcRcfqg02YYd27
X-Authority-Analysis: v=2.4 cv=drTWylg4 c=1 sm=1 tr=0 ts=6985fc53 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=2Zy88G6H4nKnHoKmEisA:9
X-Proofpoint-ORIG-GUID: HazLgJd6JTEEtmBifDMcRcfqg02YYd27
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEwMyBTYWx0ZWRfX9N/KTU6h5Rhs
 Hk5VyAF9A8hdCqoWt3GFL0+p7z3CgpKbUtMQs6U7W5kQFUPpshXAUTjqt85IDY4Q2d4YY3F6GRx
 6Uk2JlrAm0npCgxvBaKAy3xkP7q4rD1LHQMB2N4ARtRQfTSSFqtA4fX+Suoq4uQnvoky/T5zOMH
 P2bpgliPIrKABd+udwS7z4SHt1PcnIxQXlf5gD0U02r/eKS0FbME6XmmpelXnDQ/dhOl7irK+F6
 nu53JrKMHY+OK2/pJR9yf0vm68mVPG0OvYbT5DeJxnD/+s1qH6H/PTi9Da06EIgl4iAo74rDwN/
 akqDxd2fUyvVVpRl92ZlaH+WnpotR5TX2XsOTvWx3GqKzuOWnrXCIoYR387+n12RScjKIulRUgB
 aK86G5qq+t1c3xGuwWasPaUsz6bQI6Uo+t9fvB/vWIhNjP7F1ehBPZW2CLi6yN9WMaU0xwLCelm
 x9ePjk+4+VboF8tkecg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_04,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060103
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
	TAGGED_FROM(0.00)[bounces-70443-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: BD828FF0D7
X-Rspamd-Action: no action

The shadow gmap returned by gmap_create_shadow() could get dropped
before taking the gmap->children_lock. This meant that the shadow gmap
was sometimes being used while its reference count was 0.

Fix this by taking the additional reference inside gmap_create_shadow()
while still holding gmap->children_lock, instead of afterwards.

Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
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
index faf8b01fa672..d0296491b2f7 100644
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
2.52.0


