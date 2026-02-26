Return-Path: <kvm+bounces-71971-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHruE5BCoGmrhAQAu9opvQ
	(envelope-from <kvm+bounces-71971-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:54:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5DBD1A5F34
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E14BC317725F
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58EB2FCC06;
	Thu, 26 Feb 2026 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OCg6GjXW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8C12DE6F8;
	Thu, 26 Feb 2026 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110184; cv=none; b=QuwzlbgvafsSDgXF41cbdtciFgqNFeiRudOPUvZKePaZ16ojDb+ZeC13VB/oWySwyzQtTY7ueVHZey7/neE5QA90IO1CeO8bFVrLYtUypBelU8CYgy1CQLAd556T/JAPLGtf9uItlyj3DRyiqcU0mMmIvoYIaILKUckDmtGu0SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110184; c=relaxed/simple;
	bh=ZIqxY6W0ZcZ5iLLFHa1cyFtDYEEWUpbHS4odS/r1WmE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PM1eUFaOAJ2ogrvOPgyhY9jjY6Ho/SynXPuLE+ZcmaPL/nQGMvhwTab47mjVi5xrxhgeSrZKLPMao99jmW676wqXkFxlq1MlbLvsJvoYMkGQeUbiwmqLRgJGw/G7HE0ZQ1aM2qMVqvzdQuF9h5tPdJFF9Q8SSS1yMqtPaDwxamU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OCg6GjXW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q77ass3207066;
	Thu, 26 Feb 2026 12:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ovunRP
	X2H9YhBbxfQeE/ZYkdJpTdD9b2gM/uETFqAek=; b=OCg6GjXWtaaT4NvNM9yoC2
	EO62GRYWKMN9FzCI2+H7Xm0iSpKqhRKjWkunLWHHpv4ZyVZe/TJ68dlBVA2BMBnY
	Csn8v4SA460LCC7T9SLKR/+L3KNgeWuoRWGhL3u7cx3Cs+4PX0q8dTQ6p0oRNotK
	80oyW5vGmWehCHfj7HW8PCDvP1UGQkRT+uOzRMFrgHoY+MptKImXXwdsoO/v3OV9
	1XPqvmGSR1n3G8oLkXgXaZDCui0v4aW9gQ+a6UHjjDoFHDZpU/O/3wcxgF/lvBnP
	Pdr6K+CCg7XF9h1ZGYyXFkXpHYQRB5jD3zmNW8VevUUxO4DkW0tMO6XVjezeWR4w
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf24gnrhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:49:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61Q9p2AC015970;
	Thu, 26 Feb 2026 12:49:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfq1sugrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:49:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QCnXgZ14942696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 12:49:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 424B620040;
	Thu, 26 Feb 2026 12:49:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0882520043;
	Thu, 26 Feb 2026 12:49:33 +0000 (GMT)
Received: from [9.52.198.32] (unknown [9.52.198.32])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 26 Feb 2026 13:49:07 +0100
Subject: [PATCH v2 4/4] KVM: s390: vsie: Implement ASTFLEIE facility 2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-vsie-alter-stfle-fac-v2-4-914974cb922c@linux.ibm.com>
References: <20260226-vsie-alter-stfle-fac-v2-0-914974cb922c@linux.ibm.com>
In-Reply-To: <20260226-vsie-alter-stfle-fac-v2-0-914974cb922c@linux.ibm.com>
To: linux-s390@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4464;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=9LmIGZVQ/QH/YcfnPYrtIP32NlrCLnbTxCM6e03UlPY=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJkLHKPtM5r2ZlhsDGU04Vti0lFUWHnTxU/vZdrdP99iF
 p9TWi7XUcrCIMbFICumyFItbp1X1de6dM5By2swc1iZQIYwcHEKwETk+Rj+h9z6/0Al9knhjjr2
 Y60ab2KdHSf+ORJWtlfw9Wz9hMW/lBn+iptKz01QffNc/mrHhOoja/n3l33If3w2asX6qIZHM/c
 fYAcA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=TNRIilla c=1 sm=1 tr=0 ts=69a04161 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=F8FVqei25e47uhyEDlAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: X1isxHoUPp8n2WTyDgOIaXy_grlxIYyM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDExNCBTYWx0ZWRfX8xzyRuhsf+iQ
 DNLR1RLsn/Nb2hMPkoXkSc5R90YsdkG0F1PCFLGsdOsmV4xdnvLYSxEN4gXuGuqPCeWuoCn/GRY
 uRj4xpRlWjhUoUH48DqB9FnMyYeCUuzbsHeXE5hrD11Y5gznQ9AOt0g5vjZJ6cfk++qqqSvHrfB
 cYKV457Qq2rZayEJ1O25eQ+g291hM6pUv+Z6KkoiWdmZt9bOjt67h8HBt/+uKoLt7ymzvN6/SQa
 LYS7Vt9M56mlJ83Jay+YQGOMgND/O0anJFno4ydGzLwKzEP2yCLxHbGIZuEmV4GDXAR1U4QT7zw
 +j5uDI8c5OstYvWb+ys5f4tYcfuhL6SeqPy9i9pjIP3hUSvjetv48lzTx1xNRVvdj+0oAMqyeEa
 e6xPqXHOiZzAdeLQqiOm1FPU7uEzWdBX/8r4/VIMHuXJuDzz6mOzJfrjCSmE8Bb0OYGTXJeQsky
 DhnwZM1dRVqcQG701yQ==
X-Proofpoint-ORIG-GUID: X1isxHoUPp8n2WTyDgOIaXy_grlxIYyM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260114
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-71971-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: A5DBD1A5F34
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
 arch/s390/include/asm/kvm_host.h |  7 +++++++
 arch/s390/kvm/kvm-s390.c         |  2 ++
 arch/s390/kvm/vsie.c             | 34 ++++++++++++++++++++++++++++++----
 3 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 23d17700319a5ef2031eabcad34b6191d1ef9b21..89a797e436336b9671119d93b02f3b39b0ed45e6 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -506,6 +506,13 @@ struct kvm_s390_cpu_model {
 	struct kvm_s390_vm_cpu_uv_feat uv_feat_guest;
 };
 
+#define S390_ARCH_FAC_FORMAT_2 2
+struct kvm_s390_f2_flcb {
+	u8	reserved0[7];
+	u8	length;
+	u64	facilities[S390_ARCH_FAC_LIST_SIZE_U64];
+};
+
 typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
 
 struct kvm_s390_crypto {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1a4abac697a40079c4dd6566581aaed321871a1f..ff9edc7d265b3b5babb265d47ea36464f684a040 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -460,6 +460,8 @@ static void __init kvm_s390_cpu_feat_init(void)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_IBS);
 	if (sclp.has_kss)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_KSS);
