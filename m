Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843166C1FAF
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 19:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCTS2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 14:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjCTS1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 14:27:22 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECEB41B42
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 11:20:13 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id i22so8564964uat.8
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 11:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679336412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iqr7dqeCu3WuwYcjyIEJKpkp1we1G6oozoTi9KflYfw=;
        b=U/l+BtAb13glvSZD1gnQjmc58AGU+zB2xfK1EqwDRN7ROuY74uxdF3IsbYHH2ZBbij
         JazuWbnXF0MNOOS+O1M0QiZ/YWT90WyHM9e4lQYf4znuot++tSQmbBNhiBNzichas8zV
         a/5b+dyZ+MIoeuiL6HT6LxUs06xdQq7WeMwVzukLyMI9NTSGSglvq5pyrw7D2905i4pa
         Wuvjz2MEWXHACp8vL+VPanZ+12TStjQQdXWp2UPZW8PIjYaA5IvLO23uIw2vLx/a2X9F
         WEYmORTA1o5HjhnNVDWuXzPkiUwqYdPuwHpedYKNfcecNj+Lvw5CMURYid+JSIi+4eyq
         tDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679336412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iqr7dqeCu3WuwYcjyIEJKpkp1we1G6oozoTi9KflYfw=;
        b=0RoA28qsdTuyzsd6RHfSj7/jUiPCn3qS3YL0biJt9DeyDPCqFOrzefdCFOb5yN0nQ1
         eFDuNRkBJpFTcqC0rCtSaqazHAXp9bsW4hfqF59Rc82QlBGFPetncHRJXxpnTkuuS7/7
         j9z3hClLTecFUd5XEV96p5PHARFiPuC2D9bOPo26zlB1+iJSwvz0Z27cU+sNzPVW8d7D
         j1UxNIdt629v9e/bVrAS4KLhqp9t6f9bl7kGw5mdLY57QTmZcozLOwszF4PkLOb2j8Ae
         76pq3a6PHUvNMxEa8w8FCE4eKlOv2TwuxWiD7wRb8yLjXdqMUGBZFmj4swB+nTDYFdRT
         JB7g==
X-Gm-Message-State: AO0yUKUeqYZfyVmNn1uKPvyOu0FbDPypxGUq98U6MSd1TJ5GTVmwivqL
        G5TG6AbMCsB/molS4hJo+6SfOu2w8KkQeYjiYVT3Qg==
X-Google-Smtp-Source: AK7set9Op4pDW/dPGGPc4Qei66Ay/8m0gFEvEAoS3SvEakdmFx60+M4OiiimSlLREQzHLk55ouK95TYSngn0gDbP2mI=
X-Received: by 2002:a05:6122:181b:b0:401:8087:3693 with SMTP id
 ay27-20020a056122181b00b0040180873693mr109603vkb.10.1679336411631; Mon, 20
 Mar 2023 11:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com>
In-Reply-To: <ZBiBkwIF4YHnphPp@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 20 Mar 2023 11:19:35 -0700
Message-ID: <CAF7b7mrQBA3Po47Vvy5LOdMPHkDo=DVPsWXYOt9-pU8ndeds3A@mail.gmail.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Mar 17, 2023, Anish Moorthy wrote:
> > On Fri, Mar 17, 2023 at 2:50=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > I wonder if we can get away with returning -EFAULT, but still filling=
 vcpu->run
> > > with KVM_EXIT_MEMORY_FAULT and all the other metadata.  That would li=
kely simplify
> > > the implementation greatly, and would let KVM fill vcpu->run uncondit=
onally.  KVM
> > > would still need a capability to advertise support to userspace, but =
userspace
> > > wouldn't need to opt in.  I think this may have been my very original=
 though, and
