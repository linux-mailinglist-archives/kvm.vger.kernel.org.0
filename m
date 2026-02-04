Return-Path: <kvm+bounces-70215-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iCUwNnNhg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70215-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:10:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BFCE80F4
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B3C81301C11A
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89ED0421A00;
	Wed,  4 Feb 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="L8LwRJ6v"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A75D421890;
	Wed,  4 Feb 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217390; cv=none; b=OYBQRqZpONn+OfuTMBfWwz53tmpmjmiQULUkXrxgNqOq+dSUUegCKm2KREsJMT095t749CUgZ2mhGLSIOETQxBL0lwg+BCB/9qCNXoTcx/HECqKGAr/iPPk0BI0OZOeip46v+Cbk8BPueeQy7byITtELuna6TnJv7zR9kAf/U0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217390; c=relaxed/simple;
	bh=9J579RODsBY3NHU28XOdCR6DAB1tRTgjQOLebDa/iz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utkspyojGFOiwOfaJkUKS1642aQ0MPZHDK3xbTcA+N8ScllixBC7YN78nq/ggBGcaeI6LDKlQQtFdshFbE/hnzf643FcGa5ST2RdLOCTKRlyrWy6aZ1EhikfVw46TnAd1hECPJbWV6PP0mZp0pq8zTrQCC3PYdUnMgWCMT7ufTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=L8LwRJ6v; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 614F228Q014475;
	Wed, 4 Feb 2026 15:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=oOx4bRoIpElNi+6/4
	tyln67C51SNBcTtwkDt4dOQoUw=; b=L8LwRJ6vDQvKHjeBWZF0K8O+LSn/YuHRi
	TjjZqGJRVAdfEk/a7iiegK6047WY2PCVxEAK9NbYRzrG0a64ZbKhAtn4+w9Ao+jv
	dMJ1DhztUzD5aYf0Fmo1VniH35OL102Wdih+cVbo0gw7wRnebCUxWGSniNHTz2AR
	z2S54AdfNRQwhizduVDIM02KTHj1G6i39h4Sk5F3qqUBMDvI43x6x09WFo2BMP8N
	gEdHzf6tsKXD5mMy7PGSsOaCMWfldwLw9OsmglmoCLxCV5ohtXf2+EqQKofOhCYA
	6Gr1YeMTPdga7CSy4JIpFM3wmg0B9plI9wSwAk/sHf2dR92fgvzVQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtad6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614D1fOZ004411;
	Wed, 4 Feb 2026 15:03:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjwk8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F32sv43975124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF96C20040;
	Wed,  4 Feb 2026 15:03:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEB3E2004D;
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
Subject: [PATCH v7 08/29] s390/mm: Warn if uv_convert_from_secure_pte() fails
Date: Wed,  4 Feb 2026 16:02:37 +0100
Message-ID: <20260204150259.60425-9-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfXyBnAd7/AiFXG
 NqIZ8otL826+ELG1ypCe15/2ypbCO7027oPOJk8c8Xi5mMIyjtBlmCVMWxkOvSmSdmBfkW7ts8M
 aQtN0+REDPJH36pROLG8lAASouSrmAIWloAZQ9Spgh/iSHbMTfP5F7Wzc7BRiII7QsR7upBVa8a
 QeUrwgZxqaryhbnaoofZxj43Kp7OnDcUXKCjp0WUQFqBCUUkj18FmbrYTX7iotN0s3tkwyRH+GS
 pYECrw0UmdFgy9Ocq8a+3pwy1LS5xJjk9QA/X/3tz86zJ3+J7WimEXXj4f4+V8PTjRBCUT3Nitd
 KWzMKTGkP1rgJe8fAxf4mo6T8nun3NE39CZWScUcHtTE4qCP8NOSzluvQpD5y7+8MSz/DZ0aM6W
 nGZ9M1vGOJX0Obfo6ACdLspi/Pk5YayQ9+DjphqwWnYzp1NKNr6vJqM0N5qrmh9fi7ufdHM+wQJ
 3UiKnNpYDpfy9S0dsOw==
X-Proofpoint-GUID: OBo_1wYLNWGoA9Tb0Fh3liAmLAa0ft-n
X-Proofpoint-ORIG-GUID: OBo_1wYLNWGoA9Tb0Fh3liAmLAa0ft-n
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=69835fab cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=gEHK17p0qXyn9eJGjbgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602040113
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
	TAGGED_FROM(0.00)[bounces-70215-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 65BFCE80F4
X-Rspamd-Action: no action

If uv_convert_from_secure_pte() fails, the page becomes unusable by the
host. The failure can only occour in case of hardware malfunction or a
serious KVM bug.

When the unusable page is reused, the system can have issues and
hang.

Print a warning to aid debugging such unlikely scenarios.

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
2.52.0


