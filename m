Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599073B6D5D
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 06:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhF2EPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 00:15:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhF2EPi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 00:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624939992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7N6S5aXlTsxjRnLUAwuT1GGB2dsJH/gvDpQ3UzIqM0M=;
        b=SzUh/i8W2tjOYdKVVA/eEfddfMy1StTwJiTZYSj8HAtZ68CiWJ874FtLqq+cdtz+G0LEXY
        vkI1Z7GBb5PCxfQwmWZ6uZGDH2stkTWWqiZT4Su5U3MaKm7lK7PwFtdxziuC9eW84yu2Z9
        hfBlLce79yj+OthZpYL/4Tk8tdmefIw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-IV61naWbPgeUQ8bjzXQ3ng-1; Tue, 29 Jun 2021 00:13:08 -0400
X-MC-Unique: IV61naWbPgeUQ8bjzXQ3ng-1
Received: by mail-pg1-f197.google.com with SMTP id k9-20020a63d1090000b029021091ebb84cso13368727pgg.3
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 21:13:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7N6S5aXlTsxjRnLUAwuT1GGB2dsJH/gvDpQ3UzIqM0M=;
        b=ccN0aRsomzYo1IAdxg/r70ZQ1agc5qhDYkUXCMwHFUT1mxm+ihH9vfKkhKIGzf/Fnn
         UCymzuQk5yQYiDjuKTa3ENdpdC5GG5p0eN3mhK8zneo4D4Jb56B95SlHFgX6Q9GnA99L
         D2P5bS+66CyPCZ39fqRpm5+sU/anHrQc8wEr8oTMmTfiQvlVky/9JxzbZYCqKyjjLdGd
         mBFK5MS6cnKJYmOji6oCdL97orsg3OHzz+SdFG826LW2ncEqKP+EkkC/5HUFjGZ0On+w
         YnOh8l9YnkQ+4XzlJCeGZcxLk/cHBS7zYVZU2NNYbgJLFL/6JV14IAVbz8lyypdw8WOw
         Co5Q==
X-Gm-Message-State: AOAM530F1WyiEAQvfq/8AapNfhWlO0yhdOiOPvj7xrV1XGFGAJ5SLG/1
        XicKZqiaDauH3G2k0HyeaV5165YbJ+6oiVRSw3S+RNQr+s+sXmm5EbhhDpWx7KRcCFx4Q+JUiII
        cbovRRo+7U6x4
X-Received: by 2002:a65:478d:: with SMTP id e13mr26587069pgs.37.1624939987921;
        Mon, 28 Jun 2021 21:13:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTnV+jCJcWth5Gh1PanbNwyDV44mMvsm0eLCzSFKGOg12/3H6rwksZzo35n3QJumwiuRcZHQ==
X-Received: by 2002:a65:478d:: with SMTP id e13mr26587053pgs.37.1624939987713;
        Mon, 28 Jun 2021 21:13:07 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k13sm1525904pgh.82.2021.06.28.21.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 21:13:07 -0700 (PDT)
Subject: Re: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
To:     Yongji Xie <elohimes@gmail.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, songmuchun@bytedance.com,
        linux-fsdevel@vger.kernel.org
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210628103309.GA205554@storage2.sh.intel.com>
 <CAONzpcbjr2zKOAQrWa46Tv=oR1fYkcKLcqqm_tSgO7RkU20yBA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d5321870-ef29-48e2-fdf6-32d99a5fa3b9@redhat.com>
Date:   Tue, 29 Jun 2021 12:12:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAONzpcbjr2zKOAQrWa46Tv=oR1fYkcKLcqqm_tSgO7RkU20yBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/28 下午6:32, Yongji Xie 写道:
>> The large barrier is bounce-buffer mapping: SPDK requires hugepages
>> for NVMe over PCIe and RDMA, so take some preallcoated hugepages to
>> map as bounce buffer is necessary. Or it's hard to avoid an extra
>> memcpy from bounce-buffer to hugepage.
>> If you can add an option to map hugepages as bounce-buffer,
>> then SPDK could also be a potential user of vduse.
>>
> I think we can support registering user space memory for bounce-buffer
> use like XDP does. But this needs to pin the pages, so I didn't
> consider it in this initial version.
>

Note that userspace should be unaware of the existence of the bounce buffer.

So we need to think carefully of mmap() vs umem registering.

Thanks

