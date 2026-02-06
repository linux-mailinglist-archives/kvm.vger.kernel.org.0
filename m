Return-Path: <kvm+bounces-70441-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OHTOG1v9hWnUIwQAu9opvQ
	(envelope-from <kvm+bounces-70441-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:40:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BC8FF16B
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 40090308A7F1
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901F6421A07;
	Fri,  6 Feb 2026 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UewZh3Dg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9012841B37A;
	Fri,  6 Feb 2026 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770388565; cv=none; b=knGuqxInzsxjULuXgfML2Sm/SR3RAhtUmDCdxlcrebZQmBYsCS+6ytFjMmynQ+td9dULmSjt4uE5ynCvxVd4QH7M+R7m1plwmdD8MCK/sbLsQEVDfecq9uIDgHMfz9Ipu8NInZm4WJc5RPqO6TxdwNL9EYqV2GxXlLQVdfjTzEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770388565; c=relaxed/simple;
	bh=teosBCDK6IfIkmGwdHQiKygu4qGeF4c/T6x89BA1fkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8402xfasUs/rwp0ODyu1coHeZNEd8ZsynxKdqMb3Pcf60MU4hhqV+w2XekmBKRhq6uq5Bi9rxOuyK6trLOFd2ZI3XhKR18m+KAEo3XsHtlTUqLYhDkDyPTbycliiG+g/4qlf3uNb1uRdJ7IkK4u81w1Dr/XnY5qvIbb6/oKQXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UewZh3Dg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 615MFmFa019976;
	Fri, 6 Feb 2026 14:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lNLJv3ESo/NTya75o
	TVxxKaf8QnphHTvd6B8ri0MSCY=; b=UewZh3DgRQ5AxvNInBWnJ5YTOI29qf/tk
	vttRMYLL1ENVMwrukwjE2PVdh8adAZdeYjsoL4eBiFzmBGaFOo6cgK1bVwfUa5Ip
	mFAlbmJJ6cRsG11LnrAijje+UEBrE5tBpcQSFlZlvTQPqUAr3LTRdHdMEoAL60H6
	Dd9A4ezzzKmIG8H0aSpIm8s9op8W8KFMXkF94sOkSWTuWy6Mref/ONKG59jHJ8s2
	PALhdyY5JTX5ItbsLp6LrC/z8bYdkZ6NdKIPen2OVZosHphnj6YYqwGRAzKxaVIr
	i5kR6hgksvk5O0tQa2uUsOf2+Rgtp4sqdGeHAtt3jqXpXo2p1GLuA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185h8ugr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:36:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616DrKba027357;
	Fri, 6 Feb 2026 14:36:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs1p7rn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:36:00 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616EZuYA54198716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 14:35:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2542720043;
	Fri,  6 Feb 2026 14:35:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A3B920040;
	Fri,  6 Feb 2026 14:35:55 +0000 (GMT)
Received: from p-imbrenda.t-mobile.de (unknown [9.111.61.157])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 14:35:55 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v1 1/3] KVM: s390: Use guest address to mark guest page dirty
Date: Fri,  6 Feb 2026 15:35:51 +0100
Message-ID: <20260206143553.14730-2-imbrenda@linux.ibm.com>
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
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=f4flIeLPmhlFVUFj6_kA:9
X-Proofpoint-GUID: gRdVZBM6xh4dWZiR0bERqo1e__rVI6CQ
X-Proofpoint-ORIG-GUID: gRdVZBM6xh4dWZiR0bERqo1e__rVI6CQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEwMyBTYWx0ZWRfX8gBCdu/xUQwI
 HdhYJ8h27seac4qNLAjSQfkKsT+ejmJyvWOCy8BlKDtHp8YBPR34duVfl7QNzVLFeAUnTWN42En
 KbnmRaTn74mrSwKbsQWndAieSkKXX6nzUDOC8MEpkO+nP0Ubeuflv6n58ifcVNj79ko391WaYPz
 Nwa2l1+2Jwv0lWKAEqpPtHih3rt2/D+8aKX6xCX5WpgeHxP0/YsGwrV2Gf/QJS/43wRklCAwZGK
 uLVFSCtfJGK2E/oZeQfAf5MHenX/ZtE7kyQ7ILrAE2dpa1cqvBM+SHjMBRVvcjMzphEHVtQ2mXL
 gfvporDiZ3BgtVZv1aNu1rjtBztgdp/IG4B12Pt4OzQKhtGcBAiiTMR+U9E/ol5+TicSK8a5aRp
 TyMQ5Z8ZgKZVwg9WF4WhTgepuEt3wAaeF/TCUwOb109JkzhMXelojGgCQ9zQdoUoATpk9HLnVbf
 hcvPTjfbYTSU/7vxSiA==
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
	TAGGED_FROM(0.00)[bounces-70441-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 03BC8FF16B
X-Rspamd-Action: no action

Stop using the userspace address to mark the guest page dirty.
mark_page_dirty() expects a guest frame number, but was being passed a
host virtual frame number. When slot == NULL, mark_page_dirty_in_slot()
does nothing and does not complain.

This means that in some circumstances the dirtiness of the guest page
might have been lost.

Fix by adding two fields in struct kvm_s390_adapter_int to keep the
guest addressses, and use those for mark_page_dirty().

Fixes: f65470661f36 ("KVM: s390/interrupt: do not pin adapter interrupt pages")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 6 ++++--
 include/linux/kvm_host.h  | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index f55eca9aa638..1c2bb5cd7e12 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2768,13 +2768,13 @@ static int adapter_indicators_set(struct kvm *kvm,
 	bit = get_ind_bit(adapter_int->ind_addr,
 			  adapter_int->ind_offset, adapter->swap);
 	set_bit(bit, map);
-	mark_page_dirty(kvm, adapter_int->ind_addr >> PAGE_SHIFT);
+	mark_page_dirty(kvm, adapter_int->ind_gaddr >> PAGE_SHIFT);
 	set_page_dirty_lock(ind_page);
 	map = page_address(summary_page);
 	bit = get_ind_bit(adapter_int->summary_addr,
 			  adapter_int->summary_offset, adapter->swap);
 	summary_set = test_and_set_bit(bit, map);
-	mark_page_dirty(kvm, adapter_int->summary_addr >> PAGE_SHIFT);
+	mark_page_dirty(kvm, adapter_int->summary_gaddr >> PAGE_SHIFT);
 	set_page_dirty_lock(summary_page);
 	srcu_read_unlock(&kvm->srcu, idx);
 
@@ -2870,7 +2870,9 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		if (kvm_is_error_hva(uaddr_s) || kvm_is_error_hva(uaddr_i))
 			return -EFAULT;
 		e->adapter.summary_addr = uaddr_s;
+		e->adapter.summary_gaddr = ue->u.adapter.summary_addr;
 		e->adapter.ind_addr = uaddr_i;
+		e->adapter.ind_gaddr = ue->u.adapter.ind_addr;
 		e->adapter.summary_offset = ue->u.adapter.summary_offset;
 		e->adapter.ind_offset = ue->u.adapter.ind_offset;
 		e->adapter.adapter_id = ue->u.adapter.adapter_id;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..deb36007480d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -645,7 +645,9 @@ static inline unsigned long *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
 
 struct kvm_s390_adapter_int {
 	u64 ind_addr;
+	u64 ind_gaddr;
 	u64 summary_addr;
+	u64 summary_gaddr;
 	u64 ind_offset;
 	u32 summary_offset;
 	u32 adapter_id;
-- 
2.52.0


