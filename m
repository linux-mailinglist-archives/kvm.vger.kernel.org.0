Return-Path: <kvm+bounces-70218-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IORvEyFhg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70218-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:09:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5976E802E
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 29F323071171
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDC6421F10;
	Wed,  4 Feb 2026 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KPJPCIIp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CE4421A02;
	Wed,  4 Feb 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217391; cv=none; b=fdca5NCWvzM+9P07GpPdFAHb8Y0QVdIkManiLWtyOGap1i9d+NfccBHWOn+VQYyq+OsMle46sV4+LKAZsFqKwmtxqeIdEb5g/9cavVWCSRMdcp9cNUtyJfrwTucq9267pqAnbbXgaTua1CIwegdax6a2Eh4mxoabYgbUnRT8Oww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217391; c=relaxed/simple;
	bh=gvAnFdHT/XMjCR1zs+fqNo8NXhkPFU1ciyQBZIXGeAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8qCTneNfPBuf+cmbXUYvlGbGLMXrQ/QMh6FOnBBzyoMuTTumqLdh+9ZX3lVrOPBkebkfg1eER/6p2ozZrUZnJHKJXLal7gVMnP7gMigSCzRgNMS7cEJmNKoHY/Qpp3T2+WbhVwtK/LmFObP0xEZmulum66JSVUXczJDEonkgQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KPJPCIIp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6140IDtw012349;
	Wed, 4 Feb 2026 15:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=JtFCSxrF9CLU3LvfT
	rCfyoeTzzbfLQKkoH4wpG6bzTA=; b=KPJPCIIpPXvsGj1KQDKF9nJBaDpmP5PWx
	OKnvynhFCojDVxdj/RYhG61DaRIpya2hYRhAtC2cbmFXmtMmhb2tB/QcJnFMR77Q
	5cM17DXpAjEbcOmmwIL+oSD3To1vhvYmYyoE6vPsQGJ3h4+cQJJosxiZBSCcv/nd
	PkjkbdtLJGssfIk4pC6+pQ0vP7BdrwbXf05GdhsMJ0FpiKu34ILExmdRS6tuXMOL
	Mq/le+jJfC869fCIJ7fdCT54P8fJXxa9DeQHPMn31UyasUjHVtTcdUWLmp4W9uzG
	cTG+JHCllGjGFeYB0Jm50SrkXYj0CGK2fjW7dKmzwEoHu7Lp1LgAQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cw7rnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614DFkhW004437;
	Wed, 4 Feb 2026 15:03:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjwk8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F32lH46727438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7A8120043;
	Wed,  4 Feb 2026 15:03:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 968872004D;
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
Subject: [PATCH v7 11/29] KVM: s390: Rename some functions in gaccess.c
Date: Wed,  4 Feb 2026 16:02:40 +0100
Message-ID: <20260204150259.60425-12-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX3+nPGB8BAeUh
 qkb7TH2l7TZvS1M/ZosAtyjY8RsJnL5xLCdiUngVLFYT4b8/tPPzkz2iR4JsU8MTRQtuNPTkSlf
 ov3U4hwvx63Q06lROQdyyyQzs35iW0K+T2u75N6Zq3SoPZR1iBRVwCV7NcNW/ATJcBf7LOWGg/I
 702veBtQgGm3izhDoGLRHlAXLAUTDEM9HUNYKuXV41IomkLSKYJMd6Rn3+C5GUoMc8r3J15Qdd0
 RXggrpOp8aEZUc1PRKHs8+n6Bd5zx0UD4uUFxcyHcWw2VMslcZFnSNmGPF1ta3Nn2eRsHL6ae8i
 UHRSOKuz3jfEun8Ix7iLE8b3MrGiIwFHUJCv+HSgXzf/9ikRIzwm73VEU+h0DeYSeYXZVUV/N4Y
 fv5f379YVQz8lbh9/wRzCV4WMu0hkPz9KSeaf8SvZo8KpOZw43UiG5z7uX7RxzRkg/4XzsiyCQT
 ianU33Kf5p9b66Upraw==
X-Authority-Analysis: v=2.4 cv=UuRu9uwB c=1 sm=1 tr=0 ts=69835fab cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=daTLW1200KpnZZ0VTdgA:9
X-Proofpoint-ORIG-GUID: nKB0nAMT7wuiZ_nS1kTdLV7Ol8LqsdRK
X-Proofpoint-GUID: nKB0nAMT7wuiZ_nS1kTdLV7Ol8LqsdRK
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
	TAGGED_FROM(0.00)[bounces-70218-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: E5976E802E
X-Rspamd-Action: no action

Rename some functions in gaccess.c to add a _gva or _gpa suffix to
indicate whether the function accepts a virtual or a guest-absolute
address.

This makes it easier to understand the code.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
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
2.52.0


