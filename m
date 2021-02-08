Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8743B313A39
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 17:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhBHQ4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 11:56:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234515AbhBHQzi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 11:55:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612803247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mpKQMznskIi3xd4XqVYyI2LFxEbTfjM/cP6CMM6SQOg=;
        b=PXejSgvA+0wDSLhdCDGp35yluOwQjf7jQlb442gicljiuvoWGlCEEXnXkIsVmEAuIwwAw/
        0T+mV9YAwPNj/+APmm923vUVAXumU6lpExraiOln+TP8URDCzGVZCr2eJh6pVpvlsPSgYq
        aqNZgnb4XKsPQI5xamRARbJHyAPdZ/I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-bCJgG5G0OSCYKiQV0zi8cQ-1; Mon, 08 Feb 2021 11:54:06 -0500
X-MC-Unique: bCJgG5G0OSCYKiQV0zi8cQ-1
Received: by mail-wr1-f69.google.com with SMTP id o10so3368771wru.11
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 08:54:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mpKQMznskIi3xd4XqVYyI2LFxEbTfjM/cP6CMM6SQOg=;
        b=cPvwKj8NWbDq/TeWuuVJZ2jurE3Ez25mtvix2b1SnqioQOKadNmOQo2Mo89Gepg06W
         hv2F8D4TjUhI9jkvhMeZcghgedeTEWQdmYUPK0zWw6RwVpST1U1GGQbWJylUcaWBQyRq
         1GulBTfCrS7YHB+TItTomUkbM0+ckjWP7OgKOyA/jd9ThDjufGs2WRxFD/IxegDpgud+
         YgR/yKxsGI3PjzNDL9jzCrRpPYJUrNiptLgMOIKpt3x5ll2xQMhFqlFH4JqguBeD1TnZ
         4fF/fr5fB6n+bwxOAr/siDl0ZVX7tRm1yfsEVJcPjdgWoYaaf/TYLYTJFoLCYMChD8s7
         Dflw==
X-Gm-Message-State: AOAM533EIzsHGbtI8FfQBkD1+LS17V8Wt3zu8cBr5pe2RxblOSPprWkH
        5f97vcxDGpaAnPbGeor+U72hv+Re1JT8I/SxUGUNDWC5sZQbQ+tCsRQ40yeWHzwT/NQrG4aSlsl
        j9E7p52zdx7vI
X-Received: by 2002:adf:eed0:: with SMTP id a16mr20416861wrp.107.1612803245339;
        Mon, 08 Feb 2021 08:54:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8pxFlOHeM/dPCCDsq9XQ/lmv0eCa7/y9Fce/lb6TsQPH7+aFoiq+PYgblQA0ScfhfpD1ZQA==
X-Received: by 2002:adf:eed0:: with SMTP id a16mr20416842wrp.107.1612803245123;
        Mon, 08 Feb 2021 08:54:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u3sm33878972wre.54.2021.02.08.08.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 08:54:04 -0800 (PST)
Subject: Re: [PATCH for 5.4] Fix unsynchronized access to sev members through
 svm_register_enc_region
To:     Peter Gonda <pgonda@google.com>, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210208164855.772287-1-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0adf1e40-4398-9a52-2293-d77efa52b35e@redhat.com>
Date:   Mon, 8 Feb 2021 17:54:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208164855.772287-1-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 17:48, Peter Gonda wrote:
> commit 19a23da53932bc8011220bd8c410cb76012de004 upstream.
> 
> Grab kvm->lock before pinning memory when registering an encrypted
> region; sev_pin_memory() relies on kvm->lock being held to ensure
> correctness when checking and updating the number of pinned pages.
> 
> Add a lockdep assertion to help prevent future regressions.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> V2
>   - Fix up patch description
>   - Correct file paths svm.c -> sev.c
>   - Add unlock of kvm->lock on sev_pin_memory error
> 
> V1
>   - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/
> 
> Message-Id: <20210127161524.2832400-1-pgonda@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 2b506904be02..93c89f1ffc5d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1830,6 +1830,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   	struct page **pages;
>   	unsigned long first, last;
>   
> +	lockdep_assert_held(&kvm->lock);
> +
>   	if (ulen == 0 || uaddr + ulen < uaddr)
>   		return NULL;
>   
> @@ -7086,12 +7088,21 @@ static int svm_register_enc_region(struct kvm *kvm,
>   	if (!region)
>   		return -ENOMEM;
>   
> +	mutex_lock(&kvm->lock);
>   	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>   	if (!region->pages) {
>   		ret = -ENOMEM;
> +		mutex_unlock(&kvm->lock);
>   		goto e_free;
>   	}
>   
> +	region->uaddr = range->addr;
> +	region->size = range->size;
> +
> +	mutex_lock(&kvm->lock);
> +	list_add_tail(&region->list, &sev->regions_list);
> +	mutex_unlock(&kvm->lock);
> +
>   	/*
>   	 * The guest may change the memory encryption attribute from C=0 -> C=1
>   	 * or vice versa for this memory range. Lets make sure caches are
> @@ -7100,13 +7111,6 @@ static int svm_register_enc_region(struct kvm *kvm,
>   	 */
>   	sev_clflush_pages(region->pages, region->npages);
>   
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
>   	return ret;
>   
>   e_free:
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

