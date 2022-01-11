Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E091D48A859
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 08:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348503AbiAKHZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 02:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348490AbiAKHZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 02:25:27 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BF6C061748
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 23:25:26 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id w188so632628oiw.13
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 23:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bId8hV3sd5+4VtQFgHlCJzB4lD2gDKbX1HVM1usAgyU=;
        b=G0lsTGsyexUBs9MlWSFXPM8Xf0Lhw1/LEbVLY1GzRvAScBj4JxwvgR5S1Jbx7aKwoW
         uwXS4rO72vRgna0qMbUFL3E5CZa92ie0YVOl7gQI0SrImSEI3lo1HSc78OnF6sOifEQ8
         VEb00iAjUaD8d5AQ1Q/gxjYxdxyMhG4feviVseu8ZFceWordbMpkE+wHEUo/eChwq3D9
         nG8hEgIqAnwBmAiwxJJzUwGdw0aoCQSZMzrvjtmAZQwNQe0/SiK0pROVV1YRW41ivaKi
         KeDe8zUfiNuhQ28UhxYp+pR707nzC9TrV6kxj+d+yKAcFX+8fN/y3to6H271f2nH80Ij
         ZWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bId8hV3sd5+4VtQFgHlCJzB4lD2gDKbX1HVM1usAgyU=;
        b=MgXO/8mHFcQSMfTXH/pIkJWp410mbseh7nqEeqQJQJCAueXwHgE4PhcJaEXoolrCcw
         TdoHc/oxQ1Qr7b2rYRK+GYGpRBJ2FlHVW0xJk+l8EH0ErYdNzUTs82JFPuTb5KfGU7vd
         t95ixdoYIhOZhcPylX3hQrgN6sWk/5z7T7o3ycIP0lZzruL7Lo7c5xRl/1SKvFAZecB7
         QETNKD0doNl2NvbgFwBlz3iP48leN69c80+s4I6h1VZub8imEsDdM+tONWzIqEAc2KPw
         ocMfgM+lGwu2jCzHD42G7puyp9WBlB4kbw5DLNH3ycIXpmd1+6He2lt/0scM74y1kKjT
         dwsw==
X-Gm-Message-State: AOAM532f7aFohZXsjY0yvNL5+qgRj9x3WUjDujLtWi9ZL2SAJY4uzBZd
        WCzn5+NeM4/B6CQpGncZsVRGzO//z5848s2ROlEOBg==
X-Google-Smtp-Source: ABdhPJwU16Bh7OEUO1U6L8EsFD4PAamtUcyC7sQuHuMjY0xJIXXeXkcPPSevbUiisN1DS8xdoCzmi+CNdmyxpK/xCZY=
X-Received: by 2002:a05:6808:ddd:: with SMTP id g29mr966769oic.66.1641885925876;
 Mon, 10 Jan 2022 23:25:25 -0800 (PST)
MIME-Version: 1.0
References: <20211117080304.38989-1-likexu@tencent.com> <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eRA8hw9zVEwnZEX56Gao-MibX5A+XXYS-n-+X0BkhrSvQ@mail.gmail.com>
 <438d42de-78e1-0ce9-6a06-38194de4abd4@redhat.com> <CALMp9eSLU1kfffC3Du58L8iPY6LmKyVO0yU7c3wEnJAD9JZw4w@mail.gmail.com>
 <CALMp9eR3PEgXhe_z8ArHK0bPeW4=htta_f3LHTm9jqL2rtcT7A@mail.gmail.com>
 <a2b6fb82-292b-f714-cfd7-31a5310c28ed@gmail.com> <CALMp9eQbiqjf_MMJP9Cc9=Ubm7qKv88BXtu3=7z8ax9W_1AY4Q@mail.gmail.com>
 <1f293656-49f5-ce02-1c59-a0f215306033@gmail.com> <CALMp9eTqMMia0Vx=kfGpQVHVYvSCDtuBN1eDr12cop0EAzCSaw@mail.gmail.com>
 <7fa1a2d8-040c-1485-41ae-ad51f1182bdb@gmail.com>
In-Reply-To: <7fa1a2d8-040c-1485-41ae-ad51f1182bdb@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Jan 2022 23:25:14 -0800
Message-ID: <CALMp9eTYnY31KLG3c5+CiZ2Teav2VNg5-SsNm0Q7rs8WKTCWJA@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 10:18 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 11/1/2022 11:24 am, Jim Mattson wrote:
> > On Mon, Jan 10, 2022 at 6:11 PM Like Xu <like.xu.linux@gmail.com> wrote=
:
> >>
> >> On 11/1/2022 2:13 am, Jim Mattson wrote:
> >>> On Sun, Jan 9, 2022 at 10:23 PM Like Xu <like.xu.linux@gmail.com> wro=
te:
> >>>>
> >>>> On 9/1/2022 9:23 am, Jim Mattson wrote:
> >>>>> On Fri, Dec 10, 2021 at 7:48 PM Jim Mattson <jmattson@google.com> w=
rote:
> >>>>>>
> >>>>>> On Fri, Dec 10, 2021 at 6:15 PM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
> >>>>>>>
> >>>>>>> On 12/10/21 20:25, Jim Mattson wrote:
> >>>>>>>> In the long run, I'd like to be able to override this system-wid=
e
> >>>>>>>> setting on a per-VM basis, for VMs that I trust. (Of course, thi=
s
> >>>>>>>> implies that I trust the userspace process as well.)
> >>>>>>>>
> >>>>>>>> How would you feel if we were to add a kvm ioctl to override thi=
s
> >>>>>>>> setting, for a particular VM, guarded by an appropriate permissi=
ons
> >>>>>>>> check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?
> >>>>>>>
> >>>>>>> What's the rationale for guarding this with a capability check?  =
IIRC
> >>>>>>> you don't have such checks for perf_event_open (apart for getting=
 kernel
