Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6C272E58D
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbjFMOTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240427AbjFMOTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:19:22 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77D0122
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:19:20 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so6832169e87.2
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1686665959; x=1689257959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7G7WISwn9s1FAbksaD2ySHTKgO7VUIhbMY1jTirXvrw=;
        b=VwH3fqs2X4hcxz6P+8fjA8T2eB93MGDJrzwV+fuJx5r1AR922Z3dnYtUInF3o7UlnE
         X7+bKD75xNkz9hJqiEuVe8nN6RINGfW+BK5VBqODTD5SwWKdr7y1gBcuK2PxO+C3FYx4
         8pxhUH1DV/pzAf2RyTJ+WUS9BDENMJZxB4WUWSLlPFSZ08CDMDJsLNe89tXxiIKndnS8
         ByuLMLDx9WWGc17i2/O+GaBpTIeRY7wwzc0IkuzcNG9VnlqVD0LVeEcFXl0f3wYPvLiE
         JUW1XhF3HrhotH3379iETRcTPWjPqTM3YHGH4Chj/UhqYlZMUn5mXe3gukNDtLkxoDQz
         t4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686665959; x=1689257959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7G7WISwn9s1FAbksaD2ySHTKgO7VUIhbMY1jTirXvrw=;
        b=NWYGkEkv0IhhOScMXQrlkwUOEi0XNh4QD29rpQBJF9aL24jZvj4pfBJiJGm1AbcBYN
         WA5TgBe2W2I/ICKN1RfzCeFoC1kXQPytJoZEWvxkfOT8X7sjmELmCjn9FnmG0L3eBmfE
         Iy6QQqsJwJ8NRo4oEB2IrVw091sc8fP7Na8vWZ5oFFOqnnV7R4Lf1oL5dFm1B+UcUZfL
         w2qq3IiRQT8JC5UtNoKmbCE5HJaRojaiuGFaNKFziUpSAnzNLVddxzZo+aUIBLkabpUM
         /v8ecD1uZtlUKxHnl4i/rSx6/cLNCahsbhvqV4UoRhnqmiir2V3FvqlzXQ712ERV6cYx
         EgtQ==
X-Gm-Message-State: AC+VfDwahn4dVms/BFkpDdPzXKcDb8+SYhnGjlN49afNMHqzYUJbA1uL
        +2OKJSPnwxIO+ALoQjVlsrs5clVlR28a3MvoxK/jLg==
X-Google-Smtp-Source: ACHHUZ7lZwSYwjLPUf/5y6/cdfw7eI2TX61GvfBndGuTtP3wWsH9igBCJ8KOiFMdgB8yD4ANBNRyCka1/8jg1s3VVPA=
X-Received: by 2002:a05:651c:14f:b0:2af:2871:9a66 with SMTP id
 c15-20020a05651c014f00b002af28719a66mr5183509ljd.39.1686665959080; Tue, 13
 Jun 2023 07:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230605110724.21391-1-andy.chiu@sifive.com> <20230605110724.21391-10-andy.chiu@sifive.com>
 <5271851.rBgCu3BfMA@basile.remlab.net>
