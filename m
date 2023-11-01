Return-Path: <kvm+bounces-321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF477DE3FD
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 16:47:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEBAE1C20D7C
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 15:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB24414A8A;
	Wed,  1 Nov 2023 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8f5o18b"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC1010796
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 15:47:13 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C205A1A3
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 08:46:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9cb10a5d44so3517917276.0
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 08:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698853614; x=1699458414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+gmfEwDq9YKbn0e9zNhr6JroCC1Q/o4VCtKw/NJY+XI=;
        b=R8f5o18bZMfb+Mujd5yu7bloi3yblWuXh53i6ZvNzS7+BhzU0VrifCKiPIJnSIMxLl
         /IFFOhaWEQGz751e8hhiUtDhQsRnwpTrW3oV5BBZsivBoUlwhSD5ccQ8OAf13p6YVfBx
         a1FHXRo7EtfUYAlCa8E6nqDpPP5NIP17YppMxFhCpyaUPzDGkL2F6Ri+qNRvatCSLKo2
         euwd11vg2nTUeqkKX0iHbn/wbDs4r1tE3RjkZjtQQes04hToH327VxdEz7PLkBX/jqJH
         LdxhvcCUfIL31/tywkl+TQAcghyUULIKk9FjRCLIE5S16//mEBaMgpgVgezBdlL2kbkb
         Tvcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698853614; x=1699458414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gmfEwDq9YKbn0e9zNhr6JroCC1Q/o4VCtKw/NJY+XI=;
        b=ej1Fv3dDPi5FPc0a4HGlefvvZiKege9lpsEz1AQgmE4vMxDq//HBeVUJe/JyEPmV4R
         gr24Mz9sJbCOwwUhyESu26r9jcxg5bE9scIR50WKBcgtXp0L7eICURaww6X+AMEiHycd
         CXOKqV3ErcHEfXzmq35HbnKQovtsKP0WfiazQ4eBVqfyTM+50cNCBPdyPVoM/NTUD69c
         WVtamv+V7QJ2JcucDkNyPtxD/XJ83tWHij3Wb/G+flmemR0oFeB224ZmMv8bvARxcjlg
         aMNRkV/CbIhyGyEyDCPbqWZm7a/9jzFrJ2KhrMEy4f+rR16gIqMdfHE5DRZHvqFxucBe
         oVjQ==
X-Gm-Message-State: AOJu0Yz5Jjx4MAUE/qZWid64y7SGHQ4HswuJE8/3UZq+fcqFBfDmGgZE
	vpCjhSpgTu5CFLPO9jP3vDU8XsKCuew=
X-Google-Smtp-Source: AGHT+IEBt0uSJewyoJrLLtdvjctQO/o9X0wlbeyTNS63E5GY+2uUI42JULOEN/0uLDWjZChmRx92eHbGuic=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aac6:0:b0:d9a:5349:4bdd with SMTP id
 t64-20020a25aac6000000b00d9a53494bddmr316853ybi.8.1698853613847; Wed, 01 Nov
 2023 08:46:53 -0700 (PDT)
Date: Wed, 1 Nov 2023 08:46:52 -0700
In-Reply-To: <ea3609bf7c7759b682007042b98191d91d10a751.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-19-weijiang.yang@intel.com> <ea3609bf7c7759b682007042b98191d91d10a751.camel@redhat.com>
Message-ID: <ZUJy7A5Hp6lnZVyq@google.com>
Subject: Re: [PATCH v6 18/25] KVM: x86: Use KVM-governed feature framework to
 track "SHSTK/IBT enabled"
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > Use the governed feature framework to track whether X86_FEATURE_SHSTK
> > and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
> > the features can be used iff both KVM and guest CPUID can support them.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/governed_features.h | 2 ++
> >  arch/x86/kvm/vmx/vmx.c           | 2 ++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> > index 423a73395c10..db7e21c5ecc2 100644
> > --- a/arch/x86/kvm/governed_features.h
> > +++ b/arch/x86/kvm/governed_features.h
> > @@ -16,6 +16,8 @@ KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
> >  KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
> >  KVM_GOVERNED_X86_FEATURE(VGIF)
> >  KVM_GOVERNED_X86_FEATURE(VNMI)
> > +KVM_GOVERNED_X86_FEATURE(SHSTK)
> > +KVM_GOVERNED_X86_FEATURE(IBT)
> >  
> >  #undef KVM_GOVERNED_X86_FEATURE
> >  #undef KVM_GOVERNED_FEATURE
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9409753f45b0..fd5893b3a2c8 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7765,6 +7765,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
> >  
> >  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
> > +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
> > +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_IBT);
> >  
> >  	vmx_setup_uret_msrs(vmx);
> >  
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> 
> PS: IMHO The whole 'governed feature framework' is very confusing and
> somewhat poorly documented.
>
> Currently the only partial explanation of it, is at 'governed_features',
> which doesn't explain how to use it.

