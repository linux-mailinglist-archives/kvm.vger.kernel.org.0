Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0F226B96C
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 03:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgIPBeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 21:34:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:49975 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgIPBeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 21:34:05 -0400
IronPort-SDR: jYtZe6N2Jm47X6p20D133IfZkBgh5y0WZGFYTn2ZFB8Fiw/YH6jmR4xMjeNbo+vXu6PS3oK21I
 83t1sqNLz6aA==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="160314308"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="160314308"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 18:34:04 -0700
IronPort-SDR: zv+n+at9i1NMfj5WzjxhlFKQP0m5WZkDl+mQQDmbXfxuRVSAjFllsrO577hzDvlIUZr34oJHe6
 odMogtaZD4aw==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="483090074"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 18:34:02 -0700
Date:   Wed, 16 Sep 2020 09:33:00 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: fix a missed vfio group put in vfio_pin_pages
Message-ID: <20200916013259.GA18934@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200915002835.14213-1-yan.y.zhao@intel.com>
 <20200915110601.5adb7129.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915110601.5adb7129.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 11:06:01AM +0200, Cornelia Huck wrote:
> On Tue, 15 Sep 2020 08:28:35 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > when error occurs, need to put vfio group after a successful get.
> > 
> > Fixes: 95fc87b44104 (vfio: Selective dirty page tracking if IOMMU backed
> > device pins pages)
> 
> The format of the Fixes: line should be
> 
> Fixes: 95fc87b44104 ("vfio: Selective dirty page tracking if IOMMU backed device pins pages")
> 
got it. thanks! I'll update it.

Thanks
Yan
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/vfio.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
