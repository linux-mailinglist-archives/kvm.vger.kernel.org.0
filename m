Return-Path: <kvm+bounces-6849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 090BC83AF3C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:09:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABC3728526B
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4AC7F7C6;
	Wed, 24 Jan 2024 17:06:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794537F7C3;
	Wed, 24 Jan 2024 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706116017; cv=none; b=bw2T7kIkYxzrCG5QA6hXKjsAJVdiEATErN8mQYlu2lA6FqjiKhAd7lyZHZ+RkELLwoXOq1ykOcPFdQ+q7iAhv5Z/0DQ96lYuaO/1pPI3R8aSUNkxyTGI5DaM8Eih7ZOjT+5lJTDHYEg+o6nZKhdpGDCZT9FWCAA+yGSf82WCla8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706116017; c=relaxed/simple;
	bh=yGMFy9VbHpVW4x3/ENaUg/gKL8ctcbbQE18kHBt8/jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3qnsNmRlKDt//1CGFLRNF+KCQiQYMiLEoZ+Wry3VighCtWABhs2tV1kYWMebpHuJgquSSHli9c7m+bFr0iWc9Xi0y5xu4lFXzx9Z2zb+zf36bfReHLokUnqyUvl8izFsjV8nqh6G/1Kx5gWlpBUqzwT871B3u1mbP6wW9p7GCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=manifault.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=manifault.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-78315243c11so366618085a.3;
        Wed, 24 Jan 2024 09:06:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706116014; x=1706720814;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qRUj4hZOopN5foqfkobvTVsuJ/p+9KKRg1G6NkkN3AQ=;
        b=timdqBG+EOAeT9e0AcZ5K2OySVQbmdwoxG09PVDZy1IEFo05Q2OqANjLaoQpUaEKNX
         AWApJJjueOAok6sZqzu9V2Jvv5wHQBoWRu7tDkBn2f3WGiOGRjTkzixCwmXa9VJaT+GU
         FC0+mQjXmNuR6hRP5a8dIUTs56fqCRuFoJDw/b4Xde39lL/SMVRQ7gPWkEacCFknlLG5
         s/FU50ewkoF8arbw2N0tID3Qcll/vV11gLdBadt0RrSlulVYCd3Yly013uM+8MVLjXCj
         gLANyeOJEt0VQGXarFuYSLultnAdMzCb4shO+tEn07zOs8ASC3fVTl/8E+Ld3g5gfZBb
         o3bA==
X-Gm-Message-State: AOJu0YywdGiUjVq0GnfZ6Ehpyk7g2/Jdn3Naswd/WFqLBevcBm1Csr1U
	DMOAFcGl+vxoMLFKW8sGsHk7YAlK9Nj8QJRKaGSYF9Xu8cytcQhD
X-Google-Smtp-Source: AGHT+IGJXq5APfx++ki18RYMyUS6NTP/zomGaaou1GT7xY7+Wj0cB04eowFYBo3wxmOowwebuXOQJw==
X-Received: by 2002:a05:6214:e6a:b0:686:212d:4efa with SMTP id jz10-20020a0562140e6a00b00686212d4efamr3242899qvb.51.1706116014064;
        Wed, 24 Jan 2024 09:06:54 -0800 (PST)
Received: from maniforge (c-24-1-27-177.hsd1.il.comcast.net. [24.1.27.177])
        by smtp.gmail.com with ESMTPSA id ly4-20020a0562145c0400b0068688a2964asm3632815qvb.113.2024.01.24.09.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 09:06:53 -0800 (PST)
Date: Wed, 24 Jan 2024 11:06:48 -0600
From: David Vernet <void@manifault.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Sean Christopherson <seanjc@google.com>,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>,
	Barret Rhoden <brho@google.com>, David Dunn <daviddunn@google.com>,
	julia.lawall@inria.fr, himadrispandya@gmail.com,
	jean-pierre.lozi@inria.fr, ast@kernel.org, paulmck@kernel.org
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
Message-ID: <20240124170648.GA249939@maniforge>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com>
 <20231215181014.GB2853@maniforge>
 <6595bee6.e90a0220.57b35.76e9@mx.google.com>
 <20240104223410.GE303539@maniforge>
 <052b0521-2273-4b1f-bd94-a3decceb9b05@joelfernandes.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4R1mPdi76Z6lAXqf"
