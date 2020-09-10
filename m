Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3454264AA9
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 19:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgIJRGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 13:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgIJQzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 12:55:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1EDC0617AA
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 09:46:47 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x18so1199676pll.6
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 09:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GYaKs8QftCALWrd/sCxpr6wE3DfZJ/m8ISq/bE/sCjY=;
        b=wjV5Iutzt3GOgNkbzv9kunLWp6wW50/GNnkDMxO/xiLwXQ6bKO1dw3l8aDU+wDLhyg
         F8/RIUP66nbx+Brqiu4BzA+BG0KEENU77NnarFAuTiLithwLw46ccaSTWVQB4rwbU/ag
         XFC9/9uqTsc+14qHih9dnsETHtLjXOFUD3chc3iGhNFxtr9pBUA2iacasnaIZhQf4KsZ
         tWeOpg7iJeGUvTBx7Z+KKpKh6/NB4ehRe5EvhMs0F1vB/HJ3J8F9TRzay1EguU/qLseV
         m25ZLwd9077hIeD0euIC0vrPCSCP5c1MdliLB1kWQdEm05Es3HRUOCHqdlpsOUAWGz8X
         W5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GYaKs8QftCALWrd/sCxpr6wE3DfZJ/m8ISq/bE/sCjY=;
        b=Tj1Ynw1lpdYgaRmVEp/8Okrl6ZMNizYFuRfTXLzXTNtCAfY7090JWnV/hutgnQVpRW
         yUEvcRDWdX/0P6HNpwh7xjAzaDUF/Q/ON4Z+C7OQO6DBk0mdx3knxb0s6GVllaj3TUqf
         IlqWn2xUiz3/JSsy8zWgFSkHbpQrkCjuOSPkXOaNRGwvZ8rFxBeAMQHyWAGea/Fq/Yo7
         /UWLm/M643gS9Ytbb8tmRrkpqjnno4yXCYwy52hRA2BrB5EmrLPBsNncn+84ce2tjyJc
         UyMPpp6+jFB+mdDhXw9TJQcwqD0f40BSxY6GvX8T+2mOF3vzWPqxm7P0z79UEubnNxj5
         2T9w==
X-Gm-Message-State: AOAM532zio8gghxWZQWe+bAyIEDkxNLuZvE/LAiIhDtb/EahHitiTJ7F
        F45Mfk0/wN7B4tCytQaRhx9xrTbDTDxG7g==
X-Google-Smtp-Source: ABdhPJwOnUUyLYGcvPlx2R3ZfhXPdQyH/JzSYYBPUjSL0AmjsDwkY/+H59hwDpdXZjTZLUk9zwqqTw==
X-Received: by 2002:a17:90a:ab91:: with SMTP id n17mr810364pjq.84.1599756406674;
        Thu, 10 Sep 2020 09:46:46 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id nu14sm2290451pjb.19.2020.09.10.09.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:46:45 -0700 (PDT)
Date:   Thu, 10 Sep 2020 10:46:43 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v5 1/4] vhost: convert VHOST_VSOCK_SET_RUNNING to a
 generic ioctl
Message-ID: <20200910164643.GA579940@xps15>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-2-guennadi.liakhovetski@linux.intel.com>
 <20200909224214.GB562265@xps15>
 <20200910062144.GA16802@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910062144.GA16802@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 10, 2020 at 09:15:13AM +0200, Guennadi Liakhovetski wrote:
> Hi Mathieu,
> 
> On Wed, Sep 09, 2020 at 04:42:14PM -0600, Mathieu Poirier wrote:
> > On Wed, Aug 26, 2020 at 07:46:33PM +0200, Guennadi Liakhovetski wrote:
> > > VHOST_VSOCK_SET_RUNNING is used by the vhost vsock driver to perform
> > > crucial VirtQueue initialisation, like assigning .private fields and
> > > calling vhost_vq_init_access(), and clean up. However, this ioctl is
> > > actually extremely useful for any vhost driver, that doesn't have a
> > > side channel to inform it of a status change, e.g. upon a guest
> > > reboot. This patch makes that ioctl generic, while preserving its
> > > numeric value and also keeping the original alias.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > ---
> > >  include/uapi/linux/vhost.h | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > > index 75232185324a..11a4948b6216 100644
> > > --- a/include/uapi/linux/vhost.h
> > > +++ b/include/uapi/linux/vhost.h
> > > @@ -97,6 +97,8 @@
> > >  #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
> > >  #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
> > >  
> > > +#define VHOST_SET_RUNNING _IOW(VHOST_VIRTIO, 0x61, int)
> > > +
> > 
> > I don't see it used in the next patches and as such should be part of another
> > series.
> 
> It isn't used in the next patches, it is used in this patch - see below.
>

Right, but why is this part of this set?  What does it bring?  It should be part
of a patchset where "VHOST_SET_RUNNING" is used.
 
> Thanks
> Guennadi
> 
> > >  /* VHOST_NET specific defines */
> > >  
> > >  /* Attach virtio net ring to a raw socket, or tap device.
> > > @@ -118,7 +120,7 @@
> > >  /* VHOST_VSOCK specific defines */
> > >  
> > >  #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> > > -#define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> > > +#define VHOST_VSOCK_SET_RUNNING		VHOST_SET_RUNNING
> > >  
> > >  /* VHOST_VDPA specific defines */
> > >  
> > > -- 
> > > 2.28.0
> > > 
