Return-Path: <kvm+bounces-71107-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCVRF6zSkWm+nAEAu9opvQ
	(envelope-from <kvm+bounces-71107-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:05:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0D513ECBF
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62C33300E391
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 14:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E232C0F90;
	Sun, 15 Feb 2026 14:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="c+oH1kN8"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A463BB57
	for <kvm@vger.kernel.org>; Sun, 15 Feb 2026 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771164324; cv=none; b=OW4ln187a6imKucy7L6GBWo/mDCRDb9A5nV7FhqGjyzBH8l3wp+L8KrnIys4DXT3W9bnNQuHujDnfCv+EKTFsB69yuTkSU1LizjTpOoibO1z4vT3CYZQHO1to36j5opf2IMlGPlqfLKrXtQeedonp1I5GToFzz858q0vQ8mZwGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771164324; c=relaxed/simple;
	bh=hLVvsKeUjZnDb76HkhGVoxi80fmId3IbV4m7ZHWk26U=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=qvTnW0ExbldzkLtVTMc571qw+6yAMY/myYpn2KZ9GUyHplTn11l1RENHbCrAlF7LagQ8Cv8m5iJjdIfKTy0eQClG8ehic+L5R79h/VK6A+Y4OJiElBHlFqPCNBKfBeuMn3HfYlazHBZs3+yclOWGyYsuw+mpO2Uq9pVrvV3dIHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=c+oH1kN8; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1771164318; bh=Ffshtsjrk+BtxIoHPYvs2B6eiQy8uzdCk/yeV4L2RJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+oH1kN8BrNhCISNjLvMXCLVJ7nO4LntNz4/l9XBusQisRHSKJSbm6SoFdCtB6biX
	 v71UO6ilDegpprDfKdD/272llGd6Tr8ozylY5VJ4h6YT49MptDWsbrmSWP8VX9qs07
	 q479TlVzWQYldqD1/YNm5solKyRzvpUO7VdCi5DQ=
Received: from pve.sebastian ([118.250.2.92])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 10481CF7; Sun, 15 Feb 2026 22:04:04 +0800
X-QQ-mid: xmsmtpt1771164249tbfmnxbb3
Message-ID: <tencent_EAB2053E04BF4C7F996CEC61331C23154007@qq.com>
X-QQ-XMAILINFO: OK7NBzdNss/Rx1PACFRVKIp0y/xdEey6QAqj7mPA9iUsNgMyy6dUEoUyyAmjjQ
	 oTNVzstiDLdI4Ccmud1AkeskPf3REGK55k0uDu4TlJXp9N909GLOi0ofQx/Yxkm2x0IZzfdOXuEy
	 Sg9ynlnhVq1wZm+Bm8DW2JF9SEbATkYAKN9myGCFfP5kxEJ3iWWZFJtStfQ6EeWEok8Aaz5QfUfT
	 6w2FsvWzK2Z1rQMnh4tCXCgHRS+OFVwMK1ygAvXxpg/R3shLxwZzA9KUu5z7bO6ZRmBbMwTWhG2z
	 iPdEHpgSS8FnDU/9Ys+v0ZGI07SDhe7QdgPmU5Gq11Avxz+snVXBneIo1K3YIOsg4IvGQQQFXeYI
	 RlcPL7psEroFty/iplL5ikUv67JJqD+pCxpDdrQq0cBMRVXk6HHkTbr8gi0lw6e6sNnDYWkhk4xJ
	 LRusjReYjAHR4pUwQRQbIoe87WBsAsAD8GkFW4MNJYqZtCxP2M4TRwKNG5f4PvmpzNzXe2FhnFJa
	 9fJBQq4jx4iszKhWmkiynnM0g20jVdchLAYQfglzf/29uznfzjYShuh4O90EsHM2w5sgY0UHD3ON
	 xRZ/JnPkljTwSJ3YB/T91l0vA66AtKt7ArxKouxYS7XIX+yeUvndBe9QJ+QNedTbwL2RYLkRNQBD
	 xwsxMMElHohd+TZpM3v3URog86mN4f5yZpJA2T/yqpBSyAnjeMnG74rn0sUMQJsRckcc9b8Y7OKU
	 VZEHhIO3014O9ST4ictk/5hQyQgFGtj4j7bRHKbRJVL5UmqUkoD1LyMMUQHYqScL0//RH5XQEyfi
	 pQAaD+FMitNwx/pZmaH9kn8zBt1qtuug5glZk9te1ZseA8IsRm9d5viwEApa6rA99XsLhu3sqKGy
	 M3XEQMZcm2R2wYGxHstTHPbOsrXFYCAjzfhVQhxCSRG8xFnvhFgPzTQNr5tWN1WrZxasxQmpHV0F
	 MRYj5C3Ful9PVnEOBZ/A+mtuYTb8BJ0ovhWOS4M+fyVWQVpFIDenF0UVSTM5fgoQawnTx15eMXPO
	 XBjZnS8Z6THxPLr1sjg8ou34FaOlebrugbSYoBbOa3ciCMQDxm
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: 76824143@qq.com
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	zhanghao <zhanghao1@kylinos.cn>
Subject: [PATCH 3/3] KVM: x86: Use dynamic try count based on vCPU count
Date: Sun, 15 Feb 2026 22:04:02 +0800
X-OQ-MSGID: <20260215140402.24659-4-76824143@qq.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260215140402.24659-1-76824143@qq.com>
References: <20260215140402.24659-1-76824143@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qq.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[qq.com:s=s201512];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71107-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[qq.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[76824143@qq.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[qq.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,qq.com:mid,qq.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DA0D513ECBF
X-Rspamd-Action: no action

From: zhanghao <zhanghao1@kylinos.cn>

Replace the fixed try count (3) with a dynamic calculation based
on the number of online vCPUs. This allows larger VMs to try more
candidates before giving up, while keeping small VMs efficient.

Formula: clamp(ilog2(nr_vcpus + 1), 3, 10)
- 4 vCPUs: try = 3
- 64 vCPUs: try = 6
- 256 vCPUs: try = 8

Signed-off-by: zhanghao <zhanghao1@kylinos.cn>
---
 virt/kvm/kvm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 663df3a121c8..7f83e434e39a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3984,12 +3984,13 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
-	int nr_vcpus, start, i, idx, yielded;
+	int nr_vcpus, start = 0, i, idx, yielded;
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
-	int try = 3;
+	int try;
 
 	nr_vcpus = atomic_read(&kvm->online_vcpus);
+	try = clamp(ilog2(nr_vcpus + 1), 3, 10);
 	if (nr_vcpus < 2)
 		return;
 
-- 
2.39.2


