Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75C76C1ADE
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 17:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbjCTQFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 12:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjCTQEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 12:04:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBD83C7AD
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:54:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5425c04765dso125562587b3.0
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679327637;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZnhQmPSkOwm2b/4XIY9w2NI6qEiUWNWo7DH/h31iCc=;
        b=rpZL0tkII/ncyN0hK9Xe9NDFuLAiS6tl9FKkEGeyEk7veheqYR9vJcJN5RvdT9kjF9
         IlwsJeVXs4XHd7KugbaW1NaXaQvEj7sDxJSDp5hknR1GxrGXD+EY2ri65KY5MNqCzy6q
         15r5GcRwd8QkdJeOr7w5cXcmIw86kTe3peR3FGJjE2CzZbeeJ0hJV4U0R271DY+lF1QG
         q+FZIUmKBa5Vm1HXG5Vw8bwkmy2q2hfIhtX/TAUj78Fr82BzaUD7elqUGBINJ5MMilNL
         m7AB6RjOfbD0KYgdRdE5pCaapLyIH7MQatmFZzFC+c07PB7ON7rC98E4ujfUIHmaaWeE
         ZB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679327637;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DZnhQmPSkOwm2b/4XIY9w2NI6qEiUWNWo7DH/h31iCc=;
        b=rQbI2l4DLkc1MCJ8y1vQqV+q0xMNCbz1oE+PsGKNTfKeHBUvOBXYe46tlGaJYVsH62
         xzs435dxNkkG3fzFEvXKdiSc4otMhxHz937hpNrcabz/gCCBeZIo9RlJmdgUIFO2uXUH
         6KiX2MgasccYB+YtclotIWtXUJFVHPI5NFBMD1xXQ2XDRb4PERm4DPGkJUJbJUaCXDNX
         pwFpubSLOtudr59FDxzg6EJGRu/XQzSpezPGN1ms6tnM+jRdBYWqX15Ceit4VZeYd3l1
         jwbXGuQn7ThU5lb5P2L07reR7QLQtTZuy/Z0dfI22xZQgx4/Cz46/CRUioqY9xQDBWy2
         FawQ==
X-Gm-Message-State: AO0yUKWeiiFoiLSAbmQkPHvbsdeL74nBuJyC/IaYBArtWRoBgyV+1XBA
        2ZfHsLaufxcXpOP7o0cIsTjMvDkOyoM=
X-Google-Smtp-Source: AK7set+WHIShpDoN90tRyWU34puoHV96nfreapvGl5sJ2PVigRFaT+jpGt1ejQWBhotqMu1iZ/EK0DJdR5k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b385:0:b0:541:8c77:93b1 with SMTP id
 r127-20020a81b385000000b005418c7793b1mr9986837ywh.8.1679327637581; Mon, 20
 Mar 2023 08:53:57 -0700 (PDT)
Date:   Mon, 20 Mar 2023 08:53:55 -0700
In-Reply-To: <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
Message-ID: <ZBiBkwIF4YHnphPp@google.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023, Anish Moorthy wrote:
> On Fri, Mar 17, 2023 at 2:50=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > I wonder if we can get away with returning -EFAULT, but still filling v=
cpu->run
> > with KVM_EXIT_MEMORY_FAULT and all the other metadata.  That would like=
ly simplify
> > the implementation greatly, and would let KVM fill vcpu->run unconditon=
ally.  KVM
> > would still need a capability to advertise support to userspace, but us=
erspace
> > wouldn't need to opt in.  I think this may have been my very original t=
hough, and
> > I just never actually wrote it down...
>=20
> Oh, good to know that's actually an option. I thought of that too, but
> assumed that returning a negative error code was a no-go for a proper
> vCPU exit. But if that's not true then I think it's the obvious
> solution because it precludes any uncaught behavior-change bugs.
>=20
> A couple of notes
> 1. Since we'll likely miss some -EFAULT returns, we'll need to make
> sure that the user can check for / doesn't see a stale
> kvm_run::memory_fault field when a missed -EFAULT makes it to
> userspace. It's a small and easy-to-fix detail, but I thought I'd
> point it out.

Ya, this is the main concern for me as well.  I'm not as confident that it'=
s
easy-to-fix/avoid though.

> 2. I don't think this would simplify the series that much, since we
> still need to find the call sites returning -EFAULT to userspace and
> populate memory_fault only in those spots to avoid populating it for
> -EFAULTs which don't make it to userspace.

Filling kvm_run::memory_fault even if KVM never exits to userspace is perfe=
ctly
ok.  It's not ideal, but it's ok.

> We *could* relax that condition and just document that memory_fault shoul=
d be
> ignored when KVM_RUN does not return -EFAULT... but I don't think that's =
a
> good solution from a coder/maintainer perspective.

You've got things backward.  memory_fault _must_ be ignored if KVM doesn't =
return
the associated "magic combo", where the magic value is either "0+KVM_EXIT_M=
EMORY_FAULT"
or "-EFAULT+KVM_EXIT_MEMORY_FAULT".

Filling kvm_run::memory_fault but not exiting to userspace is ok because us=
erspace
never sees the data, i.e. userspace is completely unaware.  This behavior i=
s not
ideal from a KVM perspective as allowing KVM to fill the kvm_run union with=
out
exiting to userspace can lead to other bugs, e.g. effective corruption of t=
he
kvm_run union, but at least from a uABI perspective, the behavior is accept=
able.

The reverse, userspace consuming kvm_run::memory_fault without being explic=
itly
told the data is valid, is not ok/safe.  KVM's contract is that fields cont=
ained
in kvm_run's big union are valid if and only if KVM returns '0' and the ass=
ociated
exit reason is set in kvm_run::exit_reason.

From an ABI perspective, I don't see anything fundamentally wrong with bend=
ing
that rule slightly by saying that kvm_run::memory_fault is valid if KVM ret=
urns
-EFAULT+KVM_EXIT_MEMORY_FAULT.  It won't break existing userspace that is u=
naware
of KVM_EXIT_MEMORY_FAULT, and userspace can precisely check for the combina=
tion.

My big concern with piggybacking -EFAULT is that userspace will be fed stal=
e if
KVM exits with -EFAULT in a patch that _doesn't_ fill kvm_run::memory_fault=
.
Returning a negative error code isn't hazardous in and of itself, e.g. KVM =
has
had bugs in the past where KVM returns '0' but doesn't fill kvm_run::exit_r=
eason.
The big danger is that KVM has existing paths that return -EFAULT, i.e. we =
can
introduce bugs simply by doing nothing, whereas returning '0' would largely=
 be
limited to new code.

The counter-argument is that propagating '0' correctly up the stack carries=
 its
own risk due to plenty of code correctly treating '0' as "success" and not =
"exit
to userspace".

And we can mitigate the risk of using -EFAULT.  E.g. fill in kvm_run::memor=
y_fault
even if we are 99.9999% confident the -EFAULT can't get out to userspace in=
 the
context of KVM_RUN, and set kvm_run::exit_reason to some arbitrary value at=
 the
start of KVM_RUN to prevent reusing memory_fault from a previous userspace =
exit.
