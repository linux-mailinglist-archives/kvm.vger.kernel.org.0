Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5AD4C5679
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 15:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiBZOZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Feb 2022 09:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiBZOZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Feb 2022 09:25:41 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCC395A08
        for <kvm@vger.kernel.org>; Sat, 26 Feb 2022 06:25:06 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id z7so9848204oid.4
        for <kvm@vger.kernel.org>; Sat, 26 Feb 2022 06:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mGLbYD/2nvuQU3bxrB+PQon9DhwpNEkOfLPBNbbaSA0=;
        b=HPfZ0tqpALJXNjZRE/OiJQXvraZ4XX1qn47Ai61jqZ+uDRD+fG7NlDQqXTJ6OVNcKz
         bJNpXfslK4+NbxihXj5QNa1gvtBJmojDBo2AyyB0Xq0pLRzQA9RtTZ4WQox08Uv+8acF
         4MICtEZqy1BW7jpMFsSj6RulzASIVNN1i2H8Cz62QCzPoVm+SpOR0XAqVE+1/Ti8Vu/5
         e3K5gUV+W3SG6ZQ1uqOxni9DNaoDBpNwwTgSeHZdR+48WclYDBEIBi+KE9+PSFvHXRBe
         URhYZPJJ7J6/luMixnOBUBbRlj3E/nfmiICUGk6eV+4ZYMgmGVlVhSoxdvw/fw0EG2Yp
         sVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mGLbYD/2nvuQU3bxrB+PQon9DhwpNEkOfLPBNbbaSA0=;
        b=8MZIxm3tz4klPHsWjELEDpoaH6+u85A+NrETUkj2SwWFietGLMl1ROtANsoTHOi8h4
         sQRV7tKFSDJWkKyD2kOGQCuDi1XZwV8my7NJeWDDucb56RIfJGkhGPblnWV/fhPRd7u0
         VcQgtSvsEWIAsd+vuqOWpV6smZGPeEQ1hNxr1PMVxTucIeH/jl4qFoVYazcr3J/YC0GR
         2O2SVvD1I7jx6MtWZcxfGabWGk+FO8yBPvlk6G2mG/RhtUB8NYr00pKCWZo723N2rhhi
         EN0yVt08+fLbPUl3p04WXaDSvkwL6eyc2Oh9dA6yzdScsTJBvMjpwR0uRyHv+r6SH/1q
         NKlQ==
X-Gm-Message-State: AOAM530dFPfQMci85SiwjhERrIYe+SQyDd4nGlwZzYCBy3rPz3Vm2ojV
        AFggW+lLqNvTmdFNab4QHCX3cXonzSUzRaZsT8s13w==
X-Google-Smtp-Source: ABdhPJwXGABl8/8OLYQ/t3omf3P0lDrz48yCsuYm3SM1WC+ZOwTezPsrmuq4EI8Vaw9MLPlyTCEccwyDuMZJ1TAkqOc=
X-Received: by 2002:a05:6808:1999:b0:2d6:7fe3:10bd with SMTP id
 bj25-20020a056808199900b002d67fe310bdmr4820885oib.68.1645885505692; Sat, 26
 Feb 2022 06:25:05 -0800 (PST)
MIME-Version: 1.0
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
 <CALMp9eT50LjXYSwfWENjmfg=XxT4Bx3RzOYubKty8kr_APXCEw@mail.gmail.com>
 <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com> <6a839b88-392d-886d-836d-ca04cf700dce@intel.com>
 <7859e03f-10fa-dbc2-ed3c-5c09e62f9016@redhat.com> <bcc83b3d-31fe-949a-6bbf-4615bb982f0c@intel.com>
 <CALMp9eT1NRudtVqPuHU8Y8LpFYWZsAB_MnE2BAbg5NY0jR823w@mail.gmail.com>
 <CALMp9eS6cBDuax8O=woSdkNH2e2Y2EodE-7EfUTFfzBvCWCmcg@mail.gmail.com> <71736b9d-9ed4-ea02-e702-74cae0340d66@intel.com>
