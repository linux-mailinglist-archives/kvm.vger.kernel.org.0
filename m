Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3EB1A1AB5
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 06:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDHEAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 00:00:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:12733 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgDHEAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 00:00:22 -0400
IronPort-SDR: fcZA7fQERZUq2zf7yil4HR7pd4u9R4djaZni0CONZOlTJEIcLBamnKRzIKYp4up3gLulLaLQxs
 Hwx/mH9fvn8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 21:00:21 -0700
IronPort-SDR: f9f374JUMkKx4uPk6CViWMoJ7usS0ImJsEAoos95KEZ8procvMO83u9Ez6k6bMdPzvgEpKaLQq
 uU7jtP826KNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="269639700"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.25])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2020 21:00:21 -0700
Date:   Tue, 7 Apr 2020 21:00:21 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Message-ID: <20200408040021.GS67127@otc-nc-03>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
 <1584880394-11184-3-git-send-email-yi.l.liu@intel.com>
 <20200402165954.48d941ee@w520.home>
 <A2975661238FB949B60364EF0F2C25743A2204FE@SHSMSX104.ccr.corp.intel.com>
 <20200403112545.6c115ba3@w520.home>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D80E13D@SHSMSX104.ccr.corp.intel.com>
 <20200407095801.648b1371@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407095801.648b1371@w520.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex

+ Bjorn

FWIW I can't understand why PCI SIG went different ways with ATS, 
where its enumerated on PF and VF. But for PASID and PRI its only
in PF. 

I'm checking with our internal SIG reps to followup on that.

On Tue, Apr 07, 2020 at 09:58:01AM -0600, Alex Williamson wrote:
> > Is there vendor guarantee that hidden registers will locate at the
> > same offset between PF and VF config space? 
> 
> I'm not sure if the spec really precludes hidden registers, but the
> fact that these registers are explicitly outside of the capability
> chain implies they're only intended for device specific use, so I'd say
> there are no guarantees about anything related to these registers.

As you had suggested in the other thread, we could consider
using the same offset as in PF, but even that's a better guess
still not reliable.

The other option is to maybe extend driver ops in the PF to expose
where the offsets should be. Sort of adding the quirk in the 
implementation. 

I'm not sure how prevalent are PASID and PRI in VF devices. If SIG is resisting 
making VF's first class citizen, we might ask them to add some verbiage
to suggest leave the same offsets as PF open to help emulation software.


> 
> FWIW, vfio started out being more strict about restricting config space
> access to defined capabilities, until...
> 
> commit a7d1ea1c11b33bda2691f3294b4d735ed635535a
> Author: Alex Williamson <alex.williamson@redhat.com>
> Date:   Mon Apr 1 09:04:12 2013 -0600
> 

Cheers,
Ashok

