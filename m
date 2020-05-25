Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F611E0FE1
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 15:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403890AbgEYNxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 09:53:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:1697 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403805AbgEYNxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 09:53:39 -0400
IronPort-SDR: DCW/11XHepeDbR+69LRbuVduNxM7xaE0u6QSdqq7Duwt6eFzgZbjLvDBYpNLAMPmYbRL0ir9ot
 NkAc2x2UR++g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 06:53:39 -0700
IronPort-SDR: dSNA+hsvMXQ7/TGmbLKjL+2+ct9xikg6bsHiUwaUyF9OiTeNBvGAnD4tO+kDSFVC+NL5D1WoQp
 c8E/WTKvX20g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,433,1583222400"; 
   d="scan'208";a="310010026"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.41.109])
  by FMSMGA003.fm.intel.com with ESMTP; 25 May 2020 06:53:37 -0700
Date:   Mon, 25 May 2020 15:53:36 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: Re: [Sound-open-firmware] [PATCH 5/6] vhost: add an rpmsg API
Message-ID: <20200525135336.GB6761@ubuntu>
References: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
 <20200516101109.2624-6-guennadi.liakhovetski@linux.intel.com>
 <9737e3f2-e59c-0174-9254-a2d8f29f30b7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9737e3f2-e59c-0174-9254-a2d8f29f30b7@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Pierre,

On Sat, May 16, 2020 at 12:00:35PM -0500, Pierre-Louis Bossart wrote:
> 
> > +config VHOST_RPMSG
> > +	tristate
> > +	depends on VHOST
> 
> depends on RPMSG_VIRTIO?

No, RPMSG_VIRTIO is used on the guest side, VHOST_RPMSG (as well as 
all other vhost drivers) on the host side.

> > +	default n
> 
> not needed

Ok, will remove.

Thanks
Guennadi
