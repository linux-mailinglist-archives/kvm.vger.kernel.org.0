Return-Path: <kvm+bounces-64699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 062FBC8B193
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AECB3B7A0E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04443328B50;
	Wed, 26 Nov 2025 16:58:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF3E33F387
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 16:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764176313; cv=none; b=a0Y3AhDoSQyxTcbeiWKEsuA3e++U2A/RIHeHmy9N8dP4cduvyruXTeUtBSQXZg3OSDriHbfLbWMfQJLvea/cdG6pdt4+05dzFXZ7jti1OopQkaH8jax+0zFMhfNIcmsW7/eIQ2sT6XHsO9pCjRGQUSyunRosuGYYkbbAiyNQDGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764176313; c=relaxed/simple;
	bh=yb34uNDIfM6mJr/oy9cuDu1MlzuDauyd8f+uO+/MJjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bL2oAP6aSVUKHEch3ozy1IFG8r+BdI+UHABzYhMOqvqZnvd+4WrXPXBTc07+m1cd0PDN4rQ+pX7CjDgxpIiJLaLiS0iC7+8MWCVL4czsmWmKl/3yF/z1OcFpvJuE31JJm5rtTAQUh9+c1p8keCgwRmCLEemUI+/nG6jHm9Gw/9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 561D8168F;
	Wed, 26 Nov 2025 08:58:22 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA2CA3F66E;
	Wed, 26 Nov 2025 08:58:28 -0800 (PST)
Message-ID: <c5e85f4d-2646-4459-8034-bc9765c8e5da@arm.com>
Date: Wed, 26 Nov 2025 16:58:27 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] KVM: arm64: Add a generic synchronous exception
 injection primitive
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20251126155951.1146317-1-maz@kernel.org>
 <20251126155951.1146317-4-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251126155951.1146317-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 11/26/25 15:59, Marc Zyngier wrote:
> Maybe in a surprising way, we don't currently have a generic way
> to inject a synchronous exception at the EL the vcpu is currently
> running at.
> 
> Extract such primitive from the UNDEF injection code.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  1 +
>  arch/arm64/kvm/inject_fault.c        | 10 +++++++---
>  2 files changed, 8 insertions(+), 3 deletions(-)

LGTM.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben




