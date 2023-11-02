Return-Path: <kvm+bounces-426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA93B7DF914
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81447B21343
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0228E208CB;
	Thu,  2 Nov 2023 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UotzgL4+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0207208A4
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 17:46:13 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB668131
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 10:46:11 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so1438a12.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 10:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698947170; x=1699551970; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G85pRGyLip1+tcQHyAvlsC1xDG3Jc9lQ+KHYjFzzSQc=;
        b=UotzgL4+aFAn85dY3jbrkStVZvaHjnjDvV7JniuwXFI3o52AE9VQ+g+ylCBJeX1f7i
         512PslTR2OQElheY1S1MRdPMPhZpI6pJKb00W/W43dz4qmU1p8gHemwlOq2wjl330yJF
         ZrUbu1yKiPVxwg/Uqjd0lGaAfKGC/IbVzS7KED5/Fim9ZuMFvLnk+T6wU5e2RuAnPcB1
         LLB4cJpH72iSqbHIFk7HHuskQL+loM5CXwbRsj+MYipp5vvIkxDMDhVnx2jpTRUjvP5q
         xv7wjGxY/+ThbF6VFPP1DlU4kPw0lq0OcYHJcl+NzTfBlwoCmhqv/tcL5UHhheteYNW+
         7J0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698947170; x=1699551970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G85pRGyLip1+tcQHyAvlsC1xDG3Jc9lQ+KHYjFzzSQc=;
        b=bd/bvtmGaqi4bbHaDXi5g4AsrKkc0ZNtx3I+vUlUTDZm7NU5gbNiCB5VFcs7GGYPPw
         6nlrqqCORPUP6Z1M0nZdyuFycfnnV0jP0PTGYbAEYP1G1xk2A7JuWzn4frpO1MCw8WAZ
         VgJmjpKMKhOki/CmwHaH4Wpg9A5DCcM3TeG+wj5Iluc2fBxlRuwJyiNn03Tq/jG1d675
         RsxNY2IFRt/pJ40vhp0/q94W9e16BFlsr8EMNkKSbdE1fBvMY9zoeUBJ8AIFJpKjqMGd
         wDAgzE23ZQpHLaZnOgljOMJhjkgQVFnvq9iDkTKixWKksZa0wVC5TvQYqjShFWZeosiE
         +spg==
X-Gm-Message-State: AOJu0YwSyYTxNe3qUiWNLb0lx2C0YpaCWuLnvY3081yitF7FkL1vSB67
	eStNTyhbFDKEIJdKP1lhmomdrAzmRvU10cM1xBkUpQ==
X-Google-Smtp-Source: AGHT+IGSe7qAyEQZs1bKmfSacwohVtcCs/g6GqCLZ2kkpMOCfQ8TXSwwazIgs5PBRlN5AX8zrrVPCXuZiJZrVtAnLpk=
X-Received: by 2002:a50:f60b:0:b0:543:3f97:aa0f with SMTP id
 c11-20020a50f60b000000b005433f97aa0fmr106457edn.4.1698947169816; Thu, 02 Nov
 2023 10:46:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231031090613.2872700-1-dapeng1.mi@linux.intel.com>
 <20231031090613.2872700-2-dapeng1.mi@linux.intel.com> <CALMp9eR_BFdNNTXhSpbuH66jXcRLVB8VvD8V+kY245NbusN2+g@mail.gmail.com>
 <c3f0e4ac-1790-40c1-a09e-209a09e3d230@linux.intel.com> <CALMp9eTDAiJ=Kuh7KkwdAY8x1BL2ZjdgFiPFRHXSSVCpcXp9rw@mail.gmail.com>
 <baa64cf4-11de-4581-89b6-3a86448e3a6e@linux.intel.com> <a14147e7-0b35-4fba-b785-ef568474c69b@linux.intel.com>
 <85706bd7-7df0-4d4b-932c-d807ddb14f9e@linux.intel.com>
