Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3905E334047
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 15:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhCJOZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 09:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhCJOY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 09:24:56 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A960C061761
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 06:24:56 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t26so11505665pgv.3
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 06:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ia4RFpicq2fRuAPgXhAozb2Coa1dHuagLeIfRQj8pNQ=;
        b=MVAAnh5akGxaYjBBsx/wd8dd5mvwQkezHzzvAcU0d3DczYATYUbjWj9CxafssTwVdh
         REID571/jUKlKRb3gGXQIlmV97PHAQyskUXSEstmL5xmEQibOXsFipYb2XnIpvfU/T9o
         tw83tRACD2PPz3STkY9W0iyfEEMWvShwcUJhhroXzZPJa4iu4/uuJGifbuCZ1GdvUO/3
         qAEqnVpVVKcnT+Jgqa6JsFXIGmQzsk3jlQZSKNaw+CgA2tdZkeXuIGPyeTntOeYHuNQN
         5u99ovhof1usctC3jN4IBI++x0C5EDQWVXrvs09hQp3zP9acru0Y93MNL+ipZ8lBvpmm
         NiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ia4RFpicq2fRuAPgXhAozb2Coa1dHuagLeIfRQj8pNQ=;
        b=TvLWDShbfSD1xi4e2MNkjEG1aTkhpNIFbGRRYIe2P0Rwr3bPAyoLt8u4L+xMeSAWCJ
         JlX+Fb93wAgYEajUw/YE93d5gIQj28lq0+lB47w3LsHLad7CokdmhWzsejQ0W12C2nd3
         KGwLejsC0EQ2D+MkhW2ZNHab58mKtmTERFoROuIkNoOIPmYIsbPeaDNHqyHn01ldyrTh
         M1qa2bZNJf8URVED7MbbrQZ9hdWn5vKQvIvE/XTz1kzzeaA6Kfo4eN+ZAEruRWk1GWIx
         rP7FxssoIvgDUWFYJfXLs3OPRKQkepZUwp9R17WWxUsXPpvS1du8Wfi5lOGt0jUxWIkK
         IXvw==
X-Gm-Message-State: AOAM5314G6XoZbvQut9yRO8dZweT4FOqV3DbP9OtaZUa1V6c+SUIIsTM
        8ZhzbHM1TbZUpbxTXQlWbOm+5g==
X-Google-Smtp-Source: ABdhPJx/UEee10lhYSYD3qYfveLX/q/dS1C6S7LjHVDoMUNs4sdEMcr8xQaGtWjRqety3E84OglSew==
X-Received: by 2002:a63:5b5d:: with SMTP id l29mr2978518pgm.272.1615386295912;
        Wed, 10 Mar 2021 06:24:55 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id j3sm3099058pjf.36.2021.03.10.06.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 06:24:55 -0800 (PST)
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor vfio_pci
 drivers
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
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
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
Date:   Thu, 11 Mar 2021 01:24:47 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210310130246.GW2356281@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/03/2021 00:02, Jason Gunthorpe wrote:
> On Wed, Mar 10, 2021 at 02:57:57PM +0200, Max Gurtovoy wrote:
> 
>>>> +    .err_handler        = &vfio_pci_core_err_handlers,
>>>> +};
>>>> +
>>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev *pdev)
>>>> +{
>>>> +    if (pci_match_id(nvlink2gpu_vfio_pci_driver.id_table, pdev))
>>>> +        return &nvlink2gpu_vfio_pci_driver;
>>>
>>>
>>> Why do we need matching PCI ids here instead of looking at the FDT which
>>> will work better?
>>
>> what is FDT ? any is it better to use it instead of match_id ?
> 
> This is emulating the device_driver match for the pci_driver.


No it is not, it is a device tree info which lets to skip the linux PCI 
discovery part (the firmware does it anyway) but it tells nothing about 
which drivers to bind.


> I don't think we can combine FDT matching with pci_driver, can we?

It is a c function calling another c function, all within vfio-pci, this 
is not called by the generic pci code.



-- 
Alexey
