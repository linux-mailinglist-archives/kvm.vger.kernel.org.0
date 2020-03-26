Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD78193FF1
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 14:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgCZNlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 09:41:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:43233 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbgCZNlH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 09:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585230066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oGdFXcuSNv1lFds/DpxLS9JrxVpkM15AF9tzkx4/Jpw=;
        b=fI5LR61t3VQSe1+0hddr0guNzMnNK8cvRf0PXx97Y/NecbWETohVUJAkdeFH6VWQSlbkF4
        Q1/Cw+O9Dk+gkPnjnEPm+LPdV7D41LUvItpmle3OkjE3J9WgWp4Qzpe54RyZ9Oa2cYhiEj
        KXXNSzFkxVgHuW3o1D3mrZUSJ50Y4Q0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-bdDucGl1OxuOIv4KaLxWoQ-1; Thu, 26 Mar 2020 09:41:05 -0400
X-MC-Unique: bdDucGl1OxuOIv4KaLxWoQ-1
Received: by mail-wm1-f70.google.com with SMTP id r19so2459449wmg.8
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 06:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oGdFXcuSNv1lFds/DpxLS9JrxVpkM15AF9tzkx4/Jpw=;
        b=eqSjmZtkN+3QZ3GyIjq6NtJkzdF8AnUHvc+TIfK6m3/S3TgHdgY/iLrTAMgxB+CSJs
         QNJVc1cDiAKWcQZhxyL+F36BA5ac4lfNqetXY0wvuV5377LfDsU758iyEswN5EQviKBQ
         t4huG/jUEJ8PHnGRvy7m7cHz4R+MUgtww1EzyregaKPQIrvurU1SY1VLr0rnNwBSl0D6
         VmGR+lK46OQ4vhwyrRhEtG+FJ2Mkk0HUAVxTGAaW+5qXIDtmxG+6lBKFyD+XibldqUkF
         oHUrLSWdInJzc5CX4L4iIaw7xsHRBx1RNeEeX5fukAivLugkXSGycWiilZ2/+bYoGKjx
         YIYg==
X-Gm-Message-State: ANhLgQ0Fiw0kxRrvd5MTr3dc0EF5od1h4NHSbbRK0OYD2AFpLV3PDf1D
        iaFo0MxuX80DqgPnOriUdE4IsIqL4kL4U0VFGPKBFYl6lL8zbzh8WrSRb8f29EaoI6Gwbci1/Th
        vRCupcLTAbriG
X-Received: by 2002:a1c:2404:: with SMTP id k4mr2006wmk.87.1585230063508;
        Thu, 26 Mar 2020 06:41:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtbbJGmBwGro5wmdPWHJOZmcvHECfDoJz68BZJMx279+d/UfjAoFqC4VUFQQs7980HsVdEJAw==
X-Received: by 2002:a1c:2404:: with SMTP id k4mr1979wmk.87.1585230063220;
        Thu, 26 Mar 2020 06:41:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y11sm3755358wrd.65.2020.03.26.06.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 06:41:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86: cleanup kvm_inject_emulated_page_fault
In-Reply-To: <20200326093516.24215-3-pbonzini@redhat.com>
References: <20200326093516.24215-1-pbonzini@redhat.com> <20200326093516.24215-3-pbonzini@redhat.com>
Date:   Thu, 26 Mar 2020 14:41:01 +0100
Message-ID: <877dz75j4i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> To reconstruct the kvm_mmu to be used for page fault injection, we
> can simply use fault->nested_page_fault.  This matches how
> fault->nested_page_fault is assigned in the first place by
> FNAME(walk_addr_generic).
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 6 ------
>  arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>  arch/x86/kvm/x86.c             | 7 +++----
>  3 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e26c9a583e75..6250e31ac617 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4353,12 +4353,6 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>  	return kvm_read_cr3(vcpu);
>  }
>  
> -static void inject_page_fault(struct kvm_vcpu *vcpu,
> -			      struct x86_exception *fault)
> -{
> -	vcpu->arch.mmu->inject_page_fault(vcpu, fault);
> -}
> -

This is already gone with Sean's "KVM: x86: Consolidate logic for
injecting page faults to L1".

It would probably make sense to have a combined series (or a branch on
kvm.git) to simplify testing efforts.

>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>  			   unsigned int access, int *nr_present)
>  {
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 1ddbfff64ccc..ae646acf6703 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -812,7 +812,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	if (!r) {
>  		pgprintk("%s: guest page fault\n", __func__);
>  		if (!prefault)
> -			inject_page_fault(vcpu, &walker.fault);
> +			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
>  
>  		return RET_PF_RETRY;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 64ed6e6e2b56..522905523bf0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -614,12 +614,11 @@ EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
>  bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>  				    struct x86_exception *fault)
>  {
> +	struct kvm_mmu *fault_mmu;
>  	WARN_ON_ONCE(fault->vector != PF_VECTOR);
>  
> -	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
> -		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
> -	else
> -		vcpu->arch.mmu->inject_page_fault(vcpu, fault);
> +	fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu : vcpu->arch.walk_mmu;
> +	fault_mmu->inject_page_fault(vcpu, fault);
>  
>  	return fault->nested_page_fault;
>  }

-- 
Vitaly