+	if (sclp.has_astfleie2)
+		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ASTFLEIE2);
 	/*
 	 * KVM_S390_VM_CPU_FEAT_SKEY: Wrong shadow of PTE.I bits will make
 	 * all skey handling functions read/set the skey from the PGSTE
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 3a2c644ef4fc630e2a13475fc1600c8053520bcd..bae96ff4a7c7b6e8ea2906007ce6fc9a386e0038 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -65,9 +65,9 @@ struct vsie_page {
 	gpa_t scb_gpa;				/* 0x0258 */
 	/* the shadow gmap in use by the vsie_page */
 	struct gmap_cache gmap_cache;		/* 0x0260 */
-	__u8 reserved[0x0700 - 0x0278];		/* 0x0278 */
-	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
-	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
+	__u8 reserved[0x06f8 - 0x0278];		/* 0x0278 */
+	struct kvm_s390_crypto_cb crycb;	/* 0x06f8 */
+	__u8 fac[8 + S390_ARCH_FAC_LIST_SIZE_BYTE];/* 0x0800 */
 };
 
 static_assert(sizeof(struct vsie_page) == PAGE_SIZE);
@@ -999,6 +999,28 @@ static int handle_stfle_0(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 	return 0;
 }
 
+static int handle_stfle_2(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u32 fac_list_origin)
+{
+	struct kvm_s390_f2_flcb *flcb_s = (struct kvm_s390_f2_flcb *)vsie_page->fac;
+	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	u64 len;
+
+	if (read_guest_real(vcpu, fac_list_origin, &len, sizeof(len)))
+		return set_validity_icpt(scb_s, 0x1090U);
+
+	/* discard reserved bits */
+	len = (len & U8_MAX);
+	flcb_s->length = len;
+	len += 1;
+
+	if (read_guest_real(vcpu, fac_list_origin + offsetof(struct kvm_s390_f2_flcb, facilities),
+			    &flcb_s->facilities, len * sizeof(u64)))
+		return set_validity_icpt(scb_s, 0x1090U);
+
+	scb_s->fac = (u32)virt_to_phys(&vsie_page->fac) | S390_ARCH_FAC_FORMAT_2;
+	return 0;
+}
+
 /*
  * Try to shadow + enable the guest 2 provided facility list.
  * Retry instruction execution if enabled for and provided by guest 2.
@@ -1013,6 +1035,8 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	int format_mask, format;
 	u32 origin;
 
+	/* assert no overflow with maximum len */
+	BUILD_BUG_ON(sizeof(vsie_page->fac) < ((S390_ARCH_FAC_LIST_SIZE_U64 + 1) * sizeof(u64)));
 	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct vsie_page, fac), 8));
 
 	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
@@ -1028,9 +1052,11 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		case 0:
 			return handle_stfle_0(vcpu, vsie_page, origin);
 		case 1:
+			return set_validity_icpt(&vsie_page->scb_s, 0x1330U);
 		case 2:
+			return handle_stfle_2(vcpu, vsie_page, origin);
 		case 3:
-			unreachable();
+			return set_validity_icpt(&vsie_page->scb_s, 0x1330U);
 		}
 	}
 	return 0;

-- 
2.53.0


