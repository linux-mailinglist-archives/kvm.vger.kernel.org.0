Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3A92CE157
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 23:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgLCWIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 17:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgLCWID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 17:08:03 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9111EC061A4F
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 14:07:23 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id t18so3337705otk.2
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 14:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+fcr9AsvTSU8M9HtgILoI/sqhE+c+IJbt4P3odH0eMM=;
        b=XAE1W3uW3Fgd9wPm19jh2i7D4OoyG+4kWce7+hc8V2YgGIPbhxh3sk0V84PFFP/y3C
         Fa7bL04XR7Lde0yLCBcKtLv8VER10Sl394P/4G2/Vl5oCH83fPoslorVUQjDFDFv+Ank
         i7G5F5LH9T/fj4pTt2A/Fs9gb9UHbGVp7cNxw/Hy6H3LD+Jwm86hk++65SzRoa3XvgzL
         u6A8F68vFZOIhh1v0qrWrMhLXu9tNA7L8t4/B5xj59ZdjMcVVg0SAZNBjW44XXOmIAAD
         WEMLOmyzdAA+Ts2LFhXA5eRRyHbOdb9YIAmCcKCDVj8tDEDBp1nZFX4rkarMLKtr4EkM
         4a3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+fcr9AsvTSU8M9HtgILoI/sqhE+c+IJbt4P3odH0eMM=;
        b=Q/eH4U5IGpOA8b2u4p2UXuWAXbWndG2HLr6q3mCAmr+/+S+ARdWAo0aSQmxvprUAM5
         nvebPQTcJ8kF4EeGMFb7R2k9k0OnvJ5+ooxFqTj8G+iK6BCr8Djdn0uFEecs8/AXyPnx
         JdLd1cd6sfLzCp791ARVuda/RHXqRA3y2YDyv5/a1lZe/C6MmllolKmxwygWjDw+3Bav
         mSZgpRTO18EzrqFeeulZjMseRsdzCS7mStp3Uy1VvYoN/JRJmCBBmmwFEyJSG0RVAqnp
         aAW6VwvQkoTChT+ubCHyfroHS0nAsczZ//ftPIy3iffIliOhVwUlIBU9Wj9O5BGy9NYr
         rXow==
X-Gm-Message-State: AOAM530iyD3sj0GxiLDc+3tfd1UY6RX6GQ6AhEi3o0TfzyPPFbjEscy9
        bBAV1YYlA8etXpBAtGQ9cZBATdwPChth4a2DM86eCg==
X-Google-Smtp-Source: ABdhPJwDN9Q28DMrxT79iNOEzS/MtxwqOgnmqIpyYh3plJa9laHIJ+7/rwEx0Ej0MHwkBhPKF3CTqDRKMyFHTWJTUYM=
X-Received: by 2002:a9d:68d9:: with SMTP id i25mr1146175oto.241.1607033242696;
 Thu, 03 Dec 2020 14:07:22 -0800 (PST)
MIME-Version: 1.0
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com> <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com> <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
In-Reply-To: <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Dec 2020 14:07:10 -0800
Message-ID: <CALMp9eTHKihAeq1uK3GfYwk=FkJtHzrxiUM3CqWqX3E+ZNQ_=g@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Idan Brown <idan.brown@oracle.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        Wanpeng Li <wanpeng.li@hotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 24, 2020 at 3:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/11/20 02:55, Sean Christopherson wrote:
> >>> I believe there is a 1-to-many relationship here, which is why I said
> >>> each CPU would need to maintain a linked list of possible vCPUs to
> >>> iterate and find the intended recipient.
> >
> > Ya, the concern is that it's theoretically possible for the PINV to arrive in L0
> > after a different vCPU has been loaded (or even multiple different vCPUs).
> > E.g. if the sending pCPU is hit with an NMI after checking vcpu->mode, and the
> > NMI runs for some absurd amount of time.  If that happens, the PINV handler
> > won't know which vCPU(s) should get an IRQ injected into L1 without additional
> > tracking.  KVM would need to set something like nested.pi_pending before doing
> > kvm_vcpu_trigger_posted_interrupt(), i.e. nothing really changes, it just gets
> > more complex.
>
> Ah, gotcha.  What if IN_GUEST_MODE/OUTSIDE_GUEST_MODE was replaced by a
> generation count?  Then you reread vcpu->mode after sending the IPI, and
> retry if it does not match.

