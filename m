Return-Path: <kvm+bounces-47033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D7E2ABC86C
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 22:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54FDE7A67C8
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB1321772B;
	Mon, 19 May 2025 20:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IWnlRMtC"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF53D1EDA3C;
	Mon, 19 May 2025 20:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747686720; cv=none; b=VqAVZ3ssrPJd7Aq41JRdIdwJfD8abCb09BphzDUMHbs7XGtxI5j9959ouduf0J4Yh6viYp1AFXzHrbYljg90AX+nQAxtvSoOMf9QQkm1umYQQAB0mPi9dtaZDA+VuLVlW1tfTd3jCrUAPCHx4xU+S92gEg2eIhqjl610Q9kn4Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747686720; c=relaxed/simple;
	bh=YCBCe5d3B39GNXpn1ybx8IvyeToH8/X+MQ0o/Iz8Yvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nbJSTzeNjaJVV82tWkEJH1nh5QaLA7qGzQ0QCIl5H3fuLJGR9v1z3Gyq6mo+uCI5qOMPmVZei/I0aiQZEr71m6tWiUFNHArKLm89FGwiQKHYKcwZ9iQEcwjQT9TMM7jZxbO7hqhbj9qjD28BVWphO6E1wAxxfLUuvMl4iddaI14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IWnlRMtC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=C8fppadYFccNVCB4tVO3sSETnE8kHQgA8/3tcd622uk=; b=IWnlRMtCiOqXCU1Psi3yKF+K/x
	YBTVIebYHrj2ElK/0VPJGJl1Lje/7HqcRvbCY7PDW00LQn356Qizy05OILkHlgy7GU/+vtvSmNlSF
	4YHHiGZ7myKR4Ken1LFcOX1Ad9hC5Q3/p7EPXpWNOqmRib2QBVDdAIPuMielj8zhOg1UD1Evk1nKX
	3ZERyqtIyTkRQZHgAUfJelAXZyUsWxfv0QRuatZej3UHIQVDpq09Cwm5zEaJZX0ATpGniQA91ODXT
	7U5kfj62Syw6CxvMvwHhZDo3PQHoBermUXgO9E09XAeN5lA5ihewzMNo0YRmeZMwRTRDnonuYxT3J
	9xzlh/XQ==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uH79P-00000002Lea-3gp4;
	Mon, 19 May 2025 20:31:56 +0000
Message-ID: <00a039ff-7d2e-4028-bf84-edeeaa978f13@infradead.org>
Date: Mon, 19 May 2025 13:31:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Documentation/virt/kvm: Fix TDX whitepaper footnote
 reference
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux KVM <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <20250425015150.7228-1-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250425015150.7228-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/24/25 6:51 PM, Bagas Sanjaya wrote:
> Sphinx reports unreferenced footnote warning on TDX docs:
> 
> Documentation/virt/kvm/x86/intel-tdx.rst:255: WARNING: Footnote [1] is not referenced. [ref.footnote]
> 
> Fix footnote reference to the TDX docs on Intel website to squash away
> the warning.
> 
> Fixes: 52f52ea79a4c ("Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20250409131356.48683f58@canb.auug.org.au/
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Link: https://lore.kernel.org/r/20250410014057.14577-1-bagasdotme@gmail.com
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> 
> Changes since v1 [1]:
>   - Add Reviewed-by: tag from Binbin Wu
> 
> [1]: https://lore.kernel.org/linux-doc/20250410014057.14577-1-bagasdotme@gmail.com/
> 
>  Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index de41d4c01e5c68..2ab90131a6402a 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -11,7 +11,7 @@ host and physical attacks.  A CPU-attested software module called 'the TDX
>  module' runs inside a new CPU isolated range to provide the functionalities to
>  manage and run protected VMs, a.k.a, TDX guests or TDs.
>  
> -Please refer to [1] for the whitepaper, specifications and other resources.
> +Please refer to [1]_ for the whitepaper, specifications and other resources.
>  
>  This documentation describes TDX-specific KVM ABIs.  The TDX module needs to be
>  initialized before it can be used by KVM to run any TDX guests.  The host
> 
> base-commit: 45eb29140e68ffe8e93a5471006858a018480a45

-- 
~Randy

