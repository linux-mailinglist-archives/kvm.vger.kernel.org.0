Return-Path: <kvm+bounces-51650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E68AFAACC
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 07:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53585179DAF
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D75262FF0;
	Mon,  7 Jul 2025 05:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AMtGmCKy"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2644D2620E4
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 05:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751865661; cv=none; b=k+uDYFcEI900hnUYJ+ceDSe0DXw3+D6IjQcXyCcoPwQ8GEUI35b5bCELNLA6TC2qRxeKA8HRAvrAjIo9uYY+xVTJ5ExHDD5CdveSUDhO1158HVlqBmgkZrujs9H/SnEEieR78nxuNtGTVOzHOEUBoDBaj+WBNJ3VbL7CwmTccww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751865661; c=relaxed/simple;
	bh=XrClrX/nEf0YWvPsWg5bqf8P1996WjPOwqrihIHRpaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=APDcnxP4FJtHqubiDSMAxF7WUYsyMt//tqoTWsaXfti46mUgW3y+ea5ubZL+R2uLSeSYdLuEbj72BY44tg3uhoyu5TUnW1m8VMEqNI8Wp7JewOTomTu6L4O3zK988dMro/Br0QSLZU2y/FoFhqaFeC6Gmaojt1MMQe9oZflDahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AMtGmCKy; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <85f2fdc0-a624-4aaa-9ab4-14be45864f5f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751865647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tcV7bNjrkAkk7dneD01bWPinJ5BTlr1h2gpNebjCFUs=;
	b=AMtGmCKylVAw6fCdsCBxnPtk8IOI3JNTz7bF1oUsKedbvBKGIQ9kllWS/tBe4ZiMevjgsJ
	cIX3aVVBqgaqhDnX4FlPcwd8Kdg5yFLTqtbPWJXwwoktjtvRO9KShFx6rZ6p/HY9SggFqq
	azOUFGQLEvuF0dN8a7vfn0AYnIIPvOI=
Date: Mon, 7 Jul 2025 13:20:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] LoongArch: KVM: Add some feature detection on host with
 3C6000
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250707035143.1979013-1-maobibo@loongson.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yanteng Si <si.yanteng@linux.dev>
In-Reply-To: <20250707035143.1979013-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 7/7/25 11:51 AM, Bibo Mao 写道:
> With 3C6000 hardware platform, hardware page table walking and avec
> features are supported on host. Here add these two feature detection
> on KVM host.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Reviewed-by: Yanteng Si <siyanteng@cqsoftware.com.cn>

Thanks,
Yanteng
> ---
>   arch/loongarch/include/uapi/asm/kvm.h | 2 ++
>   arch/loongarch/kvm/vm.c               | 8 ++++++++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index 5f354f5c6847..0b9feb6c0d53 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -103,6 +103,8 @@ struct kvm_fpu {
>   #define  KVM_LOONGARCH_VM_FEAT_PMU		5
>   #define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
>   #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
> +#define  KVM_LOONGARCH_VM_FEAT_PTW		8
> +#define  KVM_LOONGARCH_VM_FEAT_AVEC		9
>   
>   /* Device Control API on vcpu fd */
>   #define KVM_LOONGARCH_VCPU_CPUCFG	0
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index edccfc8c9cd8..728b24a62f1e 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -146,6 +146,14 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
>   		if (kvm_pvtime_supported())
>   			return 0;
>   		return -ENXIO;
> +	case KVM_LOONGARCH_VM_FEAT_PTW:
> +		if (cpu_has_ptw)
> +			return 0;
> +		return -ENXIO;
> +	case KVM_LOONGARCH_VM_FEAT_AVEC:
> +		if (cpu_has_avecint)
> +			return 0;
> +		return -ENXIO;
>   	default:
>   		return -ENXIO;
>   	}


