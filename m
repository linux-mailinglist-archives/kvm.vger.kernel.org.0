Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C147A0F9E
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 23:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjINVNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjINVNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 17:13:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF9D26B2
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 14:13:03 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81a76a11eeso896742276.3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 14:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694725982; x=1695330782; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YWn+iYLCIPAaljxTAu+WVnTCSLTqlK32IcDZuLI0g0M=;
        b=wL1o/q4BCXCtRvbEtrI/BOVIfJbYEavLefKV/WVTSKB/o1139vhSnH3AdGghuMPQq4
         0vGjdsjmL1ApT+lTcUgKu7G8Bx/P3iMqeLMb9Gf7/SI7krnw/qmq64aRXUm7lbWgZdZq
         U+RfURxoDPxPWRUKS9o4aAvE3VPg+7Suk6LKh/OCMhS0czAxARKjbln8KK00XuTPVzML
         ZjKPlWEP/GKQCF+acm8OvSgXtScHnYiuvHXw5Oxot9SX+GvGxKGdTJF7CANqTJUnwHZ0
         zD3+5hRzqk0p/6Qq18T0f2Uz+5s3OchIlDDreP1MQnhgHeQ4XxovkWuvVIG0gQcL/jVj
         jdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694725982; x=1695330782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YWn+iYLCIPAaljxTAu+WVnTCSLTqlK32IcDZuLI0g0M=;
        b=YywbQ2hZ30FD3BBF455ouT4f9bBzGHllWjIBeK0ZTNGlzo2u2RkJI3+4hJzMrnuc3G
         barc5yWhNT1qCHkTQ6HrihI8RxI8B0IJD8mpWvhtHARBJVDjRaDnQKC1vdD2jb82dp2A
         mWmFEwsb0mKafIM9fv9V9ydJpjLgBeSEaVuo2pfGFFOL8qtDVCBdIUmIApguCkoXpwFp
         7GaQZPizR/xo3oFitX00jXgPRAyVhlw+hMWed+t/98j03t/QMpmLPrS3fg13j3uDgFsI
         KhJqB2Wbm0QJnIZ4ewTHIc/CG35v2z+h5/zRz+67Wk6Fhtl0DBHkmpQmXL020InUvnGc
         vu4Q==
X-Gm-Message-State: AOJu0YzjjwU8FzLVSiCzCfo58vPytbS3G3I120R5lhtvF6EJ45J7Co6D
        Fc3MRRqx0lZVbigAFk+GY7Pv4EmpG/Y=
X-Google-Smtp-Source: AGHT+IHUX88Dl7zdyWRqWv7GNZ3j9/vn8QPn/8bKSqAChRlqrniiHB31EofcnWXeLao+6RSFKGDhpfO0HTY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:571:b0:d7f:d239:596 with SMTP id
 a17-20020a056902057100b00d7fd2390596mr176100ybt.0.1694725982701; Thu, 14 Sep
 2023 14:13:02 -0700 (PDT)
Date:   Thu, 14 Sep 2023 14:13:01 -0700
In-Reply-To: <f2c0907c-9e30-e01b-7d65-a20e6be4bf49@amd.com>
Mime-Version: 1.0
References: <cover.1694721045.git.thomas.lendacky@amd.com> <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
 <ZQNs7uo8F62XQawJ@google.com> <f2c0907c-9e30-e01b-7d65-a20e6be4bf49@amd.com>
Message-ID: <ZQN3Xbi5bEqlSkY3@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix TSC_AUX virtualization setup
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023, Tom Lendacky wrote:
> On 9/14/23 15:28, Sean Christopherson wrote:
> > On Thu, Sep 14, 2023, Tom Lendacky wrote:
> > > The checks for virtualizing TSC_AUX occur during the vCPU reset processing
> > > path. However, at the time of initial vCPU reset processing, when the vCPU
> > > is first created, not all of the guest CPUID information has been set. In
> > > this case the RDTSCP and RDPID feature support for the guest is not in
> > > place and so TSC_AUX virtualization is not established.
> > > 
> > > This continues for each vCPU created for the guest. On the first boot of
> > > an AP, vCPU reset processing is executed as a result of an APIC INIT
> > > event, this time with all of the guest CPUID information set, resulting
> > > in TSC_AUX virtualization being enabled, but only for the APs. The BSP
> > > always sees a TSC_AUX value of 0 which probably went unnoticed because,
> > > at least for Linux, the BSP TSC_AUX value is 0.
> > > 
> > > Move the TSC_AUX virtualization enablement into the vcpu_after_set_cpuid()
> > > path to allow for proper initialization of the support after the guest
> > > CPUID information has been set.
> > > 
> > > Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
> > > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > > ---
> > >   arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++--------
> > >   arch/x86/kvm/svm/svm.c |  3 +++
> > >   arch/x86/kvm/svm/svm.h |  1 +
> > >   3 files changed, 23 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index b9a0a939d59f..565c9de87c6d 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -2962,6 +2962,25 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
> > >   				    count, in);
> > >   }
> > > +static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
> > 
> > I would rather name this sev_es_after_set_cpuid() and call it directly from
> > svm_vcpu_after_set_cpuid().  Or I suppose bounce through sev_after_set_cpuid(),
> > but that seems gratuitous.
> 
> There is a sev_guest() check in svm_vcpu_after_set_cpuid(), so I can move
> that into sev_vcpu_after_set_cpuid() and keep the separate
> sev_es_vcpu_after_set_cpuid().

Works for me.

> And it looks like you would prefer to not have "vcpu" in the function name?
> Might be better search-wise if vcpu remains part of the name?

Oh, that was just a typo/oversight, not intentional.

> > AFAICT, there's no point in calling this from init_vmcb(); guest_cpuid_has() is
> > guaranteed to be false when called during vCPU creation and so the intercept
> > behavior will be correct, and even if SEV-ES called init_vmcb() from
> > shutdown_interception(), which it doesn't, guest_cpuid_has() wouldn't change,
> > i.e. the intercepts wouldn't need to be changed.
> 
> Ok, I thought that's how it worked, but wasn't 100% sure. I'll move it out
> of the init_vmcb() path.
> 
> > 
> > init_vmcb_after_set_cpuid() is a special snowflake because it handles both SVM's
> > true defaults *and* guest CPUID updates.
> > 
> > > +{
> > > +	struct kvm_vcpu *vcpu = &svm->vcpu;
> > > +
> > > +	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
> > > +	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
> > > +	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
> > 
> > This needs to toggled interception back on if RDTSCP and RDPID are hidden from
> > the guest.  KVM's wonderful ABI doesn't disallow multiple calls to KVM_SET_CPUID2
> > before KVM_RUN.
> 
> Do you want that as a separate patch with the first patch purely addressing
> the current issue? Or combine them?

Hmm, now that you mention it, probably a seperate patch on top.
