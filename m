Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6256E3BD84B
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhGFOgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:36:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231485AbhGFOgn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1DoKVHI9FzjI4Qx1LUCOepoQK98RB9H5U9MBViyCTM=;
        b=Z3qhg3SR/sounjiVlk6NXB2P8siSxaj52Rw6R49WvmY81U/A220bNmcRECd8BZRcA90Rdh
        /ZLOGp4ZRTUPzuJ9qnExPKOptTgH5p53CXHjzYrw3WktoonUVIiZA8vBbUOqUwau/NkEZc
        KovnApKLgebOl5EKis1U6e2yHUWKRNU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-z2Wc4TAAMNKw6UEcUbKCcQ-1; Tue, 06 Jul 2021 10:32:57 -0400
X-MC-Unique: z2Wc4TAAMNKw6UEcUbKCcQ-1
Received: by mail-wr1-f72.google.com with SMTP id r11-20020a5d52cb0000b02901309f5e7298so3892596wrv.0
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t1DoKVHI9FzjI4Qx1LUCOepoQK98RB9H5U9MBViyCTM=;
        b=HK2avlEzlpdGy2KSYhVMbPWTZSWEMuxSymcrJKxuMLzMJBfIy129FjvgKTOfB5oMUr
         I0NWvNnv/xtryDHnFUGVDzk1pqDd+Qir4pSqgaYZgf1OuLNQk97AqkLJuN7GtHt1LVtp
         NJHyjH6Rz/lw0qcsFyah6tIWmjiR3KeYRnPyMODz6wFf4LxUmDVFhtKr32X0E2EZhdO1
         8fb18EFxmBvUucAhbe4GNGjANpXYY2Q57kB2Vt1KV7EA5Jpj3a2SqNfq659BYrtrRIE8
         2tDJUcNHElwSHCITnnW7vRZeEsiBNcw0qoTpyxEHyppJ/gbpPIewOR+4Yx16lepPQXQz
         nxsw==
X-Gm-Message-State: AOAM5315NxUEQ4bxEGeL+L/KNnkWu1GdmOtfcklDNJUVYaoAcdnogYA2
        N6Tf0yQPF08rzo5yBXB1Ce1bZCiOncBqR3I/yIJm8RTu6GkFTyFCICpdi+iiwNTBQqnjf4R3ngd
        ajlS8xwXSV0Fc
X-Received: by 2002:a7b:c248:: with SMTP id b8mr1141347wmj.115.1625581976561;
        Tue, 06 Jul 2021 07:32:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1ToTtXKHTosfl36uXa29rvALiXcYLSBcVGdpLtuve1nqhKP3e+Nn+/0k8Io8yuaN1JFjp3w==
X-Received: by 2002:a7b:c248:: with SMTP id b8mr1141322wmj.115.1625581976372;
        Tue, 06 Jul 2021 07:32:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u2sm10592604wmc.42.2021.07.06.07.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:32:55 -0700 (PDT)
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <1ef40d74af89c4e347e46412a5d07f6e7eebf839.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 40/69] KVM: Export kvm_is_reserved_pfn() for use by
 TDX
Message-ID: <8bfa2859-1d6e-858a-85f9-2e61b4f74f32@redhat.com>
Date:   Tue, 6 Jul 2021 16:32:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1ef40d74af89c4e347e46412a5d07f6e7eebf839.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TDX will use kvm_is_reserved_pfn() to prevent installing a reserved PFN
> int SEPT.  Or rather, to prevent such an attempt, as reserved PFNs are
> not covered by TDMRs.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   virt/kvm/kvm_main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8b075b5e7303..dd6492b526c9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -188,6 +188,7 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>   
>   	return true;
>   }
> +EXPORT_SYMBOL_GPL(kvm_is_reserved_pfn);
>   
>   bool kvm_is_transparent_hugepage(kvm_pfn_t pfn)
>   {
> 

As before, there's no problem in squashing this in the patch that 
introduces the use of kvm_is_reserved_pfn.  You could also move 
kvm_is_reserved_pfn and kvm_is_zone_device_pfn to a .h file.

Paolo

