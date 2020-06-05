Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF701EF1A0
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 08:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFEGrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 02:47:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:23144 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFEGrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 02:47:03 -0400
IronPort-SDR: nG5HF0qsJifcXBhWM3DgyY8yhFzr9CEJaCklWsDFQ+caaXhZaR5H+pzs+pkNYPEsNRveeysd4K
 KrhxsMeblJ9A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 23:47:03 -0700
IronPort-SDR: WnnVVIdiW3il2sBTTZGnfrO6uGvZzsuHI4KDy4CFF86jvS6k0jWo8f+qtxxXS4jRBc5zcbWiKZ
 1UOQN4j0fJVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,475,1583222400"; 
   d="scan'208";a="257952630"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.45.234])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2020 23:47:00 -0700
Date:   Fri, 5 Jun 2020 08:46:59 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
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
Message-ID: <20200605064659.GC32302@ubuntu>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
 <20200529073722.8184-13-guennadi.liakhovetski@linux.intel.com>
 <20200604200156.GB26734@xps15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604200156.GB26734@xps15>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mathieu,

On Thu, Jun 04, 2020 at 02:01:56PM -0600, Mathieu Poirier wrote:
> On Fri, May 29, 2020 at 09:37:22AM +0200, Guennadi Liakhovetski wrote:
> > The ADSP device uses the RPMsg API to connect vhost and VirtIO SOF
> > Audio DSP drivers on KVM host and guest.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > ---
> >  drivers/rpmsg/virtio_rpmsg_bus.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> > index f3bd050..ebe3f19 100644
> > --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> > +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> > @@ -949,6 +949,7 @@ static void rpmsg_remove(struct virtio_device *vdev)
> >  
> >  static struct virtio_device_id id_table[] = {
> >  	{ VIRTIO_ID_RPMSG, VIRTIO_DEV_ANY_ID },
> > +	{ VIRTIO_ID_ADSP, VIRTIO_DEV_ANY_ID },
> 
> I am fine with this patch but won't add an RB because of the (many) checkpatch
> errors.  Based on the comment I made on the previous set seeing those was
> unexpected.

Are you using "--strict?" Sorry, I don't see any checkpatch errors, only warnings. 
Most of them are "over 80 characters" which as we now know is no more an issue, 
I just haven't updated my tree yet. Most others are really minor IMHO. Maybe one 
of them I actually would want to fix - using "help" instead of "---help---" in 
Kconfig. What errors are you seeing in your checks?

Thanks
Guennadi

> Thanks,
> Mathieu
> 
> >  	{ 0 },
> >  };
> >  
> > -- 
> > 1.9.3
> > 
