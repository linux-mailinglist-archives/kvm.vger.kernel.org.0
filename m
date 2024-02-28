Return-Path: <kvm+bounces-10239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A6A86AEAF
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2321298D39
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5C973526;
	Wed, 28 Feb 2024 12:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l67zPqdS"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4767D73501
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 12:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709121850; cv=none; b=q8IrOTdD8xs5bTIFblWWzLi12+P+wE3oWF5cQg9kHJsH/TzRaUjLzqKTAot75zVR0ddJuqZS7AE4x28dYB1Z9XNquADQn0S6dVLqFKZgdZbOS9IPX0g+ONZ+ig1oD0iS3rAH6UGofvsf2M1forDJQnrUJQCARg3iwFGanf/TrP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709121850; c=relaxed/simple;
	bh=wcxA1xRCcmu7PzykPdlK9fm1ZDpzC5pNYLFpXFqclKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7mEaKqLJQ1mZn4M1u7LGXnMK26LZEC5P5bd9IQYTCrVvj92T/6RSyqAimL8kFCzM3jusrzbV8F6RWfo1ZK09mU8OGz6xUEW2aXk78LaGf9dEG829lIcmVu5fuEbqxpN7O0aqemJs6PKuJ2iZlqpkJNO110Om5EFePsRQtZ6WOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l67zPqdS; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 13:04:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709121846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u00ElXyXOufHqCLdR4uMNx31NnYXH97xBaIzPn3Hn+Y=;
	b=l67zPqdSKtGoXYc+m4nQIKaTTSUf0vYLMvkl+3A0cFqzEHJseYddhhbsBPv8aD8vFPa3MK
	vmUkCF6oS0azcDZcFeUaAOGWmvDfsiyqi4gsivWoZ7Ha4cVQFiAaEi/DagWI3JyTGQDgQL
	dF6KVqm6B+ItD6g+f0TKIVJCPnfoVL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 25/32] common/sieve: Support machines
 without MMU
Message-ID: <20240228-c35ae38d8f0f7a2132b51689@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-26-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226101218.1472843-26-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 26, 2024 at 08:12:11PM +1000, Nicholas Piggin wrote:
> Not all powerpc CPUs provide MMU support. Define vm_available() that is
> true by default but archs can override it. Use this to run VM tests.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  common/sieve.c      | 14 ++++++++------
>  lib/ppc64/asm/mmu.h |  1 -
>  lib/ppc64/mmu.c     |  2 +-
>  lib/vmalloc.c       |  7 +++++++
>  lib/vmalloc.h       |  2 ++
>  5 files changed, 18 insertions(+), 8 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

