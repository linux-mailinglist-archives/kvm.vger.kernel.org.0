Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858BD69EC98
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 02:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjBVBzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 20:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjBVBzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 20:55:14 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88822822F
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 17:55:11 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a4eba107so71013167b3.19
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 17:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oH3wzgYYq/74BwrcfiZL5bA9g0o+Ffd7CJOhixtujEY=;
        b=KD0d27RcUKUIRPIlAofkm1rJ/RBs2KPWmGH2VR034IRUD+NvdjhbM/RYGwuzwd8aaC
         jByCraewDxz2QZEENcIppv9jJciGnb+vdFXnF35QVJ/O3nGHdbeVBZe37PcRp2iX+WE1
         gThQhIoYoRgWWB0hjdC/Fz1kUlkFyrcVXgBL1AZPVG52qnGZoM+JB5zyqHwzjGMhjVii
         Ij2xOEFpvowPbT9uwYsdcX73hBCw915wjjPLYYSUU6OcoMP6hJQNdoRJugaTp1FiQ2Dp
         gFvL+GWRQr/57ApovfGO6mua/Fc5DNGlnhz+OUHc3J8gtUp/MDoHcco6AWDKjRaQOKFU
         51eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oH3wzgYYq/74BwrcfiZL5bA9g0o+Ffd7CJOhixtujEY=;
        b=IeSFjIDyEnyQHZ4zJBQ1CF+4S5PANTriycvqRQHOSStS64PLqTLNUctvCL7sKnxT04
         xANjoth6wPNeC8cGSxM2Wz55dwgcgkBfkt92ZM7us43eKwoRUAMnlM5se0wbsk2dBezz
         KiLCJND4mST1EIdif9qx/zURqXrjPdamuQ4BJudIoBnRYK9RWHXbMbaE96cY5gD2+qq5
         yELqI65dDCLom/ju68OXcwZ+lbDJHHctdeE7ME/BOkAj8xQfk8C3iftwai4UEgOfFhVs
         CQb1SLOO380/4Xj0DMS2AawpNdhAQIjq5c860L784yGYzCAAbM7TPy+yeM3YPyVorqa1
         62UQ==
X-Gm-Message-State: AO0yUKWtEB+IOY6IB6YTcR15tF6h9Lz/gI7nZxQx8RAPJGx2TX4Qpcn9
        feil/aID/8qWeY6MXHPNRAUW9FGqsCk=
X-Google-Smtp-Source: AK7set/RE3d3HUCYKXQYj1/S4gC27BgatAEGR/mQlpeo99cXGbkEic36ZeqGSQDIpc8WgFlKodW9oPQ7ze8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10ca:b0:9ed:13e9:fe68 with SMTP id
 w10-20020a05690210ca00b009ed13e9fe68mr702832ybu.3.1677030911201; Tue, 21 Feb
 2023 17:55:11 -0800 (PST)
Date:   Tue, 21 Feb 2023 17:55:09 -0800
In-Reply-To: <460b341c-4720-bfb2-d1ef-1e42acf81974@gmail.com>
Mime-Version: 1.0
References: <20230217225449.811957-1-seanjc@google.com> <20230217225449.811957-3-seanjc@google.com>
 <460b341c-4720-bfb2-d1ef-1e42acf81974@gmail.com>
Message-ID: <Y/V1/Z15Ax3Igydb@google.com>
Subject: Re: [PATCH 2/2] Documentation/process: Add a maintainer handbook for
 KVM x86
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
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

On Mon, Feb 20, 2023, Like Xu wrote:
> On 18/2/2023 6:54 am, Sean Christopherson wrote:
> > Add a KVM x86 doc to the subsystem/maintainer handbook section to expla=
in
> > how KVM x86 (currently) operates as a sub-subsystem, and to soapbox on
> > the rules and expectations for contributing to KVM x86.
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   .../process/maintainer-handbooks.rst          |   1 +
> >   Documentation/process/maintainer-kvm-x86.rst  | 347 +++++++++++++++++=
+
> >   MAINTAINERS                                   |   1 +
> >   3 files changed, 349 insertions(+)
> >   create mode 100644 Documentation/process/maintainer-kvm-x86.rst
> >=20
> > diff --git a/Documentation/process/maintainer-handbooks.rst b/Documenta=
tion/process/maintainer-handbooks.rst
> > index d783060b4cc6..d12cbbe2b7df 100644
> > --- a/Documentation/process/maintainer-handbooks.rst
> > +++ b/Documentation/process/maintainer-handbooks.rst
> > @@ -17,3 +17,4 @@ Contents:
> >      maintainer-tip
> >      maintainer-netdev
> > +   maintainer-kvm-x86
> > diff --git a/Documentation/process/maintainer-kvm-x86.rst b/Documentati=
on/process/maintainer-kvm-x86.rst
> > new file mode 100644
> > index 000000000000..ac81a42a32a3
> > --- /dev/null
> > +++ b/Documentation/process/maintainer-kvm-x86.rst
> > @@ -0,0 +1,347 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +KVM x86
>=20
> KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)

