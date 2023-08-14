Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A439C77B41D
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbjHNI2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 04:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbjHNI1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 04:27:53 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C3FAC;
        Mon, 14 Aug 2023 01:27:44 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bd9b4f8e0eso22601965ad.1;
        Mon, 14 Aug 2023 01:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692001664; x=1692606464;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6ZLVmVU72z//BrT7M800C5eC3p9HVcgPrMw+dRpxbc=;
        b=RSyyiuay19Gb/Kevghl48H2c6NvlQVfdswzcqOls6h+pv464rgudsOF847zc2kj2+0
         NkTNJvv8i0pJldDZWVsnpo9jlyl7rYDksBhio0AN+WBW7i/SoWXc0dZrBWs3v/y/rtim
         JnB0ydKuJ4xXbDkYLiMUDQhDUm5XwRft6jt75J7Bs8tlQXKpUfYT7fiWQFlnl2G5TXGm
         mREE2eQx6c0AOXrF38XfFTbOs2NO3bX8yYLjlZGEAidTebi9dm8jrIJCMOmq/+ofl1i5
         iwTSQ7ry3daxeUEPiYzDcDi0SkAP/1e4UqCYC/IC4Pbni7M2kTTB32mvLWISEbEabNvC
         06Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692001664; x=1692606464;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M6ZLVmVU72z//BrT7M800C5eC3p9HVcgPrMw+dRpxbc=;
        b=NfRnV/nKDOhozm4u5DwPbaJPr/2YngxwzYoXuJe7rhjQhjGy2N31/adsCwL4lPcxQT
         e7zbGFWeB49tIZTROE9y5wswXVuchqKu7Yb92Tpa4o77DoL21tFHUm+T9oLdg3ntQC3m
         Irq5VsMGj56XW5/dkP6EIxGGRT3/2GKQ76tSfHxPXIYjYtcR6KOmGfyHQTmUJupH62qg
         JMu8M6a1BXU/E0EW5gnRKuSVyitDXnFMw6SHK/IlhGt8ViW3uNlG++PHTJjuNo6Z8J6w
         vYlIcl4UfxvdZoi6fspjsk9W8vQIK86P2qJwoh8CAK7fxc+fORkYqrl1oDw4oKhfAZ0Y
         wguQ==
X-Gm-Message-State: AOJu0Yyvdh58X8RLmk+vxbNFGyOIjb8UX8gO8/c1dnluyT6hN/3geiSw
        M8JdOLjGXyJ3NghhpyUy/wA=
X-Google-Smtp-Source: AGHT+IGYexny14RMiwrfYyJPyf9+GWafcn3Gl1drSRhbJL5TyoTsymt15Fg+PZzBlRE1l+Rsw6Bp8A==
X-Received: by 2002:a17:903:41c2:b0:1bb:a55d:c6e7 with SMTP id u2-20020a17090341c200b001bba55dc6e7mr7664776ple.55.1692001664017;
        Mon, 14 Aug 2023 01:27:44 -0700 (PDT)
Received: from localhost ([61.68.161.249])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902c3c400b001bdccf6b8c9sm4172836plj.127.2023.08.14.01.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 01:27:43 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 14 Aug 2023 18:27:37 +1000
Message-Id: <CUS4J2YPYFAO.3P4R24H4KFJ83@wheely>
Cc:     <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <mikey@neuling.org>, <paulus@ozlabs.org>, <vaibhav@linux.ibm.com>,
        <sbhat@linux.ibm.com>, <gautam@linux.ibm.com>,
        <kconsul@linux.vnet.ibm.com>, <amachhiw@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/6] KVM: PPC: Rename accessor generator macros
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Jordan Niethe" <jniethe5@gmail.com>,
        <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.15.2
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-3-jniethe5@gmail.com>
In-Reply-To: <20230807014553.1168699-3-jniethe5@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Aug 7, 2023 at 11:45 AM AEST, Jordan Niethe wrote:
> More "wrapper" style accessor generating macros will be introduced for
> the nestedv2 guest support. Rename the existing macros with more
> descriptive names now so there is a consistent naming convention.
>
> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>

