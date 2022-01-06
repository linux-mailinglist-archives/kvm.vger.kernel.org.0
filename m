Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71948646F
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 13:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbiAFMgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 07:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiAFMgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 07:36:45 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2E1C061245;
        Thu,  6 Jan 2022 04:36:45 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gp5so2393240pjb.0;
        Thu, 06 Jan 2022 04:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=NoGjPaQivsMsvPLvpJIAFIB5+lRj8RKV5+GIsw37iRc=;
        b=RTnJPDeSUzJA4TjwTadXWyZtBQPrUHjSNnz0aRyI6m5NQvIjelMPdMw8yqvxMLnKN6
         MQ99ExAMl9er0lOZ/1qTBqlILm0QL/Y+mU5fTeDflfPuCMbkrbmK01D1OQ+f4Bi94whI
         RKkw+8QKOKJDAxts3ugakKuqXFuOeO2tENuEHSweXO8bNmTJGF3YPMdWBgmcZoXIVO8H
         p+JqPvfiaapbr/0DZDaWAJCzKofX+wee04N+j4rlDlCi1M5EmDLryuyfs6vwqSaobH0a
         S88KXQIePJZfBcTT0BqAM33p+4uM4aHDQexe187a8SThwd9tydx2GG/1QNydchxWJRa+
         0oJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=NoGjPaQivsMsvPLvpJIAFIB5+lRj8RKV5+GIsw37iRc=;
        b=CZpvC27rkjVCp4Q54rzSn3cJGpZiaFUk3DhhontiElds2JvTxFaJ5Tum18air9FB/7
         b6VGUSjGfWFgZq644h6bQdrqo0xjbfAiWloxWPGhA0x/MFL5czhgspGA6A04VIBoEhzX
         b/UrlRv9K3cUZmx8AloToCe8fCW2wickgOT+X9s6p0G0JdcGTZK1EjkD4Mm1uErzFQh1
         pOm5MRijv0xbgy6E/2YeU1UJU2k6c7FH53bHE4QTvr2hUJQIfE1hXt/6UXArEoKg6Nf6
         L2TF2wH52PyPbm/9G0qPlIfUsoOkIph1OM8H+rWSVEdD/KL18/sWXxlGFHjpFLmrCb8l
         scDQ==
X-Gm-Message-State: AOAM5308DmDmu4LVExpGUoDaMygyN80X5DIhm/bFi7n+uU0ne08i93MF
        J4TloSrNgSQj6Vp2aWbgGF0=
X-Google-Smtp-Source: ABdhPJyN0tM8perJ1u9smSoj//wHs3VS/4LED4KAS+D5h3tR1/0Y/LHJ6ZY3McvK2Ws9EhttI+uNkQ==
X-Received: by 2002:a17:90b:1a92:: with SMTP id ng18mr9789966pjb.238.1641472604715;
        Thu, 06 Jan 2022 04:36:44 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m16sm2914161pfk.32.2022.01.06.04.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 04:36:44 -0800 (PST)
Message-ID: <9e01f081-f6c5-5597-6898-a043346063b6@gmail.com>
Date:   Thu, 6 Jan 2022 20:36:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org)" 
        <pbonzini@redhat.com>, Jietao Xiao <shawtao1125@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
References: <20220102082207.10485-1-shawtao1125@gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH] KVM:x86: Let kvm-pit thread inherit the cgroups of the
 calling process
In-Reply-To: <20220102082207.10485-1-shawtao1125@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2022 4:22 pm, Jietao Xiao wrote:
> Qemu-kvm will create several kernel threads for each VM including
> kvm-nx-lpage-re, vhost, and so on. Both of them properly inherit
> the cgroups of the calling process,so they are easy to attach to
> the VMM process's cgroups.
> 
> Kubernetes has a feature Pod Overhead for accounting for the resources
> consumed by the Pod infrastructure(e.g overhead brought by qemu-kvm),
> and sandbox container runtime usually creates a sandbox or sandbox
> overhead cgroup for this feature. By just simply adding the runtime or
> the VMM process to the sandbox's cgroup, vhost and kvm-nx-lpage-re thread
> can successfully attach to the sanbox's cgroup but kvm-pit thread cannot.

Emm, it seems to be true for kvm-pit kthread.

> Besides, in some scenarios, kvm-pit thread can bring some CPU overhead.
> So it's better to let the kvm-pit inherit the cgroups of the calling
> userspace process.

As a side note, there is about ~3% overhead in the firecracker scenario.

> 
> By queuing the attach cgroup work as the first work after the creation
> of the kvm-pit worker thread, the worker thread can successfully attach
> to the callings process's cgroups.
> 
> Signed-off-by: Jietao Xiao <shawtao1125@gmail.com>
> ---
>   arch/x86/kvm/i8254.c | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 0b65a764ed3a..c8dcfd6a9ed4 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -34,6 +34,7 @@
>   
>   #include <linux/kvm_host.h>
>   #include <linux/slab.h>
> +#include <linux/cgroup.h>
>   
>   #include "ioapic.h"
>   #include "irq.h"
> @@ -647,6 +648,32 @@ static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
>   		kvm_pit_reset_reinject(pit);
>   }
>   
> +struct pit_attach_cgroups_struct {
> +	struct kthread_work work;
> +	struct task_struct *owner;
> +	int ret;
> +};
> +
> +static void pit_attach_cgroups_work(struct kthread_work *work)
> +{
> +	struct pit_attach_cgroups_struct *attach;
> +
> +	attach = container_of(work, struct pit_attach_cgroups_struct, work);
> +	attach->ret = cgroup_attach_task_all(attach->owner, current);

This cgroup_v1 interface is also called by the vhost_attach_cgroups_work(),
as well as the kvm_vm_worker_thread() in the KVM context.

This part of the code may be a bit redundant as the number of kthreads increases.

> +}
> +
> +
> +static int pit_attach_cgroups(struct kvm_pit *pit)
> +{
> +	struct pit_attach_cgroups_struct attach;
> +
> +	attach.owner = current;
> +	kthread_init_work(&attach.work, pit_attach_cgroups_work);
> +	kthread_queue_work(pit->worker, &attach.work);
> +	kthread_flush_work(&attach.work);
> +	return attach.ret;
> +}
> +
>   static const struct kvm_io_device_ops pit_dev_ops = {
>   	.read     = pit_ioport_read,
>   	.write    = pit_ioport_write,
> @@ -683,6 +710,10 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>   	if (IS_ERR(pit->worker))
>   		goto fail_kthread;

I wonder if we could unify the kthread_create method for both vhost and kvm-pit
so that all kthreds from kvm_arch_vm agent could share the cgroup_attach_task_all()
code base and more stuff like set_user_nice().

>   
> +	ret = pit_attach_cgroups(pit);
> +	if (ret < 0)
> +		goto fail_attach_cgroups;
> +
>   	kthread_init_work(&pit->expired, pit_do_work);
>   
>   	pit->kvm = kvm;
> @@ -723,6 +754,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>   fail_register_pit:
>   	mutex_unlock(&kvm->slots_lock);
>   	kvm_pit_set_reinject(pit, false);
> +fail_attach_cgroups:
>   	kthread_destroy_worker(pit->worker);

If it fails, could we keep it at least alive and functional ?

>   fail_kthread:
>   	kvm_free_irq_source_id(kvm, pit->irq_source_id);
