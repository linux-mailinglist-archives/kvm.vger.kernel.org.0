Return-Path: <kvm+bounces-1387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F2B7E7491
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 23:52:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 995111F20CBA
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBFC374E0;
	Thu,  9 Nov 2023 22:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X88YwnP6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FD820315
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 22:52:19 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002D34231
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 14:52:18 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so19159a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 14:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699570337; x=1700175137; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxqH4FtJRovfKhN1Doxka0q1j+3qJN1a7cs4m8DTYUA=;
        b=X88YwnP6nAjw1nHtNN8iFCPzi89s9xHGT8JAIrFjPqzKk8CQBoUtEHHAHDX5Z8Bx9O
         YxaPkCzJRnD4WCg/Xgu8vRLaGKAGc762MAPN8iq3HlEbY808sbqTHs1jo62Vf7Brmzvg
         0LUYAxK9dRZa2RfpVIXxOlA1Ejbqpt57scdkm/Ze+12r78/ceal42kmAwLULyB3x3+Yr
         mjQZXNOEA2dhPa4TnGx5zfNQeGvTR1bHAzAPZYH/SOikj+SJMq/Icv3EVfaWeojUc32t
         R5deeIRquwtFPOx0DpTeKlbPK9izJZQYSSvmbivwUyfeJkITkuIVnsLlKg0H39TaOtzM
         1a7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699570337; x=1700175137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxqH4FtJRovfKhN1Doxka0q1j+3qJN1a7cs4m8DTYUA=;
        b=gFOi8b1y78m1ruLe45z/WOfKpXTJXOmrrX+YvO5A74085hfhqMGHSNTdm32llGIscj
         2+vHG7AGvbEjZ0qKwC/ZfrzcpPvEaFVYVfVPVJPDToj37oKQcCmnmE/ERaBWy00+Dic1
         5qvj2IShzkjPKe+XpVtziB+YVTT95QXsLnO169C44U0mLybsAa8C9G0wtqIrwrf7XoeJ
         r+9hGz5Kk2L4wC+S2FpP9lC6uv/j8YE0TSbjsYx7Rv0Q0Zd7qPggVXjeF/bLwoIUwMd5
         sHoL4vPjBWOIwVkhey4z6kxyAHLdAn69L1/IUAOS95hkLs9fwih1YhGruzy21FnAvI1R
         nURQ==
X-Gm-Message-State: AOJu0YyCX9mUuYIAeqhpcjvOShDZM9F5rHSF9tyhvVSPrnoWHx7semlh
	ToPFkT/r7m5cLn8MlqxwEp1pqtc/+Iuq3Ih+SifqLg==
X-Google-Smtp-Source: AGHT+IFfpgI4oc69D+zRN+BrD4Rejzen8Z66z0NNfhJtPXkl/FH6gpXISpQnZOLdrD6zjX6vrYYitxg55EOamva3ogo=
X-Received: by 2002:aa7:d34a:0:b0:543:fb17:1a8 with SMTP id
 m10-20020aa7d34a000000b00543fb1701a8mr261168edr.3.1699570337024; Thu, 09 Nov
 2023 14:52:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109180646.2963718-1-khorenko@virtuozzo.com> <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
In-Reply-To: <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Nov 2023 14:52:04 -0800
Message-ID: <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
Subject: Re: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Denis V. Lunev" <den@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 10:18=E2=80=AFAM Konstantin Khorenko
<khorenko@virtuozzo.com> wrote:
>
> Hi All,
>
> as a followup for my patch: i have noticed that
> currently Intel kernel code provides an ability to detect if PMU is total=
ly disabled for a VM
> (pmu->version =3D=3D 0 in this case), but for AMD code pmu->version is ne=
ver 0,
> no matter if PMU is enabled or disabled for a VM (i mean <pmu state=3D'of=
f'/> in the VM config which
> results in "-cpu pmu=3Doff" qemu option).
>
> So the question is - is it possible to enhance the code for AMD to also h=
onor PMU VM setting or it is
> impossible by design?

The AMD architectural specification prior to AMD PMU v2 does not allow
one to describe a CPU (via CPUID or MSRs) that has fewer than 4
general purpose PMU counters. While AMD PMU v2 does allow one to
describe such a CPU, legacy software that knows nothing of AMD PMU v2
can expect four counters regardless.

Having said that, KVM does provide a per-VM capability for disabling
the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
section 8.35 in Documentation/virt/kvm/api.rst.

