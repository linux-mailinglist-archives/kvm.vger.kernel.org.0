Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865733132B1
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 13:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhBHMpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 07:45:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3485 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhBHMpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 07:45:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602132440001>; Mon, 08 Feb 2021 04:44:52 -0800
Received: from [172.27.1.173] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 12:44:46 +0000
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>
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
 <d69a7f3c-f552-cd25-4e15-3e894f4eb15a@ozlabs.ru>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <5bf0b8f7-38fb-bfdf-d093-d8d9b28b9679@nvidia.com>
Date:   Mon, 8 Feb 2021 14:44:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d69a7f3c-f552-cd25-4e15-3e894f4eb15a@ozlabs.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612788292; bh=+JrPIiWybx2rgSx+ma5GOztR5YPtENuEAC7IyP6QYiQ=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=mOxLdd2FAPZCQMEGx7pVfF0ZFPK0Id0n7fGaNKe8iR8/YbtntxI985Q6lr7hn/uZf
         uXaoZJOlRhlFLl7/c4sW5YpPj3+9dGx5P1IRLDY+bkA+YF3lzI4+7o7DZBp5JwRE1k
         +FTilFUDsMMnjaTbWTX2bo4cwD6AXODBmrNnCY53P/1kZu+1cIM/NUTLqX9q2/sh5G
         LIdtNUIkBjQSuef/8GE5f7Si4NEdTU8x6JACeg120x6luYRA/0/9t3/L1GUI2rtR47
         QQyHxK/TbS5pnB5lSxTGi6WNwpeWVuxtlqahhCmbvuL+bpsrJhCr6EyNl/RgOlxM4c
         ugSyl9hoRmuMA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/5/2021 2:42 AM, Alexey Kardashevskiy wrote:
>
>
> On 04/02/2021 23:51, Jason Gunthorpe wrote:
>> On Thu, Feb 04, 2021 at 12:05:22PM +1100, Alexey Kardashevskiy wrote:
>>
>>> It is system firmware (==bios) which puts stuff in the device tree. The
>>> stuff is:
>>> 1. emulated pci devices (custom pci bridges), one per nvlink, 
>>> emulated by
>>> the firmware, the driver is "ibmnpu" and it is a part on the nvidia 
>>> driver;
>>> these are basically config space proxies to the cpu's side of nvlink.
>>> 2. interconnect information - which of 6 gpus nvlinks connected to 
>>> which
>>> nvlink on the cpu side, and memory ranges.
>>
>> So what is this vfio_nvlink driver supposed to be bound to?
>>
>> The "emulated pci devices"?
>
> Yes.
>
>> A real GPU function?
>
> Yes.
>
>> A real nvswitch function?
>
> What do you mean by this exactly? The cpu side of nvlink is "emulated 
> pci devices", the gpu side is not in pci space at all, the nvidia 
> driver manages it via the gpu's mmio or/and cfg space.
>
>> Something else?
>
> Nope :)
> In this new scheme which you are proposing it should be 2 drivers, I 
> guess.

I see.

So should it be nvidia_vfio_pci.ko ? and it will do the NVLINK stuff in 
case the class code matches and otherwise just work as simple vfio_pci GPU ?

What about the second driver ? should it be called ibmnpu_vfio_pci.ko ?

>
>>
>> Jason
>>
>
