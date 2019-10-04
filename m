Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8B7CB6AB
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 10:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbfJDIxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 04:53:55 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:50266 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDIxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 04:53:55 -0400
Received: by mail-wm1-f46.google.com with SMTP id 5so4940088wmg.0
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 01:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rWnxbg+kulbhAoq+Zj74jJt5YfGrSQ0gMvKIbLzarcY=;
        b=hmDRE0T1eXxVY8euJBtRWybl8WVii4XnML1KGYN3wXH6t9p3jACsMnWcFyS5Y9F8HZ
         LFU9u5prmgnGpsGpSGZJEg4TMG77yruvL45dz5KtIxzmxSdUSfkHkX/nfJOd0Ot/fGb8
         Y78zxOeHs2MjZlGdj1V2b4bLUZ2DzUKJ8ugu/dyQQ3X21a4LEjQG2LBpY8vRu+AgJ4c0
         LYBkr+cg0MaqKnYIcmZqm89XxGWHZc7u974S5u4WY6hbK0APRik83nT5nPhm6guVez5d
         MeQ0TCPMi0ZTVFVQUUp530jUQc/XnMw8PoeXSGsQ89fyTD8jJj1v/9od0rrXKVEyGq3U
         BYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rWnxbg+kulbhAoq+Zj74jJt5YfGrSQ0gMvKIbLzarcY=;
        b=fD8gVetKRq6quPx8MKWuJ6seR0FwwgiF8EhbSy/pzaHFz34Clj8MHp1J8fkSsnrsRr
         naRczSgZpThxRVRJWvmCm2u8c9EiBJTe1FaQZ7cP9VgZ072c0p6BWEHSANaDvngm7vHg
         e0/0U7vi5ZMSkO9qUiQKTYK7by0S0rvFlWhcTA19jEnc2zkdEi1DQa2+4GT+eaO+ruwI
         I2eQYjWOM/Db7mBv2s3KAm0Y59PnqouGykdlO7VX6d+xfUILypnXQTp5eL3mczyz9viP
         MFoZbyjwTGG6lGXXGHKXOpITmR4qm8CrpeiijYORD3bb4E30AQWLHuq+IMUPrNkax0dH
         TRGQ==
X-Gm-Message-State: APjAAAVDP61dmbBwmVVg8NFWnOSBMQQMNYZll2QXauOYK90GLCDgejyf
        KX56gy37tHaDjHNdtI0D3+38bgf2MyauMseFwEn2vw==
X-Google-Smtp-Source: APXvYqy13MwA5tLv/2YtXvPGNSDzvsoZ9ff0hHIh7ogbofES9Sqv1262DabETnAPmt+dB9exZvSf2MQK5H9b9e0/6rM=
X-Received: by 2002:a1c:7dd1:: with SMTP id y200mr9592505wmc.59.1570179231417;
 Fri, 04 Oct 2019 01:53:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAMGffE=JTrCvj900OeMJQh06vogxKepRFn=7tdA965VJ9zSWow@mail.gmail.com>
 <DDC3DE27-46A3-4CB4-9AB8-C3C2F1D54777@oracle.com> <20191002172943.GG9615@linux.intel.com>
