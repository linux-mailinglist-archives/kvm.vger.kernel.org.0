Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ABD3982A5
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 09:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhFBHIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 03:08:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231346AbhFBHIv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 03:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622617628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DIn7oU6+FWaajjVOBnVnDXXj1rPq+MuBcxlSw0xkwZE=;
        b=SG8TnGdZMWOTDQnHTL1//IgN5SneSrV/eZFgWwGlrRnzntBPVzZMjAcxdW/3VtI/2Tp+tS
        b8yzsnuBGvfTKLToo0k5M3h9x5olo8+FBPKoajBRpOW52LlWXIKbapYTYupsj3zFXl+Qxm
        6LzuCiJVelUK25ndn881d/QxekUKodc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-aN2YxHrvNfawhPrBGjZZYw-1; Wed, 02 Jun 2021 03:07:07 -0400
X-MC-Unique: aN2YxHrvNfawhPrBGjZZYw-1
Received: by mail-pj1-f71.google.com with SMTP id 15-20020a17090a0f0fb029016ad0f32fd0so591899pjy.6
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 00:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DIn7oU6+FWaajjVOBnVnDXXj1rPq+MuBcxlSw0xkwZE=;
        b=U8izPTXttKH3uVPbeQSg0jVksafr8Ahbt/iUljHiIJuqc0Nae/piuO59E3WJyfSCH+
         axwyT/RHa7aRnOAoweGR8eJnpbnWiFX90iH55WAscNmeMhR7a7Jb9D44HFSNv22b38MU
         wW0ziwQPhxoQZf1a4k0WGJAwrhy15Hbehlr44yd4WnhVbFcMi6mVYvM8BpDLZ+4R0tFZ
         kt1NyfD/QtOaULTZ3DUwFhG+fOooGjw0vyplMNpsEY3BsKKf+QhEXKLqyRYDMXoFmYFN
         JuoGWDzXXwp5uA2+DW2n8hjajkUUYHAyuu+3UKx6X/N5Bz3dpQczGILggEkf5BYasU7O
         npRA==
X-Gm-Message-State: AOAM5325MZbjbOnkaY+KdJk2feTDnotZ3xas5Xk9PY4A8Jbl1wLHaa0z
        VI89qe3XVEHBToqTOGpT26icxG2x0SOvwM9f8kMvVyw5WGgQ5eGwabslpI+cEVgha6cnjy+geNi
        3jswj42hPJnye
X-Received: by 2002:a63:370b:: with SMTP id e11mr2997522pga.356.1622617625654;
        Wed, 02 Jun 2021 00:07:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQPBUIaMSz6qvd9JSBnMqXSurn4bBEos0N6fpw0TLZWd+uW/3B70u5qTqpAn9peLKQgziDfg==
X-Received: by 2002:a63:370b:: with SMTP id e11mr2997512pga.356.1622617625499;
        Wed, 02 Jun 2021 00:07:05 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p26sm3560856pfw.178.2021.06.02.00.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 00:07:05 -0700 (PDT)
Subject: Re: [PATCH V2 4/4] virtio/vdpa: clear the virtqueue state during
 probe
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, eli@mellanox.com
References: <20210602021043.39201-1-jasowang@redhat.com>
 <20210602021043.39201-5-jasowang@redhat.com>
 <20210602061723.GB8662@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7ce52bd6-60b7-b733-9881-682cfba51ad8@redhat.com>
Date:   Wed, 2 Jun 2021 15:07:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602061723.GB8662@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/2 ÏÂÎç2:17, Eli Cohen Ð´µÀ:
> On Wed, Jun 02, 2021 at 10:10:43AM +0800, Jason Wang wrote:
>> From: Eli Cohen <elic@nvidia.com>
>>
>> Clear the available index as part of the initialization process to
>> clear and values that might be left from previous usage of the device.
>> For example, if the device was previously used by vhost_vdpa and now
>> probed by vhost_vdpa, you want to start with indices.
>>
>> Fixes: c043b4a8cf3b ("virtio: introduce a vDPA based transport")
>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/virtio/virtio_vdpa.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
>> index e28acf482e0c..e1a141135992 100644
>> --- a/drivers/virtio/virtio_vdpa.c
>> +++ b/drivers/virtio/virtio_vdpa.c
>> @@ -142,6 +142,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
>>   	struct vdpa_callback cb;
>>   	struct virtqueue *vq;
>>   	u64 desc_addr, driver_addr, device_addr;
>> +	/* Assume split virtqueue, switch to packed if necessary */
>> +	struct vdpa_vq_state state = {0};
>>   	unsigned long flags;
>>   	u32 align, num;
>>   	int err;
>> @@ -191,6 +193,19 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
>>   		goto err_vq;
>>   	}
>>   
>> +	/* reset virtqueue state index */
>> +	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
>> +		struct vdpa_vq_state_packed *s = &state.packed;
>> +
>> +		s->last_avail_counter = 1;
>> +		s->last_avail_idx = 0;
> It's already 0
>
>> +		s->last_used_counter = 1;
>> +		s->last_used_idx = 0;
> already 0


Yes, but for completeness and make code easy to read, it's no harm to 
keep them I think.

Thanks


>
>> +	}
>> +	err = ops->set_vq_state(vdpa, index, &state);
>> +	if (err)
>> +		goto err_vq;
>> +
>>   	ops->set_vq_ready(vdpa, index, 1);
>>   
>>   	vq->priv = info;
>> -- 
>> 2.25.1
>>

