Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B9736F78C
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 11:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhD3JH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 05:07:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhD3JH0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Apr 2021 05:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619773598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHj3aPSNlnR+e/0iWYEPIjVJ3UrGKFYzhAQvYOuwStw=;
        b=bV1hHm1nu2U2p7UhK1mr8X9e7FEb4pdF8Rui6749Zxy3wK4jsgG4NR1F0zpAFRfnsYEjmA
        BzFTKpg8xonZ92YeiU/NDGfO2mHjb+oaN0n6X0PEZeL2D3dHYQhEzZmtsX0nIj5+07qVZ9
        x3RZAfVrkHYy9ZGGmkVyudfDQd9cGoc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-lWFl-7FkPPuq6nhmdI39Xg-1; Fri, 30 Apr 2021 05:06:36 -0400
X-MC-Unique: lWFl-7FkPPuq6nhmdI39Xg-1
Received: by mail-ed1-f70.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so28225789eds.13
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 02:06:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RHj3aPSNlnR+e/0iWYEPIjVJ3UrGKFYzhAQvYOuwStw=;
        b=RBsAfHu24reB1478II6PN2/mvp4M4TAbJ66TEaTNMHc5y1elTAMbs5moGFrm8iq4C0
         Hbu/3926aJ3nxvZqxLGs5cXjKpsKa+0FN9NBOe7rKIdyzWC4OKOTO37t10Lphw8HcGTR
         ncPmAXcNQelyJWqjdhwrWj83FY3l/TKnZwshUqPKeL1APZsSKRxDcqBgbjx5yy/SpT75
         O7MQQmVGrR5SXgGtz0gWOxivnCN5DV3kN2fQwAKhLDsMymxLpqIyGLcolOYzwyaPydC0
         YpmBgUccQLpltcYZ5ILiC7xDs4vfdqTXggK8us9fNDHNy5euYz1OZXXGYB9b4iLpdHPK
         95Pw==
X-Gm-Message-State: AOAM531DF4Jqi0nFrgRhXQ73LAEy9uLtKnHJq77UZ5JicrNmtj/UVYJa
        aalev6+Y53DlVPsk3OgpHH74l738+YSuCBPd1SMIPbb63r4QZgdCpEbWTKWfjzDuZLKDuVgZspC
        rdYMRYCfKHFYzlt5+2fxsTPgUbQx6lbsOjcQgG15Dr/Gmfrn+gZD22Yyyhtq9PFpR
X-Received: by 2002:a17:906:d7a6:: with SMTP id pk6mr3163148ejb.118.1619773594805;
        Fri, 30 Apr 2021 02:06:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtG83XWilui4ZuscSx08I+jXgXF0/RCmbV8LwAJ1PdCF0RybYjpi+E/Tvo0xdY5zHVXHdDFw==
X-Received: by 2002:a17:906:d7a6:: with SMTP id pk6mr3163103ejb.118.1619773594523;
        Fri, 30 Apr 2021 02:06:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z12sm786035edr.17.2021.04.30.02.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 02:06:33 -0700 (PDT)
Subject: Re: [PATCH 4/4] KVM/VMX: Fold handle_interrupt_nmi_irqoff() into its
 solo caller
To:     Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
 <20210426230949.3561-5-jiangshanlai@gmail.com>
 <87y2d0du02.ffs@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ba3f6230-8766-92e5-1189-a114c236fd48@redhat.com>
Date:   Fri, 30 Apr 2021 11:06:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87y2d0du02.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/21 11:03, Thomas Gleixner wrote:
> Lai,
> 
> On Tue, Apr 27 2021 at 07:09, Lai Jiangshan wrote:
>>   	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
>> @@ -6427,12 +6417,19 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>>   static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>>   {
>>   	u32 intr_info = vmx_get_intr_info(vcpu);
>> +	unsigned int vector;
>> +	gate_desc *desc;
>>   
>>   	if (WARN_ONCE(!is_external_intr(intr_info),
>>   	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>>   		return;
>>   
>> -	handle_interrupt_nmi_irqoff(vcpu, intr_info);
>> +	vector = intr_info & INTR_INFO_VECTOR_MASK;
>> +	desc = (gate_desc *)host_idt_base + vector;
>> +
>> +	kvm_before_interrupt(vcpu);
>> +	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
>> +	kvm_after_interrupt(vcpu);
> 
> So the previous patch does:
> 
> +               kvm_before_interrupt(&vmx->vcpu);
> +               vmx_do_interrupt_nmi_irqoff((unsigned long)asm_noist_exc_nmi);
> +               kvm_after_interrupt(&vmx->vcpu);
> 
> What is this idt gate descriptor dance for in this code?

NMIs are sent through a different vmexit code (the same one as 
exceptions).  This one is for interrupts.

Paolo

