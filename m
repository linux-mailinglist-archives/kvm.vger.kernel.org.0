Return-Path: <kvm+bounces-1395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE9567E7582
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 891452812F7
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1554111B;
	Fri, 10 Nov 2023 00:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="muls4XTz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509871100
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:02:23 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BD1769A
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:02:22 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-54366bb1c02so20499a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699574541; x=1700179341; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Uct5fRuxJFXU94Tz4PJyyKXoirMBsA5N0Xtf3w4zUY=;
        b=muls4XTzCZdRaCLbi1mKgfOQLC6iEI5ko+ddp1S/B7aonU4H+HjUBqgKKTsdZLVMdP
         63AOEXHHoubx9GbBWUSRFgU1VyLsXriNSIgZYGavhSX2zLMF+X8mRispLWEjxE6yDqMO
         hMOpEn8M07ZjuUfGgcaTmdQO9xRdfuj328y+l9axtSxGaH8SKVWoHMGlGeGprU5aNvLo
         P8t+s6vlt/1C36zQBNzNVFbCdSUF+RCk5hU+Dt2WCMSqZzBYcgkXshWbwYZjvd1QKmSq
         1LTrQ4tijlKgbL5YycrJSI9nlF7A+vcxxDWaNEDv2jweFTVJ6O89+X/+dxpI9sKgLt4u
         vylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699574541; x=1700179341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Uct5fRuxJFXU94Tz4PJyyKXoirMBsA5N0Xtf3w4zUY=;
        b=hfP6t0BbWQyzXWxvvTm9CC/vGxl6w0JHCQaBP+XYjkDU8YDo3XYHCDNNy6egUBdPLz
         SCSSNisSRkJ+R/3KDvU97jc04IXiA8ZCWzbbDKBY8xovNP8B7RPEIjIvGpOKXp+ud3ue
         4nM1hH75qjRk9U2mR6rjQZb785j79rRDqngla36HqolUgNAdCmqfFGZ0ad+3L57jJ6ET
         BrxHSa2hO1Gy6lXOwTw1g7YidoZYg4YvMteAz/QguG8HtHC4uJ6sebX+ZgEZuX0g3fUJ
         lGXnE3niSmleE1+/x5xyKkkCCPJ0orB4kwticig0tApOz6FySUHyLaQ+whOhUlxXs5xN
         lG8g==
X-Gm-Message-State: AOJu0YxpY09FMRq6+IPFz0z4uNYoqvAhfgG9mH8BYMOpHEg1Hcf9w0jY
	4D5EyCg6LXVMNpfS/bdY0ljsnvPbG95LGSNWRZK54w==
X-Google-Smtp-Source: AGHT+IEHIZYWQkUEDtEIX15uWrgumO5VpPvdRBCVvSyu74zpWG4zw0fFjNzBuEEUSoHTadwmW69UqTf920Rp6Z+RYq0=
X-Received: by 2002:a05:6402:114d:b0:545:2921:d217 with SMTP id
 g13-20020a056402114d00b005452921d217mr284759edw.6.1699574540886; Thu, 09 Nov
 2023 16:02:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com> <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
 <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
In-Reply-To: <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Nov 2023 16:02:05 -0800
Message-ID: <CALMp9eRC_suWQ+NCH1bREfg0iFHJtGeuB0x-wZ-MpZh3HXFNcg@mail.gmail.com>
Subject: Re: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
To: "Denis V. Lunev" <den@virtuozzo.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 3:46=E2=80=AFPM Denis V. Lunev <den@virtuozzo.com> w=
rote:
>
> On 11/9/23 23:52, Jim Mattson wrote:
> > On Thu, Nov 9, 2023 at 10:18=E2=80=AFAM Konstantin Khorenko
> > <khorenko@virtuozzo.com> wrote:
> >> Hi All,
> >>
> >> as a followup for my patch: i have noticed that
> >> currently Intel kernel code provides an ability to detect if PMU is to=
tally disabled for a VM
> >> (pmu->version =3D=3D 0 in this case), but for AMD code pmu->version is=
 never 0,
> >> no matter if PMU is enabled or disabled for a VM (i mean <pmu state=3D=
'off'/> in the VM config which
> >> results in "-cpu pmu=3Doff" qemu option).
> >>
> >> So the question is - is it possible to enhance the code for AMD to als=
o honor PMU VM setting or it is
> >> impossible by design?
> > The AMD architectural specification prior to AMD PMU v2 does not allow
> > one to describe a CPU (via CPUID or MSRs) that has fewer than 4
> > general purpose PMU counters. While AMD PMU v2 does allow one to
> > describe such a CPU, legacy software that knows nothing of AMD PMU v2
> > can expect four counters regardless.
> >
> > Having said that, KVM does provide a per-VM capability for disabling
> > the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
> > section 8.35 in Documentation/virt/kvm/api.rst.
> But this means in particular that QEMU should immediately
> use this KVM_PMU_CAP_DISABLE if this capability is supported and
> PMU=3Doff. I am not seeing this code thus I believe that we have missed
> this. I think that this change worth adding. We will measure the impact
> :-) Den

At present, KVM will still blindly cycle through each GP counter (4
minimum for AMD) until it checks vcpu->kvm->arch.enable_pmu at the top
of get_gp_pmc_amd().

Sean's proposal to clear the metadata should eliminate the overhead
for VMs with the virtual PMU disabled. My proposal should eliminate
the overhead even for VMs with the virtual PMU enabled, as long as no
counters are programmed for "instructions retired."

