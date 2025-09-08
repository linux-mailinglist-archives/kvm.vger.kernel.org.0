Return-Path: <kvm+bounces-57000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3892B49879
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DF217AD85B
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 18:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D55731B838;
	Mon,  8 Sep 2025 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uVDqYo2k"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3908331B83C
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757356795; cv=none; b=USx3a3rfeRVY9IaGw4nsoDgCmGJxAKxCSmVrN+FKj0ys9vMWR1hZDv2yZfM0/JDaUOioESbYp7yhr19xvadhRrtCZKX0qDAxzSZVTDVQSb1CG2+mLhD7TvU8qfGc40S8CjM2G2fsURpayENVWimgCbAIYebMw7yDN/5WV34GwsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757356795; c=relaxed/simple;
	bh=n+kcDQ3+vBNJXH9yy4KsGGsrPRv5yQ5PGhobcmFU5b4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjNF5WlAitZhqYyFUejRnHXdR41j3u3ogP30+2tuIVP+mWWDiUiqbIX5CwiWi9nGd4Ii0SWGhwv7R5bDb+Mtw4cycuBps/7RcOSuYDYptuC3oLAonyM3cXPEJ7A++tUpOD0/tSnCQzGUxrhqC3N0MO+F7Pa10DIAt1JdSUEyyJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uVDqYo2k; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 8 Sep 2025 13:39:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757356789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mSSkUfzSfswzZdajRB69FyYQbnrZC8Vq6MBzSiKOg1I=;
	b=uVDqYo2kPvVccTUTycUnvESxtFeLruQqvqtoC4d4RWC10OQpVJTbJqKK0aYV2spJZGOzvo
	X1qaV3+KPV2Ngr2MqxDamsR6SGUCIG4MqfS6g0WeKYwfBM62CdQymg4I95tnRrKDUC+iqt
	b0CWSYq/e3Pq+G8KNgrxHBlzuWiFL34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] scripts/checkpatch.pl: Adjust the
 top_of_kernel_tree check for kvm-unit-tests
Message-ID: <20250908-3c28b520ea1cf3ffa7b03509@orel>
References: <20250724143258.52597-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724143258.52597-1-thuth@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 24, 2025 at 04:32:58PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> The copy of checkpatch.pl that we currently have in the kvm-unit-tests
> repository refuses to work without the --no-tree switch, since it looks
> for some kernel-related files to determine the top directory. Adjust this
> list of files for the kvm-unit-tests repository to make it work.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  scripts/checkpatch.pl | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index acef47b7..e858261c 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1382,9 +1382,8 @@ sub top_of_kernel_tree {
>  	my ($root) = @_;
>  
>  	my @tree_check = (
> -		"COPYING", "CREDITS", "Kbuild", "MAINTAINERS", "Makefile",
> -		"README", "Documentation", "arch", "include", "drivers",
> -		"fs", "init", "ipc", "kernel", "lib", "scripts",
> +		"COPYRIGHT", "LICENSE", "MAINTAINERS", "Makefile",
> +		"README.md", "docs", "lib", "scripts",
>  	);
>  
>  	foreach my $check (@tree_check) {
> -- 
> 2.50.1
>

Merged.

Thanks,
drew

