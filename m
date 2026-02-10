Return-Path: <kvm+bounces-70736-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cB3DCU9Qi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70736-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F1C11C882
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1AAE83006929
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8877927A904;
	Tue, 10 Feb 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oCNjS0mb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2638171D;
	Tue, 10 Feb 2026 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737671; cv=none; b=h1HJ3fkj+YLpNnak0YoAfqu8emV08dB2bRG+buBXZrl1A18TmmaPnHZT8E+9wUX8KZwIGc5FwkFaBu7mArELj9O966iKsNCmk3ZSiLh2LRmRwO20mnKLmAOmJdfSHSdNd1excp32m2Owv/0DBRhB1EwrdKmwrN5yeUY+nJmrcR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737671; c=relaxed/simple;
	bh=cdd03Yai7kb7C+zE/Qz1oTCYTSuCkjSA4p7CpeSJF+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii9MdeB6GZFA008MqQPylw8rjnTH1oOv/rknJKllvD8ixe/4D7iZKnrLw6HwROsOZ3fGXCDy6JOWGhNyLU4YnpGuPVRF/GAknGywdcCSdIrcx9Y9jMUR1c3/wg5tmnxaoMbQcaazEz2HUwGD1exQZ50JLGJZSvk++5yUbZIF6+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oCNjS0mb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A3jb2Z3537614;
	Tue, 10 Feb 2026 15:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0MFfFMqcvy2MT7NHg
	YY0U032J0eX2HMMhp7yL1jZa0w=; b=oCNjS0mbdPy6ZUi6kftWtjOJD9kVTj+bS
	LBgcEMVZci8PRwI/G4IcRJy6tlzU70Ioq7INl+7hWZP/+UNDhDYvGAPECDT2e1ZK
	ybC5moP9LG2LLWUggniGWxcoEAOGqlU3irWswUv/yfT4YOKhC1FIJ30ndC1VHt2B
	dA6kJoqVUOWKCeDETfbNmJSvL1NqDDFgH9kK5/1uIJti0ddbdul1/rU7kfolQPxk
	c0RHkaDdfgbXaDTUV0OeurzU8OhFHM9bWHmTqYHnY3L+lnJVocrlI1WiUF5/IdFh
	A499hw6gxFQj52hS3cQZT8MtQ0jZ9+sk0JYk7y+qCt/c3ESKtWqZQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v2qkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AB5Pvh019221;
	Tue, 10 Feb 2026 15:34:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk1nvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:25 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYMid16646630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 025E220043;
	Tue, 10 Feb 2026 15:34:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D76D20040;
	Tue, 10 Feb 2026 15:34:21 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:21 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 07/36] KVM: s390: Introduce import_lock
Date: Tue, 10 Feb 2026 16:33:48 +0100
Message-ID: <20260210153417.77403-8-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: rhKvNzl4rLL2SN3kcfERoElg43Z1LTVC
X-Proofpoint-ORIG-GUID: rhKvNzl4rLL2SN3kcfERoElg43Z1LTVC
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698b5002 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=ukBcN2NOhkw1kEjOR7IA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX83vzcerbrUAa
 jaBBGieXznalYI0D9omfV5HrEXFaae4LAAVHXGzLgkXWJ3G5n0eMwjGyGkkUuSl7pWbw79qpUrP
 ND/S3+AyZ+ukPA/PL349og6huIn5w2EvQCFki/AQIrPqXtAyKbzYAKYIzq0elMmjsKVqdesfNZy
 7V0sYMKSnpNf9gmC6h3pRwWUwfYsYnjq0bTlxe9/GeQxOOjwiFOcOrQ3UkJjVF33VjhXNIqLSYm
 WyCdRFJoebvEccTvyvUO1vvWMMzzb5DeJ06gaY0/7MrOy8mUf/dfundinj7eRAogQCQ33Z8LeGc
 L7GL3OfkoJNgTUX3QsHSceYazwlOx06xBMXrzspoNcbjepRlYZUU5DUAbJFv8+qUlTututLj/8Q
 DA1tq57CVr8524ZdY0j4eJBK0cPMoW7JYfXw+ZUq74TQ5TGgbk80rpHYhXy7TnyliYKuJzwAB7O
 IOOSuhYvKtSmLQS8Jrw==
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70736-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 74F1C11C882
X-Rspamd-Action: no action

Introduce import_lock to avoid future races when converting pages to
secure.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 2 ++
 arch/s390/kvm/kvm-s390.c         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index ae1223264d3c..3dbddb7c60a9 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -630,6 +630,8 @@ struct kvm_s390_pv {
 	void *set_aside;
 	struct list_head need_cleanup;
 	struct mmu_notifier mmu_notifier;
+	/* Protects against concurrent import-like operations */
+	struct mutex import_lock;
 };
 
 struct kvm_arch {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 56a50524b3ee..cd39b2f099ca 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3330,6 +3330,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	char debug_name[16];
 	int i, rc;
 
+	mutex_init(&kvm->arch.pv.import_lock);
+
 	rc = -EINVAL;
 #ifdef CONFIG_KVM_S390_UCONTROL
 	if (type & ~KVM_VM_S390_UCONTROL)
-- 
2.53.0


