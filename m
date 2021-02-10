Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7A63172E4
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 23:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhBJWHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 17:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbhBJWHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 17:07:01 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0A8C06174A
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 14:06:20 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w1so2176020ilm.12
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 14:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iu2xEOFPIf5Cf7y5kNSpQn/KHHFkgG4VitZwu6eya/c=;
        b=L3QsD8eA5i8fPgS+BBV0Zdzf+LXALBAZ1223jIAe6Eyc8bZSYkkDeaV3+vcJj056WD
         YrUHcuf68d/dpYBZJ+5Qa74C7lEME/i3U2RO/I/9x9byWu6b+3dN0rOnnw9pR3TnEtL6
         UFSD+EvFglCXHmS+x7o39IZ+roQuAqHaND6SNYUJT6xIlFLnzQWNVtaS4ddy66iI4Xq6
         OyCYjGYWcJq3lKHJKQ2vftFwggeACreCKBUththZlsukzwsxqF2OiyBa/mOqBP8Hqigy
         nY4EkhA9mx0I4kL8bDWCBVKLGZ09iDgJ/a44c9hQEu8U/u1Et37XiSUU8DgPnjA3CCeJ
         Pm/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iu2xEOFPIf5Cf7y5kNSpQn/KHHFkgG4VitZwu6eya/c=;
        b=MvsrU5fb0Mqxjg5oqDOr1uY6ja0hUXAJpk2SQEPsk3Pttj50sLTZPIN6cqD9m42x5x
         kOmYTA/ogodwMtN8EujnJoDB+ejX+VmH6VLnibzcAi6l+8B5ke7/pRRIt2i2V6UI5nOt
         olqzVstSmRvWPlAgibD1QPFXnyFp88Jvi/LdkohpSTkEkjZc72jRC/OqOxa/Q8OJhLlI
         dGzRIQ68rvhMEIL3K1pfO80OaVcHlvOP88iVty5Ln+nPh1tJZU63e1roDGci1GxX2kUg
         676Fc8g45pjf5CLOqst5tVwAa4jPO6NrIDc3xxj9A5/Ee8evh9UKmoV+kl38mSze8l9m
         f6DA==
X-Gm-Message-State: AOAM533i3+KI7zIlXQDyFFTzstNDIYDW6LS37ahXXOkKblyUCb1398a1
        2KA9Y+zGC4YVrA5Txb3oEkj+6iquP+2NmlLDmziQEA==
X-Google-Smtp-Source: ABdhPJzF6Go2tPyJ2Kgp3gbxb1YfU2x06yZbck/MUCHwtv1iR8wV3jnRJ99+yZbYMIRd8GAbs9e0XTXLUDf3E6RPF94=
X-Received: by 2002:a92:cd8a:: with SMTP id r10mr793625ilb.110.1612994778638;
 Wed, 10 Feb 2021 14:06:18 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612398155.git.ashish.kalra@amd.com> <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
 <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
 <20210205030753.GA26504@ashkalra_ubuntu_server> <CABayD+eVwUsnB9pt+GA92uJis5dEGZ=zcrzraaR8_=YhuLTntg@mail.gmail.com>
 <20210206054617.GA19422@ashkalra_ubuntu_server> <20210206135646.GA21650@ashkalra_ubuntu_server>
 <20210208002858.GA23612@ashkalra_ubuntu_server> <CABayD+dB3fJ-YmZZ2qsP7ud-E+R8McjVmVXB4ER4Dmk18cAvoA@mail.gmail.com>
 <20210210203606.GA30775@ashkalra_ubuntu_server> <CABayD+cXJbRVV-fZFM+8xw3GypTLq=6WUES4ZrLnZEcgchVd9Q@mail.gmail.com>
In-Reply-To: <CABayD+cXJbRVV-fZFM+8xw3GypTLq=6WUES4ZrLnZEcgchVd9Q@mail.gmail.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 10 Feb 2021 14:05:42 -0800
Message-ID: <CABayD+eGYeLNe3jJRhNSdcO69xFzm26T8kk5n4S43zaLL6YH6A@mail.gmail.com>
Subject: Re: [PATCH v10 12/16] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION
 feature & Custom MSR.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 2:01 PM Steve Rutherford <srutherford@google.com> wrote:
>
> Hi Ashish,
>
> On Wed, Feb 10, 2021 at 12:37 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > Hello Steve,
> >
> > We can remove the implicit enabling of this live migration feature
> > from svm_vcpu_after_set_cpuid() callback invoked afer KVM_SET_CPUID2
> > ioctl, and let this feature flag be controlled by the userspace
> > VMM/qemu.
> >
> > Userspace can set this feature flag explicitly by calling the
> > KVM_SET_CPUID2 ioctl and enable this feature whenever it is ready to
> > do so.
> >
> > I have tested this as part of Qemu code :
> >
> > int kvm_arch_init_vcpu(CPUState *cs)
> > {
> > ...
> > ...
> >         c->function = KVM_CPUID_FEATURES | kvm_base;
> >         c->eax = env->features[FEAT_KVM];
> >         c->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> > ...
> > ...
> >
> >     r = kvm_vcpu_ioctl(cs, KVM_SET_CPUID2, &cpuid_data);
> > ...
> >
> > Let me know if this addresses your concerns.
> Removing implicit enablement is one part of the equation.
> The other two are:
> 1) Host userspace being able to ask the kernel if it supports SEV Live Migration
> 2) Host userspace being able to disable access to the MSR/hypercall
>
> Feature flagging for paravirt features is pretty complicated, since
> you need all three parties to negotiate (host userspace/host
> kernel/guest), and every single one has veto power. In the end, the
> feature should only be available to the guest if every single party
> says yes.
>
> For an example of how to handle 1), the new feature flag could be
> checked when asking the kernel which cpuid bits it supports by adding
> it to the list of features that the kernel mentions in
> KVM_GET_SUPPORTED_CPUID.
>
> For example (in KVM's arch/x86/kvm/cpuid.c):
> case KVM_CPUID_FEATURES:
> ==========
> entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
>     (1 << KVM_FEATURE_NOP_IO_DELAY) |
> ...
>     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> +  (1 << KVM_FEATURE_ASYNC_PF_INT) |
> -   (1 << KVM_FEATURE_ASYNC_PF_INT);
> +  (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> ==========
>
> Without this, userspace has to infer if the kernel it is on supports that flag.
>
> For an example of how to handle 2), in the new msr handler, KVM should
> throw a GP `if (!guest_pv_has(vcpu, KVM_FEATURE_SEV_LIVE_MIGRATION))`
> (it can do this by returning th. The issue here is "what if the guest
Correction: (it can do this by returning 1).