In-Reply-To: <85706bd7-7df0-4d4b-932c-d807ddb14f9e@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 2 Nov 2023 10:45:55 -0700
Message-ID: <CALMp9eS3NdTUnRrYPB+mMoGKj5NnsYXNUfUJX8Gv=wWCN4dkoQ@mail.gmail.com>
Subject: Re: [Patch 1/2] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots event
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 1, 2023 at 7:07=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel.c=
om> wrote:
>
>
> On 11/1/2023 9:33 PM, Liang, Kan wrote:
> >
> > On 2023-10-31 11:31 p.m., Mi, Dapeng wrote:
> >> On 11/1/2023 11:04 AM, Jim Mattson wrote:
> >>> On Tue, Oct 31, 2023 at 6:59=E2=80=AFPM Mi, Dapeng
> >>> <dapeng1.mi@linux.intel.com> wrote:
> >>>> On 11/1/2023 2:22 AM, Jim Mattson wrote:
> >>>>> On Tue, Oct 31, 2023 at 1:58=E2=80=AFAM Dapeng Mi
> >>>>> <dapeng1.mi@linux.intel.com> wrote:
> >>>>>> This patch adds support for the architectural topdown slots event
> >>>>>> which
> >>>>>> is hinted by CPUID.0AH.EBX.
> >>>>> Can't a guest already program an event selector to count event sele=
ct
> >>>>> 0xa4, unit mask 1, unless the event is prohibited by
> >>>>> KVM_SET_PMU_EVENT_FILTER?
> >>>> Actually defining this new slots arch event is to do the sanity chec=
k
> >>>> for supported arch-events which is enumerated by CPUID.0AH.EBX.
> >>>> Currently vPMU would check if the arch event from guest is supported=
 by
> >>>> KVM. If not, it would be rejected just like intel_hw_event_available=
()
> >>>> shows.
> >>>>
> >>>> If we don't add the slots event in the intel_arch_events[] array, gu=
est
> >>>> may program the slots event and pass the sanity check of KVM on a
> >>>> platform which actually doesn't support slots event and program the
> >>>> event on a real GP counter and got an invalid count. This is not
> >>>> correct.
> >>> On physical hardware, it is possible to program a GP counter with the
> >>> event selector and unit mask of the slots event whether or not the
> >>> platform supports it. Isn't KVM wrong to disallow something that a
> >>> physical CPU allows?
> >>
> >> Yeah, I agree. But I'm not sure if this is a flaw on PMU driver. If an
> >> event is not supported by the hardware,  we can't predict the PMU's
> >> behavior and a meaningless count may be returned and this could mislea=
d
> >> the user.
> > The user can program any events on the GP counter. The perf doesn't
> > limit it. For the unsupported event, 0 should be returned. Please keep
> > in mind, the event list keeps updating. If the kernel checks for each
> > event, it could be a disaster. I don't think it's a flaw.
>
>
> Thanks Kan, it would be ok as long as 0 is always returned for
> unsupported events. IMO, it's a nice to have feature that KVM does this
> sanity check for supported arch events, it won't break anything.

The hardware PMU most assuredly does not return 0 for unsupported events.

For example, if I use host perf to sample event selector 0xa4 unit
mask 1 on a Broadwell host (406f1), I get...

# perf stat -e r01a4 sleep 10

 Performance counter stats for 'sleep 10':

           386,964      r01a4

      10.000907211 seconds time elapsed

Broadwell does not advertise support for architectural event 7 in
CPUID.0AH:EBX, so KVM will refuse to measure this event inside a
guest. That seems broken to me.

>
> >
> > Thanks,
> > Kan
> >> Add Kan to confirm this.
> >>
> >> Hi Kan,
> >>
> >> Have you any comments on this? Thanks.
> >>
> >>
> >>>>> AFAICT, this change just enables event filtering based on
> >>>>> CPUID.0AH:EBX[bit 7] (though it's not clear to me why two independe=
nt
> >>>>> mechanisms are necessary for event filtering).
> >>>> IMO, these are two different things. this change is just to enable t=
he
> >>>> supported arch events check for slot events, the event filtering is
> >>>> another thing.
> >>> How is clearing CPUID.0AH:EBX[bit 7] any different from putting {even=
t
> >>> select 0xa4, unit mask 1} in a deny list with the PMU event filter?
> >> I think there is no difference in the conclusion but with two differen=
t
> >> methods.
> >>
> >>

