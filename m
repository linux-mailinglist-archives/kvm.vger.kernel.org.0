Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D826BE8A2
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCQLy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCQLyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:54:54 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F332B624
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:54:51 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r11so19340121edd.5
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1679054090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZfMRNa8FGIfSyoZfd7pNoeUbhvxMUZ3twk8JQtru4g=;
        b=qp5ET6DrTIyWL2fuyhLZ6S8luibcTZS89HQWeG5N2nlLMokpiCK5elK1fWS/l1+0sy
         NgIwpXLPGXTDamDiuGsVafQ2EICWkyuGx0C62fEmLHpjgdQ5vr4uT+Py2ey5Ys9zlHFK
         7vw7SqmFdKcGaoHTkCa1MqJ4fAgNUa+CV3m7VkTwYtLn0mKYnK1z8e4+n2HBxIkvdIr6
         iQxZ5SLshxHhfAmUvlqzqtLkWGOeEnsk7lmWBGwHiPl5SySQPiCvo44IdY0fEvAUogqk
         MMpXtucluoRl6/JDJiF8JR07lN9hm/tv1myRRWErQwqboe3onHVDKNqH+3W8MpYi9ZYd
         nsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679054090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FZfMRNa8FGIfSyoZfd7pNoeUbhvxMUZ3twk8JQtru4g=;
        b=r9dZrcB49EKbf/fFc+HboNhzZE31qAD7bCli2Ka/c2IXnshMZ8tjuDqDbjCLbnRp+S
         qwaVZTUln/G8V0wVByUzQjoY5KrMIz9jEBFTvRoevO6EkxvT60hRtxpQ+ZQq8+hkCPR2
         PDI9ERsboSmY9KwqeXWeWs+4eQuZNijI4FhjRmi3SyPY8xpeA3Bj4HUz+6Z/tV4Dzmft
         8/HdJQHAm/fSUUG4qcR0oycHWRTY0t2EAXgLli0sC/+63+V17zB1MOr59npuBjq8bzNF
         OjWrUhtQ7oe9CFuTTeqcsjgBJY7z/WtTFZlxrW71pNXM9mPYGFbdS19aKOwyWoikoGF+
         7GFg==
X-Gm-Message-State: AO0yUKXBwLuJAUKVJaFAMMipVN6dEvGesAIsJsNBXKb9sgZXJzYR0J6D
        6fcqQj3Ucx7N4y6z+osPyqKx4LQrIH+uGBbkg/g+CQ==
X-Google-Smtp-Source: AK7set9r1yJmif39um2UY6hYIh0CxgK4zk2KfkaIEQg56O8rtyFHNyMFbFX4EJuK0xaPwNEjtviX3o54r8Yp668IyEg=
X-Received: by 2002:a17:906:9b94:b0:931:8502:ad29 with SMTP id
 dd20-20020a1709069b9400b009318502ad29mr1578620ejc.13.1679054089719; Fri, 17
 Mar 2023 04:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113538.10878-1-andy.chiu@sifive.com> <20230317113538.10878-18-andy.chiu@sifive.com>
In-Reply-To: <20230317113538.10878-18-andy.chiu@sifive.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 17 Mar 2023 17:24:37 +0530
Message-ID: <CAAhSdy2yFkxpM3CyCvXcbUwDeMnF3BDRVt28fSuTwAkDUThT0A@mail.gmail.com>
Subject: Re: [PATCH -next v15 17/19] riscv: kvm: Add V extension to KVM ISA
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 5:08=E2=80=AFPM Andy Chiu <andy.chiu@sifive.com> wr=
ote:
>
> From: Vincent Chen <vincent.chen@sifive.com>
>
> Add V extension to KVM isa extension list to enable supporting of V
> extension on VCPUs.
>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu.c             | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 92af6f3f057c..3e3de7d486e1 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -105,6 +105,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_SVINVAL,
>         KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
>         KVM_RISCV_ISA_EXT_ZICBOM,
> +       KVM_RISCV_ISA_EXT_V,
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7d010b0be54e..a7ddb7cf813e 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -57,6 +57,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
>         [KVM_RISCV_ISA_EXT_H] =3D RISCV_ISA_EXT_h,
>         [KVM_RISCV_ISA_EXT_I] =3D RISCV_ISA_EXT_i,
>         [KVM_RISCV_ISA_EXT_M] =3D RISCV_ISA_EXT_m,
> +       [KVM_RISCV_ISA_EXT_V] =3D RISCV_ISA_EXT_v,
>
>         KVM_ISA_EXT_ARR(SSTC),
>         KVM_ISA_EXT_ARR(SVINVAL),
> --
> 2.17.1
>