Content-Disposition: inline
In-Reply-To: <052b0521-2273-4b1f-bd94-a3decceb9b05@joelfernandes.org>
User-Agent: Mutt/2.2.12 (2023-09-09)


--4R1mPdi76Z6lAXqf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 09:15:10PM -0500, Joel Fernandes wrote:
> Hi David,
> I got again side tracked. I'll now prioritize this thread with quicker
> (hopefully daily) replies.

Hi Joel,

Thanks for your detailed reply.

[...]

> > Thanks for clarifying. I think we're on the same page. I didn't mean to
> > imply that KVM is actually in the scheduler making decisions about what
> > task to run next, but that wasn't really my concern. My concern is that
> > this patch set makes KVM responsible for all of the possible paravirt
> > policies by encoding it in KVM UAPI, and is ultimately responsible for
> > being aware of and communicating those policies between the guest to the
> > host scheduler.
> >=20
> > Say that we wanted to add some other paravirt related policy like "these
> > VCPUs may benefit from being co-located", or, "this VCPU just grabbed a
> > critical spinlock so please pin me for a moment". That would require
> > updating struct guest_schedinfo UAPI in kvm_para.h, adding getters and
> > setters to kvm_host.h to set those policies for the VCPU (though your
> > idea to use a BPF hook on VMEXIT may help with that onme), setting the
> > state from the guest, etc.
>=20
> These are valid points, and I agree!
>=20
> >=20
> > KVM isn't making scheduling decisions, but it's the arbiter of what data
> > is available to the scheduler to consume. As it relates to a VCPU, it
> > seems like this patch set makes KVM as much invested in the scheduling
> > decision that's eventually made as the actual scheduler. Also worth
> > considering is that it ties KVM UAPI to sched/core.c, which seems
> > undesirable from the perspective of both subsystems.
>=20
> Ok, Agreed.
>=20
> >=20
> >> In that sense, I agree with Sean that we are probably forcing a singul=
ar
> >> policy on when and how to boost which might not work for everybody (in=
 theory
> >> anyway). And I am perfectly OK with the BPF route as I mentioned in th=
e other
> >=20
> > FWIW, I don't think it's just that boosting may not work well in every
> > context (though I do think there's an argument to be made for that, as
> > Sean pointed out r.e. hard IRQs in nested context). The problem is also
> > that boosting is just one example of a paravirt policy that you may want
> > to enable, as I alluded to above, and that comes with complexity and
> > maintainership costs.
>=20
> Ok, agreed.
>=20
> >=20
> >> email. So perhaps we can use a tracepoint in the VMEXIT path to run a =
BPF
> >> program (?). And we still have to figure out how to run BPF programs i=
n the
> >> interrupt injections patch (I am currently studying those paths more a=
lso
> >> thanks to Sean's email describing them).
> >=20
> > If I understand correctly, based on your question below, the idea is to
> > call sched_setscheduler() from a kfunc in this VMEXIT BPF tracepoint?
> > Please let me know if that's correct -- I'll respond to this below where
> > you ask the question.
>=20
> Yes that's correct.
>=20
> >=20
> > As an aside, even if we called a BPF tracepoint prog on the VMEXIT path,
> > AFAIU it would still require UAPI changes given that we'd still need to
> > make all the same changes in the guest, right?
>=20
> By UAPI, do you mean hypercall or do you mean shared memory? If hypercall=
, we
> actually don't need hypercall for boosting. We boost during VMEXIT. We on=
ly need
> to set some state from the guest, in shared memory to hint that it might =
be
> needed at some point in the future. If no preemption-induced VMEXIT happe=
ns,
> then no scheduler boosting happens (or needs to happen).

So I was referring to setting state in shared memory from the guest.
Specifically, the UAPI defined in [0] and set in [1] (also shown below).
There's no hypercall here, right? But we're still adding UAPI for the
shared data structure written by the guest and consumed by the host.
Please let me know if I'm missing something, which seems very possible.

[0]: https://lore.kernel.org/all/20231214024727.3503870-4-vineeth@bitbytewo=
rd.org/
[1]: https://lore.kernel.org/all/20231214024727.3503870-8-vineeth@bitbytewo=
rd.org/

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/a=
sm/kvm_para.h
index 6b1dea07a563..e53c3f3a88d7 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -167,11 +167,30 @@ enum kvm_vcpu_boost_state {
 	VCPU_BOOST_BOOSTED
 };
=20
+/*
+ * Boost Request from guest to host for lazy boosting.
+ */
+enum kvm_vcpu_boost_request {
+	VCPU_REQ_NONE =3D 0,
+	VCPU_REQ_UNBOOST,
+	VCPU_REQ_BOOST,
+};
+
+
+union guest_schedinfo {
+	struct {
+		__u8 boost_req;
+		__u8 preempt_disabled;
+	};
+	__u64 pad;
+};
+
 /*
  * Structure passed in via MSR_KVM_PV_SCHED
  */
 struct pv_sched_data {
 	__u64 boost_status;
+	union guest_schedinfo schedinfo;
 };

> There might be a caveat to the unboosting path though needing a hypercall=
 and I
> need to check with Vineeth on his latest code whether it needs a hypercal=
l, but
> we could probably figure that out. In the latest design, one thing I know=
 is
> that we just have to force a VMEXIT for both boosting and unboosting. Wel=
l for
> boosting, the VMEXIT just happens automatically due to vCPU preemption, b=
ut for
> unboosting it may not.

As mentioned above, I think we'd need to add UAPI for setting state from
the guest scheduler, even if we didn't use a hypercall to induce a
VMEXIT, right?

> In any case, can we not just force a VMEXIT from relevant path within the=
 guest,
> again using a BPF program? I don't know what the BPF prog to do that woul=
d look
> like, but I was envisioning we would call a BPF prog from within a guest =
if
> needed at relevant point (example, return to guest userspace).

I agree it would be useful to have a kfunc that could be used to force a
VMEXIT if we e.g. need to trigger a resched or something. In general
that seems like a pretty reasonable building block for something like
this. I expect there are use cases where doing everything async would be
useful as well. We'll have to see what works well in experimentation.

> Does that make sense?

Yes it does, though I want to make sure I'm not misunderstanding what
you mean by shared memory vs. hypercall as it relates to UAPI.

> > I see why having a BPF
> > hook here would be useful to avoid some of the logic on the host that
> > implements the boosting, and to give more flexibility as to when to
> > apply that boosting, but in my mind it seems like the UAPI concerns are
> > the most relevant.
>=20
> Yes, lets address the UAPI. My plan is to start a new design document lik=
e a
> google doc, and I could share that with you so we can sketch this out. Wh=
at do
> you think? And perhaps also we can discuss it at LSFMM.

Awesome, thank you for writing that up. I'm happy to take a look when
it's ready for more eyes.

[...]

> >>> The main building block that I was considering is a new kptr [0] and =
set
> >>> of kfuncs [1] that would allow a BPF program to have one or more R/W
> >>> shared memory regions with a guest.
> >>
> >> I really like your ideas around sharing memory across virt boundary us=
ing
> >> BPF. The one concern I would have is that, this does require loading a=
 BPF
> >> program from the guest userspace, versus just having a guest kernel th=
at
> >> 'does the right thing'.
> >=20
> > Yeah, that's a fair concern. The problem is that I'm not sure how we get
> > around that if we want to avoid tying up every scheduling paravirt
> > policy into a KVM UAPI. Putting everything into UAPI just really doesn't
> > seem scalable. I'd be curious to hear Sean's thoughts on this. Note that
> > I'm not just talking about scheduling paravirt here -- one could imagine
> > many possible examples, e.g. relating to I/O, MM, etc.
>=20
> We could do same thing in guest, call BPF prog at a certain point, if nee=
ded.
> But again, since we only need to bother with VMEXIT for scheduler boosting
> (which doesn't need hypercall), it should be Ok. For the unboosting part,=
 we

Hopefully my explanation above r.e. shared memory makes sense. My worry
isn't just for hypercalls, it's that we also need to make UAPI changes
for the guest to set the shared memory state that's read by the host. If
we instead had the BPF program in the guest setting state via its shared
memory channel with the BPF prog on the host, that's a different story.

> could implement that also using either a BPF prog at appropriate guest ho=
ok, or
> just having a timer go off to take away boost if boosting has been done t=
oo
> long. We could award a boost for a bounded time as well, and force a VMEX=
IT to
> unboost if VMEXIT has not already happened yet.. there should be many way=
s to
> avoid an unboost hypercall..
>
> > It seems much more scalable to instead have KVM be responsible for
> > plumbing mappings between guest and host BPF programs (I haven't thought
> > through the design or interface for that at _all_, just thinking in
> > high-level terms here), and then those BPF programs could decide on
> > paravirt interfaces that don't have to be in UAPI.
>=20
> It sounds like by UAPI, you mean hypercalls right? The actual shared memo=
ry
> structure should not be a UAPI concern since that will defined by the BPF
> program and how it wants to interpret the fields..

See above -- I mean the shared data structure added in patch 3 / 8
("kvm: x86: vcpu boosting/unboosting framework").

> > Having KVM be
> > responsible for setting up opaque communication channels between the
> > guest and host feels likes a more natural building block than having it
> > actually be aware of the policies being implemented over those
> > communication channels.
>=20
> Agreed.
>=20
> >=20
> >> On the host, I would have no problem loading a BPF program as a one-ti=
me
> >> thing, but on the guest it may be more complex as we don't always cont=
rol the
> >> guest userspace and their BPF loading mechanisms. Example, an Android =
guest
> >> needs to have its userspace modified to load BPF progs, etc. Not hard
> >> problems, but flexibility comes with more cost. Last I recall, Android=
 does
> >> not use a lot of the BPF features that come with the libbpf library be=
cause
> >> they write their own userspace from scratch (due to licensing). OTOH, =
if this
> >> was an Android kernel-only change, that would simplify a lot.
> >=20
> > That is true, but the cost is double-sided. On the one hand, we have the
> > complexity and maintenance costs of plumbing all of this through KVM and
> > making it UAPI. On the other, we have the cost of needing to update a
> > user space framework to accommodate loading and managing BPF programs.
> > At this point BPF is fully supported on aarch64, so Android should have
> > everything it needs to use it. It sounds like it will require some
> > (maybe even a lot of) work to accommodate that, but that seems
> > preferable to compensating for gaps in a user space framework by adding
> > complexity to the kernel, no?
>=20
> Yes it should be preferable.
>=20
> >=20
> >> Still there is a lot of merit to sharing memory with BPF and let BPF d=
ecide
> >> the format of the shared memory, than baking it into the kernel... so =
thanks
> >> for bringing this up! Lets talk more about it... Oh, and there's my LS=
FMMBPF
> >> invitiation request ;-) ;-).
> >=20
> > Discussing this BPF feature at LSFMMBPF is a great idea -- I'll submit a
> > proposal for it and cc you. I looked and couldn't seem to find the
> > thread for your LSFMMBPF proposal. Would you mind please sending a link?
>=20
> I actually have not even submitted one for LSFMM but my management is sup=
portive
> of my visit. Do you want to go ahead and submit one with all of us includ=
ed in
> the proposal? And I am again sorry for the late reply and hopefully we di=
d not
> miss any deadlines. Also on related note, there is interest in sched_ext =
for

