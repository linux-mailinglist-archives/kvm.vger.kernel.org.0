Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B963BBA9D
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 11:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhGEJ76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 05:59:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGEJ76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 05:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625479041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TT9vJEoaVxuLffb3JgMy8FhvtJ+ac7w2RFyRIaNwv0E=;
        b=YovEjDsm7fretM6ovXvp+U6EfBsmmkOPDb0n4oDM1B4n6hrFmM6WMgYTlU9Txdz7SFmNo+
        CQAbSXBAXOaBhli7RdkFKUUnNnE7iDX9tuZRgAnBSpBosG4MN+0a4q9VzZCOpZkeINQF8g
        vcNhapfrKK/UB77nT6lgXzcPDjBm7Ws=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-BhOoArC3Mu-_imEYm7TN-w-1; Mon, 05 Jul 2021 05:57:20 -0400
X-MC-Unique: BhOoArC3Mu-_imEYm7TN-w-1
Received: by mail-wm1-f69.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so2914845wmj.8
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 02:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TT9vJEoaVxuLffb3JgMy8FhvtJ+ac7w2RFyRIaNwv0E=;
        b=QbVbeVJpzNwszTIpWNyT/lwI7QaJqd44esCyhyfwLXxJ89fw/TqBHrmsV3Rng4aZrT
         AO+/YRbU8lTXHAOCNW2+SYrfiXRFP2I5Z5c0YZYHwXWw1pqocgnwNEtsofKne8j9KtOm
         OZ91APVUXzP0l351OfPm27RT145JDuEXTnOmt9axF1wz6dqrTqL3qDbeIYtc7zAIWbZx
         IlK01xXNBJCPbhnrbBcJ+U/9km41+EUZYUUxwmFErsPU8NduDY/0SNePlEJaJGNuhgLg
         KxyXN7SxNyECF7Sm3Y6CVlpFxzrPn0s5ZcGnIdpSJvj5jYpHGxwD7Ff4426Qiixi16DW
         IFSQ==
X-Gm-Message-State: AOAM532/Aa+a+xochfxJojYawZLdNhcXUcFwq+QuI0o2Kx1DThUgj18m
        EnhSWvTBT+Rfy1jZ0xf+vZ/d9NFCrb/uzd7fzFS7itK2V5Ox8Ds7/wGknkcs7/Oepccd7AbHLJk
        sMfWHqinlRc0h
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr13572360wmb.39.1625479038956;
        Mon, 05 Jul 2021 02:57:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUUJkycBN1IGxatVRV8AT19lHi23ORSBLStzRwyll5y4tv8tW5FBc57g3oPpWeWfi+32GUYA==
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr13572348wmb.39.1625479038812;
        Mon, 05 Jul 2021 02:57:18 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v15sm21840814wmj.39.2021.07.05.02.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 02:57:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Address extra memslot parameters in
 vm_vaddr_alloc
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Cc:     maz@kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu
References: <20210702201042.4036162-1-ricarkol@google.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <441f3230-7d31-8a14-f100-a0c6063e3d07@redhat.com>
Date:   Mon, 5 Jul 2021 11:57:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210702201042.4036162-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 7/2/21 10:10 PM, Ricardo Koller wrote:
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 9f49f6caafe5..632b74d6b3ca 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -401,7 +401,7 @@ void route_exception(struct ex_regs *regs, int vector)
>  void vm_init_descriptor_tables(struct kvm_vm *vm)
>  {
>  	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> -			vm->page_size, 0, 0);
> +			vm->page_size);
>  
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
> 

