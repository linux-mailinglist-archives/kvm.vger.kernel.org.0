Return-Path: <kvm+bounces-4409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E6BA8122BD
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 00:18:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3060A1F21A4A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 23:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB93477B2F;
	Wed, 13 Dec 2023 23:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gEMmEMI4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E40B0
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 15:18:43 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-54744e66d27so5474a12.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 15:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702509521; x=1703114321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtO9cW/bS+T4J2DvUT4r9uDI2FISmZm46NtsOlUjLfk=;
        b=gEMmEMI4zDG3ms5JSyMCGI8dKWw4l+cb3b17NjP+xghWg9KpVVYAtCDh8mtYCx7WuB
         8iSxOIOKKgU0z8a31nXvfw8aCi/VavJFtceBJ+7jFGdy+dZ1bSjm06NeIz4DAgd5d3Sq
         af2b/IzRfF9Fb3Yt1e+JOx6gcHhbXYFW0WycpX/aQI9SOglXhXZPlScuz6TPdxFpg7Ro
         +pAFEQng4gDyyWEktI4ysG1AF/obOwDWCs3GJ4rLTShYGEMzNqyFODtWEi+CFVjGPxfj
         PsScc5RnyTUAIfKA9RVeZDRMVVxzV0MzK2VmbtcjS850SDlptpJFaAN5iVn80GoXhR6h
         vKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702509521; x=1703114321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CtO9cW/bS+T4J2DvUT4r9uDI2FISmZm46NtsOlUjLfk=;
        b=TgaKSp4SAk3nQvTMWLZfxKsoKBD6g1O2Dbid9UmuPIG70Nz3Z8CR4ey6jIKaf9Fb7H
         m3xeaqVeB+nvvShiP11qgHkFt4d2GWOO7s03Zs+2q6UI4P589qF9IM2XI1zqVExUSgKr
         ABBh1Bya59rTU+PTKoxMkUURUlPV1mvhnlY6JG67qk5Qg3uH0oxdSWVGjWQiBUDp5jNn
         VFEhr1vxm6DEMymx22RFrX3vTZyxnlQ3IgwTGrhwWnIK8oYlg4+R7KajSXKKq8+A33Sq
         JbCmpAwe9YSxBSacO0rUylsnx54xjko8+Bad5q689PlSe7hSB4mTVSnK/b4+OOKwXRxx
         Py3A==
X-Gm-Message-State: AOJu0YxqWZKVdgTqDJxDBxW3m2Rz4Tpc4lQeaKkMvmLb6QDhQBcHsY1Y
	GaT9pM6uiw0aRm4eo49u+0Wpbe4wj/k7sw8qLqLD+A==
X-Google-Smtp-Source: AGHT+IHJlijaS4jp5pajI4NmOiafXFWdXV2A3PlgtibtORBNW9UNjAL2V2BgHeLDv+VyAiVat1lsNy4sHnzcE+xRGIA=
X-Received: by 2002:a50:d7ca:0:b0:54a:ee8b:7a8c with SMTP id
 m10-20020a50d7ca000000b0054aee8b7a8cmr550601edj.0.1702509521358; Wed, 13 Dec
 2023 15:18:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1699936040.git.isaku.yamahata@intel.com>
 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com> <ZXo54VNuIqbMsYv-@google.com>
In-Reply-To: <ZXo54VNuIqbMsYv-@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 13 Dec 2023 15:18:25 -0800
Message-ID: <CALMp9eQUs44tq-3mbqGxcnXjmAx=-jHOLxmW+DuMfeVXGVSDzg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency vm variable
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 3:10=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Dec 14, 2023, Maxim Levitsky wrote:
> > On Mon, 2023-11-13 at 20:35 -0800, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > > TDX virtualizes the advertised APIC bus frequency to be 25MHz.
> >
> > Can you explain a bit better why TDX needs this? I am not familiar
> > with TDX well enough yet to fully understand.
>
> TDX (the module/architecture) hardcodes the core crystal frequency to 25M=
hz,
> whereas KVM hardcodes the APIC bus frequency to 1Ghz.  And TDX (again, th=
e module)
> *unconditionally* enumerates CPUID 0x15 to TDX guests, i.e. _tells_ the g=
uest that
> the frequency is 25MHz regardless of what the VMM/hypervisor actually emu=
lates.
> And so the guest skips calibrating the APIC timer, which results in the g=
uest
> scheduling timer interrupts waaaaaaay too frequently, i.e. the guest ends=
 up
> gettings interrupts at 40x the rate it wants.
>
> Upstream KVM's non-TDX behavior is fine, because KVM doesn't advertise su=
pport
> for CPUID 0x15, i.e. doesn't announce to host userspace that it's safe to=
 expose
> CPUID 0x15 to the guest.  Because TDX makes exposing CPUID 0x15 mandatory=
, KVM
> needs to be taught to correctly emulate the guest's APIC bus frequency, a=
.k.a.
> the TDX guest core crystal frequency of 25Mhz.

Aside from placating a broken guest infrastructure that ignores a
17-year old contract between KVM and its guests, what are the
advantages to supporting a range of APIC bus frequencies?

> I halfheartedly floated the idea of "fixing" the TDX module/architecture =
to either
> use 1Ghz as the base frequency (off list), but it definitely isn't a hill=
 worth
> dying on since the KVM changes are relatively simple.

Not making the KVM changes is even simpler. :)

