Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170811C5D56
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgEEQUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 12:20:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26680 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730282AbgEEQUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 12:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588695635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I2s71uL8xGKEolWyYIMtKAtRYtl4jyJkJ/99unlnUqU=;
        b=LXS/EvKigeO0Vc5nJ+lhBeQobRusQru2zhne8Pkt3TOHjRuLUERwgqXWDvbb+JkNCeWYtx
        RU7S6c9dXQIajrNqGc7K0tSgHq8p+mCDk6SGknnepan3jqk8EXdUi34PR4w9n4ruOY5Uyp
        IAnGvINzN6VNkxZl9VCNX/P7ZXWSSd4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-Y3bpnOsNP12JcXdaxCh8zQ-1; Tue, 05 May 2020 12:20:11 -0400
X-MC-Unique: Y3bpnOsNP12JcXdaxCh8zQ-1
Received: by mail-wr1-f70.google.com with SMTP id z5so1451126wrt.17
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 09:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I2s71uL8xGKEolWyYIMtKAtRYtl4jyJkJ/99unlnUqU=;
        b=HCT2+LvQQEfh7F+3O6XK7LTq3URsfv2eP+mAOMv3kj0oZqcVJejAEqaTuGUwr/iNAa
         hgKmED6MX3rWLQj9vx7H0jQAPjOndVsGhaoxb9Vpdb2laxp3giPxIKtgab3S/WTLlaMX
         g5nd1JizMmlSHxDDFUl10aunkMyZsphVPPVOXhhTbCrOgNXXPHbYOet054CS0M4rMUlg
         0KOnMuAcodzJpQiCU9mJJEJppT+IYKiNcBHec9gPO8OtqO/2W41bpuc9mrnsfNt38Qq/
         q1/7Oqk2UJnae/H8ByVHPkRxWRm27b7XMLyeFWygbfQGHnK5ciV5TOvx0GmGOZ3sdPvf
         MQTw==
X-Gm-Message-State: AGi0Pub66lKwdf0b5D9iSKFF38TjP+67S26JXaZqoyWSSam7a9PnjyqS
        LLZWG64feLHPs0k2sC8K9L6aCarSdncDIOg66EhG6Q0LHByvCoVKDki7PLp3IYqgVR4eVjhgHiy
        uHsmBgDxmuNkk
X-Received: by 2002:a05:600c:c9:: with SMTP id u9mr4061970wmm.15.1588695610844;
        Tue, 05 May 2020 09:20:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypItx4pewXH8KspumOw+hW8KlzDc1X/wIkpla2d9GHs5ihHGkbZ8JJ4G4js7d++2/VPr7p4xvA==
X-Received: by 2002:a05:600c:c9:: with SMTP id u9mr4061952wmm.15.1588695610624;
        Tue, 05 May 2020 09:20:10 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id d1sm3805662wrx.65.2020.05.05.09.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 09:20:10 -0700 (PDT)
Date:   Tue, 5 May 2020 12:20:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: Re: [vhost:vhost 8/22] drivers/virtio/virtio_mem.c:1375:20: error:
 implicit declaration of function 'kzalloc'; did you mean 'vzalloc'?
Message-ID: <20200505121732-mutt-send-email-mst@kernel.org>
References: <202005052221.83QerHmG%lkp@intel.com>
 <7dea2810-85cf-0892-20a8-bba3e3a2c133@redhat.com>
 <20200505114433-mutt-send-email-mst@kernel.org>
 <3eaebd8d-750a-d046-15f5-706fb00a196e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3eaebd8d-750a-d046-15f5-706fb00a196e@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 05:46:44PM +0200, David Hildenbrand wrote:
> On 05.05.20 17:44, Michael S. Tsirkin wrote:
> > On Tue, May 05, 2020 at 04:50:13PM +0200, David Hildenbrand wrote:
> >> On 05.05.20 16:15, kbuild test robot wrote:
> >>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> >>> head:   da1742791d8c0c0a8e5471f181549c4726a5c5f9
> >>> commit: 7527631e900d464ed2d533f799cb0da2b29cc6f0 [8/22] virtio-mem: Paravirtualized memory hotplug
> >>> config: x86_64-randconfig-b002-20200505 (attached as .config)
> >>> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> >>> reproduce:
> >>>         git checkout 7527631e900d464ed2d533f799cb0da2b29cc6f0
> >>>         # save the attached .config to linux build tree
> >>>         make ARCH=x86_64 
> >>>
> >>> If you fix the issue, kindly add following tag as appropriate
> >>> Reported-by: kbuild test robot <lkp@intel.com>
> >>>
> >>> All error/warnings (new ones prefixed by >>):
> >>>
> >>>    drivers/virtio/virtio_mem.c: In function 'virtio_mem_probe':
> >>>>> drivers/virtio/virtio_mem.c:1375:20: error: implicit declaration of function 'kzalloc'; did you mean 'vzalloc'? [-Werror=implicit-function-declaration]
> >>>      vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
> >>>                        ^~~~~~~
> >>>                        vzalloc
> >>>>> drivers/virtio/virtio_mem.c:1375:18: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
> >>>      vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
> >>>                      ^
> >>>>> drivers/virtio/virtio_mem.c:1419:2: error: implicit declaration of function 'kfree'; did you mean 'vfree'? [-Werror=implicit-function-declaration]
> >>>      kfree(vm);
> >>>      ^~~~~
> >>>      vfree
> >>>    cc1: some warnings being treated as errors
> >>>
> >>> vim +1375 drivers/virtio/virtio_mem.c
> >>
> >> Guess we simply need
> >>
> >>  #include <linux/slab.h>
> >>
> >> to make it work for that config.
> > 
> > 
> > OK I added that in the 1st commit that introduced virtio-mem.
> 
> Thanks. I have some addon-patches ready, what's the best way to continue
> with these?

If these are bugfixes, just respin the series (including this fix).
If these are more features, you can just post them on list noting "next" in
subject and saying "this is on top of vhost tree" after --.
I don't know how to make 0-day figure out where to apply such dependent
patches unfortunately.

> 
> -- 
> Thanks,
> 
> David / dhildenb

