Return-Path: <kvm+bounces-18598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1338D7BDA
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 08:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 032361C214BD
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 06:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36192D052;
	Mon,  3 Jun 2024 06:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rR3DkdbR"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EBF4A0C
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 06:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717397290; cv=none; b=fOHuRB5O3obzqRWGSe1s57zYaxRT8YP1qH39lnZVy/KMi5EeWm4BPs/BVYk1JFnA9WyEx6SW/uyCQ3CMWmod7tn2OYozsB55VRBIe7oQegGh0l0fE/JTUieO0jjnYV+5HjmWvLT/R/Prp8FnQlg2FhYWb93NmVbcvVuZoiaIzV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717397290; c=relaxed/simple;
	bh=5wo9U6ItRXh5/+2XiBdBKZ0+crrMxRvEYtKuWL8T9eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFnmthwAdvq4YYBEa6W1SAdgDQSmQ+tjCti11zqWIFT26KhDn64D1d7KTK+ydsOKQH8giNBAu+RH2PuNjWDcwTTK6MDgoFZeC3sj17wtQ8r99V7dDpiBO6t8OiebvnMEcNhunUhQQ3GUae6xPo8RdslAhDRG0gq/p4DMWzS+1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rR3DkdbR; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: npiggin@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717397286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fvobece6xgCphl76l0V+mK4xdYAk4rER7HXdsgWyqM0=;
	b=rR3DkdbRpFi/lLWAr/srDaLbfK3oG8UAvs2fjDFlASqhZugm//PO9F+JAAptgydZpPLrmQ
	jTQqxLiE4C1B+LEmrkWsr2V7rKfgh+jKvDEkBjVSyCOpwK8CQxcbA6lSy0EWCz0B5ATjZL
	EJV/UXTt10xct+rN9pjGPm9shF0It1g=
X-Envelope-To: thuth@redhat.com
X-Envelope-To: kvm@vger.kernel.org
Date: Mon, 3 Jun 2024 08:47:59 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/4] doc: update unittests doc
Message-ID: <20240603-740192cec3e3e8cdaaf69275@orel>
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-3-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602122559.118345-3-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 02, 2024 at 10:25:56PM GMT, Nicholas Piggin wrote:
> Document the special groups, check path restrictions, and a small fix
> for check option syntax.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  docs/unittests.txt | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index 6ff9872cf..509c529d7 100644
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
> +  expects the test to make migrate_*() calls.

expect make migrate_*() calls.

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
> +The path and value can not contain space, =, or shell wildcard characters.

cannot

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

