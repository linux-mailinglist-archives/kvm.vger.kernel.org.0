Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3335336984
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 02:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhCKBUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 20:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhCKBUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 20:20:43 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22FFC061760
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 17:20:42 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p21so12591691pgl.12
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 17:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e05gNqFmEe1I9vJPFbv/SBKS9J6IN2bhiLFxjOWA5Fw=;
        b=eDRfPDA6YWI7zoh24eHzQJzr78ortggEi1AHgvYtrnYCkxmk5PSyRHlgrf3YkgNxv4
         NT/0UAhbi8fJmsjFHVqowR3sFslQ0K3+0K8LjLzqeJs40m/2xPJfPNYODX3PMrIsrEJX
         RDWOpMCPiaCA/eNlX/75paoBX4JCXzvdWrWhjkrVwHz2P+b03TP4LbeyGVExZtjnojf9
         UYU00AxdnKYgctlyr/D5fctCWAg+qMVAAdW7DY0Ltx5lJQ1XqcAhsTGs5d5YijBZ0Cff
         lKIjUm3HrWyC9jMNeZBERZse/a4Ntt1OF6BOooH9M6OW+1eJwhVNaSeglDZmaqHkkqZA
         onLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e05gNqFmEe1I9vJPFbv/SBKS9J6IN2bhiLFxjOWA5Fw=;
        b=h7R93nJri8Kh2tokw9HUiBPWj8z7mhZlXXL/z3JxmQugrvim6sOyk7d2VUEFLROGoN
         t01wYPtzse6TYA4nKIm4E/AU859CJgE1Q+wZNVC4rs2taYl/CJkb/OJO46zEKiNCxUqU
         VSZyvUMkshPyOMByC3tJuQ3LfdbqXK+lmZaBiY31WwJV/PEMB4g+esvS/FlCWiBvYIbw
         sRINHhzzy9xZS2COC8299nw3DIIM3jJ4wtzmtVWCVYUdbLETYAhB8hBSwCZ0kNKdEzvV
         dqMKuYVeNzlUwpgvo5W44/7lncr6+thN0TCT8p/iA9EWUoqf294IwsSo2+1RbkLhQ+dl
         UleQ==
X-Gm-Message-State: AOAM532jWugjKFWXxRC7ZfUznwQBLfWlcDijvPREpezrWUgpAd8nOpvn
        vxQvC7Ms0kWeK+Y6auH8ltGbSw==
X-Google-Smtp-Source: ABdhPJx0VDBZ7VTI7yH5PnrUyDBS4jmSPdJDctDRFMlePYS5ZGmao3zjdhZdmlcZ3uU8uc4P5FgodA==
X-Received: by 2002:a62:38d7:0:b029:1fb:2382:57b0 with SMTP id f206-20020a6238d70000b02901fb238257b0mr5441431pfa.10.1615425642503;
        Wed, 10 Mar 2021 17:20:42 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id 138sm631493pfv.192.2021.03.10.17.20.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 17:20:42 -0800 (PST)
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
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <7f0310db-a8e3-4045-c83a-11111767a22f@ozlabs.ru>
Date:   Thu, 11 Mar 2021 12:20:33 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210310194002.GD2356281@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/03/2021 06:40, Jason Gunthorpe wrote:
> On Thu, Mar 11, 2021 at 01:24:47AM +1100, Alexey Kardashevskiy wrote:
>>
>>
>> On 11/03/2021 00:02, Jason Gunthorpe wrote:
>>> On Wed, Mar 10, 2021 at 02:57:57PM +0200, Max Gurtovoy wrote:
>>>
>>>>>> +    .err_handler        = &vfio_pci_core_err_handlers,
>>>>>> +};
>>>>>> +
>>>>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>>>>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev *pdev)
>>>>>> +{
>>>>>> +    if (pci_match_id(nvlink2gpu_vfio_pci_driver.id_table, pdev))
>>>>>> +        return &nvlink2gpu_vfio_pci_driver;
>>>>>
>>>>>
>>>>> Why do we need matching PCI ids here instead of looking at the FDT which
>>>>> will work better?
>>>>
>>>> what is FDT ? any is it better to use it instead of match_id ?
>>>
>>> This is emulating the device_driver match for the pci_driver.
>>
>> No it is not, it is a device tree info which lets to skip the linux PCI
>> discovery part (the firmware does it anyway) but it tells nothing about
>> which drivers to bind.
> 
> I mean get_nvlink2gpu_vfio_pci_driver() is emulating the PCI match.
> 
> Max added a pci driver for NPU here:
> 
> +static struct pci_driver npu2_vfio_pci_driver = {
> +	.name			= "npu2-vfio-pci",
> +	.id_table		= npu2_vfio_pci_table,
> +	.probe			= npu2_vfio_pci_probe,
> 
> 
> new userspace should use driver_override with "npu-vfio-pci" as the
> string not "vfio-pci"
> 
> The point of the get_npu2_vfio_pci_driver() is only optional
> compatibility to redirect old userspace using "vfio-pci" in the
> driver_override to the now split driver code so userspace doesn't see
> any change in behavior.
> 
> If we don't do this then the vfio-pci driver override will disable the
> npu2 special stuff, since Max took it all out of vfio-pci's
> pci_driver.
> 
> It is supposed to match exactly the same match table as the pci_driver
> above. We *don't* want different behavior from what the standrd PCI
> driver matcher will do.


This is not a standard PCI driver though and the main vfio-pci won't 
have a list to match ever. IBM NPU PCI id is unlikely to change ever but 
NVIDIA keeps making new devices which work in those P9 boxes, are you 
going to keep adding those ids to nvlink2gpu_vfio_pci_table? btw can the 
id list have only vendor ids and not have device ids?


> Since we don't have any way to mix in FDT discovery to the standard
> PCI driver match it will still attach the npu driver but not enable
> any special support. This seems OK.



-- 
Alexey
