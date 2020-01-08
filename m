Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E5D1349B2
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAHRrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:47:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21085 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbgAHRrW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 12:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578505642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bAa69owWCpVJkLCmnm+u7z+Vy9Ti9WLM44pgY0D4sxY=;
        b=YN5eqGOOwn2jZafTSn1n227MYh/jUtgOJVQ41C3kfgCoD6LE05Tgko1zv56zIzP0vz7L9L
        EZ4dG1dH4x3NGL38cTwo/2lh0/nCy4OxkqCm0eZbdJEZYiu96sjauD6k5WJMMqBxAb5FXt
        aCLBkRUML+6Kpyhre9OghLJ/+5x0QK4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-YpWiVetNPQG-kS5zP4nmdA-1; Wed, 08 Jan 2020 12:47:20 -0500
X-MC-Unique: YpWiVetNPQG-kS5zP4nmdA-1
Received: by mail-wm1-f69.google.com with SMTP id o24so575930wmh.0
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:47:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bAa69owWCpVJkLCmnm+u7z+Vy9Ti9WLM44pgY0D4sxY=;
        b=jurLKxhVGvf7SJBr1yvFhah9r30n0tx6D3iKGprzzjOrJnZ7o74PLjCv2j7QacwG0u
         9nCBk08czy+bC4zTFI+drSfvmeP5JKhQYI5as1AO1T5cpSXboFAlf6bcwEztYgpx8cXK
         z02LdR3L4wSAEnLoPAJhWJeI3U45PAlaXw9FFgu80n7T3f4LCXPN1xjKQrqwftqVqjyh
         Rc9KlEXg28Ye/M3fNiaKiNcruOv0oqFvMu5acww8NPRrxXApW+uvHdXrYs8WU3kZtWOS
         zkKpEL5Io2qINiDLM5EsMujw9uYPxW21uqBJeXgvQ4e529RWxz5ANZipdtu/Qb6erzHC
         ++Mw==
X-Gm-Message-State: APjAAAU9S0OolcTsZOAGZs+CE0+PqqLTANE3lXuIsD2T/vmIKZFaPuNV
        W9i+m22SI4MeeARAX6HxTp99pWLNyb91msKBjt3N2Srw6YFvYDEar2oIe5QSkj2CEsUBHU98z7k
        7ffBw8K08yb0Y
X-Received: by 2002:a5d:484f:: with SMTP id n15mr6012217wrs.365.1578505639299;
        Wed, 08 Jan 2020 09:47:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqwUmk3FDfXBZY3A8HYnfBqzfD0M+CFw9a/XaX+37Y+I7ptfdXLeU0/jbrqR4VO05Zhdfc3tqw==
X-Received: by 2002:a5d:484f:: with SMTP id n15mr6012188wrs.365.1578505639104;
        Wed, 08 Jan 2020 09:47:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id s15sm5090309wrp.4.2020.01.08.09.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:47:18 -0800 (PST)
Subject: Re: [PATCH RESEND v2 04/17] KVM: Cache as_id in kvm_memory_slot
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-5-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c60668e-1d60-5ab7-8524-54cc970d496d@redhat.com>
Date:   Wed, 8 Jan 2020 18:47:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191221014938.58831-5-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/19 02:49, Peter Xu wrote:
> Let's cache the address space ID just like the slot ID.

Please add a not that it will be useful in order to fill in the dirty
page ring buffer.

Paolo

> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/kvm_host.h | 1 +
>  virt/kvm/kvm_main.c      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4e34cf97ca90..24854c9e3717 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -348,6 +348,7 @@ struct kvm_memory_slot {
>  	unsigned long userspace_addr;
>  	u32 flags;
>  	short id;
> +	u8 as_id;
>  };
>  
>  static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b1047173d78e..cea4b8dd4ac9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1027,6 +1027,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  
>  	new = old = *slot;
>  
> +	BUILD_BUG_ON(U8_MAX < KVM_ADDRESS_SPACE_NUM);
> +	new.as_id = as_id;
>  	new.id = id;
>  	new.base_gfn = base_gfn;
>  	new.npages = npages;
> 

