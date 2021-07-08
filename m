Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8523C17EF
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhGHRTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 13:19:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhGHRTE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 13:19:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625764581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+NjBGd/4T9twKgX/ZHNdm+93Uf3nnJPB993PVyrBW5E=;
        b=GleDX/IDgJAdw7BZlXSOaZG0vbxfpWGFnSY0NrJUjqwGM79IwzCyjEvOCYhIMAjDe3yXl+
        K/Aws7Kd3vKyLJ7XjYTMjVFFS7gHanKyULk0FVClavW3WtOb1dN3AH2o45N2A8xC2igb+k
        Ow6EgbrnFd92O/HoDd5ly7r83a2gawg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-5HQy5KGcOQC22VRGhNGjPw-1; Thu, 08 Jul 2021 13:16:20 -0400
X-MC-Unique: 5HQy5KGcOQC22VRGhNGjPw-1
Received: by mail-ej1-f70.google.com with SMTP id rl7-20020a1709072167b02904f7606bd58fso1701188ejb.11
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 10:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+NjBGd/4T9twKgX/ZHNdm+93Uf3nnJPB993PVyrBW5E=;
        b=WWDt7Fdrkn6PzCHFyss4J4RrNYjwgnuwSlb9r7yxOuWpKejXi19DMd8f97vQpRUXK9
         p9KPW8pNxgzh24hKmcrU2R8pVx9xbzC5jMk0ry+d6AwYW6R3+vwhGDmED8+hqgsIQYNh
         3INHvQdDE5KOQSDs4YPL5sbOoR/qA7D1Z0CbEd1ajhkmH+4vsbfvWzClLj1yO/hR3zdB
         qQg/AeBPLBVU7GR1snkRiJCzRfncGiuu/qK0kw+QBPujMHRDiupxdi3NBtxyL1NgB80+
         52455tEUf+FyIXC6IP01XlmheDQUAtgQ5+PJjS8cHq9b19jhmxP/MbVHG7ViMoPTG4N4
         +AAg==
X-Gm-Message-State: AOAM530p4P533i2r6BLc/Rx5q4edfP1Q3aTx65JY/d0z1EeHQucEkTPh
        nX/CQwsfXOuw1IGivoLcjMQezIYQF4woMaJmEDJgD5LSkzZJUbg4gsVH/p0mt/nvHQPRPw/xN1x
        9NwwMWNvsKCcA
X-Received: by 2002:a05:6402:419:: with SMTP id q25mr40332855edv.331.1625764579274;
        Thu, 08 Jul 2021 10:16:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQVvnmaFFbGkreLluH7iRVwQq7iwQchIQvrtFvvU2a0y+JUwjav42PUgwI1804W02tpXYMtA==
X-Received: by 2002:a05:6402:419:: with SMTP id q25mr40332821edv.331.1625764578995;
        Thu, 08 Jul 2021 10:16:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e24sm1138632ejx.100.2021.07.08.10.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 10:16:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Address extra memslot parameters in
 vm_vaddr_alloc
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu, seanjc@google.com, maz@kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20210702201042.4036162-1-ricarkol@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eebf14e1-cd5c-a55d-cd68-620df1c9bcf0@redhat.com>
Date:   Thu, 8 Jul 2021 19:16:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702201042.4036162-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/07/21 22:10, Ricardo Koller wrote:
> Commit a75a895e6457 ("KVM: selftests: Unconditionally use memslot 0 for
> vaddr allocations") removed the memslot parameters from vm_vaddr_alloc.
> It addressed all callers except one under lib/aarch64/, due to a race
> with commit e3db7579ef35 ("KVM: selftests: Add exception handling
> support for aarch64")
> 
> Fix the vm_vaddr_alloc call in lib/aarch64/processor.c.
> 
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   tools/testing/selftests/kvm/lib/aarch64/processor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 9f49f6caafe5..632b74d6b3ca 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -401,7 +401,7 @@ void route_exception(struct ex_regs *regs, int vector)
>   void vm_init_descriptor_tables(struct kvm_vm *vm)
>   {
>   	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> -			vm->page_size, 0, 0);
> +			vm->page_size);
>   
>   	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>   }
> 

Queued, thanks.

Paolo

