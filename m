Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9F6524FCC
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 16:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355175AbiELOSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 10:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355181AbiELOSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 10:18:36 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFDD8D6A2
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 07:18:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x18so5006186plg.6
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 07:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EJCIgLlmlrEBfCKZGVMMjM7XE4hdH7cPIpVtr4puXbg=;
        b=sqGrRKuvRsGAT9Rvn7s3ecBx0cKJzFT9HRKTHjDSNkBKrH1SCsytVym5adDqxG4sFX
         EN7HgnWHrznI/Ozg3Bad4LKo99IXblGh8CPUNipHWL4II4TUMScLxYkJ7L3LxXSQZVDi
         8+eo6lZTNL+9jEazz5mjHxjqfre/rBsSSoct2aXc2jKbir0L1kH0epOiVPONQqf+XGkf
         6b/FIa5fJs7kbhl82w0oxEcREJCq+uzH4YWT9Sgv41b6nMEV0OCxlknML6OKACriWfAr
         A05EnBaFxZni+961eBEWEePSwwke4lgomSmL+UFtgg1EnoHUpzFJBLq1Y13g+YkFlV/u
         Is2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EJCIgLlmlrEBfCKZGVMMjM7XE4hdH7cPIpVtr4puXbg=;
        b=m04DMyj9xhm/CewOIGmwltHmV6HcY203xTW0mp82ckjrLg8RDerqYv5gJ6JtTV4pRt
         0daT91XyaV6bPE9NhkjAkGSzMOzMFOdU6nkVMqsOdAvqDp/tc8cryv8ShUe5l6wKeVOP
         QbKFMuUXbwaYdLAftO6CSzTN0x6bL5nNWOxM7VLii1hDR4pRQ/+HkzTgiuONWdrj0XOR
         0U0AcgDyvqNHecVz1ItLZD/fYT09X2O7G1VokMFfNCHtn6bkHE0ue2uUcWa2B1vCMiaX
         3zHpHrzoPkMz9ARVUHq4c8NQFr4okElhkSGreZI5P99e8zDAznI8fRJUJwZV6cou2BGI
         MfZA==
X-Gm-Message-State: AOAM533miK3sQZkL3kxKkc1pVqpqrF/5ui3Hum7slpvFAYuKZ11IE7NY
        Y8rxdoAKwZ+0NgRQBiZEGsB2JQ==
X-Google-Smtp-Source: ABdhPJylEBGBm3thCxu5K66iXnEOJwEUQ8EAE3QfRKkImsymqDHIZiGiux8MWND7ylRxta3E27DKxQ==
X-Received: by 2002:a17:903:182:b0:15e:8de0:2859 with SMTP id z2-20020a170903018200b0015e8de02859mr201551plg.124.1652365114298;
        Thu, 12 May 2022 07:18:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t67-20020a628146000000b0050dc762814asm3903647pfd.36.2022.05.12.07.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 07:18:33 -0700 (PDT)
Date:   Thu, 12 May 2022 14:18:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 16/22] KVM: x86/mmu: remove redundant bits from extended
 role
Message-ID: <Yn0XNnqnbstGSiEl@google.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
 <20220414074000.31438-17-pbonzini@redhat.com>
 <Ynmv2X5eLz2OQDMB@google.com>
 <e1fc28b6-996f-a436-2664-d6b044d07c82@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1fc28b6-996f-a436-2664-d6b044d07c82@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022, Paolo Bonzini wrote:
> On 5/10/22 02:20, Sean Christopherson wrote:
> > --
> > From: Sean Christopherson<seanjc@google.com>
> > Date: Mon, 9 May 2022 17:13:39 -0700
> > Subject: [PATCH] KVM: x86/mmu: Return true from is_cr4_pae() iff CR0.PG is set
> > 
> > Condition is_cr4_pae() on is_cr0_pg() in addition to the !4-byte gPTE
> > check.  From the MMU's perspective, PAE is disabling if paging is
> > disabled.  The current code works because all callers check is_cr0_pg()
> > before invoking is_cr4_pae(), but relying on callers to maintain that
> > behavior is unnecessarily risky.
> > 
> > Fixes: faf729621c96 ("KVM: x86/mmu: remove redundant bits from extended role")
> > Signed-off-by: Sean Christopherson<seanjc@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 909372762363..d1c20170a553 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -240,7 +240,7 @@ static inline bool is_cr0_pg(struct kvm_mmu *mmu)
> > 
> >   static inline bool is_cr4_pae(struct kvm_mmu *mmu)
> >   {
> > -        return !mmu->cpu_role.base.has_4_byte_gpte;
> > +        return is_cr0_pg(mmu) && !mmu->cpu_role.base.has_4_byte_gpte;
> >   }
> > 
> >   static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
> 
> Hmm, thinking more about it this is not needed for two kind of opposite
> reasons:
> 
> * if is_cr4_pae() really were to represent the raw CR4.PAE value, this is
> incorrect and it should be up to the callers to check is_cr0_pg()
> 
> * if is_cr4_pae() instead represents 8-byte page table entries, then it does
> even before this patch, because of the following logic in
> kvm_calc_cpu_role():
> 
>         if (!____is_cr0_pg(regs)) {
>                 role.base.direct = 1;
>                 return role;
>         }
> 	...
>         role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
> 
> 
> So whatever meaning we give to is_cr4_pae(), there is no need for the
> adjustment.

I disagree, because is_cr4_pae() doesn't represent either of those things.  It
represents the effective (not raw) CR4.PAE from the MMU's perspective.  If you
want it to represent 8-byte gPTEs, that's fine, but then please name the helper
accordingly, because is_cr4_pae() is flat out wrong if CR0.PG=0 && CR4.PAE=0.
