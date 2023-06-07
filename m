Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A549725681
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 09:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjFGHz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 03:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbjFGHzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 03:55:20 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B68173B;
        Wed,  7 Jun 2023 00:55:18 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d18d772bdso7777771b3a.3;
        Wed, 07 Jun 2023 00:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686124518; x=1688716518;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSpR+cWU04iRIoIReN5SfCnN4k/gkf4T7uvt8nSNQ5w=;
        b=oGPsGi/kB7XwSqq7iU3ikH7ANmaWp5fJfzu8ttnXixDBJMsgJeNgTvhazoLKJcnlop
         /LxmwemCky3Q0zQOcXRByVyfE9voZr0baEM1blWDytpx2pz7p3FMGnj1O8Xxy+OMT5gx
         yc+kvv/xw0rLy33UFvOva+ITsP9ALgsd18VItFkqHSaRaZb3PTAmApGbbJAEZF/qjjkm
         gwSiWzE+YRTGnZulkCIx2l2Q4DIqujehnjBGDnpHpldrFTzVWy01kc2oExZ3OKvuDSA+
         ZeYDzOEhk/Era3l/lcTJ+f2IV4/D80QcDwYEdufdt99YTwsr6+PmaMISnFMtvVUF0Qww
         h8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686124518; x=1688716518;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xSpR+cWU04iRIoIReN5SfCnN4k/gkf4T7uvt8nSNQ5w=;
        b=JybJ+Z6M2Y+XJbnGNiXZDSgpzYDl8vPIItTjfbeXZ6miTGfg7v3hUSkhzD9pclMbvi
         IjwLGME8TSzKzeGpjVqEs3YUvUWg3EF0ljrWyWxxmUeBbw/ZPBbc+KPviq3sBSR4lR+q
         ncJv1eAEfIpxRfR4L/XcVYKAnFsPPx6yrT9SUxm6AQVqB/EEllZ8ZIn0DlFUKkXvFqmf
         7/MM4ELnGJoondQplDd4qcl6nAM2vve/LeVVthupr0gkcUL+ojCZEV+fzHqsIeAxButE
         6Ds64RVCBIwTdGaIIsfL9vxmeDV3bZ7Bxibr9qmxiTr0kV8fY1z1CXRPxyHGXbM2ZpuP
         BqtA==
X-Gm-Message-State: AC+VfDwcdllLENqIfHa+adU4p2MGI2oGQKkD3qiykTdq8kPvAneyd0/l
        TfKmhrDYGi4cH5EF2l1IJSA=
X-Google-Smtp-Source: ACHHUZ6F0FHKx24DZo61vm3joxKHGiju4BRrc09r1K50G+vG6nnk2V5FN7x8IhdjXhh3SJHP4o0k6w==
X-Received: by 2002:a05:6a20:244c:b0:117:1c72:2f06 with SMTP id t12-20020a056a20244c00b001171c722f06mr2867153pzc.38.1686124518163;
        Wed, 07 Jun 2023 00:55:18 -0700 (PDT)
Received: from localhost (193-116-206-233.tpgi.com.au. [193.116.206.233])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090a12ca00b00246cc751c6bsm743437pjg.46.2023.06.07.00.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 00:55:17 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 07 Jun 2023 17:55:11 +1000
Message-Id: <CT6996Z3V83E.21I51JGIDHPOE@wheely>
Cc:     <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <mikey@neuling.org>, <paulus@ozlabs.org>,
        <kautuk.consul.1980@gmail.com>, <vaibhav@linux.ibm.com>,
        <sbhat@linux.ibm.com>
Subject: Re: [RFC PATCH v2 2/6] KVM: PPC: Add fpr getters and setters
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Jordan Niethe" <jpn@linux.vnet.ibm.com>,
        <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.14.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
 <20230605064848.12319-3-jpn@linux.vnet.ibm.com>
