Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F81F1573
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 11:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgFHJb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 05:31:59 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45355 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728956AbgFHJb6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 05:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591608715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNvKSHGcNFpoKloJv9CTa41fupcZYOPp955NFOVf5iE=;
        b=YIKd5RiKE3vLzHYP5KXroMxs6uKWM8HnY09c6MGt2EM/yH3zXj3YVhxGbYuXvbnDbvS2xa
        RTybprXyaegaU9N+Lq/vW0NWTa8OGFfXWCTXT47E2NvNPnLV0VU12Zr/9aO9xeo00bivUz
        Rw50KieKkiEjrGTe7doLdVrHbfd1tjg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-I8SasRigP0KcXCGEEcpxsg-1; Mon, 08 Jun 2020 05:31:53 -0400
X-MC-Unique: I8SasRigP0KcXCGEEcpxsg-1
Received: by mail-wm1-f69.google.com with SMTP id j128so5013663wmj.6
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 02:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LNvKSHGcNFpoKloJv9CTa41fupcZYOPp955NFOVf5iE=;
        b=mRuM/kz2slIO1Htbmk+lreNy37pMy/69Del2H5xCDYnW63QaJR4MmVjo+A18XosBla
         uNDFP50lxUg0f4LZba+9pINjrWDaPlPPaNdfsJ57osT/KHjnqLLlm7iNU01zPMIryFVf
         mKLle+U5xREGlzKxVUWQvZHKcAJnpxwZ5jjhz+Nvn+wlUWnp662q9uwyz/1cygCA5xsw
         o/Hp6+2h6y/AJ0SksGqEYyuzQvGQzHhs45f09QgeDbie8C/2viMRULYMjLZJobcDC46B
         6G4msPa4ZA+fOzGoGyVIGVqTr/tEf62yiz1fdUD212GW0K1KcZyXYVpNW6y1xnl8mMWd
         +CFA==
X-Gm-Message-State: AOAM532NsCH7GIyMQ6se/POTjK0Ep6MJNTNgY6hNp5OUlHSyimU7uFCU
        IiyYaZtXvQAN3X3XtP0mxXLGAGKvxUqCpys/32V33x5r4fg5gtCvUEtl7a1zZEkOv7h+RStzL1v
        GAVXBN5D+Ai+D
X-Received: by 2002:a1c:2d4b:: with SMTP id t72mr10264718wmt.105.1591608712039;
        Mon, 08 Jun 2020 02:31:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrW5kFnoqZJwp6PoFmC2wBk4W6FEbW+539vCJi8Cp1MLsFQDk07bfCq2UDoydOIUKxhQvvGw==
X-Received: by 2002:a1c:2d4b:: with SMTP id t72mr10264699wmt.105.1591608711808;
        Mon, 08 Jun 2020 02:31:51 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id c65sm22564342wme.8.2020.06.08.02.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 02:31:51 -0700 (PDT)
Date:   Mon, 8 Jun 2020 05:31:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
Message-ID: <20200608052041-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010332-mutt-send-email-mst@kernel.org>
 <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
 <6b1d1ef3-d65e-08c2-5b65-32969bb5ecbc@redhat.com>
 <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 05:18:44PM +0800, Jason Wang wrote:
> 
> On 2020/6/8 下午2:32, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2020 at 11:32:31AM +0800, Jason Wang wrote:
> > > On 2020/6/7 下午9:51, Michael S. Tsirkin wrote:
> > > > On Fri, Jun 05, 2020 at 04:54:17PM +0800, Jason Wang wrote:
> > > > > On 2020/6/2 下午3:08, Jason Wang wrote:
> > > > > > > > +static const struct pci_device_id vp_vdpa_id_table[] = {
> > > > > > > > +    { PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> > > > > > > > +    { 0 }
> > > > > > > > +};
> > > > > > > This looks like it'll create a mess with either virtio pci
> > > > > > > or vdpa being loaded at random. Maybe just don't specify
> > > > > > > any IDs for now. Down the road we could get a
> > > > > > > distinct vendor ID or a range of device IDs for this.
> > > > > > Right, will do.
> > > > > > 
> > > > > > Thanks
> > > > > Rethink about this. If we don't specify any ID, the binding won't work.
> > > > We can bind manually. It's not really for production anyway, so
> > > > not a big deal imho.
> > > 
> > > I think you mean doing it via "new_id", right.
> > I really meant driver_override. This is what people have been using
> > with pci-stub for years now.
> 
> 
> Do you want me to implement "driver_overrid" in this series, or a NULL
> id_table is sufficient?


Doesn't the pci subsystem create driver_override for all devices
on the pci bus?

> 
> > 
> > > > > How about using a dedicated subsystem vendor id for this?
> > > > > 
> > > > > Thanks
> > > > If virtio vendor id is used then standard driver is expected
> > > > to bind, right? Maybe use a dedicated vendor id?
> > > 
> > > I meant something like:
> > > 
> > > static const struct pci_device_id vp_vdpa_id_table[] = {
> > >      { PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID,
> > > VP_TEST_VENDOR_ID, VP_TEST_DEVICE_ID) },
> > >      { 0 }
> > > };
> > > 
> > > Thanks
> > > 
> > Then regular virtio will still bind to it. It has
> > 
> > drivers/virtio/virtio_pci_common.c:     { PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> > 
> > 
> 
> IFCVF use this to avoid the binding to regular virtio device.


Ow. Indeed:

#define IFCVF_VENDOR_ID         0x1AF4

Which is of course not an IFCVF vendor id, it's the Red Hat vendor ID.

I missed that.

Does it actually work if you bind a virtio driver to it?
I'm guessing no otherwise they wouldn't need IFC driver, right?




> Looking at
> pci_match_one_device() it checks both subvendor and subdevice there.
> 
> Thanks


But IIUC there is no guarantee that driver with a specific subvendor
matches in presence of a generic one.
So either IFC or virtio pci can win, whichever binds first.

I guess we need to blacklist IFC in virtio pci probe code. Ugh.

-- 
MST

