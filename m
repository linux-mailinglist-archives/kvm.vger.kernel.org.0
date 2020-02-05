Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E494A152653
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 07:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgBEGam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 01:30:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28541 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726308AbgBEGam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 01:30:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580884242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SK/6EZm6JjjZrHYe/o5W90LoH1mAJQFt67RmR4CQh0M=;
        b=f26iPlwwNz8dvaJJgPKtdHRGMSNMSvkghRp4Y0o0m4XtLwbG9cpdUp8xlLMlGv89islxqA
        xz8EnOvO8Q/2hyfT35zqqVjwuyi7MjLRGAjKGCr1CKek9KtZ1Ru+N/oR2rRhKcDasR5mF9
        Nue9GYechHu9KC8PbeRS36ECXwpqRUs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-3VjX9x0CNlKIUe03TKWHiQ-1; Wed, 05 Feb 2020 01:30:40 -0500
X-MC-Unique: 3VjX9x0CNlKIUe03TKWHiQ-1
Received: by mail-qt1-f197.google.com with SMTP id t4so711887qtd.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 22:30:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SK/6EZm6JjjZrHYe/o5W90LoH1mAJQFt67RmR4CQh0M=;
        b=hbpymRpKjyO+32hLrwmWdleZ3vvHsVj0nLdtggjMGhGtIfqwrMbO59gbBK5Ttej6Rt
         8MjaHGmRiGuoQxeR95Kk8eXazr4qPG90c4OQeW4DRRle3ZhzkVLP45aRlZg0FIo9Fhiy
         OfhsbEvHCmhhYGer4Kbxd6WxQOT27sXByt9o3EQiEZQk5xDM+Xxz7WIf2txi+aYhO7EA
         egv6C/7JSt2hweXM7MxKxk87s2xesFjmQctmL/9TUTqNxJWH2uOH+ZHUMFHnA2pLqd+G
         z25gEA+ehCkr739E7k8hVM2My3ZWWKp65YQ1VaeIgtxcmmXNBKF8MNyEsbbzbADGtIiB
         HsoQ==
X-Gm-Message-State: APjAAAWpsoW/YJhyBqcfNhXylsCSUAG1PNtP7aPgXubzc+gmXzyq0NB8
        vHcUTlwSiZTEBpi0vE5NTnwFgggK+rNO12TMjAYUEKL2MZHnLw2C8hL78zEbgs7Mde0LYglyXYE
        N6JSbfi8Pu1Tx
X-Received: by 2002:a05:6214:11a8:: with SMTP id u8mr30684172qvv.16.1580884239900;
        Tue, 04 Feb 2020 22:30:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwkD0A2RyJgsZhuekPIPi4xkOg0VrIIr3OXInSUl8ooLyFt/kzVDntwDVhZLhJKb38ZnUEwpg==
X-Received: by 2002:a05:6214:11a8:: with SMTP id u8mr30684150qvv.16.1580884239611;
        Tue, 04 Feb 2020 22:30:39 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id a36sm13471539qtk.29.2020.02.04.22.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 22:30:38 -0800 (PST)
Date:   Wed, 5 Feb 2020 01:30:32 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205011935-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200204005306-mutt-send-email-mst@kernel.org>
 <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
 <20200205020555.GA369236@___>
 <798e5644-ca28-ee46-c953-688af9bccd3b@redhat.com>
 <20200205003048-mutt-send-email-mst@kernel.org>
 <eb53d1c2-92ae-febf-f502-2d3e107ee608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb53d1c2-92ae-febf-f502-2d3e107ee608@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 01:50:28PM +0800, Jason Wang wrote:
> 
> On 2020/2/5 下午1:31, Michael S. Tsirkin wrote:
> > On Wed, Feb 05, 2020 at 11:12:21AM +0800, Jason Wang wrote:
> > > On 2020/2/5 上午10:05, Tiwei Bie wrote:
> > > > On Tue, Feb 04, 2020 at 02:46:16PM +0800, Jason Wang wrote:
> > > > > On 2020/2/4 下午2:01, Michael S. Tsirkin wrote:
> > > > > > On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> > > > > > > 5) generate diffs of memory table and using IOMMU API to setup the dma
> > > > > > > mapping in this method
> > > > > > Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?
> > > > > > 
> > > > > Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?
> > > > Do you mean we let userspace to only use VHOST_IOTLB_UPDATE/INVALIDATE
> > > > to do the DMA mapping in vhost-vdpa case? When vIOMMU isn't available,
> > > > userspace will set msg->iova to GPA, otherwise userspace will set
> > > > msg->iova to GIOVA, and vhost-vdpa module will get HPA from msg->uaddr?
> > > > 
> > > > Thanks,
> > > > Tiwei
> > > I think so. Michael, do you think this makes sense?
> > > 
> > > Thanks
> > to make sure, could you post the suggested argument format for
> > these ioctls?
> > 
> 
> It's the existed uapi:
> 
> /* no alignment requirement */
> struct vhost_iotlb_msg {
>     __u64 iova;
>     __u64 size;
>     __u64 uaddr;
> #define VHOST_ACCESS_RO      0x1
> #define VHOST_ACCESS_WO      0x2
> #define VHOST_ACCESS_RW      0x3
>     __u8 perm;
> #define VHOST_IOTLB_MISS           1
> #define VHOST_IOTLB_UPDATE         2
> #define VHOST_IOTLB_INVALIDATE     3
> #define VHOST_IOTLB_ACCESS_FAIL    4
>     __u8 type;
> };
> 
> #define VHOST_IOTLB_MSG 0x1
> #define VHOST_IOTLB_MSG_V2 0x2
> 
> struct vhost_msg {
>     int type;
>     union {
>         struct vhost_iotlb_msg iotlb;
>         __u8 padding[64];
>     };
> };
> 
> struct vhost_msg_v2 {
>     __u32 type;
>     __u32 reserved;
>     union {
>         struct vhost_iotlb_msg iotlb;
>         __u8 padding[64];
>     };
> };

Oh ok.  So with a real device, I suspect we do not want to wait for each
change to be processed by device completely, so we might want an asynchronous variant
and then some kind of flush that tells device "you better apply these now".

-- 
MST

