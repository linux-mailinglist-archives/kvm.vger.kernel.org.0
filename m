Return-Path: <kvm+bounces-4579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA18814D3F
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 17:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 618421C231AF
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 16:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824ED3DBB1;
	Fri, 15 Dec 2023 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1iGS+ih0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4823D396
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e20c9c4080so8863137b3.3
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 08:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702658298; x=1703263098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zgdHSne41jls/Iu38cFPyplzyuw/yqgpZf6KTB9p7Bk=;
        b=1iGS+ih0epN1Rc/vpN1n7fgRAgsiX7p8806gxx9gr80zZTd2tYlFwDMCo9Sx4zULNU
         Hz6gCNmhphXY28HWdzkSQVHkgAN3w0y1FyL20UPiu5q6T8WBTvRr+YGJpB9kq+0yIMYo
         zQvALcXYqsWH6RqVXQhUJnRb1OZQBh1jrA0wPMW7q5MwUV8azQlN4ayVbO2cjYgfMccU
         AHTOAb/rjXXuXv7aTfiHfNsutiUyGvORtXJrzEiNierNsncfd/dNhUYJxTdwdiplm0Hv
         DLKG9FrPCLioPh9f7RwEqbMOcZh0kTyYCkaAfsc9o3ksDECd6WOd/tqfjf6kkK8byLtt
         donw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702658298; x=1703263098;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zgdHSne41jls/Iu38cFPyplzyuw/yqgpZf6KTB9p7Bk=;
        b=A4qopEvxiOmE/GIPTr1h5UHrEZ2LFlk8gwGfnAa+qQyRp49j6lN788C3R/BecXIbC1
         X2UdeKnS1Jqmvl5+xdGIMcgvoW8yf0gDUbDPCMXUMfgW8U8GKtAsQ8xHtZZRPqDZtDuT
         a8ie1Llw4kod3t68UpzV8Rg36RPVurQqWUJuTV9TBdrOhLI1dV3jj88wpDIMfTOhPQY/
         8LcZGEbZzJTRxtU34A0x+ncs6YUlqrG4/P8FMGomS0cEXzf68N51TL51M8PCsqMopS1b
         L+gZKrXL2q3P36wb5bc0VUebBYnlnHBz0Xc1moUSaOTk0B/UENmxqX54xsdgSy4gGdCO
         yrTQ==
X-Gm-Message-State: AOJu0YzfP+kjrP4HSD/HOed4kD1iQRN7oP09RA1yY+nFXKyBfCN7biKs
	Gh1x+7htzrKb2zCzK3NIFY5l7OjPKKQ=
X-Google-Smtp-Source: AGHT+IHnhe1jLf9GGToWx4e9UQAVVrl5imBG6KedCH2fTmmXsd8V1qfpC9/WDBslLt0CNZDLC0UfU/QHq3c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:534:b0:db4:6936:48b7 with SMTP id
 y20-20020a056902053400b00db4693648b7mr123425ybs.2.1702658297810; Fri, 15 Dec
 2023 08:38:17 -0800 (PST)
Date: Fri, 15 Dec 2023 08:38:16 -0800
In-Reply-To: <CAEXW_YTfgemRBKRv2UNjsOLhokxvvmHbVVj1JLtVmhywKtqeHA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com> <CAEXW_YTfgemRBKRv2UNjsOLhokxvvmHbVVj1JLtVmhywKtqeHA@mail.gmail.com>
Message-ID: <ZXyA-Me-DSmCWr7x@google.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
From: Sean Christopherson <seanjc@google.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023, Joel Fernandes wrote:
> Hi Sean,
> Nice to see your quick response to the RFC, thanks. I wanted to
> clarify some points below:
>=20
> On Thu, Dec 14, 2023 at 3:13=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> > > On Thu, Dec 14, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > Now when I think about it, the implementation seems to
> > > suggest that we are putting policies in kvm. Ideally, the goal is:
> > > - guest scheduler communicates the priority requirements of the workl=
oad
> > > - kvm applies the priority to the vcpu task.
> >
> > Why?  Tasks are tasks, why does KVM need to get involved?  E.g. if the =
problem
> > is that userspace doesn't have the right knobs to adjust the priority o=
f a task
> > quickly and efficiently, then wouldn't it be better to solve that probl=
em in a
> > generic way?
>=20
> No, it is not only about tasks. We are boosting anything RT or above
> such as softirq, irq etc as well.

