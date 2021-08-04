Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5023DFCEB
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbhHDIdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:33:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236296AbhHDIdH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 04:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628065975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Mht9KhrSAoC5vXTThxE4PNfv46coChGKCgMCqOMEH8=;
        b=dyOpaIwGpzWoc8ZuRFP7YDpMwK02/4zEOi0VVeq1KF0LCbagYbLPAgsMqOIiju/QXpCJzP
        TguirhqwFZ4Gz0F0JO1ya4/KweC7eP9K5VitKlezybrNtCl0hanbDYmJ1elW8hurfrrVWW
        3NHgcCZRnmYxeV7/tannE9nzxI7Dqq8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-uO3YvWWdOXWTVEtF1pZBOA-1; Wed, 04 Aug 2021 04:32:54 -0400
X-MC-Unique: uO3YvWWdOXWTVEtF1pZBOA-1
Received: by mail-pj1-f72.google.com with SMTP id h21-20020a17090adb95b029017797967ffbso1847427pjv.5
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8Mht9KhrSAoC5vXTThxE4PNfv46coChGKCgMCqOMEH8=;
        b=N56VDRHUdtAXQVExSivO9Adp6xiUoNxmjs+feQA5UPQ9Kz8QuSFXWxwFrZ00ATv5x+
         0UHVDjSAPszwCaas17cwkRDlLclX34hWAz06wcOwwO7Vd7d7LgnmKDaCDp5E0G7zySSh
         XENhxjolmHjIRyCe/ji3650iOWJLc/F4YjI2fA67pwqj9Dwy9ZWPO2rfpgYHBt1ILYEx
         T44gU4Ya6e17A3TlltWJ8TvOza/ehJ9i+yOyIzysXcQc7SOKFVhI6w3nuBlKlwhm6O1R
         TFdmPt6V0UVL08ckZ/uA4axm/Kh8A53BOTlyqexlIYpmZ+u5IkVt3PT5GdD3mudXo8PR
         WMwQ==
X-Gm-Message-State: AOAM533Ekfec2qgYv6ozWLwZWuGwM6igjqjZXO2rLOB5vgmw57iCVBqy
        Tqj5I6Z8so8/Ryadh3sRm7lCrwPkFCxF8Lnssm1ZsiOC72bSiVkRkSueAvxFqvogVRkEwF8/mkc
        eDGXA8tYzox3R
X-Received: by 2002:a17:903:2448:b029:12c:cbce:8f86 with SMTP id l8-20020a1709032448b029012ccbce8f86mr5117571pls.72.1628065973009;
        Wed, 04 Aug 2021 01:32:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0IqxY2soH2Uz1iq8mrB6lhygXB67xl2gJSTSu+DC+/FQJJ+3UJPurBSvXJuePHIlHPLAFsQ==
X-Received: by 2002:a17:903:2448:b029:12c:cbce:8f86 with SMTP id l8-20020a1709032448b029012ccbce8f86mr5117546pls.72.1628065972803;
        Wed, 04 Aug 2021 01:32:52 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d65sm1065176pjk.45.2021.08.04.01.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 01:32:52 -0700 (PDT)
Subject: Re: [PATCH v10 10/17] virtio: Handle device reset failure in
 register_virtio_device()
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-11-xieyongji@bytedance.com>
 <6bb6c689-e6dd-cfa2-094b-a0ca4258aded@redhat.com>
 <CACycT3v7BHxYY0OFYJRFU41Bz1=_v8iMRwzYKgX6cJM-SiNH+A@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fdcb0224-11f9-caf2-a44e-e6406087fd50@redhat.com>
Date:   Wed, 4 Aug 2021 16:32:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3v7BHxYY0OFYJRFU41Bz1=_v8iMRwzYKgX6cJM-SiNH+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/8/3 下午5:38, Yongji Xie 写道:
> On Tue, Aug 3, 2021 at 4:09 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/7/29 下午3:34, Xie Yongji 写道:
>>> The device reset may fail in virtio-vdpa case now, so add checks to
>>> its return value and fail the register_virtio_device().
>>
>> So the reset() would be called by the driver during remove as well, or
>> is it sufficient to deal only with the reset during probe?
>>
> Actually there is no way to handle failure during removal. And it
> should be safe with the protection of software IOTLB even if the
> reset() fails.
>
> Thanks,
> Yongji


If this is true, does it mean we don't even need to care about reset 
failure?

Thanks


