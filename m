Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB91B28890D
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 14:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbgJIMnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 08:43:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:56440 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJIMnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 08:43:11 -0400
IronPort-SDR: Dgz9NowuqHeyF2t5fvvpG8OdBX8+IxI8Wxhuzw7Or5bWtmgPg/7OH9j/0EopSqiHPY6v/43Z7C
 2ckPJYkbGTcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="165592474"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="165592474"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 05:43:10 -0700
IronPort-SDR: mbOaxvauxBcqkYS5cswFgFbzINe8QEqu5bJ/bWN0EeIwnWp6+4EEPaUUW5HzGvu1SGaneXGBVn
 jYNQVCGl5L+A==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="354841361"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 05:43:09 -0700
Date:   Fri, 9 Oct 2020 05:43:07 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
Message-ID: <20201009124307.GA63643@otc-nc-03>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de>
 <20201008233210.GH4734@nvidia.com>
 <20201009012231.GA60263@otc-nc-03>
 <20201009115737.GI4734@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009115737.GI4734@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 08:57:37AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 08, 2020 at 06:22:31PM -0700, Raj, Ashok wrote:
> 
> > Not randomly put there Jason :-).. There is a good reason for it. 
> 
> Sure the PASID value being associated with the IRQ make sense, but
> combining that register with the interrupt mask is just a compltely
> random thing to do.

Hummm... Not sure what you are complaining.. but in any case giving
hardware a more efficient way to store interrupt entries breaking any
boundaries that maybe implied by the spec is why IMS was defined.

> 
> If this HW was using MSI-X PASID would have been given its own
> register.

Well there is no MSI-X PASID is there? 
