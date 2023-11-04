Return-Path: <kvm+bounces-548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 913897E0C73
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2920B1F21A31
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFDB01864;
	Sat,  4 Nov 2023 00:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CFMT/kaO"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90C8A3B
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:02:44 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17BED4C
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:02:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afa071d100so53776587b3.1
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056162; x=1699660962; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nOzsUN1YNjo4mM3u1hilIKuxhzw1b/cPpyuR5vqvOEM=;
        b=CFMT/kaORlS2yU0gvAAAxQ1jOYqJYKqa+q1KZd9Zwuc+usFP6yHgxaoOBKETtlFsHv
         jHBAR8F7UnDz5/UBgKXgSZE84V7ckfz8L9jy+oCz+lPi+I36q8t/TEPLd4DfM78CMBED
         p8cd016sLD1tRfZhMOPhlHcPA3NAIY53MEk1kpzXdHjCkDHUdw/p6zociJAplcCG0JL6
         5St3VZgwKFNnCnP9LEg523MvY0ckM1/Df3ELVoBjagBf33fjUSNOIyRfiNBMCHK/UlhA
         zqtzlxYHY6MY7US7zMVNGPip7G1VSzuMG90d9AqUq7d7kz1FF+fs1qTu9iFX6a3R49WZ
         ZmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056162; x=1699660962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nOzsUN1YNjo4mM3u1hilIKuxhzw1b/cPpyuR5vqvOEM=;
        b=oEu4Ag4FlQaBV8mstTSTQZ/I2iPhb0O3kSUI/fqUB8JGPcq52Ko2R98SX+Yr57lihg
         it0HngCCTYPNiVamHnwOztxv+l55/2tFQ8EHYqHftMFMlv0a7icrUVOxZUk3FAkAdtI0
         4Jg6L0dcurQeG9GsHbbbGUOCHo+Piui3Y5Fy6up1TMZM4JR36DPZnuL5FfD33zHco9Ez
         rYG2nokarKC30SaCOMqKk/g0J/eucw75EkPEbjfS+mr/ldyv+EFc/wr1ZeBKze/5crdI
         fYKC4gj1OXWQq6PiwBooezxE7UZG3K1PuN0tLeqZllLw0IqmAb1kkhaGLOTVxgSz5jLo
         V8gA==
X-Gm-Message-State: AOJu0YxUxQhJaBkxtIG9u+N37/eEMnxvlpnl1hLFGoFVh75ximLnDxuc
	W56NNkq98gWhuLin7S7Z1LXzUVfkYo8=
X-Google-Smtp-Source: AGHT+IGAbN0m5ShzVxvluMl0W5kCIQjTup2IT2nxWsIkQodtNZB6+MZQkaVB8Sf70LHX1BZEnLV0C+dyiLg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:df52:0:b0:5a7:b9b0:d23f with SMTP id
 i79-20020a0ddf52000000b005a7b9b0d23fmr83931ywe.6.1699056162701; Fri, 03 Nov
 2023 17:02:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:19 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-2-seanjc@google.com>
Subject: [PATCH v6 01/20] KVM: x86/pmu: Don't allow exposing unsupported
 architectural events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Hide architectural events that unsupported according to guest CPUID *or*
hardware, i.e. don't let userspace advertise and potentially program
unsupported architectural events.

Note, KVM already limits the length of the reverse polarity field, only
the mask itself is missing.

Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820d3e1f6b4f..1b13a472e3f2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -533,7 +533,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	eax.split.mask_length = min_t(int, eax.split.mask_length,
 				      kvm_pmu_cap.events_mask_len);
-	pmu->available_event_types = ~entry->ebx &
+	pmu->available_event_types = ~(entry->ebx | kvm_pmu_cap.events_mask) &
 					((1ull << eax.split.mask_length) - 1);
 
 	if (pmu->version == 1) {
-- 
2.42.0.869.gea05f2083d-goog


