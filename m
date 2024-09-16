Return-Path: <kvm+bounces-26994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6593697A067
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9D17B21277
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6471215534E;
	Mon, 16 Sep 2024 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKNrUKt/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5680813A89B;
	Mon, 16 Sep 2024 11:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486724; cv=none; b=S/BTYM9puEG4AR+3L9HEcAwXsGFTKIuH5rckeCOGHtbDjNMfeoyzhJUzwt0/DdAlIHlHwHzTgcfGOabU7gSZjMjWaDy6wjgmYRBkvC1ZrjWBhdLjuC6Cx4MXkJ/hLBFnxfTJWSmtD/IG+mPBfefYfU34cNFFRYzwzvyihUGA2RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486724; c=relaxed/simple;
	bh=064gb9l0g0swz2X7Fk6lnmve2IFc+u8+yCp3Jb8Kk/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQZaeWqn2KlFAU10YaivbeWT600VLFhGQ4qZdXTnuvqTtpWh+suQSGol5zsyQHMgG+cu3cWzR2/qxqwj+8JGMrRYSIBFQJjCIHFX7NKbkjFbCgGYDFqGEpI5r6BPu2p07c/Rcs5W+DqIWJoDaZJVEF5P4DlzCjXq9u0UGXgIUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKNrUKt/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B995DC4CEC4;
	Mon, 16 Sep 2024 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726486724;
	bh=064gb9l0g0swz2X7Fk6lnmve2IFc+u8+yCp3Jb8Kk/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yKNrUKt/sxtsystZjRsNQXsC6xsYpiGjj5B62w8RfpVzKxpFibPK8yUCBiD7zRxgx
	 Ql2PooFqZm60RttG1cQ1lt+M5Ay6UNuBSYZBejjOylTtEVXGhRlo1LRbg+aQrQL1kj
	 xchsFXSk1YczxNl8GllBMEMY+ys2wuzdRAu8zACs=
Date: Mon, 16 Sep 2024 13:38:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: WangYuli <wangyuli@uniontech.com>
Cc: stable@vger.kernel.org, sashal@kernel.org, maobibo@loongson.cn,
	guanwentao@uniontech.com, chenhuacai@loongson.cn,
	zhaotianrui@loongson.cn, kernel@xen0n.name, kvm@vger.kernel.org,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.10] LoongArch: KVM: Remove unnecessary definition of
 KVM_PRIVATE_MEM_SLOTS
Message-ID: <2024091628-gigantic-filth-b7b7@gregkh>
References: <796C6F09389EF61B+20240916092052.422948-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796C6F09389EF61B+20240916092052.422948-1-wangyuli@uniontech.com>

On Mon, Sep 16, 2024 at 05:20:52PM +0800, WangYuli wrote:
> From: Yuli Wang <wangyuli@uniontech.com>
> 
> [ Upstream commit 296b03ce389b4f7b3d7ea5664e53d432fb17e745 ]
> 
> 1. "KVM_PRIVATE_MEM_SLOTS" is renamed as "KVM_INTERNAL_MEM_SLOTS".
> 
> 2. "KVM_INTERNAL_MEM_SLOTS" defaults to zero, so it is not necessary to
> define it in LoongArch's asm/kvm_host.h.
> 
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=bdd1c37a315bc50ab14066c4852bc8dcf070451e
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=b075450868dbc0950f0942617f222eeb989cad10
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index c87b6ea0ec47..d348005d143e 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -26,8 +26,6 @@
>  
>  #define KVM_MAX_VCPUS			256
>  #define KVM_MAX_CPUCFG_REGS		21
> -/* memory slots that does not exposed to userspace */
> -#define KVM_PRIVATE_MEM_SLOTS		0
>  
>  #define KVM_HALT_POLL_NS_DEFAULT	500000

Why is this needed in the stable tree?

thanks,

greg k-h

