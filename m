Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498317209A4
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 21:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbjFBTQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 15:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbjFBTQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 15:16:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439B11B8
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 12:16:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-565d1b86a63so34078277b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 12:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685733398; x=1688325398;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BoQUTXfxaRB/p76ihuT9Z9G5PHcxctvDQtFSRdoU+Vs=;
        b=TiLkimaj9WcWWsidILIo0oIa69xBLeso+wo4STF0I3rssxKp9hIbuCqwM7BHJ4fd5b
         TAfYJsWr0mQeKdRpqRiYGTHWvP8OekSXcUQPGpyvo7bWceEOquzCTbCyJw9AWStmLdLm
         qLHWfOl8hVlkD7vwJ8BZdzSLsY30D/kkQDDRoSUjkpkONEDU1v3+QZt6Yp9LfBkcIFEG
         Dk4Pje7DKyppuyBSiG0QulCMII404UiTWL1x8jWRDQ1EBFBn4uXhpeQgOiXOTLTHqcwL
         1uTsXIjuw2qlZJnaLk7fAnnCcEDO+wKvpFg1GFloiBx8UaBQukUjGxaBKZ8106EjMKJw
         AExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685733398; x=1688325398;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BoQUTXfxaRB/p76ihuT9Z9G5PHcxctvDQtFSRdoU+Vs=;
        b=brAFWDfaoiA70mbydMcAt2cpwWI4CqPa6j+5m/f50vI1Y8mrWnyHANiOEbM3syu5I+
         IyLnJ4j34rzfZ3nCE+soLodAQbivXj6XPNe5PSl/H0Rn8eT+XGugjgobLsIiH8mKXj+d
         k1kOsGSczRAhSUJmVDDXDPPJzKSX4O+gPuDGTX/KleIbP4DPhalaKrGyB9XfqlEpmfRh
         C5p+yeS9tl3Y66Kocnn1kYRlo61BEvMt75RCIC2xOD1/3c1ENrImxgdSC/5YaEjeCvQ5
         J9+KJ93SFGrQpet0bY/oKeA7dQ1y1Z1xuxFEygzDa//+leWOUAD1NA4w2hKFpQi3+JYy
         wRbw==
X-Gm-Message-State: AC+VfDzlE+8QEd5TeqCzfm5MVc85WYlcJNXVfP8gAIhXrhDynSPIUMHC
        8kI+sA69BKRPaMZ42YnZ5R6x+b9rQq8=
X-Google-Smtp-Source: ACHHUZ40kj5g+hwiL+3/ACRy/jdYmSnEqGkXjxKyMfYZXLligK/pTeOtCJPEp7AU2A7VTE9dQP3jX75tE3Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102f:b0:bb1:3606:6a29 with SMTP id
 x15-20020a056902102f00b00bb136066a29mr1535874ybt.3.1685733398568; Fri, 02 Jun
 2023 12:16:38 -0700 (PDT)
Date:   Fri, 2 Jun 2023 12:16:36 -0700
In-Reply-To: <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
Mime-Version: 1.0
References: <20230602070224.92861-1-gaoshiyuan@baidu.com> <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
Message-ID: <ZHpAFOw/RW/ZRpi2@google.com>
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
> On Fri, Jun 2, 2023 at 12:18=E2=80=AFAM Gao Shiyuan <gaoshiyuan@baidu.com=
> wrote:
> >
> > From: Shiyuan Gao <gaoshiyuan@baidu.com>
> >
> > When live-migrate VM on icelake microarchitecture, if the source
> > host kernel before commit 2e8cd7a3b828 ("kvm: x86: limit the maximum
> > number of vPMU fixed counters to 3") and the dest host kernel after thi=
s
> > commit, the migration will fail.
> >
> > The source VM's CPUID.0xA.edx[0..4]=3D4 that is reported by KVM and
> > the IA32_PERF_GLOBAL_CTRL MSR is 0xf000000ff. However the dest VM's
> > CPUID.0xA.edx[0..4]=3D3 and the IA32_PERF_GLOBAL_CTRL MSR is 0x7000000f=
f.
> > This inconsistency leads to migration failure.

IMO, this is a userspace bug.  KVM provided userspace all the information i=
t needed
to know that the target is incompatible (3 counters instead of 4), it's use=
rspace's
fault for not sanity checking that the target is compatible.

I agree that KVM isn't blame free, but hacking KVM to cover up userspace mi=
stakes
everytime a feature appears or disappears across kernel versions or configs=
 isn't
maintainable.

> > The QEMU limits the maximum number of vPMU fixed counters to 3, so igno=
re
> > the check of IA32_PERF_GLOBAL_CTRL bit35.

Unconditionally allowing the bit is unsafe, e.g. will cause KVM to miss con=
sistency
checks on PERF_GLOBAL_CTRL when emulating nested VM-Enter.  They should eve=
ntually
be caught by hardware, but it's still undesirable.

> Today, the fixed counters are limited to 3, but I hope we get support
> for top down slots soon.

Is there any reason KVM can't simply add support for the fourth fixed count=
er?
Perf is already aware of the topdown slots event, so isn't this "just" a ma=
tter
of adding the appropriate entries?

> Perhaps this inconsistency is best addressed with a quirk?

*If* we ended up adding a hack to KVM, I'd prefer not to add a quirk, this =
shouldn't
be something KVM needs to carry long term.
