Return-Path: <kvm+bounces-71970-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eFzfMkFCoGmrhAQAu9opvQ
	(envelope-from <kvm+bounces-71970-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:53:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 711171A5EE6
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:53:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B233314E612
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357A92E0B5B;
	Thu, 26 Feb 2026 12:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BsbrxnpK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548462D838C;
	Thu, 26 Feb 2026 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110182; cv=none; b=ZFef3SWbz4cpTCcFFYN30LkBvXCbNJ3BDERgf8WCDemGsb2tk9IwXPp/PZ3XGr9wZFRnFZ1ly4ZA4HTGZbCubVMb/Utgh2tiZBNPM2mMUFQ0MAL1/VuLMwoFrqrQm9XUWQrphF1AkM8IMLEtldfl/8iUDJIxvljLXu5L2Cg3UkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110182; c=relaxed/simple;
	bh=Y2vRDuIq0ImHn6M2tBJjx5bpTlIo/fJlH6A2AZpLvmQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rVeH9qqzZ/VVKy7mHdFmSbjjO5Ps7u1uS/ljd8xHWWkLq4Qj/NpwAzL/VFcwI4aIr0rdYy5F9REizfHchk3tqGDmBQ1nm22usPAouvdITMQd4Juon92i7qbl2bKg1VYvT/exjUmPU1rCVEF6TJ/Te/ZFrc5arXF7WaWW/ahZK6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BsbrxnpK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q6TOer2733894;
	Thu, 26 Feb 2026 12:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=e1gU8/
	jg/BOhYHKGUo4kE1RBr17UrQtjhAHW38EcUao=; b=BsbrxnpK6KXqVq/o7604YC
	hfDDKVHGefMyyVF4vRAnx9gVGFN4Ds6XnombLlCaP0Syt+M32bTrCIMEZjVTMadF
	jjsLbK/D998rDslsR6O2ieYN18vXY2ePHLs6YBe4H4h6n4KA0qjZ8ujEHY8wQIlK
	EMsvG0CkBbkOwlDO2uMoTjYxQZu7MAmc8WIpCUwzBgGzIWaCkuCQPKUgWgxvXkgQ
	j+HGmZWitDXVQ6ITuV2mnrcv3wDHE5Jtbwu/VfXU4TxaO3gslxUkZGh39gjY5pl7
	w6FFwqLE5nFygxfrsF3Bhoar5vBotgZOqJfx7ueACUOAEFPkKoyFfCG01J8wYQBg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4cr6cqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:49:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QAPhJ9002215;
	Thu, 26 Feb 2026 12:49:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfr1nbdd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:49:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QCnWxX57016670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 12:49:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE8AB20040;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A6DE20043;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
Received: from [9.52.198.32] (unknown [9.52.198.32])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 26 Feb 2026 13:49:05 +0100
Subject: [PATCH v2 2/4] s390/sclp: Detect ASTFLEIE 2 facility
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-vsie-alter-stfle-fac-v2-2-914974cb922c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1652;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=TpvDCmwor6cASpK8/j/9E6R2qUQYOgtE/cgiy7FG0Tg=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJkLHKP57fK/iiv8enhDObB7q7HNKdb9hx4w2m2TEzi7c
 KndvSufOkpZGMS4GGTFFFmqxa3zqvpal845aHkNZg4rE8gQBi5OAZhIgh/DHw6haQ/kTpl0ql1T
 27lE5e2SnHW9c1cl1t3bspb1zufArNsM/8y7+Au3nV7o/s5u36Xd7G9XWJzXfnRkL4fdn6s5ry8
 G/uICAA==
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lxR4JP5LWqtAfKVh2vL-EuPr6xZGpIFU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDExNCBTYWx0ZWRfX0L5DJIvnKkuT
 OJJp1ur9mqCWzprQ9BshJFNRZh1u3GAMlPHxujh0L9Ek8Q2Qp68u/+LDFNx7r8caLSVp3qtdY91
 1W3/DhqAgUO/vKEgydWinDLYT52Q8mFsHbalQsJyfp5Vh1C432RXhK/HnZTB2feq7/4fE33p8F6
 Ab2JUhJW43jRQUZUAaHQNWeGGMk6gN5fRvLJW50zEHEOQREY8s9HtnthsMqw005SUx+CayPASak
 M300Y23I6bTaQnUD7/f37kAUZ7Q+apBPahZmXF+KywGWU6jR0LGRG5AEABJFoG/Dfa2dwxLIYP4
 +NXanHYrqcYj9kwgEOKlZPM8pGRCInoVkc1584weqMI+vWmIOi49cwMT4FaVGY4rdk7TIp1NDPa
 Z9ah+LSTnXXq8FG8g1rlFWdkzqUsH6rwx0huSiqfkLIZ/wromLkKfpuMTsrjovLvbkjh805/GWE
 Yr64D5euUiuniqzVbsQ==
X-Proofpoint-GUID: lxR4JP5LWqtAfKVh2vL-EuPr6xZGpIFU
X-Authority-Analysis: v=2.4 cv=bbBmkePB c=1 sm=1 tr=0 ts=69a04161 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=txTkv-xiYvDc7-xnE9QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
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
	TAGGED_FROM(0.00)[bounces-71970-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 711171A5EE6
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Detect alternate STFLE interpretive execution facility 2.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
---
 arch/s390/include/asm/sclp.h   | 1 +
 drivers/s390/char/sclp_early.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index 0f184dbdbe5e0748fcecbca38b9e55a56968dc79..0f21501d3e866338895caeed385aa4f586384d69 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -104,6 +104,7 @@ struct sclp_info {
 	unsigned char has_aisii : 1;
 	unsigned char has_aeni : 1;
 	unsigned char has_aisi : 1;
+	unsigned char has_astfleie2 : 1;
 	unsigned int ibc;
 	unsigned int mtid;
 	unsigned int mtid_cp;
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index 6bf501ad8ff0ea6d3df0a721f29fd24506409493..22dd797e62291fef087d46ac1c7f805486e3935b 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -61,8 +61,10 @@ static void __init sclp_early_facilities_detect(void)
 		sclp.has_sipl = !!(sccb->cbl & 0x4000);
 		sclp.has_sipl_eckd = !!(sccb->cbl & 0x2000);
 	}
-	if (sccb->cpuoff > 139)
+	if (sccb->cpuoff > 139) {
 		sclp.has_diag324 = !!(sccb->byte_139 & 0x80);
+		sclp.has_astfleie2 = !!(sccb->byte_139 & 0x40);
+	}
 	sclp.rnmax = sccb->rnmax ? sccb->rnmax : sccb->rnmax2;
 	sclp.rzm = sccb->rnsize ? sccb->rnsize : sccb->rnsize2;
 	sclp.rzm <<= 20;

-- 
2.53.0


