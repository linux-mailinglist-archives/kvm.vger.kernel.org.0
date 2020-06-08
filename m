Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057101F1D16
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 18:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgFHQSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 12:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbgFHQSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 12:18:01 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F15C08C5C3
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 09:18:00 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q24so44288pjd.1
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 09:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UYwfnB3ynwS5FT1bnWpptzCKoVAn6rGz8POW+9WmHHM=;
        b=MTsTBBL3wp0LVJKjWTsfFaV1UknomJOGIY9D9gLsov3noHn3VLgGpTXwfowbijyKfj
         9iGJo253Ca7kB9q9RTL5IUNiALYYl/5bBw/bYt6GZukRo2MEqBM4ZnRVGMTF7crOmZxi
         BXutOrU5unWLex1AxR27OKFK1VKrf1xOLsmEW3IbheWkuYMFJKiMhljbvOere3b60FtV
         TLYmp+IprtwzcCd9uO3pjL++wGhgKa8qwzYxq/BXAeK7gFKod9h/e/d8PcpOnvw0tTqd
         CMRoh1M9RBQQ5Yq/sSj+bPj4YVUSwKCzKSwLgCcsJopqHFDxLvCxlHUsS0bH8x3HnyLa
         CRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UYwfnB3ynwS5FT1bnWpptzCKoVAn6rGz8POW+9WmHHM=;
        b=L8WrtRbMIHb5NO0pyIsyQCQjOi9XA9InYaphnHFpdQlZnNu1c7knkAywenU9K2ve0W
         kJ1nUDzX2+GUGUHDDOkCvr1CuliJRPAv/CwwSjfhRHEhi3VnuraLTac29KN6ubUyWLp2
         hX3dBD9LQ7Mvg8hJMVCEowHI2XQvx6ovY7z2/mAmmInRnv4NFuJMhjEfb0ZSRMM5o31D
         UNhiob+iDA411oifDgtEjOcI87kShsFdld4UtIqOvWSPR5lQosg3eHLDrt3HqpA9QAxx
         hKsdf+rHrJOxKKyL3QByp3mBMtuXydipd4gaTEys6nPE0Wm9rif30175sc8ba2sTDM70
         tgBQ==
X-Gm-Message-State: AOAM530l05ecRx3GFChPnxRrM4qdI6MXfu7ug1OCfVXse69xgGNsKK/I
        Bji8mJnKY3IT3A3t0Z0h2DjjYSRNJCY=
X-Google-Smtp-Source: ABdhPJz9bSlAVrnXmQjcF99gsBzVx+gJazW+tdCAitT0I8gtyxiWV8gZnuF8TSKRDqE68ItSPm4YKA==
X-Received: by 2002:a17:90b:b16:: with SMTP id bf22mr85162pjb.151.1591633080431;
        Mon, 08 Jun 2020 09:18:00 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id w124sm7521335pfc.213.2020.06.08.09.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 09:17:59 -0700 (PDT)
Date:   Mon, 8 Jun 2020 10:17:57 -0600
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
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [RFC 12/12] rpmsg: add a device ID to also bind to the ADSP
 device
Message-ID: <20200608161757.GA32518@xps15>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
 <20200529073722.8184-13-guennadi.liakhovetski@linux.intel.com>
 <20200604200156.GB26734@xps15>
 <20200605064659.GC32302@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605064659.GC32302@ubuntu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 05, 2020 at 08:46:59AM +0200, Guennadi Liakhovetski wrote:
> Hi Mathieu,
> 
> On Thu, Jun 04, 2020 at 02:01:56PM -0600, Mathieu Poirier wrote:
> > On Fri, May 29, 2020 at 09:37:22AM +0200, Guennadi Liakhovetski wrote:
> > > The ADSP device uses the RPMsg API to connect vhost and VirtIO SOF
> > > Audio DSP drivers on KVM host and guest.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > ---
> > >  drivers/rpmsg/virtio_rpmsg_bus.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> > > index f3bd050..ebe3f19 100644
> > > --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> > > +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> > > @@ -949,6 +949,7 @@ static void rpmsg_remove(struct virtio_device *vdev)
> > >  
> > >  static struct virtio_device_id id_table[] = {
> > >  	{ VIRTIO_ID_RPMSG, VIRTIO_DEV_ANY_ID },
> > > +	{ VIRTIO_ID_ADSP, VIRTIO_DEV_ANY_ID },
> > 
> > I am fine with this patch but won't add an RB because of the (many) checkpatch
> > errors.  Based on the comment I made on the previous set seeing those was
> > unexpected.
> 
> Are you using "--strict?" Sorry, I don't see any checkpatch errors, only warnings. 

No, plane checkpatch on the rproc-next branch.

> Most of them are "over 80 characters" which as we now know is no more an issue,

There is a thread discussing the matter but I have not seen a clear resolution
yet.
 
> I just haven't updated my tree yet. Most others are really minor IMHO. Maybe one

Minor or not, if checkpatch complains then it is important enough to address.  I
am willing to overlook the lines over 80 characters but everything else needs to
be dealt with.

Thanks,
Mathieu
 
> of them I actually would want to fix - using "help" instead of "---help---" in 
> Kconfig. What errors are you seeing in your checks?
> 
> Thanks
> Guennadi
> 
> > Thanks,
> > Mathieu
> > 
> > >  	{ 0 },
> > >  };
> > >  
> > > -- 
> > > 1.9.3
> > > 
