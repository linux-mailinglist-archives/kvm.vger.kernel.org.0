Return-Path: <kvm+bounces-71843-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMBsLkUTn2nWYwQAu9opvQ
	(envelope-from <kvm+bounces-71843-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 16:20:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 36AC219978C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 16:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ED00830158B4
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337B33D3D0C;
	Wed, 25 Feb 2026 15:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nGcpJM/L"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695833B530F;
	Wed, 25 Feb 2026 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772032824; cv=none; b=jKJLTHIR3cYcRB9Y4ph+w+rC8e50WWSIEUkK1//C7bN2SopKoIxi3qlB350qhZ8sgrZYGSPirC27H0heySpkLUa4dCDp3gCD6qkjpvoTN1DgZw1KZJDr6bsCtgqbFvuSUfiJVwnjO6tXeymzjg3/4wqlLnsgCTF6PR6Z+dCiXpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772032824; c=relaxed/simple;
	bh=mbPRfIADMFXCOwBrGT1FtQ/RpCEJwc12gWVyMWtoke4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kdRYwW5L2X7xmZsOrhmWJoVKTuk+qIjYBkzjfjK5zWRQJao7zM4L5dNSmBF81383i1kB/4Fija7E+vGV0jampOAr4+JoX7s+DnoY6oJNx3BntRGJ+4jrswmtO3rsLcGK/Py/rMoQ5OY2DVpafDPP1n0rtF3/6Jb+mK7BLrlZFrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nGcpJM/L; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P3udXn961544;
	Wed, 25 Feb 2026 15:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ho/xAKzQ0HYa8cXr4tSN04W5Wri1Z34DLWAm5ZoLT
	E4=; b=nGcpJM/LCczDSMhrSBKYhOvoACCAgqh5QcLdhLqPlz6tOSaAnsi7Q8IDg
	rmqmQ+5JrCcX601YpGrjhj4VLo4po7Go0WMktRlOU1dbnKtrgYM04lipZ2MF1YA3
	IAUnN6XJFqDWYG4yBwdGXboQw3OZpZtyjCU+55L7CMDhgk7tqSl6xh6L5oTcfUIE
	/K0GpHlWr4cgDJbpUUep4JV5vghcDGgzJF5F7r62ep0yyHrZ/YU//yDUu4rATIhR
	j9Zw+zjXVKr9c1ZZRGZ+WjEIEjGHlf8Pf/eyJhtJDEn8X0wnRx7LZQyNYHbc6e1F
	N3Z2xCBwJmgYfvWmodVuQ2VJ6u/CA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4cr0t71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 15:20:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE2p0C003821;
	Wed, 25 Feb 2026 15:20:19 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfs8jwm96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 15:20:19 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61PFKFUx48300358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:20:15 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62CC52004E;
	Wed, 25 Feb 2026 15:20:15 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F22220043;
	Wed, 25 Feb 2026 15:20:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 25 Feb 2026 15:20:15 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id 2560FE0BAA; Wed, 25 Feb 2026 16:20:15 +0100 (CET)
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] KVM: s390: only deliver service interrupt with payload
Date: Wed, 25 Feb 2026 16:20:13 +0100
Message-ID: <20260225152013.1108842-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5pwhpV_ai7FAPzeEl26voGvZOcrAc7nd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0NSBTYWx0ZWRfX3ZhyemhbZivB
 c/HJoExwPLm2tqUCGvFeLUnGjo4iwHWUORhs4LBfqlTv34OANafhyUJjNfqbsUau3KIwDkSHLcq
 fHbgYxNl3/Jp/t3MJcfI6C/FN7WBNVOzsQE9U9Yo3Qymc+f8dobsDTEhK+l8SH2J5gFjWeK4gP5
 cUxuS8QhB+fHxks0uHRlnJc7/yd6bKhLCyIld4Y1Kh3EHl59ticeWRSrjAaLypel0wZ3E/OLg+w
 Y6Q0n9K8ENlZwEhumU3Mg59QtODPpzijLdWwTNzVhWs/kD2t+lMhCsFjeXYgqRjOZGsLJEj3NMn
 OzhSx4RbceqTiRalZCzRMvKTefNWOmquQZqzUVynELDeHgwL7buvvSAjpSr2ONXXA1UKNw8615i
 9GWUW7Ju7pw1qXDoibwP+QQDqIjeKR62gsLBmKC2rQ6qmuQxJ2Hsdr0j94QRmLSkm2K8+zAYaWm
 rhdBMBxDa1m4W3pb9ZA==
X-Proofpoint-GUID: 5pwhpV_ai7FAPzeEl26voGvZOcrAc7nd
X-Authority-Analysis: v=2.4 cv=bbBmkePB c=1 sm=1 tr=0 ts=699f1334 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=25EaFSAiIRNNOV5pwi0A:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602250145
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
	FROM_NEQ_ENVFROM(0.00)[farman@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71843-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid]
X-Rspamd-Queue-Id: 36AC219978C
X-Rspamd-Action: no action

Routine __inject_service() may set both the SERVICE and SERVICE_EV
pending bits, and in the case of a pure service event the corresponding
trip through __deliver_service_ev() will clear the SERVICE_EV bit only.
This necessitates an additional trip through __deliver_service() for
the other pending interrupt bit, however it is possible that the
external interrupt parameters are zero and there is nothing to be
delivered to the guest.

To avoid sending empty data to the guest, let's only write out the SCLP
data when there is something for the guest to do, otherwise bail out.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 18932a65ca68..dd0413387a9e 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -956,6 +956,9 @@ static int __must_check __deliver_service(struct kvm_=
vcpu *vcpu)
 		set_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
 	spin_unlock(&fi->lock);
=20
+	if (!ext.ext_params)
+		return 0;
+
 	VCPU_EVENT(vcpu, 4, "deliver: sclp parameter 0x%x",
 		   ext.ext_params);
 	vcpu->stat.deliver_service_signal++;
--=20
2.51.0


