Return-Path: <kvm+bounces-50495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A124AE66EC
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 070E41921D0A
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0389D2BE7C6;
	Tue, 24 Jun 2025 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="EZI/MrMO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770BE28314C
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772831; cv=none; b=SMGrrpobqqWqJZCS4P1/qTlG64RDzEaMv+ef5L15UGogyh0+mD7RBq4VQkbK56m9Yrb9ou5NJggsiLJrCqWtPTbZJB6AMc00qJ/X04N28Is9rSl5mtN0hmERikEbYSRIHbQrYrevSRTuDttM06ipHuP2q4IE8Pty0pnI/JBJbN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772831; c=relaxed/simple;
	bh=RdblSIpyqHIHC7x9AJFKZ4JmLneV50aZUMQcreRaw+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQP+aT+0SPuKkjtX0fT8HsvK1jiKtS0809nk7h14oc59EnChruBDFiBD1Jc4GH+xeAlCE0UhKzpPXjaAyeH1b1yIRIDsHQ1BAnMj903S79WfENTRc7jus6oEajT4Tpvnb33FY0GxRYwkZ/btt/TwPtqQihRNdQjLp1XOR3u0B+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=EZI/MrMO; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a57ae5cb17so3004117f8f.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 06:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750772828; x=1751377628; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J8PCCubQNcr7nCZVM93eZuCGNtXLAAyFhXBC4cgzvqo=;
        b=EZI/MrMOfrsiutCQlqKQF3LLKyBKfuhHRsRdWvJXVXU3+VVNLA9lGijlbZXh4IcP7q
         QMhiRe0da/JI28r9VUf6UTG0LmkroiipoPkSoC1vElk3cMFz9w0K/l7hpOv0wJdG3aZJ
         kfYabCAlS6mdJDL9otZ2jz2pLC47PzTOktaFYKI1IZiM4PCASv3aTWRFIsOY+J0j6Vx8
         iwAF3t3lnzRdDcDuiBwMa3JDbOJJQMSVyz2ZIlMBLfzNBbKZI7/RXm1qmsAbBFZRmS/X
         uJraJVZzYs6Vq+WepBkLXfX7a1hKmVOwchRQMtxzAnXrZsfAtBbKXFhFmVaJUdOIP4Gb
         o1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772828; x=1751377628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8PCCubQNcr7nCZVM93eZuCGNtXLAAyFhXBC4cgzvqo=;
        b=Rpx6+5c0dabE0/J5ohV+0tSzZcozivuCdSUQ5t0hhlNkQQn3r9ng17U13KWpvpnVM6
         A7NbXyw8RR5OiAdRrhQH5FWTDlofcUnM/yeeAVrKYvanopghp7dmIqhq+oXt+EY27b36
         84H5jw8U/xOYIGSEOM2vRMltf/aST8QYjLP3DGsaoXYMe4j19Ren6HJtAraM/U8nVsX3
         M62EvWfbZheYHlr8DqaOqTCi4uat/Cw3Bboq2dSk+mF1F2R6dCb8kmWQg0kHksxyBblG
         6m06Gzmd122jbkoaoA0pdO71ib7/MGt7c/PwS4B6AfC2sP3KDwkwZSkLIor3wHC6tVj2
         SC3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWrEexnZ6wLXi+Gysct7XEhWEWSZa6hSNrrl6BaVPUCKcpsAZEm+IdOEd24sXx9D81nQTg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFSWv7qiO+NLgJJVbJOsT7v1cqWkJvbw0LSBq8mojx+wEkOv4b
	IXPgvpvFjgpUbK98KH1T4n3NlSfFRGnZLMTZe789Auef9RMR7Klfa0cp5pSYaJKGxis=
X-Gm-Gg: ASbGncvX4l/AWcmLEFfX/JmSraarv5LInDt/zz9fzrG3w23GOFzULdyBidHYm5/ITUf
	iIYZqDuqrlfulLEXixESDWPNrSWBoHp7E+ny34q1cAzPZq0U813wh5UxU9f8dUKcNx6kR88t/SX
	F0D38xCW0+bMWW06eWPiJdexbERRuWNqpUyo//e8UH3zD0GCJBRX0V0ANDB8G3Ub7g72719FJvv
	UaZA2N6Okjh99Tsl6QW2UNAfjldQH8uRUna4JxdWVWGi85pAeaPZ381g9+edTpGNK6Qn6fdPGhM
	3R01W9w6eNl+TWHLjHOJzl/zSlwUU4ws8E86InnUHQb+9xSpxg==
