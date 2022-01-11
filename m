Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523D548A63D
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 04:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiAKDZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 22:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346717AbiAKDY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 22:24:56 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF51C061748
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 19:24:55 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id s8-20020a0568301e0800b00590a1c8cc08so11343056otr.9
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 19:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vt6eTIkW2rjgsDlp2Z3piPi66iajGtL8d5EhM3+JwDc=;
        b=PDZZMBR3ILiRIPUN7aXI728zpXb1y8zLSKQ+ENdryuEu01RNFHW3NFifiIvPv5NTkt
         gQvucQoKuoyoiBdHwegVWLXrARPhRgbk37t3X/nUIkLw+ZvCwRXcGIVo5C5GRM0ay+r5
         sKCIFheAYgxBzU5ddo8oHeh80RHyypLkVEBnN+pX5Z0w63O/+NwuyCH63nu0gRwEqq1W
         hickR/I8duDLsKa5m4fmwUMzVG6somKefc2CbIi+Nvw+ulu3T4VEl9uY24SAmZjrUUPV
         8UhgRYdeJDh/pPhC9Ycg1dqKbFzgIbilUSUCq8pkXSd6nbiXDUI6gvK881OlAT+XnwoB
         AxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vt6eTIkW2rjgsDlp2Z3piPi66iajGtL8d5EhM3+JwDc=;
        b=Fpbz55krO6hS6EkG18z1Po1CsGEpdfibbp/CpLegdfEkNBe7l6nnP9C0nLoWrGTi1j
         sOPsTua3HNi9RdIfhDh2gZK8QXueL75qb3CDjNNh/aUZJIgtvFDYSz/bJVrQuKeZaBha
         wnos8EXi5VjYTFGDO/0ScELCbn+LWSQS5GzUs+E5Z3nyF6gEv4c9Dcg9dNINz25wPOqx
         n4kVzdGYwgCIuUxTQ1IpBRloRSYVXet5chD+UM2GBpU4EYG0g0gy2/Cjrzzl4ty+C63B
         Sd/P/CUwvJVx/IkAJHiqcdRaFOt1fCFuBgJJmRTcQRnyinWypvKOE9inWDLnhnJVjqlG
         V0PA==
X-Gm-Message-State: AOAM532VZvXJX56z1wgWe9BJJ0n0je781ZakWlq4E1YiMeysNKLcQetC
        +aPRp/xqfaDwlyOR/OQlQ7jpNeoKNOeoBsYZCVL7FA==
X-Google-Smtp-Source: ABdhPJxN1qdnCnvDwG4vqV5IYMMsFcmQo3pz7JTnaUYQacPcCthQJujAOML/NRV8FYO5TPRfc2jv+EkJnWYW5eq2qqA=
X-Received: by 2002:a05:6830:441f:: with SMTP id q31mr2162701otv.14.1641871494663;
 Mon, 10 Jan 2022 19:24:54 -0800 (PST)
MIME-Version: 1.0
References: <20211117080304.38989-1-likexu@tencent.com> <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eRA8hw9zVEwnZEX56Gao-MibX5A+XXYS-n-+X0BkhrSvQ@mail.gmail.com>
 <438d42de-78e1-0ce9-6a06-38194de4abd4@redhat.com> <CALMp9eSLU1kfffC3Du58L8iPY6LmKyVO0yU7c3wEnJAD9JZw4w@mail.gmail.com>
 <CALMp9eR3PEgXhe_z8ArHK0bPeW4=htta_f3LHTm9jqL2rtcT7A@mail.gmail.com>
 <a2b6fb82-292b-f714-cfd7-31a5310c28ed@gmail.com> <CALMp9eQbiqjf_MMJP9Cc9=Ubm7qKv88BXtu3=7z8ax9W_1AY4Q@mail.gmail.com>
 <1f293656-49f5-ce02-1c59-a0f215306033@gmail.com>
