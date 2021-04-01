Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D77A35196A
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhDARxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236501AbhDARpR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:45:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5cXKDMg3hKjPJQxwPGQ5ktY0E9OHOmBfWVuhkV+IFpg=;
        b=H7g0bcsE7OmJVh8n14J+ms3Zdmj2YSUOYKffGCc00W01mGQ5tGBxIu1lRrxMnFZxD2qTK5
        qvrtNKddmsY09u3BU/R5OebARg0m0LilhKILEQWRPDUPN1hCcNVN7Ig7z7koyiRywBBaQg
        FCtqEl/AxbDzlrW2kT9NWGXWx/1o5nc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-Ugk1OS0wO_-bzLtF78Gh1g-1; Thu, 01 Apr 2021 10:44:16 -0400
X-MC-Unique: Ugk1OS0wO_-bzLtF78Gh1g-1
Received: by mail-ej1-f69.google.com with SMTP id mj6so2317205ejb.11
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 07:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5cXKDMg3hKjPJQxwPGQ5ktY0E9OHOmBfWVuhkV+IFpg=;
        b=ZFv/V9l6p355nhnw8Dp+nNoN6GxRBTQED9Hu9VMkURxTE2YIoOdxkMM20+nwba8uM2
         P8lx7b0+mo406oVJLqmvQ6ft+uSnNq8JGZhmk5DYSkuDkRDssigJuz3jtbcN7hjzf12L
         T01mVl51Wp39AgcLOinB5Lrbu1VjqCZqtVhpWlsxob1FM848cmE172t86OTCxKi+rdGV
         Kt5iKTqJzd5cxtwN8Je8IOFxlDWu8136moeKrrU21m/HT718pK+jfxSwu471Tspd3FeJ
         Vc6HChefcOuhRYRfg6i+nnRbUzKIN18QENMAJpqBOSdE9BH/cv+WtvJqnR+Qb7SIA113
         IQlA==
X-Gm-Message-State: AOAM530DiZkF00KXwNJAujfVLKSucK1eES/FrLF9zwA9eHNKe0PyWDa5
        dwCJzKQrJ6XE9mJxwQsZa4PRyEl81QmQxBP7TIyGvzgu7ZS8mlCSAuhbBX/zL9mSsDSSFWtF8Ad
        BIEOIA9vWjSpl
X-Received: by 2002:a17:906:7cc:: with SMTP id m12mr9198951ejc.171.1617288255494;
        Thu, 01 Apr 2021 07:44:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBvqVmNf7jxxrmZVvbLGCfGGoUZuyyx3hDl4qqpBdw1aJqT1wubt4ceARSA8kiv/b6Aoi4tw==
X-Received: by 2002:a17:906:7cc:: with SMTP id m12mr9198931ejc.171.1617288255332;
        Thu, 01 Apr 2021 07:44:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id si3sm2877618ejb.90.2021.04.01.07.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 07:44:14 -0700 (PDT)
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
 <20210401141814.1029036-5-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4/6] KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2
Message-ID: <b1a36c94-6dd5-88ef-a503-f6d91eb2d267@redhat.com>
Date:   Thu, 1 Apr 2021 16:44:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401141814.1029036-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just a quick review on the API:

On 01/04/21 16:18, Maxim Levitsky wrote:
> +struct kvm_sregs2 {
> +	/* out (KVM_GET_SREGS2) / in (KVM_SET_SREGS2) */
> +	struct kvm_segment cs, ds, es, fs, gs, ss;
> +	struct kvm_segment tr, ldt;
> +	struct kvm_dtable gdt, idt;
> +	__u64 cr0, cr2, cr3, cr4, cr8;
> +	__u64 efer;
> +	__u64 apic_base;
> +	__u64 flags; /* must be zero*/

I think it would make sense to define a flag bit for the PDPTRs, so that 
userspace can use KVM_SET_SREGS2 unconditionally (e.g. even when 
migrating from a source that uses KVM_GET_SREGS and therefore doesn't 
provide the PDPTRs).

> +	__u64 pdptrs[4];
> +	__u64 padding;

No need to add padding; if we add more fields in the future we can use 
the flags to determine the length of the userspace data, similar to 
KVM_GET/SET_NESTED_STATE.


> 
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	if (is_pae_paging(vcpu)) {
> +		for (i = 0 ; i < 4 ; i++)
> +			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
> +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> +		mmu_reset_needed = 1;
> +	}
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +

SRCU should not be needed here?

> +	case KVM_GET_SREGS2: {
> +		u.sregs2 = kzalloc(sizeof(struct kvm_sregs2), GFP_KERNEL_ACCOUNT);
> +		r = -ENOMEM;
> +		if (!u.sregs2)
> +			goto out;

No need to account, I think it's a little slower and this allocation is 
very short lived.

>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_SREGS2 196

195, not 196.

>  #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
>  #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
> +
> +#define KVM_GET_SREGS2             _IOR(KVMIO,  0xca, struct kvm_sregs2)
> +#define KVM_SET_SREGS2             _IOW(KVMIO,  0xcb, struct kvm_sregs2)
> +

It's not exactly overlapping, but please bump the ioctls to 0xcc/0xcd.

Paolo

