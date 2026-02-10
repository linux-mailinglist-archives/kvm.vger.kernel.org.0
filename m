Return-Path: <kvm+bounces-70737-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHmsFllQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70737-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F7011C88A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 03E9B3058B94
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5CE2385EE2;
	Tue, 10 Feb 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UUz18XjA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C5B2ED159;
	Tue, 10 Feb 2026 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737672; cv=none; b=gv9O3qbkXcVqjMt0V3r2oKtZ3jsTUSOlcPBUe9+Z6p7IqvOAyZpSNk8gtFWo5dWn9UpCwPBUZ3qX5yIhJI0ozpHxQtnNIWkHNY/Y2LYfxpedxbyKVNj3brbfdgBtzwDRF3jV4lh1AtJ9YXTn7kNhsNiXtPactU+iPFb5f1aPhz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737672; c=relaxed/simple;
	bh=pFOW6RO6MOgrAOa/8tQmSXpsFRYH5GfXfSRc4hO6ZfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brEjX4XGUjGUyT74/6K057eRQ8BfXIwb9DcXvN4QOcpP7Qk5oknjsnwVyuuVsUGfHOmNioVEcoCDZlnhWFs89QjCz9P+3GxCfxEDd/PETd3cnqSsHZTNX8cBGLrIejfU8tU0xjkVgmfi1FfjxI+oBTZAes/Si1SVZfS61VpqGWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UUz18XjA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A8irfs111923;
	Tue, 10 Feb 2026 15:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9taw05L1Fy+PZVH71
	MvP75CxVb0LqOc3P54238UmgZg=; b=UUz18XjADGXbkLVe/TrSu2gsLu/X2LB/x
	+lMAlbwLrKgI6U5EQUiLfKUNL51bgS59edMLZtjwuAx3Cx0iXU16iVjuKPHAsPzT
	OyeO+gHZcZ3a7C8XmnzPbFKLdI3Knfe01wp2HNUJd3gPZYyTjAN+ql4alZAs9oPx
	TnM8UAlYN+czEi0hXDCgmCKONfJ3eZPNx0ry9nLHID27QvsHRgnY1w0HH4NBsOpl
	mGDx2PULbklYKa0T2GsTPbT9NXW06RtXDDK9SbQt3FEd3p7b9s6LGMd4l1YyHqVg
	KdqX3x5RUA6bHFA3B1NYQ9hLkY/Q3/GmmHuM7Fl8mI1KGew5WtKyQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucwf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABNOV7001837;
	Tue, 10 Feb 2026 15:34:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je21jbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYMn816646638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D0A020043;
	Tue, 10 Feb 2026 15:34:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C10A20040;
	Tue, 10 Feb 2026 15:34:22 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:22 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 08/36] KVM: s390: Export two functions
Date: Tue, 10 Feb 2026 16:33:49 +0100
Message-ID: <20260210153417.77403-9-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698b5003 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=kE4rddDq9Ks6am3DDGoA:9
X-Proofpoint-ORIG-GUID: hmfd0OUosug86WgDgYEhSHQBsGXx9QWZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX+vfNF/uf3/+A
 RTPxDrTbMg2HAZqN1zWBXO4Ss2FZ/BkFf3okdAmQ8IWgr0b5mLzRBrAIeuPYUWATIx14W2YWGSr
 FmPXEvnJh8VepQ+pthMDIdqSMX3mlW9/yuaU716O394cfMs9U8ZpL5MMQa0AXKoFqOnD5ZnwXIH
 vZF+eMMMlBSSAiaO++5t3AxYF/ExdnGx/ZUwiaZ4QAnjEGygoh6I7FPDakwX3tTrQQpNYzOtUtB
 hdXXqgkCCTpjfRrcOp2a427dqFbWG/CqNtAoc5UbCwholzTYI3SedAFp8OPYRU4klxysYnZBnzq
 I3NWhIyx8JovlkLZM7RKNaI27NMYhHXwrjFg9Z1BgUlLXl3QTiwQS3G7PagpFMq/k29NwNLi8c0
 i26FpHTrSuGFk7SVXEh/jG8PSZFdslCB0hLzZFEechXrz6CPZ6M0NoLSHCPfBAMs/fq8VZ3AJKz
 zygTBJJDZbav/jx0G4A==
X-Proofpoint-GUID: hmfd0OUosug86WgDgYEhSHQBsGXx9QWZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100128
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
	TAGGED_FROM(0.00)[bounces-70737-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C9F7011C88A
X-Rspamd-Action: no action

Export __make_folio_secure() and s390_wiggle_split_folio(), as they will
be needed to be used by KVM.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 2 ++
 arch/s390/kernel/uv.c      | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 8018549a1ad2..0744874ca6df 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -632,6 +632,8 @@ int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
 int uv_convert_from_secure_pte(pte_t pte);
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
+int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio);
+int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_from_secure_folio(struct folio *folio);
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index ca0849008c0d..cb4e8089fbca 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -281,7 +281,7 @@ static int expected_folio_refs(struct folio *folio)
  *          (it's the same logic as split_folio()), and the folio must be
  *          locked.
  */
-static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
+int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 {
 	int expected, cc = 0;
 
@@ -311,6 +311,7 @@ static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 		return -EAGAIN;
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
+EXPORT_SYMBOL(__make_folio_secure);
 
 static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct uv_cb_header *uvcb)
 {
@@ -339,7 +340,7 @@ static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct u
  *		   but another attempt can be made;
  *	   -EINVAL in case of other folio splitting errors. See split_folio().
  */
-static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
+int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 {
 	int rc, tried_splits;
 
@@ -411,6 +412,7 @@ static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 	}
 	return -EAGAIN;
 }
+EXPORT_SYMBOL_GPL(s390_wiggle_split_folio);
 
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
 {
-- 
2.53.0


