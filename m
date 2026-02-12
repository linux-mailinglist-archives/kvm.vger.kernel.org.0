Return-Path: <kvm+bounces-70934-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +G4FIIKcjWlT5QAAu9opvQ
	(envelope-from <kvm+bounces-70934-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F3D012BD7B
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 63A2D30185DF
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2FE82E0400;
	Thu, 12 Feb 2026 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ofUyg83g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EC72DB7A6;
	Thu, 12 Feb 2026 09:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770888313; cv=none; b=PPF/zHSBQhmFuv99UznlZFmfnJ7Zy9M9/De0GQMuOF10xAqWrJymbKw9D/b2s8TVr+YxbSOuhq8NHTaxtJv1Deqq2x04ZeaTFCeXIGp6QdNAlo+mJXxeu3AQoiMr8tm1oNLTUzWiEFoI7+WYQhqnVT2tYzHBRT26CVsMekdT0dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770888313; c=relaxed/simple;
	bh=KJYf4MEfbFE3sAFe8FaFXTYXw/tEyHD0xLrdFETEU6k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sy71pCc8nOl1gzSmP5vpqna6ZMhYTx2U0T4ulhNf2PygA40/j4q8qRqMiqWY/lp1TJYT2ENSmLDo0fhnprXnpFL/PkV+z+pYhSjMyW7X5rKBEIWTv2Z7g0bXu7QHwgGd5Z2RzPaAB1AQnIZfS5jhuI0mXWySz9t46S70UlIOxkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ofUyg83g; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C5Rm8u239438;
	Thu, 12 Feb 2026 09:25:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xreNCx
	sh0B1DqpOxpJWdM0tnw7y71c4pM4yx4SIUXWY=; b=ofUyg83gADqN/0I3B8vNL8
	/Ivx0eu5tkL8pyzofZDyN8KibG4fV793YDA7EaBmQqMxNrWnTsQeaFnN2CxQjgM3
	VFj67GybbL8MvXv9GupWLuWPylShO9JYDNhN4CGCv9MT+kZwYD+fb1v46PvNrq1c
	V+p6wx+mpdXPv9iknq4kwDMwU8m17XwHRl2m1lavg7at0uGOG5RC0v9rMdnxDpFx
	6nf7YY40hYnEP3Snhag8PrbEhDk1y2EthlHbjivKshSTuG550py+8Yoa3aV2W9AX
	VzrV1pceVdc3pmZAg4jAmYX94xeQJ0iSEkDQzWdkvytXcQe30CiNgKL0BndqR/UA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v2r5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61C5C5pF001840;
	Thu, 12 Feb 2026 09:25:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je29g2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61C9P5Yg51380674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 09:25:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E10242004E;
	Thu, 12 Feb 2026 09:25:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FB1220043;
	Thu, 12 Feb 2026 09:25:05 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.23.205])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 09:25:05 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 12 Feb 2026 10:24:55 +0100
Subject: [PATCH 1/4] KVM: s390: Minor refactor of base/ext facility lists
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-vsie-alter-stfle-fac-v1-1-d772be74a4da@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4104;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=5eGPqKy5l9iFd1bo2+c32CjluOsHKtEcxR/RKZB3XuI=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJm9c/J59jE9uLxvm7RkwK4fq3dpn3+/+skbm9naWg+Mj
 /i8/r77WEcpC4MYF4OsmCJLtbh1XlVf69I5By2vwcxhZQIZwsDFKQATOSTM8D/sgnNYa3eTRnRJ
 7e0PT7rPbbYVPsH+9vyl8zJr3v6felaG4RdzwSEnT3GLT5+LjuWee3RcrtDCjEc/4X3tPgHhvq9
 M5xgB
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDA2OCBTYWx0ZWRfX9/T7S2Vu52vg
 Voq/uWnXeFbNcaSRqt8qqfphDcam7r4C8INpZOjVAoexXhvR1m171JhPqMljlekejZ8YuNgT2C+
 kzjSu6w2Nfc9pJGK+DDmE4Ug1L1CAl1v2cOyaEksrDDZ9gcck39QOVWLBEVpwKg+Id/1J1ig2KN
 db57XDhNm7dBOVJM4eWq1UpZNHqw36JTJDjmu11mMQ1w8tSk25P0COADGk3GOTydd+aYcNWFbVR
 lcLUA27fv06uVkdU6FCeJGbH0h+zgaEauxGhj+3UWvUbPLNEhB4putr+oAiGUlQhNrTMEAMUp8G
 upgntSiDgCxEIJrtTUlzqF1C1O43L9SOVpeRoa3n2ITtINMostczaqcAyJHiXVf/yAJXVIS7ztJ
 VLaffhRmQWBRRNRUSGUlcRNvOOAXUAfyMvrHafDlmO7J9t9spDpQRV/1mMKpTodM+qvvalab28Y
 F3JK9RMCnYncOhnyy/g==
