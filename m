Return-Path: <kvm+bounces-20718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C39691CA0C
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 03:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE2351C21BDF
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 01:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74BDD3FC2;
	Sat, 29 Jun 2024 01:33:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC53A926
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719624792; cv=none; b=mWWUN18+fY0bmF7DicoaR6+VRleGxrOiKrpiRA4W024PxlPIeIMihC+kaH1FiWCvAmv1KOwrfCnnWxROuONqkNVgQEfehoQWCUqgtXaZ0BTgYbi5Qloq3Pf7Ls1F1/qK6pSVIMPZLws/sCFAcHp4E87k+9w4N2A/epbpXJOwQ4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719624792; c=relaxed/simple;
	bh=FztG6LWYNy0V2s0oxsJEcTLvIDhXRCGVvPlDHC3TyXU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KM3YjNvmjF/qVsYnd9RIfg6e381f9RxwQEmCVu5YDP5Wh6u8see8uDKpoxMKt5YxMhaztxeasYKbk7FZeHN+fa586C7LPWpqgySZGsLsfhg3BtfvQe4CQhNPeQ8wlcqOJD5Snnf2oGgnQt5fISoEzUwH5W2/52z98VTlG6xHSGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4W9vp82jxZz1T4Jk;
	Sat, 29 Jun 2024 09:28:32 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id E31AD180089;
	Sat, 29 Jun 2024 09:32:59 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 29 Jun 2024 09:32:59 +0800
Subject: Re: [PATCH] MAINTAINERS: Include documentation in KVM/arm64 entry
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	<kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20240628222147.3153682-1-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <63685fc4-38fb-f938-959d-2c1f96cff6b1@huawei.com>
Date: Sat, 29 Jun 2024 09:32:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240628222147.3153682-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/6/29 6:21, Oliver Upton wrote:
> Ensure updates to the KVM/arm64 documentation get sent to the right
> place.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aacccb376c28..05d71b852857 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12078,6 +12078,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:	kvmarm@lists.linux.dev
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
> +F:	Documentation/virt/kvm/arm/
>  F:	arch/arm64/include/asm/kvm*
>  F:	arch/arm64/include/uapi/asm/kvm*
>  F:	arch/arm64/kvm/

Should we include the vgic documentation (in
Documentation/virt/kvm/devices/) as well? They're indeed KVM/arm64
stuff.

Thanks,
Zenghui

