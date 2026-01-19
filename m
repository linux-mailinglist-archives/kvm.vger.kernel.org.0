Return-Path: <kvm+bounces-68485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A498D3A227
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D348A3066440
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 08:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7213502B7;
	Mon, 19 Jan 2026 08:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEGGYe+d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D96F350A1C
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 08:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768812841; cv=none; b=bkKWbCqUvvP+eed1b/LytxlLoV9cBmI7ymW3hV5TIqDznLtY+PiJJRfk1OW+Fy0Mu6+LUK2utn+YYXVeU2Qyv8oRyuBF3tdtH2IBAB1Batkh1zszpmMKOlbP8MW84TSHZzDTog4PuRhfeyh9eVj4spj6mWtIvJl3cUAfFavvpyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768812841; c=relaxed/simple;
	bh=uba0nFvOJYEuWOISWCB5ubiPWwmNrXiSA4weuwW3O+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tehT5LU38/DXJQQmYeNjdbxmO2szAbjxYjkw8IW3haDfMqq9lB+kDo6D0pfdwu1Ic2XsS5YYSMTUT9Jy0PpItknbmP/VEjG/6c0DlKa7DgJQHXkEevVtG7tgS8scbyqTdqpxVxdf+Ikb1qKuOY/WloM+9yAjoBlt6Ha7qQn5Um0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEGGYe+d; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a09d981507so30651695ad.1
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 00:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768812839; x=1769417639; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PyBTzhCyrfYcBCTy28+HxsdxbT6bLWAKi1ungEuBkwE=;
        b=JEGGYe+d0B5BPvIr0rJeduUW1/ZRO3pkuqdti0Dobdk2hjaTaAEiCY7T4svV/WDAkM
         667p8J4KE+1Q/WIBQg+LCsYL14+ux94aitxILagNA5MHkAXqJ94N5Cge+mvMY5lQq7tQ
         wyprOGkQOXmEYffj+6x9fsaA0skvNQJQ6Rvmp+oUzUWCRKpigQT2HFmI/6w+pjBHkwbq
         JbmpNAEKqOBZlg+va3w4lSKsQqwt8rsgQeK6Wnx3EOHhbVTojJPyRvQzvqHQQXIhAsxg
         DGqGUzfPo7ZuFUYRUgUFknYhrlD8yfJziUkkGYOaapzKQQN6mQTBOLWivtl8PU0APb7z
         8U4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768812839; x=1769417639;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PyBTzhCyrfYcBCTy28+HxsdxbT6bLWAKi1ungEuBkwE=;
        b=mK5cJwDunF6KgDJaPqQXs9ZUIagPlirn3VkAddS9AgVwh8orf4To5+nWKyC0XPyfIp
         nCblmX/0yzu6piVQJ3lPstXGvgFC03iwkndEwdUwhXReVGd91m5vo6er8k5Bwkc2ph4B
         xDcgVPbnjlYy4cLaX84SHwE8e3NotI9SoLAJZ44f+2PriCIXWPxQPnVjCMJzJn2+mNc5
         eubLCRg6w4LHgwg9IvhkhEKY+yAd+Bg4/WlzQtpvgDhwQInkL3rArOKItryAFz5Nh8v7
         PC7h2MwwwNOMipSwLXo86gcLSzCuAUzv14XbNzME9bE9/+6QxP3pjhCTa6syKtsF7/qq
         bjyg==
X-Gm-Message-State: AOJu0YyKVnI2gmzCK2+cQ1cvwriMuYuiiFoIVKaG/tbawrlhicX0/l9g
	Y+MCnzBLcahIjHcq4llG542fbQPn4Gp/RJtqThOZpTea6Z1Fgol9QyBeR6/pYnvVsAY=
X-Gm-Gg: AZuq6aJsucpv+/7l7EqC/1hmWRmFcY1EmkJjcs44bhCALfxwrRgWh8L/Ny/7VE+al9z
	9WylnHEOIFdrqcnhc0MIYkIVDYMoWu15Z4yeYeBkZdRqMA1e6EjG7Fh3dCLRdjyMkr+47VtKZ1E
	kBEOutcEa29QeZR7JECeo8Nzp7R891qKnSBa1Z8y4mJWb60IH2NkDo1gEWP3egIcBa0ft25Hynk
	S6ThCa2NKboWqbVZzmjTDy9trL1j4Yl+/d7KXekHmeiAntLUjhiWyUJiKZ9c8CTaEuVstK9tMaF
	fwKUs+u0RYoL2lvlFzbIiKl+AvvEmFiAXyIJvil/JacYZaUIbF4iFO5LZQeNicJ1syU6A0muPoC
	aWsX+RYW1L1eE6l8XMIV83/EoWK6uv0SA03So9WhmHVM15lrS8mVlGoaUOqkX5IwLNM+V0ubI4D
	+jl0SOJ2grFm51AXicUJTMfIUT
