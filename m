Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A008396BE7
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 05:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhFADdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 23:33:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232598AbhFADdp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 23:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622518324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wO/Ymt4rFpB9aPVUx2fOwYVlvuO0/tOHoU+BNz8BFGU=;
        b=GHDWcQHe1ttA0cRNXJFiavovwRS7orP+/XeRsdSopdi/z77qgudOXJY3nXCkTgpSXnG7dD
        IWf7h4bgDJm1bESLz1X0f8pGhwqda+CVovg9IxdDF01zp2wiXw4xEW1IbjjPPLBwn1CaWe
        xcR49hedwx1SqVWq6CbuGOQ7MO4gMo8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-0XInWVPVNHeGj3GGTQ6b8Q-1; Mon, 31 May 2021 23:32:02 -0400
X-MC-Unique: 0XInWVPVNHeGj3GGTQ6b8Q-1
Received: by mail-pg1-f197.google.com with SMTP id x29-20020a63b21d0000b0290220232dd8e6so2014609pge.2
        for <kvm@vger.kernel.org>; Mon, 31 May 2021 20:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wO/Ymt4rFpB9aPVUx2fOwYVlvuO0/tOHoU+BNz8BFGU=;
        b=G0Z36nyvlieVdRNsJvCnq0wsLC+KdW3TnpbkKahIZ6rod1HBXrh6d/VVluwGIO54Wp
         ckgKegh7SQd9coPVCLRjwvertJ//uxmeLkmsUe3KKMLsQmv/lcoXWsJGr2O5GCooVMlK
         QLQRkIQI8KF0VKFpjEFUo70wQdBYHMwgWeGYS0a3ldiCAHwN2e2fAgoVOw8A9LkRkswP
         omxzGLrV+20nWX91MddvEQPOhmsS4pg20TRORhbceJtdeU9MWWrPNjEn/ybb4GTAanic
         fs6Q1ie3eSqA+QQt5oEmrRA3HlznaPgdbuxdiJr9PPwHq00UbRdnqupsEMZp2T3jePfp
         +kSA==
X-Gm-Message-State: AOAM532jn+UfQykIMlGIsmCKdwFZ9vD0PtR0UlVn9OatfhLxI7UOsHPX
        mAZMhhAWPE+YEk9D9vo6t5SdKN86uX5iHI+JcnvEPSEm9MBoku/m2FbREswCHAlBONHNe2IyHuA
        Fsvcy6KK9mwRmdGd0a79jdEIUjqLrxrUj0FzcZtytV8XrGlPUSOdjY05Rnob6Jqfy
X-Received: by 2002:a62:860b:0:b029:28e:d45b:4d2e with SMTP id x11-20020a62860b0000b029028ed45b4d2emr20061995pfd.70.1622518321099;
        Mon, 31 May 2021 20:32:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz8tloqg4mNdNJcuGsMq7jMbGxC3NTMB3AeEEmzuoOAB9HUW4bJISV/+kfES7ueUEZ0B+d1A==
X-Received: by 2002:a62:860b:0:b029:28e:d45b:4d2e with SMTP id x11-20020a62860b0000b029028ed45b4d2emr20061973pfd.70.1622518320807;
        Mon, 31 May 2021 20:32:00 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r11sm12553574pgl.34.2021.05.31.20.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 20:32:00 -0700 (PDT)
Subject: Re: [PATCH V2 RESEND 2/2] vDPA/ifcvf: implement doorbell mapping for
 ifcvf
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210531073316.363655-1-lingshan.zhu@intel.com>
 <20210531073316.363655-3-lingshan.zhu@intel.com>
 <f3c28e92-3e8d-2a8a-ec5a-fc64f2098678@redhat.com>
 <5dbdc6a5-1510-9411-6b85-d947d091089c@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <91c64c0c-7b78-4c41-a6d7-6d9f084c7cc5@redhat.com>
Date:   Tue, 1 Jun 2021 11:31:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <5dbdc6a5-1510-9411-6b85-d947d091089c@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/1 上午11:27, Zhu, Lingshan 写道:
>
>
> On 5/31/2021 3:56 PM, Jason Wang wrote:
>>
>> 在 2021/5/31 下午3:33, Zhu Lingshan 写道:
>>> This commit implements doorbell mapping feature for ifcvf.
>>> This feature maps the notify page to userspace, to eliminate
>>> vmexit when kick a vq.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 17 +++++++++++++++++
>>>   1 file changed, 17 insertions(+)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index ab0ab5cf0f6e..effb0e549135 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -413,6 +413,22 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>>> vdpa_device *vdpa_dev,
>>>       return vf->vring[qid].irq;
>>>   }
>>>   +static struct vdpa_notification_area 
>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>>> +                                   u16 idx)
>>> +{
>>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>> +    struct pci_dev *pdev = adapter->pdev;
>>> +    struct vdpa_notification_area area;
>>> +
>>> +    area.addr = vf->vring[idx].notify_pa;
>>> +    area.size = PAGE_SIZE;
>>> +    if (area.addr % PAGE_SIZE)
>>> +        IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE 
>>> aligned\n", idx);
>>
>>
>> Let's leave the decision to upper layer by: (see 
>> vp_vdpa_get_vq_notification)
>>
>> area.addr = notify_pa;
>> area.size = notify_offset_multiplier;
>>
>> Thanks
>
> Hi Jason,
>
> notify_offset_multiplier can be zero, means vqs share the same 
> doorbell address, distinguished by qid.
> and in vdpa.c:
>
>         if (vma->vm_end - vma->vm_start != notify.size)
>                 return -ENOTSUPP;
>
> so a zero size would cause this feature failure.
> mmap should work on at least a page, so if we really want "area.size = 
> notify_offset_multiplier;"
> I think we should add some code in vdpa.c, like:
>
> if(!notify.size)
>     notify.size = PAGE_SIZE;
>
> sounds good?


It's the responsibility of the driver to report a correct one. So I 
think it's better to tweak it as:

area.size = notify_offset_multiplier ?: PAGE_SIZE;

Thanks


>
> Thanks
> Zhu Lingshan
>>
>>
>>> +
>>> +    return area;
>>> +}
>>> +
>>>   /*
>>>    * IFCVF currently does't have on-chip IOMMU, so not
>>>    * implemented set_map()/dma_map()/dma_unmap()
>>> @@ -440,6 +456,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops 
>>> = {
>>>       .get_config    = ifcvf_vdpa_get_config,
>>>       .set_config    = ifcvf_vdpa_set_config,
>>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>>> +    .get_vq_notification = ifcvf_get_vq_notification,
>>>   };
>>>     static int ifcvf_probe(struct pci_dev *pdev, const struct 
>>> pci_device_id *id)
>>
>

