Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A532D4720
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 17:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbgLIQtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 11:49:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:64346 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgLIQtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 11:49:01 -0500
IronPort-SDR: 8vL2cbFoN8Sci9uWKh8bJ4nOymwuYvkLF9m1nWsWbcqaylA/Tt4AWmqU8kDPai+Ct6REQ2utv0
 XBFWwXU9omPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="153913835"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="153913835"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 08:47:15 -0800
IronPort-SDR: 6xvAWiJglxtnxpO0kZJ80PwAlRLuWCAd/Zq7n4ngzD+rekWQjdcFdwC1Vb3WC6zrkzYQM4qQpH
 yxkcVd/6RciQ==
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="318354384"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 08:47:14 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kn2dU-00DB7u-33; Wed, 09 Dec 2020 18:48:16 +0200
Date:   Wed, 9 Dec 2020 18:48:16 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Auger Eric <eric.auger@redhat.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/5] vfio: platform: Switch to use
 platform_get_mem_or_io_resource()
Message-ID: <20201209164816.GS4077@smile.fi.intel.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
 <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
 <fb0b02a0-d672-0ff8-be80-b95bdbb58e57@redhat.com>
 <20201203130719.GX4077@smile.fi.intel.com>
 <X9Djagfnvsr7V6Ey@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9Djagfnvsr7V6Ey@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 09, 2020 at 03:47:06PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 03, 2020 at 03:07:19PM +0200, Andy Shevchenko wrote:
> > On Thu, Dec 03, 2020 at 01:54:38PM +0100, Auger Eric wrote:
> > > On 10/27/20 6:58 PM, Andy Shevchenko wrote:
> > > > Switch to use new platform_get_mem_or_io_resource() instead of
> > > > home grown analogue.
> > > > 
> > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > > Cc: kvm@vger.kernel.org
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Acked-by: Eric Auger <eric.auger@redhat.com>
> > 
> > Thanks!
> > 
> > Greg, do I need to do anything else with this series?
> 
> Have them taken by the vfio maintainers?  I'm not that person :)

But it can't be done with a first patch that provides a new API.
The rest seems under your realm, if I didn't miss anything.
Btw, VFIO agreed on the change (as per given tags).

-- 
With Best Regards,
Andy Shevchenko


