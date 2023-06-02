Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D4B720B29
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 23:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbjFBVsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 17:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjFBVsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 17:48:31 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB5A1A5
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 14:48:30 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-653c16b3093so348505b3a.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 14:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685742510; x=1688334510;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fp7NyrtPmHmWf/ayFOoFK2XGYuNbVvY6DFV6P0ELIy4=;
        b=061BC9XCKEZyYsbzPOwZu4wd4LEHNaSUsgcVmPcmPFL0KywceuBzu74FSPE/wzyBsE
         0EM+eOzKceakase8V4fkQrGVYgl/VIEw/aXVK8OlW6DzYwaRryI2PTvLgY4Cm1wc0ejW
         pvtbmXJqQuwU5tXOZO1fbvj0J05Oz0fJa93AeyOEOZa1dBx2YLjeBND6vgVk/EAJtvzH
         sTdeXHOM/Kpa2OCc4SDYQimhclDIoo8qBR+SmACB1hy6R6uxIweMhMedn/EgkQLZVVSn
         wg2EN3G0cPtFQO7VnQvYt9oXBgykmcrIzsUtd1BT3uly5guxIaiOLxWWMljcm2wTXvp7
         SZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685742510; x=1688334510;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Fp7NyrtPmHmWf/ayFOoFK2XGYuNbVvY6DFV6P0ELIy4=;
        b=MahH2bHKDMJXZB1gLUm0fuG6EkM2Zj5FMinhvV6Ig2KzHjeuQmbYOY7MKGQD0VyqvC
         5AH62aNdLAuOekhsPg6uwUWeNbJ6TBpjdGOnBr5QnZFT5Kjo6qFPoKvzFRAiRqty3mM7
         LD/AJFVJpJXOp2pke3jScd/PIkMKYHxOGJxE4hRBBwI2qhDq6H11LtiW27vd1PXPkQ6p
         XfcxVKLJUz3lUT9fqY//Zy99tRTzmolQ/Yoi9s5n0mHJ03nISoune6Fng2d2/0iJoOMM
         uYYjR00SJj5CrxTpdJRf4ZdgUq7Aiwvx9sHj5MPVnKZ+TUV9/7VVVuCfCoYQwYDWHjoE
         eNIQ==
X-Gm-Message-State: AC+VfDzra7UxDtUbszpz5uKunK/txTXxD48P3P2hqoKbwlrAlKMmVteE
        3e5LkaQxS2elCfDj5Ux5LsxW5QcmaDs=
X-Google-Smtp-Source: ACHHUZ6gieIz0ETeb9hF89zjosb9Ldv5tSCSz+UlPC86uns/CaEWZUUyH4LPWxxj5F4sWQo39chFDg+dfEc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:88c8:0:b0:643:536b:e764 with SMTP id
 k8-20020aa788c8000000b00643536be764mr4917278pff.4.1685742510240; Fri, 02 Jun
 2023 14:48:30 -0700 (PDT)
Date:   Fri, 2 Jun 2023 14:48:28 -0700
In-Reply-To: <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230602070224.92861-1-gaoshiyuan@baidu.com> <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com> <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
Message-ID: <ZHpjrOcT4r+Wj+2D@google.com>
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
> On Fri, Jun 2, 2023 at 12:16=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Jun 02, 2023, Jim Mattson wrote:
> > > On Fri, Jun 2, 2023 at 12:18=E2=80=AFAM Gao Shiyuan <gaoshiyuan@baidu=
.com> wrote:
> > > >
> > > > From: Shiyuan Gao <gaoshiyuan@baidu.com>
> > > >
> > > > When live-migrate VM on icelake microarchitecture, if the source
> > > > host kernel before commit 2e8cd7a3b828 ("kvm: x86: limit the maximu=
m
> > > > number of vPMU fixed counters to 3") and the dest host kernel after=
 this
> > > > commit, the migration will fail.
> > > >
> > > > The source VM's CPUID.0xA.edx[0..4]=3D4 that is reported by KVM and
> > > > the IA32_PERF_GLOBAL_CTRL MSR is 0xf000000ff. However the dest VM's
> > > > CPUID.0xA.edx[0..4]=3D3 and the IA32_PERF_GLOBAL_CTRL MSR is 0x7000=
000ff.
> > > > This inconsistency leads to migration failure.
> >
> > IMO, this is a userspace bug.  KVM provided userspace all the informati=
on it needed
> > to know that the target is incompatible (3 counters instead of 4), it's=
 userspace's
> > fault for not sanity checking that the target is compatible.
> >
> > I agree that KVM isn't blame free, but hacking KVM to cover up userspac=
e mistakes
> > everytime a feature appears or disappears across kernel versions or con=
figs isn't
> > maintainable.
>=20
> Um...
>=20
> "You may never migrate this VM to a newer kernel. Sucks to be you."

Userspace can fudge/fixup state to migrate the VM.

> That's not very user-friendly.

Heh, I never claimed it was. =20

I don't think KVM should treat this any differently than if userspace didn'=
t strip
a new feature when regurgitating KVM_GET_SUPPORTED_CPUID, and ended up with=
 VMs
that couldn't migrate to *older* kernels.

The only way this is KVM's responsibility is if KVM's ABI is defined such t=
hat
KVM_GET_SUPPORTED_CPUID is strictly "increasing" across kernel versions (on=
 the
same hardware).  I reall don't want to go down that route, as that would co=
mplicate
fixing KVM bugs, and would pull in things beyond KVM's control.  E.g. PCID =
support
is about to disappear on hardware affected by the recent INVLPG erratum (co=
mmit
ce0b15d11ad8 "x86/mm: Avoid incomplete Global INVLPG flushes").
