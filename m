Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD476E0308
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 02:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjDMAIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 20:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDMAIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 20:08:30 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE32769F
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:07:56 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 185so20484467pgc.10
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681344474; x=1683936474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kKAsIKGLMCjdiMjyYgpIrloOvGnvw3VKlriI5GXRN4I=;
        b=2ItN+tuUpWJoDHZW7JEKXnfoI8Ujg4dDAlkY/WfQSIZQmMt22ieaeyCJ/MX4GAoB5J
         TVXdtxMQ/qpSt3c5QAg30x7AD8THGhS5T2khj9Ja/5HEScjOfn9w3cWGkkVX4JKtLaAl
         EKkFjRiS9tGTBpbYqVXPUvzA8uI0t/dyDimUnQFCSgVfxF8yE/xSjXuse4k0xujgQZ5P
         czZQlXliQxSKDKUuu/mZc0kh2DFv6LQB5Ef2zFr3f7JdrjSo94quWeZdT0ITuRqpsOHR
         Lq2bQrIrveuvzRucH92FVUbafqoxOiJlUK8Gj+YJTo66w2mlj8HzLvlZiuo4cjm/D4KU
         RkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681344474; x=1683936474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kKAsIKGLMCjdiMjyYgpIrloOvGnvw3VKlriI5GXRN4I=;
        b=de1cDHPe3Oj7nvgPqJUY7BjDfzSjirNVKLT6IZOiphP1f0/Uu4VA8PzOEJuAIfCHQ7
         sCcf60iidw2Uobr8/HQfzo2H2uNBAKeqs/HZoy5hlUskkgBkjWOtE9U0qWPnJRGNx6Wy
         8xh1bu8C7MKHobNYi6eLOWfwqqYct1KaZpJPATEz6MVGAxsr6hvUtLFXJt/6AmcDJ6U0
         ZF9bNpP1uszZS9gTS/4+b45MBpVqAzLqrQclrFgm5N+MeOaIwQOFPc2ooFqVYvKHXF56
         X4vYw+soFtXVDXw6midoh5aZldC1/3eGmF8q/RjLLBBHiOzQOa4Kkp3qzPfrQAE448Cz
         yihA==
X-Gm-Message-State: AAQBX9cLOueBGWuPaKVo6kofSH/XfLtMLM//bgjeT/WSOORL8vr06fpl
        NTUTEZuFwUmEV6iTnJ6h/o36czZUSbJ7DvNy6FxzZg==
X-Google-Smtp-Source: AKy350ZslI/1nnGseGhaPt1ANKI3NMzvWy4XpoBuKrS83PsSkHoKwJ4zv6tFEy5paivPw1yzgwz46V4bM56jOb1AiNs=
X-Received: by 2002:a63:5158:0:b0:513:955d:ee9f with SMTP id
 r24-20020a635158000000b00513955dee9fmr4393677pgl.4.1681344474384; Wed, 12 Apr
 2023 17:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230408034759.2369068-1-reijiw@google.com> <20230408034759.2369068-3-reijiw@google.com>
 <ZDUpfnXi/GwFwFV9@FVFF77S0Q05N> <20230412051410.emaip77vyak624pu@google.com>
 <ZDZ3xbSePtOD3CSX@FVFF77S0Q05N> <86v8i1l7ru.wl-maz@kernel.org>
In-Reply-To: <86v8i1l7ru.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 12 Apr 2023 17:07:38 -0700
Message-ID: <CAAeT=FwUZ-TTn+4tt9pcesB59b7_=_zxkeRftMh5aQDUqnMz8g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Apr 12, 2023 at 11:22:29AM +0100, Marc Zyngier wrote:
> On Wed, 12 Apr 2023 10:20:05 +0100,
> Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > On Tue, Apr 11, 2023 at 10:14:10PM -0700, Reiji Watanabe wrote:
> > > Uh, right, interrupts are not masked during those windows...
> > >
> > > What I am currently considering on this would be disabling
> > > IRQs while manipulating the register, and introducing a new flag
> > > to indicate whether the PMUSERENR for the guest EL0 is loaded,
> > > and having kvm_set_pmuserenr() check the new flag.
> > >
> > > The code would be something like below (local_irq_save/local_irq_restore
> > > needs to be excluded for NVHE though).
>
> It shouldn't need to be excluded. It should be fairly harmless, unless
> I'm missing something really obvious?

The reason why I think local_irq_{save,restore} should be excluded
are because they use trace_hardirqs_{on,off} (Since IRQs are
masked here for NVHE, practically, they shouldn't be called with
the current KVM implementation though).

I'm looking at using "ifndef __KVM_NVHE_HYPERVISOR__" or other
ways to organize the code for this.
Since {__activate,__deactivate}_traps_common() are pretty lightweight
functions, I'm also considering disabling IRQs in their call sites
(i.e. activate_traps_vhe_load/deactivate_traps_vhe_put), instead of in
__{de}activate_traps_common() (Thanks for this suggestion, Oliver).


> > I'm happy with that; it doesn't change the arm_pmu side of the interface and it
> > looks good from a functional perspective.
> >
> > I'll have to leave it to Marc and Oliver to say whether they're happy with the
> > KVM side.
>
> This looks OK to me. My only ask would be to have a small comment in
> the __{de}activate_traps_common() functions to say what this protects
> against, because I'll page it out within minutes.

Thank you for the feedback!
Yes, I will add a comment for those.

Thank you,
Reiji
