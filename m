Return-Path: <kvm+bounces-70755-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDCTFiNRi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70755-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D104511C9DF
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8B5423055017
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BFE38A9D9;
	Tue, 10 Feb 2026 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i41ixdKr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAC938553D;
	Tue, 10 Feb 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737689; cv=none; b=M88R52dHh/pXG/1wGQdqaFvc1NTByjLLwrRshEHbnA/E+EW3A/1avdjtXabGIvRbb5PtsblnY/ZUqX7Xzh1Tt0BiytOiB8ydksC6xipwtMgHI+DzoRyl5ZAW1jIIr3Yna08UKL9U2UCqlXIKEPzOBdAzFlP9pK+DDzPltuVMWJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737689; c=relaxed/simple;
	bh=naNR+aZ6HCFRAdHC2i3nYdgkd5DcKUNWbdfHhV1Ldwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5TXwBFwrMdSJR7lElPjy1fEmWDfwO1h2lasGl7OSQscjJlbGhE1EYtXsJICKxDgVwxwZXPRxNPuO0S0CMnrapVwpNs4JzFyJCrKcpt4MTiq+pJ1aH220nxUSXK7uoYIrfuAubn7yFs9fhvRsMga5Tno34xWwSplqvtugInA5sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i41ixdKr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9Qu2N224811;
	Tue, 10 Feb 2026 15:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IdMANhXXphU6TOpbj
	qX/rSmYvFAHP+sSizkqNWtNVFw=; b=i41ixdKruKxFMUFTAovsF48viswnK1jR2
	hs+3oYTwTLimGqetsw3ObL9oS4WRQgjsw5HP8U/A6y5fiyu6Ki9nwABAA6lEUFm5
	VzStVi3pJyon+UilBvxm4sscykv2YhEAWH0rS/Y7uQdwxhyDE99NY8xFacCgnBer
	h8jqs7/TZ1O1/bAJqxFabDHEuGFyNH9iUn2is/84mBLTOdp/0xE3J/aAQv0+XXoE
	lZynvnZDdQV0Prerxs8QiN1eF89W18iJJXb2GHwFb2A+Yiwgx3MitVv4rOpr6ou2
	R28S7OZ0gmAm+GTaNqP2U0Y5UaHGmtkjsuIP87IOwxr1InY4SZOeg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v2qmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABwoUN001833;
	Tue, 10 Feb 2026 15:34:42 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je21jd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYcaa42991914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A1902004D;
	Tue, 10 Feb 2026 15:34:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4FE720043;
	Tue, 10 Feb 2026 15:34:37 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:37 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 35/36] MAINTAINERS: Replace backup for s390 vfio-pci
Date: Tue, 10 Feb 2026 16:34:16 +0100
Message-ID: <20260210153417.77403-36-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: IbnGN9hQNMyUKqwuCpMAY7n16NCAkXu0
X-Proofpoint-ORIG-GUID: IbnGN9hQNMyUKqwuCpMAY7n16NCAkXu0
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698b5013 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=r1p2_3pzAAAA:8 a=VwQbUJbxAAAA:8
 a=P-kxdRkxCln11g2Oxa0A:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=r_pkcD-q9-ctt7trBg_g:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX2P08rlTur8FA
 fak5TJYvDkadVoQ3AbThIhEyO5l+bJp3owCm2/4oRsoTpZLFDy4RH150rEsQIHFYTYuR9+M66LZ
 DPTa+mUHhLzlh3+5UCJ401vfRqSLLA3ClgsVyXvqyTdPz/gF3xB/TPoWBCrE+OrbF0VGb45wz9W
 40AZvWuDcAUvMa+xNMQ/CtoRlAWExR/QQA44cfhfLNYJRnLJgf/RkQf4wstrPo0qOomIpM22e7W
 qVm5qiZyWb5TvwY4NJQre30CJIcFPk7F349aJM/YLg2w7oqqmDbT5sn9+hQxTILkewrOkHX+r77
 AnQmehUFTzhxIYeYuuNmuig+HLAP/++zx2cgBVrRMo/SJKJ058JI2+jM/Z7tEPzHpvB3qu0+TjO
 4S+1WQhwjdfihX4Kvw2hdX7+CBgu6DNEFcNlKGt/dU/dL93X5pjzW7l/SkwXElYKC5TQkKD/re6
 j18eYlELdq9xm8j3YOg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
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
	TAGGED_FROM(0.00)[bounces-70755-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: D104511C9DF
X-Rspamd-Action: no action

From: Eric Farman <farman@linux.ibm.com>

Farhan has been doing a masterful job coming on in the
s390 PCI space, and my own attention has been lacking.
Let's make MAINTAINERS reflect reality.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Acked-by: Alex Williamson <alex@shazbot.org>
Acked-by: Farhan Ali <alifm@linux.ibm.com>
Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95448b485fd2..51063f30c577 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23072,7 +23072,8 @@ F:	include/uapi/linux/vfio_ccw.h
 
 S390 VFIO-PCI DRIVER
 M:	Matthew Rosato <mjrosato@linux.ibm.com>
-M:	Eric Farman <farman@linux.ibm.com>
+M:	Farhan Ali <alifm@linux.ibm.com>
+R:	Eric Farman <farman@linux.ibm.com>
 L:	linux-s390@vger.kernel.org
 L:	kvm@vger.kernel.org
 S:	Supported
-- 
2.53.0


