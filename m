Return-Path: <kvm+bounces-70732-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCjFFylQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70732-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA2111C82F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8FE04304BC1B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2EF38550C;
	Tue, 10 Feb 2026 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bF8LCdLx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B922EC09B;
	Tue, 10 Feb 2026 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737669; cv=none; b=s6S68JmbaeN2g4r7phis+FNHPBhtES4MgEMNI6GILh7LH7eWOCM7kWIyzLg8hSibE0Q5y/W9mBxlva0W2TJ7YdJ3Zl/yB8SgFUudN8WiJoh2yOT0byi7GpZhlq2+jHsZbbnqeUByILZYU7nx6FGBC44kC1RjxvXg1J6aVQ3sBYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737669; c=relaxed/simple;
	bh=p/gOpi0D7OMrt6kNeQy8qase9TgkdVKaAlFfz0PV6ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZyqPcXzecnVvykCPa80hngA6dDkGzS8aR5+SS0S48+HXe4Om0n0a+5JgEabanvub948SIFavhLMjF+ySK8qiJ8r0KkPj3cyMlnu0zCyowmrvdw3V6JEmESDrxP2oueLFthHRqdG5FDr3RNNt09LCFurG5DjorUsOVmpVzDgdkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bF8LCdLx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AA7Fe0328612;
	Tue, 10 Feb 2026 15:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pKqlgRAY2lBdS7BZm
	AZ1T0IyXXzM2JNX/rOIrchCiVc=; b=bF8LCdLxeohvl//JkAptHr1qrSjzNvriW
	vqpMpPw1yoVEzg4WOaoNQmZDUsCVVlN05Wk+cEqx7seuVJZL2A5d4nVf8VEvEfbj
	pdOJK+EV9AE4IO+ypMOqS89gxPRN8j9bhWqSr3JWdqqixU0Xbs7vYdat157UO3G5
	SSw/kQPi+S5nu4uKHAyk6KmnYNFlgshaO6rn9RVT4BDgOuuNw65gClmopJ45/kxd
	0WuvIQCrvBTJzP5a4cWK9OghFzDMC4UoaF6zKP67gbFgOg5BeU03IwE1SgEeBNPK
	7ZJamVZD//+VH9uyJthqT1zFgS8VSdcPKPq2/KB5aVIZcy1KwFOJA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uts1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABYTSa019258;
	Tue, 10 Feb 2026 15:34:24 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk1nvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYKOH59638074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 412472004B;
	Tue, 10 Feb 2026 15:34:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C31E820040;
	Tue, 10 Feb 2026 15:34:19 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:19 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 04/36] s390: Make UV folio operations work on whole folio
Date: Tue, 10 Feb 2026 16:33:45 +0100
Message-ID: <20260210153417.77403-5-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXxgztr73ETiqP
 8ZB0zVp/VG9sIaFg5iBBrr2b7To91A3SO5ZnEcuJNqe6yAiLqLHC4YUX5N8yntZgVOjXwQJheHi
 6pr5ZyhveE9hrKKrSIEGGJjQtoGDBZOscVw1wIFDDMHwKt1j3CN5iatQXrE5i/xj9ReaBQsgAre
 Om8Nno1m8mfHgnuyY6wcmonLGIJ3Yk793/1OPfI5xcMnoPiuoMqw7tDajutuyHN9JL05dEGkfdT
 0Q1F18kQ4krazgK9Gw1/LiLHduuM0a0kitr+rSj7ngVc1IjaTTTO1KYwPUBHVqnLj+TnuNk4jMd
 9QTRVKudZbm491HAXJe6gBX49VjjCYqU6HmQZQ6EpOKdNVkeGHYKPaq7dGs1G0q5iK5w7NxRRHI
 BR3wo+VoRnajg0vQHfRAzpBaT4CYVOefP8/WBDhPSOcvoCNStcIz/q+fG+SWuJXo0Z7iCR/mvFj
 O5SI1cZg/ONZry1kxWA==
X-Proofpoint-ORIG-GUID: k8nnA1fvfwD99ZH4Ss3mgc4FwEHSD0bZ
X-Proofpoint-GUID: k8nnA1fvfwD99ZH4Ss3mgc4FwEHSD0bZ
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698b5000 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=56eYp6RrapUnXBmR778A:9
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70732-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 0BA2111C82F
X-Rspamd-Action: no action

uv_destroy_folio() and uv_convert_from_secure_folio() should work on
all pages in the folio, not just the first one.

This was fine until now, but it will become a problem with upcoming
patches.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
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
2.53.0


