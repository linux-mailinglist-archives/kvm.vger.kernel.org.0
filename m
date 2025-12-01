Return-Path: <kvm+bounces-64991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AAAE0C96724
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 10:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6BD604E24A7
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 09:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFC1303A38;
	Mon,  1 Dec 2025 09:45:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DB93016FD;
	Mon,  1 Dec 2025 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.175.24.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764582308; cv=none; b=ftArw/nSpytJe+QpMeSaz9jfj6nMdeuWTHSD+fuekY6q1Sd84lprXc0z9nKCCeoXtTNYhSFWRpTW7EIAjekotlv3Ir4mua//cjBcLYHigoSWuULp/K8hsM2SwWJrnDBJv8unvyO6FkWlp4kzyVi+4TOduAFdt2rREM7ZJB7N3hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764582308; c=relaxed/simple;
	bh=rdtCxxB5s1rRp0qlqZHRr7DJ+FojzBoesEnYtkJmFIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcDHu9Gg9IN27yB+RsPLcThUJtOtyQMOJoKcV9iOPpBwajI957HFOI+pqW3Ia3xfyKieqlbZajmJLHtSmlNKck6jWIqbf4GfVYcHPup5fNAPK8q7rj28cWBtsnuLdyokHKwfXqa6vjWx50vSse88fRl0sGaHV6MOMOqRwNFvJQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de; spf=pass smtp.mailfrom=alpha.franken.de; arc=none smtp.client-ip=193.175.24.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alpha.franken.de
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1vQ0Sn-0002g6-00; Mon, 01 Dec 2025 10:44:57 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
	id 50392C088F; Mon,  1 Dec 2025 10:43:53 +0100 (CET)
Date: Mon, 1 Dec 2025 10:43:53 +0100
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Yury Norov <yury.norov@gmail.com>
Cc: Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: kvm: simplify kvm_mips_deliver_interrupts()
Message-ID: <aS1jWTUu9SDEoF2g@alpha.franken.de>
References: <20250716172918.26468-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716172918.26468-1-yury.norov@gmail.com>

On Wed, Jul 16, 2025 at 01:29:17PM -0400, Yury Norov wrote:
> The function opencodes for_each_set_bit() macro, which makes it bulky.
> Using the proper API makes all the housekeeping code go away.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/mips/kvm/interrupt.c | 20 ++------------------
>  1 file changed, 2 insertions(+), 18 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

