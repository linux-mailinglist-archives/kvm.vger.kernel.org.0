Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE6530EDF3
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 09:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhBDIEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 03:04:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230252AbhBDIDy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 03:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612425749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PC2k5DsAuAqCMx4jOECaSWHG2jS+sWcLS4PYn2OqsJo=;
        b=G+B1RhgVBFBaRjPu7z4O+DKoyeW8Kz1tdSTRN3xiAhOt5Vw/RSliYpeLqKI3GTBLi0yes0
        78jxO/w1ul3+8IokVBFrM5IRX1+eYPr0oWCOxrt0+4QCiO95cdw4MnQvXvx0deGXDM08ya
        PsmgIg1EdM/ziRX0WLaNZ/zI3xYeAGE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-_9ZQN8EMNX-QDHz0dmW58A-1; Thu, 04 Feb 2021 03:02:27 -0500
X-MC-Unique: _9ZQN8EMNX-QDHz0dmW58A-1
Received: by mail-wr1-f71.google.com with SMTP id u3so2161886wri.19
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 00:02:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PC2k5DsAuAqCMx4jOECaSWHG2jS+sWcLS4PYn2OqsJo=;
        b=rJ5ZCM4J6HCcT1vfQPDOuumreumX3b6Ra9crZhIQOEMCN/rFCBI+1tUeHpVKF+PvFA
         zqCFaYPin464TaeW+Q2bnrfoLX0d88cx4TgGKg8LwnkD9RNjDWTTAIQk9fEPN13X0nRl
         wDt6RkPm7w58ld/oofa+SULhxjniFvoiMwm50hLrAxdslJCFgAWE5yTndwFbDixlTez9
         iV3R9j0U0Tdeaw7pSzVU8uJzfh14rlCiydNsgPWhNiISP5DYcyRIEUt9bE2eBvDzUkgr
         85dax5lkmpfrBU0m8OhibxGqjIS0MNzP7YX33TKTP2TQkgEMQXWNhKKGiEm1x7NzJ4D4
         WG4g==
X-Gm-Message-State: AOAM531iNdRTo7jxIlP5zkpHXCSlFIwZgl0q0zpO3/IbRuLia+vQX3ta
        3hitEGVqJVuZAIHkF5JD2WUCLuczGiZ+IY8jtV/k/X3TUb8RozLbhnXouPc2H8n3W65TAyTgAtT
        xmeLCfrdWAEoF
X-Received: by 2002:a05:6000:143:: with SMTP id r3mr7724283wrx.357.1612425746493;
        Thu, 04 Feb 2021 00:02:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXSUXbbv7QIsSZCrVyfKN0nNnYLUHVULTKkCXlHYVs3OM4HtjhG+7SaPYaWtGCw0U0TLO6MA==
X-Received: by 2002:a05:6000:143:: with SMTP id r3mr7724253wrx.357.1612425746232;
        Thu, 04 Feb 2021 00:02:26 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id c9sm5443636wmb.33.2021.02.04.00.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 00:02:25 -0800 (PST)
Date:   Thu, 4 Feb 2021 09:02:23 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 08/10] vdpa: add vdpa simulator for block device
Message-ID: <20210204080223.rkc7zieq34ofs5ku@steredhat>
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-9-sgarzare@redhat.com>
 <20210202093412.GA243557@stefanha-x1.localdomain>
 <20210202154950.g3rclpigyaigzfgo@steredhat>
 <20210203164551.GG74271@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210203164551.GG74271@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 04:45:51PM +0000, Stefan Hajnoczi wrote:
>On Tue, Feb 02, 2021 at 04:49:50PM +0100, Stefano Garzarella wrote:
>> On Tue, Feb 02, 2021 at 09:34:12AM +0000, Stefan Hajnoczi wrote:
>> > On Thu, Jan 28, 2021 at 03:41:25PM +0100, Stefano Garzarella wrote:
>> > > +static void vdpasim_blk_work(struct work_struct *work)
>> > > +{
>> > > +	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
>> > > +	u8 status = VIRTIO_BLK_S_OK;
>> > > +	int i;
>> > > +
>> > > +	spin_lock(&vdpasim->lock);
>> > > +
>> > > +	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>> > > +		goto out;
>> > > +
>> > > +	for (i = 0; i < VDPASIM_BLK_VQ_NUM; i++) {
>> > > +		struct vdpasim_virtqueue *vq = &vdpasim->vqs[i];
>> > > +
>> > > +		if (!vq->ready)
>> > > +			continue;
>> > > +
>> > > +		while (vringh_getdesc_iotlb(&vq->vring, &vq->out_iov,
>> > > +					    &vq->in_iov, &vq->head,
>> > > +					    GFP_ATOMIC) > 0) {
>> > > +			int write;
>> > > +
>> > > +			vq->in_iov.i = vq->in_iov.used - 1;
>> > > +			write = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
>> > > +						      &status, 1);
>> > > +			if (write <= 0)
>> > > +				break;
>> >
>> > This code looks fragile:
>> >
>> > 1. Relying on unsigned underflow and the while loop in
>> >   vringh_iov_push_iotlb() to handle the case where in_iov.used == 0 is
>> >   risky and could break.
>> >
>> > 2. Does this assume that the last in_iov element has size 1? For
>> >   example, the guest driver may send a single "in" iovec with size 513
>> >   when reading 512 bytes (with an extra byte for the request status).
>> >
>> > Please validate inputs fully, even in test/development code, because
>> > it's likely to be copied by others when writing production code (or
>> > deployed in production by unsuspecting users) :).
>>
>> Perfectly agree on that, so I addressed these things, also following your
>> review on the previous version, on the next patch of this series:
>> "vdpa_sim_blk: implement ramdisk behaviour".
>>
>> Do you think should I move these checks in this patch?
>>
>> I did this to leave Max credit for this patch and add more code to emulate a
>> ramdisk in later patches.
>
>You could update the commit description so it's clear that input
>validation is missing and will be added in the next commit.

I'll do it.

Thanks,
Stefano

