Return-Path: <kvm+bounces-448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D4A7DF9FF
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0A2F281190
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E87B21357;
	Thu,  2 Nov 2023 18:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YOw9bHF5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E079E21359
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:35:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC25128
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698950114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N4aRCzDVchJmhXnWZveRqLidGEencbVI2Bo/er04qs0=;
	b=YOw9bHF5XyAwv2vWexaPkPXFjayFpHZuzWIkWbP3idfUNRkl87sHxJ1q3u9zaFICGPYV9T
	bAN7M4UUofxoVMBphrw/KnrtddmgUfKIMZelC1l5R0f1kX+0L/X1Bdj26tDr0SvXF/zoys
	uER0lAaTovwkl21W5fKQvb6yHc2/xZ4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-HSAklbxIPceCgEQ0iKrC_g-1; Thu, 02 Nov 2023 14:35:12 -0400
X-MC-Unique: HSAklbxIPceCgEQ0iKrC_g-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32f521150aaso645620f8f.1
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698950111; x=1699554911;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N4aRCzDVchJmhXnWZveRqLidGEencbVI2Bo/er04qs0=;
        b=uIrthN3qdbge6VtSDkV8cPHF5pXatI02QrxNjeRXy1JVWAiFMrJXIye55ghm9cvxxt
         mAwIgNEHHyP0AwSrtQ6wgvkebjZtCETwjHukJcTNRWaI98gTcvQXLiGfHlMlXu9t5YKM
         /Rt6D/Xr2MJwS3NDPg5uiTh61YAJa7NWIaiCbM/u3YSbruBLNxy9K6wstMc6Sm2EWa/Y
         5kCTSsnW3Du+JGgbIbQrhTsFoKyQWzHgJF8CYjU4U0pdSfYx5aHr3edHIFe+I2SOotbq
         /bqFGI7qscnT/nAHkOBaqOYSoEnhyDvHpUA9lqkiqt8idx5YkGUB5U9G9YfyA7MpXqai
         /wmw==
X-Gm-Message-State: AOJu0Yy24U0C7bcPRCXy/c2jcuZWzCg3rPHxH21PrIrRxp+oXl0sLXjU
	yyKmH9F4C1QdieVhh1WmKwaWpVRj9hAExiJ/da2UV21+J9+MRmku2ebwY3+ahKqRPYbWbkiAWns
	Kd/7kiN7RUYOU
X-Received: by 2002:a5d:58d8:0:b0:32d:d2ab:f8e3 with SMTP id o24-20020a5d58d8000000b0032dd2abf8e3mr13140001wrf.68.1698950111444;
        Thu, 02 Nov 2023 11:35:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzlbcNABTrNQMGaiVGyemkwLQ6UflpTYTNRiwRtee1J+zE6N6uq8VBudkTvaQQC2tvlgpkSQ==
X-Received: by 2002:a5d:58d8:0:b0:32d:d2ab:f8e3 with SMTP id o24-20020a5d58d8000000b0032dd2abf8e3mr13139991wrf.68.1698950111068;
        Thu, 02 Nov 2023 11:35:11 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id d13-20020adfe2cd000000b0032ddf2804ccsm4081wrj.83.2023.11.02.11.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:35:08 -0700 (PDT)
Message-ID: <73c4d3d4c4e7b631d5604178a127bf20cc122034.camel@redhat.com>
Subject: Re: [PATCH v6 18/25] KVM: x86: Use KVM-governed feature framework
 to track "SHSTK/IBT enabled"
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com, 
	peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 02 Nov 2023 20:35:06 +0200
In-Reply-To: <ZUJy7A5Hp6lnZVyq@google.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-19-weijiang.yang@intel.com>
	 <ea3609bf7c7759b682007042b98191d91d10a751.camel@redhat.com>
	 <ZUJy7A5Hp6lnZVyq@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-01 at 08:46 -0700, Sean Christopherson wrote:
> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > Use the governed feature framework to track whether X86_FEATURE_SHSTK
> > > and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
> > > the features can be used iff both KVM and guest CPUID can support them.
> > > 
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >  arch/x86/kvm/governed_features.h | 2 ++
> > >  arch/x86/kvm/vmx/vmx.c           | 2 ++
> > >  2 files changed, 4 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> > > index 423a73395c10..db7e21c5ecc2 100644
> > > --- a/arch/x86/kvm/governed_features.h
> > > +++ b/arch/x86/kvm/governed_features.h
> > > @@ -16,6 +16,8 @@ KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
> > >  KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
> > >  KVM_GOVERNED_X86_FEATURE(VGIF)
> > >  KVM_GOVERNED_X86_FEATURE(VNMI)
> > > +KVM_GOVERNED_X86_FEATURE(SHSTK)
> > > +KVM_GOVERNED_X86_FEATURE(IBT)
> > >  
> > >  #undef KVM_GOVERNED_X86_FEATURE
> > >  #undef KVM_GOVERNED_FEATURE
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 9409753f45b0..fd5893b3a2c8 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -7765,6 +7765,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
> > >  
> > >  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
> > > +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
> > > +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_IBT);
> > >  
> > >  	vmx_setup_uret_msrs(vmx);
> > >  
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> > 
> > PS: IMHO The whole 'governed feature framework' is very confusing and
> > somewhat poorly documented.
> > 
> > Currently the only partial explanation of it, is at 'governed_features',
> > which doesn't explain how to use it.
> 
> To be honest, terrible name aside, I thought kvm_governed_feature_check_and_set()
> would be fairly self-explanatory, at least relative to all the other CPUID handling
> in KVM.

What is not self-explanatory is what are the governed_feature and how to query them.

> 
> > For the reference this is how KVM expects governed features to be used in the
> > common case (there are some exceptions to this but they are rare)
> > 
> > 1. If a feature is not enabled in host CPUID or KVM doesn't support it, 
> >    KVM is expected to not enable it in KVM cpu caps.
> > 
> > 2. Userspace uploads guest CPUID.
> > 
> > 3. After the guest CPUID upload, the vendor code calls
> >    kvm_governed_feature_check_and_set() which sets governed features = True iff
> >    feature is supported in both kvm cpu caps and in guest CPUID.
> > 
> > 4. kvm/vendor code uses 'guest_can_use()' to query the value of the governed
> >    feature instead of reading guest CPUID.
> > 
> > It might make sense to document the above somewhere at least.
> > 
> > Now about another thing I am thinking:
> > 
> > I do know that the mess of boolean flags that svm had is worse than these
> > governed features and functionality wise these are equivalent.
> > 
> > However thinking again about the whole thing: 
> > 
> > IMHO the 'governed features' is another quite confusing term that a KVM
> > developer will need to learn and keep in memory.
> 
> I 100% agree, but I explicitly called out the terrible name in the v1 and v2
> cover letters[1][2], and the patches were on the list for 6 months before I
> applied them.  I'm definitely still open to a better name, but I'm also not
> exactly chomping at the bit to get behind the bikehsed.

Honestly I don't know if I can come up with a better name either.
Name is IMHO not the underlying problem, its the feature itself that is confusing.

> 
> v1:
>  : Note, I don't like the name "governed", but it was the least awful thing I
>  : could come up with.  Suggestions most definitely welcome.
> 
> v2:
>  : Note, I still don't like the name "governed", but no one has suggested
>  : anything else, let alone anything better :-)
> 
> 
> [1] https://lore.kernel.org/all/20230217231022.816138-1-seanjc@google.com
> [2] https://lore.kernel.org/all/20230729011608.1065019-1-seanjc@google.com
> 
> > Because of that, can't we just use guest CPUID as a single source of truth
> > and drop all the governed features code?
> 
> No, not without a rather massive ABI break.  To make guest CPUID the single source
> of true, KVM would need to modify guest CPUID to squash features that userspace
> has set, but that are not supported by hardware.  And that is most definitely a
> can of worms I don't want to reopen, e.g. see the mess that got created when KVM
> tried to "help" userspace by mucking with VMX capability MSRs in response to
> CPUID changes.


