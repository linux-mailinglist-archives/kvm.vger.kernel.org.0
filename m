Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895D527A936
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 10:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgI1IBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 04:01:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726615AbgI1IBg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 04:01:36 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601280095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T7R9m9FhJdi6KLm4nsGm74cvSvwdnrQBjKd7fzOBDVM=;
        b=dDN2tQ4zgFmba8//fcehJVu3v8bfNbMCzBvuaLl4hgnFeQRM5LzshOdLjWLG4e7K0Oa0it
        +jHjAvzcZ4U9LijhTm7kIOHJ3omeAHjMHM7QBl3ufrmM42i2BOtIH/rAtQWfW3KMfOmHFm
        wJL72FwnLDh6bSVz8wzj7WUhRMYy2O8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-W_MVNzZhPI21KsxUaFcd8Q-1; Mon, 28 Sep 2020 04:01:31 -0400
X-MC-Unique: W_MVNzZhPI21KsxUaFcd8Q-1
Received: by mail-wm1-f72.google.com with SMTP id c204so61918wmd.5
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 01:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T7R9m9FhJdi6KLm4nsGm74cvSvwdnrQBjKd7fzOBDVM=;
        b=osiKy4StrcRNfc/KwcK1lWXXHJUMrtyk1hqObDi5ffw1Eow+6aAMDU6NbmoN9OU5rr
         f+fN91y9hnL5XzH8ZLYTSmELT057nWNO++WpvarhahruJbRq4YmEyuaXxoZbMxq38ycC
         HxWVu0PaCI/tMmuNfrswxHho9iU5HB9SiK8KIrcMjreAyxFJ44uE8vJ0Vv0CBegc69k/
         W4PZh/oK/lK+dJRSsFowj6lrFx5BG4ruNlCIuwOTaer2GMuwVmxKnbUsfbNiiMeEdrIW
         sgJJaNfsHwig1V1bN+3NxM5jleqt6lIRXGHJqLvNjXil1VvUQIGN3yWFG2UvESymfFp6
         aWSQ==
X-Gm-Message-State: AOAM533BgrLgVDJcnzudFKHpeZ/RAi82r/Sg+5qzggBWZPPYVaDGBPTU
        MZv62IA66WCZR3uPWwbH1PE8NbBbDhexmSaJs+LS68Xn0zbtitV2cN+meBTMGT4mUfclq4gyUZK
        2NPNIEOzd3j0H
X-Received: by 2002:a1c:9ad0:: with SMTP id c199mr320691wme.54.1601280089806;
        Mon, 28 Sep 2020 01:01:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwP7b6XUT7QVZLutTp3aUJBUofOOz7c2L1LlPUU8NuHqEv78dhfLvgZQfFAp+/Mvmp18QizUQ==
X-Received: by 2002:a1c:9ad0:: with SMTP id c199mr320667wme.54.1601280089566;
        Mon, 28 Sep 2020 01:01:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:18a0:e78d:6703:1066? ([2001:b07:6468:f312:18a0:e78d:6703:1066])
        by smtp.gmail.com with ESMTPSA id f12sm145381wmf.26.2020.09.28.01.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 01:01:28 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Initialize ir_list and ir_list_lock regardless
 of AVIC enablement
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     joro@8bytes.org
References: <20200922084446.7218-1-suravee.suthikulpanit@amd.com>
 <1b8ff096-85a4-3dda-61d3-9a44ca6bb360@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dafba8d1-8e1b-a3d3-d95f-e5581b26066d@redhat.com>
Date:   Mon, 28 Sep 2020 10:01:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1b8ff096-85a4-3dda-61d3-9a44ca6bb360@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/09/20 07:53, Suravee Suthikulpanit wrote:
> Hi,
> 
> Are there any issues or concerns about this patch?

Yes, sorry I haven't replied yet.  Looks like Linus is doing an -rc8 so
there's plenty of time to have it in 5.9.

The thing I'm wondering is, why is svm_update_pi_irte doing anything if
you don't have AVIC enabled?  In other word, this might not be the root
cause of the bug.  You always get to the "else" branch of the loop of
course, and I'm not sure how irq_set_vcpu_affinity returns something
with pi.prev_ga_tag set.

Thanks,

Paolo

> Thank you,
> Suravee
> 
> On 9/22/20 3:44 PM, Suravee Suthikulpanit wrote:
>> The struct vcpu_svm.ir_list and ir_list_lock are being accessed even when
>> AVIC is not enabled, while current code only initialize the list and
>> the lock only when AVIC is enabled. This ended up trigger NULL pointer
>> dereference bug in the function vm_ir_list_del with the following
>> call trace:
>>
>>      svm_update_pi_irte+0x3c2/0x550 [kvm_amd]
>>      ? proc_create_single_data+0x41/0x50
>>      kvm_arch_irq_bypass_add_producer+0x40/0x60 [kvm]
>>      __connect+0x5f/0xb0 [irqbypass]
>>      irq_bypass_register_producer+0xf8/0x120 [irqbypass]
>>      vfio_msi_set_vector_signal+0x1de/0x2d0 [vfio_pci]
>>      vfio_msi_set_block+0x77/0xe0 [vfio_pci]
>>      vfio_pci_set_msi_trigger+0x25c/0x2f0 [vfio_pci]
>>      vfio_pci_set_irqs_ioctl+0x88/0xb0 [vfio_pci]
>>      vfio_pci_ioctl+0x2ea/0xed0 [vfio_pci]
>>      ? alloc_file_pseudo+0xa5/0x100
>>      vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
>>      ? vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
>>      __x64_sys_ioctl+0x96/0xd0
>>      do_syscall_64+0x37/0x80
>>      entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Therefore, move the initialziation code before checking for AVIC enabled
>> so that it is always excuted.
>>
>> Fixes: dfa20099e26e ("KVM: SVM: Refactor AVIC vcpu initialization into
>> avic_init_vcpu()")
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 2 --
>>   arch/x86/kvm/svm/svm.c  | 3 +++
>>   2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index ac830cd50830..1ccf13783785 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -572,8 +572,6 @@ int avic_init_vcpu(struct vcpu_svm *svm)
>>       if (ret)
>>           return ret;
>>   -    INIT_LIST_HEAD(&svm->ir_list);
>> -    spin_lock_init(&svm->ir_list_lock);
>>       svm->dfr_reg = APIC_DFR_FLAT;
>>         return ret;
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index c44f3e9140d5..714d791fe5a5 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1225,6 +1225,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>>       svm_init_osvw(vcpu);
>>       vcpu->arch.microcode_version = 0x01000065;
>>   +    INIT_LIST_HEAD(&svm->ir_list);
>> +    spin_lock_init(&svm->ir_list_lock);
>> +
>>       return 0;
>>     free_page4:
>>
> 

