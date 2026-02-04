Return-Path: <kvm+bounces-70228-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDLQOjdig2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70228-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:13:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D625E8288
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:13:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A31A7300D359
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468A7427A03;
	Wed,  4 Feb 2026 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OiHvoJwN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C685B426D18;
	Wed,  4 Feb 2026 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217397; cv=none; b=aakU0BjhDcOiRSyq6tlEUZPUb6knmiddMHywVAAeA0S2761AdNJ+ySyT/hxoCDOLfXcHQySl6AtqtPXVpMdNSe4atZyNkBt0/CGBtyoDlk0+nnvmDKIb5bIS0KDfZS75zcP3CxhnxRRZY0h4lod9VN98KOJzLSSHqghnzxUcmWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217397; c=relaxed/simple;
	bh=iaDeeAoqyQexpm0v5nF88NpyzLFFGn3GmxMmLhX7GXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkxqX0gEqixzKVsUqspR2fpEc1Yj/rnT+MUJPyDuAUmV+D4EdtL9d4A/zqTWlUzG7WlZLvh1W+j7LAe61hnJ3oKt8BgzqXL//h8Vm5SBLrU0U7nb87tCBEuvTHOEa1bM3kmcfULZzhsNRPybBJj3eXFKGGJbJXXnTF5nks7pLXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OiHvoJwN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6142HcSH026415;
	Wed, 4 Feb 2026 15:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ns863W8Wv5bMVsucA
	hesthm4tlT4MBzu/kPxzIiikfo=; b=OiHvoJwN7KNfeYGsoFD/MIWsjKaZXevJY
	Vk+qLM1tpZEK7H0gJPqFSS/M2IDnJtqQ/UwDPQS1NMd7wpTBeeJ0GI9SsIvFEB2H
	FOGKzZOC23JIxHwwk5crmjRluyRGPkYd7uGTNOhkQ+SuBTRwF9QTsmoJczKD1xsk
	bbeRH6Mgw5BJcc5w1/Z1z7tXcCVlQ4J0w1ylolJMLAuvehn4LdOKYEkq04Pf0hp1
	aVTpIf1lcISrkCpu1FdZXtV1J9SSMa1nit3juYrEw659+HqvVWd8xx4/V1BICXpH
	16Sj5zaLmFAvAlYoYJo+IEJcP38vfwdgVSwTPX0Te7ajyKBBwG24w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175n00fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614C9rYJ029053;
	Wed, 4 Feb 2026 15:03:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1v2sdsq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F386M15598010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EED42004D;
	Wed,  4 Feb 2026 15:03:08 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E4C42004B;
	Wed,  4 Feb 2026 15:03:08 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:08 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 27/29] KVM: s390: Enable 1M pages for gmap
Date: Wed,  4 Feb 2026 16:02:56 +0100
Message-ID: <20260204150259.60425-28-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: FJarjiDj94UGvX1A0WsCm68wUcWM90Or
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=69835fb1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=2DwSK8QdlStOok5YbGYA:9
X-Proofpoint-GUID: FJarjiDj94UGvX1A0WsCm68wUcWM90Or
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX/f5Szz06VE5y
 zYtgjsGzLILIfBrgwGccHzS+7hWG3Ai0K0bBJEyZD9eI2McMBieUdEzrCwB5qVDAIW8E1DSbQVl
 aVCdHJKyYOh/25NyVBf1Eo5OBa/troojWbO7LzzWtOBKZtUsJwwquwWiRVSd4U5fnutRJRfjbhS
 8Qe5yRCVOrXdlB84ch1TIeomCFdXHFh7PFgC7+DuZYu8WdiFoeGA+MXHCb8Gl6FwSVJ6im/plCI
 xl3FTCnL+utk4wEcfmKSGVbjVAaSy6XYnrQCeAmjOMD9bu52TaKSL+WDk+bcnjm++SQAcsITMi4
 SKDeU7Cz9fpjul0v/mhV+EI55w6zxftmjinaDjvBIXuM+gu10jhP8Ma9n2DcQel4icXJud2gf8H
 wmZDdf6tLcjMiyLyEgnT+5u4Gm5RAC7Hf8zJjIotxaKeqngEcplzMizpheG7jQ6BHVSt/3GVp/4
 /lzxzVniAqwFKsvOVpw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602040113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70228-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 9D625E8288
X-Rspamd-Action: no action

While userspace is allowed to have pages of any size, the new gmap
would always use 4k pages to back the guest.

Enable 1M pages for gmap.

This allows 1M pages to be used to back a guest when userspace is using
1M pages for the corresponding addresses (e.g. THP or hugetlbfs).

Remove the limitation that disallowed having nested guests and
hugepages at the same time.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gmap.c     | 2 +-
 arch/s390/kvm/kvm-s390.c | 6 +-----
 arch/s390/kvm/pv.c       | 3 +++
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index fea1c66fcabe..da222962ef6d 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -620,7 +620,7 @@ static inline bool gmap_2g_allowed(struct gmap *gmap, gfn_t gfn)
 
 static inline bool gmap_1m_allowed(struct gmap *gmap, gfn_t gfn)
 {
-	return false;
+	return test_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &gmap->flags);
 }
 
 int gmap_link(struct kvm_s390_mmu_cache *mc, struct gmap *gmap, struct guest_fault *f)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bde55761bf8a..ac7b5f56f0b5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -851,6 +851,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 			r = -EINVAL;
 		else {
 			r = 0;
+			set_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &kvm->arch.gmap->flags);
 			/*
 			 * We might have to create fake 4k page
 			 * tables. To avoid that the hardware works on
@@ -5729,11 +5730,6 @@ static int __init kvm_s390_init(void)
 		return -ENODEV;
 	}
 
-	if (nested && hpage) {
-		pr_info("A KVM host that supports nesting cannot back its KVM guests with huge pages\n");
-		return -EINVAL;
-	}
-
 	for (i = 0; i < 16; i++)
 		kvm_s390_fac_base[i] |=
 			stfle_fac_list[i] & nonhyp_mask(i);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index a48a8afd40df..461b413c76a3 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -721,6 +721,9 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.flags.ap_allow_instr = kvm->arch.model.uv_feat_guest.ap;
 	uvcb.flags.ap_instr_intr = kvm->arch.model.uv_feat_guest.ap_intr;
 
+	clear_bit(GMAP_FLAG_ALLOW_HPAGE_1M, &kvm->arch.gmap->flags);
+	gmap_split_huge_pages(kvm->arch.gmap);
+
 	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
-- 
2.52.0


