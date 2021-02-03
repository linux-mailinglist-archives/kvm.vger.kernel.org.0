Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F80A30D4A4
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhBCIFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:05:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232148AbhBCIFY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612339438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3qk/ydnwHTmRHlgp4xlVLacPsLSyuigK5DfsA29p84A=;
        b=Y+GxvlQ3HCRyy/42m6SC03CCT09atEJfkjLtOYhvp/FaHItd7Isrzu+/RIG0LHGJ4HLZjM
        LXhFXB+KHvblLuSWQ7MJJ+axss2XzewONkbL42dvctiN8TG7vdz+C3uBZVl3mUyNMbfCQV
        MWMuoz2mkJUMlSuMUa0KOQY5sX18qEE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-J8RZKpvBNtCJ3aVhuZNUtA-1; Wed, 03 Feb 2021 03:03:54 -0500
X-MC-Unique: J8RZKpvBNtCJ3aVhuZNUtA-1
Received: by mail-ed1-f69.google.com with SMTP id w23so1769715edr.15
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 00:03:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3qk/ydnwHTmRHlgp4xlVLacPsLSyuigK5DfsA29p84A=;
        b=fzSb2wgLGsMAzsu6FO9ABzmQ7Xo1/f6D0kB3nMu4kbYmO/xh2Un6J8PaE4CcGmVmnU
         yiXJzQnQUwfx/SUPt9F+MbuYzp7GUDhZFBu8ME/5tPOgyZgBGXtE2HNOnaYToQLnjqoM
         923KVlUuB/sa2XtCGO4vYBnMRM+XMpI50t4vwVdYpTYrDvuJCuEcANfolulUqiCcMfkn
         waLlZ/JZXv6agHRc/EA5zC5NK0hc8FBfijtkJz7/dbSp6uFrTzVDLp9Gmzl+CaGp5/8M
         J3efbr1haiUdmVNHXBC0K3FWYA1WlwWkwxyI/ZzSwi39SyyC3l4GhhKurbGoacrOMhbP
         iIOQ==
X-Gm-Message-State: AOAM530DvOm5K3fvjN0sZjA31tw2J4/bG4Rt30Z9lwUzcXHtP4sAgb1R
        wHoPgSgBtdG0wFOpJk85zJqsjjM4NuDQzjWYJhtP03tyZ5PR5L6KLZ8h2zvPcjYHpU8JdPTnjyJ
        uR96YGtN15gu0
X-Received: by 2002:a17:906:3945:: with SMTP id g5mr2056296eje.514.1612339433377;
        Wed, 03 Feb 2021 00:03:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsoa2Ijyte2XTgXtObUhXo8gCgSUcKEY7CIIfXwarm0/nAAahEEvn1iBlarAS7pCYbLxBYQQ==
X-Received: by 2002:a17:906:3945:: with SMTP id g5mr2056273eje.514.1612339433204;
        Wed, 03 Feb 2021 00:03:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bf8sm485593edb.34.2021.02.03.00.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:03:52 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Use 'unsigned long' for the physical address
 passed to VMSAVE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>
References: <20210202223416.2702336-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cbd8894f-4218-26ca-f0ff-9513fe7b194f@redhat.com>
Date:   Wed, 3 Feb 2021 09:03:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202223416.2702336-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 23:34, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
> index 0c8377aee52c..9f007bc8409a 100644
> --- a/arch/x86/kvm/svm/svm_ops.h
> +++ b/arch/x86/kvm/svm/svm_ops.h
> @@ -51,7 +51,12 @@ static inline void invlpga(unsigned long addr, u32 asid)
>  	svm_asm2(invlpga, "c"(asid), "a"(addr));
>  }
>  
> -static inline void vmsave(hpa_t pa)
> +/*
> + * Despite being a physical address, the portion of rAX that is consumed by
> + * VMSAVE, VMLOAD, etc... is still controlled by the effective address size,
> + * hence 'unsigned long' instead of 'hpa_t'.
> + */
> +static inline void vmsave(unsigned long pa)
>  {
>  	svm_asm1(vmsave, "a" (pa), "memory");
>  }
> -- 
> 2.30.0.365.g02bc693789-goog
> 

Squashed, thanks.

Paolo

