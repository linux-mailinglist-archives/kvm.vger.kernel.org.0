Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BC0177681
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgCCM55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 07:57:57 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40396 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgCCM54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 07:57:56 -0500
Received: by mail-pg1-f195.google.com with SMTP id t24so1504140pgj.7
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 04:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Lg++IdYMeQd94pD/ZLBO5CJLpoQAjy8oNL8AZop1ans=;
        b=pBdyV79X5PzDSeKMLl78uCsyMMfApV/dm6Xt0abLb0CDLkPTIcuZfFfifhGyzHBFhQ
         uPB4L44CjJt97iTH9OX3ExajyF+uak9tl+MDBZELIkQQfJI1y1OkWiBWc7V5K5uXdoeX
         u6kP+HaiPiyu0ajhimW8fQaIwSIqfZ0BTiecuD48wzWbijj3BWVCVPXQ/vW7aH9X9HfV
         2XV3ry/BiJQIAjFEAV05BQrRjLk0QxP8gwLS54uTMj/wr7EVFpSiKBZf/OQXoqV5xBCi
         760oD2HdWo/B0hn2swU9vOQ+0n7r9yfX4BWiryhqSt8waHinEjBMk+4TlYNMMItRsRIC
         jZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Lg++IdYMeQd94pD/ZLBO5CJLpoQAjy8oNL8AZop1ans=;
        b=A7Y2a8wUx1OW7NY3UaCvdkauEGy7vRD4rXPyv9bPlmjWPbjGS84+NEVU25BKIz3/jB
         tSxY+YjrZndm4+ZsopWzk8B2dxxnI6rbpAiKN1aPtrf4u1Da5NZyHxjseQlpXDTZjmgO
         2rSuP5AlQVkX9PJB4a3YwNxwneZ4CO2eW1S/S0uA4yP8zAd/nE+cqcBG1v5wU6J/q1zL
         L5x3ZQaN5oFhi9Xm7UTl1ma4sxRvtoRjzTcYIh3OZe5qmrLSTgIzaVxqP0Fi2v2oHHaB
         Hkc18e8XpA22TVBgJLRWHg9MXrD04u1rl3WS3qlty7fiOQokmfqxyfENbbSzHytG88j4
         6vCQ==
X-Gm-Message-State: ANhLgQ0gKmqO98Koxm7xrpF3/Z/FHBHC5h+roYtsYXe98NDlIx5HPbao
        DGHuDc3rNaW2XmCn4dhX3EN06Q==
X-Google-Smtp-Source: ADFU+vvmaCiGdnLf7VVnD73qoTDE9qAVS2O4FvZFUlSW1+1T1yr52B7c7d1Vy26Nlbvk0udV+zchMA==
X-Received: by 2002:a63:91c1:: with SMTP id l184mr3862200pge.341.1583240275667;
        Tue, 03 Mar 2020 04:57:55 -0800 (PST)
Received: from [10.122.2.74] ([45.135.186.15])
        by smtp.gmail.com with ESMTPSA id x66sm13299097pgb.9.2020.03.03.04.57.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 04:57:54 -0800 (PST)
Subject: Re: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
To:     Auger Eric <eric.auger@redhat.com>,
        Tomasz Nowicki <tnowicki@marvell.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Cc:     "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "vincent.stehle@arm.com" <vincent.stehle@arm.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "tina.zhang@intel.com" <tina.zhang@intel.com>,
        wangzhou1 <wangzhou1@hisilicon.com>,
        Kenneth Lee <kenneth-lee-2012@foxmail.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
 <a35234a6-e386-fc8e-fcc4-5db4601b00d2@marvell.com>
 <3741c034-08f1-9dbb-ab06-434f3a8bd782@redhat.com>
From:   zhangfei <zhangfei.gao@linaro.org>
Message-ID: <e0133df5-073b-13e1-8399-ff48bfaef5e5@linaro.org>
Date:   Tue, 3 Mar 2020 20:57:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3741c034-08f1-9dbb-ab06-434f3a8bd782@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Eric

On 2019/11/20 下午6:18, Auger Eric wrote:
>
>>> This series brings the VFIO part of HW nested paging support
>>> in the SMMUv3.
>>>
>>> The series depends on:
>>> [PATCH v9 00/14] SMMUv3 Nested Stage Setup (IOMMU part)
>>> (https://www.spinics.net/lists/kernel/msg3187714.html)
>>>
>>> 3 new IOCTLs are introduced that allow the userspace to
>>> 1) pass the guest stage 1 configuration
>>> 2) pass stage 1 MSI bindings
>>> 3) invalidate stage 1 related caches
>>>
>>> They map onto the related new IOMMU API functions.
>>>
>>> We introduce the capability to register specific interrupt
>>> indexes (see [1]). A new DMA_FAULT interrupt index allows to register
>>> an eventfd to be signaled whenever a stage 1 related fault
>>> is detected at physical level. Also a specific region allows
>>> to expose the fault records to the user space.
>>>
>>> Best Regards
>>>
>>> Eric
>>>
>>> This series can be found at:
>>> https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9
>> I think you have already tested on ThunderX2, but as a formality, for
>> the whole series:
>>
>> Tested-by: Tomasz Nowicki <tnowicki@marvell.com>
>> qemu: https://github.com/eauger/qemu/tree/v4.1.0-rc0-2stage-rfcv5
>> kernel: https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9 +
>> Shameer's fix patch
>>
>> In my test I assigned Intel 82574L NIC and perform iperf tests.
> Thank you for your testing efforts.
>> Other folks from Marvell claimed this to be important feature so I asked
>> them to review and speak up on mailing list.
> That's nice to read that!  So it is time for me to rebase both the iommu
> and vfio parts. I will submit something quickly. Then I would encourage
> the review efforts to focus first on the iommu part.
>
>
vSVA feature is also very important to us, it will be great if vSVA can 
be supported in guest world.

We just submitted uacce for accelerator, which will be supporting SVA on 
host, thanks to Jean's effort.

https://lkml.org/lkml/2020/2/11/54


However, supporting vSVA in guest is also a key component for accelerator.

Looking forward this going to be happen.


Any respin, I will be very happy to test.


Thanks




