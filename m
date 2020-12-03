Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06782CD65E
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 14:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgLCNH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 08:07:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:54076 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgLCNH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 08:07:59 -0500
IronPort-SDR: mPIvpCo/CgVoWsm4w0sz25zs3qmVrif7GbZtv0QL11ObuSOwbbhxS46DVWhtwWOS0/sZBjmuqf
 B4y2xWhKkvGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="170620377"
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="170620377"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 05:06:19 -0800
IronPort-SDR: UvQDuSGfUyQVAaRYhL3oQIVCyyY9/eny+pQGu/wImv8HKOMrp9XPh/Nq89gkHSVkVqbqdMBxog
 FgOhISFj2Srg==
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="365772391"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 05:06:17 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kkoKN-00Bl0H-Ku; Thu, 03 Dec 2020 15:07:19 +0200
Date:   Thu, 3 Dec 2020 15:07:19 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/5] vfio: platform: Switch to use
 platform_get_mem_or_io_resource()
Message-ID: <20201203130719.GX4077@smile.fi.intel.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
 <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
 <fb0b02a0-d672-0ff8-be80-b95bdbb58e57@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb0b02a0-d672-0ff8-be80-b95bdbb58e57@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 03, 2020 at 01:54:38PM +0100, Auger Eric wrote:
> Hi Andy,
> 
> On 10/27/20 6:58 PM, Andy Shevchenko wrote:
> > Switch to use new platform_get_mem_or_io_resource() instead of
> > home grown analogue.
> > 
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks!

Greg, do I need to do anything else with this series?

-- 
With Best Regards,
Andy Shevchenko


