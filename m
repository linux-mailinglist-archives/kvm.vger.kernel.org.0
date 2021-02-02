Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6330C46E
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 16:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbhBBPvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 10:51:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235792AbhBBPvX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 10:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612280996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xl3UYgDrwSAlvWw9aAeOlF3n/HRosBCyWycSbwiVnos=;
        b=KwyWQHwu9BSdQmFFmFK2HkQZS7inr2mcn5GE5v1SmZrCbUxQaQFZxzPoHJNPz2MqI360vK
        +AQHLyQBF8KMiLWNwmPwYQUvYIPo8X1ZkynVrR05va/IDMAdWKqfstl4Ts/jfwbkts8PNA
        ju6Vp19GaR1j1cvKxsZ7TrymB7Ro1pI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-VWGtt9MPPHacU3HZ5AnOSw-1; Tue, 02 Feb 2021 10:49:55 -0500
X-MC-Unique: VWGtt9MPPHacU3HZ5AnOSw-1
Received: by mail-wm1-f72.google.com with SMTP id n17so1130648wmk.3
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 07:49:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xl3UYgDrwSAlvWw9aAeOlF3n/HRosBCyWycSbwiVnos=;
        b=Zpw2bqdCBAvWEO6pfxs6/WpaKcZEKhvKFL7mGdnqGGJm06zwkHtgOJSYjPkL55RPuT
         KLGd5gslwdQLbXciorQEHpRHwEpH1+4DMRZshiYS7LQCGR5XMtz4Mw5KP/6ojkZMHAwK
         4OS8lNtQM1Oba0ZT75lCUtlEOQuxMhhF+tsVy2sj6fy4MgscM2+l4vysGGKwkqeKONTs
         ViEA5Kfrv5pOsoFANmqadZePoSv/hq90pBnX1XVng1tGUIa53tVtBIGgYn7dTl1IrTee
         lh2Gas8/sYtjoT9Gig1HnoZoIKdh3nvMW3EAfkMRzTjDVjR+UKdv9/PxqU5pyjTgKIt2
         1OkA==
X-Gm-Message-State: AOAM530/ggZqygoujj/7BxDtWUgA2l30sGxOh17+dRt9tuNyBHZ1vUJV
        lcjLvDCMSFR18eJYpo1Cb7hbSkAJ87uWUL1H/FDmQ3Nwv2B8ED39jAloo4eefUpN9z1fHns8ubo
        qPxwnw8Xc1Yw4
X-Received: by 2002:a05:600c:4f0d:: with SMTP id l13mr4266398wmq.92.1612280993773;
        Tue, 02 Feb 2021 07:49:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWu4WNYzB77YBRASb1WGMExDKDUMNYTw6v09BmpngKIZyogm2i5LC52DUiZnh7HxS460FjEg==
X-Received: by 2002:a05:600c:4f0d:: with SMTP id l13mr4266379wmq.92.1612280993532;
        Tue, 02 Feb 2021 07:49:53 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id f17sm34650125wrv.0.2021.02.02.07.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 07:49:52 -0800 (PST)
Date:   Tue, 2 Feb 2021 16:49:50 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 08/10] vdpa: add vdpa simulator for block device
Message-ID: <20210202154950.g3rclpigyaigzfgo@steredhat>
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-9-sgarzare@redhat.com>
 <20210202093412.GA243557@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210202093412.GA243557@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 09:34:12AM +0000, Stefan Hajnoczi wrote:
>On Thu, Jan 28, 2021 at 03:41:25PM +0100, Stefano Garzarella wrote:
>> +static void vdpasim_blk_work(struct work_struct *work)
>> +{
>> +	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
>> +	u8 status = VIRTIO_BLK_S_OK;
>> +	int i;
>> +
>> +	spin_lock(&vdpasim->lock);
>> +
>> +	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>> +		goto out;
>> +
>> +	for (i = 0; i < VDPASIM_BLK_VQ_NUM; i++) {
>> +		struct vdpasim_virtqueue *vq = &vdpasim->vqs[i];
>> +
>> +		if (!vq->ready)
>> +			continue;
>> +
>> +		while (vringh_getdesc_iotlb(&vq->vring, &vq->out_iov,
>> +					    &vq->in_iov, &vq->head,
>> +					    GFP_ATOMIC) > 0) {
>> +			int write;
>> +
>> +			vq->in_iov.i = vq->in_iov.used - 1;
>> +			write = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
>> +						      &status, 1);
>> +			if (write <= 0)
>> +				break;
>
>This code looks fragile:
>
>1. Relying on unsigned underflow and the while loop in
>   vringh_iov_push_iotlb() to handle the case where in_iov.used == 0 is
>   risky and could break.
>
>2. Does this assume that the last in_iov element has size 1? For
>   example, the guest driver may send a single "in" iovec with size 513
>   when reading 512 bytes (with an extra byte for the request status).
>
>Please validate inputs fully, even in test/development code, because
>it's likely to be copied by others when writing production code (or
>deployed in production by unsuspecting users) :).

Perfectly agree on that, so I addressed these things, also following 
your review on the previous version, on the next patch of this series:
"vdpa_sim_blk: implement ramdisk behaviour".

Do you think should I move these checks in this patch?

I did this to leave Max credit for this patch and add more code to 
emulate a ramdisk in later patches.

Thanks,
Stefano

