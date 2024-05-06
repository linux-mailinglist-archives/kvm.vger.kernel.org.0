Return-Path: <kvm+bounces-16686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A92258BC90E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:05:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E65C1F22895
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D91BE14290A;
	Mon,  6 May 2024 08:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="poyFDBnG"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017651420BB
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 08:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714982565; cv=none; b=e1lRsDBOnE1w7rQRSFSc2EKZKOCDkeMezjw0ZwOMYzOsxeSHk8WDlOjjRwDB7OiqJ0UWc7DjZsxV1Imqv3HQrPlyCtZ3Hdkvod9WEe4sisMs3BKLzVopQGbE6oORmlknPo2nhdctX0ulWLEfjXiENgdGir4f0Kx0w9RqoFA7LYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714982565; c=relaxed/simple;
	bh=abhO8Sc0e79cOGna9e5qlvStltGjEewIVdtTOuM2gEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDxG3XSYvyGx2L4CeeBaIi6x30U+LTtYbqAGz9Io/bh/CEmhzeOTMngS9c5FFFUcmxg2hLynu1bULWWt/ueNyDuUM+Mn5pn86bUwv4wlJLUrI4b0nFVaMw25FsJeifULjiu8i17GVA3CRujlwvYT+bbDLnReT9QFFThfVqIvxrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=poyFDBnG; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 6 May 2024 10:02:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714982561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FwG4XQ33pOhbqQSbU9r2mTNxiLfRkP6NBq9+hsdstEk=;
	b=poyFDBnGSsOIIsDzWCoe1Iy82rwwkFMdZNFN2daz+E2KLnuUZ21x7zxq3vVz/RDIDg/M3O
	CmTkkB7sTwlIYn5ByOQtaw/djuVf5jABJl9n0FIvBjwTqBAsGSMi1KF1Z2GyB8dcCS6pnJ
	y4d4AcuwWiHpptu0WePH4Bc2Zi0Reyk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v9 01/31] doc: update unittests doc
Message-ID: <20240506-c50ad09a466d9931632cadad@orel>
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-2-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240504122841.1177683-2-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, May 04, 2024 at 10:28:07PM GMT, Nicholas Piggin wrote:
> This adds a few minor fixes.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  docs/unittests.txt | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index 3192a60ec..7cf2c55ad 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -15,8 +15,8 @@ unittests.cfg format
>  
>  # is the comment symbol, all following contents of the line is ignored.
>  
> -Each unit test is defined with a [unit-test-name] line, followed by
> -a set of parameters that control how the test case is run. The name is
> +Each unit test is defined with a [unit-test-name] line, followed by a
> +set of parameters that control how the test case is run. The name is
>  arbitrary and appears in the status reporting output.
>  
>  Parameters appear on their own lines under the test name, and have a
> @@ -62,8 +62,8 @@ groups
>  groups = <group_name1> <group_name2> ...
>  
>  Used to group the test cases for the `run_tests.sh -g ...` run group
> -option. Adding a test to the nodefault group will cause it to not be
> -run by default.
> +option. The group name is arbitrary, aside from the nodefault group
> +which makes the test to not be run by default.
>  
>  accel
>  -----
> @@ -82,8 +82,10 @@ Optional timeout in seconds, after which the test will be killed and fail.
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
> +The path and value can not contain space, =, or shell wildcard characters.
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

