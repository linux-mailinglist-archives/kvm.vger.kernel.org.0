Return-Path: <kvm+bounces-70729-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BAUFxBQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70729-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:34:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 117E111C802
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4B494303E4A9
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E6C366DDE;
	Tue, 10 Feb 2026 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bWk/Fp11"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4DC26D4EF;
	Tue, 10 Feb 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737668; cv=none; b=QLyyZ0ZSnGU6TodWrS2SsxAWvAW65TAKCcj9YOXs5NjdhrRVKYffkG9JIL7cnLdNXpFXtb8vmXd6RrzHQMYjmxzxPj/vpR72wL3eZcGZOWg9QGVg4ivcOKW0InIwfk45pdNsr6lu709d+9rtGbLSrnKUUUlx/9N5EIKAgGuAbbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737668; c=relaxed/simple;
	bh=TW63rkIvZo93fmurahalUAT6VwHPB7SVvljouEMu0ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcHGbpMZSSYshHapoX0+UuAo4IqQ5/DPabMvPvdXaOi331EA9rIyCabiWDEkk2OBHI6rQD4UcITi8IxklLiH9Q1PypVTvl+bEFdaWuwLnvUijq1I1ctOr1/wki8ntiXHEri5zJgcF1C16Oa3M7qaDFGRhfKwbJjs10t/Q7ogGRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bWk/Fp11; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AA4QlA400635;
	Tue, 10 Feb 2026 15:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BDXQx9MqHm1hlC/hg
	seLmp7A5zwPepixROIUV0Nu57Q=; b=bWk/Fp11k/EnPvLxX3JJXfEfEHL1Ni115
	fmEoRNREaEVdWoByMl00Uzw3sXaQQBDIEdClTvSpRqjjc+FdULb2gITIAOYtTRcm
	uQBUCbmHhS4754uimzQ9GufXk5iZgfbzScW81HhYSwBgMOC18QnRjQXOB/ZkiBfw
	US5dffIX6Kw+6uuvB8opnZ0XWB/Rh/gjhM4rJ+vP0GkOr2tStyOkiCJz41tz6UCo
	ZfUfnHgfFUblYkfTMpWXnBFuqExxBk2F9tRDmeenh/hHy7L0ohv70ZirYdBDDQXY
	h4rpRtNy4vwjgMwm9lh/qsdGAsklLudQ2j9Tl/IsjL7SAniMcfKSQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w4x8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:23 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ADagOk002570;
	Tue, 10 Feb 2026 15:34:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6fqsj1uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYID619333450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 861B920043;
	Tue, 10 Feb 2026 15:34:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13F6A2004B;
	Tue, 10 Feb 2026 15:34:18 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:17 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 01/36] KVM: s390: vsie: retry SIE when unable to get vsie_page
Date: Tue, 10 Feb 2026 16:33:42 +0100
Message-ID: <20260210153417.77403-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b4fff cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=HSVDk6IH-gmX55RuthsA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-GUID: Lede7aAGBtIConZGdQ7FKr4BmP2iL0Vk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXy/ne1XoGOXkt
 VGhij8LzBaz+nM0w5jObbZiMiuO3BEWxx8LBt6y5uAIcUbv6ln3pId1gZ5x2XjiYFzymRLT2Odg
 4AKOdDad7VOJf0GTaHvqCgeiuxOCEkNBeRp7QQ3qcvxF8KRm2bEu1vhTQ3FGSVDs5nIWv6VDo8b
 KBn8jC+tOw92UJOolXoNCweLFOD9ahnPeBkNZsNAs7CV9zZc+q2L/Y1C0EiSP1ZxCbJslh7lXMV
 UGzhojKVT3IAU5WX0nAQ5k0DsNOh20KYjFwJDDeQvpQDyvS/O9knWLV4wThic8AGC4j3PVdIoxq
 bnFOTvwlYA3gazjzIiQXXjcyGvSRnHD9wIW5CRAgFQlZRcyDgx4zTK3SGpGiVBx3NBNFUYtU1c4
 7EgWdXSu4cISSFJgSlWlzMPDrRjjD1R2Z3GH7jppWkmMHGZKFHjOY+TYnSx3am3HyTx+Ojorpk8
 U1G7AuYIyRWg3Mb8JWQ==
X-Proofpoint-ORIG-GUID: Lede7aAGBtIConZGdQ7FKr4BmP2iL0Vk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70729-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 117E111C802
X-Rspamd-Action: no action

From: Eric Farman <farman@linux.ibm.com>

SIE may exit because of pending host work, such as handling an interrupt,
in which case VSIE rewinds the guest PSW such that it is transparently
resumed (see Fixes tag). Unlike those other places that return rc=0, this
return leaves the guest PSW in place, requiring the guest to handle a
spurious intercept. This showed up when testing heavy I/O workloads,
when multiple vcpus attempted to dispatch the same SIE block and incurred
failures inserting them into the radix tree.

Fixes: 33a729a1770b ("KVM: s390: vsie: retry SIE instruction on host intercepts")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
[frankja@linux.ibm.com: Replaced commit message as agreed on the list]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b526621d2a1b..b8064c6a4b57 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1498,11 +1498,13 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 	}
 
 	vsie_page = get_vsie_page(vcpu->kvm, scb_addr);
-	if (IS_ERR(vsie_page))
+	if (IS_ERR(vsie_page)) {
 		return PTR_ERR(vsie_page);
-	else if (!vsie_page)
+	} else if (!vsie_page) {
 		/* double use of sie control block - simply do nothing */
+		kvm_s390_rewind_psw(vcpu, 4);
 		return 0;
+	}
 
 	rc = pin_scb(vcpu, vsie_page, scb_addr);
 	if (rc)
-- 
2.53.0


