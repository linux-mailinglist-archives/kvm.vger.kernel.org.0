Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACED3145E5
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 02:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhBIB4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 20:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhBIB4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 20:56:12 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2ABC061793
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 17:55:32 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t25so11484291pga.2
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 17:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H9vusQPG3gc7CnqBMhQxm3rI+btv7MJBpSMfnycyGPs=;
        b=vq4d+UIYc6Cl9yqExRIKp4B8DULlrvlymru63jPGQqkwtoeaoV/cspyWcruJlWW5Hf
         xdwyxeJLbCx2IztvzS27yIh4iv6MeooPbPgHDTZnMgoTuTofYfP7joBLTs1wt8RrHwWF
         TmYLCei3kNrowIBM2KN9gFL/7joKVYFHhs66bk3oxpRdfVz2uJtFSaJ5AeR9XCXVhpRr
         76DSm+PYZRsVJ000k9027035XLEnoP2A4N2dHb5/3dN3z4riLS1JFuRzprN0T+yrXn1v
         SwfTi8//hMaOSUHSKiT87BFRNTZKOn0Crl/ueBW+4cctLq0+OblxnzTsIHMxSIRSE9ir
         PxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H9vusQPG3gc7CnqBMhQxm3rI+btv7MJBpSMfnycyGPs=;
        b=W+luxhjoLk3l35QZ9CBn11zciMo4w5XmK++VSwkfM0E/gdBSOJYZiBtn/s2XrtJmLk
         YfZ0wxlraDANfdiVGL1AKdPgA2VB9zD6p3ZYDa/oxQ71a/HCA0auKtZift9K5MJbMkgk
         czhV99Cnx6HBOWOvxFi5y7F+Zzmps1DO2KJ7nP3Pk8mnyayciOfkaQ6Y3JELNaGXHbk7
         wYNpoXrgaaEgHPnJhQTIjr/omC5uwJXM99CkpBG8xyaVtKZifr51q/HzGG0aesyQliWG
         Smsv8u90MoCT5HrVJA0fWGeyQznUcsWMvTG3x0NDPwKUaY1/T4Dd2FpSAOcwQRXAaoG6
         FcmA==
X-Gm-Message-State: AOAM5316wh3PS2RehNz2fJNLIq6Oo1/6nibVSZycDQl2CL+tgIiI0xpC
        rxSnkVOMgP44jTSQojnhrLhKGg==
X-Google-Smtp-Source: ABdhPJwf881m9YNqJrjAFSQitrS2uf6hPc9RQ/zxIn3JTvQT2S3bQVI8HL4MpOfFXJFuWot327n1TA==
X-Received: by 2002:a63:d246:: with SMTP id t6mr19473913pgi.283.1612835731840;
        Mon, 08 Feb 2021 17:55:31 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id e23sm6180782pfd.145.2021.02.08.17.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 17:55:31 -0800 (PST)
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
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
 <d69a7f3c-f552-cd25-4e15-3e894f4eb15a@ozlabs.ru>
 <5bf0b8f7-38fb-bfdf-d093-d8d9b28b9679@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <63632419-ddf2-a6d9-d479-3a9548406018@ozlabs.ru>
Date:   Tue, 9 Feb 2021 12:55:15 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <5bf0b8f7-38fb-bfdf-d093-d8d9b28b9679@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/02/2021 23:44, Max Gurtovoy wrote:
> 
> On 2/5/2021 2:42 AM, Alexey Kardashevskiy wrote:
>>
>>
>> On 04/02/2021 23:51, Jason Gunthorpe wrote:
>>> On Thu, Feb 04, 2021 at 12:05:22PM +1100, Alexey Kardashevskiy wrote:
>>>
>>>> It is system firmware (==bios) which puts stuff in the device tree. The
>>>> stuff is:
>>>> 1. emulated pci devices (custom pci bridges), one per nvlink, 
>>>> emulated by
>>>> the firmware, the driver is "ibmnpu" and it is a part on the nvidia 
>>>> driver;
>>>> these are basically config space proxies to the cpu's side of nvlink.
>>>> 2. interconnect information - which of 6 gpus nvlinks connected to 
>>>> which
>>>> nvlink on the cpu side, and memory ranges.
>>>
>>> So what is this vfio_nvlink driver supposed to be bound to?
>>>
>>> The "emulated pci devices"?
>>
>> Yes.
>>
>>> A real GPU function?
>>
>> Yes.
>>
>>> A real nvswitch function?
>>
>> What do you mean by this exactly? The cpu side of nvlink is "emulated 
>> pci devices", the gpu side is not in pci space at all, the nvidia 
>> driver manages it via the gpu's mmio or/and cfg space.
>>
>>> Something else?
>>
>> Nope :)
>> In this new scheme which you are proposing it should be 2 drivers, I 
>> guess.
> 
> I see.
> 
> So should it be nvidia_vfio_pci.ko ? and it will do the NVLINK stuff in 
> case the class code matches and otherwise just work as simple vfio_pci 
> GPU ?

"nvidia_vfio_pci" would be too generic, sounds like it is for every 
nvidia on every platform. powernv_nvidia_vfio_pci.ko may be.

> What about the second driver ? should it be called ibmnpu_vfio_pci.ko ?

This will do.


> 
>>
>>>
>>> Jason
>>>
>>

-- 
Alexey
