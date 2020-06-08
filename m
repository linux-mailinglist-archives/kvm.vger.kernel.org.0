Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E381F1A11
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 15:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgFHN33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 09:29:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39447 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729645AbgFHN33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 09:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591622967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAi5RnB11l/kNjeRk8ozS/jXDdeHeIrWEjaZ8oVwPv4=;
        b=PjMl2shGx5+3Yo9rsHi7AuNTbvJ9lQnArsuKSgaQ2Ab1+Ywxh2WGJmQXaj9wbj81PIKoh+
        banPpXdoUMZZBla/5DAHiyguvaK2Bx8S4HhEl08Cxtg6FNC+UTVLnKFqSqw2gpMREZrtA8
        Yu2734sTDrzljospIWgYzeSU1xlVBpc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-ihbsps0lP3eQHT7ZEPMRng-1; Mon, 08 Jun 2020 09:29:06 -0400
X-MC-Unique: ihbsps0lP3eQHT7ZEPMRng-1
Received: by mail-wm1-f70.google.com with SMTP id u15so3934224wmm.5
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 06:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tAi5RnB11l/kNjeRk8ozS/jXDdeHeIrWEjaZ8oVwPv4=;
        b=jX7ZdCpd+Lfg+RxB5Ys41icUT1ppkOrtpRIQNajRil1PJb1pAb71LdUmGq07IY4cGl
         PLS2T8jnHLxTWh5wuNBeTb4JExqhmmKw/ka/R8tnaf4WStJU8m/j4H3QDc8q2Xik8FZo
         OBgKpAJngCHFbnvpV/S6xk3aKKIV0v8cUiJtUvRR9kKn/pyLp2HW8eYr2oAdBBTG/pMm
         IQxcLSZGijQBblwkYP+dJEBSLCnCuN6+CsqVMrth4z9G75QIM/TSTMA9wYe8Z0R1CaMd
         OkHmW3j0iJ0QH/6qhXVF3Mpl3xHNMmplAxzvneLcJ2wGsG/brahx14oP/n/7RAM2cqrP
         SUyg==
X-Gm-Message-State: AOAM5316FFgHMAW6jKWHMmO49tscW/14ko5yX5AoGFfNwxjQh70xJA8V
        OuRF+FfobnybtW5Lo+UzDs4oCiHgNPi2VgC2RPB6wvGjL2oA9vh8zhQAfAf7BTn2gvp9IPn6y6l
        ch5U75w6SLN8h
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr23250524wrs.223.1591622945518;
        Mon, 08 Jun 2020 06:29:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLsV4zKcIqO3YHdQC1Vbu08DLKVYtIAwGXFJX9rmOu7fddWNahirZvRHnTir6Z4zHxaZCpjg==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr23250502wrs.223.1591622945243;
        Mon, 08 Jun 2020 06:29:05 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id o20sm24303052wra.29.2020.06.08.06.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 06:29:04 -0700 (PDT)
Date:   Mon, 8 Jun 2020 09:29:01 -0400
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
Message-ID: <20200608092530-mutt-send-email-mst@kernel.org>
References: <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
 <20200608052041-mutt-send-email-mst@kernel.org>
 <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
 <20200608054453-mutt-send-email-mst@kernel.org>
 <bc27064c-2309-acf3-ccd8-6182bfa2a4cd@redhat.com>
 <20200608055331-mutt-send-email-mst@kernel.org>
 <61117e6a-2568-d0f4-8713-d831af32814d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61117e6a-2568-d0f4-8713-d831af32814d@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 06:07:36PM +0800, Jason Wang wrote:
> 
> On 2020/6/8 下午5:54, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2020 at 05:46:52PM +0800, Jason Wang wrote:
> > > On 2020/6/8 下午5:45, Michael S. Tsirkin wrote:
> > > > On Mon, Jun 08, 2020 at 05:43:58PM +0800, Jason Wang wrote:
> > > > > > > Looking at
> > > > > > > pci_match_one_device() it checks both subvendor and subdevice there.
> > > > > > > 
> > > > > > > Thanks
> > > > > > But IIUC there is no guarantee that driver with a specific subvendor
> > > > > > matches in presence of a generic one.
> > > > > > So either IFC or virtio pci can win, whichever binds first.
> > > > > I'm not sure I get there. But I try manually bind IFCVF to qemu's
> > > > > virtio-net-pci, and it fails.
> > > > > 
> > > > > Thanks
> > > > Right but the reverse can happen: virtio-net can bind to IFCVF first.
> > > 
> > > That's kind of expected. The PF is expected to be bound to virtio-pci to
> > > create VF via sysfs.
> > > 
> > > Thanks
> > > 
> > > 
> > > 
> > Once VFs are created, don't we want IFCVF to bind rather than
> > virtio-pci?
> 
> 
> Yes, but for PF we need virtio-pci.
> 
> Thanks
> 

(Ab)using the driver_data field for this is an option.
What do you think?

-- 
MST

