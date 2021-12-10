Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C654705BB
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243479AbhLJQdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243485AbhLJQds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:33:48 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CA1C0617A1;
        Fri, 10 Dec 2021 08:30:13 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id w1so31476298edc.6;
        Fri, 10 Dec 2021 08:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HpfDAT6WvpTP7gmAXKoP3MZTEZPgr1lYsw5PpU8yOc0=;
        b=JzyfTWDQn69yfucWjLc1cZichz725kMJ2TGgUbPRFpfBEmRhg4XIN5pn7HQwQPEy3E
         cOz6+uo7m7bOdUcTHHv/XnCURvoifRmdJ+833LJOB8eIiyL6Nr8SYQ2Ddb4G1cZ7uPSM
         NVN44FPhbzHuWg6Lif67dQ8G6vw1F9mNrT3jTuBhBnpy1qIyeAvnZubVM6qXrQbyvxIX
         8Ne2riDY2IvEX97HxyubPDk8bfjWki+CIcRizbntK9IsxNVOVtAdLRoxFFZl/a/xGtla
         PRvCAl2AWpUAWHJfoHzhrDDorZ93OipcBOJzw7wzNgEzaIucuN64kDFBm6D1X0PC59To
         2F9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HpfDAT6WvpTP7gmAXKoP3MZTEZPgr1lYsw5PpU8yOc0=;
        b=LpYkxG1dKqVIkgh5tK58yb2mwf3s7PzQo7WecLlPNFq72kcNCUZxaJm3rPj9KOS/v8
         CCaqijIrzzF8ENEZeDaWrxJQhBZrEN7wH4y452gDBlOD2sP1AlmFlwsuxRlj69fdL6Hz
         8p+BFOSj0LsTIwBWsgKKDlDgwDAsL6itsZMvJZv52Ja5mD86LVgPJ5ZgqCBY3GHpWItk
         8/QT9RLYvuOX/8RKrftu7RrPiEHEaD6XGnyxz74U+SZ53NsaomJf9IJ1QOYY0kdV6Clr
         91lHCC3yAcBSMOrUe71N+Sos46RkNypY4UneqwJRM5KHoBMVrWQ2yWo6/CR/Z3wZ2qcO
         m+QA==
X-Gm-Message-State: AOAM5313A+hFTHT7dyL5hHrKz0eJaCswQ4f9RLj268Wk2xQV1t7SeZ72
        TvrTCeR8zylJGLwUiKFHrnw=
X-Google-Smtp-Source: ABdhPJy6Ku7kFWtOND31ALTRNyVN3SlfFf/oJTIsfZCTNq0UowdA1z7e9ut7ZSKnFag0HFLy2JUTOw==
X-Received: by 2002:a17:906:c297:: with SMTP id r23mr24426129ejz.528.1639153810966;
        Fri, 10 Dec 2021 08:30:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id nb4sm1713429ejc.21.2021.12.10.08.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:30:10 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
Date:   Fri, 10 Dec 2021 17:30:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-17-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
> +static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> +					  u8 *state, u32 size)
> +{
> +	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> +		return;
> +
> +	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
> +				       state, size,
> +				       vcpu->arch.pkru);
> +}
> +
>   static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>   					struct kvm_xsave *guest_xsave)
>   {
> @@ -4951,6 +4963,15 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>   					      supported_xcr0, &vcpu->arch.pkru);
>   }
>   
> +static int kvm_vcpu_ioctl_x86_set_xsave2(struct kvm_vcpu *vcpu, u8 *state)
> +{
> +	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> +		return 0;
> +
> +	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, state,
> +					      supported_xcr0, &vcpu->arch.pkru);
> +}
> +

I think fpu_copy_uabi_to_guest_fpstate (and therefore 
copy_uabi_from_kernel_to_xstate) needs to check that the size is 
compatible with the components in the input.

Also, IIUC the size of the AMX state will vary in different processors. 
  Is this correct?  If so, this should be handled already by 
KVM_GET/SET_XSAVE2 and therefore should be part of the 
arch/x86/kernel/fpu APIs.  In the future we want to support migrating a 
"small AMX" host to a "large AMX" host; and also migrating from a "large 
AMX" host to a "small AMX" host if the guest CPUID is compatible with 
the destination of the migration.

Paolo
