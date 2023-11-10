Return-Path: <kvm+bounces-1514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E44B77E86C4
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:56:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 743BDB20BB0
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0563E49D;
	Fri, 10 Nov 2023 23:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pM6pVi7n"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5753E495
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:55:55 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49024789
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:51 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7bbe0a453so34606457b3.0
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699660551; x=1700265351; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qmj7GZ0SAOjD/VDeZDIJ7y/K+3O78AzZdQ/afS++F9w=;
        b=pM6pVi7nJiH1VW2fSQVC2iEpCLiB96dBV6OwYdYlfpC2N1QxzswHcd8WlRbLywOM35
         ZU0cKFLTyFglKyY7QcsuxCqFncMlIlq5asWvP2HUd8dd5h84I3/LwsfLExd84Wno9ifx
         /Blllg4y8tlAFu+xRkz98CaCTVKwiVRyDDKYALTv7/8jrhNr5VljzjscK4BXghdqH9J+
         oPFovF+7+tk7V+J+BLwfVoU2hZkikHpOQ0gvgS+s2ADC+a3pXkriT4HbVv3FnAzJboAt
         86CprFHucIdFj9otwpL9vtfHniVtlbBZRP0K+ee98Pgxw4lrFai5q5lzuz/O1dGqn6QZ
         9kSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660551; x=1700265351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qmj7GZ0SAOjD/VDeZDIJ7y/K+3O78AzZdQ/afS++F9w=;
        b=vna3pE0HDL18i/KlCgU15grDxoipHjl2RWI0uQ01MlMUbdstvIfX3I6oj3Qza9cItZ
         wBl36IQamtCJjaJ0N/1otkUGRTk3iBPXPXdJP0lQazeGfoVmAPo4ujm0Oh8BjSNvv2sU
         /dK7dA/YhX8dYs6yiEUTWNYwEnLmkRqYharYgrl+HNopeWobWILqMVH3cILJFY873wsM
         I+fgGvF6S4oDTOnmfS86lzXgblo9q2FA9BurzXU0wgUQ5oqVTDOZ3HqzTl+Dy1TBjD9R
         zb5pfHogFplcm37Z/Xk1qc5sehRckrhOQrdYEaFUKwqpOAzqwLbpPzg+Ku7nXwA81lFc
         Ij+Q==
X-Gm-Message-State: AOJu0YyLRszsmJLioKpp1XuXJo3GtSFeweAKP2ozV0o1JmkYqE1VwNfm
	ws7c8q5DwOPEuaAi+FV8AHBa03dPzYk=
X-Google-Smtp-Source: AGHT+IEjA1FyHv2eFtTBRxlVBGlSko6kQgtbPOhwvosPV9tjPhS4aG+DEOi3c1T1lz38zGocB/oAF1i7h7w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:914e:0:b0:5a7:db29:40e3 with SMTP id
 i75-20020a81914e000000b005a7db2940e3mr21020ywg.7.1699660551073; Fri, 10 Nov
 2023 15:55:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Nov 2023 15:55:28 -0800
In-Reply-To: <20231110235528.1561679-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110235528.1561679-10-seanjc@google.com>
Subject: [PATCH 9/9] KVM: x86: Restrict XSAVE in cpu_caps based on KVM capabilities
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Restrict XSAVE in guest cpu_caps so that XSAVES dependencies on XSAVE are
automatically handled instead of manually checking for host and guest
XSAVE support.  Aside from modifying XSAVE in cpu_caps, this should be a
glorified nop as KVM doesn't query guest XSAVE support (which is also why
it wasn't/isn't a bug to leave XSAVE set in guest CPUID).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e3a9191dac1..6fe2d7bf4959 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4315,8 +4315,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
 	 * the guest read/write access to the host's XSS.
 	 */
+	guest_cpu_cap_restrict(vcpu, X86_FEATURE_XSAVE);
 	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
-			     boot_cpu_has(X86_FEATURE_XSAVE) &&
 			     boot_cpu_has(X86_FEATURE_XSAVES) &&
 			     guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE));
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 815692dc0aff..7645945af5c5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7752,8 +7752,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
 	 * set if and only if XSAVE is supported.
 	 */
-	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
-	    guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
+	guest_cpu_cap_restrict(vcpu, X86_FEATURE_XSAVE);
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
 		guest_cpu_cap_restrict(vcpu, X86_FEATURE_XSAVES);
 	else
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
-- 
2.42.0.869.gea05f2083d-goog