In-Reply-To: <71736b9d-9ed4-ea02-e702-74cae0340d66@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 26 Feb 2022 06:24:54 -0800
Message-ID: <CALMp9eRwKHa0zdUFtSEBVCwV=MHJ-FmvW1uERxCt+_+Zz4z8fg@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Feb 25, 2022 at 10:24 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 2/26/2022 12:53 PM, Jim Mattson wrote:
> > On Fri, Feb 25, 2022 at 8:25 PM Jim Mattson <jmattson@google.com> wrote:
> >>
> >> On Fri, Feb 25, 2022 at 8:07 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>>
> >>> On 2/25/2022 11:13 PM, Paolo Bonzini wrote:
> >>>> On 2/25/22 16:12, Xiaoyao Li wrote:
> >>>>>>>>
> >>>>>>>
> >>>>>>> I don't like the idea of making things up without notifying userspace
> >>>>>>> that this is fictional. How is my customer running nested VMs supposed
> >>>>>>> to know that L2 didn't actually shutdown, but L0 killed it because the
> >>>>>>> notify window was exceeded? If this information isn't reported to
> >>>>>>> userspace, I have no way of getting the information to the customer.
> >>>>>>
> >>>>>> Then, maybe a dedicated software define VM exit for it instead of
> >>>>>> reusing triple fault?
> >>>>>>
> >>>>>
> >>>>> Second thought, we can even just return Notify VM exit to L1 to tell
> >>>>> L2 causes Notify VM exit, even thought Notify VM exit is not exposed
> >>>>> to L1.
> >>>>
> >>>> That might cause NULL pointer dereferences or other nasty occurrences.
> >>>
> >>> IMO, a well written VMM (in L1) should handle it correctly.
> >>>
> >>> L0 KVM reports no Notify VM Exit support to L1, so L1 runs without
> >>> setting Notify VM exit. If a L2 causes notify_vm_exit with
> >>> invalid_vm_context, L0 just reflects it to L1. In L1's view, there is no
> >>> support of Notify VM Exit from VMX MSR capability. Following L1 handler
> >>> is possible:
> >>>
> >>> a)      if (notify_vm_exit available & notify_vm_exit enabled) {
> >>>                  handle in b)
> >>>          } else {
> >>>                  report unexpected vm exit reason to userspace;
> >>>          }
> >>>
> >>> b)      similar handler like we implement in KVM:
> >>>          if (!vm_context_invalid)
> >>>                  re-enter guest;
> >>>          else
> >>>                  report to userspace;
> >>>
> >>> c)      no Notify VM Exit related code (e.g. old KVM), it's treated as
> >>> unsupported exit reason
> >>>
> >>> As long as it belongs to any case above, I think L1 can handle it
> >>> correctly. Any nasty occurrence should be caused by incorrect handler in
> >>> L1 VMM, in my opinion.
> >>
> >> Please test some common hypervisors (e.g. ESXi and Hyper-V).
> >
> > I took a look at KVM in Linux v4.9 (one of our more popular guests),
> > and it will not handle this case well:
> >
> >          if (exit_reason < kvm_vmx_max_exit_handlers
> >              && kvm_vmx_exit_handlers[exit_reason])
> >                  return kvm_vmx_exit_handlers[exit_reason](vcpu);
> >          else {
> >                  WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_reason);
> >                  kvm_queue_exception(vcpu, UD_VECTOR);
> >                  return 1;
> >          }
> >
> > At least there's an L1 kernel log message for the first unexpected
> > NOTIFY VM-exit, but after that, there is silence. Just a completely
> > inexplicable #UD in L2, assuming that L2 is resumable at this point.
>
> At least there is a message to tell L1 a notify VM exit is triggered in
> L2. Yes, the inexplicable #UD won't be hit unless L2 triggers Notify VM
> exit with invalid_context, which is malicious to L0 and L1.

There is only an L1 kernel log message *the first time*. That's not
good enough. And this is just one of the myriad of possible L1
hypervisors.

> If we use triple_fault (i.e., shutdown), then no info to tell L1 that
> it's caused by Notify VM exit with invalid context. Triple fault needs
> to be extended and L1 kernel needs to be enlightened. It doesn't help
> old guest kernel.
>
> If we use Machine Check, it's somewhat same inexplicable to L2 unless
> it's enlightened. But it doesn't help old guest kernel.
>
> Anyway, for Notify VM exit with invalid context from L2, I don't see a
> good solution to tell L1 VMM it's a "Notify VM exit with invalid context
> from L2" and keep all kinds of L1 VMM happy, especially for those with
> old kernel versions.

I agree that there is no way to make every conceivable L1 happy.
That's why the information needs to be surfaced to the L0 userspace. I
contend that any time L0 kvm violates the architectural specification
in its emulation of L1 or L2, the L0 userspace *must* be informed.
