Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5826B3101C0
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 01:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhBEAnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhBEAnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:43:02 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AD2C0613D6
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:42:22 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o16so3340309pgg.5
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WvTZLay2ru5X1pURvRWUIq3TtHLZwRntRZn6qaViwlQ=;
        b=J1Wfrb3GLssyLXY/C8LcIoM/h21nzpupqwHZltgOy3tU7bbowlp757RI0ddVWDZdvk
         cmpp4ReGe8UUzpc2ed7t/4QlcbuxzSq607G0sQ49OwtWLG5p0h2rbjLSd5V2TvqOIXSL
         c2VbDSAprr75ca7lYxkgqDm1FY9stDnMYCwBjVAICxgFu4g7D16vadRpayLpRvDrxoBb
         MLjgiOmbRsXkDkVQC6KksvwrntoPgNBjpcC6DvHBDKe07QGfADBu/Lrc13wxEUoxH0Ez
         6hJpXDeH/5YmIKX+MdmO93iV/SGzU4fy7r9/SMpzkPkSqSfzBcJfVL6zzNf5F1zMd1Nh
         PsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WvTZLay2ru5X1pURvRWUIq3TtHLZwRntRZn6qaViwlQ=;
        b=s9H/qB1RiyJ4duTuTHtPEwOhP4bhK4VzCb7Wth4+8pPziA+eVa/o1fBs2zFmwDih8r
         vQdf6Mjxw+jTj+6A6lYbaYCU+hMtptB28+38yvwN+zNbkHVrVL4vE9m9eslQRdg2tvre
         vRAoidBbeDCqs0JxQhurc0Grkb6nKWXAy/I7nN9z7BQOU/PqHANg2SdYiAjLEvXxxAzr
         imX/mB3dKLnLq2ntzfs+2Arv4X2+lMtGiV7T5Xx3jW8hfm6P9yupnSbYUtHb4GvFwXhX
         jmsep7BmhyikDXOkcAV0tOSwKcfkQxZ0Lftt89V6T2Lff7kGTu18ceu8zUpX1UQByOVR
         sAuA==
X-Gm-Message-State: AOAM530us8ILWNP8nR1GKXAxrIEf8ELbOcV912cO8Kv7rZVuVTdcMr18
        EvDkbn7dCpL/8mwbAUTGpGXuBg==
X-Google-Smtp-Source: ABdhPJywrIsnhrRw8GIv65LUisn7U5OX526IqUq0LWcB0J2fwnnHD0V3ixACm5v/fD5n4xJfFBW4uQ==
X-Received: by 2002:a63:1110:: with SMTP id g16mr1589397pgl.357.1612485742467;
        Thu, 04 Feb 2021 16:42:22 -0800 (PST)
Received: from [192.168.10.153] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id q2sm6260643pfu.215.2021.02.04.16.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 16:42:21 -0800 (PST)
Message-ID: <d69a7f3c-f552-cd25-4e15-3e894f4eb15a@ozlabs.ru>
Date:   Fri, 5 Feb 2021 11:42:11 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Content-Language: en-US
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
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <806c138e-685c-0955-7c15-93cb1d4fe0d9@ozlabs.ru>
 <34be24e6-7f62-9908-c56d-9e469c3b6965@nvidia.com>
 <83ef0164-6291-c3d1-0ce5-2c9d6c97469e@ozlabs.ru>
 <20210204125123.GI4247@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210204125123.GI4247@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04/02/2021 23:51, Jason Gunthorpe wrote:
> On Thu, Feb 04, 2021 at 12:05:22PM +1100, Alexey Kardashevskiy wrote:
> 
>> It is system firmware (==bios) which puts stuff in the device tree. The
>> stuff is:
>> 1. emulated pci devices (custom pci bridges), one per nvlink, emulated by
>> the firmware, the driver is "ibmnpu" and it is a part on the nvidia driver;
>> these are basically config space proxies to the cpu's side of nvlink.
>> 2. interconnect information - which of 6 gpus nvlinks connected to which
>> nvlink on the cpu side, and memory ranges.
> 
> So what is this vfio_nvlink driver supposed to be bound to?
> 
> The "emulated pci devices"?

Yes.

> A real GPU function?

Yes.

> A real nvswitch function?

What do you mean by this exactly? The cpu side of nvlink is "emulated 
pci devices", the gpu side is not in pci space at all, the nvidia driver 
manages it via the gpu's mmio or/and cfg space.

> Something else?

Nope :)
In this new scheme which you are proposing it should be 2 drivers, I guess.

> 
> Jason
> 

-- 
Alexey
