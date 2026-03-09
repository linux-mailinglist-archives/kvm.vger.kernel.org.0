Return-Path: <kvm+bounces-73286-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHPsNxe2rmkSHwIAu9opvQ
	(envelope-from <kvm+bounces-73286-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:59:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E46A238501
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9DF413019FFD
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 11:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFB839B490;
	Mon,  9 Mar 2026 11:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k+U1zGBW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7259C27603A;
	Mon,  9 Mar 2026 11:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773057553; cv=none; b=M4FauZcrA7e1mr82TtX/7Gc3bVkRpGTg5ol5vidgnn2xw34tGL5rriB5YwlpH+wy5g2DtU1ER3NiduWmodonK84ne0X7KQnE29lhXs/S7JEpxaRE4de01xiv490d9o8KLp+wq7yZUl1qGwNuOIb7tqdDxdEqgBHPZ1aJdSOnnHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773057553; c=relaxed/simple;
	bh=UWcEZh6dGXYV5Oga/9d2Cw6hQhOQBzfP6cV8V/cI3M0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UI2wsDYSnLh9UMBdHEvG3H+0uqv+PdCXiCjwdKnUWl1e7WoxjqhusPC1tFoRqNf+0ZgEGhIXDYCfpmFIH04CtO+ai3uNLn5/z9fo3GN+ELXAMx12wQZ0u6W+uejifqsCQdJn0UMGXxVTCFynsYY6ztZfPdJ/3CZLAZkJ5wPD53U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k+U1zGBW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628NVe6h1619828;
	Mon, 9 Mar 2026 11:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=P8wmXXEGtjAtWjPktMGFDENKnLwtFJW8fNtMWJ3To
	ww=; b=k+U1zGBWb1UsO+X7fdH08dPaf5g7YoyMkrNmTF5ckwtiFiCUYWPr57dor
	TSHq8FAk7elFpqsgbjWlp6gIle9BQkmxUTKT1iF16wJVK4kNd4DfiadyCMm54Zf2
	Pj1MLywT9DsmBlTMLpFLsyvb3KxI5BUd+SqzJuPvvYXthMpgeKP5OQe9hEqlI60s
	8tFwsWz5I15EVmkBm7pI8QuHcDKJgngf3CYRFk4EwdE49HtfIe1dKe0mnsG5rlZH
	CNW/gn0XpLLhkOVoPy1/ySAShyGu/y0Qhc3uA/HzfOPO5h9TvoF3aOHFKFDGWTLg
	36xUbHEGBJUUvrk3LKJS92np4zo8w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcyw6bn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 11:59:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6298tvQR021389;
	Mon, 9 Mar 2026 11:59:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4crxbsmxfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 11:59:08 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 629Bx5jP56164652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Mar 2026 11:59:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E6A620043;
	Mon,  9 Mar 2026 11:59:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DBF6F20040;
	Mon,  9 Mar 2026 11:59:04 +0000 (GMT)
Received: from m83lp52.lnxne.boe (unknown [9.87.84.240])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Mar 2026 11:59:04 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: KVM <kvm@vger.kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH] KVM: s390: log machine checks more aggressively
Date: Mon,  9 Mar 2026 12:59:04 +0100
Message-ID: <20260309115904.7280-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDEwNiBTYWx0ZWRfX0G3oQmpUQywV
 sx2aqBHPkfPGOzGPdSbuaqsMpvU/zG+irnBrP8GEHUecrsgpYAnMMr4F8vPVDbGOg2YbAplIEJa
 7VZJZtGM4YK+Pg+FBAKW7PocdgCG7a0Q7RQ3Uu0elHGFiIBS/Hg1Uhhu+rWOjdsGdSaV19Q+B8d
 AjsmZZCrSP4iVWteuHEwX0YvGvpUnx/duqofPmDEeLPNizaAI/18mkfEcSHOB/imwp5HcUCBuYv
 2sopqN+6b7ZjX2drJZP18SujgZBPn0y5uzNmVBsIQjrkJDCpqY5LNEiPf5bIuI/IqMoHWpxUkVg
 pr88DJQTzQT/9Sta1rw4t6zYgnsLFrhmQGAFpdRzYCf4wf+0NnXbD2YGhwnJ7Otdx4RPCgGBE+r
 NJEwZAUgeItqSwiJtqoYbn/+VjTsK7gh4lr59nZp7vJybnfL/j8uIbFL/Zgb096q72AFzRpSxkl
 fl2AyyIt/7sL9jnrxAg==
X-Authority-Analysis: v=2.4 cv=QaVrf8bv c=1 sm=1 tr=0 ts=69aeb60d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=AY7VfyBuPtHfJwy2xJcA:9
X-Proofpoint-GUID: CSKr9KQKKQ577QbdeJBrpPy6F6dS_oaA
X-Proofpoint-ORIG-GUID: CSKr9KQKKQ577QbdeJBrpPy6F6dS_oaA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_03,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603090106
X-Rspamd-Queue-Id: 5E46A238501
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
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-73286-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[borntraeger@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.990];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

KVM will reinject machine checks that happen during guest activity.
From a host perspective this machine check is no longer visible
and even for the guest, the guest might decide to only kill a
userspace program or even ignore the machine check.
As this can be a disruptive event nevertheless, we should log this
not only in the VM debug event (that gets lost after guest shutdown)
but also on the global KVM event as well as syslog.
Consolidate the logging and log with loglevel 2 and higher.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---

 arch/s390/kvm/interrupt.c | 6 ++++++
 arch/s390/kvm/kvm-s390.c  | 1 -
 arch/s390/kvm/vsie.c      | 1 -
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 18932a65ca68..9885d4bcb6ae 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2824,6 +2824,12 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
 	int rc;
 
 	mci.val = mcck_info->mcic;
+
+	/* log machine checks being reinjected on all debugs */
+	VCPU_EVENT(vcpu, 2, "guest machine check %lx", mci.val);
+	KVM_EVENT(2, "guest_machine check %lx", mci.val);
+	pr_info("guest_machine check pid %d: %lx", current->pid, mci.val);
+
 	if (mci.sr)
 		cr14 |= CR14_RECOVERY_SUBMASK;
 	if (mci.dg)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bc7d6fa66eaf..1668580008c6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4634,7 +4634,6 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 	vcpu->run->s.regs.gprs[15] = vcpu->arch.sie_block->gg15;
 
 	if (exit_reason == -EINTR) {
-		VCPU_EVENT(vcpu, 3, "%s", "machine check");
 		sie_page = container_of(vcpu->arch.sie_block,
 					struct sie_page, sie_block);
 		mcck_info = &sie_page->mcck_info;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index d249b10044eb..c0d36afd4023 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1179,7 +1179,6 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struc
 	kvm_vcpu_srcu_read_lock(vcpu);
 
 	if (rc == -EINTR) {
-		VCPU_EVENT(vcpu, 3, "%s", "machine check");
 		kvm_s390_reinject_machine_check(vcpu, &vsie_page->mcck_info);
 		return 0;
 	}
-- 
2.53.0


