Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4025397E94
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 04:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhFBCNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 22:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230334AbhFBCN3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 22:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622599907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lZVFPtcnihzw6Crkb+n7RJjTscY9buzOxvek+kEcgCo=;
        b=iJYsArkuXGrt8fgAI1VT07R6JPu075ZTO0hF6VS8U9ESOeS7TLf3AYxxjGehwdvSCitmDv
        U8Rxm6NLXr5C5kJiyRocNbQpOslm/gMzm5vaFgBi7rzdhFQVyYZRAObwJ2YVe7Z3yF+F2j
        YHx1jAQ2Mhbj4pI2141mDwx+9XsaIRs=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-Dh_0Wf3AOR-GTVuhQCnO-g-1; Tue, 01 Jun 2021 22:11:46 -0400
X-MC-Unique: Dh_0Wf3AOR-GTVuhQCnO-g-1
Received: by mail-pg1-f197.google.com with SMTP id 124-20020a6306820000b029021ff5a7c55dso746108pgg.0
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 19:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lZVFPtcnihzw6Crkb+n7RJjTscY9buzOxvek+kEcgCo=;
        b=ne5vKlQsq9GwCURrObfuEFAwVZDWVun+UGeZIWTiPtPLmH57XxgXSc4VGZ5KmRYpQy
         BWJbKdWAC4LFHQtgNov8RyxcT66vD2Y1LDZoAPDme27k9xdSwuTy5PWzbBhJCEoMTq2a
         hTFKpz27zI89f1xlA8JhUGOEqGqsfflvpYAy0X7NAb5pPjU8k77DX4l0IXGhlWJiOdot
         jZyMGzYTMAct7yatfDIdLkmJwQW6T5UbfV2oOacvqnjlQmnjBAxDq6K8TzgyCe4E5rci
         m7sFfIgsB3auZ7bQG0V43YUX7cjBbQOjcZqt9QAkdYpx/X6hTZ2AM6S5QT+XNuBlg3KA
         lX+g==
X-Gm-Message-State: AOAM531BttCBeO65bmq1ROk4BquFAuC2/28DMYItasFFbSNg+bWFix7W
        wRz1tmokCu92R/eS8VQnHbUrMgj3i4cbT4W4bYLE8DNxtWAbLUnyzLM8Fo16xC7F1gO7VGRhUEx
        IbYLVvegHTMCa
X-Received: by 2002:a17:90a:9411:: with SMTP id r17mr27751157pjo.49.1622599904797;
        Tue, 01 Jun 2021 19:11:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7jaPg4i0ubXcEyXL3E/szYzG3vyar8Ms/jhzMDyREusEWUIsRPjx8+473wjnPnqHfhg3W0Q==
X-Received: by 2002:a17:90a:9411:: with SMTP id r17mr27751135pjo.49.1622599904510;
        Tue, 01 Jun 2021 19:11:44 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm14759633pjq.5.2021.06.01.19.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 19:11:43 -0700 (PDT)
Subject: Re: [PATCH 1/4] vdpa: support packed virtqueue for set/get_vq_state()
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, eli@mellanox.com
References: <20210601084503.34724-1-jasowang@redhat.com>
 <20210601084503.34724-2-jasowang@redhat.com>
 <20210601104711.GD215954@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <da410b5f-8603-8aa5-d2c7-89bf06a40de3@redhat.com>
Date:   Wed, 2 Jun 2021 10:11:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601104711.GD215954@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/1 ÏÂÎç6:47, Eli Cohen Ð´µÀ:
> On Tue, Jun 01, 2021 at 04:45:00PM +0800, Jason Wang wrote:
>> This patch extends the vdpa_vq_state to support packed virtqueue
>> state which is basically the device/driver ring wrap counters and the
>> avail and used index. This will be used for the virito-vdpa support
>> for the packed virtqueue and the future vhost/vhost-vdpa support for
>> the packed virtqueue.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> You changed interface but did not modify mlx5. Does this compile on your
> system?


Yes but I'm using a minimal config without mlx5 enabled :(

V2 is posted.

Thanks


