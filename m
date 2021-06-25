Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F753B3B0E
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 05:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhFYDLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 23:11:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233071AbhFYDLX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 23:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624590542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x2g9lBasApYrM4QFsD5hgHZyz+dwqoNSSbWrkfNZV2I=;
        b=iaT02gjDN2MRRtiVAwie2VFaySSMUfhFl+tBDA+4/FUu5gNq8qg0+YApq9MZrzh/jeEPOO
        5CqTeoMzah7s9OU3gZDHbfY1Ci22uVNAl/rV2Ohi8OsEQHwZPy6JkcgkE7alZH7JMKdsCP
        VxkAw9vR+uCUstkc2VWs/iEvFWl/xuY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-NN5T5j4wOMOEBm6RgdQ89w-1; Thu, 24 Jun 2021 23:09:00 -0400
X-MC-Unique: NN5T5j4wOMOEBm6RgdQ89w-1
Received: by mail-pg1-f197.google.com with SMTP id t28-20020a63461c0000b0290221e90ef795so5197961pga.6
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 20:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=x2g9lBasApYrM4QFsD5hgHZyz+dwqoNSSbWrkfNZV2I=;
        b=CqjEBpEKXEfE4MlLrXzWrg0sQm5uexZXaJnaRnPT5QOi3n/klJabSf/KKDfF9E4r9n
         T+w3D0ugJS/vMIlZj1Y8/qbRBO8rfazlyqAw1hXaNmnsQ/6kNrvci1qtseJ9mMmI7iRr
         0Gofiqmrxv+zqmFN0rq6tbYWcTh7yHHII/PqJQQRAExKRaDJyz2odUw3PpwMTMPBNDqK
         VZUQoM0nH6ugpRR4I7GCmgD9Cfpk+laGkhY7pmmfx/PKeOYbmrXzJ+QD70vazpvf5oKG
         0/Zlv8WSm+gIvCtj9vsherQ10O/aDx/fSGDf+0VvJ2sGELu0Dt5XmRb7jyYyDvcFUI76
         eFTg==
X-Gm-Message-State: AOAM532M+3AiRFxjZvXfKurpUBr6I9GCrmqW5MU8cUSEKn64qN136+n5
        lBKCzOWOJf4lYn1W6U6CiOx0fggZQxfvk5jVk5vYBLs+BNP/2ebnQDKOcGDGmrCeNKHUFc+QKkF
        pApOjAg1zTZPh
X-Received: by 2002:a17:90a:d302:: with SMTP id p2mr597035pju.186.1624590535429;
        Thu, 24 Jun 2021 20:08:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSt2a7irPTEnHB75wt/k1DcVWt+k1ibjJ9B3uVz8Ybl5wVpiHcOLL8vV4fUc+onvCWC2yUZA==
X-Received: by 2002:a17:90a:d302:: with SMTP id p2mr597003pju.186.1624590535223;
        Thu, 24 Jun 2021 20:08:55 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z9sm4301129pfc.101.2021.06.24.20.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 20:08:54 -0700 (PDT)
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
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
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com>
 <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com>
 <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com>
 <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
 <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com>
 <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
 <d2334f66-907c-2e9c-ea4f-f912008e9be8@redhat.com>
 <CACycT3uCSLUDVpQHdrmuxSuoBDg-4n22t+N-Jm2GoNNp9JYB2w@mail.gmail.com>
 <48cab125-093b-2299-ff9c-3de8c7c5ed3d@redhat.com>
 <CACycT3tS=10kcUCNGYm=dUZsK+vrHzDvB3FSwAzuJCu3t+QuUQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b10b3916-74d4-3171-db92-be0afb479a1c@redhat.com>
Date:   Fri, 25 Jun 2021 11:08:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3tS=10kcUCNGYm=dUZsK+vrHzDvB3FSwAzuJCu3t+QuUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/24 下午5:16, Yongji Xie 写道:
> On Thu, Jun 24, 2021 at 4:14 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/24 下午12:46, Yongji Xie 写道:
>>>> So we need to deal with both FEATURES_OK and reset, but probably not
>>>> DRIVER_OK.
>>>>
>>> OK, I see. Thanks for the explanation. One more question is how about
>>> clearing the corresponding status bit in get_status() rather than
>>> making set_status() fail. Since the spec recommends this way for
>>> validation which is done in virtio_dev_remove() and
>>> virtio_finalize_features().
>>>
>>> Thanks,
>>> Yongji
>>>
>> I think you can. Or it would be even better that we just don't set the
>> bit during set_status().
>>
> Yes, that's what I mean.
>
>> I just realize that in vdpa_reset() we had:
>>
>> static inline void vdpa_reset(struct vdpa_device *vdev)
>> {
>>           const struct vdpa_config_ops *ops = vdev->config;
>>
>>           vdev->features_valid = false;
>>           ops->set_status(vdev, 0);
>> }
>>
>> We probably need to add the synchronization here. E.g re-read with a
>> timeout.
>>
> Looks like the timeout is already in set_status().


Do you mean the VDUSE's implementation?


>   Do we really need a
> duplicated one here?


1) this is the timeout at the vDPA layer instead of the VDUSE layer.
2) it really depends on what's the meaning of the timeout for set_status 
of VDUSE.

Do we want:

2a) for set_status(): relay the message to userspace and wait for the 
userspace to quiescence the datapath

or

2b) for set_status(): simply relay the message to userspace, reply is no 
needed. Userspace will use a command to update the status when the 
datapath is stop. The the status could be fetched via get_stats().

2b looks more spec complaint.

> And how to handle failure? Adding a return value
> to virtio_config_ops->reset() and passing the error to the upper
> layer?


Something like this.

Thanks


>
> Thanks,
> Yongji
>

