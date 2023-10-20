Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A057D0795
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 07:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbjJTF01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 01:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbjJTF0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 01:26:25 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5D5D4C
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 22:26:22 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id ada2fe7eead31-457e5dec94dso162121137.3
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 22:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697779581; x=1698384381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IVgRisShFqd7EiamTTw+bWWTirWYsFZ+qCSq/HGAIy0=;
        b=SZN0+PVof30n4KVsW5UjKM07VgQ5XRWG8+QdcZJ5WtL3H3NMLqBtHyg705dIKAjnNr
         w4HclU8zb25S/xDEy+d6UfEyte1vetCzjo+8I8RBkWozQra9JNKqfLqR4dW8MyPEueHw
         6JyhxGcG3LJyEsfdKwSc9k97nmKatRM5eGcxLN/qVPm2Oo2cpUGfjtnkXl5aTx84bhWA
         WTy4mVD64lHjPad9gHlHxTiXJGk6dHagEyVbSsCmRJQuj9yXYuF6s0iSwrBxdv2rgtnH
         Z+6HqKWrNJPEZUWKLQdrnGa/ksn4eEQH6If+9/RcaoH1HglMW6/oX7FSITfqD1XMeSlb
         ximw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697779581; x=1698384381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IVgRisShFqd7EiamTTw+bWWTirWYsFZ+qCSq/HGAIy0=;
        b=T835Vz+f78ZISMuzDQAN/gEwnG35VfLf2WXKTYCa09HES7frdevkP6mAGaIx8k2yBk
         rNN2hapSfJOWRW/Iq2ay8Q6AfybbJKYJieb4vvMGoOWPTK55QHeZ4MwE6eLFKwMGbpaQ
         /3OyVv7DnjZUIQV6T0CNvV2ZoOC4PCLJMFEz8d9LzaDxRHbbgT9an32lB3eWwVjfTkwr
         9YOggoxcxdaVX7eGxGtBqa6oWe2NTb73b1jPmFBnBuwsqFAYvq0JoZXaL5hxkIg/ee4n
         sfcPCIKeFaJJFL0zp66r+8e01OaoXMsjsSbalgs1ahKce6+UKCBVM1wE55+Dpfik+8KO
         /b+w==
X-Gm-Message-State: AOJu0Yyc25Go8CfkhAAPhNCHDha6NWAiRzDIniDkA6+hxe4NVvo4/hcJ
        16F6JT9+wWwRdZHeebjTebBgX0l13azD8KqLqr+ckQ==
X-Google-Smtp-Source: AGHT+IHo8erdk2AN0cF2HUMClMRLyNwghQbHQC1m7KfJFjkcJhqBzh3HXIExQo07E3k6BH9SqTyX3KGslOi9ibHfP8c=
X-Received: by 2002:a67:ef51:0:b0:457:dbe3:ef45 with SMTP id
 k17-20020a67ef51000000b00457dbe3ef45mr1085001vsr.19.1697779581093; Thu, 19
 Oct 2023 22:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-4-apatel@ventanamicro.com> <20231019-1e6f411e1cbc4a3b0fbff3f5@orel>
