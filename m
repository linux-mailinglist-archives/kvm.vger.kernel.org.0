Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643411D898C
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 22:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgERUpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 16:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERUpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 16:45:44 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2065F20849
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 20:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589834743;
        bh=m0qDc2rqhbYfXzUhdgSURC1JfnDA7BV3Q1x+hiVOdJg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bdXQSf2pAvowX+dXYkD1lb7HPOLv/PGjTl0dkf5fUSTOVJXEkCO9AMQXHani8vjaR
         nVU5XE6shDDRqJb0YbpMoW1+HSwA52Qte+s5flOlZBv4ULrNbed159JOU5MqlZ+L++
         qMZhvn3Sc/okuegyGXdi3yatOVuPsNFSihG38yAM=
Received: by mail-wm1-f47.google.com with SMTP id z4so851729wmi.2
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 13:45:43 -0700 (PDT)
X-Gm-Message-State: AOAM532cdwyWvqMYVk7JzUTJ4ZAr44AJkv6O6/yP0Fv3Dy99/2BPZMi9
        bD6OYiMWDqkV65+Bl820bawOdX9oST+OePT19K99YQ==
X-Google-Smtp-Source: ABdhPJx74MCALT/pra6bLUZ0ByZ9NJrr/WbfqwQKtkG5VsYQr7lPeTeDLdtzrMRIkUVLWmR0I2kPQpVXvHf7FyLTN/0=
X-Received: by 2002:a1c:9989:: with SMTP id b131mr1256561wme.176.1589834741453;
 Mon, 18 May 2020 13:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1589784221.git.ananos@nubificus.co.uk> <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
 <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
In-Reply-To: <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 18 May 2020 13:45:29 -0700
X-Gmail-Original-Message-ID: <CALCETrVKJK43jHhFyDqEeAczVDkNp5QpFFpsy8vE7VAhpAyXDA@mail.gmail.com>
Message-ID: <CALCETrVKJK43jHhFyDqEeAczVDkNp5QpFFpsy8vE7VAhpAyXDA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
To:     Anastassios Nanos <ananos@nubificus.co.uk>
Cc:     Marc Zyngier <maz@kernel.org>, kvm list <kvm@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 18, 2020 at 1:50 AM Anastassios Nanos
<ananos@nubificus.co.uk> wrote:
>
> On Mon, May 18, 2020 at 10:50 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On 2020-05-18 07:58, Anastassios Nanos wrote:
> > > To spawn KVM-enabled Virtual Machines on Linux systems, one has to us=
e
> > > QEMU, or some other kind of VM monitor in user-space to host the vCPU
> > > threads, I/O threads and various other book-keeping/management
> > > mechanisms.
> > > This is perfectly fine for a large number of reasons and use cases: f=
or
> > > instance, running generic VMs, running general purpose Operating
> > > systems
> > > that need some kind of emulation for legacy boot/hardware etc.
> > >
> > > What if we wanted to execute a small piece of code as a guest instanc=
e,
> > > without the involvement of user-space? The KVM functions are already
> > > doing
> > > what they should: VM and vCPU setup is already part of the kernel, th=
e
> > > only
> > > missing piece is memory handling.
> > >
> > > With these series, (a) we expose to the Linux Kernel the bare minimum
> > > KVM
> > > API functions in order to spawn a guest instance without the
> > > intervention
> > > of user-space; and (b) we tweak the memory handling code of KVM-relat=
ed
> > > functions to account for another kind of guest, spawned in
> > > kernel-space.
> > >
> > > PATCH #1 exposes the needed stub functions, whereas PATCH #2 introduc=
es
> > > the
> > > changes in the KVM memory handling code for x86_64 and aarch64.
> > >
> > > An example of use is provided based on kvmtest.c
> > > [http://email.nubificus.co.uk/c/eJwdzU0LgjAAxvFPo0eZm1t62MEkC0xQScJTu=
BdfcGrpQuvTN4KHP7_bIygSDQfY7mkUXotbzQJQftIX7NI9EtEYofOW3eMJ6uTxTtIqz2B1LPhl=
-w6nMrc8MNa9ctp_-TzaHWUekxwfSMCRIA3gLvFrQAiGDUNE-MxWtNP6uVootGBsprbJmaQ2Chf=
dcyVXQ4J97EIDe6G7T8zRIJdJKmde2h_0WTe_] at
> > > http://email.nubificus.co.uk/c/eJwljdsKgkAYhJ9GL2X9NQ8Xe2GSBSaoJOFVrO=
t6QFdL17Sevq1gGPhmGKbERllRtFNb7Hvn9EIKF2Wv6AFNtPmlz33juMbXYAAR3pYwypMY8n1KT=
-u7O2SJYiJO2l6rf05HrjbYsCihRUEp2DYCgmyH2TowGeiVCS6oPW6EuM-K4SkQSNWtaJbiu5ZA=
-3EpOzYNrJ8ldk_OBZuFOuHNseTdv9LGqf4Apyg8eg
>
> Hi Marc,
>
> thanks for taking the time to check this!
>
> >
> > You don't explain *why* we would want this. What is the overhead of
> > having
> > a userspace if your guest doesn't need any userspace handling? The
> > kvmtest
> > example indeed shows that the KVM userspace API is usable  without any
> > form
> > of emulation, hence has almost no cost.
>
> The rationale behind such an approach is two-fold:
> (a) we are able to ditch any user-space involvement in the creation and
> spawning of a KVM guest. This is particularly interesting in use-cases
> where short-lived tasks are spawned on demand.  Think of a scenario where
> an ABI compatible binary is loaded in memory.  Spawning it as a guest fro=
m
> userspace would incur a number of IOCTLs. Doing the same from the kernel
> would be the same number of IOCTLs but now these are function calls;
> additionally, memory handling is kind of simplified.
>
> (b) I agree that the userspace KVM API is usable without emulation for a
> simple task, written in bytecode, adding two registers. But what about
> something more complicated? something that needs I/O? for most use-cases,
> I/O happens between the guest and some hardware device (network/storage
> etc.). Being in the kernel saves us from doing unneccessary mode switches=
.
> Of course there are optimizations for handling I/O on QEMU/KVM VMs
> (virtio/vhost), but essentially what happens is removing mode-switches (a=
nd
> exits) for I/O operations -- is there a good reason not to address that
> directly? a guest running in the kernel exits because of an I/O request,
> which gets processed and forwarded directly to the relevant subsystem *in=
*
> the kernel (net/block etc.).
>
> We work on both directions with a particular focus on (a) -- device I/O c=
ould
> be handled with other mechanisms as well (VFs for instance).
>
> > Without a clear description of the advantages of your solution, as well
> > as a full featured in-tree use case, I find it pretty hard to support
> > this.
>
> Totally understand that -- please keep in mind that this is a first (baby=
)
> step for what we call KVMM (kernel virtual machine monitor). We presented
> the architecture at FOSDEM and some preliminary results regarding I/O. Of
> course, this is WiP, and far from being upstreamable. Hence the kvmmtest
> example showcasing the potential use-case.
>
> To be honest my main question is whether we are interested in such an
> approach in the first place, and then try to work on any rough edges. As
> far as I understand, you're not in favor of this approach.

The usual answer here is that the kernel is not in favor of adding
in-kernel functionality that is not used in the upstream kernel.  If
you come up with a real use case, and that use case is GPL and has
plans for upstreaming, and that use case has a real benefit
(dramatically faster than user code could likely be, does something
new and useful, etc), then it may well be mergeable.
