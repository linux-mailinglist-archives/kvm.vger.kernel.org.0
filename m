Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC303BD8D7
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhGFOtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:49:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231509AbhGFOto (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2zEi3JA5vxYLnytmbscJHpgEdeSyuxKHDnYYh4/c/i4=;
        b=Zqgg0Sy2PmxLNaIbgZ00EI+5sLyvOfKLGWJ8HFU1ffgcI2qEo0NhDzEQ6Io5QToNV98Pxu
        29YhsNr1ihQ87FSeKjKAvAUob5kwEgcxB53W/V3NwEpe/v/sa3+sqzTVKabebxB48bvqLE
        cPwa8KlYUxo0Ck3NhD5Q/CKCvCuAPnE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-9VdZGzQYOeWe4zFYLFm91Q-1; Tue, 06 Jul 2021 10:47:04 -0400
X-MC-Unique: 9VdZGzQYOeWe4zFYLFm91Q-1
Received: by mail-wr1-f72.google.com with SMTP id u13-20020a5d6dad0000b029012e76845945so5172003wrs.11
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2zEi3JA5vxYLnytmbscJHpgEdeSyuxKHDnYYh4/c/i4=;
        b=j0tdovMU0SZyordBKDThaqORHy2bvqFceBf1IvmIvO3xrY945anGLKz5PJeQilJAed
         XTwhx46HwnnGrdaVxeUDNMutbz5P4337irnNsEx72ddJBn0I6UAJyzpq+Yr4A1i8xZu3
         zQDNTULua63NvjmmvXczoJuXkSTltPK3rH///yJTVOD7/eYf6woc86I9kPUWnDTl9ho4
         8oVOEdJoi++jed5sN2dgpPNgl2v6pVyGFYOVJtU0BEvK9Dtpwz8fVOD13koUZDYLVRtR
         5OXjsn0l/QccwCwV5H7Pl1dKxXWAadimzqb0JxmyOvVV+wa3xUzUyH7qmtU7FDExnYSY
         gbWw==
X-Gm-Message-State: AOAM530ocWsmdMfMwiIy/8WM1aAYXkNlgfyjwmieHNiiOVRFZHHUmmPH
        Vc96dCl7qFwlCNJA5W7JzBvTEJFOXYeoqHIDkyhM+S5KkvxTKCzu0sL30U8cRKkxkfR4JvDGGKR
        jRR099Q5oMeA9
X-Received: by 2002:a1c:7915:: with SMTP id l21mr1227688wme.62.1625582823376;
        Tue, 06 Jul 2021 07:47:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzid6t4p3WZqPjx3/4S24NKZA4uKoSLHJqm5fdOoy4vPppVyOj85o1MbAR3L/keEt0PxGAVDw==
X-Received: by 2002:a1c:7915:: with SMTP id l21mr1227662wme.62.1625582823199;
        Tue, 06 Jul 2021 07:47:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a12sm2879128wrh.26.2021.07.06.07.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:47:01 -0700 (PDT)
Subject: Re: [RFC PATCH v2 62/69] KVM: VMX: MOVE GDT and IDT accessors to
 common code
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
 <461baaa98c6b8c324ee297b76717d623d92bc510.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <524b2da2-21ae-f810-c513-f1a8325f4da9@redhat.com>
Date:   Tue, 6 Jul 2021 16:46:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <461baaa98c6b8c324ee297b76717d623d92bc510.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c |  6 ++++--
>   arch/x86/kvm/vmx/vmx.c  | 12 ------------
>   2 files changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index b619615f77de..8e03cb72b910 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -311,7 +311,8 @@ static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>   
>   static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
>   {
> -	vmx_get_idt(vcpu, dt);
> +	dt->size = vmread32(vcpu, GUEST_IDTR_LIMIT);
> +	dt->address = vmreadl(vcpu, GUEST_IDTR_BASE);
>   }
>   
>   static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> @@ -321,7 +322,8 @@ static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
>   
>   static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
>   {
> -	vmx_get_gdt(vcpu, dt);
> +	dt->size = vmread32(vcpu, GUEST_GDTR_LIMIT);
> +	dt->address = vmreadl(vcpu, GUEST_GDTR_BASE);
>   }
>   
>   static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 40843ca2fb33..d69d4dc7c071 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3302,24 +3302,12 @@ static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
>   	*l = (ar >> 13) & 1;
>   }
>   
> -static void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> -{
> -	dt->size = vmcs_read32(GUEST_IDTR_LIMIT);
> -	dt->address = vmcs_readl(GUEST_IDTR_BASE);
> -}
> -
>   static void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
>   {
>   	vmcs_write32(GUEST_IDTR_LIMIT, dt->size);
>   	vmcs_writel(GUEST_IDTR_BASE, dt->address);
>   }
>   
> -static void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
> -{
> -	dt->size = vmcs_read32(GUEST_GDTR_LIMIT);
> -	dt->address = vmcs_readl(GUEST_GDTR_BASE);
> -}
> -
>   static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
>   {
>   	vmcs_write32(GUEST_GDTR_LIMIT, dt->size);
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

