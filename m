Return-Path: <kvm+bounces-4591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26654815000
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 20:10:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A4061C209A9
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 19:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B34D3FE30;
	Fri, 15 Dec 2023 19:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="sjudvEJG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7B73F8FE
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 19:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6da45aa5549so713416a34.0
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 11:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702667418; x=1703272218; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUQt64cxTRekczJujRwSGMZNUaofXXGwCuQbCkI4cV0=;
        b=sjudvEJG64A78oWCIDBRX5yRdxPFiilOoyNN2ITLeMpg8zuMt1jw1Z/4QzsmvjAA3e
         JoRTzEJnvBZtELPW7lGxlS97liB3rOgIJP+jcssttyWS9yVvhkXDHbzi3V+AD4KuAmc3
         OpBnS/Q2PGvM0MmshLLLlgrNlErB7SFp6AXGghzL6+3J1MIjiTUiA43xqCiufrY0NAiT
         g7qiWCsD9Qk5dSeFBx2H9kVBN9EyOwREbJp+KPLaINgPJ5Tkm14HS8sVkW7S/8rTxNxk
         jizt1EjIOTKRHtsrm+jn0uqSP48msvEH4ZHG49Mq+iK4T2I10TdJsYotvuIk9KyRrB3G
         k75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702667418; x=1703272218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LUQt64cxTRekczJujRwSGMZNUaofXXGwCuQbCkI4cV0=;
        b=tzGyOsP4hWQV3B0kk9OjKbZrWVhqsUQ6zIzl/nFdXNQ4ptEspTCUw+x0+OMYbEpYJd
         DOZ6Tb0K1xhWuI/463ULUBdvKT7QFDCiPciGuDOao3riqB1DdjOqOhngZZylQLapGF5l
         SQ7d383xG43zcmrbuTUorALea7uzmEB09aIyqlGad6cDOeYHsUhO0QGC099mY5Q/+5va
         ++QosokW/AIB2tqXFXe2rseCDF8D1iv1EzmuUtNLH/ZAjBPY86pX0HPLThrQHP4m/G3y
         F1T5EQPCLOoIjb1xEjUWwuv3IlRasZezbvdRx5cf4+7COYFWi2aAti77UNygHdDCs8rZ
         3B0Q==
X-Gm-Message-State: AOJu0YyFLIUEtszY9HrtLloCzmepY/mChP6sIccUPSySur5o2PMhgKe6
	dflIPQ4AmY+GzT9lKSIT+opDPSZMLkpRMffnDZq2Pg==
X-Google-Smtp-Source: AGHT+IEggW6PgLUr0D4F6at7LeGq7cNUnBzwvFQmAEXQLpk+KIbEII5GosSI41SopHRLHkeCwP7H1/F/pNrFVx39YsY=
X-Received: by 2002:a9d:6187:0:b0:6d9:e32e:fb0d with SMTP id
 g7-20020a9d6187000000b006d9e32efb0dmr11579063otk.20.1702667418223; Fri, 15
 Dec 2023 11:10:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com> <CAO7JXPhQ3zPzsNeuUphLx7o_+DOfJrmCoyRXXjcQMEzrKnGc9g@mail.gmail.com>
 <ZXuiM7s7LsT5hL3_@google.com> <CAO7JXPik9eMgef6amjCk5JPeEhg66ghDXowWQESBrd_fAaEsCA@mail.gmail.com>
 <ZXyFWTSU3KRk7EtQ@google.com> <CAO7JXPgH6Z9X5sWXLa_15VMQ-LU6Zy-tArauRowyDNTDWjwA2g@mail.gmail.com>
 <ZXyS5Xw2J6TBQeK3@google.com>
In-Reply-To: <ZXyS5Xw2J6TBQeK3@google.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Fri, 15 Dec 2023 14:10:06 -0500
Message-ID: <CAO7JXPgKXv0D3XZzFwgLuSpta6Nou0HZMLEjSpYUYnv9FUphnw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
To: Sean Christopherson <seanjc@google.com>
Cc: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>, 
	Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 12:54=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Dec 15, 2023, Vineeth Remanan Pillai wrote:
> > > You are basically proposing that KVM bounce-buffer data between guest=
 and host.
> > > I'm saying there's no _technical_ reason to use a bounce-buffer, just=
 do zero copy.
> > >
> > I was also meaning zero copy only. The help required from the kvm side =
is:
> > - Pass the address of the shared memory to bpf programs/scheduler once
> > the guest sets it up.
> > - Invoke scheduler registered callbacks on events like VMEXIT,
> > VEMENTRY, interrupt injection etc. Its the job of guest and host
> > paravirt scheduler to interpret the shared memory contents and take
> > actions.
> >
> > I admit current RFC doesn't strictly implement hooks and callbacks -
> > it calls sched_setscheduler in place of all callbacks that I mentioned
> > above. I guess this was your strongest objection.
>
> Ya, more or less.
>
> > As you mentioned in the reply to Joel, if it is fine for kvm to allow
> > hooks into events (VMEXIT, VMENTRY, interrupt injection etc) then, it
> > makes it easier to develop the ABI I was mentioning and have the hooks
> > implemented by a paravirt scheduler. We shall re-design the
> > architecture based on this for v2.
>
> Instead of going straight to a full blown re-design, can you instead post=
 slightly
> more incremental RFCs?  E.g. flesh out enough code to get a BPF program a=
ttached
> and receiving information, but do NOT wait until you have fully working s=
etup
> before posting the next RFC.
>
Sure, makes sense.

> There are essentially four-ish things to sort out:
>
>  1. Where to insert/modify hooks in KVM
>  2. How KVM exposes KVM-internal information through said hooks
>  3. How a BPF program can influence the host scheduler
>  4. The guest/host ABI
>
> #1 and #2 are largely KVM-only, and I think/hope we can get a rough idea =
of how
> to address them before moving onto #3 and #4 (assuming #3 isn't already a=
 solved
> problem).

Agreed. Will start with the kvm side and keep you posted on the progress.

Thanks,
Vineeth

