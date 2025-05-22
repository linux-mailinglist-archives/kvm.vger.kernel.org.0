Return-Path: <kvm+bounces-47416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BAB2AC162F
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F09B1C030A5
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5253525CC7D;
	Thu, 22 May 2025 21:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OOkG4nO6"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2626A258CDD
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 21:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747950241; cv=none; b=CihsYKWzf1P6BdP1i2JOyGAzYb3MYgkD1s7aweHBAPnc0tw/UDQryT+HW7PXFQyjC7M5CE6XXxm/cOoLpukE4DABXwTBhceehTqdSe6Lg9diOmn08q216Rr8ZnI36ENF1TLLkdlKFyJKLQVrYki54k9fH5zr2FbLF6lGNj3kNqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747950241; c=relaxed/simple;
	bh=RWfUVJ+R+Vt3km2MW8uGMn6uTuXrPyTFfzIZbw4Ardc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rVo1igNds8lfLn9B5X5Q2YdZBqnevj7YgLNCitvQR8Nzk3oA40+AV6M29ZemOAq/gGCV9tcxq4Rhrv2MKIYD25mWahi1Bb2+pe7wTAgkm0bs/RjerykqyVqMsc++5Ox5tlcRkqMkaSZC5BmZpT4xCdqmHFlHE4u9uOgNpwVepns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OOkG4nO6; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <1a7a81fd-cf15-4b54-a805-32d66ced4517@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747950227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=plmj0gdkiLDj4KVFLXX5cTeiNOeT4yGDHPQsokxsHYA=;
	b=OOkG4nO6c5U8WpwXR5zHF9F4hraYfw3IqEfgDjBO5ZMGHMQNcyDuF6iF0vJTho3r/Z1Cmo
	aO2zKV1AZgm9LSAdsZIsdIPSJ/E26aJyz9VWKCUF8uBhNWRnNB2o0sxPviVwWFYpKO4H2E
	QLcdkZY7Sl/SgBnOzB43xKs05KME/ss=
Date: Thu, 22 May 2025 14:43:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/2] RISC-V: KVM: VCPU reset fixes
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>
References: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 5/15/25 7:37 AM, Radim KrÄmÃ¡Å wrote:
> Hello,
> 
> the design still requires a discussion.
> 
> [v3 1/2] removes most of the additional changes that the KVM capability
> was doing in v2.  [v3 2/2] is new and previews a general solution to the
> lack of userspace control over KVM SBI.
> 

I am still missing the motivation behind it. If the motivation is SBI 
HSM suspend, the PATCH2 doesn't achieve that as it forwards every call 
to the user space. Why do you want to control hsm start/stop from the 
user space ?


> A possible QEMU implementation for both capabilities can be seen in
> https://github.com/radimkrcmar/qemu/tree/reset_fixes_v3
> The next step would be to forward the HSM ecalls to QEMU.
> 
> v2: https://lore.kernel.org/kvm-riscv/20250508142842.1496099-2-rkrcmar@ventanamicro.com/
> v1: https://lore.kernel.org/kvm-riscv/20250403112522.1566629-3-rkrcmar@ventanamicro.com/
> 
> Radim Krčmář (2):
>    RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
>    RISC-V: KVM: add KVM_CAP_RISCV_USERSPACE_SBI
> 
>   Documentation/virt/kvm/api.rst        | 22 ++++++++++++++++++++++
>   arch/riscv/include/asm/kvm_host.h     |  6 ++++++
>   arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
>   arch/riscv/kvm/vcpu.c                 | 27 ++++++++++++++-------------
>   arch/riscv/kvm/vcpu_sbi.c             | 27 +++++++++++++++++++++++++--
>   arch/riscv/kvm/vm.c                   | 18 ++++++++++++++++++
>   include/uapi/linux/kvm.h              |  2 ++
>   7 files changed, 88 insertions(+), 15 deletions(-)
> 


