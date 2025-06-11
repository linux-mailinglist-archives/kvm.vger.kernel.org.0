Return-Path: <kvm+bounces-49091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65714AD5CB0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AC8F7AD4D7
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEC420E713;
	Wed, 11 Jun 2025 16:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="n5VnOf12"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45412E610F;
	Wed, 11 Jun 2025 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749660634; cv=none; b=YYQ04DlVtDDKYK/9oZBnlvc9gevSkTDZM1lO5/PmTOTyqqRIffaj5vRFUQRt1FpSOkxBe00NqD3rjY/TqWj/QGWho6DL0zjYRx3VZGZ9WLpOeUjn0rUHl8UxtEGaB7WfBVhRdE8KL6NrBbLuqiHSinTTCz2H1omr04FvWEpuVQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749660634; c=relaxed/simple;
	bh=pKeHfuJCvibCVUEiijmqIbl2R3U0gwLuy7BlutemhL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J0upvQa3pjZdK9cz1rA56qs+1sD8iFs51Rw3HzdYCHMT3zfpumF9RKNF/iOR1jzLoDVxZRstbAOqzkB9MMdgKO4BBeRFqDWAUd0B8e8ynipz6TaTzhDj0TbVf2S+7g4EGAAhd8y7VP2vcEk9y6VSLatvh/dU2TES0onTevlZRE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=n5VnOf12; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.65.208.185] (unknown [20.236.11.69])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3DB1F21151A2;
	Wed, 11 Jun 2025 09:50:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3DB1F21151A2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1749660632;
	bh=FPPX7YYZ8XcYflcrWTpvoOffBT2d5LZYxQ3qxbCqh4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n5VnOf12XqDy1EJXmNidNMRRrGTiqAP2sCXq0CDii1u/gxSlrbHUUBZNbDVvNlzvG
	 pC+FRSOjFzu21Z8Be5lz4e77cvw2ht+jbnG0a00v68Sx9350zHovrdMvXRywTy104j
	 vnSsJY80Za2jPuW6uSY5Flm3KJYdI4MpQcqyg7fc=
Message-ID: <789d1112-020f-402e-9fd2-aa6e061879ff@linux.microsoft.com>
Date: Wed, 11 Jun 2025 09:50:29 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] Drivers: hv: Fix warnings for missing export.h header
 inclusion
To: Naman Jain <namjain@linux.microsoft.com>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Konstantin Taranov <kotaranov@microsoft.com>,
 Leon Romanovsky <leon@kernel.org>, Long Li <longli@microsoft.com>,
 Shiraz Saleem <shirazsaleem@microsoft.com>,
 Shradha Gupta <shradhagupta@linux.microsoft.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
 Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org
References: <20250611100459.92900-1-namjain@linux.microsoft.com>
 <20250611100459.92900-2-namjain@linux.microsoft.com>
Content-Language: en-US
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
In-Reply-To: <20250611100459.92900-2-namjain@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/2025 3:04 AM, Naman Jain wrote:
> Fix below warning in Hyper-V drivers that comes when kernel is compiled
> with W=1 option. Include export.h in driver files to fix it.
> * warning: EXPORT_SYMBOL() is used, but #include <linux/export.h>
> is missing
> 
> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
> ---
>  drivers/hv/channel.c           | 1 +
>  drivers/hv/channel_mgmt.c      | 1 +
>  drivers/hv/hv_proc.c           | 1 +
>  drivers/hv/mshv_common.c       | 1 +
>  drivers/hv/mshv_root_hv_call.c | 1 +
>  drivers/hv/ring_buffer.c       | 1 +
>  6 files changed, 6 insertions(+)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 35f26fa1ffe7..7c7c66e0dc3f 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -18,6 +18,7 @@
>  #include <linux/uio.h>
>  #include <linux/interrupt.h>
>  #include <linux/set_memory.h>
> +#include <linux/export.h>
>  #include <asm/page.h>
>  #include <asm/mshyperv.h>
>  
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 6e084c207414..65dd299e2944 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -20,6 +20,7 @@
>  #include <linux/delay.h>
>  #include <linux/cpu.h>
>  #include <linux/hyperv.h>
> +#include <linux/export.h>
>  #include <asm/mshyperv.h>
>  #include <linux/sched/isolation.h>
>  
> diff --git a/drivers/hv/hv_proc.c b/drivers/hv/hv_proc.c
> index 7d7ecb6f6137..fbb4eb3901bb 100644
> --- a/drivers/hv/hv_proc.c
> +++ b/drivers/hv/hv_proc.c
> @@ -6,6 +6,7 @@
>  #include <linux/slab.h>
>  #include <linux/cpuhotplug.h>
>  #include <linux/minmax.h>
> +#include <linux/export.h>
>  #include <asm/mshyperv.h>
>  
>  /*
> diff --git a/drivers/hv/mshv_common.c b/drivers/hv/mshv_common.c
> index 2575e6d7a71f..6f227a8a5af7 100644
> --- a/drivers/hv/mshv_common.c
> +++ b/drivers/hv/mshv_common.c
> @@ -13,6 +13,7 @@
>  #include <linux/mm.h>
>  #include <asm/mshyperv.h>
>  #include <linux/resume_user_mode.h>
> +#include <linux/export.h>
>  
>  #include "mshv.h"
>  
> diff --git a/drivers/hv/mshv_root_hv_call.c b/drivers/hv/mshv_root_hv_call.c
> index a222a16107f6..c9c274f29c3c 100644
> --- a/drivers/hv/mshv_root_hv_call.c
> +++ b/drivers/hv/mshv_root_hv_call.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/export.h>
>  #include <asm/mshyperv.h>
>  
>  #include "mshv_root.h"
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 3c9b02471760..23ce1fb70de1 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -18,6 +18,7 @@
>  #include <linux/slab.h>
>  #include <linux/prefetch.h>
>  #include <linux/io.h>
> +#include <linux/export.h>
>  #include <asm/mshyperv.h>
>  
>  #include "hyperv_vmbus.h"

Reviewed-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

