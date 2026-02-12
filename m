Return-Path: <kvm+bounces-70936-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NGxC6WcjWlT5QAAu9opvQ
	(envelope-from <kvm+bounces-70936-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA2E12BDB3
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A708D30B27A7
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C913A2DEA97;
	Thu, 12 Feb 2026 09:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y8jbiUht"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13FB23717F;
	Thu, 12 Feb 2026 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770888315; cv=none; b=T+mkX3AuDeqvCoP5u0K/hltP4uUTy7CMJaBNjjV/9y/5UMQPUUgEMTz9B5blPtNsqi+RR5FMp8sQ56AD6G2vSzqJgHad7xqzkQGIutk7mo1A5jWmJUJPS9566htgCyPeks4TaUUpoWJHEoPs9hy4PkY+j8g4zNtBHbs9YLstFYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770888315; c=relaxed/simple;
	bh=CWtJ6Ha7+phAtjXDhEnIJ6ngjz2K+Hfl0k6fpH/2p5c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FDGDQUtMfeQUXlpBRnWPxbMpSX2Fl3q5wHro3YN4Sp337/cbU9Naz6DRaaBI2Wvk3zfcFCMHeILzInVkQe8X1WruJbdZxoIzzBCeMmFX6+qufKzLGsY4/NiN4ke+Rzrs8RZ8S0AFssHltvezb/8VzmrSmPaXaqRIZN1a39ZMt88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y8jbiUht; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C9AQ6w700860;
	Thu, 12 Feb 2026 09:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=920sBm
	49fG7uyaPFDff0kkBu88rnALUR65H2sDF7vGc=; b=Y8jbiUhtwjFbM90t6hBIMz
	U1h62eOrUxN9ktuT/llwk/WlasGWKPLLTUd3KQlMJ+XtR1hhf8FRQ8ghepkSwED/
	ppRwvf0tLW4qLwI0JxXwLURBz7g3vHQrOlpFcFCtPu6KwG7HdigAVfqvYY1rW0LF
	nfu/4FvdYP4r/zD9NxpFiHDbkm1NN6146ci7DNYDVvytmU4BhlDIcCEZHZnrlfGM
	eaULqQ0QzxjVCpdn8LXDxtNo2Wh+F6Wam8plZHq50bswajiqoQD6cDr+rIPiGIlr
	+PC+o/KDC7UoaV+yumEfJ/l1/43bdNKliMdZjH2+bRwXwdqxDCOJNeAUSsmlgpNQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696wdd7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61C8vjNl012996;
	Thu, 12 Feb 2026 09:25:11 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7khndq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:11 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61C9P7v161866298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 09:25:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7BCA2004B;
	Thu, 12 Feb 2026 09:25:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B12120043;
	Thu, 12 Feb 2026 09:25:07 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.23.205])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 09:25:06 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 12 Feb 2026 10:24:57 +0100
Subject: [PATCH 3/4] KVM: s390: vsie: Refactor handle_stfle
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-vsie-alter-stfle-fac-v1-3-d772be74a4da@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4190;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=lCqjSAF0S4Hrf95ZPy53t9+rqs0lhBcfhe8cN/gRhP8=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJm9c/L3cPY/ON9teDHkgzWjyHE/SX/X23wBv9bNa/0Zo
 RDzRO9lRykLgxgXg6yYIku1uHVeVV/r0jkHLa/BzGFlAhnCwMUpABM5LcTwv2y5nc9j3wPz05jm
 PN5rMdu0jvvkkewja2e+2Bf9No9vjTLDH777HSwiHXvlqnNfe+2ZsJFty4w+vtq4QMllc3LsNLb
 /5QAA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698d9c79 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=j8Ixm2VswuN3s4kyCd0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cs6PaaDfZFbQQjjF44eaWst-ybPLAFuC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDA2OCBTYWx0ZWRfX3DUI37m0jP9O
 DZfLVVI9woa7Erkgfiga+1rWFsI6rmszdm7X4YuKTwYA+IxQ2wfzvX2kW1bRdWTx7ItcdOZvSGb
 s/TPxl5hBwG745gllHZ4g97Et3IloCbG5VYLBrCXsqHa/CFPwfErBQQwvSVQPKjTGiUNqSd3JGf
 h435uuDJEiydx1t8W0lVucz6P4rooyBpYOwmYKwMZX+yLBvAC4he6MCzb6qzUEykIaReYZ+LCpR
 tS7G0+2pyP3vH+wAETKeGAHJOz7gNXaIAp9isiBnujw/ZjBAk/JMPRU6GdFxaPPCNPKrcYj19ng
 uqjRoPvT0n18Dzzc8/0S98BZxck9d9CAG6VQVWEiG5oUAi32Yuz9/CTXoYDQmAKjklmEQ1rXwkR
 TKkeNKNj+T21ABYhm8xGmv+GHLIseydjCt7b6kXDLhC0KjTyspV8CUfz5FF7Efvzbg5GMdKtJNB
 FxzJ07fzc0vkGJwKYhg==
