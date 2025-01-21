Return-Path: <kvm+bounces-36119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2699CA1802E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:43:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB568188BA79
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 14:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E471C1F3FD4;
	Tue, 21 Jan 2025 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U1g6GiVV"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1861F192A
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737470524; cv=none; b=tg8ZtpKFDTtTmAkSLBUNQ4cXAgBOajC6skOVcA073yfDQ6T8pDBOxNBPYlhn9dPRagFbXrpLZfuUD8WYGK3blE5mlxKLf4xLdjBgZA1Z7kNYu/CD8ul4B+yyfGXnjt5lf1fe9B/1fHavs90E4Nv7CtfWfnxC5iId+WMz1/9PKvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737470524; c=relaxed/simple;
	bh=yB2yXD8T57reRMN0KX8QsPeW3YgXVYEfrzb/0duLQ0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K0Hbi+38y6z3+WQEID9woxZx1EJGYcUzE9xcWaeSAe2MGwhg8zVVY8FDSbsGQfDe/LW5fPRX75+DSXdbClOKYuRX5Z4kyLuqfGHuWS/X+v0gK0lWml0dt7WtynyFJ34MRdOERj9dDZIDRDWc8I30YcOqzm3SwRKkcUtcU7bdxkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U1g6GiVV; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 15:41:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737470515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1pZPMNacqT3FWVN3+5IJh+1Gn4JDnmbN6slSSMAGWNY=;
	b=U1g6GiVVnnNvwjlefCbkSGE9rYkiSotU1DJDhhlacz830AQCJY+x+BSFIgBHEdBEjF7whh
	1iOobHh0VB/5gCqnxexgn5mMeNeHTTP/ErMJNus8Z3laTIH16QEgG4GETVntCJkH13UDVC
	pd8HDOrWvDQOqi0jJZ75AGa0Tmxygpo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com, Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 02/18] Document environment variables
Message-ID: <20250121-005ff84295df2dd87b8329b3@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-3-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-3-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:00PM +0000, Alexandru Elisei wrote:
> Document the environment variables that influence how a test is executed
> by the run_tests.sh test runner.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  docs/unittests.txt |  5 ++++-
>  run_tests.sh       | 12 +++++++++---
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index c4269f6230c8..dbc2c11e3b59 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -88,7 +88,8 @@ timeout
>  -------
>  timeout = <duration>
>  
> -Optional timeout in seconds, after which the test will be killed and fail.
> +Optional timeout in seconds, after which the test will be killed and fail. Can
> +be overwritten with the TIMEOUT=<duration> environment variable.
>  
>  check
>  -----
> @@ -99,3 +100,5 @@ can contain multiple files to check separated by a space, but each check
>  parameter needs to be of the form <path>=<value>
>  
>  The path and value cannot contain space, =, or shell wildcard characters.
> +
> +Can be overwritten with the CHECK environment variable with the same syntax.
> diff --git a/run_tests.sh b/run_tests.sh
> index f30b6dbd131c..23d81b2caaa1 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -27,9 +27,15 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
>      -l, --list          Only output all tests list
>          --probe-maxsmp  Update the maximum number of VCPUs supported by host
>  
> -Set the environment variable QEMU=/path/to/qemu-system-ARCH to
> -specify the appropriate qemu binary for ARCH-run.
> -
> +The following environment variables are used:
> +
> +    QEMU            Path to QEMU binary for ARCH-run
> +    ACCEL           QEMU accelerator to use, e.g. 'kvm', 'hvf' or 'tcg'
> +    ACCEL_PROPS     Extra argument to ACCEL
> +    MACHINE         QEMU machine type
> +    TIMEOUT         Timeout duration for the timeout(1) command
> +    CHECK           Overwrites the 'check' unit test parameter (see
> +                    docs/unittests.txt)
>  EOF
>  }
>  
> -- 
> 2.47.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

