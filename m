Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0AC3BBB02
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhGEKTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:19:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230474AbhGEKT3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625480212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nbFoAzVILeq1vaQ6QYXxMMsMhWIu9fZZUnayrh9ZvL0=;
        b=a/3fPNitHiTDKeo5DcCXv4rQbjUVYh77EtgayHXBxbzFkzHYfBaX80WPgWH2FH0v+jcbEJ
        NvttK5zTyhZ/bUcKSi1zPYFWmKtUVsWTzRl+bHEa7NL6kdv8uAlHOhlV8Ce5YhmK/P+1WB
        er4AL4yKBcpSoIevPaNlLsDWwKPK/hE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-nSt7DZN0PVy6Qsjlq2ro8A-1; Mon, 05 Jul 2021 06:16:49 -0400
X-MC-Unique: nSt7DZN0PVy6Qsjlq2ro8A-1
Received: by mail-wm1-f69.google.com with SMTP id a129-20020a1ce3870000b02901f050bc61d2so5677091wmh.8
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 03:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nbFoAzVILeq1vaQ6QYXxMMsMhWIu9fZZUnayrh9ZvL0=;
        b=On0tkYQZbcqj78Vkpc2u0Acb4uxrAED9Ro+R4yErbG1F3zqeJaw2C0wR6eykHCOq3e
         fNgztyrlXmyA8BCxepbEuRwpVPuPllJLAthUfm3/jmX2urxjuOPbkp465wWFQg6RQvBH
         1lRd0ifnnWsIuljBXaNtdr49FEjWlRXL9bEtYYC1aOwn/y9nhX5jIHIA9WsktufbBUSt
         C2DjFLlvPmqIZZJPZvYKwl8McUqmrMvVDnuf1qFFi3a/cAp5XH/BNbys4xU3pZohO6b+
         EAXgV7E1irDp2BdyqvJXDz1QKcvMKBC9q+KB+yp2Cex7g8rWxO3bWLv6gUjI0FHyw1x9
         BbPA==
X-Gm-Message-State: AOAM532e3cLpuJM1bfG3QESG4GeeDw3vg/s/iO06ukQWvrD7sJ1jV5B7
        Jk+7WQ8nTb7RkMvG+8u96Pc6nP1vysq3gFgbVAzaBrJQN6WtxL9nJ7UfyM7F1SU9IjbgFuBtfFE
        n16Aw7QG7GvpT
X-Received: by 2002:a5d:5985:: with SMTP id n5mr8607899wri.63.1625480208089;
        Mon, 05 Jul 2021 03:16:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1AYbsAxlmgoUz32zzV3wCNrATL42NVs9zK91n/Mwbq4wN1u52Qc566qS9clkG8rFnSVPr+g==
X-Received: by 2002:a5d:5985:: with SMTP id n5mr8607875wri.63.1625480207894;
        Mon, 05 Jul 2021 03:16:47 -0700 (PDT)
Received: from thuth.remote.csb (pd9575e1e.dip0.t-ipconnect.de. [217.87.94.30])
        by smtp.gmail.com with ESMTPSA id h15sm12284938wrq.88.2021.07.05.03.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 03:16:47 -0700 (PDT)
Subject: Re: [PATCH/RFC] KVM: selftests: introduce P44V64 for z196 and EC12
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210701153853.33063-1-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9b80d35e-0696-5938-8565-9e92aa359829@redhat.com>
Date:   Mon, 5 Jul 2021 12:16:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701153853.33063-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/2021 17.38, Christian Borntraeger wrote:
> Older machines likes z196 and zEC12 do only support 44 bits of physical
> addresses. Make this the default and check via IBC if we are on a later
> machine. We then add P47V64 as an additional model.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: 1bc603af73dd ("KVM: selftests: introduce P47V64 for s390x")
> ---
>   tools/testing/selftests/kvm/include/kvm_util.h |  3 ++-
>   tools/testing/selftests/kvm/lib/guest_modes.c  | 16 ++++++++++++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c     |  5 +++++
>   3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 35739567189e..74d73532fce9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -44,6 +44,7 @@ enum vm_guest_mode {
>   	VM_MODE_P40V48_64K,
>   	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
>   	VM_MODE_P47V64_4K,
> +	VM_MODE_P44V64_4K,
>   	NUM_VM_MODES,
>   };
>   
> @@ -61,7 +62,7 @@ enum vm_guest_mode {
>   
>   #elif defined(__s390x__)
>   
> -#define VM_MODE_DEFAULT			VM_MODE_P47V64_4K
> +#define VM_MODE_DEFAULT			VM_MODE_P44V64_4K
>   #define MIN_PAGE_SHIFT			12U
>   #define ptes_per_page(page_size)	((page_size) / 16)
>   
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index 25bff307c71f..c330f414ef96 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -22,6 +22,22 @@ void guest_modes_append_default(void)
>   		}
>   	}
>   #endif
> +#ifdef __s390x__
> +	{
> +		int kvm_fd, vm_fd;
> +		struct kvm_s390_vm_cpu_processor info;
> +
> +		kvm_fd = open_kvm_dev_path_or_exit();
> +		vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
> +		kvm_device_access(vm_fd, KVM_S390_VM_CPU_MODEL,
> +				  KVM_S390_VM_CPU_PROCESSOR, &info, false);
> +		close(vm_fd);
> +		close(kvm_fd);
> +		/* Starting with z13 we have 47bits of physical address */
> +		if (info.ibc >= 0x30)
> +			guest_mode_append(VM_MODE_P47V64_4K, true, true);

Wouldn't it make more sense to check the processor number in /proc/cpuinfo? 
... well, I guess both ways of checking have their advantages and 
disadvantages, so anyway:

Reviewed-by: Thomas Huth <thuth@redhat.com>

