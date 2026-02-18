Return-Path: <kvm+bounces-71290-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0EufMAlHlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71290-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:11:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA5815AD22
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5E720305BBA3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1CE33B6DA;
	Wed, 18 Feb 2026 23:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CRoEgNIU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26DD33AD87
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456218; cv=none; b=f2RS8XNrj81VSWw/sUMArj7ilfxobiIIoTBVsllYGLs+jTW+oJizsd22O+sQ5KTSN8beEuGtPM2u+7ny1Y+4eYj5weieTV8NVX6GP1CM4ooDByJv90ojgf7NsD39kKhKA4XVS/e6cIoikWdOGt4pUGBOA6RwusHqC/WG1HwGPEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456218; c=relaxed/simple;
	bh=SGgvqiKaZL5fy2IkUdFKlk/TZFrV5osOdE55bpdVgKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qKSXkxS0ePOJ2NjySLboSBk+56iHVpsG5fvOwwKTbus5doqTzZWsYz/eIL1ebKfQTR/LS4JL1ITONIV5RvJvVRl3zly6qivmgK/S2/AeUtXnn1FoM+ltrOEw9ol4wStvF5DBcvu/ObQXAGrRux+9obMVp6TPHUYRoXl28e6BOVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CRoEgNIU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35449510446so238709a91.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456213; x=1772061013; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sPuks5BJ8BXEbVY+ZQQ2OY9oHJAsuNn824AR4ziLnKk=;
        b=CRoEgNIU7UU3Gq/lBekzviYXCjo16LZESkMPzzIPRBesCQff1CJ/jBVs1yf0HULCX1
         Pjx/2bCkPmcuYZU+wiABCJJbVwgGwRCltAz9zsZjs3G/TiDmu3MzM5amDnx0V8uymk5D
         C/FEtqKPcbXyw0HPbz4NMzqzYDSJBL/qdAEYUdeaqKEPebbpw75oJRbTRpP3/a9B47mH
         x/YLyAcIC4sjThuDy1HWCvWS5yx9MVUzqbHCzHqiSrdjknWVnORQfrjm/CdTBg0uZnuJ
         dWOlrfDU8jowNmGr2R4670UQYvTPoBciSN94hKr6fK0s6wjpUV3lD0MUzVWWEdg+yZ3d
         i7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456213; x=1772061013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sPuks5BJ8BXEbVY+ZQQ2OY9oHJAsuNn824AR4ziLnKk=;
        b=TSzkgqDsOvd0bVwQrpSLA50mce9szhq5+zZxVaeMDoSxwtnZL0nGCB+v7GjZZEMj+p
         SBW+MA+5vk8upvEQuUc5LvNE3lJrQ3hiEpgRIHYc83axUhwMHsOKWrkkDJZSwZoDAp7k
         74N/CAcrlRzaRsbI6w1nNTynAuXzWTypi/AXT+0FIEsSxO9W4XsLtNLWTNqGEUBCvJGa
         Sk3ACKKnZQ+cjqQVp1esu25G8dASkiBHN7FLjDFHS2ueE5VCswvzjlgC0q6nElY2nFkQ
         jPoZEKuiyQRvsDVR75wvXwMMxjniC5GEin28+rx9ddzfMa2EOmnrYzsW8vBcMiwq5KnK
         bLNA==
X-Gm-Message-State: AOJu0YweByl7zu2m4056x1zaHvGb6FjRhPzrtzM+FyxFTYXs6NLnZFBC
	XSTRSNG9ycg7y+hw9ZWlX6+rYqJ89diWxVN2qcnIgAHgLf49CXrcDD+mmU/4egRpEvr73H+zst3
	nqj8FBw==
X-Received: from pjbnw3.prod.google.com ([2002:a17:90b:2543:b0:356:1dfc:2560])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33c3:b0:34e:630c:616c
 with SMTP id 98e67ed59e1d1-358891cba4cmr2470562a91.31.1771456212515; Wed, 18
 Feb 2026 15:10:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:56 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-7-seanjc@google.com>
Subject: [PATCH v2 6/8] KVM: nSVM: Use vmcb12_is_intercept() in nested_sync_control_from_vmcb02()
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71290-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
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
X-Rspamd-Queue-Id: 7DA5815AD22
X-Rspamd-Action: no action

From: Yosry Ahmed <yosry.ahmed@linux.dev>

Use vmcb12_is_intercept() instead of open-coding the intercept check.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bda2d6d613c9..bbb8dfc9979b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -530,7 +530,7 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 	 * int_ctl (because it was never recognized while L2 was running).
 	 */
 	if (svm_is_intercept(svm, INTERCEPT_VINTR) &&
-	    !test_bit(INTERCEPT_VINTR, (unsigned long *)svm->nested.ctl.intercepts))
+	    !vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_VINTR))
 		mask &= ~V_IRQ_MASK;
 
 	if (nested_vgif_enabled(svm))
-- 
2.53.0.345.g96ddfc5eaa-goog


