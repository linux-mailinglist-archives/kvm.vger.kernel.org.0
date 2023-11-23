Return-Path: <kvm+bounces-2358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 018017F5B85
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 10:43:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 172C71C20DDA
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 09:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733BE21369;
	Thu, 23 Nov 2023 09:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4vWsEzq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C252168D5
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 09:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DA5C433C7;
	Thu, 23 Nov 2023 09:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700732617;
	bh=7AO36pcPwM7Yerei+BySWxe8GlzHgN7XBTJn/OJg4eU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b4vWsEzqapyJvagQQ7JKCDgL9TwPHTZJ0qokp/EcABOred9x4CEyvwCDTTec4sNCA
	 Mf2EXMgtJ6LMdFihLS0/YM55JQ0+Awdieq+gybvO3TeALrcA7YKehM2/eKv8oj+yAS
	 I8Ok5q580ZHA6inF1VHacaiVjdhnBPC/nWQai1lY=
Date: Thu, 23 Nov 2023 09:43:33 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Zhao Ke <ke.zhao@shingroup.cn>
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
	fbarrat@linux.ibm.com, ajd@linux.ibm.com, arnd@arndb.de,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, shenghui.qu@shingroup.cn,
	luming.yu@shingroup.cn, dawei.li@shingroup.cn
Subject: Re: [PATCH v1] powerpc: Add PVN support for HeXin C2000 processor
Message-ID: <2023112317-ebook-dreamless-0cfe@gregkh>
References: <20231123093611.98313-1-ke.zhao@shingroup.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231123093611.98313-1-ke.zhao@shingroup.cn>

On Thu, Nov 23, 2023 at 05:36:11PM +0800, Zhao Ke wrote:
> HeXin Tech Co. has applied for a new PVN from the OpenPower Community
> for its new processor C2000. The OpenPower has assigned a new PVN
> and this newly assigned PVN is 0x0066, add pvr register related
> support for this PVN.
> 
> Signed-off-by: Zhao Ke <ke.zhao@shingroup.cn>
> Link: https://discuss.openpower.foundation/t/how-to-get-a-new-pvr-for-processors-follow-power-isa/477/10
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
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
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

Why is this not in sorted order?

thanks,

greg k-h

