Return-Path: <kvm+bounces-70935-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHBYOIScjWlT5QAAu9opvQ
	(envelope-from <kvm+bounces-70935-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F5212BD89
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 97CF7301FB50
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6ADC2E0B77;
	Thu, 12 Feb 2026 09:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="At8sYSD6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166992DEA87;
	Thu, 12 Feb 2026 09:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770888314; cv=none; b=fMQdfuI6ZlozomAr809Ki0jyjMqEaWjtU5O57gYUjHH6kAmjTxDzPh3VuNUyZpUJI6OTWlnpS0mWpT/DayQ0FPhnbEdZsVW/0bTG1KZR+NFTWs0ESBDLpBeL+Dm3u3EpbHAG4kqxdKxT9mHXZy+7BOvnNxyGdkWilTwF0611KxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770888314; c=relaxed/simple;
	bh=mjtrjEnlvBvA9mPhwVutaggz/MS0399H4EuGUSjv8j0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pmwNuKUZ3W1wBgisbZ73iEvYozuDbWv2f5981zvasUhHS/BSChjrzYOsLk+n6xlVXKIisO/AhK3qQK14gdOXcJ/qwWjR+6MYk/Xupw+2cySI2+cF8carbVBUmtAjFrCtBb8I/Y8g5SdNkkd2hBB5sUgYBWuOqKdm1QzsofC4DoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=At8sYSD6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BKe1v73371925;
	Thu, 12 Feb 2026 09:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JrPU2O
	rBuWXGBk9NsKFjPLB9HQPDrIL6lAmO3p7EwOg=; b=At8sYSD6UJw1dJ000ryQVO
	+GD4AZJVE6T/CYuns2Az8g9WjhVcO1C0qzDxGDhJcfF8mweAWKHbeDdQCezq+jTj
	hU2J95Djl962fSsMe4BsO8QLAmhYge0WdEg/e6XFNgz2aZ8f2q/e2v/hoyxnGU69
	b6bX2CboS/GeKT0e836Ealz/h1n6e9R0mIN8Mdr5uYvKX7z5s58vZGcXiJYjLxce
	V1OYc9a6eCJOZ8axCEvZ4RaniS2M3Cu4o45c1sWfqcd7WCGrXEoDX0q16zQSsJsD
	8xxaz/eiX7yO3DBwPe1owwc+MZyuClEn/KrhzwGZdxAJySSiFXiEpX9TJRbLVUqg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696unfb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61C8oQNe008413;
	Thu, 12 Feb 2026 09:25:11 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3yhv6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:10 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61C9P74v58720694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 09:25:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E79192004B;
	Thu, 12 Feb 2026 09:25:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2397E20043;
	Thu, 12 Feb 2026 09:25:06 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.23.205])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 09:25:05 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 12 Feb 2026 10:24:56 +0100
Subject: [PATCH 2/4] s390/sclp: Detect ASTFLEIE 2 facility
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-vsie-alter-stfle-fac-v1-2-d772be74a4da@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1542;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=lP5uB9OWejOF5OnY+Ws7b2hG9Di8F70k8MIBlAsq0po=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJm9c/K7Tl6rObHtj7H5g0sGjA/qfljMjp9l8GvKVtXld
 zas3PWOp6OUhUGMi0FWTJGlWtw6r6qvdemcg5bXYOawMoEMYeDiFICJmJ9j+O/0mvF/oIafe1Lv
 nAkSTJPiYwy8r201T0t79cr+/fcN7T2MDEsmP13/c9HieyodctUm+6163eXq9DfIzYn9Xtv1MDX
 ElAMA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698d9c78 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=txTkv-xiYvDc7-xnE9QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDA2OCBTYWx0ZWRfX9yyduXRhDxQ7
 IfRvLZ8z79/ZZatA3oAtik0jy3F9VEOij3F1Tk1NiR/tHImHq77QCm66aCybLcKPjviWXOI3S8M
 tehwdyZWeD92tQ/RwwwT9M0zuryqTUzCLaO1/ipHYMPScXmgiSE4WfhPQRWcV9g9qPfu9nNPkf4
 rkRyjYWIoED+vAWf41pnLohkvlObjC7F/P7oqVVzK6V6CwCY5SBxOkWRwwVDB9YEz/h77ymCT3C
 oYxKSz/gwMmD1BGvvM4MXx152zoCD6B2medRyg/Edui8rS4jj3dl75ImUVuQjr9G8FuWRa85Laa
 4RP+l+uUEAm7v3Y2nxYx4SoRDktYtdpUBCIluf4EUa2e57NoSj1qdKqnq6XqNuzwwhYHRuvRRWM
 LpdrZysxGm8uH+zigsfcr44FUnlZrGAYqjhGnGsDR4SwMu5VKS4+0CCo9GSX76HR7ZkTva0GSoD
 DG/E0YIKWdCpMTTKYCQ==
X-Proofpoint-ORIG-GUID: xCVHEaDNYvt9Fl9eVTvnNGMBCSjQL777
X-Proofpoint-GUID: xCVHEaDNYvt9Fl9eVTvnNGMBCSjQL777
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
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
	TAGGED_FROM(0.00)[bounces-70935-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: 53F5212BD89
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Detect alternate STFLE interpretive execution facility 2.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
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


