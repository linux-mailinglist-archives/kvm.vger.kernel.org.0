Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C5B987A8
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 01:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbfHUXKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 19:10:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40557 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfHUXKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 19:10:52 -0400
Received: by mail-io1-f67.google.com with SMTP id t6so8084304ios.7
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 16:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uikWFpF397h21i8cVlF4uWDfqo50BX87s5mGbE+XTS4=;
        b=DGhro0FdVlkDmBfuvrmtcAPxXuDYFPaFxFkDGCzO19Z01N0HH7UAHNFQ0mPL/QEmax
         VavaYVsCNvLl/y0/G30unjRCZ6ZR3ByKv2C3UrrC6HFG+XC5gE+w3lo12noZcy8Jo5Ke
         49cz/eAyntnfBX0W7Lr6KFTMr/oe9hnyFUdGpKdCrB+6ibRQVo+78+WrmObF37CqiVgG
         HL362s7TNSW2S2NUPcM6x2m7tJf0uRtZBjzQ4ZqKvNZSEWw5kuF4cjakBrXeweyxNila
         CL+TAVfgTAjnwdSUc9P/Xv/hOrmrB4qmVyACBdQvg/o48NZ5AocMYGwnmySINhpN19BE
         V/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uikWFpF397h21i8cVlF4uWDfqo50BX87s5mGbE+XTS4=;
        b=WFkNJbn18uM4Rry9B2EXg2Ttl4nH/bQ5XztnLh+Cn1PLM33E9OXbq9MISNCVuEFO0h
         a1DP61zH3wgm9SOOpv3HsMwohY0leYIJbPrNt6/l6MsTykBarGGb3ZDg7cQR9u1EaMPA
         aFJ0zD6UFhEaNLE3ZgeFZ8E4MCkS26crzOf1hgWeirsZNsq1y6BxIboVjhNl4rGgbSAi
         7nCAl8I7jCWzBll3iNl0peBNCjYiqjhLA2SDNj61rp2D+RbHw4JQB29rjPMmqKylZs/C
         lyw/jMOlbdZNiZm53YN9Z9OgrYp9ykr1kdRZpVAyehLfujAF4qAPQ/oL6erZuMExmSdF
         TA7A==
X-Gm-Message-State: APjAAAWDW8MOG4sf1zuhkVCfw+CzWixfK0MVcw/4TcJHgEIyQdtPhico
        VlBPnC+8t038UbSAY46+AO0LaDL+/vj1UtWV4+XnTA==
X-Google-Smtp-Source: APXvYqxUF5EuQUrrXWNVAKCZBafoWKhAI/nblfbgxPpwHzZhbp0xcWHU8spe+tRybbv5gySIsPjDDpAQo25nipyxIj8=
X-Received: by 2002:a5d:8954:: with SMTP id b20mr4066733iot.118.1566429051455;
 Wed, 21 Aug 2019 16:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-7-krish.sadhukhan@oracle.com> <CALMp9eR8u6qPF5Gv-UEXSmB9NX=H=AGb4jh4d=mEm7jyTqBfWg@mail.gmail.com>
 <6d0a81be-1546-2a02-92b3-6b94468de9c6@oracle.com>
In-Reply-To: <6d0a81be-1546-2a02-92b3-6b94468de9c6@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Aug 2019 16:10:40 -0700
Message-ID: <CALMp9eQTT3xMqavekKubd1KoKLH0B=zHY_TgSxtVrFgsOh2GMw@mail.gmail.com>
Subject: Re: [PATCH 6/8][KVM nVMX]: Load IA32_PERF_GLOBAL_CTRL MSR on vmentry
 of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 4:05 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 8/15/19 3:44 PM, Jim Mattson wrote:
> > On Wed, Apr 24, 2019 at 4:43 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> According to section "Loading Guest State" in Intel SDM vol 3C, the
> >> IA32_PERF_GLOBAL_CTRL MSR is loaded on vmentry of nested guests:
> >>
> >>      "If the =E2=80=9Cload IA32_PERF_GLOBAL_CTRL=E2=80=9D VM-entry con=
trol is 1, the
> >>       IA32_PERF_GLOBAL_CTRL MSR is loaded from the IA32_PERF_GLOBAL_CT=
RL
> >>       field."
> >>
> >> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >> Suggested-by: Jim Mattson <jmattson@google.com>
> >> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> >> ---
> >>   arch/x86/kvm/vmx/nested.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> index a7bf19eaa70b..8177374886a9 100644
> >> --- a/arch/x86/kvm/vmx/nested.c
> >> +++ b/arch/x86/kvm/vmx/nested.c
> >> @@ -2300,6 +2300,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu=
, struct vmcs12 *vmcs12,
> >>          vcpu->arch.cr0_guest_owned_bits &=3D ~vmcs12->cr0_guest_host_=
mask;
> >>          vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_=
bits);
> >>
> >> +       if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL=
_CTRL)
> >> +               vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> >> +                            vmcs12->guest_ia32_perf_global_ctrl);
> >> +
> >>          if (vmx->nested.nested_run_pending &&
> >>              (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT)) {
> >>                  vmcs_write64(GUEST_IA32_PAT, vmcs12->guest_ia32_pat);
> >> --
> >> 2.17.2
> >>
> > This isn't quite right. The GUEST_IA32_PERF_GLOBAL_CTRL value is just
> > going to get overwritten later by atomic_switch_perf_msrs().
>
>
> atomic_switch_perf_msrs() gest called from vmx_vcpu_run() which I
> thought was executing before handle_vmlaunch() stuff that lead to
> prepare_vmcs02(). Did I miss something in the call-chain ?

Handle_vmlaunch is called on a VM-exit from vmcs01 as the result of a
VMLAUNCH instruction. Atomic_switch_perf_msrs() is called on every
VM-entry (to either vmcs01 or vmcs02).

> > Instead of writing the vmcs12 value directly into the vmcs02, you
> > should call kvm_set_msr(), exactly as it would have been called if
> > MSR_CORE_PERF_GLOBAL_CTRL had been in the vmcs12
> > VM-entry MSR-load list. Then, atomic_switch_perf_msrs() will
> > automatically do the right thing.