I see that you submitted a proposal in [2] yesterday. Thanks for writing
it up, it looks great and I'll comment on that thread adding a +1 for
the discussion.

[2]: https://lore.kernel.org/all/653c2448-614e-48d6-af31-c5920d688f3e@joelf=
ernandes.org/

No worries at all about the reply latency. Thank you for being so open
to discussing different approaches, and for driving the discussion. I
think this could be a very powerful feature for the kernel so I'm
pretty excited to further flesh out the design and figure out what makes
the most sense here.

> more custom scheduling. We could discuss that as well while at LSFMM.

Sure thing. I haven't proposed a topic for that yet as I didn't have
anything new to discuss following last year's discussion, but I'm happy
to continue the discussion this year. I'll follow up with you in a
separate thread.

> >=20
> >>> This could enable a wide swath of
> >>> BPF paravirt use cases that are not limited to scheduling, but in ter=
ms
> >>> of sched_ext, the BPF scheduler could communicate with the guest
> >>> scheduler over this shared memory region in whatever manner was requi=
red
> >>> for that use case.
> >>>
> >>> [0]: https://lwn.net/Articles/900749/
> >>> [1]: https://lwn.net/Articles/856005/
> >>
> >> Thanks, I had no idea about these. I have a question -- would it be po=
ssible
> >> to call the sched_setscheduler() function in core.c via a kfunc? Then =
we can
> >> trigger the boost from a BPF program on the host side. We could start =
simple
> >> from there.
> >=20
> > There's nothing stopping us from adding a kfunc that calls
> > sched_setscheduler(). The questions are how other scheduler folks feel
> > about that, and whether that's the appropriate general solution to the
> > problem. It does seem odd to me to have a random KVM tracepoint be
> > entitled to set a generic task's scheduling policy and priority.
>=20
> Such oddities are application specific though. User space can already call
> setscheduler arbitrarily, so why not a BPF program?

