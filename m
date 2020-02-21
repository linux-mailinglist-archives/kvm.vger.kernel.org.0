Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E67168455
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 18:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgBURED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 12:04:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23740 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726150AbgBURED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 12:04:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582304641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8G8BZBouM/mQbwFQpvSrCjCl8B0n5IMFrewnfRa7ZHQ=;
        b=VGP5pkMdhxVbLW/kN/f1L1RbNAlrQB35hcUIxMPxh7JEMB6W5VMeqhXJNlhs1KJWwYoVjl
        NBFxeLwDc8T7f1QGDto7Iv7ql5OeUyeCRkcOWWLRNB/TpWVdgP1HECqp7Mw3NGW8lVIIsM
        CjhQviJYOCC6KmHh5qkypUSmBJHJ2Bw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-ITGPffGWMo6JJrikaMcrtg-1; Fri, 21 Feb 2020 12:03:59 -0500
X-MC-Unique: ITGPffGWMo6JJrikaMcrtg-1
Received: by mail-wr1-f70.google.com with SMTP id s13so1272068wrb.21
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 09:03:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8G8BZBouM/mQbwFQpvSrCjCl8B0n5IMFrewnfRa7ZHQ=;
        b=ebENw45niY0DwmbF1/+k9Li9wv4/3Uof9nCX6PF0d3fdkiW3SmuaX5SWCIc79mLeOy
         RaFmzOpv+3NyInkXC1Oaw3xkrUgkHZdZ8Cmgi3Czx51jqnPFrZwYn7z5/e//4EkVp1Dv
         Q5b+zQPu7jwfO84saGl2ykito4TF9zuyvrR8F/GoQOpyoL57K6NsX/TnPID/Ti3vMLHh
         rAZGz8XWMoEnvdHdv5tv10ZFsXwPBA2TTwgr1ZMcpVqzFKSUneoQwJp1/6DzqEzld7WU
         chXHqc0we3RaT4HyVCmRdHyIH4PWfQF7F6eX0ChOUZHQjxTWgeWhzpMcGY/bf0S643y2
         0sIw==
X-Gm-Message-State: APjAAAVJfR8k8oKGaYSrYQV+XbD3u21BBS9KFm3sBbVCj+PIsPsiWOUv
        ROioy6hgLxKfepoeCI2/zVSf0/W+2V34ypIyMvINvOKL18JQesV35Pyb6tWvqMSNi/d4z/POw/p
        KQBrhd1GJYPH0
X-Received: by 2002:adf:f304:: with SMTP id i4mr21262854wro.379.1582304638126;
        Fri, 21 Feb 2020 09:03:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqycqGQ/vXL+GcFTL84DXzdJhPFJsCbwR2zdeMb+niCcvVPE6dnEi0QtYrhmWkPHfR0VCvR2rA==
X-Received: by 2002:adf:f304:: with SMTP id i4mr21262835wro.379.1582304637816;
        Fri, 21 Feb 2020 09:03:57 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id k8sm4768060wrq.67.2020.02.21.09.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:03:57 -0800 (PST)
Subject: Re: [PATCH] accel/kvm: Check ioctl(KVM_SET_USER_MEMORY_REGION) return
 value
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
References: <20200221163336.2362-1-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6d29e18-722c-77d1-ca56-220b3b02ae00@redhat.com>
Date:   Fri, 21 Feb 2020 18:03:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200221163336.2362-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/20 17:33, Philippe Mathieu-Daudé wrote:
> kvm_vm_ioctl() can fail, check its return value, and log an error
> when it failed. This fixes Coverity CID 1412229:
> 
>   Unchecked return value (CHECKED_RETURN)
> 
>   check_return: Calling kvm_vm_ioctl without checking return value
> 
> Reported-by: Coverity (CID 1412229)
> Fixes: 235e8982ad3 ("support using KVM_MEM_READONLY flag for regions")
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index c111312dfd..6df3a4d030 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -308,13 +308,23 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
>          /* Set the slot size to 0 before setting the slot to the desired
>           * value. This is needed based on KVM commit 75d61fbc. */
>          mem.memory_size = 0;
> -        kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +        if (ret < 0) {
> +            goto err;
> +        }
>      }
>      mem.memory_size = slot->memory_size;
>      ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
>      slot->old_flags = mem.flags;
> +err:
>      trace_kvm_set_user_memory(mem.slot, mem.flags, mem.guest_phys_addr,
>                                mem.memory_size, mem.userspace_addr, ret);
> +    if (ret < 0) {
> +        error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
> +                     " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
> +                     __func__, mem.slot, slot->start_addr,
> +                     (uint64_t)mem.memory_size, strerror(errno));
> +    }
>      return ret;
>  }
>  
> 

Queued, thanks.

Paolo

