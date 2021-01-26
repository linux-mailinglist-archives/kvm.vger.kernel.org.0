Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CE1304C7E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbhAZWp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:45:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390685AbhAZSRo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 13:17:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611684978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmZOZYz/idYpsUVMR+3OZjZX/ko4arY+uQksfsUX+40=;
        b=c4PNI8s2ycn+SsuzMJ0CW/Hg0fD2zHBLsZWjeecwlgjfIvDbkhfDeGjKMEYUGR1juCT4fr
        hrwUEwZUwWxpFg3gPS3/8clMq9xmF9ufPYd7SrhcFD7bpi+SDWCX39Om7O3mOA+ojtI/SH
        izqH6u3zfQ7UqUK0JS7SX2QzNlBFLxo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-kIp43Ux3NrOwVj2To43blQ-1; Tue, 26 Jan 2021 13:16:16 -0500
X-MC-Unique: kIp43Ux3NrOwVj2To43blQ-1
Received: by mail-ej1-f72.google.com with SMTP id k3so5250534ejr.16
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:16:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cmZOZYz/idYpsUVMR+3OZjZX/ko4arY+uQksfsUX+40=;
        b=ZqVircqbAS4KuuUTBO0+iZHImvumOCosAhlru06dKoNnilMMzwDD/Ptah3PMHdnLWh
         4ya2ee6AlNZiMnWhP8aU4rXsbHjZyg/u9hMHcNyGTsFIYl+G3sj5KLIIVdi70deAq8po
         +O4Q17T7wzTxQirlh93YT4q+V/4vqQaj4Kx03+Zr4o7WWZQ0dPTvx08MDbwQwHtVu0Cy
         A3d4akcFEOQm14terAo/tHW4hwL8MPJ6pPreLQ7+qa4hUDpSrgQgebWyDToghWRU7QzN
         HlRFHhB4wxVtqs0V7/3GchrWJ//TY/M5JzZ8HfjFgc6spi8fI5XJDmHXMTsLYzXFUFcR
         pDAQ==
X-Gm-Message-State: AOAM533jvK1eHtqigd1wWJ/55r4r8K6aXDQBuHh6goe2/MKBTWE4z2oz
        78lzJcog6YEK33fiUXAFzwA9pPL6L/TMrYgRARO7b2UWTq9dfwVhor8HwIBP/1hGetw1S3jkxpi
        V1n7MpBGXLZq/
X-Received: by 2002:a17:906:b756:: with SMTP id fx22mr4048968ejb.406.1611684975448;
        Tue, 26 Jan 2021 10:16:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypKXVL9QA3KjINlSp9zzxrFNyf6nh1t/Um3t99rhx/I4h0iJs9AqWjmXyOZtrMW1FsPrA9Mw==
X-Received: by 2002:a17:906:b756:: with SMTP id fx22mr4048959ejb.406.1611684975305;
        Tue, 26 Jan 2021 10:16:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r11sm12850914edt.58.2021.01.26.10.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 10:16:14 -0800 (PST)
Subject: Re: [RFC 4/7] KVM: MMU: Refactor pkr_mask to cache condition
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-5-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f4e5dd40-f721-049f-de0f-3af59d48a003@redhat.com>
Date:   Tue, 26 Jan 2021 19:16:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20200807084841.7112-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/20 10:48, Chenyi Qiang wrote:
> 
>  		* index of the protection domain, so pte_pkey * 2 is
>  		* is the index of the first bit for the domain.
>  		*/
> -		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
> +		if (pte_access & PT_USER_MASK)
> +			pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
> +		else
> +			pkr_bits = 0;
>  
> -		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
> -		offset = (pfec & ~1) +
> -			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
> +		/* clear present bit */
> +		offset = (pfec & ~1);
>  
>  		pkr_bits &= mmu->pkr_mask >> offset;
>  		errcode |= -pkr_bits & PFERR_PK_MASK;

I think this is incorrect.  mmu->pkr_mask must cover both clear and set 
ACC_USER_MASK, in to cover all combinations of CR4.PKE and CR4.PKS. 
Right now, check_pkey is !ff && pte_user, but you need to make it 
something like

	check_pkey = !ff && (pte_user ? cr4_pke : cr4_pks);

Paolo

