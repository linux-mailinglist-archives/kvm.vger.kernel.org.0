Return-Path: <kvm+bounces-70738-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNM1B11Qi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70738-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56EFA11C898
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 634F43015EE3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE76B387363;
	Tue, 10 Feb 2026 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HsSPLcay"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E330F3009D2;
	Tue, 10 Feb 2026 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737673; cv=none; b=LhxuqxXVt80lwK6vlvpzbOxyPejRazcQyrHyRnZdExHk6vtMnLkdCEty5/hiCrwfOZBX+VDINnbxELfIRV6LJ6UK7ARYz+qqU6tcdK0pFuTK9mo5FSo3vUVmEyEZVIOurK8b25D2+pnWMHHxubvwTED1x8LlE77BPp1M+7zm+BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737673; c=relaxed/simple;
	bh=Iikfvg25RgwHQBRdXnCtsVuXPhSONRowGwT6Xoz0qbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWHNKqJwy8G4BtBCo/PjpCVYwDrwTFAei2g9waxCuLXOpBpLMrLcKwUhga5hkw6gBWcOCWIF6pTukOLQpmeYtnY3LfQpdzvOzP0t4FRH/rCRJu3ky1UQCVBcAi6IRsGZFhbIFBQLfTk04J79tbiavajbqW140R/F8xUdog6kSJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HsSPLcay; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A91WlL225970;
	Tue, 10 Feb 2026 15:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=kZ0WpbJ/6u6lg/lx0
	wiAak/rTeZ0PS234vU0fsqEWCo=; b=HsSPLcayWevC52rKdce15LJYLyIIa3QwW
	kWtV+dvayjmtD3Y+ByiC9UYqWReDSaA6ja/1xjtYaJPQnMG5flytYcpyS3wEAuHm
	EadmOJqhEDHUYSkPPgfH70Ku5jHRerP2P4qHsH/xplUT11xvhAlq3tMgpILt7O2s
	TjJxmE+/uUgiDgKdTTWwddOIbzuEplmpfJUiKcOVg5Gw6v1HsERJ6NtJUNfZvD83
	Qbv/Huup5YCnggKm+DxAU4ln8+LnXb1aDN9Rw3hyTVIrCl2AUTUOL2KgT1xuV6Rb
	W+/F+anzTfufMKceQ+m/4ywk4FuQqRwVyQ297pAdFbLAGKZTuJAEA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucwfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEOkqN001479;
	Tue, 10 Feb 2026 15:34:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn1veu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYN0A49283414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25D7520043;
	Tue, 10 Feb 2026 15:34:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6FFD20040;
	Tue, 10 Feb 2026 15:34:22 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:22 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 09/36] s390/mm: Warn if uv_convert_from_secure_pte() fails
Date: Tue, 10 Feb 2026 16:33:50 +0100
Message-ID: <20260210153417.77403-10-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698b5004 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=gEHK17p0qXyn9eJGjbgA:9
X-Proofpoint-ORIG-GUID: YtMJYbPl4RtqY8bS3j6kcDYFH-fOWv0R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX1kN5jqn8a3C+
 mlrgr25o1/ihMJ0nO27aPQGF3wQT/C70VLXJ/F3sSpPpdDCrLodI/QylYQe1Fz5B/q921Dv9Iun
 VVISKz3rpbGuDG77RVJV5FlwyS9KHRkJahmr15RlLxKV280RjXNBuNECtxMqzfQhROTik8GE55K
 4y95Ey6ASyG16LBVfviJLihqsRPfu7/jvV7P42dDMTpEVwgsk+ocmGjxv6maEBWrjIiHuRMr3HI
 YfRcEhQKdscFNoVOYkRn6syr76mt39Bdx3kTZRd360/02gpJ+jv/a4JreXos9Cz6DsboyazjH12
 DuSJufzCrgv43lzRScUY/sJ3znpAC1+7K/X0lXMMnQjI8/UDxcLi7wS4QQ3tf1v/I01o5Ztq2kJ
 t+dKicsVYW0ZcERJrW6HFOUUCL1sd9pYet+XotXaATSOzwFN5AH9YItzYgdOvvbpXWN7Y3Tcai+
 Ehfhw6BUBQMqWckPnZQ==
X-Proofpoint-GUID: YtMJYbPl4RtqY8bS3j6kcDYFH-fOWv0R
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70738-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 56EFA11C898
X-Rspamd-Action: no action

If uv_convert_from_secure_pte() fails, the page becomes unusable by the
host. The failure can only occour in case of hardware malfunction or a
serious KVM bug.

When the unusable page is reused, the system can have issues and
hang.

Print a warning to aid debugging such unlikely scenarios.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 73c30b811b98..04335f5e7f47 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1239,7 +1239,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_from_secure_pte(res);
+		WARN_ON_ONCE(uv_convert_from_secure_pte(res));
 	return res;
 }
 
@@ -1257,7 +1257,7 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
 	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(vma->vm_mm) && pte_present(res))
-		uv_convert_from_secure_pte(res);
+		WARN_ON_ONCE(uv_convert_from_secure_pte(res));
 	return res;
 }
 
@@ -1294,9 +1294,10 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	/*
 	 * If something went wrong and the page could not be destroyed, or
 	 * if this is not a mm teardown, the slower export is used as
-	 * fallback instead.
+	 * fallback instead. If even that fails, print a warning and leak
+	 * the page, to avoid crashing the whole system.
 	 */
-	uv_convert_from_secure_pte(res);
+	WARN_ON_ONCE(uv_convert_from_secure_pte(res));
 	return res;
 }
 
-- 
2.53.0


