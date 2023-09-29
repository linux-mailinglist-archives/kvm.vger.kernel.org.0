Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F627B2EE4
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 11:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjI2JI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 05:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbjI2JI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 05:08:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91E31AA
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 02:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695978496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m0YwDJJKdQQtZNICAcr7E2f6PUBVKHV+uHDC6bNQc4g=;
        b=EVxGLYcSG2PRfBXx6fi/RGJKJ25UtzzhD1QPTK0fYpGr3u4DZ1B44iqvQV5mT6ADG2tSmQ
        LUyC725XeOONw3wX08f3ZVkzSTGf6ppqwSS5h2ufdRTcCxW48SKFp1rOz37FNKNPR0VZ/6
        K0yV1WoAuxPNpEG4KxANd1tsvZIAmjw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-EXB0zdH6NZ6A7976Vy4WvQ-1; Fri, 29 Sep 2023 05:08:11 -0400
X-MC-Unique: EXB0zdH6NZ6A7976Vy4WvQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E79829AA3B9;
        Fri, 29 Sep 2023 09:08:11 +0000 (UTC)
Received: from [10.39.208.41] (unknown [10.39.208.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A70BC15BB8;
        Fri, 29 Sep 2023 09:08:09 +0000 (UTC)
Message-ID: <6c4cd924-0d44-582e-13a4-791f38d10fe8@redhat.com>
Date:   Fri, 29 Sep 2023 11:08:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To:     Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
References: <20230912030008.3599514-1-lulu@redhat.com>
 <20230912030008.3599514-5-lulu@redhat.com>
 <CACGkMEtCYG8-Pt+V-OOwUV7fYFp_cnxU68Moisfxju9veJ-=qw@mail.gmail.com>
 <CACLfguW3NS_4+YhqTtGqvQb70mVazGVfheryHx4aCBn+=Skf9w@mail.gmail.com>
 <CACGkMEt-m9bOh9YnqLw0So5wqbZ69D0XRVBbfG73Oh7Q8qTJsQ@mail.gmail.com>
Content-Language: en-US
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
Subject: Re: [RFC v2 4/4] vduse: Add new ioctl VDUSE_GET_RECONNECT_INFO
In-Reply-To: <CACGkMEt-m9bOh9YnqLw0So5wqbZ69D0XRVBbfG73Oh7Q8qTJsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/25/23 04:57, Jason Wang wrote:
> On Thu, Sep 21, 2023 at 10:07 PM Cindy Lu <lulu@redhat.com> wrote:
>>
>> On Mon, Sep 18, 2023 at 4:49 PM Jason Wang <jasowang@redhat.com> wrote:
>>>
>>> On Tue, Sep 12, 2023 at 11:01 AM Cindy Lu <lulu@redhat.com> wrote:
>>>>
>>>> In VDUSE_GET_RECONNECT_INFO, the Userspace App can get the map size
>>>> and The number of mapping memory pages from the kernel. The userspace
>>>> App can use this information to map the pages.
>>>>
>>>> Signed-off-by: Cindy Lu <lulu@redhat.com>
>>>> ---
>>>>   drivers/vdpa/vdpa_user/vduse_dev.c | 15 +++++++++++++++
>>>>   include/uapi/linux/vduse.h         | 15 +++++++++++++++
>>>>   2 files changed, 30 insertions(+)
>>>>
>>>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
>>>> index 680b23dbdde2..c99f99892b5c 100644
>>>> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
>>>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
>>>> @@ -1368,6 +1368,21 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
>>>>                  ret = 0;
>>>>                  break;
>>>>          }
>>>> +       case VDUSE_GET_RECONNECT_INFO: {
>>>> +               struct vduse_reconnect_mmap_info info;
>>>> +
>>>> +               ret = -EFAULT;
>>>> +               if (copy_from_user(&info, argp, sizeof(info)))
>>>> +                       break;
>>>> +
>>>> +               info.size = PAGE_SIZE;
>>>> +               info.max_index = dev->vq_num + 1;
>>>> +
>>>> +               if (copy_to_user(argp, &info, sizeof(info)))
>>>> +                       break;
>>>> +               ret = 0;
>>>> +               break;
>>>> +       }
>>>>          default:
>>>>                  ret = -ENOIOCTLCMD;
>>>>                  break;
>>>> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
>>>> index d585425803fd..ce55e34f63d7 100644
>>>> --- a/include/uapi/linux/vduse.h
>>>> +++ b/include/uapi/linux/vduse.h
>>>> @@ -356,4 +356,19 @@ struct vhost_reconnect_vring {
>>>>          _Bool avail_wrap_counter;
>>>>   };
>>>>
>>>> +/**
>>>> + * struct vduse_reconnect_mmap_info
>>>> + * @size: mapping memory size, always page_size here
>>>> + * @max_index: the number of pages allocated in kernel,just
>>>> + * use for check
>>>> + */
>>>> +
>>>> +struct vduse_reconnect_mmap_info {
>>>> +       __u32 size;
>>>> +       __u32 max_index;
>>>> +};
>>>
>>> One thing I didn't understand is that, aren't the things we used to
>>> store connection info belong to uAPI? If not, how can we make sure the
>>> connections work across different vendors/implementations. If yes,
>>> where?
>>>
>>> Thanks
>>>
>> The process for this reconnecttion  is
>> A.The first-time connection
>> 1> The userland app checks if the device exists
>> 2>  use the ioctl to create the vduse device
>> 3> Mapping the kernel page to userland and save the
>> App-version/features/other information to this page
>> 4>  if the Userland app needs to exit, then the Userland app will only
>> unmap the page and then exit
>>
>> B, the re-connection
>> 1> the userland app finds the device is existing
>> 2> Mapping the kernel page to userland
>> 3> check if the information in shared memory is satisfied to
>> reconnect,if ok then continue to reconnect
>> 4> continue working
>>
>>   For now these information are all from userland,So here the page will
>> be maintained by the userland App
>> in the previous code we only saved the api-version by uAPI .  if  we
>> need to support reconnection maybe we need to add 2 new uAPI for this,
>> one of the uAPI is to save the reconnect  information and another is
>> to get the information
>>
>> maybe something like
>>
>> struct vhost_reconnect_data {
>> uint32_t version;
>> uint64_t features;
>> uint8_t status;
>> struct virtio_net_config config;
>> uint32_t nr_vrings;
>> };
> 
> Probably, then we can make sure the re-connection works across
> different vduse-daemon implementations.

+1, we need to have this defined in the uAPI to support interoperability
across different VDUSE userspace implementations.

> 
>>
>> #define VDUSE_GET_RECONNECT_INFO _IOR (VDUSE_BASE, 0x1c, struct
>> vhost_reconnect_data)
>>
>> #define VDUSE_SET_RECONNECT_INFO  _IOWR(VDUSE_BASE, 0x1d, struct
>> vhost_reconnect_data)
> 
> Not sure I get this, but the idea is to map those pages to user space,
> any reason we need this uAPI?

It should not be necessary if the mmapped layout is properly defined.

Thanks,
Maxime

> Thanks
> 
>>
>> Thanks
>> Cindy
>>
>>
>>
>>
>>>> +
>>>> +#define VDUSE_GET_RECONNECT_INFO \
>>>> +       _IOWR(VDUSE_BASE, 0x1b, struct vduse_reconnect_mmap_info)
>>>> +
>>>>   #endif /* _UAPI_VDUSE_H_ */
>>>> --
>>>> 2.34.3
>>>>
>>>
>>
> 

