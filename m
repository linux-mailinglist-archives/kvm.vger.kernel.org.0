Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB6B1F1764
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 13:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgFHLQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 07:16:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:17355 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgFHLQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 07:16:42 -0400
IronPort-SDR: rpZr5W3iBMzAwoth/g9/KtgFcfqya2pIC9fN7f1xSNnE6woowbTWpa+9bcOdkrQc8infoDNCHU
 4YZDyT9g8Icw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 04:16:42 -0700
IronPort-SDR: dl0qMu7dTDv+wwShs4f6FCGDv2URJOMFnCoSpWPuwosIAU8FdJ3hB6cg3IQtAVv53P8j+CQP/X
 1sto+gbPjG1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="288442494"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.46.212])
  by orsmga002.jf.intel.com with ESMTP; 08 Jun 2020 04:16:39 -0700
Date:   Mon, 8 Jun 2020 13:16:38 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20200608111637.GE10562@ubuntu>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200604151917-mutt-send-email-mst@kernel.org>
 <20200605063435.GA32302@ubuntu>
 <20200608073715.GA10562@ubuntu>
 <20200608091100.GC10562@ubuntu>
 <20200608051358-mutt-send-email-mst@kernel.org>
 <20200608101526.GD10562@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608101526.GD10562@ubuntu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 12:15:26PM +0200, Guennadi Liakhovetski wrote:
> On Mon, Jun 08, 2020 at 05:19:06AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2020 at 11:11:00AM +0200, Guennadi Liakhovetski wrote:
> > > Update: I looked through VirtIO 1.0 and 1.1 specs, data format their, 
> > > including byte order, is defined on a per-device type basis. RPMsg is 
> > > indeed included in the spec as device type 7, but that's the only 
> > > mention of it in both versions. It seems RPMsg over VirtIO isn't 
> > > standardised yet.
> > 
> > Yes. And it would be very good to have some standartization before we
> > keep adding things. For example without any spec if host code breaks
> > with some guests, how do we know which side should be fixed?
> > 
> > > Also it looks like newer interface definitions 
> > > specify using "guest native endianness" for Virtual Queue data.
> > 
> > They really don't or shouldn't. That's limited to legacy chapters.
> > Some definitions could have slipped through but it's not
> > the norm. I just quickly looked through the 1.1 spec and could
> > not find any instances that specify "guest native endianness"
> > but feel free to point them out to me.
> 
> Oh, there you go. No, sorry, my fault, it's the other way round: "guest 
> native" is for legacy and LE is for current / v1.0 and up.
> 
> > > So 
> > > I think the same should be done for RPMsg instead of enforcing LE?
> > 
> > That makes hardware implementations as well as any cross-endian
> > hypervisors tricky.
> 
> Yes, LE it is then. And we need to add some text to the spec.

I found the protocol and the message format definition: 
https://github.com/OpenAMP/open-amp/wiki/RPMsg-Messaging-Protocol#transport-layer---rpmsg 
Don't know what the best way for referencing it in the VirtIO standard 
would be: just a link to the source or a quote.

Thanks
Guennadi
