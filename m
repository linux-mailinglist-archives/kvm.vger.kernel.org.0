Return-Path: <kvm+bounces-70937-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLM/JoecjWlT5QAAu9opvQ
	(envelope-from <kvm+bounces-70937-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CF72812BD90
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C2731302C148
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC0B23717F;
	Thu, 12 Feb 2026 09:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UWOToQ7X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8C82E0923;
	Thu, 12 Feb 2026 09:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770888315; cv=none; b=BnAi5MKjld4DtdflyqEpIw6tfteR9z4feSrYs6NCMvK1sPW+DdOS5jOSAaF87lc/WnOuXaSbIxk5ceSM7aq6H29i0cyv3DewYuMhwCFqPYoaojqrKen+zJCtrTp6lKrZ1Ca1thZqOkY5M3GVxj263gyIsZhKHL+i1+iNRno4jQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770888315; c=relaxed/simple;
	bh=xcsk87tCH8JjdJG7B9waPlpJ5qPLBdcDU/ZIylY6hOA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HcipOzF0FZhFhnf6+PHA9z2p4ukJwZpyk57c3pHhD2UK9m2ytro/NszYuD9OExJK6ZUrdjw11NGoSD1yJ/jI8+2vsHEnYmumHw2cQZM8P85SEJbsaekyVsyz2ssQUW/GdXJ7E/iicml3jFjV/FHiQqIJqpLyofxK+Q68Mcng7U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UWOToQ7X; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C6UnjE316694;
	Thu, 12 Feb 2026 09:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cprkx+
	MPIfRd/qcX2fGdriyGDRr0X1EfghHW12Wio4o=; b=UWOToQ7XScbOWAdKFYRzpD
	nUhvvaAy3zuIq7+qVxpP5R+J/OfkJsr2V/fdkQWr3gXTUX7mjDGSRUx3e4GTjR3o
	E6nG3rtyp6JmgnGqLKeqcMEhmq/KhbFlhS9574xZ8kaP1r4I65WiSTyyM6m3MPZW
	/2LUW/mw24ZWbFFNdlnc+yr3W0cOdcMsZ/UYoRkUMYS/PtE1BKwwqbtSlErHIevk
	PT1YEf2cNqKkejWKIcouElGzF0/HnUVs5E13JOlHB5B1Rw9xf4Yd8UxrmkDfgTJy
	0GTMzx0RysJmm/Nv52wAgodtgnZtXyO4pDstMxlz2mKdSYSJxr3XZ+jcZO/Qpp8w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696unc3x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61C4lhvx019221;
	Thu, 12 Feb 2026 09:25:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk9ksk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61C9P8Bq48890288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 09:25:08 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3AD32004B;
	Thu, 12 Feb 2026 09:25:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF36C20043;
	Thu, 12 Feb 2026 09:25:07 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.23.205])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 09:25:07 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 12 Feb 2026 10:24:58 +0100
Subject: [PATCH 4/4] KVM: s390: vsie: Implement ASTFLEIE facility 2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-vsie-alter-stfle-fac-v1-4-d772be74a4da@linux.ibm.com>
References: <20260212-vsie-alter-stfle-fac-v1-0-d772be74a4da@linux.ibm.com>
In-Reply-To: <20260212-vsie-alter-stfle-fac-v1-0-d772be74a4da@linux.ibm.com>
To: linux-s390@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3433;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=Nrf6Njqo+xjYXz7xsgS7QrjK9K3DHSM1lgpyDKA6h8g=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJm9cwrWxgo+5Dyx5nRq8wXzOBuruTF6Fm/l7/kp2a5fv
 6Ak1PpWRykLgxgXg6yYIku1uHVeVV/r0jkHLa/BzGFlAhnCwMUpABMxvMzI8HTxubmiCxx/e6xU
 vfR6zrXlpQc837yf7r2gvHOiXvmiXd8ZGWa5FjO5Jbp43BGaY9X64d6WqAVHv4a6bt0uw8z4r4B
 rJiMA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698d9c79 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=mvqX4yjK82HC70EXregA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: fmkXH-Aq1CC0vFIO98wRKnY9Imhv7LV8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDA2OCBTYWx0ZWRfXwAMXDtMe0o/y
 KtZfqi/9IM6WoolWTpvXblE8nwGac9w78w+Trvj1bYni5Da0mMTQoxeLPklqQze6K/lqE8G66Ph
 jJIgVjOBi1t9Db1xhVnC6rz/HQYqhCVaudX56NP5UGaukA4PhY+O7S7ozidg2+tpDK61lzDz+PW
 fvunBNdA+yMa5l5UnfufPID7y2vJPJwMOsvuSgW2/vR0oBRi6K254+7ZhO1OexrimnU+a8XLtWY
 r4uIyypUXcpn7+qivByRyRUKe6T1iyXEx+PkbdX7ejW/YmxLLCWZUz5nG/KqgvKBgd34f6alptG
 iA6IPHV+JaJCLP+VPI4AlZZ7Uyru3a61VK9v7dzsbXYduXWnRYss+WfAAJmieI1wa1ouynZgSev
 GKXjO2eS64mb9lOtGgfJ1bBj9f8bKeC5u5lGfF6+PVW8S00n5dh3zNyz+qt0bqxx17j7Gv1xO41
 FJaEEAKjvChtdubXtuw==
