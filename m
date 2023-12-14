Return-Path: <kvm+bounces-4537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 709C3813B56
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 21:13:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A00E2827CB
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 20:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B896A02A;
	Thu, 14 Dec 2023 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3uXO53yS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB94D6A032
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 20:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d32b4a8ea0so52019595ad.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 12:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702584816; x=1703189616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o6UuF2I+ksa0nRBkfH8g4L0LiVSfO6AHAS12VBA0d84=;
        b=3uXO53yS0xx9GMoa+komR8PI861qPpzCKzKGgx56phJ8Hs2Bgv1uJfdXktZ1DtAf+h
         LMpt+mcZiChHv4qbuyM9LI+CGrJNAriiPtatLimiZp9Y41osIH4nu3+QaYQa9ylrtp9c
         5XFOnAdGlNNMZmSwqtIBU87d/AbBuy+Zx0egjOtZmvDQZuot3Y92Q/+KUbJ4NWxR31Ci
         TY1i5HPd93n+XrZ9a+LE2NPhE1cX9lYO0t+sHD/vPL0IxZus8SjQF/u/RkJCZZfEzpgP
         Sl25R2eTWqEldgUPSw2vtHsi792+1hzII1t1YpSE4U10WnU/KUCMqeRZhMckVE/88TC4
         +8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702584816; x=1703189616;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o6UuF2I+ksa0nRBkfH8g4L0LiVSfO6AHAS12VBA0d84=;
        b=COL0xAYvRLNVQYnEsgW5HbsCMYTuJAyfGgFBXV7xZ7WaFPROxJsKTVpKyuuTfLc+3J
         ilFjZmhTPV1FEeamfXiPpldpikbyY2t5UEkBdVrHTCPMFFiCenYf3r/tO1tet+rmMsCd
         yxE8jRbef4fCFYN3zkN68W+7pSj4jCh6RG9JiF8ocDqLKm1Emvw9DsN6vjigNP7FlraZ
         921y/Ta6f0kuS9e8WmRFqh4H6FreGvod+Sc6Cpv+032tWOFzbDF/5EEtCkgCk96DHhLc
         1oG5W+UUPJ5C7VBo/f8nT2LYm9/ghb4Pb9LCJ0/bPi0zweTfpdeSki/4+kibowFzaNee
         UMBg==
X-Gm-Message-State: AOJu0YwDLzuThjsbl/m3yTWulVnzyy2pyntqnz58Cc6jT3R4n7OoppAi
	SzVj60KnIpSym5Q+oOqMzLGD0CWjuB0=
X-Google-Smtp-Source: AGHT+IGEiwa1cSoRDflydMN7++Q6taulTF4HV3L/RNxde17wAejKqSXkzjYYxVXM2/0619dGhrSppCrZiaM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b18f:b0:1d0:9b2d:5651 with SMTP id
 s15-20020a170902b18f00b001d09b2d5651mr1570045plr.1.1702584816052; Thu, 14 Dec
 2023 12:13:36 -0800 (PST)
Date: Thu, 14 Dec 2023 12:13:34 -0800
In-Reply-To: <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
Message-ID: <ZXth7hu7jaHbJZnj@google.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
From: Sean Christopherson <seanjc@google.com>
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> On Thu, Dec 14, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> Now when I think about it, the implementation seems to
> suggest that we are putting policies in kvm. Ideally, the goal is:
> - guest scheduler communicates the priority requirements of the workload
> - kvm applies the priority to the vcpu task.

Why?  Tasks are tasks, why does KVM need to get involved?  E.g. if the prob=
lem
is that userspace doesn't have the right knobs to adjust the priority of a =
task
quickly and efficiently, then wouldn't it be better to solve that problem i=
n a
generic way?

> - Now that vcpu is appropriately prioritized, host scheduler can make
> the right choice of picking the next best task.
>=20
> We have an exception of proactive boosting for interrupts/nmis. I
> don't expect these proactive boosting cases to grow. And I think this
> also to be controlled by the guest where the guest can say what
> scenarios would it like to be proactive boosted.
>=20
> That would make kvm just a medium to communicate the scheduler
> requirements from guest to host and not house any policies.  What do
> you think?

...
=20
> > Pushing the scheduling policies to host userspace would allow for far m=
ore control
> > and flexibility.  E.g. a heavily paravirtualized environment where host=
 userspace
> > knows *exactly* what workloads are being run could have wildly differen=
t policies
> > than an environment where the guest is a fairly vanilla Linux VM that h=
as received
> > a small amount of enlightment.
> >
> > Lastly, if the concern/argument is that userspace doesn't have the righ=
t knobs
> > to (quickly) boost vCPU tasks, then the proposed sched_ext functionalit=
y seems
> > tailor made for the problems you are trying to solve.
> >
> > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
> >
> You are right, sched_ext is a good choice to have policies
> implemented. In our case, we would need a communication mechanism as
> well and hence we thought kvm would work best to be a medium between
> the guest and the host.

Making KVM be the medium may be convenient and the quickest way to get a Po=
C
out the door, but effectively making KVM a middle-man is going to be a huge=
 net
negative in the long term.  Userspace can communicate with the guest just a=
s
easily as KVM, and if you make KVM the middle-man, then you effectively *mu=
st*
define a relatively rigid guest/host ABI.

If instead the contract is between host userspace and the guest, the ABI ca=
n be
much more fluid, e.g. if you (or any setup) can control at least some amoun=
t of
code that runs in the guest, then the contract between the guest and host d=
oesn't
even need to be formally defined, it could simply be a matter of bundling h=
ost
and guest code appropriately.

If you want to land support for a given contract in upstream repositories, =
e.g.
to broadly enable paravirt scheduling support across a variety of usersepac=
e VMMs
and/or guests, then yeah, you'll need a formal ABI.  But that's still not a=
 good
reason to have KVM define the ABI.  Doing it in KVM might be a wee bit easi=
er because
it's largely just a matter of writing code, and LKML provides a centralized=
 channel
for getting buyin from all parties.  But defining an ABI that's independent=
 of the
kernel is absolutely doable, e.g. see the many virtio specs.

I'm not saying KVM can't help, e.g. if there is information that is known o=
nly
to KVM, but the vast majority of the contract doesn't need to be defined by=
 KVM.

