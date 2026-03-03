Return-Path: <kvm+bounces-72554-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 5m2gDd8fp2kTegAAu9opvQ
	(envelope-from <kvm+bounces-72554-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:52:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A15691F4CE1
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 451943058313
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 17:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1062D4A2E15;
	Tue,  3 Mar 2026 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SOIBuoC0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A6731A053;
	Tue,  3 Mar 2026 17:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772560345; cv=none; b=AOYMF/ZT2pDw/hDYBbEJHbB1FVUNdfIw1LV9XUaCT7wiE1GpE26rwIVwL6rdC+QBcctqHZgdknd0vBLN3X38OnnB6jFVHMX7cYI1q1GViyUGMHOnHMYJ65quPXWN99BeQ7NtLxIuOrKNEDyLjy0/myPm5bllzSpOzr5qNjdQa5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772560345; c=relaxed/simple;
	bh=q9y2qqxdQ8Bsa4heMLQ4qi/SJGEWhvc1j0Xgy0nxXCA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UVhPRwbtjnuJjpV3pmTuT1IRNRxazSwz8TEbQ3x+b8vX6LRgLIMz8XPW7Sr3PtK1sr1k3+3RrgAOwRv54ea1uMYWbvQwskeoKazdBpBZB4kXsIvCAE3Og9VG6XRGGjxCZM7NL+yyPZLLrqgtSHspoWKQ9eEWy4GlLSKhh7Pl3jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SOIBuoC0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62386YOn2216780;
	Tue, 3 Mar 2026 17:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=tuumb4BzGxNH5SWy3cof/U3TgcGWqB9kJ+iVRdVfO
	tM=; b=SOIBuoC0VHwPYP8ipk5tk8U6IbreqTtLlr50f2oGsqMfY6FumwZPwzJTP
	x1jNfygTe7I0KRciOouhUKYDKEARjlU4y8ZQqlShwgYg6N/K1hAHeO4Uht8NhzY/
	TbNkEnYu9qJUnkXjKjguB/h4U3Ouf1xcuxEAwRj+j54MHdk1SyuTz8EXM7WwUdmb
	RD5+LLmh/N4SHbF4U6dDqjtdaxxTYqB3ebo4+C20NlWwo+JX+AwKN7uexgB4dmDp
	zLbLlfjJ3x8eNEm9vKromC+AUspfSBZbLnSr0sK5U1pV8kHgNCmFD69dOyBdqHDQ
	bm3AGsjBa6OG9T1S/vCpIu1+BiJcw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskcv6na-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 17:52:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 623FWX1U027733;
	Tue, 3 Mar 2026 17:52:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmcwjb4td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 17:52:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 623Hq8kW46334386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 17:52:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B7FB20049;
	Tue,  3 Mar 2026 17:52:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6254920040;
	Tue,  3 Mar 2026 17:52:07 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.18.245])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Mar 2026 17:52:07 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, david@kernel.org
Subject: [PATCH v1 1/1] KVM: s390: Fix a deadlock
Date: Tue,  3 Mar 2026 18:52:06 +0100
Message-ID: <20260303175206.72836-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PBaeN14LYjKSxauLQKyTTvM25MO5KtkK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDE0MiBTYWx0ZWRfX6PVdHQ/fKf6i
 +VrcThqcPj2FID06dYjp6i5kOoqSt/JpQaFFiMCO3LCNmvrjOiruC4YC/bwxKQ5lE71Uxmr3jJT
 4PUJoKufz8VezXo5mATDmu1KoZWVKi8dXFe9grP6GVOm/UV3dVCAs+mQP/gdjBup+W/HLrBbKUU
 soe7bAnRbx0TkS0kn040UOiAFdLdlxN5tJi/uwBYZegENRsn7kit6kfAS2x/gRcJfsBERKlPEmY
 I8LD8sQVeSRCijlVhJizszjRJgdJmoi0dA5VMXn++J3KE5ktneSS/Ab9DmVWqErS13iVeUErHcv
 aVuHPwY8ayVbN6lPS+C9+fPuovEAySYSk2TPvjNg2QrdjzO5Spxx4+5a0G2XJo4FmPqioxzKHiq
 6Iu4U3p+UftTxQdBuJkKXH+n/oRJAodIdyx2Invjm87CYoqq1Wj+Tyuxde81CV2wAKbn1xb3uSZ
 PbHn47iPcEE1oDXbiSQ==
X-Authority-Analysis: v=2.4 cv=H7DWAuYi c=1 sm=1 tr=0 ts=69a71fcd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=MFxHPMzSBJxkdh7CuRcA:9
X-Proofpoint-ORIG-GUID: PBaeN14LYjKSxauLQKyTTvM25MO5KtkK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_02,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030142
X-Rspamd-Queue-Id: A15691F4CE1
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
	TAGGED_FROM(0.00)[bounces-72554-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

In some scenarios, a deadlock can happen, involving _do_shadow_pte().

Convert all usages of pgste_get_lock() to pgste_get_trylock() in
_do_shadow_pte() and return -EAGAIN. All callers can already deal with
-EAGAIN being returned.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
---
 arch/s390/kvm/gaccess.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 4630b2a067ea..a9da9390867d 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1434,7 +1434,8 @@ static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union
 	if (rc)
 		return rc;
 
-	pgste = pgste_get_lock(ptep_h);
+	if (!pgste_get_trylock(ptep_h, &pgste))
+		return -EAGAIN;
 	newpte = _pte(f->pfn, f->writable, !p, 0);
 	newpte.s.d |= ptep->s.d;
 	newpte.s.sd |= ptep->s.sd;
@@ -1444,7 +1445,8 @@ static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union
 	pgste_set_unlock(ptep_h, pgste);
 
 	newpte = _pte(f->pfn, 0, !p, 0);
-	pgste = pgste_get_lock(ptep);
+	if (!pgste_get_trylock(ptep, &pgste))
+		return -EAGAIN;
 	pgste = __dat_ptep_xchg(ptep, pgste, newpte, gpa_to_gfn(raddr), sg->asce, uses_skeys(sg));
 	pgste_set_unlock(ptep, pgste);
 
-- 
2.53.0


