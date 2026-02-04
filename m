Return-Path: <kvm+bounces-70214-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KswK+tgg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70214-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:08:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 613CFE7FAC
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E713F30611A1
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA8C4219FB;
	Wed,  4 Feb 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="A86Xhtne"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAD842188E;
	Wed,  4 Feb 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217390; cv=none; b=cOD/nVvT6VXNhRGmpojR7mJeEXHFKBeiCwZiE50vXMxFz2OiQyLMKz4BmK1KW2NoIEFJbHrAIE/72heaz9SXnigVQexulL9BJ3ZZJZ9t5NdCFtHIc8Yicxnqsv3eV1mHPUr0pQDNeZGUCdDxsNQ9N+j2cqFPv087krc4qXmEzQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217390; c=relaxed/simple;
	bh=MwRlEXS+9TTKAVxXRbRJfm30lcddhdF+DFAQ7aLn7eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBV3T8X3gChisWMyhd0sh4jcZqoBLfOr54TUdJwyJefZyDA224YPiJPr4TfDSMEVFPRQeAEhjDe6/GxaO9sASMew3abnOAAsv3CEncck6g1//OvUJxPF53/riL/a409CrdCMbHiRM8cLadxy8JpxLSNEKmK6PohwMogVVTRPFXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=A86Xhtne; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613LxS5G024736;
	Wed, 4 Feb 2026 15:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9VBHMGApuDPu1H5nW
	xC2gjbA/GYRZEiMfQwZendHh0k=; b=A86Xhtne8s8i9Dguc9de2j+Rg6l3OyN1B
	OnQCSDu9EbwvF9SgVDpx0x89aBow3lDsFN1Y4s+kQpo45j+fU5zuRMsKS0XIIUKo
	PIU/lY9IBRe8AFO8doH7CtOBZWTNC3Ts84KgtP1el8Xq3FqT6wTtjh5qRVNUuvEP
	CmcBfkmtGLUPjleQBNX/zcb7cIz5iVom0A1P7xw+VVjgXX3cchi6ltpT6+WoYnWi
	8w7h8gKgPsizAC+atsB4AjaN4N7mES0sAVELq+165At4W14v/8FcVQbM+7lFHWj+
	LDBOGfasqzeyhDcMxtyz5arPw39dpiXLgYN/n+Ri1pvSXLs4jLAlA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f6jg2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:07 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614CV4Xx025812;
	Wed, 4 Feb 2026 15:03:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1w2mwnjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F32dV43975126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46E312004B;
	Wed,  4 Feb 2026 15:03:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 038E120043;
	Wed,  4 Feb 2026 15:03:02 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:01 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 09/29] KVM: s390: vsie: Pass gmap explicitly as parameter
Date: Wed,  4 Feb 2026 16:02:38 +0100
Message-ID: <20260204150259.60425-10-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: Oj7l8ikxz_hWsQlyQlXRUkBPTh3E59Eg
X-Authority-Analysis: v=2.4 cv=drTWylg4 c=1 sm=1 tr=0 ts=69835fab cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=HXG1Eys9fZm8ipb54dgA:9
X-Proofpoint-ORIG-GUID: Oj7l8ikxz_hWsQlyQlXRUkBPTh3E59Eg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX+OdHcrARwFEC
 mzZw7Py5KLAZ8j/LGmYGHf0Xg994neEp3ZMAwIyHVvI8qUWON5RuZ07xjS+QCXxbs0eGJgNi3xR
 lKjVev7rDmz9u+XEXtOJ46ahZSxvr0hNVjk4S8ApMf4dfnsYEv9DroQ92VUCVHAe7w8Pxx99fp7
 DTw3SkHbPBViyWq0sTl5/kQ3YrPZhR5SRR5q7rtyEcFyoFr3uPrCWyh2lXf/XT1KhH6D3WnhQHx
 nuiDTwsHvOkEQahN5wUROxsd6OotEVnkR/+VZRCzmRcgCkrj9/DhY7gLffgrKdGEmFrP+doU44y
 ZVGVtwoO12mhP8Xv9R7NoDLlr/RanhQ2pfaGtYPZTkVHVCfCDMbMjJlfGCJR6mQpc20TFozpO09
 hiRvWxWzSPGh/ZE4rPBvC4layjOHbvKMoDpoUVqfmzliJv3+C4+EDrxROCI0F7bTDilmuIzEGRK
 HDn+GzN9E233nncbBWA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
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
	TAGGED_FROM(0.00)[bounces-70214-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 613CFE7FAC
X-Rspamd-Action: no action

Pass the gmap explicitly as parameter, instead of just using
vsie_page->gmap.

This will be used in upcoming patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b526621d2a1b..1dd54ca3070a 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -652,7 +652,7 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
  *          - -EAGAIN if the caller can retry immediately
  *          - -ENOMEM if out of memory
  */
-static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	u64 prefix = scb_s->prefix << GUEST_PREFIX_SHIFT;
@@ -667,10 +667,9 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* with mso/msl, the prefix lies at offset *mso* */
 	prefix += scb_s->mso;
 
-	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix, NULL);
+	rc = kvm_s390_shadow_fault(vcpu, sg, prefix, NULL);
 	if (!rc && (scb_s->ecb & ECB_TE))
