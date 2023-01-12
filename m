Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2E7667E5D
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjALSrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbjALSr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:47:26 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06683820C0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:19:57 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i65so10946421pfc.0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0XqZSkBjF0/NwCudxK7VyjrIpDSZ4UaVvor7D5Au+9I=;
        b=Nss6QjOj2gWAnAUZSZ/Om/bvUd0ReXJo7t3e+0oHUVC0Dcr0a+a15NlUkN1pPkdNjI
         xqJouLOLu6WulABRRjr2EE8ABIhfopSfsqApSd3bBpqeKqcWQknlDmtwAnudN+zJ7Y0O
         tCQIhs+JofA7eoEN2kcocsbiz/R/AazVdN0xuYpe8+2yWT7P78IqnNkOWsgwnC05suE+
         Teec6JjBKNr3pGUiteMTH1/5Aprxv2ExecE4R5B/AThLZaTlT1/9bTMPaBNaJ1E47PbW
         SWrrj+6IYPGVrdXP9Mi9zdenICE6ibCfm4uO8gdqzKJo8G2C5yU2z34+JDcT3YVdMnoT
         USXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0XqZSkBjF0/NwCudxK7VyjrIpDSZ4UaVvor7D5Au+9I=;
        b=SW53i2q323nsTzw21cT1o36TFuQAonNBhtGH1pVSgpt97X7KMshavHE1b+puOCW9Mq
         LOmEw8i1+5t4tXt3/kaFZ4Q7SjDcnyeqCAK5ZO6Z8ISJLAzACR+v5tZLZjVhiuXiVD5r
         WaQI9MLXgx/pAVevZl/WjjZEu71nnv4g+ey3lQRf3iuGKqFRAk+Xojsmu4W2txBphozS
         cb+cRwrXPpCjyLSKTIg/pD1Bi3b0Jijw74xsmx0YrDte5NA9DccBnU2AjTbWM6xQztww
         BsUwGsnOPCqIVqA3EatrNQ6ngNzMdLQUBPfAgCqAEndOfUPZxkgmdMrJ4qevNYT4ZmCx
         XQlQ==
X-Gm-Message-State: AFqh2kqSRs4Xd8CXXE3OhORjRD/5J3+Qke+Pd1hwqEZD74ENao19dCde
        MaDCTjjqs/A0woakxFe9/we9DgysuBkiXHd7gGqSFw==
X-Google-Smtp-Source: AMrXdXsMZYU+ot9pUjM6sBfBWlHRs5OKPeSzQPbNaLx2GTCzg8mr/58dc6ua+GqpoYiouuO1ycmVhn1xvGW01o0l2Ac=
X-Received: by 2002:a63:d14a:0:b0:479:5a45:6d32 with SMTP id
 c10-20020a63d14a000000b004795a456d32mr3854918pgj.138.1673547597227; Thu, 12
 Jan 2023 10:19:57 -0800 (PST)
MIME-Version: 1.0
References: <20221215170046.2010255-1-atishp@rivosinc.com> <20221215170046.2010255-3-atishp@rivosinc.com>
 <20230112102141.chpcqzoko25s2cak@orel>
In-Reply-To: <20230112102141.chpcqzoko25s2cak@orel>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Thu, 12 Jan 2023 10:19:46 -0800
Message-ID: <CAHBxVyG0mmVJDg0MUG0FMhQM11xrk6dTw9Hc1YntVE+9qdbfOg@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] RISC-V: KVM: Define a probe function for SBI
 extension data structures
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 2:21 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Dec 15, 2022 at 09:00:37AM -0800, Atish Patra wrote:
> > Currently the probe function just checks if an SBI extension is
> > registered or not. However, the extension may not want to advertise
> > itself depending on some other condition.
> > An additional extension specific probe function will allow
> > extensions to decide if they want to be advertised to the caller or
> > not. Any extension that does not require additional dependency checks
> > can avoid implementing this function.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
> >  arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++++++++++--
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > index f79478a..61dac1b 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > @@ -29,6 +29,9 @@ struct kvm_vcpu_sbi_extension {
> >       int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                      unsigned long *out_val, struct kvm_cpu_trap *utrap,
> >                      bool *exit);
> > +
> > +     /* Extension specific probe function */
> > +     unsigned long (*probe)(struct kvm_vcpu *vcpu, unsigned long extid);
>
> It doesn't seem like the extid parameter should be necessary since the
> probe function is specific to the extension, but it doesn't hurt either.
>

Yeah. You are correct. I will drop it. Thanks.

> >  };
> >
> >  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> > diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> > index 5d65c63..89e2415 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_base.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> > @@ -19,6 +19,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >  {
> >       int ret = 0;
> >       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> > +     const struct kvm_vcpu_sbi_extension *sbi_ext;
> >
> >       switch (cp->a6) {
> >       case SBI_EXT_BASE_GET_SPEC_VERSION:
> > @@ -43,8 +44,16 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                        */
> >                       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> >                       *exit = true;
> > -             } else
> > -                     *out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
> > +             } else {
> > +                     sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> > +                     if (sbi_ext) {
> > +                             if (sbi_ext->probe)
> > +                                     *out_val = sbi_ext->probe(vcpu, cp->a0);
> > +                             else
> > +                                     *out_val = 1;
> > +                     } else
> > +                             *out_val = 0;
> > +             }
> >               break;
> >       case SBI_EXT_BASE_GET_MVENDORID:
> >               *out_val = vcpu->arch.mvendorid;
> > --
> > 2.25.1
> >
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
