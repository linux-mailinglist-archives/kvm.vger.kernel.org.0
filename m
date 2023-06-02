Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F178B720C11
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 00:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbjFBWwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 18:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbjFBWwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 18:52:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34874A3
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 15:52:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56938733c13so25444497b3.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 15:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685746337; x=1688338337;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NHNI2dbVzsnogrDisHjzABTLVyTKvvyUqRs2YOkI3Tg=;
        b=UKa/JxEo/B+qHHNn7+d+XGnjAvyRo7qT2Qur5Al5a+VVfdTSI5lT+eqSYKMSYXaB/V
         6SdkE4zlKLpOUTW+RS0h92GxoIkZqwzCFGKErzvEamxddN5QChdkV4J0yUWn8mXg5lTp
         3rtg51e2yQB2vMXTTxumr52COEfxcRC/vYWJyHUx92fE+W8hpNqkE8LxAf11xoD8U6qR
         Eg0SmiSp9sF3cs81j1L1sdBwWQwzA8mYWQ9HTmV0er/sdE5DN8GQ/iAWd+aC9b8H9N0f
         q2dudYcGF/KM/7d86P4UiGMYG+6mUpgJJw2gIedU0GEn/lE/3NaQmxk0mIIuJrGGo4Dq
         vofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685746337; x=1688338337;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NHNI2dbVzsnogrDisHjzABTLVyTKvvyUqRs2YOkI3Tg=;
        b=bpv6Poit1HdX52dh3iuLn4f0uMYQMq81/y3kJrHiTd3T8TPkiNW+81/K4DX8xVujpk
         vfOJURZmNDG5DeEwdmHvasziiN3WzqAKioiTBvjhdqVxOJaaaD6ZVF7lMMEVzDxDB9tx
         f0HDUKPQPO6nE4oNGn04IZi/cfdw9frsnOZUG6sYVvkRG/+xnTa5oBj0evIzl9GUHZVJ
         /PA2GOBdOFpYFAXkdpibiZL0x64jpTO5fL8smU5sVEZw5mJNsr5skpr+ST/OSP55Ssx8
         Tjuv6xEyn8yW1N9pMTlAdnkO2E1go4fFjuqre8UQmK2DrkcUcJ6BzdmLHk1aVMfo6VvS
         LtYw==
X-Gm-Message-State: AC+VfDw0WLyQJeGt4JJTrSCrm9G27GKv4QP4LnLhD7Z9KMYlynSARy15
        JcSPSR0QB3vNc1DOsU4W65A5WWLS5oY=
X-Google-Smtp-Source: ACHHUZ4I7O5OIYcQjla3oXTeonmO70IFk3NDj8wuZDE9GMMwWmag7aaMEoDnuLYWW1VMLQiWcmaQLU8YvAA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e20a:0:b0:54f:a35e:e79a with SMTP id
 p10-20020a81e20a000000b0054fa35ee79amr626004ywl.8.1685746337499; Fri, 02 Jun
 2023 15:52:17 -0700 (PDT)
Date:   Fri, 2 Jun 2023 15:52:15 -0700
In-Reply-To: <CALMp9eRLhNu-x24acfHvySf6K1EOFW_+rAqeLJ6bBbLp3kCc=Q@mail.gmail.com>
Mime-Version: 1.0
References: <20230602070224.92861-1-gaoshiyuan@baidu.com> <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com> <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
 <ZHpjrOcT4r+Wj+2D@google.com> <CALMp9eRLhNu-x24acfHvySf6K1EOFW_+rAqeLJ6bBbLp3kCc=Q@mail.gmail.com>
Message-ID: <ZHpyn7GqM0O0QkwO@google.com>
Subject: Re: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL bit35
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Gao Shiyuan <gaoshiyuan@baidu.com>, pbonzini@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, likexu@tencent.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023, Jim Mattson wrote:
> On Fri, Jun 2, 2023 at 2:48=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Fri, Jun 02, 2023, Jim Mattson wrote:
> > > On Fri, Jun 2, 2023 at 12:16=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Fri, Jun 02, 2023, Jim Mattson wrote:
> > > > > On Fri, Jun 2, 2023 at 12:18=E2=80=AFAM Gao Shiyuan <gaoshiyuan@b=
aidu.com> wrote:
> > > > > >
> > > > > > From: Shiyuan Gao <gaoshiyuan@baidu.com>
> > > > > >
> > > > > > When live-migrate VM on icelake microarchitecture, if the sourc=
e
> > > > > > host kernel before commit 2e8cd7a3b828 ("kvm: x86: limit the ma=
ximum
> > > > > > number of vPMU fixed counters to 3") and the dest host kernel a=
fter this
> > > > > > commit, the migration will fail.
> > > > > >
> > > > > > The source VM's CPUID.0xA.edx[0..4]=3D4 that is reported by KVM=
 and
> > > > > > the IA32_PERF_GLOBAL_CTRL MSR is 0xf000000ff. However the dest =
VM's
> > > > > > CPUID.0xA.edx[0..4]=3D3 and the IA32_PERF_GLOBAL_CTRL MSR is 0x=
7000000ff.
> > > > > > This inconsistency leads to migration failure.
> > > >
> > > > IMO, this is a userspace bug.  KVM provided userspace all the infor=
mation it needed
> > > > to know that the target is incompatible (3 counters instead of 4), =
it's userspace's
> > > > fault for not sanity checking that the target is compatible.
> > > >
> > > > I agree that KVM isn't blame free, but hacking KVM to cover up user=
space mistakes
> > > > everytime a feature appears or disappears across kernel versions or=
 configs isn't
> > > > maintainable.
> > >
> > > Um...
> > >
> > > "You may never migrate this VM to a newer kernel. Sucks to be you."
> >
> > Userspace can fudge/fixup state to migrate the VM.
>=20
> Um, yeah. Userspace can clear bit 35 from the saved
> IA32_PERF_GLOBAL_CTRL MSR so that the migration will complete. But
> what happens the next time the guest tries to set bit 35 in
> IA32_PERF_GLOBAL_CTRL, which it will probably do, since it cached
> CPUID.0AH at boot?

Ah, right.  Yeah, guest is hosed.

I'm still not convinced this is KVM's problem to fix.
