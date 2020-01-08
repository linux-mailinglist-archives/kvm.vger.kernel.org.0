Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809111349A5
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgAHRpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:45:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27479 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726290AbgAHRpd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 12:45:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578505532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAbrCkrIuQhAIxDIFRpXY9taZ5SfRby6+FX1Mi+Hdt4=;
        b=MloR51gXRDflbWqF9O2S0KYwn1whGXK1Hy3bWnhjfqls8KPEvJerHfty1wKiAPIqJ5yl5J
        Ns5nuRMsB+YCgOJ2WwgnYzyCZ41Fq2+8xQ0DK1g9yKMW05mEBGxCxRRUgermXWzDl/YtA0
        HbJ0qToLqOqOUmUy6WKrbrn1Oyj72PA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-l6Q2s8KePFGWIKC7jhizxw-1; Wed, 08 Jan 2020 12:45:31 -0500
X-MC-Unique: l6Q2s8KePFGWIKC7jhizxw-1
Received: by mail-wr1-f72.google.com with SMTP id b13so1704425wrx.22
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:45:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vAbrCkrIuQhAIxDIFRpXY9taZ5SfRby6+FX1Mi+Hdt4=;
        b=oe2PS1dryaowB1osGxjN1A257sWqv4bo5XJ2dTlw4rxMRE0Nz+HFMIrwUMNNHPWgOz
         THsc6wVgxB3o6LScoBMSXZyGpCRJx91qt0xvSQuXBqPPx5wrjTR4Oz6JvOD+bSm+/Rp2
         4wcv2zdW6r/JaXS4oX96qZZkiWvOX792mVk4zg1ni5idskvEM9wImjBT2/DqlkL84GoP
         9WXykKB1FUEemwsfIIxhWd80/bWjDSn8iY+vQAwVnBaUtGWSouf76wAdB+k9NsMq1kxb
         ADyIeKlyvYD/dpmBtuP5bDO0fCdXjYWOalGPApP6M6n+4jEXAtqX7syrql/LGBBt4ez2
         cnjw==
X-Gm-Message-State: APjAAAX1tIkxUPpY2sHGJv8g0X+3yW/s6vFMDzjeEIP980o0Y4Epa0q2
        wcUKvXj7wiZgadlaV5ZMROrNxcvwEJcV47AQPyRVBYQ7PXEELtU3QjFRZLiFxkvENDEaWyG1r5V
        49GP3wlKR7KzW
X-Received: by 2002:a05:600c:1009:: with SMTP id c9mr5552196wmc.162.1578505529996;
        Wed, 08 Jan 2020 09:45:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUOQXtzLAkEHEjUID+HnRc2XOSMUnPPe6lslm3LAC2FtlfT9P1+XCgvOpBL4apTaLuisYbSw==
X-Received: by 2002:a05:600c:1009:: with SMTP id c9mr5552179wmc.162.1578505529762;
        Wed, 08 Jan 2020 09:45:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id p17sm4658551wmk.30.2020.01.08.09.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:45:29 -0800 (PST)
Subject: Re: [PATCH RESEND v2 01/17] KVM: Remove kvm_read_guest_atomic()
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-2-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <15bc02b7-595d-2564-b1f9-a4a8aae37252@redhat.com>
Date:   Wed, 8 Jan 2020 18:45:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191221014938.58831-2-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/19 02:49, Peter Xu wrote:
> Remove kvm_read_guest_atomic() because it's not used anywhere.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/kvm_host.h |  2 --
>  virt/kvm/kvm_main.c      | 11 -----------
>  2 files changed, 13 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d41c521a39da..2ea1ea79befd 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -730,8 +730,6 @@ void kvm_get_pfn(kvm_pfn_t pfn);
>  
>  int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  			int len);
> -int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
> -			  unsigned long len);
>  int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
>  int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  			   void *data, unsigned long len);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13efc291b1c7..7ee28af9eb48 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2039,17 +2039,6 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
>  	return 0;
>  }
>  
> -int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
> -			  unsigned long len)
> -{
> -	gfn_t gfn = gpa >> PAGE_SHIFT;
> -	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> -	int offset = offset_in_page(gpa);
> -
> -	return __kvm_read_guest_atomic(slot, gfn, data, offset, len);
> -}
> -EXPORT_SYMBOL_GPL(kvm_read_guest_atomic);
> -
>  int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  			       void *data, unsigned long len)
>  {
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

