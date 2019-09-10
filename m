Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723E3AEC5B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 15:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfIJNw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 09:52:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfIJNw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 09:52:57 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 07BE659465
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 13:52:56 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id h18so19830811qto.18
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 06:52:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vKjBadJZsVZtUGd3WVckVL2DIAFF4FA1DCNgRycmkBI=;
        b=odkx4MIiYdw9/D3hxsrbPBmiu/ZiDb1+1ll6Qlj1U3pxY0+Vqd9FpsrkzcDGDLnR6h
         /t0ASQ1w8cyjQrLuSRaYyI/bZjcbfBq3UZWntZW4MCno03yZkbvbixywFAxZ28g98dKl
         S2m2TJ+kav5q04CJDr/4KklVaMyoj6WSnzuur26m7Wbfj6hBEtj2b2EuqRXT4LyRDT4R
         BBiG1Z0SUO/sQGD/GB9D1wDNnjG4/zNZ9v6BMfQaH+2X84/eExgC9Z8AGPPHdbC94UXK
         FhCFw/KDDE5XkImMhJ5VtmVVI2lHALJ7UVUZ/Rr1t0tFKAf63l6XBIHYkuvKlg9+VIi8
         fByw==
X-Gm-Message-State: APjAAAW67Xht4u1Yw5B0DR5n2ZBYOUNawlO+KjKAaZO0og1se+9sAC9E
        sHJy4zf3YDCRncwpm2WiL6JMCi5i7d0XPwgLKkvyJrHbgrY4BFHX4PJYkby/urSMgFfAWI2R7Ee
        p8/CU5zqjFvmM
X-Received: by 2002:a0c:e811:: with SMTP id y17mr7641978qvn.68.1568123575198;
        Tue, 10 Sep 2019 06:52:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy87Xk8h9CwEg4tdqy4DXt/JFYQLpQHouOJ6fOEiaMkub6yelg6yVSS11xTwQ5fJFutl2Pk0A==
X-Received: by 2002:a0c:e811:: with SMTP id y17mr7641951qvn.68.1568123574950;
        Tue, 10 Sep 2019 06:52:54 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id n42sm10807604qta.31.2019.09.10.06.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 06:52:53 -0700 (PDT)
Date:   Tue, 10 Sep 2019 09:52:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com,
        cohuck@redhat.com, tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, idos@mellanox.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com
Subject: Re: [RFC PATCH 3/4] virtio: introudce a mdev based transport
Message-ID: <20190910094807-mutt-send-email-mst@kernel.org>
References: <20190910081935.30516-1-jasowang@redhat.com>
 <20190910081935.30516-4-jasowang@redhat.com>
 <20190910055744-mutt-send-email-mst@kernel.org>
 <572ffc34-3081-8503-d3cc-192edc9b5311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <572ffc34-3081-8503-d3cc-192edc9b5311@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 09:13:02PM +0800, Jason Wang wrote:
> 
> On 2019/9/10 下午6:01, Michael S. Tsirkin wrote:
> > > +#ifndef _LINUX_VIRTIO_MDEV_H
> > > +#define _LINUX_VIRTIO_MDEV_H
> > > +
> > > +#include <linux/interrupt.h>
> > > +#include <linux/vringh.h>
> > > +#include <uapi/linux/virtio_net.h>
> > > +
> > > +/*
> > > + * Ioctls
> > > + */
> > Pls add a bit more content here. It's redundant to state these
> > are ioctls. Much better to document what does each one do.
> 
> 
> Ok.
> 
> 
> > 
> > > +
> > > +struct virtio_mdev_callback {
> > > +	irqreturn_t (*callback)(void *);
> > > +	void *private;
> > > +};
> > > +
> > > +#define VIRTIO_MDEV 0xAF
> > > +#define VIRTIO_MDEV_SET_VQ_CALLBACK _IOW(VIRTIO_MDEV, 0x00, \
> > > +					 struct virtio_mdev_callback)
> > > +#define VIRTIO_MDEV_SET_CONFIG_CALLBACK _IOW(VIRTIO_MDEV, 0x01, \
> > > +					struct virtio_mdev_callback)
> > Function pointer in an ioctl parameter? How does this ever make sense?
> 
> 
> I admit this is hacky (casting).
> 
> 
> > And can't we use a couple of registers for this, and avoid ioctls?
> 
> 
> Yes, how about something like interrupt numbers for each virtqueue and
> config?

