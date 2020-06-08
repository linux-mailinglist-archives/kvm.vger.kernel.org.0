Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A371F1E10
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 19:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgFHRCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 13:02:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:1701 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730712AbgFHRCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 13:02:48 -0400
IronPort-SDR: e7YH6ST9/vR4d8NLNd5SKEgbwE+340NIlo2+aMK2cXH76NPu7iN2shZqIeqvIryoJBJh5391W4
 qTnO50FhZPkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 10:02:33 -0700
IronPort-SDR: p4KFNaWueYHUWVFFaEvmfRaE7L2L3X79MfyU23nJE5C9UKdgy8vS9D3H67NaNJHIg/fzsweu60
 3FRFbfslAMJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="472767150"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.46.212])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jun 2020 10:02:29 -0700
Date:   Mon, 8 Jun 2020 19:02:27 +0200
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
Message-ID: <20200608170227.GG10562@ubuntu>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
 <20200529073722.8184-13-guennadi.liakhovetski@linux.intel.com>
 <20200604200156.GB26734@xps15>
 <20200605064659.GC32302@ubuntu>
 <20200608161757.GA32518@xps15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608161757.GA32518@xps15>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mathieu,

On Mon, Jun 08, 2020 at 10:17:57AM -0600, Mathieu Poirier wrote:
> On Fri, Jun 05, 2020 at 08:46:59AM +0200, Guennadi Liakhovetski wrote:
> > Hi Mathieu,
> > 
> > On Thu, Jun 04, 2020 at 02:01:56PM -0600, Mathieu Poirier wrote:
> > > On Fri, May 29, 2020 at 09:37:22AM +0200, Guennadi Liakhovetski wrote:
> > > > The ADSP device uses the RPMsg API to connect vhost and VirtIO SOF
> > > > Audio DSP drivers on KVM host and guest.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > ---
> > > >  drivers/rpmsg/virtio_rpmsg_bus.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> > > > index f3bd050..ebe3f19 100644
> > > > --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> > > > +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> > > > @@ -949,6 +949,7 @@ static void rpmsg_remove(struct virtio_device *vdev)
> > > >  
> > > >  static struct virtio_device_id id_table[] = {
> > > >  	{ VIRTIO_ID_RPMSG, VIRTIO_DEV_ANY_ID },
> > > > +	{ VIRTIO_ID_ADSP, VIRTIO_DEV_ANY_ID },
> > > 
> > > I am fine with this patch but won't add an RB because of the (many) checkpatch
> > > errors.  Based on the comment I made on the previous set seeing those was
> > > unexpected.
> > 
> > Are you using "--strict?" Sorry, I don't see any checkpatch errors, only warnings. 
> 
> No, plane checkpatch on the rproc-next branch.
> 
> > Most of them are "over 80 characters" which as we now know is no more an issue,
> 
> There is a thread discussing the matter but I have not seen a clear resolution
> yet.

I think the resolution is pretty clear as defined by Linus, but maybe it has changed 
again since I last checked.

> > I just haven't updated my tree yet. Most others are really minor IMHO. Maybe one
> 
> Minor or not, if checkpatch complains then it is important enough to address.  I
> am willing to overlook the lines over 80 characters but everything else needs to
> be dealt with.

Sure, checkpatch should be run before each patch submission and whatever it reports 
should be considered. As Documentation/process/submitting-patches.rst clearly 
states:

"Check your patches with the patch style checker prior to submission
(scripts/checkpatch.pl).  Note, though, that the style checker should be
viewed as a guide, not as a replacement for human judgment.  If your code
looks better with a violation then its probably best left alone."

So, yes, I checked all what checkepatch reported and used my judgement to decide 
which recommendations to take and which to ignore.

Thanks
Guennadi

> Thanks,
> Mathieu
>  
> > of them I actually would want to fix - using "help" instead of "---help---" in 
> > Kconfig. What errors are you seeing in your checks?
> > 
> > Thanks
> > Guennadi
> > 
> > > Thanks,
> > > Mathieu
> > > 
> > > >  	{ 0 },
> > > >  };
> > > >  
> > > > -- 
> > > > 1.9.3
> > > > 
