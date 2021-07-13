Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C29C3C7573
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 19:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhGMRDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 13:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhGMRD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 13:03:29 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B83C0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:00:38 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id n24-20020a4ad4180000b029025bcb88a40eso4555077oos.2
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Iyd71zygjkALjfNR6BPtRYHIjCwkNZJ9IWsAmCWNWXw=;
        b=oKG33raUTfKzmue0/xiWngowvVuZ7RSY1xx8Sx1DoVgB3k2tEzmLQ7QtloH25idFhA
         t5lNmLZjvGvaqzuYNAQ/yr9gAivPmkHzwf3xNPDHMW3V/NqHja7EAIkvVaVkGBp84tHQ
         V0QTMzJK4KWJ1d75E9EA5/VjCKGALSKuFYfgC+UqT7HzjcYD1vopRSD9OKqrroRmfOXr
         IbZAxQr+DV0kMIBMpWryUgeW4bX2SgqL6gWN7DJgkmwArwMW8eRd6Q8u0a67oiXyPEGc
         gfBajshntHIiMg2ZHWfggkbKdj0Bav1/ng5lOPx406nUKKLLifhDOJFnugw8bV3DhAJQ
         A8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Iyd71zygjkALjfNR6BPtRYHIjCwkNZJ9IWsAmCWNWXw=;
        b=gSr38Y/0fYA+xIayEa1OwMwqg1qGS4hyzv1m9kmcbOEpzGWrRd4suYEJtr76E9LEh6
         R/gHN3o3Ys3bQGb5XbsYWVR8/qMLTIr5g38GXquyAimioZ/qQ6GRYvqEr2f7kScEVNjd
         3hMy/Sf3eQFNf5v9Rbw9r6Ypeb2oy2wQISrw6ds4Qg7DuLUXmjTRgETL7pJKClEHmrPQ
         8aaVEWoEv3d2gOXMc6wSl9pqBD1VpFr/uVq3tErAI+AK5n7CvRG3+AX6Dz5Bz606T7lH
         b/Lucrg7U8tUMg5B9evtrFp43XJtBVSUlaW2c1VlC/bc/jKo1BKQ0TSfu+FUs1jqkQ1w
         CHNw==
X-Gm-Message-State: AOAM532d8YRXoGYpoo48KEy9lqVs3Duu9Q4Ouou3E6J0RYJ5QP/9Do29
        Cyi/1zy3SunZ7fLpto5be/GT61/hV51/PlM5SM4AGA==
X-Google-Smtp-Source: ABdhPJyqUdx2+4+LH6kBnhmxtFqnpOsDAQJfiUPsPfAEV+M0wliH2RWETipy/jfG0iVPnPrspcVq4wo7J5wooPYl31k=
X-Received: by 2002:a4a:6c0c:: with SMTP id q12mr4290748ooc.81.1626195636387;
 Tue, 13 Jul 2021 10:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
 <20210712095305.GE12162@intel.com> <d73eb316-4e09-a924-5f60-e3778db91df4@gmail.com>
 <CALMp9eQmK+asv7fXeUpF2UiRKL7VmZx44HMGj67aSqm0k9nKVg@mail.gmail.com>
 <CALMp9eSWDmWerj5CaxRyMiNqnBf1akHHaWV2Cfq_66Xjg-0MEw@mail.gmail.com> <12a3e8e4-3183-9917-c9d5-59ab257b8fd3@gmail.com>
In-Reply-To: <12a3e8e4-3183-9917-c9d5-59ab257b8fd3@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 13 Jul 2021 10:00:25 -0700
Message-ID: <CALMp9eROgWVBe1NuqD46xbgXHedgAFW1EMFX5zW-_Ee5enHmnw@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL state
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 2:49 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 13/7/2021 1:45 am, Jim Mattson wrote:
> > On Mon, Jul 12, 2021 at 10:20 AM Jim Mattson <jmattson@google.com> wrot=
e:
> >>
> >> On Mon, Jul 12, 2021 at 3:19 AM Like Xu <like.xu.linux@gmail.com> wrot=
e:
> >>>
> >>> On 12/7/2021 5:53 pm, Yang Weijiang wrote:
> >>>> On Fri, Jul 09, 2021 at 04:41:30PM -0700, Jim Mattson wrote:
> >>>>> On Fri, Jul 9, 2021 at 3:54 PM Jim Mattson <jmattson@google.com> wr=
ote:
> >>>>>>
> >>>>>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.=
com> wrote:
> >>>>>>>
> >>>>>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> >>>>>>> and reload it after vm-exit.
> >>>>>>
> >>>>>> I don't see anything being done here "before VM-entry" or "after
> >>>>>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
> >>>>>>
> >>>>>> In any case, I don't see why this one MSR is special. It seems tha=
t if
> >>>>>> the host is using the architectural LBR MSRs, then *all* of the ho=
st
> >>>>>> architectural LBR MSRs have to be saved on vcpu_load and restored =
on
> >>>>>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() =
do
> >>>>>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) an=
d
> >>>>>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
> >>>>>
> >>>>> It does seem like there is something special about IA32_LBR_DEPTH, =
though...
> >>>>>
> >>>>> Section 7.3.1 of the Intel=C2=AE Architecture Instruction Set Exten=
sions
> >>>>> and Future Features Programming Reference
> >>>>> says, "IA32_LBR_DEPTH is saved by XSAVES, but it is not written by
> >>>>> XRSTORS in any circumstance." It seems like that would require some
> >>>>> special handling if the host depth and the guest depth do not match=
.
> >>>> In our vPMU design, guest depth is alway kept the same as that of ho=
st,
> >>>> so this won't be a problem. But I'll double check the code again, th=
anks!
> >>>
> >>> KVM only exposes the host's depth value to the user space
> >>> so the guest can only use the same depth as the host.
> >>
> >> The allowed depth supplied by KVM_GET_SUPPORTED_CPUID isn't enforced,
> >> though, is it?
>
> Like other hardware dependent features, the functionality will not
> promise to work properly if the guest uses the unsupported CPUID.

It's fine if it doesn't work in the guest, but can't a guest with the
wrong depth prevent the host LBRs from being reloaded when switching
back to the host state? It's definitely not okay for an ill-configured
guest to break host functionality.

> >
> > Also, doesn't this end up being a major constraint on future
> > platforms? Every host that this vCPU will ever run on will have to use
> > the same LBR depth as the host on which it was started.
> >
>
> As a first step, we made the guest LBR feature only available for the
> "migratable=3Doff" user space, which is why we intentionally did not add
> MSR_ARCH_LBR_* stuff to msrs_to_save_all[] in earlier versions.

We have no such concept in our user space. Features that are not
migratable should clearly be identified as such by an appropriate KVM
API. At present, I don't believe there is such an API.

> But hopefully, we may make it at least migratable for Arch LBR.
>
> I'm personally curious about the cost of using XSAVES to swicth
> guest lbr msrs during vmx transaction, and if the cost is unacceptable,
> we may ask the perf host to adjust different depths for threads.
>
>
