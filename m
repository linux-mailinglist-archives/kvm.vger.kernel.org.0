Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9869498155
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 14:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiAXNqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 08:46:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229562AbiAXNqe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 08:46:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643031993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VMWjUFPNROSNZ1gB7bIAJHjMk/KVdbCxC1i1CaU9o8k=;
        b=dLaq+IBnNeXqPubyheXgyWNkID+xMyS8+JlPZKTFbclUe2gHPL7G0/GxOfs5yBNV6AK3BZ
        vzBU70fEpeQR88+AaddKhapHfh5n1sqZFNb35lqpuJFLuNh+CIDhCNzXoBgUtdxK08DVcF
        IFHGeb529SqUGYtE6FMivvH+FSUv7ls=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-bYncPiTgPEOR2nWGNSIWfA-1; Mon, 24 Jan 2022 08:46:31 -0500
X-MC-Unique: bYncPiTgPEOR2nWGNSIWfA-1
Received: by mail-ed1-f70.google.com with SMTP id p17-20020aa7c891000000b004052d1936a5so8793618eds.7
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 05:46:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VMWjUFPNROSNZ1gB7bIAJHjMk/KVdbCxC1i1CaU9o8k=;
        b=Cqz1KEJa6RpagGQJmYBRXXFbh4bFg1+vHIOtk4EDPXztuMzh5+M7R8BQ3gfQk4/jQ1
         uUtZ/WPEEqucfNSH21Kdm9STRGe+cUYcRtKiwZMvEZZ4SIOBxnmyvVGZNL+AGaSFiFbZ
         IymGa2Ef3+Qj23ZfDXBmezu5a4wUSazdDvxEmENMjmr/CfbuouxeqkeHBkyTqUS3t/SD
         oNlc6uRCKqWJa5C18P16LLEHCI80QnXDUZ5+QSRZqHMSWZqlBiZ7JRcYu99Zg6xKIlBV
         QDbqtjDj/P3FRzNCNWSNCRMqGiTt05GZh79c8fKkoDebPxJOJPj0lFdX3aUqnpdX4XgM
         dd1A==
X-Gm-Message-State: AOAM532XjLbfm6Wc/2nGxLeZW80/OUe0ZHNL4CO+0Juo8hXLzsaEuBlr
        HcuI4usi1qYAzMiT6QSB/KagiXAq74Ny9Flaz5O9VJZRGFMa0bfz6MLOf3gzOoVgKb+Qpi0cCtF
        ZzONRSRfOvKYo
X-Received: by 2002:a05:6402:650:: with SMTP id u16mr16286107edx.163.1643031990562;
        Mon, 24 Jan 2022 05:46:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPPS6Cfx4PZykBtvSaLRQRaAbKk4CngKeatZ4sjeSvxKkSns8X1naDMiTsILFxx8eTjvA0Ag==
X-Received: by 2002:a05:6402:650:: with SMTP id u16mr16286089edx.163.1643031990351;
        Mon, 24 Jan 2022 05:46:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gh14sm4886125ejb.38.2022.01.24.05.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 05:46:29 -0800 (PST)
Message-ID: <93cd45a7-700b-2437-d56b-3597bdadb657@redhat.com>
Date:   Mon, 24 Jan 2022 14:46:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: VMX: Zero host's SYSENTER_ESP iff SYSENTER is NOT
 used
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
References: <20220122015211.1468758-1-seanjc@google.com>
 <8735lgjgwl.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8735lgjgwl.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/22 09:47, Vitaly Kuznetsov wrote:
>>   	 */
>> -	vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
>> +	if (!IS_ENABLED(CONFIG_IA32_EMULATION) && !IS_ENABLED(CONFIG_X86_32))
> Isn't it the same as "!IS_ENABLED(CONFIG_COMPAT_32)"? (same goes to the
> check in vmx_vcpu_load_vmcs())
> 

It is, but I think it's clearer to write it as it's already done in 
arch/x86/kvm/vmx/vmx.c, or possibly

if (IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_IA32_EMULATION))

CONFIG_COMPAT_32 doesn't say as clearly whether it's enabled for 32-bit 
systems or not.

Paolo

