Return-Path: <kvm+bounces-70851-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNxnMKqZjGkhrgAAu9opvQ
	(envelope-from <kvm+bounces-70851-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:00:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA72A1255F5
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:00:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 013CB3040F84
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1319C2877E5;
	Wed, 11 Feb 2026 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OPISN+k+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196B721B191;
	Wed, 11 Feb 2026 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822013; cv=none; b=M34j5QclqnauSTYyX+3UGFF7DnuGk3OvEG3DSBiBfufTJCH+wTMuDdlYXfTZSPYcApIaMiGHPvIWjHgG7I5RAc1Wa7W6zhuiF40mnL9UweuujrUPGeFmF4VFGbAaosP6vZ8iOG6nVeyNyzdqeHfONDIDc334YzYybZFSnG2CdHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822013; c=relaxed/simple;
	bh=5yqyUJ54Yi7dyZmv92DJxAVcrMP379V4125a2x3pgas=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=iQw8iN7x3uHrpFlg0ACLhB8q4OHfg7Z492D9tiltZQqxFCIwssqLpfnWMFjLi35xpFrrWR7GvcifzmydtxXAMZirFszmGWHNYbrrKu6zG3hCwNsb0WXwC5J9Sm+1+WW9NdTItGt70w/X6FJ5DkjzQI9vX0bQH+7LtDUImN9GA64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OPISN+k+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AM0IrP239438;
	Wed, 11 Feb 2026 15:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=TUuNKFsSy9H+KzNGodO8keB9HNik
	S3lkO6Ytoze51as=; b=OPISN+k+UsfXqknyTzBeTeLAezudM8bQUe0BOd4zb44y
	/SWcdtY5kLXiPuAnUkh05UCBSaCGEXPrFZbGs8MYLujo2ea//+npJXrd5cRmdzBP
	J/+n5d5wme7h9hg51Dowk0dql+lCU1C9hzODvjUiX6Th87pMxsBGW8ecHzlU1Dz5
	zv5PD5nd3hiF7jYN9QiAdkrhvFr0nREOBlI7wXeWWtQW/rzRE+p544TEauynsli5
	v99wGzk6r9pDG3r5tll/yx4Y4ankTU+lNdMQhBaSuskUqAmDsrFTSYTVT8VsCxJY
	/PTshlKSgQucNy3Lpqzdmu+yAZiMNWoQlpCwLBFZ6w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uy6he-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BAu4Vo001833;
	Wed, 11 Feb 2026 15:00:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je25x9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BF04NC48628128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 15:00:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B31CB2004B;
	Wed, 11 Feb 2026 15:00:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53FEC20040;
	Wed, 11 Feb 2026 15:00:04 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.49.16])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 15:00:04 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [kvm-unit-tests PATCH 0/3] s390x: Add test for STFLE interpretive
 execution (format-2)
Date: Wed, 11 Feb 2026 15:57:04 +0100
Message-Id: <20260211-vsie-stfle-fac-v1-0-46c7aec5912b@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MwQqDMBAFf0X23IUYg5b+SulB9EUX21iyMQjiv
 xu8DMxh5iBFFCi9qoMisqisoUj9qGiY+zCBZSxO1tjWFHBWAWvyX7DvB3amgXNtNz5hqUT/CC/
 7PXzTkn+8BUmcoEnpc54Xz0DX2XAAAAA=
X-Change-ID: 20260202-vsie-stfle-fac-403e4467d8e2
To: linux-s390@vger.kernel.org
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1421;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=5yqyUJ54Yi7dyZmv92DJxAVcrMP379V4125a2x3pgas=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJk9M4sZC6p2Tm4Xzgk5ZxDuyDnnvXVli0X2+vCp80rL/
 TRZXi3qKGVhEONikBVTZKkWt86r6mtdOueg5TWYOaxMIEMYuDgFYCJTbjEyrK5ct3XqlVBJoylq
 G3YKv12guafSme/djZ1rZqROY7/HfI3hn8WUK2IJ6Sdu95iGKonx7ldtt4xVl+Tylrzr9cPiNFs
 HAwA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDExNCBTYWx0ZWRfX41F2fr5ygund
 EeEALoPYDGkvWKxnuYaK7Q5TKq227Mee8QD6KJDomaeYGmV2WXVlecFLvzBlKuUF35l5mxf02a4
 olWD2V2ndPoDqFJqW1ppF9zAyoDwjthYpOCj3XhIXo68EE5g1X+YJEzOHZ4NMYYeyttsgETBVRW
 Hc1N+O1bfwcSaPZQqcIm8XBhz7sXT9ZSOtbnr9o0v+ej1xE/bAfJd+qD7Z7dRvL8lDxsLj2PIk5
 PGsircrI7Z76HigX+6yDxr7fsR58t0IxQMdwX2wdcuvdkU82mjlJIi6aOBwiuFypuuMj+HK+oxb
 DiZDJLR1Ho1ADLgRhHRYEQGdUKUOPJ/jlJb0608xtinhZZgyuW/ZwNEn5t3xN/f4tpl7tlK1SHu
 qU6ejl6LdBal8cMS/yTNj8JIZaz2KUhqn2sB7LRMTZaIsJOrIiq92xpjJdCKUJM03K+IZVVCqDc
 q9eODhN8TnNoxRpgBIg==
X-Proofpoint-ORIG-GUID: pSnwY72oMrcpSMKDFA-JNjfRshRTPPxU
X-Proofpoint-GUID: pSnwY72oMrcpSMKDFA-JNjfRshRTPPxU
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698c9979 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=1pEIAPF2W-qNjrGd5QYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1011 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110114
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70851-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: EA72A1255F5
X-Rspamd-Action: no action

Test the shadowing of format-2 facility list when running in VSIE.

The tests will skip the format 2 tests
* if running with unpatched kernels or qemu in G1 or G2
* if running on machines prior IBM z16 GA1 (where ASTFLEIE2 is not
  available)

Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: "Nico Böhr" <nrb@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: linux-s390@vger.kernel.org
Cc: kvm@vger.kernel.org

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
The original series was started by Nina and finished by me.

---
Nina Schoetterl-Glausch (3):
      s390x: snippets: Add reset_guest() to lib
      s390x: sclp: Add detection of alternate STFLE facilities
      s390x: Add test for STFLE interpretive execution (format-2)

 lib/s390x/sclp.c    |  2 ++
 lib/s390x/sclp.h    |  6 +++-
 lib/s390x/sie.c     | 11 +++++++
 lib/s390x/sie.h     |  1 +
 lib/s390x/snippet.h |  6 ++++
 s390x/spec_ex-sie.c | 10 ++----
 s390x/stfle-sie.c   | 91 ++++++++++++++++++++++++++++++++++++++++++++++-------
 7 files changed, 107 insertions(+), 20 deletions(-)
---
base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
change-id: 20260202-vsie-stfle-fac-403e4467d8e2

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


