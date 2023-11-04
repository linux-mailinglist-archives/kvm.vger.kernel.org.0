Return-Path: <kvm+bounces-575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D18D77E0F4B
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 13:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 166991C2099A
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 12:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C80C168C7;
	Sat,  4 Nov 2023 12:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="16bLiGuN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A485717D5
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 12:08:32 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C2FFB
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 05:08:31 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-54366bb1c02so3642a12.1
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 05:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699099709; x=1699704509; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfHji7Ga58BYl+g/DnM6ZF6YFg3Y4ct5ZcRCVcclsa0=;
        b=16bLiGuNtm2pLOltuMFhujZdhB12OuYSmsU+F5+gLrl5XuUEg2Ru76iCwe5bYCnxxu
         j0BuAP9iU2JET7nboMABSfNschuolaHSioA0NJ6OhZfCGlS1dxV7pxFix8ukGfkaI8AQ
         J6vwhxIWap0KFagS2YCyDKursmjunTkojCBks0aKcz044D6pgh/oRwwsRHkq9GwRgTre
         inR3n/jTRsHaK2yMjg2dmwBmV4GPQoLFfaIRsysE91rWzjT0fmT7rJKStXrtW7fyuQSr
         bG09aW4uawwnJAE4/dHED3aaWHLejdAedr8xtPRibhKojZIiBVVLi9evEXFIDgn64Nd2
         r49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699099709; x=1699704509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfHji7Ga58BYl+g/DnM6ZF6YFg3Y4ct5ZcRCVcclsa0=;
        b=bc9kZ2fb8gCtEX8970LsxbDx5de22XG6k7E78psQ+QY98uoJXcl/v3slCd/NlAp3pp
         nFc0j38TNPiDGdzk7hSkllvCvU/FZTE5qZqRxC7k1y6C/41CQkE8lJk4/vcPPo9ZuOrM
         wbXEwD1belUU5HQh7kESPqXfaosEMFHlya0HltbDNdI4eQko6AlsW9rkPjBaWFK88k4f
         f6mLYV7BrmM7rf0NOBOsbsQBf4ebgeWDAlTMlH8UPeW3NMN41vriT49KL3+YKaDila1j
         qA1se3nI34AkJjtmS+gT4ZUnVXrrUAQOUQXOHCKh/NPe2Qa65/Ky81JVuvQvn7cEpKEL
         QpBw==
X-Gm-Message-State: AOJu0YxIFl2IkS/hh0fDf7+7nGKRYNKry1pY09PSHi8iex2u3dPwBoAq
	mSop6htP1X/QqUySCe6dhlHVtrtRG6KpKCMitgQDaA==
X-Google-Smtp-Source: AGHT+IHPg5/XVMOqndhPMvOwkRuTH8dEV9/UWaHArRzbPx6nONEweJZJJocBsz4HHR2fp8EOzm7d+FMX1UPwYPi/1xk=
X-Received: by 2002:a50:9ecc:0:b0:543:faac:e135 with SMTP id
 a70-20020a509ecc000000b00543faace135mr54281edf.3.1699099709343; Sat, 04 Nov
 2023 05:08:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-2-seanjc@google.com>
In-Reply-To: <20231104000239.367005-2-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 4 Nov 2023 05:08:13 -0700
Message-ID: <CALMp9eSgvq1zOZ4KFnsPHQWk62AGYj560SvVops-bmtpyLGPRQ@mail.gmail.com>
Subject: Re: [PATCH v6 01/20] KVM: x86/pmu: Don't allow exposing unsupported
 architectural events
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Hide architectural events that unsupported according to guest CPUID *or*
> hardware, i.e. don't let userspace advertise and potentially program
> unsupported architectural events.

The bitmask, pmu->available_event_types, is only used in
intel_hw_event_available(). As discussed
(https://lore.kernel.org/kvm/ZUU12-TUR_1cj47u@google.com/),
intel_hw_event_available() should go away.

> Note, KVM already limits the length of the reverse polarity field, only
> the mask itself is missing.
>
> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a gues=
ts")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 820d3e1f6b4f..1b13a472e3f2 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -533,7 +533,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>         pmu->counter_bitmask[KVM_PMC_GP] =3D ((u64)1 << eax.split.bit_wid=
th) - 1;
>         eax.split.mask_length =3D min_t(int, eax.split.mask_length,
>                                       kvm_pmu_cap.events_mask_len);
> -       pmu->available_event_types =3D ~entry->ebx &
> +       pmu->available_event_types =3D ~(entry->ebx | kvm_pmu_cap.events_=
mask) &
>                                         ((1ull << eax.split.mask_length) =
- 1);
>
>         if (pmu->version =3D=3D 1) {
> --
> 2.42.0.869.gea05f2083d-goog
>

