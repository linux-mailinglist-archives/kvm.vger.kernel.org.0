Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560BE4987DD
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiAXSIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:08:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245038AbiAXSHq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 13:07:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643047666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MYTZ4YsMWSk4U76dnDXD2XsmyTvHScUcCi4gHHHwZPM=;
        b=FjeaW8s92tZfkYXYv55MqYMNpmoxcxzuWB1/DKkkngTBxxiXBzQLXilECnlOUkIVeBVO+Q
        RZKYPGZOf5PrCD5nKc3z3E6tzdGPpAomsbCsgD8wDUAtmC7b+cIrAg3RIIqh/2NgT9ehPc
        dnfubV8Kd09wzj/yzSWcSrjHuVTHMzo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-XniCK8_8MrKiZ7B4wnfOHg-1; Mon, 24 Jan 2022 13:07:44 -0500
X-MC-Unique: XniCK8_8MrKiZ7B4wnfOHg-1
Received: by mail-ed1-f71.google.com with SMTP id w3-20020a50c443000000b0040696821132so6496464edf.22
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 10:07:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MYTZ4YsMWSk4U76dnDXD2XsmyTvHScUcCi4gHHHwZPM=;
        b=r7SOTmO+Ieh9Lg2jMNuKKTmsuJ2MBQOiMgZVhhZ19ugf6NXAxNimrehYbStRS3b/7r
         lMMiA6+CCKl6KNKhvXIjakbjyBGueWARJDOZB7LpbuVTjDR626L1IFH4dnWrA/xmIY+v
         gB4hnpot9ff9606DtVEt5EntLf/PUFVIeztZV0bzAVybXLlIUXJYtjgi8a6ejDUaIoC5
         4laN85lre6ucEYY3BH+QOhDtU70yXwMuMZcB+0ypBCT6Gt71Bw+4E+HTW3nV21pO7nMx
         6h/QCwTAjurphwOFshyF/0yITo1J/+et2ZmwTEFwJRXXMDziHaXkkfhsU+xVaCasVcMt
         1b/A==
X-Gm-Message-State: AOAM5332uYqs3niKgH4MTa4hbd21yvsg6nzYapF/qSz65ZOLBuatKOLa
        24onaS91KC3t1uHfPaGezgGlEFvc1Qs2m8+jIApIywvIRBmNGWXOPXb3mZYU7079Ph7pzm3U4/i
        f7sOP1Wv2B0yT
X-Received: by 2002:a17:906:4c95:: with SMTP id q21mr13162709eju.173.1643047663574;
        Mon, 24 Jan 2022 10:07:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXW8pZvNJK/4zV3t3MKOwIkrkLvJCkbKQYglLSt1Z5TlDZjbyq+OJw2XV2+3fyqwS0CJG45A==
X-Received: by 2002:a17:906:4c95:: with SMTP id q21mr13162694eju.173.1643047663386;
        Mon, 24 Jan 2022 10:07:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id t8sm5161408ejx.217.2022.01.24.10.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 10:07:42 -0800 (PST)
Message-ID: <6fd96538-b767-41e8-0cca-5b9be1dbb1c9@redhat.com>
Date:   Mon, 24 Jan 2022 19:07:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RESEND] KVM: x86/mmu: fix UAF in
 paging_update_accessed_dirty_bits
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
References: <20220124172633.103323-1-tadeusz.struk@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220124172633.103323-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/22 18:26, Tadeusz Struk wrote:
> Syzbot reported an use-after-free bug in update_accessed_dirty_bits().
> Fix this by checking if the memremap'ed pointer is still valid.

access_ok only checks that the pointer is in the userspace range.  Is 
this correct?  And if so, what are the exact circumstances in which 
access_ok returns a non-NULL but also non-userspace address?

Thanks,

Paolo

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: <stable@vger.kernel.org>
> Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
> Link: https://syzkaller.appspot.com/bug?id=6cb6102a0a7b0c52060753dd62d070a1d1e71347
> Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>   arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 5b5bdac97c7b..d25b72d7b1b1 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -174,7 +174,7 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
>   		paddr = pfn << PAGE_SHIFT;
>   		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
> -		if (!table) {
> +		if (!table || !access_ok(table, PAGE_SIZE)) {
>   			mmap_read_unlock(current->mm);
>   			return -EFAULT;
>   		}

