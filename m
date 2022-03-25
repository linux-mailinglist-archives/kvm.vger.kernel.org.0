Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63904E6D8C
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 06:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358331AbiCYFRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 01:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbiCYFRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 01:17:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A3C53B48
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 22:15:58 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gb19so6600068pjb.1
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 22:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DSGIykvCtT+9uKWZ2s9GWRC6JuauRYmkEarpf9JYC7k=;
        b=rL20PxHwBobs31YUcTdFtYcC++iBt78ge8AP86lUAaAefsu1H310EFR46fdNh6Yyd2
         RKT9uxO+Wrzad7JytjbCjwWFcAlfaC2ME60oQmfeN0vC9+OECRDNheGNXA04jfOjfxYE
         +2slN9emseCg3ndu/OHMR95SXzaCj4Jh3tYp0OAYGLHFIyxqaIFbIdiOImM+f8ugNKDu
         e92uT7xNQg+KW6XuAYpFutP1hTpDzODUyymrfrJXIFkMt3DPR51d8Co3H6OZyahSn03F
         WQdRpNhSNWqTlZ7J0XmBOLG8ZwiFn3l0ApYb7BvU2YUuY7Grdu49XjoQ64jN42FmZ0+L
         NVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DSGIykvCtT+9uKWZ2s9GWRC6JuauRYmkEarpf9JYC7k=;
        b=L5Ym2OtFma66mLZ0oykc0wIRnYHax8IJGupapcOdM/51ixgE5pAOWu4W7/5McYkQdw
         HXR8lITrxW+i9xQUlcsyKwbB3m2BlXS4HgjO1mQc38TirUTSkXzOAivt14N8SWaHIiir
         2OhVr3Nbr6UW2TREfSQFwONqFCSJBb8HftusFh3UiUsdI3JrzpNUhB+tNvUiaNBaSteb
         PM88Y7w/4gi4sSwB7P1BwtqVrRESwaenSoEc8kbPWyRz6aOnHD0muwwZd2VJdsh3PuWZ
         LLJ5D3XlHWWwiavd1vtVCZMV/0Nvvx3y1AKnRKMP6eUpgHcyr/20p93T1rerlDxq/QdG
         H1mA==
X-Gm-Message-State: AOAM533g+lqK70L1WQyI5R6VZvXY4RxghmogyPrr1OlCsEUDUC23mfiX
        ctVqtZLOLoq5ku8M24x+WaAjwJolhaMNAfPbubhJyA==
X-Google-Smtp-Source: ABdhPJytkSR7D+etNJgrnIuPGEqORduvtiLBGN8L4lmkT6LJ/cGe8oc/8Nik674WjC3l7m+p6t3OzaO7KJa9gLpW58A=
X-Received: by 2002:a17:90b:314d:b0:1c7:b159:28b5 with SMTP id
 ip13-20020a17090b314d00b001c7b15928b5mr9447980pjb.110.1648185357326; Thu, 24
 Mar 2022 22:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com> <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com> <CAAeT=FwkXSpwtCOrggwg=V72TYCRb24rqHYVUGd+gTEA-jN66w@mail.gmail.com>
 <Yjz4SZbqS+3aD5YO@google.com>
In-Reply-To: <Yjz4SZbqS+3aD5YO@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 24 Mar 2022 22:15:41 -0700
Message-ID: <CAAeT=FxbXELzn4gTjdqwO9hwNMJN69BTWntNyNXHCjFTW=t25g@mail.gmail.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to id_reg_desc_table
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 4:01 PM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Mar 24, 2022 at 01:23:42PM -0700, Reiji Watanabe wrote:
> > Hi Oliver,
> >
> > On Wed, Mar 23, 2022 at 12:53 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Hi Reiji,
> > >
> > > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > > Add hidden or reserved ID registers, and remaining ID registers,
> > > > which don't require special handling, to id_reg_desc_table.
> > > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > > or reserved registers. Since now id_reg_desc_init() is called even
> > > > for hidden/reserved registers, change it to not do anything for them.
> > > >
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > >
> > > I think there is a very important detail of the series that probably
> > > should be highlighted. We are only allowing AArch64 feature registers to
> > > be configurable, right? AArch32 feature registers remain visible with
> > > their default values passed through to the guest. If you've already
> > > stated this as a precondition elsewhere then my apologies for the noise.
> > >
> > > I don't know if adding support for this to AArch32 registers is
> > > necessarily the right step forward, either. 32 bit support is working
> > > just fine and IMO its OK to limit new KVM features to AArch64-only so
> > > long as it doesn't break 32 bit support. Marc of course is the authority
> > > on that, though :-)
> > >
> > > If for any reason a guest uses a feature present in the AArch32 feature
> > > register but hidden from the AArch64 register, we could be in a
> > > particularly difficult position. Especially if we enabled traps based on
> > > the AArch64 value and UNDEF the guest.
> > >
> > > One hack we could do is skip trap configuration if AArch32 is visible at
> > > either EL1 or EL0, but that may not be the most elegant solution.
> > > Otherwise, if we are AArch64-only at every EL then the definition of the
> > > AArch32 feature registers is architecturally UNKNOWN, so we can dodge
> > > the problem altogether. What are your thoughts?
> >
> > Thank you so much for your review, Oliver!
> >
> > For aarch32 guests (when KVM_ARM_VCPU_EL1_32BIT is configured),
> > yes, the current series is problematic as you mentioned...
> > I am thinking of disallowing configuring ID registers (keep ID
> > registers immutable) for the aarch32 guests for now at least.
> > (will document that)
>
> That fixes it halfway, but the AArch64 views of the AArch32 feature
> registers have meaning even if AArch32 is defined at EL0. The only time
> they are architecturally UNKNOWN is if AArch32 is not implemented at any
> EL visible to the guest.
>
> So, given that:
>
> > For aarch64 guests that support EL0 aarch32, it would generally
> > be a userspace bug if userspace sets inconsistent values in 32bit
> > and 64bit ID registers. KVM doesn't provide a complete consistency
> > checking for ID registers, but this could be added later as needed.
>
> I completely agree that there is a large set of things that can be swept
> under the rug of userspace bugs. If we are going to do that, we need to
> strongly assert that configurable feature registers is only for fully
> AArch64-only guests. Additionally, strong documentation around these
> expectations is required.

Just to be clear, what I meant "this could be added later" is that
the feature consistency checking between 64bit ID registers and 32bit ID
registers could be added later.  It means configuring ID registers
itself will be allowed for EL1 aarch64 guests including ones that
support EL0 aarch32 (but not for EL1 aarch32 guests).

> Mind you, these opinions are my own and IDK how others or Marc feel
> about it. My read of the situation w.r.t. the AArch32 registers is that
> it will become a mess to implement on top of the AArch64 registers.
> Given the fact that we aren't breaking AArch32 VMs, only augmenting
> behavior for AArch64, it seems OK.

Thank you for sharing your thoughts.
They look almost the same as what I've been thinking.

Thanks,
Reiji


> But I would genuinely love to be wrong on this topic too. I just don't
> have perspective on AArch32 users so it is hard to really say whether
> this is something they need as well.