My preference is "KVM x86", but I don't have a super strong opinion.  I def=
initely
don't think it's necessary to strictly match the MAINTAINERS file.

> > +Lifecycle
> > +~~~~~~~~~
> > +Pull requests for the next release cycle are sent to the main KVM tree=
, one
> > +for each KVM x86 topic branch.  If all goes well, the topic branches a=
re rolled
> > +into the main KVM pull request sent during Linus' merge window.  Pull =
requests
> > +for KVM x86 branches are typically made the week before Linus' opening=
 of the
> > +merge window, e.g. the week following rc7 for "normal" releases.
> > +
> > +The KVM x86 tree doesn't have its own official merge window, but there=
's a soft
> > +close around rc5 for new features, and a soft close around rc6 for fix=
es.
>=20
> Any urgent AND critical fixes are exempt. No?

More or less.  The majority of urgent and critical fixes should target the =
current
release, and the "soft" qualifier on "soft close" covers the rest.  Ah, but=
 this
section doesn't say anything about fixes that target mainline.  I'll add a =
paragraph
to explicitly talk about fixes.

> > +SDM and APM References
> > +~~~~~~~~~~~~~~~~~~~~~~
> > +Much of KVM's code base is directly tied to architectural behavior def=
ined in
> > +Intel's Software Development Manual (SDM) and AMD's Architecture Progr=
ammer=E2=80=99s
> > +Manual (APM).  Use of "Intel's SDM" and "AMD's APM", or even just "SDM=
" or
> > +"APM", without additional context is a-ok.
>=20
> ISE: Intel=C2=AE Architecture Instruction Set Extensions and Future Featu=
res
> PPR: Processor Programming Reference (PPR) for specific AMD Model

Hmm, I think we should explicitly spell those out in changelogs.  ISE relea=
ses
should _never_ be referenced in code, and I would prefer=20

> > +
> > +Do not reference specific sections, tables, figures, etc. by number, e=
specially
> > +not in comments.  Instead, copy-paste the relevant snippet (if warrant=
ed), and
> > +reference sections/tables/figures by name.  The layouts of the SDM and=
 APM are
> > +constantly changing, and so the numbers/labels aren't stable/consisten=
t.
> > +
> > +Generally speaking, do not copy-paste SDM or APM snippets into comment=
s.  With
> > +few exceptions, KVM *must* honor architectural behavior, therefore it'=
s implied
> > +that KVM behavior is emulating SDM and/or APM behavior.
>=20
> All undefined behaviors (if any) need to be clarified.
>=20
> > +
> > +Shortlog
> > +~~~~~~~~
> > +The preferred prefix format is ``KVM: <topic>:``, where ``<topic>`` is=
 one of::
> > +
> > +  - x86
> > +  - x86/mmu
> > +  - x86/pmu
> > +  - x86/xen
>=20
> Any conflict w/ "KVM X86 Xen (KVM/Xen)" ? Then "KVM X86 HYPER-V (KVM/hype=
r-v)" ?

I didn't follow this question.  Are you asking if we should have "KVM: x86/=
hyperv:"?
If so, my answer is "probably not".  The Hyper-V code isn't as isolated as =
the Xen
code and much of it is vendor specific, e.g. I would rather Hyper-V changes=
 that
primarily touch vmx.c be tagged "KVM: VMX" as it's possible, however unlike=
ly, that
non-Hyper-V users could be affected.=20
=20
> > +  - selftests > +  - SVM
> > +  - nSVM
> > +  - VMX
> > +  - nVMX
>=20
> emulator ? lapic ?

I don't want to introduce "emulator" as I don't think there will be a high =
enough
volume of patches to benefit from the extra qualifier, the emulator isn't a=
s isolated
as we like to think it is, and because KVM does a lot of emulation outside =
of the
emulator.  E.g. enter_smm() doesn't flow through emulate.c, but emulator_le=
ave_smm()
_only_ gets invoked via the emulator.

Similar to Hyper-V, I'm hesitant to introduce x86/apic as many "APIC" chang=
es are
actually in vendor specific code, e.g. much of APICv, AVIC, IPI virtualizat=
ion, etc.
I'm definitely not opposed to using x86/apic for local and and maybe even I=
/O APIC
changes though.