I was talking about the host side of things.  A vCPU is a task, full stop. =
 KVM
*may* have some information that is useful to the scheduler, but KVM does n=
ot
*need* to initiate adjustments to a vCPU's priority.

> Could you please see the other patches?

I already have, see my comments about boosting vCPUs that have received NMI=
s and
IRQs not necessarily being desirable.

> Also, Vineeth please make this clear in the next revision.
>
> > > > Pushing the scheduling policies to host userspace would allow for f=
ar more control
> > > > and flexibility.  E.g. a heavily paravirtualized environment where =
host userspace
> > > > knows *exactly* what workloads are being run could have wildly diff=
erent policies
> > > > than an environment where the guest is a fairly vanilla Linux VM th=
at has received
> > > > a small amount of enlightment.
> > > >
> > > > Lastly, if the concern/argument is that userspace doesn't have the =
right knobs
> > > > to (quickly) boost vCPU tasks, then the proposed sched_ext function=
ality seems
> > > > tailor made for the problems you are trying to solve.
> > > >
> > > > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
> > > >
> > > You are right, sched_ext is a good choice to have policies
> > > implemented. In our case, we would need a communication mechanism as
> > > well and hence we thought kvm would work best to be a medium between
> > > the guest and the host.
> >
> > Making KVM be the medium may be convenient and the quickest way to get =
a PoC
> > out the door, but effectively making KVM a middle-man is going to be a =
huge net
> > negative in the long term.  Userspace can communicate with the guest ju=
st as
> > easily as KVM, and if you make KVM the middle-man, then you effectively=
 *must*
> > define a relatively rigid guest/host ABI.
>=20
> At the moment, the only ABI is a shared memory structure and a custom
> MSR. This is no different from the existing steal time accounting
> where a shared structure is similarly shared between host and guest,
> we could perhaps augment that structure with other fields instead of
> adding a new one?

I'm not concerned about the number of structures/fields, it's the amount/ty=
pe of
information and the behavior of KVM that is problematic.  E.g. boosting the=
 priority
of a vCPU that has a pending NMI is dubious.  This RFC has baked in a large
number of assumptions that (mostly) fit your specific use case, but do not
necessarily apply to all use cases.  I'm not even remotely convinced that w=
hat's
prosed here is optimal for your use case either.

> On the ABI point, we have deliberately tried to keep it simple (for examp=
le,
> a few months ago we had hypercalls and we went to great lengths to elimin=
ate
> those).

Which illustrates one of the points I'm trying to make is kind of my point.
Upstream will never accept anything that's wildly complex or specific becau=
se such
a thing is unlikely to be maintainable.  And so we'll end up with functiona=
lity
in KVM that is moderately helpful, but doesn't fully solve things and doesn=
't have
legs to go anywhere precisely because the specificity and/or complexity req=
uired
to eke out maximum performance will never be accepted.

> > If instead the contract is between host userspace and the guest, the AB=
I can be
> > much more fluid, e.g. if you (or any setup) can control at least some a=
mount of
> > code that runs in the guest
>=20
> I see your point of view. One way to achieve this is to have a BPF
> program run to implement the boosting part, in the VMEXIT path. KVM
> then just calls a hook. Would that alleviate some of your concerns?

Yes, it absolutely would!  I would *love* to build a rich set of BPF utilit=
ies
and whatnot for KVM[1].  I have zero objections to KVM making data availabl=
e to
BPF programs, i.e. to host userspace, quite the opposite.  What I am steadf=
astedly
against is KVM make decisions that are not obviously the "right" decisions =
in all
situations.  And I do not want to end up in a world where KVM has a big pil=
e of
knobs to let userspace control those decisions points, i.e. I don't want to=
 make
KVM a de facto paravirt scheduler.

