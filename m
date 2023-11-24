Return-Path: <kvm+bounces-2450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6DBC7F86BF
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 00:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9607A282309
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 23:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664843D99A;
	Fri, 24 Nov 2023 23:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/Y8AIQ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4341987;
	Fri, 24 Nov 2023 15:35:50 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cfa36bfe0cso7840935ad.1;
        Fri, 24 Nov 2023 15:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700868950; x=1701473750; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rCTuOTZLjqU1EAi1Ot/Eoexb0bjF9zepY/pVrUGWrc=;
        b=S/Y8AIQ0rZpkxzc02ZIooQzI9HdkxOIY6juzAJIZNfYC09n61VeSzbIbjYG1H26rl+
         i/dzCB7mkGcRhcl8q3XSvYNlrtlrsxurg3TKe+kzFq/R4pFtla7R1bV1YLciawCkumSA
         ueItAo6pOyrErtRDYEFjmAxz8DJckKAOHvV1+pRcmv6/5oF4anOWbkY7uNi/s6VECm+6
         2tuXkYF0O5nQGREYHIZMabinek2RM/W0un9hPxI9Hp7iXrNm8Ffk3nzZlcCvik/W0n29
         YF73TxAfb4LFbadBXu5rXeO6IRD55yLJ6zU7Liek0rw8eADTBK1O2NO01w8JSOA+8qRI
         6m4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700868950; x=1701473750;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8rCTuOTZLjqU1EAi1Ot/Eoexb0bjF9zepY/pVrUGWrc=;
        b=pnlnjMw/1BxRcTukYM8h/SGK8mKxWbmXGOjnzLa7dRLqWhg8SqVe8XYXgMdoDBBe69
         kExMhytjEDzCApzB+yhk/EtctoLDJt/0zZuqkJHhtnR11wxrposzgXz07O8xiCmyYQeR
         hk/cuikMh0PwSN7XVBIjmzQXqw6jXt+zq41MYEOcpSQnVFbAD3SuwstPQYdeXo04fYZ7
         Uk7P/7L9bNfY23dgfmh7jn+LRAGbcxZ9ojh/GlCQrEd4YixF3reiwgkGcZ5kdb4ZyjF5
         QU7aywUW5P6Ypq39ImucW37dB2bh7AlwcdyeiNlB/I0wVMk2Oz657QvKMeyoJjzAZsYc
         FBUA==
X-Gm-Message-State: AOJu0YwYJkQ7GGrztXW8Xrb/2dfRIEBHHss5+uW4+qU8vPDrZUgsxH6R
	ix8ppjmOh1o+HI2VahXXYbG5Tmhpd/I=
X-Google-Smtp-Source: AGHT+IHAQJ2ELJ94l1wPHi56ly0865tGTj4Uqv/dSxGe9cSb6rmoKUkYL5F50RyySSQjayJuQ7H48A==
X-Received: by 2002:a17:902:868c:b0:1ce:b83f:bd0c with SMTP id g12-20020a170902868c00b001ceb83fbd0cmr8557698plo.7.1700868949824;
        Fri, 24 Nov 2023 15:35:49 -0800 (PST)
Received: from localhost (121-44-66-27.tpgi.com.au. [121.44.66.27])
        by smtp.gmail.com with ESMTPSA id gx1-20020a17090b124100b0027e289ac436sm3453860pjb.8.2023.11.24.15.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 15:35:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 25 Nov 2023 09:35:41 +1000
Message-Id: <CX7FPX15PN0F.W7PEA51B0KD6@wheely>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <shenghui.qu@shingroup.cn>,
 <luming.yu@shingroup.cn>, <dawei.li@shingroup.cn>
Subject: Re: [PATCH v1] powerpc: Add PVN support for HeXin C2000 processor
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Zhao Ke" <ke.zhao@shingroup.cn>, <mpe@ellerman.id.au>,
 <christophe.leroy@csgroup.eu>, <fbarrat@linux.ibm.com>,
 <ajd@linux.ibm.com>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>
X-Mailer: aerc 0.15.2
References: <20231123093611.98313-1-ke.zhao@shingroup.cn>
In-Reply-To: <20231123093611.98313-1-ke.zhao@shingroup.cn>

