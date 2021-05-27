Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7723926AD
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 07:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhE0FBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 01:01:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233565AbhE0FBw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 01:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622091619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WvNDULJK9zHRMwqe44K4RR3WKdtWUGMATeJjP7wtcZY=;
        b=AU2+5mfOda8rjlBycUP8H5Fiq0WOpjX/9SbilqkatzEYPPJ5N0cFNo43QxQfV+zJm/pq+j
        HYE+gpkV20ZAiO+sypzMoTjQXRjdxiCmibLOZ3ytDT35ajLfr4s2z0WBYV3Q8s6zB+oS+b
        KBnMnw8KWpH2uYOpNlpI6M4SY5OutN8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-yVwgnA-dMaGFa7-KQRECYA-1; Thu, 27 May 2021 01:00:17 -0400
X-MC-Unique: yVwgnA-dMaGFa7-KQRECYA-1
Received: by mail-pl1-f197.google.com with SMTP id o19-20020a170902e293b02900ef869214f9so1713775plc.18
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 22:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WvNDULJK9zHRMwqe44K4RR3WKdtWUGMATeJjP7wtcZY=;
        b=HXFmxUYJO9UCXH5VCa8Ez2+cYLadbRMphPsQU0b5LjafM4Da45eVZbmEKJC5VG7inJ
         EpF9mKamErmkc9dYXevCooIXxqpLJ4BMtssZHPGqgV0Bqi/4ttwI6bISw0QaQOc+4w9Y
         DoLvNpwtTH0w5U91SqnHEzgxtC1FRXx7PycV9LUtE3rup2BCuyXOP8Mly48UIMciSqs7
         haDyHmZ/H9xOgg/e3B7M+DS+zbRE9sSaQHPpFF8J1qDaD9NvvyYAwW6zwSgHN7+TlqQC
         Gau0tO1b9I9u4xgwGaqun4kYJ0m1xldHajHH9PijhRtlDMjr9c4wGlMmeRWPs+4eTmRI
         p29w==
X-Gm-Message-State: AOAM530qMEqJZ51L9/3TibnlqCfEDOcePx+Ru1TUDYK/gxkjJD05+gzd
        9ji9UjcR1rxWGykSrjHz6QGVFHvY8T4SHhG+bHptPk/62sfPCBtXQLAv10ywNjOX2mVGZSumX8b
        FCJij0nhJAS85
X-Received: by 2002:a17:90b:1d8f:: with SMTP id pf15mr1854479pjb.36.1622091616470;
        Wed, 26 May 2021 22:00:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbQssOI3XI76V4pKYYsFesmyrvxjTc0EKTWn6Zl6xKwlpjIji0dLlRJIWAqJ1uNqyHlcKbWw==
X-Received: by 2002:a17:90b:1d8f:: with SMTP id pf15mr1854461pjb.36.1622091616242;
        Wed, 26 May 2021 22:00:16 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u5sm715334pfi.179.2021.05.26.22.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 22:00:15 -0700 (PDT)
Subject: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in
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
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-12-xieyongji@bytedance.com>
 <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com>
 <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5a68bb7c-fd05-ce02-cd61-8a601055c604@redhat.com>
Date:   Thu, 27 May 2021 13:00:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/5/27 下午12:57, Yongji Xie 写道:
> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/5/17 下午5:55, Xie Yongji 写道:
>>> +
>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
>>> +                           struct vduse_dev_msg *msg)
>>> +{
>>> +     init_waitqueue_head(&msg->waitq);
>>> +     spin_lock(&dev->msg_lock);
>>> +     vduse_enqueue_msg(&dev->send_list, msg);
>>> +     wake_up(&dev->waitq);
>>> +     spin_unlock(&dev->msg_lock);
>>> +     wait_event_killable(msg->waitq, msg->completed);
>>
>> What happens if the userspace(malicous) doesn't give a response forever?
>>
>> It looks like a DOS. If yes, we need to consider a way to fix that.
>>
> How about using wait_event_killable_timeout() instead?


Probably, and then we need choose a suitable timeout and more important, 
need to report the failure to virtio.

Thanks


>
> Thanks,
> Yongji
>

