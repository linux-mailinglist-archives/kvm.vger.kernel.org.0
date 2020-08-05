Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB5A23D097
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgHETux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:50:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:36706 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbgHEQxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:53:09 -0400
IronPort-SDR: m++JnwnhNHC2gDCRMke7EA/m0X+4cwYfbOsktQqrHDemIVQFAJI6NGH/NaKY4Uv7jPNHwDRQGZ
 N1+54F1GyTpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="150282118"
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="150282118"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 04:58:01 -0700
IronPort-SDR: xjY4nJKgDSVJOnww82VStA1AgiZAiI52l8t0Pt9vLG2oZ8gz3/WUSaA119sAOBSiVfVBer/K+n
 Idwz9Pew0kRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="288901071"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003.jf.intel.com with ESMTP; 05 Aug 2020 04:57:59 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1k3I3T-006aB2-IM; Wed, 05 Aug 2020 14:57:59 +0300
Date:   Wed, 5 Aug 2020 14:57:59 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1] vfio: platform: use platform_get_resource()
Message-ID: <20200805115759.GB3703480@smile.fi.intel.com>
References: <20200804135622.11952-1-andriy.shevchenko@linux.intel.com>
 <20200805130635.373b0daf.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805130635.373b0daf.cohuck@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 01:06:35PM +0200, Cornelia Huck wrote:
> On Tue,  4 Aug 2020 16:56:22 +0300
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > Use platform_get_resource() to fetch the memory resource
> > instead of open-coded variant.

> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Thanks! I have better approach now, please, postpone this one.
I'll send it after v5.9-rc1.

-- 
With Best Regards,
Andy Shevchenko