In-Reply-To: <20191002172943.GG9615@linux.intel.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 4 Oct 2019 10:53:40 +0200
Message-ID: <CAMGffE=NFdkg3Qh9pwvWcS2QhqmPJ4Lb4UMSB_Aomsx8H8_PDw@mail.gmail.com>
Subject: Re: Broadwell server reboot with vmx: unexpected exit reason 0x3
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 2, 2019 at 7:29 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Sep 30, 2019 at 01:48:15PM +0300, Liran Alon wrote:
> >
> > > On 30 Sep 2019, at 11:43, Jinpu Wang <jinpu.wang@cloud.ionos.com> wro=
te:
> > >
> > > Dear KVM experts,
> > >
> > > We have a Broadwell server reboot itself recently, before the reboot,
> > > there were error messages from KVM in netconsole:
> > > [5599380.317055] kvm [9046]: vcpu1, guest rIP: 0xffffffff816ad716 vmx=
:
> > > unexpected exit reason 0x3
> > > [5599380.317060] kvm [49626]: vcpu0, guest rIP: 0xffffffff81060fe6
> > > vmx: unexpected exit reason 0x3
> > > [5599380.317062] kvm [36632]: vcpu0, guest rIP: 0xffffffff8103970d
> > > vmx: unexpected exit reason 0x3
> > > [5599380.317064] kvm [9620]: vcpu1, guest rIP: 0xffffffffb6c1b08e vmx=
:
> > > unexpected exit reason 0x3
> > > [5599380.317067] kvm [49925]: vcpu5, guest rIP: 0xffffffff9b406ea2
> > > vmx: unexpected exit reason 0x3
> > > [5599380.317068] kvm [49925]: vcpu3, guest rIP: 0xffffffff9b406ea2
> > > vmx: unexpected exit reason 0x3
> > > [5599380.317070] kvm [33871]: vcpu2, guest rIP: 0xffffffff81060fe6
> > > vmx: unexpected exit reason 0x3
> > > [5599380.317072] kvm [49925]: vcpu4, guest rIP: 0xffffffff9b406ea2
> > > vmx: unexpected exit reason 0x3
> > > [5599380.317074] kvm [48505]: vcpu1, guest rIP: 0xffffffffaf36bf9b
> > > vmx: unexpected exit reason 0x3
> > > [5599380.317076] kvm [21880]: vcpu1, guest rIP: 0xffffffff8103970d
> > > vmx: unexpected exit reason 0x3
> >
> > The only way a CPU will raise this exit-reason (3 =3D=3D EXIT_REASON_IN=
IT_SIGNAL)
> > is if CPU is in VMX non-root mode while it has a pending INIT signal in=
 LAPIC.
> >
> > In simple terms, it means that one CPU was running inside guest while
> > another CPU have sent it a signal to reset itself.
> >
> > I see in code that kvm_init() does register_reboot_notifier(&kvm_reboot=
_notifier).
> > kvm_reboot() runs hardware_disable_nolock() on each CPU before reboot.
> > Which should result on every CPU running VMX=E2=80=99s hardware_disable=
() which should
> > exit VMX operation (VMXOFF) and disable VMX (Clear CR4.VMXE).
> >
> > Therefore, I=E2=80=99m quite puzzled on how a server reboot triggers th=
e scenario you
> > present here.  Can you send your full kernel log?
>
> My guess is that the system triggered an emergency reboot and was either
> unable to force CPUs out of VMX non-root with NMIs, hit a triple fault
> shutdown and auto-generated INITs before it could shootdown the other
> CPUs, or didn't even attempt the NMI because VMX wasn't enabled on the
> CPU that triggered reboot.
>
> In arch/x86/kernel/reboot.c:
>
> /* Use NMIs as IPIs to tell all CPUs to disable virtualization */
> static void emergency_vmx_disable_all(void)
> {
>         /* Just make sure we won't change CPUs while doing this */
>         local_irq_disable();
>
>         /*
>          * We need to disable VMX on all CPUs before rebooting, otherwise
>          * we risk hanging up the machine, because the CPU ignore INIT
>          * signals when VMX is enabled.
>          *
>          * We can't take any locks and we may be on an inconsistent
>          * state, so we use NMIs as IPIs to tell the other CPUs to disabl=
e
>          * VMX and halt.
>          *
>          * For safety, we will avoid running the nmi_shootdown_cpus()
>          * stuff unnecessarily, but we don't have a way to check
>          * if other CPUs have VMX enabled. So we will call it only if the
>          * CPU we are running on has VMX enabled.
>          *
>          * We will miss cases where VMX is not enabled on all CPUs. This
>          * shouldn't do much harm because KVM always enable VMX on all
>          * CPUs anyway. But we can miss it on the small window where KVM
>          * is still enabling VMX.
>          */
>         if (cpu_has_vmx() && cpu_vmx_enabled()) {
>                 /* Disable VMX on this CPU. */
>                 cpu_vmxoff();
>
>                 /* Halt and disable VMX on the other CPUs */
>                 nmi_shootdown_cpus(vmxoff_nmi);
>
>         }
> }
>
> static void native_machine_emergency_restart(void)
> {
>         ...
>
>         if (reboot_emergency)
>                 emergency_vmx_disable_all();
> }
>
Thanks for the information, Sean, I checked the call path for
emergency_restart, I would expect there should be a kernel message
to indicate the reason why it has to do the emergency_restart, but
there is nothing logged in netconsole or kernel log. I don't
understand.

Do you have a guess what could cause the system to trigger an emergency reb=
oot?

Regards,
Jinpu
