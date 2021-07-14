Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332273C7E50
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 08:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbhGNGF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 02:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237921AbhGNGF5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 02:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626242586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c7Q8ciSmkkFwqcK9Ly2flr5V7ufFOKmLdTuweetcBqc=;
        b=Ni8dhCeKAa6CFZEPBNbHxe5pbfl/jKG0kVLhm2oXoFYvWbq7fIhmQaWISWJ7HRqQL6p4Ag
        eRi/hH/OZ25Li3Ty0sYLiQz71X0jSaYp+0f2Ef5DtvG5sUTUtsmAPmlPh8qji/G7IImEXN
        RpdqwKbIfQlTtVhOnQNMG4ILsRQfWgQ=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-aWqpmK3tMQSu6p3_30gD-w-1; Wed, 14 Jul 2021 02:03:05 -0400
X-MC-Unique: aWqpmK3tMQSu6p3_30gD-w-1
Received: by mail-pg1-f199.google.com with SMTP id 137-20020a63058f0000b02902285c45652dso749568pgf.4
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 23:03:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=c7Q8ciSmkkFwqcK9Ly2flr5V7ufFOKmLdTuweetcBqc=;
        b=DCxiR6fe4Ip82D8reH2LzFp6aGztXpBUy5Xkg8heMrKGp5xKOiWWT5/3dfricu9xTQ
         3epdtGDU+6Vltx2lqzod2UMORfSQ+4/t4PwJI/96MiCdlLsL5uZWFADBAcoPwJ8Um176
         AeQTwk2EopJoSUdx14lA9Hy9PVNJX2TV0YRcHRv4MQlgkYNa3j+5ADo3jcJbSq24TbfK
         gJk1eU8xuSi7h6H8x6wevnALFxGyLrs4Rv6jB7mkfB3LU/wk3YO9ysP9+vveYBuNwF/y
         39ua+4mr0F1avmhqPhxZktaKwcpj/qpWpxkCb9a02qjdyeUP9xTTYcE9nADrC8r1b81Q
         MtVA==
X-Gm-Message-State: AOAM533wyD3edd3KRjkw0hnlk9VeBOGA1eZANYKA1oyy3bFYgr+6/WkN
        YHcGsmjHtgAZ6gbeAAZtFM3jiG6lQwtyTQqRZH1M2CBTK42/NGg/enVydHVN+HAieBq6Q3sz8lF
        E58ps1xEMVbr9
X-Received: by 2002:a63:111a:: with SMTP id g26mr7785887pgl.103.1626242584043;
        Tue, 13 Jul 2021 23:03:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdA7Ox90h5XXIshMvBjDNcFMeGycsIxzhnY5/F/BBeS8iYsHUo11OJSfqeDY+OH4iEPOdWBg==
X-Received: by 2002:a63:111a:: with SMTP id g26mr7785847pgl.103.1626242583780;
        Tue, 13 Jul 2021 23:03:03 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d2sm4572795pjo.50.2021.07.13.23.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 23:03:02 -0700 (PDT)
Subject: Re: [PATCH v9 16/17] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-17-xieyongji@bytedance.com>
 <26116714-f485-eeab-4939-71c4c10c30de@redhat.com>
 <20210714014817-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0565ed6c-88e2-6d93-7cc6-7b4afaab599c@redhat.com>
Date:   Wed, 14 Jul 2021 14:02:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210714014817-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/7/14 ÏÂÎç1:54, Michael S. Tsirkin Ð´µÀ:
> On Wed, Jul 14, 2021 at 01:45:39PM +0800, Jason Wang wrote:
>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
>>> +			      struct vduse_dev_msg *msg)
>>> +{
>>> +	int ret;
>>> +
>>> +	init_waitqueue_head(&msg->waitq);
>>> +	spin_lock(&dev->msg_lock);
>>> +	msg->req.request_id = dev->msg_unique++;
>>> +	vduse_enqueue_msg(&dev->send_list, msg);
>>> +	wake_up(&dev->waitq);
>>> +	spin_unlock(&dev->msg_lock);
>>> +
>>> +	wait_event_killable_timeout(msg->waitq, msg->completed,
>>> +				    VDUSE_REQUEST_TIMEOUT * HZ);
>>> +	spin_lock(&dev->msg_lock);
>>> +	if (!msg->completed) {
>>> +		list_del(&msg->list);
>>> +		msg->resp.result = VDUSE_REQ_RESULT_FAILED;
>>> +	}
>>> +	ret = (msg->resp.result == VDUSE_REQ_RESULT_OK) ? 0 : -EIO;
>>
>> I think we should mark the device as malfunction when there is a timeout and
>> forbid any userspace operations except for the destroy aftwards for safety.
> This looks like if one tried to run gdb on the program the behaviour
> will change completely because kernel wants it to respond within
> specific time. Looks like a receipe for heisenbugs.
>
> Let's not build interfaces with arbitrary timeouts like that.
> Interruptible wait exists for this very reason.


The problem is. Do we want userspace program like modprobe to be stuck 
for indefinite time and expect the administrator to kill that?

Thanks


>   Let userspace have its
> own code to set and use timers. This does mean that userspace will
> likely have to change a bit to support this driver, such is life.
>

