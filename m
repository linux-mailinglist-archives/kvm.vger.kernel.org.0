Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9544536AA76
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 03:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhDZBwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Apr 2021 21:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhDZBwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Apr 2021 21:52:01 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD776C061574
        for <kvm@vger.kernel.org>; Sun, 25 Apr 2021 18:51:20 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id y14-20020a056830208eb02902a1c9fa4c64so14185484otq.9
        for <kvm@vger.kernel.org>; Sun, 25 Apr 2021 18:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kJzeRr/hSbG8wZSt9u3FLoIO3LYVV3P53m7v50sRCc0=;
        b=GuhmoIGhIQMRBone0xcenD6kg5wNUg9WCoKzcNIdFKcmPRcCwmvnPhYjsh4iaieAzl
         1J6HeLVHRj/aGQJ+eCVi+sYKfzyMdUvpBL0oU9kAyxKuxBsVrU6oSEbzZdbZ1vdJuNov
         CoFl+qEofO3YcTLKqXg1QVlI1b3Z+49mBTR9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kJzeRr/hSbG8wZSt9u3FLoIO3LYVV3P53m7v50sRCc0=;
        b=gcTeY2CdYH3d2RYCDgw6qZ3cSVg4NSTpSfjuls1/DggSXDzcgfpQWB2tlrSVNAdsDX
         mb8T9jF1VKoKTPiAKPiXZ/6ys59ykpWIUoZj9VJxz37JBcZjflP0a6fqBDW5rp8mF07b
         ljT/0wslcH+/hdY6LfRob/a7qMk6Dh1RQN4FVAal/EoNfeVnd3jhuxNgUkaewtrR7k09
         SiDgI5GuXGfXcEJWILXRsDuZFuXrhRWAKwJnut0L3KlT+3z2vgNpjJ7DWAL4tF1ffeGS
         JbFamG4fFPhHoLUNnind2Vs+aW+fML+uxD0SMGL7Z5hYjzYebGEm9QIFQevcV/EdzD99
         h59A==
X-Gm-Message-State: AOAM530HQZfjmJp6zvtddlv4X6UMdCUXCL258DNupzv9zAogGdzKSdB1
        T+Rlrc2QX4MqXbjlJ8UW0z1XjUaQ5qtQNHRCg9hzjw==
X-Google-Smtp-Source: ABdhPJySja3S4AByRbyOLWMm1A+APD941glvCLeLquoSGWFyRPJneq362f8BU6EyQDUBvushXpC2Gna/uIWYsX5j+kE=
X-Received: by 2002:a05:6830:1c76:: with SMTP id s22mr12436190otg.46.1619401880214;
 Sun, 25 Apr 2021 18:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GKd_YR9QmTR-6KsiE16=4s8fuqh8pmQTYnxHXS=mYp9g@mail.gmail.com>
 <YH2z3uuQYwSyGJfL@google.com> <CAJGDS+FGnDFssYXLfLrog+AJu62rrs6DzAQuESJSDaNNdsYdcw@mail.gmail.com>
 <CAJGDS+GT1mKHz6K=qHQf54S_97ym=nRP12MfO6OSEOpLYGht=A@mail.gmail.com>
In-Reply-To: <CAJGDS+GT1mKHz6K=qHQf54S_97ym=nRP12MfO6OSEOpLYGht=A@mail.gmail.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Mon, 26 Apr 2021 07:21:09 +0530
Message-ID: <CAJGDS+EDsTqhL-i0RkJy+v=mxQ9HEfPX_=t2m4un4P=S7KF+nQ@mail.gmail.com>
Subject: Re: Intercepting RDTSC instruction by causing a VMEXIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

Thank you very much for your answer again. I could actually see that
the RDTSC handler gets called successfully. I added a "printk"
statement to the handler and I can see the messages being printed out
to the kernel syslog.

However, I am not sure if a VMEXIT is happening in userspace. I use
QEMU and I do not see any notification from QEMU that tells me that a
VMEXIT happened due to RDTSC being executed. Is there a mechanism to
confirm this?

My actual requirement to record tsc values read out as a result of
RDTSC execution still stands.

Best Regards,
Arnabjyoti Kalita