Meanwhile, the IPI that you previously sent may have triggered posted
interrupt processing for the wrong vCPU.

Consider an overcommitted scenario, where each pCPU is running two
vCPUs. L1 initializes all of the L2 PIDs so that PIR[x] and PID.ON are
set. Then, it sends the VMCS12 NV IPI to one specific L2 vCPU. When L0
processes the VM-exit for sending the IPI, the target vCPU is running
IN_GUEST_MODE, so we send the vmcs02 NV to the corresponding pCPU.
But, by the time the IPI is received on the pCPU, a different L2 vCPU
is running. Oops. It seems that we have to pin the target vCPU to the
pCPU until the IPI arrives. But since it's the vmcs02 NV, we have no
way of knowing whether or not it has arrived.

If the requisite IPI delivery delays seem too absurd to contemplate,
consider pushing L0 down into L1.

> To guarantee atomicity, the OUTSIDE_GUEST_MODE IN_GUEST_MODE
> EXITING_GUEST_MODE READING_SHADOW_PAGE_TABLES values would remain in the
> bottom 2 bits.  That is, the vcpu->mode accesses like
>
>         vcpu->mode = IN_GUEST_MODE;
>
>         vcpu->mode = OUTSIDE_GUEST_MODE;
>
>         smp_store_mb(vcpu->mode, READING_SHADOW_PAGE_TABLES);
>
>         smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
>
>         return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
>
> becoming
>
>         enum {
>                 OUTSIDE_GUEST_MODE,
>                 IN_GUEST_MODE,
>                 EXITING_GUEST_MODE,
>                 READING_SHADOW_PAGE_TABLES,
>                 GUEST_MODE_MASK = 3,
>         };
>
>         vcpu->mode = (vcpu->mode | GUEST_MODE_MASK) + 1 + IN_GUEST_MODE;
>
>         vcpu->mode &= ~GUEST_MODE_MASK;
>
>         smp_store_mb(vcpu->mode, vcpu->mode|READING_SHADOW_PAGE_TABLES);
>
>         smp_store_release(&vcpu->mode, vcpu->mode & ~GUEST_MODE_MASK);
>
>         int x = READ_ONCE(vcpu->mode);
>         do {
>                 if ((x & GUEST_MODE_MASK) != IN_GUEST_MODE)
>                         return x & GUEST_MODE_MASK;
>         } while (!try_cmpxchg(&vcpu->mode, &x,
>                               x ^ IN_GUEST_MODE ^ EXITING_GUEST_MODE))
>         return IN_GUEST_MODE;
>
> You could still get spurious posted interrupt IPIs, but the IPI handler
> need not do anything at all and that is much better.
>
> > if we're ok with KVM
> > processing virtual interrupts that technically shouldn't happen, yet.  E.g. if
> > the L0 PINV handler consumes vIRR bits that were set after the last PI from L1.
>
> I actually find it curious that the spec promises posted interrupt
> processing to be triggered only by the arrival of the posted interrupt
> IPI.  Why couldn't the processor in principle snoop for the address of
> the ON bit instead, similar to an MWAIT?
>
> But even without that, I don't think the spec promises that kind of
> strict ordering with respect to what goes on in the source.  Even though
> posted interrupt processing is atomic with the acknowledgement of the
> posted interrupt IPI, the spec only promises that the PINV triggers an
> _eventual_ scan of PID.PIR when the interrupt controller delivers an
> unmasked external interrupt to the destination CPU.  You can still have
> something like
>
>         set PID.PIR[100]
>         set PID.ON
>                                         processor starts executing a
>                                          very slow instruction...
>         send PINV
>         set PID.PIR[200]
>                                         acknowledge PINV
>
> and then vector 200 would be delivered before vector 100.  Of course
> with nested PI the effect would be amplified, but it's possible even on
> bare metal.
>
> Paolo
>
