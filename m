Return-Path: <kvm+bounces-40004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2528EA4D8B1
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49CD7177018
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8579C1FECA0;
	Tue,  4 Mar 2025 09:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T6gtLt1Q"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980F11FDA9E
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080732; cv=none; b=swvrTeHor84odTIbxKgR7ZB0z0yTfkTbVJKjwFTur9taFqG1nPvoXfc/eWaeNAMLZnMCysxyqiqOlQWlJsub9qy0H0B3jUk9vRvH31i7Fjtpty6/OMWEuGclhnZbRQfSSpJMK9Zc/R8dg+0dZoHft+cmDGIBaIaj1/6S/2LQJG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080732; c=relaxed/simple;
	bh=IDjvk94rKZybQAlhAUWNC+KfSiGavH/5iMMsf+FGg0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvkvApXMzDvUmah9NPFf9eJPIkbvBiVZlFHLG3QxaB8X47ZWzGFWQGZU1KP7vL1B52A5rOHN36GD+moj/BlDLSqgOiPcqltM5pdH7Tyy2VVM8Y6wL9W6sIlkQmgFw5qgN1rXYcS9aWPBgihFXots371QKbLkr4I77yWJGYUtkBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T6gtLt1Q; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 4 Mar 2025 10:31:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741080717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p2F44jkdAl5d6Y7W7SiN0NSgO/b81SC9eWu/a3vDhv8=;
	b=T6gtLt1QOFeEE+xiGaE5fT9BfkFnXkZjtrFCpSRIz5I+0Kbjbwr+M403yWzs0UdhcFYNYn
	+jNkPtjr2ZPefO3qneSJblMV0G3yuxYulb7MdKorexIth3k+ZEKBVmVmIXxyTXE+tcs5As
	+snjIIVds315bfFuOpuW0SFaw22nYnQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, atishp@rivosinc.com, 
	cleger@rivosinc.com, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 0/2] riscv: Run with other QEMU models
Message-ID: <20250304-47806ddca2d868f97d63de6b@orel>
References: <20250221162753.126290-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221162753.126290-4-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 21, 2025 at 05:27:54PM +0100, Andrew Jones wrote:
> Provide a couple patches allowing a QEMU machine model other than 'virt'
> to be used. We just need to be able to override 'virt' in the command
> line and it's also nice to be able to specify a different UART address
> for any early (pre DT parsing) outputs. 
> 
> Andrew Jones (2):
>   configure: Allow earlycon for all architectures
>   riscv: Introduce MACHINE_OVERRIDE
> 
>  configure | 88 +++++++++++++++++++++++++++----------------------------
>  riscv/run |  6 ++--
>  2 files changed, 47 insertions(+), 47 deletions(-)
> 
> -- 
> 2.48.1

Merged.

Thanks,
drew