> >>>>>>> addresses, which is not a problem for virtualization).
> >>>>>>
> >>>>>> My reasoning was simply that for userspace to override a mode 0444
> >>>>>> kernel module parameter, it should have the rights to reload the
> >>>>>> module with the parameter override. I wasn't thinking specifically
> >>>>>> about PMU capabilities.
> >>>>
> >>>> Do we have a precedent on any module parameter rewriting for privile=
ger ?
> >>>>
> >>>> A further requirement is whether we can dynamically change this part=
 of
> >>>> the behaviour when the guest is already booted up.
> >>>>
> >>>>>
> >>>>> Assuming that we trust userspace to decide whether or not to expose=
 a
> >>>>> virtual PMU to a guest (as we do on the Intel side), perhaps we cou=
ld
> >>>>> make use of the existing PMU_EVENT_FILTER to give us per-VM control=
,
> >>>>> rather than adding a new module parameter for per-host control. If
> >>>>
> >>>> Various granularities of control are required to support vPMU produc=
tion
> >>>> scenarios, including per-host, per-VM, and dynamic-guest-alive contr=
ol.
> >>>>
> >>>>> userspace calls KVM_SET_PMU_EVENT_FILTER with an action of
> >>>>> KVM_PMU_EVENT_ALLOW and an empty list of allowed events, KVM could
> >>>>> just disable the virtual PMU for that VM.
> >>>>
> >>>> AMD will also have "CPUID Fn8000_0022_EBX[NumCorePmc, 3:0]".
> >>>
> >>> Where do you see this? Revision 3.33 (November 2021) of the AMD APM,
> >>> volume 3, only goes as high as CPUID Fn8000_0021.
> >>
> >> Try APM Revision: 4.04 (November 2021),  page 1849/3273,
> >> "CPUID Fn8000_0022_EBX Extended Performance Monitoring and Debug".
> >
> > Is this a public document?
>
> The latest version of APM (40332) is revision v4.04, released on 12/1/202=
1.

LOL. I was misled by the table of contents for Appendix E.4, which
stops at E.4.19 Function 8000_0021=E2=80=94Extended Feature Identification =
2.

> >
> >> Given the current ambiguity in this revision, the AMD folks will revea=
l more
> >> details bout this field in the next revision.
> >>
> >>>
> >>>>>
> >>>>> Today, the semantics of an empty allow list are quite different fro=
m
> >>>>> the proposed pmuv module parameter being false. However, it should =
be
> >>>>> an easy conversion. Would anyone be concerned about changing the
> >>>>> current semantics of an empty allow list? Is there a need for
> >>>>> disabling PMU virtualization for legacy userspace implementations t=
hat
> >>>>> can't be modified to ask for an empty allow list?
> >>>>>
> >>>>
> >>>> AFAI, at least one user-space agent has integrated with it plus addi=
tional
> >>>> "action"s.
> >>>>
> >>>> Once the API that the kernel presents to user space has been defined=
,
> >>>> it's best not to change it and instead fall into remorse.
> >>>
> >>> Okay.
> >>>
> >>> I propose the following:
> >>> 1) The new module parameter should apply to Intel as well as AMD, for
> >>> situations where userspace is not trusted.
> >>> 2) If the module parameter allows PMU virtualization, there should be
> >>> a new KVM_CAP whereby userspace can enable/disable PMU virtualization=
.
> >>> (Since you require a dynamic toggle, and there is a move afoot to
> >>> refuse guest CPUID changes once a guest is running, this new KVM_CAP
> >>> is needed on Intel as well as AMD).
> >>
> >> Both hands in favour. Do you need me as a labourer, or you have a read=
y-made one ?
> >
> > We could split the work. Since (1) is a modification of the change you
> > proposed in this thread, perhaps you could apply it to both AMD and
>
> We obviously need extra code to make the module parameters suitable for I=
ntel
> since it
> affects other features (such as LBR and PEBS), we may not rush to draw th=
is line
> clearly.
>
> > Intel in v2? We can find someone for (2).
>
> The ioctl_set_pmu_event_filter() interface is already practical for dynam=
ic toggle,
> as not being able to program any events is the same as having none vPMU,
> w/o considering performance impact of traversing the list.

Not being able to program any events is actually not the same as
setting the pmuv module parameter to false. In the former case,
prohibited events simply don't advance the counters. In the latter
case, all accesses to the PMU MSRs raise #GP. That was what I meant
earlier, when I said that we would have to change the semantics of an
empty allow list if we want to match the behavior of pmuv=3D0.

> I am not sure if the maintainer will buy in another KVM_CAP for only per-=
VM,
> considering
> "CPUID Fn8000_0022_EBX[NumCorePmc, 3:0]" is a feature that will be availa=
ble soon.

For existing guests, the future availability of that feature is
irrelevant. We're going to need another solution that doesn't involve
recompiling every guest kernel.

> >
> >>> 3) If the module parameter does not allow PMU virtualization, there
> >>> should be no userspace override, since we have no precedent for
> >>> authorizing that kind of override.
> >>
> >> Uh, I thought you (Google) had a lot of these (interesting) use cases =
internally.
> >
> > We have modified some module parameters so that they can be changed at
> > runtime, but we don't have any concept of a privileged userspace
> > overriding a module parameter restriction.
>
> Considering that the semantics of the different module parameters are dif=
ferent,
> allowing one of them to be overridden does not mean that such a generic f=
ramework
> is promising, but it makes sense for the community to see another case fo=
r it.
>
> >
> >>>
> >>>> "But I am not a decision maker. " :D
> >>>>
> >>>> Thanks,
> >>>> Like Xu
> >>>>
> >
