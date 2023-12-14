Return-Path: <kvm+bounces-4538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B797813CB6
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 22:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1387D2822D2
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 21:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC136D1B9;
	Thu, 14 Dec 2023 21:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="HaSyZDqY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8D42DF66
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 21:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6d9d29a2332so510751a34.0
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 13:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702589810; x=1703194610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNTW4HGEn2eLI4nVJW3F+wSrHy2V3o9pHHtOnM+UAcE=;
        b=HaSyZDqYK6gTs607n3/KOvwr7sOZmwLxFgmR63DVXpIbpmIac9NKeBq3FXjrKm5Zqo
         qRdOXO+1x44T+BiXoRCJjaRBn/kI+ZSYAhnMIyWt3XdPS98pgMH++kryfvIx4uaKnUUf
         FT0oZdCT72aclUvXjRhthg4E9/1JsfAoF0AdrFK3viUrVfsn6OupFjA1F8Oz9vbSbMcR
         +KtUg9+kZ1jh50MLyt40exfupM6PghzWKS0Q2ATbElDgLx4jrZ23PRo5vULurHbJJj12
         KvNsmwVVKpZDOBbeq9PvgSTpzmFrEU8CGA6xppNiXWRIuZsVap+tAaGutQHOjMdWJLab
         MscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702589810; x=1703194610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wNTW4HGEn2eLI4nVJW3F+wSrHy2V3o9pHHtOnM+UAcE=;
        b=nVVNSqBXU/bdoZ1Au8icL74EAaP6W/KL+9Gnz/UPkqzSM6Q8CwwO7gcK6LvM0x30dd
         jo9HDZkmuD+0KarfVh6dfDpCA8dnRVETctuSn2pHux25/SCEJJGcz4CUffTTgS78FVn7
         0ldwP9XQOKhyxMI40IN4E1lf20TYHpWDyRflAOQhWxAU7WPM9xQzdBUGKnHfF16BdLTw
         2nuVg0hzRPmvZV3wH7X6cMGmf23JVoaiYJE+UiycEoLa55is8OSG4JPh+bRip25gck9L
         kuRZJhf+vKk37l3E3ZgYVeX8TJ5OczwoctqGfOiICA9qD2663CF4RY4V46yv4kBeNtnV
         X+0g==
X-Gm-Message-State: AOJu0Yzs3XV0UWjnTFJM1clQ6BIWyyZXypKGT8sQnkKRCWCJnSfSFxH0
	JJhVSNhVdw7urCm5SBOrmwlspJKG1e25Y7jG08ATeg==
X-Google-Smtp-Source: AGHT+IFM+9ZNZUOYR19J8c44hUkDjsv7+P/5K0QEly1j6LoUgEIed0HrDpXcJNvyS3mMvpwdR1Y+fB7yePDp5deqqZA=
X-Received: by 2002:a05:6830:4487:b0:6d9:e251:d946 with SMTP id
 r7-20020a056830448700b006d9e251d946mr5026570otv.15.1702589810225; Thu, 14 Dec
 2023 13:36:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com>
In-Reply-To: <ZXth7hu7jaHbJZnj@google.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Thu, 14 Dec 2023 16:36:39 -0500
Message-ID: <CAO7JXPhQ3zPzsNeuUphLx7o_+DOfJrmCoyRXXjcQMEzrKnGc9g@mail.gmail.com>
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

On Thu, Dec 14, 2023 at 3:13=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> > On Thu, Dec 14, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > Now when I think about it, the implementation seems to
> > suggest that we are putting policies in kvm. Ideally, the goal is:
> > - guest scheduler communicates the priority requirements of the workloa=
d
> > - kvm applies the priority to the vcpu task.
>
> Why?  Tasks are tasks, why does KVM need to get involved?  E.g. if the pr=
oblem
> is that userspace doesn't have the right knobs to adjust the priority of =
a task
> quickly and efficiently, then wouldn't it be better to solve that problem=
 in a
> generic way?
>
I get your point. A generic way would have been more preferable, but I
feel the scenario we are tackling is a bit more time critical and kvm
is better equipped to handle this. kvm has control over the VM/vcpu
execution and hence it can take action in the most effective way.

One example is the place where we handle boost/unboost. By the time
you come out of kvm to userspace it would be too late. Currently we
apply the boost soon after VMEXIT before enabling preemption so that
the next scheduler entry will consider the boosted priority. As soon
as you enable preemption, the vcpu could be preempted and boosting
would not help when it is boosted. This timing correctness is very
difficult to achieve if we try to do it in userland or do it
out-of-band.

[...snip...]
> > > Lastly, if the concern/argument is that userspace doesn't have the ri=
ght knobs
> > > to (quickly) boost vCPU tasks, then the proposed sched_ext functional=
ity seems
> > > tailor made for the problems you are trying to solve.
> > >
> > > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
> > >
> > You are right, sched_ext is a good choice to have policies
> > implemented. In our case, we would need a communication mechanism as
> > well and hence we thought kvm would work best to be a medium between
> > the guest and the host.
>
> Making KVM be the medium may be convenient and the quickest way to get a =
PoC
> out the door, but effectively making KVM a middle-man is going to be a hu=
ge net
> negative in the long term.  Userspace can communicate with the guest just=
 as
> easily as KVM, and if you make KVM the middle-man, then you effectively *=
must*
> define a relatively rigid guest/host ABI.
>
> If instead the contract is between host userspace and the guest, the ABI =
can be
> much more fluid, e.g. if you (or any setup) can control at least some amo=
unt of
> code that runs in the guest, then the contract between the guest and host=
 doesn't
> even need to be formally defined, it could simply be a matter of bundling=
 host
> and guest code appropriately.
>
> If you want to land support for a given contract in upstream repositories=
, e.g.
> to broadly enable paravirt scheduling support across a variety of usersep=
ace VMMs
> and/or guests, then yeah, you'll need a formal ABI.  But that's still not=
 a good
> reason to have KVM define the ABI.  Doing it in KVM might be a wee bit ea=
sier because
> it's largely just a matter of writing code, and LKML provides a centraliz=
ed channel
> for getting buyin from all parties.  But defining an ABI that's independe=
nt of the
> kernel is absolutely doable, e.g. see the many virtio specs.
>
> I'm not saying KVM can't help, e.g. if there is information that is known=
 only
> to KVM, but the vast majority of the contract doesn't need to be defined =
by KVM.
>
As you mentioned, custom contract between guest and host userspace is
really flexible, but I believe tackling scheduling(especially latency)
issues is a bit more difficult with generic approaches. Here kvm does
have some information known only to kvm(which could be shared - eg:
interrupt injection) but more importantly kvm has some unique
capabilities when it comes to scheduling. kvm and scheduler are
cooperating currently for various cases like, steal time accounting,
vcpu preemption state, spinlock handling etc. We could possibly try to
extend it a little further in a non-intrusive way.

Having a formal paravirt scheduling ABI is something we would want to
pursue (as I mentioned in the cover letter) and this could help not
only with latencies, but optimal task placement for efficiency, power
utilization etc. kvm's role could be to set the stage and share
information with minimum delay and less resource overhead. We could
use schedulers (vanilla, sched_ext, ...) to actually make decisions
based on the information it receives.

Thanks for all your valuable inputs and I understand that a formal ABI
is needed for the above interface. We shall look more into the
feasibility and efforts for this.

Thanks,
Vineeth

