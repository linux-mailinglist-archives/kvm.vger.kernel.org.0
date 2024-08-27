Return-Path: <kvm+bounces-25159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 168409610F3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:15:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7CB1282713
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E404B1C57BC;
	Tue, 27 Aug 2024 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DrhmaJpG"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE7F1C6F71
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 15:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771660; cv=none; b=RR59FfQWjbmuMtX4FSSlz8mhMNv6uEtybgcw+TnW/ayYPax4t/+aSxKEnirdaFIFCOLxBRKKhgB1RhQMhkvlroklAWmpgppLw9mx0bf5DeWfokm+zYxCKQQAIhRM5JOUn/6CWwA5O2K1rsbo6DWwd0tmHiHsWr2D4z1+0X0iS5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771660; c=relaxed/simple;
	bh=le06kK5mC9fj+aor/1y7cXZX3sFwMvtXY1/h4WGQD/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFWN/YegRK51CS5TdeAQplMNMjkHcB//qZx9wy+shnhdw9RL0gH7nRwKqqRKbhqzqZjyaCYrxSyQpkTbc1n1RGekWrLsMsM0tFln4bxXMxgRG0znnodYY0lWwDAIjWdrT8ONt7MvNHwysJ01oJS0ffzIMeNOLzku/KM8kHJe1ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DrhmaJpG; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 27 Aug 2024 17:14:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724771655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xMEa5WJjDs2HLVwNJ7TxKfZwh2HpGdIrz+kO+iRmXIc=;
	b=DrhmaJpGlKqHIWFGmPccby09ztpRs9YRzaMLk6ziAkNN0IT/45zg2Dgc+C1yue38TBz/TD
	FysISnd4b/WQ69NkVMK4s3IvYjLp22udGYoauisc9Osa45agYoV4g2SM3ZnnX/c5vMssAJ
	19OaTMDO2ILK5dEkFI0WE7dCvWFCF8M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH] Added prefix pop at bottom of DBCN test
 function.
Message-ID: <20240827-b1109aec9abbba8ca66e1738@orel>
References: <20240826053309.10802-1-cade.richard@berkeley.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826053309.10802-1-cade.richard@berkeley.edu>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 25, 2024 at 10:33:09PM GMT, Cade Richard wrote:
> Added report prefix pop at bottom of DBCN test function.
> 
> Fixes: https://lore.kernel.org/kvm/20240812141354.119889-10-andrew.jones@linux.dev/#t

This should be

Fixes: ce58d3a45d96 ("riscv: sbi: Add dbcn write test")

and without a space before the s-o-b.

I've fixed it up while queuing.

Thanks,
drew

> 
> Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> ---
>  riscv/sbi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 36ddfd48..01697aed 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -418,6 +418,7 @@ static void check_dbcn(void)
>  	report(ret.value == 0, "expected ret.value (%ld)", ret.value);
>  
>  	report_prefix_pop();
> +	report_prefix_pop();
>  }
>  
>  int main(int argc, char **argv)
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

