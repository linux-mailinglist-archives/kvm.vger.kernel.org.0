Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CA42D4736
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 17:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbgLIQxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 11:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730461AbgLIQxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 11:53:14 -0500
Date:   Wed, 9 Dec 2020 17:53:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607532754;
        bh=FDDBiLQb2dVjoSLhKuuYxRuHAeK2uDAa1OmNYumqiCc=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=g8Uh1BgweQQPLTapykYMYc6xMcjapbd0ZgGQwVObEWxJ2sH6zsWiv1H8upqoC2SpL
         zv7UA6QEsNQsXvYFK4ZmSNf9RpJ+zpDxHLz1MzfVGJIzjSxsX09thMUrtqPQxEBg65
         lKVQ+Gop96/kghWp/CskH36UEPRQko8E3QyO2Lc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Auger Eric <eric.auger@redhat.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/5] vfio: platform: Switch to use
 platform_get_mem_or_io_resource()
Message-ID: <X9EBGV/Tnuk/HzOH@kroah.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
 <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
 <fb0b02a0-d672-0ff8-be80-b95bdbb58e57@redhat.com>
 <20201203130719.GX4077@smile.fi.intel.com>
 <X9Djagfnvsr7V6Ey@kroah.com>
 <20201209164816.GS4077@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209164816.GS4077@smile.fi.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 09, 2020 at 06:48:16PM +0200, Andy Shevchenko wrote:
> On Wed, Dec 09, 2020 at 03:47:06PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Dec 03, 2020 at 03:07:19PM +0200, Andy Shevchenko wrote:
> > > On Thu, Dec 03, 2020 at 01:54:38PM +0100, Auger Eric wrote:
> > > > On 10/27/20 6:58 PM, Andy Shevchenko wrote:
> > > > > Switch to use new platform_get_mem_or_io_resource() instead of
> > > > > home grown analogue.
> > > > > 
> > > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > > > Cc: kvm@vger.kernel.org
> > > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Acked-by: Eric Auger <eric.auger@redhat.com>
> > > 
> > > Thanks!
> > > 
> > > Greg, do I need to do anything else with this series?
> > 
> > Have them taken by the vfio maintainers?  I'm not that person :)
> 
> But it can't be done with a first patch that provides a new API.
> The rest seems under your realm, if I didn't miss anything.
> Btw, VFIO agreed on the change (as per given tags).

Ok, can you resend all of these, with the vfio tags added, so I know to
take them all?

thanks,

greg k-h
