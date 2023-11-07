Return-Path: <kvm+bounces-1052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F24A7E4864
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF7181C209B0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69179358B2;
	Tue,  7 Nov 2023 18:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kwk7yBSr"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429AC12E7C
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:39:27 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE43D7A
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:39:26 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5af9b0850fdso80447587b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699382365; x=1699987165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OT9bj/29t1BqbSJ5iHMrrGwZYaUkERVnWSnezKZ0wXI=;
        b=kwk7yBSrMnZdncH1jQcReilehc08ZAVeylnNRnGJcel3U+U7LzoT0Ckv799nsN3rdi
         KKN28wQcuitUzYHrZkU+HeeIVmg3tZA7gjcnWmJFETxkwNDdk9v4rwy6aOo4x6tV/ca+
         /Gyl6OBNTyFfLsfjRI8KzbUCdCzqq7p0uV8d4nFtustyt9+CNm2adKjShYDHw+cyAhAA
         Vmrxkf1yrVGmt6sQZDBHP7WWdbxHfqh+NOsuOB4caufuMeHRgjNzL7Z2sja8mH01LhHV
         BF9FyXbUuxdu37EiuoBQAgULMIiH/rRkdthjkz+RhAm2nXMXy4Hcjs5uOVceJaJpwbCA
         m1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699382365; x=1699987165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OT9bj/29t1BqbSJ5iHMrrGwZYaUkERVnWSnezKZ0wXI=;
        b=NRMOQWzHdkEEAAffTabkLacve8UUsFSMhDjY098T2+QMcl43VEe+TSTV0MH4WNnNgB
         lCvQWRSACIZFUIfW0yoP+JXldFkZyCr+hj4zvxLUKAY7JoAw+7vcNKeeiYgTYEjKkqCQ
         VjKMPROpEXJxRHbV/pVsutuZvXhMNSUKxd4NaaUkASZH+GW92StWhXALPspXipWIo+Cz
         dQjy/F+M3CAMqXATNxueNenK9sF7Rw2NKzMPO+SlFyW4dvTRLmPqf8LcbgC10HMqTG/s
         e2nplVxNcSvbrw+pdJH75qmrWQyyxpIioTRHmDB9+JCC1zq//9ikd4cxu/MDxCu9Lh1U
         szig==
X-Gm-Message-State: AOJu0Ywo8Q67YZ1c6KX4DA6G7ZIhVLviIgAnkCo3KMUtcmb1sWIQw8Fn
	xeH3i5k/oyfxVrMSnfIaEOj4z0G38BI=
X-Google-Smtp-Source: AGHT+IG4HOSCPYw9f8qMhhQB2ugljmmWkWpna/lil2xtTRCeFCmFCpSgEesdvsEQwdd66zWxIR+SgTLrK/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9182:0:b0:5af:a9ab:e131 with SMTP id
 i124-20020a819182000000b005afa9abe131mr275401ywg.1.1699382365501; Tue, 07 Nov
 2023 10:39:25 -0800 (PST)
Date: Tue, 7 Nov 2023 10:39:23 -0800
In-Reply-To: <690bd404204106fc17d465e2fdb9be8863767544.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-20-weijiang.yang@intel.com> <d67fe0ca19f7aef855aa376ada0fc96a66ca0d4f.camel@redhat.com>
 <ZUJ9fDuQUNe9BLUA@google.com> <ff6b7e9d90d80feb9dcabb0fbd3808c04db3ff94.camel@redhat.com>
 <ZUQ3tcuAxYQ5bWwC@google.com> <690bd404204106fc17d465e2fdb9be8863767544.camel@redhat.com>
Message-ID: <ZUqEWySrEeJXCoAO@google.com>
Subject: Re: [PATCH v6 19/25] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 07, 2023, Maxim Levitsky wrote:
> On Thu, 2023-11-02 at 16:58 -0700, Sean Christopherson wrote:
> > Ooh, if we're clever, I bet we can extend KVM_{G,S}ET_ONE_REG to also work with
> > existing MSRs, GPRs, and other stuff,
> 
> Not sure if we want to make it work with MSRs. MSRs are a very well defined thing
> on x86, and we already have an API to read/write them.

Yeah, the API is weird though :-)

> Other registers maybe, don't know.
> 
> >  i.e. not force userspace through the funky
> > KVM_SET_MSRS just to set one reg, and not force a RMW of all GPRs just to set
> > RIP or something.
> Setting one GPR like RIP does sound like a valid use case of KVM_SET_ONE_REG.
> 
> >   E.g. use bits 39:32 of the id to encode the register class,
> > bits 31:0 to hold the index within a class, and reserve bits 63:40 for future
> > usage.
> > 
> > Then for KVM-defined registers, we can route them internally as needed, e.g. we
> > can still define MSR_KVM_SSP so that internal it's treated like an MSR, but its
> > index isn't ABI and so can be changed at will.  And future KVM-defined registers
> > wouldn't _need_ to be treated like MSRs, i.e. we could route registers through
> > the MSR APIs if and only if it makes sense to do so.
> 
> I am not sure that even internally I'll treat MSR_KVM_SSP as MSR. 
> An MSR IMHO is a msr, a register is a register, mixing this up will
> just add to the confusion.

I disagree, things like MSR_{FS,GS}_BASE already set the precedent that MSRs and
registers can be separate viewpoints to the same internal CPU state.  AIUI, these
days, whether a register is exposed via an MSR or dedicated ISA largely comes
down to CPL restrictions and performance.

> Honestly if I were to add support for the SSP register, I'll just add a new
> ioctl/capability and vendor callback. All of this code is just harmless
> boilerplate code.

We've had far too many bugs and confusion over error handling for things like
checking "is this value legal" to be considered harmless boilerplate code.

> Even using KVM_GET_ONE_REG/KVM_SET_ONE_REG is probably overkill, although using
> it for new registers is reasonable.

Maybe, but if we're going to bother adding new ioctls() for x86, I don't see any
benefit to reinventing a wheel that's only good for one thing.

