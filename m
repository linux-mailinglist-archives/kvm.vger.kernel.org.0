Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF696C244B
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCTWMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCTWMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:12:25 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976161D937
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:12:07 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id h34so9000276uag.4
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679350326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOEZIjXJN/pwRoAvIr/0R59+DaKJuyWWS4vOreGHyM4=;
        b=F9D/UqV8m91hieGjFYR4VW5F4BDEzpA/pP3P7TP9BUVKVT/gm7/2p17J9k5TRfC5tX
         1rmxin98R58wpFE3hG/wOIClAPNWW7zBarMz0Nj3rf+dH9Sh9lm1IWp7dYiIYRBw9x4D
         ARYlrhGEJAF1vo/bQkJoidHnGQNvLVf04SH8/baAVKObxJXh07di2I71jWPa3QlHpLj7
         a4J+lGVhdwIHp0jc+D40P3EtnxJfWBJbTrqa5fkdvjeauIRbSXvYUQuHenVG/MW4V97F
         01owkDa2Bpfv1RMneJkZtz+AzF6RUB4ZNk6qd1m4jhhsRibzTALdane3MGR7LTpC1iLb
         N2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679350326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOEZIjXJN/pwRoAvIr/0R59+DaKJuyWWS4vOreGHyM4=;
        b=LR0Z5obHPByDEUuI1xS7++vj9OJRHI330NSRq7XQSW8IhQCOeCcuisjYND5anFkrQ7
         x60SO1HsNNy7Leu7ZT7jAxJRFu58YasKfONLqPCpmKoFn2PT9gY9wCmVoglKHRCoyNZ+
         YdzU/ixgn3fEqrTgrEstm3lG9jiHCo63O5K2gTAhCuTWOo/KYL4yLkWeB15W5mg2MWt9
         7tH8AujHmIr4CaV/SmSMebxGc8ICPepFz6DSRR9fnXPURdJKv6ASkt8tSITf7CfkbYna
         2Jp3mi8WhSeSaSwuazMU/qtx4O7TgwIzaZC/R822Lo+k4tU/mKwcWkYIZ1ytT11H6E47
         U4kg==
X-Gm-Message-State: AO0yUKXT28hhh1DNonphNNB9joDPoCi6uHuYv2Yq82Lww5SA3bcibOwv
        tuxaKw9Wq21hZ8YN8iJboIWMYq7Z3aTOM9c7GuuCvQ==
X-Google-Smtp-Source: AK7set/vfR7lEHTdTb4Ylw+wvtUr7f5RuNlpCZiguq0S9ZRmHG3sGJ9QuQR1rpgLqOYpWcvmrSHLCVkHZUz7m0nG4Wg=
X-Received: by 2002:a1f:2554:0:b0:435:b4a5:d3c0 with SMTP id
 l81-20020a1f2554000000b00435b4a5d3c0mr66550vkl.10.1679350326554; Mon, 20 Mar
 2023 15:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com>
In-Reply-To: <ZBiBkwIF4YHnphPp@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 20 Mar 2023 15:11:30 -0700
Message-ID: <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
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
>
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
>
> Filling kvm_run::memory_fault but not exiting to userspace is ok because =
userspace
> never sees the data, i.e. userspace is completely unaware.  This behavior=
 is not
> ideal from a KVM perspective as allowing KVM to fill the kvm_run union wi=
thout
> exiting to userspace can lead to other bugs, e.g. effective corruption of=
 the
> kvm_run union, but at least from a uABI perspective, the behavior is acce=
ptable.

Actually, I don't think the idea of filling in kvm_run.memory_fault
for -EFAULTs which don't make it to userspace works at all. Consider
the direct_map function, which bubbles its -EFAULT to
kvm_mmu_do_page_fault. kvm_mmu_do_page_fault is called from both
kvm_arch_async_page_ready (which ignores the return value), and by
kvm_mmu_page_fault (where the return value does make it to userspace).
Populating kvm_run.memory_fault anywhere in or under
kvm_mmu_do_page_fault seems an immediate no-go, because a wayward
kvm_arch_async_page_ready could (presumably) overwrite/corrupt an
already-set kvm_run.memory_fault / other kvm_run field.

That in turn looks problematic for the
memory-fault-exit-on-fast-gup-failure part of this series, because
there are at least a couple of cases for which kvm_mmu_do_page_fault
will -EFAULT. One is the early-efault-on-fast-gup-failure case which
was the original purpose of this series. Another is a -EFAULT from
FNAME(fetch) (passed up through FNAME(page_fault)). There might be
other cases as well. But unless userspace can/should resolve *all*
such -EFAULTs in the same manner, a kvm_run.memory_fault populated in
"kvm_mmu_page_fault" wouldn't be actionable. At least, not without a
whole lot of plumbing code to make it so.

Sean, am I missing anything here?
