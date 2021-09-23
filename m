Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E6C4158FB
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 09:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbhIWH1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 03:27:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239075AbhIWH1F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 03:27:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632381933;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FvNkPyLF+1kcsTR6hdilBDqHZDnrfR2QQ6CleyZplLs=;
        b=h+M4oYZdcSAcFtYKtVvwX+bn4KZhVYESX+9N/CDANafke3O4w2HThQDucSWK20CpUWYqzX
        h6fAog/3QivrK7L7uHUNZs98K3bjws51xgcsDD3kXAmwy7TlL//CJ0D1R0ZwtAsQ75oD1I
        YCHNlDGv6f3kXybMfTCuPs2XK50gcYw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-wGGMro9OOICIP2292N4l6w-1; Thu, 23 Sep 2021 03:25:31 -0400
X-MC-Unique: wGGMro9OOICIP2292N4l6w-1
Received: by mail-wr1-f69.google.com with SMTP id v15-20020adff68f000000b0015df51efa18so4333293wrp.16
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 00:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=FvNkPyLF+1kcsTR6hdilBDqHZDnrfR2QQ6CleyZplLs=;
        b=ZAcf8qUSm1BcOApAQXkhMAMRrCs0vVmSIGDFwabH1SvSVU3ALzAe3pGRtzG1FlmwND
         n/Ojpuh8yatu9u+q6FPAoybgBWl0LKrIUv6MgNcJ+0RM099a3eoGfzhc4rRKdciFglzu
         tbVGaT5jQar+dU7oT9dc4sGMKzcs/Z/icVj95K4+jjAaj+Zu7uShvnIXv0m9QD9rCJBz
         9rXWIB18YaHyq0GfxjsW69eb1c4K68AOfD1n/cf2qbfLj3h3nQUdVtlAWUV/9Xsz06yS
         UGnebZj1YagDxlro1rGWtyuNKwucT/H3SuPMOi2LBPE+C4NSBMwZr7dbS2OYzaKodUVR
         l04w==
X-Gm-Message-State: AOAM533kQAC1cqb0o5VBysCrJjuucUUAH/ibiVjjly6WS6a7hhxw5Mfs
        7CepmpBToc7rt+cB/WehAM0y00mfJwEcx2aMzioHYRhV0kzbJYAJgm1du9/x5t5D36HPTXYVhYU
        cYJGICmpWTVmA
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr3162692wru.243.1632381930605;
        Thu, 23 Sep 2021 00:25:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGEfOyPkvpzZWpr9l9SkDYU2vwNuyGcQuSIPfvYxfPQ2pBpa+znyeIdD2Ff7pAnFgXSYPtrQ==
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr3162668wru.243.1632381930433;
        Thu, 23 Sep 2021 00:25:30 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r9sm4325952wru.2.2021.09.23.00.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 00:25:29 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 03/20] vfio: Add vfio_[un]register_device()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB54330421CA825F5CAA44BAC98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922010014.GE327412@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <7d717ad0-fb9b-2af0-7818-147dc5d21373@redhat.com>
Date:   Thu, 23 Sep 2021 09:25:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210922010014.GE327412@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/22/21 3:00 AM, Jason Gunthorpe wrote:
> On Wed, Sep 22, 2021 at 12:54:02AM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>> Sent: Wednesday, September 22, 2021 12:01 AM
>>>
>>>>  One open about how to organize the device nodes under
>>> /dev/vfio/devices/.
>>>> This RFC adopts a simple policy by keeping a flat layout with mixed
>>> devname
>>>> from all kinds of devices. The prerequisite of this model is that devnames
>>>> from different bus types are unique formats:
>>> This isn't reliable, the devname should just be vfio0, vfio1, etc
>>>
>>> The userspace can learn the correct major/minor by inspecting the
>>> sysfs.
>>>
>>> This whole concept should disappear into the prior patch that adds the
>>> struct device in the first place, and I think most of the code here
>>> can be deleted once the struct device is used properly.
>>>
>> Can you help elaborate above flow? This is one area where we need
>> more guidance.
>>
>> When Qemu accepts an option "-device vfio-pci,host=DDDD:BB:DD.F",
>> how does Qemu identify which vifo0/1/... is associated with the specified 
>> DDDD:BB:DD.F? 
> When done properly in the kernel the file:
>
> /sys/bus/pci/devices/DDDD:BB:DD.F/vfio/vfioX/dev
>
> Will contain the major:minor of the VFIO device.
>
> Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> that the major:minor matches.
>
> in the above pattern "pci" and "DDDD:BB:DD.FF" are the arguments passed
> to qemu.
I guess this would be the same for platform devices, for instance
/sys/bus/platform/devices/AMDI8001:01/vfio/vfioX/dev, right?

Thanks

Eric
>
> You can look at this for some general over engineered code to handle
> opening from a sysfs handle like above:
>
> https://github.com/linux-rdma/rdma-core/blob/master/util/open_cdev.c
>
> Jason
>