X-Proofpoint-ORIG-GUID: NiHpsSVmsjMHThlcmoUck8P7tBYRQdO_
X-Proofpoint-GUID: NiHpsSVmsjMHThlcmoUck8P7tBYRQdO_
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698d9c76 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=V1mMjla59gyM6mHp8IcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602120068
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
	TAGGED_FROM(0.00)[bounces-70934-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: 9F3D012BD7B
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Directly use the size of the arrays instead of going through the
indirection of kvm_s390_fac_size().
Don't use magic number for the number of entries in the non hypervisor
managed facility bit mask list.
Make the constraint of that number on kvm_s390_fac_base obvious.
Get rid of implicit double anding of stfle_fac_list.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 56a50524b3eee4e17b5b8a5833c2a560d120c443..797d77174fe692c1e63cacc38f251dd3bc98a23b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -231,33 +231,25 @@ static int async_destroy = 1;
 module_param(async_destroy, int, 0444);
 MODULE_PARM_DESC(async_destroy, "Asynchronous destroy for protected guests");
 
-/*
- * For now we handle at most 16 double words as this is what the s390 base
- * kernel handles and stores in the prefix page. If we ever need to go beyond
- * this, this requires changes to code, but the external uapi can stay.
- */
-#define SIZE_INTERNAL 16
-
+#define HMFAI_DWORDS 16
 /*
  * Base feature mask that defines default mask for facilities. Consists of the
  * defines in FACILITIES_KVM and the non-hypervisor managed bits.
  */
-static unsigned long kvm_s390_fac_base[SIZE_INTERNAL] = { FACILITIES_KVM };
+static unsigned long kvm_s390_fac_base[HMFAI_DWORDS] = { FACILITIES_KVM };
+static_assert(ARRAY_SIZE(((long[]){ FACILITIES_KVM })) <= HMFAI_DWORDS);
+static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= S390_ARCH_FAC_MASK_SIZE_U64);
+static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= S390_ARCH_FAC_LIST_SIZE_U64);
+static_assert(ARRAY_SIZE(kvm_s390_fac_base) <= ARRAY_SIZE(stfle_fac_list));
+
 /*
  * Extended feature mask. Consists of the defines in FACILITIES_KVM_CPUMODEL
  * and defines the facilities that can be enabled via a cpu model.
  */
-static unsigned long kvm_s390_fac_ext[SIZE_INTERNAL] = { FACILITIES_KVM_CPUMODEL };
-
-static unsigned long kvm_s390_fac_size(void)
-{
-	BUILD_BUG_ON(SIZE_INTERNAL > S390_ARCH_FAC_MASK_SIZE_U64);
-	BUILD_BUG_ON(SIZE_INTERNAL > S390_ARCH_FAC_LIST_SIZE_U64);
-	BUILD_BUG_ON(SIZE_INTERNAL * sizeof(unsigned long) >
-		sizeof(stfle_fac_list));
-
-	return SIZE_INTERNAL;
-}
+static const unsigned long kvm_s390_fac_ext[] = { FACILITIES_KVM_CPUMODEL };
+static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= S390_ARCH_FAC_MASK_SIZE_U64);
+static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= S390_ARCH_FAC_LIST_SIZE_U64);
+static_assert(ARRAY_SIZE(kvm_s390_fac_ext) <= ARRAY_SIZE(stfle_fac_list));
 
 /* available cpu features supported by kvm */
 static DECLARE_BITMAP(kvm_s390_available_cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
@@ -3371,13 +3363,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.sie_page2->kvm = kvm;
 	kvm->arch.model.fac_list = kvm->arch.sie_page2->fac_list;
 
-	for (i = 0; i < kvm_s390_fac_size(); i++) {
+	for (i = 0; i < ARRAY_SIZE(kvm_s390_fac_base); i++) {
 		kvm->arch.model.fac_mask[i] = stfle_fac_list[i] &
-					      (kvm_s390_fac_base[i] |
-					       kvm_s390_fac_ext[i]);
+					      kvm_s390_fac_base[i];
 		kvm->arch.model.fac_list[i] = stfle_fac_list[i] &
 					      kvm_s390_fac_base[i];
 	}
+	for (i = 0; i < ARRAY_SIZE(kvm_s390_fac_ext); i++) {
+		kvm->arch.model.fac_mask[i] |= stfle_fac_list[i] &
+					       kvm_s390_fac_ext[i];
+	}
 	kvm->arch.model.subfuncs = kvm_s390_available_subfunc;
 
 	/* we are always in czam mode - even on pre z14 machines */
@@ -6040,9 +6035,8 @@ static int __init kvm_s390_init(void)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < 16; i++)
-		kvm_s390_fac_base[i] |=
-			stfle_fac_list[i] & nonhyp_mask(i);
+	for (i = 0; i < HMFAI_DWORDS; i++)
+		kvm_s390_fac_base[i] |= nonhyp_mask(i);
 
 	r = __kvm_s390_init();
 	if (r)

-- 
2.53.0


