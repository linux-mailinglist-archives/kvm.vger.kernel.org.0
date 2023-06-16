Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CBC733106
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 14:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343914AbjFPMUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 08:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344690AbjFPMTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 08:19:55 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA85430C7
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 05:19:51 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-519c0ad1223so830232a12.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 05:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1686917990; x=1689509990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MosOklUNgvqifdhsCUo4moVzcaCroJZ7UdTzOr+75BI=;
        b=tn+xpS97rpRmozcSmZ93QTrcVSiGR7+pnTvkfQclJXzJkSBGm2Gio/mKTPAvvRwAf7
         XUpchRP7CGqXom3QfZK6Ijz/gz/XFisw+mVfGycjiN9XVlrXgixRvX5gsd71ha8PCH7y
         JtPpnUE6oJ4IkOuEciaFtAyNmuOGih3we2eDacdzrotGazkr4LiieTd59HEvFZAuXbeC
         CUYZmiFDelVGIPFVggmVjYwNxAewy9/EmXQ9DTVwmyG5OhUbvBw/DFaUPJ4nMZxOOGNm
         T/TrcbViUevAXI5SrWgmxp3TZXpRXOHqIfi0q9ZnoUHUu5oMEsYWKpyyDQM50nxvv7LJ
         4c7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686917990; x=1689509990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MosOklUNgvqifdhsCUo4moVzcaCroJZ7UdTzOr+75BI=;
        b=PjS5slFGd5sf5+ivmDZZdl5cNosLtHKXx+HSdscnXeooClKMJgMJ7Xd1DC21OnVk7r
         +VZL6q5H0WVxhc6zOBF0EPeDiFnKMZEkuVwQsp5gwsvn5+UXafwJgGizeLZOLVP7FHAc
         Fc8I8iwUsrkjp/ClYazj23b1hREmy714Lum74Bbt5WNRpBYXyPRs6zvp03yrdm/RYzZq
         QR9SjbbMYasjoxRxAzP5O84HRq3uJeVfvrIn0sK5a0R9r+VwATOSMzj7tOa9aJUvshSZ
         nUSBctw7p/2MUh8RhQuWZopazMgUON4w8TXbSBzTUxzOuBKp5I+pDD6qcXsxysAwgqvO
         vrjQ==
X-Gm-Message-State: AC+VfDxaEFieiF7khZgnDrjkWLHfpJTbNJNNkANHuZ5dO89Q24nfEsYy
        j2qVYzRg4jIhCytbV17QuECH2Ikz1T2IxpSm95cn7g==
X-Google-Smtp-Source: ACHHUZ77UHbOd8DerdFF1eVNKYlRvZqSimLHBKpk7GsJkukHoGREIquwh5hCTlR7VqcS9XcVtYy0oubeMcluj5L2UMQ=
X-Received: by 2002:a17:907:6d83:b0:96f:d345:d100 with SMTP id
 sb3-20020a1709076d8300b0096fd345d100mr1728831ejc.59.1686917990056; Fri, 16
 Jun 2023 05:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230616115410.166244-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20230616115410.166244-1-ben.dooks@codethink.co.uk>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 16 Jun 2023 17:49:38 +0530
Message-ID: <CAAhSdy0-WJVBbJJoePLRooRFquiJKRizpEO6ATTnds9iNJou-Q@mail.gmail.com>
Subject: Re: [PATCH] riscv: kvm: define vcpu_sbi_ext_pmu in header
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        palmer@dabbelt.com, atishp@atishpatra.or
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 5:24=E2=80=AFPM Ben Dooks <ben.dooks@codethink.co.u=
k> wrote:
>
> Sparse is giving a warning about vcpu_sbi_ext_pmu not being
> defined, so add a definition to the relevant header to fix
> the following:
>
> arch/riscv/kvm/vcpu_sbi_pmu.c:81:37: warning: symbol 'vcpu_sbi_ext_pmu' w=
as not declared. Should it be static?
>
> Fixes: 3e5e56c60a1477 ("riscv: kvm: move extern sbi_ext declarations to a=
 header")
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 3 +++
>  arch/riscv/kvm/vcpu_sbi.c             | 4 +---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> index 4278125a38a5..b94c7e958da7 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -66,4 +66,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext=
_hsm;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
>
> +#ifdef CONFIG_RISCV_PMU_SBI
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> +#endif
>  #endif /* __RISCV_KVM_VCPU_SBI_H__ */
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index e52fde504433..c973d92a0ba5 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -20,9 +20,7 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext=
_v01 =3D {
>  };
>  #endif
>
> -#ifdef CONFIG_RISCV_PMU_SBI
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> -#else
> +#ifndef CONFIG_RISCV_PMU_SBI
>  static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu =3D {
>         .extid_start =3D -1UL,
>         .extid_end =3D -1UL,
> --
> 2.39.2
>
