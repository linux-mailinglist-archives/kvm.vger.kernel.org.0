Return-Path: <kvm+bounces-71287-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGDCCyVHlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71287-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:11:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8855115AD38
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E6A1306FE04
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CA733ADB5;
	Wed, 18 Feb 2026 23:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="336Wmtce"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0067133AD89
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456209; cv=none; b=WLLcaU72AGDQHk5VbxsKRlELTq48x26W3sSkw48hjSaIOsDIHaVmmEkLMCRRGodsgnngfwoWBnf2+qXKqagEED6+JCShzbsdyXEztI6ISr4jA0kP9QOC3Cmh+pZux64ph+AEKR5rf8acWPOcY0URp+qnzdrEZpVJ3jlZX+u7tBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456209; c=relaxed/simple;
	bh=3DZZd8lu8WIKxAiwbtA8KRS5+FC7VWHgRRfIAwjLnpc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NWte2ICvtaftTDZS4D3jzq5v9+gJ8ZBJci1iIvJMHaz1FVqPUDLwCAdZ3qykRfFdFM7r9Ta4h5V+qLjaaqPGFVtGyVfu1BYYvyxUuB1W2cs6tj1TzC34GTSmpOeuEX+bD4YSJSVpuSbGLO9OwvlSUEadd/kBB9BORR+JUsFw7QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=336Wmtce; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6de06e6c08so154618a12.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456207; x=1772061007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6Kw8QE5cNoJCuppqB1Y2qVSbKI4zWPrm2R6k+VHt6KA=;
        b=336WmtceiQQXxpZepvZWrVXMVL2uqI2pMJ2tqq7yrYghLBqJrpNLlFqwD5SYPRoQY6
         D5qG3q/LAllpIekTonQ1F8NN0AgLuzOqVgPdvsEFQ3Rr874IxQiP7aujmb/WNjNzoJiq
         wMz7nIdAPoh3ym8fIeLD54PkeDw0zqE4gVODC02k5SwW/6OAVHp1PeUoxp0fDMgyePQq
         tqJsGp4sQfBx9oAA1NxDHBEwd5LBxKjNxqKgKQr8G8Sv/DJ6Gjtp5Aa8xSZqU8uPVGgW
         8Le8XuanOwYMnXZgzSYx0s0g1R8RxoXO2VJdNcCf5lJ82ZdYIDTDUk71auZhNdiggaoV
         h6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456207; x=1772061007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Kw8QE5cNoJCuppqB1Y2qVSbKI4zWPrm2R6k+VHt6KA=;
        b=iD+WRsS6N9QskEwElUnh7GpUONg1B78xy6paRyCPwRx7BsxTJGu/hMbhgSSONkaWHk
         7JY68QWaIsp2CbPI6D+k3maq4f+OjAcpnXJBWNEhBb00QHG2k86Xg6A8kVcVCDNZlYSS
         JXbRgnRZKTcL932Ih5lywYuOLfZaoLy0NHzuW1sWif6QCZ74LfHCAWe8r60dlH8u7VxJ
         iKuQkEC/uAANyobLn5QpzZ1yve98ob3zNT1HyBukA9CVE9CquduR9dFY7uf0FOV2BJc1
         IGZukQ4btBgegUDmjzj00z+dX0INH0SOsnPojSwvQ1SESj36Qo1e1LNUtEz2jzx8bQ5n
         zowA==
X-Gm-Message-State: AOJu0Yy6jsF7ZLRFnywtX0u90AXoGYZPQiATXBSef9eHMxPmInqGqa4v
	+WveTpSP/Fp5kqrx/pcqCyEfNjrq+Qo/OBnx3nCrWGy1nT0JYvN5ScQEfx81LszCgoCuTcbJH57
	fMMVfSQ==
X-Received: from pgaq67.prod.google.com ([2002:a63:4346:0:b0:c6e:8f1b:392a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3941:b0:38e:8842:6683
 with SMTP id adf61e73a8af0-394fc13aa71mr3169591637.5.1771456206901; Wed, 18
 Feb 2026 15:10:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:53 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-4-seanjc@google.com>
Subject: [PATCH v2 3/8] KVM: nSVM: WARN and abort vmcb02 intercepts recalc if
 vmcb02 isn't active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71287-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 8855115AD38
X-Rspamd-Action: no action

From: Yosry Ahmed <yosry.ahmed@linux.dev>

WARN and bail early from nested_vmcb02_recalc_intercepts() if vmcb02 isn't
the active/current VMCB, as recalculating intercepts for vmcb01 using logic
intended for merging vmcb12 and vmcb01 intercepts can yield unexpected and
unwanted results.

In addition to hardening against general bugs, this will provide additional
safeguards "if" nested_vmcb02_recalc_intercepts() is invoked directly from
nested_vmcb02_prepare_control().

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
[sean: split to separate patch, bail early on "failure"]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 48b60dd6e7a3..793f5d2eed3a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -128,6 +128,9 @@ void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
 	struct vmcb_ctrl_area_cached *g;
 	unsigned int i;
 
+	if (WARN_ON_ONCE(svm->vmcb != svm->nested.vmcb02.ptr))
+		return;
+
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 
 	c = &svm->vmcb->control;
-- 
2.53.0.345.g96ddfc5eaa-goog


