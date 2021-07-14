Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F042A3C80DA
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 10:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhGNJAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 05:00:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238781AbhGNJAB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 05:00:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626253029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b67pj1XjCFcb4vjOC6L9gEcYmcQccLEDJzYb3n+c66I=;
        b=izYdgIPViBrjodbEmKIuj31rynO1KOexp4s0EXFtCbJN0aczCRvebWxDEqPH3bFjYFGJiC
        CZaGgTxbxhySnYm+eGcA6q0Mqc8RAajrNpdR3fAUbNK3JcrHcYvhj/fEUj6Je2jTcmHv0d
        wQv44fcgVaJljc4kC+4OeHjZX8r4VtI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-Gh3b8NEFNgmZq17iKiMcog-1; Wed, 14 Jul 2021 04:57:06 -0400
X-MC-Unique: Gh3b8NEFNgmZq17iKiMcog-1
Received: by mail-pj1-f72.google.com with SMTP id k23-20020a17090a5917b02901739510b17fso881887pji.6
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 01:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=b67pj1XjCFcb4vjOC6L9gEcYmcQccLEDJzYb3n+c66I=;
        b=Q52r4LHq1rL8JoeNVOuvy+i0/e91D5zdA+/7ixS5uVoG1KY/NDbhojpYUvpkXYGfBT
         GztHr3GBH5LI8cfEvrOax/aGW/UUTzZ8rE9jDLMmxf2YnqKTyBdvLRP1XsRD1AcpkILj
         oRTmxXGL7IkjjLVJeZmQVvDQNjYwNquyNEA/NEpybDcdvH/jsCUO/mudUeIYbV91UiTT
         PJhNCuYkqFf7CKyKKGjxxlngmqWvJ9bAZVpHlUUmXRoUHvn7JxJawkENskv/zdIWhsN4
         rRqng1zTKiKClBjec6nlBnRDJHiHbdLWW8OFxV/EFpL/5nV6d2QN3NKGeCXQyRNwdKq4
         YUKA==
X-Gm-Message-State: AOAM530TSCSLhIXcI8mLXJpA5o8DiDgaBn94WX1NN8hHNyRLQXf2Akro
        2yt69S8lUYcimk5r+io3gCIo9LBEAO8lrE08OJUaYrOtYAdknWRDXfhsd+yGr43LO1fOolUppA2
        tQtpg/eBgAHrL
X-Received: by 2002:a17:90a:af90:: with SMTP id w16mr2814472pjq.129.1626253025289;
        Wed, 14 Jul 2021 01:57:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzI/UxSDMVXZBsCbO/ysTuOL+td5Krg49S3x+yII+Nt1pi43Zbgr08iKwIXB4LRw/hvEMwy1w==
X-Received: by 2002:a17:90a:af90:: with SMTP id w16mr2814452pjq.129.1626253024987;
        Wed, 14 Jul 2021 01:57:04 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d2sm2127796pgh.59.2021.07.14.01.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 01:57:04 -0700 (PDT)
Subject: Re: [PATCH v9 16/17] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-17-xieyongji@bytedance.com>
 <26116714-f485-eeab-4939-71c4c10c30de@redhat.com>
 <20210714014817-mutt-send-email-mst@kernel.org>
 <0565ed6c-88e2-6d93-7cc6-7b4afaab599c@redhat.com>
 <YO6IiDIMUjQsA2LS@kroah.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a493bc51-9a5c-05f1-2eac-54cb9e6c9d9b@redhat.com>
Date:   Wed, 14 Jul 2021 16:56:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YO6IiDIMUjQsA2LS@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/7/14 下午2:47, Greg KH 写道:
> On Wed, Jul 14, 2021 at 02:02:50PM +0800, Jason Wang wrote:
>> 在 2021/7/14 下午1:54, Michael S. Tsirkin 写道:
>>> On Wed, Jul 14, 2021 at 01:45:39PM +0800, Jason Wang wrote:
>>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
>>>>> +			      struct vduse_dev_msg *msg)
>>>>> +{
>>>>> +	int ret;
>>>>> +
>>>>> +	init_waitqueue_head(&msg->waitq);
>>>>> +	spin_lock(&dev->msg_lock);
>>>>> +	msg->req.request_id = dev->msg_unique++;
>>>>> +	vduse_enqueue_msg(&dev->send_list, msg);
>>>>> +	wake_up(&dev->waitq);
>>>>> +	spin_unlock(&dev->msg_lock);
>>>>> +
>>>>> +	wait_event_killable_timeout(msg->waitq, msg->completed,
>>>>> +				    VDUSE_REQUEST_TIMEOUT * HZ);
>>>>> +	spin_lock(&dev->msg_lock);
>>>>> +	if (!msg->completed) {
>>>>> +		list_del(&msg->list);
>>>>> +		msg->resp.result = VDUSE_REQ_RESULT_FAILED;
>>>>> +	}
>>>>> +	ret = (msg->resp.result == VDUSE_REQ_RESULT_OK) ? 0 : -EIO;
>>>> I think we should mark the device as malfunction when there is a timeout and
>>>> forbid any userspace operations except for the destroy aftwards for safety.
>>> This looks like if one tried to run gdb on the program the behaviour
>>> will change completely because kernel wants it to respond within
>>> specific time. Looks like a receipe for heisenbugs.
>>>
>>> Let's not build interfaces with arbitrary timeouts like that.
>>> Interruptible wait exists for this very reason.
>>
>> The problem is. Do we want userspace program like modprobe to be stuck for
>> indefinite time and expect the administrator to kill that?
> Why would modprobe be stuck for forever?
>
> Is this on the module probe path?


Yes, it is called in the device probing path where the kernel forwards 
the device configuration request to userspace and wait for its response.

If it turns out to be tricky, we can implement the whole device inside 
the kernel and leave only the datapath in the userspace (as what TUN did).

Thanks


>