I think there is far more potential for this direction.  KVM already has ho=
oks
for VM-Exit and VM-Entry, they likely just need to be enhanced to make them=
 more
useful for BPF programs.  And adding hooks in other paths shouldn't be too
contentious, e.g. in addition to what you've done in this RFC, adding a hoo=
k to
kvm_vcpu_on_spin() could be quite interesting as I would not be at all surp=
rised
if userspace could make far better decisions when selecting the vCPU to yie=
ld to.

And there are other use cases for KVM making "interesting" data available t=
o
userspace, e.g. there's (very early) work[2] to allow userspace to poll() o=
n vCPUs,
which likely needs much of the same information that paravirt scheduling wo=
uld
find useful, e.g. whether or not the vCPU has pending events.

[1] https://lore.kernel.org/all/ZRIf1OPjKV66Y17%2F@google.com
[2] https://lore.kernel.org/all/ZR9gATE2NSOOhedQ@google.com

> > then the contract between the guest and host doesn't
> > even need to be formally defined, it could simply be a matter of bundli=
ng host
> > and guest code appropriately.
> >
> > If you want to land support for a given contract in upstream repositori=
es, e.g.
> > to broadly enable paravirt scheduling support across a variety of users=
epace VMMs
> > and/or guests, then yeah, you'll need a formal ABI.  But that's still n=
ot a good
> > reason to have KVM define the ABI.  Doing it in KVM might be a wee bit =
easier because
> > it's largely just a matter of writing code, and LKML provides a central=
ized channel
> > for getting buyin from all parties.  But defining an ABI that's indepen=
dent of the
> > kernel is absolutely doable, e.g. see the many virtio specs.
> >
> > I'm not saying KVM can't help, e.g. if there is information that is kno=
wn only
> > to KVM, but the vast majority of the contract doesn't need to be define=
d by KVM.
>=20
> The key to making this working of the patch is VMEXIT path, that is
> only available to KVM. If we do anything later, then it might be too
> late.=20

Strictly speaking, no, it's not.  It's key if and only if *KVM* boosts the =
priority
of the task/vCPU (or if KVM provides a hook for a BPF program to do its thi=
ng).

> We have to intervene *before* the scheduler takes the vCPU thread off the
> CPU.

If the host scheduler is directly involved in the paravirt shenanigans, the=
n
there is no need to hook KVM's VM-Exit path because the scheduler already h=
as the
information needed to make an informed decision.

> Similarly, in the case of an interrupt injected into the guest, we have
> to boost the vCPU before the "vCPU run" stage -- anything later might be =
too
> late.

Except that this RFC doesn't actually do this.  KVM's relevant function nam=
es suck
and aren't helping you, but these patches boost vCPUs when events are *pend=
ed*,
not when they are actually injected.

Now, maybe boosting vCPUs with pending events is actually desirable, but th=
at is
precisely the type of policy making that I do not want to have in KVM.  Tak=
e the
existing kvm_vcpu_on_spin() path for example.  It's a relatively simple ide=
a, and
has no major downsides since KVM has very high confidence that the current =
vCPU
is spinning, i.e. waiting on something and thus doing nothing useful.

But even that path has a non-trivial amount of subtle, delicate logic to im=
prove
the probability that KVM yields to a vCPU that can actually make forward pr=
ogress.

Boosting the priority of vCPUs at semi-arbitrary points is going to be much=
 more
difficult for KVM to "get right".  E.g. why boost the priority of a vCPU th=
at has
a pending IRQ, but not a vCPU that is running with IRQs disabled?  The pote=
ntial
for endless twiddling to try and tune KVM's de facto scheduling logic so th=
at it's
universally "correct" is what terrifies me.

> Also you mentioned something about the tick path in the other email,
> we have no control over the host tick preempting the vCPU thread. The
> guest *will VMEXIT* on the host tick. On ChromeOS, we run multiple VMs
> and overcommitting is very common especially on devices with smaller
> number of CPUs.
>=20
> Just to clarify, this isn't a "quick POC". We have been working on
> this for many months and it was hard to get working correctly and
> handle all corner cases. We are finally at a point where - it just
> works (TM) and is roughly half the code size of when we initially
> started.

