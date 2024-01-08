Return-Path: <kvm+bounces-5851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB3682767A
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 18:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 950301C20E6E
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C1F55E53;
	Mon,  8 Jan 2024 17:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1yff7LPS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AF554F82
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbcd9f4396eso2218560276.0
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 09:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704735485; x=1705340285; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CeET3LCD9y8mkzdt1n7zEREdExwaFpwQOr0tIUhzNgg=;
        b=1yff7LPSiX+Lx9usqzs3Ck7+fY59unWKCz9VwGMAY7w4RCgqBd4FImn/dqQmKvU5GY
         ajXMHZrEntZ51vVZxopVlZe5Q7R5obWH7o5C+BM9uQ1ZuKrymWuhumXUjrRIbFCErfk+
         vZyPR3/rLP/6NslI9e0++PXoVzmWHLS4fW7gJUsqyyacTecmi3ia12nujaARyRYsgYbs
         nvuGZ42DA06RAFY4RxpQ6k7jABOgzdMbYP/2Kc3mryEg1QH07euEWRt572EnypLl1SMZ
         T3XYmgsHwFkvAIW5DaKtX4OJsfK8HtUMAH9WKsnCTL92s/38z2C2FTteRDltXZl8qyRZ
         WoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704735485; x=1705340285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CeET3LCD9y8mkzdt1n7zEREdExwaFpwQOr0tIUhzNgg=;
        b=oxG8zF9Sb9HArNiM70AuEZpOqgyyx0nFnX6FFyFWsakj3yJWlrOAW7QPk++rqVQlFf
         cmiUUAncByvuWf9Zfv7jTaZBS8gL9CjlUHcXau+NWn5aThbYP3Zdce9GhRWPfkEg/IW7
         aA6NRkTE0PZSlWlukltyTK6/zmsCXAO6/2oakK07zvs0fEEuEnf6M94arI3zpJE9o/ss
         42eY6aV9mVxEn+23ZNJhS/XO4ZwHZm2chp1mOmtSvumQOlbRvpgAhSP61L4js2uBkf7E
         BSl34oFx+z9vqyfTMAnbYH0KBJ21CQqBUH+iokXOGgUfvBDxlXldantG/jogDdujTG9m
         wGjg==
X-Gm-Message-State: AOJu0YwZSCduVM/oY/ZTW/6i/NaTuuf9Jb3U7jVodxYySlB+Uvi+JBNo
	Ygt+j5wkKMb0OrIjmf4vnXCO/oizArmnuL1+Zw==
X-Google-Smtp-Source: AGHT+IFY9eZr/TVBtL10OzQOm/ftwdCvRmuFITZVupfSGA0iFM+gy+JvMfFVxN4DNX5NCzguKOIVEMkCDaM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ba86:0:b0:dbe:9f60:c72f with SMTP id
 s6-20020a25ba86000000b00dbe9f60c72fmr1636784ybg.4.1704735485088; Mon, 08 Jan
 2024 09:38:05 -0800 (PST)
Date: Mon, 8 Jan 2024 09:38:03 -0800
In-Reply-To: <CAE8KmOwPKDM5xcd1kFhefeJsqYZndP09n9AxaRbypTsHm8mkgw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240103075343.549293-1-ppandit@redhat.com> <CAE8KmOwPKDM5xcd1kFhefeJsqYZndP09n9AxaRbypTsHm8mkgw@mail.gmail.com>
Message-ID: <ZZwy-wCpHs-piGhJ@google.com>
Subject: Re: [PATCH] KVM: x86: make KVM_REQ_NMI request iff NMI pending for vcpu
From: Sean Christopherson <seanjc@google.com>
To: Prasad Pandit <ppandit@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Prasad Pandit <pjp@fedoraproject.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 08, 2024, Prasad Pandit wrote:
> On Wed, 3 Jan 2024 at 13:24, Prasad Pandit <ppandit@redhat.com> wrote:
> > kvm_vcpu_ioctl_x86_set_vcpu_events() routine makes 'KVM_REQ_NMI'
> > request for a vcpu even when its 'events->nmi.pending' is zero.
> > Ex:
> >     qemu_thread_start
> >      kvm_vcpu_thread_fn
> >       qemu_wait_io_event
> >        qemu_wait_io_event_common
> >         process_queued_cpu_work
> >          do_kvm_cpu_synchronize_post_init/_reset
> >           kvm_arch_put_registers
> >            kvm_put_vcpu_events (cpu, level=[2|3])
> >
> > This leads vCPU threads in QEMU to constantly acquire & release the
> > global mutex lock, delaying the guest boot due to lock contention.
> > Add check to make KVM_REQ_NMI request only if vcpu has NMI pending.
> >
> > Fixes: bdedff263132 ("KVM: x86: Route pending NMIs from userspace through process_nmi()")
> > Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
> > ---
> >  arch/x86/kvm/x86.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1a3aaa7dafae..468870450b8b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5405,7 +5405,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> >         if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> >                 vcpu->arch.nmi_pending = 0;
> >                 atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
> > -               kvm_make_request(KVM_REQ_NMI, vcpu);
> > +               if (events->nmi.pending)
> > +                       kvm_make_request(KVM_REQ_NMI, vcpu);
> >         }
> >         static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> > --
> > 2.43.0
> 
> Ping...!

This is on my list of things to grab for 6.8, I'm just waiting for various pull
requests to fully land in order to simplify my branch management.