Hmm, that's a good point. Perhaps it does make sense. The BPF program
would be no less privileged than a user space application with
sufficient privileges to change a remote task's prio.

> >> I agree on the rest below. I just wanted to emphasize though that this=
 patch
> >> series does not care about what the scheduler does. It merely hints the
> >> scheduler via a priority setting that something is an important task. =
That's
> >> a far cry from how to actually schedule and the spirit here is to use
> >> whatever scheduler the user has to decide how to actually schedule.
> >=20
> > Yep, I don't disagree with you at all on that point. To me this really
> > comes down to a question of the costs and long-term design choices, as
> > we discussed above:
> >=20
> > 1. What is the long-term maintenance cost to KVM and the scheduler to
> >    land paravirt scheduling in this form?
> >=20
> > Even assuming that we go with the BPF hook on VMEXIT approach, unless
> > I'm missing something, I think we'd still need to make UAPI changes to
> > kvm_para.h, and update the guest to set the relevant paravirt state in
> > the guest scheduler.
>=20
> As mentioned above, for boosting, there is no hypercall. The VMEXIT is in=
duced
> by host preemption.

I expect I am indeed missing something then, as mentioned above. VMEXIT
aside, we still need some UAPI for the shared structure between the
guest and host where the guest indicates its need for boosting, no?

