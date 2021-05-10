Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDCE377E8F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhEJItw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:49:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJItv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620636527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vnGpvIn/OC6naRdou+qWD5vB8Pajw3E3BttE4VJxDus=;
        b=Q9LuQ8sCaSB4885NQHA3CVLgfHwiljSEw9tyjdO194mekw0f/0CASTd8ebBrQVVb35SnQX
        3u5VodBvyr0lve/De05Pyd3QUAZaEqBA7rRR1IXivZF1uNzcSS4PdE6VbJh+JNF+HMwIA7
        ytR41y7hQgiu7JErreSThCSc2zQjG7Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-lJCh_t-aNQ-R8RaX8LEbBw-1; Mon, 10 May 2021 04:48:45 -0400
X-MC-Unique: lJCh_t-aNQ-R8RaX8LEbBw-1
Received: by mail-wm1-f70.google.com with SMTP id x7-20020a7bc2070000b0290149dcabfd85so3249635wmi.8
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 01:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vnGpvIn/OC6naRdou+qWD5vB8Pajw3E3BttE4VJxDus=;
        b=uEg6zgDMd3x2tbYaWwaQpCOFE6Dbkxx6BmlMkqC9fhjv34bzm/nBAs07ljWh3X81j1
         kIUnSOf+pl8Ra1vGKfM3FiriZJ9kczlUYnxYkedJ+/hcqAOiF5Gkz39RSo2d9t9J3ACm
         +dRijnP8zRvOu1w1X96FK0aswdUJJfbcAuoAqEsoHkn9CvcpQRtDiRk8GfxktK+JlwYn
         0WBd4c47BUrfOY0R3T/rS9LNH3In4Vfn+y+vFhLMzJlk2PhMsVgQp4740VS9AYp52x8Y
         Aj+TpL2MUSXtPNnW1jixgDYarp/YAB0ZdJW2jueWUqFWZcdTmOpHLrUiaK71bJkOM+As
         FSAQ==
X-Gm-Message-State: AOAM532yjJUCkAdLOAbY7YY3bvADxScqC8w04LhV2bfVUnOEn7+fsRuV
        Azg8ryhKtY5dnwij/sRPj1HXwy3GM8QfFNIZ49YlN2I2mmFTTcInS3K+B1LvgY3o2+16GklkGaP
        J1TWxPmplwFsY49ooROdz4Wu4oB23nSm9Oi6uh6K4rty4NQh+SJ+U5+nw+dIqGTh7
X-Received: by 2002:a1c:9a95:: with SMTP id c143mr25302408wme.143.1620636524104;
        Mon, 10 May 2021 01:48:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN1AtMCzyBBFXrRvYpJzkM/McsavjduMVcTEH6LMrPsvYOp7hP3fRcaROhP/hxQ7WZ62E7Nw==
X-Received: by 2002:a1c:9a95:: with SMTP id c143mr25302389wme.143.1620636523907;
        Mon, 10 May 2021 01:48:43 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j13sm21697404wrw.93.2021.05.10.01.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 01:48:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: hyper-v: Task srcu lock when accessing
 kvm_memslots()
In-Reply-To: <1620634919-4563-1-git-send-email-wanpengli@tencent.com>
References: <1620634919-4563-1-git-send-email-wanpengli@tencent.com>
Date:   Mon, 10 May 2021 10:48:42 +0200
Message-ID: <87mtt3vus5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
>  WARNING: suspicious RCU usage
>  5.13.0-rc1 #4 Not tainted
>  -----------------------------
>  ./include/linux/kvm_host.h:710 suspicious rcu_dereference_check() usage!
>  
> other info that might help us debug this:
>
> rcu_scheduler_active = 2, debug_locks = 1
>  1 lock held by hyperv_clock/8318:
>   #0: ffffb6b8cb05a7d8 (&hv->hv_lock){+.+.}-{3:3}, at: kvm_hv_invalidate_tsc_page+0x3e/0xa0 [kvm]
>  
> stack backtrace:
> CPU: 3 PID: 8318 Comm: hyperv_clock Not tainted 5.13.0-rc1 #4
> Call Trace:
>  dump_stack+0x87/0xb7
>  lockdep_rcu_suspicious+0xce/0xf0
>  kvm_write_guest_page+0x1c1/0x1d0 [kvm]
>  kvm_write_guest+0x50/0x90 [kvm]
>  kvm_hv_invalidate_tsc_page+0x79/0xa0 [kvm]
>  kvm_gen_update_masterclock+0x1d/0x110 [kvm]
>  kvm_arch_vm_ioctl+0x2a7/0xc50 [kvm]
>  kvm_vm_ioctl+0x123/0x11d0 [kvm]
>  __x64_sys_ioctl+0x3ed/0x9d0
>  do_syscall_64+0x3d/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> kvm_memslots() will be called by kvm_write_guest(), so we should take the srcu lock.
>
> Fixes: e880c6ea5 (KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary CPUs)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/hyperv.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f98370a3..f00830e 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1172,6 +1172,7 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
>  {
>  	struct kvm_hv *hv = to_kvm_hv(kvm);
>  	u64 gfn;
> +	int idx;
>  
>  	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
>  	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
> @@ -1190,9 +1191,16 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
>  	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
>  
>  	hv->tsc_ref.tsc_sequence = 0;
> +
> +	/*
> +	 * Take the srcu lock as memslots will be accessed to check the gfn
> +	 * cache generation against the memslots generation.
> +	 */
> +	idx = srcu_read_lock(&kvm->srcu);
>  	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
>  			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
>  		hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
> +	srcu_read_unlock(&kvm->srcu, idx);
>  
>  out_unlock:
>  	mutex_unlock(&hv->hv_lock);

Thanks! 

Do we need to do the same in kvm_hv_setup_tsc_page()?

-- 
Vitaly

