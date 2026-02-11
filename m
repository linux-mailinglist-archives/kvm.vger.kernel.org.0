Return-Path: <kvm+bounces-70853-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIweLqeZjGkhrgAAu9opvQ
	(envelope-from <kvm+bounces-70853-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:00:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F041255DF
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 83B1D3013FEB
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAC82BE658;
	Wed, 11 Feb 2026 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MEUfLNw5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD1F27FD56;
	Wed, 11 Feb 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822014; cv=none; b=lmCH1jNmFkDRj4Je16H8UM1fMyAN4QdmEROnx8OtQ5K6kDA8QcXNe+cI7yJam1qQYgWdVSMJBKigG25iUm0K/Uu29SVLAs3pttYfbR6lyE413F66idMfiitdlep0HYB1e8RcEGsStjIg615EQtTB7Rif2QyXGhpxWQ0nM/MsVlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822014; c=relaxed/simple;
	bh=jMSz23AJBHoUuV3NG76ng2VoHZykYKVs0O9Vq6qLvgQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g6Ak6t1n3g5AIyUR+ZC6+88Bj1I3RNHjrui11HmZOKHUIiYZfDUk6mqodrhEWFfay9CzBQNpxwaLj90dps9mwFce+Mx5xbk2tZKusFPfaOClpgMAW0hawN325NSOBSu+gU3noZKNN89R67xBv+w0Bt7pMxMHGAmuVVUsqr5LyRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MEUfLNw5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BCwxWL235984;
	Wed, 11 Feb 2026 15:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pdJ/OS
	CeZEFHenJgNDL4Wd5oYBaJNZJuCLHvAGxOycY=; b=MEUfLNw5qUXLP4EUlXwDSa
	fJcaxRdUK7LvrDhIwmlSYAjQ8/zJJXWHpZNXOz528gBTof9fLCYaFj2DIoOeZpiZ
	EH9q8CWdn0OWL83jf8K3s1lQVHayH20wPPYd4d70nwAUkSltyFye/Fdv0pssRrTJ
	mtLZ+RLUUt0CKivE6C3aA9varMft0dtpt71f6gJNMAk/KhYMAFwkJmCgqCLOp2ch
	F1w0DJ0bxG1cXAF3HooFoWbuRWhOxdk+sQNcdW7EcWOLQJ6FlTpEmDTYim7M0kQd
	Wkvq/LugjMVi/f+0tRHhmoCRs5pXicoCheHjFogKPvFJlqbpiVafKYJKcUPcZfCw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uhrr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BAnrWt001819;
	Wed, 11 Feb 2026 15:00:09 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je25xa4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:09 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BF053T30409416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 15:00:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99AEA2004B;
	Wed, 11 Feb 2026 15:00:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 41AD220040;
	Wed, 11 Feb 2026 15:00:05 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.49.16])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 15:00:05 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Wed, 11 Feb 2026 15:57:06 +0100
Subject: [kvm-unit-tests PATCH 2/3] s390x: sclp: Add detection of alternate
 STFLE facilities
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-vsie-stfle-fac-v1-2-46c7aec5912b@linux.ibm.com>
References: <20260211-vsie-stfle-fac-v1-0-46c7aec5912b@linux.ibm.com>
In-Reply-To: <20260211-vsie-stfle-fac-v1-0-46c7aec5912b@linux.ibm.com>
To: linux-s390@vger.kernel.org
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2259;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=nqQOjKIF4bgj9WUbH4ok0KxpFkKf2Cm8/bdDbxVXZxo=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJk9M4uXhTiIan1TsUt+FK6g3WUbKFCdqyZtuDDE4bDV+
 WUHpqZ0lLIwiHExyIopslSLW+dV9bUunXPQ8hrMHFYmkCEMXJwCMBH7ekaG15PunGPwzAoo9Z/y
 V20Dx7E3G+eY6K9fEVd2oqzz8OPwuYwMb/XN4t79/HhsL5sH0zZV6ZlWG2Nmbow9vj+66NodtuR
 CXgA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698c997a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=Dxa6YZADxO0mQfdHC30A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDExNCBTYWx0ZWRfX601yIyR7zenG
 QDMKaey4SptxSScc222EjqU6I8pX8MX5aeGJ3qjcjvkiYCDngOum0YJRyN/LLa4uAMRMAXNSPS0
 iHphi1i4AxDaezJtXbW19H7Xfc/nYFCum+TVZA6SrJewUxGliK0xNGkc2KvUylVoTJFpDWqoIGD
 ykRLKYmM1RKnGsqeffT00RUUfkYMNIt9ZDbCtB9q2UBg6xfuIy0WHpAY2ul/fKmRJTY0ob6Du3O
 QHsqmIK3n/Ls/lf2kdOL0FccqCYghwepiiu8CVRPqOaKbyxG+CCCdK3Lde7sLe8jRU78E5uMUub
 kYQQ5Rr/aNTaU+UkOLXcqH/Vg7JTkBNV0cR1a+GVcWUu/KiAG5ndeyydNXSNywUFep/kQAWYmNY
 SbzE7BGXr4ig0Qi3/8fpb1DltUrs8tPB3Li9Lc+4CCXTMZ3ITzqr1BNzQYHTtQGhKWoY1MfFq+1
 LEdUv9y2PijewqgbmMg==
