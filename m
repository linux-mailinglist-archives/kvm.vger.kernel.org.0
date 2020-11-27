Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D93C2C68E6
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 16:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgK0PoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 10:44:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730786AbgK0PoP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 10:44:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606491853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ZMptySEVF+qxp46nt0WeS28nH29hpHOpjHUabFK4vI=;
        b=G+ZZ2yGeHe94Ovp99d81RtDqsN4sBLS/WGTHHAzNlmiqbY2UWnzA+3vSVzM9fzl6FECTC6
        nSlg+3G1pb3Rz8puyrl5HNKQ78LS64kvJPeakgkcmspkkjpI/Rm5ZliOD4KBR4zvIuiaOi
        7nuVftcGenfoSq3tjs+s4vyKao2tFx0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-LoScb7WXNrGHc-Gmh-z41A-1; Fri, 27 Nov 2020 10:44:10 -0500
X-MC-Unique: LoScb7WXNrGHc-Gmh-z41A-1
Received: by mail-wr1-f71.google.com with SMTP id c8so3621117wrh.16
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 07:44:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7ZMptySEVF+qxp46nt0WeS28nH29hpHOpjHUabFK4vI=;
        b=CfZr808RamZAktZ0oNCLFjLwzcH94yQ0qX9mmjcgEDyiCDt3l3eLkPLL7TyskQvjVF
         dTWuNBiV5f+OU8a6KI85qu9q8u1yOVAN5rO9jgMlODR+Nf3j6yRr21KpS7UgcjooFp70
         3v+KrPcIZUz6HTYbTif/8itacLV4NSw/Yv/cA9tyQmbs0hT7768SeB9nYG8UccUDQhmV
         zcInooP3EKJkFWKPl01FbOAjdLzHEmBt5xy3MhVWauX19HyzVUxhYp7htXT8FPOfAxQL
         h+1UX4rsVSsP0nqlk6q82umdzIW+mjE+X1TLGHE/X57Qaj51YrYb/jTkWH0C7gp5UM4s
         NmJQ==
X-Gm-Message-State: AOAM530RyoHbFF9uoKqCeRHin/ZyBHs4vO6VbK/OnTo8CzeZbGWn1nYa
        cQUxj8bEIpIKe1CbNZi9/gjsMvDNhRSMQgi40H88MHRgFZLCmcaTauGf1NZsRQeZtcWB1+tuQyu
        VZWWZfYQHzon0
X-Received: by 2002:a1c:1982:: with SMTP id 124mr9831260wmz.74.1606491849338;
        Fri, 27 Nov 2020 07:44:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytxW8ZnvAV68ZiceF5w4J07tAVGsS+GFr6oOgADr9NuCD3xPvI6HRJ+H6eMt9FwWNO3X7TYw==
X-Received: by 2002:a1c:1982:: with SMTP id 124mr9831237wmz.74.1606491849069;
        Fri, 27 Nov 2020 07:44:09 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id p19sm16051757wrg.18.2020.11.27.07.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 07:44:08 -0800 (PST)
Date:   Fri, 27 Nov 2020 16:44:05 +0100
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
Subject: Re: [RFC PATCH 00/27] vDPA software assisted live migration
Message-ID: <20201127154405.uobkujyhd7fuv7nx@steredhat>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 07:50:38PM +0100, Eugenio Pérez wrote:
>This series enable vDPA software assisted live migration for vhost-net
>devices. This is a new method of vhost devices migration: Instead of
>relay on vDPA device's dirty logging capability, SW assisted LM
>intercepts dataplane, forwarding the descriptors between VM and device.
>
>In this migration mode, qemu offers a new vring to the device to
>read and write into, and disable vhost notifiers, processing guest and
>vhost notifications in qemu. On used buffer relay, qemu will mark the
>dirty memory as with plain virtio-net devices. This way, devices does
>not need to have dirty page logging capability.
>
>This series is a POC doing SW LM for vhost-net devices, which already
>have dirty page logging capabilities. None of the changes have actual
>effect with current devices until last two patches (26 and 27) are
>applied, but they can be rebased on top of any other. These checks the
>device to meet all requirements, and disable vhost-net devices logging
>so migration goes through SW LM. This last patch is not meant to be
>applied in the final revision, it is in the series just for testing
>purposes.
>
>For use SW assisted LM these vhost-net devices need to be instantiated:
>* With IOMMU (iommu_platform=on,ats=on)
>* Without event_idx (event_idx=off)
>
>Just the notification forwarding (with no descriptor relay) can be
>achieved with patches 7 and 9, and starting migration. Partial applies
>between 13 and 24 will not work while migrating on source, and patch
>25 is needed for the destination to resume network activity.
>
>It is based on the ideas of DPDK SW assisted LM, in the series of
>DPDK's https://patchwork.dpdk.org/cover/48370/ .
>
>Comments are welcome.

Hi Eugenio,
I took a look and the idea of the shadow queue I think is the right way.
It's very similar to what we thought with Stefan for io_uring 
passthrough and vdpa-blk.

IIUC, when the migrations starts, the notifications from the guest to 
vhost are disabled, so QEMU starts to intercept them through the 
custom_handler installed in virtio-net (we need to understand how to 
generalize this).
At this point QEMU starts to use the shadows queues and exposes them to 
vhost.
The opposite is done for vhost to guest notifications, where 
vhost_handle_call is installed to masked_notifier to intercept the 
notification.

I hope to give better feedback when I get a complete overview ;-)

Anyway, as Jason suggested, we should split this series, so maybe we can 
merge some preparations patches (e.g. 1, 11, 21, 22) regardless the 
other patches.

Thanks,
Stefano

