Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0592D48DE
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 19:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbgLISXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 13:23:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:50943 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731010AbgLISXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 13:23:12 -0500
IronPort-SDR: 7at3vIrTFF+kRPfauPKVIm/rEZTAy0tYe8LpJp9+xcZ9Jk4bFXrjJWoLj6YmmyGopPaCfmETxI
 tdvv3xvY6Ubg==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="174269377"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="174269377"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 10:21:24 -0800
IronPort-SDR: prqyeNZqGcbVk2UUGVs3f5otPajswSnH0Lzw0YM9JS9crpTSNEkwdFmcTa7qxHbqiFUqpJxT1g
 gEkHf1YhfxVg==
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="408170410"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 10:21:22 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kn46a-00DCT9-Kt; Wed, 09 Dec 2020 20:22:24 +0200
Date:   Wed, 9 Dec 2020 20:22:24 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Auger Eric <eric.auger@redhat.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/5] vfio: platform: Switch to use
 platform_get_mem_or_io_resource()
Message-ID: <20201209182224.GU4077@smile.fi.intel.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
 <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
 <fb0b02a0-d672-0ff8-be80-b95bdbb58e57@redhat.com>
 <20201203130719.GX4077@smile.fi.intel.com>
 <X9Djagfnvsr7V6Ey@kroah.com>
 <20201209164816.GS4077@smile.fi.intel.com>
 <X9EBGV/Tnuk/HzOH@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9EBGV/Tnuk/HzOH@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 09, 2020 at 05:53:45PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Dec 09, 2020 at 06:48:16PM +0200, Andy Shevchenko wrote:
> > On Wed, Dec 09, 2020 at 03:47:06PM +0100, Greg Kroah-Hartman wrote:
> > > On Thu, Dec 03, 2020 at 03:07:19PM +0200, Andy Shevchenko wrote:
> > > > On Thu, Dec 03, 2020 at 01:54:38PM +0100, Auger Eric wrote:

...

> > > > Greg, do I need to do anything else with this series?

> > > Have them taken by the vfio maintainers?  I'm not that person :)

> > But it can't be done with a first patch that provides a new API.
> > The rest seems under your realm, if I didn't miss anything.
> > Btw, VFIO agreed on the change (as per given tags).

> Ok, can you resend all of these, with the vfio tags added, so I know to
> take them all?

Sure. Will do soon.

-- 
With Best Regards,
Andy Shevchenko


