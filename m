Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381481A1961
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 03:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDHBC4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Apr 2020 21:02:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:1582 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgDHBC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 21:02:56 -0400
IronPort-SDR: 4dbzYw+tIZR/z0qjm62dvyIFzo08GoWVyPozslIWbuSK0vmX5Gub0GLDyiMsoOsX8NvNl1rTRI
 L5cCGUrJK7zg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 18:02:55 -0700
IronPort-SDR: aoIgWarb9rwY1gMIByAFYJfIksZEwy6R2tUCK1nWiJ/zDgSSL5U3c++igIgFK/DpicWLudRxgt
 tMxJ4x9k/FfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="424955822"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga005.jf.intel.com with ESMTP; 07 Apr 2020 18:02:55 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 18:02:55 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 18:02:54 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.7]) with mapi id 14.03.0439.000;
 Wed, 8 Apr 2020 09:02:52 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Auger Eric <eric.auger@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Thread-Topic: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Thread-Index: AQHWAEUcqZEEdiOKbEGofjWp2Yic+6hjfq+AgAC/vLD//4YrAIAC1vWAgAbjh1CAAQJ/8A==
Date:   Wed, 8 Apr 2020 01:02:51 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A225A72@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
 <cb68e9ab-77b0-7e97-a661-4836962041d9@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21DB4E@SHSMSX104.ccr.corp.intel.com>
 <b47891b1-ece6-c263-9c07-07c09c7d3752@redhat.com>
 <20200403082305.GA1269501@myrica>
 <A2975661238FB949B60364EF0F2C25743A2249DF@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A2249DF@SHSMSX104.ccr.corp.intel.com>
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
> Sent: Tuesday, April 7, 2020 5:43 PM
>
> > We don't, the PASID spaces are per-VM on Arm, so this function should
> > consult the IOMMU driver before setting flags. As you said on patch 3,
> > nested doesn't necessarily imply PASID support. The SMMUv2 does not
> > support PASID but does support nesting stages 1 and 2 for the IOVA space.
> > SMMUv3 support of PASID depends on HW capabilities. So I think this
> > needs to be finer grained:
> >
> > Does the container support:
> > * VFIO_IOMMU_PASID_REQUEST?
> >   -> Yes for VT-d 3
> >   -> No for Arm SMMU
> > * VFIO_IOMMU_{,UN}BIND_GUEST_PGTBL?
> >   -> Yes for VT-d 3
> >   -> Sometimes for SMMUv2
> >   -> No for SMMUv3 (if we go with BIND_PASID_TABLE, which is simpler due to
> >      PASID tables being in GPA space.)
> > * VFIO_IOMMU_BIND_PASID_TABLE?
> >   -> No for VT-d
> >   -> Sometimes for SMMUv3
> >
> > Any bind support implies VFIO_IOMMU_CACHE_INVALIDATE support.
> 
> good summary. do you expect to see any
please ignore this message. I planned to ask if possible to report
VFIO_IOMMU_CACHE_INVALIDATE  only (no bind support). But I stopped
typing it when I came to believe it's unnecessary to report it if
there is no bind support.

Regards,
Yi Liu
