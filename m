Return-Path: <kvm+bounces-15242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C0E78AAD00
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2B8EB21B2D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8A97EEF6;
	Fri, 19 Apr 2024 10:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f2Em38O7"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB5199C2
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713523353; cv=none; b=RH8lh2Qk3tb/zRok2sc4xdqjJIAGhtLOlktb4qkuISlJwED7wTZ9b8kj5O24bZlfD9Ivih/sVxbhyaEZySmbqScy5XpfGH54to9C7Ni5FGH9UpH7w39kQjB3xOiNuwtBq/eSUNg3UrsBAXkhRj2jEVBk2DXwo5nW5jFYVL9sD7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713523353; c=relaxed/simple;
	bh=eDN8B7vdXHwlNJoe/WDXXWlnUfUQdaEakDgBlr9KsI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Smb3ng2cvN4Czmk3u7WLPu5P+QZv+Kiu8kWanEFhiO18OXqVbpReaXKB5kPlMjufbtCA3WjdZK0rAS+o7gPaZfa5bbr6r2JRxsIM6blGI4gjCjPlQdTCLDqilJCA7GoWYNHgL5oGWqF+9BUMfqgMnk40I3UhPEV6mtT4g7eAUoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f2Em38O7; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 19 Apr 2024 12:42:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713523348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=410Xx19TaAlkv7Gj5GrIDN3k6kFOzo44JZf6xOpjPQM=;
	b=f2Em38O7T6XlgbsTLix7uJTXz/JSMEs3nY6Re4F8nCx9OePowDHFSijKEP4gcK/Ue65eQd
	al43HaoujbilPl/pEdZyp00BrKdEJNgi+Dqzan3WGv9qtrVQK1X3gdka/0JwMHFAJ+i1zp
	kjbb9Hwe1JFOf1Py5gAZHxKWFf7yqWQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jan Richter <jarichte@redhat.com>
Cc: kvm@vger.kernel.org, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] test_migrate_unmapped_collection test
 fails during skip
Message-ID: <20240419-66ae844635470865974b13a7@orel>
References: <20240419083104.158311-1-jarichte@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419083104.158311-1-jarichte@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 10:13:18AM +0200, Jan Richter wrote:
> The test_migrate_unmapped_collection test fails when the errata
> requirements are not met and the test should be skipped. Instead of
> being skipped, the test returns `ERROR: Test exit before migration
> point.`
> 
> This is caused by changes in commit fa8914bccc22 ("migration: Add a
> migrate_skip command") which changes the behaviour of skipped migration
> tests. This fixes this issue by adding migrate_skip() method to
> test_migrate_unmapped_collection.
> 
> Fixes: fa8914bccc22 ("migration: Add a migrate_skip command")
> Signed-off-by: Jan Richter <jarichte@redhat.com>
> ---
> Changes from v1->v2:
> 1. typo fix meet/met
> 2. commit reference changed
> 3. Fixes tag added
> 
>  arm/gic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index bbf828f1..256dd80d 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -829,6 +829,7 @@ static void test_migrate_unmapped_collection(void)
>  	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
>  		report_skip("Skipping test, as this test hangs without the fix. "
>  			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
> +		migrate_skip();
>  		return;
>  	}
>  
> -- 
> 2.44.0
>

Merged.

Thanks,
drew

