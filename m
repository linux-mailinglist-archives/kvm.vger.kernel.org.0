Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597B13B2A24
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 10:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhFXIQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 04:16:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231890AbhFXIQd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 04:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624522454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QgEPrtgYrjYyuikepQ643R5m9hvqjjuW2YQFdqmgfAI=;
        b=KkQLycnG86Jr4cN811GZzfP7IWpjIRA9ruoVQhiBll6rYBjrg6wEWJIMjK/3VJ5B0jHI6Z
        UXVMXxTZqNrj9iR5uHKlz54Dp9YAUlfvbQ0FCH48hc6nQCMY1E4Hhv1MWrWcqcWU+cTW03
        2XW8c9Rp0bJSo16PCshHvWaGEy5QR/8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-h5MspzuVN2KqXeThUoaepQ-1; Thu, 24 Jun 2021 04:14:10 -0400
X-MC-Unique: h5MspzuVN2KqXeThUoaepQ-1
Received: by mail-pg1-f200.google.com with SMTP id x7-20020a63db470000b029022199758419so3356494pgi.11
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 01:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=QgEPrtgYrjYyuikepQ643R5m9hvqjjuW2YQFdqmgfAI=;
        b=gsU+fPkpuWUDsR5WNaSqqogFRoqdYFGz6bRgxpkMQEu/KKoW6GsNXtCSaQjURjmOVn
         tNSUkSJh4PatHAjwZlauJZ7O/XaRV3o7cgokCHP8Vk/bk3zDSL8lEFI+kEgkJbv7gagO
         56bWwu6Ak8720qt/qwkk57UdKi4of49n5n+oK63qBzfw9vjhhPsT2kHUnBnN8pyakcl4
         b4yL04d87jLoooHcVBPoaRRtm9j4qml3tuEXVDkVFm2XgoVhmeHNKNzuES9Ho0c01UOx
         mNg29D8YmaOcuZ1Ta9jp1W6sDQ+1GDcrjdfa5IGgkSZ3h+IOohdnRqj2C8qi0FlQSdzl
         NJrg==
X-Gm-Message-State: AOAM531LTzLSFXYPlGj5jYDzflHp5ScthYATekC0oTyLODi6UTl/0UKP
        5oD5bRWKPGVxesLAvf/I52ntgIyw29oWOmll1b4pX6PrXurAhAMLvPACI7441TRmVPtqJm5Bocf
        tXv1AREDOBpJP
X-Received: by 2002:a63:e04e:: with SMTP id n14mr3633700pgj.324.1624522449548;
        Thu, 24 Jun 2021 01:14:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfl/37xGZkYh7EyP/rmRN1//BEFW+vjWFYtE33l7LAdc/0dPkEsdVgi/iD6hW3Szw3O6lBHQ==
X-Received: by 2002:a63:e04e:: with SMTP id n14mr3633666pgj.324.1624522449288;
        Thu, 24 Jun 2021 01:14:09 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v21sm2129727pfu.77.2021.06.24.01.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 01:14:08 -0700 (PDT)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <48cab125-093b-2299-ff9c-3de8c7c5ed3d@redhat.com>
Date:   Thu, 24 Jun 2021 16:13:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3uCSLUDVpQHdrmuxSuoBDg-4n22t+N-Jm2GoNNp9JYB2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/24 下午12:46, Yongji Xie 写道:
>> So we need to deal with both FEATURES_OK and reset, but probably not
>> DRIVER_OK.
>>
> OK, I see. Thanks for the explanation. One more question is how about
> clearing the corresponding status bit in get_status() rather than
> making set_status() fail. Since the spec recommends this way for
> validation which is done in virtio_dev_remove() and
> virtio_finalize_features().
>
> Thanks,
> Yongji
>

I think you can. Or it would be even better that we just don't set the 
bit during set_status().

I just realize that in vdpa_reset() we had:

static inline void vdpa_reset(struct vdpa_device *vdev)
{
         const struct vdpa_config_ops *ops = vdev->config;

         vdev->features_valid = false;
         ops->set_status(vdev, 0);
}

We probably need to add the synchronization here. E.g re-read with a 
timeout.

Thanks

