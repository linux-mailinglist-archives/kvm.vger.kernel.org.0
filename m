Return-Path: <kvm+bounces-1388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 368E27E74EB
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 644BD1C20D09
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 23:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB71438DC9;
	Thu,  9 Nov 2023 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QG5XY3ab"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CC0374D5
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 23:05:39 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565CE4239
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 15:05:39 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5b02ed0f886so19978797b3.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 15:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699571138; x=1700175938; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjzQ70dIii0aQke9hZY91N1JYyLYd3OjxGBZLLov1ig=;
        b=QG5XY3abfTxF4xZnHUG9Z8XAaCN4zUMpxhYqmc2+MhQZRbFTT0+u8cKnpJx12iFrNO
         1eQgpiorC3TZGle7pVOOO0zJSVgsaa3zzegKJFy3PYsXdMG4FOT7m2S5XawRgkkCqnzU
         gURdatdsPPMelaJm3pFtsPF3u4zBLu2FeNZolB2WLjtQUajEQlCQ3Dw56c2cIHY1851r
         BwOSwq5Oc5Z/7XvHEOqyAOCo5MqNw8eH7SS8x+hbIgmEU7XkfqYLQIr3lF1uFSLf7YGN
         RaDLtLSDTRbpFZj63kan3Jq0OCUFY6/yRuVrSNRtiHlphcCSETnkltW5lITmZeEyPEYF
         HaUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699571138; x=1700175938;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HjzQ70dIii0aQke9hZY91N1JYyLYd3OjxGBZLLov1ig=;
        b=Pb9Wi3SOGD8t6ze62bwJq9Gya5l2WwqTrmqi2uLbrQmC8iK9YIf4gZIEpKPv7/68xa
         N7oNdE1qKstRUCyVvL7Exvp6rMAfjU86t3VDjK2tZ6ydMK56qrYbGAznM4Y4E6ygtwZz
         cJgFhZdDMQ1HV7ddImb8+WVAWzfrMAvkayqZPO/x3LfG66kntkXEaxGUb5/Q/YNfwrtx
         ti+AUYv3GqoZOr9TrtMn2KlfQ+Df3+TYftMX9sZ7/k9t8+aLbUZDkdoTLnu1VdwM8fcG
         h0xgp2R5x2hC5zLZb4W8JPbBsxwdD6eiiFJ/AiDC7cqTFxdLsrGL+hAqFcQ4+rVYPgpS
         95dA==
X-Gm-Message-State: AOJu0Ywj+gDcGF2zB51qR2S1CqduVAPDuMkIofxtwWgt4dT9In+Gf/q0
	k2tI6bsNAnWx5fxlz30adX14Oh+CVv0=
X-Google-Smtp-Source: AGHT+IE018ErF8huRo2NaTD/Dz6GiBtvPamqI3xiGKEPPMgVfo9uZlg4dPCR0tyEabNajivXmcQRoRw7tj4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6c56:0:b0:59b:ec33:ec6d with SMTP id
 h83-20020a816c56000000b0059bec33ec6dmr201069ywc.5.1699571138466; Thu, 09 Nov
 2023 15:05:38 -0800 (PST)
Date: Thu, 9 Nov 2023 15:05:36 -0800
In-Reply-To: <CALMp9eRpq+vYDD7s9t54ZMOK6WaXTY_trKzSE3R2vWP9PeSCOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <20231109180646.2963718-2-khorenko@virtuozzo.com> <CALMp9eRpq+vYDD7s9t54ZMOK6WaXTY_trKzSE3R2vWP9PeSCOA@mail.gmail.com>
Message-ID: <ZU1lwEONQv_CtBM9@google.com>
Subject: Re: [PATCH 1/1] KVM: x86/vPMU: Check PMU is enabled for vCPU before
 searching for PMC
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Denis V. Lunev" <den@virtuozzo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 09, 2023, Jim Mattson wrote:
> On Thu, Nov 9, 2023 at 10:24=E2=80=AFAM Konstantin Khorenko <khorenko@vir=
tuozzo.com> wrote:
> > ---
> >  arch/x86/kvm/pmu.c | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 9ae07db6f0f6..290d407f339b 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -731,12 +731,38 @@ static inline bool cpl_is_matched(struct kvm_pmc =
*pmc)
> >         return (static_call(kvm_x86_get_cpl)(pmc->vcpu) =3D=3D 0) ? sel=
ect_os : select_user;
> >  }
> >
> > +static inline bool guest_pmu_is_enabled(struct kvm_pmu *pmu)
> > +{
> > +       /*
> > +        * Currently VMs do not have PMU settings in configs which defa=
ults
> > +        * to "pmu=3Doff".
> > +        *
> > +        * For Intel currently this means pmu->version will be 0.
> > +        * For AMD currently PMU cannot be disabled:
>=20
> Isn't that what KVM_PMU_CAP_DISABLE is for?

Yeah, see my response.  KVM doesn't clear the metadata, so internally it lo=
oks
like the PMU is enabled even though it's effectively disabled from the gues=
t's
perspective.

