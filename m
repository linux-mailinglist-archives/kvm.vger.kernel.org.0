Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088F64E7EA1
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 03:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiCZChb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 22:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiCZChb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 22:37:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1715718C0DE
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 19:35:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p4-20020a17090ad30400b001c7ca87c05bso5142368pju.1
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 19:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NUY1wg4evhKaQGByM6d8SxocfJxkAaaILI7ZScN9kP0=;
        b=N0E4+4JwvqtgxjjrlkKtHyw3eECXc+FlnXH6m3vvN1NcH4mS0PMlcLliwCgwJ/+ri3
         NiQzHCz5FG+BcAJnbfr9gfMwhBtYjkgd1yfDc47FQLjFRflaWOe1Qic6kgnypxgeCKPV
         9RGzVt6b3FhWnR0qiMtC4+3GvPmcqB/hrjinWcGuvFivwCMfGSvh4yDEqzFyYLxfSZrH
         9vpxnenX8oIJgiuL/x7n5aNRHSyKPYhFSmvkq1yhpfnhOqcpyi7qs8PGxjgrl8ewDC+F
         MJ+D1icEK53F7j+aLnUcp6KEDBiniYAiPog22s5NERRX4uYVPcl8yOsF7USgLoMfU/Hc
         FO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NUY1wg4evhKaQGByM6d8SxocfJxkAaaILI7ZScN9kP0=;
        b=MJx8bl9y6M3gZwyuu3QyeU+J143s5WUKEYtj9WDmob0K/wDr88L/QqrEHfLpNPRnCK
         cIdZIHvxxJaNoY+2QhnUQ3Jv429RJDxUNxkt5rPocafkjJtAygO6C+z1KEuOg17J5qVT
         AyftnQJO03ODtew+3gL2JabgKpvnA+uyeHEydYLXJ/keZBxuQDNwbwG/zMcKPYT2MpTV
         M1vFPdRlwxsh7Z0MYgind+RwpaPddiZGO28Muh4kk8bjyi52mB++oELIaqsfBJ51SQMl
         TyNEr1L+Z4Vutgwh3UAFVds0Ee1/j4kCPP7+HljUh8Sk7Obt9FxnX5cMBw1aq3t2a67u
         L4jQ==
X-Gm-Message-State: AOAM533MvGKKsjwN/A+bf2o0exlibxhZ6BRFwZ/ZwLj2vUbchAmZxfmn
        LVD2KFHnF8MhFjzie0phYPxPoRMEpimNTVoL1ZvLMIQpXRHkzq8Q
X-Google-Smtp-Source: ABdhPJyLILWFARa9ecDWFgbUjLgj8SnpKU6JSTSw6I7oIEXSWaHNQR4oQ0R5ChNlG/u8ieDTUMKNG57lNdTMwXVAAXA=
X-Received: by 2002:a17:902:b403:b0:153:62bb:c4b7 with SMTP id
 x3-20020a170902b40300b0015362bbc4b7mr14660873plr.138.1648262155360; Fri, 25
 Mar 2022 19:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com> <20220311044811.1980336-3-reijiw@google.com>
 <YjtzZI8Lw2uzjm90@google.com> <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
 <YjywaFuHp8DL7Q9T@google.com>
In-Reply-To: <YjywaFuHp8DL7Q9T@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 25 Mar 2022 19:35:39 -0700
Message-ID: <CAAeT=FwkSUb59Uc35CJgerJdBM5ZCUExNnz2Zs2oHFLn0Jjbsg@mail.gmail.com>
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

> > > > + */
> > > > +#define KVM_ARM_ID_REG_MAX_NUM   64
> > > > +#define IDREG_IDX(id)            ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > > +
> > > >   struct kvm_arch {
> > > >           struct kvm_s2_mmu mmu;
> > > > @@ -137,6 +144,9 @@ struct kvm_arch {
> > > >           /* Memory Tagging Extension enabled for the guest */
> > > >           bool mte_enabled;
> > > >           bool ran_once;
> > > > +
> > > > + /* ID registers for the guest. */
> > > > + u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > >
> > > This is a decently large array. Should we embed it in kvm_arch or
> > > allocate at init?
> >
> >
> > What is the reason why you think you might want to allocate it at init ?
>
> Well, its a 512 byte array of mostly cold data. We're probably
> convinced that the guest is going to access these registers at most once
> per vCPU at boot.
>
> For the vCPU context at least, we only allocate space for registers we
> actually care about (enum vcpu_sysreg). My impression of the feature
> register ranges is that there are a lot of registers which are RAZ, so I
> don't believe we need to make room for uninteresting values.
>
> Additionally, struct kvm is visible to EL2 if running nVHE. I
> don't believe hyp will ever need to look at these register values.

As saving/restoring breakpoint/watchpoint registers for guests
might need a special handling when AA64DFR0_EL1.BRPs get changed,
next version of the series will use the data in the array at
EL2 nVHE.  They are cold data, and almost half of the entries
will be RAZ at the moment though:)

Thanks,
Reiji
