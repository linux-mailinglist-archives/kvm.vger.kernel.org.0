Return-Path: <kvm+bounces-12690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8618388BF49
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 11:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07B5BB27D7C
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C1D6F068;
	Tue, 26 Mar 2024 10:24:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C360967A04
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 10:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711448683; cv=none; b=MfwB0+ST/T/SL8aKpUHYHfQ3y/i8BAHCEN3nWP2fFHRlSI6P7dcO4gomjCDEvIij+It4xwGs+IovsvtQM3P+3otELs0aF+94ktmaTILfUo7CZKxEeXMKEDxN5IfuvuU30EDtfo/ewrZFgbKSYcNZPr1yAnBu+xyi4cTB7TNY5Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711448683; c=relaxed/simple;
	bh=Tz270KoWeGy7qNpUR2Y2FQ3uWU7ZLDn6BatvOB5WzU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=smnZ7wBu/Kbao3S6NngTQCjjKzfb/nT1DOry/Z/vu44BXvQAhVe5lXfLJQwPUc/aLnQR5cyFREcbG0aQvVUqOagcKHJQBESXHYOX65MrGz1qqa+gsOmvpYUqisJmoSfIPNLFA4Z3K8EKMOIsgekUL15AzpIFooaIfgBPWyqlmyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B44A22F4;
	Tue, 26 Mar 2024 03:25:13 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C95053F64C;
	Tue, 26 Mar 2024 03:24:38 -0700 (PDT)
Message-ID: <72fc0e61-175b-4f48-a980-e715d9265a08@arm.com>
Date: Tue, 26 Mar 2024 10:24:37 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] KVM: arm64: Exclude host_debug_data from vcpu_arch
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Mark Brown <broonie@kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20240322170945.3292593-1-maz@kernel.org>
 <20240322170945.3292593-3-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240322170945.3292593-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/03/2024 17:09, Marc Zyngier wrote:
> Keeping host_debug_state on a per-vcpu basis is completely
> pointless. The lifetime of this data is only that of the inner
> run-loop, which means it is never accessed outside of the core
> EL2 code.
> 
> Move the structure into kvm_host_data, and save over 500 bytes
> per vcpu.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