-		rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-					   prefix + PAGE_SIZE, NULL);
+		rc = kvm_s390_shadow_fault(vcpu, sg, prefix + PAGE_SIZE, NULL);
 	/*
 	 * We don't have to mprotect, we will be called for all unshadows.
 	 * SIE will detect if protection applies and trigger a validity.
@@ -951,7 +950,7 @@ static int inject_fault(struct kvm_vcpu *vcpu, __u16 code, __u64 vaddr,
  *          - > 0 if control has to be given to guest 2
  *          - < 0 if an error occurred
  */
-static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	int rc;
 
@@ -960,8 +959,7 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		return inject_fault(vcpu, PGM_PROTECTION,
 				    current->thread.gmap_teid.addr * PAGE_SIZE, 1);
 
-	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				   current->thread.gmap_teid.addr * PAGE_SIZE, NULL);
+	rc = kvm_s390_shadow_fault(vcpu, sg, current->thread.gmap_teid.addr * PAGE_SIZE, NULL);
 	if (rc > 0) {
 		rc = inject_fault(vcpu, rc,
 				  current->thread.gmap_teid.addr * PAGE_SIZE,
@@ -978,12 +976,10 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
  *
  * Will ignore any errors. The next SIE fault will do proper fault handling.
  */
-static void handle_last_fault(struct kvm_vcpu *vcpu,
-			      struct vsie_page *vsie_page)
+static void handle_last_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	if (vsie_page->fault_addr)
-		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				      vsie_page->fault_addr, NULL);
+		kvm_s390_shadow_fault(vcpu, sg, vsie_page->fault_addr, NULL);
 	vsie_page->fault_addr = 0;
 }
 
@@ -1065,7 +1061,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 	}
 }
 
-static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	unsigned long pei_dest, pei_src, src, dest, mask, prefix;
@@ -1083,8 +1079,8 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
 	src = _kvm_s390_real_to_abs(prefix, src) + scb_s->mso;
 
-	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
-	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
+	rc_dest = kvm_s390_shadow_fault(vcpu, sg, dest, &pei_dest);
+	rc_src = kvm_s390_shadow_fault(vcpu, sg, src, &pei_src);
 	/*
 	 * Either everything went well, or something non-critical went wrong
 	 * e.g. because of a race. In either case, simply retry.
@@ -1144,7 +1140,7 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
  *          - > 0 if control has to be given to guest 2
  *          - < 0 if an error occurred
  */
-static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 	__releases(vcpu->kvm->srcu)
 	__acquires(vcpu->kvm->srcu)
 {
@@ -1153,7 +1149,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	int guest_bp_isolation;
 	int rc = 0;
 
-	handle_last_fault(vcpu, vsie_page);
+	handle_last_fault(vcpu, vsie_page, sg);
 
 	kvm_vcpu_srcu_read_unlock(vcpu);
 
@@ -1191,7 +1187,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 			goto xfer_to_guest_mode_check;
 		}
 		guest_timing_enter_irqoff();
-		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce);
+		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, sg->asce);
 		guest_timing_exit_irqoff();
 		local_irq_enable();
 	}
@@ -1215,7 +1211,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	if (rc > 0)
 		rc = 0; /* we could still have an icpt */
 	else if (current->thread.gmap_int_code)
-		return handle_fault(vcpu, vsie_page);
+		return handle_fault(vcpu, vsie_page, sg);
 
 	switch (scb_s->icptcode) {
 	case ICPT_INST:
@@ -1233,7 +1229,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		break;
 	case ICPT_PARTEXEC:
 		if (scb_s->ipa == 0xb254)
-			rc = vsie_handle_mvpg(vcpu, vsie_page);
+			rc = vsie_handle_mvpg(vcpu, vsie_page, sg);
 		break;
 	}
 	return rc;
@@ -1330,15 +1326,17 @@ static void unregister_shadow_scb(struct kvm_vcpu *vcpu)
 static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	struct gmap *sg;
 	int rc = 0;
 
 	while (1) {
 		rc = acquire_gmap_shadow(vcpu, vsie_page);
+		sg = vsie_page->gmap;
 		if (!rc)
-			rc = map_prefix(vcpu, vsie_page);
+			rc = map_prefix(vcpu, vsie_page, sg);
 		if (!rc) {
 			update_intervention_requests(vsie_page);
-			rc = do_vsie_run(vcpu, vsie_page);
+			rc = do_vsie_run(vcpu, vsie_page, sg);
 		}
 		atomic_andnot(PROG_BLOCK_SIE, &scb_s->prog20);
 
-- 
2.52.0


