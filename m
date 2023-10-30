Return-Path: <kvm+bounces-138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AE07DC30B
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 00:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0A78B20F1D
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 23:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFC218C17;
	Mon, 30 Oct 2023 23:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wulmNnME"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BDD12E65
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 23:17:54 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1344E4
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:17:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0ccfc4fc8so4228788276.2
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698707872; x=1699312672; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Csx+TsEcocBEQ6kz2m3CofW0FivmcdzPkNL/+8GkZMU=;
        b=wulmNnMEVs3z1tDVSYYaowkPOqPUAn0OwUr0Yxt0sNaGoWkFzIS5lxPZsuZTFxmzqz
         K3k0qwnP4rd0aFYKs+dSrkrCkaacN0asJ9V56YnPOXvkt5ior2H2ik4wM9SBvFBn9NVt
         0DV9a5aefavweNuYu/yfkIH8hLgoBBMDTDUb79Gzvzfu7TowIU2Ese6EwlEEYufCjz5o
         ou/V2xRPnTIacxCxE9hBkPaeifWvMZWG8R+k5DajFwO7+XScAzAQdu2nUuxxmAPSlqML
         4USw3SHoBdA4IxouKgvqvBqdhA5HEJGJNbEKMTPBrdn9s0EKu0NniVjx6cRZ/D9sLwLV
         gFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698707872; x=1699312672;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Csx+TsEcocBEQ6kz2m3CofW0FivmcdzPkNL/+8GkZMU=;
        b=suA8nOY2pyxHHR2QNrUSVKP9vY2wnC7vjoXWBJTrkWilM23nCUTcVxHQCGtFWV1fo8
         0lgkQDe/YOgXXEPcLL7V8epqHxBwL+6B0xF3dI2EnkNFWecZ/TBO8JOKJN0/1hB7FdRs
         XgldgMy7G20L0zUdkE6fdJcP5y0XljgmlV+rK5kqrLgVLYIUPuHXV1DPriqoRJhrULbX
         iSmGD/sFCBqKfUjnHS8sfsotXQFdZbkq1o1KntUB27VT3aoS8uG5I4JykbaZ3vSm2Vs8
         kZ7sGEcPnLKz6DxJDocRmRrmNmDVyLosCB9A3pmm0VaMfZKsv7VswuGz4Gg2U/3DJH+G
         8KJg==
X-Gm-Message-State: AOJu0YwCak77IPEgcDRTzNkm/1Il8FSeHQStgy09dY1T3qbK1XWl+p3I
	ZfkBVDKstaM4tR576lW229Y9E/bj4mE=
X-Google-Smtp-Source: AGHT+IHcWu2teE0w4erdqneJsvHZS2M1ee6fdESgDAEOW+IWBnZCh53mWv/aUqxFdZ3MsAoLbwB56oaCH0o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa04:0:b0:d9c:2a58:b905 with SMTP id
 s4-20020a25aa04000000b00d9c2a58b905mr210703ybi.9.1698707872051; Mon, 30 Oct
 2023 16:17:52 -0700 (PDT)
Date: Mon, 30 Oct 2023 16:17:50 -0700
In-Reply-To: <47c9a8f1-0098-4543-ac98-e210ca6b0d34@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231025055914.1201792-1-xiaoyao.li@intel.com>
 <20231025055914.1201792-2-xiaoyao.li@intel.com> <87a5s73w53.fsf@redhat.com>
 <ZTkkmgs_oCnDCGvd@google.com> <47c9a8f1-0098-4543-ac98-e210ca6b0d34@intel.com>
Message-ID: <ZUA5nnAV3CxOX9lB@google.com>
Subject: Re: [PATCH v2 1/2] x86/kvm/async_pf: Use separate percpu variable to
 track the enabling of asyncpf
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 30, 2023, Xiaoyao Li wrote:
> On 10/25/2023 10:22 PM, Sean Christopherson wrote:
> > On Wed, Oct 25, 2023, Vitaly Kuznetsov wrote:
> > > Xiaoyao Li <xiaoyao.li@intel.com> writes:
> > > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > > index b8ab9ee5896c..388a3fdd3cad 100644
> > > > --- a/arch/x86/kernel/kvm.c
> > > > +++ b/arch/x86/kernel/kvm.c
> > > > @@ -65,6 +65,7 @@ static int __init parse_no_stealacc(char *arg)
> > > >   early_param("no-steal-acc", parse_no_stealacc);
> > > > +static DEFINE_PER_CPU_READ_MOSTLY(bool, async_pf_enabled);
> > > 
> > > Would it make a difference is we replace this with a cpumask? I realize
> > > that we need to access it on all CPUs from hotpaths but this mask will
> > > rarely change so maybe there's no real perfomance hit?
> > 
> > FWIW, I personally prefer per-CPU booleans from a readability perspective.  I
> > doubt there is a meaningful performance difference for a bitmap vs. individual
> > booleans, the check is already gated by a static key, i.e. kernels that are NOT
> > running as KVM guests don't care.
> 
> I agree with it.
> 
> > Actually, if there's performance gains to be had, optimizing kvm_read_and_reset_apf_flags()
> > to read the "enabled" flag if and only if it's necessary is a more likely candidate.
> > Assuming the host isn't being malicious/stupid, then apf_reason.flags will be '0'
> > if PV async #PFs are disabled.  The only question is whether or not apf_reason.flags
> > is predictable enough for the CPU.
> > 
> > Aha!  In practice, the CPU already needs to resolve a branch based on apf_reason.flags,
> > it's just "hidden" up in __kvm_handle_async_pf().
> > 
> > If we really want to micro-optimize, provide an __always_inline inner helper so
> > that __kvm_handle_async_pf() doesn't need to make a CALL just to read the flags.
> > Then in the common case where a #PF isn't due to the host swapping out a page,
> > the paravirt happy path doesn't need a taken branch and never reads the enabled
> > variable.  E.g. the below generates:
> 
> If this is wanted. It can be a separate patch, irrelevant with this series,
> I think.

Yes, it's definitely beyond the scope of this series.

