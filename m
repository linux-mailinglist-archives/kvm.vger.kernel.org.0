Return-Path: <kvm+bounces-70212-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EmmEyVhg2mfmAMAu9opvQ
	(envelope-from <kvm+bounces-70212-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:09:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E1653E8035
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 08DC23090AD0
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7A6421892;
	Wed,  4 Feb 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oZjWKczv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EAC41B359;
	Wed,  4 Feb 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217389; cv=none; b=B+YT6AxHNqxc+KNEeOzL7KPRvSmfmq3P8gbyDW3BfxwNAz0q8nRBXehVAlKsAv4XUb+Yx89dTStrdopoPpqvpZviv1ZOjxWJO2Zp1Q8lCPgbw8wVnBQCX4g64cCXpdS5P4K5UIUNewDooAhIk00dd3l52sxgQow6MaAT6DdSWnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217389; c=relaxed/simple;
	bh=2G/RNx8tFc20K9NAY2KiZ4CkWJ7nDB/pbKmFm1hV4Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2VMe+eVW/u2eyjpdh4ZYi2r/TCvNXHQ8RqLTPoK0/Z+qkDCvoD4Pqraj2aAcgwfIXmEWvjZ7Tyu8kcFPLJRuwx968G3bjoT+4wG3T88bY5faxW9iJ0Vz+jmBKjcbRee7sWy9h7yGpslmSCwnaBX7+0fo62lPjh5XxtTkbF2PKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oZjWKczv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 61408RTb021631;
	Wed, 4 Feb 2026 15:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9qirMlnR08lnLuOsu
	ocG1SXixr7jpbIgJF3CIcBfEdM=; b=oZjWKczvi3uD9IqkGeAffKvKQv1o44VVn
	KF4pypeX/bGAEp0F0uEetd8ZYPi4g3Bdh2Mq4sqvV1+sK/aZXleAOgeNjr9yT1dX
	G8NTXrmh3t1aK1e5p2gxfnl+RJnICO5BLdtxYCspJjw8Aydhn8SvUxwUT3SmODlg
	wt7w7eqkPOslANkidufOz7J5wqSFARP6ZpK0kyFp2XUrkb1knOe659tLDhz6f1xe
	W2NDSPAdLZwnLNvGQbbuHeHwabEcb1IvdrB1KVwsJlNe9SVrilQyfArry7Ver4MK
	f2a8u8zhwSMs6c8QwPDdCYFQwW7rLCYZAyjVghzNhgExamBI9UCeQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c1986jf5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:07 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614C9Q07009115;
	Wed, 4 Feb 2026 15:03:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1vey5s29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F31aC16777720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E0792004B;
	Wed,  4 Feb 2026 15:03:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11F882004F;
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
Subject: [PATCH v7 06/29] KVM: s390: Introduce import_lock
Date: Wed,  4 Feb 2026 16:02:35 +0100
Message-ID: <20260204150259.60425-7-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX8xAwTD2nPO+5
 RXunBXovkNX9LpSoBeQB8iiS/yxM7SC1RoeNKodBBE1QjbYe5HoDDgE9XXVdnGiEcf+8ogEUiDs
 YvasaGBF3CMzNEmNLQSuMKm+j+Vy/vx4wpfS+9vorguSZNPUWhysnUR/I6/DwWOkEG50gbyLZgh
 /CVx5xvLjTD/Vio4zPTAP87UEIwBg4FTMj+Q9335rjf3syXq4BatWQOElC65AKBOxmqZWXfdQOH
 zidKL8qa6fjmHY1TR92HA+SBVTBlKUK9SoYaJ/1WDvLjioFqlDHXGMpeganaaEKsZdMxwa49QnO
 NF4jMOv9gkW5DGMd/Nc12uYtzoZgtL+UiQwMzlWtrsS7k2w1VX7AmVmoefZr13ycCCZnjCEhBvX
 iDySWUzK7wpxAz4u14F7omOTZ75JenQrGq9iMYGWTz3lhEUW2SwM0pm+M//eCPqQQqIY+NgNFu3
 X2c+gjlWTu/fM7mhjUg==
X-Proofpoint-GUID: CkTnNpl9gYGbYk7wOXVeDTjwIFd9nvoo
X-Authority-Analysis: v=2.4 cv=DbAaa/tW c=1 sm=1 tr=0 ts=69835fab cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=ukBcN2NOhkw1kEjOR7IA:9
X-Proofpoint-ORIG-GUID: CkTnNpl9gYGbYk7wOXVeDTjwIFd9nvoo
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70212-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: E1653E8035
X-Rspamd-Action: no action

Introduce import_lock to avoid future races when converting pages to
secure.

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
2.52.0


