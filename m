Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410531FEE45
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 11:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgFRJDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 05:03:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:51740 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbgFRJDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 05:03:48 -0400
IronPort-SDR: Xp0RTI8c6kbb+VsF6d38iUSdr5kquLxg97SIyNTTT7P3S+uTP26bAc3+XLmr3lIefSfKJtzWq9
 2GyfNypcVv8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="140002609"
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="140002609"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 02:03:48 -0700
IronPort-SDR: /6kHDHX7wY1CRf0e6PPCtYuooZMheWGl/tF42hkNHlSAubcrMt9WbD6cJYqo6V6SVrDIB93lxX
 COgb867Ow9Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="261966815"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.48.152])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jun 2020 02:03:44 -0700
Date:   Thu, 18 Jun 2020 11:03:42 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 5/5] vhost: add an RPMsg API
Message-ID: <20200618090341.GA4189@ubuntu>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200527180541.5570-6-guennadi.liakhovetski@linux.intel.com>
 <20200617191741.whnp7iteb36cjnia@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617191741.whnp7iteb36cjnia@axis.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vincent,

On Wed, Jun 17, 2020 at 09:17:42PM +0200, Vincent Whitchurch wrote:
> On Wed, May 27, 2020 at 08:05:41PM +0200, Guennadi Liakhovetski wrote:
> > Linux supports running the RPMsg protocol over the VirtIO transport
> > protocol, but currently there is only support for VirtIO clients and
> > no support for a VirtIO server. This patch adds a vhost-based RPMsg
> > server implementation.
> 
> This looks really useful, but why is it implemented as an API and not as
> a real vhost driver which implements an rpmsg bus?  If you implement it
> as a vhost driver which implements rpmsg_device_ops and
> rpmsg_endpoint_ops, then wouldn't you be able to implement your
> vhost-sof driver using the normal rpmsg APIs?

Sorry, not sure what you mean by the "normal rpmsg API?" Do you mean the 
VirtIO RPMsg API? But that's the opposite side of the link - that's the 
guest side in the VM case and the Linux side in the remoteproc case. What 
this API is adding is a vhost RPMsg API. The kernel vhost framework 
itself is essentially a library of functions. Kernel vhost drivers simply 
create a misc device and use the vhost functions for some common 
functionality. This RPMsg vhost API stays in the same concept and provides 
further functions for RPMsg specific vhost operation.

> I tried quickly hooking up this code to such a vhost driver and I was
> able to communicate between host and guest systems with both
> rpmsg-client-sample and rpmsg-char which almost no modifications to
> those drivers.

You mean you used this patch to create RPMsg vhost drivers? Without 
creating a vhost RPMsg bus? Nice, glad to hear that!

Thanks
Guennadi
