Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C05F1A61BC
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 05:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgDMD3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Apr 2020 23:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgDMD3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Apr 2020 23:29:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804B2C0A3BE0;
        Sun, 12 Apr 2020 20:29:35 -0700 (PDT)
IronPort-SDR: hE7V3V4VpnrkDfnrrC8jxXwcBy+UZT+IP6Q5iCTaZnAduiBIBmMRIXkTTaVW9XsMGo2ERBMKJV
 nDvOGRmi0q/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 20:29:34 -0700
IronPort-SDR: kaY6tSE5sav4RYffzh5Gz8m+KI24+vSEUaId10rWnW/z77yZuUjZQe137BBTWyM9T41eTMKCJy
 8agcj2vT/LvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,377,1580803200"; 
   d="scan'208";a="453023852"
Received: from araj-mobl1.jf.intel.com ([10.255.32.166])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2020 20:29:31 -0700
Date:   Sun, 12 Apr 2020 20:29:31 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     "Raj, Ashok" <ashok.raj@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Wu, Hao" <hao.wu@intel.com>, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Message-ID: <20200413032930.GB18479@araj-mobl1.jf.intel.com>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
 <1584880394-11184-3-git-send-email-yi.l.liu@intel.com>
 <20200402165954.48d941ee@w520.home>
 <A2975661238FB949B60364EF0F2C25743A2204FE@SHSMSX104.ccr.corp.intel.com>
 <20200403112545.6c115ba3@w520.home>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D80E13D@SHSMSX104.ccr.corp.intel.com>
 <20200407095801.648b1371@w520.home>
 <20200408040021.GS67127@otc-nc-03>
 <20200408101940.3459943d@w520.home>
 <20200413031043.GA18183@araj-mobl1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413031043.GA18183@araj-mobl1.jf.intel.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex

Going through the PCIe Spec, there seems a lot of such capabilities
that are different between PF and VF. Some that make sense
and some don't.


On Sun, Apr 12, 2020 at 08:10:43PM -0700, Raj, Ashok wrote:
> 
> > 
> > I agree though, I don't know why the SIG would preclude implementing
> > per VF control of these features.  Thanks,
> > 

For e.g. 

VF doesn't have I/O and Mem space enables, but has BME
Interrupt Status
Correctable Error Reporting
Almost all of Device Control Register.

So it seems like there is a ton of them we have to deal with today for 
VF's. How do we manage to emulate them without any support for them 
in VF's? 


> 
> Cheers,
> Ashok
