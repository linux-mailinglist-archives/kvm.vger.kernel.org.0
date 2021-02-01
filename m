Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CCB30A8F1
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 14:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhBANjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 08:39:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232196AbhBANjh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 08:39:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612186690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIidTHAlvNTypJNX4Ptuq/3z20fdadApbhIsv9h3oks=;
        b=O0nla96WS5I3mFvU++6qS29oNBKpMX2rTChP2ci1G42uqdkY49GmSCmCOzARGGg5sw9AAl
        Anik7RCQBurfH3yeHaa26leYwdapXeg6SVnOeNwjP3bTTiA4U+k3YWAVH1rlgXWMKS3/3t
        G/LQIpNFSVtDDlHt9oFgMwTFik5I8S4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-h1K7icjwPMi53r4FrzYRAg-1; Mon, 01 Feb 2021 08:38:08 -0500
X-MC-Unique: h1K7icjwPMi53r4FrzYRAg-1
Received: by mail-ed1-f71.google.com with SMTP id o8so7956085edh.12
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 05:38:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wIidTHAlvNTypJNX4Ptuq/3z20fdadApbhIsv9h3oks=;
        b=fEAdZv98nin/LP+WZ56gk/RHnx6XMZ8oMpqmzqPU8jRmqZW7cULcpNTwf++lQYlmjW
         V9ifjKpLtq+Ur+hQHqxklSdyBm5/rW0Yajs+OEMCogLs3GkU8DJSro6oT/Bsc9FnGbs3
         CKZUhkOux3qLuUZdifB/6H0vXN8gxyhdXWji0eyVcVg9ONLrjwtqxeWUIlgWhFwb0l5i
         JewjsPFkxEaGpMHoyeLi3yfsnYVo3feNai/KUMzw821WhNZfWmmdU5W6ssRi8k3/gGWV
         9/MXHbJLUT7bhrXbtwoOK3xt+j0VJsN4M6QypQsiVMDrlb/FI3lmAhS6gt66MyMEzGpa
         QJ+Q==
X-Gm-Message-State: AOAM531jP3zrbNktICNHBhueED8niJXYGr8Q3oNXprrx3G15W222fYrK
        USuQawwxSKkYFT1wthRDm7SILXYVwQ8QKpUcSu0l/+EMos6UKKFHKrQ9A5XXEirroc4fQVT7q3K
        9oF4jjNuzn4xv
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr17769655ejb.552.1612186687245;
        Mon, 01 Feb 2021 05:38:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7eaJLZccsr/7XoXoaYOhRjGJ3l7lY+Ixm9zSwzLhn0XeXkuWxpJSlECBzs8FAsL/W8npLDg==
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr17769642ejb.552.1612186687077;
        Mon, 01 Feb 2021 05:38:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bk2sm8137778ejb.98.2021.02.01.05.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 05:38:06 -0800 (PST)
Subject: Re: [stable-5.4][PATCH] KVM: Forbid the use of tagged userspace
 addresses for memslots
To:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kvm@vger.kernel.org,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210201133137.3541896-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b08e3ccf-9a69-819a-8632-46c82dade2fa@redhat.com>
Date:   Mon, 1 Feb 2021 14:38:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201133137.3541896-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 14:31, Marc Zyngier wrote:
> commit 139bc8a6146d92822c866cf2fd410159c56b3648 upstream.
> 
> The use of a tagged address could be pretty confusing for the
> whole memslot infrastructure as well as the MMU notifiers.
> 
> Forbid it altogether, as it never quite worked the first place.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   Documentation/virt/kvm/api.txt | 3 +++
>   virt/kvm/kvm_main.c            | 1 +
>   2 files changed, 4 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index a18e996fa54b..7064efd3b5ea 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -1132,6 +1132,9 @@ field userspace_addr, which must point at user addressable memory for
>   the entire memory slot size.  Any object may back this memory, including
>   anonymous memory, ordinary files, and hugetlbfs.
>   
> +On architectures that support a form of address tagging, userspace_addr must
> +be an untagged address.
> +
>   It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>   be identical.  This allows large pages in the guest to be backed by large
>   pages in the host.
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8f3b40ec02b7..f25b5043cbca 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1017,6 +1017,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	/* We can read the guest memory with __xxx_user() later on. */
>   	if ((id < KVM_USER_MEM_SLOTS) &&
>   	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
> +	     (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
>   	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
>   			mem->memory_size)))
>   		goto out;
> 

Indeed untagged_addr was added in 5.3.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

