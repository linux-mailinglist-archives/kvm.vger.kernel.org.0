Return-Path: <kvm+bounces-70752-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHbVEPxQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70752-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:38:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E61EA11C9B2
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AC064308FBD1
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C23C38A9A5;
	Tue, 10 Feb 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OXur9BOs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB3E2EC09B;
	Tue, 10 Feb 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737688; cv=none; b=q4cbs3LwESDPiRzgAemigXKTZ9UbehnAYuOdsoSPca7Ya3beo1rPZ2cGqeaZFDXmkxNFl9hvYJzSuLD2Hml/whCH4UVf/mt5QC8Hq4g8VjnAWgkTimz2RVGNhsOefAE+1NKUgVt9Uzh2yOn7sCItDq4cmTRgPzZBIqXBothiFdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737688; c=relaxed/simple;
	bh=AVR1p8niQlB+5FWX2KR1JUvvxCC0Ely48lbUOQenmfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vy0QKRK3TRfLTkuLv225fEwfbhEnpc7Ey2hNKvdyC+fDySRNPdS7ykBOxwUi44fHxzRmmN8YGDPWyv9J113SG9Npi+R7KjnXclohOTfMKgT6wu+uFSISDd6O9LAigwkfKvrmdgpxqLkBgeFtqt5MzIQS2rifrNFMvLaB8bEoo54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OXur9BOs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A8d1YF3988415;
	Tue, 10 Feb 2026 15:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=8HtDQT0rsd7sFJEyF
	B10Ek379155+S/9RDAhjjd0qKU=; b=OXur9BOsAih51pnvAZsfxwvegiY9g3HTf
	5FHtkFhEbUc7/G0UHZFmL5cF3DHLfmPTdBYyNfz7sPSlns7Nx3iMACH/YHyrjiUy
	suPFesTjpxqXCxNxJJ65XCaPE/scAgMrAgNIQavqe4LyqIIz6uu/wOaOJPaOqVjU
	naRcpA3YF0BPYmu8Wmn87Av48kbfDO/tC8DsnRGvgdFfNSt8mISYG4lL4pQmfYlI
	0X4Njx0IqGKf9TUyqKdsqU/VzLVKZe9DsOEqNOLtR+OMM8gelZDCQYl7wJULBTMK
	kyy7TQZqcCoTrYD9LYd9n8eS8YA6jLk2lEJJgJ1N5EF8E88M12J9A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w4xa0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:41 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEKBHS001412;
	Tue, 10 Feb 2026 15:34:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn1vfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYaZF16187704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12B6B20040;
	Tue, 10 Feb 2026 15:34:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D1E020043;
	Tue, 10 Feb 2026 15:34:35 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:35 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 31/36] KVM: s390: Add explicit padding to struct kvm_s390_keyop
Date: Tue, 10 Feb 2026 16:34:12 +0100
Message-ID: <20260210153417.77403-32-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b5011 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=i3t3eYffWquF8k63CIkA:9
X-Proofpoint-GUID: AbM7qTx45RRFN3r5ToTdw6oWm6etkd8q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX173FAZ3Gp9+q
 E0fPTlo93/65ZyzYvYP7BmF5CjOuOxqb0F7VcKSVDLn8WIVAPzByLXNJht6T5kes8WEpICv4p7Z
 OJyZ4SRmRKuX+k35GxvslIz+SrN3lNyo3ZYfOyPUI1VOFqs1ZHaG5jHmAF6SvLidKk3wWu8B8qY
 nJzz+29ehAWm0eNFBJWlcO+E6CfQM8VgDVP+g0Wwl3abAR/7lRv6LfU+KCURh0nViplw9jQyGll
 j5jyL2vTVGIqXfY6rgblvG6BDUkRhPqUOatSSvxtQ+M3Q8LlDPHDAPFnchCMqeN7W6K9BMkpa1e
 P27hQik6HkaYLNNsoKGhrTSvbzEhTW80INYdsjZqIzJFrXpkK/mvfOI0NMgXUxFo3h8xxbaE/Zu
 trVAtBc28szeCghRytePBXsgRq3/U0uE6dLpt4R9M/2cY4WkUlHfwBJhO8O9V5b5ufeJLlmuXfg
 hGzuTEhXTqDpnwkyZJg==
X-Proofpoint-ORIG-GUID: AbM7qTx45RRFN3r5ToTdw6oWm6etkd8q
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70752-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E61EA11C9B2
X-Rspamd-Action: no action

From: Arnd Bergmann <arnd@arndb.de>

The newly added structure causes a warning about implied padding:

./usr/include/linux/kvm.h:1247:1: error: padding struct size to alignment boundary with 6 bytes [-Werror=padded]

The padding can lead to leaking kernel data and ABI incompatibilies
when used on x86. Neither of these is a problem in this specific
patch, but it's best to avoid it and use explicit padding fields
in general.

Fixes: 0ee4ddc1647b ("KVM: s390: Storage key manipulation IOCTL")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ab3d3d96e75f..d4250ab662fe 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1227,6 +1227,7 @@ struct kvm_s390_keyop {
 	__u64 guest_addr;
 	__u8  key;
 	__u8  operation;
+	__u8  pad[6];
 };
 
 /*
-- 
2.53.0


