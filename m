Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AE6452E08
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 10:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhKPJeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 04:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbhKPJeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 04:34:03 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69490C061764;
        Tue, 16 Nov 2021 01:31:06 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id z2-20020a9d71c2000000b0055c6a7d08b8so32499762otj.5;
        Tue, 16 Nov 2021 01:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ERqD3wgji1bqpuYnyKO5vsp/sXZh2S2bbfRVsJntGIk=;
        b=CEzr8i2Ao1fccI/sT87CPrT8nvdEVhnDuboaD0DXaNJelrU0p621JdkHtvaEArPBSL
         MhzmyKJ6z0AcsbkCK46MnlFY2p7V4+d/8XFvQJOnJ+/Cc+L8nw9HQbfIbX68nV8J5pYU
         JiGfXMqSQjvF6ftloMXWKEZ0mYBfgg8uWusYHWwwnaG5ih5wNiNVD4Ak9/nLbnJDsCzt
         iOlk+AJ3Esm4MloV8gacKOF6K/TDODA/WYU2AHIZE8OTF3Gv9vSGHgOg3BNhfFpo+crE
         1p6Na6JIIpO/3IgXIL3NjsAJOFI2N0DGjK/ZtQ24p8I36tCDYFmPqXlgvIM1O5gxyJJn
         e4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERqD3wgji1bqpuYnyKO5vsp/sXZh2S2bbfRVsJntGIk=;
        b=H4VgzZ4f0x6MrfPxxlNdsky+qWqJ7StqnyTwDJ8fOKFp04OqJjDL5V46ybieKqfgyR
         cRv6WTQOuM6J2cVvnTEYwgPMaHOo/CKZnRywmSF68TEyhqbvjHYLijkyy1UGfTCRjlvU
         oVUE4IvpU5on3WJxtRF73xTiJ4ERnkKVN6nMK7twIVP2UFJlYKRR8Mya/7HFz2H6R7qx
         Jc3ZqSqf9wtDOP5Qh88qFwk6c3NuY1dArelTtQ3FUJYQEFZIWXycWmVH1F9f4wSIse+w
         55uCFFHatIGDryhaOhfUtT+ShSXMVZVMgz4lxwHFzfM8gQm8tVUSUmxV7ebnUB54vI24
         wMtA==
X-Gm-Message-State: AOAM533JBe9dhKZ43Dn1BZssy/6r48/phVIOBU6DyEfhRkbuZF3OAodT
        OLVsPPrYrwwTy0R7rxry08/gpo7Dggl9ypOq+FI=
X-Google-Smtp-Source: ABdhPJyKAF3So171wKhUqhVXeRpr2qiHN6yBG0gAlqB0GSpdsJ8qRX5CY9qfulrLJ+MuJXfpi7qLGqQrRch9/JEe8xY=
X-Received: by 2002:a9d:6559:: with SMTP id q25mr4869540otl.0.1637055065823;
 Tue, 16 Nov 2021 01:31:05 -0800 (PST)
MIME-Version: 1.0
References: <20211108095931.618865-1-huangkele@bytedance.com>
 <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com> <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
 <CANRm+Cze_b0PJzOGB4-tPdrz-iHcJj-o7QL1t1Pf1083nJDQKQ@mail.gmail.com>
 <d65fbd73-7612-8348-2fd8-8da0f5e2a3c0@bytedance.com> <20211116090604.GA12758@gao-cwp>
In-Reply-To: <20211116090604.GA12758@gao-cwp>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 16 Nov 2021 17:30:54 +0800
Message-ID: <CANRm+Cx24kjw8kk7XSTGsyTn56cQf2rKayCPb5bg814BwoneKg@mail.gmail.com>
Subject: Re: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with AVIC
To:     Chao Gao <chao.gao@intel.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kele Huang <huangkele@bytedance.com>, chaiwen.cc@bytedance.com,
        xieyongji@bytedance.com, dengliang.1214@bytedance.com,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Nov 2021 at 16:56, Chao Gao <chao.gao@intel.com> wrote:
