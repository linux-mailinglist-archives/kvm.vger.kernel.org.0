Return-Path: <kvm+bounces-70741-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PIXLHVQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70741-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA8311C8CB
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1B2293018B8C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC8A3806AB;
	Tue, 10 Feb 2026 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V1O5tcl7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B933168FB;
	Tue, 10 Feb 2026 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737674; cv=none; b=Wv3KCvNpWktBbbNNlvXYzrtHv1VbFeq9nPKfDsYYUxOtF8d5U1u/5CfZew+2dXdXCdeS38UWUWGVpObss6Fx6ot/nyjK1HjO8Xc7PURtx2Tcf2Fbix69qPytOqGCnhzK9HeaFF4cZrNObkGFdKlCHauWVO3/tVvpg46v6cR4jnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737674; c=relaxed/simple;
	bh=lYcOBwceqJl6dgBwGgTT3r6m/jio3B/zEMFURvVwi1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dX+YKbeMJZTgRzCybRrtpxOKKNaLjiebYwtjfjTBxMVEikqY8IXGSCyeHUURfVHPDipnO34ZCCwxtnHVy53hYyM4yu6uuYuTP+KUPkWEIY/CMT816FSkFW5ud0kKx7jt4ixOuGLKdSF0azYdOBUbqHmC2BPoYl8K98w0Pn5Plcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V1O5tcl7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A8URIs238024;
	Tue, 10 Feb 2026 15:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2rlpQDWL+jQ7ihryU
	Jy6xst+JFg/i/8ic7ARCHqXioU=; b=V1O5tcl75+o0PlYKWswqGulD7i9SwGiam
	ksK/KJ0TfctMsyUnsQtGgV2b5cJvQqbwIBDHKb89QoS+Q/FnUwHAdokLxDWa/sAZ
	oE5YSyuwWStiHReDcxYvNuWzlFYpu3iI7VbtpmbbIWSM/nlgvXwbC6xHOUcgQrB2
	34024H4vTDWKXv84Fcj79mc91h54Qqg4tZglKziAwlv6TPlDtcVpWBE+803D3Ak3
	un1PB1wGATf3WjVgFQoj9SkFyYw+PcCB25hixmQTJrYl/lHLKJN4tUGfxcQvT4Vk
	GKbPtBNwBw+a5Q+sIlZLG8MOq7SoVm0bl3vtonUTb/70cCF2zv9fg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w4x96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEtiOZ012996;
	Tue, 10 Feb 2026 15:34:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7k9rg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:28 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYOLU35324262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:25 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D263D20043;
	Tue, 10 Feb 2026 15:34:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62E0520040;
	Tue, 10 Feb 2026 15:34:24 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:24 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 12/36] KVM: s390: Rename some functions in gaccess.c
Date: Tue, 10 Feb 2026 16:33:53 +0100
Message-ID: <20260210153417.77403-13-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b5006 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=daTLW1200KpnZZ0VTdgA:9
X-Proofpoint-GUID: HPt5apcoqj29d30RQCC2Ly9SKstMV9P-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX67NnAvw435L8
 8SWnf4K8N5dNxjiu64nY4Rzx3z0wPp/s+s8rkOr/iwuQe6H2Jwki7a1UEQFf31V/GMndm8UrJMj
 uHirHYoWvsFWvoR83YoUpyudkb+f2x5jDPkU83e7GtjIbMgGvDTmTaM4au1O5Z7YON+VCoo26Oh
 bRCy8HzXBxUpIbqIZrhr0pR7RAwsqJl8sgbQp166jT/C0+420wugZdAC0L0XTAU7UuGoOThh7Ha
 ZQdVighzDS7UC+HCZb4jXdxKdRnN25t2C4jPc9QXMxZEONlH6sh+zWQowN7VRjzhVdSo9wXlzCw
 k4cYZtaGGoUQnX6crh49/4ESMxVYItJQvD2gdNLv97Sd5ZskqoYIO5asD7uSFikia7Wyvyp2OYa
 /XnOjV2xUZjOIiZ00cXwRkRhgh0SZQldkBweA87aRb0mOqPNVtp8JIdn0Ady/eaEtAzTJ4OYifh
 WF2ZuSOI6lrtG/jn7iw==
X-Proofpoint-ORIG-GUID: HPt5apcoqj29d30RQCC2Ly9SKstMV9P-
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70741-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 0AA8311C8CB
X-Rspamd-Action: no action

Rename some functions in gaccess.c to add a _gva or _gpa suffix to
indicate whether the function accepts a virtual or a guest-absolute
address.

This makes it easier to understand the code.

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 51 +++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index d8347f7cbe51..9df868bddf9a 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -397,7 +397,7 @@ static int deref_table(struct kvm *kvm, unsigned long gpa, unsigned long *val)
 }
 
 /**
- * guest_translate - translate a guest virtual into a guest absolute address
+ * guest_translate_gva() - translate a guest virtual into a guest absolute address
  * @vcpu: virtual cpu
  * @gva: guest virtual address
  * @gpa: points to where guest physical (absolute) address should be stored
@@ -417,9 +417,9 @@ static int deref_table(struct kvm *kvm, unsigned long gpa, unsigned long *val)
  *	      the returned value is the program interruption code as defined
  *	      by the architecture
  */
