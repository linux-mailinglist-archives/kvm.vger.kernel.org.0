Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E05667E73
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjALSzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjALSzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:55:24 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2455587907
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:25:18 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a30so14420337pfr.6
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wdJjNMR8HoaXn9/oJmxLSyIdwmRRw8E6OKveZFE7S0o=;
        b=oF+dydPOzLUV6gm4IhZPy0ytIJCP75Hu4akx7+XbCZvo4om5HhS0f6mJ4n/K7276Un
         amkhxNx8AaLMjji0vPkssaD8xMJ58T2+hwuFVwOWnvCKRDqJo5f887je41pc1p3jd6sS
         /wALf4JB3cR96/2BEXXlBKLL3rid+e94peWAraxVVF1BrcrbgkHer2gutrf0Sp5py5o0
         zV1oZ1GAvU6ICcKFXa7a2KInbBN/lNBmpoX+WkdL9/1ahzxMIXHXLY0UePgT5pTXpN0i
         tStu6VFSnY6yx6ikuU6Q1oW6/uuCDwnHo+09soFPALkFgJq9UZWDoxmm9nvQ03nG0bpM
         txtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wdJjNMR8HoaXn9/oJmxLSyIdwmRRw8E6OKveZFE7S0o=;
        b=aP19SCCwnpjtAWRdinO+p0O3y+rTsvppaa/jRSfZ1xsuQjP0eTXJFWSBqVVtLWAluF
         tbSTHJgeidZ3S1MujW8Erp1sZtUs4jFgmX88wQ6FTAzR9aa8oF4M0pbqV/IroaMiBL26
         99HmrWrA9INgxBJJIogOXCvu3vC6/VXrdOdWlTdcjkJjj1HCjdCXm/nJQNXhqt515436
         6IJ48CoOJgqfOSc0zGGeYpMpa90F9SlFfwioE8YwRFgQVHroFwOHjRNj6Wjs16ofZowb
         VdELmUSsYj5QlPC2aGftC9pbnr2CfZC3SN84ckkrUHtz3Jg7rmR4Cxg0EDkVX7/1uKuX
         7RpA==
X-Gm-Message-State: AFqh2kqSJNgtC4stqIpTTU/QVuzSO9VztYZKKt0n3Pt5+uW3++OjSP37
        ixnwEJcAVZa9EGZWKsctKukF/Jyx/gD1FLZSffKjvg==
X-Google-Smtp-Source: AMrXdXsx35UN6HQZXy9TboGur74n9jMc/+z2he86i6ImOAdpx6biI35utBvv3jLg1hykCHRZ3SrlfMNRJ1rrL/K2XSA=
X-Received: by 2002:a63:d902:0:b0:490:597e:1c0a with SMTP id
 r2-20020a63d902000000b00490597e1c0amr3600920pgg.309.1673547917553; Thu, 12
 Jan 2023 10:25:17 -0800 (PST)
MIME-Version: 1.0
References: <20221215170046.2010255-1-atishp@rivosinc.com> <20221215170046.2010255-4-atishp@rivosinc.com>
 <20230112102839.rsabb2bah5lkkx4e@orel>
In-Reply-To: <20230112102839.rsabb2bah5lkkx4e@orel>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Thu, 12 Jan 2023 10:25:06 -0800
Message-ID: <CAHBxVyFokVx0C+a8LvYrftE=JwuDAHgPRmhMQFtV9LHGqMuJgA@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] RISC-V: KVM: Return correct code for hsm stop function
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

On Thu, Jan 12, 2023 at 2:28 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Dec 15, 2022 at 09:00:38AM -0800, Atish Patra wrote:
> > According to the SBI specification, the stop function can only
> > return error code SBI_ERR_FAILED. However, currently it returns
> > -EINVAL which will be mapped SBI_ERR_INVALID_PARAM.
>
> I presume the mapping referred to here is kvm_linux_err_map_sbi().
> If so, then -EPERM isn't correct either. That maps to SBI_ERR_DENIED.
> The only thing that will ensure we get SBI_ERR_FAILURE (-1) is
> anything not handled by the kvm_linux_err_map_sbi switch, as we
> need to use the default.
>

It returns SBI_ERR_FAILURE in the next patch when kvm_linux_err_map_sbi
is removed. Maybe I should drop this patch. The next patch does the
correct thing anyways.

> Thanks,
> drew
>
> >
> > Return the appropriate linux error code.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/kvm/vcpu_sbi_hsm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> > index 2e915ca..0f8d9fe 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> > @@ -42,7 +42,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
> >  static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
> >  {
> >       if (vcpu->arch.power_off)
> > -             return -EINVAL;
> > +             return -EPERM;
> >
> >       kvm_riscv_vcpu_power_off(vcpu);
> >
> > --
> > 2.25.1
> >