In-Reply-To: <1f293656-49f5-ce02-1c59-a0f215306033@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Jan 2022 19:24:43 -0800
Message-ID: <CALMp9eTqMMia0Vx=kfGpQVHVYvSCDtuBN1eDr12cop0EAzCSaw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU virtualization
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 6:11 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 11/1/2022 2:13 am, Jim Mattson wrote:
> > On Sun, Jan 9, 2022 at 10:23 PM Like Xu <like.xu.linux@gmail.com> wrote:
> >>
> >> On 9/1/2022 9:23 am, Jim Mattson wrote:
> >>> On Fri, Dec 10, 2021 at 7:48 PM Jim Mattson <jmattson@google.com> wrote:
> >>>>
> >>>> On Fri, Dec 10, 2021 at 6:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>>>>
> >>>>> On 12/10/21 20:25, Jim Mattson wrote:
> >>>>>> In the long run, I'd like to be able to override this system-wide
> >>>>>> setting on a per-VM basis, for VMs that I trust. (Of course, this
> >>>>>> implies that I trust the userspace process as well.)
> >>>>>>
> >>>>>> How would you feel if we were to add a kvm ioctl to override this
> >>>>>> setting, for a particular VM, guarded by an appropriate permissions
> >>>>>> check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?
> >>>>>
> >>>>> What's the rationale for guarding this with a capability check?  IIRC
> >>>>> you don't have such checks for perf_event_open (apart for getting kernel
> >>>>> addresses, which is not a problem for virtualization).
> >>>>
> >>>> My reasoning was simply that for userspace to override a mode 0444
> >>>> kernel module parameter, it should have the rights to reload the
> >>>> module with the parameter override. I wasn't thinking specifically
> >>>> about PMU capabilities.
> >>
> >> Do we have a precedent on any module parameter rewriting for privileger ?
> >>
> >> A further requirement is whether we can dynamically change this part of
> >> the behaviour when the guest is already booted up.
> >>
> >>>
> >>> Assuming that we trust userspace to decide whether or not to expose a
> >>> virtual PMU to a guest (as we do on the Intel side), perhaps we could
> >>> make use of the existing PMU_EVENT_FILTER to give us per-VM control,
> >>> rather than adding a new module parameter for per-host control. If
> >>
> >> Various granularities of control are required to support vPMU production
> >> scenarios, including per-host, per-VM, and dynamic-guest-alive control.
> >>
> >>> userspace calls KVM_SET_PMU_EVENT_FILTER with an action of
> >>> KVM_PMU_EVENT_ALLOW and an empty list of allowed events, KVM could
> >>> just disable the virtual PMU for that VM.
> >>
> >> AMD will also have "CPUID Fn8000_0022_EBX[NumCorePmc, 3:0]".
> >
> > Where do you see this? Revision 3.33 (November 2021) of the AMD APM,
> > volume 3, only goes as high as CPUID Fn8000_0021.
>
> Try APM Revision: 4.04 (November 2021),  page 1849/3273,
> "CPUID Fn8000_0022_EBX Extended Performance Monitoring and Debug".

Is this a public document?

> Given the current ambiguity in this revision, the AMD folks will reveal more
> details bout this field in the next revision.
>
> >
> >>>
> >>> Today, the semantics of an empty allow list are quite different from
> >>> the proposed pmuv module parameter being false. However, it should be
> >>> an easy conversion. Would anyone be concerned about changing the
> >>> current semantics of an empty allow list? Is there a need for
> >>> disabling PMU virtualization for legacy userspace implementations that
> >>> can't be modified to ask for an empty allow list?
> >>>
> >>
> >> AFAI, at least one user-space agent has integrated with it plus additional
> >> "action"s.
> >>
> >> Once the API that the kernel presents to user space has been defined,
> >> it's best not to change it and instead fall into remorse.
> >
> > Okay.
> >
> > I propose the following:
> > 1) The new module parameter should apply to Intel as well as AMD, for
> > situations where userspace is not trusted.
> > 2) If the module parameter allows PMU virtualization, there should be
> > a new KVM_CAP whereby userspace can enable/disable PMU virtualization.
> > (Since you require a dynamic toggle, and there is a move afoot to
> > refuse guest CPUID changes once a guest is running, this new KVM_CAP
> > is needed on Intel as well as AMD).
>
> Both hands in favour. Do you need me as a labourer, or you have a ready-made one ?

We could split the work. Since (1) is a modification of the change you
proposed in this thread, perhaps you could apply it to both AMD and
Intel in v2? We can find someone for (2).

> > 3) If the module parameter does not allow PMU virtualization, there
> > should be no userspace override, since we have no precedent for
> > authorizing that kind of override.
>
> Uh, I thought you (Google) had a lot of these (interesting) use cases internally.

We have modified some module parameters so that they can be changed at
runtime, but we don't have any concept of a privileged userspace
overriding a module parameter restriction.

> >
> >> "But I am not a decision maker. " :D
> >>
> >> Thanks,
> >> Like Xu
> >>
