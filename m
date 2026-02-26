Return-Path: <kvm+bounces-71967-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Bp2BPxBoGmrhAQAu9opvQ
	(envelope-from <kvm+bounces-71967-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:52:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95B9B1A5EA3
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 363BF3125D70
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0316E2DAFB9;
	Thu, 26 Feb 2026 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nG77X7Dj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034AE2882D6;
	Thu, 26 Feb 2026 12:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110181; cv=none; b=BW1X93OftUxcdRurl9+NysWZzr3g0f/JYI9au2rkSc6gRqGw8pu0gzU3wcBhjnA7kfLAVDYFvhzTnWdA3idNDKqL/grrrz2CDOkQ3zrd10SzFb8iczoMtIzqMeOAZCu/mPIjdz8XlVldCv+ftYUHoGzsEuB0eUunBLURJ9qLdjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110181; c=relaxed/simple;
	bh=r+VJvl1h78tHxpsL0r51tGrYhtsqOOtmKrt4mDGuf4c=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tQPAsr5TQf957K33nOv8g7W2IX7PSqW1byJ9upUaTrrE1GCqh0k9Sn0siACco6FO8hJPMa3AWjwXGVyBg2GrbgiSbGFz6H+HL6kpV2uUEr6ep3TTfvTcbo1osCqO2adgy4oaKZoBnlhDMSKi1tjB/y9Ey3uxAk0bKnJVucyf6hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nG77X7Dj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QAwoQC2848171;
	Thu, 26 Feb 2026 12:49:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=tEEExC3DtC3gRLyASQVisoqGkiCw
	Wz/to2dVxZu8xBM=; b=nG77X7DjSXVeIkEiD2Z88JaW8L9YPWl721mxNizn33WN
	IKPuqBaR4+Y+58cc/1XTaoG0Cz2lS+ANcv/60Vkmbd0lS6nS3U4tKCTQH69/ooQS
	F4GBF9e2KsEK5srnV77A3MmfLW2SIGoOPZn7HcldXTHDz4oeZSXhPpWkmPc2n92H
	wGpgd1rPDM+l0oft/DNUXcHTycj+f/NS6R9nNf5YNU7XfrwvcRdcQL3b+mzPUPe5
	PQFglCKhcCv7wWxsoyj/zFB0kZfrGNLZom8m/qIZe2iEHMUlfdUEyBnxbAkvE0Q4
	2VDj0aTwqngULI/GuhVoWqhAdwwWc5cVTDtgtnOBnw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf34cdjj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:49:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QB4HpW003413;
	Thu, 26 Feb 2026 12:49:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfs8k3631-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:49:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QCnWoj57016666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 12:49:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48A0120043;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12DDB20040;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
Received: from [9.52.198.32] (unknown [9.52.198.32])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Feb 2026 12:49:32 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [PATCH v2 0/4] KVM: s390: vsie: Implement ASTFLEIE facility 2
Date: Thu, 26 Feb 2026 13:49:03 +0100
Message-Id: <20260226-vsie-alter-stfle-fac-v2-0-914974cb922c@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22OSQ6DMAxFr4KyrlGSIoaueo+KRQZTLDG0SYioE
 HdvCtsuv/39njfm0RF6dss25jCSp3lKQV4yZno1PRHIpswklyUXsoHoCUENAR340A0InTKgr1b
 WuilqUZQsnb4cdrQe2Eebck8+zO5zWKL4TU+gFPI/MArgYKtKaqwKVVh1H2ha1pz0mJt5ZO1+W
 hy+l/RzOFVMK4+Q9iOFWxarnIMzIpX3L2ElyZboAAAA
X-Change-ID: 20260129-vsie-alter-stfle-fac-b3d28b948146
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1560;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=r+VJvl1h78tHxpsL0r51tGrYhtsqOOtmKrt4mDGuf4c=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJkLHKPuN1u/d4s8qPU0cfo3+90JsvfMdCr2OvhtPe0h9
 tc4mk+qo5SFQYyLQVZMkaVa3Dqvqq916ZyDltdg5rAygQxh4OIUgInM3MrIcFPQI1z5asDb1aLJ
 uZxKO3w5tXkka6YecO685cE5/4MVA8N/R+GPNXNTU9XjeV2/PC8r5F/50vL4XHvbvO03p56O9zD
 jAAA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDExNCBTYWx0ZWRfX+EatyZ7l42JS
 mT2qHXkJvDECHTq4B74nPok2Y5WXm7SQLGACae8ayn0TxHo8poF8uFv7IEVQxvzXrtvspDh0Ciw
 8qQ/uNIn8z27zFERwMl3EdlpNX0gtlFMj1R+mUFygDKNQ7gwyg4WYfaPYt81qArhrGGv/TsEzv8
 MHXmT3kyXaFjq2DlMVQUe89I4ngRE3NyILBBoTE6xMM+7QmfdloOhauevpt5a91ZL7lOKu0+iLz
 9TqujbbUrPidBikj8p2Eb4sgu9gXSpdbEZl+pI3vHAlNJCrOcxo/r8x4HyuGCmfKueeGE7uG2Lf
 Rppv9cqxFApucMj95sQWnL2NbTTwvGuAZRzjFRdZGPYWSLEY9IBbcE2ImJAkllaCCWmDISMpWq9
 LklWc+HjfnW0+iAQPzH+CLIOIOLRlyZp26v6wHoUX1xzGWZMxtCa+C/K79vU+M6crSQp3/bM+5r
 /qmtD4TqM/h6LtGiTiA==
X-Proofpoint-ORIG-GUID: W9NHIEcRsv2Yt_D6rzPC-tHbV5xFfgaP
X-Authority-Analysis: v=2.4 cv=F9lat6hN c=1 sm=1 tr=0 ts=69a04160 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=JTEGq0UErLZmNMgf6yQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: W9NHIEcRsv2Yt_D6rzPC-tHbV5xFfgaP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602260114
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-71967-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 95B9B1A5EA3
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
slightly adjusted by me for v1. It was not sent earlier since the accompanying
kvm-unit-tests and qemu changes were not ready.

---
Changes in v2:
- adjusted variable naming in handle_stfle()
- add some constants for readability
- add struct for format-2 facility list control block
- rebased to v7.0-rc1

---
Nina Schoetterl-Glausch (4):
      KVM: s390: Minor refactor of base/ext facility lists
      s390/sclp: Detect ASTFLEIE 2 facility
      KVM: s390: vsie: Refactor handle_stfle
      KVM: s390: vsie: Implement ASTFLEIE facility 2

 arch/s390/include/asm/kvm_host.h |  9 +++++
 arch/s390/include/asm/sclp.h     |  1 +
 arch/s390/include/uapi/asm/kvm.h |  1 +
 arch/s390/kvm/kvm-s390.c         | 46 ++++++++++------------
 arch/s390/kvm/vsie.c             | 85 +++++++++++++++++++++++++++++++---------
 drivers/s390/char/sclp_early.c   |  4 +-
 6 files changed, 101 insertions(+), 45 deletions(-)
---
base-commit: 559f264e403e4d58d56a17595c60a1de011c5e20
change-id: 20260129-vsie-alter-stfle-fac-b3d28b948146

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


