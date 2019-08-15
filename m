Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13E8F743
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 00:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733149AbfHOWyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 18:54:49 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33212 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730124AbfHOWyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 18:54:49 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so2525180iog.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 15:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xAbvvoLe0EGkjEpIiR5uSGwAxuaQ0LTftrIgW/B7/cA=;
        b=WCtVHzEiAMG0e3eg8Mk6348UoM5EmMAdNOYnIP6TfYu+ganmboivjfJt+mk3QSkWJ8
         RIKaEOjLlmwKa93aaBxjXm24OydclMv3hsTk+VY9QHIgvcXXOweimIfb+co12M5f1kDc
         R2Bn7iOzsA7eM7B2tXMlEim8bIb5egMqY1I/fFDcZN9305VMyQeJLA8rNPxgilHwNWwX
         c1ZJQCDcau79W/P/W47DfOBCFVN+Qr+/7ZllTemgbYgMqNClAsAJ2hQffJyIUI6fQXSk
         2Q8ykc2d1Ez+SL5Qn1tbRI/tkzqiA9zIYf4EW7GH5v+wTMiLkeiOslr30kwfykaoeYqP
         G5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xAbvvoLe0EGkjEpIiR5uSGwAxuaQ0LTftrIgW/B7/cA=;
        b=s25rtuIvkRMzf0bEiw6PaIIq2AB5ifveR0NDYXwrtN8cUVLokc3rfXh3QC2BxfaTCL
         GjdFkJLh78+Hn21HzuBftfMdYGRwjUQMowsCCYSyjni9gSYDUoq24SHKnXh+zgBgvEek
         /UguVvxpBVgfZbnE/kHkQip2dLy/AG0+4+e7hVaqnCTY6YRPdC+PeZ4gxUCrBX1eWaGW
         2cbb+tSEgB5qoVWjs7FrfhsTlLEf9tXFJTLh2qVgHb5P4UrOt2JUHGG4HRbAPehZBaYB
         qB62rjfRDGhUCjgCS6puiJ0a/qTEDe4csKRTxwwNs2q7K9CWsp7/iAQj7Ac/HxgUEbYf
         /5JA==
X-Gm-Message-State: APjAAAWgfLSe5pBcVq8JwKADHJm2iuTp2HDxfsycMNKsCE8IRBFyYriA
        hWxbt0ODrFmsxcfFyqtURsgzGpkdS4JNZaNDtplV/g==
X-Google-Smtp-Source: APXvYqysB7YhI6II1uC/pP54G80rKqF2hDZUHJ8IeNJAqx836pyuwiHHp9+mlNWz6oEkFS8OgDUdZ12Z27sFFBUyrvM=
X-Received: by 2002:a02:9092:: with SMTP id x18mr5221699jaf.48.1565909688256;
 Thu, 15 Aug 2019 15:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-5-krish.sadhukhan@oracle.com> <20190513190016.GI28561@linux.intel.com>
 <2c08cd38-fd7d-da68-7c8d-2c7c93c3a9c8@oracle.com> <20190517203440.GL15006@linux.intel.com>
In-Reply-To: <20190517203440.GL15006@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 15 Aug 2019 15:54:37 -0700
Message-ID: <CALMp9eQs7xn5aTF3Bf+L_mCm8ziGUTQpPg9q0=-pqiY=qZsCSw@mail.gmail.com>
Subject: Re: [PATCH 4/8][KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" VM-exit
 control on vmentry of nested guests
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 17, 2019 at 1:34 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 16, 2019 at 03:07:48PM -0700, Krish Sadhukhan wrote:
> >
> >
> > On 05/13/2019 12:00 PM, Sean Christopherson wrote:
> > >On Wed, Apr 24, 2019 at 07:17:20PM -0400, Krish Sadhukhan wrote:
> > >>According to section "Checks on Host Control Registers and MSRs" in Intel
> > >>SDM vol 3C, the following check is performed on vmentry of nested guests:
> > >>
> > >>     "If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, bits reserved
> > >>     in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
> > >>     register."
> > >>
> > >>Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > >>Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> > >>---
> > >>  arch/x86/kvm/vmx/nested.c | 5 +++++
> > >>  1 file changed, 5 insertions(+)
> > >>
> > >>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > >>index 83cd887638cb..d2067370e288 100644
> > >>--- a/arch/x86/kvm/vmx/nested.c
> > >>+++ b/arch/x86/kvm/vmx/nested.c
> > >>@@ -2595,6 +2595,11 @@ static int nested_check_host_control_regs(struct kvm_vcpu *vcpu,
> > >>        !nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
> > >>        !nested_cr3_valid(vcpu, vmcs12->host_cr3))
> > >>            return -EINVAL;
> > >>+
> > >>+   if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL &&
> > >>+      !kvm_valid_perf_global_ctrl(vmcs12->host_ia32_perf_global_ctrl))
> > >If vmcs12->host_ia32_perf_global_ctrl were ever actually consumed, this
> > >needs to ensure L1 isn't able to take control of counters that are owned
> > >by the host.
> >
> > Sorry, I didn't understand your concern. Could you please explain how L1 can
> > control L0's counters ?
>
> MSR_CORE_PERF_GLOBAL_CTRL isn't virtualized in the sense that there is
> only one MSR in hardware (per logical CPU).  Loading an arbitrary value
> into hardware on a nested VM-Exit via vmcs12->host_ia32_perf_global_ctrl
> means L1 could toggle counters on/off without L0's knowledge.  See
> intel_guest_get_msrs() and intel_pmu_set_msr().
>
> Except that your patches don't actually do anything functional with
> vmcs12->host_ia32_perf_global_ctrl, hence my confusion over what you're
> trying to accomplish.  If KVM advertises VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL
> to L1, then L1 will think it can use the VMCS field to handle
> MSR_CORE_PERF_GLOBAL_CTRL when running L2, e.g. instead of adding
> MSR_CORE_PERF_GLOBAL_CTRL to the MSR load lists, which will break L1
> (assuming nested PMU works today).

I think nested PMU should work today if the vmcs12 VM-entry and
VM-exit MSR-load lists are used to swap IA32_PERF_GLOBAL_CTRL values
between L1 and L2. Note that atomic_switch_perf_msrs() is called on
every vmx_vcpu_run(), for vmcs02 as well as vmcs01.

This change set should aim to provide equivalent functionality with
the new(er) VM-entry and VM-exit controls for "load
IA32_PERF_GLOBAL_CTRL," so that L1 doesn't have to resort to the
MSR-load lists.
