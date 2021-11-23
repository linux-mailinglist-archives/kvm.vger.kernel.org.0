Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F12459CAF
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 08:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhKWHZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 02:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhKWHZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 02:25:58 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D124C061574;
        Mon, 22 Nov 2021 23:22:51 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so1396556pja.1;
        Mon, 22 Nov 2021 23:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:subject:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E152euvL8xFG6VtAVAYhcexuCCdzDHvA0/ZqwvZLKFw=;
        b=SO9zbuw+diZKTBr22YgM1YDinZbXMFBFDBKd3Lax/vvRG70Ooa3eUp7TS57a1wHgGQ
         9w8xYbZZ/TNLehbBL18OAuuI37+sB2rnLFMbaZSdCtjYcqRKz+79upKooeCW2LL8FN5y
         tb9N+mCo9CEV6iVDnSpRghWJFw8g6MpsccfzGOEwjasGJrqcCK0Keq/d1UIoPEEeq2+L
         qYz8gOilk3JUWzLgOEOpZalnY800qzwWNhioDWDmEXD8+Sj4QmyNXSfclYDQbG2JzqqQ
         8wQdEhLFOfl1wm+wAWrQlrUJ8CATRGiH1KX4Unud7EQGn2woAVVM5+eFd9sHAEsu1M/y
         sEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E152euvL8xFG6VtAVAYhcexuCCdzDHvA0/ZqwvZLKFw=;
        b=bl/OEuWGOw7zUf73btV8I9NN5VVa9xb2HYpfny18b1of4c4K1YPSDYi9OXGpzS5Tgf
         ZuyzVVu3QIdtoju4T/PpP5FkuywAIJVPwqwrK+YNHZ+3imCnbVk2Luge7jGS8WzQJJfj
         3uWRdzfjtCp79YRkzLnnDuikThLFokFpk3y8Lmm7jwhll98BlESagb+x8FnU4EXGygXa
         hzhPs9mx268SFPKkbqCK9rJTEMyQ9hN48UPKawz3kAkZzxx8R/GXUhRoNPD1qVY3nwss
         e7DgcAEkZQuPpYTkHFVbJUkm6e4gVhL33zIn+t1k4uMjRwsvgpLevrIpS2xKCR1u7RKZ
         6CDg==
X-Gm-Message-State: AOAM5325A4VhRHqxTyFO8Pm/dto4yo/SsZduwf98VAw1pT5D4TNZheJ4
        wbWr9z+Mnlo6aEmNuBuxOvw=
X-Google-Smtp-Source: ABdhPJyGKnaA+H7NrpBN2lqstj0eyHlhXCpNCfzFdZJJUs82VkCATzi6Dr3KMHEmUGe7tiJahjpy4Q==
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr388499pjb.142.1637652170654;
        Mon, 22 Nov 2021 23:22:50 -0800 (PST)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id p6sm198907pjb.48.2021.11.22.23.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 23:22:50 -0800 (PST)
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <20211123002042.GQ2105516@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
From:   Akira Yokosawa <akiyks@gmail.com>
Message-ID: <62d331f3-ce82-dbb0-bb94-7a2ce50d231c@gmail.com>
Date:   Tue, 23 Nov 2021 16:22:45 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211123002042.GQ2105516@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Nov 2021 20:20:42 -0400, Jason Gunthorpe wrote:
> On Mon, Nov 22, 2021 at 01:31:14PM -0700, Jonathan Corbet wrote:
>> Jason Gunthorpe <jgg@nvidia.com> writes:
>> 
>> > Provide some more complete documentation for the migration region's
>> > behavior, specifically focusing on the device_state bits and the whole
>> > system view from a VMM.
>> >
>> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> >  Documentation/driver-api/vfio.rst | 208 +++++++++++++++++++++++++++++-
>> >  1 file changed, 207 insertions(+), 1 deletion(-)
>> >
>> > Alex/Cornelia, here is the first draft of the requested documentation I promised
>> >
>> > We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.
>> >
>> > Our thinking is that NDMA would be implemented like this:
>> >
>> >    +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)
>> >
>> > And a .add_capability ops will be used to signal to userspace driver support:
>> >
>> >    +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6
>> >
>> > I've described DIRTY TRACKING as a seperate concept here. With the current
>> > uAPI this would be controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START, with our
>> > change in direction this would be per-tracker control, but no semantic change.
>> >
>> > Upon some agreement we'll include this patch in the next iteration of the mlx5 driver
>> > along with the NDMA bits.
>> >
>> > Thanks,
>> > Jason
>> >
>> > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
>> > index c663b6f978255b..b28c6fb89ee92f 100644
>> > +++ b/Documentation/driver-api/vfio.rst
>> > @@ -242,7 +242,213 @@ group and can access them as follows::
>> >  VFIO User API
>> >  
>> > -Please see include/linux/vfio.h for complete API documentation.
>> > +Please see include/uapi/linux/vfio.h for complete API documentation.
>> > +
>> > +-------------------------------------------------------------------------------
>> > +
>> > +VFIO migration driver API
>> > +-------------------------------------------------------------------------------
>> > +
>> > +VFIO drivers that support migration implement a migration control register
>> > +called device_state in the struct vfio_device_migration_info which is in its
>> > +VFIO_REGION_TYPE_MIGRATION region.
>> > +
>> > +The device_state triggers device action both when bits are set/cleared and
>> > +continuous behavior for each bit. For VMMs they can also control if the VCPUs in
>> > +a VM are executing (VCPU RUNNING) and if the IOMMU is logging DMAs (DIRTY
>> > +TRACKING). These two controls are not part of the device_state register, KVM
>> > +will be used to control the VCPU and VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the
>> > +container controls dirty tracking.
>> > +
>> > +Along with the device_state the migration driver provides a data window which
>> > +allows streaming migration data into or out of the device.
>> > +
>> > +A lot of flexibility is provided to userspace in how it operates these bits. The
>> > +reference flow for saving device state in a live migration, with all features:
>> > +
>> > +  RUNNING, VCPU_RUNNING
>> > +     Normal operating state

Hi.

So if you'd like definition lists of ReST, adding empty lines here

>> > +  RUNNING, DIRTY TRACKING, VCPU RUNNING>> > +     Log DMAs

and here should do the trick.

>> > +     Stream all memory

Ditto for the rest of the lists.

>> 
>> So I'd recommend actually building the docs and looking at the result;
>> this will not render the way you expect it to.  
> 
> Hum... It is really close to what I'd like, with the state names
> bolded and in something like an enumerated list
> 
> But on close inspection I see the text fragments have been assembled
> together. I'd probably try to make them into sentances than go to a
> literal block?

Please see ReST documentation for further info:

    https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#definition-lists

        Thanks, Akira
> 
> Thanks,
> Jason