> > > I just never actually wrote it down...
> >
> > Oh, good to know that's actually an option. I thought of that too, but
> > assumed that returning a negative error code was a no-go for a proper
> > vCPU exit. But if that's not true then I think it's the obvious
> > solution because it precludes any uncaught behavior-change bugs.
> >
> > A couple of notes
> > 1. Since we'll likely miss some -EFAULT returns, we'll need to make
> > sure that the user can check for / doesn't see a stale
> > kvm_run::memory_fault field when a missed -EFAULT makes it to
> > userspace. It's a small and easy-to-fix detail, but I thought I'd
> > point it out.
>
> Ya, this is the main concern for me as well.  I'm not as confident that i=
t's
> easy-to-fix/avoid though.
>
> > 2. I don't think this would simplify the series that much, since we
> > still need to find the call sites returning -EFAULT to userspace and
> > populate memory_fault only in those spots to avoid populating it for
> > -EFAULTs which don't make it to userspace.
>
> Filling kvm_run::memory_fault even if KVM never exits to userspace is per=
fectly
> ok.  It's not ideal, but it's ok.

Right- I was just pointing out that doing so could mislead readers of
the code if they assume that kvm_run::memory_fault is populated iff it
was going to be associated w/ an exit to userspace," which I know I
would.

> > We *could* relax that condition and just document that memory_fault sho=
uld be
> > ignored when KVM_RUN does not return -EFAULT... but I don't think that'=
s a
> > good solution from a coder/maintainer perspective.
>
> You've got things backward.  memory_fault _must_ be ignored if KVM doesn'=
t return
> the associated "magic combo", where the magic value is either "0+KVM_EXIT=
_MEMORY_FAULT"
> or "-EFAULT+KVM_EXIT_MEMORY_FAULT".

I think we're saying the same thing- I was using "should" to mean "must."

> Filling kvm_run::memory_fault but not exiting to userspace is ok because =
userspace
> never sees the data, i.e. userspace is completely unaware.  This behavior=
 is not
> ideal from a KVM perspective as allowing KVM to fill the kvm_run union wi=
thout
> exiting to userspace can lead to other bugs, e.g. effective corruption of=
 the
> kvm_run union

Ooh, I didn't think of the corruption issue here: thanks for pointing it ou=
t.

> but at least from a uABI perspective, the behavior is acceptable.

This does complicate things for KVM implementation though, right? In
particular, we'd have to make sure that KVM_RUN never conditionally
modifies its return value/exit reason based on reads from kvm_run:
that seems like a slightly weird thing to do, but I don't want to
assume anything here.

Anyways, unless that's not (and never will be) a problem, allowing
corruption of kvm_run seems very risky.

> The reverse, userspace consuming kvm_run::memory_fault without being expl=
icitly
> told the data is valid, is not ok/safe.  KVM's contract is that fields co=
ntained
> in kvm_run's big union are valid if and only if KVM returns '0' and the a=
ssociated
> exit reason is set in kvm_run::exit_reason.
>
> From an ABI perspective, I don't see anything fundamentally wrong with be=
nding
> that rule slightly by saying that kvm_run::memory_fault is valid if KVM r=
eturns
> -EFAULT+KVM_EXIT_MEMORY_FAULT.  It won't break existing userspace that is=
 unaware
> of KVM_EXIT_MEMORY_FAULT, and userspace can precisely check for the combi=
nation.
>
> My big concern with piggybacking -EFAULT is that userspace will be fed st=
ale if
> KVM exits with -EFAULT in a patch that _doesn't_ fill kvm_run::memory_fau=
lt.
> Returning a negative error code isn't hazardous in and of itself, e.g. KV=
M has
> had bugs in the past where KVM returns '0' but doesn't fill kvm_run::exit=
_reason.
> The big danger is that KVM has existing paths that return -EFAULT, i.e. w=
e can
> introduce bugs simply by doing nothing, whereas returning '0' would large=
ly be
> limited to new code.
>
> The counter-argument is that propagating '0' correctly up the stack carri=
es its
> own risk due to plenty of code correctly treating '0' as "success" and no=
t "exit
> to userspace".
>
> And we can mitigate the risk of using -EFAULT.  E.g. fill in kvm_run::mem=
ory_fault
> even if we are 99.9999% confident the -EFAULT can't get out to userspace =
in the
> context of KVM_RUN, and set kvm_run::exit_reason to some arbitrary value =
at the
> start of KVM_RUN to prevent reusing memory_fault from a previous userspac=
e exit.

Right, this is what I had in mind when I called this "small and
easy-to-fix." Piggybacking -EFAULT seems like the right thing to do to
me, but I'm still uneasy about possibly corrupting kvm_run for masked
-EFAULTS.
