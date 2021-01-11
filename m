Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E07C2F1D27
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731782AbhAKRzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730148AbhAKRzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 12:55:06 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CAFC061794
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 09:54:26 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m6so379253pfm.6
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 09:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XZK48QQkN7RA/sEENBWwlUGiy2uTgtWa4ATvegDKvSs=;
        b=aEZcEqf4OGBNlRjjwVWr69Hps/SK9P4rbPeLlf8LadRkkLQOovL9a1lBLUoK+NQB3L
         1/b4OaGa/dComerO+eBsVvy7IB3niugBqtCqc3f1+qJAQZM5IqPPjYsKPI+2KJr/uOFg
         PPSxqmDlKhvzk/5Lj6u92OuxIghkme4+SKNAB+FQmHsAiDrMSE6WU/j/bhnc8bFJS42K
         D9XSlWW9z2OLTXa0d53C8XnQPAfKLYAz1RMUHf1GSKBq5fCUoPM/Rf6XkgFS5yZ/wLYN
         ZKco7rnOaplGHqjjM+zU02mV9+s5i2cgJ5WV/pXdrCe5D6BdhOTPypRWKyiIGaNAgUKk
         1b7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XZK48QQkN7RA/sEENBWwlUGiy2uTgtWa4ATvegDKvSs=;
        b=sb5COr/D8XwuANZJrZIm66Q2Oxs67RlFXVC0mtRs5fhz9M1vusGtFK70lceoeTmboQ
         bjMSxxCxB6doUKNi10e+wzZLraI8jkHLaRgpn3IeuKcK8tF67DUeB2YOzu7fnzsTSQEH
         tT1ZWwtjIZa/ogHO8hZZY0kR8XBHV5owhok6E1sOEjMB3dVaycsoXH478nfuXONHRlL7
         dxhBf0APGIsebreC8T6mKD3LR8gV724pvnpMIZ4ifdthXikl+GdwQX3CHVhuindX0eRx
         veTFRmXtlRgZ7Fvpp+bSEHxHPtVOEn81fk2SVJd+BW9zcOPHfkCwikA0GOAhsd7Zi60m
         D0kQ==
X-Gm-Message-State: AOAM533geZwIoTzJZZ/Eirc3q6c0fTjmv5DU3tigbfHi2pwVIJ7S8yKr
        2juJ4E2U0Ee8dIZ21bs1LvZfjg==
X-Google-Smtp-Source: ABdhPJztDbUBmlhXsgvntTJYjVR3Va3PSFpz1zDXPImRo+aUglquL+8zCV1/sxXJ6CG/O5dCCHDOhw==
X-Received: by 2002:a63:cf06:: with SMTP id j6mr634537pgg.195.1610387665245;
        Mon, 11 Jan 2021 09:54:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id f9sm257059pfa.41.2021.01.11.09.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:54:24 -0800 (PST)
Date:   Mon, 11 Jan 2021 09:54:17 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <X/yQyUx4+veuSO0e@google.com>
References: <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
 <20210106221527.GB24607@zn.tnic>
 <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
 <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
 <20210109011939.GL4042@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109011939.GL4042@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 09, 2021, Borislav Petkov wrote:
