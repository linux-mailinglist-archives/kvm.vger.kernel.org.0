Return-Path: <kvm+bounces-70852-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6NdTD8CZjGkhrgAAu9opvQ
	(envelope-from <kvm+bounces-70852-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:01:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE9C125616
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 63295305731D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0282770A;
	Wed, 11 Feb 2026 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QKlzk+wA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BDD260565;
	Wed, 11 Feb 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822014; cv=none; b=lQ6M0CUWI+pLPm1xifjuOgidYAEoulOKxtIzTKZ19C9nhlO0b5Nr/Ij1DBmqrwRm5hsMudz09w9y2BNLdomWyw7ZqQHlIQk/ZH0O/xTK5EL6wJWdZr1BKWOeVatGd13u5kpyjW8jxHlNS/FPTE98UinQa9qeoaFhXMrSnof8RUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822014; c=relaxed/simple;
	bh=2VWmao3DGMYpxseufmX7LejQ2MYg2qdouEyxR43uWY4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OKX0FmrKjBsWFkXb+3HRlR2WahQWU014TfSyxBAaU/rj3zBdauYk6SCsXX1s0CpqPlcj6ok2ior+JJ37X4z+yLuecnYl6W4FKk1t9m15mOMEoBuIYymhIdoOhqGbT5I/Ejd2wdvAqmeFIyGGmg2ucrYiJh6PAN54g7UN5MEiYQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QKlzk+wA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BB2ars3671972;
	Wed, 11 Feb 2026 15:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fyhZdS
	BqGMYG3HypMWc2+qf2P0xVHovetMmGIVqOWOU=; b=QKlzk+wAAgrr933XqwKw9M
	BoGlifuMk47KvTdfGbN+yjBJEeYCCLAdEtVr7DWAy8epkXdGyU6+m+lE39b1LdGr
	/Ia9C8OI/OyCzc+qf74Mmx2O4Nt/eTtAFeCHe6rwu50T1lzeJbQo3o0JZZVxwis/
	krIOIA3R7D8slN9JZwpcP+WptL6gI9LRdsBlowbXsAHcf5gT4Y3EHgmHN2Lv0bLx
	OObZnGI2Z1NhzBFlsyf/paTPTkWPefcxJ2HlQ4odVb5cPR84bsAerTLzAoMHCWSw
	ZZgQQFhKc0cFoEts1qvGXcJv3fehKOYUJjVGwe31XWeOXoIaCl3WZUP+GKqzj3QA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uy6hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BDecT2008390;
	Wed, 11 Feb 2026 15:00:09 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3yea9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:09 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BF05Es16777518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 15:00:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31B992004D;
	Wed, 11 Feb 2026 15:00:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C294D20040;
	Wed, 11 Feb 2026 15:00:04 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.49.16])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 15:00:04 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Wed, 11 Feb 2026 15:57:05 +0100