> > That's not a huge amount of code for just boosting
> > and deboosting, but it sets the precedent that any and all future
> > scheduling paravirt logic will need to go through UAPI, and that the
> > core scheduler will need to accommodate that paravirt when and where
> > appropriate.
> >=20
> > I may be being overly pessimistic, but I feel that could open up a
> > rather scary can of worms; both in terms of the potential long-term
> > complexity in the kernel itself, and in terms of the maintenance burden
> > that may eventually be imposed to properly support it. It also imposes a
> > very high bar on being able to add and experiment with new paravirt
> > policies.
>=20
> Hmm, yeah lets discuss this more. It does appear we need to do *something=
* than
> leaving the performance on the table.

Agreed. There is a lot of performance to be gained from this. Doing
nothing is not the answer. Or at least not the answer I'm hoping for.

> >=20
> > 2. What is the cost we're imposing on users if we force paravirt to be
> >    done through BPF? Is this prohibitively high?
> >=20
> > There is certainly a nonzero cost. As you pointed out, right now Android
> > apparently doesn't use much BPF, and adding the requisite logic to use
> > and manage BPF programs is not insigificant.
> >=20
> > Is that cost prohibitively high? I would say no. BPF should be fully
> > supported on aarch64 at this point, so it's really a user space problem.
> > Managing the system is what user space does best, and many other
> > ecosystems have managed to integrate BPF to great effect. So while the
> > cost is cetainly nonzero, I think there's a reasonable argument to be
> > made that it's not prohibitively high.
>=20
> Yes, I think it is doable.
>=20
> Glad to be able to finally reply, and I shall prioritize this thread more=
 on my
> side moving forward.

Thanks for your detailed reply, and happy belated birthday :-)

- David

--4R1mPdi76Z6lAXqf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRBxU1So5MTLwphjdFZ5LhpZcTzZAUCZbFDqAAKCRBZ5LhpZcTz
ZCqAAP9f+kGjStCUcU3vqdULLBVReejQXmbA+d5TRhsCUBi7KAEAqNlIqVlqhXt2
ZJrZvqYlzV92BvOZNn32NSr4xREhbgQ=
=eLuT
-----END PGP SIGNATURE-----

--4R1mPdi76Z6lAXqf--

