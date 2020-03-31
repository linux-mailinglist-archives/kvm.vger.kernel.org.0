Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C73198EA5
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 10:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgCaIgg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 31 Mar 2020 04:36:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:3442 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgCaIgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 04:36:36 -0400
IronPort-SDR: +1I4UM7b8oFDzl5KVG7J3dkaaIAzRDkoyRvbiJjn5Y7kAGPZEkC6Z8X841eJ4SwUhSOlABgPUv
 Ldzsb0hH6u1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 01:36:36 -0700
IronPort-SDR: BCHlBz3w0XARy3CBwHjzOnmOqnDLE+mwxJfDmTj2gLrnQ8UhXMtSFpz9HZdK1Kf8uksteX++wd
 2ZgbQX/AXyGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="359435393"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga001.fm.intel.com with ESMTP; 31 Mar 2020 01:36:35 -0700
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 01:36:35 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx122.amr.corp.intel.com (10.18.125.37) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 01:36:35 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.129]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 16:36:31 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHWAEUbC4GB74LMekup8jIcF6WIFqhh3EqAgACPuLCAAAINQA==
Date:   Tue, 31 Mar 2020 08:36:32 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21A9ED@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
 <20200331075331.GA26583@infradead.org>
 <A2975661238FB949B60364EF0F2C25743A21A9BB@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A21A9BB@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L
> Sent: Tuesday, March 31, 2020 4:33 PM
> To: 'Christoph Hellwig' <hch@infradead.org>
> Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
> 
> > From: Christoph Hellwig <hch@infradead.org>
> > Sent: Tuesday, March 31, 2020 3:54 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 1/8] vfio: Add
> > VFIO_IOMMU_PASID_REQUEST(alloc/free)
> >
> > Who is going to use thse exports?  Please submit them together with a
> > driver actually using them.
the user of the symbols are already in this patch. sorry for the split answer..

Regards,
Yi Liu
