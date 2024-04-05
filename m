Return-Path: <kvm+bounces-13717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEA6899EA7
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 15:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C425B227F6
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 13:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FDA16D9A0;
	Fri,  5 Apr 2024 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="to1pdbBV"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E55B12E5B
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712324734; cv=none; b=S5HxjRS7XbSppBJg7PJPVrpOSpFapnQJvGBqEWltR1XYjLrrVeX156jJroSoK2R0/OxP2fiDTgMV5mBhstTTHMrnd2l+sg8J2xbu81luwss1D6aCbZvRgMYrvGu8rF8qx/512fl0pQUWxpwdlOv67PnHdDlafViAhn8sxXzRAD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712324734; c=relaxed/simple;
	bh=vWXpkA0lOxnVE7hJbDTPVU5/zTOLEDp8UlExaCE2pB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndPRq8YR0fkzb+auQVmbhvQwA4u9efmp2VX/1vns+tveVJ4UAXzVSQqocJk0+ORJnZY9/oqwuzlZ0L8JCQ7j3uYWScjkAho23VIpoylRCUNYOOI3f1dPAIm1zNTHQBD1h/0i2cEkj7aRuhWAc6smPEb/Tgboe3I15vGHPWqLp6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=to1pdbBV; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 15:45:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712324729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D4RFDfJ7+IIu/IqKGXhFsFLXS8k2AzT/NEimt9VnkMQ=;
	b=to1pdbBV8dK2yU5zVpKempfOFm/Fsjfb+cw/HsUr3hfwZjiG3sNmZcqoMC+7WTVXq0P2Gg
	V9cZzwS7D9vU9P/igbCt5i1xqa7yXWKJVKMvLwKj+N1bkLZ6eiPghwgsxhC5oaGebqMkQ9
	5d5A7HhDebwBukyBdL4QtErbnSR2uFE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v8 13/35] doc: start documentation
 directory with unittests.cfg doc
Message-ID: <20240405-c177544d7b41fbfa047420a6@orel>
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-14-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405083539.374995-14-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 06:35:14PM +1000, Nicholas Piggin wrote:
> Consolidate unittests.cfg documentation in one place.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/unittests.cfg     | 26 ++-----------
>  docs/unittests.txt    | 89 +++++++++++++++++++++++++++++++++++++++++++
>  powerpc/unittests.cfg | 25 ++----------
>  riscv/unittests.cfg   | 26 ++-----------
>  s390x/unittests.cfg   | 18 ++-------
>  x86/unittests.cfg     | 26 ++-----------
>  6 files changed, 107 insertions(+), 103 deletions(-)
>  create mode 100644 docs/unittests.txt

This is really nice. I only found one thing, which I point out below.

> 
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index fe601cbb1..54cedea28 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -1,28 +1,10 @@
>  ##############################################################################
>  # unittest configuration
>  #
> -# [unittest_name]
> -# file = <name>.flat		# Name of the flat file to be used.
> -# smp  = <num>			# Number of processors the VM will use
> -#				# during this test. Use $MAX_SMP to use
> -#				# the maximum the host supports. Defaults
> -#				# to one.
> -# extra_params = -append <params...>	# Additional parameters used.
> -# arch = arm|arm64			# Select one if the test case is
> -#					# specific to only one.
> -# groups = <group_name1> <group_name2> ...	# Used to identify test cases
> -#						# with run_tests -g ...
> -#						# Specify group_name=nodefault
> -#						# to have test not run by
> -#						# default
> -# accel = kvm|tcg		# Optionally specify if test must run with
> -#				# kvm or tcg. If not specified, then kvm will
> -#				# be used when available.
> -# timeout = <duration>		# Optionally specify a timeout.
> -# check = <path>=<value> # check a file for a particular value before running
> -#                        # a test. The check line can contain multiple files
> -#                        # to check separated by a space but each check
> -#                        # parameter needs to be of the form <path>=<value>
> +# arm specifics:
> +#
> +# file = <name>.flat            # arm uses .flat files
> +# arch = arm|arm64
>  ##############################################################################
>  
>  #
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> new file mode 100644
> index 000000000..53e02077c
> --- /dev/null
> +++ b/docs/unittests.txt
> @@ -0,0 +1,89 @@
> +unittests
> +*********
> +
> +run_tests.sh is driven by the <arch>/unittests.cfg file. That file defines
> +test cases by specifying an executable (target image) under the <arch>/
> +directory, and how to run it. This way, for example, a single file can
> +provide multiple test cases by being run with different host configurations
> +and/or different parameters passed to it.
> +
> +Detailed output from run_tests.sh unit tests are stored in files under
> +the logs/ directory.
> +
> +unittests.cfg format
> +====================
> +
> +# is the comment symbol, all following contents of the line is ignored.
> +
> +Each unit test is defined as with a [unit-test-name] line, followed by

s/ as//

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

