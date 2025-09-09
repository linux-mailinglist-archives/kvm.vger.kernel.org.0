Return-Path: <kvm+bounces-57116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA76B50216
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DB4E445C36
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 16:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE5032CF76;
	Tue,  9 Sep 2025 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lTj96fNZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA78121B9C0
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757433953; cv=none; b=aG68VK1S8IiqtP6HzevpfGJWzN2G1ny0AnSwurRhsNQIXDsy7qzP9qdcXAyqvu88z11+x+EbPxRP/DSunsd6+USsmbjKk4v5Jo0Nc0qK+HsweE8I5zB/6CAoWBnhLtbhCjfMNFaMXIIKR6VUCi3ECMooQpxlvYHJfrTe0g34Py8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757433953; c=relaxed/simple;
	bh=BayPygkvSB3pW7SeNQ4pT1Dw+756o87lhKeFhVlzsiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dr32Q7srFT6liI0kn/QZf/GMPx/12iGikx1ua6isWcYX2xtCMqn6+YUNZjz0/voG+rJIAYh6XOalvQ7+N2SVtUbnIT8dEmXpfHvMBkkqYzijs9TnBw8J1OU0U+LoesXQHEEgkK/0DuhTY8oU0xnXwXfuDWpOkcCi/2DKaR+dcOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lTj96fNZ; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Sep 2025 11:05:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757433948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U65ZvJGogLI9XWduZqdaqweGCV4FAS/M646h++xRfuY=;
	b=lTj96fNZndhKkuqjhWqZ5yrp86riiJAyVEt6EiyphVxIQY1W7Qn+JVPxwgOQDYjkgZkjFH
	k+E0fvSgn2OQgPxzxJyUKpePI3mw5qwdmt9ZEPKW//Whn2oKF2g5DoSljCQ4DvJ4h0QTjR
	Eztay8rshdbo9AeNrV1BY2qG+IsqnZI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2] scripts/arch-run.bash: Drop the
 dependency on "jq"
Message-ID: <20250909-007d720ee7bacfea514e5f19@orel>
References: <20250909045855.71512-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909045855.71512-1-thuth@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 09, 2025 at 06:58:55AM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> For checking whether a panic event occurred, a simple "grep"
> for the related text in the output is enough - it's very unlikely
> that the output of QEMU will change. This way we can drop the
> dependency on the program "jq" which might not be installed on
> some systems.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2: Change the regular expression according to Claudio's suggestion
> 
>  scripts/arch-run.bash | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 36222355..16417a1e 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -296,11 +296,6 @@ do_migration ()
>  
>  run_panic ()
>  {
> -	if ! command -v jq >/dev/null 2>&1; then
> -		echo "${FUNCNAME[0]} needs jq" >&2
> -		return 77
> -	fi
> -
>  	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
>  	trap 'rm -f ${qmp}.in ${qmp}.out' RETURN EXIT
>  
> @@ -312,8 +307,7 @@ run_panic ()
>  		-mon chardev=mon,mode=control -S &
>  	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' > ${qmp}.in
>  
> -	panic_event_count=$(jq -c 'select(.event == "GUEST_PANICKED")' < ${qmp}.out | wc -l)
> -	if [ "$panic_event_count" -lt 1 ]; then
> +	if ! grep -E -q '"event"[[:blank:]]*:[[:blank:]]*"GUEST_PANICKED"' ${qmp}.out ; then
>  		echo "FAIL: guest did not panic"
>  		ret=3
>  	else
> -- 
> 2.51.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