In-Reply-To: <5271851.rBgCu3BfMA@basile.remlab.net>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 13 Jun 2023 22:19:08 +0800
Message-ID: <CABgGipX95PsavJ-Wrpc2ziJ5xj6nRTJ9QjddOyCp6Bn=fwP3mw@mail.gmail.com>
Subject: Re: [PATCH -next v21 09/27] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
To:     =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 10:36=E2=80=AFPM R=C3=A9mi Denis-Courmont <remi@rem=
lab.net> wrote:
>
> Le maanantaina 5. kes=C3=A4kuuta 2023, 14.07.06 EEST Andy Chiu a =C3=A9cr=
it :
> > @@ -32,13 +54,86 @@ static __always_inline void riscv_v_disable(void)
> >       csr_clear(CSR_SSTATUS, SR_VS);
> >  }
> >
> > +static __always_inline void __vstate_csr_save(struct __riscv_v_ext_sta=
te
> > *dest) +{
> > +     asm volatile (
> > +             "csrr   %0, " __stringify(CSR_VSTART) "\n\t"
> > +             "csrr   %1, " __stringify(CSR_VTYPE) "\n\t"
> > +             "csrr   %2, " __stringify(CSR_VL) "\n\t"
> > +             "csrr   %3, " __stringify(CSR_VCSR) "\n\t"
> > +             : "=3Dr" (dest->vstart), "=3Dr" (dest->vtype), "=3Dr" (de=
st-
> >vl),
> > +               "=3Dr" (dest->vcsr) : :);
> > +}
> > +
> > +static __always_inline void __vstate_csr_restore(struct __riscv_v_ext_=
state
> > *src) +{
> > +     asm volatile (
> > +             ".option push\n\t"
> > +             ".option arch, +v\n\t"
> > +             "vsetvl  x0, %2, %1\n\t"
> > +             ".option pop\n\t"
> > +             "csrw   " __stringify(CSR_VSTART) ", %0\n\t"
> > +             "csrw   " __stringify(CSR_VCSR) ", %3\n\t"
> > +             : : "r" (src->vstart), "r" (src->vtype), "r" (src->vl),
> > +                 "r" (src->vcsr) :);
> > +}
> > +
> > +static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state
> > *save_to, +                                    void *datap)
> > +{
> > +     unsigned long vl;
> > +
> > +     riscv_v_enable();
> > +     __vstate_csr_save(save_to);
> > +     asm volatile (
> > +             ".option push\n\t"
> > +             ".option arch, +v\n\t"
> > +             "vsetvli        %0, x0, e8, m8, ta, ma\n\t"
> > +             "vse8.v         v0, (%1)\n\t"
> > +             "add            %1, %1, %0\n\t"
> > +             "vse8.v         v8, (%1)\n\t"
> > +             "add            %1, %1, %0\n\t"
> > +             "vse8.v         v16, (%1)\n\t"
> > +             "add            %1, %1, %0\n\t"
> > +             "vse8.v         v24, (%1)\n\t"
> > +             ".option pop\n\t"
> > +             : "=3D&r" (vl) : "r" (datap) : "memory");
> > +     riscv_v_disable();
> > +}
>
> Shouldn't this use `vs8r.v` rather than `vse8.v`, and do away with `vsetv=
li`?
> This seems like a textbook use case for the whole-register store instruct=
ion,
> no?

Yes, I think it is worth changing to whole-register load/store
instruction. Let me form a follow-up patch to improve it a bit.

>
> > +
> > +static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state
> > *restore_from, +                                          void
> *datap)
> > +{
> > +     unsigned long vl;
> > +
> > +     riscv_v_enable();
> > +     asm volatile (
> > +             ".option push\n\t"
> > +             ".option arch, +v\n\t"
> > +             "vsetvli        %0, x0, e8, m8, ta, ma\n\t"
> > +             "vle8.v         v0, (%1)\n\t"
> > +             "add            %1, %1, %0\n\t"
> > +             "vle8.v         v8, (%1)\n\t"
> > +             "add            %1, %1, %0\n\t"
> > +             "vle8.v         v16, (%1)\n\t"
> > +             "add            %1, %1, %0\n\t"
> > +             "vle8.v         v24, (%1)\n\t"
> > +             ".option pop\n\t"
> > +             : "=3D&r" (vl) : "r" (datap) : "memory");
> > +     __vstate_csr_restore(restore_from);
> > +     riscv_v_disable();
> > +}
> > +
>
> Ditto but `vl8r.v`.
>
> >  #else /* ! CONFIG_RISCV_ISA_V  */
> >
> >  struct pt_regs;
> >
> >  static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
> >  static __always_inline bool has_vector(void) { return false; }
> > +static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return
> > false; } #define riscv_v_vsize (0)
> > +#define riscv_v_vstate_off(regs)             do {} while (0)
> > +#define riscv_v_vstate_on(regs)                      do {} while (0)
> >
> >  #endif /* CONFIG_RISCV_ISA_V */
> >
>
>
> --
> =D0=A0=D0=B5=D0=BC=D0=B8 =D0=94=D1=91=D0=BD=D0=B8-=D0=9A=D1=83=D1=80=D0=
=BC=D0=BE=D0=BD
> http://www.remlab.net/
>
>
>

Thanks,
Andy