On Mon, Apr 26, 2021 at 7:19 AM Arnabjyoti Kalita
<akalita@cs.stonybrook.edu> wrote:
>
> Hello Sean,
>
> Thank you very much for your answer again. I could actually see that the RDTSC handler gets called successfully. I added a "printk" statement to the handler and I can see the messages being printed out to the kernel syslog.
>
> However, I am not sure if a VMEXIT is happening in userspace. I use QEMU and I do not see any notification from QEMU that tells me that a VMEXIT happened due to RDTSC being executed. Is there a mechanism to confirm this?
>
> My actual requirement to record tsc values read out as a result of RDTSC execution still stands.
>
> Best Regards,
> Arnabjyoti Kalita
>
>
>
>
> On Tue, 20 Apr 2021, 08:03 Arnabjyoti Kalita, <akalita@cs.stonybrook.edu> wrote:
>>
>> Hello Sean,
>>
>> Thank you very much for your answer. I'm hoping the inlined changes
>> should be enough to see RDTSC interception.
>>
>> No, I'm actually not running a nested guest, even though vmx is enabled.
>>
>> Best Regards,
>> Arnabjyoti Kalita
>>
>> On Mon, Apr 19, 2021 at 10:16 PM Sean Christopherson <seanjc@google.com> wrote:
>> >
>> > On Sat, Apr 17, 2021, Arnabjyoti Kalita wrote:
>> > > Hello all,
>> > >
>> > > I'm having a requirement to record values obtained by reading tsc clock.
>> > >
>> > > The command line I use to start QEMU in KVM mode is as below -
>> > >
>> > > sudo ./qemu-system-x86_64 -m 1024 --machine pc-i440fx-2.5 -cpu
>> > > qemu64,-vme,-x2apic,-kvmclock,+lahf_lm,+3dnowprefetch,+vmx -enable-kvm
>> > > -netdev tap,id=tap1,ifname=tap0,script=no,downscript=no -device
>> > > virtio-net-pci,netdev=tap1,mac=00:00:00:00:00:00 -drive
>> > > file=~/os_images_for_qemu/ubuntu-16.04.server.qcow2,format=qcow2,if=none,id=img-direct
>> > > -device virtio-blk-pci,drive=img-direct
>> > >
>> > > I am using QEMU version 2.11.92 and the guest kernel is a
>> > > 4.4.0-116-generic. I use the CPU model "qemu64" because I have a
>> > > requirement to create a snapshot of this guest and load the snapshot
>> > > in TCG mode. The generic CPU model helps, in this regard.
>> > >
>> > > Now when the guest is running, I want to intercept all rdtsc
>> > > instructions and record the tsc clock values. I know that for this to
>> > > happen, the CPU_BASED_RDTSC_EXITING flag needs to exist for the
>> > > particular CPU model.
>> > >
>> > > How do I start adding support for causing VMEXIT upon rdtsc execution?
>> >
>> > This requires a KVM change.  The below should do the trick.
>> >
>> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > index c05e6e2854b5..f000728e4319 100644
>> > --- a/arch/x86/kvm/vmx/vmx.c
>> > +++ b/arch/x86/kvm/vmx/vmx.c
>> > @@ -2453,7 +2453,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>> >               CPU_BASED_MWAIT_EXITING |
>> >               CPU_BASED_MONITOR_EXITING |
>> >               CPU_BASED_INVLPG_EXITING |
>> > -             CPU_BASED_RDPMC_EXITING;
>> > +             CPU_BASED_RDPMC_EXITING |
>> > +             CPU_BASED_RDTSC_EXITING;
>> >
>> >         opt = CPU_BASED_TPR_SHADOW |
>> >               CPU_BASED_USE_MSR_BITMAPS |
>> > @@ -5194,6 +5195,15 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
>> >         return kvm_skip_emulated_instruction(vcpu);
>> >  }
>> >
>> > +static int handle_rdtsc(struct kvm_vcpu *vcpu)
>> > +{
>> > +       u64 tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>> > +
>> > +       kvm_rax_write(vcpu, tsc & -1u);
>> > +       kvm_rdx_write(vcpu, (tsc >> 32) & -1u);
>> > +       return kvm_skip_emulated_instruction(vcpu);
>> > +}
>> > +
>> >  static int handle_apic_access(struct kvm_vcpu *vcpu)
>> >  {
>> >         if (likely(fasteoi)) {
>> > @@ -5605,6 +5615,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>> >         [EXIT_REASON_INVD]                    = kvm_emulate_invd,
>> >         [EXIT_REASON_INVLPG]                  = handle_invlpg,
>> >         [EXIT_REASON_RDPMC]                   = kvm_emulate_rdpmc,
>> > +       [EXIT_REASON_RDTSC]                   = handle_rdtsc,
>> >         [EXIT_REASON_VMCALL]                  = kvm_emulate_hypercall,
>> >         [EXIT_REASON_VMCLEAR]                 = handle_vmx_instruction,
>> >         [EXIT_REASON_VMLAUNCH]                = handle_vmx_instruction,
>> >
>> > > I see that a fairly recent commit in QEMU helps adding nested VMX
>> > > controls to named CPU models, but not "qemu64". Can I extend this
>> > > commit to add these controls to "qemu64" as well? Will making this
>> > > change immediately add support for intercepting VMEXITS for "qemu64"
>> > > CPU?
>> >
>> > Are you actually running a nested guest?
