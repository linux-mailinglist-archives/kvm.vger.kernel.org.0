Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BE7143362
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 22:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgATVZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 16:25:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726607AbgATVZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 16:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579555536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9l++3OuyTlK7LXp5Mq/OwpRSmGcumz9fcGOybYboMEQ=;
        b=PwoSQFD37XCoWdHLcxkngtwb8sM/gT5FpvlxGBzrrZ22VuvdE8/q4rbMUL+JleUtmOTzlg
        tGRX0s2u8XIqY8sHHZkcNF94LYKLtqZmGYOxaZrUTrlTF3yUbsTQZ8dnAXD5CffySDLgeu
        K+LXqjrxvzpwU3kpZVEXGvPH+u58d0I=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-osO99w3cOAGGyEQfDSkNrA-1; Mon, 20 Jan 2020 16:25:33 -0500
X-MC-Unique: osO99w3cOAGGyEQfDSkNrA-1
Received: by mail-qk1-f197.google.com with SMTP id k10so539640qki.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 13:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9l++3OuyTlK7LXp5Mq/OwpRSmGcumz9fcGOybYboMEQ=;
        b=mj45vfVF60CUaBkvuwnG5mzWoGDJuLbnPSyIdKi5aU2nc6Ss/F+OxeY42DLlxv73C/
         1pNORGuc3671BXJG2b4REkHdhO0Ko8HHQrohFipTuSzXp9JJgxHW5D2463oefAoS1xP0
         nMu6SCfs4RdzMqLMhlB2v6fzxoX17WZF4brCt07BC8SZ/xRvE9GpALqdgfQNR0DxyFR4
         VcP/767t33yHeA2HnZ/yhFDlPEJ16EJQ24JvWv6XM+k/sio/uBuYDPdUikq05mi65hbx
         IqwzigP5ZDYXmwisJDCkXINd3G+bQkchRMOyNmI29XMOotjn6rIZ5CfMffn6jZO/I/bh
         qLLA==
X-Gm-Message-State: APjAAAWpYn2JsGRUBmXQhzyum8MaKXvZ9Wwf3N1ttYp57t3UaE30jC3H
        TBi7CiNsu+kCvS5OwtMaNotSde5fv9XbZ1u3lwPoYKX4PMoU0wZV66qxrfLzwLVSiFfApMGVof5
        1tZ/TAvnvxeuD
X-Received: by 2002:ac8:1196:: with SMTP id d22mr1407852qtj.344.1579555532894;
        Mon, 20 Jan 2020 13:25:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqywvPPeh7FgOr2FVgGg2WUbLkkvTqU5itT+MWratS+JkuLjho3cX5Dq8zUicH4JEtMdHkf1hA==
X-Received: by 2002:ac8:1196:: with SMTP id d22mr1407821qtj.344.1579555532648;
        Mon, 20 Jan 2020 13:25:32 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id f19sm16201765qkk.69.2020.01.20.13.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 13:25:31 -0800 (PST)
Date:   Mon, 20 Jan 2020 16:25:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shahaf Shuler <shahafs@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Jason Wang <jasowang@redhat.com>,
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
Message-ID: <20200120162449-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <AM0PR0502MB3795C92485338180FC8059CFC3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR0502MB3795C92485338180FC8059CFC3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 20, 2020 at 08:51:43PM +0000, Shahaf Shuler wrote:
> Monday, January 20, 2020 7:50 PM, Jason Gunthorpe:
> > Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
> > 
> > On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> > > This is similar to the design of platform IOMMU part of vhost-vdpa. We
> > > decide to send diffs to platform IOMMU there. If it's ok to do that in
> > > driver, we can replace set_map with incremental API like map()/unmap().
> > >
> > > Then driver need to maintain rbtree itself.
> > 
> > I think we really need to see two modes, one where there is a fixed
> > translation without dynamic vIOMMU driven changes and one that supports
> > vIOMMU.
> > 
> > There are different optimization goals in the drivers for these two
> > configurations.
> 
> +1.
> It will be best to have one API for static config (i.e. mapping can be
> set only before virtio device gets active), and one API for dynamic
> changes that can be set after the virtio device is active. 

Frankly I don't see when we'd use the static one.
Memory hotplug is enabled for most guests...

> > 
> > > > If the first one, then I think memory hotplug is a heavy flow
> > > > regardless. Do you think the extra cycles for the tree traverse will
> > > > be visible in any way?
> > >
> > > I think if the driver can pause the DMA during the time for setting up
> > > new mapping, it should be fine.
> > 
> > This is very tricky for any driver if the mapping change hits the virtio rings. :(
> > 
> > Even a IOMMU using driver is going to have problems with that..
> > 
> > Jason

