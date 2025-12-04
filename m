Return-Path: <kvm+bounces-65298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B15CA4B84
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 18:16:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2BE6F3059598
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 17:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1706F2F3C0E;
	Thu,  4 Dec 2025 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vkWE6mra"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D922F12D1
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764868213; cv=none; b=rD0XkESZ19yDd4AbypzxvoyFX3SfT7MYQoW0Sh8N81gc7HZa6spYITmXw8RGlT2njltb/sMtANe3UZg1MLaLna5W+1Ne6hBvfBLrT1CLOVYQk2tnGLnMf7tMoj/W/elkv7wJv2DKgmJsPkYUYYBkcJYEWBK28CF7NeKhTtKocx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764868213; c=relaxed/simple;
	bh=BWntlgu6tcfCSweNpkczVwC3zE8X9u1J7omu5fjHLCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lYkgrp4Y+oRWX6B7LfHjyyE8ZcUjpkRSs/VPGGdbetuSrUiS+KSssV70ikISVHTaL9woB5Jm0IMmgeRVXMlkQ82MotiPIz0oKSHD/5ylYDa/sO6t9k219Hlv+myWya6EWELNuekwo3knlsvIbFTkIl1R02iG8S3D2C4RBD/19r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vkWE6mra; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 4 Dec 2025 11:09:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764868192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T6h+XGJct7IZGL1jcQDWZroeewkEwO15BgcQpYlwazE=;
	b=vkWE6mra/llraEluxinq5dq5hoL7HqhQDEA0ebw4VMMsU7JOvX1lHsO9CEAw1gL5NNB6Cu
	PHJsMiIY8nsg8A7uPUv9jd14tfiQ+ttMR6znDVzmMAnppuBFMpsz+3h4jqdJ3j1umHelyI
	snOXxoVLXPYlh1wU6mfrH076Dt/kuEM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v4 08/11] arm64: selftest: update test for
 running at EL2
Message-ID: <20251204-96632701672b23ff844ba300@orel>
References: <20251204142338.132483-1-joey.gouly@arm.com>
 <20251204142338.132483-9-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204142338.132483-9-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 04, 2025 at 02:23:35PM +0000, Joey Gouly wrote:
...
> +#if defined(__aarch64__)
> +	expected_level = current_level();
> +#endif

Another way to get rid of the #ifdef would be to create a test prep
function for each target in their already present #if areas;

arm's

 static void test_exception_prep(void) { }

arm64's

 static void test_exception_prep(void)
 {
     expected_level = current_level();
 }

and then just unconditionally call

 test_exception_prep()

in main.

Thanks,
drew

