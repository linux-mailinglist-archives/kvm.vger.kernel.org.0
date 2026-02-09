Return-Path: <kvm+bounces-70602-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKA7GV/9iWluFQAAu9opvQ
	(envelope-from <kvm+bounces-70602-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:29:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C079111EAE
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:29:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5B7173008C2B
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 15:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0970337F751;
	Mon,  9 Feb 2026 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="si1Rz/dR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224553793C6;
	Mon,  9 Feb 2026 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770650972; cv=none; b=cYPlGBAAP88T9YvWYGB1mNchSDmZC4C+S0UPxJsSrrEVNg90qTTwoV0tys3CiRu4nZ0SSrxDP/c6R9YYRIXz9dIeACDww0C3aBroqknf29xqnS6OtqtCIMaJ8/XVZwC1kbbDPQGDY29M5YSjnWDVSXwUgGZcgiNDCr4lsrcERIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770650972; c=relaxed/simple;
	bh=8rh/5nyvKx1OUvPTe9dHQuymZme3RENu7OYXRyc6UVg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qLcH3To7EPY/qfD/SgBvw31chAa7St4IyjxrD5igPynrCCjr/2xHctL3Wr/BWS0gKV+ogGBOuREkbGdludD7iCwy92vH2W46yYMySnRjLyiXyNRDSiSc18vIXqjq+QfyhTZto1dHeY2joG3BSgmTva/Do7UIJORVr6O2QDIb1eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=si1Rz/dR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619FR9Gb169452;
	Mon, 9 Feb 2026 15:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Hx617PIOI3M1xDuib2pP8eVTssD+bpbR9hn4wNydx
	vM=; b=si1Rz/dRSoeVRd4YASnwNUUOM49XfVWjlTx/Ms8JkFz4jftba+71I/EYi
	HEW/j/WkC3/Ht7is1FBY7MK22wr2967kS1m0a14iNiBB6XW3pyWwaeVKVGKE5Aq7
	t22Qxnl9QOtvXhEdC/OQ+OUgIq5cdLQQ1CFsQJ0ajGimh1fbSMyP32yN0rVaN78d
	nuuNqneGf/O73IGPPVHVXXFYoyCq1pIk7ab8F35aEXmwuaoGLwQpXvSma3+GaDBs
	02dtqba4XLjVYD/aNC+2mgvtzv/GJDliy4XxfcLERT63MkwBKULR3zZLkOhK3eVD
	P36E6QbH8Vk1tJbkFWoNnhhSc0k9g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696vyt5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 15:29:31 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 619E2v27012626;
	Mon, 9 Feb 2026 15:29:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7k5k76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 15:29:29 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 619FTPLO40763712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Feb 2026 15:29:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE48D2004F;
	Mon,  9 Feb 2026 15:29:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B0DA2004E;
	Mon,  9 Feb 2026 15:29:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Feb 2026 15:29:25 +0000 (GMT)
From: Steffen Eiden <seiden@linux.ibm.com>
To: linux-s390@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andreas Grapentin <gra@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [PATCH v1 1/1] KVM: s390: Increase permitted SE header size to 1 MiB
Date: Mon,  9 Feb 2026 16:29:25 +0100
Message-ID: <20260209152925.578872-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=6989fd5b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=nzWhWrZSqZcqTgXQ2MUA:9
 a=ZXulRonScM0A:10
X-Proofpoint-GUID: U0uLEOU4ljsiM3tpfPotPj2JwLK3BClG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDEyOCBTYWx0ZWRfXw8dE5JOjUjo8
 6q41KlIjSr2og0MxWOWZh8tGZWb/SlR0tocg2lTIJIA0lk+0xLglcXZJ5wqyoc7vhrDSvqR3yfO
 uNHMh2I+TPPSqmgTUzNnKVCVkPMj3DnVmwOevwmYHZ1U5S9ByB0qyhzbfNWuge80QtUQoY4ecp7
 MNfTsY1fd+wrFZxGJB30zQ1qo5yKnlEufiNQDm4IciJ9rJI8ShA5xDW6kB4azrHJtUsyUVjf7j/
 a1UVNB3Za/V2HxphDW4qZHX3wTuaJuz+7d5QkAvGH32mHjmEtI6lzJjEvOZe24To/ILQvqxd6DU
 VBVDpPo4ZNm1mPMGGOy31K44BXS63RbjKwZq4cOkORIh588Vg2dNePdIZwLJ6SLoWgKXpwZ7G33
 zzJg28jrVUoVUK1plB61URemR69u8QT5w63QSl3bALpZ2ENpvrvbbPDSrg/y4/D3//929jIvjjO
 P6l7uXsEKwm79x/Xt9A==
X-Proofpoint-ORIG-GUID: U0uLEOU4ljsiM3tpfPotPj2JwLK3BClG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602090128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70602-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.ibm.com:mid];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seiden@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 0C079111EAE
X-Rspamd-Action: no action

Relax the maximum allowed Secure Execution (SE) header size from
8 KiB to 1 MiB. This allows individual secure guest images to run on a
wider range of physical machines.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 56a50524b3ee..3428a8d427b2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2744,9 +2744,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (copy_from_user(&parms, argp, sizeof(parms)))
 			break;
 
-		/* Currently restricted to 8KB */
+		/* Currently restricted to 1MiB */
 		r = -EINVAL;
-		if (parms.length > PAGE_SIZE * 2)
+		if (parms.length > SZ_1M)
 			break;
 
 		r = -ENOMEM;
-- 
2.51.0


