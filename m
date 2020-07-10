Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B221BA7A
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgGJQNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:13:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:8091 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgGJQNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 12:13:13 -0400
IronPort-SDR: R17TjykX77qZbOiYbXLgRVul63IDuz46hD4FRRcyC6R69ylprATWEqML+VfF92xjOA1RTPd0/4
 GX44B+kquOew==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="128300281"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="128300281"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 09:13:12 -0700
IronPort-SDR: jCFRZBYwafKk1P9ty315rWxvNA8m3KZsVPIpoyIPY1lCt6htKnYnQ+/O7PYoMVLlPIo5Tm8fY6
 HhoMQTvIebiw==
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="458324272"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 09:13:09 -0700
Date:   Fri, 10 Jul 2020 17:13:02 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     alex.williamson@redhat.com, herbert@gondor.apana.org.au,
        cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] vfio/pci: add blocklist and disable qat
Message-ID: <20200710161302.GA411219@silpixa00400314>
References: <20200701110302.75199-1-giovanni.cabiddu@intel.com>
 <20200701124209.GA12512@infradead.org>
 <20200710154807.GA7292@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710154807.GA7292@infradead.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 04:48:07PM +0100, Christoph Hellwig wrote:
> On Wed, Jul 01, 2020 at 01:42:09PM +0100, Christoph Hellwig wrote:
> > On Wed, Jul 01, 2020 at 12:02:57PM +0100, Giovanni Cabiddu wrote:
> > > This patchset defines a blocklist of devices in the vfio-pci module and adds
> > > the current generation of Intel(R) QuickAssist devices to it as they are
> > > not designed to run in an untrusted environment.
> > 
> > How can they not be safe?  If any device is not safe to assign the
> > whole vfio concept has major issues that we need to fix for real instead
> > of coming up with quirk lists for specific IDs.
> 
> No answer yet:  how is this device able to bypass the IOMMU?  Don't
> we have a fundamental model flaw if a random device can bypass the
> IOMMU protection?  Except for an ATS bug I can't really think of a way
> how a device could bypass the IOMMU, and in that case we should just
> disable ATS.
Apologies.
This is specific to the QAT device and described in QATE-39220 in the
QAT release notes:
https://01.org/sites/default/files/downloads/336211-014-qatforlinux-releasenotes-hwv1.7_0.pdf
If a request with an address outside of the IOMMU domain attached to the
device is submitted, the device can lock up or induce a platform hang.

Regards,

-- 
Giovanni
