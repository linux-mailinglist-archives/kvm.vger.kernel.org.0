Return-Path: <kvm+bounces-71969-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MP2mJitCoGmrhAQAu9opvQ
	(envelope-from <kvm+bounces-71969-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:52:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 039311A5ED1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:52:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D2053144F2B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF89C2DF137;
	Thu, 26 Feb 2026 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AxQpuYMU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85C92D8393;
	Thu, 26 Feb 2026 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110182; cv=none; b=N4Nm5DN5SxGHu5Fg4PJLMN1mVM+hTnr7yXGwfgL05n10GXbFj+7BtOSUMXOwjFAFpNp+VZLFTSLe6shTo6tawBO5LsJXWI3eMPMP3hUkQ5UKSpbQLaXSN5mLS5AcsAYdPce7rQ4Cc4YcjC74mtndnHW+wc+xrmqWsFlZx+9gX80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110182; c=relaxed/simple;
	bh=iAfu+K6uqWkGAiNb1mvr3e1LfRpy4V9gxn7nK7rICBs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OzOv9UPGyrbpbusDICGpX70ZWHook/ly3wsv9OEK3ny6dtgU5GZZpmvufLd9io9znTkZA0OA9qF8UmCx75WjnP9omYLqA5OSwuYQynv5K1uk5dQv52Os+tScCyiGCkSgTZVCB/jq2h2utnzKNh1U9K+3u3cfO7u8Rp3jk5RYyAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AxQpuYMU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q4G3uW2345995;
	Thu, 26 Feb 2026 12:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ngJC2M
	YWASVIvs75lYzR0mC43j3mLFxoRxMGgDbwgcM=; b=AxQpuYMUTiFr5n4IYLvXmx
	Ff0MPVLJHJomp+6fZZOrC8+5yKtqXCinGfWqzRyGi/UHQPcnb6wz4CqNgfDVQ809
	vgzMRIYCKju2odUYrDw5kNd22eQJwIAv5soZqVNzc2lTUMcvQbCncNGWdbpeVtSF
	nMkinGVL4vs53A8STrk/jBx3FRBmo/tl0TMajEL6avPZAL23LQU5GeD0va/oIv7E
	gPkh5Smk0RDw/hbqSk2u9kT25nMny5BPhtPw4aL37y2uU8i0DJOmFJw9WEgzBNFQ
	ubVjFPE4I2v8RNfaOXC4NTR6FGkbHI/FdY/FDvzhrQzYzjdCu5BX9WVzgcy9DDpg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ch858utwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:49:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QAgKvf030256;
	Thu, 26 Feb 2026 12:49:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfrhkka8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:49:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QCnXXo14942692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 12:49:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 034C420040;
	Thu, 26 Feb 2026 12:49:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3C072004E;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
Received: from [9.52.198.32] (unknown [9.52.198.32])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 26 Feb 2026 13:49:06 +0100
Subject: [PATCH v2 3/4] KVM: s390: vsie: Refactor handle_stfle
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-vsie-alter-stfle-fac-v2-3-914974cb922c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4811;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=1BeqlVbLFLKjyKh+VoVQ3ZHt067UkWnk27xOoJ8LXJ4=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJkLHKNZCoJ2y1lHbC3/EnzcpVVblqszd6G/hFrh98pZv
 G9ON67sKGVhEONikBVTZKkWt86r6mtdOueg5TWYOaxMIEMYuDgFYCIrnjIyLHTc+/5+1MviWWya
 V5Jm36tb8oLt5M3IfRJ7Tp0ItWARq2b47/fyW5LdrSSv8Hffzlj7pfEFcuV9aY60uuRYGPSyf0U
 RKwA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDExNCBTYWx0ZWRfX2aEMUUJoN4mN
 PsfVjDQBQjWNYpVySvl4JhhbEYjyQt7a4fCLcjRXmHj+EpO27SDeZPoZE1I6DUgB/Q8Erb7R2jG
 LtLR7XiwaFVUr7v6+9MnlqWr2U1dC0Wj/aJdZdreXdqTpgLwhTvDc7KnVrj/G5Sia6nVWhx0rIa
 VABpp/sCozURwxsxHa5Fzc2MMI3EsbyczStis30or3/vPaoeFa79MU1dAC+dfrl/Dc4Qjm4Tz34
 0YuYrKkwnSeOmt8b94jO7MEzNgQUaDK+qg00ETu6daC3QUg86l84tLTQ5Q4R+arAVnHKoY1HHJ0
 zph3miVxLEgKZ8VrEX4L4/stZEB4zcZR+ZCyLN7F4Q0iGCbwIsWvgWNxNXWnh6CcrlI6GPM5gT6
 GICADswH8K7YmIpTId3IkvaY+3wPxPU45JqVyqauPpHml3p1cRiIdBZpUls2aY3yrc6Fd2ec/sH
 XNjDiT1ZGgR9UxAydZw==
X-Proofpoint-GUID: sJ3eoo3f6SN4675YCKpuakY6wLLROd9E
X-Authority-Analysis: v=2.4 cv=S4HUAYsP c=1 sm=1 tr=0 ts=69a04162 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=XKQQt2AcN9TueXHyMy8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: sJ3eoo3f6SN4675YCKpuakY6wLLROd9E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
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
	TAGGED_FROM(0.00)[bounces-71969-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 039311A5ED1
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Use switch case in anticipation of handling format-1 and format-2
facility list designations in the future.
As the alternate STFLE facilities are not enabled, only case 0 is
possible.
No functional change intended.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Co-developed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/include/uapi/asm/kvm.h |  1 +
 arch/s390/kvm/vsie.c             | 53 ++++++++++++++++++++++++++++------------
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 64a50f0862aabb994089090c750bd312a7233e2c..23d17700319a5ef2031eabcad34b6191d1ef9b21 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -484,6 +484,8 @@ struct s390_io_adapter {
 #define MAX_S390_IO_ADAPTERS ((MAX_ISC + 1) * 8)
 #define MAX_S390_ADAPTER_MAPS 256
 
+#define S390_ARCH_FAC_ORIGIN_MASK 0x7ffffff8U
+
 /* maximum size of facilities and facility mask is 2k bytes */
 #define S390_ARCH_FAC_LIST_SIZE_BYTE (1<<11)
 #define S390_ARCH_FAC_LIST_SIZE_U64 \
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
index d249b10044eb7595295fc20e9287e0629958d896..3a2c644ef4fc630e2a13475fc1600c8053520bcd 100644
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
 
@@ -979,6 +982,23 @@ static void retry_vsie_icpt(struct vsie_page *vsie_page)
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
@@ -988,29 +1008,30 @@ static void retry_vsie_icpt(struct vsie_page *vsie_page)
  */
 static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
-	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
+	bool has_astfleie2 = test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ASTFLEIE2);
+	u32 fac = READ_ONCE(vsie_page->scb_o->fac);
+	int format_mask, format;
+	u32 origin;
+
+	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct vsie_page, fac), 8));
 
-	/*
-	 * Alternate-STFLE-Interpretive-Execution facilities are not supported
-	 * -> format-0 flcb
-	 */
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
+		origin = fac & S390_ARCH_FAC_ORIGIN_MASK;
+		format_mask = has_astfleie2 ? 3 : 0;
+		format = fac & format_mask;
+		switch (format) {
+		case 0:
+			return handle_stfle_0(vcpu, vsie_page, origin);
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


