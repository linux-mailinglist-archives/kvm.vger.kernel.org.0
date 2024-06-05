Return-Path: <kvm+bounces-18875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2832C8FC954
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1C7E1F2542C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB8319006E;
	Wed,  5 Jun 2024 10:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nHBN5NGv"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2661946D0
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 10:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717584390; cv=none; b=F2d+a1TFZxHQQckzVxipEtBwfdo9HYULXiwtppSkoLw4sYU0WJJacZC8ujsZy+s/FOnoOZ/v0OnNLsrFp+O30Fx7xlWemeU0q8NssewRsFDZ5eKtchn37D+1Uv8Np8UH8JIchIfmj+300iFVmhhOIZNKgcJGBCAqDEpLdUv6yGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717584390; c=relaxed/simple;
	bh=w4nbwf1fkjR6df1JlxgDCRN5XRuO4jgMJmFRsKB/FJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4AzDxoe81tV2ANtHC8+EfIw5/jiZ+nnr+Twwp8lDuk6Gv/fpQjm+yJ50JHPnaEqNat0spgLtYCdiDT5CWRMdZfAicMIUk8Y9Jbp/gbziOTJDlZEjZ+7NWl+1zlGyNRD2ic7aThKgMyq7SQ2b+sDMqRve9Iq8WhH/PPY+VdJDuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nHBN5NGv; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: npiggin@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717584384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oeZOrDdPvqaNkdgEaDcGEA/8o23c5PyARpk1x/wmB9I=;
	b=nHBN5NGvhiFnktliSO68iI7k1L0yidrm1xBKWsOJZ4Jujb1cHTj+hXAUHmDjbLjNaaSLoy
	jvEgNcDGPyjOjvfunLpqbyienjDNHxeFlR5T7ZBr1UOC/UcCB2cCaWjCQVZdjF7G+KHSZB
	wRuDY+RHFY3uBJbJnGh9nxMw8hKogzQ=
X-Envelope-To: thuth@redhat.com
X-Envelope-To: kvm@vger.kernel.org
Date: Wed, 5 Jun 2024 12:46:19 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/2] doc: update unittests doc
Message-ID: <20240605-95f3d6f2456d9d5d10d6ff31@orel>
References: <20240605080942.7675-1-npiggin@gmail.com>
 <20240605080942.7675-2-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605080942.7675-2-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 05, 2024 at 06:09:40PM GMT, Nicholas Piggin wrote:
> Document the special groups, check path restrictions, and a small fix
> for check option syntax.
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  docs/unittests.txt | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index 6ff9872cf..c4269f623 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -69,8 +69,11 @@ groups
>  groups = <group_name1> <group_name2> ...
>  
>  Used to group the test cases for the `run_tests.sh -g ...` run group
> -option. Adding a test to the nodefault group will cause it to not be
> -run by default.
> +option. The group name is arbitrary, except for these special groups:
> +- Tests in the "nodefault" group are not run by default (with no -g option).
> +- Tests in the "migration" group are run with the migration harness and
> +  are expected to make migrate_*() calls.
> +- Tests in the "panic" group expect QEMU to enter the GUEST_PANICKED state.
>  
>  accel
>  -----
> @@ -89,8 +92,10 @@ Optional timeout in seconds, after which the test will be killed and fail.
>  
>  check
>  -----
> -check = <path>=<<value>
> +check = <path>=<value>
>  
>  Check a file for a particular value before running a test. The check line
>  can contain multiple files to check separated by a space, but each check
>  parameter needs to be of the form <path>=<value>
> +
> +The path and value cannot contain space, =, or shell wildcard characters.
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

