Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2CE26FABE
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 12:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgIRKjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 06:39:10 -0400
Received: from smtp2.axis.com ([195.60.68.18]:11297 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgIRKjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 06:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=2468; q=dns/txt; s=axis-central1;
  t=1600425549; x=1631961549;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dfHnCSDcQJsHwmC06UCTmcgXTK9CGBepW1LnH1PWlIk=;
  b=p6keZAG3gb+Rz7zTgOy/sjTLfDkdYEHRkhfBwJMX/3uTg1WrVXNrbRrd
   HjmZyxoW7lw3Y4WETJyctOlY0CrHZE5xoeFRMSXcRxelZGBYKpKjxAr/J
   qiMEqwZnLQbVtMSLE4lC0RFHzoesdoKfzFikknmwFe4XdEMRpmbYC/mbc
   KHNbmMBLmNDFIsneSDLgj4KVKv17umxLtfEOcXJmz4CnwdRTNB3H6OHpn
   NmPUJy8HGdK67EhALMYJFnDv1+arkIqvaBVd6XMI1fQxL5o88jkrBr/ZC
   OaFQSQtaS+2VjXI4k9IYgLBgrXVU+LuIiryF/xk4oXG3UUz86LwHUSKGG
   w==;
IronPort-SDR: doNySO46aU7fpJx9Wb/YAZM9E8th1TVYK39QygX4h1SShuVKErS025dPWgD27AIlM77ydSAhwj
 AnrzCp0kYOml32Cs9FJH4Lt/Vwf+ysIas/4JFaqA6mHr1yDnG9JiX+WygQCK4Kxh/dDdvIHWmI
 6Ik0qxLpcA7wl8SjN+o0jduO3uuWxHI+BPhshHZnLZakGN0EWdLzMEJ6pCHWq7TPiQP/DqoOV/
 p7J/naBBMaHIL362CU6ydYLN+et06Nu1oInTwz5RnBzezJ0+8rKCL8gUFqEtWDVBjTtPBGZ8XS
 z0c=
X-IronPort-AV: E=Sophos;i="5.77,274,1596492000"; 
   d="scan'208";a="12633924"
Date:   Fri, 18 Sep 2020 12:39:07 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
CC:     Arnaud POULIQUEN <arnaud.pouliquen@st.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "sound-open-firmware@alsa-project.org" 
        <sound-open-firmware@alsa-project.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
Message-ID: <20200918103907.2ts4l5xiwm4542rs@axis.com>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
 <9433695b-5757-db73-bd8a-538fd1375e2a@st.com> <20200917054705.GA11491@ubuntu>
 <47a9ad01-c922-3b1c-84de-433f229ffba3@st.com> <20200918054420.GA19246@ubuntu>
 <0b7d9004-d71b-8b9a-eaed-f92833ce113f@st.com> <20200918094719.GD19246@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200918094719.GD19246@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 18, 2020 at 11:47:20AM +0200, Guennadi Liakhovetski wrote:
> On Fri, Sep 18, 2020 at 09:47:45AM +0200, Arnaud POULIQUEN wrote:
> > IMO, as this API is defined in the Linux documentation [5] we should respect it, to ensure
> > one generic implementation. The RPMsg sample client[4] uses this user API, so seems to me
> > a good candidate to verify this. 
> > 
> > That's said, shall we multiple the RPMsg implementations in Linux with several APIs,
> > With the risk to make the RPMsg clients devices dependent on these implementations?
> > That could lead to complex code or duplications...
> 
> So, no, in my understanding there aren't two competing alternative APIs, you'd never have 
> to choose between them. If you're writing a driver for Linux to communicate with remote 
> processors or to run on VMs, you use the existing API. If you're writing a driver for 
> Linux to communicate with those VMs, you use the vhost API and whatever help is available 
> for RPMsg processing.
> 
> However, I can in principle imagine a single driver, written to work on both sides. 
> Something like the rpmsg_char.c or maybe some networking driver. Is that what you're 
> referring to? I can see that as a fun exercise, but are there any real uses for that? 

I hinted at a real use case for this in the previous mail thread[0].
I'm exploring using rpmsg-char to allow communication between two chips,
both running Linux.  rpmsg-char can be used pretty much as-is for both
sides of the userspace-to-userspace communication and (the userspace
side of the) userspace-to-kernel communication between the two chips.

> You could do the same with VirtIO, however, it has been decided to go with two 
> distinct APIs: virtio for guests and vhost for the host, noone bothered to create a 
> single API for both and nobody seems to miss one. Why would we want one with RPMsg?

I think I answered this question in the previous mail thread as well[1]:
| virtio has distinct driver and device roles so the completely different
| APIs on each side are understandable.  But I don't see that distinction
| in the rpmsg API which is why it seems like a good idea to me to make it
| work from both sides of the link and allow the reuse of drivers like
| rpmsg-char, instead of imposing virtio's distinction on rpmsg.

[0] https://www.spinics.net/lists/linux-virtualization/msg43799.html
[1] https://www.spinics.net/lists/linux-virtualization/msg43802.html
