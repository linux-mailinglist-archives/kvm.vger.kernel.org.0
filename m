Return-Path: <kvm+bounces-70759-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CGr1FV9Ri2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70759-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:40:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDD411CA30
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:40:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F3E33059ADC
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F02E38B982;
	Tue, 10 Feb 2026 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HI3UA8cu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654CF38A9AE;
	Tue, 10 Feb 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737690; cv=none; b=UMzPkCAW29kSCdAgO98Kwk80L1F9wsrf00/H2UlXVBzKOpeHIooZU1yJSd8gXfThh/Qx0ILAaE410XMTC09QumAlLt3aSineqlEVeohtc4bDWAARqYcirgH0Uuz+24f0abzWz1/bd14yrrs6OknI6RteztV6ud40EjZnNnt7mB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737690; c=relaxed/simple;
	bh=++JmWPr6Z66I3Tvwjqhaml/aaDF67/71nmUbxiH6CVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0xJmmWs2v2TDv9IhvK1PinmJUXpHk46AKOZfXzkpk8fYt60tSc3LxU9TJx2VUBG4eGiXo7V5l82wqtEQil9S1Fas3a8aBwMDmksj3bzAvYsfv/PIbARgDAQy6ua5f1+t/mQX9ghS53eWH8YPhinr1HQuzGCR2c4168fdUPp724=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HI3UA8cu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A8gYCS192099;
	Tue, 10 Feb 2026 15:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Gz1i7epnZCD6hc/Y7
	Npe7SqYOy23d/g6gS8PHyZvNvs=; b=HI3UA8cugeI7ZZQU3TbPHEVccODhS4AnF
	iNonBTFK7lBr+E7oCIQK0HvnEM7UX75VheJYaGUN3pdP7Ctyjaq0gIwgs8kmCeRz
	urCViNyXbxM6uPpZImwE00I76oSOISNwzS9R1S5XB3AYAK2ATDispwK+/w5mPMyA
	WbEhLxKtejQYzrzIDBP+dZ8VqZ16Tzvey4W/jJaK3wQdMgPwdW5jp3zqJVC2p2FV
	4V9PHIKBXD3F1uJqA4k8/ojGZUara9juDrmc3yfPZnPLEaB/U3sUVwPILgTSUs1I
	ycx6qgHcO/fmHGxIY6JOH2otHkEK6xiV6r3Pyb6C3BcmIggcpUZeQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucwgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ADc6fq002548;
	Tue, 10 Feb 2026 15:34:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6fqsj1w0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYblX47645156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4022920040;
	Tue, 10 Feb 2026 15:34:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8E7920043;
	Tue, 10 Feb 2026 15:34:36 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:36 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 33/36] KVM: s390: vsie: Fix race in walk_guest_tables()
Date: Tue, 10 Feb 2026 16:34:14 +0100
Message-ID: <20260210153417.77403-34-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698b5011 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=Xpc-Ysi5efBL8YaAkn8A:9
X-Proofpoint-ORIG-GUID: OWg9T7oMO_ypz2Ar_HCFo69KQBg3Ejgm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXyOwLB2nk6Lba
 ohAKy+BGY2fAk9JCGfslrl/5skWBwGdcv8DMzAh5hlLuHg2U4kGfRubLISML1XrZEQPha0MeCt2
 tQexAL6/LfdtJswG+jgQe8j2TSsEWAqF0jLICy7k2olSu3Oglt38HZlzKl4DyWJf3w/23+SsDQ4
 Y/DYeHUDuvQ60h4QT+I0nT+qOcuPkT0aAyOjCTWw+KGD0coGPIN0jkeZKUwWgupIsP2sq85OeLK
 h0ZH0E3r9ZfXfpUpYDQLALw5NYVMtdFLb1k3ns33kfs+K+OoC/NpPQwLJVmKbFAQnwSYds0diuO
 KKavkAeJ+WmSfqt5DTdv1G3qhZlGjtxqv2trdenIeYz/K2BYE3V841xuT513H3X8LZQppYCnHkC
 u2Pnjr+KhsEhFS/+M6JFc5MiHV/2M+I77UkWl6bLHOD4kfKSSfW7Yra5vFxX/t1PImlCK6wUdAP
 uuwkgx5IazVNmNgy70w==
X-Proofpoint-GUID: OWg9T7oMO_ypz2Ar_HCFo69KQBg3Ejgm
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70759-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: BDDD411CA30
X-Rspamd-Action: no action

It is possible that walk_guest_tables() is called on a shadow gmap that
has been removed already, in which case its parent will be NULL.

In such case, return -EAGAIN and let the callers deal with it.

Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 67de47a81a87..4630b2a067ea 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1287,7 +1287,10 @@ static int walk_guest_tables(struct gmap *sg, unsigned long saddr, struct pgtwal
 	union asce asce;
 	int rc;
 
+	if (!parent)
+		return -EAGAIN;
 	kvm = parent->kvm;
+	WARN_ON(!kvm);
 	asce = sg->guest_asce;
 	entries = get_entries(w);
 
-- 
2.53.0


