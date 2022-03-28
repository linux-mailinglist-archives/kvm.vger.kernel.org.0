Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F04E8B29
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 02:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbiC1AG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 20:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiC1AG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 20:06:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C607C12AB1
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 17:05:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q19so10949417pgm.6
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 17:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GYMVP9OcKppCPlsPpjFdXuvj9GQOHfrmZVMxuBWQMzk=;
        b=UOxWHJfBVxArY0VLUCwJyQc28fwR60rMZ4S+d0rgbgXS8D5RnDbQxQifCxLtrWaUZL
         LPsY+nIUBjj1pwA4aT1IfEo0kpUTAV71v6UD7tyqMfI2mdSP430LpN0Mdg8q1MmjLXZm
         PT9iJZ97vc3dSx+sPU4oiMZM9puvMkPNisQlEXPIdWT/Md56HM/GMkWSgrodvzVABY4P
         //zREGepFUdm6gc8H7E/4hy3AALqUb0ODCSwTDuSI4nxpOhtbh1ZvqoFmXc57z1/yHSr
         Izsg88jeaspt87mMJHfYs6PgQHuC2XcH4Iq/6/CN47YfXCteVZW5jFi3zzeS1TfjiUwh
         58Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GYMVP9OcKppCPlsPpjFdXuvj9GQOHfrmZVMxuBWQMzk=;
        b=cRG6wWsjAErPUPdFioEjPSeky5hkdq541kD/w5LipP59Nq0TG5uxV+hQSQvygr0l9u
         LnuKTq2pvd1MBk6GhbvqKL6Ru57tUSpqPkAcl53kW9byEWesjX7nMyBmke3SDnFOO4Rw
         eEC2f9L4pbayWRwHUeJjuHJB8ozu/AfzFMYfYEuuRRvpJUVC+qHfnYxb3r11Fh0gxQ+f
         F7N/kc7I5D3UyaffDOBlFRz21dm1hRtGogNhcma/C3hHRv/HwDIkrlxzGOaoHwsWGWeA
         o++JJoY8rRook2KY4CYJIu3lysOMo3HyiIKUy9ZlK7IsG9XqzkUcy1hvrNkX4TnjhPTp
         nvZg==
X-Gm-Message-State: AOAM533hKtJM/r/x2f262Xyp3Aat+Ce+XrH/8vFL6vC3NKl+WiDlsN0y
        /fFY+KuiRNsj1+9WdIPBwY0e3ikZGA3EatMsGba4Hg==
X-Google-Smtp-Source: ABdhPJyBQuYuCqeNZAOxA+BktTbh+7vcK4unm4ItMQkMKvp6ipwld2A4FhAXXvvhUrz3D9PIsaWPX7c9ospx8G7/m9M=
X-Received: by 2002:a05:6a00:26cf:b0:4f6:fc52:7b6a with SMTP id
 p15-20020a056a0026cf00b004f6fc527b6amr20736309pfw.39.1648425914133; Sun, 27
 Mar 2022 17:05:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com> <20220311044811.1980336-3-reijiw@google.com>
 <YjtzZI8Lw2uzjm90@google.com> <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
 <YjywaFuHp8DL7Q9T@google.com> <CAAeT=FwkSUb59Uc35CJgerJdBM5ZCUExNnz2Zs2oHFLn0Jjbsg@mail.gmail.com>
 <YkDrv2JdZhVFnGMk@google.com>
In-Reply-To: <YkDrv2JdZhVFnGMk@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 27 Mar 2022 17:04:58 -0700
Message-ID: <CAAeT=Fx8d9aWr1DFJ2N0n9KUs3z3PaGmFVbkcYRSkt7=H19hog@mail.gmail.com>
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
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

Hi Oliver,

On Sun, Mar 27, 2022 at 3:57 PM Oliver Upton <oupton@google.com> wrote:
>
> On Fri, Mar 25, 2022 at 07:35:39PM -0700, Reiji Watanabe wrote:
> > Hi Oliver,
> >
> > > > > > + */
> > > > > > +#define KVM_ARM_ID_REG_MAX_NUM   64
> > > > > > +#define IDREG_IDX(id)            ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > > > > +
> > > > > >   struct kvm_arch {
> > > > > >           struct kvm_s2_mmu mmu;
> > > > > > @@ -137,6 +144,9 @@ struct kvm_arch {
> > > > > >           /* Memory Tagging Extension enabled for the guest */
> > > > > >           bool mte_enabled;
> > > > > >           bool ran_once;
> > > > > > +
> > > > > > + /* ID registers for the guest. */
> > > > > > + u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > > > >
> > > > > This is a decently large array. Should we embed it in kvm_arch or
> > > > > allocate at init?
> > > >
> > > >
> > > > What is the reason why you think you might want to allocate it at init ?
> > >
> > > Well, its a 512 byte array of mostly cold data. We're probably
> > > convinced that the guest is going to access these registers at most once
> > > per vCPU at boot.
> > >
> > > For the vCPU context at least, we only allocate space for registers we
> > > actually care about (enum vcpu_sysreg). My impression of the feature
> > > register ranges is that there are a lot of registers which are RAZ, so I
> > > don't believe we need to make room for uninteresting values.
> > >
> > > Additionally, struct kvm is visible to EL2 if running nVHE. I
> > > don't believe hyp will ever need to look at these register values.
> >
> > As saving/restoring breakpoint/watchpoint registers for guests
> > might need a special handling when AA64DFR0_EL1.BRPs get changed,
> > next version of the series will use the data in the array at
> > EL2 nVHE.  They are cold data, and almost half of the entries
> > will be RAZ at the moment though:)
>
> Shouldn't we always be doing a full context switch based on what
> registers are present in hardware? We probably don't want to leave host
> watchpoints/breakpoints visible to the guest.

Correct, any host breakpoints/watchpoints won't be exposed to the guest.
(When restoring breakpoints/watchpoints for the guest, physical
 breakpoints that are not mapped to any virtual ones will be cleared)


> Additionally, if we are narrowing the guest's view of the debug
> hardware, are we going to need to start trapping debug register
> accesses? Unexposed breakpoint registers are supposed to UNDEF if we
> obey the Arm ARM to the letter. Even if we decide to not care about
> unexposed regs, I believe certain combinations of ID_AA64DF0_EL1.{BRPs,
> CTX_CMPs} might require that we emulate.

Exactly, we will need to start trapping debug registers when the special
handling is needed, and yes, we will need a special handling when the
guest accesses to invalid virtual breakpoints/watchpoints or use the
invalid virtual breakpoints as linked breakpoints.

Thanks,
Reiji
