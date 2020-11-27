Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1512C2C68B6
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 16:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbgK0P3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 10:29:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729344AbgK0P3K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 10:29:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606490948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oXKdmvLkDWwHXIC1vCfXtPKtHEwtoC4CPS+KvE2OLhs=;
        b=AjAXuczT5MLVwZMNhZrrrMknP7FLdUrtzRa+iy2V4ADQXi8CCur7twE61a4Gx6OWu/HONq
        hIdEBQnZb9cVZL50SNkLazautqd/vUwPw/HghbGfbDg/CeYNbt6UZzABV0VDFhgiOgKeTV
        LxWG8NsSFQb6fQhw+E7D8sIdNAGpTz8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-uITk0hcoNHGrd3pF5pjkRg-1; Fri, 27 Nov 2020 10:29:06 -0500
X-MC-Unique: uITk0hcoNHGrd3pF5pjkRg-1
Received: by mail-wm1-f69.google.com with SMTP id k128so3327903wme.7
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 07:29:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oXKdmvLkDWwHXIC1vCfXtPKtHEwtoC4CPS+KvE2OLhs=;
        b=Oq7ZmdAGx1balzqFa+7KNZieXp+OX8w2cM7V5GvE8J6HBMC2c/uSCPy8rS+BCzJ0qN
         m6CdJN7Acx7UUwE7bFdd+j5v9V5DrKRu6f5x7qTjFFwSklK9kOwvohuFo/EB0CMGXwem
         ojRnX6p52mndmK9G1+GJE2HqgmrYjgEjiifytoVkNhCwQeYFM19QKf9RdUsrjxwOUx0o
         xmOWH3r4WRF+HMjK3TPwHUJUKLrI+gcyH1d7LUB5QWYkfIzV41gDGShsXCEphGdXnwIY
         cbongw+qsNvm/gEQl6G2fu51cd6TSF1zlrfQ3dPxYC9OpvhmLM58h9ClwfbReiBxPlmU
         jHBw==
X-Gm-Message-State: AOAM530RJWcsN4rNlkKcG9qMGowb67+/04vOcBIcx+P4KK8BN44en5RS
        Rmmq5VOqQBqEqr0zTz8udOjb+qIbsWmG3JPpZcLPofP5ruPFxry8iqfzT1o3iKSl9XarSLsX498
        93L65YW7A8tOA
X-Received: by 2002:a5d:67c5:: with SMTP id n5mr11453730wrw.179.1606490945471;
        Fri, 27 Nov 2020 07:29:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/4cCpUXCG3PtHNxRVLUGmUfj2FFttkpnXAUAHHS8uWedyJzj98T7fAMDHerVy+9j1MoYo4Q==
X-Received: by 2002:a5d:67c5:: with SMTP id n5mr11453684wrw.179.1606490945268;
        Fri, 27 Nov 2020 07:29:05 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id d3sm14667103wrr.2.2020.11.27.07.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 07:29:04 -0800 (PST)
Date:   Fri, 27 Nov 2020 16:29:01 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: Re: [RFC PATCH 23/27] vhost: unmap qemu's shadow virtqueues on sw
 live migration
Message-ID: <20201127152901.cbfu7rmewbxventr@steredhat>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-24-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201120185105.279030-24-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 07:51:01PM +0100, Eugenio Pérez wrote:
>Since vhost does not need to access it, it has no sense to keep it
>mapped.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> hw/virtio/vhost.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>index f640d4edf0..eebfac4455 100644
>--- a/hw/virtio/vhost.c
>+++ b/hw/virtio/vhost.c
>@@ -1124,6 +1124,7 @@ static int vhost_sw_live_migration_start(struct vhost_dev *dev)
>
>         dev->sw_lm_shadow_vq[idx] = vhost_sw_lm_shadow_vq(dev, idx);
>         event_notifier_set_handler(&vq->masked_notifier, vhost_handle_call);
>+        vhost_virtqueue_memory_unmap(dev, &dev->vqs[idx], true);

IIUC vhost_virtqueue_memory_unmap() is already called at the end of 
vhost_virtqueue_stop(), so we can skip this call, right?

>
>         vhost_vring_write_addr(dev->sw_lm_shadow_vq[idx], &addr);
>         r = dev->vhost_ops->vhost_set_vring_addr(dev, &addr);
>-- 2.18.4
>

