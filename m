Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE563BB5A0
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 05:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhGEDjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jul 2021 23:39:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhGEDjG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Jul 2021 23:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625456190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PNRaRFhxCfnbw9LvPZ80acVFOHmYfRIDpgg4dy1jTTw=;
        b=aNN86Z9WBpniD+7U7SY/V3S5RduvyFy/H0esuq2+YMvYI0WVUSpe69toHpxn9aqlaP+/qx
        wW4Tcw4m57vdC7OCW/1Ro/TnlcTHJtA3Zkjfy75pT0VTL5Abg4AcGzjMnkA2SEfg9tde8j
        TR8hAf7P1NodVXl2uaITDQ4PqU3FoDI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-nLFtmL8WMBu7hq2arWaLHg-1; Sun, 04 Jul 2021 23:36:28 -0400
X-MC-Unique: nLFtmL8WMBu7hq2arWaLHg-1
Received: by mail-pf1-f200.google.com with SMTP id t17-20020a62ea110000b029030fd2a30515so10842994pfh.20
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 20:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PNRaRFhxCfnbw9LvPZ80acVFOHmYfRIDpgg4dy1jTTw=;
        b=BK3dcC54IKV6G/2bXwVNJwrCTlVJ+7Okwaaimj3uTRuMCxyxfsZ0FFj3SX6Bbu1n45
         ly+VK7Co0mUdP3KNT026x/9r8QVMktRm1J4Es85mRvYIU/hWJMdJKPT9uSgJxIlcm20q
         8p2yYHiwJJAamYg0sp284R9diIvpIVy+ih/mlcmRgZqXIisslhOy7/6ur3R94+CXMiKR
         34zsfBsUVaJ+MdCGDefF/YbGFvBnjSSiogsYZCHA0HLRNe3ps9dBFZJM81AQDhq0dpE8
         JowFwBGhPIKVdzMB7382AB0eI3iDfGgVEO33/MWzQJIVCYOXiH3USRCAKQcWkGMHkMST
         eSvQ==
X-Gm-Message-State: AOAM530kafmyOemjr4kiy0GbQBaYj5f31NU4bx0N7TDW6dvtNXwO/9Fb
        fY6PU3dzVvDQ6pLg+aHEF/yLAhB4qhs4eYLcdTfoMlG9GOkH6nME3pJ/6aIXa3/Gs82XBsskh3C
        sE1HEVIeHJa6c
X-Received: by 2002:a62:b502:0:b029:2ec:a539:e29b with SMTP id y2-20020a62b5020000b02902eca539e29bmr12907029pfe.37.1625456187864;
        Sun, 04 Jul 2021 20:36:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU1ORvJgRFvEdcSUoAIpBbFs4fUYC6vc+xVQFL1exU5Y4g4vdf/8e25LPd+joB4XFQ5Hj+PQ==
X-Received: by 2002:a62:b502:0:b029:2ec:a539:e29b with SMTP id y2-20020a62b5020000b02902eca539e29bmr12907014pfe.37.1625456187646;
        Sun, 04 Jul 2021 20:36:27 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u13sm10509834pfi.54.2021.07.04.20.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 20:36:27 -0700 (PDT)
Subject: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
To:     Yongji Xie <xieyongji@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-11-xieyongji@bytedance.com>
 <YNSCH6l31zwPxBjL@stefanha-x1.localdomain>
 <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
 <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain>
 <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
 <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain>
 <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com>
Date:   Mon, 5 Jul 2021 11:36:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/7/4 下午5:49, Yongji Xie 写道:
>>> OK, I get you now. Since the VIRTIO specification says "Device
>>> configuration space is generally used for rarely-changing or
>>> initialization-time parameters". I assume the VDUSE_DEV_SET_CONFIG
>>> ioctl should not be called frequently.
>> The spec uses MUST and other terms to define the precise requirements.
>> Here the language (especially the word "generally") is weaker and means
>> there may be exceptions.
>>
>> Another type of access that doesn't work with the VDUSE_DEV_SET_CONFIG
>> approach is reads that have side-effects. For example, imagine a field
>> containing an error code if the device encounters a problem unrelated to
>> a specific virtqueue request. Reading from this field resets the error
>> code to 0, saving the driver an extra configuration space write access
>> and possibly race conditions. It isn't possible to implement those
>> semantics suing VDUSE_DEV_SET_CONFIG. It's another corner case, but it
>> makes me think that the interface does not allow full VIRTIO semantics.


Note that though you're correct, my understanding is that config space 
is not suitable for this kind of error propagating. And it would be very 
hard to implement such kind of semantic in some transports.  Virtqueue 
should be much better. As Yong Ji quoted, the config space is used for 
"rarely-changing or intialization-time parameters".


> Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. And to
> handle the message failure, I'm going to add a return value to
> virtio_config_ops.get() and virtio_cread_* API so that the error can
> be propagated to the virtio device driver. Then the virtio-blk device
> driver can be modified to handle that.
>
> Jason and Stefan, what do you think of this way?


I'd like to stick to the current assumption thich get_config won't fail. 
That is to say,

1) maintain a config in the kernel, make sure the config space read can 
always succeed
2) introduce an ioctl for the vduse usersapce to update the config space.
3) we can synchronize with the vduse userspace during set_config

Does this work?

Thanks


>

