Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDFB614EBD8
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 12:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgAaLmT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 31 Jan 2020 06:42:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:58328 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbgAaLmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 06:42:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 03:42:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,385,1574150400"; 
   d="scan'208";a="323340350"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2020 03:42:17 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 31 Jan 2020 03:42:16 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.97]) with mapi id 14.03.0439.000;
 Fri, 31 Jan 2020 19:41:53 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v3 07/25] header file update VFIO/IOMMU vSVA APIs
Thread-Topic: [RFC v3 07/25] header file update VFIO/IOMMU vSVA APIs
Thread-Index: AQHV1p1OoTYvvVpt3kqFgb7urV9AkKgBC/CAgAOdaoA=
Date:   Fri, 31 Jan 2020 11:41:53 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1992E4@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
        <1580300216-86172-8-git-send-email-yi.l.liu@intel.com>
 <20200129132841.6900963f.cohuck@redhat.com>
In-Reply-To: <20200129132841.6900963f.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTZlNTYwNjAtYTNlNC00MjQ1LTlmNzUtMDEwODViMThjYTVjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSGFGb0hiNjF0N0g3c2d3UmQrXC8xYXJEeFhib3NhQW1TYkNBXC91dE42SVFXRCs4RXN0eXN0U3BDMWZNT3NpajFCIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf
> Of Cornelia Huck
> Sent: Wednesday, January 29, 2020 8:29 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v3 07/25] header file update VFIO/IOMMU vSVA APIs
> 
> On Wed, 29 Jan 2020 04:16:38 -0800
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > The kernel uapi/linux/iommu.h header file includes the extensions for
> > vSVA support. e.g. bind gpasid, iommu fault report related user
> > structures and etc.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  linux-headers/linux/iommu.h | 372
> > ++++++++++++++++++++++++++++++++++++++++++++
> >  linux-headers/linux/vfio.h  | 148 ++++++++++++++++++
> >  2 files changed, 520 insertions(+)
> >  create mode 100644 linux-headers/linux/iommu.h
> 
> Please add a note that this is to be replaced with a full headers update, so that it
> doesn't get missed :)

Exactly, thanks for the reminder. I expect to have a full headers update when
the whole vSVA series is accepted. :-)

Thanks,
Yi Liu

