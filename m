Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D0C23BA4C
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgHDM1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 08:27:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42186 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725950AbgHDM1G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Aug 2020 08:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596544024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9vhPgMDKcGi9ZPslRrds1Rb1iUgXvAPxw94iDlV9Esw=;
        b=hGPYheDXg6fSDy7KwvRkrOLaqf4hGeG6V3reRKN9F4g0mgpxEA2jFDLg3jdLQT1x13XfYq
        FOtWpk/GuMCHpNX9Ax1ykQZAprKbjbiVsRr9RKBDI6751hvuYecZwcnueuA/PPnUTYjSgn
        ksnZHwGMTr29xLo1R6oAS5jPGOa2/os=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-6p-A_5HPPiWsCIpn4nyHBA-1; Tue, 04 Aug 2020 08:27:01 -0400
X-MC-Unique: 6p-A_5HPPiWsCIpn4nyHBA-1
Received: by mail-qk1-f198.google.com with SMTP id c202so22622438qkg.12
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 05:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9vhPgMDKcGi9ZPslRrds1Rb1iUgXvAPxw94iDlV9Esw=;
        b=NZkom76/9doWVW57pE6OoTWQzrmmuh8OEYSfHlHWtJibXdPnlZ59pMAmaqla/8krpx
         lf6BuUX+ajsfSzwbh6YO1//bK1z7XJtrCUSZ6H52Jgt8rW8CUkbLHiL/x43a/4OLa+Ln
         Tgi9ExScqPFdbbGvitVhvgJ8vfVPfox0nJh1Rlm+0NEKDUVxpAaCOlxKmRNR+8xgEojy
         6OA1LmT/ppUh22FWY6oTA+nKCNrLA02vfesgNVGP6c/Hyi014t3NS87Z9JG6jeNDrd6J
         qcZhEtRuFILs83lk18YQ6rCnOW3pV33VzVPqB5LFMFMAnMV0Q/TGqjg2hAV0MVJRuyC6
         E5Lw==
X-Gm-Message-State: AOAM531JPwY5CWVZo2d5F0ZJfmJFWOFJFjQIlIdyeSJmO26jEw3ke35h
        z6i98xJDHK+qLdCi2pnbY5sl+i7OVYywDZv8L/0XDfRju+1gk+B0YR60SEfYzMVLuNQyf1jEvXn
        gNaqoIooy3yMX
X-Received: by 2002:ac8:586:: with SMTP id a6mr21323488qth.391.1596544020888;
        Tue, 04 Aug 2020 05:27:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGMj+9fSab5vOUQnGujXpnk+obUr+jaJXm5QnWgBc4+EfOvLlsgeBJv/ur3ycUhBN2ervlkA==
X-Received: by 2002:ac8:586:: with SMTP id a6mr21323472qth.391.1596544020661;
        Tue, 04 Aug 2020 05:27:00 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id e21sm21251091qkl.88.2020.08.04.05.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 05:26:59 -0700 (PDT)
Date:   Tue, 4 Aug 2020 08:26:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 0/4] Add a vhost RPMsg API
Message-ID: <20200804082250-mutt-send-email-mst@kernel.org>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> Hi,
> 
> Now that virtio-rpmsg endianness fixes have been merged we can 
> proceed with the next step.

OK my attempts to resolve conflicts just created a mess.

I dropped these for now, could you pls rebase on top
of linux-next branch in my tree, and repost?
Thanks!


> v4:
> - add endianness conversions to comply with the VirtIO standard
> 
> v3:
> - address several checkpatch warnings
> - address comments from Mathieu Poirier
> 
> v2:
> - update patch #5 with a correct vhost_dev_init() prototype
> - drop patch #6 - it depends on a different patch, that is currently
>   an RFC
> - address comments from Pierre-Louis Bossart:
>   * remove "default n" from Kconfig
> 
> Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> cases. It can however also be used for virtualisation scenarios,
> e.g. when using KVM to run Linux on both the host and the guests.
> This patch set adds a wrapper API to facilitate writing vhost
> drivers for such RPMsg-based solutions. The first use case is an
> audio DSP virtualisation project, currently under development, ready
> for review and submission, available at
> https://github.com/thesofproject/linux/pull/1501/commits
> 
> Thanks
> Guennadi
> 
> Guennadi Liakhovetski (4):
>   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
>   rpmsg: move common structures and defines to headers
>   rpmsg: update documentation
>   vhost: add an RPMsg API
> 
>  Documentation/rpmsg.txt          |   6 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
>  drivers/vhost/Kconfig            |   7 +
>  drivers/vhost/Makefile           |   3 +
>  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
>  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
>  include/linux/virtio_rpmsg.h     |  83 +++++++
>  include/uapi/linux/rpmsg.h       |   3 +
>  include/uapi/linux/vhost.h       |   4 +-
>  9 files changed, 553 insertions(+), 80 deletions(-)
>  create mode 100644 drivers/vhost/rpmsg.c
>  create mode 100644 drivers/vhost/vhost_rpmsg.h
>  create mode 100644 include/linux/virtio_rpmsg.h
> 
> -- 
> 2.27.0

