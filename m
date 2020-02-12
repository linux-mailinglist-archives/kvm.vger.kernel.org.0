Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53415A861
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgBLLzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:55:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbgBLLzc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 06:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581508531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0IEHnwZZPyBIEGcR0ZsZyQ6KBh3ikM/o9PpbHc9B434=;
        b=XPqguJi/pWxR5mWRoUaY7Z5Qb8EkE4ObS0YDbUHb2BAE11mmQDarnu6oW4tNC7EOjw3wiT
        m8NGxEVR6VLHSO3bHYT66Odhj4CCDbTns9m7V6YHTYxxY0wqQ2jKJOaWjzqc39o0QNyBTS
        5+RuIrgl1YgAUEOszpQWS1fjCPZl5U0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-ubjCqxDVNEGl0_tw9J7F9w-1; Wed, 12 Feb 2020 06:55:29 -0500
X-MC-Unique: ubjCqxDVNEGl0_tw9J7F9w-1
Received: by mail-wr1-f70.google.com with SMTP id v17so702809wrm.17
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:55:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0IEHnwZZPyBIEGcR0ZsZyQ6KBh3ikM/o9PpbHc9B434=;
        b=kApJIYSIKfP5g1tXGbP8jPRr6K4WL62aWWKl6yXYxkh8tsrYdBs+M5AgBh85HNhvlS
         utmLmHnySGTEl2KgqgWLrlaJQjHoEvd9RwN1CHJqYm319aRxCgxVEEEZSiVhX6GYHQuk
         9XWlUAvjZNefZ3CJWzkh85Ym+UiK8IBfQ6iwLvBM75LIqTmzoqfNdccC24EaAKEIhcZg
         sPDgVVbg+FTmgfNCmAwi8tX0Qr6rtyJCWvVbhQuEJ+FH42J2KSNWo4EtHym79b2KnqOj
         tBDT/AbrcyXnccer6FjX4dSpv61pb6ZjgP+kx2AIdABBnakkZCMzUIp5Art1F/KHeLA4
         NniQ==
X-Gm-Message-State: APjAAAUpL9X3mBSFIiiOTMKLOVAhMRcPMnXquQDQHu3RpIOPye4/acJm
        pKJd9PFcsc+Ue1eLLpFnzRXNT6NJDVvQ7OSP9BjbUlyYU/R403+CnZQswccxzHsBs/CFTUW7mP9
        EXVHRm/Cx6+u5
X-Received: by 2002:a1c:f008:: with SMTP id a8mr12169437wmb.81.1581508528039;
        Wed, 12 Feb 2020 03:55:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqxPv5Ko8URJ2b/dg/ucuTlO72j/IzHX/OQJWevsFr3X0NDwhHuG4WRjjtdMTzfwnaFxsGduag==
X-Received: by 2002:a1c:f008:: with SMTP id a8mr12169409wmb.81.1581508527772;
        Wed, 12 Feb 2020 03:55:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id g7sm361622wrq.21.2020.02.12.03.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:55:27 -0800 (PST)
Subject: Re: [PATCH v2] KVM: nVMX: Fix some comment typos and coding style
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1581088965-3334-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <326b6411-d88d-5522-8296-6486d282a512@redhat.com>
Date:   Wed, 12 Feb 2020 12:55:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1581088965-3334-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 16:22, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Fix some typos in the comments. Also fix coding style.
> [Sean Christopherson rewrites the comment of write_fault_to_shadow_pgtable
> field in struct kvm_vcpu_arch.]
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> v1->v2:
> Use Sean Christopherson' comment for write_fault_to_shadow_pgtable
> ---
>  arch/x86/include/asm/kvm_host.h | 16 +++++++++++++---
>  arch/x86/kvm/vmx/nested.c       |  5 +++--
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4dffbc10d3f8..40a0c0fd95ca 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -781,9 +781,19 @@ struct kvm_vcpu_arch {
>  	u64 msr_kvm_poll_control;
>  
>  	/*
> -	 * Indicate whether the access faults on its page table in guest
> -	 * which is set when fix page fault and used to detect unhandeable
> -	 * instruction.
> +	 * Indicates the guest is trying to write a gfn that contains one or
> +	 * more of the PTEs used to translate the write itself, i.e. the access
> +	 * is changing its own translation in the guest page tables.  KVM exits
> +	 * to userspace if emulation of the faulting instruction fails and this
> +	 * flag is set, as KVM cannot make forward progress.
> +	 *
> +	 * If emulation fails for a write to guest page tables, KVM unprotects
> +	 * (zaps) the shadow page for the target gfn and resumes the guest to
> +	 * retry the non-emulatable instruction (on hardware).  Unprotecting the
> +	 * gfn doesn't allow forward progress for a self-changing access because
> +	 * doing so also zaps the translation for the gfn, i.e. retrying the
> +	 * instruction will hit a !PRESENT fault, which results in a new shadow
> +	 * page and sends KVM back to square one.
>  	 */
>  	bool write_fault_to_shadow_pgtable;
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 657c2eda357c..e7faebccd733 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -544,7 +544,8 @@ static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
>  	}
>  }
>  
> -static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap) {
> +static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
> +{
>  	int msr;
>  
>  	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
> @@ -1981,7 +1982,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
>  	}
>  
>  	/*
> -	 * Clean fields data can't de used on VMLAUNCH and when we switch
> +	 * Clean fields data can't be used on VMLAUNCH and when we switch
>  	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
>  	 */
>  	if (from_launch || evmcs_gpa_changed)
> 

Queued, thanks.

Paolo