Should we just reuse VIRTIO_PCI_COMMON_Q_XXX then?


> 
> > 
> > > +
> > > +#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
> > > +
> > > +/*
> > > + * Control registers
> > > + */
> > > +
> > > +/* Magic value ("virt" string) - Read Only */
> > > +#define VIRTIO_MDEV_MAGIC_VALUE		0x000
> > > +
> > > +/* Virtio device version - Read Only */
> > > +#define VIRTIO_MDEV_VERSION		0x004
> > > +
> > > +/* Virtio device ID - Read Only */
> > > +#define VIRTIO_MDEV_DEVICE_ID		0x008
> > > +
> > > +/* Virtio vendor ID - Read Only */
> > > +#define VIRTIO_MDEV_VENDOR_ID		0x00c
> > > +
> > > +/* Bitmask of the features supported by the device (host)
> > > + * (32 bits per set) - Read Only */
> > > +#define VIRTIO_MDEV_DEVICE_FEATURES	0x010
> > > +
> > > +/* Device (host) features set selector - Write Only */
> > > +#define VIRTIO_MDEV_DEVICE_FEATURES_SEL	0x014
> > > +
> > > +/* Bitmask of features activated by the driver (guest)
> > > + * (32 bits per set) - Write Only */
> > > +#define VIRTIO_MDEV_DRIVER_FEATURES	0x020
> > > +
> > > +/* Activated features set selector - Write Only */
> > > +#define VIRTIO_MDEV_DRIVER_FEATURES_SEL	0x024
> > > +
> > > +/* Queue selector - Write Only */
> > > +#define VIRTIO_MDEV_QUEUE_SEL		0x030
> > > +
> > > +/* Maximum size of the currently selected queue - Read Only */
> > > +#define VIRTIO_MDEV_QUEUE_NUM_MAX	0x034
> > > +
> > > +/* Queue size for the currently selected queue - Write Only */
> > > +#define VIRTIO_MDEV_QUEUE_NUM		0x038
> > > +
> > > +/* Ready bit for the currently selected queue - Read Write */
> > > +#define VIRTIO_MDEV_QUEUE_READY		0x044
> > Is this same as started?
> 
> 
> Do you mean "status"?

I really meant "enabled", didn't remember the correct name.
As in:  VIRTIO_PCI_COMMON_Q_ENABLE

> 
> > 
> > > +
> > > +/* Alignment of virtqueue - Read Only */
> > > +#define VIRTIO_MDEV_QUEUE_ALIGN		0x048
> > > +
> > > +/* Queue notifier - Write Only */
> > > +#define VIRTIO_MDEV_QUEUE_NOTIFY	0x050
> > > +
> > > +/* Device status register - Read Write */
> > > +#define VIRTIO_MDEV_STATUS		0x060
> > > +
> > > +/* Selected queue's Descriptor Table address, 64 bits in two halves */
> > > +#define VIRTIO_MDEV_QUEUE_DESC_LOW	0x080
> > > +#define VIRTIO_MDEV_QUEUE_DESC_HIGH	0x084
> > > +
> > > +/* Selected queue's Available Ring address, 64 bits in two halves */
> > > +#define VIRTIO_MDEV_QUEUE_AVAIL_LOW	0x090
> > > +#define VIRTIO_MDEV_QUEUE_AVAIL_HIGH	0x094
> > > +
> > > +/* Selected queue's Used Ring address, 64 bits in two halves */
> > > +#define VIRTIO_MDEV_QUEUE_USED_LOW	0x0a0
> > > +#define VIRTIO_MDEV_QUEUE_USED_HIGH	0x0a4
> > > +
> > > +/* Configuration atomicity value */
> > > +#define VIRTIO_MDEV_CONFIG_GENERATION	0x0fc
> > > +
> > > +/* The config space is defined by each driver as
> > > + * the per-driver configuration space - Read Write */
> > > +#define VIRTIO_MDEV_CONFIG		0x100
> > Mixing device and generic config space is what virtio pci did,
> > caused lots of problems with extensions.
> > It would be better to reserve much more space.
> 
> 
> I see, will do this.
> 
> Thanks
> 
> 
> > 
> > 
> > > +
> > > +#endif
> > > +
> > > +
> > > +/* Ready bit for the currently selected queue - Read Write */
> > > -- 
> > > 2.19.1
