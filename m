Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D690198C12
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 08:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgCaGIr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 31 Mar 2020 02:08:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:34529 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgCaGIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 02:08:47 -0400
IronPort-SDR: hwcWUU7dLm2cMQcSN5/BFNpN2eBMqXJ9BBQsH1scS+RI1eTeuDIPiimvugyztIL2Dgw/NbuGns
 xC7RESc6wACA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 23:08:46 -0700
IronPort-SDR: 3m8kJMNvedZ6Jhi9W+XpPrxLHsh7+68nleUU/7ne7N6TlQK88j7csJq1qWpx4jn8t7dhv2c6PX
 GodFGh/cDelA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="448548189"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga005.fm.intel.com with ESMTP; 30 Mar 2020 23:08:46 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:08:46 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:08:46 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 14:08:43 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v2 03/22] vfio: check VFIO_TYPE1_NESTING_IOMMU support
Thread-Topic: [PATCH v2 03/22] vfio: check VFIO_TYPE1_NESTING_IOMMU support
Thread-Index: AQHWBkpiF+OzDttw/0mCFTO45dt2yKhgWqOAgAHPSbA=
Date:   Tue, 31 Mar 2020 06:08:42 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21A63C@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-4-git-send-email-yi.l.liu@intel.com>
 <2c65e531-1cc8-dc01-4b06-e7baff58addd@redhat.com>
In-Reply-To: <2c65e531-1cc8-dc01-4b06-e7baff58addd@redhat.com>
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

Eric,

> From: Auger Eric <eric.auger@redhat.com>
> Sent: Monday, March 30, 2020 5:36 PM
> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
> Subject: Re: [PATCH v2 03/22] vfio: check VFIO_TYPE1_NESTING_IOMMU support
> 
> Yi,
> 
> On 3/30/20 6:24 AM, Liu Yi L wrote:
> > VFIO needs to check VFIO_TYPE1_NESTING_IOMMU support with Kernel before
> > further using it. e.g. requires to check IOMMU UAPI version.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > ---
> >  hw/vfio/common.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> > index 0b3593b..c276732 100644
> > --- a/hw/vfio/common.c
> > +++ b/hw/vfio/common.c
> > @@ -1157,12 +1157,21 @@ static void
> vfio_put_address_space(VFIOAddressSpace *space)
> >  static int vfio_get_iommu_type(VFIOContainer *container,
> >                                 Error **errp)
> >  {
> > -    int iommu_types[] = { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
> > +    int iommu_types[] = { VFIO_TYPE1_NESTING_IOMMU,
> > +                          VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
> >                            VFIO_SPAPR_TCE_v2_IOMMU, VFIO_SPAPR_TCE_IOMMU };
> > -    int i;
> > +    int i, version;
> >
> >      for (i = 0; i < ARRAY_SIZE(iommu_types); i++) {
> >          if (ioctl(container->fd, VFIO_CHECK_EXTENSION, iommu_types[i])) {
> > +            if (iommu_types[i] == VFIO_TYPE1_NESTING_IOMMU) {
> > +                version = ioctl(container->fd, VFIO_CHECK_EXTENSION,
> > +                                VFIO_NESTING_IOMMU_UAPI);
> > +                if (version < IOMMU_UAPI_VERSION) {
> > +                    info_report("IOMMU UAPI incompatible for nesting");
> > +                    continue;
> > +                }
> > +            }
> This means that by default VFIO_TYPE1_NESTING_IOMMU wwould be chosen. I
> don't think this what we want. On ARM this would mean that for a
> standard VFIO assignment without vIOMMU, SL will be used instead of FL.
> This may not be harmless.
> 
> For instance, in "[RFC v6 09/24] vfio: Force nested if iommu requires
> it", I use nested only if I detect we have a vSMMU. Otherwise I keep the
> legacy VFIO_TYPE1v2_IOMMU.
> 
Good point. I also replied in your patch.

Regards,
Yi Liu
