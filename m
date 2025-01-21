Return-Path: <kvm+bounces-36118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FE8A1802C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:42:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94BA0188AC2C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 14:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB851F3FF3;
	Tue, 21 Jan 2025 14:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MfmAIDOw"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0536B1F3FEB
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 14:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737470490; cv=none; b=NYd9dedB+W6eUCLNMirUk988lzvSXLwfQfLaE4G/I/EbgH7Z546m1A/GFwBeuqAkjUkOKHF2WVrCG3DuO8ylGheGlh2ZAXelsY4jr4bZ+IujFPOcElAXSSxUaWYfii9UwGhe+kTtAohSC2bbgss6IDl1XcJychruuiOmBDG1ioU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737470490; c=relaxed/simple;
	bh=0tDSw5HQQv+ZjKR7TrxZKpDd5ZMpssn2xb4TcobRd3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFW7qHdE3/UP6aifEapu/1mu5SiT03LU2EWT8gJf2xf9jI0g9A6UTdf3uAvb8cs8YHl2FuhPR4RN0eUx1v6dAXYpSnejByDIog3Qm8OqHJNOoQWaj1/zhKDJpFGkyKnHMt47cbiQxl23Aq+dCniRzstTQTtTEkGFGqz86/M20VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MfmAIDOw; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 15:41:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737470480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gf/1W+m78aXfLIDaJ6uGUwztghDrNUX5iY9PP5ywKHE=;
	b=MfmAIDOwPguHo8xunevud183sAezfRujYbii7fySiBS7KLOvel3jZLxFLZdOKqYMmnRAAO
	np6PXOSd8Sj3vtB2H3dRlHmdV+23IoNDIVT3J/I9cNdCR0+1cOm1G2sdK2e0n4Fufi6sDY
	SlF0FxE8wfW5aO/P8LGJOhlvzZat4N8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 01/18] run_tests: Document
 --probe-maxsmp argument
Message-ID: <20250121-033cee8123fdac80f70bc0ee@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-2-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-2-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:42:59PM +0000, Alexandru Elisei wrote:
> Commit 5dd20ec76ea63 ("runtime: Update MAX_SMP probe") added the
> --probe-maxmp argument, but the help message for run_tests.sh wasn't
> updated. Document --probe-maxsmp.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  run_tests.sh | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 152323ffc8a2..f30b6dbd131c 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -17,14 +17,15 @@ cat <<EOF
>  
>  Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
>  
> -    -h, --help      Output this help text
> -    -v, --verbose   Enables verbose mode
> -    -a, --all       Run all tests, including those flagged as 'nodefault'
> -                    and those guarded by errata.
> -    -g, --group     Only execute tests in the given group
> -    -j, --parallel  Execute tests in parallel
> -    -t, --tap13     Output test results in TAP format
> -    -l, --list      Only output all tests list
> +    -h, --help          Output this help text
> +    -v, --verbose       Enables verbose mode
> +    -a, --all           Run all tests, including those flagged as 'nodefault'
> +                        and those guarded by errata.
> +    -g, --group         Only execute tests in the given group
> +    -j, --parallel      Execute tests in parallel
> +    -t, --tap13         Output test results in TAP format
> +    -l, --list          Only output all tests list
> +        --probe-maxsmp  Update the maximum number of VCPUs supported by host
>  
>  Set the environment variable QEMU=/path/to/qemu-system-ARCH to
>  specify the appropriate qemu binary for ARCH-run.
> -- 
> 2.47.1
> 
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

