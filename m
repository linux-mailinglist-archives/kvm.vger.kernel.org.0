Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB2922B8CE
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 23:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgGWVkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 17:40:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:49151 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgGWVkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 17:40:41 -0400
IronPort-SDR: QYZrAG2UZimOo0rHAIV4S9E6Dcld4eTCNWZPTbMQgsIVIhFB/ax/6prlaFi5X8RvkM17ppSs2n
 bk8lZ4wzCxYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130701915"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="130701915"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 14:40:40 -0700
IronPort-SDR: d8OBUfzyhIUtrluHwoWBiEPYaGXZ+sJT4Sw1hBqSikxetw67LHKcbn4BFC2pFvvdSQsrr1R7G9
 ZmShiXK962EQ==
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="463007280"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 14:40:37 -0700
Date:   Thu, 23 Jul 2020 22:40:29 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     herbert@gondor.apana.org.au, cohuck@redhat.com, nhorman@redhat.com,
        vdronov@redhat.com, bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] vfio/pci: Add device blocklist
Message-ID: <20200723214029.GA6572@silpixa00400314>
References: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
 <20200714063610.849858-3-giovanni.cabiddu@intel.com>
 <20200722230210.55b2d326@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722230210.55b2d326@x1.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 11:02:10PM -0600, Alex Williamson wrote:
> On Tue, 14 Jul 2020 07:36:07 +0100
> Giovanni Cabiddu <giovanni.cabiddu@intel.com> wrote:
> 
> > Add blocklist of devices that by default are not probed by vfio-pci.
> > Devices in this list may be susceptible to untrusted application, even
> > if the IOMMU is enabled. To be accessed via vfio-pci, the user has to
> > explicitly disable the blocklist.
> > 
> > The blocklist can be disabled via the module parameter disable_blocklist.
> > 
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> 
> Hi Giovanni,
> 
> I'm pretty satisfied with this series, except "blocklist" makes me
> think of block devices, ie. storage, or block chains, or building block
> types of things before I get to "block" as in a barrier.  The other
> alternative listed as a suggestion currently in linux-next is denylist,
> which is the counter to an allowlist.  I've already proposed changing
> some other terminology in vfio.c to use the term "allowed", so
> allow/deny would be my preference versus pass/block.
Thanks Alex for your feedback. A new revision is on the way.

Regards,

-- 
Giovanni