X-Proofpoint-GUID: fmkXH-Aq1CC0vFIO98wRKnY9Imhv7LV8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602120068
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70937-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: CF72812BD90
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Implement shadowing of format-2 facility list when running in VSIE.

ASTFLEIE2 is available since IBM z16.
To function G1 has to run this KVM code and G1 and G2 have to run QEMU
with ASTFLEIE2 support.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Co-developed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c |  2 ++
 arch/s390/kvm/vsie.c     | 33 +++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 797d77174fe692c1e63cacc38f251dd3bc98a23b..3f922b96356aa3c5ed653758fbd05509ba5b337f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -464,6 +464,8 @@ static void __init kvm_s390_cpu_feat_init(void)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_IBS);
 	if (sclp.has_kss)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_KSS);
+	if (sclp.has_astfleie2)
+		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ASTFLEIE2);
 	/*
 	 * KVM_S390_VM_CPU_FEAT_SKEY: Wrong shadow of PTE.I bits will make
 	 * all skey handling functions read/set the skey from the PGSTE
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 3a90d4011bf06c35416ca2ea81eab1f0f71e8be4..4396abeb58ed577c49fa9b98de1c630d6759e9a2 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -65,9 +65,9 @@ struct vsie_page {
 	 * looked up by other CPUs.
 	 */
 	unsigned long flags;			/* 0x0260 */
-	__u8 reserved[0x0700 - 0x0268];		/* 0x0268 */
-	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
-	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
+	__u8 reserved[0x06f8 - 0x0268];		/* 0x0268 */
+	struct kvm_s390_crypto_cb crycb;	/* 0x06f8 */
+	__u8 fac[8 + S390_ARCH_FAC_LIST_SIZE_BYTE];/* 0x0800 */
 };
 
 /**
@@ -1028,6 +1028,29 @@ static int handle_stfle_0(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 	return 0;
 }
 
+static int handle_stfle_2(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
+			  u32 fac_list_origin)
+{
+	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	u8 *shadow_fac = &vsie_page->fac[0];
+	u64 len;
+
+	if (read_guest_real(vcpu, fac_list_origin, &len, sizeof(len)))
+		return set_validity_icpt(scb_s, 0x1090U);
+	fac_list_origin += sizeof(len);
+	len = (len & 0xff);
+	memcpy(shadow_fac, &len, sizeof(len)); /* discard reserved bits */
+	shadow_fac += sizeof(len);
+	len += 1;
+	/* assert no overflow with maximum len */
+	BUILD_BUG_ON(sizeof(vsie_page->fac) < 257 * sizeof(u64));
+	if (read_guest_real(vcpu, fac_list_origin, shadow_fac, len * sizeof(u64)))
+		return set_validity_icpt(scb_s, 0x1090U);
+	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct vsie_page, fac), 8));
+	scb_s->fac = (u32)virt_to_phys(&vsie_page->fac) | 2;
+	return 0;
+}
+
 /*
  * Try to shadow + enable the guest 2 provided facility list.
  * Retry instruction execution if enabled for and provided by guest 2.
@@ -1057,9 +1080,11 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		case 0:
 			return handle_stfle_0(vcpu, vsie_page, fac_list_origin);
 		case 1:
+			return set_validity_icpt(&vsie_page->scb_s, 0x1330U);
 		case 2:
+			return handle_stfle_2(vcpu, vsie_page, fac_list_origin);
 		case 3:
-			unreachable();
+			return set_validity_icpt(&vsie_page->scb_s, 0x1330U);
 		}
 	}
 	return 0;

-- 
2.53.0


