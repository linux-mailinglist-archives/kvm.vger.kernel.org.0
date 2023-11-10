Return-Path: <kvm+bounces-1511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9343E7E86C0
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2300FB20CB9
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C96D3E48B;
	Fri, 10 Nov 2023 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iEc25nsv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5F93E46E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:55:44 +0000 (UTC)
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686484212
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:43 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-280465be3c9so2584091a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699660543; x=1700265343; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lj6QboIyWdPKwpOPfJ3u7CONO+6S55iCaYCfcwC+TWo=;
        b=iEc25nsvsauTcalh84eeP2HJzFe5VLQfjJRlce3g+JgdgW88cWCLLkwEWIsPEeRen5
         PS+gkCXWD4jhG86f4Z/5iI7UYt20uB43lH1Tp7EdGruwFDctylDUtOLypXMrolNmJsGk
         /Yf5aPFUZ6W62xO+UFACyXDpyHPz5wQR/LTgW8P/d6TkO5mOXJj4eUms4UEA9bGFBwS1
         poWH/MCetJjhhebB1/B3Xcz0xeKegNd5TbFzEwFJB5F0UrtvlxVnol/dkNMpymRG0n0+
         Mqlrr/hHJQw46i8dW1pAhnyvTU1sJ92Ly/7KBHo6U9gYO9BP1G/MXHogAEk1vwT/7O7e
         9TDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660543; x=1700265343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lj6QboIyWdPKwpOPfJ3u7CONO+6S55iCaYCfcwC+TWo=;
        b=MWRcMf8kHfuzCEBikNn2v1JFnbSB2UTHWhbW+RQUwQI9Hkv+1ZeACfD0TE8Pp5JcxM
         d7lphrm+YewRmdNBkHD5rzA3jhSKjqEKKvYAj0GgX2LiBEZZJ9E/hVEfBo409ZW7EKWq
         Y+njGdpDS37x5WYUK0FC4FS8+x/5P8CWiKRnF2933ElUeZdSPd7aIWeEwmV9IyrKpP68
         dJENzzkMq+tqd+gQLdCqCH6ForPrm4rxn0HztIx5iWqTrktgspov6qZ2IIDe9nDZBVnY
         q3p2HoEyKylzBapaLJdH6ZG+o0cezwGCzU36rK0a+bMdUMDIA40e9ZmDbK/u+T1yv6Ld
         CZDw==
X-Gm-Message-State: AOJu0YzzZhb0uUUlcMeXnuYao/V3veEY4sgTrmPN9AlR61lr6MJ0rC9v
	fMZxrYs3FKlIcd0KWmktgxhR/LjTXPY=
X-Google-Smtp-Source: AGHT+IGnfhC7CLi2jPB1BP4mqYcKdyc5bXkMBRuQ0Ukestup4m0lzMxogNBHWXgmaVlSgUzREdADxCqw4EE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e413:b0:27d:3322:68aa with SMTP id
 hv19-20020a17090ae41300b0027d332268aamr164287pjb.2.1699660542941; Fri, 10 Nov
 2023 15:55:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Nov 2023 15:55:24 -0800
In-Reply-To: <20231110235528.1561679-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110235528.1561679-6-seanjc@google.com>
Subject: [PATCH 5/9] KVM: x86: Drop unnecessary check that cpuid_entry2_find()
 returns right leaf
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Drop an unnecessary check that cpuid_entry2_find() returns the correct
leaf when getting CPUID.0x7.0x0 to update X86_FEATURE_OSPKE, as
cpuid_entry2_find() never returns an entry for the wrong function.  And
not that it matters, but cpuid_entry2_find() will always return a precise
match for CPUID.0x7.0x0 since the index is significant.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6777780be6ae..36bd04030989 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -284,7 +284,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 	}
 
 	best = cpuid_entry2_find(entries, nent, 7, 0);
-	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
+	if (best && boot_cpu_has(X86_FEATURE_PKU))
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
-- 
2.42.0.869.gea05f2083d-goog


