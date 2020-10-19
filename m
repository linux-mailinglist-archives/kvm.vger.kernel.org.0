Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B52292AE6
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 17:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgJSPyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 11:54:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730025AbgJSPyx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 11:54:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603122891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4z1phI+SVOyafuXVS/D26W6DGzBcOPHN9ROuznA6UNI=;
        b=SnbcoH8JWaAdp/oTyzef6Gh2DqRof8EBN2p+gCIe/4s0unoUsoX1triZeR1s29ojM2QrMH
        dHL7hKd7CiywfS93LuAqsicvnx080zfhsaGJgSG8rOZmAPHrb/cFC1SR4vQzqsRmBrRQdo
        QJ8ZQuU9bzqzfw38PvdvOM75s7B1z6M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-CfOElL6BNcWnurDIbN5qRA-1; Mon, 19 Oct 2020 11:54:50 -0400
X-MC-Unique: CfOElL6BNcWnurDIbN5qRA-1
Received: by mail-wr1-f72.google.com with SMTP id b11so55122wrm.3
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 08:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4z1phI+SVOyafuXVS/D26W6DGzBcOPHN9ROuznA6UNI=;
        b=sxsyBW546x19Mq+zRT3lMs7lQEfTHp62c7WHedF6ScepuNm921fxlkKFuzruynMal4
         X/MOrswgvlHwvzQZ4RCLAB4Gj8AQKeT7x2efp54z/LIPf2iajHP+Q5w/z5RA6OTPYbFJ
         ggKFnjPljXl971/aFP+XBbIYNSPEL/p+ggIzFYB3msGQSOdUbJfcE6TtujA/CD8GA7uE
         YmSwDBCvlX8oKK+Kz5B8Eu/QtCpQs0gv+Hd+L8FvttWONWE3qyCAmZkheVMIbbxLXURv
         9hMQUgaDB1RBdeu6d+3LtEBCYPXLrFQA5HgfKk465xHWSHhr6edOUfCligN4Mq/PwX5y
         6aQg==
X-Gm-Message-State: AOAM5315BmYgeCMs5gMo284M7z38kE+e56hQGRQVpmiMI4JVCnhsE0oJ
        eGUqdke7TpngsPqTW+KV3ppz5cC62RTk8IXGtLLsg3yMy7u89XHWeKUhd2quVyobXt7L4+bkaCL
        p4a/jIEH2hfFX
X-Received: by 2002:a05:600c:255:: with SMTP id 21mr39445wmj.69.1603122888718;
        Mon, 19 Oct 2020 08:54:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzdPa+6nVJnTD0myUKcXmclhTnkyjSzj09HiHnr2jgW57lnv4yiOFefo5M+s3BG0ruzYbjQQ==
X-Received: by 2002:a05:600c:255:: with SMTP id 21mr39417wmj.69.1603122888503;
        Mon, 19 Oct 2020 08:54:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u20sm1188wmm.29.2020.10.19.08.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 08:54:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Initialize prev_ga_tag before use
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     joro@8bytes.org
References: <20201003232707.4662-1-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f45801ff-9fd8-636d-44df-74a70a41a712@redhat.com>
Date:   Mon, 19 Oct 2020 17:54:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201003232707.4662-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/20 01:27, Suravee Suthikulpanit wrote:
> The function amd_ir_set_vcpu_affinity makes use of the parameter struct
> amd_iommu_pi_data.prev_ga_tag to determine if it should delete struct
> amd_iommu_pi_data from a list when not running in AVIC mode.
> 
> However, prev_ga_tag is initialized only when AVIC is enabled. The non-zero
> uninitialized value can cause unintended code path, which ends up making
> use of the struct vcpu_svm.ir_list and ir_list_lock without being
> initialized (since they are intended only for the AVIC case).
> 
> This triggers NULL pointer dereference bug in the function vm_ir_list_del
> with the following call trace:
> 
>     svm_update_pi_irte+0x3c2/0x550 [kvm_amd]
>     ? proc_create_single_data+0x41/0x50
>     kvm_arch_irq_bypass_add_producer+0x40/0x60 [kvm]
>     __connect+0x5f/0xb0 [irqbypass]
>     irq_bypass_register_producer+0xf8/0x120 [irqbypass]
>     vfio_msi_set_vector_signal+0x1de/0x2d0 [vfio_pci]
>     vfio_msi_set_block+0x77/0xe0 [vfio_pci]
>     vfio_pci_set_msi_trigger+0x25c/0x2f0 [vfio_pci]
>     vfio_pci_set_irqs_ioctl+0x88/0xb0 [vfio_pci]
>     vfio_pci_ioctl+0x2ea/0xed0 [vfio_pci]
>     ? alloc_file_pseudo+0xa5/0x100
>     vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
>     ? vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
>     __x64_sys_ioctl+0x96/0xd0
>     do_syscall_64+0x37/0x80
>     entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Therefore, initialize prev_ga_tag to zero before use. This should be safe
> because ga_tag value 0 is invalid (see function avic_vm_init).
> 
> Fixes: dfa20099e26e ("KVM: SVM: Refactor AVIC vcpu initialization into avic_init_vcpu()")
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ac830cd50830..381d22daa4ac 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -868,6 +868,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>  			 * - Tell IOMMU to use legacy mode for this interrupt.
>  			 * - Retrieve ga_tag of prior interrupt remapping data.
>  			 */
> +			pi.prev_ga_tag = 0;
>  			pi.is_guest_mode = false;
>  			ret = irq_set_vcpu_affinity(host_irq, &pi);
>  
> 

Queued (with Cc: stable), thanks.

Paolo

