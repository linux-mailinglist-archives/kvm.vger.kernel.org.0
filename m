Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6913B1F13A9
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 09:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgFHHhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 03:37:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:45867 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbgFHHhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 03:37:21 -0400
IronPort-SDR: 8dD/nrT2GjlEUkHhXfOuaLy0lM7kOQRIfqg73UvhAJL/VGOTTKnXVyeIDoZ88CaBp9DbTxKKbj
 el1oejH00mSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 00:37:20 -0700
IronPort-SDR: 0MbWgAOzst80uRoqCZyGU9kY1/hY94HQs2KGF+L7ExL4Mb/GJwVBRYNnJGJEei4CbpeZ6+jl0v
 Qiu36kiErNQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="417947180"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.46.212])
  by orsmga004.jf.intel.com with ESMTP; 08 Jun 2020 00:37:16 -0700
Date:   Mon, 8 Jun 2020 09:37:15 +0200
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
Message-ID: <20200608073715.GA10562@ubuntu>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200604151917-mutt-send-email-mst@kernel.org>
 <20200605063435.GA32302@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605063435.GA32302@ubuntu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On Fri, Jun 05, 2020 at 08:34:35AM +0200, Guennadi Liakhovetski wrote:
> 
> On Thu, Jun 04, 2020 at 03:23:37PM -0400, Michael S. Tsirkin wrote:

[snip]

> > Another it's out of line with 1.0 spec passing guest
> > endian data around. Won't work if host and guest
> > endian-ness do not match. Should pass eveything in LE and
> > convert.
> 
> Yes, I have to fix this, thanks.

Just to make sure my understanding is correct: this would involve also 
modifying the current virtio_rpmsg_bus.c implementation to add 
endianness conversions. That's what you meant, right?

Thanks
Guennadi
