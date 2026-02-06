Return-Path: <kvm+bounces-70440-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMwGMDP9hWnUIwQAu9opvQ
	(envelope-from <kvm+bounces-70440-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:39:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 287BAFF136
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C1C43047E57
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94D741C2ED;
	Fri,  6 Feb 2026 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mvZqzVub"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF6135E521;
	Fri,  6 Feb 2026 14:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770388564; cv=none; b=QIGh6SskhRCF657mMU7G9J7IM8zWhkLTtb//Pqn8UGH7vXUYea8MCecwKzmMrjrkqIEDSkNXl9K+Q7N1qFtRcaaWtOUdCG5niSZOiSfXfvZicN/ip9zE0H6royuVa5g4e+FHkqJ1Cmhdr0E09JA5v8rGWwjSLZIlgzWOJ66Z+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770388564; c=relaxed/simple;
	bh=WxZSVR28C0J06CdU5HpuJp3SEpsQ34WB+WC7Ni4MoG8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lW7Ngsq2MzM2bdKYoc4Kxt/9PymVn/KGkLOkjmAn9uzmcO7hgbne2OfYydJ2c9iHt0kytow5ireVa4bUDfaryoqKYEXsC8vWFtyBX4BAV3vlh/fY/Bd/35Z8/1rjrMIqnsQoXZCHmaa7j7foj5njuREDM5X68Bb5VWl7iiItdNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mvZqzVub; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616CT18T013535;
	Fri, 6 Feb 2026 14:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=fT8m/7oDs3uUiDibf1XM9svipsmU/rlg5tX/Cgqe8
	sw=; b=mvZqzVubEw71YnwmUOsYniIPdnx3oeNpsvb/pkuvIogjbAIwSAQf3tZG5
	RbEZVFc/pJ6d0D4N7XkLs5pCq/8k9q0JfeGxMyzUHzHEu/M1YQMpkczxETlZSXnf
	UsxDTB4KbJpIrAOzCEbRQ/znsjh1ocTz7MnLIC2qylD3jHJq+mJlfetC8FMIBE3A
	QRsti2c4NtF0Epm+yvzlMbZRmiew0LoNKme1V2VECpUY4+zhyw/qSCsWEhqDrULe
	pW2GsaGmExVA0F5mFhGCR1nXmcY9vkMFDBD8eBHM3As2/oAoHFNfAJfr3sKp2LXv
	zcgVMOSzmjrilr5ENEeNyHjgP2Jrg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cwgrey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:35:59 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616C33FH025735;
	Fri, 6 Feb 2026 14:35:59 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1w2n6f70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:35:59 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616EZtmf49807864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 14:35:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32F8620043;
	Fri,  6 Feb 2026 14:35:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4901120040;
	Fri,  6 Feb 2026 14:35:54 +0000 (GMT)
Received: from p-imbrenda.t-mobile.de (unknown [9.111.61.157])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 14:35:54 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v1 0/3] KVM: s390: Three small fixes
Date: Fri,  6 Feb 2026 15:35:50 +0100
Message-ID: <20260206143553.14730-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEwMyBTYWx0ZWRfX2pYc2Klec8oc
 1ZdISFZ4lp5zvS11gGGfFM+CFL164f+m4WrnerwAuVHUENiCXD3pSjoTgID1btg0MMZhDuddjAg
 GXYj/CCJ2lVOwaRzue6liAu6RZneXgke63dTApw4CVEo93vfDWXeDPNAFFcXTj+UOu6TV9v3Vp1
 B03kGIFptX8n5C2+XgPSXnyvXpmwp2kru8eiFD7E3447O6cFHwb58Slr07k3NTeEN95JEzdCm2G
 BetqQmkx698pmOat/iDR2LPy1AdsjBRC+wQ8psy9eZKflp7OZIIVDLikR/0g0nNukEyhWGMrNUb
 qZsbFP8wXiYu8re3bpZnGiIqghA1O4Ms/n8GkybqTzi/FLY0JJ8t6+P6LAjWczvmAuwaPb6lkoW
 27roKwe9aph+xBYhvqdcMubEBruyqd8qONZuiGOjvLJel1n9niMJWfFK8614VRScFNp75f1457z
 1r9oxlfLV5Me70tzmhw==
X-Authority-Analysis: v=2.4 cv=UuRu9uwB c=1 sm=1 tr=0 ts=6985fc4f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=5UAc1gh_pN7DRtg5jAwA:9
X-Proofpoint-ORIG-GUID: hW9Oqxk-dWEleZKZsS4YEoI0N3E8hEpV
X-Proofpoint-GUID: hW9Oqxk-dWEleZKZsS4YEoI0N3E8hEpV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_04,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060103
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70440-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 287BAFF136
X-Rspamd-Action: no action

This is a follow-up bugfix series for the previous series
titled "KVM: s390: gmap rewrite, the real deal"

* Fix a small long standing issue when marking as dirty guest pages that
  contain the interrupt indicator bits and summary bits.
* Fix two newly introduced race conditions that can be triggered with
  nested virtualization.

To be applied on top of kvms390/next:
commit f7ab71f178d5 ("KVM: s390: Add explicit padding to struct kvm_s390_keyop")

Claudio Imbrenda (3):
  KVM: s390: Use guest address to mark guest page dirty
  KVM: s390: vsie: Fix race in walk_guest_tables()
  KVM: s390: vsie: Fix race in acquire_gmap_shadow()

 arch/s390/kvm/gaccess.c   |  3 +++
 arch/s390/kvm/gmap.c      | 15 ++++++++++++---
 arch/s390/kvm/interrupt.c |  6 ++++--
 arch/s390/kvm/vsie.c      |  6 +++++-
 include/linux/kvm_host.h  |  2 ++
 5 files changed, 26 insertions(+), 6 deletions(-)

-- 
2.52.0