Subject: [kvm-unit-tests PATCH 1/3] s390x: snippets: Add reset_guest() to
 lib
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-vsie-stfle-fac-v1-1-46c7aec5912b@linux.ibm.com>
References: <20260211-vsie-stfle-fac-v1-0-46c7aec5912b@linux.ibm.com>
In-Reply-To: <20260211-vsie-stfle-fac-v1-0-46c7aec5912b@linux.ibm.com>
To: linux-s390@vger.kernel.org
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2029;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=bjVh2Jd4HUPneagPovR9zNlWE3EhhmtPr4fePzoLyQY=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJk9M4ujmQzEg5x1OvYvSJS6sON4ZU5B9BeWGdUrPk32q
 mN1nyHYUcrCIMbFICumyFItbp1X1de6dM5By2swc1iZQIYwcHEKwETM5zIybHJJCNT58HyinWgy
 j9dJ9X83Hx7ijbhn5qJ8RrdB7c+T2YwMR9/s8o3ecfOgyCLjHmceNZfYE0fen5QViQr8MnHWIVY
 VLgA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDExNCBTYWx0ZWRfX5IkkrGnoXbsJ
 jZP22+kkCjurGNDRWjwOz7NUAfYPEp/XcVDotm7pz3/gAItyzBcG75ME4eHtaIspdiWlsaOj7RL
 haXKZX0E6OEERiCXY65aPUAATXb7L/WP8BUiBcAywRpo4fiLfJLXZs6Q23+Fv3rjbvlFnpMi7zP
 Rb9r2orpYpJtGV2fpqY/SFcszKySMZos29BDPYs967u/A8C8v9PguxfShLRdSCDXAM/rTb6utk/
 3bbDbP8NxcR/ow7XpiQUwghuLUylLl7OKapqcEaApDTjM13Klqa/gaAH8UKl2eU9bu5yTyG3f0a
 1q0j4vspvSkCl6zVvErZ0Itt5X7uNO/14FedCGlPf3eiDWA/+tKYeJ3LTsLN/Q+VlMgt9en3Z9E
 YeHkBJtHx2oS5Pn/24gbVxQhcwCPWHnk1MMUDbyMx1Wc5ayOEKlvL1wnD5z4Ped62JZYExoZgMi
 PTWuVh4xo//SCEuhPKA==
X-Proofpoint-ORIG-GUID: gNGaQXrCHNFIe1iEGy_u5udDMf8ohitw
X-Proofpoint-GUID: gNGaQXrCHNFIe1iEGy_u5udDMf8ohitw
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698c997a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=_bFefhojSA62otXczxEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110114
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70852-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RSPAMD_EMAILBL_FAIL(0.00)[schlameuss.linux.ibm.com:query timed out,nsg.linux.ibm.com:query timed out];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: BCE9C125616
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Extract reset_guest from spec_ex-sie into the lib.
After reset_guest() the snippet can be executed again.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 lib/s390x/snippet.h |  6 ++++++
 s390x/spec_ex-sie.c | 10 ++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index 910849aa186ce2f94c64ac1f40f8d6d7cdc36a1f..6f611de510d832f23384739606da13e71de3d6fd 100644
--- a/lib/s390x/snippet.h
+++ b/lib/s390x/snippet.h
@@ -83,6 +83,12 @@ static inline void snippet_init(struct vm *vm, const char *gbin,
 	vm->sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
 }
 
+static inline void reset_guest(struct vm *vm)
+{
+	vm->sblk->gpsw = snippet_psw;
+	vm->sblk->icptcode = 0;
+}
+
 /*
  * Sets up a snippet UV/PV guest on top of an existing and initialized
  * SIE vm struct.
diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index fe2f23ee3d84fa144416808cb4b353627fe87f3d..75625ecffc4a5a09ff7ef6136b7f1120a831a8c5 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -31,12 +31,6 @@ static void setup_guest(void)
 		     SNIPPET_LEN(c, spec_ex), SNIPPET_UNPACK_OFF);
 }
 
-static void reset_guest(void)
-{
-	vm.sblk->gpsw = snippet_psw;
-	vm.sblk->icptcode = 0;
-}
-
 static void test_spec_ex_sie(void)
 {
 	const char *msg;
@@ -45,7 +39,7 @@ static void test_spec_ex_sie(void)
 
 	report_prefix_push("SIE spec ex interpretation");
 	report_prefix_push("off");
-	reset_guest();
+	reset_guest(&vm);
 	sie(&vm);
 	/* interpretation off -> initial exception must cause interception */
 	report(vm.sblk->icptcode == ICPT_PROGI
@@ -56,7 +50,7 @@ static void test_spec_ex_sie(void)
 
 	report_prefix_push("on");
 	vm.sblk->ecb |= ECB_SPECI;
-	reset_guest();
+	reset_guest(&vm);
 	sie(&vm);
 	/* interpretation on -> configuration dependent if initial exception causes
 	 * interception, but invalid new program PSW must

-- 
2.53.0


