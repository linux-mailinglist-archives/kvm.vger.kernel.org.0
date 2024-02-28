Return-Path: <kvm+bounces-10236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEDB86AE72
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C3C41C244F4
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DD3149E17;
	Wed, 28 Feb 2024 11:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V2Sp1Fpt"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C13B36132
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 11:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709121160; cv=none; b=o4WX/+ti5+99yHlONQyvOrtluhMlBhYeQyR9wSo4xa0VVDEeVaY69kNqoF7fQ1mtyGmRRgMEeKTE5m7dYORgE50etEKt5nRDVdLTDMV6jLu31mFfi97oTzPB0ZY+X9DJHkGkNW4Qh3B8f1exZkWE/1gPW/MrqaWiYSiwa+3nuMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709121160; c=relaxed/simple;
	bh=6n3kFU5x/YvVfyL3lTrYQWQTvuJnDSdSNAIGJoaralg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sctMOCluHDFL7ma6ig5iFCe0zrb14qEsAZonfL2zp8qpNCyA83I1SpGgU1mtugigngej1SBz4IPV5QuiqRl3VvXYjLUrfU6aUXByFZ6h/TKCM1bDO2MGJPJ8tkffnYLiIekg0Fh47BTJu0OurMZs+/0h6+EyRXS87yBnDh3bHAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V2Sp1Fpt; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 12:52:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709121156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Of/c4OJ5QqHlfcHd3DqDvmXrLytO4RZYVHjHL4aaXcw=;
	b=V2Sp1FptrbsItKaiOjgH5NmVTBGMfmksj7NpLNxd/w5qi4WZxCSYl0MBhYEzflV8Pyv83v
	MtidTYuuTwhP7E0FRvGtFlhVZtjEnn2F4CtnIVKGCA6LWHxbo1LQjx+Q58mhCJGhSO9F6w
	iuruuVM9V9Iz18vTKBpNYs8Fh/rD53Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 10/32] scripts: Accommodate powerpc
 powernv machine differences
Message-ID: <20240228-1a4664ebbc59b704b7cfd2a0@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-11-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226101218.1472843-11-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 26, 2024 at 08:11:56PM +1000, Nicholas Piggin wrote:
> The QEMU powerpc powernv machine has minor differences that must be
> accommodated for in output parsing:
> 
> - Summary parsing must search more lines of output for the summary
>   line, to accommodate OPAL message on shutdown.
> - Premature failure testing must tolerate case differences in kernel
>   load error message.
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/runtime.bash | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 8f9672d0d..bb32c0d10 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -9,7 +9,7 @@ FAIL() { echo -ne "\e[31mFAIL\e[0m"; }
>  extract_summary()
>  {
>      local cr=$'\r'
> -    tail -3 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
> +    tail -5 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
>  }
>  
>  # We assume that QEMU is going to work if it tried to load the kernel
> @@ -18,7 +18,7 @@ premature_failure()
>      local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>  
>      echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> +        grep -q -e "[Cc]ould not \(load\|open\) kernel" -e "error loading" &&
>          return 1
>  
>      RUNTIME_log_stderr <<< "$log"
> -- 
> 2.42.0
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>

