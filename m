Return-Path: <kvm+bounces-44769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE73AA0D0C
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3900980564
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121832D869B;
	Tue, 29 Apr 2025 13:08:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA7E2D4B4D
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932091; cv=none; b=lzmZqFEa4Tc2BLDak/DW6K3sXMzhHlwZtdaVQbFeMx1NB7NYGWiczIs2mJD465i71lkQUM0llcF7J1XPoMl8dRZaCEsC0+Gf/2VazcFCX1Wft6Rrf7i/Jk5m8IcXFWwOS8AdbYKGWZ1pv+ynCZfHP2xk5rbrMpkG8hCVp1/1cbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932091; c=relaxed/simple;
	bh=TCTWNmFT4mUR4lTgmnrXfJpn+nw+UMhBIAgBQWdi5F0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KIbX3JB0SNcWrT/gIVj/SrDCoZ0I20T9T3k6INU7GZbNYo6+BGlnMy6z3n4ZAQrV3KbFiwuhCSNUqphwzZXS8VSCpXqNfxrMGdrTkbXEp2HK3j1EK+xuMG8rK9jnUdYhvCd6CqE9pFXBPeUd0D0hVICI1C0adZgIKuSwGj6oEzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A807E1516;
	Tue, 29 Apr 2025 06:08:02 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC1793F673;
	Tue, 29 Apr 2025 06:08:07 -0700 (PDT)
Message-ID: <a8227a8f-3901-454c-a9bd-ac2a061dd259@arm.com>
Date: Tue, 29 Apr 2025 14:08:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/42] KVM: arm64: Restrict ACCDATA_EL1 undef to
 FEAT_ST64_ACCDATA being disabled
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-19-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250426122836.3341523-19-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 4/26/25 13:28, Marc Zyngier wrote:
> We currently unconditionally make ACCDATA_EL1 accesses UNDEF.
> 
> As we are about to support it, restrict the UNDEF behaviour to cases
> where FEAT_ST64_ACCDATA is not exposed to the guest.

Isn't the feature called FEAT_LS64_ACCDATA rather than FEAT_ST64_ACCDATA?

Thanks,

Ben


