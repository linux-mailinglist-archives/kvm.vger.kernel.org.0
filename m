Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BB926228B
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 00:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgIHWUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 18:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgIHWUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 18:20:07 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63141C061573
        for <kvm@vger.kernel.org>; Tue,  8 Sep 2020 15:20:07 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b124so319966pfg.13
        for <kvm@vger.kernel.org>; Tue, 08 Sep 2020 15:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HpO7qFDD3rpwUzhoJe86mz7ApwH2rwNoTt29+YIuNgI=;
        b=L24ETfvvpwMMCQrSIcMf9frtMTGyMZCHyq65uUETZeuPY78wbzlmJ9CqC0E6g1ZX6O
         1xtz73V1o4jagggQTSZtBgxTDAXlo6Sf0BuF4/JMVDDUzwtvvdxG0eH3SznGG258TUJT
         FwARYoHB1801a62Qf4GX4gINVpcbwlQOHWolaQyAKOvXgzHyNdHkAilzF7I66+Zd8zVD
         tr2nPTU3FztqZ2ZUgf4BQE4PNnsZRs6IniAq0ebhWKzDwMrmiPIrR0kNpE97oKObEmjo
         jBM0+OwDhV92Q0MDCApvF/nMNp4PwtQCTcLN+H1pTDritmLoeVrdOsJnicHgM1MhSsh1
         PD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HpO7qFDD3rpwUzhoJe86mz7ApwH2rwNoTt29+YIuNgI=;
        b=p/gywznbr2x2CgyYuXMxdI+pJgguYXyxPSsQvNDJs3tHhQLWvH9pTA6Z5vIKXqCANE
         wzdL88pBx1OvduKUkSOo5uy4WN39JfzjMIX8y6vOUyER5/zUgB4kF5COQ3GZqCxIQcak
         AorvWbYHCjXRlb5nGd4eEkyHmSzZeO8I2WDvm5ebjxGzmIBC2memSpzprNOryyVOcXyS
         PFKRjGpqR2WeiePgr+rwDWSR5JwGxbfuzVZi8WGeP/WVVYgGwQlTHoYQqZ11w4ytpe4w
         WjFfx6XJmJuy8QP/c1HZZaoNLARhqm9c/420yih8XfWl/J5kJshYAm9ixHEgP/MiNQk7
         vB7w==
X-Gm-Message-State: AOAM532lbxIszccmHewrDvmz7DB7i+X/BNBQJXosiFnbn655DHgJqbDI
        o12/4NDUpySZYoUFBoVdXkL4eg==
X-Google-Smtp-Source: ABdhPJww4nx7ZoEkx6+oRQJneGGWhPF2IuOPKZlLcu7WSNgIHz+KiCTS6sLRuBYzJ4c3NP+krw47XA==
X-Received: by 2002:a62:8c86:: with SMTP id m128mr803155pfd.111.1599603606670;
        Tue, 08 Sep 2020 15:20:06 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id y23sm395670pfp.65.2020.09.08.15.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 15:20:06 -0700 (PDT)
Date:   Tue, 8 Sep 2020 16:20:04 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v5 0/4] Add a vhost RPMsg API
Message-ID: <20200908222004.GA516194@xps15>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200908101617-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908101617-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 08, 2020 at 10:16:52AM -0400, Michael S. Tsirkin wrote:
> On Wed, Aug 26, 2020 at 07:46:32PM +0200, Guennadi Liakhovetski wrote:
> > Hi,
> > 
> > Next update:
> 
> OK could we get some acks from rpmsg folks on this please?
> It's been quite a while, patchset is not huge.

There is a V6 of this set where Guennadi and I have agreed that patches 2 and 3
have been dealt with. Patch 1 is trivial, leaving only patch 4.  I had initially
decided to skip it because the vhost driver is completely foreign to me and the
cycles to change that are scarse.  But this set [1] from Arnaud has brought to
the fore issues related to the definition struct rpmsg_ns_msg, also used by
Guennadi's work.

As such I don't really have a choice now, I will review this series tomorrow or
Thursday.

[1]. https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338335 

> 
> 
> > v5:
> > - don't hard-code message layout
> > 
> > v4:
> > - add endianness conversions to comply with the VirtIO standard
> > 
> > v3:
> > - address several checkpatch warnings
> > - address comments from Mathieu Poirier
> > 
> > v2:
> > - update patch #5 with a correct vhost_dev_init() prototype
> > - drop patch #6 - it depends on a different patch, that is currently
> >   an RFC
> > - address comments from Pierre-Louis Bossart:
> >   * remove "default n" from Kconfig
> > 
> > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > cases. It can however also be used for virtualisation scenarios,
> > e.g. when using KVM to run Linux on both the host and the guests.
> > This patch set adds a wrapper API to facilitate writing vhost
> > drivers for such RPMsg-based solutions. The first use case is an
> > audio DSP virtualisation project, currently under development, ready
> > for review and submission, available at
> > https://github.com/thesofproject/linux/pull/1501/commits
> > 
> > Thanks
> > Guennadi
> > 
> > Guennadi Liakhovetski (4):
> >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> >   rpmsg: move common structures and defines to headers
> >   rpmsg: update documentation
> >   vhost: add an RPMsg API
> > 
> >  Documentation/rpmsg.txt          |   6 +-
> >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> >  drivers/vhost/Kconfig            |   7 +
> >  drivers/vhost/Makefile           |   3 +
> >  drivers/vhost/rpmsg.c            | 373 +++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> >  include/linux/virtio_rpmsg.h     |  83 +++++++
> >  include/uapi/linux/rpmsg.h       |   3 +
> >  include/uapi/linux/vhost.h       |   4 +-
> >  9 files changed, 551 insertions(+), 80 deletions(-)
> >  create mode 100644 drivers/vhost/rpmsg.c
> >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> >  create mode 100644 include/linux/virtio_rpmsg.h
> > 
> > -- 
> > 2.28.0
> 
