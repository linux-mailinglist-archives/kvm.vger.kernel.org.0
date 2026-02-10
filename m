Return-Path: <kvm+bounces-70758-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGU9Jx5Ri2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70758-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B26FA11C9D8
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 786D8303F855
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECB238B7D7;
	Tue, 10 Feb 2026 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F3Ejr6ff"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028B13859D0;
	Tue, 10 Feb 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737690; cv=none; b=pQFH1dr+FGDRSi9jUdJluol+NOMmw+gMPNx3AsVxDGuIw0W06g6iGAcDezvBoIeGQhGlH6krPter+SeNhBnJswOtDz9zs6+osZKS8SoPy5gCQuka4Pt8+hUK+ZbWYYVUm9iQzP486GJUNmjvjsssWTqTAu2372P9Snwbh3aXqo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737690; c=relaxed/simple;
	bh=eEXjVJiaE4J75ZBDDO+E7nWnn1zZWVctG9V17gH+jo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4gHvu0CZ/MuOknkElMTS3tFeSpY+KppovGipYgksL4hQehUcuYaDRCTijoH6Ex0Z+/mlI7Qwhx+TSpIg26Ug9VKlZ3quVgGw2bD9yA4hTW47aePtHOGMXIPGWHXlEpvj9loPZXxfMOFu+2hHNJe2GyGjhujo+mFzoy1MLpTfis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F3Ejr6ff; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9xmck034466;
	Tue, 10 Feb 2026 15:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=8YQO6Xi2XJHjLOCJW
	WBbM7aF+6rzT65iviz62GwhPMM=; b=F3Ejr6ffi9hSdh/XCWobXlGN7FFdRqRg3
	va+SlXlgN8IlVdbKQwrM991F6UHHsjOA6hLIzJ+QYeDGcHNAZ4rMIKV/NbW9SGcI
	TFaQy4L8EWXncPulQFByF8D4+UYphMP1lZlxh//YJr2+6Z740wMTaeKyKK7d6Yfp
	4uxWTLHRXhEGAAt0xQGXhRcqxTfwHa8cDLt/acmt06MPiDQg3Dudtt4G5IcgSE/P
	5GuxjlYr47zfVkWTZfT2yl5S5sMkBr+g0Lv1EBfxOqlJF7u/df2pfqegSZZaYiqz
	DTknd4/bNnDdKjN21hM+Vg6x6m2wwhGFqdx54Q8nVuJxT2vXPg7+A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucycf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:43 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABNOVB001837;
	Tue, 10 Feb 2026 15:34:42 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je21jd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYdjS23593342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A2C820040;
	Tue, 10 Feb 2026 15:34:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8472120043;
	Tue, 10 Feb 2026 15:34:38 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:38 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 36/36] KVM: s390: Increase permitted SE header size to 1 MiB
Date: Tue, 10 Feb 2026 16:34:17 +0100
Message-ID: <20260210153417.77403-37-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698b5013 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=D2ETlDs0240gq-PhJq4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXwsgySlRTZWCR
 vJO/nQ8R3j5hXI4oMnV663/0O/ktjPRMpE/ztgFxB/mJ5nghLZvnLl6YY0M4DHbxri+uWvTkZlO
 WAgs8t3aYnTWDWi24f1w/c+/z2LR574h4MXEV/JtN/wP/oxtOWw19XMP6WDkhZ6MCwvRG9UQDu9
 MuquDl5x92FCMOaoTw7n7ZWBfOeh1zR1l9cgAS3bFfQKozTrrh8MlB76aXQQbEAI0tEbznpwRfv
 9rRTU5q8GYUDOG5+uHEPsoEavzP7RkNM8fdVLnyAhwgOF36H4bf9z165BV8P0ppi3JC47NxgeQg
 C8nf7YYRFEjE3yKdf8vWNk/RJjgQFORsHBQW4osOGv7nsgdDNvWdb2vk6n/qHWcedOERrunWDhv
 xCj/oA1bPuJT97dwX+7SXQElYd827zsYUR+IA8w7S/iI8rN7J4W11o2JOQKJg0qrZrO4ZF4F2e2
 kt1mnuaQq7CK52kDoww==
X-Proofpoint-ORIG-GUID: 7V4qFo3H4rSz2Ogy3x_JMlTj56S4V2ST
X-Proofpoint-GUID: 7V4qFo3H4rSz2Ogy3x_JMlTj56S4V2ST
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70758-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: B26FA11C9D8
X-Rspamd-Action: no action

From: Steffen Eiden <seiden@linux.ibm.com>

Relax the maximum allowed Secure Execution (SE) header size from
8 KiB to 1 MiB. This allows individual secure guest images to run on a
wider range of physical machines.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 9f24252775dd..de645025db0f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2589,9 +2589,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (copy_from_user(&parms, argp, sizeof(parms)))
 			break;
 
-		/* Currently restricted to 8KB */
+		/* Currently restricted to 1MiB */
 		r = -EINVAL;
-		if (parms.length > PAGE_SIZE * 2)
+		if (parms.length > SZ_1M)
 			break;
 
 		r = -ENOMEM;
-- 
2.53.0


