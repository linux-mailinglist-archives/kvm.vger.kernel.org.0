Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D8C3A230A
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 06:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhFJEF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 00:05:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhFJEF4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 00:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623297840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=19S4V0oFIhYTEmjCi3wnOG6CCDqJn4GFX2fH4afLaKA=;
        b=P7OmA0kTxagkieW5Zt9yOQsoDKq2Z7bhg5HmpZgCxhtJrbAUVNhPnWQW7B191ray7uxKQe
        beb6aY6du44gIJYFxQhHUZ5vfTCfUqLVD15758itaL+pC7RBkk6w3raxyo8QzX+njunR4c
        1z1O/m3kt/hGBCIp37wpyKO1128d2ls=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-P12ckxufP_-hVTXKaJ1Krw-1; Thu, 10 Jun 2021 00:03:58 -0400
X-MC-Unique: P12ckxufP_-hVTXKaJ1Krw-1
Received: by mail-pj1-f69.google.com with SMTP id e12-20020a17090a630cb029016de1736f41so3025799pjj.3
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 21:03:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=19S4V0oFIhYTEmjCi3wnOG6CCDqJn4GFX2fH4afLaKA=;
        b=p+HBnkWlWG3YUcOdNWa3tA71yf4PHxLZtl21u2ilozeblSjGsqOg3A8XM+pl8AuyIy
         GyMt7V6NV62P0CtIl3GNEZv3dOv/UmXozxUZ33LWQKADYp0GsT6eKpQhst8v3FzBxOeg
         NZmanFRx07UAafjs/DYRkH5dX3GjTOihEcr67cLrQ6wG4o5bZ1/tTxVuZIOoXZn76k/8
         l2lJQxOfPKVQ0GBkwtHtfrFYQpylZdTu/I+IeQW0R8mwHAbKSMSv+1KnJVVVnna6MjdW
         vViXqqmKpj5zJnvstoNfqaMahZnwWz9vYxRvk1OCGal/eu1pnsvfXVGfVGJ4ZtnshWF8
         GM6g==
X-Gm-Message-State: AOAM530o7iXyRcd7sgo1vWidkw6N9LMCq33SybKmXfh6RLIRTGbL4pd9
        H/w7HjVGJq/HHlUlIIPS3jW2VvlMwc+e+aXFnZGcRahrL+ankMPx4HGYAQC3pOWgaq299fzQKTM
        3rxqcxjxAmOOq
X-Received: by 2002:a63:3fc6:: with SMTP id m189mr2985880pga.239.1623297837854;
        Wed, 09 Jun 2021 21:03:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVMH4GRlTNZgCb4SGiAzZbg0vm86YmdxLIXUVjkXzrgfxl13LW9u+XyYW03LglmHfkfEaonA==
X-Received: by 2002:a63:3fc6:: with SMTP id m189mr2985870pga.239.1623297837705;
        Wed, 09 Jun 2021 21:03:57 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j16sm1136234pgh.69.2021.06.09.21.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 21:03:57 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
From:   Jason Wang <jasowang@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
References: <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
 <c84787ec-9d8f-3198-e800-fe0dc8eb53c7@redhat.com>
 <20210608132039.GG1002214@nvidia.com>
 <f4d70f28-4bd6-5315-d7c7-0a509e4f1d1d@redhat.com>
Message-ID: <3af22408-f0f1-7e04-48ab-852619d28ef6@redhat.com>
Date:   Thu, 10 Jun 2021 12:03:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f4d70f28-4bd6-5315-d7c7-0a509e4f1d1d@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/10 上午10:00, Jason Wang 写道:
>
> 在 2021/6/8 下午9:20, Jason Gunthorpe 写道:
>> On Tue, Jun 08, 2021 at 09:10:42AM +0800, Jason Wang wrote:
>>
>>> Well, this sounds like a re-invention of io_uring which has already 
>>> worked
>>> for multifds.
>> How so? io_uring is about sending work to the kernel, not getting
>> structued events back?
>
>
> Actually it can. Userspace can poll multiple fds via preparing 
> multiple sqes with IORING_OP_ADD flag.


IORING_OP_POLL_ADD actually.

Thanks


>
>
>>
>> It is more like one of the perf rings
>
>
> This means another ring and we need introduce ioctl() to add or remove 
> ioasids from the poll. And it still need a kind of fallback like a 
> list if the ring is full.
>
> Thanks
>
>
>>
>> Jason
>>