To be honest, terrible name aside, I thought kvm_governed_feature_check_and_set()
would be fairly self-explanatory, at least relative to all the other CPUID handling
in KVM.

> For the reference this is how KVM expects governed features to be used in the
> common case (there are some exceptions to this but they are rare)
> 
> 1. If a feature is not enabled in host CPUID or KVM doesn't support it, 
>    KVM is expected to not enable it in KVM cpu caps.
> 
> 2. Userspace uploads guest CPUID.
> 
> 3. After the guest CPUID upload, the vendor code calls
>    kvm_governed_feature_check_and_set() which sets governed features = True iff
>    feature is supported in both kvm cpu caps and in guest CPUID.
>
> 4. kvm/vendor code uses 'guest_can_use()' to query the value of the governed
>    feature instead of reading guest CPUID.
> 
> It might make sense to document the above somewhere at least.
>
> Now about another thing I am thinking:
> 
> I do know that the mess of boolean flags that svm had is worse than these
> governed features and functionality wise these are equivalent.
> 
> However thinking again about the whole thing: 
> 
> IMHO the 'governed features' is another quite confusing term that a KVM
> developer will need to learn and keep in memory.

I 100% agree, but I explicitly called out the terrible name in the v1 and v2
cover letters[1][2], and the patches were on the list for 6 months before I
applied them.  I'm definitely still open to a better name, but I'm also not
exactly chomping at the bit to get behind the bikehsed.

v1:
 : Note, I don't like the name "governed", but it was the least awful thing I
 : could come up with.  Suggestions most definitely welcome.

v2:
 : Note, I still don't like the name "governed", but no one has suggested
 : anything else, let alone anything better :-)


[1] https://lore.kernel.org/all/20230217231022.816138-1-seanjc@google.com
[2] https://lore.kernel.org/all/20230729011608.1065019-1-seanjc@google.com

> Because of that, can't we just use guest CPUID as a single source of truth
> and drop all the governed features code?

No, not without a rather massive ABI break.  To make guest CPUID the single source
of true, KVM would need to modify guest CPUID to squash features that userspace
has set, but that are not supported by hardware.  And that is most definitely a
can of worms I don't want to reopen, e.g. see the mess that got created when KVM
tried to "help" userspace by mucking with VMX capability MSRs in response to
CPUID changes.

There aren't many real use cases for advertising "unsupported" features via guest
CPUID, but there are some, and I have definitely abused KVM_SET_CPUID2 for testing
purposes.

And as above, that doesn't work for X86_FEATURE_XSAVES or X86_FEATURE_GBPAGES.

We'd also have to overhaul guest CPUID lookups to be significantly faster (which
is doable), as one of the motiviations for the framework was to avoid the overhead
of looking through guest CPUID without needing one-off boolean fields.

> In most cases, when the governed feature value will differ from the guest
> CPUID is when a feature is enabled in the guest CPUID, but not enabled in the
> KVM caps.
> 
> I do see two exceptions to this: XSAVES on AMD and X86_FEATURE_GBPAGES, in
> which the opposite happens, governed feature is enabled, even when the
> feature is hidden from the guest CPUID, but it might be better from
> readability wise point, to deal with these cases manually and we unlikely to
> have many new such cases in the future.
> 
> So for the common case of CPUID mismatch, when the governed feature is
> disabled but guest CPUID is enabled, does it make sense to allow this? 

Yes and no.  For "governed features", probably not.  But for CPUID as a whole, there
are legimiate cases where userspace needs to enumerate things that aren't officially
"supported" by KVM.  E.g. topology, core crystal frequency (CPUID 0x15), defeatures
that KVM hasn't yet learned about, features that don't have virtualization controls
and KVM hasn't yet learned about, etc.  And for things like Xen and Hyper-V paravirt
features, it's very doable to implement features that are enumerate by CPUID fully
in userspace, e.g. using MSR filters.

But again, it's a moot point because KVM has (mostly) allowed userspace to fully
control guest CPUID for a very long time.

> Such a feature which is advertised as supported but not really working is a
> recipe of hard to find guest bugs IMHO.
> 
> IMHO it would be much better to just check this condition and do
> kvm_vm_bugged() or something in case when a feature is enabled in the guest
> CPUID but KVM can't support it, and then just use guest CPUID in
> 'guest_can_use()'.

Maybe, if we were creating KVM from scratch, e.g. didn't have to worry about
existing uesrspace behavior and could implement a more forward-looking API than
KVM_GET_SUPPORTED_CPUID.  But even then the enforcement would need to be limited
to "pure" hardware-defined feature bits, and I suspect that there would still be
exceptions.  And there would likely be complexitly in dealing with CPUID leafs
that are completely unknown to KVM, e.g. unless KVM completely disallowed non-zero
values for unknown CPUID leafs, adding restrictions when a feature is defined by
Intel or AMD would be at constant risk of breaking userspace.

