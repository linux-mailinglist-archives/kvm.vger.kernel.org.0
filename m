Return-Path: <kvm+bounces-70210-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNlCCfxgg2mfmAMAu9opvQ
	(envelope-from <kvm+bounces-70210-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:08:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C523E7FE8
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7558D3080F0C
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A52041C305;
	Wed,  4 Feb 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eIOeS1+F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306462D879E;
	Wed,  4 Feb 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217389; cv=none; b=L1GnqV5IRQGHwwoyRJsEJ3PxynTRcI9F8JMaWeMPFJ+Vk2d88a4xNgh1YguY2MaI4f5rqcKhonbbmBeQu+eFwCsLOY536wDHQNDm+i1t1rLj2NZGAlrJCLJzOSH4woSyA+e3qiT/teHFK0/t2sLAc094opVt508+8CpbrYZbGY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217389; c=relaxed/simple;
	bh=9YJhYzyxGQsOEJpcFJeaFUho+YsLDtwkF+hgJBjHvhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro0d/HJs5X3tcuKnp8X1PD43FMeRi7YIxQFvSIBb+NVc698ts1nHuKBB++aGjE2OsOkQ7dzWCcNnQafPMhDYK4vDpIyNmC6vvSLD+2bzHIztw1ik/8NdjZi12j9GrrkkV6z0SPyztraFsogI3UieJVD1VHIyPPe1xN5kdOzrjzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eIOeS1+F; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613N6c9d008818;
	Wed, 4 Feb 2026 15:03:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=z1DOOgHqufta6Fg5x
	p6jSQBL+c+NsNMwlN8dukx9jZs=; b=eIOeS1+FLTop6GduoF09S1/By8/p25Sjt
	BkdI9b4rdt5OLmt/H52XSOy98MERl/tEQEnVrPwsC1ZWN6TQVTWtGFt+1SXyq4UR
	xs+IjAF4eoKmKmsSAkHHXmB4F8pNpsxp9U3ajlM38gsD2Pfq3mHK3zv4Nf1XpTs5
	TEDbAMPHMnkS2OebDVThmnFle6rdSbK0TcIoofCYQcBgCYntsQoCDJr/uX/WmFct
	ToTJvM4iLf8Eej6nZjdCAyWqZkGgoru/6KsGnA6K0aCNJ8JScLoszoFYkXQgx2Oz
	Hwqxt6GZZTWtV5/Faki2NbgyrMx5Vk+6AK/HjBFSYtOct2PP1A/ug==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c1986jf5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614E05tK027391;
	Wed, 4 Feb 2026 15:03:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs1dcr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F31P329688504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A712520040;
	Wed,  4 Feb 2026 15:03:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65B8020043;
	Wed,  4 Feb 2026 15:03:01 +0000 (GMT)
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
Subject: [PATCH v7 07/29] KVM: s390: Export two functions
Date: Wed,  4 Feb 2026 16:02:36 +0100
Message-ID: <20260204150259.60425-8-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfXxdW1XJSujOqE
 qwzOdB10sM7k/x5abNDPVwcpU13/0zvdxpBMNFIszLRBx3S4I9nRlorA8urNLenmZMjKnL8A0sj
 DKfwf+obhpKvknyPWyE1xkpBNblVWHLO/wTDMk14R4ApWuHWo8UhJhNzzYHVUN4Ua2cNv+iTpPz
 xlNR8ZbeYkALW0dVeCWqlAEDE3YeJUdnFLdsmsCnbfQ5CKdgubmP4g8lKb6JCVuKnnCbvfiKBL7
 CJueYZS1IeetLKUFmXLObLI31ECqBiX0HDApdLyBSmKGP9sDR9d3bJaxM2G1JoUQhdduOZECT71
 q+XzkzWyj54YW/zbsRX8dCob//+fcIQHeHSO3GtkOpJ5sSH2w01cJnmKVPPOA2Kq9vRtfgz56V5
 8eBV1yLlGu7Zgj2ULjpB0B+UPGLZmunuHNv8oDwmhNvM0ObUIlzM8ZUb0l4MpN1S3T+hktiZxNQ
 ks5ZWN4GMLq0LpFZC9Q==
X-Proofpoint-GUID: QgSV8MtVXN3eTPPKjROnjRnpbjebCWBe
X-Authority-Analysis: v=2.4 cv=DbAaa/tW c=1 sm=1 tr=0 ts=69835faa cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=kE4rddDq9Ks6am3DDGoA:9
X-Proofpoint-ORIG-GUID: QgSV8MtVXN3eTPPKjROnjRnpbjebCWBe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602040113
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
	TAGGED_FROM(0.00)[bounces-70210-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 8C523E7FE8
X-Rspamd-Action: no action

Export __make_folio_secure() and s390_wiggle_split_folio(), as they will
be needed to be used by KVM.

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
2.52.0


