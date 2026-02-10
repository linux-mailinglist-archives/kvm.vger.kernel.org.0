Return-Path: <kvm+bounces-70739-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uCtqJXVQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70739-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 483DA11C8CC
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1A51E304AC19
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC4F3876B6;
	Tue, 10 Feb 2026 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BnUcwr29"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76DB385EDE;
	Tue, 10 Feb 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737673; cv=none; b=iCGtyZXZ3UQOrFCyEWrFeEc7H/+IXkv6hSZZUXe2v6VIcCIMqUzJEb3n7ZVqFpt/nmvy83b+VFwvt/VLLyf1nUBkWsxRpkeQiv2RceFEnFRNaxZi70Ch4tZkCQK9A6znd5tv0p+yyBJpY3I/6VeUOEXsB0CLcV7xyTd7mLljcIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737673; c=relaxed/simple;
	bh=XBl4VpQqfIosSBW6irkm24qlPQ0YpYa+2M6w8vpVubI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKR7ZcsCW3xgr1tgyoPW25m843PsNnVQ0EB0qqH+TZkIlawbPqnviOqhEWKndNig+Uync/CRivWRhtTRGUoYY17UPPbDoqogOYdLkkpMzg3fEgZ2aQUaX2ohepEb4sfQXlfmhLn9K2v9j4PIzBv8D8YpvEg8axgeWmSudPo9VYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BnUcwr29; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AAj9XE476964;
	Tue, 10 Feb 2026 15:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3bbIfr3FpM+6HJ/rx
	OksPftl0mlkccqmSFVFIoZOV70=; b=BnUcwr29+KIfXqtoSdhZgwuIN/Irg2qRN
	ltDa0qo1qFx5uZ2hB0rO9WA8bLzVTd90JXROvlUZ0FhEpR2hhvYW59QO3jKZgBHL
	eIMzzsVtdqQPvg3gsT0jWgx57exxUuC6HA/BdKT9FdO020eiStkRYCzgMcvyXKMM
	k/lZ916jdm5zjtczpDAJyiyKi5/7mZud7X0Uj1WTDX4nVGLo+2abgb6jc2BQG/hE
	IAv0iCZ3vyQgWzjBB+8FGWcEleBFrsfumkVGsdkXzz5yqP8xdaDBgpfHgEETdKNF
	M/aN0hJSrEdd+IavdbPkQWgC6BEar9QCoTvM4X+zY4eCw+XPQtybg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w4x93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AFEuln019336;
	Tue, 10 Feb 2026 15:34:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk1nw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYNqC49283424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFEFE20043;
	Tue, 10 Feb 2026 15:34:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F83720040;
	Tue, 10 Feb 2026 15:34:23 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:23 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 10/36] KVM: s390: vsie: Pass gmap explicitly as parameter
Date: Tue, 10 Feb 2026 16:33:51 +0100
Message-ID: <20260210153417.77403-11-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b5004 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=HXG1Eys9fZm8ipb54dgA:9
X-Proofpoint-GUID: SoB-htz3lwuwxik4WgtUnIy-LX7bPGvt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX5VFsvH2nVltE
 u4SWwaa5ygPdAgE3xB9HcaQpMq8g0FXNZL6nNWhvdN/GELahr+5PRvZZs4rCITldXbc1CRNX47H
 ozdWjG3ve+cwnw4UlN2TEnUR+kBtcxp00Kri9fQnYWh4t8MxEOQItxv4/i8TCi5oK0rPFOecZK5
 /+M/nWltLU5xgf1kuopBidtwDrghR8JmqKm12Ui+7cmj1tqPuCoc5E6i0/XvVK9SrTxQXGIj1zX
 1f/lH7Xvh8yYR4+6dZ7rP8Pq3DbqXPnwUqETCNyVwjvOmTC/x/rwhhXrTXg0Uf6+h416qpD0Jpc
 DQ4eNzhVps8ENOlEzWkgjFgr+cGwruHl0ofvQJsNw0cd2d79H1j1znIpE9/EawV1CXoY5XGTDMp
 rQPo7ysKXW1RlF06PjGVBzDXRnUcFFnt1oz71LmxJjUdCzPLvaD9VeVCIlW6zvzwB0nbeXn4V4w
 e3nrg4pLk5BMgfGw8iQ==
X-Proofpoint-ORIG-GUID: SoB-htz3lwuwxik4WgtUnIy-LX7bPGvt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70739-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 483DA11C8CC
X-Rspamd-Action: no action

Pass the gmap explicitly as parameter, instead of just using
vsie_page->gmap.

This will be used in upcoming patches.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b8064c6a4b57..1da1d0f460e1 100644
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
2.53.0


