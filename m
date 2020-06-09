Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2871D1F40BD
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 18:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgFIQ0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 12:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgFIQ0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 12:26:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F55FC03E97C
        for <kvm@vger.kernel.org>; Tue,  9 Jun 2020 09:26:48 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 23so9397587pfw.10
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 09:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PD+qPdtMsGS1L01tmMHguU9Uu9Qedxbopt/Br3SoS40=;
        b=KsV/udHdF2omdWbVte24mOMgZevtOzz0zaEWYVJa1v0U2r6qQNsVbBvPOfDLMTIQyc
         yoHeHRHTdq2zxA1uJR8ZU9ciD9zHQxbIdqbMtgAe1Y/3pUqw806uGxq4w+HnpSnrWBND
         JskhhmnK5sfhKMDIpG1hy9s/XdDTV/VgptQRpB7nm2hdUXy/K5f3o0GLpCmriMsmAFYv
         IDNpD27hl0NLAwnTWm8PptYzKsTToDlhD+ebkJeR7iMSf/54pwYgWP1xBF4YTkO9e/eR
         DwHTdNQQizr7GiU++GBXVPSzRMSPGYMFgl76fbQ1BBZgrC7Na8myrM+mCnkoIscC3hd2
         xpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PD+qPdtMsGS1L01tmMHguU9Uu9Qedxbopt/Br3SoS40=;
        b=hRH/qH/texBTr5tjRi8MTJc2alPzHPNLUHOWb7fXm5YwhtEogc3GhyK16jKsBVjehF
         k4CRXelXeCUO1stmaXUoK+tseZXaC91RD1sdxYE4xSHxGYr1bLyYoTkM7QVaTIsYQwGd
         uLZ2z1qoEpP7CpqtYqS35ND4eTiQNmTuZ1unSjQaaIHtUtZHg+Rswg0jvzFyHz3mltuD
         S1I4aVlz+0ym8KoGtg7KClV/DWs9Mq3en8waoArYsqv1PPfH0d14wII58b81t8bqCQLG
         d3G/0Etlapsh5DbpGXGPujNrYAQdR+lJn5UGtwzCT1du8Npz5QNUUQxTpIjRFmoNncAC
         KadQ==
X-Gm-Message-State: AOAM532bMs03dlFN47bVjBL5O9Zv9bZAFYohKcPoHmf3lpY9lT/WtCWj
        +elD+/BX9GVb5KD9O6ASaI9xHQ==
X-Google-Smtp-Source: ABdhPJxMCqvoeQUNXti3JRrF9iZcD52gvFk7dXgkL+XY9nS435lRgDczRix/SqcEVYhAzx6b9x1cDw==
X-Received: by 2002:a63:e008:: with SMTP id e8mr24693556pgh.451.1591720007759;
        Tue, 09 Jun 2020 09:26:47 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id z8sm8876098pgc.80.2020.06.09.09.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 09:26:47 -0700 (PDT)
Date:   Tue, 9 Jun 2020 10:26:45 -0600
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
Message-ID: <20200609162645.GA23371@xps15>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
 <20200529073722.8184-13-guennadi.liakhovetski@linux.intel.com>
 <20200604200156.GB26734@xps15>
 <20200605064659.GC32302@ubuntu>
 <20200608161757.GA32518@xps15>
 <20200608170227.GG10562@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608170227.GG10562@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 07:02:27PM +0200, Guennadi Liakhovetski wrote:
> Hi Mathieu,
> 
> On Mon, Jun 08, 2020 at 10:17:57AM -0600, Mathieu Poirier wrote:
> > On Fri, Jun 05, 2020 at 08:46:59AM +0200, Guennadi Liakhovetski wrote:
> > > Hi Mathieu,
> > > 
> > > On Thu, Jun 04, 2020 at 02:01:56PM -0600, Mathieu Poirier wrote:
> > > > On Fri, May 29, 2020 at 09:37:22AM +0200, Guennadi Liakhovetski wrote:
> > > > > The ADSP device uses the RPMsg API to connect vhost and VirtIO SOF
> > > > > Audio DSP drivers on KVM host and guest.
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > > ---
> > > > >  drivers/rpmsg/virtio_rpmsg_bus.c | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > > 
> > > > > diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> > > > > index f3bd050..ebe3f19 100644
> > > > > --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> > > > > +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> > > > > @@ -949,6 +949,7 @@ static void rpmsg_remove(struct virtio_device *vdev)
> > > > >  
> > > > >  static struct virtio_device_id id_table[] = {
> > > > >  	{ VIRTIO_ID_RPMSG, VIRTIO_DEV_ANY_ID },
> > > > > +	{ VIRTIO_ID_ADSP, VIRTIO_DEV_ANY_ID },
> > > > 
> > > > I am fine with this patch but won't add an RB because of the (many) checkpatch
> > > > errors.  Based on the comment I made on the previous set seeing those was
> > > > unexpected.
> > > 
> > > Are you using "--strict?" Sorry, I don't see any checkpatch errors, only warnings. 
> > 
> > No, plane checkpatch on the rproc-next branch.
> > 
> > > Most of them are "over 80 characters" which as we now know is no more an issue,
> > 
> > There is a thread discussing the matter but I have not seen a clear resolution
> > yet.
> 
> I think the resolution is pretty clear as defined by Linus, but maybe it has changed 
> again since I last checked.
> 
> > > I just haven't updated my tree yet. Most others are really minor IMHO. Maybe one
> > 
> > Minor or not, if checkpatch complains then it is important enough to address.  I
> > am willing to overlook the lines over 80 characters but everything else needs to
> > be dealt with.
> 
> Sure, checkpatch should be run before each patch submission and whatever it reports 
> should be considered. As Documentation/process/submitting-patches.rst clearly 
> states:
> 
> "Check your patches with the patch style checker prior to submission
> (scripts/checkpatch.pl).  Note, though, that the style checker should be
> viewed as a guide, not as a replacement for human judgment.  If your code
> looks better with a violation then its probably best left alone."
> 
> So, yes, I checked all what checkepatch reported and used my judgement to decide 
> which recommendations to take and which to ignore.

I will let Michael and friends decide how to handle checkpatch warnings in the
vhost subsystem but as far as remoteproc/rpmsg are concerned, I will not review
patches that trigger warnings.

There is a patch in linux-next that deprecates warnings for lines over 80
characters, so those are no longer a problem.

> 
> Thanks
> Guennadi
> 
> > Thanks,
> > Mathieu
> >  
> > > of them I actually would want to fix - using "help" instead of "---help---" in 
> > > Kconfig. What errors are you seeing in your checks?
> > > 
> > > Thanks
> > > Guennadi
> > > 
> > > > Thanks,
> > > > Mathieu
> > > > 
> > > > >  	{ 0 },
> > > > >  };
> > > > >  
> > > > > -- 
> > > > > 1.9.3
> > > > > 
