Return-Path: <kvm+bounces-7713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49918845A10
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D1441C24FB1
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4145D499;
	Thu,  1 Feb 2024 14:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IY0JCblx"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635435D484
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706797320; cv=none; b=EA+pMIlM29Rm5L9tjle/fLF45YnrThdSq4egb4rSZRrZkDch3wmL50TveNOQbpNxDQTgm68zvycghfQjoRZQ7ve788OA0/0kCosGRkbhL6syn5c4Tz3K3Va2jEZYOEL6yHyvldWWOYu9Ycww67h5e6Nz47rrs+/cFfEmRzKXddg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706797320; c=relaxed/simple;
	bh=iYpaBLMCZhWUlKKMK/hEdPZU0MmOK7apbaU89nBfUK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CgScMyKW9GDfSHysGRkiN7UNrvEavOEAaAEERfEVrKOmVXiTWd+LjBbwlqNjFgbTL5S0paCDb1rIjH6ZtuTcS4tddHsWeGNk85SH1u3E1SQoaQeRXKTwn3UqC1pRkPGxUHujJgm7FF/FNJJXUzPVfAW/+v5p8F2KQsJHScJ5o2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IY0JCblx; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 1 Feb 2024 15:21:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706797315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=li1OLAP9tm8IKwrzUYcrtTm1BWvR/doBNI8fjZVmwOA=;
	b=IY0JCblxMhsuUxe33LqDtiMTOOqbDw5N2eeZb0zKrjJ63/Bi88hkv8msNEFTucB3UOChMR
	wG06YIys+PgU2bresGtRxYhXog1DMrMlEVCveYaMouJw9QngcikZwNS9mjfkBjgSY/rGX7
	J3CR1h+M6Rk5GMRrLAzcIIF1CbKE2sk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, ajones@ventanamicro.com, anup@brainfault.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
Subject: Re: Re: [kvm-unit-tests PATCH v2 16/24] arm/arm64: Share memregions
Message-ID: <20240201-522cd6aa1f8162c0c50f63b0@orel>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-42-andrew.jones@linux.dev>
 <730ca018-cb7b-4ef8-b544-7afdfce03bc8@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <730ca018-cb7b-4ef8-b544-7afdfce03bc8@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 01, 2024 at 01:03:54PM +0100, Eric Auger wrote:
> Hi Drew,
> 
> On 1/26/24 15:23, Andrew Jones wrote:
...
> > -static void mem_regions_add_assumed(void)
> > -{
> > -	phys_addr_t code_end = (phys_addr_t)(unsigned long)&_etext;
> > -	struct mem_region *r;
> > -
> > -	r = mem_region_find(code_end - 1);
> > -	assert(r);
> > +	struct mem_region *code, *data;
> >  
> >  	/* Split the region with the code into two regions; code and data */
> > -	mem_region_add(&(struct mem_region){
> > -		.start = code_end,
> > -		.end = r->end,
> > -	});
> > -	*r = (struct mem_region){
> > -		.start = r->start,
> > -		.end = code_end,
> > -		.flags = MR_F_CODE,
> > -	};
> > +	memregions_split((unsigned long)&_etext, &code, &data);
> > +	assert(code);
> > +	code->flags |= MR_F_CODE;
> I think this would deserve to be split into several patches, esp. this
> change in the implementation of
> 
> mem_regions_add_assumed and the init changes. At the moment this is pretty difficult to review
>

Darn, you called me out on this one :-) I had a feeling I should split out
the introduction of memregions_split(), since it was sneaking a bit more
into the patch than just code motion as advertised, but then I hoped I
get away with putting a bit more burden on the reviewer instead. If you
haven't already convinced yourself that the new function is equivalent to
the old code, then I'll respin with the splitting and also create a new
patch for the 'mem_region' to 'memregions' rename while at it (so there
will be three patches instead of one). But, if you're already good with
it, then I'll leave it as is, since patch splitting is a pain...

Thanks,
drew

