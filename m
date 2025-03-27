Return-Path: <kvm+bounces-42129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F312A73A2A
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 18:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8389C16FE0D
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 17:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA6B1A8F9E;
	Thu, 27 Mar 2025 17:11:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBC01DFF8
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743095491; cv=none; b=alqiyAeV2nLHOBZFfCmIybfWbVx5wfxdQiN83+pqjRY1KwC7PYAP3V/Wb4vq6Mey4jDEObpIv9U+ko1r1w/jMtRCEPvrDpI73yYxAW6f16xGlWDFMuDvbOS0D47vOZ8Ju6hBmBh+458fGsXC6TNb+kBajQz/Nkih2QfeiGcEo+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743095491; c=relaxed/simple;
	bh=BuEIdozODnu8Pi8cV2q1qibFyh11cZdTbxRUiasKPU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+MoeVw0a+n2xFSuns6TRDfzIHGwjsqPfV/lAGm8GdjAV3kWXJOWfwjCzlFB5NtaDifdENBwPxuf/AlhsH45xdt3eQJ7ec378DWMLpvpqBoscwSs6Y4kBPCXmdf8G8YMeZnmSowk88ghhPfJyRaNHXWb1knMkhVZXMUw+fW5rZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDCD81063;
	Thu, 27 Mar 2025 10:11:32 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 645FE3F63F;
	Thu, 27 Mar 2025 10:11:26 -0700 (PDT)
Date: Thu, 27 Mar 2025 17:11:23 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: andrew.jones@linux.dev, eric.auger@redhat.com, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 1/5] configure: arm64: Don't display
 'aarch64' as the default architecture
Message-ID: <Z-WGuyzy4qxAcJD4@raptor>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
 <20250325160031.2390504-4-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325160031.2390504-4-jean-philippe@linaro.org>

Hi Jean-Philippe

On Tue, Mar 25, 2025 at 04:00:29PM +0000, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> --arch=aarch64, intentional or not, has been supported since the initial
> arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
> "aarch64" does not show up in the list of supported architectures, but
> it's displayed as the default architecture if doing ./configure --help
> on an arm64 machine.
> 
> Keep everything consistent and make sure that the default value for
> $arch is "arm64", but still allow --arch=aarch64, in case they are users
> that use this configuration for kvm-unit-tests.

You can drop this paragraph, since the change to the default value for $arch was
dropped.

With this change:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> The help text for --arch changes from:
> 
>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> 
> to:
> 
>     --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  configure | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/configure b/configure
> index 52904d3a..010c68ff 100755
> --- a/configure
> +++ b/configure
> @@ -43,6 +43,7 @@ else
>  fi
>  
>  usage() {
> +    [ "$arch" = "aarch64" ] && arch="arm64"
>      cat <<-EOF
>  	Usage: $0 [options]
>  
> -- 
> 2.49.0
> 

