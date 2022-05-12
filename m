Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B04525716
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 23:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358772AbiELVeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 17:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358768AbiELVeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 17:34:10 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B9E20F778
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 14:34:09 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p12so6012888pfn.0
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 14:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kT78jyQCJ+GjJAeDh/CUyZPg5Qs8hQDQelAq6dcamx4=;
        b=TbnoKUTn9MWKJoGeq6DDC0iiPcfCJI7YfoyanGnASP69yBxEK13C98sh2T8Ne5MCav
         GoqAODRkuNBKBYSadp7+H6LYdV0EeUg/SJHZRoJ5zYw+ch0kX+EbjZH00AI/5Yqa7Hcd
         QLDPlpDX7Y11+DAkezRcpzh+sCF31GK7XPf02Xi+YFu6rLQ/h/vmASwgjEuHcgd8wmAc
         xwIkJASAHQMcXLSyQtNlfCW371PCPuwYm+vHDNRZGmpTuFGHC7lp8SF2L8z02DLxwKMA
         K1xEMCAw2tgdsYAmZ3GRwzsO9tXhfHKn2Q2IERY8h6e/Hol0D8oN168iS5g0C0wca55R
         Z8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kT78jyQCJ+GjJAeDh/CUyZPg5Qs8hQDQelAq6dcamx4=;
        b=tafDPHkVAsD+7vxLW6kV5hIMn3Smu4ZJiqqtEwJt0QaTG2Pb3qJNlf7CTGAY/k8W7l
         Bx4KfNQLzY1PMclQHTZ+PgjPeAlk3wSaIc6e01+9SHH1AmrS3OVl7bVNLtGDbcU6xKct
         wPZgQA45y4Sy0w4bzouuJzhJm7f3A2zABTDPdsItyYVtenua5OpChIbh+CopetIJi6pL
         6u+IxYUW1uGCXduBoJyvFL2wLVK/1GixSa8nZUo/JWsP/wmf4waJZRJNvyFLIZUplNP9
         fwqvoBXaLE6dGBa3WgZT4lSKtJiLKHz2B35D4/ukpHqnxToUIk8V1zCilQQxTuCsGOxs
         XP7Q==
X-Gm-Message-State: AOAM530xLpn2uoPNke7zorIpD40SVxAvDboSxzvpsRmB/9OMDJM7SVuD
        HVxpA9qn0oNoqsIize+KXhwSIw==
X-Google-Smtp-Source: ABdhPJxBsszXtqmVCuTr0ewsW5pmZeyX6uRxwnsl4HJP2Cqdv1b7f9oSaoRwYRWswBNiOYWcu6gqLA==
X-Received: by 2002:a05:6a00:10d3:b0:4fe:5d:75c8 with SMTP id d19-20020a056a0010d300b004fe005d75c8mr1520624pfu.6.1652391248629;
        Thu, 12 May 2022 14:34:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a17090a428700b001dcc0cb262asm275495pjg.17.2022.05.12.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 14:34:08 -0700 (PDT)
Date:   Thu, 12 May 2022 21:34:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 16/22] KVM: x86/mmu: remove redundant bits from extended
 role
Message-ID: <Yn19TPJgdrzDLmbf@google.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
 <20220414074000.31438-17-pbonzini@redhat.com>
 <Ynmv2X5eLz2OQDMB@google.com>
 <e1fc28b6-996f-a436-2664-d6b044d07c82@redhat.com>
 <Yn0XNnqnbstGSiEl@google.com>
 <8c92f44f-3e56-5a5d-76c2-b50b8fe58b3d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c92f44f-3e56-5a5d-76c2-b50b8fe58b3d@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022, Paolo Bonzini wrote:
