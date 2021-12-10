Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32419470CF2
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239547AbhLJWRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 17:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbhLJWRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 17:17:13 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C35CC061746;
        Fri, 10 Dec 2021 14:13:38 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so33811151edd.0;
        Fri, 10 Dec 2021 14:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=qELqGYlcnkzSKZFC2vN/cMrmp+OqxfI0N9xecKWte1g=;
        b=Z/ONwOtEX/FhQEGLeoj5pTFQJpAeoJ7/P5kueqMT9nAhftY0I4T30UKkCF5uaLrpH3
         CPQKHPzzyyw9lwLrpRPJg2Mqb1NYyfUmQVI/VfN7/INVB4IRv/xqpPixZO+XXexKmLWQ
         HMUiz4gLokP9MrI5JFTwoOvG/a9S+D0ySm71cdryVv4yxzxk0OFfUkh/5/i/eVmhKG4s
         LeRYMGyRR3pMY6cbwTIOuwRheDHcvlnXPS7bx0/D2ejwx3lljWzaVaZJJbRom1teEXnN
         D3Cg3QBg18JLSO2UIl9Xvgo2SafrCpvLu+rkjOpn1GdEr/hb1IBoychvRuNGzAgXcCLy
         umeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=qELqGYlcnkzSKZFC2vN/cMrmp+OqxfI0N9xecKWte1g=;
        b=lVorCclOXheOHmk8D6M5lRTyPNC82ha/S+8gRK2oZ3qHXo3HGxlHoMhmOa4xqHabEs
         FkWiDXWBpSKgQ5pb52Sw2+nu3Gv7NEG9AVDY5C1ZJXbutrvWSE3a96CI8FztpEy0rD2+
         fFsfX+MuSR7Jo3dJWQlwN4TEU3dwOy4IPKd0XRqcgDDFjO18TrPSBCXpe320UBqq16Qj
         VZCZUwmaCkKxSz+ax3QV1IH1P5gj+/mS+AWbyeIfwI8JQFBf3d9aa3uKmzdRF51+ynas
         xX1JuAu+Xy4BeU7q3yI4VmWDy8X5bfrSOcklDpi9jh4gdh6jqdYLQ6m9VC5PfxoJwpLo
         KHLg==
X-Gm-Message-State: AOAM533+atlZ8pWgUozJOS+qX4p8S3i3vRXZ5R0OZtHtUWH5MHX5F3OO
        ttlIeSX7vWKLsQWWSF4bZ2g=
X-Google-Smtp-Source: ABdhPJzRIuWF6mBvRWPDEuetC/KzZs614Ose6NImRrXhDKcMHyDpybx2bZqjLWHtHyvbqTemzK/sAA==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr42451894edd.2.1639174416532;
        Fri, 10 Dec 2021 14:13:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id hr17sm2017608ejc.57.2021.12.10.14.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 14:13:36 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
Date:   Fri, 10 Dec 2021 23:13:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
In-Reply-To: <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 17:30, Paolo Bonzini wrote:
>>
>> +static int kvm_vcpu_ioctl_x86_set_xsave2(struct kvm_vcpu *vcpu, u8 
>> *state)
>> +{
>> +    if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>> +        return 0;
>> +
>> +    return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, state,
>> +                          supported_xcr0, &vcpu->arch.pkru);
>> +}
>> +
> 
> I think fpu_copy_uabi_to_guest_fpstate (and therefore 
> copy_uabi_from_kernel_to_xstate) needs to check that the size is 
> compatible with the components in the input.
> 
> Also, IIUC the size of the AMX state will vary in different processors. 
>   Is this correct?  If so, this should be handled already by 
> KVM_GET/SET_XSAVE2 and therefore should be part of the 
> arch/x86/kernel/fpu APIs.  In the future we want to support migrating a 
> "small AMX" host to a "large AMX" host; and also migrating from a "large 
> AMX" host to a "small AMX" host if the guest CPUID is compatible with 
> the destination of the migration.

So, the size of the AMX state will depend on the active "palette" in 
TILECONFIG, and on the CPUID information.  I have a few questions on how 
Intel intends to handle future extensions to AMX:

- can we assume that, in the future, palette 1 will always have the same 
value (bytes_per_row=64, max_names=8, max_rows=16), and basically that 
the only variable value is really the number of palettes?

- how does Intel plan to handle bigger TILEDATA?  Will it use more XCR0 
bits or will it rather enlarge save state 18?

If it will use more XCR0 bits, I suppose that XCR0 bits will control 
which palettes can be chosen by LDTILECFG.

If not, on the other hand, this will be a first case of one system's 
XSAVE data not being XRSTOR-able on another system even if the 
destination system can set XCR0 to the same value as the source system.

Likewise, if the size and offsets for save state 18 were to vary 
depending on the selected palette, then this would be novel, in that the 
save state size and offsets would not be in CPUID anymore.  It would be 
particularly interesting for non-compacted format, where all save states 
after 18 would also move forward.

So, I hope that save state 18 will be frozen to 8k.  In that case, and 
if palette 1 is frozen to the same values as today, implementing 
migration will not be a problem; it will be essentially the same as 
SSE->AVX (horizontal extension of existing registers) and/or AVX->AVX512 
(both horizontal and vertical extension).

By the way, I think KVM_SET_XSAVE2 is not needed.  Instead:

- KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) should return the size of the 
buffer that is passed to KVM_GET_XSAVE2

- KVM_GET_XSAVE2 should fill in the buffer expecting that its size is 
whatever KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) passes

- KVM_SET_XSAVE can just expect a buffer that is bigger than 4k if the 
save states recorded in the header point to offsets larger than 4k.

Paolo
