Return-Path: <kvm+bounces-73182-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uK2cIMRfq2mmcQEAu9opvQ
	(envelope-from <kvm+bounces-73182-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:14:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4B432288EE
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68EE030541D5
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 23:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897F836DA0B;
	Fri,  6 Mar 2026 23:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="TGFCe93z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EE434F479;
	Fri,  6 Mar 2026 23:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772838836; cv=none; b=CXFDB2netAToUMEDfqXndPXOLzcWsomO3D03s4yffBaFv0OUN9GSZXz1es2SktWUwG8M4kGCphnJ6WY6RALzkfPDek1jOkQA8yK9+ITbl+6kosAyYQnk9Dz6XDwDHwhmHvsVa/sa7bri1YGKwoIkVTpA+aWnRIaojVfqlinIjBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772838836; c=relaxed/simple;
	bh=RLI4CfdmHew9Rj7qnmtFB7QPD3tncAVvmt3e/exxz2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dsj4y0Fh8XJXeQHnJJ3F8QgJW4RXgOweaXrJ86dkon1wYDWgLcj72o1/MCAc4SdlMqIAKSfSzMFB9Y8VcQHIIEClxaO6umjdMAdC4SXw92OfNSnT54djfr1NE+J+r11v7u6oLDMWaPwxNI4FRfi9XOCykDJvKpqEqQlvypXe61o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=TGFCe93z; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 626NCs4R2177262
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 6 Mar 2026 15:12:57 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 626NCs4R2177262
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772838778;
	bh=W/RFtoL0oyi4WGrcLF6hZu87GPY7rOxOurIbrHWiKHs=;
	h=From:To:Cc:Subject:Date:From;
	b=TGFCe93zoiv6K0x1sx2XZ/ShHU5/wWnU++0dLKBmw03dDiCpgPfKqnrxEYBzNrU5u
	 XsLXQIwpttqPTnCpzZMaDYtoZOu3tWkd1XbSqE/WXg4mtgLyuqUI9CTgpHuGmKV6co
	 AY2E0SLGttv543Z3L+qyIhOxhUemEQikBZ/vBwHagNPbppkUOT5MISlxwnOs0UwHkF
	 xT2PTknA3AP5kNCXIpyGPM+dGsCi57LKIbkIrvVuawHyJ7jG09uYLNwsGvTkTpLrxU
	 tKgAUl+Vd50DnTQRPvyJS63+PugTCUiPAhW4mebR9BO7fp6+5mqA2//8VgN1yURlKK
	 dDadVi5dSO26Q==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com
Subject: [PATCH v2] KVM: VMX: Remove unnecessary parentheses
Date: Fri,  6 Mar 2026 15:12:53 -0800
Message-ID: <20260306231253.2177246-1-xin@zytor.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4B432288EE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-73182-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.977];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,zytor.com:dkim,zytor.com:email,zytor.com:mid]
X-Rspamd-Action: no action

From: Xin Li <xin@zytor.com>

Drop redundant parentheses; the & operator has higher precedence than the
return statement's implicit evaluation, making the grouping redundant.

Signed-off-by: Xin Li <xin@zytor.com>
---

Changes in v2:
*) Don't remove parentheses in multiple checks. (Bill Xiang)
---
 arch/x86/kvm/vmx/capabilities.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4e371c93ae16..56cacc06225e 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -107,7 +107,7 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 
 static inline bool cpu_has_load_cet_ctrl(void)
 {
-	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
+	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE;
 }
 
 static inline bool cpu_has_save_perf_global_ctrl(void)

base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
-- 
2.53.0


