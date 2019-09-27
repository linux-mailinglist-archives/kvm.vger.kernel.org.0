Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74C0C0A51
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 19:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfI0R0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 13:26:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40433 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfI0R0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 13:26:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so6376042wmj.5
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 10:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kihNAJEY2Qp1rCpK/bfh6FKe8MMSTNYHDOnUQ94UjuM=;
        b=FDf97l1FEWMrTUbb/ejWjCkghqwkh9A3g4e9uT3gSKKE/QgHjHRHljS57CEhVpjZ1b
         M55XHrgXNJnT3ZUb4KwZIYyqSy2LCrkhvn4FXnGD5UwMZ5SP07YlTzrA18C3LklDp/WF
         n98IGDw+6AwpLmsNihKxJKKMfRzBJ44tg8gjDu/K9IKuW53rV2CFDJYfrsaV/KC1FGz7
         vMOBVi4vrHKBK6dGwDlwBpMLpd3f1OFsqn2Gqmd3fqvZsNQa0h8HjA5ZGw6o2LBAUKhQ
         Z8zzoc1XkyF/6lBMpYSI+jYOFcYG8yBwX7mBFLAXoarloWK7p5RHUWOY0MFu1414VQk7
         ZG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kihNAJEY2Qp1rCpK/bfh6FKe8MMSTNYHDOnUQ94UjuM=;
        b=jS09cSLr5C4KJWYxn3lGKHu00YiZ5LIAIcyJ2fFHjbL3EzA0bisUCvULOlEFxKsY1A
         pN8HiE3cDzPP+Tbr6gTBeIjK8y/4r4fgpGknpejPxyNxxm1Zs/G7izN6JS6t09YuDghf
         syAe66YbpXyEVwZC71ljaNSCRdOThle2sg1IQeiw6aSOz0axtjQhuj+pa/2dVKlvkDeE
         2EoyBsBc9+IJVFkkeA6KbdvKgbPoLA5fki6qNGzrYG3SE6gl4CktgO7DqCegEy4nbuaK
         LUETf646VolAit2of221XKPqIfWOLewLWxWqtHWDsPBpR0ly+1eWIf1T79L/fVo6tK4E
         aTqg==
X-Gm-Message-State: APjAAAUIJ0XDfocGqTCs1mkRWdsRDbLHzLKYElN4JVYUz+hPsiDlBeH5
        VkdiGAPG812Yaj/NQwd5268GQFupiqHW4GyCBu3t1g==
X-Google-Smtp-Source: APXvYqyqsG76q/ohMFUwvEYGSgNMNnpbavExoIkHKunbZ1LPerwEMB6cPNyY07PrU1hb0TziDpWhou277yNwh5zt7tU=
X-Received: by 2002:a1c:c1cc:: with SMTP id r195mr8556234wmf.50.1569605199948;
 Fri, 27 Sep 2019 10:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com> <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com> <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com> <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com> <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
 <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com>
In-Reply-To: <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 10:26:27 -0700
Message-ID: <CALMp9eThXVWxqfxmq7HqPmKokrN0EXzO6WWAq0YXW03FU8f-2A@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 9:32 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/09/19 18:10, Jim Mattson wrote:
> > On Fri, Sep 27, 2019 at 9:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 27/09/19 17:58, Xiaoyao Li wrote:
> >>> Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
> >>> they are free from different guest configuration since they're initialized when
> >>> kvm module is loaded.
> >>>
> >>> Even though some MSRs are not exposed to guest by clear their related cpuid
> >>> bits, they are still saved/restored by QEMU in the same fashion.
> >>>
> >>> I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?
> >>
> >> We can add a per-VM version too, yes.
>
> There is one problem with that: KVM_SET_CPUID2 is a vCPU ioctl, not a VM
> ioctl.
>
> > Should the system-wide version continue to list *some* supported MSRs
> > and *some* unsupported MSRs, with no rhyme or reason? Or should we
> > codify what that list contains?
>
> The optimal thing would be for it to list only MSRs that are
> unconditionally supported by all VMs and are part of the runtime state.
>  MSRs that are not part of the runtime state, such as the VMX
> capabilities, should be returned by KVM_GET_MSR_FEATURE_INDEX_LIST.
>
> This also means that my own commit 95c5c7c77c06 ("KVM: nVMX: list VMX
> MSRs in KVM_GET_MSR_INDEX_LIST", 2019-07-02) was incorrect.
> Unfortunately, that commit was done because userspace (QEMU) has a
> genuine need to detect whether KVM is new enough to support the
> IA32_VMX_VMFUNC MSR.
>
> Perhaps we can make all MSRs supported unconditionally if
> host_initiated.  For unsupported performance counters it's easy to make
> them return 0, and allow setting them to 0, if host_initiated (BTW, how
> did you pick 32?  is there any risk of conflicts with other MSRs?).
>
> I'm not sure of the best set of values to allow for VMX caps, especially
> with the default0/default1 stuff going on for execution controls.  But
> perhaps that would be the simplest thing to do.
>
> One possibility would be to make a KVM_GET_MSR_INDEX_LIST variant that
> is a system ioctl and takes a CPUID vector.  I'm worried that it would
> be tedious to get right and hardish to keep correct---so I'm not sure
> it's a good idea.

Even worse, CPUID alone isn't sufficient. For example, according to
the SDM, "The IA32_VMX_VMFUNC MSR exists only on processors that
support the 1-setting of the 'activate secondary controls'
VM-execution control (only if bit 63 of the IA32_VMX_PROCBASED_CTLS
MSR is 1) and the 1-setting of the 'enable VM functions' secondary
processor-based VM-execution control (only if bit 45 of the
IA32_VMX_PROCBASED_CTLS2 MSR is 1)."
