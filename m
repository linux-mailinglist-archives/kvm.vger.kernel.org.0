Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8EDAF90F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 11:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfIKJg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 05:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbfIKJg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 05:36:58 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2512793FF
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 09:36:56 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id u17so12560625qkj.7
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 02:36:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Pl8aywfJEsNYEX8Cjmv4sK/xJV1YVyk6NPEurxInDFs=;
        b=E6GfK4S21kfmkGWwbnVUZzK29QcMIBfGfM3YC4jVrSmeIVHAE6SqDM39LkL1RLSqtU
         HUO4cOc+tmH4eHIU3kbIQzIbd189R4HYUnEmql63sh2olr5G14dwmcPV5cVVqFJTXxGA
         XLXDNe++kijpoef18mcv1ZxilI0XC0Bsy/0OWncxMzQoOlE17NPCf49vhbTVpE8doLLR
         EtbI3skDUFN4G9bLlpKTM1+AVdcSQnGPCg1bN3NvWkTwY7OS59J/pKFg519f2sWwcXgt
         fBXkJU9p70M0bsb2MVvPxw513g8z3VoImUo8YbOfehH6rDTw3KN2vyuF5ZXEP8N2VTaB
         LCpw==
X-Gm-Message-State: APjAAAUww87DoGKdQ0jGtATLfxAPXVW81eNtqvqHzIb2VJiZZdIjfpdh
        7edP+E5TFEn4GzoagfTQFGaYKsqmU14RZv8+BNZ/b3vJSRLsc/0oS7CChLIMadq6aHHoLRhX3jp
        dG2UmO4Ot8bdp
X-Received: by 2002:ac8:6b8b:: with SMTP id z11mr25874575qts.294.1568194616185;
        Wed, 11 Sep 2019 02:36:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyduGh4tE6L2L4j9QajV/pYOcnJTIR4z+KJdEnrqU8VS2MoRsYfqeB30DhBJEta8i78v0T5Nw==
X-Received: by 2002:ac8:6b8b:: with SMTP id z11mr25874563qts.294.1568194616000;
        Wed, 11 Sep 2019 02:36:56 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id j7sm13058768qtc.73.2019.09.11.02.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 02:36:55 -0700 (PDT)
Date:   Wed, 11 Sep 2019 05:36:47 -0400
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
Message-ID: <20190911053502-mutt-send-email-mst@kernel.org>
References: <20190910081935.30516-1-jasowang@redhat.com>
 <20190910081935.30516-4-jasowang@redhat.com>
 <20190910055744-mutt-send-email-mst@kernel.org>
 <572ffc34-3081-8503-d3cc-192edc9b5311@redhat.com>
 <20190910094807-mutt-send-email-mst@kernel.org>
 <390647ae-0a53-5f2b-ccb0-28ed657636e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <390647ae-0a53-5f2b-ccb0-28ed657636e6@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 10:38:39AM +0800, Jason Wang wrote:
> 
> On 2019/9/10 下午9:52, Michael S. Tsirkin wrote:
> > On Tue, Sep 10, 2019 at 09:13:02PM +0800, Jason Wang wrote:
> > > On 2019/9/10 下午6:01, Michael S. Tsirkin wrote:
> > > > > +#ifndef _LINUX_VIRTIO_MDEV_H
> > > > > +#define _LINUX_VIRTIO_MDEV_H
> > > > > +
> > > > > +#include <linux/interrupt.h>
> > > > > +#include <linux/vringh.h>
> > > > > +#include <uapi/linux/virtio_net.h>
> > > > > +
> > > > > +/*
> > > > > + * Ioctls
> > > > > + */
> > > > Pls add a bit more content here. It's redundant to state these
> > > > are ioctls. Much better to document what does each one do.
> > > 
> > > Ok.
> > > 
> > > 
> > > > > +
> > > > > +struct virtio_mdev_callback {
> > > > > +	irqreturn_t (*callback)(void *);
> > > > > +	void *private;
> > > > > +};
> > > > > +
> > > > > +#define VIRTIO_MDEV 0xAF
> > > > > +#define VIRTIO_MDEV_SET_VQ_CALLBACK _IOW(VIRTIO_MDEV, 0x00, \
> > > > > +					 struct virtio_mdev_callback)
> > > > > +#define VIRTIO_MDEV_SET_CONFIG_CALLBACK _IOW(VIRTIO_MDEV, 0x01, \
> > > > > +					struct virtio_mdev_callback)
> > > > Function pointer in an ioctl parameter? How does this ever make sense?
> > > 
> > > I admit this is hacky (casting).
> > > 
> > > 
> > > > And can't we use a couple of registers for this, and avoid ioctls?
> > > 
> > > Yes, how about something like interrupt numbers for each virtqueue and
> > > config?
> > Should we just reuse VIRTIO_PCI_COMMON_Q_XXX then?
> 
> 
> You mean something like VIRTIO_PCI_COMMON_Q_MSIX? Then it becomes a PCI
> transport in fact. And using either MSIX or irq number is actually another
> layer of indirection. So I think we can just write callback function and
> parameter through registers.

