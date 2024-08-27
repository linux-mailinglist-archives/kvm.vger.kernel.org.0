Return-Path: <kvm+bounces-25173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCB096121F
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E9251C2385E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D9C1C86FB;
	Tue, 27 Aug 2024 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EAQD3Qxw"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34D11BFE07
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772351; cv=none; b=JxhL1VJbAEVn3JYdhLDmJ3U6UPQHKg5ZJJOCpokmNfUCdaxRlTzXHiYB9y1dQ97r4yK5mshlsoSUQ71XN9z2n5uahuknIYEGlot6VNF6tliHVVVYiYNky3CgygG+DKwvdxgzoP2jScZQqEimyOWi6lCN66wqokxDSmnyj+64vJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772351; c=relaxed/simple;
	bh=3+QvEBa4uv7l/a5MQPY7+uvjT1ii80eJCdS4sVGH4GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEpOOXVxutpL0N0R2OYBYiT7BKsbT/2YM40i/1hHVVYaGJO2SgXSQ+z/hTjPDTKdaKdsWR35uurI8SHNMSKXuxMXov2yl0JteZV6LpmnWtSovHA4W65hx/sQytDB5siFkmc1Fg1wh6y4IpsGVpLZsZaR71r/RO0ZEJBgTeFu9aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EAQD3Qxw; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 27 Aug 2024 17:25:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724772347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wMNSMSKGCcwLdG9pFGhHriyzPikWhB5ZJa2DXnKuoVg=;
	b=EAQD3Qxw0DYwUenlMolaqx5OkVBEr84fuZ3AoKmPlaJgyfaA6VOteBI8Fkjed0uhcgaAuW
	iBHUtfC22G0+qwiGy/FUGedEghQgQcO5+AM0TVV8flmPMSYFLU9aJIWwNTCfFX/MYJXYn8
	G0mGc11+1zEpIaDH84Fv+wTePoJxOeU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH] Added prefix pop at bottom of DBCN test
 function.
Message-ID: <20240827-35ad2f4724351f0ee5512b8e@orel>
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


This patch summary has a period. I've removed it. I also rewrote the
commit message. Just repeating the summary isn't helpful. I wrote

    The number of pops needs to balance the number of pushes, but
    check_dbcn was missing a pop, resulting in a dbcn prefix being output
    on following non-dbcn tests. Add the pop.

Thanks,
drew

On Sun, Aug 25, 2024 at 10:33:09PM GMT, Cade Richard wrote:
> Added report prefix pop at bottom of DBCN test function.
> 
> Fixes: https://lore.kernel.org/kvm/20240812141354.119889-10-andrew.jones@linux.dev/#t
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

