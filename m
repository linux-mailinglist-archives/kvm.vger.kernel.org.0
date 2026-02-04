Return-Path: <kvm+bounces-70217-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gKDKKIhhg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70217-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:11:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF35E810C
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 78B463044592
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5ED421EFE;
	Wed,  4 Feb 2026 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K058GrJE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1B42BF002;
	Wed,  4 Feb 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217391; cv=none; b=n5Z9ZvjI+nBcXLgviSqq7LDDil4ywMsr3xUl6HaXL/3gDsM2ot9irEunTAdS0lwcB6zgXJRFr7D+RGm99mlZp7BiLewICUGIzeZNh5J0IAhWZY28XIxsOqWSafz3OJpd9/Mkh7rIDamYbR0TwQnuLUoSp8rSjZchyz94lcUSlRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217391; c=relaxed/simple;
	bh=KKJC+YnSQfRueC8R5pCG5k1inUq4VYQQ3SDb0JxrwfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR8yYvZBjLN2UkQrHfA8qepSw2J2ozijgDgG/96dRxeCInmvY5NHdoWBUq+l44UzJsIE1vGoyxMu5YGetyxhDm/ct9R6LDYcjhkPWrDLmwMaSnoexEO/aYFMEZQTz4E9ptBAX4IykjXO180bkuMHBg+s3xx3+zSpX/8z6Kv4EG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=K058GrJE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 61417gWB014178;
	Wed, 4 Feb 2026 15:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HX2NRnK5H2nIdD2i/
	6mgkh0Vo4qi+8ItWn9NM+weks8=; b=K058GrJElbujo6c1PORl0ccCD0UnqyZ8I
	4A6FWg9IcsckjhujQQOI6ld1H4lxveDnEpytDtzUaW18cp9bDYLS7iccsL1lY6fL
	Pe/ft9JKZl72wPt6Hv5XAmSIF8xZz6kYRrkqd7cgxL23TwxKEZkZCwwJfPOnG3W7
	N9bTFGkNIjBfmmfH5LQVFB9WCY3uxVqeX7cLy5zuQjftJTB2uNHVcHBmLWuiJeQv
	lY5JmaNJ591GYJ+qRmmLfwuH22JCNIWL+vNJqILTnt8UWZ+lFwNrq90r+FKXi1U0
	9KFLNSPVDXfKZlk/ZtkadCmLuC2CH4KEZmfMgK3LZV7LOzi7BdDAg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cw7rna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614Dc3pn005996;
	Wed, 4 Feb 2026 15:03:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1x9jde54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F30Jq57606576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 692E92004D;
	Wed,  4 Feb 2026 15:03:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 282E72004B;
	Wed,  4 Feb 2026 15:03:00 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:00 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 03/29] s390: Make UV folio operations work on whole folio
Date: Wed,  4 Feb 2026 16:02:32 +0100
Message-ID: <20260204150259.60425-4-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX3eqmY//46mwP
 31NCYE6TFPFHJelR2+VyS35z+Zkdi/AKvdxUWKoKFiW3U4bRQrq+csB9ZEhmuaO14t1yMyPKVu3
 l/ao6l+yHAkbtmnODbngmJrKun9H+nkdB8AJtPLxWH0bHdM9vn/BQ/u4+xu+O8v/i7vPPN8wR/b
 3i1g36XFcmw63C0Pa9FMdgD+b6CbuiCcG6Di4cyzbdgWJJeIb+o9GkNmg6B2KKnK9Bhnv6XZkMi
 jherSXv4YguOCWXqvoo3Rjq5coGVQ1IiFeiv2XZSiAMsQy0hiJFLRMmco1ot3NhcAfDUWLBbY+9
 vur1q1jtRVG9iXjEQ8cj9XMpkMMjTCukN/4vrtPy6IT4AQtROCS5rKqZ3jP9DSDt545dssHpT8a
 axtnnWURtwuIyhdawQSoa2eBxfiTTGhj3pOgKW/Ewar0OxJsGf3GM1CERkaxHME9/fl+x1s/b6V
 HQcsD1APNpjmdqpiW3g==
X-Authority-Analysis: v=2.4 cv=UuRu9uwB c=1 sm=1 tr=0 ts=69835fa8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=56eYp6RrapUnXBmR778A:9
X-Proofpoint-ORIG-GUID: y3_J4by3HLekC6oxvoHdPSQFtfUe7E5x
X-Proofpoint-GUID: y3_J4by3HLekC6oxvoHdPSQFtfUe7E5x
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70217-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 1FF35E810C
X-Rspamd-Action: no action

uv_destroy_folio() and uv_convert_from_secure_folio() should work on
all pages in the folio, not just the first one.

This was fine until now, but it will become a problem with upcoming
patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index ed46950be86f..ca0849008c0d 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -134,14 +134,15 @@ static int uv_destroy(unsigned long paddr)
  */
 int uv_destroy_folio(struct folio *folio)
 {
+	unsigned long i;
 	int rc;
 
-	/* Large folios cannot be secure */
-	if (unlikely(folio_test_large(folio)))
-		return 0;
-
 	folio_get(folio);
-	rc = uv_destroy(folio_to_phys(folio));
+	for (i = 0; i < (1 << folio_order(folio)); i++) {
+		rc = uv_destroy(folio_to_phys(folio) + i * PAGE_SIZE);
+		if (rc)
+			break;
+	}
 	if (!rc)
 		clear_bit(PG_arch_1, &folio->flags.f);
 	folio_put(folio);
@@ -183,14 +184,15 @@ EXPORT_SYMBOL_GPL(uv_convert_from_secure);
  */
 int uv_convert_from_secure_folio(struct folio *folio)
 {
+	unsigned long i;
 	int rc;
 
-	/* Large folios cannot be secure */
-	if (unlikely(folio_test_large(folio)))
-		return 0;
-
 	folio_get(folio);
-	rc = uv_convert_from_secure(folio_to_phys(folio));
+	for (i = 0; i < (1 << folio_order(folio)); i++) {
+		rc = uv_convert_from_secure(folio_to_phys(folio) + i * PAGE_SIZE);
+		if (rc)
+			break;
+	}
 	if (!rc)
 		clear_bit(PG_arch_1, &folio->flags.f);
 	folio_put(folio);
-- 
2.52.0