> On Fri, Jan 08, 2021 at 03:55:52PM -0800, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > index dc921d76e42e..21f92d81d5a5 100644
> > --- a/arch/x86/kvm/cpuid.h
> > +++ b/arch/x86/kvm/cpuid.h
> > @@ -7,7 +7,25 @@
> >  #include <asm/processor.h>
> >  #include <uapi/asm/kvm_para.h>
> > 
> > -extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
> > +/*
> > + * Hardware-defined CPUID leafs that are scattered in the kernel, but need to
> > + * be directly by KVM.  Note, these word values conflict with the kernel's
> > + * "bug" caps, but KVM doesn't use those.
> 
> This feels like another conflict waiting to happen if KVM decides to use
> them at some point...

Yes, but KVM including the bug caps in kvm_cpu_caps is extremely unlikely, and
arguably flat out wrong.  Currently, kvm_cpu_caps includes only CPUID-based
features that can be exposed direcly to the guest.  I could see a scenario where
KVM exposed "bug" capabilities to the guest via a paravirt interface, but I
would expect that KVM would either filter and expose the kernel's bug caps
without userspace input, or would add a KVM-defined paravirt CPUID leaf to
enumerate the caps and track _that_ in kvm_cpu_caps.

Anyways, I agree that overlapping the bug caps it's a bit of unnecessary
cleverness.  I'm not opposed to incorporating NBUGINTS into KVM, but that would
mean explicitly pulling in even more x86_capability implementation details.

> So let me get this straight: KVM wants to use X86_FEATURE_* which
> means, those numbers must map to the respective words in its CPUID caps
> representation kvm_cpu_caps, AFAICT.

That part is deliberate and isn't a dependency so much as how things are
implemented.  The true dependency is on the bit offsets within each word.  The
kernel could completely rescramble the word numbering and KVM would chug along
happily.  What KVM won't play nice with is if the kernel broke up a hardware-
defined, gathered CPUID leaf/word into scattered features spread out amongst
multiple Linux-defined words.

> Then, it wants the leafs to correspond to the hardware leafs layout so
> that it can do:
> 
> 	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
> 
> which comes straight from CPUID.
> 
> So lemme look at one word:
> 
>         kvm_cpu_cap_mask(CPUID_1_EDX,
>                 F(FPU) | F(VME) | F(DE) | F(PSE) |
>                 F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> 		...
> 
> 
> it would build the bitmask of the CPUID leaf using X86_FEATURE_* bits
> and then mask it out with the hardware leaf read from CPUID.
> 
> But why?
> 
> Why doesn't it simply build those leafs in kvm_cpu_caps from the leafs
> we've already queried?
> 
> Oh it does so a bit earlier:
> 
>         memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
>                sizeof(kvm_cpu_caps));
> 
> and that kvm_cpu_cap_mask() call is to clear some bits in kvm_cpu_caps
> which is kvm-specific thing (not supported stuff etc).
> 
> But then why does kvm_cpu_cap_mask() does cpuid_count()? Didn't it just
> read the bits from boot_cpu_data.x86_capability? And those bits we do
> query and massage extensively during boot. So why does KVM needs to
> query CPUID again instead of using what we've already queried?

It's mostly historical; before the kvm_cpu_caps concept was introduced, the code
had grown organically to include both boot_cpu_data and raw CPUID info.  The
vast, vast majority of the time, doing CPUID is likely redundant.  But, as noted
in commit d8577a4c238f ("KVM: x86: Do host CPUID at load time to mask KVM cpu
caps"), the code is quite cheap and runs once at KVM load.  My argument back
then was, and still is, that an extra bit of paranoia is justified since the
code and operations are quite nearly free.

This particular dependency can be broken, and quite easily at that.  Rather than
memcpy() boot_cpu_data.x86_capability, it's trivially easy to redefine the F()
macro to invoke boot_cpu_has(), which would allow dropping the memcpy().  The
big downside, and why I didn't post the code, is that doing so means every
feature routed through F() requires some form of BT+Jcc (or CMOVcc) sequence,
whereas the mempcy() approach allows the F() features to be encoded as a single
literal by the compiler.

From a latency perspective, the extra code is negligible.  The big issue is that
all those extra checks add 2k+ bytes of code.  Eliminating the mempcy() doesn't
actually break KVM's dependency on the bit offsets, so we'd be bloating kvm.ko
by a noticeable amount without providing substantial value.

And, this behavior is mostly opportunistic; the true justification/motiviation
for taking a dependency on the X86_FEATURE_* bit offsets is for communication
with userspace, querying the guest CPU model, and runtime checks.

> Maybe I'm missing something kvm-specific.
> 
> In any case, this feels somewhat weird: you have *_cpu_has() on
> baremetal abstracting almost completely from CPUID by collecting all
> feature bits it needs into its own structure - x86_capability[] along
> with accessors for it - and then you want to "abstract back" to CPUID
> leafs from that interface. I wonder why.

It's effectively for communication with userspace.  Userspace, via ioctl(),
dictates the vCPU model to KVM, including the exact CPUID results.  to properly
virtualize/emulate the defined vCPU model, KVM must query the dictated CPUID
results to determine what features are supported, what guest operations
should fault, etc...  E.g. if the vCPU model, via CPUID, states that SMEP isn't
supported then KVM needs to inject a #GP if the guest attempts to set CR4.SMEP.

KVM also uses the hardware-defined CPUID ABI to advertise which features are
supported by both hardware and KVM.  This is the kvm_cpu_cap stuff, where KVM
reads boot_cpu_data to see what features were enabled by the kernel.

It would be possible for KVM to break the dependency on X86_FEATURE_* bit
offsets by defining a translation layer, but I strongly feel that adding manual
translations will do more harm than good as it increases the odds of us botching
a translation or using the wrong feature flag, creates potential namespace
conflicts, etc...