> > +**DO NOT use x86/kvm!**  ``x86/kvm`` is used exclusively for Linux-as-=
a-KVM-guest
> > +changes, i.e. for arch/x86/kernel/kvm.c.
> > +
> > +Note, these don't align with the topics branches (the topic branches c=
are much
> > +more about code conflicts).
> > +
> > +All names are case sensitive!  ``KVM: x86:`` is good, ``kvm: vmx:`` is=
 not.
> > +
> > +Capitalize the first word of the condensed patch description, but omit=
 ending
> > +punctionation.  E.g.::
>=20
> s/punctionation/punctuation
>=20
> > +
> > +    KVM: x86: Fix a null pointer dererence in function_xyz()
>=20
> s/dererence/dereference

Heh, at least I'm consistent.

> > +    kvm: x86: fix a null pointer dererence in function_xyz.
> > +
> > +If a patch touches multiple topics, traverse up the conceptual tree to=
 find the
> > +first common parent (which is often simply ``x86``).  When in doubt,
> > +``git log path/to/file`` should provide a reasonable hint.
> > +
> > +New topics do occasionally pop up, but please start an on-list discuss=
ion if
> > +you want to propose introducing a new topic, i.e. don't go rogue.
> > +
> > +Do not use file names or complete file paths as the subject/shortlog p=
refix.
> > +
> > +Changelog
> > +~~~~~~~~~
> > +Write changelogs using imperative mood and avoid pronouns.  Lead with =
a short
> > +blurb on what is changing, and then follow up with the context and bac=
kground.
> > +Note!  This order directly conflicts with the tip tree's preferred app=
roach!
>=20
> Emm, could this be considered/clarified as an incentive option ?

Can you elaborate?  I don't understand what you're asking.

> > +Testing
> > +-------
> > +At a bare minimum, *all* patches in a series must build cleanly for KV=
M_INTEL=3Dm
> > +KVM_AMD=3Dm, and KVM_WERROR=3Dy.  Building every possible combination =
of Kconfigs
> > +isn't feasible, but the more the merrier.  KVM_SMM, KVM_XEN, PROVE_LOC=
KING, and
> > +X86_64 are particularly interesting knobs to turn.
> > +
> > +Running KVM selftests and KVM-unit-tests is also mandatory (and statin=
g the
> > +obvious, the tests need to pass).  When possible and relevant, testing=
 on both
> > +Intel and AMD is strongly preferred.  Booting an actual VM is encourag=
ed, but
> > +not mandatory.
>=20
> Testing L2 guest available features inside L1 is also encouraged.

Hmm.  Sort of.  In a perfect world where everyone has unlimited time, then =
testing
a inside a nested VM would be encouraged.  But practically speaking, doing =
basic
testing of a feature in a nested VM doesn't buy all that much meaningful co=
verage,
and can even give a false sense of security.

The things we tend to get wrong are the edge cases, error handling, etc., a=
nd those
are unlikely to be excercised by basic testing, i.e. really need dedicated =
tests.
And if we have dedicated tests, then nested is covered by "Running selftest=
s and KUT
are mandatory".

At least for official documentation, I think I would prefer not to explicit=
ly
encourage people to use their time booting and testing in nested VMs.

> > +For changes that touch KVM's shadow paging code, running with TDP (EPT=
/NPT)
> > +disabled is mandatory.  For changes that affect common KVM MMU code, r=
unning
> > +with TDP disabled is strongly encouraged.  For all other changes, if t=
he code
> > +being modified depends on and/or interacts with a module param, testin=
g with
> > +the relevant settings is mandatory.
> > +
> > +Note, KVM selftests and KVM-unit-tests do have known failures.  If you=
 suspect
> > +a failure is not due to your changes, verify that the *exact same* fai=
lure
> > +occurs with and without your changes.
> > +
> > +If you can't fully test a change, e.g. due to lack of hardware, clearl=
y state
> > +what level of testing you were able to do, e.g. in the cover letter.
>=20
> Add an RFT (request for test) tag.

I'm not necessarily opposed to the idea of "RFT", but until it's a ubiquito=
us
and/or formally documented tag I would prefer to avoid using RFT KVM x86.

For the overwhelming majority of changes where "I couldn't test this" is le=
gitimate
_and_ the series/patch isn't tagged RFC, I have access to the necessary har=
dware.
For the few cases where I don't have hardware, I don't mind hunting down so=
meone
who does.  I.e. blasting "RFT to everyone isn't necessary.

In other words, I think we'll spend more time explaining and trying to unde=
rstand
the use of RFT than we would benefit from using it to identify when a serie=
s needs
extra testing.

