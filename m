Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3C64CC848
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiCCVpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiCCVpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:45:12 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6F0ED978
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 13:44:25 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id s203-20020a4a3bd4000000b003191c2dcbe8so7300096oos.9
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 13:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OkdpHld9Mqej9LdERVUsOkeLZ84S2x7OZadvoehTTp0=;
        b=lspq+5WDOLeV8ir3qCRvEOwM8qbE5DAjPdE2pyLwJelZgaQs+PE7MrK4pYHAfdYpe0
         5u6TDpzHTCHTdPtWvnc5a8C1dSktEF7nuBDaSmDgBFuXdVTqE78Z3/zEy/4LdmV655gl
         5d+Vf4lEdo+7NsfQt9XTZcBNhqWk7SFR7sRL3jb58LsZrNr1YieqSaY/uVjN0ok6iLH/
         Gtzv+SJ/l4IsJV75bcgVS+Oj4c0NA5pwiuSmopfxnZh18Qf7FIHI3xRe0TQDqlK1bWGe
         co6GDy5m+Eh6GnplCmivB3ajZ70pT67QFbCaW58uX59bwbLn2EGKoxFDr4GFhD3tJ1H6
         PJig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OkdpHld9Mqej9LdERVUsOkeLZ84S2x7OZadvoehTTp0=;
        b=eufv8eK872jl+qtMONzJsdY4VhmUJ+AMxov1ROZP1+sE0EjzAZkEZ5McEHO/DOhRam
         0uNPvCrIKTD6EVUGDm8WbMuob082cWLF5qNcg1VuprwZAaRz5IyT1gHG45vPqnLaEa94
         DkNUb3E+TcIldoKuFT+1XDdnw4+RaJ9YjF4eqPzHWl5pwKdU0Ct6pXI1WmcePJ0r27EW
         P2zz+MGGy6WbJOdm0mQQL9YczOzD0/2h8bC5YKEA4Fb8Hpl9l1G/LJTs5+ltoN4Q31cM
         nNjaa911uxKFgoRMnYRwC8JZrJjUQ89l6hEkH/ZU2wE7dPczmqwkwd+20GkWtN/p8/r2
         /dVg==
X-Gm-Message-State: AOAM532J3shWFTcKHkIqZ6xkBXyRyAsVf34XxQhc276AqhQg5cmAD9n1
        bttq84BrglID9Q9jWbYBuY88hQrtoMovei0yk5uxGbjVu3jqJQ==
X-Google-Smtp-Source: ABdhPJzYAFnJHkyJBoAoljcVTl3u4ewjNHbPkYy5u5VI8zpUTJQqACiACUPn0z9Zq+25te5WzSrtcCt9hP6544hYM6k=
X-Received: by 2002:a4a:8893:0:b0:31b:fd08:2735 with SMTP id
 j19-20020a4a8893000000b0031bfd082735mr19659155ooa.96.1646343864933; Thu, 03
 Mar 2022 13:44:24 -0800 (PST)
MIME-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com> <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com> <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com> <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com> <Yh/nlOXzIhaMLzdk@google.com>
 <YiAdU+pA/RNeyjRi@google.com> <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
 <YiDps0lOKITPn4gv@google.com>
In-Reply-To: <YiDps0lOKITPn4gv@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Mar 2022 13:44:13 -0800
Message-ID: <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 3, 2022 at 8:15 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> > On 3/3/22 02:43, Sean Christopherson wrote:
> > > > Maybe I can redirect you to a test case to highlight a possible
> > > > regression in KVM, as seen by userspace;-)
> > > Regressions aside, VMCS controls are not tied to CPUID, KVM should not be mucking
> > > with unrelated things.  The original hack was to fix a userspace bug and should
> > > never have been mreged.
> >
> > Note that it dates back to:
> >
> >     commit 5f76f6f5ff96587af5acd5930f7d9fea81e0d1a8
> >     Author: Liran Alon <liran.alon@oracle.com>
> >     Date:   Fri Sep 14 03:25:52 2018 +0300
> >
> >     KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled
> >     Before this commit, KVM exposes MPX VMX controls to L1 guest only based
> >     on if KVM and host processor supports MPX virtualization.
> >     However, these controls should be exposed to guest only in case guest
> >     vCPU supports MPX.
> >
> > It's not to fix a userspace bug, it's to support userspace that doesn't
> > know about using KVM_SET_MSR for VMX features---which is okay since unlike
> > KVM_SET_CPUID2 it's not a mandatory call.
>
> I disagree, IMO failure to properly configure the vCPU model is a userspace bug.
> Maybe it was a userspace bug induced by a haphazard and/or poorly documented KVM
> ABI, but it's still a userspace bug.  One could argue that KVM should disable/clear
> VMX features if userspace clears a related CPUID feature, but _setting_ a VMX
> feature based on CPUID is architecturally wrong.  Even if we consider one or both
> cases to be desirable behavior in terms of creating a consistent vCPU model, forcing
> a consistent vCPU model for this one case goes against every other ioctl in KVM's
> ABI.
>
> If we consider it KVM's responsibility to propagate CPUID state to VMX MSRs, then
> KVM has a bunch of "bugs".
>
>   X86_FEATURE_LM => VM_EXIT_HOST_ADDR_SPACE_SIZE, VM_ENTRY_IA32E_MODE, VMX_MISC_SAVE_EFER_LMA
>
>   X86_FEATURE_TSC => CPU_BASED_RDTSC_EXITING, CPU_BASED_USE_TSC_OFFSETTING,
>                      SECONDARY_EXEC_TSC_SCALING
>
>   X86_FEATURE_INVPCID_SINGLE => SECONDARY_EXEC_ENABLE_INVPCID
>
>   X86_FEATURE_MWAIT => CPU_BASED_MONITOR_EXITING, CPU_BASED_MWAIT_EXITING
>
>   X86_FEATURE_INTEL_PT => SECONDARY_EXEC_PT_CONCEAL_VMX, SECONDARY_EXEC_PT_USE_GPA,
>                           VM_EXIT_CLEAR_IA32_RTIT_CTL, VM_ENTRY_LOAD_IA32_RTIT_CTL
>
>   X86_FEATURE_XSAVES => SECONDARY_EXEC_XSAVES

I don't disagree with you, but this does beg the question, "What's
going on with all of the invocations of cr4_fixed1_update()?"