X-Google-Smtp-Source: AGHT+IHpMvNqukUYWx9oydnYOB85GNC6fRs2uW/m2DCi770l/WC1aWkrfcHX78PHUx/VK0Unvrw5XA==
X-Received: by 2002:a05:6000:310f:b0:3a4:e8bc:594 with SMTP id ffacd0b85a97d-3a6d1191de3mr11186332f8f.8.1750772827749;
        Tue, 24 Jun 2025 06:47:07 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::5485])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45361461375sm160230815e9.14.2025.06.24.06.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:47:07 -0700 (PDT)
Date: Tue, 24 Jun 2025 15:47:06 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 4/5] KVM: riscv: selftests: Add Zicbop extension to
 get-reg-list test
Message-ID: <20250624-1960ad3d8a1108b04ea85d9d@orel>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn>
 <3591f5aed544f9026d8375651936e006b57defdb.1750164414.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3591f5aed544f9026d8375651936e006b57defdb.1750164414.git.zhouquan@iscas.ac.cn>

On Tue, Jun 17, 2025 at 09:10:42PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> The KVM RISC-V allows Zicbop extension for Guest/VM
> so add them to get-reg-list test.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index a0b7dabb5040..ebdc34b58bad 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -83,6 +83,7 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFH:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOP:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOZ:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICCRSE:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICNTR:
> @@ -253,6 +254,8 @@ static const char *config_id_to_str(const char *prefix, __u64 id)
>  		return "KVM_REG_RISCV_CONFIG_REG(isa)";
>  	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
>  		return "KVM_REG_RISCV_CONFIG_REG(zicbom_block_size)";
> +	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
> +		return "KVM_REG_RISCV_CONFIG_REG(zicbop_block_size)";
>  	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
>  		return "KVM_REG_RISCV_CONFIG_REG(zicboz_block_size)";
>  	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
> @@ -535,6 +538,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
>  		KVM_ISA_EXT_ARR(ZFH),
>  		KVM_ISA_EXT_ARR(ZFHMIN),
>  		KVM_ISA_EXT_ARR(ZICBOM),
> +		KVM_ISA_EXT_ARR(ZICBOP),
>  		KVM_ISA_EXT_ARR(ZICBOZ),
>  		KVM_ISA_EXT_ARR(ZICCRSE),
>  		KVM_ISA_EXT_ARR(ZICNTR),
> @@ -864,6 +868,11 @@ static __u64 zicbom_regs[] = {
>  	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM,
>  };
>  
> +static __u64 zicbop_regs[] = {
> +	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_CONFIG | KVM_REG_RISCV_CONFIG_REG(zicbop_block_size),
> +	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOP,
> +};
> +
>  static __u64 zicboz_regs[] = {
>  	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_CONFIG | KVM_REG_RISCV_CONFIG_REG(zicboz_block_size),
>  	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOZ,
> @@ -1012,6 +1021,8 @@ static __u64 vector_regs[] = {
>  	 .regs = sbi_sta_regs, .regs_n = ARRAY_SIZE(sbi_sta_regs),}
>  #define SUBLIST_ZICBOM \
>  	{"zicbom", .feature = KVM_RISCV_ISA_EXT_ZICBOM, .regs = zicbom_regs, .regs_n = ARRAY_SIZE(zicbom_regs),}
> +#define SUBLIST_ZICBOP \
> +	{"zicbop", .feature = KVM_RISCV_ISA_EXT_ZICBOP, .regs = zicbop_regs, .regs_n = ARRAY_SIZE(zicbop_regs),}
>  #define SUBLIST_ZICBOZ \
>  	{"zicboz", .feature = KVM_RISCV_ISA_EXT_ZICBOZ, .regs = zicboz_regs, .regs_n = ARRAY_SIZE(zicboz_regs),}
>  #define SUBLIST_AIA \
> @@ -1130,6 +1141,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
>  KVM_ISA_EXT_SUBLIST_CONFIG(zicbom, ZICBOM);
> +KVM_ISA_EXT_SUBLIST_CONFIG(zicbop, ZICBOP);
>  KVM_ISA_EXT_SUBLIST_CONFIG(zicboz, ZICBOZ);
>  KVM_ISA_EXT_SIMPLE_CONFIG(ziccrse, ZICCRSE);
>  KVM_ISA_EXT_SIMPLE_CONFIG(zicntr, ZICNTR);
> @@ -1204,6 +1216,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&config_zfh,
>  	&config_zfhmin,
>  	&config_zicbom,
> +	&config_zicbop,
>  	&config_zicboz,
>  	&config_ziccrse,
>  	&config_zicntr,
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

