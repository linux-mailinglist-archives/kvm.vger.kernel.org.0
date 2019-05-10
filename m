Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318F319AEF
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 11:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfEJJxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 05:53:45 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41240 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbfEJJxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 05:53:45 -0400
Received: by mail-ot1-f65.google.com with SMTP id g8so5020998otl.8
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 02:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FTwY+p9wC/tSMZYtuzYFlvLy9tk15X2oHV+NC6Pb1KM=;
        b=D3CMaP9a1463B+1iYZqyDGwBKDvsUONLoQcc5RxDKw4NLqbOBMvK3UJMn0KsLR9jQw
         Sa9g/6VTKTTHm8IIRojGeQh/CrgrQgZW+9aha6Q0ebvTFzoLO1QOwy3ZEO7KjPon4vxu
         haJ12ychcyWNb08GQO7Q2GSJwoMoOAQcFxrE9sFuJwNpOfpG2IcXxOO5DL7PSbrjpDAv
         qIYj6z5viHWWL8gySFzLi5BrDUtLtTkiqa4gQJQ/Y8MRydjibRXVp1l4ArZrgMpY6wdC
         /obvweeTNtgsKaEeXctEwsBpvsXKTjw1cEJOGOm/ZDjE6L9qAiaD1JHmS57CnSotxUqp
         JEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FTwY+p9wC/tSMZYtuzYFlvLy9tk15X2oHV+NC6Pb1KM=;
        b=O5S7RFTW6C6VZEcjUul+voVxaFwvDVbPz74jLk5syS0DbK9ecMkAoo9lSuLfAoJMPn
         seWEz1zJACowBuyPmwSRJ1C4sPouJcCQ9LGzg+uRVUnZ4xqyHw+GmMijAi2xaEcGYG4N
         Wk41+FpFU08u83gBEsubRcYjgyyofn+NWJCMH76uk2+lGXZ7/NUmsA63fBWzJfFYeoRS
         sjD68Yrkiz8eEeOPA1do6JNP1pAZU2vdcKXEhDhKKm/KL0ujwBkDmbauqzjQ+NS6WDJi
         grT70kDFyvuugZiDBGHjoOECONF1flsEBP7GmPfSC0OY418Vn225FZ6YDLL3MeSqEiCY
         lllw==
X-Gm-Message-State: APjAAAWB8paOjrClYvwiO7tUU2s8Ygb64BOuzipLWPWBaViBweRf87Kt
        dfz4UVCV+xuN1m+IHYMDaB22TQ51ibxqgoqY8HY=
X-Google-Smtp-Source: APXvYqz2CegxNLYz2qPDONbtaxak5szbocfl9Uh3U8oLuSDXMG9dWVTsFaL6LUcn2hSh3XoevbtlPrdQ+m0XU6gsnjU=
X-Received: by 2002:a9d:6013:: with SMTP id h19mr5845716otj.215.1557482024517;
 Fri, 10 May 2019 02:53:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190415154526.64709-1-liran.alon@oracle.com> <20190415181702.GH24010@linux.intel.com>
 <AD81166E-0C42-49FD-AC37-E6F385C23B13@oracle.com> <4848D424-F852-4E1C-8A86-6AA1A26D2E90@oracle.com>
 <2dad36e7-a0e5-9670-c902-819c5200466f@oracle.com>
In-Reply-To: <2dad36e7-a0e5-9670-c902-819c5200466f@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 10 May 2019 17:54:32 +0800
Message-ID: <CANRm+CyYkjFaLZMOHP3sMYVjFNo1P7uKbrRr7U3FfRHhG5jVkA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Nop emulation of MSR_IA32_POWER_CTL
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,
On Wed, 17 Apr 2019 at 03:18, Joao Martins <joao.m.martins@oracle.com> wrot=
e:
>
> On 4/16/19 4:40 PM, Liran Alon wrote:
> >> On 16 Apr 2019, at 18:21, Liran Alon <liran.alon@oracle.com> wrote:
> >>> On 15 Apr 2019, at 21:17, Sean Christopherson <sean.j.christopherson@=
intel.com> wrote:
> >>> On Mon, Apr 15, 2019 at 06:45:26PM +0300, Liran Alon wrote:
> >>>
> >>> Technically, I think this is a Qemu bug.  KVM reports all zeros for
> >>> CPUID_MWAIT_LEAF when userspace queries KVM_GET_SUPPORTED_CPUID and
> >>> KVM_GET_EMULATED_CPUID.  And I think that's correct/desired, supporti=
ng
> >>> MONITOR/MWAIT sub-features should be a separate enabling patch set.
> >>
> >> At some point in time Jim added commit df9cb9cc5bcd ("kvm: x86: Amend =
the KVM_GET_SUPPORTED_CPUID API documentation=E2=80=9D)
> >> which added the following paragraph to documentation:
> >> "Note that certain capabilities, such as KVM_CAP_X86_DISABLE_EXITS, ma=
y
> >> expose cpuid features (e.g. MONITOR) which are not supported by kvm in
> >> its default configuration. If userspace enables such capabilities, it
> >> is responsible for modifying the results of this ioctl appropriately.=
=E2=80=9D
> >>
> >> It=E2=80=99s indeed not clear what it means to =E2=80=9Cmodify the res=
ults of this ioctl *appropriately*=E2=80=9D right?
> >> It can either mean you just expose in CPUID[EAX=3D1].ECX support for M=
ONITOR/MWAIT
> >> or that you also expose CPUID_MWAIT_LEAF (CPUID[EAX=3D5]).
> >> Both regardless of the value returned from KVM_GET_SUPPORTED_CPUID ioc=
tl.
> >>
> >> Having said that, I tend to agree with you.
> >> Instead of emulating this MSR in KVM, I think it it preferred to chang=
e QEMU to expose MONITOR/MWAIT support in CPUID[EAX=3D1].ECX
> >> but in CPUID[EAX=3D5] init everything as in host besides ECX[0] which =
will be set to 0 to report we don=E2=80=99t support extensions.
> >> (We still want to support range of monitor line size, whether we can t=
reat interrupts as break-events for MWAIT and the supported C substates).
> >> I will create this patch for QEMU.
> >
> > Actually on second thought, I will just remain with the KVM patch (that=
 Paolo was nice enough to already queue).
> > and not do this QEMU patch. This is because why will we want to prevent=
 guest from specifying target C-State if he is exposed with MWAIT?
> > I don=E2=80=99t see a reason we should prevent that. Do you?
> >
> One reason it is a good idea to prevent the guest from entering deeper
> C-states (e.g. deeper than C2) is to allow preemption timer to be used ag=
ain
> when guests are exposed with MWAIT (currently we can't do that).

It is weird that we can observe intel_idle driver in the guest
executes mwait eax=3D0x20, and the corresponding pCPU enters C3 on HSW
server, however, we can't observe this on SKX/CLX server, it just
enters maximal C1. All the setups between HSW and SKX/CLX are the
same. Sean and Liran, any opinions?

Regards,
Wanpeng Li