On Thu Nov 23, 2023 at 7:36 PM AEST, Zhao Ke wrote:
> HeXin Tech Co. has applied for a new PVN from the OpenPower Community
> for its new processor C2000. The OpenPower has assigned a new PVN
> and this newly assigned PVN is 0x0066, add pvr register related
> support for this PVN.
>
> Signed-off-by: Zhao Ke <ke.zhao@shingroup.cn>
> Link: https://discuss.openpower.foundation/t/how-to-get-a-new-pvr-for-pro=
cessors-follow-power-isa/477/10
> ---
> 	v0 -> v1:
> 	- Fix .cpu_name with the correct description
> ---
> ---
>  arch/powerpc/include/asm/reg.h            |  1 +
>  arch/powerpc/kernel/cpu_specs_book3s_64.h | 15 +++++++++++++++
>  arch/powerpc/kvm/book3s_pr.c              |  1 +
>  arch/powerpc/mm/book3s64/pkeys.c          |  3 ++-
>  arch/powerpc/platforms/powernv/subcore.c  |  3 ++-
>  drivers/misc/cxl/cxl.h                    |  3 ++-
>  6 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/re=
g.h
> index 4ae4ab9090a2..7fd09f25452d 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -1361,6 +1361,7 @@
>  #define PVR_POWER8E	0x004B
>  #define PVR_POWER8NVL	0x004C
>  #define PVR_POWER8	0x004D
> +#define PVR_HX_C2000	0x0066
>  #define PVR_POWER9	0x004E
>  #define PVR_POWER10	0x0080
>  #define PVR_BE		0x0070
> diff --git a/arch/powerpc/kernel/cpu_specs_book3s_64.h b/arch/powerpc/ker=
nel/cpu_specs_book3s_64.h
> index c370c1b804a9..367c9f6d9be5 100644
> --- a/arch/powerpc/kernel/cpu_specs_book3s_64.h
> +++ b/arch/powerpc/kernel/cpu_specs_book3s_64.h
> @@ -238,6 +238,21 @@ static struct cpu_spec cpu_specs[] __initdata =3D {
>  		.machine_check_early	=3D __machine_check_early_realmode_p8,
>  		.platform		=3D "power8",
>  	},
> +	{	/* 2.07-compliant processor, HeXin C2000 processor */
> +		.pvr_mask		=3D 0xffffffff,
> +		.pvr_value		=3D 0x00660000,
> +		.cpu_name		=3D "POWER8 (raw)",

If this is a raw mode, it should go with the raw POWER8 entry.
The raw vs architected entries are already out of order with
POWER6, but we should fix that too.

You may want your PVR mask to follow the other raw examples too,
but it depends on how you foresee PVR being used. Using 0xffff0000
allows you to increment the low part of the PVR and existing
kernels will continue to match it. You can then add a specific
match for the older version if you need to add special handling
for it (e.g., see how POWER9 is handled).

Do you want .cpu_name to be "POWER8 (raw)"? You could call it
"HX-C2000", as Michael suggested earlier.

> +		.cpu_features		=3D CPU_FTRS_POWER8,
> +		.cpu_user_features	=3D COMMON_USER_POWER8,
> +		.cpu_user_features2	=3D COMMON_USER2_POWER8,
> +		.mmu_features		=3D MMU_FTRS_POWER8,
> +		.icache_bsize		=3D 128,
> +		.dcache_bsize		=3D 128,
> +		.cpu_setup		=3D __setup_cpu_power8,
> +		.cpu_restore		=3D __restore_cpu_power8,
> +		.machine_check_early	=3D __machine_check_early_realmode_p8,
> +		.platform		=3D "power8",
> +	},
>  	{	/* 3.00-compliant processor, i.e. Power9 "architected" mode */
>  		.pvr_mask		=3D 0xffffffff,
>  		.pvr_value		=3D 0x0f000005,
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index 9118242063fb..5b92619a05fd 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -604,6 +604,7 @@ static void kvmppc_set_pvr_pr(struct kvm_vcpu *vcpu, =
u32 pvr)
>  	case PVR_POWER8:
>  	case PVR_POWER8E:
>  	case PVR_POWER8NVL:
> +	case PVR_HX_C2000:
>  	case PVR_POWER9:
>  		vcpu->arch.hflags |=3D BOOK3S_HFLAG_MULTI_PGSIZE |
>  			BOOK3S_HFLAG_NEW_TLBIE;
> diff --git a/arch/powerpc/mm/book3s64/pkeys.c b/arch/powerpc/mm/book3s64/=
pkeys.c
> index 125733962033..c38f378e1942 100644
> --- a/arch/powerpc/mm/book3s64/pkeys.c
> +++ b/arch/powerpc/mm/book3s64/pkeys.c
> @@ -89,7 +89,8 @@ static int __init scan_pkey_feature(void)
>  			unsigned long pvr =3D mfspr(SPRN_PVR);
> =20
>  			if (PVR_VER(pvr) =3D=3D PVR_POWER8 || PVR_VER(pvr) =3D=3D PVR_POWER8E=
 ||
> -			    PVR_VER(pvr) =3D=3D PVR_POWER8NVL || PVR_VER(pvr) =3D=3D PVR_POWE=
R9)
> +			    PVR_VER(pvr) =3D=3D PVR_POWER8NVL || PVR_VER(pvr) =3D=3D PVR_POWE=
R9 ||
> +				PVR_VER(pvr) =3D=3D PVR_HX_C2000)
>  				pkeys_total =3D 32;
>  		}
>  	}
> diff --git a/arch/powerpc/platforms/powernv/subcore.c b/arch/powerpc/plat=
forms/powernv/subcore.c
> index 191424468f10..58e7331e1e7e 100644
> --- a/arch/powerpc/platforms/powernv/subcore.c
> +++ b/arch/powerpc/platforms/powernv/subcore.c
> @@ -425,7 +425,8 @@ static int subcore_init(void)
> =20
>  	if (pvr_ver !=3D PVR_POWER8 &&
>  	    pvr_ver !=3D PVR_POWER8E &&
> -	    pvr_ver !=3D PVR_POWER8NVL)
> +	    pvr_ver !=3D PVR_POWER8NVL &&
> +		pvr_ver !=3D PVR_HX_C2000)
>  		return 0;
> =20
>  	/*
> diff --git a/drivers/misc/cxl/cxl.h b/drivers/misc/cxl/cxl.h
> index 0562071cdd4a..9ac2991b29c7 100644
> --- a/drivers/misc/cxl/cxl.h
> +++ b/drivers/misc/cxl/cxl.h
> @@ -836,7 +836,8 @@ static inline bool cxl_is_power8(void)
>  {
>  	if ((pvr_version_is(PVR_POWER8E)) ||
>  	    (pvr_version_is(PVR_POWER8NVL)) ||
> -	    (pvr_version_is(PVR_POWER8)))
> +	    (pvr_version_is(PVR_POWER8)) ||
> +		(pvr_version_is(PVR_HX_C2000)))
>  		return true;
>  	return false;
>  }

These should follow the same alignment pattern as the other lines.

Thanks,
Nick