X-Proofpoint-ORIG-GUID: cs6PaaDfZFbQQjjF44eaWst-ybPLAFuC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602120068
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70936-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: CBA2E12BDB3
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Use switch case in anticipation of handling format-1 and format-2
facility list designations in the future.
As the alternate STFLE facilities are not enabled, only case 0 is
possible.
No functional change intended.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/uapi/asm/kvm.h |  1 +
 arch/s390/kvm/vsie.c             | 53 ++++++++++++++++++++++++++++------------
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 60345dd2cba2d611b76f8b5c70eab8f0abab4b9b..4192769b5ce069ba28d00d7cf1c4f1b34037d633 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -444,6 +444,7 @@ struct kvm_s390_vm_cpu_machine {
 #define KVM_S390_VM_CPU_FEAT_PFMFI	11
 #define KVM_S390_VM_CPU_FEAT_SIGPIF	12
 #define KVM_S390_VM_CPU_FEAT_KSS	13
+#define KVM_S390_VM_CPU_FEAT_ASTFLEIE2	14
 struct kvm_s390_vm_cpu_feat {
 	__u64 feat[16];
 };
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b526621d2a1b0a00cd63afd7a96b5c8da81984a7..3a90d4011bf06c35416ca2ea81eab1f0f71e8be4 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -6,12 +6,15 @@
  *
  *    Author(s): David Hildenbrand <dahi@linux.vnet.ibm.com>
  */
+#include <linux/align.h>
 #include <linux/vmalloc.h>
 #include <linux/kvm_host.h>
 #include <linux/bug.h>
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/bitmap.h>
 #include <linux/sched/signal.h>
+#include <linux/stddef.h>
 #include <linux/io.h>
 #include <linux/mman.h>
 
@@ -1008,6 +1011,23 @@ static void retry_vsie_icpt(struct vsie_page *vsie_page)
 	clear_vsie_icpt(vsie_page);
 }
 
+static int handle_stfle_0(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
+			  u32 fac_list_origin)
+{
+	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+
+	/*
+	 * format-0 -> size of nested guest's facility list == guest's size
+	 * guest's size == host's size, since STFLE is interpretatively executed
+	 * using a format-0 for the guest, too.
+	 */
+	if (read_guest_real(vcpu, fac_list_origin, &vsie_page->fac,
+			    stfle_size() * sizeof(u64)))
+		return set_validity_icpt(scb_s, 0x1090U);
+	scb_s->fac = (u32)virt_to_phys(&vsie_page->fac);
+	return 0;
+}
+
 /*
  * Try to shadow + enable the guest 2 provided facility list.
  * Retry instruction execution if enabled for and provided by guest 2.
@@ -1017,29 +1037,30 @@ static void retry_vsie_icpt(struct vsie_page *vsie_page)
  */
 static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
-	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
+	u32 fac = READ_ONCE(vsie_page->scb_o->fac);
+	int fac_list_format_mask, fac_list_format;
+	u32 fac_list_origin;
+	bool has_astfleie2;
 
-	/*
-	 * Alternate-STFLE-Interpretive-Execution facilities are not supported
-	 * -> format-0 flcb
-	 */
+	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct vsie_page, fac), 8));
 	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
 		retry_vsie_icpt(vsie_page);
 		/*
 		 * The facility list origin (FLO) is in bits 1 - 28 of the FLD
 		 * so we need to mask here before reading.
 		 */
-		fac = fac & 0x7ffffff8U;
-		/*
-		 * format-0 -> size of nested guest's facility list == guest's size
-		 * guest's size == host's size, since STFLE is interpretatively executed
-		 * using a format-0 for the guest, too.
-		 */
-		if (read_guest_real(vcpu, fac, &vsie_page->fac,
-				    stfle_size() * sizeof(u64)))
-			return set_validity_icpt(scb_s, 0x1090U);
-		scb_s->fac = (u32)virt_to_phys(&vsie_page->fac);
+		fac_list_origin = fac & 0x7ffffff8U;
+		has_astfleie2 = test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ASTFLEIE2);
+		fac_list_format_mask = has_astfleie2 ? 3 : 0;
+		fac_list_format = fac & fac_list_format_mask;
+		switch (fac_list_format) {
+		case 0:
+			return handle_stfle_0(vcpu, vsie_page, fac_list_origin);
+		case 1:
+		case 2:
+		case 3:
+			unreachable();
+		}
 	}
 	return 0;
 }

-- 
2.53.0