>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c  |  4 ++--
>>   drivers/vdpa/vdpa_sim/vdpa_sim.c |  4 ++--
>>   drivers/vhost/vdpa.c             |  4 ++--
>>   include/linux/vdpa.h             | 25 +++++++++++++++++++++++--
>>   4 files changed, 29 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index ab0ab5cf0f6e..5d3891b1ca28 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -264,7 +264,7 @@ static int ifcvf_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
>>   {
>>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>   
>> -	state->avail_index = ifcvf_get_vq_state(vf, qid);
>> +	state->split.avail_index = ifcvf_get_vq_state(vf, qid);
>>   	return 0;
>>   }
>>   
>> @@ -273,7 +273,7 @@ static int ifcvf_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
>>   {
>>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>   
>> -	return ifcvf_set_vq_state(vf, qid, state->avail_index);
>> +	return ifcvf_set_vq_state(vf, qid, state->split.avail_index);
>>   }
>>   
>>   static void ifcvf_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> index 98f793bc9376..14e024de5cbf 100644
>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> @@ -374,7 +374,7 @@ static int vdpasim_set_vq_state(struct vdpa_device *vdpa, u16 idx,
>>   	struct vringh *vrh = &vq->vring;
>>   
>>   	spin_lock(&vdpasim->lock);
>> -	vrh->last_avail_idx = state->avail_index;
>> +	vrh->last_avail_idx = state->split.avail_index;
>>   	spin_unlock(&vdpasim->lock);
>>   
>>   	return 0;
>> @@ -387,7 +387,7 @@ static int vdpasim_get_vq_state(struct vdpa_device *vdpa, u16 idx,
>>   	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>>   	struct vringh *vrh = &vq->vring;
>>   
>> -	state->avail_index = vrh->last_avail_idx;
>> +	state->split.avail_index = vrh->last_avail_idx;
>>   	return 0;
>>   }
>>   
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index fb41db3da611..210ab35a7ebf 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -383,7 +383,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>   		if (r)
>>   			return r;
>>   
>> -		vq->last_avail_idx = vq_state.avail_index;
>> +		vq->last_avail_idx = vq_state.split.avail_index;
>>   		break;
>>   	}
>>   
>> @@ -401,7 +401,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>   		break;
>>   
>>   	case VHOST_SET_VRING_BASE:
>> -		vq_state.avail_index = vq->last_avail_idx;
>> +		vq_state.split.avail_index = vq->last_avail_idx;
>>   		if (ops->set_vq_state(vdpa, idx, &vq_state))
>>   			r = -EINVAL;
>>   		break;
>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> index f311d227aa1b..3357ac98878d 100644
>> --- a/include/linux/vdpa.h
>> +++ b/include/linux/vdpa.h
>> @@ -28,13 +28,34 @@ struct vdpa_notification_area {
>>   };
>>   
>>   /**
>> - * struct vdpa_vq_state - vDPA vq_state definition
>> + * struct vdpa_vq_state_split - vDPA split virtqueue state
>>    * @avail_index: available index
>>    */
>> -struct vdpa_vq_state {
>> +struct vdpa_vq_state_split {
>>   	u16	avail_index;
>>   };
>>   
>> +/**
>> + * struct vdpa_vq_state_packed - vDPA packed virtqueue state
>> + * @last_avail_counter: last driver ring wrap counter observed by device
>> + * @last_avail_idx: device available index
>> + * @last_used_counter: device ring wrap counter
>> + * @last_used_idx: used index
>> + */
>> +struct vdpa_vq_state_packed {
>> +        u16	last_avail_counter:1;
>> +        u16	last_avail_idx:15;
>> +        u16	last_used_counter:1;
>> +        u16	last_used_idx:15;
>> +};
>> +
>> +struct vdpa_vq_state {
>> +     union {
>> +          struct vdpa_vq_state_split split;
>> +          struct vdpa_vq_state_packed packed;
>> +     };
>> +};
>> +
>>   struct vdpa_mgmt_dev;
>>   
>>   /**
>> -- 
>> 2.25.1
>>

