Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0AA3369DB
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 02:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhCKBnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 20:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhCKBnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 20:43:12 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2EDC061574
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 17:43:12 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id t26so12620425pgv.3
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 17:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MWojlJbUjd8zeoqWw9mfU3jMWrIYqMEd6vbJ5jtrUws=;
        b=Sa9/Vp7ANEMp+nq3kdNHz5hLIhyAAfUqRrv1U71IBC4MZ/QwYxf7GA9TfF/vIleoGD
         LG8ZdcTnkWi2Ka8G05Q7H2ZoN5R/0JvxjDcdf0DAXG6U4b0v0u1RzaFZhTvGjvNIjfM3
         qtcB1HniugfDx0NsU9tGro1jViIiR8g0aBIjQlQng4CtvI2uwqfqlTCwryXZZqhW/cPE
         Dm5HnCFbg2UjhbaxBUvhOp+d+SjnHLvSno2XKApGMKeJ/JXyU6i4hieRNdF+PvxwZYLn
         /uziyQZs2tSbiWGTLsonMt00StcmiDExuqM1O7g5RN75xk8KPmpS1CBXJJlWEvkOPkGN
         gFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MWojlJbUjd8zeoqWw9mfU3jMWrIYqMEd6vbJ5jtrUws=;
        b=uVBsa12gX13RHrGW/keM4pI8N+4HjLd/DDN8TPfFj4pG8Ee/RXCLs7Axxrsw8bt/gx
         m/CWmBKPXTzWNRpvWX0Z8Nmw62glF7ElBjkPlTYVgczqDPxnca0NcrWGHvrimuvTuIz1
         gqKMiUIRlusMHrww/ZDa84LULEjSLkwO+di/RLRYoU0Vh5EbDrIvoWEfYRQ4niMam8nt
         cV1qCJFveMHAVYvazhygDAeq3NRT4Br0EVOnT1EyP2uZUH01/qwh/0zJhOucVOIkgJtw
         0jRSyUtevRJbzGSYRjzGxKr7RUzLBOZOkV19roTuqXNchT+3htWuoxTBNI6eOJV89qYE
         qJfg==
X-Gm-Message-State: AOAM531/Xm2aoQbj+VRKRUtMH2BrWBgtBjiJO1wiVdQuC4hcvpGuqtUb
        VGbC/tTLjmKyUcLNoYDBpA4x8Q==
X-Google-Smtp-Source: ABdhPJzCjrEDF22HR8BBzOTqHG5psBpFNzWPU//hpBEJ39p1CwsucIYBG8PUZdW8cdI4LaaOtKux6g==
X-Received: by 2002:a63:689:: with SMTP id 131mr5200828pgg.416.1615426991602;
        Wed, 10 Mar 2021 17:43:11 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id s11sm641511pfu.69.2021.03.10.17.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 17:43:11 -0800 (PST)
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor vfio_pci
 drivers
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, hch@lst.de
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210310130246.GW2356281@nvidia.com>
 <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
 <20210310194002.GD2356281@nvidia.com>
 <7f0310db-a8e3-4045-c83a-11111767a22f@ozlabs.ru>
 <20210311013443.GH2356281@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <d862adf9-6fe7-a99e-6c14-8413aae70cd4@ozlabs.ru>
Date:   Thu, 11 Mar 2021 12:42:56 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210311013443.GH2356281@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/03/2021 12:34, Jason Gunthorpe wrote:
> On Thu, Mar 11, 2021 at 12:20:33PM +1100, Alexey Kardashevskiy wrote:
> 
>>> It is supposed to match exactly the same match table as the pci_driver
>>> above. We *don't* want different behavior from what the standrd PCI
>>> driver matcher will do.
>>
>> This is not a standard PCI driver though
> 
> It is now, that is what this patch makes it into. This is why it now
> has a struct pci_driver.
> 
>> and the main vfio-pci won't have a
>> list to match ever.
> 
> ?? vfio-pci uses driver_override or new_id to manage its match list


Exactly, no list to update.


>> IBM NPU PCI id is unlikely to change ever but NVIDIA keeps making
>> new devices which work in those P9 boxes, are you going to keep
>> adding those ids to nvlink2gpu_vfio_pci_table?
> 
> Certainly, as needed. PCI list updates is normal for the kernel.
> 
>> btw can the id list have only vendor ids and not have device ids?
> 
> The PCI matcher is quite flexable, see the other patch from Max for
> the igd


ah cool, do this for NVIDIA GPUs then please, I just discovered another 
P9 system sold with NVIDIA T4s which is not in your list.


> But best practice is to be as narrow as possible as I hope this will
> eventually impact module autoloading and other details.

The amount of device specific knowledge is too little to tie it up to 
device ids, it is a generic PCI driver with quirks. We do not have a 
separate drivers for the hardware which requires quirks.

And how do you hope this should impact autoloading?



-- 
Alexey
