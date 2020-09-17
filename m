Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A932226D6F0
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 10:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgIQIn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 04:43:59 -0400
Received: from smtp2.axis.com ([195.60.68.18]:7897 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgIQIn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 04:43:58 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 04:43:57 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=1732; q=dns/txt; s=axis-central1;
  t=1600332237; x=1631868237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9NKLIVDraz6+fyMH3+VMwK8eJnp6H6X4d9mocI9g0Kc=;
  b=lqR+O7Qb7Lb88vs7TWjewCwfddCjJ3YNsoufO4exRG6AFL+NF9nX5SUu
   7aKRsOx9xxGAXUN6w27oLDII6e1rvO4u4zuEn4aG4s6+DoghWUIOiGJGh
   pcgqRksPWur2qj7G0JtobNMibJ6cq88zXMXk5lHwcQwy+9JACr80+36m1
   n5S4dWjzeSfyeIELRjFwRWjQm7lTmzmgSef/XB8V76W+X8FXFLPV4YrqW
   Z8HKsGlpA9AaR8iXTV9wyYnAUfP49o65RNAw4q1ekkf8gyu4DFZYUGM4T
   djuu+HMoypcyybQMN5cbYNoWFJLDpYGxN4/2PbzsYNqor5xb5Q0/EelRU
   w==;
IronPort-SDR: oDhvlA/ddrSklE6SljIF/+4cdbbGS38ZQ1+JfYDEJ16X4ULPtiXAW3r6j9cjc5HVT5P/h+lrsE
 iwnX44zhcc9hyXYUSy9ikb40bCPd5b1n8AI4/vg+P8fSdMofqk+PueLiDv1xopJHbRSlY/1DUQ
 I7EoQa5t/QzxOSTeE7WmmbwuaBpQnzyAe489aj+dYnLPmqgnMqiDFlRTkJe7n5mG7VO80wPAwM
 D5Q+TMautFCVhASARpm2xUGtkJaClGq4lRoOCMBdVhKOLK0Agzf/s6aRSZhMDrF6sEPayskDeC
 Jm4=
X-IronPort-AV: E=Sophos;i="5.76,436,1592863200"; 
   d="scan'208";a="12573765"
Date:   Thu, 17 Sep 2020 10:36:44 +0200
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
        Mathieu Poirier <mathieu.poirier@linaro.org>, <kishon@ti.com>
Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
Message-ID: <20200917083644.66yjer4zvoiftrk3@axis.com>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
 <9433695b-5757-db73-bd8a-538fd1375e2a@st.com> <20200917054705.GA11491@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200917054705.GA11491@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 07:47:06AM +0200, Guennadi Liakhovetski wrote:
> On Tue, Sep 15, 2020 at 02:13:23PM +0200, Arnaud POULIQUEN wrote:
> > So i would be agree with Vincent[2] which proposed to switch on a RPMsg API
> > and creating a vhost rpmsg device. This is also proposed in the 
> > "Enhance VHOST to enable SoC-to-SoC communication" RFC[3].
> > Do you think that this alternative could match with your need?
> 
> As I replied to Vincent, I understand his proposal and the approach taken 
> in the series [3], but I'm not sure I agree, that adding yet another 
> virtual device / driver layer on the vhost side is a good idea. As far as 
> I understand adding new completely virtual devices isn't considered to be 
> a good practice in the kernel. Currently vhost is just a passive "library" 
> and my vhost-rpmsg support keeps it that way. Not sure I'm in favour of 
> converting vhost to a virtual device infrastructure.

I know it wasn't what you meant, but I noticed that the above paragraph
could be read as if my suggestion was to convert vhost to a virtual
device infrastructure, so I just want to clarify that that those are not
related.  The only similarity between what I suggested in the thread in
[2] and Kishon's RFC in [3] is that both involve creating a generic
vhost-rpmsg driver which would allow the RPMsg API to be used for both
sides of the link, instead of introducing a new API just for the server
side.  That can be done without rewriting drivers/vhost/.

> > [1]. https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338335 
> > [2]. https://www.spinics.net/lists/linux-virtualization/msg44195.html
> > [3]. https://www.spinics.net/lists/linux-remoteproc/msg06634.html  
