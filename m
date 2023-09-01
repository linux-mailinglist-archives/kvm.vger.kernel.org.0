Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2527900EA
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 18:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348359AbjIAQsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 12:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238201AbjIAQsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 12:48:19 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C159310E5
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 09:48:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56f75e70190so2495178a12.3
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 09:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693586895; x=1694191695; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IIsKqJP4zzJnSyLtJubxxUR230WOWQDNF6SlEkb/jpc=;
        b=s1EqejacUZZCmzLZim6NEbR+SnpW8IIv6hi0m/U53bdva5esdXoL3tVNTmr+EeYqzo
         9jZPDE5ESP3WexfpVL4sqVpsq7AyxLbiYIaagA2fM+DHGQ6JAAuE9zPSgIls+8MyS6O9
         7iTtKlIDd20WumFP98mwKmosU8xTHTsOIPRB8eBGhrINNr9EtiTgOhhBr4iisG/8QCxw
         URX1W+nm6rPsBUMQUQ3iNNkIg2+LKB9JOIc/Xq1oo2LH4UdTccCdG0M6pZEcDONbxoA/
         o9erhNv6N+mW9IP4sIt3GzBmo8+PPCi4n5idfUIzt66rivpEARqsK3exUGbKI4o0fiN1
         ijhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693586895; x=1694191695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IIsKqJP4zzJnSyLtJubxxUR230WOWQDNF6SlEkb/jpc=;
        b=Ykg9YwiIIkHCbvbOsoWw1EaB7s0vWW79pcaPBvC6fY0xOEiyKtqRvSWfbq0xHqRAcx
         CqDRJGKWWrry0gD4IqdETM62XtcLnnFYCmlH40Lij9k71ALt2zQNWWBLl7JdgyUoz2wK
         1Dxhn1IxeVLF4p9OL6gjxbN87pkd+vWx923DKCif23nZSqg7zElKYQ3CXPO9Kd7HsbjM
         dfLHhQLEGrP9LFSDjWMZQxSJKyhy9hJNu59iZhBvykm+S1xuMDvsreywp4sl7jii6J2P
         wfZjzqHadPzstbTdAz2k/XDQ12u1U8zraLRf5sKLapERwCM55lk8tGahlll01kwtiLxL
         x9hg==
X-Gm-Message-State: AOJu0YyGaW40vW22N76AJfpLrOu4A6+zJpmdl8H/PHUVG/NO1yKyxsBp
        +cni26GXx5+O8habynwhvAv8n4IvjJM=
X-Google-Smtp-Source: AGHT+IH0+/Ice7G2IFVCmnmdzDOJ1RDHe9ugKzbFkW4mWYvVU/kgmm5gEkk6OnoadSNh1wbQ63PF5BW3Yqk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ee0f:0:b0:56c:2f67:7294 with SMTP id
 e15-20020a63ee0f000000b0056c2f677294mr538903pgi.5.1693586895252; Fri, 01 Sep
 2023 09:48:15 -0700 (PDT)
Date:   Fri, 1 Sep 2023 09:48:13 -0700
In-Reply-To: <20230902175431.2925-1-zeming@nfschina.com>
Mime-Version: 1.0
References: <20230902175431.2925-1-zeming@nfschina.com>
Message-ID: <ZPIVzccIAiQnG4IA@google.com>
Subject: Re: [PATCH] x86/kvm/mmu: =?utf-8?Q?Remove_?= =?utf-8?B?dW5uZWNlc3Nhcnkg4oCYTlVMTOKAmQ==?=
 values from sptep
From:   Sean Christopherson <seanjc@google.com>
To:     Li zeming <zeming@nfschina.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 03, 2023, Li zeming wrote:
> sptep is assigned first, so it does not need to initialize the assignment.
> 
> Signed-off-by: Li zeming <zeming@nfschina.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..95f745aec4aa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3457,7 +3457,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	struct kvm_mmu_page *sp;
>  	int ret = RET_PF_INVALID;
>  	u64 spte = 0ull;
> -	u64 *sptep = NULL;
> +	u64 *sptep;
>  	uint retry_count = 0;
>  
>  	if (!page_fault_can_be_fast(fault))

Hmm, this is safe, but there's some ugliness lurking.  Theoretically, it's possible
for spte to be left untouched by the walkers.  That _shouldn't_ happen, as it means
there's a bug somewhere in KVM.  But if that did happen, on the second or later
iteration, it's (again, theoretically) possible to consume a stale spte.

		if (tdp_mmu_enabled)
			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
		else
			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);

		if (!is_shadow_present_pte(spte)) <=== could consume stale data
			break;

If we're going to tidy up sptep, I think we should also give spte similar treatment
and harden KVM in the process, e.g.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6325bb3e8c2b..ae2f87bbbf0a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3430,8 +3430,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
        struct kvm_mmu_page *sp;
        int ret = RET_PF_INVALID;
-       u64 spte = 0ull;
-       u64 *sptep = NULL;
+       u64 spte;
+       u64 *sptep;
        uint retry_count = 0;
 
        if (!page_fault_can_be_fast(fault))
@@ -3447,6 +3447,14 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
                else
                        sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
+               /*
+                * It's entirely possible for the mapping to have been zapped
+                * by a different task, but the root page is should always be
+                * available as the vCPU holds a reference to its root(s).
+                */
+               if (WARN_ON_ONCE(!sptep))
+                       spte = REMOVED_SPTE;
+
                if (!is_shadow_present_pte(spte))
                        break;
 

