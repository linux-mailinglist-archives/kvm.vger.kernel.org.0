Return-Path: <kvm+bounces-70751-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UN5KJ/VQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70751-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:38:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3665511C9AB
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2AA8E308DEBE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FB43859E5;
	Tue, 10 Feb 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RPTu5mMZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199B2EDD40;
	Tue, 10 Feb 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737688; cv=none; b=NNRGr44UAnhE8jN8IyKJ+W892GqT/D3BtVgxJYAZxwP5J6rgl9y1p0r0FCvpJJ1LZnhwMwHNM8dF0THEO5+hlZIpvfe1N7BqC2utHDKDNHsjZ4AYnzW1fnwYez+FnxrhbAFetxqzFqublWhMcZPJBBd0qn4CE66fpeiE18ZWCm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737688; c=relaxed/simple;
	bh=NhGap8IbgZBOYyi+b9vWT9MzEavU19LMKOpvAEoAJQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXpZQSWBNAZqUB6m0ycN1OlWtPjfkIV1+BI6StOP6iUxsCV1j3BFgdEzC6Wv+J26eu21ebfF0lo/+9OVSKWe+YgAVf12ikQ3+spMy9HuZQRm7PIzVb8xSe6C35ynpBEn7L8mKjyMrQGi9LIzqjoPeeDtl+0P3GKxEELtyrc6aCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RPTu5mMZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A96RsJ266057;
	Tue, 10 Feb 2026 15:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=v8AOeL1TFCbobgKqt
	eK/4icGLgzOUGNU6SRmJ40/mtg=; b=RPTu5mMZiRZeCtKAPBwt/ItpuwG6CsN6X
	RtLOVaIPCwP0SxXgA868seJHxlFhr0xFB2N6R2fW/LEUbqrJxEs/GYdUYOlT32O0
	xlb5Z8bBmd5GQrPmirf9DWCdB5D9+oc/M0R/KQNq5M4C9MCKjLvLnv7b/FdsaTpK
	gCDA0nQBfMOljGWNXG73Lbk/v1HR1Ol84RLoWOnbeViuuKodVxGeOL2QYcs2glmR
	g/g8MPYeBrHWFYwjkVw6WbMfbyV2BXYKEaQ/0OPdti0Zqrqebe+oqTw3mVueVk9Z
	LBVGKg7SGbxdGDmwTWTONjwAw7TpdpLZYDiQOGT6KPr8D3bWV/Y5A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v2qm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AE3Ckp002557;
	Tue, 10 Feb 2026 15:34:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6fqsj1vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYa8L16187706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F13320040;
	Tue, 10 Feb 2026 15:34:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E48020043;
	Tue, 10 Feb 2026 15:34:36 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:36 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 32/36] KVM: s390: Use guest address to mark guest page dirty
Date: Tue, 10 Feb 2026 16:34:13 +0100
Message-ID: <20260210153417.77403-33-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: vpYvSy9oisZAUfVphnifOkikMYEJrbzc
X-Proofpoint-ORIG-GUID: vpYvSy9oisZAUfVphnifOkikMYEJrbzc
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698b5011 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=any6fehDw3tcYZvPCS0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXwuUvTzxziAyD
 mXotV6ydu8MAYLB+F+yl6qkMBKrbLm2xOYNGX5TfpY+BGHZaYHvT1H4Bhaj9NoozRaYcGRTqj+n
 jRT6V0RXdnQUw5/5gXD1CC2NfjAy/6xWLGfSS9tsbfxHjqrkz8xf1LfgEGRTCWVTgh9WqfsevBQ
 GE50g0O/eqy6vX3X5lZFq5CecuRQowG/lcOGIVQffrw2c3n6iEGMaEAs1yZ8NKRvmdnXbuaXUY6
 F20P2H7B23FegSaBCN3k2bAKV6RB/CojbcpOonf5oSd/I7k5ZjeNuhJvnyIFdJ8dI34I2Oi4/BA
 dGYcZfF96yVXSZ3fTRbyqFAXiRQk0DBdr3stylqywJDM2BPfcNgQcqRFeV7n+hLEmQZE43VCx63
 taNvaVJ0Uwk2GnvVQnV/NzJqi3uGJxUOeHh+gNIjj4TAPDJjNMNENP1pyR7eY3FDkdjoiUJOYHy
 4CavSOnuemn5aSHfT0g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
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
	TAGGED_FROM(0.00)[bounces-70751-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 3665511C9AB
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
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
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
2.53.0


