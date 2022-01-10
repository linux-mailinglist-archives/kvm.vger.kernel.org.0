Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9195489C8B
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 16:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbiAJPsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 10:48:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231592AbiAJPsh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 10:48:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641829716;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FRh34pLIE/j1S6VXPTEy162SKih2nlk9xawUHYO91Iw=;
        b=DsmFFqZFwgyET2iY+Gb1sFUYp6AJaji6Ca+hSSk0nDlJe94GIoetn6mveQld/OFl3sLaSq
        viga72DATkqqHiQ6+m0tJq74CJjDU2kRiWdJRE/gY/hjmdv8tBCukldFazIlgYWYAxvw3O
        3s1yPSqwDw5gqxCKh1LEhpmrCniXT9Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-gWZClXd1MAS5x1AOECh8bQ-1; Mon, 10 Jan 2022 10:48:35 -0500
X-MC-Unique: gWZClXd1MAS5x1AOECh8bQ-1
Received: by mail-wm1-f69.google.com with SMTP id d4-20020a05600c34c400b00345d5d47d54so108989wmq.6
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 07:48:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=FRh34pLIE/j1S6VXPTEy162SKih2nlk9xawUHYO91Iw=;
        b=PSVj65rUzY+lHmaVZj5aogMX6tr62+twXT6ODFghxFHHi0Zy6fwGGtPzYaCZOmFg7Z
         vH4A3I2PG/Iw4gtYRE5e0aacndDM1Dlxcem7kYLtE/Z4JbIthvfrBOVsSFlwwV/D9hdx
         u9nthg/rXADLABgvWjnxKvMcJwqb2CwP0nLFLmbdBBBJAX9sId5h6bLvYtSKkS09h57J
         dI0Nirn01yjdEB0LtQhMriGa6Lkoqr2AH2YwYYk7Gc7Y/+FYmv5S4Fp9iVRnua/jVh65
         /NIjbAOdKDm8LQKmh8zAbhL9M/tnPO/hm6xNKzprtQCOhsuEMYS9bmzx54tQzPUdYG2l
         p5MA==
X-Gm-Message-State: AOAM532rVxipINn4VmVsyJg3rjloGdDvz+Ebg9QhX+Bc6H5QwO7CVN2s
        RZ/FtE8tId05fe7tUP75ueCroBhr9OhA7xXkO737soP88I6aNqRGZDOdM9Ye34LMjj9nLhX1aM7
        YPmq9ELGpN2+w
X-Received: by 2002:a05:6000:144c:: with SMTP id v12mr220809wrx.266.1641829714358;
        Mon, 10 Jan 2022 07:48:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydJ6KvXu0aXm01WZeSn2a0YAfQz/ZkJxslisA/6vpKl4Olp4DRMWEoBlP6JYDRfwXVCFQ3Nw==
X-Received: by 2002:a05:6000:144c:: with SMTP id v12mr220793wrx.266.1641829714194;
        Mon, 10 Jan 2022 07:48:34 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id b14sm6946310wrg.15.2022.01.10.07.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 07:48:33 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 2/6] hw/arm/virt: Add a control for the the highmem
 redistributors
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-3-maz@kernel.org>
 <448274ac-2650-7c09-742d-584109fb5c56@redhat.com>
 <87k0f7tx17.wl-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <f1d5a00b-b9d1-8e86-acd6-f7a605b77d8b@redhat.com>
Date:   Mon, 10 Jan 2022 16:48:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87k0f7tx17.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/10/22 4:45 PM, Marc Zyngier wrote:
> Hi Eric,
>
> On Mon, 10 Jan 2022 15:35:44 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 1/7/22 5:33 PM, Marc Zyngier wrote:
> [...]
>
>>> @@ -190,7 +191,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
>>>  
>>>      assert(vms->gic_version == VIRT_GIC_VERSION_3);
>>>  
>>> -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
>>> +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
>>> +            vms->highmem_redists) ? 2 : 1;
>> If we fail to use the high redist region, is there any check that the
>> number of vcpus does not exceed the first redist region capacity.
>> Did you check that config, does it nicely fail?
> I did, and it does (example on M1 with KVM):
>
> $ /home/maz/vminstall/qemu-hack -m 1G -smp 256 -cpu host -machine virt,accel=kvm,gic-version=3,highmem=on -nographic -drive if=pflash,format=raw,readonly=on,file=/usr/share/AAVMF/AAVMF_CODE.fd
> qemu-hack: warning: Number of SMP cpus requested (256) exceeds the recommended cpus supported by KVM (8)
> qemu-hack: warning: Number of hotpluggable cpus requested (256) exceeds the recommended cpus supported by KVM (8)
> qemu-hack: Capacity of the redist regions(123) is less than number of vcpus(256)

OK perfect!

Eric
>
> Thanks,
>
> 	M.
>

