Return-Path: <kvm+bounces-72526-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cEFjGJ3qpmnjZgAAu9opvQ
	(envelope-from <kvm+bounces-72526-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:05:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6DC41F105A
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 77F15321B978
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 13:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7A436074A;
	Tue,  3 Mar 2026 13:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qGFNIW3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0BE35773F;
	Tue,  3 Mar 2026 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772546050; cv=none; b=hQeAKP5w90mnV5ltK2l1GZwB2jOWOkvgLW3YT0WQSkduIeMycwrQBQc286BJLSBqkKX/IpsM0zl1+rGp4IVbneMb7QI6dc55Anx9t6idD3ykwsGu+jg+D3LSHPgDIoix5M3qE+W91exrxxQ+Q8SbNtO6w1SvIZBr9wmxIGjbhzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772546050; c=relaxed/simple;
	bh=W3Z5heyTlUTJJYt0yzYC2uotK3sfAELcH31/p+K/ZIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du14ddo5dbr29t03q0r8PN8lXAgzNsr/VE3fhoXDrp4X9i3IkgsdgIt7UTFgRgIllhIVqdhAEGqQ/3fK4LMn9SrRoDOSLmL1Rp68m6iYTJqlCbaJy5IZUrL9EBHLma3ri/TSc0BGZwBKp2ciyYQdhZJd4gbN6ekZFMeTQzpjebo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qGFNIW3Y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6237YdNu2139963;
	Tue, 3 Mar 2026 13:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xD7RVCTOIaZ4KkqZs
	X81F5F4s3SlydJ+5TfZG2HgbT8=; b=qGFNIW3Yw6lk9JFYTZMvBImalY4U+Lgfu
	NZAt7a8EAIQdC7dYopRh6PJXnISd40IQlpddi8lnYytd3yn1agb5DGHj91mww+rl
	E0/zwemmhODhkpwltNXGvv42Ysk0rmjGaWCcN8Uebu+6QujlL0n4iov425Uvx/dL
	DUQs3eh9UsfyV3fG7ONWd5XFY1dbMEbmkmw5cbrqh6cbjcaliSpKPByJjUSnh+E5
	iDA1wsff7duhqj+eDNvTgFFD4wOLsjogMPp9XSci7ll6RcSvxOABx1KVBbbHRjOF
	djyq0iUNtoIscrnuWMAxbW13hMI9cqYkbEoV+I3O+un4weImwF/tw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckssmjy1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 13:54:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 623Dhsgd029080;
	Tue, 3 Mar 2026 13:54:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmaps2p6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 13:54:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 623Ds3M826870130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 13:54:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70ADB20043;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51B1F2004D;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
Received: from b46lp25.lnxne.boe (unknown [9.87.84.240])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Mar 2026 13:54:03 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, mjrosato@linux.ibm.com, freimuth@linux.ibm.com,
        imbrenda@linux.ibm.com, borntraeger@linux.ibm.com
Subject: [PATCH v2 1/2] KVM: s390: Limit adapter indicator access to mapped page
Date: Tue,  3 Mar 2026 13:46:34 +0000
Message-ID: <20260303135250.3665-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303135250.3665-1-frankja@linux.ibm.com>
References: <20260303135250.3665-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEwOCBTYWx0ZWRfX99F2jtK/vM79
 f+Maqh/fe2KvpxJ75/DMXUXNjfRa5TmXtwFzxHg2UBzeOOjoKk/nx97Y3Bl2bcnxJ8yEaD/fgnh
 lrKJvPjaaTM1Ukb7/vFQRKZ6gnCNaBh7O3oP+/IHmmeMP1bClmIF7TBMki3MDpb8DnZ8XvUGyJI
 NbnqyNeo7bH0ua96S805rsvQN7cavYqPy7/2emAr3qenHs39HFHNuVUIYMlYooFgzh3yrWIIZek
 ItoIBRgxEMvbR32n7vWQxJYX+TGpvoUvWgp09KeoxzXS9ACUMjM1pqTp0Fa+1+iRCNt93MkxlgR
 RLWK0xXquo+N/eHL5rVo4pcZSn4QsDXT/HhcjTlGZRwvFBYcxAy9hg1dDPl2I6VGIY+gdRypiWY
 Dz8kQi4u0oWjBxUEZyQenT4zRB2RG/zMNNNFpHZ9FA1DelZHdjF1jX8wS2Vzq70YZ2pGJr7ilqe
 OzBwISH8k34TNhTRDjQ==
X-Proofpoint-ORIG-GUID: ojGW4Wm1-OOlqZxZjaWYJgf2StcoTR3f
X-Proofpoint-GUID: ojGW4Wm1-OOlqZxZjaWYJgf2StcoTR3f
X-Authority-Analysis: v=2.4 cv=AobjHe9P c=1 sm=1 tr=0 ts=69a6e7ff cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=jGWXv5dM_gJt9w-Nn-UA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030108
X-Rspamd-Queue-Id: B6DC41F105A
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
	TAGGED_FROM(0.00)[bounces-72526-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

While we check the address for errors, we don't seem to check the bit
offsets and since they are 32 and 64 bits a lot of memory can be
reached indirectly via those offsets.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 18932a65ca68..1a702e8ef574 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2724,6 +2724,9 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 
 	bit = bit_nr + (addr % PAGE_SIZE) * 8;
 
+	/* kvm_set_routing_entry() should never allow this to happen */
+	WARN_ON_ONCE(bit > (PAGE_SIZE * BITS_PER_BYTE - 1));
+
 	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
 }
 
@@ -2852,6 +2855,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
+	const struct kvm_irq_routing_s390_adapter *adapter;
 	u64 uaddr_s, uaddr_i;
 	int idx;
 
@@ -2862,6 +2866,14 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			return -EINVAL;
 		e->set = set_adapter_int;
 
+		adapter = &ue->u.adapter;
+		if (adapter->summary_addr + (adapter->summary_offset / 8) >=
+		    (adapter->summary_addr & PAGE_MASK) + PAGE_SIZE)
+			return -EINVAL;
+		if (adapter->ind_addr + (adapter->ind_offset / 8) >=
+		    (adapter->ind_addr & PAGE_MASK) + PAGE_SIZE)
+			return -EINVAL;
+
 		idx = srcu_read_lock(&kvm->srcu);
 		uaddr_s = gpa_to_hva(kvm, ue->u.adapter.summary_addr);
 		uaddr_i = gpa_to_hva(kvm, ue->u.adapter.ind_addr);
-- 
2.51.0


