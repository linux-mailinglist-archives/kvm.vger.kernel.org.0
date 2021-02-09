Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2603145DB
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 02:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhBIBwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 20:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhBIBwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 20:52:49 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AF3C061788
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 17:52:10 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id g15so11456802pgu.9
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 17:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2srAivJsR8ZUb2Of5OZio4LXVkIXxX89sGFnynDTxFQ=;
        b=mzW8QUkCHDb8txTgts6/c250bc5psaLG8vkJij6TG+bDHh0ltf2ZB555hvnxiZ4Tp3
         NuFa51SYv9e+VDlKbK4QmbF+N1lKEnNJKrDVP4HthOy0YotW3zNUWHHVVl7Y7u1FY7dV
         YgOI+jQ00Zrc4EvirXMlD3AU4kTzg9UbS5g3B/KPRE3gFVUEBSS5R2YAOe8lAd6ypZE2
         NVx7M2gomjIftGUt0NTrwWOkYGGYdvAkltGSkx74W1D4W6vq6y9PRRAp1z+xMHSAraeQ
         Yt+cYm6x0U0hk/Fxu9/5DA3uVm1xgFyMinOR0nsgAeu8MjxnYtu+z8ulhiVo8wBTkp6b
         BgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2srAivJsR8ZUb2Of5OZio4LXVkIXxX89sGFnynDTxFQ=;
        b=s75jQ8pY/IMoEIY+zahsjEi5hxGVOVA+eYTbPOJKUuE/EBrGQYKoiqiIso9Wd2xdf6
         WlJQcc9P4v8yPSDajUtfZVgc2D7sWY/8PVP+UBiT8eKh2KAiqqfAB/Ws8KBro5NRFph5
         5it4YgKI141kv6bLDjTOeGmLjAlYNXuqa+m7jdRRIFMnhboStO5NOqqjKAt3sBZ7E4AP
         KsGst1dqvyhDwYhej+2GMMnAQCJ/LPRP8dnbbBrJ6Uk2nNu8f2eZPU8RHdkMigbniltz
         eeNvz+2mUUP7AYvSLZYFiTUy70D9Aa5QnapHL2cuxNi+FW4s5NQkiFGfr55lZT5VsXHf
         Mapw==
X-Gm-Message-State: AOAM533rtwzzmMr7Zu3Kk5UKBQYSOA2XluGLxS8roOa+6fVEciaf0NN1
        FGAqJ338VOX8ViokTiV6cOgxeA==
X-Google-Smtp-Source: ABdhPJwZftY+JfG4/ltpdGEm0VNS1bpBKVoGIJbWBMNCcNrjv07btIltmE0V7Uk4wPBBx9gbw16M0A==
X-Received: by 2002:a62:1890:0:b029:1dc:1b2e:e07a with SMTP id 138-20020a6218900000b02901dc1b2ee07amr9121622pfy.14.1612835529512;
        Mon, 08 Feb 2021 17:52:09 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id nl12sm761085pjb.2.2021.02.08.17.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 17:52:08 -0800 (PST)
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, gmataev@nvidia.com,
        cjia@nvidia.com, yishaih@nvidia.com
References: <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <806c138e-685c-0955-7c15-93cb1d4fe0d9@ozlabs.ru>
 <34be24e6-7f62-9908-c56d-9e469c3b6965@nvidia.com>
 <83ef0164-6291-c3d1-0ce5-2c9d6c97469e@ozlabs.ru>
 <20210204125123.GI4247@nvidia.com>
 <d69a7f3c-f552-cd25-4e15-3e894f4eb15a@ozlabs.ru>
 <20210208181313.GH4247@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <7c5bf697-86a6-5147-061c-7a7c38b6897c@ozlabs.ru>
Date:   Tue, 9 Feb 2021 12:51:59 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210208181313.GH4247@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/02/2021 05:13, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 11:42:11AM +1100, Alexey Kardashevskiy wrote:
>>> A real nvswitch function?
>>
>> What do you mean by this exactly? The cpu side of nvlink is "emulated pci
>> devices", the gpu side is not in pci space at all, the nvidia driver manages
>> it via the gpu's mmio or/and cfg space.
> 
> Some versions of the nvswitch chip have a PCI-E link too, that is what
> I though this was all about when I first saw it.

> So, it is really a special set of functions for NVIDIA GPU device
> assignment only applicable to P9 systems, much like IGD is for Intel
> on x86.



These GPUs are not P9 specific and they all have both PCIe and NVLink2 
links. The special part is that some nvlinks are between P9 and GPU and 
the rest are between GPUs, everywhere else (x86, may be ARM) the nvlinks 
are used between GPUs but even there I do not think the nvlink logic is 
presented to the host in the PCI space.



-- 
Alexey
