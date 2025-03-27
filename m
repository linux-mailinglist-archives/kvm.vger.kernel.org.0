Return-Path: <kvm+bounces-42130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2AA3A73A2B
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 18:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1DB7188CFCA
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 17:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F281AB6D8;
	Thu, 27 Mar 2025 17:11:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCD6155300
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743095504; cv=none; b=rAzRr4oSzMWt0TpeVgPD+1qowjACRI4tjUbFODAcRh/T7BVp3BMuVM06DcQGHze6N3LCyrcU9ENIerB2IbbgsJvLuPG+waKnZmkJpNlFIgnuPQW4UHSZmUhP8OzzzV1qpSSw9JAEZO5dXkvkCMZmeYXt7UUuRcziIzS201wW4p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743095504; c=relaxed/simple;
	bh=TJATI+Y/hXzQbtPcbEJAWqJ6YxCC7KhCJS333VsMm1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djCCKaP0BP3fB7rC5R/Nkqar23oAN347I0aTSDl2VXBnLMMrg8cO9p/5zwvmz6yIMqIsAlDqlwik5svSP9WVN+EICCbkwM55D0t9ltc4gquJsQ+ZvLf0IQcs7K3TPgWoBvdRx8kF/yGPCIZ/ubWU8oCU6jh3PUj2fn34VHBfLgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 923F61063;
	Thu, 27 Mar 2025 10:11:47 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AB1B3F63F;
	Thu, 27 Mar 2025 10:11:41 -0700 (PDT)
Date: Thu, 27 Mar 2025 17:11:38 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: andrew.jones@linux.dev, eric.auger@redhat.com, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 2/5] configure: arm/arm64: Display the
 correct default processor
Message-ID: <Z-WGygaYIs4RLoJk@raptor>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
 <20250325160031.2390504-5-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325160031.2390504-5-jean-philippe@linaro.org>

Hi Jean-Philippe,

On Tue, Mar 25, 2025 at 04:00:30PM +0000, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> The help text for the --processor option displays the architecture name as
> the default processor type. But the default for arm is cortex-a15, and for
> arm64 is cortex-a57. Teach configure to display the correct default
> processor type for these two architectures.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  configure | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/configure b/configure
> index 010c68ff..b4875ef3 100755
> --- a/configure
> +++ b/configure
> @@ -5,6 +5,24 @@ if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
>      exit 1
>  fi
>  
> +# Return the default CPU type to compile for
> +function get_default_processor()
> +{
> +    local arch="$1"
> +
> +    case "$arch" in
> +    "arm")
> +        echo "cortex-a15"
> +        ;;
> +    "arm64")
> +        echo "cortex-a57"
> +        ;;
> +    *)
> +        echo "$arch"
> +        ;;
> +    esac
> +}
> +
>  srcdir=$(cd "$(dirname "$0")"; pwd)
>  prefix=/usr/local
>  cc=gcc
> @@ -44,13 +62,14 @@ fi
>  
>  usage() {
>      [ "$arch" = "aarch64" ] && arch="arm64"
> +    [ -z "$processor" ] && processor=$(get_default_processor $arch)
>      cat <<-EOF
>  	Usage: $0 [options]
>  
>  	Options include:
>  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
>  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> -	    --processor=PROCESSOR  processor to compile for ($arch)
> +	    --processor=PROCESSOR  processor to compile for ($processor)
>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
> @@ -326,13 +345,8 @@ if [ "$earlycon" ]; then
>      fi
>  fi
>  
> -[ -z "$processor" ] && processor="$arch"
> -
> -if [ "$processor" = "arm64" ]; then
> -    processor="cortex-a57"
> -elif [ "$processor" = "arm" ]; then
> -    processor="cortex-a15"
> -fi
> +# $arch will have changed when cross-compiling.
> +[ -z "$processor" ] && processor=$(get_default_processor $arch)
>  
>  if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>      testdir=x86
> -- 
> 2.49.0
> 

