Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32523143814
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 09:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAUIP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 03:15:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57408 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726729AbgAUIP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 03:15:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579594555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDZZx/Gnj5ZRM82WjxYSmYyaFueti+mk2d2ohpv+jeI=;
        b=YSlJP+OuHEsfvx0Qe2cYsmzBSL9sRbJbG8j7AbIn0+2OeG0juRr6le7jYZxtUzeiJy8HHd
        eg3dC25id+/aPD4QYhaa8CibBHkMpDfOUD3cuXPbNR1uY6Z22bgboDlzByLy4qq4KL+LOI
        g6y84rSSPPqNypEbuTwxt8lTiMDSF6o=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-7hrXMzzJP6-If3kMMiPJAw-1; Tue, 21 Jan 2020 03:15:54 -0500
X-MC-Unique: 7hrXMzzJP6-If3kMMiPJAw-1
Received: by mail-qt1-f198.google.com with SMTP id b7so1375234qtg.23
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 00:15:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LDZZx/Gnj5ZRM82WjxYSmYyaFueti+mk2d2ohpv+jeI=;
        b=JNH0CxYGElgz4UkJfR3ZTQoX2WyUKMdbrXhUI234/95ChBjmVMeMQgvO7MJTlcophY
         mbBX5BK/kLrD+xT0qG5hWAfOGNje5Xli3BfsDbFtta/SLjn9A0+xBoIjJ5ag52lBANj4
         4qh69Ffd+09zzhye5ZQLEdj2KoglVCek3N/CdFxhksMNc6/dhCB5ZKl5CyOQvCbSxHRJ
         K8/8D0tvmJ+ZYa3lEgC+zkue0Hz62AsrI8Lo5uCYArlTX23iT15KwKXAf8bXkhxAy+IO
         6ntCgL9OTZv4UQdI22mT6tElD8pe1Wk3sQsWhB9JlW6YNeFisrj4nK39i8NrpKq6R1IW
         /a9Q==
X-Gm-Message-State: APjAAAVqTUmgNDYE1WkL8pdTUGiFNjdvUiYZGX0ExbOda3sjxtt13qPO
        zP9E9ZHt21hPX272on8MghKzGqoeGYiCD/L6dS6M+DBBrYefZgsm3gjvSpR2Q+0qD4dL6cW3Xzn
        LOfao82y5X6Fe
X-Received: by 2002:a37:4792:: with SMTP id u140mr3527893qka.100.1579594553679;
        Tue, 21 Jan 2020 00:15:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdkjBVx/UGOKVK94Xs4SyAvooIxcojAHiVS5/OG5oUdaH/4DoRhuXXCGIK/jBUqS0IK043lw==
X-Received: by 2002:a37:4792:: with SMTP id u140mr3527856qka.100.1579594553353;
        Tue, 21 Jan 2020 00:15:53 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id z3sm18825316qtm.5.2020.01.21.00.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 00:15:52 -0800 (PST)
Date:   Tue, 21 Jan 2020 03:15:43 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Message-ID: <20200121031506-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <2a324cec-2863-58f4-c58a-2414ee32c930@redhat.com>
 <20200121004047-mutt-send-email-mst@kernel.org>
 <b9ad744e-c4cd-82f9-f56a-1ecc185e9cd7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9ad744e-c4cd-82f9-f56a-1ecc185e9cd7@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 04:00:38PM +0800, Jason Wang wrote:
> 
> On 2020/1/21 下午1:47, Michael S. Tsirkin wrote:
> > On Tue, Jan 21, 2020 at 12:00:57PM +0800, Jason Wang wrote:
> > > On 2020/1/21 上午1:49, Jason Gunthorpe wrote:
> > > > On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> > > > > This is similar to the design of platform IOMMU part of vhost-vdpa. We
> > > > > decide to send diffs to platform IOMMU there. If it's ok to do that in
> > > > > driver, we can replace set_map with incremental API like map()/unmap().
> > > > > 
> > > > > Then driver need to maintain rbtree itself.
> > > > I think we really need to see two modes, one where there is a fixed
> > > > translation without dynamic vIOMMU driven changes and one that
> > > > supports vIOMMU.
> > > 
> > > I think in this case, you meant the method proposed by Shahaf that sends
> > > diffs of "fixed translation" to device?
> > > 
> > > It would be kind of tricky to deal with the following case for example:
> > > 
> > > old map [4G, 16G) new map [4G, 8G)
> > > 
> > > If we do
> > > 
> > > 1) flush [4G, 16G)
> > > 2) add [4G, 8G)
> > > 
> > > There could be a window between 1) and 2).
> > > 
> > > It requires the IOMMU that can do
> > > 
> > > 1) remove [8G, 16G)
> > > 2) flush [8G, 16G)
> > > 3) change [4G, 8G)
> > > 
> > > ....
> > Basically what I had in mind is something like qemu memory api
> > 
> > 0. begin
> > 1. remove [8G, 16G)
> > 2. add [4G, 8G)
> > 3. commit
> 
> 
> This sounds more flexible e.g driver may choose to implement static mapping
> one through commit. But a question here, it looks to me this still requires
> the DMA to be synced with at least commit here. Otherwise device may get DMA
> fault? Or device is expected to be paused DMA during begin?
> 
> Thanks

For example, commit might switch one set of tables for another,
without need to pause DMA.

> 
> > 
> > Anyway, I'm fine with a one-shot API for now, we can
> > improve it later.
> > 
> > > > There are different optimization goals in the drivers for these two
> > > > configurations.
> > > > 
> > > > > > If the first one, then I think memory hotplug is a heavy flow
> > > > > > regardless. Do you think the extra cycles for the tree traverse
> > > > > > will be visible in any way?
> > > > > I think if the driver can pause the DMA during the time for setting up new
> > > > > mapping, it should be fine.
> > > > This is very tricky for any driver if the mapping change hits the
> > > > virtio rings. :(
> > > > 
> > > > Even a IOMMU using driver is going to have problems with that..
> > > > 
> > > > Jason
> > > 
> > > Or I wonder whether ATS/PRI can help here. E.g during I/O page fault,
> > > driver/device can wait for the new mapping to be set and then replay the
> > > DMA.
> > > 
> > > Thanks
> > > 
> > 

