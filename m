Return-Path: <kvm+bounces-70933-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNTFIX6cjWlT5QAAu9opvQ
	(envelope-from <kvm+bounces-70933-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B5CF412BD71
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:25:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6CE783014065
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA8F2DF3DA;
	Thu, 12 Feb 2026 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QbMQgdxy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035D23717F;
	Thu, 12 Feb 2026 09:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770888312; cv=none; b=MeQmhx0dpytLaFOR47jTMYSRI43HzLGP+EL0OsGsS4QD7Cl9Oj/vlMHuJ8subEC8ddfCvFPsQPEHelIVTbNaGWO5CawoRdDI55mRFCfLQuojwp4aOhZrpJOhkgnAbbKbKCiPSj7j3VSB0D0FNhjeqUaU5TsYLLOt1x0SH35ZMg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770888312; c=relaxed/simple;
	bh=BrGqZSomPd2cGkdUmMWcBpwMlLdo741geisUZbV4og4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ESphHg9LPmmXG/RLhk0K6+yNdQTzC2dAksiGa6vu7ySnPPVcRCDjfT/dM/qjdQv1C8LV9/Un4iUk6U4442NgwLYQMQ0xfTJBob33aA+LCNJwZ5ujAu2nNfQKf0sOT+yMeC8Z+hZ7L6wNO+0hWoN9UFDxZFvAWiS373Tk4q4JrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QbMQgdxy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C5KfaK027884;
	Thu, 12 Feb 2026 09:25:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=ofdNzYsQ0eTUk++pFWVmL5EeU+ZD
	WS7PT3nnHr23HpM=; b=QbMQgdxyveLTepcbm49Doj4x8Jvlfi1cYCER7X6qplz4
	4BVZmGM8k6p7z8J/YCmvY5lu0Qy8EoQ1gnplPUTMgIU65pg4fhVq9AxJsMjk64MK
	57KXsLY2YmU8rkwplfOpqVuFIcTWV2iwgZ+9eyztQLmdbsW62N98KvfLGuPFeC82
	1h5VLfhu9ofXtU6NRfD4KEWKrCYp18PJev5Pbp4V5VlGpS/TpQtq2uBBP6IxvNaF
	VoXoG7CenIRNJyby8B7rDaUjrEDgQZacVxrTAqxXJopDBabBFVNycF6JBK9ZXv7/
	bu6/oTYsG9AFbprI+YGOvoatGbEqZSTKERQSacHcCQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696x2rw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61C959js019277;
	Thu, 12 Feb 2026 09:25:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk9ksc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 09:25:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61C9P5tm51380664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 09:25:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 155992004B;
	Thu, 12 Feb 2026 09:25:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AC1D20043;
	Thu, 12 Feb 2026 09:25:04 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.23.205])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 09:25:04 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [PATCH 0/4] KVM: s390: vsie: Implement ASTFLEIE facility 2
Date: Thu, 12 Feb 2026 10:24:54 +0100
Message-Id: <20260212-vsie-alter-stfle-fac-v1-0-d772be74a4da@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3NQQqFMAxF0a1IxgZsFVG3Ig6qphoQlaSIIt27/
 X94Bve9F5SESaHLXhC6WPnYE0yewbS6fSHkORlsYevC2BYvZUK3BRLU4DdC7yYcy9k2Y1s1pqo
 hpaeQ5/s/2w/JK2s45Pm9xBg/SUueOnUAAAA=
X-Change-ID: 20260129-vsie-alter-stfle-fac-b3d28b948146
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1321;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=BrGqZSomPd2cGkdUmMWcBpwMlLdo741geisUZbV4og4=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJm9c/LkavzFZj7L+dfo+OR95KRq5XiBsrTZ/u+2Xsx+w
 LntX1tuRykLgxgXg6yYIku1uHVeVV/r0jkHLa/BzGFlAhnCwMUpABNx52X4n+FwgydlZxNj2Ie3
 C95XGXtP9H9x5P7x/fkPd8++91G6ewcjQ//VxCqXr5GS78TzdzOz1O0vsOWcbMLal9P87Lrr1Xd
 CTAA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698d9c75 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=JTEGq0UErLZmNMgf6yQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: MOfj5-ySv5pPyFy6mnXJzpLklkzIBb9o
X-Proofpoint-ORIG-GUID: MOfj5-ySv5pPyFy6mnXJzpLklkzIBb9o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDA2OCBTYWx0ZWRfX5SP6QmQPzs0F
 jcf9kS6XSFDU9nS+AD4T8JSIo3iQqeE9uNONKyAt458NjWPdQBeSpIaVUZAK/FGuLw7gqDzYxfv
 W+dSzZWR+ECTGNa+9hhp/fEQA0SQTF/LudYxF9HkhTCaWW/qqMJCgm33LB4Vh4yihU9GYw09m5G
 T+PyAdFhWf5CIOkXKNn49rBvM388RbU65OnUyoq/PnnPUJkEyxokZZutat0l5x4Ve3pD45x6gSM
 2aGlrc7o1AaQ3mmD4GCMzLDMTqxHvC1Q9ZDes8+R0r5Nrf3yStyeiXWRFhzkoBS26EIep9K+YvH
 3KzOUMIHNwqQZhaBxRj69jIfPaGye6tNnyAtcV01bfDo4iM0Y7gqHbZAZp96ejfTcd4cbMJH12R
 EH7opZrQCbSuclGeugggV3hEDJY2bkAZlmL5op+StSY6H42SCDMetedfxOsZeTr6NWUyX6xzVgv
 JhIrGuZPMTE2OEOe2ZQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602120068
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70933-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: B5CF412BD71
X-Rspamd-Action: no action

Add support for STFLE format 2 in VSIE guests.

The change requires qemu support to set the ASTFLEIE2 feature bit.
ASTFLEIE2 is available since IBM z16.
To function G1 has to run this KVM code and G1 and G2 have to run QEMU

Tests are implemented in kvm-unit-tests and sent as a series to that
list.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
The series was originally developed by Nina and only rebased and
slightly adjusted by me. It was not sent earlier since the accompanying
kvm-unit-tests and qemu changes were not ready.

---
Nina Schoetterl-Glausch (4):
      KVM: s390: Minor refactor of base/ext facility lists
      s390/sclp: Detect ASTFLEIE 2 facility
      KVM: s390: vsie: Refactor handle_stfle
      KVM: s390: vsie: Implement ASTFLEIE facility 2

 arch/s390/include/asm/sclp.h     |  1 +
 arch/s390/include/uapi/asm/kvm.h |  1 +
 arch/s390/kvm/kvm-s390.c         | 46 ++++++++++------------
 arch/s390/kvm/vsie.c             | 84 +++++++++++++++++++++++++++++++---------
 drivers/s390/char/sclp_early.c   |  4 +-
 5 files changed, 91 insertions(+), 45 deletions(-)
---
base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
change-id: 20260129-vsie-alter-stfle-fac-b3d28b948146

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


