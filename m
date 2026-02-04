Return-Path: <kvm+bounces-70213-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNl+JDNhg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70213-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:09:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC27E8061
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 938453094F78
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43F64218A3;
	Wed,  4 Feb 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZDy7EhYw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F5841B36D;
	Wed,  4 Feb 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217389; cv=none; b=n3XYU8lUOpehw4gJ0MeChqxoHBtshO2ix0g1ML79QqNBCVOOMTSm4l6EtDhj95HmgDDYoHuCKET/JzO7GLPaXHbx5j9f1sGy4Kz+PVTnjsFcMEX0U4K2IXgKveHUh2nmUDtXek/ewSde57wCcpxqKI+edW7xzlYOivpr2ICu890=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217389; c=relaxed/simple;
	bh=ppddRHBjjzuGKYC56DMR9Y/6uMZxA+vA361WbAMUQjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLxgUagsIGl7F8bnh9MZRELWa/47ZaE+I7G67mTU9pR1YRw9S8dOGTVm3lpZkQy5Qkdyhb4u8Q1UN04bdv02FLvgyW0Iq9gYWRC1Q3g1zh05QeuCwrbqYSq0xxNaaMx6XiJ/EM5rv6i5bYo7J6FMyqJUSpr07njs8MSNOvWVlA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZDy7EhYw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6149VkGO016593;
	Wed, 4 Feb 2026 15:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=53+6YA0gHtcxVllIt
	onUc6YdfZpmIkiOnoO0JHtuaEQ=; b=ZDy7EhYwCShykWabk+oCcN4TGVZmr3T78
	Vf4AYsrSxfaXg2/rEW07O7mFUgXOzfbhmdAkufqnb5Y9OHmKenf+hvs+E5wm/he5
	YL9DVNytGygDC/YxURIBcZVDdCUWrWQBTJt+X8ji6taZ+WYBL9ZLcTIAm4DtGgB3
	2z+1xD7e7EvVz2Dm8tmxhLAvbF3r++KQ1ibfjosnGk5yyehvKVLZdJDnfyUKvcPG
	iSSSP7bMgA1fRHDIXA/yDmpJ2pIwpVzqBEUGzPeQk4VmBV00S6uZNMLp7+aV4Aph
	A30bO+qhFs+texMkUlBqQaGeVMTJMA5VpPZqKwkxnROP4a1y32baw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185gyw6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614EP2Y4027348;
	Wed, 4 Feb 2026 15:03:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs1dcqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F30XR57606578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B117C2004B;
	Wed,  4 Feb 2026 15:03:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70AA720043;
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
Subject: [PATCH v7 04/29] s390: Move sske_frame() to a header
Date: Wed,  4 Feb 2026 16:02:33 +0100
Message-ID: <20260204150259.60425-5-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=69835fa9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=cwyL-bC_1qH1TysSW8cA:9
X-Proofpoint-GUID: d8fLPXytuwIq-LUUZV29sDKVdqYH2iAQ
X-Proofpoint-ORIG-GUID: d8fLPXytuwIq-LUUZV29sDKVdqYH2iAQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX7fsom2Y+PQVk
 GV207boAikW8WXnpETheRyM9RS10xR5jBvezkkp4TLJ2OAxuUXLYaPPJQVRnOZqJqfIoOR3/Www
 S9iMPjcOcgcgywSN5OauUjPirx1r8fyLf/11nP+6SbnN1v6GUMBvSk6pzf9dHAFos8DygIAzCTC
 lE/7JYpFZjoaQ4j/NKnbIx1tjAzt4435++++srSamOEwKylFHjnwGea8VfUsX30Jj9EzZhlIRZG
 KS73cmoi6tddvf/gylaCoXAvBztgy2i4bOUQP129Emu1NcVsNUbBC88lBhsx32QX1Ehr9onsCR2
 xdFGfDfdrP1Q39J6L98sU+voiFtmpJaSC0Vr6VEdyDJ64xRt/2+Am8uG0F/HRgt4wEV3twgrpJ2
 lKx0GkdLjI5Y5SF02Zce6Fcu5WM55ZHjk2BRnOLUmt+63Th34U3s53IJqh76dsAElr23vSJeofF
 8fnQo/osEY78OZdBQBA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
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
	TAGGED_FROM(0.00)[bounces-70213-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 0EC27E8061
X-Rspamd-Action: no action

Move the sske_frame() function to asm/pgtable.h, so it can be used in
other modules too.

Opportunistically convert the .insn opcode specification to the
appropriate mnemonic.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 7 +++++++
 arch/s390/mm/pageattr.c         | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 8194a2b12ecf..73c30b811b98 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1136,6 +1136,13 @@ static inline pte_t pte_mkhuge(pte_t pte)
 }
 #endif
 
+static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
+{
+	asm volatile("sske %[skey],%[addr],1"
+		     : [addr] "+a" (addr) : [skey] "d" (skey));
+	return addr;
+}
+
 #define IPTE_GLOBAL	0
 #define	IPTE_LOCAL	1
 
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index d3ce04a4b248..bb29c38ae624 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -16,13 +16,6 @@
 #include <asm/asm.h>
 #include <asm/set_memory.h>
 
-static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
-{
-	asm volatile(".insn rrf,0xb22b0000,%[skey],%[addr],1,0"
-		     : [addr] "+a" (addr) : [skey] "d" (skey));
-	return addr;
-}
-
 void __storage_key_init_range(unsigned long start, unsigned long end)
 {
 	unsigned long boundary, size;
-- 
2.52.0