X-Received: by 2002:a17:902:d48d:b0:29a:69d:acdc with SMTP id d9443c01a7336-2a71781fd8emr84144655ad.25.1768812838578;
        Mon, 19 Jan 2026 00:53:58 -0800 (PST)
Received: from [10.3.165.111] ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7194224d1sm87647565ad.101.2026.01.19.00.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 00:53:58 -0800 (PST)
Message-ID: <8b4ff052-e9b8-4e57-a3a9-9383c5cd39c1@gmail.com>
Date: Mon, 19 Jan 2026 16:53:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: irqchip: KVM: Reduce allocation overhead in
 kvm_set_irq_routing()
To: Yanfei Xu <yanfei.xu@bytedance.com>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, caixiangfeng@bytedance.com,
 fangying.tommy@bytedance.com
References: <20251226062741.4014391-1-yanfei.xu@bytedance.com>
From: Yanfei Xu <isyanfei.xu@gmail.com>
In-Reply-To: <20251226062741.4014391-1-yanfei.xu@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

gentle ping :)

On 2025/12/26 14:27, Yanfei Xu wrote:
> In guests with many VFIO devices and MSI-X vectors, kvm_set_irq_routing()
> becomes a high-overhead operation. Each invocation walks the entire IRQ
> routing table and reallocates/frees every routing entry.
>
> As the routing table grows on each call, entry allocation and freeing
> dominate the execution time of this function. In scenarios such as VM
> live migration or live upgrade, this behavior can introduce unnecessary
> downtime.
>
> Allocate memory for all routing entries in one shot using kcalloc(),
> allowing them to be freed together with a single kfree() call.
>
> Example: On a VM with 120 vCPUs and 15 VFIO devices (virtio-net), the
> total number of calls to kzalloc and kfree is over 20000. With this
> change, it is reduced to around 30.
>
> Reported-by: Xiangfeng Cai <caixiangfeng@bytedance.com>
> Signed-off-by: Yanfei Xu <yanfei.xu@bytedance.com>
> ---
> v1->v2:
> 1. fix variable 'r' is used uninitialized when a 'if' condition is true
> 2. simplified free_irq_routing_table() by removing the iteration over the
>     entries and the hlist cleanup.
>
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/irqchip.c       | 34 +++++++++++-----------------------
>   2 files changed, 12 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d93f75b05ae2..cc27490bef4b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -692,6 +692,7 @@ struct kvm_kernel_irq_routing_entry {
>   struct kvm_irq_routing_table {
>   	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
>   	u32 nr_rt_entries;
> +	struct kvm_kernel_irq_routing_entry *entries_addr;
>   	/*
>   	 * Array indexed by gsi. Each entry contains list of irq chips
>   	 * the gsi is connected to.
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 6ccabfd32287..56779394033d 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -98,21 +98,10 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
>   
>   static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
>   {
> -	int i;
> -
>   	if (!rt)
>   		return;
>   
> -	for (i = 0; i < rt->nr_rt_entries; ++i) {
> -		struct kvm_kernel_irq_routing_entry *e;
> -		struct hlist_node *n;
> -
> -		hlist_for_each_entry_safe(e, n, &rt->map[i], link) {
> -			hlist_del(&e->link);
> -			kfree(e);
> -		}
> -	}
> -
> +	kfree(rt->entries_addr);
>   	kfree(rt);
>   }
>   
> @@ -186,6 +175,12 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   	new = kzalloc(struct_size(new, map, nr_rt_entries), GFP_KERNEL_ACCOUNT);
>   	if (!new)
>   		return -ENOMEM;
> +	e = kcalloc(nr, sizeof(*e), GFP_KERNEL_ACCOUNT);
> +	if (!e) {
> +		r = -ENOMEM;
> +		goto out;
> +	}
> +	new->entries_addr = e;
>   
>   	new->nr_rt_entries = nr_rt_entries;
>   	for (i = 0; i < KVM_NR_IRQCHIPS; i++)
> @@ -193,25 +188,20 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   			new->chip[i][j] = -1;
>   
>   	for (i = 0; i < nr; ++i) {
> -		r = -ENOMEM;
> -		e = kzalloc(sizeof(*e), GFP_KERNEL_ACCOUNT);
> -		if (!e)
> -			goto out;
> -
>   		r = -EINVAL;
>   		switch (ue->type) {
>   		case KVM_IRQ_ROUTING_MSI:
>   			if (ue->flags & ~KVM_MSI_VALID_DEVID)
> -				goto free_entry;
> +				goto out;
>   			break;
>   		default:
>   			if (ue->flags)
> -				goto free_entry;
> +				goto out;
>   			break;
>   		}
> -		r = setup_routing_entry(kvm, new, e, ue);
> +		r = setup_routing_entry(kvm, new, e + i, ue);
>   		if (r)
> -			goto free_entry;
> +			goto out;
>   		++ue;
>   	}
>   
> @@ -228,8 +218,6 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   	r = 0;
>   	goto out;
>   
> -free_entry:
> -	kfree(e);
>   out:
>   	free_irq_routing_table(new);
>   

