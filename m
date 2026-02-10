Return-Path: <kvm+bounces-70734-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHh7NDpQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70734-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9660B11C84C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4AB91305092B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7363815FB;
	Tue, 10 Feb 2026 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CBQuhXLN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A291A3815DE;
	Tue, 10 Feb 2026 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737670; cv=none; b=K86BwjBm86+bqnISeMUIgwZaAhRnZC2s4BM2iW90mmWhCCPocdWs0nzWRFdtWLeQroK5J0y1GxesBIdDzIrzDr/YhmC2GoEjFdZJMXZOmMi2ciP1Yl4YU4Spv2eVWs2gtzEUtj8lwb/v5fqVvYd5jsUKua+Zutmj0m7kNJp4y+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737670; c=relaxed/simple;
	bh=B3keCssbcGYMGJrO6P539/T7YLGz8+CfjzsLKZPjzSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1fxSAJrWjeMiWbUyAzyZty6cs99NjyBh8lhuXKtnlbgWCj4Lu3ZN1Mg7SD6YS7k9iPTrygWzpQ8qf4jtOccNSHRDzXPyczAw1gc0vt6W3OZCwMqXXimAsD2Kti6P3nbi5Ep4g7ftuEmEPASt62o7TnxEh4pa6ZjFcxhuM+8o4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CBQuhXLN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A93V8U397449;
	Tue, 10 Feb 2026 15:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cgrygJ0IL1rlNl4M7
	jGySEVTk07rjNkmRIn2guU/boc=; b=CBQuhXLNrD2khtkOeQTyf0F0sp+Y+bXpq
	ytuajB/SqgW70ZR4uasG+jycVDSQuZr1zVEEXxjSdofLF44ykC1F1Dc0pUqfKg6L
	p3p1tufFpdonJ7dnlXujfZFg2bCkpNlL8lLerX8kF4OQX7W+pr4B2pi92mtIpXqT
	OqmPTHJCIzX7YcWiGz+xNFVWaxR7UtFfGeYVwLcVFavjSe8vNUVOYM+sfq4PjaQd
	4xnvw+M5tQQNd2EAgNchXABCKXYDgRWQgYyGtChAUJBLJuzuASwQJRAZHEP6KxSL
	IPoG4NdL5QDRC8ewcc48f6heK1tqC3uGYZokypvl/0q/I6et4CB+w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w4x8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABnpYL001819;
	Tue, 10 Feb 2026 15:34:24 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je21jbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYKL359638080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCC1320043;
	Tue, 10 Feb 2026 15:34:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B3C820040;
	Tue, 10 Feb 2026 15:34:20 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:20 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 05/36] s390: Move sske_frame() to a header
Date: Tue, 10 Feb 2026 16:33:46 +0100
Message-ID: <20260210153417.77403-6-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b5001 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=cwyL-bC_1qH1TysSW8cA:9
X-Proofpoint-GUID: uONUFuS-K9jwGcaew_g65-c9gfmMf2yI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX6GgmsIaePjJF
 heOHSMFVDx7kRh+T/5FHxdaXQdvvsPKxvLIcOSpx6NLWHJ359W5+LT1PBNd03+WZz4RKl/LETxF
 RbRPmjj8915cfw4/MhWi9NyTQ6PH3Q49n51Ci1q+FiUUZMKz2I08TJkj62HkiIT621yuEQDj3zN
 QfjdqLZAGRaVvNMzAwTEg9+cSNrHYbq6z+AEf1V1fRdLgrfpgtFdHXvsALiRaNPScsc5Q0A6FD4
 6OHxqbcGgf6NTlxS1cb2Ysek7Ga64VPDSUGNQokApTObbHMho79IbngvJHqI4hRCGuY/vvpUVwM
 7xzukc/TDySmrms+UXLNIyufccaIjM0VWj8grz2AXaF3P7P+5zLpOnAc5LC0Fjgag7DSQKJdW+a
 gYCBJz/+Dr2mNN8SyHMLn38WgXgfS1IOxX2R/2eoNmi4cdYwjOJT/UsZzm3Gvcbv6wkkacZTfsV
 dcdXiN6iAV1VLWzE9Nw==
X-Proofpoint-ORIG-GUID: uONUFuS-K9jwGcaew_g65-c9gfmMf2yI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70734-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 9660B11C84C
X-Rspamd-Action: no action

Move the sske_frame() function to asm/pgtable.h, so it can be used in
other modules too.

Opportunistically convert the .insn opcode specification to the
appropriate mnemonic.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 7 +++++++
 arch/s390/mm/pageattr.c         | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 8194a2b12ecf..73c30b811b98 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1136,6 +1136,13 @@ static inline pte_t pte_mkhuge(pte_t pte)
 }
 #endif
 
+static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
+{
+	asm volatile("sske %[skey],%[addr],1"
+		     : [addr] "+a" (addr) : [skey] "d" (skey));
+	return addr;
+}
+
 #define IPTE_GLOBAL	0
 #define	IPTE_LOCAL	1
 
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index d3ce04a4b248..bb29c38ae624 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -16,13 +16,6 @@
 #include <asm/asm.h>
 #include <asm/set_memory.h>
 
-static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
-{
-	asm volatile(".insn rrf,0xb22b0000,%[skey],%[addr],1,0"
-		     : [addr] "+a" (addr) : [skey] "d" (skey));
-	return addr;
-}
-
 void __storage_key_init_range(unsigned long start, unsigned long end)
 {
 	unsigned long boundary, size;
-- 
2.53.0


