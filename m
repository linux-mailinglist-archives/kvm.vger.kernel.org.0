Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED515083FA
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 10:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376914AbiDTIuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 04:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349974AbiDTIuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 04:50:10 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A255C1837F
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 01:47:24 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id q14so1082072ljc.12
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 01:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tAe7ocOZ0bBrreHF0RxD9R0oEMScj7O80nn6Z0+6mKk=;
        b=l7aPeWemyn/R90hcDdIeAm1ynIy9VHgrdD+aB5XMWSttSYjB3m3nf82oOQL5BO70pf
         yKt3cTG/Y5uxBT8/EdawX4RKgVRideaRv/5Y7f97MbkHjGBbHi0TTrcVApE+ETXXOupq
         dx7KHF8KZaGgXBfzM/A9wSl1a3draGgOOuk7qRps+NYoWW+Mr801M1qRdrSpZXYnojrq
         l+bZqHL70oDSYG7GZTP9rmWgoRJZLsZtCTHdM9k57/gikiSWCDq85aPUMQdI7hCkl3mi
         0k26ZysqwMsgqb8+2Xw+u3S7eUxUwzzJO5pz7PPrlzgKaqvBLXtAs0iQpZ+ktMuhrq00
         cczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tAe7ocOZ0bBrreHF0RxD9R0oEMScj7O80nn6Z0+6mKk=;
        b=Z8Pgup80m/jV09UGDojw7p2/jr6F2Nsa9q5S5ggKOXKQqbgCbjXDchuLF6jIL3+egA
         v2w05hBJlPIcZJzzyxt3YfarTz2z+brovYzh0q8FAi/2M+7EIndJYhXVDsJurCWurvlC
         GMjmQA1ROYEocg4LB77QPq4ihXJeE1hxdeK6FC2VtleM3xmIUO8D+wL4xiYjkoQWFqLX
         RNznxklnGej9uKKQx1Uqfls23TXmIGwc00i3NZazoR3n5nW6es5HjjZ98cptmA1/3sw6
         Si/jtbocvfx0o8+CdnfBL5Ol6KV2ngB3fjZ0KKL9XD6BBbp1AXbJZh4+9VdcRH3uBXxC
         mmNQ==
X-Gm-Message-State: AOAM5314RRNf4HnO5pUUtqZm8qhx012cThVRsBENbuerAMBHhHh4iVSK
        LhyiBiSbrMjz7OK0Ejnc3EhHndyNaqdckagl0rea6w==
X-Google-Smtp-Source: ABdhPJzPP6FZmr+6nZr+hzEU+yTnYEzGCQtdmZue5NJ/rrH+3+6fdShgY4mEO9KwAJzNgJeNkdQEkxHQJNmJ6W9b15c=
X-Received: by 2002:a2e:6a08:0:b0:24d:14af:4be4 with SMTP id
 f8-20020a2e6a08000000b0024d14af4be4mr12846312ljc.24.1650444442933; Wed, 20
 Apr 2022 01:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220420013258.3639264-1-atishp@rivosinc.com> <20220420013258.3639264-3-atishp@rivosinc.com>
 <CAOnJCU+EPHxD7MqbswKMy=gZhmyyXMiezqaw1+D1h+O+pbYR2w@mail.gmail.com>
In-Reply-To: <CAOnJCU+EPHxD7MqbswKMy=gZhmyyXMiezqaw1+D1h+O+pbYR2w@mail.gmail.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Wed, 20 Apr 2022 14:17:10 +0530
Message-ID: <CAK9=C2U4s5hC9G0w8ELmZn=YgCJ2hTAU-EfGZsSh=HZy4gQaiw@mail.gmail.com>
Subject: Re: [PATCH 2/2] RISC-V: KVM: Restrict the extensions that can be disabled
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Atish Patra <atishp@rivosinc.com>,
        KVM General <kvm@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        devicetree <devicetree@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 1:13 PM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Tue, Apr 19, 2022 at 6:33 PM Atish Patra <atishp@rivosinc.com> wrote:
> >
> > Currently, the config reg register allows to disable all allowed
> > single letter ISA extensions. It shouldn't be the case as vmm
> > shouldn't be able disable base extensions (imac).
>
> /s/able/able to/
>
> > These extensions should always be enabled as long as they are enabled
> > in the host ISA.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/kvm/vcpu.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 2e25a7b83a1b..14dd801651e5 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -38,12 +38,16 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
> >                        sizeof(kvm_vcpu_stats_desc),
> >  };
> >
> > -#define KVM_RISCV_ISA_ALLOWED  (riscv_isa_extension_mask(a) | \
> > -                                riscv_isa_extension_mask(c) | \
> > -                                riscv_isa_extension_mask(d) | \
> > -                                riscv_isa_extension_mask(f) | \
> > -                                riscv_isa_extension_mask(i) | \
> > -                                riscv_isa_extension_mask(m))
> > +#define KVM_RISCV_ISA_DISABLE_ALLOWED  (riscv_isa_extension_mask(d) | \
> > +                                       riscv_isa_extension_mask(f))
> > +
> > +#define KVM_RISCV_ISA_DISABLE_NOT_ALLOWED      (riscv_isa_extension_mask(a) | \
> > +                                               riscv_isa_extension_mask(c) | \
> > +                                               riscv_isa_extension_mask(i) | \
> > +                                               riscv_isa_extension_mask(m))
> > +
> > +#define KVM_RISCV_ISA_ALLOWED (KVM_RISCV_ISA_DISABLE_ALLOWED | \
> > +                              KVM_RISCV_ISA_DISABLE_NOT_ALLOWED)
> >
> >  static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> >  {
> > @@ -217,9 +221,10 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
> >         switch (reg_num) {
> >         case KVM_REG_RISCV_CONFIG_REG(isa):
> >                 if (!vcpu->arch.ran_atleast_once) {
> > -                       vcpu->arch.isa = reg_val;
> > +                       /* Ignore the disable request for these extensions */
> > +                       vcpu->arch.isa = reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
> >                         vcpu->arch.isa &= riscv_isa_extension_base(NULL);
> > -                       vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
> > +                       vcpu->arch.isa &= KVM_RISCV_ISA_DISABLE_ALLOWED;
> >                         kvm_riscv_vcpu_fp_reset(vcpu);
> >                 } else {
> >                         return -EOPNOTSUPP;
> > --
> > 2.25.1
> >
>
> Sorry. I forgot to add the fixes tag.
>
> Fixes: 92ad82002c39 (RISC-V: KVM: Implement
> KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls)

I have queued this for fixes.

Thanks,
Anup

>
> --
> Regards,
> Atish
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
