Return-Path: <kvm+bounces-1065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 961F27E4986
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 512CB28134F
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A9C36B15;
	Tue,  7 Nov 2023 20:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KM/p+njy"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5236AED
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:03:49 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D8C102
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:03:48 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so2658a12.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699387427; x=1699992227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YnEVKTaaLYxHM268Q5WdvdnJgEBuM9SDF2SNDc+ebdk=;
        b=KM/p+njyUtFO27uIWZWGef9Ymu1p/UQSfhiJE7O5WqhyNKuk++eQ7DFvcRXMxS2uNL
         3KzKupQsYlf/yRR44uPPwkXCjnlj4des/dK46bgR0fos3PRoinV5rlcO1tDzNDxKfUta
         EaSgXuTvstici8RK87tvy97t8Udu2gu72uJHstWHjQWi425t6wu21SU3OH8YeAyM3UU8
         uDpCpyOtNUPEBhwrJBUSy8NcRttzt9L4jBOw6XBXdqAzc3lmGXzpba64VF9ifihj2oBh
         aE4TwCbI2fptqVnrywQmZOnptX/gnHC9uHPNuCYTy845FF0vYAcyUZvKC28+XhGEv0yX
         V3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699387427; x=1699992227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnEVKTaaLYxHM268Q5WdvdnJgEBuM9SDF2SNDc+ebdk=;
        b=YaMTluGwBbVgxiwEPsddiAXGdm+Rq6QLfgf1s4Fk72XaxhwbHZtvRjY1uCXrqqa3K7
         HAWt1nuP6SdoQPEzchmbIuzIQJCJlhbZu51s1E9cYpMUeu75lgFEBUiHqRXdPjPxGMO+
         wkHIpbbE3tv3Ykc4rL0N6pG2qlyTswpBrdU4D/uwCbP06kyQLn4EEqLOFJYs+fPkHUtV
         NuQWUUMrygu9GyMbSAbBsBrkUrhNPI1ij6cgYn4xUxBN14eEOtkAVR1V+ilIW8X7Anqb
         Gb/u0dZSI3u1A3eowGjWWeK55FEC4q/L1NKDmw+36X+lW6MNPiMN2BfI3a6UJ5QJ0Kvy
         w+vg==
X-Gm-Message-State: AOJu0YyzVDM3k/dDQltnPKMlWCBSkb7Nwa2CNP9VTf8q0ePKmoSRAwTY
	0X3VYi5bHOKZtXBTMmin+xJXhyFRG6AvU6KvOi/kVN4WfS2YTsOmcWw=
X-Google-Smtp-Source: AGHT+IH0rRs2clz95qXcyn4xwmyOugYn8RIEUiyHiBTf/rBVN1V8tzdQR7UDOCyjrHuD6xSlusqUHU+yHoCT/50WncU=
X-Received: by 2002:a50:d753:0:b0:542:d737:dc7e with SMTP id
 i19-20020a50d753000000b00542d737dc7emr222213edj.0.1699387426998; Tue, 07 Nov
 2023 12:03:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1699383993.git.isaku.yamahata@intel.com> <20231107192933.GA1102144@ls.amr.corp.intel.com>
In-Reply-To: <20231107192933.GA1102144@ls.amr.corp.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 7 Nov 2023 12:03:35 -0800
Message-ID: <CALMp9eR8Jnn0g0XBpTKTfKKOtRmFwAWuLAKcozuOs6KAGZ6MQQ@mail.gmail.com>
Subject: Re: KVM: X86: Make bus clock frequency for vapic timer (bus lock ->
 bus clock) (was Re: [PATCH 0/2] KVM: X86: Make bus lock frequency for vapic
 timer) configurable
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 11:29=E2=80=AFAM Isaku Yamahata
<isaku.yamahata@linux.intel.com> wrote:
>
> I meant bus clock frequency, not bus lock. Sorry for typo.
>
> On Tue, Nov 07, 2023 at 11:22:32AM -0800,
> isaku.yamahata@intel.com wrote:
>
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
> > crystal clock (or processor's bus clock) for APIC timer emulation.  All=
ow
> > KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREUQNCY_CONTROL) to set the
> > frequency.  When using this capability, the user space VMM should confi=
gure
> > CPUID[0x15] to advertise the frequency.
> >
> > TDX virtualizes CPUID[0x15] for the core crystal clock to be 25MHz.  Th=
e
> > x86 KVM hardcodes its freuqncy for APIC timer to be 1GHz.  This mismatc=
h
> > causes the vAPIC timer to fire earlier than the guest expects. [1] The =
KVM
> > APIC timer emulation uses hrtimer, whose unit is nanosecond.
> >
> > There are options to reconcile the mismatch.  1) Make apic bus clock fr=
equency
> > configurable (this patch).  2) TDX KVM code adjusts TMICT value.  This =
is hacky
> > and it results in losing MSB bits from 32 bit width to 30 bit width.  3=
). Make
> > the guest kernel use tsc deadline timer instead of acpi oneshot/periodi=
c timer.
> > This is guest kernel choice.  It's out of control of VMM.
> >
> > [1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@go=
ogle.com/
> >
> > Isaku Yamahata (2):
> >   KVM: x86: Make the hardcoded APIC bus frequency vm variable
> >   KVM: X86: Add a capability to configure bus frequency for APIC timer

I think I know the answer, but do you have any tests for this new feature?

