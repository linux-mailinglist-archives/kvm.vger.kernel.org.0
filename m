Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC1742227E
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhJEJk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:40:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233365AbhJEJk1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 05:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633426716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2ablajv2gCgBYeJPHEpMUrKIOVkNd+b3atjbSFrddc=;
        b=JZY5f0h9QOvA9nzVeNAjm90Q9Wn6IXulYPD81UPvfSWVNI4AB46NSudfd2BXvVkSPS7tS+
        A3rHiZtA9Cbyl0tWdfgyGaApOwBKYWB+Vq6Wqn3Bv6myunTUucyyp5FsnIe5t7uf+kawt2
        wocBuQqReotixbdUCcZqmLfDb7lgk6E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-9sY0nQhmOqadP5mK4YESlw-1; Tue, 05 Oct 2021 05:38:35 -0400
X-MC-Unique: 9sY0nQhmOqadP5mK4YESlw-1
Received: by mail-ed1-f69.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso20055387edw.10
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 02:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n2ablajv2gCgBYeJPHEpMUrKIOVkNd+b3atjbSFrddc=;
        b=4lfG82b7eo/MJ11t1vDM2RzcoWrRMHjRLz0OTcrDm7OHjh30BEC8dP5JN9Yk+syhZY
         VYUSSwubwPU9912lfK8moqUNskn8I0ciPNDN+Iiroc5mLXCWk4+cEuIK0PDfR2cUBv/O
         HQ6F+AYmQvlzA9BVfSdlxnHntqEgjNy7FO3fAbTB6iBxtWY/sZjz9Km6FryeWjPyeuPl
         nW1psbpRoOP/B5DgwhGIbkMp2WeY1vAZjhZD3obAIoXOtX9SHTPpYRzzC/qgTQYL3U/J
         CXgNL/RVLeFFFFbfh1DOh+x1+QHr/c1JXqWvudzTgGaVDW1Vfl1kVZfff1VuM1AoYxBd
         /ENw==
X-Gm-Message-State: AOAM533P+2Cbp4wJZwLXFLNeLjWwPyYfEsh8JopIqSHixx6gO36gBzwi
        K2MPMOx05corjZJCOlT0Trac6mSMRu65JAjND7DZJ4u1tJGxYQ5l5YJBI52gBk16+jpa9nyf6r5
        ds1KJYaKqtwkz
X-Received: by 2002:a05:6402:42d5:: with SMTP id i21mr25080416edc.14.1633426714364;
        Tue, 05 Oct 2021 02:38:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwK+KMnSyUT3I651YmFN7W2jovRftriuXTNGSfTjg/rZz3ZiIye/SpfUhktb5wXtw619xAHhA==
X-Received: by 2002:a05:6402:42d5:: with SMTP id i21mr25080386edc.14.1633426714120;
        Tue, 05 Oct 2021 02:38:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id bt24sm7563604ejb.77.2021.10.05.02.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 02:38:33 -0700 (PDT)
Message-ID: <e734691b-e9e1-10a0-88ee-73d8fceb50f9@redhat.com>
Date:   Tue, 5 Oct 2021 11:38:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1] KVM: isolation: retain initial mask for kthread VM
 worker
Content-Language: en-US
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, mtosatti@redhat.com,
        tglx@linutronix.de, frederic@kernel.org, mingo@kernel.org,
        nilal@redhat.com, Wanpeng Li <kernellwp@gmail.com>
References: <20211004222639.239209-1-nitesh@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211004222639.239209-1-nitesh@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+Wanpeng]

On 05/10/21 00:26, Nitesh Narayan Lal wrote:
> From: Marcelo Tosatti <mtosatti@redhat.com>
> 
> kvm_vm_worker_thread() creates a kthread VM worker and migrates it
> to the parent cgroup using cgroup_attach_task_all() based on its
> effective cpumask.
> 
> In an environment that is booted with the nohz_full kernel option, cgroup's
> effective cpumask can also include CPUs running in nohz_full mode. These
> CPUs often run SCHED_FIFO tasks which may result in the starvation of the
> VM worker if it has been migrated to one of these CPUs.

There are other effects of cgroups (e.g. memory accounting) than just 
the cpumask; for v1 you could just skip the cpuset, but if 
cgroup_attach_task_all is ever ported to v2's cgroup_attach_task, we 
will not be able to separate the cpuset cgroup from the others.

Why doesn't the scheduler move the task to a CPU that is not being 
hogged by vCPU SCHED_FIFO tasks?  The parent cgroup should always have 
one for userspace's own housekeeping.

As an aside, if we decide that KVM's worker threads count as 
housekeeping, you'd still want to bind the kthread to the housekeeping 
CPUs(*).

Paolo

(*) switching from kthread_run to kthread_create+kthread_bind_mask

> Since unbounded kernel threads allowed CPU mask already respects nohz_full
> CPUs at the time of their setup (because of 9cc5b8656892: "isolcpus: Affine
> unbound kernel threads to housekeeping cpus"), retain the initial CPU mask
> for the kthread by stopping its migration to the parent cgroup's effective
> CPUs.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>   virt/kvm/kvm_main.c | 20 +++++++++++++++-----
>   1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7851f3a1b5f7..87bc193fd020 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -56,6 +56,7 @@
>   #include <asm/processor.h>
>   #include <asm/ioctl.h>
>   #include <linux/uaccess.h>
> +#include <linux/sched/isolation.h>
>   
>   #include "coalesced_mmio.h"
>   #include "async_pf.h"
> @@ -5634,11 +5635,20 @@ static int kvm_vm_worker_thread(void *context)
>   	if (err)
>   		goto init_complete;
>   
> -	err = cgroup_attach_task_all(init_context->parent, current);
> -	if (err) {
> -		kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
> -			__func__, err);
> -		goto init_complete;
> +	/*
> +	 * For nohz_full enabled environments, don't migrate the worker thread
> +	 * to parent cgroup as its effective mask may have a CPU running in
> +	 * nohz_full mode. nohz_full CPUs often run SCHED_FIFO task which could
> +	 * result in starvation of the worker thread if it is pinned on the same
> +	 * CPU.
> +	 */
> +	if (!housekeeping_enabled(HK_FLAG_KTHREAD)) {
> +		err = cgroup_attach_task_all(init_context->parent, current);
> +		if (err) {
> +			kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
> +				__func__, err);
> +			goto init_complete;
> +		}
>   	}
>   
>   	set_user_nice(current, task_nice(init_context->parent));
> 