X-Proofpoint-ORIG-GUID: Epz5pjyJNXgn92anD4qdE22VTE4Vh-UM
X-Proofpoint-GUID: Epz5pjyJNXgn92anD4qdE22VTE4Vh-UM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110114
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.5.7.0.0.1.0.0.e.5.1.c.3.0.0.6.2.asn6.rspamd.com:query timed out];
	TAGGED_FROM(0.00)[bounces-70853-lists,kvm=lfdr.de];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: B8F041255DF
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Detect availability of alternate STFLE interpretive execution facilities
1 and 2.
Also fix number of unassigned bits in sclp_facilities which wasn't
adjusted in a prior commit adding entries to sclp_facilities.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 lib/s390x/sclp.c | 2 ++
 lib/s390x/sclp.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 2f902e39e785ff4e139a39be2ffe11b5fa01edc0..7408b813b6396d572d740c19c15175e173fed596 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -163,8 +163,10 @@ void sclp_facilities_setup(void)
 	sclp_facilities.has_cmma = sclp_feat_check(116, SCLP_FEAT_116_BIT_CMMA);
 	sclp_facilities.has_64bscao = sclp_feat_check(116, SCLP_FEAT_116_BIT_64BSCAO);
 	sclp_facilities.has_esca = sclp_feat_check(116, SCLP_FEAT_116_BIT_ESCA);
+	sclp_facilities.has_astfleie1 = sclp_feat_check(116, SCLP_FEAT_116_BIT_ASTFLEIE1);
 	sclp_facilities.has_ibs = sclp_feat_check(117, SCLP_FEAT_117_BIT_IBS);
 	sclp_facilities.has_pfmfi = sclp_feat_check(117, SCLP_FEAT_117_BIT_PFMFI);
+	sclp_facilities.has_astfleie2 = sclp_feat_check(139, SCLP_FEAT_139_BIT_ASTFLEIE2);
 
 	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
 		/*
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 22f120d1b7ea7d1c3fe822385d0c689e5b3459fe..91a81c902eaa8ee6b999184aeb8a33633efd1065 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -129,10 +129,12 @@ struct sclp_facilities {
 	uint64_t has_cmma : 1;
 	uint64_t has_64bscao : 1;
 	uint64_t has_esca : 1;
+	uint64_t has_astfleie1 : 1;
 	uint64_t has_kss : 1;
 	uint64_t has_pfmfi : 1;
 	uint64_t has_ibs : 1;
-	uint64_t : 64 - 15;
+	uint64_t has_astfleie2 : 1;
+	uint64_t : 64 - 19;
 };
 
 /* bit number within a certain byte */
@@ -143,8 +145,10 @@ struct sclp_facilities {
 #define SCLP_FEAT_116_BIT_64BSCAO	0
 #define SCLP_FEAT_116_BIT_CMMA		1
 #define SCLP_FEAT_116_BIT_ESCA		4
+#define SCLP_FEAT_116_BIT_ASTFLEIE1	7
 #define SCLP_FEAT_117_BIT_PFMFI		1
 #define SCLP_FEAT_117_BIT_IBS		2
+#define SCLP_FEAT_139_BIT_ASTFLEIE2	1
 
 typedef struct ReadInfo {
 	SCCBHeader h;

-- 
2.53.0


