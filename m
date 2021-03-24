Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE4A346FA7
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 03:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhCXCjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 22:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbhCXCjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 22:39:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DE5C061763
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 19:39:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id l76so1551743pga.6
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 19:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R0Z3hom4olFyC1rLHUMekzsab4PlziwAhqIDP1XJVa0=;
        b=go/+PYIDh9xeklhQ2aTi/PJbwvHLcfR+BK8sVV0y3MpcKyuwrw4T4MHD/TEdeQjAxP
         05kueFQjNzv7ZZunoDfaGj7sHg3UG/i4J+3bGJotgjZBQGCQTlMAZOovlI3aW6+46YjX
         amxV28ZObYjgpRSNYUQTpmteIkN4rb+zvu+rCiPpG+I/C7Ws9dbaupuSc9EUYiZ8ejeR
         UnCn4iQvOXl553SRUj8kOaBY70orTmMb9J6UbmmepAv4FPNcxvZN7KG/FYmrWWQaa/Y2
         4/UHdbMAIgSLFuqEktUa7VozhrBjO+x/Uvy5qUd1Q0SsQrYmgf/3GYG6k8qpLj/YQF09
         FeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R0Z3hom4olFyC1rLHUMekzsab4PlziwAhqIDP1XJVa0=;
        b=n1tl4UoWzfs6NpuboOchU3axIj16VZxG/VIxtTBcjA+v58mnhdDVW/LWUPQOoSL1HA
         7VHstyP4aehNiJFfnKSvU3qM0RhEo+/JijwqCzJKrPMAtqPMqM0rx+d+XwOHGv0yU2ui
         oU5ZlLuDcg0UvvBi+TDf4Zl/uUKfnpJAFHM/dZhtFOb42a0a0NeMZHVuWoaapCWQnxvn
         DI3ijSwIqdmbKPlvWjlt1CDl1gmeplwGzUfCph2NRhlyDCjyQhuxk6Lb8etWh+EdNlDW
         8c+ru/hYdSoh5CkTe1Ny7VmvvqXXf+LwIijaucIxc6KnBdHchnxESenL4Wsuew8CGP6j
         5grQ==
X-Gm-Message-State: AOAM530zHmEMGbS5ydFFPf82zOt29MLfq0pOD7u2mXmqSQ0JWup6FD3w
        CRmX9RIR/h7fdseeJEW7sSXfqA==
X-Google-Smtp-Source: ABdhPJwVO58KX4g0YNO5cPBeI7GxgivkaD5uif5IKIo3FZPRa3cfEWTT1TjOomDAHx92rPIjsfBlyw==
X-Received: by 2002:a62:7b83:0:b029:1f1:5ef3:b4d9 with SMTP id w125-20020a627b830000b02901f15ef3b4d9mr1101621pfc.65.1616553554190;
        Tue, 23 Mar 2021 19:39:14 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id fr23sm452105pjb.22.2021.03.23.19.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 19:39:13 -0700 (PDT)
Message-ID: <b65bf833-7167-e43f-717a-923dfa8bbc15@ozlabs.ru>
Date:   Wed, 24 Mar 2021 13:39:04 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor vfio_pci
 drivers
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
References: <20210319162033.GA18218@lst.de>
 <20210319162848.GZ2356281@nvidia.com> <20210319163449.GA19186@lst.de>
 <20210319113642.4a9b0be1@omen.home.shazbot.org>
 <20210319200749.GB2356281@nvidia.com>
 <20210319150809.31bcd292@omen.home.shazbot.org>
 <20210319225943.GH2356281@nvidia.com>
 <20210319224028.51b01435@x1.home.shazbot.org>
 <20210321125818.GM2356281@nvidia.com>
 <20210322104016.36eb3c1f@omen.home.shazbot.org>
 <20210323193213.GM2356281@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210323193213.GM2356281@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24/03/2021 06:32, Jason Gunthorpe wrote:

>>> For NVIDIA GPU Max checked internally and we saw it looks very much
>>> like how Intel GPU works. Only some PCI IDs trigger checking on the
>>> feature the firmware thing is linked to.
>>
>> And as Alexey noted, the table came up incomplete.  But also those same
>> devices exist on platforms where this extension is completely
>> irrelevant.
> 
> I understood he ment that NVIDI GPUs *without* NVLINK can exist, but
> the ID table we have here is supposed to be the NVLINK compatible
> ID's.


I also meant there are more (than in the proposed list)  GPUs with 
NVLink which will work on P9.


-- 
Alexey