> ---
> v3:
>   - New to series
> ---
>  arch/powerpc/include/asm/kvm_ppc.h | 60 +++++++++++++++---------------
>  1 file changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/as=
m/kvm_ppc.h
> index d16d80ad2ae4..b66084a81dd0 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -927,19 +927,19 @@ static inline bool kvmppc_shared_big_endian(struct =
kvm_vcpu *vcpu)
>  #endif
>  }
> =20
> -#define SPRNG_WRAPPER_GET(reg, bookehv_spr)				\
> +#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR_GET(reg, bookehv_spr)		\
>  static inline ulong kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
>  {									\
>  	return mfspr(bookehv_spr);					\
>  }									\
> =20
> -#define SPRNG_WRAPPER_SET(reg, bookehv_spr)				\
> +#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR_SET(reg, bookehv_spr)		\
>  static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, ulong val)	\
>  {									\
>  	mtspr(bookehv_spr, val);						\
>  }									\
> =20
> -#define SHARED_WRAPPER_GET(reg, size)					\
> +#define KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(reg, size)			\
>  static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
>  {									\
>  	if (kvmppc_shared_big_endian(vcpu))				\
> @@ -948,7 +948,7 @@ static inline u##size kvmppc_get_##reg(struct kvm_vcp=
u *vcpu)		\
>  	       return le##size##_to_cpu(vcpu->arch.shared->reg);	\
>  }									\
> =20
> -#define SHARED_WRAPPER_SET(reg, size)					\
> +#define KVMPPC_VCPU_SHARED_REGS_ACESSOR_SET(reg, size)			\
>  static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	=
\
>  {									\
>  	if (kvmppc_shared_big_endian(vcpu))				\
> @@ -957,36 +957,36 @@ static inline void kvmppc_set_##reg(struct kvm_vcpu=
 *vcpu, u##size val)	\
>  	       vcpu->arch.shared->reg =3D cpu_to_le##size(val);		\
>  }									\
> =20
> -#define SHARED_WRAPPER(reg, size)					\
> -	SHARED_WRAPPER_GET(reg, size)					\
> -	SHARED_WRAPPER_SET(reg, size)					\
> +#define KVMPPC_VCPU_SHARED_REGS_ACESSOR(reg, size)					\
> +	KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(reg, size)					\
> +	KVMPPC_VCPU_SHARED_REGS_ACESSOR_SET(reg, size)					\
> =20
> -#define SPRNG_WRAPPER(reg, bookehv_spr)					\
> -	SPRNG_WRAPPER_GET(reg, bookehv_spr)				\
> -	SPRNG_WRAPPER_SET(reg, bookehv_spr)				\
> +#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR(reg, bookehv_spr)					\
> +	KVMPPC_BOOKE_HV_SPRNG_ACESSOR_GET(reg, bookehv_spr)				\
> +	KVMPPC_BOOKE_HV_SPRNG_ACESSOR_SET(reg, bookehv_spr)				\
> =20
>  #ifdef CONFIG_KVM_BOOKE_HV
> =20
> -#define SHARED_SPRNG_WRAPPER(reg, size, bookehv_spr)			\
> -	SPRNG_WRAPPER(reg, bookehv_spr)					\
> +#define KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(reg, size, bo=
okehv_spr)	\
> +	KVMPPC_BOOKE_HV_SPRNG_ACESSOR(reg, bookehv_spr)			\
> =20
>  #else
> =20
> -#define SHARED_SPRNG_WRAPPER(reg, size, bookehv_spr)			\
> -	SHARED_WRAPPER(reg, size)					\
> +#define KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(reg, size, bo=
okehv_spr)	\
> +	KVMPPC_VCPU_SHARED_REGS_ACESSOR(reg, size)			\

Not the greatest name I've ever seen :D Hard to be concice and
consistent though, this is an odd one.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> =20
>  #endif
> =20
> -SHARED_WRAPPER(critical, 64)
> -SHARED_SPRNG_WRAPPER(sprg0, 64, SPRN_GSPRG0)
> -SHARED_SPRNG_WRAPPER(sprg1, 64, SPRN_GSPRG1)
> -SHARED_SPRNG_WRAPPER(sprg2, 64, SPRN_GSPRG2)
> -SHARED_SPRNG_WRAPPER(sprg3, 64, SPRN_GSPRG3)
> -SHARED_SPRNG_WRAPPER(srr0, 64, SPRN_GSRR0)
> -SHARED_SPRNG_WRAPPER(srr1, 64, SPRN_GSRR1)
> -SHARED_SPRNG_WRAPPER(dar, 64, SPRN_GDEAR)
> -SHARED_SPRNG_WRAPPER(esr, 64, SPRN_GESR)
> -SHARED_WRAPPER_GET(msr, 64)
> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(critical, 64)
> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg0, 64, SPRN_GSPRG=
0)
> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg1, 64, SPRN_GSPRG=
1)
> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg2, 64, SPRN_GSPRG=
2)
> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg3, 64, SPRN_GSPRG=
3)
> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(srr0, 64, SPRN_GSRR0)
> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(srr1, 64, SPRN_GSRR1)
> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(dar, 64, SPRN_GDEAR)
> +KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(esr, 64, SPRN_GESR)
> +KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(msr, 64)
>  static inline void kvmppc_set_msr_fast(struct kvm_vcpu *vcpu, u64 val)
>  {
>  	if (kvmppc_shared_big_endian(vcpu))
> @@ -994,12 +994,12 @@ static inline void kvmppc_set_msr_fast(struct kvm_v=
cpu *vcpu, u64 val)
>  	else
>  	       vcpu->arch.shared->msr =3D cpu_to_le64(val);
>  }
> -SHARED_WRAPPER(dsisr, 32)
> -SHARED_WRAPPER(int_pending, 32)
> -SHARED_WRAPPER(sprg4, 64)
> -SHARED_WRAPPER(sprg5, 64)
> -SHARED_WRAPPER(sprg6, 64)
> -SHARED_WRAPPER(sprg7, 64)
> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(dsisr, 32)
> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(int_pending, 32)
> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg4, 64)
> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg5, 64)
> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg6, 64)
> +KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg7, 64)
> =20
>  static inline u32 kvmppc_get_sr(struct kvm_vcpu *vcpu, int nr)
>  {