I just realized, all these registers are just encoded so you
can pass stuff through read/write. But it can instead be
just a normal C function call with no messy encoding.
So why do we want to do this encoding?


> 
> > 
> > 
> > > > > +
> > > > > +#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
> > > > > +
> > > > > +/*
> > > > > + * Control registers
> > > > > + */
> > > > > +
> > > > > +/* Magic value ("virt" string) - Read Only */
> > > > > +#define VIRTIO_MDEV_MAGIC_VALUE		0x000
> > > > > +
> > > > > +/* Virtio device version - Read Only */
> > > > > +#define VIRTIO_MDEV_VERSION		0x004
> > > > > +
> > > > > +/* Virtio device ID - Read Only */
> > > > > +#define VIRTIO_MDEV_DEVICE_ID		0x008
> > > > > +
> > > > > +/* Virtio vendor ID - Read Only */
> > > > > +#define VIRTIO_MDEV_VENDOR_ID		0x00c
> > > > > +
> > > > > +/* Bitmask of the features supported by the device (host)
> > > > > + * (32 bits per set) - Read Only */
> > > > > +#define VIRTIO_MDEV_DEVICE_FEATURES	0x010
> > > > > +
> > > > > +/* Device (host) features set selector - Write Only */
> > > > > +#define VIRTIO_MDEV_DEVICE_FEATURES_SEL	0x014
> > > > > +
> > > > > +/* Bitmask of features activated by the driver (guest)
> > > > > + * (32 bits per set) - Write Only */
> > > > > +#define VIRTIO_MDEV_DRIVER_FEATURES	0x020
> > > > > +
> > > > > +/* Activated features set selector - Write Only */
> > > > > +#define VIRTIO_MDEV_DRIVER_FEATURES_SEL	0x024
> > > > > +
> > > > > +/* Queue selector - Write Only */
> > > > > +#define VIRTIO_MDEV_QUEUE_SEL		0x030
> > > > > +
> > > > > +/* Maximum size of the currently selected queue - Read Only */
> > > > > +#define VIRTIO_MDEV_QUEUE_NUM_MAX	0x034
> > > > > +
> > > > > +/* Queue size for the currently selected queue - Write Only */
> > > > > +#define VIRTIO_MDEV_QUEUE_NUM		0x038
> > > > > +
> > > > > +/* Ready bit for the currently selected queue - Read Write */
> > > > > +#define VIRTIO_MDEV_QUEUE_READY		0x044
> > > > Is this same as started?
> > > 
> > > Do you mean "status"?
> > I really meant "enabled", didn't remember the correct name.
> > As in:  VIRTIO_PCI_COMMON_Q_ENABLE
> 
> 
> Yes, it's the same.
> 
> Thanks
> 
> 
> > 
> > > > > +
> > > > > +/* Alignment of virtqueue - Read Only */
> > > > > +#define VIRTIO_MDEV_QUEUE_ALIGN		0x048
> > > > > +
> > > > > +/* Queue notifier - Write Only */
> > > > > +#define VIRTIO_MDEV_QUEUE_NOTIFY	0x050
> > > > > +
> > > > > +/* Device status register - Read Write */
> > > > > +#define VIRTIO_MDEV_STATUS		0x060
> > > > > +
> > > > > +/* Selected queue's Descriptor Table address, 64 bits in two halves */
> > > > > +#define VIRTIO_MDEV_QUEUE_DESC_LOW	0x080
> > > > > +#define VIRTIO_MDEV_QUEUE_DESC_HIGH	0x084
> > > > > +
> > > > > +/* Selected queue's Available Ring address, 64 bits in two halves */
> > > > > +#define VIRTIO_MDEV_QUEUE_AVAIL_LOW	0x090
> > > > > +#define VIRTIO_MDEV_QUEUE_AVAIL_HIGH	0x094
> > > > > +
> > > > > +/* Selected queue's Used Ring address, 64 bits in two halves */
> > > > > +#define VIRTIO_MDEV_QUEUE_USED_LOW	0x0a0
> > > > > +#define VIRTIO_MDEV_QUEUE_USED_HIGH	0x0a4
> > > > > +
> > > > > +/* Configuration atomicity value */
> > > > > +#define VIRTIO_MDEV_CONFIG_GENERATION	0x0fc
> > > > > +
> > > > > +/* The config space is defined by each driver as
> > > > > + * the per-driver configuration space - Read Write */
> > > > > +#define VIRTIO_MDEV_CONFIG		0x100
> > > > Mixing device and generic config space is what virtio pci did,
> > > > caused lots of problems with extensions.
> > > > It would be better to reserve much more space.
> > > 
> > > I see, will do this.
> > > 
> > > Thanks
> > > 
> > > 
> > > > 
> > > > > +
> > > > > +#endif
> > > > > +
> > > > > +
> > > > > +/* Ready bit for the currently selected queue - Read Write */
> > > > > -- 
> > > > > 2.19.1
