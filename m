Return-Path: <kvm+bounces-12691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0940088BF4A
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 11:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B4371C3A85F
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1C36A8DE;
	Tue, 26 Mar 2024 10:25:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370295466D
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711448727; cv=none; b=qZi0zj8QljCZ+0ENeOpRGbnWp6diXAD/sHsD9JyQBUdUdUbAff/rQrAZkUBvvZful8X/rOJox+SS1P0kAAB5N7Gd52vCmEB2lAl+IoCR60AwAA3HatT1RCfrbo9IHVG3lvEx8nyCs5Njx+gPZv8adQJE8+3EWGJZmORGLkvWNs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711448727; c=relaxed/simple;
	bh=1R5ia46aYik7UyTdaAzJEt3ond5HISoCgbOeqsRXrwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kHm8S4U0hA/S3RSsdRDKO31yM4qrt6z/i/ECeM2n4DSmDTMaFTDvHDn9sUcVG6VsJYAgj3mEEXmAwg60o6vV+UFTKq1ArC9jrfIOyKasYrVcy6LrFP3k8X2v7f/0x0lBJzwQO02djLyj4pQ9t1BvanKOE7VYALzhZXq7jeqnlGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 395C12F4;
	Tue, 26 Mar 2024 03:25:59 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 602613F64C;
	Tue, 26 Mar 2024 03:25:24 -0700 (PDT)
Message-ID: <14aa70d3-e130-4225-a22c-9e604ebb960c@arm.com>
Date: Tue, 26 Mar 2024 10:25:24 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] KVM: arm64: Exclude mdcr_el2_host from
 kvm_vcpu_arch
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Mark Brown <broonie@kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20240322170945.3292593-1-maz@kernel.org>
 <20240322170945.3292593-4-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240322170945.3292593-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/03/2024 17:09, Marc Zyngier wrote:
> As for the rest of the host debug state, the host copy of mdcr_el2
> has little to do in the vcpu, and is better placed in the host_data
> structure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by : Suzuki K Poulose <suzuki.poulose@arm.com>



