Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8DA2CD5A5
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgLCMix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:38:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:59479 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgLCMix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 07:38:53 -0500
IronPort-SDR: Ljj0it0B54IFoxZT5j2csP/ckMYcCC24nSSCITq3k3CG5HuAiRXByI0DxQtJIawxIAybOVdigk
 RFaMOYeP0YRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="160239594"
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="160239594"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 04:37:12 -0800
IronPort-SDR: cQBwOZ63V955vJ+94nNtHgBIL1N0YFZt08ZSeWXMfXnzbTwPA97Uxr+cGpB8g+JmqAiIpDv+wd
 +ApZnkpNDtQQ==
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="481954178"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 04:37:11 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kknsD-00Bkkc-JT; Thu, 03 Dec 2020 14:38:13 +0200
Date:   Thu, 3 Dec 2020 14:38:13 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1] vfio: platform: use platform_get_resource()
Message-ID: <20201203123813.GU4077@smile.fi.intel.com>
References: <20200804135622.11952-1-andriy.shevchenko@linux.intel.com>
 <20200805130635.373b0daf.cohuck@redhat.com>
 <20200805115759.GB3703480@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805115759.GB3703480@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 02:57:59PM +0300, Andy Shevchenko wrote:
> On Wed, Aug 05, 2020 at 01:06:35PM +0200, Cornelia Huck wrote:
> > On Tue,  4 Aug 2020 16:56:22 +0300
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > 
> > > Use platform_get_resource() to fetch the memory resource
> > > instead of open-coded variant.
> 
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
> Thanks! I have better approach now, please, postpone this one.
> I'll send it after v5.9-rc1.

FYI: It's part of the series [1].

[1]: https://lore.kernel.org/lkml/20201028162727.GX4077@smile.fi.intel.com/T/

-- 
With Best Regards,
Andy Shevchenko