>
> On Tue, Nov 16, 2021 at 10:56:25AM +0800, zhenwei pi wrote:
> >
> >
> >On 11/16/21 10:48 AM, Wanpeng Li wrote:
> >> On Mon, 8 Nov 2021 at 22:09, Maxim Levitsky <mlevitsk@redhat.com> wrote:
> >> >
> >> > On Mon, 2021-11-08 at 11:30 +0100, Paolo Bonzini wrote:
> >> > > On 11/8/21 10:59, Kele Huang wrote:
> >> > > > Currently, AVIC is disabled if x2apic feature is exposed to guest
> >> > > > or in-kernel PIT is in re-injection mode.
> >> > > >
> >> > > > We can enable AVIC with options:
> >> > > >
> >> > > >     Kmod args:
> >> > > >     modprobe kvm_amd avic=1 nested=0 npt=1
> >> > > >     QEMU args:
> >> > > >     ... -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard ...
> >> > > >
> >> > > > When LAPIC works in xapic mode, both AVIC and PV_SEND_IPI feature
> >> > > > can accelerate IPI operations for guest. However, the relationship
> >> > > > between AVIC and PV_SEND_IPI feature is not sorted out.
> >> > > >
> >> > > > In logical, AVIC accelerates most of frequently IPI operations
> >> > > > without VMM intervention, while the re-hooking of apic->send_IPI_xxx
> >> > > > from PV_SEND_IPI feature masks out it. People can get confused
> >> > > > if AVIC is enabled while getting lots of hypercall kvm_exits
> >> > > > from IPI.
> >> > > >
> >> > > > In performance, benchmark tool
> >> > > > https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/
> >> > > > shows below results:
> >> > > >
> >> > > >     Test env:
> >> > > >     CPU: AMD EPYC 7742 64-Core Processor
> >> > > >     2 vCPUs pinned 1:1
> >> > > >     idle=poll
> >> > > >
> >> > > >     Test result (average ns per IPI of lots of running):
> >> > > >     PV_SEND_IPI      : 1860
> >> > > >     AVIC             : 1390
> >> > > >
> >> > > > Besides, disscussions in https://lkml.org/lkml/2021/10/20/423
> >> > > > do have some solid performance test results to this.
> >> > > >
> >> > > > This patch fixes this by masking out PV_SEND_IPI feature when
> >> > > > AVIC is enabled in setting up of guest vCPUs' CPUID.
> >> > > >
> >> > > > Signed-off-by: Kele Huang <huangkele@bytedance.com>
> >> > >
> >> > > AVIC can change across migration.  I think we should instead use a new
> >> > > KVM_HINTS_* bit (KVM_HINTS_ACCELERATED_LAPIC or something like that).
> >> > > The KVM_HINTS_* bits are intended to be changeable across migration,
> >> > > even though we don't have for now anything equivalent to the Hyper-V
> >> > > reenlightenment interrupt.
> >> >
> >> > Note that the same issue exists with HyperV. It also has PV APIC,
> >> > which is harmful when AVIC is enabled (that is guest uses it instead
> >> > of using AVIC, negating AVIC benefits).
> >> >
> >> > Also note that Intel recently posted IPI virtualizaion, which
> >> > will make this issue relevant to APICv too soon.
> >>
> >> The recently posted Intel IPI virtualization will accelerate unicast
> >> ipi but not broadcast ipis, AMD AVIC accelerates unicast ipi well but
> >> accelerates broadcast ipis worse than pv ipis. Could we just handle
> >> unicast ipi here?
> >>
> >>      Wanpeng
> >>
> >Depend on the number of target vCPUs, broadcast IPIs gets unstable
> >performance on AVIC, and usually worse than PV Send IPI.
> >So agree with Wanpeng's point, is it possible to separate single IPI and
> >broadcast IPI on a hardware acceleration platform?
>
> Actually, this is how kernel works in x2apic mode: use PV interface
> (hypercall) to send multi-cast IPIs and write ICR MSR directly to send
> unicast IPIs.
>
> But if guest works in xapic mode, both unicast and multi-cast are issued
> via PV interface. It is a side-effect introduced by commit aaffcfd1e82d.
>
> how about just correcting the logic for xapic:
>
> From 13447b221252b64cd85ed1329f7d917afa54efc8 Mon Sep 17 00:00:00 2001
> From: Jiaqing Zhao <jiaqing.zhao@intel.com>
> Date: Fri, 9 Apr 2021 13:53:39 +0800
> Subject: [PATCH 1/2] x86/apic/flat: Add specific send IPI logic
>
> Currently, apic_flat.send_IPI() uses default_send_IPI_single(), which
> is a wrapper of apic->send_IPI_mask(). Since commit aaffcfd1e82d
> ("KVM: X86: Implement PV IPIs in linux guest"), KVM PV IPI driver will
> override apic->send_IPI_mask(), and may cause unwated side effects.
>
> This patch removes such side effects by creating a specific send_IPI
> method.

This looks reasonable to me.

    Wanpeng