In-Reply-To: <20231019-1e6f411e1cbc4a3b0fbff3f5@orel>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 20 Oct 2023 10:56:09 +0530
Message-ID: <CAK9=C2XSdrOSTp7skR4btGFkfL==0E+Su71d4bgJGXB80x6rBw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] RISC-V: KVM: Allow some SBI extensions to be
 disabled by default
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023 at 1:27=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Oct 12, 2023 at 10:45:04AM +0530, Anup Patel wrote:
> > Currently, all SBI extensions are enabled by default which is
> > problematic for SBI extensions (such as DBCN) which are forwarded
> > to the KVM user-space because we might have an older KVM user-space
> > which is not aware/ready to handle newer SBI extensions. Ideally,
> > the SBI extensions forwarded to the KVM user-space must be
> > disabled by default.
> >
> > To address above, we allow certain SBI extensions to be disabled
> > by default so that KVM user-space must explicitly enable such
> > SBI extensions to receive forwarded calls from Guest VCPU.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |  4 +++
> >  arch/riscv/kvm/vcpu.c                 |  6 ++++
> >  arch/riscv/kvm/vcpu_sbi.c             | 45 ++++++++++++++++-----------
> >  3 files changed, 36 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include=
/asm/kvm_vcpu_sbi.h
> > index 8d6d4dce8a5e..c02bda5559d7 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > @@ -35,6 +35,9 @@ struct kvm_vcpu_sbi_return {
> >  struct kvm_vcpu_sbi_extension {
> >       unsigned long extid_start;
> >       unsigned long extid_end;
> > +
> > +     bool default_unavail;
> > +
> >       /**
> >        * SBI extension handler. It can be defined for a given extension=
 or group of
> >        * extension. But it should always return linux error codes rathe=
r than SBI
> > @@ -59,6 +62,7 @@ int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *v=
cpu,
> >  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> >                               struct kvm_vcpu *vcpu, unsigned long exti=
d);
> >  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *ru=
n);
> > +void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
> >
> >  #ifdef CONFIG_RISCV_SBI_V01
> >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index c061a1c5fe98..e087c809073c 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -141,6 +141,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >       if (rc)
> >               return rc;
> >
> > +     /*
> > +      * Setup SBI extensions
> > +      * NOTE: This must be the last thing to be initialized.
> > +      */
> > +     kvm_riscv_vcpu_sbi_init(vcpu);
>
> With this, we no longer defer probing to the first access (whether that's
> by the guest or KVM userspace). With our current small set of SBI
> extensions where only a single one has a probe function, then this
> simpler approach is good enough. We can always go back to the lazy
> approach later if needed.

I agree. We can fallback to lazy probing in the future if required.

>
> > +
> >       /* Reset VCPU */
> >       kvm_riscv_reset_vcpu(vcpu);
> >
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > index 9cd97091c723..1b1cee86efda 100644
> > --- a/arch/riscv/kvm/vcpu_sbi.c
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -155,14 +155,8 @@ static int riscv_vcpu_set_sbi_ext_single(struct kv=
m_vcpu *vcpu,
> >       if (!sext)
> >               return -ENOENT;
> >
> > -     /*
> > -      * We can't set the extension status to available here, since it =
may
> > -      * have a probe() function which needs to confirm availability fi=
rst,
> > -      * but it may be too early to call that here. We can set the stat=
us to
> > -      * unavailable, though.
> > -      */
> > -     if (!reg_val)
> > -             scontext->ext_status[sext->ext_idx] =3D
> > +     scontext->ext_status[sext->ext_idx] =3D (reg_val) ?
> > +                     KVM_RISCV_SBI_EXT_AVAILABLE :
> >                       KVM_RISCV_SBI_EXT_UNAVAILABLE;
>
> We're missing the change to riscv_vcpu_get_sbi_ext_single() which should
> also drop the comment block explaining the limits to status knowledge
> without initial probing (which we now do) and then just check for
> available, i.e.
>
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index bb76c3cf633f..92c42d9aba1c 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -186,15 +186,8 @@ static int riscv_vcpu_get_sbi_ext_single(struct kvm_=
vcpu *vcpu,
>         if (!sext)
>                 return -ENOENT;
>
> -       /*
> -        * If the extension status is still uninitialized, then we should=
 probe
> -        * to determine if it's available, but it may be too early to do =
that
> -        * here. The best we can do is report that the extension has not =
been
> -        * disabled, i.e. we return 1 when the extension is available and=
 also
> -        * when it only may be available.
> -        */
> -       *reg_val =3D scontext->ext_status[sext->ext_idx] !=3D
> -                               KVM_RISCV_SBI_EXT_UNAVAILABLE;
> +       *reg_val =3D scontext->ext_status[sext->ext_idx] =3D=3D
> +                               KVM_RISCV_SBI_EXT_AVAILABLE;
>
>         return 0;
>  }

Thanks, I will include this change in the next revision.

>
> >
> >       return 0;
> > @@ -337,18 +331,8 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_=
find_ext(
> >                           scontext->ext_status[entry->ext_idx] =3D=3D
> >                                               KVM_RISCV_SBI_EXT_AVAILAB=
LE)
> >                               return ext;
> > -                     if (scontext->ext_status[entry->ext_idx] =3D=3D
> > -                                             KVM_RISCV_SBI_EXT_UNAVAIL=
ABLE)
> > -                             return NULL;
> > -                     if (ext->probe && !ext->probe(vcpu)) {
> > -                             scontext->ext_status[entry->ext_idx] =3D
> > -                                     KVM_RISCV_SBI_EXT_UNAVAILABLE;
> > -                             return NULL;
> > -                     }
> >
> > -                     scontext->ext_status[entry->ext_idx] =3D
> > -                             KVM_RISCV_SBI_EXT_AVAILABLE;
> > -                     return ext;
> > +                     return NULL;
> >               }
> >       }
> >
> > @@ -419,3 +403,26 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
> >
> >       return ret;
> >  }
> > +
> > +void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> > +     const struct kvm_riscv_sbi_extension_entry *entry;
> > +     const struct kvm_vcpu_sbi_extension *ext;
> > +     int i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > +             entry =3D &sbi_ext[i];
> > +             ext =3D entry->ext_ptr;
> > +
> > +             if (ext->probe && !ext->probe(vcpu)) {
> > +                     scontext->ext_status[entry->ext_idx] =3D
> > +                             KVM_RISCV_SBI_EXT_UNAVAILABLE;
> > +                     continue;
> > +             }
> > +
> > +             scontext->ext_status[entry->ext_idx] =3D ext->default_una=
vail ?
> > +                                     KVM_RISCV_SBI_EXT_UNAVAILABLE :
> > +                                     KVM_RISCV_SBI_EXT_AVAILABLE;
> > +     }
> > +}
> > --
> > 2.34.1
> >
>
> Thanks,
> drew

Regards,
Anup
