Return-Path: <kvm+bounces-24015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08DD2950899
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3C061F223C4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398CE1A01C5;
	Tue, 13 Aug 2024 15:10:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA9219EED6
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723561847; cv=none; b=bdtDV6ph3TdLAZnwP4RkTa7hcP4wvkxPnS0Wy9sspzbRG3Zs7Y8+l3xUDt8CNx9l7ebRyGaPm4DJhc7vbw5KYtU1cTF5wTKmb7AHum/6ZJ3u8Tnu+0lr1UrEgwa15kcoqjm6M7UvCmu7fqEhIosH/0uQUxD66SKdikZwzgnbCbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723561847; c=relaxed/simple;
	bh=vzusSZPUHOfEHplCDELxs8sW6d1y/V2522VBvA665ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Df2vGd66UIn/eaRgySZ4IdU6xn5VCmNHnvDXzkQ2kIOsC7Kj7V4IVGqnNlc1Fgz6xvIWCnVGrRmiDm45on8sY/v8dgro4qZrN6iPKRBo9OZlbpRA/PehrQaYfKALb4WnhR2nHX96b7HAYDgHd5I9dqA+sZAWOjyXsTPLSue8zKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD0251596;
	Tue, 13 Aug 2024 08:11:11 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC1F63F6A8;
	Tue, 13 Aug 2024 08:10:44 -0700 (PDT)
Date: Tue, 13 Aug 2024 16:10:42 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 06/10] arm64: Remove VNCR definition for PIRE0_EL2
Message-ID: <20240813151042.GC3321997@e124191.cambridge.arm.com>
References: <20240813144738.2048302-1-maz@kernel.org>
 <20240813144738.2048302-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144738.2048302-7-maz@kernel.org>

On Tue, Aug 13, 2024 at 03:47:34PM +0100, Marc Zyngier wrote:
> As of the ARM ARM Known Issues document 102105_K.a_04_en, D22677
> fixes a problem with the PIRE0_EL2 register, resulting in its
> removal from the VNCR page (it had no purpose being there the
> first place).
> 
> Follow the architecture update by removing this offset.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/vncr_mapping.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
> index df2c47c55972..9e593bb60975 100644
> --- a/arch/arm64/include/asm/vncr_mapping.h
> +++ b/arch/arm64/include/asm/vncr_mapping.h
> @@ -50,7 +50,6 @@
>  #define VNCR_VBAR_EL1           0x250
>  #define VNCR_TCR2_EL1		0x270
>  #define VNCR_PIRE0_EL1		0x290
> -#define VNCR_PIRE0_EL2		0x298
>  #define VNCR_PIR_EL1		0x2A0
>  #define VNCR_ICH_LR0_EL2        0x400
>  #define VNCR_ICH_LR1_EL2        0x408

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

