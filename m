Return-Path: <kvm+bounces-72527-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wDS6MlnspmmQaAAAu9opvQ
	(envelope-from <kvm+bounces-72527-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:12:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB121F1283
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1DFB319C3ED
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 13:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D48B362121;
	Tue,  3 Mar 2026 13:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n/MiRvLB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC3B35AC2A;
	Tue,  3 Mar 2026 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772546050; cv=none; b=EuIBJAaozIUnkirkyhIgC7NXbPovGEb2KS2B0oMjPSxFWo+Rhue7JG3/IX8aUKLbkOhaHnPvUgvUwSxDNSKAGl71troADZ/DkokcLe1pcm3yv3sbKuozj+EImwuvilkApFBDuPcUWSPqN8vqDGxbnTFqk3v3tep64gaF28sNUzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772546050; c=relaxed/simple;
	bh=e9JklGsuGnuRMSdEqvb5+l3qEMMCpWiYy172iVOc028=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u+PJ9uKs6lon7YbxG+Vpvwd+if/FabLY1KYjbOk4mdY6duHTroWAYPp1sv9cRekJPcDmhpaHm8m1mBV4sTsVEdhLG6xE5L3OzQ2tGOTAdOQravmQmw8DdmlrjLAPHjLk2gEllhaPA4/lgxi3KLuvFxM1+WykwcvD3mQwNRfOw2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n/MiRvLB; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62381udV2123727;
	Tue, 3 Mar 2026 13:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=X5oVahg7GQlz8cfawRgfbe73y9kbbBpDeFYCSDDrw
	bM=; b=n/MiRvLBn7gcUUKEYjIL17xLM+kwDSqB8mDcm26gCzzM2dONJZ8kWS4be
	uuUgJBIAxILA6xwlqzbrjMIvr9q6d3Dgv5B5U75Mzi0yqDVt92ho7okhvqOmOWmk
	3H8/3k974Sh1HEKlssVWDs5PPMkVukLAU0TqDAQDM9n68O23b7loTvbdYMhT2Kdp
	gitcXQoFtndDT4FK8ITnZm8+dup7V3yjv14OBvoRI8BBMl3M+xoyUTdNo4LqIrG1
	BTnixNAcHEQaJlcLS66QZWRwCekdl8haCUntAtGlT+K0QaVz+XwVgOvrZ34tFSwI
	oTx+1omOlrocJ8nIz4rpmCbbCEGmg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskcu6rb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 13:54:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 623A3Oet010317;
	Tue, 3 Mar 2026 13:54:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmc6k2ere-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 13:54:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 623Ds3IU26870128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 13:54:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CBF020040;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22A8020043;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
Received: from b46lp25.lnxne.boe (unknown [9.87.84.240])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, mjrosato@linux.ibm.com, freimuth@linux.ibm.com,
        imbrenda@linux.ibm.com, borntraeger@linux.ibm.com
Subject: [PATCH v2 0/2] KVM: s390: Limit adapter indicator access to page
Date: Tue,  3 Mar 2026 13:46:33 +0000
Message-ID: <20260303135250.3665-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QSashC0xx1YQ7q4RstNjz2i5SjrEsFV2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEwOCBTYWx0ZWRfX+ouGZPaHEYod
 6ImLCVka5CyMlFo1Gc06sbLckemRZUvo92IRazsfeYmoY7EYdvuHWAE2/U1WPmmzoznqCgxoF+Z
 8dQwc3PDGUvx9RjGHHi85uHpgdju9iSzm4NYARVoxITMU0OpQh/3Hv0zq0Qq1tNYURyw2s6lakH
 k4q3Bb/0/p57TqlhuI3bkIz4ecmmmWKmBaEh4fXfFbBr1MycnYjwp684GMetZZyqICmSiuKD6KN
 NiEu7CcLbYsCDuXdGIbL8GqQFzzfjbzNHnWO7r+6POGkg1SUsSH1TCEeGkwG0s9ZQ0T4mkzpIKr
 SEWALkVc1ePf3vFVxeLJZki0c6uBLHzMzG8YMAwmJQkp9dfX7Ok+nINiQxm9M4VPvmUPr4Y7kpP
 gPuszDJpqehKJSTleOWHxZmyy/i+hLjBPLba76eNsY9BHaGmpAWUmfG0DUmTpsRIKIigzKo+2/1
 qDA8kt2c77rdW6mwamw==
X-Authority-Analysis: v=2.4 cv=H7DWAuYi c=1 sm=1 tr=0 ts=69a6e800 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=8hHfqOmpiw9s73ohtJkA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: QSashC0xx1YQ7q4RstNjz2i5SjrEsFV2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030108
X-Rspamd-Queue-Id: 6FB121F1283
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72527-lists,kvm=lfdr.de];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

We currently check the address of the indicator fields but not the sum
of address and offset. This patch remedies that problem and limits the
address + offset combination to a single page.

The selftest is very rudimentary but it's a start.

v2:
Reworked KVM limit check.

Changed good-case test to subtract 4 bits instead of 8.
That should ensure that we catch the error I made in v1.

Janosch Frank (2):
  KVM: s390: Limit adapter indicator access to mapped page
  KVM: s390: selftests: Add IRQ routing address offset tests

 arch/s390/kvm/interrupt.c                     | 12 +++
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/s390/irq_routing.c  | 75 +++++++++++++++++++
 3 files changed, 88 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390/irq_routing.c

-- 
2.51.0


