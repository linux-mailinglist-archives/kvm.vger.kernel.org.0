Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568DB1EEB0C
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 21:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgFDTXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 15:23:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56568 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728762AbgFDTXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 15:23:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591298625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RK7OUZgW5NorsDX1d7OO/eYBX7LBH2rL3jyqXLO1xAg=;
        b=WRHBqhzvtnBiUmV2ty+J36YUH3f9qTLrGlc6oJm9pXiSRieRre7D52aD+lZLXX1NnYACOY
        nLQpSkV+uMqb4r33gM4NOUZFinK3KLXnb74w2nur+faVmlbufb1juGBUOwozxBY6YcH0/U
        A6dc8LFLknbFjM8gxGCUKhvCi5aR0KM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-UIR8d-MgO0S-8jtnogIYGA-1; Thu, 04 Jun 2020 15:23:42 -0400
X-MC-Unique: UIR8d-MgO0S-8jtnogIYGA-1
Received: by mail-wr1-f72.google.com with SMTP id r5so2815776wrt.9
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 12:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RK7OUZgW5NorsDX1d7OO/eYBX7LBH2rL3jyqXLO1xAg=;
        b=hUFojJFSf9wEJ/vEYucmOVVXrYAKTu3YCWJL1RvyfJJqabq7Hk82E9OmlJsCoKwg0q
         HMPEq6L7n8PkdgqDDpfV34LKs24OLomaZmBRZ3w26yWg/Ogx1TpJowi4B6c1oijOGdQ6
         mKOZCzjRP6yNklsw7Oe2Pq/sa+Qx+pSBc6AKZpN+BoUSeI7z7JV/IKfkwUJI17pAyqHI
         SC4VFjkA2Gza06XQlK2/U0aPChesadPQHRboZst/RNClWaU3fu/BNUd8ADfphHLOWNUN
         GLAxQv/w61oxmEoTr4i4tZB1E6Gs8gO0culV26hAoMiPwX/cFwkvJFyef53AcSCIQ7yI
         uT+w==
X-Gm-Message-State: AOAM531FZrojbPmBOHQjiqH/wDRIj3g0DjqiNVD6RIY5MfJYVx2IN6PK
        wpgletts+EOTFu6leCwzVWZ743rVh2Qneb+55iDjwVp1TXon25d4zQT5DC10CHUhdP/njlOiGXa
        kjeFaK2q6kJJm
X-Received: by 2002:a5d:4c87:: with SMTP id z7mr5815826wrs.100.1591298621593;
        Thu, 04 Jun 2020 12:23:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxp0/pnnPfhicvkES2RGb4PHh4oHYIiCtpAgZ3EQrs+Ij/+qtfXjmNZZ+e/z1giKYaInwdODw==
X-Received: by 2002:a5d:4c87:: with SMTP id z7mr5815767wrs.100.1591298620862;
        Thu, 04 Jun 2020 12:23:40 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id e10sm9109099wrn.11.2020.06.04.12.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 12:23:40 -0700 (PDT)
Date:   Thu, 4 Jun 2020 15:23:37 -0400
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
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 0/5] Add a vhost RPMsg API
Message-ID: <20200604151917-mutt-send-email-mst@kernel.org>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 27, 2020 at 08:05:36PM +0200, Guennadi Liakhovetski wrote:
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
> Linux supports RPMsg over VirtIO for "remote processor" /AMP use
> cases. It can however also be used for virtualisation scenarios,
> e.g. when using KVM to run Linux on both the host and the guests.
> This patch set adds a wrapper API to facilitate writing vhost
> drivers for such RPMsg-based solutions. The first use case is an
> audio DSP virtualisation project, currently under development, ready
> for review and submission, available at
> https://github.com/thesofproject/linux/pull/1501/commits
> A further patch for the ADSP vhost RPMsg driver will be sent
> separately for review only since it cannot be merged without audio
> patches being upstreamed first.


RPMsg over virtio has several problems. One is that it's
not specced at all. Before we add more stuff, I'd like so
see at least an attempt at describing what it's supposed to do.

Another it's out of line with 1.0 spec passing guest
endian data around. Won't work if host and guest
endian-ness do not match. Should pass eveything in LE and
convert.

It's great to see it's seeing active development finally.
Do you think you will have time to address these?



> Thanks
> Guennadi
> 
> Guennadi Liakhovetski (5):
>   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
>   vhost: (cosmetic) remove a superfluous variable initialisation
>   rpmsg: move common structures and defines to headers
>   rpmsg: update documentation
>   vhost: add an RPMsg API
> 
>  Documentation/rpmsg.txt          |   6 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +-------
>  drivers/vhost/Kconfig            |   7 +
>  drivers/vhost/Makefile           |   3 +
>  drivers/vhost/rpmsg.c            | 382 +++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/vhost.c            |   2 +-
>  drivers/vhost/vhost_rpmsg.h      |  74 ++++++++
>  include/linux/virtio_rpmsg.h     |  81 +++++++++
>  include/uapi/linux/rpmsg.h       |   3 +
>  include/uapi/linux/vhost.h       |   4 +-
>  10 files changed, 559 insertions(+), 81 deletions(-)
>  create mode 100644 drivers/vhost/rpmsg.c
>  create mode 100644 drivers/vhost/vhost_rpmsg.h
>  create mode 100644 include/linux/virtio_rpmsg.h
> 
> -- 
> 1.9.3

