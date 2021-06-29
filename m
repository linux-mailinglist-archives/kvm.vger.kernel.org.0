Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEE13B6EC9
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 09:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhF2Hga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 03:36:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232297AbhF2Hg3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 03:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624952042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X7aRa/ari9ndRrZW6yGfSw3dQvpOEYQN4vmyoY/ZeNU=;
        b=QDgeywfxmxZQEo7IQCYNxePBlSYwC86akw8fgAgO/QLSDydrDl2sqmap5r/QOLm97tjKTA
        T8xcDv1m+hsijuTv9FQpWP5yQqNGNAwvXE77vE1nYKL1yrHPgYMGAChsipVyqPyaavNvU0
        nX/PIZXaxUNcZNzrdh8syfJGh1brgIc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-34dQuLhWOzezo0ONZ0pzxA-1; Tue, 29 Jun 2021 03:34:01 -0400
X-MC-Unique: 34dQuLhWOzezo0ONZ0pzxA-1
Received: by mail-pj1-f72.google.com with SMTP id bx13-20020a17090af48db029016fb6fa83beso1246772pjb.3
        for <kvm@vger.kernel.org>; Tue, 29 Jun 2021 00:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=X7aRa/ari9ndRrZW6yGfSw3dQvpOEYQN4vmyoY/ZeNU=;
        b=MTYFw+fZzIZQ9ssWfoQ2TbPyOS2DOA8Fzl4s68mt2PnuShwlD/egTaisSfhSmm1Gzj
         2X6DhNxKncgIpiffxFADygkwlHwuV3LsMqv9t2pmdlueTq93g4lH5qrZu4uHRXaWYJ/X
         ni8hUjJd69KjPRGaqzmLQWrlcwcAs5L8R1URake7ajhElVe24cRO4lcraqNy8YcCOXqy
         GKFq++OtbK7P4jxEQsizTUu7XskwIqRnOQ5CmT26DYBYs/Pa9CWYdk/zBzewkvHcYs21
         tlpRqkAnR3LyWeMd8TXPovEv+a1UaNVksxhe5inTJZUMHueLUPFwlSY4RfCcPKkk5Hio
         TQFw==
X-Gm-Message-State: AOAM53389BRSdJZ+/OjBSLcBhHleZTfFgmoxrg+IWU+JQ6i7jJooxk75
        xQm8vDIHV1kOsSRyYuMQ/p010cDlOpP3QcGkqanxHHAkvCEsY0FXjwi2lHLHzpEbvbolb8Zca/I
        ZBoW1EhWFnOoS
X-Received: by 2002:a63:43c4:: with SMTP id q187mr12256866pga.172.1624952039965;
        Tue, 29 Jun 2021 00:33:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7prtHQtaiL3wMVzoCQQ1u9za913WVNoujdQYVZqZ/2wS5MelCYOe6dyArhR9IgMLsZIzYyg==
X-Received: by 2002:a63:43c4:: with SMTP id q187mr12256834pga.172.1624952039684;
        Tue, 29 Jun 2021 00:33:59 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c2sm17127924pjv.10.2021.06.29.00.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 00:33:59 -0700 (PDT)
Subject: Re: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Yongji Xie <elohimes@gmail.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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
        Greg KH <gregkh@linuxfoundation.org>,
        kvm <kvm@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        iommu@lists.linux-foundation.org, songmuchun@bytedance.com,
        linux-fsdevel@vger.kernel.org
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210628103309.GA205554@storage2.sh.intel.com>
 <CAONzpcbjr2zKOAQrWa46Tv=oR1fYkcKLcqqm_tSgO7RkU20yBA@mail.gmail.com>
 <d5321870-ef29-48e2-fdf6-32d99a5fa3b9@redhat.com>
 <CACycT3vVhNdhtyohKJQuMXTic5m6jDjEfjzbzvp=2FJgwup8mg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <90e30d9e-5709-2a0b-0449-858eea9dfec9@redhat.com>
Date:   Tue, 29 Jun 2021 15:33:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vVhNdhtyohKJQuMXTic5m6jDjEfjzbzvp=2FJgwup8mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/29 下午2:40, Yongji Xie 写道:
> On Tue, Jun 29, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/28 下午6:32, Yongji Xie 写道:
>>>> The large barrier is bounce-buffer mapping: SPDK requires hugepages
>>>> for NVMe over PCIe and RDMA, so take some preallcoated hugepages to
>>>> map as bounce buffer is necessary. Or it's hard to avoid an extra
>>>> memcpy from bounce-buffer to hugepage.
>>>> If you can add an option to map hugepages as bounce-buffer,
>>>> then SPDK could also be a potential user of vduse.
>>>>
>>> I think we can support registering user space memory for bounce-buffer
>>> use like XDP does. But this needs to pin the pages, so I didn't
>>> consider it in this initial version.
>>>
>> Note that userspace should be unaware of the existence of the bounce buffer.
>>
> If so, it might be hard to use umem. Because we can't use umem for
> coherent mapping which needs physical address contiguous space.
>
> Thanks,
> Yongji


We probably can use umem for memory other than the virtqueue (still via 
mmap()).

Thanks


