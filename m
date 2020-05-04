Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558DA1C40A0
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbgEDQ5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:57:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31273 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729902AbgEDQ5u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:57:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UMnUEIb53M9vSJIf+4AAU2/DGQiUiV5KrSjI4HGHZSw=;
        b=O3f/U5E/U7hVUSRbMal20LdRLMIievX+mdDNIsPgAQLtlQrOQxEDg7u4hsfwyVMTjgSUd8
        uLpypxOrvZVGqP7kZmvSLFOJashOe/fYFz05SUcVybDy/dgSCSMho6Ez03dFUWxncNnu5e
        lCZsl9ld+M6Tz4CSoT5njZifm/DZYpk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-0Cp56PLVPwucbT9nc2p_Sg-1; Mon, 04 May 2020 12:57:33 -0400
X-MC-Unique: 0Cp56PLVPwucbT9nc2p_Sg-1
Received: by mail-wr1-f71.google.com with SMTP id u4so10609wrm.13
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UMnUEIb53M9vSJIf+4AAU2/DGQiUiV5KrSjI4HGHZSw=;
        b=brK/ZjM7qg9NOsenvIWcCVJ32+TBWfh7YwmApX0cH+99eDaYo4QG4PQT+fxbyZxfCo
         1O0MklMYe9YLtLWJHC0plbGLn6ZtiLGjyx/NIx6iLyeHqT1Rlah4/Zp9izFwDWVyN+j2
         SpNeEvmelma9K/uDjJYJqAXgR6hmKYhn18Mq6ADO1d/chX8A7AUqJ+gaPo99oA9UMSty
         29LMBR8BSek8aDaHRmxnPVqZgYvJ8o3LiQxNF6z0d/XA7RE9WCMQ9R5QFBGld5MCcgwF
         bl3NTuxFd13H94GHZmojWk3bJRn4vF9ax2M/VCfDPGOoF0jC9549EebKTuZPVNjsKjV9
         v6DA==
X-Gm-Message-State: AGi0PubyTkOCagdXJdr+RKi0CXZ1PZIRyXh3dfgRyzSR8NsgWrRlsmVw
        EQoduIsNLwh1YmI6pkgK/yP0K2PECv7eFCCjML+Dd3UGDAK+3HnJQmyWw+7e1J1YY6R4Iws4HKL
        YUJg5KJLzdgvV
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr16842982wml.55.1588611452516;
        Mon, 04 May 2020 09:57:32 -0700 (PDT)
X-Google-Smtp-Source: APiQypIfT82A7wi2+fnapnOEyrxLWBrkyoHVhpjhtvv2u/t3Q+vRVzopCBtWCWn6YMFVwLMVVI7c9A==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr16842964wml.55.1588611452299;
        Mon, 04 May 2020 09:57:32 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id o129sm27220wme.16.2020.05.04.09.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:57:31 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Force ASYNC_PF_PER_VCPU to be power of two
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200416155859.267366-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9018a62d-4473-fd3a-d48f-717ebb0442f7@redhat.com>
Date:   Mon, 4 May 2020 18:57:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416155859.267366-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 17:58, Peter Xu wrote:
> Forcing the ASYNC_PF_PER_VCPU to be power of two is much easier to be
> used rather than calling roundup_pow_of_two() from time to time.  Do
> this by adding a BUILD_BUG_ON() inside the hash function.
> 
> Another point is that generally async pf does not allow concurrency
> over ASYNC_PF_PER_VCPU after all (see kvm_setup_async_pf()), so it
> does not make much sense either to have it not a power of two or some
> of the entries will definitely be wasted.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/x86.c              | 8 +++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..9f0fdaacdfa5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -761,7 +761,7 @@ struct kvm_vcpu_arch {
>  
>  	struct {
>  		bool halted;
> -		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
> +		gfn_t gfns[ASYNC_PF_PER_VCPU];
>  		struct gfn_to_hva_cache data;
>  		u64 msr_val;
>  		u32 id;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b8124b562dea..fc74dafa72ff 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -261,7 +261,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
>  static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
>  {
>  	int i;
> -	for (i = 0; i < roundup_pow_of_two(ASYNC_PF_PER_VCPU); i++)
> +	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
>  		vcpu->arch.apf.gfns[i] = ~0;
>  }
>  
> @@ -10265,12 +10265,14 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  
>  static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
>  {
> +	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
> +
>  	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
>  }
>  
>  static inline u32 kvm_async_pf_next_probe(u32 key)
>  {
> -	return (key + 1) & (roundup_pow_of_two(ASYNC_PF_PER_VCPU) - 1);
> +	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
>  }
>  
>  static void kvm_add_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> @@ -10288,7 +10290,7 @@ static u32 kvm_async_pf_gfn_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
>  	int i;
>  	u32 key = kvm_async_pf_hash_fn(gfn);
>  
> -	for (i = 0; i < roundup_pow_of_two(ASYNC_PF_PER_VCPU) &&
> +	for (i = 0; i < ASYNC_PF_PER_VCPU &&
>  		     (vcpu->arch.apf.gfns[key] != gfn &&
>  		      vcpu->arch.apf.gfns[key] != ~0); i++)
>  		key = kvm_async_pf_next_probe(key);
> 

Queued, thanks.

Paolo

