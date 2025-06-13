Return-Path: <kvm+bounces-49432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DF2AD8FCA
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D42863A19C7
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711C81E1DF2;
	Fri, 13 Jun 2025 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rvEmwf1l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5A019D88F;
	Fri, 13 Jun 2025 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749825637; cv=none; b=diPrwT0QoAT5mdi1Tcbvwr6sWMRc5UJ7rZ7f0tVPuFT8crsWNF9y3O8tyrRWuJ8tSlqhZFGU58ik3FnEbeUibOo7do9rZfwmxNivmaQza/lIllSivxhVyC2oVfqh0o7pqS1uLSuuMZZN4CiDKFzPYCyVGbc3crKK0WtL6XzMOfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749825637; c=relaxed/simple;
	bh=ukElmnGXQREfqKEweQO3U9N27ypBuMm6P/e+FMdR3F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLXb0SuxQCphNiBZDw3PaF9YwFBO+GZShPD/fmTZtoZle0pl94XFWrIax/ALAj7XHR6i2W0+OwY1e9MYw6hk77PWs4d/94saNpFS9BGo2Cabn83CDEtTjo0nLps7eByj7gyfwB0gQTBJ32oA02BAyLtTKVOwiBzf/2Ko8cChSFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rvEmwf1l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68948C4CEE3;
	Fri, 13 Jun 2025 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749825637;
	bh=ukElmnGXQREfqKEweQO3U9N27ypBuMm6P/e+FMdR3F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rvEmwf1lFXDM9ZvmgPspADE8tJL4IEhvgbU8HfVx3ZPiT1i6its39cdN+G03Fq8P9
	 S8EbS+WBHsW8CfZqPrsK1wbrPADgopSFt0qBFkOnNw2CH1xXO8K4CjCh3cXg8hoe5t
	 IyazDn1qIEJGAPuxiLjorBKH68Dun7qzyX1ld6KCFGw4S9/53ArQscRaUAsDTWlthn
	 2k6fnhUycmeeQV/Ouk6AWU9gZafBdu3G+QHQtPVLyNJc/9FMpeqNkx3d7SCi5L6rgw
	 R8uz40PlByH7dA9RQ+IAC2JIoeiM0lst0rcEqT+CfmO5J3yplYv1AkICKuEVrdWwOE
	 EZtkBkxTrKy0g==
Date: Fri, 13 Jun 2025 20:08:26 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 10/62] KVM: SVM: Add helper to deduplicate code for
 getting AVIC backing page
Message-ID: <dgpb6ukrgoo63o3tikrwectvq5l5dcu7k7fskdkyxtr5lmbshg@eb7y7fzwc6wp>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-12-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:13PM -0700, Sean Christopherson wrote:
> Add a helper to get the physical address of the AVIC backing page, both
> to deduplicate code and to prepare for getting the address directly from
> apic->regs, at which point it won't be all that obvious that the address
> in question is what SVM calls the AVIC backing page.
> 
> No functional change intended.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)

LGTM.
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen


