Return-Path: <kvm+bounces-3582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1508C8057E6
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:52:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45D181C21100
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A6365EDE;
	Tue,  5 Dec 2023 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Pc1w3e1H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B8EAF
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 06:52:23 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1d048d38881so24979655ad.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 06:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701787943; x=1702392743; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ByBv3ux7sze9gldwQ6PK9+560Yvk3QCH1GMjLl4z4k=;
        b=Pc1w3e1Hni4YdmcO+x1KacSawo1R/hzgJVYeaWLgxCbOI8v3F7dwbW5I02g7NABU/v
         g0nDu5PqnxHMBBNSdvDm8YopXrbVgOJKv2FLv2qynoChr7+KrsYnD9Wv4KOfBNlNUhbX
         9tTXABRCOBAKEQ8htgd3wNdzrXGleOGT7KDAMsnCZi32uKpkH8V6V4M3GO9IsBwM3HLJ
         10/CCXrOi7bz5ZaTwLhBvVweW+8yzCoOcopak44eTWG/0f21suWJLcjFyhndGSakgXs5
         XnDRVwYRshcrufrizcnQk6BCXuE974mJCd71wNVpvTL3loKOqWYKQv1Hl6fG1rujnr1f
         Ai2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701787943; x=1702392743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ByBv3ux7sze9gldwQ6PK9+560Yvk3QCH1GMjLl4z4k=;
        b=rXhuHiSxiovWohmHr+9FhBl1SP0f/B1hmt+P5T9XoVkpWFxLAqmgBxcHneprRCXSeZ
         EL9HpWl1+wdWKYo/3wntTnEGj8+iIR5DSwltx+cJixt66Adw8RMTmiKM2LhlIF5yvNfN
         vgm85Bl5QAiAH/4Ts/bsPh1XYFgpx8WxeELj88MUGnlWt8DwOK1fZidB3GQDNYlBVnMH
         frIoDznPy9PqV9+72UzqCBhgqvWRbKwwAqsVLBuiBjnDzNPxwVr/yTVL1Y0+OFzrmXqB
         AiPdD4tf9HQQgj20jSfh10C2dEEyjJL1+vzJ6y2C9IzoEnf9e0yWAQ4tWn+mUi0z+bzZ
         H6ng==
X-Gm-Message-State: AOJu0Yzgulr2Zz5pITuUBPQUh/Z6LKaBGrD1hm+pmIL04Lz3OtgKqOkA
	llaMIuV21E2/+rfOgRXJVNuiWTZPvdwdYxhPfncdp+KY+AqTnha6pvQ=
X-Google-Smtp-Source: AGHT+IHhi6+245LxN6wxFFUT7G88D+PGNxnZ/aL+ySaphfzC/60aeu9G8myzUfq1e1jVmI9xpLAsj5ja7gw2S6aRPOA=
X-Received: by 2002:a17:902:8f8c:b0:1d0:6ffd:ceb8 with SMTP id
 z12-20020a1709028f8c00b001d06ffdceb8mr3489772plo.113.1701787942672; Tue, 05
 Dec 2023 06:52:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205135041.2208004-1-dbarboza@ventanamicro.com> <20231205135041.2208004-4-dbarboza@ventanamicro.com>
In-Reply-To: <20231205135041.2208004-4-dbarboza@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 5 Dec 2023 20:22:10 +0530
Message-ID: <CAK9=C2WaY--O303KfWK0ty8Pe_SipVqAbvARc4hODC=CAhCTnw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST
To: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, anup@brainfault.org, atishp@atishpatra.org, 
	palmer@dabbelt.com, ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 7:21=E2=80=AFPM Daniel Henrique Barboza
<dbarboza@ventanamicro.com> wrote:
>
> Add all vector CSRs (vstart, vl, vtype, vcsr, vlenb) in get-reg-list.
>
> Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_onereg.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f8c9fa0c03c5..712785a8f22b 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -986,6 +986,35 @@ static int copy_sbi_ext_reg_indices(u64 __user *uind=
ices)
>         return num_sbi_ext_regs();
>  }
>
> +static inline unsigned long num_vector_regs(const struct kvm_vcpu *vcpu)
> +{
> +       if (!riscv_isa_extension_available(vcpu->arch.isa, v))
> +               return 0;
> +
> +       /* vstart, vl, vtype, vcsr, vlenb; */
> +       return 5;

We have two type of vector ONE_REG IDs:
KVM_REG_RISCV_VECTOR_CSR_REG()
KVM_REG_RISCV_VECTOR_REG()

You are only returning count of KVM_REG_RISCV_VECTOR_CSR_REG()
but not including KVM_REG_RISCV_VECTOR_REG()

Refer, kvm_riscv_vcpu_vreg_addr() implementation in
arch/riscv/kvm/vcpu_vector.c


> +}
> +
> +static int copy_vector_reg_indices(const struct kvm_vcpu *vcpu,
> +                               u64 __user *uindices)
> +{
> +       int n =3D num_vector_regs(vcpu);
> +       u64 reg, size;
> +
> +       for (int i =3D 0; i < n; i++) {
> +               size =3D IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 : KV=
M_REG_SIZE_U64;
> +               reg =3D KVM_REG_RISCV | size | KVM_REG_RISCV_VECTOR | i;
> +
> +               if (uindices) {
> +                       if (put_user(reg, uindices))
> +                               return -EFAULT;
> +                       uindices++;
> +               }

Same as above.

> +       }
> +
> +       return n;
> +}
> +
>  /*
>   * kvm_riscv_vcpu_num_regs - how many registers do we present via KVM_GE=
T/SET_ONE_REG
>   *
> @@ -1001,6 +1030,7 @@ unsigned long kvm_riscv_vcpu_num_regs(struct kvm_vc=
pu *vcpu)
>         res +=3D num_timer_regs();
>         res +=3D num_fp_f_regs(vcpu);
>         res +=3D num_fp_d_regs(vcpu);
> +       res +=3D num_vector_regs(vcpu);
>         res +=3D num_isa_ext_regs(vcpu);
>         res +=3D num_sbi_ext_regs();
>
> @@ -1045,6 +1075,11 @@ int kvm_riscv_vcpu_copy_reg_indices(struct kvm_vcp=
u *vcpu,
>                 return ret;
>         uindices +=3D ret;
>
> +       ret =3D copy_vector_reg_indices(vcpu, uindices);
> +       if (ret < 0)
> +               return ret;
> +       uindices +=3D ret;
> +
>         ret =3D copy_isa_ext_reg_indices(vcpu, uindices);
>         if (ret < 0)
>                 return ret;
> --
> 2.41.0
>
>

Regards,
Anup

