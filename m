Return-Path: <kvm+bounces-58431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85824B939A4
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 01:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E97F2A1E49
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 23:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0B22FB98D;
	Mon, 22 Sep 2025 23:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bhknsX6/"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521C4260583
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 23:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758584160; cv=none; b=i0k6cwWhImBT6GYRYAyP+xdFDlj9Hj9sS6PicSx3YfwZaQEyK6KiHjt+Ka2+HGdij0CEHq8oTqxAWkxuJWToL9Oa0oYrCakknxOXn9GAHATajpmJIxCYBqjWfJun81AQjM20yA9bg94JRx9Uu4RHaNt9mMc4WhdSmGXO+n/1fb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758584160; c=relaxed/simple;
	bh=QvkvFySCol+f4OrBWqJ/V7kbVeZUeLaAPs0LUqnUKTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPWVkNVPH6Bb9Q3ShHjUBthEL9/3D6kVClvZI3fIWrW9vKNk0YYRnSBSWtVlP6fmOnHa8xQKRou2zGibtE24AV/KSVTVFYzgWuofwFII6g9yfJQSsuLK2XqSyDq2BTXJj131dRe/oEh/hKW553NedS7pujO3SdH+eJLxAPqed4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bhknsX6/; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 22 Sep 2025 16:35:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758584155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YROanHWLsZyxpmkg+bbLtUTGJa8eSeOXO+0+S132Fq0=;
	b=bhknsX6/vaxKSZnPvKsUbfdwHD6LKytZGBvllisw+rMQMMDWi/4rtFUuhfA4B3/v1aCWwx
	Lp3TL0ZLYkFWymqq4yqURK4uTHU3iRkrYuECvy+ovmF+ipjkrCz8O7QI8VSLtwPLDJfEmb
	fe6iGL/v60eF86/upnlOh+WZHIH3+qc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: selftests: Cover ID_AA64ISAR3_EL1 in
 set_id_regs
Message-ID: <aNHdVtel5VGMltJb@linux.dev>
References: <20250920-kvm-arm64-id-aa64isar3-el1-v1-0-1764c1c1c96d@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920-kvm-arm64-id-aa64isar3-el1-v1-0-1764c1c1c96d@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Sep 20, 2025 at 08:51:58PM +0100, Mark Brown wrote:
> The set_id_regs selftest lacks coverag for ID_AA64ISR3_EL1 which has
> several features exposed to KVM guests in it.  Add coverage, and while
> we're here adjust the test to improve maintainability a bit.  
> 
> The test will fail without the recently applied change adding FEAT_LSFE:
> 
>    https://lore.kernel.org/r/175829303126.1764550.939188785634158487.b4-ty@kernel.org
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> Mark Brown (2):
>       KVM: arm64: selftests: Remove a duplicate register listing in set_id_regs
>       KVM: arm64: selftests: Cover ID_AA64ISAR3_EL1 in set_id_regs

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

