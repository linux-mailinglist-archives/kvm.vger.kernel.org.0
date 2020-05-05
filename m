Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6541C5D96
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 18:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgEEQal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 12:30:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48737 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbgEEQal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 12:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588696239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yMBKhgqvtU6JZa2/gwth5BlYVmq3nyyl0uG0nZStcYk=;
        b=VRk02Ujd1Qec1U1BuABFsYthQpjfFkTPREu7oQqBglgWk65r3Zl0i/vQDvRSzLUDvshtjh
        UtudByAwIEGMgSpmpe9Nb92qAkwRbtlCs4r49O0mn5FT+hXpV6xecT+uyM5dC2GG2kZf6D
        e9gW5TGMDzJgyWgmk7ItZLPKeK/FGz4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-k30kRFbnNAC2irLmAZ1Zaw-1; Tue, 05 May 2020 12:30:37 -0400
X-MC-Unique: k30kRFbnNAC2irLmAZ1Zaw-1
Received: by mail-wm1-f70.google.com with SMTP id l21so1315637wmh.2
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 09:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yMBKhgqvtU6JZa2/gwth5BlYVmq3nyyl0uG0nZStcYk=;
        b=hkHoGhZhG+wK9LLGLhaYM8GlfqG8lqQ6vcl8BL/yYOgThdPJ7ZnI+Gw1oWoHNozvPh
         U9j4QXf/Ilvfjg7NcC6KTYikuEnpAoC+4qLKz85viFFyXevavvDVfIxjFN8D4lHQMhra
         Jvmmm7bQ0y49ZElYeCqqBId6OgynU83c493ZhuoezzY/mUp/R+qdxX2U3iusmvhBtLYb
         1B4Vl5E7XEpkpMZLTyYyXGXiCwbLx7fiBc60hJX/F7gSrsg3ANpuZmE3XNn2j03EkG5z
         PXmjDBrajGGtn7GoqiZK2jI2I1q6twbiCSgeqNYkTSEmRzcsZm27spLYymqo5E1uPvN9
         CXOQ==
X-Gm-Message-State: AGi0Pua3yC+EHKnj0rub4xXq6M9Jj/RzaSDWoIbQpP/iH562vfg9NLko
        1Kqd94sAdLd4WkTuc08GOBxmiNSBqKdXfzmE0AZ21c2b2+hDvNrj7Ti8q9AB0OJonnP4EhGLH4+
        k/eO8fgIaYV0g
X-Received: by 2002:a5d:5261:: with SMTP id l1mr4495415wrc.24.1588696236458;
        Tue, 05 May 2020 09:30:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypL6c2ZhSqgyVCoh+9xYBBrRpeIbvWaVoWn35WDDllP8SgqQVe+xSldK3GCh2yVta3+pQW6bDg==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr4495399wrc.24.1588696236272;
        Tue, 05 May 2020 09:30:36 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id x5sm3669458wro.12.2020.05.05.09.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 09:30:35 -0700 (PDT)
Date:   Tue, 5 May 2020 12:30:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: Re: [vhost:vhost 8/22] drivers/virtio/virtio_mem.c:1375:20: error:
 implicit declaration of function 'kzalloc'; did you mean 'vzalloc'?
Message-ID: <20200505123009-mutt-send-email-mst@kernel.org>
References: <202005052221.83QerHmG%lkp@intel.com>
 <7dea2810-85cf-0892-20a8-bba3e3a2c133@redhat.com>
 <20200505114433-mutt-send-email-mst@kernel.org>
 <3eaebd8d-750a-d046-15f5-706fb00a196e@redhat.com>
 <20200505121732-mutt-send-email-mst@kernel.org>
 <e607a850-ba5c-6033-93fc-144639b125b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e607a850-ba5c-6033-93fc-144639b125b8@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 06:22:51PM +0200, David Hildenbrand wrote:
> On 05.05.20 18:20, Michael S. Tsirkin wrote:
> > On Tue, May 05, 2020 at 05:46:44PM +0200, David Hildenbrand wrote:
> >> On 05.05.20 17:44, Michael S. Tsirkin wrote:
> >>> On Tue, May 05, 2020 at 04:50:13PM +0200, David Hildenbrand wrote:
> >>>> On 05.05.20 16:15, kbuild test robot wrote:
> >>>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> >>>>> head:   da1742791d8c0c0a8e5471f181549c4726a5c5f9
> >>>>> commit: 7527631e900d464ed2d533f799cb0da2b29cc6f0 [8/22] virtio-mem: Paravirtualized memory hotplug
> >>>>> config: x86_64-randconfig-b002-20200505 (attached as .config)
> >>>>> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> >>>>> reproduce:
> >>>>>         git checkout 7527631e900d464ed2d533f799cb0da2b29cc6f0
> >>>>>         # save the attached .config to linux build tree
> >>>>>         make ARCH=x86_64 
> >>>>>
> >>>>> If you fix the issue, kindly add following tag as appropriate
> >>>>> Reported-by: kbuild test robot <lkp@intel.com>
> >>>>>
> >>>>> All error/warnings (new ones prefixed by >>):
> >>>>>
> >>>>>    drivers/virtio/virtio_mem.c: In function 'virtio_mem_probe':
> >>>>>>> drivers/virtio/virtio_mem.c:1375:20: error: implicit declaration of function 'kzalloc'; did you mean 'vzalloc'? [-Werror=implicit-function-declaration]
> >>>>>      vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
> >>>>>                        ^~~~~~~
> >>>>>                        vzalloc
> >>>>>>> drivers/virtio/virtio_mem.c:1375:18: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
> >>>>>      vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
> >>>>>                      ^
> >>>>>>> drivers/virtio/virtio_mem.c:1419:2: error: implicit declaration of function 'kfree'; did you mean 'vfree'? [-Werror=implicit-function-declaration]
> >>>>>      kfree(vm);
> >>>>>      ^~~~~
> >>>>>      vfree
> >>>>>    cc1: some warnings being treated as errors
> >>>>>
> >>>>> vim +1375 drivers/virtio/virtio_mem.c
> >>>>
> >>>> Guess we simply need
> >>>>
> >>>>  #include <linux/slab.h>
> >>>>
> >>>> to make it work for that config.
> >>>
> >>>
> >>> OK I added that in the 1st commit that introduced virtio-mem.
> >>
> >> Thanks. I have some addon-patches ready, what's the best way to continue
> >> with these?
> > 
> > If these are bugfixes, just respin the series (including this fix).
> 
> There are two really minor bugfixes for corner-case error handling and
> one simplification. I can squash them and resend, makes things easier.
> 
> The other stuff I have are extensions, I will send as add-on.
> 
> Thanks!

So just send a giant patchbomb explaining what's what in the
cover letter. Thanks!


> 
> -- 
> Thanks,
> 
> David / dhildenb