> On 5/12/22 16:18, Sean Christopherson wrote:
> > On Thu, May 12, 2022, Paolo Bonzini wrote:
> > > On 5/10/22 02:20, Sean Christopherson wrote:
> > > > --
> > > > From: Sean Christopherson<seanjc@google.com>
> > > > Date: Mon, 9 May 2022 17:13:39 -0700
> > > > Subject: [PATCH] KVM: x86/mmu: Return true from is_cr4_pae() iff CR0.PG is set
> > > > 
> > > > Condition is_cr4_pae() on is_cr0_pg() in addition to the !4-byte gPTE
> > > > check.  From the MMU's perspective, PAE is disabling if paging is
> > > > disabled.  The current code works because all callers check is_cr0_pg()
> > > > before invoking is_cr4_pae(), but relying on callers to maintain that
> > > > behavior is unnecessarily risky.
> > > > 
> > > > Fixes: faf729621c96 ("KVM: x86/mmu: remove redundant bits from extended role")
> > > > Signed-off-by: Sean Christopherson<seanjc@google.com>
> > > > ---
> > > >    arch/x86/kvm/mmu/mmu.c | 2 +-
> > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 909372762363..d1c20170a553 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -240,7 +240,7 @@ static inline bool is_cr0_pg(struct kvm_mmu *mmu)
> > > > 
> > > >    static inline bool is_cr4_pae(struct kvm_mmu *mmu)
> > > >    {
> > > > -        return !mmu->cpu_role.base.has_4_byte_gpte;
> > > > +        return is_cr0_pg(mmu) && !mmu->cpu_role.base.has_4_byte_gpte;
> > > >    }
> > > > 
> > > >    static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
> > > 
> > > Hmm, thinking more about it this is not needed for two kind of opposite
> > > reasons:
> > > 
> > > * if is_cr4_pae() really were to represent the raw CR4.PAE value, this is
> > > incorrect and it should be up to the callers to check is_cr0_pg()
> > > 
> > > * if is_cr4_pae() instead represents 8-byte page table entries, then it does
> > > even before this patch, because of the following logic in
> > > kvm_calc_cpu_role():
> > > 
> > >          if (!____is_cr0_pg(regs)) {
> > >                  role.base.direct = 1;
> > >                  return role;
> > >          }
> > > 	...
> > >          role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
> > > 
> > > 
> > > So whatever meaning we give to is_cr4_pae(), there is no need for the
> > > adjustment.
> > 
> > I disagree, because is_cr4_pae() doesn't represent either of those things.  It
> > represents the effective (not raw) CR4.PAE from the MMU's perspective.
> 
> Doh, you're right that has_4_byte_gpte is actually 0 if CR0.PG=0. Swapping
> stuff back is hard.
> 
> What do you think about a WARN_ON_ONCE(!is_cr0_pg(mmu))?

Why bother?  WARN and continue would be rather silly as we'd knowingly let KVM
do something wrong for no benefit.  And this

	return !WARN_ON_ONCE(!is_cr0_pg(mmu)) && !role.base.has_4_byte_gpte;

feels wrong because there's nothing fundamentally broke with calling is_cr4_pae()
without first checking CR0.PG.

If you really want to avoid the is_cr0_pg() check, why not just use has_4_byte_gpte
directly?  Logically I think that's easy enough to follow, e.g. 64 bits == 8 bytes,
32 bits == 4 bytes.  We can always revisit the need for is_cr4_pae() if the MMU
needs to identify PAE paging for some reason, e.g. for PDPTR awareness.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 909372762363..b05190027e20 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -238,11 +238,6 @@ static inline bool is_cr0_pg(struct kvm_mmu *mmu)
         return mmu->cpu_role.base.level > 0;
 }

-static inline bool is_cr4_pae(struct kvm_mmu *mmu)
-{
-        return !mmu->cpu_role.base.has_4_byte_gpte;
-}
-
 static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 {
        struct kvm_mmu_role_regs regs = {
@@ -4855,7 +4850,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,

        if (!is_cr0_pg(context))
                context->gva_to_gpa = nonpaging_gva_to_gpa;
-       else if (is_cr4_pae(context))
+       else if (!context->cpu_role.base.has_4_byte_gpte)
                context->gva_to_gpa = paging64_gva_to_gpa;
        else
                context->gva_to_gpa = paging32_gva_to_gpa;
@@ -4877,7 +4872,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte

        if (!is_cr0_pg(context))
                nonpaging_init_context(context);
-       else if (is_cr4_pae(context))
+       else if (!context->cpu_role.base.has_4_byte_gpte)
                paging64_init_context(context);
        else
                paging32_init_context(context);

