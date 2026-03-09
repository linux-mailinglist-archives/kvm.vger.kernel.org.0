Return-Path: <kvm+bounces-73291-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMH1E4HDrmn2IgIAu9opvQ
	(envelope-from <kvm+bounces-73291-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 13:56:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CF23239456
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 13:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A51133037781
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 12:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0569A3BED40;
	Mon,  9 Mar 2026 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hzb5bzNj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23593BED49;
	Mon,  9 Mar 2026 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773060916; cv=none; b=QtBfOqokwAhJWpa2MwDnEZvH2j3LX1e/fekjlVLR6VxBgdLg6DGEaokAHKJxrrzXL5QgnnpvEJgY2lXtTu2HNOxMxzr8VTvs5OABF1A6PAWuZArg6Qbh4Lnk3Ckd9xyJNY9zCj9CBYj+x556jK98sdgvW055bhcoGbpAhHDCWwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773060916; c=relaxed/simple;
	bh=5I9cd50v1THB+1Clgqg/lET9etv9+ao3QZC0UzBGcHA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pYnneyj3Y/MTw7kmxThDA3qX9toGOBDDalqYOzvcr3iYVcFA9IS3nsrO6tW8Q1RIDYDxYrnbBFZv2m11CRAHYmN/DxdQqFRSjsij2zeu1V9V3mAMlXzAHZ8MBNSHtqE1FYN3vG+5qs4WiBnG2o03QJpcVWQX4gdJV5MczMm52QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hzb5bzNj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628N0A5F1562598;
	Mon, 9 Mar 2026 12:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=th6hcJYC8cFNrlVzWCd1U+DwEXjoYb9AjfN88whJT
	8k=; b=Hzb5bzNjLaKlFazHsNNozenEpXS84W3LeSMOGllQe8SC+jYcxTRN0AgGU
	WH7DI/qVNvRdLrrWPnj3+oVHYL3VAtKZarZekfTrY1s0hXOBGQl2Qod1pQp/zxyS
	ycmKzy4J8Fil8qr8l6kZXNQoiSNxwG1iPIRD5fxZNxFIR0cVYOEu2gXNTCSSBjqf
	Nm8WbTLWnT1pPX3Y9cPsXP4z2cLMW0GSK4CrC55PvOVQv7w4qt1BlclfZFlBEnVr
	uoZnVIYCZHl+PxtJNzvv+4QWoiy2LS7VgjPdHrVSdHsZ5/EfGUJrP4jqq+yjCmr1
	fhK4Ye4eEPqfd6MrzAGDpAxZns1Wg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcyw6j2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 12:55:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6298jdGj029625;
	Mon, 9 Mar 2026 12:55:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4csp6uhkcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 12:55:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 629Ct8re30409092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Mar 2026 12:55:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86C7A2005A;
	Mon,  9 Mar 2026 12:55:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6ACBD2004D;
	Mon,  9 Mar 2026 12:55:08 +0000 (GMT)
Received: from b46lp25.lnxne.boe (unknown [9.87.84.240])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Mar 2026 12:55:08 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] s390/mm: add missing secure storage access fixups for donated memory
Date: Mon,  9 Mar 2026 12:53:15 +0000
Message-ID: <20260309125311.31937-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDExNSBTYWx0ZWRfXzO9uMr30qL69
 nWp/uKbl0r49iQ2jd17MkMog88J+ix5Ffg8/wIuoF6J95K9qgfNklMPNtBHMRe5KWgF8SKRbJ66
 8wEUZXWSSlc91pzyx4FBGROg+JrmAh2SUTBuMQYHVqmkiuZRyzpIiDdm6TcVDtJYc+QDApKCdrN
 oANOkpYECxXMv4ez/YlYBYwjmwHfIFWwvekE6NbarSnCG2hyaWu9YRhqPzWzud49Mssu5lfEgnc
 UF+a1Vc6VXA99aofdYHQXfvykORB9U9S9FyBPXU3NY42NJxqsUR5HP+H7c31Sp2283svbmXdLvV
 C44aIZVpgW5FngoqAuAsl0XgGEw5m1R7wKa8dg58y995pK9hSEGwALZ/b5D+VvC7KaRN4mZKpMU
 a+FAWBX/JvAlHqRZMEz1sxhj+Y9HHVPA8wclKnC+FuDxGLMCuTeiepTfB9v1R2zeD1ADPlZwzfR
 CHAOLRPvfLdQJr3CkFg==
X-Authority-Analysis: v=2.4 cv=QaVrf8bv c=1 sm=1 tr=0 ts=69aec331 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=cntIUc9hOoCxFZL8CegA:9
X-Proofpoint-GUID: PTisIy52DYmP8fSX-qWT8zLHLmmAfJv0
X-Proofpoint-ORIG-GUID: PTisIy52DYmP8fSX-qWT8zLHLmmAfJv0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_03,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603090115
X-Rspamd-Queue-Id: 0CF23239456
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73291-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.989];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

There are special cases where secure storage access exceptions happen
in a kernel context for pages that don't have the PG_arch_1 bit
set. That bit is set for non-exported guest secure storage (memory)
but is absent on storage donated to the Ultravisor since the kernel
isn't allowed to export donated pages.

Prior to this patch we would try to export the page by calling
arch_make_folio_accessible() which would instantly return since the
arch bit is absent signifying that the page was already exported and
no further action is necessary. This leads to secure storage access
exception loops which can never be resolved.

With this patch we unconditionally try to export and if that fails we
fixup.

Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/mm/fault.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index a52aa7a99b6b..71bad4257aab 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -441,10 +441,15 @@ void do_secure_storage_access(struct pt_regs *regs)
 		folio = phys_to_folio(addr);
 		if (unlikely(!folio_try_get(folio)))
 			return;
-		rc = arch_make_folio_accessible(folio);
+		rc = uv_convert_from_secure(folio_to_phys(folio));
 		folio_put(folio);
+		/*
+		 * There are some valid fixup types for kernel
+		 * accesses to donated secure memory. zeropad is one
+		 * of them.
+		 */
 		if (rc)
-			BUG();
+			return handle_fault_error(regs, 0);
 	} else {
 		if (faulthandler_disabled())
 			return handle_fault_error_nolock(regs, 0);
-- 
2.51.0


