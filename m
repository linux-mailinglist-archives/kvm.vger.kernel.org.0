Return-Path: <kvm+bounces-5263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 662A081EB37
	for <lists+kvm@lfdr.de>; Wed, 27 Dec 2023 02:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09A66B22227
	for <lists+kvm@lfdr.de>; Wed, 27 Dec 2023 01:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EBBF1FD1;
	Wed, 27 Dec 2023 01:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBeI/rl4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD06A1FA3;
	Wed, 27 Dec 2023 01:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48555C433C8;
	Wed, 27 Dec 2023 01:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703639500;
	bh=O2jkYF1Uj7zpLQqP5wedmD/DGNDodYvLwbo4m5DcCbU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rBeI/rl4c4s+waM0bn3V1PHFedX3Vi7PRDnxv9QeDGB9m09QU6HcCJv0/jVWGH4Xx
	 aFX3F7qxi0VlM/6bYKK1jSoYmdk2atswEf7ftMC0S6DZe9nOPxXZHiwSMhgetJmWii
	 zAOGp0mDOApvVjFx0H7wm+3geKQlo4/CDTIUUH93RF7HCHnTgwE7AJb037bhqX19bI
	 OmjygCEsmDbNRN4shHr9/Mj1GsXv59bQv5S7G3ff8ie9XlbNtQJyuzTiVwSZ5Q4mj2
	 j/bUnl6gOG2/1iX6jXMF37pjVcpoyElqpb7ynNZPUDoo3orHPEBAZZrAbbHZDXhAMs
	 8nrUQ8Nl2ClGA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-55539cac143so687242a12.0;
        Tue, 26 Dec 2023 17:11:40 -0800 (PST)
X-Gm-Message-State: AOJu0YzSqm5kDdNH8mhkteyjdEAc3n1Wup9QBRsSDXx61YEYn6PWlnBd
	VEU7T+oLYrQW+zBpOtAOzUFw7mHJZPrQ+9nhhRU=
X-Google-Smtp-Source: AGHT+IFGDLNTovKccMjGnj1dKlUkdGC9CUXSVpCMzr7YKgYTkRFKkf9d7Dtax+Ivfz9rF6+dzvNuFAPbZU7sNYaSwCE=
X-Received: by 2002:a17:906:3397:b0:a26:ee66:7928 with SMTP id
 v23-20020a170906339700b00a26ee667928mr1671728eja.105.1703639498782; Tue, 26
 Dec 2023 17:11:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231227010742.21539-1-rdunlap@infradead.org>
In-Reply-To: <20231227010742.21539-1-rdunlap@infradead.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 27 Dec 2023 09:11:28 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4JVEa9hhD0WrDC0YA0Q55T3-SKQCHyxNm=KR3Tb_oeQA@mail.gmail.com>
Message-ID: <CAAhV-H4JVEa9hhD0WrDC0YA0Q55T3-SKQCHyxNm=KR3Tb_oeQA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: add a return kvm_own_lasx() stub
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Randy,

Could you please fix kvm_own_lsx() together?

Huacai

On Wed, Dec 27, 2023 at 9:07=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
> The stub for kvm_own_lasx() when CONFIG_CPU_HAS_LASX is not defined
> should have a return value since it returns an int, so add
> "return -EINVAL;" to the stub. Fixes the build error:
>
> In file included from ../arch/loongarch/include/asm/kvm_csr.h:12,
>                  from ../arch/loongarch/kvm/interrupt.c:8:
> ../arch/loongarch/include/asm/kvm_vcpu.h: In function 'kvm_own_lasx':
> ../arch/loongarch/include/asm/kvm_vcpu.h:73:39: error: no return statemen=
t in function returning non-void [-Werror=3Dreturn-type]
>    73 | static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { }
>
> Fixes: 118e10cd893d ("LoongArch: KVM: Add LASX (256bit SIMD) support")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: Huacai Chen <chenhuacai@loongson.cn>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: kvm@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/loongarch/include/asm/kvm_vcpu.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -- a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/=
asm/kvm_vcpu.h
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -70,7 +70,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu);
>  void kvm_save_lasx(struct loongarch_fpu *fpu);
>  void kvm_restore_lasx(struct loongarch_fpu *fpu);
>  #else
> -static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { }
> +static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { return -EINVAL; =
}
>  static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
>  static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
>  #endif
>

