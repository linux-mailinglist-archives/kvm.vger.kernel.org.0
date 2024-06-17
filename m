Return-Path: <kvm+bounces-19784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF2B90B340
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6F691C22E67
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DD713DB99;
	Mon, 17 Jun 2024 14:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W363cnYA"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00C013D272
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 14:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718633605; cv=none; b=oyBvKPrvvwIFApuXAB7FZLfW6Lv5dMYIesNn6D6S8+/futRn9L1pK8urZKy+IwdKToT2M7Z4579+SO3eo1JdD+XflwIN5aMXBgTpfMHdc7TEQkaVVwgg2oSXVibw4ckvH8Zv+Qs6XeOq9gfP6a7yh7M9YYoLUiA6fyt7ZtT3dcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718633605; c=relaxed/simple;
	bh=dbor9ZQRQYaa8NHm6oKq0ZWKd/yjSrOaYo9EyClchu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPlZne1eDn+7Ybql/p06NfXlFxfYun8OeRMZjCZomdmWdfkfbwigTINAtTOF7ysbJzn9UOrJiIcnSGiEsuXF6mI/v+JLNU1TrHbvcYZI97MAWo9ZF0D5iZwMCjgU877tDtizkKbPr9WjHSiE80YaDju5a46PSWN5PxHfgShnn4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W363cnYA; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: npiggin@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718633601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=owfz/S1E22Nunlov8mHF0N3t9ihGFemnnCxIuVLgXj0=;
	b=W363cnYAENs8pOrimNAY6laIxuLVThlcJ19aBWsHG1t6ZtjE0jyTfQhwOnEkvw6kYw1G9w
	Z6xZ8md7sWqNowKtYAL70IVS08Y1zv9YDAV3qPO6Y2V+GXSRBH2uMs5G7NFiSmkTn7Qadi
	VjtXmwgDjqYjjar9qSYQ2rtI/dNr5Ko=
X-Envelope-To: thuth@redhat.com
X-Envelope-To: lvivier@redhat.com
X-Envelope-To: linuxppc-dev@lists.ozlabs.org
X-Envelope-To: kvm@vger.kernel.org
Date: Mon, 17 Jun 2024 16:13:18 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v10 12/15] scripts/arch-run.bash: Fix
 run_panic() success exit status
Message-ID: <20240617-5516212afb51c9139b5623a9@orel>
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-13-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612052322.218726-13-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 12, 2024 at 03:23:17PM GMT, Nicholas Piggin wrote:
> run_qemu_status() looks for "EXIT: STATUS=%d" if the harness command
> returned 1, to determine the final status of the test. In the case of
> panic tests, QEMU should terminate before successful exit status is
> known, so the run_panic() command must produce the "EXIT: STATUS" line.
> 
> With this change, running a panic test returns 0 on success (panic),
> and the run_test.sh unit test correctly displays it as PASS rather than
> FAIL.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 8643bab3b..9bf2f0bbd 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -378,6 +378,7 @@ run_panic ()
>  	else
>  		# some QEMU versions report multiple panic events
>  		echo "PASS: guest panicked"
> +		echo "EXIT: STATUS=1"
>  		ret=1
>  	fi
>  
> -- 
> 2.45.1
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>