In-Reply-To: <20230605064848.12319-3-jpn@linux.vnet.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Jun 5, 2023 at 4:48 PM AEST, Jordan Niethe wrote:
> Add wrappers for fpr registers to prepare for supporting PAPR nested
> guests.
>
> Signed-off-by: Jordan Niethe <jpn@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/kvm_book3s.h | 31 +++++++++++++++++++++++++++
>  arch/powerpc/include/asm/kvm_booke.h  | 10 +++++++++
>  arch/powerpc/kvm/book3s.c             | 16 +++++++-------
>  arch/powerpc/kvm/emulate_loadstore.c  |  2 +-
>  arch/powerpc/kvm/powerpc.c            | 22 +++++++++----------
>  5 files changed, 61 insertions(+), 20 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include=
/asm/kvm_book3s.h
> index 4e91f54a3f9f..a632e79639f0 100644
> --- a/arch/powerpc/include/asm/kvm_book3s.h
> +++ b/arch/powerpc/include/asm/kvm_book3s.h
> @@ -413,6 +413,37 @@ static inline ulong kvmppc_get_fault_dar(struct kvm_=
vcpu *vcpu)
>  	return vcpu->arch.fault_dar;
>  }
> =20
> +static inline u64 kvmppc_get_fpr(struct kvm_vcpu *vcpu, int i)
> +{
> +	return vcpu->arch.fp.fpr[i][TS_FPROFFSET];
> +}
> +
> +static inline void kvmppc_set_fpr(struct kvm_vcpu *vcpu, int i, u64 val)
> +{
> +	vcpu->arch.fp.fpr[i][TS_FPROFFSET] =3D val;
> +}
> +
> +static inline u64 kvmppc_get_fpscr(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.fp.fpscr;
> +}
> +
> +static inline void kvmppc_set_fpscr(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	vcpu->arch.fp.fpscr =3D val;
> +}
> +
> +
> +static inline u64 kvmppc_get_vsx_fpr(struct kvm_vcpu *vcpu, int i, int j=
)
> +{
> +	return vcpu->arch.fp.fpr[i][j];
> +}
> +
> +static inline void kvmppc_set_vsx_fpr(struct kvm_vcpu *vcpu, int i, int =
j, u64 val)
> +{
> +	vcpu->arch.fp.fpr[i][j] =3D val;
> +}
> +
>  #define BOOK3S_WRAPPER_SET(reg, size)					\
>  static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	=
\
>  {									\
> diff --git a/arch/powerpc/include/asm/kvm_booke.h b/arch/powerpc/include/=
asm/kvm_booke.h
> index 0c3401b2e19e..7c3291aa8922 100644
> --- a/arch/powerpc/include/asm/kvm_booke.h
> +++ b/arch/powerpc/include/asm/kvm_booke.h
> @@ -89,6 +89,16 @@ static inline ulong kvmppc_get_pc(struct kvm_vcpu *vcp=
u)
>  	return vcpu->arch.regs.nip;
>  }
> =20
> +static inline void kvmppc_set_fpr(struct kvm_vcpu *vcpu, int i, u64 val)
> +{
> +	vcpu->arch.fp.fpr[i][TS_FPROFFSET] =3D val;
> +}
> +
> +static inline u64 kvmppc_get_fpr(struct kvm_vcpu *vcpu, int i)
> +{
> +	return vcpu->arch.fp.fpr[i][TS_FPROFFSET];
> +}
> +
>  #ifdef CONFIG_BOOKE
>  static inline ulong kvmppc_get_fault_dar(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 2fe31b518886..6cd20ab9e94e 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -636,17 +636,17 @@ int kvmppc_get_one_reg(struct kvm_vcpu *vcpu, u64 i=
d,
>  			break;
>  		case KVM_REG_PPC_FPR0 ... KVM_REG_PPC_FPR31:
>  			i =3D id - KVM_REG_PPC_FPR0;
> -			*val =3D get_reg_val(id, VCPU_FPR(vcpu, i));
> +			*val =3D get_reg_val(id, kvmppc_get_fpr(vcpu, i));
>  			break;
>  		case KVM_REG_PPC_FPSCR:
> -			*val =3D get_reg_val(id, vcpu->arch.fp.fpscr);
> +			*val =3D get_reg_val(id, kvmppc_get_fpscr(vcpu));
>  			break;
>  #ifdef CONFIG_VSX
>  		case KVM_REG_PPC_VSR0 ... KVM_REG_PPC_VSR31:
>  			if (cpu_has_feature(CPU_FTR_VSX)) {
>  				i =3D id - KVM_REG_PPC_VSR0;
> -				val->vsxval[0] =3D vcpu->arch.fp.fpr[i][0];
> -				val->vsxval[1] =3D vcpu->arch.fp.fpr[i][1];
> +				val->vsxval[0] =3D kvmppc_get_vsx_fpr(vcpu, i, 0);
> +				val->vsxval[1] =3D kvmppc_get_vsx_fpr(vcpu, i, 1);
>  			} else {
>  				r =3D -ENXIO;
>  			}
> @@ -724,7 +724,7 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
>  			break;
>  		case KVM_REG_PPC_FPR0 ... KVM_REG_PPC_FPR31:
>  			i =3D id - KVM_REG_PPC_FPR0;
> -			VCPU_FPR(vcpu, i) =3D set_reg_val(id, *val);
> +			kvmppc_set_fpr(vcpu, i, set_reg_val(id, *val));
>  			break;
>  		case KVM_REG_PPC_FPSCR:
>  			vcpu->arch.fp.fpscr =3D set_reg_val(id, *val);
> @@ -733,8 +733,8 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
>  		case KVM_REG_PPC_VSR0 ... KVM_REG_PPC_VSR31:
>  			if (cpu_has_feature(CPU_FTR_VSX)) {
>  				i =3D id - KVM_REG_PPC_VSR0;
> -				vcpu->arch.fp.fpr[i][0] =3D val->vsxval[0];
> -				vcpu->arch.fp.fpr[i][1] =3D val->vsxval[1];
> +				kvmppc_set_vsx_fpr(vcpu, i, 0, val->vsxval[0]);
> +				kvmppc_set_vsx_fpr(vcpu, i, 1, val->vsxval[1]);
>  			} else {
>  				r =3D -ENXIO;
>  			}
> @@ -765,7 +765,7 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
>  			break;
>  #endif /* CONFIG_KVM_XIVE */
>  		case KVM_REG_PPC_FSCR:
> -			vcpu->arch.fscr =3D set_reg_val(id, *val);
> +			kvmppc_set_fpscr(vcpu, set_reg_val(id, *val));
>  			break;
>  		case KVM_REG_PPC_TAR:
>  			kvmppc_set_tar(vcpu, set_reg_val(id, *val));
> diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emul=
ate_loadstore.c
> index 059c08ae0340..e6e66c3792f8 100644
> --- a/arch/powerpc/kvm/emulate_loadstore.c
> +++ b/arch/powerpc/kvm/emulate_loadstore.c
> @@ -250,7 +250,7 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
>  				vcpu->arch.mmio_sp64_extend =3D 1;
> =20
>  			emulated =3D kvmppc_handle_store(vcpu,
> -					VCPU_FPR(vcpu, op.reg), size, 1);
> +					kvmppc_get_fpr(vcpu, op.reg), size, 1);
> =20
>  			if ((op.type & UPDATE) && (emulated !=3D EMULATE_FAIL))
>  				kvmppc_set_gpr(vcpu, op.update_reg, op.ea);
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index ca9793c3d437..7f913e68342a 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -938,7 +938,7 @@ static inline void kvmppc_set_vsr_dword(struct kvm_vc=
pu *vcpu,
>  		val.vsxval[offset] =3D gpr;
>  		VCPU_VSX_VR(vcpu, index - 32) =3D val.vval;
>  	} else {
> -		VCPU_VSX_FPR(vcpu, index, offset) =3D gpr;
> +		kvmppc_set_vsx_fpr(vcpu, index, offset, gpr);
>  	}
>  }
> =20

Is there a particular reason some reg sets are broken into their own
patches? Looking at this hunk you think the VR one got missed, but it's
in its own patch.

Not really a big deal but I wouldn't mind them all in one patch. Or at
least the FP/VR/VSR ine one since they're quite regular and similar.

Thanks,
Nick
