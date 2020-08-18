Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B853A248DE8
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 20:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHRSYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 14:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRSYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 14:24:00 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54ADBC061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 11:24:00 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id b22so18746540oic.8
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4uE3xXRtqRfEn1OYDBHpEdtWV2R53NDeV7+oyoOPFlY=;
        b=Ez7FjKya15XLVptzGK9jhY368i4dW4wH9c4TXuNDpfUxnWcft1abxC/w1ocfrnabnE
         uHHCi23vYrA9iXfhytDd3m4m4QD1AiDrN4hYkfbZtC/PDPxKVpaate4C833r6qmeIfKa
         ZIPjGG8eFKud0nhBUNAgJ3mpGczd8HCErDrGSt4htMFD01+W1vsCTaGm7/1yRH5R7Xrw
         e2lO4yx8cm4TkZY9foBk/Y1jfGGb76zmrH1E/LlQax2YbtSEXkXxuiAbcY09uJ8bjAVW
         JDMc92qNJ/OSV47kxD6GndcGrfrF31glQCXEWSR7xN4XX+tZMg/rtlWsbYx9cm7QMuFl
         7Ggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4uE3xXRtqRfEn1OYDBHpEdtWV2R53NDeV7+oyoOPFlY=;
        b=dY6IVPGCurUjaGtIb57CW/FRH/5FuH7YXqpqM74GSPncE9OoNmKpLIAuQjmLWcotr6
         Oa4LXBqBRAc/Y+Nh8AegHJpTD+HTQ8b7ThtUNPgYxx3IAOPwSqx0ayBi28booNTh6q0x
         kr1/xFEay1whlrgCxvynS7rnoi4DK/fAmgvZr5M4a739bKqV6TfBQMGB2bOidAwcxb/2
         LvwFT6k+tldB9LmCKB2wWt0lNjv9QkbydVn3fgmAOzfrS4mJkrdcJa1MFp89GRoz9LV8
         OsoYFTVxxZSr5OgpypxOdZLAJ3NCPqbIMeg0nqiftIHqAtIhHph6RLEArPU3K+3e3Nk9
         sDoQ==
X-Gm-Message-State: AOAM530NZw1NqQC/+qaKMcZgnBq2as1B3AlwFq5dq/FthdrAaft9q+Gg
        4u3NskYWFUPIgcX/b+9ONgetNjp/NxKio3arAJ72Ug==
X-Google-Smtp-Source: ABdhPJyuGN7XZ1Z8Z2FMh8+bnDzSw7T3BCgIA3pJkT3cia0BthIccdwP/UkkDsnnZI8xefCeiZqFqvqEeMH9fkn0tUg=
X-Received: by 2002:aca:670b:: with SMTP id z11mr919784oix.6.1597775039443;
 Tue, 18 Aug 2020 11:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200807084841.7112-1-chenyi.qiang@intel.com> <20200807084841.7112-3-chenyi.qiang@intel.com>
 <CALMp9eQiyRxJ0jkvVi+fWMZcDQbvyCcuTwH1wrYV-u_E004Bhg@mail.gmail.com>
 <34b083be-b9d5-fd85-b42d-af0549e3b002@intel.com> <CALMp9eS=dO7=JvvmGp-nt-LBO9evH-bLd2LQMO9wdYJ5V6S0_Q@mail.gmail.com>
 <268b0ee4-e56f-981c-c03e-6dca8a4e99da@intel.com>
In-Reply-To: <268b0ee4-e56f-981c-c03e-6dca8a4e99da@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 18 Aug 2020 11:23:47 -0700
Message-ID: <CALMp9eSAkzGPp4zPVakypR1McSJtJ1x4j1zAAj1sM1bHxd01zg@mail.gmail.com>
Subject: Re: [RFC 2/7] KVM: VMX: Expose IA32_PKRS MSR
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 12:28 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
>
>
> On 8/14/2020 1:31 AM, Jim Mattson wrote:
> > On Wed, Aug 12, 2020 at 10:42 PM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> >>
> >>
> >>
> >> On 8/13/2020 5:21 AM, Jim Mattson wrote:
> >>> On Fri, Aug 7, 2020 at 1:46 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> >>>>
> >>>> Protection Keys for Supervisor Pages (PKS) uses IA32_PKRS MSR (PKRS) at
> >>>> index 0x6E1 to allow software to manage supervisor protection key
> >>>> rights. For performance consideration, PKRS intercept will be disabled
> >>>> so that the guest can access the PKRS without VM exits.
> >>>> PKS introduces dedicated control fields in VMCS to switch PKRS, which
> >>>> only does the retore part. In addition, every VM exit saves PKRS into
> >>>> the guest-state area in VMCS, while VM enter won't save the host value
> >>>> due to the expectation that the host won't change the MSR often. Update
> >>>> the host's value in VMCS manually if the MSR has been changed by the
> >>>> kernel since the last time the VMCS was run.
> >>>> The function get_current_pkrs() in arch/x86/mm/pkeys.c exports the
> >>>> per-cpu variable pkrs_cache to avoid frequent rdmsr of PKRS.
> >>>>
> >>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> >>>> ---
> >>>
> >>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >>>> index 11e4df560018..df2c2e733549 100644
> >>>> --- a/arch/x86/kvm/vmx/nested.c
> >>>> +++ b/arch/x86/kvm/vmx/nested.c
> >>>> @@ -289,6 +289,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
> >>>>           dest->ds_sel = src->ds_sel;
> >>>>           dest->es_sel = src->es_sel;
> >>>>    #endif
> >>>> +       dest->pkrs = src->pkrs;
> >>>
> >>> Why isn't this (and other PKRS code) inside the #ifdef CONFIG_X86_64?
> >>> PKRS isn't usable outside of long mode, is it?
> >>>
> >>
> >> Yes, I'm also thinking about whether to put all pks code into
> >> CONFIG_X86_64. The kernel implementation also wrap its pks code inside
> >> CONFIG_ARCH_HAS_SUPERVISOR_PKEYS which has dependency with CONFIG_X86_64.
> >> However, maybe this can help when host kernel disable PKS but the guest
> >> enable it. What do you think about this?
> >
> > I see no problem in exposing PKRS to the guest even if the host
> > doesn't have CONFIG_ARCH_HAS_SUPERVISOR_PKEYS.
> >
>
> Yes, but I would prefer to keep it outside CONFIG_X86_64. PKS code has
> several code blocks and putting them under x86_64 may end up being a
> mess. In addition, PKU KVM related code isn't under CONFIG_X86_64 as
> well. So, is it really necessary to put inside?

I'll let someone who actually cares about the i386 build answer that question.
