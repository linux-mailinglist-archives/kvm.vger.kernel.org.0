Return-Path: <kvm+bounces-26995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F391F97A06A
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A78D281827
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7433B155392;
	Mon, 16 Sep 2024 11:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOYAGf+O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7505F145B0C;
	Mon, 16 Sep 2024 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486747; cv=none; b=fr9rTpSYN18tyBY2wuiHsh5FNaMpV5tsqyv3Hhf6N774b5nkhLtZj8aTQN8BZkpFQeDn6BFgsY7i7jgHC9CczJYdKIVYzCW64LAPRlrUe9Q6wQWQl+xKwEY3fi3qsqc6gb7uMK2DDAhQZp4fttV2gVB/u5d0e9n0RWSfi3e4sEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486747; c=relaxed/simple;
	bh=B4POFSJV8VB5Kr5o010X/Du2R1CtR5kqeZrqDxL9QAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edfYT3IRVtOOPdkUTuiAa6j+flp84ke5IJIIRqCF4Kd8ZKkUo5O8nDQABMXZFbAcBi3ieilPW36ACOQlEcjeqU3lfPNvrgcN3D96VFXN/yngSIQRzmnW/fC+guM8jtLV/TPe0/BKfyrwaJ7BLFGTx0QLAyMHqUvxNIwu7gZsuos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOYAGf+O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD19EC4CEC4;
	Mon, 16 Sep 2024 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726486747;
	bh=B4POFSJV8VB5Kr5o010X/Du2R1CtR5kqeZrqDxL9QAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GOYAGf+ODsqdkGZubVl7Qn6eUqZPb1IpeIPywRU9/1AyxQBOL3gBWR4cdxUmyaPUt
	 O4yqnFs0kgFKdQ2WcN7xzSSrmnA7plQsEYR0ePZb2iR6X4lMpxFsTSfdI7iwmPIEZc
	 oGQbHF/c73S/1K7fPmbz4T7Rwla9xXfMWfLsrAW0=
Date: Mon, 16 Sep 2024 13:39:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: WangYuli <wangyuli@uniontech.com>
Cc: stable@vger.kernel.org, sashal@kernel.org, maobibo@loongson.cn,
	guanwentao@uniontech.com, zhangdandan@uniontech.com,
	chenhuacai@loongson.cn, zhaotianrui@loongson.cn, kernel@xen0n.name,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6.10] LoongArch: KVM: Remove undefined a6 argument
 comment for kvm_hypercall()
Message-ID: <2024091647-absolve-wharf-f271@gregkh>
References: <5B13B2AF7C2779A7+20240916092857.433334-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B13B2AF7C2779A7+20240916092857.433334-1-wangyuli@uniontech.com>

On Mon, Sep 16, 2024 at 05:28:57PM +0800, WangYuli wrote:
> From: Dandan Zhang <zhangdandan@uniontech.com>
> 
> [ Upstream commit 494b0792d962e8efac72b3a5b6d9bcd4e6fa8cf0 ]
> 
> The kvm_hypercall() set for LoongArch is limited to a1-a5. So the
> mention of a6 in the comment is undefined that needs to be rectified.
> 
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> Signed-off-by: WangYuli <wangyuli@uniontech.com>
> --
> Changlog:
>  *v1 -> v2: Correct the commit-msg format.
> ---
>  arch/loongarch/include/asm/kvm_para.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
> index 4ba2312e5f8c..6d5e9b6c5714 100644
> --- a/arch/loongarch/include/asm/kvm_para.h
> +++ b/arch/loongarch/include/asm/kvm_para.h
> @@ -28,9 +28,9 @@
>   * Hypercall interface for KVM hypervisor
>   *
>   * a0: function identifier
> - * a1-a6: args
> + * a1-a5: args
>   * Return value will be placed in a0.
> - * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
> + * Up to 5 arguments are passed in a1, a2, a3, a4, a5.
>   */
>  static __always_inline long kvm_hypercall0(u64 fid)
>  {
> -- 
> 2.43.0
> 
> 

Again, why is this needed?

thanks,

greg k-h