-static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
-				     unsigned long *gpa, const union asce asce,
-				     enum gacc_mode mode, enum prot_type *prot)
+static unsigned long guest_translate_gva(struct kvm_vcpu *vcpu, unsigned long gva,
+					 unsigned long *gpa, const union asce asce,
+					 enum gacc_mode mode, enum prot_type *prot)
 {
 	union vaddress vaddr = {.addr = gva};
 	union raddress raddr = {.addr = gva};
@@ -600,8 +600,8 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static int vm_check_access_key(struct kvm *kvm, u8 access_key,
-			       enum gacc_mode mode, gpa_t gpa)
+static int vm_check_access_key_gpa(struct kvm *kvm, u8 access_key,
+				   enum gacc_mode mode, gpa_t gpa)
 {
 	u8 storage_key, access_control;
 	bool fetch_protected;
@@ -663,9 +663,9 @@ static bool storage_prot_override_applies(u8 access_control)
 	return access_control == PAGE_SPO_ACC;
 }
 
-static int vcpu_check_access_key(struct kvm_vcpu *vcpu, u8 access_key,
-				 enum gacc_mode mode, union asce asce, gpa_t gpa,
-				 unsigned long ga, unsigned int len)
+static int vcpu_check_access_key_gpa(struct kvm_vcpu *vcpu, u8 access_key,
+				     enum gacc_mode mode, union asce asce, gpa_t gpa,
+				     unsigned long ga, unsigned int len)
 {
 	u8 storage_key, access_control;
 	unsigned long hva;
@@ -757,7 +757,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			return trans_exc(vcpu, PGM_PROTECTION, ga, ar, mode,
 					 PROT_TYPE_LA);
 		if (psw_bits(*psw).dat) {
-			rc = guest_translate(vcpu, ga, &gpa, asce, mode, &prot);
+			rc = guest_translate_gva(vcpu, ga, &gpa, asce, mode, &prot);
 			if (rc < 0)
 				return rc;
 		} else {
@@ -769,8 +769,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		}
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, prot);
-		rc = vcpu_check_access_key(vcpu, access_key, mode, asce, gpa, ga,
-					   fragment_len);
+		rc = vcpu_check_access_key_gpa(vcpu, access_key, mode, asce, gpa, ga, fragment_len);
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, PROT_TYPE_KEYC);
 		if (gpas)
@@ -782,8 +781,8 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	return 0;
 }
 
-static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
-			     void *data, unsigned int len)
+static int access_guest_page_gpa(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+				 void *data, unsigned int len)
 {
 	const unsigned int offset = offset_in_page(gpa);
 	const gfn_t gfn = gpa_to_gfn(gpa);
@@ -798,9 +797,8 @@ static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
 	return rc;
 }
 
-static int
-access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
-			   void *data, unsigned int len, u8 access_key)
+static int access_guest_page_with_key_gpa(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+					  void *data, unsigned int len, u8 access_key)
 {
 	struct kvm_memory_slot *slot;
 	bool writable;
@@ -808,7 +806,7 @@ access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
 	hva_t hva;
 	int rc;
 
-	gfn = gpa >> PAGE_SHIFT;
+	gfn = gpa_to_gfn(gpa);
 	slot = gfn_to_memslot(kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(slot, gfn, &writable);
 
@@ -841,7 +839,7 @@ int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
 
 	while (min(PAGE_SIZE - offset, len) > 0) {
 		fragment_len = min(PAGE_SIZE - offset, len);
-		rc = access_guest_page_with_key(kvm, mode, gpa, data, fragment_len, access_key);
+		rc = access_guest_page_with_key_gpa(kvm, mode, gpa, data, fragment_len, access_key);
 		if (rc)
 			return rc;
 		offset = 0;
@@ -901,15 +899,14 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	for (idx = 0; idx < nr_pages; idx++) {
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
 		if (try_fetch_prot_override && fetch_prot_override_applies(ga, fragment_len)) {
-			rc = access_guest_page(vcpu->kvm, mode, gpas[idx],
-					       data, fragment_len);
+			rc = access_guest_page_gpa(vcpu->kvm, mode, gpas[idx], data, fragment_len);
 		} else {
-			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
-							data, fragment_len, access_key);
+			rc = access_guest_page_with_key_gpa(vcpu->kvm, mode, gpas[idx],
+							    data, fragment_len, access_key);
 		}
 		if (rc == PGM_PROTECTION && try_storage_prot_override)
-			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
-							data, fragment_len, PAGE_SPO_ACC);
+			rc = access_guest_page_with_key_gpa(vcpu->kvm, mode, gpas[idx],
+							    data, fragment_len, PAGE_SPO_ACC);
 		if (rc)
 			break;
 		len -= fragment_len;
@@ -943,7 +940,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 	while (len && !rc) {
 		gpa = kvm_s390_real_to_abs(vcpu, gra);
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
-		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
+		rc = access_guest_page_gpa(vcpu->kvm, mode, gpa, data, fragment_len);
 		len -= fragment_len;
 		gra += fragment_len;
 		data += fragment_len;
@@ -1134,7 +1131,7 @@ int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
 
 	while (length && !rc) {
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), length);
-		rc = vm_check_access_key(kvm, access_key, mode, gpa);
+		rc = vm_check_access_key_gpa(kvm, access_key, mode, gpa);
 		length -= fragment_len;
 		gpa += fragment_len;
 	}
-- 
2.53.0


