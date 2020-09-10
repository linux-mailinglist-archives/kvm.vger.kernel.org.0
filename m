Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02702645B4
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 14:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgIJMHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 08:07:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:26758 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730383AbgIJMG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 08:06:57 -0400
IronPort-SDR: 66lxC1+WBHnMDxj50R/LN2QtI2W0C8bC0A7b/Hl15y4UA0/gBS3DRY6cNW9ncMXWeE1WCk8ffY
 729doFoNF7JQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="138029042"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="138029042"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 04:19:38 -0700
IronPort-SDR: /YodJdJw+QHAazflo0hTJtkpB22ZUvLnCM9DrgsaEJGiTtbZmWhqIL+Sm/rKP5+iFzNh/JrLAy
 yvJhZ0k+wNNQ==
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="480850194"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.39.14])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 04:19:35 -0700
Date:   Thu, 10 Sep 2020 13:19:32 +0200
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
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v5 3/4] rpmsg: update documentation
Message-ID: <20200910111932.GC17698@ubuntu>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-4-guennadi.liakhovetski@linux.intel.com>
 <20200909224521.GC562265@xps15>
 <20200910071841.GA17698@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910071841.GA17698@ubuntu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 10, 2020 at 09:18:41AM +0200, Guennadi Liakhovetski wrote:
> On Wed, Sep 09, 2020 at 04:45:21PM -0600, Mathieu Poirier wrote:
> > On Wed, Aug 26, 2020 at 07:46:35PM +0200, Guennadi Liakhovetski wrote:
> > > rpmsg_create_ept() takes struct rpmsg_channel_info chinfo as its last
> > > argument, not a u32 value. The first two arguments are also updated.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > ---
> > >  Documentation/rpmsg.txt | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
> > > index 24b7a9e1a5f9..1ce353cb232a 100644
> > > --- a/Documentation/rpmsg.txt
> > > +++ b/Documentation/rpmsg.txt
> > > @@ -192,9 +192,9 @@ Returns 0 on success and an appropriate error value on failure.
> > >  
> > >  ::
> > >  
> > > -  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
> > > -		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
> > > -		void *priv, u32 addr);
> > > +  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_device *rpdev,
> > > +					  rpmsg_rx_cb_t cb, void *priv,
> > > +					  struct rpmsg_channel_info chinfo);
> > 
> > Again I don't see this being used in this set...  It should have been sent on
> > its own to the remoteproc and documentation mailing list.  Note that
> > Documentation/rpmsg.txt is now Documentation/staging/rpmsg.rst

But you haven't pulled that change into your tree yet. Should I send as is for now 
or wait for you to cherry-pick that change?

> Sure, can send it separately.
> 
> Thanks
> Guennadi
> 
> > >  every rpmsg address in the system is bound to an rx callback (so when
> > >  inbound messages arrive, they are dispatched by the rpmsg bus using the
> > > -- 
> > > 2.28.0
> > > 
