Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EC414647C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 10:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgAWJXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 04:23:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44393 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725785AbgAWJXt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 04:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579771428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xLPtPbflHkEcsflpAEJimzZzCHBwCpiVv1nVRjVe5L0=;
        b=Kbp3FpN7U58z1O2pSqa/LJoZJnO/3NKycnitdK9q+fYH/ryLsL0VWsRdTHmWf3H6BXdQiJ
        Cjne5GNGAwd8qe+sfU0/IyLKpeO10NBuddhC+bk4rCH9XIwwELeZSSth9e8OzS0b8daBsV
        2TFwMun3RIRy8HQO5cuDomtpNnRftig=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-9lr_kCW6ON-LvYitgWYBWw-1; Thu, 23 Jan 2020 04:23:46 -0500
X-MC-Unique: 9lr_kCW6ON-LvYitgWYBWw-1
Received: by mail-wr1-f70.google.com with SMTP id f10so1441043wro.14
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 01:23:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xLPtPbflHkEcsflpAEJimzZzCHBwCpiVv1nVRjVe5L0=;
        b=iaYuspmPLe1S1ICOF9Lkr/B2r2sm8+PdNXhcMKO3eOlxR/kopUsfz9/5QXuHvmxnqk
         CHT1ij/y/+mmzW/B5X8OMhjhu3O+T9LLgDW4sMhn3vUdMMzKI8SRl/1juInN9HjaUkSF
         PqrLfvuqAAvfYmqI1u8+uAjFbac7soxsGCbMiR6Ow5ejqPNVW9zDJOOzkniRwm6nb02Z
         eMDDkk2oFbnXRf24vJmlsvxj91hYOwiiGqlFPkpoy2eMttr4HfiPzUHDYCSMpsMGVvvn
         601yPJuUP4BMXGpRBLiZxVf3OMGcBlN5OaR6gOEIpy11a0Y9po24Seh0+xCqSRxf9c4X
         BnoQ==
X-Gm-Message-State: APjAAAVJXMk/5LdD7Zkw14rkNUAIJ0nv8gQ6SoqlvXiaYJpa6zFkhaCs
        POmNFGc80uzol1kU6BDxV3SqDtsgP53za35SxkIsJ0pdISQZqU7CsBd2XdmLU53+cL8P6CmnExm
        rFXWRNoxQe1JS
X-Received: by 2002:adf:e591:: with SMTP id l17mr16599144wrm.139.1579771424890;
        Thu, 23 Jan 2020 01:23:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzELIoIdvuyZLL2GrfNb1F5kfvJAuwopX6+bWrOHnJuStIZz7wtxB1xm4a+UrGei4ixbrQBPw==
X-Received: by 2002:adf:e591:: with SMTP id l17mr16599120wrm.139.1579771424641;
        Thu, 23 Jan 2020 01:23:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id 16sm1874485wmi.0.2020.01.23.01.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 01:23:44 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in
 handle_invvpid() default case
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
References: <1579749241-712-1-git-send-email-linmiaohe@huawei.com>
 <8736c6sga7.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a083ac8-3b01-fd2d-d867-2b3956cdef6d@redhat.com>
Date:   Thu, 23 Jan 2020 10:23:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8736c6sga7.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 09:55, Vitaly Kuznetsov wrote:
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 7608924ee8c1..985d3307ec56 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -5165,7 +5165,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>>  		break;
>>  	default:
>>  		WARN_ON_ONCE(1);
>> -		return kvm_skip_emulated_instruction(vcpu);
>> +		break;
>>  	}
>>  
>>  	return nested_vmx_succeed(vcpu);
> Your patch seems to do the right thing, however, I started wondering if
> WARN_ON_ONCE() is the right thing to do. SDM says that "If an
> unsupported INVVPID type is specified, the instruction fails." and this
> is similar to INVEPT and I decided to check what handle_invept()
> does. Well, it does BUG_ON(). 
> 
> Are we doing the right thing in any of these cases?

Yes, both INVEPT and INVVPID catch this earlier.

For INVEPT:

        types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;

        if (type >= 32 || !(types & (1 << type)))
                return nested_vmx_failValid(vcpu,
                                VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);



For INVVPID:

        types = (vmx->nested.msrs.vpid_caps &
                        VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;

        if (type >= 32 || !(types & (1 << type)))
                return nested_vmx_failValid(vcpu,
                        VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);

So I'm leaning towards not applying Miaohe's patch.  Happy Mouse Year
to everyone, here is an ASCII art (except for one Unicode character) mouse:


       __()()
      /     o)
  ~~~~\_,__,_>°

Thanks,

