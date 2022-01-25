Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4049B37C
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391586AbiAYME2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 07:04:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382795AbiAYMAo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 07:00:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643112031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2lsdYPIqQ4QlcpvU2QM4ze8T2zz+UGakXhoLQCT2xuc=;
        b=NED8xet4OZL3J00CxHbetxFWuuzj/zWX2STD+VrGJdB37A/qMKhs8nxC65RLm7yxzmz1zT
        +hDy7aXN5hhqYv0WnACEd1yF3TuL8XdQ/DRmNQl8PjAMNR0l/LrcJzULRGI2i2L0ojI3cE
        w2QJgyiFK28SD9G8lPfzikK6+qm111E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-V2YNY87SN4eE8Mg4okBMDw-1; Tue, 25 Jan 2022 07:00:30 -0500
X-MC-Unique: V2YNY87SN4eE8Mg4okBMDw-1
Received: by mail-wm1-f69.google.com with SMTP id o194-20020a1ca5cb000000b00350b177fb22so354434wme.3
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 04:00:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2lsdYPIqQ4QlcpvU2QM4ze8T2zz+UGakXhoLQCT2xuc=;
        b=2Dv8raiPxKDli2ipX+vb9doVZYTOcW9j7tdeAlSaGrQ4UbKisnySEZnz2nBEN6gONm
         jcF2w5nw7eLFPLH+lCHrzNs7MLX/qJJxHShq2ktB/bONK/FzkActL/eJPn+Q6/g7qEgw
         kY0iv1bhhl4hH0pLjfiJXSLLMnUq+EF996NzWRZKi5M5PL70d/+0AhMDMGBd6CNpuInA
         C1t1x0EtFxV7dxiiRI7+Ci9tX4WxBtaGfJGa/zFfWjx79cFfugoRktyUU5qQIjtibom7
         GXx5HB8//LH/aKLAAIimveEbvqtLUKBZmaf7c/4KlfH6T46sDFz97a66zN2GszbIpNy+
         1t4g==
X-Gm-Message-State: AOAM530kVzJe9WXT9afLLK2NIUG0fhJISibW2eC91rciHhjBvHqmNr9I
        xCIbiw1lsIeXOMx7ynTTerJQjWL8KbrBfUW35dQ0dXKhDPkJBiL10XTileywTV5O8aUjAgM4pw2
        LLFCMhBFFvg4m
X-Received: by 2002:a1c:cc08:: with SMTP id h8mr2659695wmb.156.1643112029287;
        Tue, 25 Jan 2022 04:00:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygqV37/XDy+29IPJuuFxB8Vr2Cp0cFygEJ6RlKk0ecIA/aj6eOc5JLqKQTmnbzn5TcAS8pZA==
X-Received: by 2002:a1c:cc08:: with SMTP id h8mr2659671wmb.156.1643112029092;
        Tue, 25 Jan 2022 04:00:29 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id g5sm12180088wri.108.2022.01.25.04.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 04:00:28 -0800 (PST)
Message-ID: <3035e023-d71a-407b-2ba6-45ad0ae85a9e@redhat.com>
Date:   Tue, 25 Jan 2022 13:00:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-7-scgl@linux.ibm.com>
 <069c72b6-457f-65c7-652e-e6eca7235fca@redhat.com>
 <8647fcaf-6d8a-4678-0695-4b1cc797b3b1@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <8647fcaf-6d8a-4678-0695-4b1cc797b3b1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 13.23, Janis Schoetterl-Glausch wrote:
> On 1/20/22 11:38, Thomas Huth wrote:
>> On 18/01/2022 10.52, Janis Schoetterl-Glausch wrote:
>>> Channel I/O honors storage keys and is performed on absolute memory.
>>> For I/O emulation user space therefore needs to be able to do key
>>> checked accesses.
>>> The vm IOCTL supports read/write accesses, as well as checking
>>> if an access would succeed.
>> ...
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index e3f450b2f346..dd04170287fd 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -572,6 +572,8 @@ struct kvm_s390_mem_op {
>>>    #define KVM_S390_MEMOP_LOGICAL_WRITE    1
>>>    #define KVM_S390_MEMOP_SIDA_READ    2
>>>    #define KVM_S390_MEMOP_SIDA_WRITE    3
>>> +#define KVM_S390_MEMOP_ABSOLUTE_READ    4
>>> +#define KVM_S390_MEMOP_ABSOLUTE_WRITE    5
>>
>> Not quite sure about this - maybe it is, but at least I'd like to see this discussed: Do we really want to re-use the same ioctl layout for both, the VM and the VCPU file handles? Where the userspace developer has to know that the *_ABSOLUTE_* ops only work with VM handles, and the others only work with the VCPU handles? A CPU can also address absolute memory, so why not adding the *_ABSOLUTE_* ops there, too? And if we'd do that, wouldn't it be sufficient to have the VCPU ioctls only - or do you want to call these ioctls from spots in QEMU where you do not have a VCPU handle available? (I/O instructions are triggered from a CPU, so I'd assume that you should have a VCPU handle around?)
> 
> There are some differences between the vm and the vcpu memops.
> No storage or fetch protection overrides apply to IO/vm memops, after all there is no control register to enable them.
> Additionally, quiescing is not required for IO, tho in practice we use the same code path for the vcpu and the vm here.
> Allowing absolute accesses with a vcpu is doable, but I'm not sure what the use case for it would be, I'm not aware of
> a precedence in the architecture. Of course the vcpu memop already supports logical=real accesses.

Ok. Maybe it then would be better to call new ioctl and the new op defines 
differently, to avoid confusion? E.g. call it "vmmemop" and use:

#define KVM_S390_VMMEMOP_ABSOLUTE_READ    1
#define KVM_S390_VMMEMOP_ABSOLUTE_WRITE   2

?

  Thomas

