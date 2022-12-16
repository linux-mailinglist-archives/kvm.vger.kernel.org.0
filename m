Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335D764E50C
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 01:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiLPAMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 19:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiLPAMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 19:12:01 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CB85C767;
        Thu, 15 Dec 2022 16:12:00 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n3so691309pfq.10;
        Thu, 15 Dec 2022 16:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CjRTZSnN7OehZ4B/b2PDZdHfkdX8t/7cJbh10Uq9wgM=;
        b=G3ibw7uyJqSHBop+XRRHCmxh5nTgQl7RMsfQLqSnkXGPGve9ffo4JvGCTGIfBqMVvz
         x8PC0wrvKHy63DO6RmJW1r07L5vkhpB11bSdA3wEoZMGQzChT2zFm7EIuipHkoPuyO35
         3mjUvlo9j0NgaphkrplvCeGqhVwsT2clMyH4uc75fSxxjX7Cnr1upYL/8rxJYGitTdWF
         7HP4/Hj91uMo8LCMwOwDLLBhxBZQv6ycOo0fPKCysBnVQz6MtFlkDuV2mLnV+4opLKfN
         kmqQbwFQwzNsEW6qAkrfTaJj3rQqNXpkXL7IN/4dCXdtzP4nJ/4wGtmonS5lDhtu4Jh9
         JEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjRTZSnN7OehZ4B/b2PDZdHfkdX8t/7cJbh10Uq9wgM=;
        b=I6MGZ/b9QyGDjKYUu5qHag8OUakcwmWa/0TWTfU2iiYbLacQBAo3Yjtigpp+W2zMCP
         euCoBGLaOny2CwYF2R4Plgw+Z3pGT6p3lSHCIkrgzzET5YY8TQhCgShDbVNdrDQWGEPa
         iRLXzGpsgEwCXOLGaDP19FvU+TJ6f/ka7lhC6em8nGg9Z8PE/4pTSIxAd0m6GfsEw/Jm
         EqzBM3oRewFlIKN9op5993Arvsh8UqiLUho4MVJxMncaiWzTOrnDeq2L3BcM9i3ItdsA
         RdfdhXPJygbdyS2qjYUZ7mtxrYFtRHr6GcTo3emwvdkvcqPC5K9C/FSdCHPQpwgmwJ/J
         epvw==
X-Gm-Message-State: ANoB5pnXl0uHDs+RrR9xeKpGVXL4zpugkQvAHls0ExX0eDsmz9DeCqvp
        GzJZncJJtjqOG2Fb41viaHs=
X-Google-Smtp-Source: AA0mqf7dR646CBYvZwhssozkq0PE6GAdWdbsqBMGIDmLMOlplvU2goZCen+eJDtRAJY+tG5kXBMHgw==
X-Received: by 2002:aa7:96ab:0:b0:576:b8d0:6034 with SMTP id g11-20020aa796ab000000b00576b8d06034mr31796221pfk.31.1671149519600;
        Thu, 15 Dec 2022 16:11:59 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id d15-20020aa797af000000b00574345ee12csm188474pfq.23.2022.12.15.16.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 16:11:59 -0800 (PST)
Date:   Thu, 15 Dec 2022 16:11:57 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 056/108] KVM: TDX: don't request
 KVM_REQ_APIC_PAGE_RELOAD
Message-ID: <20221216001157.GK3632095@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <f0f134dcf59f901e4b8960c7b3f242dcd42b1c40.1667110240.git.isaku.yamahata@intel.com>
 <e813c4791d3b0a6d14f344dfd881d65a2060764a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e813c4791d3b0a6d14f344dfd881d65a2060764a.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 11:55:58PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX doesn't need APIC page depending on vapic and its callback is
> > WARN_ON_ONCE(is_tdx).  To avoid unnecessary overhead and WARN_ON_ONCE(),
> > skip requesting KVM_REQ_APIC_PAGE_RELOAD when TD.
> > 
> >   WARNING: arch/x86/kvm/vmx/main.c:696 vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
> >   RIP: 0010:vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
> >   Call Trace:
> >    vcpu_enter_guest+0x145d/0x24d0 [kvm]
> >    kvm_arch_vcpu_ioctl_run+0x25d/0xcc0 [kvm]
> >    kvm_vcpu_ioctl+0x414/0xa30 [kvm]
> >    __x64_sys_ioctl+0xc0/0x100
> >    do_syscall_64+0x39/0xc0
> >    entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3868605462ed..5dadd0f9a10e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10487,7 +10487,9 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> >  	 * Update it when it becomes invalid.
> >  	 */
> >  	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> > -	if (start <= apic_address && apic_address < end)
> > +	/* TDX doesn't need APIC page. */
> > +	if (kvm->arch.vm_type != KVM_X86_TDX_VM &&
> > +	    start <= apic_address && apic_address < end)
> >  		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
> >  }
> >  
> 
> In patch "[PATCH v10 105/108] KVM: TDX: Add methods to ignore accesses to CPU
> state", you have:
> 
> +static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
> +{
> +	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
> +		return;
> +
> +	vmx_set_apic_access_page_addr(vcpu);
> +}
> 
> If you drop the WARN_ON_ONCE() above, you can just drop this patch.
> 
> For this particular case, I don't find it is quite necessary to change the
> common x86 code as done in this patch.  In fact, SVM doesn't have a
> set_apic_access_page_addr() callback which is consistent with just return if VM
> is TD in vt_set_apic_access_page_addr().
> 

Oh, yes. I will drop this patch with removing WARN_ON_ONCE().


> Also, I don't particularly like the idea of having a lot of "is_td(kvm)" in the
> common x86 code as if similar technology happens in the future, you will need to
> have another "is_td_similar_vm(kvm)" thing.

Currently KVM_CAP_VM_TYPES has such check in x86 kvm common code.


> If modifying common x86 code is necessary, then it would make more sense to
> introduce some common flag, and make TD guest set that flag.
> 
> Btw, this patch just comes out of blue from the  middle of a bunch of MMU
> patches.  Shouldn't it be moved to "patches which handles interrupt related
> staff"?
> 
> Btw2, by saying above, does it make sense to split patch "[PATCH v10 105/108]
> KVM: TDX: Add methods to ignore accesses to CPU state" based on category such as
> MMU/interrupt, etc?  Particularly, in that patch, some callbacks have WARN() or
> KVM_BUG_ON() against TD guest, but some don't.  The logic behind those decisions
> highly depend on previous patches.  To me, it makes more sense to just move
> logic related things together.

Ok, I'll split it up to cpu states/KVM MMU/interrupt parts.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
