Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FA5140164
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 02:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732903AbgAQBUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 20:20:04 -0500
Received: from mga05.intel.com ([192.55.52.43]:63274 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729100AbgAQBUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 20:20:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 17:20:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,327,1574150400"; 
   d="scan'208";a="398482436"
Received: from unknown (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 16 Jan 2020 17:20:02 -0800
Date:   Thu, 16 Jan 2020 20:10:51 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] vfio/type1: Reduce vfio_iommu.lock contention
Message-ID: <20200117011050.GC1759@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <157919849533.21002.4782774695733669879.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157919849533.21002.4782774695733669879.stgit@gimli.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you, Alex!
I'll try it and let you know the result soon. :)

On Fri, Jan 17, 2020 at 02:17:49AM +0800, Alex Williamson wrote:
> Hi Yan,
> 
> I wonder if this might reduce the lock contention you're seeing in the
> vfio_dma_rw series.  These are only compile tested on my end, so I hope
> they're not too broken to test.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (3):
>       vfio/type1: Convert vfio_iommu.lock from mutex to rwsem
>       vfio/type1: Replace obvious read lock instances
>       vfio/type1: Introduce pfn_list mutex
> 
> 
>  drivers/vfio/vfio_iommu_type1.c |   67 ++++++++++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 26 deletions(-)
> 
