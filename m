Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A219C77C4C0
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 02:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbjHOAxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 20:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbjHOAxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 20:53:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF81819A8
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:52:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d672f55d48dso4159863276.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692060752; x=1692665552;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hk15mUEG36mYzoWqdyXNILxXbUGFuZdN5ezEkvLZ3iM=;
        b=SUKnvazqj9CVjAezsoD2+y+B/lascXFbPfh2BmPWUTPhsp2ltMrajsTckozDu9ifdm
         uRoTdnCgOM98B7Rnb91Ve9c/MBRF5IHK3nGacQ54NRHNp4jfWACljRlSNeWuoRdL+3na
         CtHqlJoC59YHPayYcYzVEhCEfMbZsPVJQIkTDsx0J6ehfskI+bg3C/TTqGB4GfV7K9Vn
         rRDM2yi+re6usECld7Z4U2WK/2ghsl54KPV4Ycl6v1kRxR+u2a297eNSVYm3jPrYQCL2
         cXFmXO9Zt4S3exCCMfQ/QP9nNjQaIR5tBPHnG0PDbMprpJdiffEDLgQQkSHFXTPIaHgD
         6rOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692060752; x=1692665552;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hk15mUEG36mYzoWqdyXNILxXbUGFuZdN5ezEkvLZ3iM=;
        b=gArRyDlgETqCw4m/5rSCMFq2wn9OLYQdCN92+yv0I9mKAteK66IyXvxTDOtvLRI17Z
         vr3Ho4xLcYRpVL5AatHlypkWfGlLwVBcr5/LFQSP2wUbMdQ+UyRiDss3ZjyXaa418nFU
         3nIYOT2tqwL1NwIRbrMGZ3lqysiMznEjXKciCyRi3214ZRcBoBBQTZazPnfGgDaQ1+hX
         AYWv9cNl5rgKgmRUa5/9e3ynp9aro2/wKXqeBBRIsdpErQ3cTRbLV2hZz7UsHs4VdTe9
         JEBMfkVGyJeDYYB5njW4wtH90F4h6IdBi9LMKw7LObxX3LO17c4CT3K7tzn1YfX4ldE4
         QQug==
X-Gm-Message-State: AOJu0Yyfa3sMH162cERi97ufttqU2tjrQdujsjE0DgJCdqYaGWbmSPO+
        ptUrRRSfBAZ4URoEFpbhBoeZSEN7AZA=
X-Google-Smtp-Source: AGHT+IEm/gyjzby2m0z7Th7h1NzS+zVz9W6iAdmwDKQNzO5UYu/Tw93ovcYoaLNJ0fJilJkbmSYm3tW9J7c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7443:0:b0:d20:7752:e384 with SMTP id
 p64-20020a257443000000b00d207752e384mr148317ybc.3.1692060751838; Mon, 14 Aug
 2023 17:52:31 -0700 (PDT)
Date:   Mon, 14 Aug 2023 17:52:30 -0700
In-Reply-To: <CAJHc60wMueazp3Wm=b6-tnFPAyX0zeYuVQe9uPEJrpAm0azw2A@mail.gmail.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <ZNq15SZ+53umvOfx@google.com>
 <CAJHc60wMueazp3Wm=b6-tnFPAyX0zeYuVQe9uPEJrpAm0azw2A@mail.gmail.com>
Message-ID: <ZNrMTmppUfQhdsyY@google.com>
Subject: Re: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023, Raghavendra Rao Ananta wrote:
> On Mon, Aug 14, 2023 at 4:16=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> > > The series is based off of upstream v6.5-rc1.
> >
> > Lies!  :-)
> >
> > This is based off one of the kvmarm.git topic branches (I didn't bother=
 to figure
> > out which one), not v6.5-rc1.
> >
> Sorry, what am I missing here? My git log is as follows:

Hmm, not sure what's going on.  Maybe I misinterpreted why `git am` was fai=
ling?
I assumed it was because there were objects in kvmarm that I didn't have lo=
cally,
and fetching kvmarm allowed am to complete, though with 3-way merges, which=
 IIUC
shouldn't have been necessary if I was using the exact same base.  Or maybe=
 I
messed up and didn't actually reset to 6.5-rc1.

> $ git log --oneline upstream_tlbi_range_v9
> 5025857507abe (upstream_tlbi_range_v9) KVM: arm64: Use TLBI
> range-based instructions for unmap
> 5c0291b99a8fc KVM: arm64: Invalidate the table entries upon a range
> 8c46b54d4aaec KVM: arm64: Flush only the memslot after write-protect
> 231abaeb7ffc2 KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
> 5ec291b863309 KVM: arm64: Define kvm_tlb_flush_vmid_range()
> 5bcd7a085c34e KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
> ea08f9dff7e5b arm64: tlb: Implement __flush_s2_tlb_range_op()
> b3178687947c9 arm64: tlb: Refactor the core flush algorithm of __flush_tl=
b_range
> a4850fa988eef KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common co=
de
> 306dc4e6afd37 KVM: Allow range-based TLB invalidation from common code
> d02785a0a1e01 KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
> 136fa2d254537 KVM: arm64: Use kvm_arch_flush_remote_tlbs()
> e35c68a75170d KVM: Declare kvm_arch_flush_remote_tlbs() globally
> 5d592777b9bba KVM: Rename kvm_arch_flush_remote_tlb() to
> kvm_arch_flush_remote_tlbs()
> 06c2afb862f9d (tag: v6.5-rc1, tag: linux/v6.5-rc1) Linux 6.5-rc1
> c192ac7357683 MAINTAINERS 2: Electric Boogaloo
> f71f64210d698 Merge tag 'dma-mapping-6.5-2023-07-09' of
> git://git.infradead.org/users/hch/dma-mapping
> ...
>=20
> Isn't the commit, 06c2afb862f9d (06c2afb862f9d (tag: v6.5-rc1, tag:
> linux/v6.5-rc1) Linux 6.5-rc1) the 'base' commit?

Ya, should be.

Either way, even if this is PEBKAC on my end, using --base would be nice, e=
.g.
then you can definitely say it's my fault ;-)

> > Please try to incorporate git format-patch's "--base" option into your =
workflow,
> > e.g. I do "git format-patch --base=3DHEAD~$nr" where $nr is the number =
of patches
> > I am posting.
> >
> > It's not foolproof, e.g. my approach doesn't help if I have a local pat=
ch that
> > I'm not posting, but 99% of the time it Just Works and eliminates any a=
mbuitity.
> >
> > You can also do "--base=3Dauto", but that only does the right thing if =
your series
> > has its upstream branch set to the base/tree that you want your patches=
 applied
> > to (I use the upstream branch for a completely different purpose for my=
 dev branches).
