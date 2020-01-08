Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746A91349B6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgAHRrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:47:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37484 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728956AbgAHRrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 12:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578505660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kPVctA+/beiB2tgYujpzj4QWpCakHQu/CLjfG7f6imE=;
        b=Lzv5DCWSCkoh3lGraAuXbJ5M6ZGx52MVVyHqkVOjm2XL0PA4MpbLUuRMs+V39yEVWMQwPZ
        cgsocaHl/S/UqkhoODdQ3n4S38hHC61Gp3aS9Wn/7AwDQyJrDQDlVlK/s78RbReJreiNdh
        UMrO+qyco0eUDmuXcFVmzCXBgD13ZMo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-Fq6U0N89PveknKcizVNXLw-1; Wed, 08 Jan 2020 12:47:38 -0500
X-MC-Unique: Fq6U0N89PveknKcizVNXLw-1
Received: by mail-wr1-f69.google.com with SMTP id z14so1743474wrs.4
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:47:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kPVctA+/beiB2tgYujpzj4QWpCakHQu/CLjfG7f6imE=;
        b=tzrq6YmLG0iJziB8nWk/OH1L5jbRBT94T1RNVDw/ybFtVt21tWj2rBp0jyT/1sYR6B
         HerTdGk1kSKwILXUmOED1oY8+DM7A0aLK3y/BXpjLK+0P97qgkjXDjEwclM9ydh/ypLH
         2CX6SRdV3RgqQRMAD5iORqS/YOyA/XO8z/G/txtRVPN4OLqH7gGpb0QHJgcsSFB6xKJL
         mgmfVdnHKr/JQrbr6GALVKVSHipC0RBdpeu0sBeggsw16gjc/MOjf+qLImkIoFJSo4qZ
         s2IBLUQzQfH0+TQzo/1ypb3y1vaAvEGssblgMRUNUL4c8Egss9wFC5Mrdd9VO7jtbRYK
         k71A==
X-Gm-Message-State: APjAAAXp2Krwt2BtqyMTdd/ZHR9dh2OgZJ4LEcC0cyO/nJhK6kiwetjw
        6iPJn4nHn/zaRU8zR2aEWp8FtdxaLx12Y01Prh4fL9wdZNr4qCN4HpN51Ys5RLhKLg2CL/Sg17i
        TTSV9OyJMH1AZ
X-Received: by 2002:a1c:7dc4:: with SMTP id y187mr5114636wmc.161.1578505656808;
        Wed, 08 Jan 2020 09:47:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqwK4smqOHHZ61RcHhcQZCij9FjfLEL0lRlGmAMs4ej7ug5KpPtW7nqSUmqikVekUsUPp0OLAg==
X-Received: by 2002:a1c:7dc4:: with SMTP id y187mr5114613wmc.161.1578505656566;
        Wed, 08 Jan 2020 09:47:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id j12sm5358156wrw.54.2020.01.08.09.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:47:35 -0800 (PST)
Subject: Re: [PATCH RESEND v2 06/17] KVM: Pass in kvm pointer into
 mark_page_dirty_in_slot()
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-7-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8d784ead-44f8-8ebc-6192-be1b4eec6ff8@redhat.com>
Date:   Wed, 8 Jan 2020 18:47:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191221014938.58831-7-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/19 02:49, Peter Xu wrote:
> The context will be needed to implement the kvm dirty ring.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c80a363831ae..17969cf110dd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -144,7 +144,9 @@ static void hardware_disable_all(void);
>  
>  static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  
> -static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
> +static void mark_page_dirty_in_slot(struct kvm *kvm,
> +				    struct kvm_memory_slot *memslot,
> +				    gfn_t gfn);
>  
>  __visible bool kvm_rebooting;
>  EXPORT_SYMBOL_GPL(kvm_rebooting);
> @@ -2053,8 +2055,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
> -static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
> -			          const void *data, int offset, int len,
> +static int __kvm_write_guest_page(struct kvm *kvm,
> +				  struct kvm_memory_slot *memslot, gfn_t gfn,
> +				  const void *data, int offset, int len,
>  				  bool track_dirty)
>  {
>  	int r;
> @@ -2067,7 +2070,7 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
>  	if (r)
>  		return -EFAULT;
>  	if (track_dirty)
> -		mark_page_dirty_in_slot(memslot, gfn);
> +		mark_page_dirty_in_slot(kvm, memslot, gfn);
>  	return 0;
>  }
>  
> @@ -2077,7 +2080,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> +	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len,
>  				      track_dirty);
>  }
>  EXPORT_SYMBOL_GPL(kvm_write_guest_page);
> @@ -2087,7 +2090,7 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_write_guest_page(slot, gfn, data, offset,
> +	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset,
>  				      len, true);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
> @@ -2202,7 +2205,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
>  	if (r)
>  		return -EFAULT;
> -	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
> +	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
>  
>  	return 0;
>  }
> @@ -2269,7 +2272,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
>  }
>  EXPORT_SYMBOL_GPL(kvm_clear_guest);
>  
> -static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
> +static void mark_page_dirty_in_slot(struct kvm *kvm,
> +				    struct kvm_memory_slot *memslot,
>  				    gfn_t gfn)
>  {
>  	if (memslot && memslot->dirty_bitmap) {
> @@ -2284,7 +2288,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
>  	struct kvm_memory_slot *memslot;
>  
>  	memslot = gfn_to_memslot(kvm, gfn);
> -	mark_page_dirty_in_slot(memslot, gfn);
> +	mark_page_dirty_in_slot(kvm, memslot, gfn);
>  }
>  EXPORT_SYMBOL_GPL(mark_page_dirty);
>  
> @@ -2293,7 +2297,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
>  	struct kvm_memory_slot *memslot;
>  
>  	memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> -	mark_page_dirty_in_slot(memslot, gfn);
> +	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
>  
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

