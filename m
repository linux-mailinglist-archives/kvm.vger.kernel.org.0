Return-Path: <kvm+bounces-44767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D06DCAA0D19
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F71E1887DA3
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900232C2AD8;
	Tue, 29 Apr 2025 13:07:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 926152C2AD0
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932065; cv=none; b=RBstdQkeqHsnKkLcZ4wPbLHtlMTCZWBM50Q/r+8MLQva2J2+ltJwJiXOTKw+pZgDEAe9AONydwD5qeX0JN+8vTHdRYpwuYvcDZbJu7flxBIFdIAq+O6vo5JTMHFnQmn7BiFz2VKsqJofXZJD0J6fXqbDSEaGkD5TPKcMkaaHjA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932065; c=relaxed/simple;
	bh=XUiEmAp51fgOeJXxf4dBszflCyWblRPjNDT+QpGEFI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=roe3N+S/GrzKqQll034PQ3aK5UYfgMMyG1OnX4NZ04S3HQfjPPdUx+5fg7rILSHZdb/M6PIU2bBxx/Et/td2Xw1WhnAlMHrK87ydRWF/di9m4TrvdIrNlDKn7k3UP6PDLGucHiXSyQpyn8Rz3PmlRjqAfJlvDwUnXu8GOCLuXJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27B861515;
	Tue, 29 Apr 2025 06:07:36 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46EE43F673;
	Tue, 29 Apr 2025 06:07:41 -0700 (PDT)
Message-ID: <8dfaa919-228e-4a5c-abbc-efa1a19ae92b@arm.com>
Date: Tue, 29 Apr 2025 14:07:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/42] arm64: sysreg: Add registers trapped by
 HDFG{R,W}TR2_EL2
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-10-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250426122836.3341523-10-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 4/26/25 13:28, Marc Zyngier wrote:
> +Sysreg	SPMCR_EL0	2	3	9	12	0
> +Res0	63:12
> +Field	11	TRO
> +Field	10	HDBG
> +Field	9	FZO
> +Field	8	NA
> +Res0	7:5	
Nit: Trailing whitespace. There are a few other places on Res0 lines. 
Maybe your generation script could be tweaked.

Thanks,

Ben


