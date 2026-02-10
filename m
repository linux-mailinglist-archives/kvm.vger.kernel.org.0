Return-Path: <kvm+bounces-70753-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kD81FP9Qi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70753-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:38:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 077D711C9BA
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6978E305237D
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BDD38A9AC;
	Tue, 10 Feb 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dLTC0zak"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47694385520;
	Tue, 10 Feb 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737688; cv=none; b=IlFsyxHkmI9GNguZieMd1Lxgf45zKoTPd8shuyqGcKG33dympxzEydXuh+jmHnKZizXWpIaMily7MIQPIuzK8WOQIiEC4vByCruCVTDCwRWqVXbwPMBmrVNDDQs4TUUKdGWSArwSY1bKcQwW7ay07Zr6jae3HboMklkiIDYhS3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737688; c=relaxed/simple;
	bh=sIbgcBmI28EV46mj8T46qBOmtsQDkG8mKzmQOy/wCZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLyRNg4M6SwPbIByGmbQNi9KVZDsWTc8ZCba7Vu3b2vpBHTymy9qPpzuIMCHV4Pl/cynE5u0UYYpSmIncExBHT8EFyT52+G3BRLdEP+6thALkcIJTXY/wr+85ZmCS9o5jQFrFvQiGIxl6zQHF+e3IgJ0cXU2zMeaSRP6rxG5m+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dLTC0zak; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AACK06198637;
	Tue, 10 Feb 2026 15:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=X0n1X79GPAkbISG1/
	8Ah4RvG+GOhR3x8VBPyiMWsXm4=; b=dLTC0zakeefM3HEEl7B0eL8wsnACTiKm+
	GvkSZqUlnAUsxh+xIQa9C+cnNiI79BRzufBqae3BfdsMd1nznorBBDr57hCwUBfe
	ZSW/qvERf1d1wgz3hnEGHbLjsiBtSDJbXfpioijMNO2Doptr+8dSNaqADbVS+l10
	yfRxkZ7TA0yhNhTzocJsbElka7VZuDdanlnmlm4L5YFpXcpJmyxca10P5TRowmXd
	79qD1TwDaj632o55UcmdHaVmeJu1R5eisA1AnqgjXJ/aQZm/LwrgJLcsjweZG0QL
	vwM6ayRz2ItubiEZLxr7oxwNUyBi5OikHyXYJ+ILoH+daVkjZy9WQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucyc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:39 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AE2WtN008404;
	Tue, 10 Feb 2026 15:34:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3y9y4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYYU761079984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51F1D20040;
	Tue, 10 Feb 2026 15:34:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D56402004B;
	Tue, 10 Feb 2026 15:34:33 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:33 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 28/36] KVM: s390: Enable 1M pages for gmap
Date: Tue, 10 Feb 2026 16:34:09 +0100
Message-ID: <20260210153417.77403-29-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698b500f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=2DwSK8QdlStOok5YbGYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXye3agoHbdh1+
 gsPQrjIjc7tNPsnedjNJxVbInzDV3dXObPaEEoZav70AXVEmOWvXtRewV2FijWU7/IQHipr/xDr
 OIwM/tjLG7p3IcQ0HCfgt7tZ0sKHvUkx32nbBLp7wahp/RVwMDqyHYSvf8X648Ox3hIk6M1N76i
 ah68YLpg57IOhT1U/BHOjiVdfYZhHO2jLUo8sg3ngbbKwJcrxoSLkRyZFUfd+spprXKcqJ4IFg6
 ycjwEJSjQg7J5lJyJmhRcE/JihlqrErbdWLOKhUrDo/OmOZXnsRwHvlSou9JJ4EiJRG4a3xQvUc
 7ekx4EBLZjgReoozVFyKF2SY6JjzkpFOI1v9G8NcVdNxDz1OWfQY+5HPFZc0myIQYLQoUb+P3Ju
 vghjBUwNsf388RrkEUCOK6A3U6WB9peIsjqyuyvYQo00hKUERQQ9r/iftW809mkh/LUTY2pqInm
 B0gWGnMCVoF9p9DN4zA==
X-Proofpoint-ORIG-GUID: AS2WZyKM40zvMqv0Q5kJbhFLoS3MfQYO
X-Proofpoint-GUID: AS2WZyKM40zvMqv0Q5kJbhFLoS3MfQYO
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70753-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 077D711C9BA
X-Rspamd-Action: no action

While userspace is allowed to have pages of any size, the new gmap
would always use 4k pages to back the guest.

Enable 1M pages for gmap.

This allows 1M pages to be used to back a guest when userspace is using
1M pages for the corresponding addresses (e.g. THP or hugetlbfs).

Remove the limitation that disallowed having nested guests and
hugepages at the same time.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c     | 2 +-
 arch/s390/kvm/kvm-s390.c | 6 +-----
 arch/s390/kvm/pv.c       | 3 +++
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index fea1c66fcabe..da222962ef6d 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -620,7 +620,7 @@ static inline bool gmap_2g_allowed(struct gmap *gmap, gfn_t gfn)
 
 static inline bool gmap_1m_allowed(struct gmap *gmap, gfn_t gfn)
 {
-	return false;
+	return test_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &gmap->flags);
 }
 
 int gmap_link(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, struct guest_fault *f)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bde55761bf8a..ac7b5f56f0b5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -851,6 +851,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 			r = -EINVAL;
 		else {
 			r = 0;
+			set_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &kvm->arch.gmap->flags);
 			/*
 			 * We might have to create fake 4k page
 			 * tables. To avoid that the hardware works on
@@ -5729,11 +5730,6 @@ static int __init kvm_s390_init(void)
 		return -ENODEV;
 	}
 
-	if (nested && hpage) {
-		pr_info("A KVM host that supports nesting cannot back its KVM guests with huge pages\n");
-		return -EINVAL;
-	}
-
 	for (i = 0; i < 16; i++)
 		kvm_s390_fac_base[i] |=
 			stfle_fac_list[i] & nonhyp_mask(i);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index a48a8afd40df..461b413c76a3 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -721,6 +721,9 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.flags.ap_allow_instr = kvm->arch.model.uv_feat_guest.ap;
 	uvcb.flags.ap_instr_intr = kvm->arch.model.uv_feat_guest.ap_intr;
 
+	clear_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &kvm->arch.gmap->flags);
+	gmap_split_huge_pages(kvm->arch.gmap);
+
 	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
-- 
2.53.0


