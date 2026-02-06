Return-Path: <kvm+bounces-70442-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YEosC2P9hWnUIwQAu9opvQ
	(envelope-from <kvm+bounces-70442-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:40:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F45FFF180
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:40:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C87A1308C895
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DDE421F15;
	Fri,  6 Feb 2026 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mnkJQirR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F0941C2EF;
	Fri,  6 Feb 2026 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770388566; cv=none; b=t5Q+vCOdogCp1jx8hGraho49dGiJ3YVwSyp/joJMg0JXSEGvfUHuXZnGSixqrtAXmh5ZecHxKv4baqvu0NUNPZ2r+ct2Fcn/EMaZue4XsS+vLdRXwY3wLfw4T7w+HRV1NA7318LeE1R2kkI4FEuQNir7PsQnzB536bAz8Vvp2xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770388566; c=relaxed/simple;
	bh=FffS2/0OnOZmx2aiSg/u8Np+riU63GonMULLXCIXrNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nb6tDUxnfCrY0bR0lQkrBgk7agpfkBs0ZC15qlZMAS0LM8m3NsHEm4v81Yi1c2JHzvm6n2V2pFAM9LbcipQtxt+xgAdSZbcy2qwkjWzPrTFE058fvwSId0N87x2ylKySsNZk6JLK/RgnsDCPNqZgkk4CFXD0iq/vQvbCH6fNw90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mnkJQirR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6167YCaB004915;
	Fri, 6 Feb 2026 14:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eitFMCAjymzAWbYDP
	pE4JBXd9oloRneQKzpjAYcKCwg=; b=mnkJQirRX+0hZQEhQSbE5OGHrb7HmdK5P
	J8R3+NwSENAnZLpMF3eWwSOVhgteDN59c4mKYNMkrbJU3tEr6j591x92jAawIz71
	L0HypTKN8beDKeEoeFxF5jfWao351xCd7Sn3g4xKEW9jIlCSMA++zY34kGPGhj7R
	rRn+zEAcJ5UjiqHcE9ykx1CMYFhCpp6Eqkv7SBhhWebBJoL+YyAEETYS0sQ0n0Uv
	Ab0YhPVkyKOq3WdPjkwmSZR17Io9SdnRbXNcsPS88vI7lTACbFpribTiaMGkaRIV
	EVfmf4mbPYgB4b23M+51TT1Ds5Phd/08Woljru/t6PtBl4pVBX2Fw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185h8ugt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:36:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616BEK13015355;
	Fri, 6 Feb 2026 14:36:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c4gsgxtf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:36:01 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616EZvfa42467668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 14:35:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FE2120043;
	Fri,  6 Feb 2026 14:35:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C98420040;
	Fri,  6 Feb 2026 14:35:56 +0000 (GMT)
Received: from p-imbrenda.t-mobile.de (unknown [9.111.61.157])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 14:35:56 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v1 2/3] KVM: s390: vsie: Fix race in walk_guest_tables()
Date: Fri,  6 Feb 2026 15:35:52 +0100
Message-ID: <20260206143553.14730-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206143553.14730-1-imbrenda@linux.ibm.com>
References: <20260206143553.14730-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=6985fc51 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=Xpc-Ysi5efBL8YaAkn8A:9
X-Proofpoint-GUID: cvMZZ6C56l5uNO_0W_grA6bNS4zbJZ68
X-Proofpoint-ORIG-GUID: cvMZZ6C56l5uNO_0W_grA6bNS4zbJZ68
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEwMyBTYWx0ZWRfX8eaA+g2L5y5e
 mhpJkcVgC2mPhZurKub/wuXPQlocACElyRN3uZabg37nEmr9s+fXvL1xZM1hI2H8scBpGzEyd6J
 2BKJfSsgIUcggmBBKfwX27LFhjlP7ahV4RMpZitmxQugxgKztY7keRBSliIth3TZoZr2msU/PRu
 2OWVRxC1Tl0QSSJukOtWgP4ilQ2qYB8rix0hJggl2RMEc5zVpJfD7jQi4YFsLZwUQtVHg9bkeBD
 FbkduN+d+psszlr6/QhMFSZquz979fwL+LMbJH9zzx7ivRTTnnJ/LhIDKT6KuPzocR6WdNnJmhI
 GMRDK67A8874bw1GB5r+4VQ0QEeyus5nq3Hu8k9/xBonwV4Xtvp/6gV/16xmqbocfULjm7fscA4
 eAwMQDMfNXEQLaWcGfQjTGEayW1CeBghcoAWDyQDe2ndjyBDf6tlctWWMoYZOyGuNLtn5vk+5Z4
 I1gGa9tdtX8luA7yuYA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_04,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060103
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70442-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 8F45FFF180
X-Rspamd-Action: no action

It is possible that walk_guest_tables() is called on a shadow gmap that
has been removed already, in which case its parent will be NULL.

In such case, return -EAGAIN and let the callers deal with it.

Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 67de47a81a87..4630b2a067ea 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1287,7 +1287,10 @@ static int walk_guest_tables(struct gmap *sg, unsigned long saddr, struct pgtwal
 	union asce asce;
 	int rc;
 
+	if (!parent)
+		return -EAGAIN;
 	kvm = parent->kvm;
+	WARN_ON(!kvm);
 	asce = sg->guest_asce;
 	entries = get_entries(w);
 
-- 
2.52.0