> > +New Features
> > +~~~~~~~~~~~~
> > +With one exception, new features *must* come with test coverage.  KVM =
specific
> > +tests aren't strictly required, e.g. if coverage is provided by runnin=
g a
> > +sufficiently enabled guest VM, or by running a related kernel selftest=
 in a VM,
> > +but dedicated KVM tests are preferred in all cases.  Negative testcase=
s in
> > +particular are mandatory for enabling of new hardware features as erro=
r and
> > +exception flows are rarely exercised simply by running a VM.
> > +
> > +The only exception to this rule is if KVM is simply advertising suppor=
t for a
> > +feature via KVM_SET_SUPPORTED_CPUID, i.e. for instructions/features th=
at KVM
> > +can't prevent a guest from using and for which there is no true enabli=
ng.
> > +
> > +Note, "new features" does not just mean "new hardware features"!  New =
features
> > +that can't be well validated using existing KVM selftests and/or KVM-u=
nit-tests
> > +must come with tests.
>=20
> must come with tests to ensure good code coverage.

I _really_ don't want to add that qualifier.  Code coverage is but one aspe=
ct of
testing, and it's not even #1 priority, e.g. exercising code that violates =
architectural
behavior means nothing if the test doesn't detect the error.  I.e. the purp=
ose of
tests isn't _just_ to ensure good code coverage.

> > +Posting new feature development without tests to get early feedback is=
 more
> > +than welcome, but such submissions should be tagged RFC, and the cover=
 letter
> > +should clearly state what type of feedback is requested/expected.  Do =
not abuse
> > +the RFC process; RFCs will typically not receive in-depth review.
> > +
> > +Bug Fixes
> > +~~~~~~~~~
> > +Except for "obvious" found-by-inspection bugs, fixes must be accompani=
ed by a
> > +reproducer for the bug being fixed.  In many cases the reproducer is i=
mplicit,
> > +e.g. for build errors and test failures, but it should still be clear =
to
> > +readers what is broken and how to verify the fix.  Some leeway is give=
n for
> > +bugs that are found via non-public workloads/tests, but providing regr=
ession
> > +tests for such bugs is strongly preferred.
>=20
> tests or detailed reproduction sequence for such bugs is strongly preferr=
ed.

No, just tests.  This is specifically talking about non-public workloads.  =
If a
detailed reproduction sequence _doesn't_ involve writing code, i.e. a test,=
 then
the fix should simply provider the reproducer.

If you're talking about the sequence of events in KVM that result in the bu=
g,
then that info belongs in the changelog and is largely covered by the tip t=
ree
handbook.

> > +Git Base
> > +~~~~~~~~
> > +If you are using git version 2.9.0 or later (Googlers, this is all of =
you!),
>=20
> Please do not mention specific developers or groups in this type of docum=
ent.

Honest question, why not?

Calling out a specific developer is one thing, but I don't see the harm in =
adding
what essentially amounts to an extra requirement for Google employees.

> > +use ``git format-patch`` with the ``--base`` flag to automatically inc=
lude the
> > +base tree information in the generated patches.
> > +
> > +Note, ``--base=3Dauto`` works as expected if and only if a branch's up=
stream is
> > +set to the base topic branch, e.g. it will do the wrong thing if your =
upstream
> > +is set to your personal repository for backup purposes.  An alternativ=
e "auto"
> > +solution is to derive the names of your development branches based on =
their
> > +KVM x86 topic, and feed that into ``--base``.  E.g. ``x86/pmu/my_branc=
h_name``,
> > +and then write a small wrapper to extract ``pmu`` from the current bra=
nch name
> > +to yield ``--base=3Dx/pmu``, where ``x`` is whatever name your reposit=
ory uses to
> > +track the KVM x86 remote.
> > +
> > +Co-Posting Tests
> > +~~~~~~~~~~~~~~~~
> > +KVM selftests that are associated with KVM changes, e.g. regression te=
sts for
> > +bug fixes, should be posted along with the KVM changes as a single ser=
ies.
>=20
> Keeping git-bisect is mandatory.

Ah, yeah, I'll explicitly call out the order between tests and KVM.

> > +Vulnerabilities
> > +---------------
> > +Bugs that can be exploited by the guest to attack the host (kernel or
> > +userspace), or that can be exploited by a nested VM to *its* host (L2 =
attacking
> > +L1), are of particular interest to KVM.  Please follow the protocol fo=
r
>=20
> L1, even L0 host),

No, because at that point it's just the guest attacking the host.  This sni=
ppet
is purely translating "nested VM to *its* host* into familiar terminology.