> 
> There aren't many real use cases for advertising "unsupported" features via guest
> CPUID, but there are some, and I have definitely abused KVM_SET_CPUID2 for testing
> purposes.
> 
> And as above, that doesn't work for X86_FEATURE_XSAVES or X86_FEATURE_GBPAGES.
> 
> We'd also have to overhaul guest CPUID lookups to be significantly faster (which
> is doable), as one of the motiviations for the framework was to avoid the overhead
> of looking through guest CPUID without needing one-off boolean fields.
> 
> > In most cases, when the governed feature value will differ from the guest
> > CPUID is when a feature is enabled in the guest CPUID, but not enabled in the
> > KVM caps.
> > 
> > I do see two exceptions to this: XSAVES on AMD and X86_FEATURE_GBPAGES, in
> > which the opposite happens, governed feature is enabled, even when the
> > feature is hidden from the guest CPUID, but it might be better from
> > readability wise point, to deal with these cases manually and we unlikely to
> > have many new such cases in the future.
> > 
> > So for the common case of CPUID mismatch, when the governed feature is
> > disabled but guest CPUID is enabled, does it make sense to allow this? 
> 
> Yes and no.  For "governed features", probably not.  But for CPUID as a whole, there
> are legimiate cases where userspace needs to enumerate things that aren't officially
> "supported" by KVM.  E.g. topology, core crystal frequency (CPUID 0x15), defeatures
> that KVM hasn't yet learned about, features that don't have virtualization controls
> and KVM hasn't yet learned about, etc.  And for things like Xen and Hyper-V paravirt
> features, it's very doable to implement features that are enumerate by CPUID fully
> in userspace, e.g. using MSR filters.
> 
> But again, it's a moot point because KVM has (mostly) allowed userspace to fully
> control guest CPUID for a very long time.
> 
> > Such a feature which is advertised as supported but not really working is a
> > recipe of hard to find guest bugs IMHO.
> > 
> > IMHO it would be much better to just check this condition and do
> > kvm_vm_bugged() or something in case when a feature is enabled in the guest
> > CPUID but KVM can't support it, and then just use guest CPUID in
> > 'guest_can_use()'.

OK, I won't argue that much over this, however I still think that there are
better ways to deal with it.

If we put optimizations aside (all of this can surely be optimized such as to
have very little overhead)

How about we have 2 cpuids: Guest visible CPUID which KVM will never use directly
other than during initialization and effective cpuid which is roughly
what governed features are, but will include all features and will be initialized
roughly like governed features are initialized:

effective_cpuid = guest_cpuid & kvm_supported_cpuid 

Except for some forced overrides like for XSAVES and such.

Then we won't need to maintain a list of governed features, and guest_can_use()
for all features will just return the effective cpuid leafs.

In other words, I want KVM to turn all known CPUID features to governed features,
and then remove all the mentions of governed features except 'guest_can_use'
which is a good API.

Such proposal will use a bit more memory but will make it easier for future
KVM developers to understand the code and have less chance of introducing bugs.

Best regards,
	Maxim Levitsky



> 
> Maybe, if we were creating KVM from scratch, e.g. didn't have to worry about
> existing uesrspace behavior and could implement a more forward-looking API than
> KVM_GET_SUPPORTED_CPUID.  But even then the enforcement would need to be limited
> to "pure" hardware-defined feature bits, and I suspect that there would still be
> exceptions.  And there would likely be complexitly in dealing with CPUID leafs
> that are completely unknown to KVM, e.g. unless KVM completely disallowed non-zero
> values for unknown CPUID leafs, adding restrictions when a feature is defined by
> Intel or AMD would be at constant risk of breaking userspace.
> 



