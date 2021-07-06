Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D921F3BD8D1
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhGFOtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:49:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231453AbhGFOtD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/fNLNqPbpNRl0+W5voAKm17mYQz3ARBBCnEfhzOSa4=;
        b=i3iQOdnGwRoQrDeiH9IhDsBLbtDbjh4LltVOf4iS1PWGb9pWMp2PBazUH+hhVP3/BlLerZ
        fNN1P6Lw1xtlqozHDM6sdsTxiXKcX+/mFIlDoLalZxS7m/xXjTZSSas86AIsGqvsdllpVn
        zv9ibXGilrQlFVSI7fT3YAnnm6TyXpY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-fCgfD-t2OgGYL3T5TUc-kw-1; Tue, 06 Jul 2021 10:46:23 -0400
X-MC-Unique: fCgfD-t2OgGYL3T5TUc-kw-1
Received: by mail-wm1-f69.google.com with SMTP id n11-20020a05600c3b8bb02901ec5ef98aa0so3806775wms.0
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/fNLNqPbpNRl0+W5voAKm17mYQz3ARBBCnEfhzOSa4=;
        b=kxoJUbqxaqOKnq46UsOsdX2Xww4xMF2MmRyjS00An/ZGLAHvrnZgf9RewKRnVTVrYQ
         5GRzX+ThiODY+2YbUDeP6vHH+iDcq491nAzY9BMxEGi39tvUtfRdyuVX/nm1OwSzWTGe
         qfX8E1bm1PQgDIPa9i7DuiWfkb9Rns2kug+aeZeXdB8AnBlbGVEH1d/ZUtWViBHwk4Cy
         fX0lgOUbXjEGYztFx484GSZTVPQaod+Ibm6eDjjMSnTJ2sTnzsHxyVioHslgMQcxBZuf
         +kUTYOarNMizaNGs1szdg/ADTZkd6UpfJnoSRYporGH3r0xRDSUWK4kpQIFDevDHnMMb
         Mvmg==
X-Gm-Message-State: AOAM530I8TyjNep2wrUws89czvHi959rS5RvY/vGBwECFMxMVbIiE7gH
        H4ixlMy1n+65KWQ7s/iWyGiXbJ9KnasTbwCpG/s33XWMbMi7muPEORwyhNffqX/QIS7yK406+tT
        88Xu+gsIPeF16
X-Received: by 2002:a5d:58f3:: with SMTP id f19mr22339134wrd.15.1625582782044;
        Tue, 06 Jul 2021 07:46:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJVlDUF95/56UZ2XdNUe3eojOejB0w5zFEPsUbIHF615IGltxhCm4HD1fNcOJuH+n82ZpXbg==
X-Received: by 2002:a5d:58f3:: with SMTP id f19mr22339098wrd.15.1625582781854;
        Tue, 06 Jul 2021 07:46:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n20sm15439384wmk.12.2021.07.06.07.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:46:19 -0700 (PDT)
Subject: Re: [RFC PATCH v2 60/69] KVM: VMX: Add macro framework to read/write
 VMCS for VMs and TDs
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
 <5735bf9268130a70b49bc32ff4b68ffc53ee788c.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <71ee8575-bd72-f51e-38c5-4e8411b8aedd@redhat.com>
Date:   Tue, 6 Jul 2021 16:46:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5735bf9268130a70b49bc32ff4b68ffc53ee788c.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a macro framework to hide VMX vs. TDX details of VMREAD and VMWRITE
> so the VMX and TDX can shared common flows, e.g. accessing DTs.
> 
> Note, the TDX paths are dead code at this time.  There is no great way
> to deal with the chicken-and-egg scenario of having things in place for
> TDX without first having TDX.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/common.h | 41 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 41 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 9e5865b05d47..aa6a569b87d1 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -11,6 +11,47 @@
>   #include "vmcs.h"
>   #include "vmx.h"
>   #include "x86.h"
> +#include "tdx.h"
> +
> +#ifdef CONFIG_KVM_INTEL_TDX

Is this #ifdef needed at all if tdx.h properly stubs is_td_vcpu (to 
return false) and possibly declares a dummy version of 
td_vmcs_read/td_vmcs_write?

Paolo

> +#define VT_BUILD_VMCS_HELPERS(type, bits, tdbits)			   \
> +static __always_inline type vmread##bits(struct kvm_vcpu *vcpu,		   \
> +					 unsigned long field)		   \
> +{									   \
> +	if (unlikely(is_td_vcpu(vcpu))) {				   \
> +		if (KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))		   \
> +			return 0;					   \
> +		return td_vmcs_read##tdbits(to_tdx(vcpu), field);	   \
> +	}								   \
> +	return vmcs_read##bits(field);					   \
> +}									   \
> +static __always_inline void vmwrite##bits(struct kvm_vcpu *vcpu,	   \
> +					  unsigned long field, type value) \
> +{									   \
> +	if (unlikely(is_td_vcpu(vcpu))) {				   \
> +		if (KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))		   \
> +			return;						   \
> +		return td_vmcs_write##tdbits(to_tdx(vcpu), field, value);  \
> +	}								   \
> +	vmcs_write##bits(field, value);					   \
> +}
> +#else
> +#define VT_BUILD_VMCS_HELPERS(type, bits, tdbits)			   \
> +static __always_inline type vmread##bits(struct kvm_vcpu *vcpu,		   \
> +					 unsigned long field)		   \
> +{									   \
> +	return vmcs_read##bits(field);					   \
> +}									   \
> +static __always_inline void vmwrite##bits(struct kvm_vcpu *vcpu,	   \
> +					  unsigned long field, type value) \
> +{									   \
> +	vmcs_write##bits(field, value);					   \
> +}
> +#endif /* CONFIG_KVM_INTEL_TDX */
> +VT_BUILD_VMCS_HELPERS(u16, 16, 16);
> +VT_BUILD_VMCS_HELPERS(u32, 32, 32);
> +VT_BUILD_VMCS_HELPERS(u64, 64, 64);
> +VT_BUILD_VMCS_HELPERS(unsigned long, l, 64);
>   
>   extern unsigned long vmx_host_idt_base;
>   void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
> 

