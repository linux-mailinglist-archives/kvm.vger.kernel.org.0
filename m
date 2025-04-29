Return-Path: <kvm+bounces-44766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A19DAA0D18
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F0B81BA19BA
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9C82D320F;
	Tue, 29 Apr 2025 13:07:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EBB2D29DE
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932043; cv=none; b=HDy5PlFmvILxkJYSoVqI6TM5C1S7mXvo2nmI1/qoU6i7Jy5CPuU4b/8Eb/+jcVzfhQGhL//GfYAY/eEjpLo2AYZdydaXLYIMZJT7o0jyzPg1k9JmYDP2dZBx8pv28/ZZPr6HmF9nPJe/PM2UDxapqREcGx+/4KIMQsSrD/YkJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932043; c=relaxed/simple;
	bh=ZmHfsW91YPWRvQ6rKwiFn3NnMv9gzsRMQhen56flCqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQuS7eK5XtEEpD2cxGpKCZORwp2NQOJIiL0HmN8lqmGi5iNB2sD3L9oXJVx+G+QiYZr1ZSn6SRKSYSpxxh+whK776pfgxDzGjNo4b4b/42IWphr4O5YjDqpn+rTHtHNB83rBnrgExPs3AI85xQElLLvRhOVRqO6q+A9NPgxlfHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E54961515;
	Tue, 29 Apr 2025 06:07:14 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D59CC3F673;
	Tue, 29 Apr 2025 06:07:19 -0700 (PDT)
Message-ID: <b41361d2-fe4c-4242-b814-b0556cb91ec0@arm.com>
Date: Tue, 29 Apr 2025 14:07:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/42] arm64: sysreg: Replace HGFxTR_EL2 with
 HFG{R,W}TR_EL2
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-5-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250426122836.3341523-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc

On 4/26/25 13:27, Marc Zyngier wrote:
> Treating HFGRTR_EL2 and HFGWTR_EL2 identically was a mistake.
> It makes things hard to reason about, has the potential to
> introduce bugs by giving a meaning to bits that are really reserved,
> and is in general a bad description of the architecture.

There is a typo in the subject line. HGFxTR_EL2 should be HFG_xTR_EL2.

Thanks,

Ben

