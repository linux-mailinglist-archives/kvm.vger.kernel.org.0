Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75FB3B2871
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 09:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhFXHVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 03:21:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230132AbhFXHVc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 03:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624519153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R6n4tQbCk5yGGBrv9C1IRK1k5LS9c127mX5xrH4taZU=;
        b=cDuPmdBAC+RUvjfaDNP1AkcTF5eAc7L/oRj6/jXoCNtssukNBXMIcNL3OCgTjtWI6nLf6Z
        UgyIPUm/nfc9Q3cqu8R74en5GpTpw/oAT6RwjmvKnW7v4stRe8u6aRBkf14+AY4UzPEqL9
        r7l2EaZ9ajYWqYk7yQqHJ1fG28+6yFk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-iN5MR40gNUWsx_ayJ2qCiw-1; Thu, 24 Jun 2021 03:19:12 -0400
X-MC-Unique: iN5MR40gNUWsx_ayJ2qCiw-1
Received: by mail-wm1-f69.google.com with SMTP id l9-20020a05600c1d09b02901dc060832e2so1275556wms.1
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 00:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R6n4tQbCk5yGGBrv9C1IRK1k5LS9c127mX5xrH4taZU=;
        b=OcgxJnYNovk62Nq8e7PNlgZl69zx8JV7r5sWjSLHukoqg1STTaGPkOWZzsQeD1Bc1u
         xN7mB/EKI4V6gsHl8yJ3dOPCwLcKJHryOYoztht7T3qacxqr/9xCXsPuN/5sxB7GlcQ8
         ik8vFMO5+abYzCFH2xz5oGCgH+9Rf3KGfQ4K5usG4VHpXOcdPtDGQMn5RxMbeRJaszs2
         tc/scQUNh5dvtBaNu37eEHOuhuzCYLUIhIp+4tmXwtsvabw3UtbayYV3obkZvbJ3O17v
         kjfnGz2Ut6sBHUHv7SIN60Y9FLFj7otrOlcB94wpH7BMs7ubiLkhRuVCk/H8I42FR+jI
         c5DA==
X-Gm-Message-State: AOAM531HECpYCkC480Z0QPts9gFMhBAR38Uez24vFkDtbklXYqdiZLJe
        ZNEWmll+ej6ZLw23gFS4rsvKm4RF+X5ZT8AKNEO3QHT8lVkp7x77kgRNyCyR6zCk6uGTWsTwTXG
        B1qFFwilotFdV
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr2663891wrk.197.1624519150935;
        Thu, 24 Jun 2021 00:19:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGKo51RB8xyk8mP5Z+OGJr8xFyOiKLx8k3DwXs4BHwm1bEoR5CAQaTWbrQw0zA0na7dnAfgQ==
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr2663874wrk.197.1624519150798;
        Thu, 24 Jun 2021 00:19:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p15sm1947285wmq.43.2021.06.24.00.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 00:19:10 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Fix mapping length truncation in
 m{,un}map()
To:     Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com
Cc:     wanghaibin.wang@huawei.com
References: <20210624070931.565-1-yuzenghui@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <836e058c-6bb1-7643-98c2-713b111c9fb8@redhat.com>
Date:   Thu, 24 Jun 2021 09:19:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210624070931.565-1-yuzenghui@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 09:09, Zenghui Yu wrote:
> max_mem_slots is now declared as uint32_t. The result of (0x200000 * 32767)
> is unexpectedly truncated to be 0xffe00000, whilst we actually need to
> allocate about, 63GB. Cast max_mem_slots to size_t in both mmap() and
> munmap() to fix the length truncation.
> 
> We'll otherwise see the failure on arm64 thanks to the access_ok() checking
> in __kvm_set_memory_region(), as the unmapped VA happen to go beyond the
> task's allowed address space.
> 
>   # ./set_memory_region_test
> Allowed number of memory slots: 32767
> Adding slots 0..32766, each memory region with 2048K size
> ==== Test Assertion Failure ====
>    set_memory_region_test.c:391: ret == 0
>    pid=94861 tid=94861 errno=22 - Invalid argument
>       1	0x00000000004015a7: test_add_max_memory_regions at set_memory_region_test.c:389
>       2	 (inlined by) main at set_memory_region_test.c:426
>       3	0x0000ffffb8e67bdf: ?? ??:0
>       4	0x00000000004016db: _start at :?
>    KVM_SET_USER_MEMORY_REGION IOCTL failed,
>    rc: -1 errno: 22 slot: 2615
> 
> Fixes: 3bf0fcd75434 ("KVM: selftests: Speed up set_memory_region_test")
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>   tools/testing/selftests/kvm/set_memory_region_test.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index d79d58eada9f..85b18bb8f762 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -376,7 +376,7 @@ static void test_add_max_memory_regions(void)
>   	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
>   		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
>   
> -	mem = mmap(NULL, MEM_REGION_SIZE * max_mem_slots + alignment,
> +	mem = mmap(NULL, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
>   		   PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>   	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
>   	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
> @@ -401,7 +401,7 @@ static void test_add_max_memory_regions(void)
>   	TEST_ASSERT(ret == -1 && errno == EINVAL,
>   		    "Adding one more memory slot should fail with EINVAL");
>   
> -	munmap(mem, MEM_REGION_SIZE * max_mem_slots + alignment);
> +	munmap(mem, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment);
>   	munmap(mem_extra, MEM_REGION_SIZE);
>   	kvm_vm_free(vm);
>   }
> 

Queued, thanks.

Paolo

