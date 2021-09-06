Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D78401F75
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244262AbhIFSPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 14:15:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243969AbhIFSPh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 14:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630952072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2xG82+ZFm24gH0tYAxEPUcMUMhGif1Gqp+OPOBOKLlw=;
        b=MNtbQ1yX2I0XTu78DoXd6FBS5Z6SoTVYgZLkFJR3fDHFHEUVwYsNqv1EKgtmXdiwqjSo9Y
        NRh/7fr6/T7wlO3JSnJCGMVIeEX+NfrCWhGz77jDpVMO7oCkI7V2GQNrhfmKH2MdbM6Oph
        tOGtJ1Yn7XZgyn7MCMX+EQjwXcBn5wo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-EergeGUkPoaaFlmdQWSF4A-1; Mon, 06 Sep 2021 14:14:31 -0400
X-MC-Unique: EergeGUkPoaaFlmdQWSF4A-1
Received: by mail-wr1-f71.google.com with SMTP id z15-20020adff74f000000b001577d70c98dso1357983wrp.12
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 11:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2xG82+ZFm24gH0tYAxEPUcMUMhGif1Gqp+OPOBOKLlw=;
        b=Fg0d2o8woF+DIPpi2z4KJ0TpnOdy1br0wdIoSqsxwpfQpEpJGmG+71TJaDPzk8xUjN
         lWOaYkADwP+d3rgGo3LdrPROIqQEdtemD/qA5gUjIAboWbBSqbkkREwRDx3VL+FpAfAf
         alV6iwfMegrs2Xhejdwy9sdecbbLv3xFs7sUd6wmwBx0zELotqDMVsjn0ebVAUiY94cz
         cQlUbjHUTwzqjsaWNBScl/7oLTpeIP44WhURizMqjOhkRnU+KuSxxxagdqdXNf+tA8kN
         fhLH421NGCljM2QMb2o5glfTAl3P+CSO2iwwvOEHFkY83ggQzEoqCej9LEHPQPs6TzNi
         62Sg==
X-Gm-Message-State: AOAM5324HvOFrr38S9y0+vQdLNF1Pj7P2PhwW/FLm1nr3HL7xBi9MEg6
        TlPCePO63uhFS0fcpN9fXzjB8+v5Zn12nZKk+f3eiEQBj9Ogr03aTRldqrnzrs9AlbriWhDyou1
        9ojJQx2gTWIUz
X-Received: by 2002:a7b:c18c:: with SMTP id y12mr358042wmi.3.1630952070548;
        Mon, 06 Sep 2021 11:14:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTKcGsAySmiUVPbZa0wChd03rANHOChx4tJM3XxNg2I2SNzcBrDT70CPLjiidSRHte2rT4JQ==
X-Received: by 2002:a7b:c18c:: with SMTP id y12mr358029wmi.3.1630952070330;
        Mon, 06 Sep 2021 11:14:30 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6323.dip0.t-ipconnect.de. [91.12.99.35])
        by smtp.gmail.com with ESMTPSA id w9sm217391wmc.19.2021.09.06.11.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 11:14:29 -0700 (PDT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-2-git-send-email-pmorel@linux.ibm.com>
 <b5ee1953-b19d-50ec-b2e2-47a05babcee4@redhat.com>
 <f8d8bf00-3965-d4a1-c464-59ffcf20bfa3@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 1/3] s390x: KVM: accept STSI for CPU topology
 information
Message-ID: <bb1f5629-a6c6-b299-7765-a4326c8fa2d5@redhat.com>
Date:   Mon, 6 Sep 2021 20:14:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f8d8bf00-3965-d4a1-c464-59ffcf20bfa3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.09.21 11:43, Pierre Morel wrote:
> 
> 
> On 8/31/21 3:59 PM, David Hildenbrand wrote:
>> On 03.08.21 10:26, Pierre Morel wrote:
>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>> Let's accept the interception of STSI with the function code 15 and
>>> let the userland part of the hypervisor handle it when userland
>>> support the CPU Topology facility.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/priv.c | 7 ++++++-
>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index 9928f785c677..8581b6881212 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -856,7 +856,8 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>        if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>>            return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>> -    if (fc > 3) {
>>> +    if ((fc > 3 && fc != 15) ||
>>> +        (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))) {
>>>            kvm_s390_set_psw_cc(vcpu, 3);
>>>            return 0;
>>>        }
>>> @@ -893,6 +894,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>                goto out_no_data;
>>>            handle_stsi_3_2_2(vcpu, (void *) mem);
>>>            break;
>>> +    case 15:
>>> +        trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
>>> +        insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>>> +        return -EREMOTE;
>>>        }
>>>        if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>>>            memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
>>>
>>
>> Sorry, I'm a bit rusty on s390x kvm facility handling.
>>
>>
>> For test_kvm_facility() to succeed, the facility has to be in both:
>>
>> a) fac_mask: actually available on the HW and supported by KVM
>> (kvm_s390_fac_base via FACILITIES_KVM, kvm_s390_fac_ext via
>> FACILITIES_KVM_CPUMODEL)
>>
>> b) fac_list: enabled for a VM
>>
>> AFAIU, facility 11 is neither in FACILITIES_KVM nor
>> FACILITIES_KVM_CPUMODEL, and I remember it's a hypervisor-managed bit.
>>
>> So unless we unlock facility 11 in FACILITIES_KVM_CPUMODEL, will
>> test_kvm_facility(vcpu->kvm, 11) ever successfully trigger here?
>>
>>
>> I'm pretty sure I am messing something up :)
>>
> 
> I think it is the same remark that Christian did as wanted me to use the
> arch/s390/tools/gen_facilities.c to activate the facility.
> 
> The point is that CONFIGURATION_TOPOLOGY, STFL, 11, is already defined
> inside QEMU since full_GEN10_GA1, so the test_kvm_facility() will
> succeed with the next patch setting the facility 11 in the mask when
> getting the KVM_CAP_S390_CPU_TOPOLOGY from userland.

Ok, I see ...

QEMU knows the facility and as soon as we present it to QEMU, QEMU will 
want to automatically enable it in the "host" model.

However, we'd like QEMU to join in and handle some part of it.

So indeed, handling it like KVM_CAP_S390_VECTOR_REGISTERS or 
KVM_CAP_S390_RI looks like a reasonable approach.

> 
> But if we activate it in KVM via any of the FACILITIES_KVM_xxx in the
> gen_facilities.c we will activate it for the guest what ever userland
> hypervizor we have, including old QEMU which will generate an exception.
> 
> 
> In this circumstances we have the choice between:
> 
> - use FACILITY_KVM and handle everything in kernel
> - use FACILITY_KVM and use an extra CAPABILITY to handle part in kernel
> to avoid guest crash and part in userland

This sounds quite nice to me. Implement minimal kernel support and 
indicate the facility via stfl to user space.

In addition, add a new capability that intercepts to user space instead.


... but I can understand that it might not be worth it.


This patch as it stands doesn't make any sense on its own. Either 
document how it's supposed to work and why it is currently dead code, or 
simply squash into the next patch (preferred IMHO).

-- 
Thanks,

David / dhildenb

