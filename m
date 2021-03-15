Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB1E33C357
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 18:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhCORGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 13:06:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234621AbhCORGN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 13:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615827972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J/vGkdsnQYAk+OhLsLeLAuUC9tdXLy1WCBIdxzujSVI=;
        b=X+GpsOWsgmKVOoIpjJfKLLpA5ZjVfuwrHDnqjrWQsQ/4QLkP3hFJrya8dDJ8ivvVxq6SxW
        mLDYQhiPFAsNCw6M91WfRzZtlLvsnDaaLYqk36HsR+hilvtIMnfDWov/DlI80cmUrfrxiM
        BN85rxxL/pkqwSqjbWBzoCCdRblB2HM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-ltupJhzgMg-LyfQOOHLbqg-1; Mon, 15 Mar 2021 13:06:11 -0400
X-MC-Unique: ltupJhzgMg-LyfQOOHLbqg-1
Received: by mail-wr1-f71.google.com with SMTP id i5so15365894wrp.8
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 10:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J/vGkdsnQYAk+OhLsLeLAuUC9tdXLy1WCBIdxzujSVI=;
        b=CPO0Wut0Cb7U6AYrpjG1hmZCuXNBGoR/pB9Oj/ImKf624awzWX0aYJuCI/F13pkNKz
         H5qv0qmhnT0l/VMlNkDY5mMd1Wz7h5yLKYcgKmq0FIgA7STqM8+5oSi58zw53FdDnkop
         qpkjeMBIilNN2GXqRX8QUtlsC1U/W3xmDk3IW+5hqPbSOsdPWxVFwTlhoCIH64k8oG4a
         WGoARJlhTSyejfTkqy/c+3q8mhaTMM7TPhwAR7aKcketlH524HAwrz2YfkJ7x0rVyoT1
         ihz2J+SWwso8DcKzJrp5+2FIz9M22iqqAgJA/FGyI3TJL6RgWqNau8WI/bVtcRsIcpHB
         OxzQ==
X-Gm-Message-State: AOAM530k9E6J/YU/miqvjKkcDFo9w7qfxe+2Rcyu6kwcL3f4K9ZbYfq7
        CCoJffM9g35b8p2D9QDxstwCXQeWLi6tnWEn5DDPUoP4lz2MqNnqdjSMQdYoE+QEXc8upc3d94/
        NE3SQ+Q/KB78+
X-Received: by 2002:adf:fb05:: with SMTP id c5mr661763wrr.302.1615827970006;
        Mon, 15 Mar 2021 10:06:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzB2RlJqBtvYUnzW0bm+UEON3/wM1HGbq8FitDx5F3L0+jguIDUzug5Ca5xtj3gBuGabiQNOw==
X-Received: by 2002:adf:fb05:: with SMTP id c5mr661748wrr.302.1615827969836;
        Mon, 15 Mar 2021 10:06:09 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id l22sm19448508wrb.4.2021.03.15.10.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 10:06:09 -0700 (PDT)
Date:   Mon, 15 Mar 2021 18:06:07 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 06/14] vringh: add vringh_kiov_length() helper
Message-ID: <20210315170607.3lajkedzkxa4elmr@steredhat>
References: <20210315163450.254396-1-sgarzare@redhat.com>
 <20210315163450.254396-7-sgarzare@redhat.com>
 <b06eb44c-d4e5-e47c-fbf5-26be469aae9e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b06eb44c-d4e5-e47c-fbf5-26be469aae9e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021 at 05:51:30PM +0100, Laurent Vivier wrote:
>On 15/03/2021 17:34, Stefano Garzarella wrote:
>> This new helper returns the total number of bytes covered by
>> a vringh_kiov.
>>
>> Suggested-by: Jason Wang <jasowang@redhat.com>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  include/linux/vringh.h | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
>> index 755211ebd195..84db7b8f912f 100644
>> --- a/include/linux/vringh.h
>> +++ b/include/linux/vringh.h
>> @@ -199,6 +199,17 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
>>  	kiov->iov = NULL;
>>  }
>>
>> +static inline size_t vringh_kiov_length(struct vringh_kiov *kiov)
>> +{
>> +	size_t len = 0;
>> +	int i;
>> +
>> +	for (i = kiov->i; i < kiov->used; i++)
>> +		len += kiov->iov[i].iov_len;
>> +
>> +	return len;
>> +}
>
>Do we really need an helper?
>
>For instance, we can use:
>
>len = iov_length((struct iovec *)kiov->iov, kiov->used);
>
>Or do we want to avoid the cast?

Yes, that should be fine. If we want, I can remove the helper and use 
iov_length() directly. I thought vringh wanted to hide iovec from users 
though.

Anyway talking to Jason, as a long term solution we should reconsider 
vringh and support iov_iter.

Thanks,
Stefano

