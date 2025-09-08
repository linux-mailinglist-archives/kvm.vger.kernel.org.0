Return-Path: <kvm+bounces-56996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26136B49838
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAB9E443494
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 18:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B863431C572;
	Mon,  8 Sep 2025 18:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hr0MirQC"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4788231B132
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355821; cv=none; b=ZuhHIQ5DIrfp6yCCsG6QjCWh0/MUlM6r196vCJTJ+G2nKh3jghAM8VNcDSRs/nxofUPAyR/FpQndOF2ta9+dYbddpEtAOYpE3vjS9ds15SiHxIl/ncigdBInia7YOyd3iq9IF0LuDjG+fhf2gG+W+Of3+nDiuUKPONnK211Q0wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355821; c=relaxed/simple;
	bh=q7+rI0XYfEZFNUn67PEP3XYfpe5ZJvpIL7VRrj0roKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgnOYUgxj8SPBimAzwYxSBSINAOFLO4o0rFxslghjG68/uFOhgFjSeFnbsgk2J08Q0fm5XsXnprBRki6vg2We8Zz/6ViqprKnAnuaI3NxGsK9tDeYiG1aFADDusHwa8Nf8e1MiO1cV+90HXIvjkYr3KA4JAPBQDd0nxN3Zg8f6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hr0MirQC; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 8 Sep 2025 13:23:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757355818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wfvbyRUrus9DdcW9zzI7on+fJXo5hCh3vG+emK2AfHg=;
	b=hr0MirQCQnOn5qgB12A20Crtc/ogkmtkyeS6UzFumatxvYvHFDpT/b/4H2BTtwjguNtujd
	GbhgrR09+x6HdohMi6e4Nr4/TLPzR9gNJOl5O8BxnVyg2q4lnxNWyjCPc0QkwTC7ukR6Yl
	LW7UOuyJ3BFDBcaDtuFsO3v7Fl/dfjU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Huth <thuth@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	kvm-riscv@lists.infradead.org, Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH 2/2] shellcheck: suppress SC2327,2328 false positives
Message-ID: <20250908-d271d19e8179dae99c23143f@orel>
References: <20250908010618.440178-1-npiggin@gmail.com>
 <20250908010618.440178-2-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908010618.440178-2-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 08, 2025 at 11:06:18AM +1000, Nicholas Piggin wrote:
> Shellcheck warnings SC2327,SC2328 complain that a command substitution
> will be empty if the output is redirected, which is a valid warning but
> shellcheck is not smart enough to see when output is redirected into a
> command that outputs what the command substitution wanted.
> 
> Add comments and shellcheck directives to these cases.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 9 +++++++++
>  scripts/runtime.bash  | 6 ++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 58e4f93f..9c089f88 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -9,6 +9,11 @@ run_test ()
>  
>  	# stdout to {stdout}, stderr to $errors and stderr
>  	exec {stdout}>&1
> +	# SC complains that redirection without tee takes output way from

s/way/away/

Same comment for the other uses below.

> +	# command substitution, but that is what we want here (stderr output
> +	# does go to command substitution because tee is used, but stdout does
> +	# not).
> +	# shellcheck disable=SC2327,SC2328
>  	errors=$("${@}" $INITRD </dev/null 2> >(tee /dev/stderr) > /dev/fd/$stdout)
>  	ret=$?
>  	exec {stdout}>&-
> @@ -23,6 +28,10 @@ run_test_status ()
>  	local stdout ret
>  
>  	exec {stdout}>&1
> +	# SC complains that redirection without tee takes output way from
> +	# command substitution, but that is what we want here (tee is used
> +	# inside the parenthesis).
> +	# shellcheck disable=SC2327,SC2328
>  	lines=$(run_test "$@" > >(tee /dev/fd/$stdout))
>  	ret=$?
>  	exec {stdout}>&-
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 289e52bb..12ac0f38 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -190,6 +190,12 @@ function run()
>      # qemu_params/extra_params in the config file may contain backticks that
>      # need to be expanded, so use eval to start qemu.  Use "> >(foo)" instead of
>      # a pipe to preserve the exit status.
> +    #
> +    # SC complains that redirection without tee takes output way from command
> +    # substitution, but that is what we want here (tee is used inside the
> +    # parenthesis and output piped to extract_summary which is captured by
> +    # command substitution).
> +    # shellcheck disable=SC2327,SC2328
>      summary=$(eval "$cmdline" 2> >(RUNTIME_log_stderr $testname) \
>                               > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
>      ret=$?
> -- 
> 2.51.0

Changed way to away while merging.

Thanks,
drew

