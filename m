Return-Path: <kvm+bounces-56993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A45AAB496CA
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 19:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 229DF3A85A8
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 17:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4CD313E3F;
	Mon,  8 Sep 2025 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wPnCgtak"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80109311580
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 17:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757351679; cv=none; b=tkusmP/tb3fZDLfN/3DTxq6/koJ6ePtudHjGQExCG5n5tfyjm8xbOGcgNvqhxQecgtHjtUsP4u7+FxpSG6yz5UiM2p4AFsEp7zw+LP7vqEgAKoeYElmsPQ1XemI6BdGcwSJKNZ6upND57Ke/I3EkxZNEFVkYhcQaTM96fRJT9kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757351679; c=relaxed/simple;
	bh=B4C+9yloFkVSchQTEt7RESrNTorwSTdfiMnFObz5F2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/wVfehh9LmhZ3sKW9D4zS6aeISZXao8U7SiCdCJ+Xdx2t+EorYatAeCAy98GmunIAfiyzKY9fbVDHlAosrMfFWf1HoDELs5UUr9ago/B3DXeRKbjz1SZZaC1ZMeAClqdJjLoP/jDJ7qMYtGRB8HLfrelYK6QEsEytoQcnDz7zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wPnCgtak; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 8 Sep 2025 12:14:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757351674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YK4zzPxP2D7Ez3JWHkDOzCW9GlmzSguUU2GuL1cZsaE=;
	b=wPnCgtakpv+oStsnWN1RiPe88eNzaRkDp98W8mGo5JfmeQGAh0hDL2rQqT5mCwNFQgQwem
	nI+AdxOb2zdeIrgVT7JN3SMwDMs6FInDmH3a4WM50zsIhFEdObFIdVjbYExLhtCxacmGua
	A/+9f1IPGCf4ZxC28C8bR1w9Kklm6m0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] scripts/checkpatch.pl: Adjust the
 top_of_kernel_tree check for kvm-unit-tests
Message-ID: <20250908-508496ff151072c5e26157ff@orel>
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

