Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543FB42D935
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhJNMZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:25:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229912AbhJNMZN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 08:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634214187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tsLEF6nEeuj2TWgFK3jrwFk5nYMWWbdG3+vtYFhZCAM=;
        b=CXxsJ30wYQARZAHeKU1TnmCZ6dgTxaQzwhtB81E6yrmfnWoK/mmq9KCjQn1u/GTzY2UoCO
        31Yq1HHfpPQ6G7atjwjxhZB05kOke9GnOcas19iE9OJCZzss1u4G8yDgmGB6CABcZRqERF
        HPhuuirJ4LKD5b68eibqfIqPOhmsmf4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-pHG1uV_hPICDEDMY_dFY-w-1; Thu, 14 Oct 2021 08:23:06 -0400
X-MC-Unique: pHG1uV_hPICDEDMY_dFY-w-1
Received: by mail-ed1-f71.google.com with SMTP id p20-20020a50cd94000000b003db23619472so4989761edi.19
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 05:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tsLEF6nEeuj2TWgFK3jrwFk5nYMWWbdG3+vtYFhZCAM=;
        b=15vq74aATdXuEN2TEt/TeEnyHz3mGJCaByVQAjMjBYtWRgDpcH0Z+8KCkRY7+AM8tZ
         anF6kBuP52WOldC+uRIWqPDRhTDME7/iVyGTs9QiLU7Aiem4IR2VBOSd0VF7mbB2WUGQ
         32qvg1kkLF29JDxsubqgnohcoOH2mpZYH5OHwLZ7c0bm0D6RZLeX8bpRm5qyuGVazaWU
         xrT2DhmDFczkZ6QA2D/u1oxj0XLM8CPtzwGrBF0sgheUZNdD9HN2rHNtjQycmiHmxVOS
         oavcrMasvkKZsjONeCvxnXWJPGbpdBa636ryFYxpJSRR6Bfvg49F1MFojhaSQrl3Dk/V
         20zg==
X-Gm-Message-State: AOAM531dmHNp1BmG7qE6RjIiBpJhfpoJaFaB0I03MmTlumg/XqsScqWA
        nIgjIFYlT952nYymeIbjEI+IggHWlZPI63/qtXHlClYTPa7/7yBe1sgRK9VBg681yvHZWn87B8y
        PKmkyLefdui/n
X-Received: by 2002:a17:906:fc11:: with SMTP id ov17mr3451459ejb.249.1634214185268;
        Thu, 14 Oct 2021 05:23:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuCBu3ROOMNyyOeyNOmEpnAPfNoRnEMyAQTAov3qFdnWsj0xm8CG0BIetG7KFQqeEjkIYRuw==
X-Received: by 2002:a17:906:fc11:: with SMTP id ov17mr3451428ejb.249.1634214185039;
        Thu, 14 Oct 2021 05:23:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g8sm2602585edb.60.2021.10.14.05.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 05:23:04 -0700 (PDT)
Message-ID: <6ccde35b-bb3f-d2cb-b4a5-365cec0eff75@redhat.com>
Date:   Thu, 14 Oct 2021 14:23:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] x86/kvm: restrict kvm user region memory size
Content-Language: en-US
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, hpa@zytor.com
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
References: <20211014120151.1437018-1-snovitoll@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211014120151.1437018-1-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/21 14:01, Sabyrzhan Tasbolatov wrote:
> syzbot found WARNING in memslot_rmap_alloc[1] when
> struct kvm_userspace_memory_region .memory_size is bigger than
> 0x40000000000, which is 4GB, e.g. KMALLOC_MAX_SIZE * 100 * PAGE_SIZE.
> 
> Here is the PoC to trigger the warning:
> 
>      struct kvm_userspace_memory_region mem = {
>          .slot = 0,
>          .guest_phys_addr = 0,
>          /* + 0x100 extra to trigger kmalloc WARNING */
>          .memory_size = 0x40000000000 + 0x100,
>          .userspace_addr = 0,
>      };
> 
>      ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> 
> I couldn't find any relevant max constant to restrict unsigned long npages.
> There might be another solution with chunking big portions of pages, but
> there is already KVM_MAX_HUGEPAGE_LEVEL, though warning happens in
> memslot_rmap_alloc() when level = 1, base_gfn = 0, e.g.
> on the very first KVM_NR_PAGE_SIZES iteration.
> 
> This is, seems, valid for early Linux versions as well. Can't tell which is
> exactly can be considered for git bisect.
> Here is Commit d89cc617b954af ("KVM: Push rmap into kvm_arch_memory_slot")
> for example, Linux 3.7.

The warning is bogus in this case.  See the discussion in 
https://lkml.org/lkml/2021/9/7/669.  The right fix is simply to use 
vmalloc instead of kmalloc.

I'm woefully behind on my KVM maintainer duties, but this is on my todo 
list.

Paolo

> [1]
> Call Trace:
>   kvmalloc include/linux/mm.h:806 [inline]
>   kvmalloc_array include/linux/mm.h:824 [inline]
>   kvcalloc include/linux/mm.h:829 [inline]
>   memslot_rmap_alloc+0xf6/0x310 arch/x86/kvm/x86.c:11320
>   kvm_alloc_memslot_metadata arch/x86/kvm/x86.c:11388 [inline]
>   kvm_arch_prepare_memory_region+0x48d/0x610 arch/x86/kvm/x86.c:11462
>   kvm_set_memslot+0xfe/0x1700 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1505
>   ...
>   kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1689
>   kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c
> 
> Reported-by: syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
>   arch/x86/kvm/mmu/page_track.c | 3 +++
>   arch/x86/kvm/x86.c            | 3 +++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 21427e84a82e..e790bb341680 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -35,6 +35,9 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
>   	int  i;
>   
>   	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
> +		if (npages > KMALLOC_MAX_SIZE)
> +			return -ENOMEM;
> +
>   		slot->arch.gfn_track[i] =
>   			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
>   				 GFP_KERNEL_ACCOUNT);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index aabd3a2ec1bc..2bad607976a9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11394,6 +11394,9 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
>   
>   		WARN_ON(slot->arch.rmap[i]);
>   
> +		if (lpages > KMALLOC_MAX_SIZE)
> +			return -ENOMEM;
> +
>   		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
>   		if (!slot->arch.rmap[i]) {
>   			memslot_rmap_free(slot);
> 

