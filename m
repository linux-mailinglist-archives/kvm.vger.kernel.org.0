Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300C741C502
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343962AbhI2M60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:58:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343919AbhI2M6Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 08:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632920204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7IhsKr72AkHWnSlS1NFhAKch0JRdHqQulQ0Y+w3psvc=;
        b=XhEMpKhj6cBCn7FrVMqsweNeZqXrBwI7c6yyVddxrlU5Yr69jUUPiAHfmoVefMt9InWBtj
        TI/th0wcceh2fOQhxYP6YnOrPCPMLs0bQ6S87Z5G7dsqHF2sL+KB2bmyNFiydjKFtGHaQw
        16xIeiYBkwLNXulkTpHAC9C/2Q/XVzA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-5RZFDipzMFu3hLP6qkGn6Q-1; Wed, 29 Sep 2021 08:56:43 -0400
X-MC-Unique: 5RZFDipzMFu3hLP6qkGn6Q-1
Received: by mail-ed1-f69.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so2299600edi.12
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 05:56:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7IhsKr72AkHWnSlS1NFhAKch0JRdHqQulQ0Y+w3psvc=;
        b=KRvsG7H0kZam6vtkjRIWnZbdzUofUo+4sNy5+TinmufszaYG4Hwj2Db+JZqUGprh/y
         g4+tzAlUP9p6fGz95uhdjVEYBXZ2psFW6bVOpUkFsbz4qk0ZtYdgPzUuDsSxmfS9Oi7X
         56L7JOTe69y1IB99TwheQLatTzoGA0oIKZFvUjWPBu+DEClvCHpA0sPqW7Q5hk56XTcp
         lbrpbbPB7Z7/AjSPlnLsrSsMY2WeaunvY4/acWDuxiGt3NyfUIwYktw+Qk5jNmH0kXzc
         CKZ8L8BsVj5s/8qAC3LCNKkgubpAhG81vl6XWsATXXhSi9SO1za6Xb2EeACCNR8LTPgr
         aUgw==
X-Gm-Message-State: AOAM531cd2jnmSlLG3OXci51aXgyWyrxRx7ARvQbWmCXwzwr2Zk/hZ93
        DhWna7xXJ3LrSc/cd+8djv7WncPBVLeoRVuKf67btZ6SmadTwRbSGNXIIAdHnos3d8HD3pSC89X
        BA5RSCGT77Ctt
X-Received: by 2002:a17:906:ad5:: with SMTP id z21mr11870815ejf.109.1632920201620;
        Wed, 29 Sep 2021 05:56:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/pS49tyZl0DHErTrVe+A0+278VsjucPdVAQ3tGX6C+RNYeGLP+q79eyjCO3u7V/ZEd5RHwg==
X-Received: by 2002:a17:906:ad5:: with SMTP id z21mr11870783ejf.109.1632920201379;
        Wed, 29 Sep 2021 05:56:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f10sm1544971edu.70.2021.09.29.05.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 05:56:40 -0700 (PDT)
Message-ID: <e19a07aa-e0a5-3be7-602c-a17963a7e307@redhat.com>
Date:   Wed, 29 Sep 2021 14:56:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH -next] KVM: use vma_pages() helper
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1632900526-119643-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1632900526-119643-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/21 09:28, Yang Li wrote:
> Use vma_pages function on vma object instead of explicit computation.
> 
> Fix the following coccicheck warning:
> ./virt/kvm/kvm_main.c:3526:29-35: WARNING: Consider using vma_pages
> helper on vma
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7851f3a..8f0e9ea 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3523,7 +3523,7 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
>   static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
>   {
>   	struct kvm_vcpu *vcpu = file->private_data;
> -	unsigned long pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> +	unsigned long pages = vma_pages(vma);
>   
>   	if ((kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff) ||
>   	     kvm_page_in_dirty_ring(vcpu->kvm, vma->vm_pgoff + pages - 1)) &&
> 

Queued, thanks.

Paolo

