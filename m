Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9BF2D44A9
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 15:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733183AbgLIOqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 09:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733175AbgLIOqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 09:46:30 -0500
Date:   Wed, 9 Dec 2020 15:47:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607525149;
        bh=13dtfJXK19PC/ajWevd6lvwNx7+Jh/ctt2e11Ga5UW0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=taIOZvUImHeJBb1E8TqqOkaRt/PnPvlFb+L8RdcFZ9qc91/+K649byThIkJayUK8D
         fmpWE2TvegHJIk+jLu9OvVeepjr2pZF8PVLAmbiQ7a04p6TRUrclZXrse8peEcDBtR
         aWh+KdpN1q7Vf1bbqqCfznXwUnahj04cETpAWf9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Auger Eric <eric.auger@redhat.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/5] vfio: platform: Switch to use
 platform_get_mem_or_io_resource()
Message-ID: <X9Djagfnvsr7V6Ey@kroah.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
 <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
 <fb0b02a0-d672-0ff8-be80-b95bdbb58e57@redhat.com>
 <20201203130719.GX4077@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203130719.GX4077@smile.fi.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 03, 2020 at 03:07:19PM +0200, Andy Shevchenko wrote:
> On Thu, Dec 03, 2020 at 01:54:38PM +0100, Auger Eric wrote:
> > Hi Andy,
> > 
> > On 10/27/20 6:58 PM, Andy Shevchenko wrote:
> > > Switch to use new platform_get_mem_or_io_resource() instead of
> > > home grown analogue.
> > > 
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > Cc: kvm@vger.kernel.org
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Acked-by: Eric Auger <eric.auger@redhat.com>
> 
> Thanks!
> 
> Greg, do I need to do anything else with this series?

Have them taken by the vfio maintainers?  I'm not that person :)
